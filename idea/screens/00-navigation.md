# Navigation Structure: AnimaLearn

## App Navigation Map

```
App Entry
    │
    ├── [Not authenticated] → Onboarding → Auth Flow
    │
    └── [Authenticated] → Main Shell
              │
              ├── Bottom Nav Tab 1: Showcase (Витрина)       [01-showcase]
              │       └── Course Detail → Player             [02-player, 03-player]
              │
              ├── Bottom Nav Tab 2: My Learning
              │       └── In-Progress Courses → Player
              │
              ├── Bottom Nav Tab 3: Create (Editor)          [04-editor]
              │       ├── New Project
              │       ├── Edit Project → Editor Screen
              │       └── Emotion Library                    [05-emotion-library]
              │
              └── Bottom Nav Tab 4: Profile
                      ├── My Courses (published)
                      ├── Analytics
                      └── Settings
```

## Route Definitions (GoRouter)

```dart
final router = GoRouter(
  routes: [
    // Auth
    GoRoute(path: '/onboarding', builder: (_,__) => OnboardingScreen()),
    GoRoute(path: '/login', builder: (_,__) => LoginScreen()),
    GoRoute(path: '/signup', builder: (_,__) => SignupScreen()),

    // Main shell with bottom nav
    ShellRoute(
      builder: (_, __, child) => MainShell(child: child),
      routes: [
        // Showcase (Витрина)
        GoRoute(
          path: '/showcase',
          builder: (_, __) => ShowcaseScreen(),
          routes: [
            GoRoute(
              path: 'course/:courseId',
              builder: (_, state) => CourseDetailScreen(
                courseId: state.pathParameters['courseId']!,
              ),
              routes: [
                GoRoute(
                  path: 'play/:moduleId',
                  builder: (_, state) => PlayerScreen(
                    courseId: state.pathParameters['courseId']!,
                    moduleId: state.pathParameters['moduleId']!,
                  ),
                ),
              ],
            ),
          ],
        ),

        // My Learning
        GoRoute(path: '/learning', builder: (_, __) => MyLearningScreen()),

        // Create (Editor)
        GoRoute(
          path: '/create',
          builder: (_, __) => MyProjectsScreen(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (_, __) => EditorScreen(),
            ),
            GoRoute(
              path: 'edit/:projectId',
              builder: (_, state) => EditorScreen(
                projectId: state.pathParameters['projectId'],
              ),
            ),
            GoRoute(
              path: 'emotions',
              builder: (_, __) => EmotionLibraryScreen(),
            ),
          ],
        ),

        // Profile
        GoRoute(path: '/profile', builder: (_, __) => ProfileScreen()),
      ],
    ),
  ],
);
```

## Navigation Design Principles

1. **Deep linking**: Every course and module has a shareable URL
2. **Back navigation**: Physical back button always works as expected
3. **State preservation**: Bottom nav tabs preserve scroll position
4. **Transition animations**: Material motion specs for screen transitions
5. **Offline fallback**: When offline, show cached content or graceful error
