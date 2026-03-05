# Screen: Video Player

## Full-Screen Player

```
┌─────────────────────────────────┐
│ [STATUS BAR - black/transparent]│
│                                 │
│  ████████████████████████████   │
│  █                          █  │
│  █    [Rive Animation       █  │  ← Main animation canvas
│  █     Canvas - Full Screen] █  │    (Rive state machine)
│  █                          █  │
│  █  ┌────────────────────┐  █  │  ← Subtitle overlay
│  █  │ "Variables store   │  █  │
│  █  │  data in Python"   │  █  │
│  █  └────────────────────┘  █  │
│  ████████████████████████████   │
│                                 │
│  ← Python in 1h        ⤴ ···  │  ← Tap anywhere to show controls
│                                 │
│  ━━━━━━━━━━●━━━━━━━━━━━━━━━━   │  ← Progress bar
│  2:34                    8:00   │
│                                 │
│  ⏮  ◀◀  ▶  ▶▶  ⏭   🔊 ⛶   │  ← Playback controls
│  prev 10s  play 10s next  vol fullscreen
│                                 │
│  ── Module 2: Variables ────── │  ← Current module title
└─────────────────────────────────┘
```

---

## Player with Scene Timeline (Landscape)

```
┌────────────────────────────────────────────────────────────────────┐
│                                                                      │
│  ████████████████████████████████████████████████████████████████   │
│  █                                                              █   │
│  █                  [Animation Canvas]                         █   │
│  █                                                              █   │
│  ████████████████████████████████████████████████████████████████   │
│                                                                      │
│  ━━━━━━━━━━━━━━━━━━━━━━━━●━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━   │
│                                                                      │
│  [Scene 1: Intro][Scene 2: Variables][Scene 3: Assignment][Scene 4] │  ← Scene markers
│                                                                      │
│  ⏮  ◀◀  ▶  ▶▶  ⏭    1:23 / 8:00    🔊 ─────●──  ⛶  📝         │
│                                                            notes      │
└────────────────────────────────────────────────────────────────────┘
```

---

## Module Navigation Drawer

```
Swipe from right edge →
┌─────────────────────────────────┐  ──────────────────────┐
│                                 │  Course Modules         │
│  [Animation Canvas]             │  ─────────────────────  │
│                                 │  ✅ 1. What is Python?  │
│                                 │  ✅ 2. Variables   ←now │  ← Current
│                                 │     ████▒▒▒▒ 45%       │
│                                 │  🔒 3. Operators        │
│                                 │  🔒 4. Strings          │
│                                 │  🔒 5. Lists            │
│                                 │  ...                    │
│                                 │                         │
│                                 │  Progress: 2/10 ████▒▒▒ │
└─────────────────────────────────┘  ──────────────────────┘
```

---

## Module Complete Screen (Interstitial)

```
┌─────────────────────────────────┐
│                                 │
│         🎉                      │  ← Confetti Lottie animation
│    [Confetti Animation]         │
│                                 │
│   Module Complete!              │
│   "Variables & Data Types"      │
│                                 │
│   ┌─────────────────────────┐  │
│   │   🎯  Quick Check       │  │  ← Optional quiz
│   │                         │  │
│   │ What does this create?  │  │
│   │ x = 42                  │  │
│   │                         │  │
│   │ ○ A function            │  │
│   │ ● A variable ✓          │  │
│   │ ○ A loop                │  │
│   └─────────────────────────┘  │
│                                 │
│  ┌────────────┐ ┌────────────┐ │
│  │  ← Back    │ │ Next →    │ │  ← Navigation
│  └────────────┘ └────────────┘ │
└─────────────────────────────────┘
```

---

## Player Technical Implementation

### Rive Animation Canvas Widget

```dart
class AnimationCanvas extends ConsumerWidget {
  final AnimationTimeline timeline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);

    return Stack(
      children: [
        // Background
        Container(color: Colors.black),

        // Rive animation (main scene)
        RiveAnimation.network(
          timeline.riveAssetUrl,
          stateMachines: [timeline.stateMachine],
          onInit: (artboard) {
            final controller = StateMachineController.fromArtboard(
              artboard,
              timeline.stateMachine,
            );
            artboard.addController(controller!);
            ref.read(riveControllerProvider.notifier).setController(controller);
          },
        ),

        // Subtitle overlay
        Positioned(
          bottom: 80,
          left: 16,
          right: 16,
          child: SubtitleWidget(timeline: timeline),
        ),

        // Playback controls (shown on tap)
        if (playerState.showControls)
          PlaybackControls(timeline: timeline),
      ],
    );
  }
}
```

### Emotion Trigger System

```dart
class EmotionTriggerService {
  final RiveController controller;

  void triggerAtTime(double currentTime, AnimationTimeline timeline) {
    for (final trigger in timeline.triggers) {
      if ((trigger.timestamp - currentTime).abs() < 0.05) {
        // Within 50ms of trigger timestamp
        _fireEmotion(trigger);
      }
    }
  }

  void _fireEmotion(EmotionTrigger trigger) {
    switch (trigger.emotionType) {
      case 'box_appear':
        controller.setInput('ShowBox', true);
        controller.setInput('BoxName', trigger.params['name'] as String);
        controller.setInput('BoxValue', trigger.params['value'].toString());
        break;
      case 'confetti':
        controller.setInput('PlayConfetti', true);
        break;
      // ... other emotions
    }
  }
}
```

---

## Design Notes

### Color Scheme (Player)
- Background: Pure black `#000000`
- Controls: White with 80% opacity
- Progress bar: Indigo `#6366F1`
- Subtitle background: `rgba(0,0,0,0.6)`, rounded corners
- Scene markers: Small white dots on progress bar

### Gestures
- **Single tap**: Toggle controls visibility
- **Double tap left**: Rewind 10 seconds
- **Double tap right**: Forward 10 seconds
- **Swipe left**: Next module
- **Swipe right**: Previous module
- **Swipe up**: Show module list
- **Pinch**: Zoom (not implemented in v1)

### Accessibility
- Subtitles ON by default
- Minimum subtitle font size: 14sp
- Controls remain visible for 3 seconds after last interaction
- Voice control support via Flutter's Semantics
