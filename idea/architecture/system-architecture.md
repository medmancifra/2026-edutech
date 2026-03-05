# System Architecture: AnimaLearn

## High-Level Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                        CLIENT LAYER                                  │
│                                                                       │
│  ┌───────────────┐  ┌───────────────┐  ┌───────────────────────┐   │
│  │  Flutter iOS  │  │ Flutter       │  │  Flutter Web          │   │
│  │  & Android    │  │ Desktop       │  │  (PWA / SaaS)         │   │
│  └───────┬───────┘  └───────┬───────┘  └──────────┬────────────┘   │
│          └──────────────────┼──────────────────────┘                │
│                             │ Supabase Client SDK / REST API        │
└─────────────────────────────┼───────────────────────────────────────┘
                              │
┌─────────────────────────────┼───────────────────────────────────────┐
│                        BACKEND LAYER                                 │
│                             │                                        │
│  ┌──────────────────────────▼──────────────────────────────────┐   │
│  │                    Supabase (BaaS)                          │   │
│  │  ┌─────────────┐  ┌──────────────┐  ┌──────────────────┐  │   │
│  │  │ PostgreSQL  │  │ Auth (JWT)   │  │ Storage (S3)     │  │   │
│  │  │ Database    │  │ OAuth2       │  │ .riv files       │  │   │
│  │  │ - users     │  │ Apple Sign-In│  │ .lottie files    │  │   │
│  │  │ - projects  │  │ Google OAuth │  │ MP4 exports      │  │   │
│  │  │ - courses   │  │ Email/Pass   │  │ Thumbnails       │  │   │
│  │  │ - templates │  └──────────────┘  │ User assets      │  │   │
│  │  │ - emotions  │                     └──────────────────┘  │   │
│  │  └─────────────┘  ┌──────────────┐                          │   │
│  │                    │  Realtime    │                          │   │
│  │                    │  (PostgREST  │                          │   │
│  │                    │   + WS)      │                          │   │
│  │                    └──────────────┘                          │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                       │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │                Python AI Service (Phase 3)                   │   │
│  │  FastAPI + Manim + FFmpeg + OpenAI API                      │   │
│  │  - Receives emotion script as input                         │   │
│  │  - Generates Manim code via LLM                             │   │
│  │  - Renders video                                             │   │
│  │  - Uploads to Storage                                        │   │
│  └──────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Flutter App Architecture

### Clean Architecture with Riverpod

```
lib/
├── main.dart
├── app.dart                    # App root, GoRouter config
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   └── emotion_types.dart  # All emotion tag definitions
│   ├── utils/
│   │   ├── emotion_parser.dart  # Parse [EMOTION:xxx] tags from script
│   │   ├── script_compiler.dart # Compile script to animation timeline
│   │   └── video_exporter.dart  # FFmpeg export logic
│   └── widgets/                 # Shared UI components
│       ├── emotion_tag_chip.dart
│       ├── course_card.dart
│       └── animated_loader.dart
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── auth_repository.dart
│   │   ├── domain/
│   │   │   └── auth_provider.dart
│   │   └── presentation/
│   │       ├── login_screen.dart
│   │       └── signup_screen.dart
│   │
│   ├── showcase/               # Витрина feature
│   │   ├── data/
│   │   │   └── courses_repository.dart
│   │   ├── domain/
│   │   │   ├── models/course.dart
│   │   │   └── showcase_provider.dart
│   │   └── presentation/
│   │       ├── showcase_screen.dart
│   │       ├── course_detail_screen.dart
│   │       └── widgets/
│   │           ├── course_grid.dart
│   │           └── featured_banner.dart
│   │
│   ├── player/                 # Video Player feature
│   │   ├── data/
│   │   │   └── playback_repository.dart
│   │   ├── domain/
│   │   │   └── player_provider.dart
│   │   └── presentation/
│   │       ├── player_screen.dart
│   │       └── widgets/
│   │           ├── animation_canvas.dart  # Rive canvas
│   │           ├── progress_bar.dart
│   │           └── scene_timeline.dart
│   │
│   ├── editor/                 # Script-Emotion Editor feature
│   │   ├── data/
│   │   │   └── project_repository.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── emotion_script.dart
│   │   │   │   ├── scene.dart
│   │   │   │   └── timeline.dart
│   │   │   └── editor_provider.dart
│   │   └── presentation/
│   │       ├── editor_screen.dart
│   │       └── widgets/
│   │           ├── script_text_field.dart   # Quill editor
│   │           ├── preview_canvas.dart       # Live Rive preview
│   │           ├── emotion_picker.dart       # Tag inserter
│   │           └── timeline_bar.dart
│   │
│   └── emotions/               # Emotion Library feature
│       ├── data/
│       │   └── emotions_repository.dart
│       ├── domain/
│       │   └── emotions_provider.dart
│       └── presentation/
│           ├── emotion_library_screen.dart
│           └── widgets/
│               ├── emotion_card.dart
│               └── emotion_preview.dart
│
└── l10n/                       # Localization
    ├── app_en.arb
    └── app_ru.arb
```

