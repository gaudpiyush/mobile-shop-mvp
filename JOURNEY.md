# Development Journey

## Project Setup & Architecture Planning

**Summary:** Understand requirements, finalize tech stack, scaffold project.

Went through the assignment requirements carefully. Decided to build backend first since I'm more comfortable with Python FastAPI. Will tackle Flutter after the API is solid.

Chose feature-first clean architecture over standard MVC because the app has 4 distinct domains (auth, catalog, leads, inquiries) — keeping them isolated makes more sense than grouping by type.

Chose Riverpod for Flutter state management.

**Setup done:**
- GitHub repo initialized
- Flutter app scaffolded (android + web targets)
- FastAPI project structure created
- Basic health check endpoint working

## Backend Data Models

Planned all endpoints and data models on paper before writing any code.

Key decisions:
- Separated request and response models cleanly (e.g. `MobileCreate` vs `MobileResponse`)
- `id` and `timestamp` are always present in responses
- Only genuinely uncertain fields are optional (`photo_url`, `vendor_reply`)
- Removed `message` fields from response models — UI concerns belong in frontend

## Backend Routers

Built all 4 routers with mock in-memory data first, Firestore will be 
wired in next milestone. This way endpoints are testable immediately 
via FastAPI's built-in Swagger UI at `/docs` without needing any 
cloud setup.

Endpoints built:
- POST /auth/register-user
- GET /mobiles (with search, brand, price, stock filters)
- GET /mobiles/{id}
- POST /leads
- GET /leads/me/{user_id}
- POST /inquiries
- GET /inquiries/{mobile_id}