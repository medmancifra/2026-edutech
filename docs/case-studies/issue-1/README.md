# Case Study: 2D Content Factory — Educational Video Service

**Issue:** [#1 — Идея создать сервис фабрика 2d контента](https://github.com/medmancifra/2026-edutech/issues/1)
**Date:** 2026-03-05
**Status:** Research & Analysis Complete

---

## Contents

| File | Description |
|------|-------------|
| [01-market-analysis.md](01-market-analysis.md) | Market size, growth trends, opportunity |
| [02-competitor-analysis.md](02-competitor-analysis.md) | Existing platforms, strengths, weaknesses |
| [03-technology-landscape.md](03-technology-landscape.md) | Available tech stacks, libraries, engines |
| [04-use-case-python-course.md](04-use-case-python-course.md) | "Learn Python in 1 Hour" use case breakdown |
| [05-proposed-solutions.md](05-proposed-solutions.md) | Proposed architecture and solution options |

---

## Summary

The request is to design a **2D Content Factory** — a SaaS platform for producing animated educational videos. The core concept:

- **Engine**: Animated infographic style, 2D vector drawings
- **Platform**: Flutter (mobile + web + desktop)
- **Content authoring**: Script-emotion editor where text with embedded "emotion scripts" triggers animated scenes
- **Two main screens**: Showcase (Витрина) + Script-Emotion Editor
- **Use case**: "How to learn Python in 1 hour" — animated course

### Key Findings

1. **Market is large and growing**: E-Learning authoring tools market projected to grow from $6.16B (2024) to $17.58B by 2030 at 19.1% CAGR
2. **Competition exists but is fragmented**: Vyond, Animaker, Powtoon dominate the animated video space but are generic, not specialized for code/tech education
3. **Flutter is viable**: Rich ecosystem of animation libraries (Rive, Lottie, Flame, flutter_animate) makes it suitable
4. **Programmatic generation is a differentiator**: Tools like Manim, Motion Canvas, Remotion enable code-driven content; integrating with LLMs creates a unique opportunity
5. **Open-source engines viable**: Blender (bpy Python API), Godot (headless scripting) both support automation

See [05-proposed-solutions.md](05-proposed-solutions.md) for recommended implementation path.
