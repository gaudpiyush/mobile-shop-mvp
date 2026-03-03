from pydantic import BaseModel
from datetime import datetime
from typing import Optional


class UserRegisterRequest(BaseModel):
    uid: str
    email: str
    display_name: str
    photo_url: Optional[str] = None


class UserResponse(BaseModel):
    uid: str
    email: str
    display_name: str
    photo_url: Optional[str] = None
    last_login: Optional[datetime] = None
    message: Optional[str] = None