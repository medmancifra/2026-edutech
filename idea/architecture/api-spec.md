# API Specification: AnimaLearn Backend

## Base URL
```
Production: https://api.animalearn.app/v1
Staging:    https://api-staging.animalearn.app/v1
```

All API calls use Supabase PostgREST. Custom endpoints use Supabase Edge Functions (Deno).

---

## Authentication

All requests require Bearer token:
```
Authorization: Bearer <supabase_jwt_token>
```

---

## Courses API

### List Courses (Showcase)
```
GET /courses
Query params:
  category    string    Filter by category
  level       string    beginner|intermediate|advanced
  is_free     boolean   Filter free courses
  search      string    Full-text search
  sort        string    popular|newest|rating
  limit       int       Default: 12, Max: 50
  offset      int       Pagination offset

Response 200:
{
  "data": [
    {
      "id": "uuid",
      "title": "Learn Python in 1 Hour",
      "creator": { "id": "uuid", "name": "Alex", "avatar_url": "..." },
      "thumbnail_url": "...",
      "duration_seconds": 3600,
      "level": "beginner",
      "tags": ["python", "beginner"],
      "view_count": 1234,
      "rating": 4.9,
      "is_free": true
    }
  ],
  "count": 150,
  "has_more": true
}
```

### Get Course Details
```
GET /courses/:courseId
Response 200:
{
  "id": "uuid",
  "title": "...",
  "description": "...",
  "modules": [
    {
      "id": "uuid",
      "title": "Variables",
      "position": 2,
      "duration_seconds": 480,
      "animation_url": "https://storage.../module2.riv"
    }
  ],
  ...
}
```

### Get Module Animation
```
GET /courses/:courseId/modules/:moduleId/timeline
Response 200: AnimationTimeline JSON (see data-models.md)
```

---

## Projects API (Creator)

### List Projects
```
GET /projects
Response 200: { "data": [Project] }
```

### Create Project
```
POST /projects
Body: {
  "title": "My Python Course",
  "emotion_script": ""
}
Response 201: { "id": "uuid", "title": "..." }
```

### Update Project
```
PATCH /projects/:projectId
Body: {
  "title": "...",
  "emotion_script": "..."
}
Response 200: Project
```

### Compile Project (Emotion Script → Animation Timeline)
```
POST /projects/:projectId/compile
Body: { "emotion_script": "..." }
Response 202: {
  "status": "compiling",
  "job_id": "uuid"
}

→ Poll: GET /jobs/:jobId
Response (done):
{
  "status": "done",
  "timeline_url": "https://storage.../timeline.json",
  "preview_url": "https://storage.../preview.gif"
}
```

### Publish Project as Course
```
POST /projects/:projectId/publish
Body: {
  "title": "...",
  "description": "...",
  "category": "programming",
  "level": "beginner",
  "tags": ["python"],
  "is_free": true,
  "price": 0
}
Response 201: { "course_id": "uuid", "url": "..." }
```

### Export to Video
```
POST /projects/:projectId/export
Body: {
  "resolution": "1080p",
  "quality": "high",
  "include_subtitles": true
}
Response 202: { "job_id": "uuid" }

→ Poll: GET /jobs/:jobId
Response (done):
{
  "status": "done",
  "download_url": "https://storage.../export.mp4",
  "expires_at": "2026-04-05T00:00:00Z"
}
```

---

## Emotions API

### List Emotion Templates
```
GET /emotions
Query params:
  category    string
  is_premium  boolean
  search      string
  limit       int

Response 200:
{
  "data": [
    {
      "id": "uuid",
      "name": "box_appear",
      "type": "box_appear",
      "category": "concept",
      "rive_asset_url": "...",
      "preview_gif_url": "...",
      "params_schema": { ... },
      "is_premium": false
    }
  ]
}
```

### Get Emotion Details
```
GET /emotions/:emotionId
Response 200: EmotionTemplate
```

---

## Progress API

### Get User Progress for Course
```
GET /progress/:courseId
Response 200:
{
  "course_id": "uuid",
  "completed_modules": ["uuid1", "uuid2"],
  "last_module_id": "uuid2",
  "progress_percent": 20.0
}
```

### Update Progress
```
POST /progress/:courseId
Body: {
  "module_id": "uuid",
  "progress_percent": 100.0
}
Response 200: UserProgress
```

---

## AI Generation API (Phase 3)

### Generate Animation from Description
```
POST /ai/generate
Body: {
  "description": "Explain Python for loops with an animated conveyor belt",
  "language": "python",
  "duration_seconds": 60,
  "style": "infographic"
}
Response 202: { "job_id": "uuid" }

→ Poll: GET /jobs/:jobId
→ Returns: AnimationTimeline when done
```

---

## Webhooks (B2B API)

For enterprise customers who need event notifications:
```
POST /webhooks
Body: {
  "url": "https://your-server.com/webhook",
  "events": ["project.compiled", "course.published", "export.done"]
}

Webhook payload:
{
  "event": "project.compiled",
  "data": { "project_id": "uuid", "timeline_url": "..." },
  "timestamp": "2026-03-05T10:00:00Z"
}
```

---

## Rate Limits

| Plan | Requests/min | Compiles/day | AI Generates/mo |
|------|-------------|-------------|----------------|
| Free | 30 | 3 | 0 |
| Creator | 120 | 20 | 0 |
| Pro | 300 | 100 | 20 |
| Team | 1000 | 500 | 100 |
| Enterprise | Unlimited | Custom | Custom |
