from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from datetime import datetime, timezone
from app.models.user import UserRegisterRequest, UserResponse

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/register-user", response_model=UserResponse)
async def register_user(payload: UserRegisterRequest):
    """
    Called after Google Sign-In.
    Creates or updates user in Firestore.
    """
    try:
        # replace with Firestore later
        user_data = {
            "uid": payload.uid,
            "email": payload.email,
            "display_name": payload.display_name,
            "photo_url": payload.photo_url,
            "last_login": datetime.now(timezone.utc).isoformat(),
        }

        print(f"[AUTH] User registered/updated: {user_data}")

        return UserResponse(
            uid=payload.uid,
            email=payload.email,
            display_name=payload.display_name,
            photo_url=payload.photo_url,
            last_login=datetime.now(timezone.utc),
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))