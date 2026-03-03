from pydantic import BaseModel
from datetime import datetime


class LeadRequest(BaseModel):
    user_id: str
    mobile_id: str


class LeadResponse(BaseModel):
    id: str
    user_id: str
    mobile_id: str
    timestamp: datetime