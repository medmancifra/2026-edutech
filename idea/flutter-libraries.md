# Flutter Libraries: Dependency List

> **Updated per issue #3**:
> - `go_router` **removed** → replaced by Flutter's built-in `Navigator` / `MaterialPageRoute`
> - `flutter_riverpod` / `riverpod_annotation` **removed** → replaced by `flutter_bloc` / `bloc`

---

## pubspec.yaml (demo app)

```yaml
name: animalearn
description: AnimaLearn - 2D Content Factory for emotion-script driven learning
version: 0.1.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # State Management (BLoC — replaces Riverpod per issue #3)
  flutter_bloc: ^8.1.6
  bloc: ^8.1.4
  equatable: ^2.0.5

  # Backend & API
  supabase_flutter: ^2.5.0
  dio: ^5.7.0

  # Animation & Canvas
  rive: ^0.13.0
  lottie: ^3.1.0
  flutter_animate: ^4.5.0

  # UI Components
  shimmer: ^3.0.0
  smooth_page_indicator: ^1.2.0
  flutter_rating_bar: ^4.0.1

  # Data / Serialization
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

  # Utilities
  uuid: ^4.4.0
  intl: ^0.19.0
  logger: ^2.4.0
  shared_preferences: ^2.3.2

  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.12
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  bloc_test: ^9.1.7
  mocktail: ^1.0.4
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/animations/
    - assets/images/
```

---

## Library Rationale

### State Management: flutter_bloc

`flutter_bloc` (BLoC pattern) was chosen per issue #3 requirements.

**Advantages over Riverpod for this project:**
- Explicit events → states: every state change is auditable
- `bloc_test` makes unit tests for each BLoC straightforward
- Well-defined separation: UI dispatches events, BLoC handles logic
- Industry-standard for Flutter enterprise apps

### Navigation: MaterialRouter (built-in)

`go_router` was removed per issue #3 requirements.

Flutter's built-in `Navigator` with `onGenerateRoute` provides:
- Zero additional dependency
- Full custom transition animations via `PageRouteBuilder`
- Simple linear flow for the demo (registration → showcase → player → review)

### Animation: rive + flutter_animate

- `rive` — drives 2D character animations via StateMachineController.
  Emotion tags trigger named inputs (e.g. `excited`, `happy`) in the Rive file.
- `flutter_animate` — lightweight declarative micro-animations for UI elements
  (fade-in, slide, scale on entrance).
- `lottie` — hero banners and loading/celebration animations.

### Backend: supabase_flutter

Supabase provides a complete BaaS (Auth, PostgreSQL, Storage, Realtime, Edge
Functions) without the vendor lock-in of Firebase. The Dart SDK wraps REST and
WebSocket transport transparently.

### Testing: bloc_test + mocktail

- `bloc_test` provides `blocTest<B, S>()` — a clean DSL for testing BLoC
  event → state sequences.
- `mocktail` offers null-safe mocking via `Mock` / `when()` without code gen.
