# Data Models: AnimaLearn

## Core Domain Models (Dart/Freezed)

### EmotionScript Model

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'emotion_script.freezed.dart';
part 'emotion_script.g.dart';

/// Represents a parsed segment in an emotion script
@freezed
sealed class ScriptSegment with _$ScriptSegment {
  const factory ScriptSegment.text(String content) = TextSegment;

  const factory ScriptSegment.emotion({
    required String type,
    @Default({}) Map<String, dynamic> params,
  }) = EmotionSegment;

  const factory ScriptSegment.code({
    required String language,
    required String code,
  }) = CodeSegment;

  const factory ScriptSegment.sceneMarker({
    required String sceneName,
  }) = SceneMarker;
}

/// Complete emotion script for a module
@freezed
class EmotionScript with _$EmotionScript {
  const factory EmotionScript({
    required String id,
    required String rawText,
    @Default([]) List<ScriptSegment> segments,
    DateTime? compiledAt,
  }) = _EmotionScript;

  factory EmotionScript.fromJson(Map<String, dynamic> json) =>
      _$EmotionScriptFromJson(json);
}
```

### Animation Timeline Model

```dart
/// Compiled animation timeline (ready for playback)
@freezed
class AnimationTimeline with _$AnimationTimeline {
  const factory AnimationTimeline({
    required String id,
    required double totalDuration, // seconds
    required List<AnimationTrack> tracks,
    @Default(30) int fps,
    @Default(Size(1920, 1080)) Size resolution,
  }) = _AnimationTimeline;

  factory AnimationTimeline.fromJson(Map<String, dynamic> json) =>
      _$AnimationTimelineFromJson(json);
}

/// A single animation track (audio, rive, subtitle, etc.)
@freezed
sealed class AnimationTrack with _$AnimationTrack {
  const factory AnimationTrack.audio({
    required String url,
    required double startTime,
    double volume,
  }) = AudioTrack;

  const factory AnimationTrack.rive({
    required String assetUrl,
    required String stateMachine,
    required List<EmotionTrigger> triggers,
  }) = RiveTrack;

  const factory AnimationTrack.subtitle({
    required List<SubtitleSegment> segments,
  }) = SubtitleTrack;
}

@freezed
class EmotionTrigger with _$EmotionTrigger {
  const factory EmotionTrigger({
    required String emotionType,
    required double timestamp, // seconds
    @Default({}) Map<String, dynamic> params,
  }) = _EmotionTrigger;
}
```

### Course Model

```dart
@freezed
class Course with _$Course {
  const factory Course({
    required String id,
    required String creatorId,
    required String title,
    String? description,
    String? thumbnailUrl,
    @Default(0) int durationSeconds,
    @Default('beginner') String level,
    @Default([]) List<String> tags,
    @Default(false) bool isPublished,
    @Default(0) int viewCount,
    @Default([]) List<CourseModule> modules,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Course;

  factory Course.fromJson(Map<String, dynamic> json) =>
      _$CourseFromJson(json);
}

@freezed
class CourseModule with _$CourseModule {
  const factory CourseModule({
    required String id,
    required String courseId,
    required String title,
    required int position,
    @Default(0) int durationSeconds,
    String? animationUrl,
    AnimationTimeline? timeline,
  }) = _CourseModule;
}
```

### Emotion Template Model

```dart
@freezed
class EmotionTemplate with _$EmotionTemplate {
  const factory EmotionTemplate({
    required String id,
    required String name,
    required String type,          // e.g. "box_appear"
    required EmotionCategory category,
    required String riveAssetUrl,
    @Default({}) Map<String, ParamSchema> paramsSchema,
    String? previewGifUrl,
    @Default(false) bool isPremium,
  }) = _EmotionTemplate;

  factory EmotionTemplate.fromJson(Map<String, dynamic> json) =>
      _$EmotionTemplateFromJson(json);
}

enum EmotionCategory {
  narrator,    // Character interactions
  code,        // Code display animations
  concept,     // Abstract concept visualizations
  reaction,    // Emotional feedback (confetti, thumbsUp)
  transition,  // Scene transitions
  data,        // Data structure animations
}
```

---

## JSON Schema: Animation Timeline

The animation timeline is stored as JSON in the database and used for playback:

```json
{
  "id": "module_python_variables_v1",
  "totalDuration": 480,
  "fps": 30,
  "resolution": { "width": 1920, "height": 1080 },
  "tracks": [
    {
      "type": "audio",
      "url": "https://storage.animalearn.app/audio/python_variables.mp3",
      "startTime": 0.0,
      "volume": 1.0
    },
    {
      "type": "rive",
      "assetUrl": "https://storage.animalearn.app/rive/python_scenes.riv",
      "stateMachine": "PythonLearning",
      "triggers": [
        {
          "emotionType": "scene_enter",
          "timestamp": 0.0,
          "params": { "scene": "blank" }
        },
        {
          "emotionType": "narrator_appear",
          "timestamp": 0.5,
          "params": {}
        },
        {
          "emotionType": "typing_code",
          "timestamp": 4.2,
          "params": { "code": "x = 42", "language": "python" }
        },
        {
          "emotionType": "box_appear",
          "timestamp": 7.5,
          "params": { "name": "x", "value": "42", "color": "blue" }
        },
        {
          "emotionType": "confetti",
          "timestamp": 14.0,
          "params": {}
        }
      ]
    },
    {
      "type": "subtitle",
      "segments": [
        { "text": "Meet Python variables!", "start": 0.5, "end": 2.5 },
        { "text": "Here we create a variable x with value 42", "start": 4.2, "end": 7.0 },
        { "text": "Think of it as a labeled box", "start": 7.5, "end": 10.0 }
      ]
    }
  ]
}
```

---

## Emotion Tags Reference Schema

```json
{
  "emotions": {
    "narrator_appear": {
      "category": "narrator",
      "description": "Animated narrator character appears",
      "params": {
        "character": { "type": "string", "default": "default", "options": ["default", "robot", "teacher"] },
        "position": { "type": "string", "default": "left", "options": ["left", "right", "center"] }
      },
      "duration": 1.5
    },
    "box_appear": {
      "category": "concept",
      "description": "A labeled box appears to represent a variable",
      "params": {
        "name": { "type": "string", "required": true },
        "value": { "type": "any", "required": true },
        "color": { "type": "string", "default": "blue" }
      },
      "duration": 1.0
    },
    "typing_code": {
      "category": "code",
      "description": "Code appears with typing animation in editor style",
      "params": {
        "theme": { "type": "string", "default": "dark", "options": ["dark", "light"] }
      },
      "duration": "dynamic"
    },
    "confetti": {
      "category": "reaction",
      "description": "Confetti celebration animation",
      "params": {
        "intensity": { "type": "number", "default": 1.0, "min": 0.1, "max": 3.0 }
      },
      "duration": 2.0
    },
    "loop_spin": {
      "category": "data",
      "description": "Circular conveyor belt loop visualization",
      "params": {
        "iterations": { "type": "number", "required": true },
        "items": { "type": "array" }
      },
      "duration": "dynamic"
    },
    "tree_branch": {
      "category": "data",
      "description": "Tree/graph branching animation",
      "params": {
        "branches": { "type": "array", "items": { "type": "string" } }
      },
      "duration": "dynamic"
    }
  }
}
```
