# Flutter Libraries: Complete Dependency List

## pubspec.yaml

```yaml
name: animalearn
description: 2D Content Factory for Educational Videos
version: 1.0.0+1

environment:
  sdk: ">=3.3.0 <4.0.0"
  flutter: ">=3.19.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # ============================================================
  # ANIMATION & CANVAS (Core Product)
  # ============================================================

  # Rive: Interactive 2D animation engine (PRIMARY ENGINE)
  # Used for: All pre-built emotion animations, scene templates
  # Why: State machine support, 15x smaller files vs video, Flutter-native
  rive: ^0.13.0

  # Lottie: JSON animation player (SECONDARY - decorative)
  # Used for: Loading states, decorative overlays, onboarding
  # Why: Huge library of free animations (LottieFiles.com)
  lottie: ^3.1.0

  # flutter_animate: Code-driven widget animations
  # Used for: UI transitions, element reveals, micro-interactions
  # Why: Clean API, chain animations easily
  flutter_animate: ^4.5.0

  # Flame: 2D game engine for complex scenes
  # Used for: Advanced canvas scenes (game-like animations)
  # Why: CustomPainter on steroids; Rive integration built-in
  flame: ^1.18.0

  # flutter_svg: SVG rendering
  # Used for: Vector asset library, custom illustrations
  # Why: Crisp at any size; editable fill/stroke colors
  flutter_svg: ^2.0.0

  # graphx: DisplayObject canvas API (Flash-like)
  # Used for: Advanced programmatic 2D drawings
  # Why: More intuitive than raw CustomPainter
  graphx: ^0.9.0

  # drawing_animation: SVG path drawing animation
  # Used for: "Writing" effect for text/diagrams
  # Why: Perfect for "diagram appearing" animations
  drawing_animation: ^2.0.0

  # animations: Material Design motion specs
  # Used for: Screen transitions, container transforms
  # Why: Official Flutter package, well-tested
  animations: ^2.0.11

  # ============================================================
  # CONTENT AUTHORING (Script-Emotion Editor)
  # ============================================================

  # flutter_quill: Rich text editor
  # Used for: Main script authoring editor
  # Why: Most mature WYSIWYG editor for Flutter
  flutter_quill: ^10.8.0

  # flutter_markdown: Markdown rendering
  # Used for: Preview mode, documentation
  flutter_markdown: ^0.7.4

  # flutter_highlight: Code syntax highlighting
  # Used for: Inline code blocks in scripts
  # Why: Supports 100+ languages including Python, JS, Dart
  flutter_highlight: ^0.7.0

  # re_editor: Advanced code editor widget
  # Used for: Code emotion blocks in editor
  # Why: Better than TextField for code; supports brackets, indent
  re_editor: ^0.3.0

  # ============================================================
  # MEDIA & VIDEO
  # ============================================================

  # video_player: Video playback
  # Used for: Playing generated/uploaded video courses
  video_player: ^2.9.0

  # chewie: Video player UI
  # Used for: Full-featured player controls
  chewie: ^1.8.1

  # ffmpeg_kit_flutter: Video processing
  # Used for: Exporting Flutter canvas to MP4
  # Why: Production-tested; runs on device; no server needed for basic export
  ffmpeg_kit_flutter: ^6.0.3

  # image: Image processing
  # Used for: Thumbnail generation, image manipulation
  image: ^4.2.0

  # just_audio: Audio playback
  # Used for: Narration audio, sound effects
  just_audio: ^0.9.39

  # record: Audio recording
  # Used for: Voiceover recording in editor
  record: ^5.1.0

  # ============================================================
  # UI COMPONENTS
  # ============================================================

  # Showcase layout
  flutter_staggered_grid_view: ^0.7.0   # Masonry grid for course cards
  infinite_scroll_pagination: ^4.0.0    # Paginated course lists

  # Animated lists
  flutter_staggered_animations: ^1.1.1  # Staggered entrance animations

  # Loading
  shimmer: ^3.0.0                        # Skeleton loading screens

  # Editor UI
  flutter_colorpicker: ^1.1.0            # Color picker for scene backgrounds
  dotted_border: ^2.1.0                  # Canvas selection borders

  # Progress & indicators
  smooth_page_indicator: ^1.2.0          # Module progress indicator
  percent_indicator: ^4.2.3              # Circular/linear progress bars

  # Icons
  iconsax: ^0.0.8                        # Modern icon set (500+ icons)
  hugeicons: ^0.0.7                      # Large icon library (4000+ icons)

  # Tooltips & help
  showcaseview: ^3.0.0                   # Feature discovery tooltips
  super_tooltip: ^2.0.5                  # Contextual tooltips

  # Bottom sheets & dialogs
  modal_bottom_sheet: ^3.0.0             # Smooth bottom sheets
  flutter_slidable: ^3.1.0              # Swipe actions on list items

  # Drag & drop
  reorderable_grid_view: ^2.2.8          # Drag-reorder grid (timeline)
  drag_and_drop_lists: ^0.4.3            # Drag-reorder lists

  # ============================================================
  # STATE MANAGEMENT & ARCHITECTURE
  # ============================================================

  # Riverpod: Reactive state management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Immutable data classes
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

  # ============================================================
  # LOCAL STORAGE & DATABASE
  # ============================================================

  # Hive: Fast key-value store
  # Used for: User preferences, draft cache, offline courses
  hive_flutter: ^1.1.0

  # Drift: SQLite ORM
  # Used for: Projects database, course content, emotion library
  drift: ^2.18.0
  sqlite3_flutter_libs: ^0.5.0

  # SharedPreferences: Simple settings
  shared_preferences: ^2.2.3

  # ============================================================
  # BACKEND & API
  # ============================================================

  # Supabase: Open-source backend (Firebase alternative)
  # Used for: Auth, database, file storage, real-time
  supabase_flutter: ^2.5.0

  # HTTP client
  dio: ^5.7.0
  retrofit: ^4.1.0             # Type-safe HTTP with code gen

  # Real-time collaboration (Phase 2)
  web_socket_channel: ^3.0.1

  # ============================================================
  # NAVIGATION
  # ============================================================

  go_router: ^14.2.7           # Declarative routing with deep links

  # ============================================================
  # UTILITIES
  # ============================================================

  # File handling
  path_provider: ^2.1.4        # File system paths
  path: ^1.9.0                 # Path utilities
  file_picker: ^8.0.3          # File selection dialog
  image_picker: ^1.1.2         # Camera/gallery picker

  # Sharing
  share_plus: ^10.0.0          # Native share dialog
  url_launcher: ^6.3.1         # Open URLs

  # Permissions
  permission_handler: ^11.3.1  # Runtime permission requests

  # Connectivity
  connectivity_plus: ^6.0.3    # Network status

  # Localization
  intl: ^0.19.0                # i18n & date formatting

  # Crypto & security
  crypto: ^3.0.5               # Hashing
  flutter_secure_storage: ^9.2.2 # Secure token storage

  # Analytics
  mixpanel_flutter: ^2.3.1     # User analytics (optional)

  # UUID generation
  uuid: ^4.4.0                 # Generate unique IDs

  # Logger
  logger: ^2.4.0               # Structured logging

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Code generation
  build_runner: ^2.4.13
  freezed: ^2.5.2
  json_serializable: ^6.8.0
  riverpod_generator: ^2.4.3
  drift_dev: ^2.18.0
  retrofit_generator: ^8.1.0

  # Linting
  flutter_lints: ^4.0.0
  custom_lint: ^0.6.7
  riverpod_lint: ^2.3.13

  # Testing
  mocktail: ^1.0.4
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
```

