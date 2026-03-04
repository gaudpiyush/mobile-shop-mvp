from fastapi import APIRouter, HTTPException
from datetime import datetime, timezone
from app.models.user import UserRegisterRequest, UserResponse
from app.services.firestore import users_collection

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/register-user", response_model=UserResponse)
async def register_user(payload: UserRegisterRequest):
    """
    Called after Google Sign-In.
    Creates or updates user in Firestore.
    """
    try:
        user_ref = users_collection.document(payload.uid)
        user_doc = user_ref.get()

        now = datetime.now(timezone.utc)

        if user_doc.exists:
            # User exists — just update last_login
            user_ref.update({"last_login": now})
            data = user_doc.to_dict()
            data["last_login"] = now
        else:
            # New user — create full record
            data = {
                "uid": payload.uid,
                "email": payload.email,
                "display_name": payload.display_name,
                "photo_url": payload.photo_url,
                "last_login": now,
            }
            user_ref.set(data)

        return UserResponse(**data)

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))