# Screen: Script-Emotion Editor

## Editor Main Screen

```
┌─────────────────────────────────┐
│  ←  My Python Course    💾 ...  │  ← App bar with save & menu
│                                 │
│  [Script]  [Preview]  [Export]  │  ← Tab bar
│                                 │
├─────────────────────────────────┤
│  SCRIPT TAB (default)           │
│                                 │
│  ┌─────────────────────────┐   │
│  │ Module Title: Variables  │   │  ← Module title field
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────────┐│
│  │                              ││  ← flutter_quill rich text editor
│  │ [SCENE:blank_screen]         ││    with emotion tag support
│  │                              ││
│  │ [EMOTION:narrator_appear]    ││  ← Emotion tags (highlighted)
│  │                              ││
│  │ Welcome to Python! Today     ││  ← Regular text (narration)
│  │ we'll learn about variables. ││
│  │                              ││
│  │ [EMOTION:typing_code]        ││
│  │                              ││
│  │ [CODE:python]                ││  ← Code block
│  │ x = 42                       ││
│  │ [/CODE]                      ││
│  │                              ││
│  │ [EMOTION:box_appear          ││  ← Emotion with parameters
│  │   name="x" value="42"]       ││
│  │                              ││
│  │ Think of a variable as a     ││
│  │ labeled box...               ││
│  │                              ││
│  │ [EMOTION:confetti]           ││
│  │                              ││
│  │ ▌                            ││  ← Cursor
│  └──────────────────────────────┘│
│                                 │
│  ── Emotion Toolbar ───────────│
│  [😊] [💻] [📦] [🎊] [🔄] [+]│  ← Quick emotion insertion
│  narrator code concept reaction more
│                                 │
│  [◀] [▶] [⌨] [🖊] [B] [I]    │  ← Text editor toolbar
└─────────────────────────────────┘
```

---

## Preview Tab (Live Preview)

```
┌─────────────────────────────────┐
│  ←  My Python Course    💾 ...  │
│                                 │
│  [Script]  [Preview✓] [Export]  │  ← Preview tab active
│                                 │
│  ████████████████████████████   │
│  █                          █  │  ← Live Rive animation preview
│  █   [Animation Preview]    █  │    Updates as script is edited
│  █   (Real-time rendering)  █  │
│  █                          █  │
│  ████████████████████████████   │
│                                 │
│  ─────────────────────────────  │
│  ◀◀  ▶  ▶▶    0:00 / 2:30    │  ← Preview playback controls
│                                 │
│  ── Timeline ──────────────────│
│  ─[intro]──[var_box]──[code]──[confetti]─── │  ← Scene segments
│   0s       5s         12s      18s           │
│                                 │
│  ── Script Preview ─────────── │
│  Current: "Think of a variable  │  ← Currently rendered text
│            as a labeled box..." │
│                                 │
│  [Regenerate Preview]           │  ← Re-compile animation
└─────────────────────────────────┘
```

---

## Emotion Picker Bottom Sheet

Triggered when user types `[` or taps emotion toolbar:

```
┌─────────────────────────────────┐
│   ─────                        │  ← Drag handle
│                                 │
│   Add Emotion                   │
│   ┌─────────────────────────┐  │
│   │ 🔍 Search emotions...   │  │  ← Search field
│   └─────────────────────────┘  │
│                                 │
│   Categories:                   │
│   [All] [Narrator] [Code] [Concept] [Reaction]│
│                                 │
│   ── Popular ──────────────────│
│   ┌──────┐ ┌──────┐ ┌──────┐  │
│   │      │ │      │ │      │  │  ← Emotion cards
│   │  👤  │ │  💻  │ │  📦  │  │    with preview GIF
│   │      │ │      │ │      │  │
│   │narrator│ typing│box_appear│ │
│   └──────┘ └──────┘ └──────┘  │
│                                 │
│   ┌──────┐ ┌──────┐ ┌──────┐  │
│   │      │ │      │ │      │  │
│   │  🎊  │ │  🔄  │ │  🌳  │  │
│   │      │ │      │ │      │  │
│   │confetti│loop_spin│tree_branch│
│   └──────┘ └──────┘ └──────┘  │
│                                 │
│   [Browse Full Library →]       │
└─────────────────────────────────┘
```

