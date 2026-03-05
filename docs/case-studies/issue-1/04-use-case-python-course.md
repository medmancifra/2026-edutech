# Use Case: "Learn Python in 1 Hour"

## Overview

This is the flagship demo use case that validates the entire platform concept.
A complete beginner should be able to understand Python fundamentals through
animated 2D scenes in under 60 minutes.

---

## Course Structure

### Module Breakdown (60 minutes total)

| Module | Title | Duration | Animation Style |
|--------|-------|----------|----------------|
| 01 | What is Python? | 3 min | Animated logo + history infographic |
| 02 | Variables & Data Types | 8 min | Box metaphor + typed value reveal |
| 03 | Operators & Expressions | 5 min | Math symbols animated |
| 04 | String Manipulation | 5 min | String as a bead necklace |
| 05 | Lists & Tuples | 7 min | Stack of boxes, ordered/unordered |
| 06 | Dictionaries | 6 min | Key-lock metaphor |
| 07 | Conditional Logic (if/else) | 7 min | Decision tree branching |
| 08 | Loops (for/while) | 8 min | Circular conveyor belt |
| 09 | Functions | 6 min | Machine/factory metaphor |
| 10 | Mini Project: Calculator | 5 min | Build in real-time animation |

---

## Script-Emotion Format Example

The "script-emotion" system is central to the authoring experience.
An instructor writes natural text with embedded emotion tags that trigger animations.

### Example Script (Module 02 — Variables):

```
[SCENE:blank_screen]

[EMOTION:narrator_appear]
Meet Python! Python is a programming language that helps
computers understand instructions.

[EMOTION:typing_code]
Let's create our first variable:

[CODE:highlight]
x = 42
[/CODE]

[EMOTION:box_appear name="x" value="42" color="blue"]
Think of a variable like a labeled box.
We named this box "x" and put the number 42 inside.

[EMOTION:arrow_label text="variable name"]
[EMOTION:arrow_label text="value stored"]

[EMOTION:question_bubble]
What happens if we change what's inside?

[EMOTION:box_change name="x" value="100" color="orange"]
[CODE:highlight]
x = 100
[/CODE]

The box now holds 100! Variables can be updated.

[EMOTION:confetti]
You just learned what a variable is!
```

### Emotion Script Categories

| Category | Emotions | Description |
|----------|---------|-------------|
| **Narrators** | `narrator_appear`, `narrator_wave`, `narrator_point` | Animated character interactions |
| **Code** | `typing_code`, `highlight_line`, `error_shake`, `success_glow` | Code display animations |
| **Concepts** | `box_appear`, `box_change`, `arrow_label`, `diagram_reveal` | Abstract concept visualizations |
| **Reactions** | `confetti`, `thumbs_up`, `question_bubble`, `lightbulb` | Emotional feedback moments |
| **Transitions** | `scene_wipe`, `fade_in`, `slide_in`, `zoom_in` | Scene transitions |
| **Data** | `list_build`, `dict_expand`, `loop_spin`, `tree_branch` | Data structure animations |

---

## Scene Templates for Python Course

### Template 1: Code Reveal
```
Background: Dark editor theme (VS Code style)
Enter: Code appears line by line with typing sound
Highlight: Current line glows
Exit: Fade to result output
```

### Template 2: Box Metaphor (Variables)
```
Background: Clean white with subtle grid
Elements: Colored 3D-style boxes with labels
Animation: Box slides in from left, label types in
Value: Number/string pops inside with bounce
```

### Template 3: Flow Chart (Conditionals)
```
Background: Light gray
Elements: Diamond shapes (decisions) → rectangular boxes (actions)
Animation: Path lights up as decision is made
True path: Green arrows
False path: Red arrows
```

### Template 4: Conveyor Belt (Loops)
```
Background: Factory floor illustration
Elements: Items pass through machine (representing loop body)
Counter: Iteration counter ticks up
Exit condition: Machine stops, green checkmark
```

### Template 5: Function Machine
```
Background: Blueprint/technical paper
Elements: Input pipe → Machine box → Output pipe
Animation: Input value enters, machine processes, output appears
Parameters: Labels on input pipes
Return value: Label on output pipe
```

---

## Screen Flow: Watching the Python Course

```
App Launch
    │
    ▼
Course Catalog (Витрина / Showcase)
    │ Tap "Python in 1 Hour"
    ▼
Course Overview Screen
    │ Tap "Start Learning" / "Continue"
    ▼
Video Player Screen (with Timeline)
    │ Animation plays with script
    ├── [Tap screen] → Pause / Show controls
    ├── [Tap timestamp] → Jump to scene
    ├── [Swipe right] → Previous module
    └── [Swipe left] → Next module
    │
    ▼
Module Complete Screen
    │ Confetti animation + progress bar update
    ▼
Quiz Screen (optional: 2 quick questions)
    │
    ▼
Next Module (auto-advance or manual)
```

---

## Expected Engagement Metrics (Target)

| Metric | Target |
|--------|--------|
| Course completion rate | 65%+ |
| Avg session length | 8–12 minutes |
| Module replay rate | 30% (re-watch confusing parts) |
| Quiz pass rate | 80%+ |
| User satisfaction (NPS) | 60+ |

---

## Technical Implementation Notes

### Animation Data Model for This Course:
```json
{
  "course_id": "python_1h",
  "title": "Learn Python in 1 Hour",
  "modules": [
    {
      "id": "variables",
      "title": "Variables & Data Types",
      "duration_seconds": 480,
      "scenes": [
        {
          "id": "box_metaphor",
          "template": "box_concept",
          "script": "Meet Python variables...",
          "emotions": [
            {"time": 0.5, "type": "box_appear", "params": {"name": "x", "value": 42}},
            {"time": 3.0, "type": "arrow_label", "params": {"text": "variable name"}},
            {"time": 5.5, "type": "confetti"}
          ]
        }
      ]
    }
  ]
}
```
