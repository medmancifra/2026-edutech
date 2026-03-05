# Screen: Onboarding & Authentication

## Onboarding Flow (3 screens, swipeable)

```
┌─────────────────────────────────┐
│                                 │
│         [AnimaLearn Logo]       │
│                                 │
│   ████████████████████████      │  ← Lottie animation: Python snake
│   █                        █   │    learns a concept with boxes
│   █    [2D Animation]      █   │
│   ████████████████████████      │
│                                 │
│   ● ○ ○                        │  ← Page indicator
│                                 │
│   "Learn anything through       │
│    beautiful animations"        │
│                                 │
│   [Get Started]  [I have account]│
└─────────────────────────────────┘

Screen 2:
┌─────────────────────────────────┐
│                                 │
│   ████████████████████████      │  ← Animation: Script editor
│   █ [EMOTION:box_appear]  █   │    with emotion tags lighting up
│   █ name = "Alice"         █   │
│   ████████████████████████      │
│                                 │
│   ○ ● ○                        │
│                                 │
│   "Write a script, we'll        │
│    animate it for you"          │
│                                 │
└─────────────────────────────────┘

Screen 3:
┌─────────────────────────────────┐
│                                 │
│   ████████████████████████      │  ← Animation: Course grid
│   █  [Course Cards]       █   │    appearing with shimmer
│   ████████████████████████      │
│                                 │
│   ○ ○ ●                        │
│                                 │
│   "Share your courses with      │
│    the world"                   │
│                                 │
│        [Start Creating]         │
└─────────────────────────────────┘
```

---

## Login Screen

```
┌─────────────────────────────────┐
│  ←                              │
│                                 │
│  [AnimaLearn Logo]              │
│                                 │
│  Welcome back                   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ Email                   │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ Password            👁  │   │
│  └─────────────────────────┘   │
│                                 │
│                  Forgot password?│
│                                 │
│  ┌─────────────────────────┐   │
│  │     Sign In             │   │  ← Primary CTA
│  └─────────────────────────┘   │
│                                 │
│  ─────────── or ───────────    │
│                                 │
│  ┌─────────────────────────┐   │
│  │  🍎  Continue with Apple │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │  G   Continue with Google│  │
│  └─────────────────────────┘   │
│                                 │
│  Don't have an account? Sign Up │
└─────────────────────────────────┘
```

---

## Sign Up Screen

```
┌─────────────────────────────────┐
│  ←                              │
│                                 │
│  Create Account                 │
│  Start creating animated courses│
│                                 │
│  ┌─────────────────────────┐   │
│  │ Full Name               │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ Email                   │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ Password            👁  │   │
│  └─────────────────────────┘   │
│                                 │
│  I am a: ○ Learner  ● Creator  │  ← Role selection
│                                 │
│  ┌─────────────────────────┐   │
│  │     Create Account      │   │
│  └─────────────────────────┘   │
│                                 │
│  ─────────── or ───────────    │
│                                 │
│  [Apple]  [Google]              │
│                                 │
│  Already have an account? Log In│
└─────────────────────────────────┘
```

---

## Design Specifications

### Colors
- Primary: `#6366F1` (Indigo) — trust, learning
- Secondary: `#F59E0B` (Amber) — energy, animation
- Background: `#FAFAFA` (Light) / `#0F0F0F` (Dark)
- Surface: `#FFFFFF` / `#1A1A2E`

### Typography
- Heading: **Plus Jakarta Sans** Bold
- Body: **Inter** Regular
- Code: **JetBrains Mono** Regular

### Animations
- Onboarding: Lottie animations (~150KB each)
- Button press: Scale(0.95) + opacity
- Screen transition: Fade + slide (Material motion)
