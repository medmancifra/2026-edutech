# Screen: Emotion Script Library (Витрина скрипт-эмоций)

## Emotion Library Main Screen

```
┌─────────────────────────────────┐
│  ←  Emotion Library     🔍     │
│                                 │
│  ┌─────────────────────────┐   │
│  │ 🔍 Search emotions...   │   │
│  └─────────────────────────┘   │
│                                 │
│  Filter:  [All ●] [Free] [Pro] │
│                                 │
│  ── Categories ────────────────│
│  [All][Narrator][Code][Concept] │  ← Horizontal filter chips
│  [Reaction][Transition][Data]   │
│                                 │
│  ── 🔥 Most Used ──────────────│
│  ┌─────────────┐ ┌───────────┐ │
│  │  [Preview]  │ │ [Preview] │ │  ← 2-column emotion cards
│  │  🎊         │ │    💻     │ │    with animated GIF preview
│  │  confetti   │ │typing_code│ │
│  │  Reaction   │ │  Code     │ │
│  │  ★ FREE     │ │  ★ FREE   │ │
│  └─────────────┘ └───────────┘ │
│                                 │
│  ┌─────────────┐ ┌───────────┐ │
│  │  [Preview]  │ │ [Preview] │ │
│  │  📦         │ │   🌳      │ │
│  │  box_appear │ │tree_branch│ │
│  │  Concept    │ │  Data     │ │
│  │  ★ FREE     │ │  ★ PRO    │  │  ← Pro badge
│  └─────────────┘ └───────────┘ │
│                                 │
│  ── 💻 Code Category ──────────│
│  [See all 12 →]                 │
│  ┌─────────────┐ ┌───────────┐ │
│  │  [Preview]  │ │ [Preview] │ │
│  │  ⌨️          │ │   🔴      │ │
│  │typing_code  │ │error_shake│ │
│  └─────────────┘ └───────────┘ │
└─────────────────────────────────┘
```

---

## Emotion Detail Screen

Tap on emotion card to open detail:

```
┌─────────────────────────────────┐
│  ←  box_appear                  │
│                                 │
│  ████████████████████████████   │
│  █                          █  │  ← Large Rive animation preview
│  █    [Animated Preview     █  │    (looping)
│  █     of box_appear]       █  │
│  █                          █  │
│  ████████████████████████████   │
│                                 │
│  📦 Box Appear                  │  ← Title
│  Category: Concept              │  ← Category
│  ★ FREE                         │  ← Availability
│                                 │
│  Description                    │
│  A labeled box slides in from   │
│  the left, with the variable    │
│  name and value inside it.      │
│  Perfect for explaining         │
│  variables in programming.      │
│                                 │
│  Parameters:                    │
│  ┌─────────────────────────┐   │
│  │ name    string  required│   │  ← Parameter schema
│  │ value   any     required│   │
│  │ color   string  optional│   │
│  │           blue (default)│   │
│  └─────────────────────────┘   │
│                                 │
│  Usage Example:                 │
│  [EMOTION:box_appear            │
│    name="x" value="42"]         │
│                                 │
│  Used in 1,247 courses          │  ← Usage stats
│                                 │
│  ┌─────────────────────────┐   │
│  │  Insert into Script     │   │  ← CTA
│  └─────────────────────────┘   │
└─────────────────────────────────┘
```

---

## Complete Emotion Reference (All 50+ emotions)

### 🎭 Narrator Category (8 emotions)
| Tag | Description | Params | Free/Pro |
|-----|-------------|--------|---------|
| `narrator_appear` | Animated character appears | `character`, `position` | FREE |
| `narrator_wave` | Character waves at viewer | `character` | FREE |
| `narrator_point` | Character points at element | `character`, `direction` | FREE |
| `narrator_think` | Character thinking pose | `character` | FREE |
| `narrator_celebrate` | Character celebrates | `character` | FREE |
| `narrator_confused` | Character confused look | `character` | PRO |
| `narrator_angry` | Character frustrated pose | `character` | PRO |
| `narrator_exit` | Character exits screen | `character`, `direction` | FREE |

