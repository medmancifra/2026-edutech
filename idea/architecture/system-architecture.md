# AnimaLearn — System Architecture

> **Updated per issue #3**: Navigation replaced from GoRouter → MaterialRouter,
> state management replaced from Riverpod → BLoC (`flutter_bloc`).

---

## High-Level Overview

```
┌────────────────────────────────────────────────────┐
│               Client Layer                          │
│  Flutter App (iOS · Android · Web · Desktop)        │
│                                                     │
│  Navigator 2.0 / MaterialPageRoute (MaterialRouter) │
│  flutter_bloc (BLoC pattern)                        │
└──────────────────┬─────────────────────────────────┘
                   │ HTTPS / WebSocket
┌──────────────────▼─────────────────────────────────┐
│               Backend Layer                         │
│  Supabase BaaS                                      │
│  ├── PostgreSQL (users, courses, modules, reviews)  │
│  ├── Auth (JWT)                                     │
│  ├── Storage (thumbnails, Rive files)               │
│  ├── Realtime                                       │
│  └── Edge Functions (Deno)                         │
│       ├── register                                  │
│       ├── courses                                   │
│       └── reviews                                   │
└────────────────────────────────────────────────────┘
```

---

## Flutter App: Clean Architecture + BLoC

```
lib/
├── main.dart                    # App entry point, MultiBlocProvider
├── core/
│   ├── theme/
│   │   └── app_theme.dart       # Dark theme, AppColors
│   ├── router/
│   │   └── app_router.dart      # MaterialRouter — onGenerateRoute
│   └── supabase/
│       └── supabase_config.dart # URL + anon key constants
└── features/
    ├── auth/
    │   ├── bloc/
    │   │   ├── auth_bloc.dart   # AuthBloc
    │   │   ├── auth_event.dart
    │   │   └── auth_state.dart
    │   ├── repository/
    │   │   └── auth_repository.dart
    │   └── screens/
    │       └── registration_screen.dart
    ├── showcase/
    │   ├── bloc/
    │   │   ├── showcase_bloc.dart
    │   │   ├── showcase_event.dart
    │   │   └── showcase_state.dart
    │   ├── models/
    │   │   └── course.dart      # Course, CourseModule, demo seed data
    │   ├── screens/
    │   │   └── showcase_screen.dart
    │   └── widgets/
    │       └── course_card.dart
    ├── player/
    │   ├── bloc/
    │   │   ├── player_bloc.dart
    │   │   ├── player_event.dart
    │   │   └── player_state.dart
    │   ├── models/
    │   │   └── emotion_script_parser.dart
    │   ├── screens/
    │   │   └── player_screen.dart
    │   └── widgets/
    │       └── emotion_avatar.dart
    └── review/
        ├── bloc/
        │   ├── review_bloc.dart
        │   ├── review_event.dart
        │   └── review_state.dart
        └── screens/
            └── review_screen.dart
```

---

## Navigation (MaterialRouter)

Navigation is handled by Flutter's built-in `Navigator` using `MaterialPageRoute`
and `PageRouteBuilder` (for custom fade/slide transitions). Route names are
constants in `AppRoutes`.

```
AppRoutes.registration  →  RegistrationScreen
         ↓ (pushReplacementNamed after login)
AppRoutes.showcase      →  ShowcaseScreen
         ↓ (pushNamed with courseId argument)
AppRoutes.player        →  PlayerScreen(courseId)
         ↓ (pushReplacementNamed after last module)
AppRoutes.review        →  ReviewScreen(courseId)
         ↓ (pushNamedAndRemoveUntil after submit/skip)
AppRoutes.showcase      →  ShowcaseScreen
```

> **Why MaterialRouter over GoRouter?**
> GoRouter adds a dependency and its own opinionated layer. For a focused demo
> with a linear flow, Flutter's built-in Navigator is simpler, has zero extra
> dependencies, and gives full control over transition animations.

---

## State Management (BLoC)

Each feature has its own BLoC:

| BLoC | Events | Key States |
|------|--------|------------|
| `AuthBloc` | `AuthPasswordGenerated`, `AuthLoginRequested`, `AuthReset` | `initial` → `generatingPassword` → `loading` → `success/failure` |
| `ShowcaseBloc` | `ShowcaseLoadCourses`, `ShowcaseCourseSelected` | `loading` → `success` |
| `PlayerBloc` | `PlayerLoadCourse`, `PlayerAdvanceSegment`, `PlayerGoToModule`, `PlayerTogglePlayback`, `PlayerCourseCompleted` | `loading` → `playing` → `moduleComplete` → `courseComplete` |
| `ReviewBloc` | `ReviewRatingChanged`, `ReviewTextChanged`, `ReviewSubmitted` | `initial` → `submitting` → `success` |

> **Why BLoC over Riverpod?**
> BLoC enforces a strict unidirectional data flow with explicit events and
> states, making the demo flow auditable and testable with `bloc_test`.

---

## Emotion-Script Format

```
[EMOTION:name]   — triggers animation state in the EmotionAvatar
[CODE:lang]      — opens a code block
[/CODE]          — closes a code block
plain text       — narration text shown as subtitle card
```

`EmotionScriptParser` parses these tags into a flat `List<ScriptSegment>`:
`EmotionSegment | NarrationSegment | CodeSegment`.

In production the `EmotionAvatar` widget drives a Rive `StateMachineController`
with the named emotion input. For the demo it uses animated emoji containers.

---

## Supabase Edge Functions (Deno)

| Function | Method | Purpose |
|----------|--------|---------|
| `register` | POST | Create auth user + `users` row, skip email confirmation |
| `courses` | GET | List/search published courses |
| `reviews` | POST | Upsert review, recalculate course average rating |

Environment variables required:
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`

---

## Demo User Journey

```
1. Registration  →  RegistrationScreen
   • Enter email
   • Auto-generated password shown + copy button
   • Tap "Войти и начать" → Supabase auth.signUp

2. Showcase      →  ShowcaseScreen
   • Course card: "Выучи Python за 1 час"
   • Tap card → navigate to Player

3. Player        →  PlayerScreen
   • EmotionAvatar reacts to [EMOTION:xxx] tags
   • NarrationSegment shown as text card
   • CodeSegment shown as syntax-highlighted block
   • "Далее →" advances segments; "Следующий модуль" moves to next module

4. Review        →  ReviewScreen
   • Star rating (1-5) via flutter_rating_bar
   • Optional text review
   • Submit → Supabase Edge Function "reviews"
   • Back to Showcase
```
