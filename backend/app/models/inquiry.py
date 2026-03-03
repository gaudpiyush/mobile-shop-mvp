from pydantic import BaseModel
from datetime import datetime


class InquiryRequest(BaseModel):
    user_id: str
    mobile_id: str
    question_text: str


class InquiryResponse(BaseModel):
    id: str
    user_id: str
    mobile_id: str
    question_text: str
    vendor_reply: str | None = None  # starts as unanswered, vendor fills it later
    timestamp: datetime