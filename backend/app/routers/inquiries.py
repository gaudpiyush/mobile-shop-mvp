from fastapi import APIRouter, HTTPException
from datetime import datetime, timezone
from app.models.inquiry import InquiryRequest, InquiryResponse

router = APIRouter(prefix="/inquiries", tags=["inquiries"])

# Temporary in-memory store until Firestore is wired
MOCK_INQUIRIES = []


@router.post("", response_model=InquiryResponse)
async def post_inquiry(payload: InquiryRequest):
    """
    Posts a question for the vendor about a specific mobile.
    """
    try:
        # TODO: replace with Firestore write later
        inquiry = {
            "id": str(len(MOCK_INQUIRIES) + 1),
            "user_id": payload.user_id,
            "mobile_id": payload.mobile_id,
            "question_text": payload.question_text,
            "vendor_reply": None,
            "timestamp": datetime.now(timezone.utc),
        }

        MOCK_INQUIRIES.append(inquiry)
        print(f"[INQUIRIES] Question posted: {inquiry}")

        return InquiryResponse(**inquiry)

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/{mobile_id}", response_model=list[InquiryResponse])
async def get_inquiries(mobile_id: str):
    """
    Returns all questions and vendor replies for a specific mobile.
    """
    # TODO: replace with Firestore query later
    mobile_inquiries = [i for i in MOCK_INQUIRIES if i["mobile_id"] == mobile_id]
    return [InquiryResponse(**i) for i in mobile_inquiries]