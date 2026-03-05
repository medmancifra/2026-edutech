# Technology Landscape: 2D Animation for Educational Content

## 1. Flutter Animation Libraries (Recommended Stack)

### Core Animation Libraries

| Library | pub.dev | Stars | Best For | License |
|---------|---------|-------|----------|---------|
| **rive** | `rive` | 9,000+ | Interactive state-machine animations | MIT |
| **lottie** | `lottie` | 4,000+ | JSON animations from After Effects | MIT |
| **flutter_animate** | `flutter_animate` | 3,500+ | Code-driven widget animations | MIT |
| **flame** | `flame` | 9,500+ | 2D game-engine canvas rendering | MIT |
| **flutter_svg** | `flutter_svg` | 4,500+ | SVG rendering & manipulation | MIT |
| **animations** | `animations` | 3,000+ | Material Design motion specs | BSD |
| **graphx** | `graphx` | 700+ | DisplayObject canvas rendering | MIT |
| **zerker** | `zerker` | 300+ | Lightweight canvas animation effects | MIT |
| **drawing_animation** | `drawing_animation` | 300+ | SVG path drawing animations | MIT |

### Rive vs. Lottie (Key Decision)

| | **Rive** | **Lottie** |
|-|----------|-----------|
| Editor | Own online editor (rive.app) | After Effects / LottieFiles Creator |
| State machine | Built-in, real-time | Limited (late 2025 update) |
| File size | 10–15x smaller than Lottie JSON | Larger JSON |
| Interactivity | High (respond to user input) | Low |
| Flutter support | Official runtime | Official package |
| Use case | Interactive UI animations | Decorative/loop animations |
| **Recommendation** | **Primary engine for interactive scenes** | **For decorative overlays** |

### Video & Media Handling

| Library | Purpose |
|---------|---------|
| `video_player` | Play educational video segments |
| `video_editor_sdk` | Full video editing SDK |
| `chewie` | Video player with controls |
| `ffmpeg_kit_flutter` | Video processing & export |

### Text & Rich Content

| Library | Purpose |
|---------|---------|
| `flutter_quill` | Rich text editor (for script authoring) |
| `flutter_markdown` | Markdown rendering |
| `flutter_highlight` | Code syntax highlighting |
| `code_text_field` | Code editor widget |

### State Management & Architecture

| Library | Purpose |
|---------|---------|
| `riverpod` | Reactive state management |
| `freezed` | Immutable data classes |
| `drift` | Local SQLite database |
| `hive` | Fast key-value store |

### UI Components

| Library | Purpose |
|---------|---------|
| `flutter_staggered_grid_view` | Showcase grid layout |
| `shimmer` | Loading skeleton UI |
| `flutter_colorpicker` | Color picker for editor |
| `dotted_border` | Timeline/canvas borders |
| `smooth_page_indicator` | Onboarding/course progress |

### Backend & API

| Library | Purpose |
|---------|---------|
| `dio` | HTTP client |
| `firebase_core` / `firebase_auth` | Authentication |
| `cloud_firestore` | Database for projects/templates |
| `firebase_storage` | Store assets/videos |
| `supabase_flutter` | Alternative to Firebase (open-source) |

---

## 2. JavaScript Animation Libraries (Web Rendering Option)

| Library | Stars | Best For | License |
|---------|-------|----------|---------|
| **GSAP (GreenSock)** | 20,000+ | Professional timeline animations | Paid for some plugins |
| **anime.js** | 51,000+ | Lightweight JS animations | MIT |
| **Pixi.js** | 44,000+ | 2D WebGL renderer, high performance | MIT |
| **Konva.js** | 12,000+ | Canvas 2D with interactivity | MIT |
| **Fabric.js** | 29,000+ | Canvas editing (objects, selection) | MIT |
| **Paper.js** | 14,000+ | Vector graphics scripting | MIT |
| **Two.js** | 8,000+ | 2D drawing API (SVG/Canvas/WebGL) | MIT |
| **Lottie-web** | 31,000+ | Play Lottie animations in browser | MIT |
| **mo.js** | 18,000+ | Motion graphics (bursts, shapes) | MIT |

**Recommendation for web component**: Use **Pixi.js** for the animation canvas renderer with **GSAP** for timeline control — best performance/feature combination.

---

## 3. Programmatic Video Generation Tools

### Python-Based

| Tool | Stars | Best For |
|------|-------|----------|
| **Manim** (3b1b) | 70,000+ | Math/code concept animations from Python |
| **Manim Community** | 18,000+ | Community fork, more stable |
| **Generative Manim** | 2,000+ | LLM → Manim code → video |

```python
# Example: Generate a Python variable assignment animation
from manim import *

class PythonVariable(Scene):
    def animate(self):
        code = Code("x = 42", language="python")
        self.play(Write(code))
        arrow = Arrow(UP, DOWN)
        self.play(Create(arrow))
```

### React/TypeScript-Based

| Tool | Stars | Best For |
|------|-------|----------|
| **Remotion** | 21,000+ | React components → MP4 |
| **Revideo** | 3,000+ | Fork of Motion Canvas, video-first |
| **Motion Canvas** | 16,000+ | TypeScript vector animations |

### API-Based (No Code)

| Service | Type | Best For |
|---------|------|---------|
| **Creatomate** | SaaS API | Template-based video generation |
| **Shotstack** | SaaS API | Video composition API |
| **Bannerbear** | SaaS API | Image/video generation from templates |

---

## 4. Open-Source Engines for 2D Content

### Blender (Grease Pencil + bpy)

```python
# Headless Blender rendering via Python API
import bpy

# Set up 2D scene
bpy.context.scene.render.resolution_x = 1920
bpy.context.scene.render.resolution_y = 1080
bpy.context.scene.render.fps = 30

# Set output path
bpy.context.scene.render.filepath = "/output/frame_"

# Render animation
bpy.ops.render.render(animation=True)
```

**CLI execution**: `blender scene.blend --background --python generate.py`

**Pros**: Grease Pencil for professional 2D animation; Python API complete; free
**Cons**: Heavy (300MB+); headless GPU required for real-time; learning curve

### Godot Engine

```gdscript
# Godot 4 GDScript: Programmatic animation
var tween = create_tween()
tween.tween_property($CodeLabel, "modulate:a", 1.0, 0.5)
tween.tween_property($Arrow, "position", target_pos, 0.3)
```

**CLI**: `godot --headless --script generate_video.gd`

**Pros**: MIT license; great 2D engine; GDScript simple; can export video via plugin
**Cons**: Video export requires third-party plugin; less automation support than Blender

### Synfig Studio

- Professional open-source 2D animation
- Command-line rendering: `synfig project.sifz -o output.mp4`
- Good for vector animations; XML-based project format (automatable)

---

## 5. Recommended Technology Stack Decision

### Phase 1: Flutter Mobile App (MVP)
```
Frontend: Flutter + Dart
Animation Engine: Rive (interactive) + Lottie (decorative)
Canvas: Flutter CustomPainter + graphx
Rich Text: flutter_quill
State: Riverpod
Local DB: Hive / Drift
Export: ffmpeg_kit_flutter
Backend: Supabase (open-source Firebase alternative)
```

### Phase 2: Web Rendering Engine
```
Canvas Renderer: Pixi.js + GSAP
Animation Format: Rive files (.riv) + Lottie JSON
Video Export: Remotion (React-based) or FFmpeg
```

### Phase 3: AI Generation
```
Script → Animation: Generative Manim / LLM → Manim code
Template Engine: Custom JSON animation schema
AI Backend: Python FastAPI + Manim + FFmpeg
```
