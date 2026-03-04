from fastapi import APIRouter, HTTPException
from datetime import datetime, timezone
from app.models.lead import LeadRequest, LeadResponse

router = APIRouter(prefix="/leads", tags=["leads"])

# Temporary in-memory store until Firestore is wired
MOCK_LEADS = []


@router.post("", response_model=LeadResponse)
async def register_interest(payload: LeadRequest):
    """
    Registers a user's interest in a specific mobile.
    """
    try:
        # TODO: replace with Firestore write later
        lead = {
            "id": str(len(MOCK_LEADS) + 1),
            "user_id": payload.user_id,
            "mobile_id": payload.mobile_id,
            "timestamp": datetime.now(timezone.utc),
        }

        MOCK_LEADS.append(lead)
        print(f"[LEADS] Interest registered: {lead}")

        return LeadResponse(**lead)

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/me/{user_id}", response_model=list[LeadResponse])
async def get_user_leads(user_id: str):
    """
    Returns all mobiles a user has registered interest in.
    """
    # TODO: replace with Firestore query later
    user_leads = [l for l in MOCK_LEADS if l["user_id"] == user_id]
    return [LeadResponse(**l) for l in user_leads]