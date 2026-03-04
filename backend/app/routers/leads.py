from fastapi import APIRouter, HTTPException
from datetime import datetime, timezone
from app.models.lead import LeadRequest, LeadResponse
from app.services.firestore import leads_collection, mobiles_collection

router = APIRouter(prefix="/leads", tags=["leads"])


@router.post("", response_model=LeadResponse)
async def register_interest(payload: LeadRequest):
    """
    Registers a user's interest in a specific mobile.
    """
    try:
        # Check if mobile exists
        mobile_doc = mobiles_collection.document(payload.mobile_id).get()
        if not mobile_doc.exists:
            raise HTTPException(status_code=404, detail="Mobile not found")

        # Check if user already registered interest in this mobile
        existing = leads_collection\
            .where("user_id", "==", payload.user_id)\
            .where("mobile_id", "==", payload.mobile_id)\
            .get()

        if len(existing) > 0:
            raise HTTPException(
                status_code=400,
                detail="Interest already registered for this mobile"
            )

        now = datetime.now(timezone.utc)
        lead_data = {
            "user_id": payload.user_id,
            "mobile_id": payload.mobile_id,
            "timestamp": now,
        }

        doc_ref = leads_collection.add(lead_data)

        return LeadResponse(
            id=doc_ref[1].id,
            user_id=payload.user_id,
            mobile_id=payload.mobile_id,
            timestamp=now,
        )

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/me/{user_id}", response_model=list[LeadResponse])
async def get_user_leads(user_id: str):
    """
    Returns all mobiles a user has registered interest in.
    """
    try:
        docs = leads_collection.where("user_id", "==", user_id).stream()

        leads = []
        for doc in docs:
            data = doc.to_dict()
            data["id"] = doc.id
            leads.append(LeadResponse(**data))

        return leads

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))