---

## Library Selection Rationale

### Why Rive over other animation engines?
1. **State machine**: Animations respond to real-time data (e.g., emotion changes)
2. **File size**: `.riv` files are 10–15x smaller than equivalent video
3. **Flutter-native**: Official Flutter runtime with full platform support
4. **Editor**: Free online editor at rive.app for creating templates
5. **Interactivity**: Can receive input events (tap, hover, data changes)

### Why Supabase over Firebase?
1. **Open-source**: Can self-host if needed; no vendor lock-in
2. **PostgreSQL**: Full SQL capabilities vs Firestore's limited queries
3. **Realtime**: Built-in PostgreSQL LISTEN/NOTIFY for live updates
4. **Storage**: S3-compatible storage with CDN
5. **Auth**: Row-level security policies

### Why Riverpod over Bloc/GetX?
1. **Type-safe**: Compile-time errors instead of runtime
2. **Testable**: Providers are easy to mock and test
3. **Code generation**: Less boilerplate with riverpod_generator
4. **No BuildContext**: Providers accessible anywhere, not just widget tree
5. **Flutter 3.x optimized**: Built for modern Flutter patterns

### Why ffmpeg_kit_flutter for video export?
1. **On-device**: No server needed for basic MP4 export
2. **Production-tested**: Used by major video apps
3. **Cross-platform**: Works on iOS, Android, macOS
4. **Full FFmpeg**: All FFmpeg filters and codecs available
