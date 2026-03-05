# Deep Research Notes: Detailed Platform & Technology Findings

This document contains the full details from deep internet research. Serves as a reference for the summaries in other documents.

## Sources
All data collected on 2026-03-05 via web research.

---

## Platform Pricing (2026 Accurate)

### Vyond
- Starter: $99/month or $699/year (10,000 AI credits/user/month)
- Professional: $199/month or $1,199/year (20,000 credits)
- Enterprise/Agency: up to $1,999/month
- **Note**: Removed Essential plan in May 2025 — heavy user backlash on Trustpilot
- **Restriction**: Max ~100 scenes in single non-whiteboard video

### Animaker
- Free tier: up to 3 videos of 2 minutes/month
- Basic: $20/month or $120/year
- Pro: $49/month or $588/year
- **Issues**: Frequent crashes, freezes, lost work; hidden asset paywalls

### Powtoon
- Free tier: with watermark
- Paid: ~$89/month for HD no-watermark
- **Issues**: Clunky timeline; steep learning curve

### Moovly
- Free plan available
- Starting: ~$24.95/month
- Academic/Enterprise: up to $299/month
- **Strength**: AI script generation + auto-translation in 130+ languages

### Synthesia
- Free: 36 minutes/year
- Starter: $18/month (10 video minutes/month)
- Creator: $64/month
- Enterprise: unlimited + SSO
- **Note**: AI avatar video, NOT 2D animation — different niche

---

## Market Data (2026 Accurate)

### E-Learning Market
- Global e-learning market (2025): **$354.71 billion**
- Projected by 2029: **$625 billion**
- CAGR: ~15%

### E-Learning Authoring Tools
- Market (2024): $5.19 billion
- Market (2025): $6.16 billion, CAGR 18.6%
- Market (2029): $12.04 billion

### EdTech Animation Specifically
- Market (2024): **$110.6 billion**
- Market (2025): $129.1 billion
- Market (2034): $518.2 billion
- CAGR: **16.7%**
- EdTech companies using animation: 25,000+ (60% increase from 2021)

### AI in Education
- Market (2024): $5.88 billion
- Market (2025): $8.30 billion (+41% YoY)
- Market (2030): $32.27 billion

---

## Flutter Library Pub Stats (2026 Accurate)

| Library | Pub Likes | Downloads | Notes |
|---------|-----------|-----------|-------|
| `flutter_animate` | ~4,150 | Very high | BSD-3 license |
| `rive` | ~1,930 | Very high | MIT |
| `lottie` | ~4,530 | ~1.29M | MIT |
| `flame` | ~2,200 | High | MIT; GitHub: 10,300 stars |
| `flutter_svg` | ~5,830 | ~3M | MIT; most popular Flutter SVG |
| `animations` | High | Very high | BSD-3, official flutter.dev |
| `flutter_quill` | ~3,000 | High | MIT |

### Rive vs Lottie (2025/2026 Update)
- **.riv file**: 10–15x smaller than equivalent uncompressed Lottie JSON
- **LottieFiles** launched native State Machine in late 2025 (catching up to Rive)
- **Rive state machine**: still more mature and production-ready for interactivity

---

## JavaScript Library Stats (2026 Accurate)

| Library | GitHub Stars | License | Bundle Size |
|---------|-------------|---------|------------|
| GSAP | ~24,000 | GreenSock (free, all plugins now free since 2024) | ~67kB |
| Anime.js | ~66,700 | MIT | ~17kB |
| Three.js | ~111,000 | MIT | ~600kB+ |
| PixiJS | ~46,700 | MIT | ~400kB |
| Paper.js | ~15,000 | MIT | ~220kB |
| Two.js | ~8,600 | MIT | ~72kB |
| Lottie-web | ~31,600 | MIT | ~275kB |
| Konva.js | ~14,200 | MIT | ~200kB |
| Fabric.js | ~31,000 | MIT | ~350kB |
| mo.js | ~18,700 | MIT | ~35kB |

