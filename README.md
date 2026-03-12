# Mobile Shop MVP

A cross-platform mobile shop application built with Flutter (Android & Web)
and a Python FastAPI backend, backed by Google Firestore.

## Project Structure
```
mobile-shop-mvp/
├── flutter_app/        # Flutter frontend (Android + Web)
├── backend/            # Python FastAPI backend
├── README.md
└── JOURNEY.md
```

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter (Dart) |
| State Management | Riverpod |
| Backend | Python FastAPI |
| Database | Google Firestore |
| Authentication | Firebase Auth (Google OAuth 2.0) |
| Backend Hosting | Google Cloud Run (pending) |
| Web Hosting | Firebase Hosting (pending) |

---

## Running Locally

### Prerequisites

- Flutter SDK
- Python 3.10+
- Node.js and npm
- Firebase project with Firestore and Google Auth enabled
- `service-account.json` from Firebase project settings
- Firebase CLI (`npm install -g firebase-tools`)

---

### Backend (FastAPI)
```bash
cd backend
python3 -m venv venv

# Windows
venv\Scripts\activate
# Linux/Mac
source venv/bin/activate

pip install -r requirements.txt
```

Create a `.env` file inside `backend/`:
```
GOOGLE_APPLICATION_CREDENTIALS=service-account.json
```

Place your `service-account.json` inside `backend/` then:
```bash
uvicorn app.main:app --reload
```

API will be available at `http://localhost:8000`
Swagger docs at `http://localhost:8000/docs`

#### Seed Mobile Data
```bash
python seed.py
```

---

### Flutter App
```bash
cd flutter_app
flutter pub get
```

#### Configure Firebase
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Activate FlutterFire CLI
dart pub global activate flutterfire_cli

# Add to PATH (Linux/Mac)
export PATH="$PATH:$HOME/.pub-cache/bin"

# Configure Firebase for the project
dart pub global run flutterfire_cli:flutterfire configure
# Select your Firebase project and choose android + web platforms
# This generates lib/firebase_options.dart automatically
```

#### Run on Web
```bash
flutter run -d chrome
```

#### Run on Android
```bash
# Start an Android emulator first, then:
flutter run
```

#### Build Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

---

## Google OAuth — Web vs Android

The app handles Google Sign-In differently per platform:

**Web:**
- Uses Firebase's `signInWithPopup` directly with `GoogleAuthProvider`
- Requires Web Client ID passed explicitly to `GoogleSignIn`
- Web Client ID sourced from Firebase Console → Authentication → Google → Web SDK configuration

**Android:**
- Uses `google_sign_in` package which handles the native Google Sign-In flow
- Requires `google-services.json` placed in `android/app/`
- SHA-1 fingerprint of the keystore must be registered in Firebase Console

Both flows end up with a Firebase `UserCredential`, from which we extract
the ID token and attach it to all subsequent API requests via Dio headers.

---

## Firestore Schema
```
users/
  {uid}/
    uid:           string
    email:         string
    display_name:  string
    photo_url:     string | null
    last_login:    timestamp

mobiles/
  {mobile_id}/
    brand:         string
    model:         string
    price:         number
    stock_status:  string (available | out_of_stock)
    specs:
      ram:         string
      storage:     string
      camera:      string
      battery:     string

leads/
  {lead_id}/
    user_id:       string
    mobile_id:     string
    timestamp:     timestamp

inquiries/
  {inquiry_id}/
    user_id:       string
    mobile_id:     string
    question_text: string
    vendor_reply:  string | null
    timestamp:     timestamp
```

---

## API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| POST | `/auth/register-user` | Register or update user on login |
| GET | `/mobiles` | Get all mobiles (supports search & filters) |
| GET | `/mobiles/{id}` | Get single mobile detail |
| POST | `/leads` | Register interest in a mobile |
| GET | `/leads/me/{user_id}` | Get user's registered interests |
| POST | `/inquiries` | Post a question for vendor |
| GET | `/inquiries/{mobile_id}` | Get all questions for a mobile |

### Query Parameters for `GET /mobiles`
| Param | Type | Description |
|---|---|---|
| `search` | string | Search by brand or model name |
| `brand` | string | Filter by brand |
| `min_price` | float | Minimum price filter |
| `max_price` | float | Maximum price filter |
| `stock_status` | string | `available` or `out_of_stock` |

---

## Architecture

The project follows a feature-first clean architecture:
```
feature/
├── data/      → Repository (API calls)
├── domain/    → Models (data classes)
└── view/      → Provider (state) + Screen (UI)
```

Data flow:
```
Screen → Provider → Repository → FastAPI → Firestore
```

---

## Deployment (Pending)

Deployed on Render as GCP free tier billing was unavailable