### 💻 Code Category (10 emotions)
| Tag | Description | Params | Free/Pro |
|-----|-------------|--------|---------|
| `typing_code` | Code appears with typing effect | `theme` | FREE |
| `highlight_line` | Specific line glows/highlights | `line`, `color` | FREE |
| `error_shake` | Red error shake on line | `line` | FREE |
| `success_glow` | Green success glow | `line` | FREE |
| `run_program` | Terminal output appears | `output` | FREE |
| `debug_step` | Step-through debugger animation | `line` | PRO |
| `git_commit` | Git commit visualization | `message` | PRO |
| `code_diff` | Show code before/after diff | `before`, `after` | PRO |
| `terminal_type` | Terminal command typing | `command` | FREE |
| `bracket_highlight` | Matching bracket highlight | | PRO |

### 📦 Concept Category (12 emotions)
| Tag | Description | Params | Free/Pro |
|-----|-------------|--------|---------|
| `box_appear` | Variable box appears | `name`, `value`, `color` | FREE |
| `box_change` | Box value changes | `name`, `newValue` | FREE |
| `arrow_label` | Labeled arrow appears | `text`, `direction` | FREE |
| `diagram_reveal` | Diagram draws itself | `type` | FREE |
| `flowchart_step` | Flowchart step highlights | `step` | PRO |
| `stack_push` | Value pushed onto stack | `value` | FREE |
| `stack_pop` | Value popped from stack | | FREE |
| `array_index` | Array index highlights | `index` | FREE |
| `pointer_move` | Memory pointer moves | `from`, `to` | PRO |
| `function_call` | Function call visualization | `name`, `args` | FREE |
| `return_value` | Return value animation | `value` | FREE |
| `class_diagram` | Class/UML diagram | `fields`, `methods` | PRO |

### 🎊 Reaction Category (8 emotions)
| Tag | Description | Params | Free/Pro |
|-----|-------------|--------|---------|
| `confetti` | Confetti celebration | `intensity` | FREE |
| `thumbs_up` | Thumbs up animation | | FREE |
| `question_bubble` | Question mark bubble | | FREE |
| `lightbulb` | Lightbulb "aha!" moment | | FREE |
| `star_burst` | Star burst effect | | FREE |
| `warning_flash` | Warning/caution flash | | FREE |
| `checkmark` | Green checkmark appears | | FREE |
| `cross_out` | Red X cross out effect | | FREE |

### 🔄 Transition Category (6 emotions)
| Tag | Description | Params | Free/Pro |
|-----|-------------|--------|---------|
| `scene_wipe` | Horizontal wipe transition | `direction` | FREE |
| `fade_in` | Fade in from black | `duration` | FREE |
| `fade_out` | Fade to black | `duration` | FREE |
| `slide_in` | Slide in from edge | `direction` | FREE |
| `zoom_in` | Zoom in from center | | FREE |
| `circle_reveal` | Circular reveal | | PRO |

### 📊 Data Structure Category (8 emotions)
| Tag | Description | Params | Free/Pro |
|-----|-------------|--------|---------|
| `list_build` | List builds item by item | `items` | FREE |
| `dict_expand` | Dictionary expands with KV pairs | `pairs` | FREE |
| `loop_spin` | Conveyor belt loop | `iterations`, `items` | FREE |
| `tree_branch` | Binary tree branches | `structure` | PRO |
| `graph_connect` | Graph nodes & edges | `nodes`, `edges` | PRO |
| `sort_animate` | Sorting algorithm visualization | `array`, `algorithm` | PRO |
| `matrix_fill` | 2D matrix filling | `matrix` | PRO |
| `queue_process` | Queue enqueue/dequeue | `items` | FREE |

---

## Design Notes

### Emotion Card Design
```
┌─────────────────┐
│                 │
│  [GIF Preview]  │  ← 200x120px animated preview
│                 │
├─────────────────┤
│ 🎊 confetti    │  ← Icon + name
│ Reaction  FREE  │  ← Category + pricing badge
└─────────────────┘
```

### Preview Animation
- Cards show looping animated GIF preview (48x27px @2x = 96x54px)
- Tap to see full-screen Rive preview
- GIFs auto-generated from Rive files during asset processing

### Marketplace (Phase 2)
Community template creators can submit custom emotions:
1. Create Rive file with required state machine interface
2. Submit via AnimaLearn Creator Portal
3. Review by team (automated + manual)
4. Publish to marketplace (free or paid)
5. Creator earns 70% of revenue from paid downloads