---

## Data Flow: Script → Animation

```
User types script in Editor
         │
         ▼
EmotionParser.parse(scriptText)
         │
         ▼
ScriptAST {
  segments: [
    TextSegment("Here is how..."),
    EmotionSegment(type: "typing_code"),
    CodeSegment(language: "python", code: "x = 42"),
    EmotionSegment(type: "box_appear", params: {name: "x", value: 42}),
    EmotionSegment(type: "confetti")
  ]
}
         │
         ▼
TimelineCompiler.compile(ast)
         │
         ▼
AnimationTimeline {
  totalDuration: 45.0, // seconds
  tracks: [
    AudioTrack(tts_audio_url, start: 0.0),
    RiveTrack(scene: "box_metaphor", triggers: [...]),
    SubtitleTrack(segments: [...])
  ]
}
         │
         ▼
AnimationCanvas (Rive + CustomPainter)
renders each frame at 60fps
         │
         ▼
[Export] → FFmpeg captures canvas → MP4
```

---

## Emotion Script Processing

### Parser (Dart)

```dart
class EmotionParser {
  static final _emotionTagRegex = RegExp(
    r'\[EMOTION:(\w+)(?:\s+([^\]]*))?\]',
    multiLine: true,
  );

  static final _codeTagRegex = RegExp(
    r'\[CODE:(\w+)\](.*?)\[/CODE\]',
    multiLine: true,
    dotAll: true,
  );

  List<ScriptSegment> parse(String script) {
    final segments = <ScriptSegment>[];
    var lastEnd = 0;

    for (final match in _emotionTagRegex.allMatches(script)) {
      // Add text before this tag
      if (match.start > lastEnd) {
        segments.add(TextSegment(script.substring(lastEnd, match.start)));
      }

      final emotionType = match.group(1)!;
      final paramsStr = match.group(2) ?? '';
      final params = _parseParams(paramsStr);
      segments.add(EmotionSegment(type: emotionType, params: params));

      lastEnd = match.end;
    }

    // Remaining text
    if (lastEnd < script.length) {
      segments.add(TextSegment(script.substring(lastEnd)));
    }

    return segments;
  }
}
```

---

## Database Schema (PostgreSQL / Supabase)

```sql
-- Users
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  display_name TEXT,
  avatar_url TEXT,
  plan TEXT DEFAULT 'free', -- free, creator, pro, team
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Courses (published)
CREATE TABLE courses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  creator_id UUID REFERENCES users(id),
  title TEXT NOT NULL,
  description TEXT,
  thumbnail_url TEXT,
  duration_seconds INT,
  level TEXT, -- beginner, intermediate, advanced
  tags TEXT[],
  is_published BOOLEAN DEFAULT FALSE,
  view_count INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Modules (course sections)
CREATE TABLE modules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  position INT NOT NULL,
  duration_seconds INT,
  animation_url TEXT,   -- .riv or MP4 URL
  script_json JSONB     -- compiled animation timeline
);

-- Projects (drafts / in-progress)
CREATE TABLE projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  creator_id UUID REFERENCES users(id),
  title TEXT NOT NULL,
  emotion_script TEXT,  -- raw script text
  compiled_json JSONB,  -- compiled timeline
  status TEXT DEFAULT 'draft', -- draft, compiling, ready, published
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Emotion Templates
CREATE TABLE emotion_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  type TEXT NOT NULL,   -- e.g. "box_appear", "code_reveal"
  category TEXT,        -- narrator, code, concept, reaction, transition
  rive_asset_url TEXT,
  params_schema JSONB,  -- JSON Schema for emotion parameters
  preview_gif_url TEXT,
  is_premium BOOLEAN DEFAULT FALSE,
  created_by UUID REFERENCES users(id)
);

-- User Progress
CREATE TABLE user_progress (
  user_id UUID REFERENCES users(id),
  course_id UUID REFERENCES courses(id),
  last_module_id UUID REFERENCES modules(id),
  completed_modules UUID[],
  progress_percent FLOAT DEFAULT 0,
  completed_at TIMESTAMPTZ,
  PRIMARY KEY (user_id, course_id)
);
```
