# Navigation Structure: AnimaLearn

> **Updated per issue #3**: GoRouter replaced by Flutter's built-in
> `Navigator` + `MaterialPageRoute` (MaterialRouter). No external routing
> library dependency.

---

## Demo App Navigation Map

```
App Entry
    │
    └── RegistrationScreen  (AppRoutes.registration = '/')
           │
           │ [after successful login]
           │ Navigator.pushReplacementNamed
           ▼
        ShowcaseScreen  (AppRoutes.showcase = '/showcase')
           │
           │ [tap course card]
           │ Navigator.pushNamed(arguments: courseId)
           ▼
        PlayerScreen  (AppRoutes.player = '/player')
           │
           │ [after last module completes]
           │ Navigator.pushReplacementNamed(arguments: courseId)
           ▼
        ReviewScreen  (AppRoutes.review = '/review')
           │
           │ [submit or skip]
           │ Navigator.pushNamedAndRemoveUntil
           ▼
        ShowcaseScreen  (back to catalog)
```

---

## Route Definitions

Routes are defined as string constants in `AppRoutes` and resolved in
`AppRouter.onGenerateRoute` (passed to `MaterialApp.onGenerateRoute`).

```dart
class AppRoutes {
  static const registration = '/';
  static const showcase     = '/showcase';
  static const player       = '/player';
  static const review       = '/review';
}
```

Arguments are passed via `RouteSettings.arguments` (typed as `String?`
for `courseId`).

---

## Transition Animations

| Route | Transition |
|-------|-----------|
| `registration` | Fade (300 ms) |
| `showcase` | Slide from right (380 ms, easeInOutCubic) |
| `player` | Slide from right (380 ms, easeInOutCubic) |
| `review` | Slide from right (380 ms, easeInOutCubic) |

---

## Why MaterialRouter over GoRouter

GoRouter was removed per issue #3 requirements. Flutter's built-in Navigator:

- Zero extra dependencies
- Full control over transition animations via `PageRouteBuilder`
- No configuration overhead for a linear demo flow
- Easy to extend: add `onGenerateRoute` cases as new screens are added
