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

Built all 4 routers with mock in-memory data first, Firestore will be wired in next milestone. This way endpoints are testable immediately via FastAPI's built-in Swagger UI at `/docs` without needing any cloud setup.

Endpoints built:
- POST /auth/register-user
- GET /mobiles (with search, brand, price, stock filters)
- GET /mobiles/{id}
- POST /leads
- GET /leads/me/{user_id}
- POST /inquiries
- GET /inquiries/{mobile_id}

## Firestore Integration

Wired Firestore to all 4 routers, replacing mock in-memory data.

Key decisions:
- Filtering mobiles in memory after fetching instead of using Firestore queries — avoids needing composite indexes for every filter combination on the free tier
- Added duplicate lead check before registering interest
- Added mobile existence check in both leads and inquiries before writing

**Issues faced:**
- Inquiries endpoint was throwing 500 — Firestore requires a composite index when combining .where() and .order_by() on different fields. Fixed by creating the index directly from the error link Firebase provided.

## Flutter Frontend

Built the entire Flutter frontend feature by feature following clean
architecture — domain models, repositories, providers, screens.

Key decisions:
- Repositories handle all API calls, screens never talk to API directly
- Riverpod FutureProvider.autoDispose for catalog so it refetches
  automatically when filters change
- Responsive grid on catalog screen — 1 column on mobile, 2 on wider screens
- Register Interest button disables itself after registering to prevent
  duplicate leads — state updated locally without refetching

**Issues faced:**
- Flutter Web Google Sign-In couldn't use GoogleSignIn package directly.
  Had to split auth into two flows — web uses Firebase's signInWithPopup,
  Android uses GoogleSignIn package with credentials. This is the key
  architectural difference between the two platforms.
- Google logo was loading from external URL which failed in Flutter Web.
  Fixed by downloading the asset locally and registering it in pubspec.yaml.
- lib/ folder was missing on Ubuntu after cloning because Python's default
  gitignore (selected during GitHub repo creation) includes lib/. Fixed by
  removing lib/ from root .gitignore and pushing again.
- Flutter Web cannot reach 10.0.2.2 (Android emulator localhost). Fixed
  by using kIsWeb to conditionally set baseUrl to localhost for web and
  10.0.2.2 for Android.

---

## Firebase Auth Integration

Wired Firebase into Flutter using FlutterFire CLI which auto-generated
firebase_options.dart and registered both Android and Web apps in Firebase.

Key decisions:
- Used flutterfire configure to handle platform registration automatically
  instead of manually downloading config files
- Web Client ID must be explicitly passed to GoogleSignIn for web — sourced
  from Firebase Console → Authentication → Google → Web SDK configuration

---

## End to End Testing

Tested all features end to end:
- Google Sign-In working on web
- Users being created in Firestore on first login
- Mobiles catalog loading from Firestore
- Search and filter working correctly
- Mobile detail page showing specs
- Register Interest writing to Firestore leads collection
- Duplicate interest prevention working
- Inquiries posting and loading correctly

**Deployment:** GCP free tier billing setup was blocked during development.
Cloud Run and Firebase Hosting deployment is pending. All features are
fully functional locally.