**Note on GSAP**: As of 2024 (following Webflow's acquisition), ALL previously premium plugins
(MorphSVG, SplitText, DrawSVG, ScrollSmoother, etc.) are now completely free.

---

## Video Generation Tools (Detailed)

### Manim Community (Recommended for Phase 3)
- PyPI: `manim`
- Renders to MP4, GIF, PNG sequences
- LaTeX math rendering built-in
- Voice sync via `manim-voiceover` plugin
- **Weakness**: CPU/Cairo intensive; not real-time

### Revideo (Highly Recommended for Phase 3)
- Fork of Motion Canvas, API-first
- TypeScript/React-based
- `await renderVideo({ projectFile, variables, output })` — API call returns MP4
- Deploys to Google Cloud Run or AWS
- Apache 2.0 license
- **Assessment**: Best fit for a video-generation-as-a-service backend

### Remotion
- React-based, renders via headless Chromium + FFmpeg
- Remotion Lambda: AWS Lambda distributed rendering, cents per minute
- Free for individuals; $100/month for teams of 4+
- **Assessment**: Better for scale; Lambda can render thousands simultaneously

### Blender bpy (Grease Pencil)
- Grease Pencil v3 (Blender 4.3+): new API
- Run headless: `blender scene.blend --background --python script.py`
- Rendering engine: EEVEE Next (real-time rasterizer, fast for stylized 2D)
- `blenderless` PyPI package for easier headless workflows
- **Assessment**: Highest quality 2D output, but heavy infrastructure

### Godot Movie Maker Mode
- Godot 4.0+ feature: `godot --write-movie output.avi --fixed-fps 60 scene.tscn`
- Decouples simulation from wall-clock time
- **Limitation**: Requires display (or Xvfb virtual framebuffer) — `--headless` disables rendering
- MIT licensed
- **Assessment**: Viable but more complex to deploy than Blender

### Creatomate (Commercial API)
- Cloud REST API for template-based video generation
- JSON-defined compositions
- Languages: Node.js, Python, PHP, Ruby, C#, Java, Go
- **Assessment**: Fastest time-to-market for basic video assembly, no infrastructure

### Shotstack (Commercial API)
- Three APIs: Edit, Serve, Ingest
- AI features (Create API): script + voiceover + image generation
- **Assessment**: Good for assembling AI-generated assets into videos at scale

---

## Creator Pain Points (Research-Confirmed)

### Top Complaints (across Capterra, G2, Trustpilot, Reddit)
1. **Rapid price increases** — Vyond's May 2025 restructuring: mass user backlash
2. **AI credits feel like "suffocation"** — Vyond's credit system
3. **Crashes and lost work** — Animaker specifically: requires refresh = lost work
4. **Generic templates** — No niche-specific templates (science, coding, language)
5. **Style lock-in** — Can't mix whiteboard + cartoon in same project
6. **No batch production** — No way to produce 50+ similar videos systematically
7. **No version control** — Can't update one character across 20 videos
8. **Hidden paywalls** — Discover assets are paid AFTER building video
9. **Enterprise pricing alienates individuals** — solo educators priced out
10. **Slow exports** — HD rendering can take many minutes, blocking workflow

### Key Insight for Product Strategy
> "No existing platform is designed for high-volume production of structured educational content.
> Tools are built for single-video creation, not course-scale content pipelines."
> — Deep research conclusion

---

## Unity for Video Generation (Research Notes)

### Unity Recorder
- Dedicated package for capturing content to files (video, image sequences, GIFs, audio)
- Can be controlled from C# scripts programmatically
- `RecorderController.StartRecording()` / `StopRecording()`
- `MovieRecorderSettings` for MP4/WebM output

### Unity Batch Mode (Headless)
- `Unity -batchmode -quit -executeMethod MyScript.Build`
- Can run C# methods without opening the editor GUI
- **Limitation**: No display rendering in batch mode without special setup
- WindowDisplayServer workaround needed for rendering

### Unity Timeline API
- Programmatic: `TimelineAsset`, `TrackAsset`, `PlayableDirector`
- Create animations as data assets via C# code
- Control playback, seek, evaluate at any time

### Assessment
Unity is viable for high-quality 2D animation but:
- Requires Unity license (Runtime Fee controversy, though mostly resolved for mobile)
- Complex headless rendering setup
- Larger than Blender/Godot for a backend service
- Best reserved for Phase 3+ if quality demands it
