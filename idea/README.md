# AnimaLearn — 2D Content Factory for Educational Videos

> A Flutter-based platform for creating and consuming animated 2D educational content.
> The "script-emotion" authoring system makes video production as easy as writing a script.

**Version**: 1.0.0 (Release Candidate)
**Platform**: Flutter (iOS · Android · Web · Desktop)
**Status**: Product Design & Architecture Complete

---

## Quick Start

```
idea/
├── README.md                    ← You are here (Product Overview)
├── product-vision.md            ← Mission, goals, success metrics
├── flutter-libraries.md         ← Complete dependency list with rationale
├── architecture/
│   ├── system-architecture.md   ← High-level system design
│   ├── data-models.md           ← Core data structures
│   └── api-spec.md              ← Backend API specification
└── screens/
    ├── 00-navigation.md         ← App navigation structure
    ├── 01-onboarding.md         ← Onboarding & auth screens
    ├── 02-showcase.md           ← Витрина (Course showcase)
    ├── 03-player.md             ← Video player screen
    ├── 04-editor.md             ← Script-Emotion editor
    ├── 05-emotion-library.md    ← Emotion script browser
    └── 06-export.md             ← Export & publish screen
```

---

## What Is AnimaLearn?

AnimaLearn is a **2D content factory** — a platform where educators can:
1. **Write** a course script with embedded "emotion tags"
2. **Preview** auto-generated 2D animations in real time
3. **Publish** as a video course accessible to students
4. **Monetize** through the built-in marketplace

### The "Script-Emotion" Innovation

Instead of manually animating each frame, educators write natural language with embedded animations:

```
[EMOTION:typing_code]
Here is how you create a variable in Python:

[CODE:python]
name = "Alice"
age = 25
[/CODE]

[EMOTION:box_appear name="name" value="Alice"]
[EMOTION:box_appear name="age" value="25"]

Think of variables as labeled boxes that store information.

[EMOTION:confetti]
```

This script automatically generates a 30-second animated scene — no timeline editing, no keyframes.

---

## Core Features

| Feature | Description |
|---------|-------------|
| **Showcase (Витрина)** | Browse and discover courses by topic, level, duration |
| **Video Player** | Full-screen animated course player with progress tracking |
| **Script Editor** | Rich text editor with emotion tag autocomplete |
| **Emotion Library** | Searchable library of 100+ pre-built animations |
| **Template Gallery** | Ready-made scene templates for common concepts |
| **Asset Library** | SVG characters, icons, backgrounds for customization |
| **AI Assistant** | "Generate animation for: explain Python loops" |
| **Export & Publish** | Export to MP4, share to platform, set pricing |
| **Analytics** | View counts, completion rates, engagement heatmaps |

---

## Target Users

### Learners
- Students learning programming (Python, JavaScript, etc.)
- Professionals upskilling in tech topics
- Visual learners who prefer animated explanations

### Creators
- YouTube educators and tutorial makers
- Bootcamp and course instructors
- Corporate L&D content teams

---

## Flagship Demo

**Course**: "Learn Python in 1 Hour"
- 10 modules × 6 minutes average
- 50+ animated scenes
- Uses all emotion categories
- Demonstrates the complete creator workflow

See [case study](../docs/case-studies/issue-1/04-use-case-python-course.md) for full breakdown.
