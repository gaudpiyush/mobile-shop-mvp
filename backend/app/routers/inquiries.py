from fastapi import APIRouter, HTTPException
from datetime import datetime, timezone
from app.models.inquiry import InquiryRequest, InquiryResponse
from app.services.firestore import inquiries_collection, mobiles_collection

router = APIRouter(prefix="/inquiries", tags=["inquiries"])

# Temporary in-memory store until Firestore is wired
MOCK_INQUIRIES = []


@router.post("", response_model=InquiryResponse)
async def post_inquiry(payload: InquiryRequest):
    """
    Posts a question for the vendor about a specific mobile.
    """
    try:
        # Check if mobile exists
        mobile_doc = mobiles_collection.document(payload.mobile_id).get()
        if not mobile_doc.exists:
            raise HTTPException(status_code=404, detail="Mobile not found")

        now = datetime.now(timezone.utc)
        inquiry_data = {
            "user_id": payload.user_id,
            "mobile_id": payload.mobile_id,
            "question_text": payload.question_text,
            "vendor_reply": None,
            "timestamp": now,
        }

        doc_ref = inquiries_collection.add(inquiry_data)

        return InquiryResponse(
            id=doc_ref[1].id,
            user_id=payload.user_id,
            mobile_id=payload.mobile_id,
            question_text=payload.question_text,
            vendor_reply=None,
            timestamp=now,
        )

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/{mobile_id}", response_model=list[InquiryResponse])
async def get_inquiries(mobile_id: str):
    """
    Returns all questions and vendor replies for a specific mobile.
    """
    try:
        docs = inquiries_collection\
            .where("mobile_id", "==", mobile_id)\
            .order_by("timestamp")\
            .stream()

        inquiries = []
        for doc in docs:
            data = doc.to_dict()
            data["id"] = doc.id
            inquiries.append(InquiryResponse(**data))

        return inquiries

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))