---

## Emotion Parameter Dialog

When emotion has configurable parameters:

```
┌─────────────────────────────────┐
│  Configure: box_appear          │  ← Dialog title
│                                 │
│  📦 Box will appear with label  │  ← Preview description
│  and value inside it            │
│                                 │
│  ┌─────────────────────────┐   │
│  │ Variable Name *          │   │  ← Required param
│  │ x                        │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ Value *                  │   │
│  │ 42                       │   │
│  └─────────────────────────┘   │
│                                 │
│  Color:  ■ Blue  ○ Green  ○ Red│
│                                 │
│  Preview:                       │
│  ┌─────────────────────────┐   │
│  │  [Box animation preview]│   │  ← Live Rive preview
│  └─────────────────────────┘   │
│                                 │
│         [Cancel]  [Insert]      │
└─────────────────────────────────┘
```

---

## Export Tab

```
┌─────────────────────────────────┐
│  ←  My Python Course    💾 ...  │
│                                 │
│  [Script]  [Preview]  [Export✓] │
│                                 │
│  Ready to Export                │
│                                 │
│  ── Export as ─────────────────│
│  ○ Animated Course (publish)    │  ← Publish to AnimaLearn platform
│  ● Export Video (MP4)           │  ← Download MP4
│  ○ Share Link                   │  ← Shareable preview URL
│                                 │
│  ── MP4 Settings ──────────────│
│  Resolution: [1080p ▾]          │
│  Quality:    [High ▾]           │
│  Include:    ✅ Subtitles        │
│              ✅ Background music │
│              ☐ Intro/Outro      │
│                                 │
│  Estimated size: ~45MB          │
│  Export time: ~2 minutes        │
│                                 │
│  ┌─────────────────────────┐   │
│  │     📤 Export Video     │   │  ← Start export
│  └─────────────────────────┘   │
│                                 │
│  ── Or Publish to AnimaLearn ──│
│  Title: [Learn Python in 1hr]  │
│  Price: [Free ▾]               │
│  Category: [Programming ▾]     │
│                                 │
│  ┌─────────────────────────┐   │
│  │    🚀 Publish Course    │   │
│  └─────────────────────────┘   │
└─────────────────────────────────┘
```

---

## Export Progress Screen

```
┌─────────────────────────────────┐
│  Exporting your video...        │
│                                 │
│         [Lottie: rendering]     │  ← Animation of film strip
│                                 │
│  ████████████░░░░░░░░░░░  65%  │
│                                 │
│  Processing scene 4 of 10...   │
│  "Variables: box_appear"        │
│                                 │
│  Estimated time: 1:23 remaining │
│                                 │
│              [Cancel]           │
└─────────────────────────────────┘
```

---

## Editor Technical Notes

### Emotion Tag Syntax
Emotion tags use a simple bracket notation parsed by `EmotionParser`:

```
[EMOTION:type]                      # Simple emotion
[EMOTION:type param="value"]        # With string param
[EMOTION:type count=3]              # With number param
[CODE:language]...[/CODE]           # Code block
[SCENE:scene_name]                  # Scene marker
```

### Real-time Preview Architecture
- Script changes debounced by 500ms
- On change: EmotionParser → TimelineCompiler → Rive state machine update
- Preview canvas always shows current scene at cursor position
- Full preview renders from beginning on "Regenerate"

### Autosave
- Autosave to local Hive DB every 30 seconds
- Manual save button syncs to Supabase
- Offline-first: all editing happens locally, syncs when connected
