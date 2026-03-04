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

**Next:** Build out all FastAPI endpoints