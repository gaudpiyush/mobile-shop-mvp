from fastapi import APIRouter, HTTPException, Query
from app.models.mobile import MobileCreate, MobileResponse, MobileListResponse
from app.services.firestore import mobiles_collection

router = APIRouter(prefix="/mobiles", tags=["mobiles"])


@router.get("", response_model=MobileListResponse)
async def get_mobiles(
    search: str | None = Query(None, description="Search by brand or model"),
    brand: str | None = Query(None, description="Filter by brand"),
    min_price: float | None = Query(None, description="Minimum price"),
    max_price: float | None = Query(None, description="Maximum price"),
    stock_status: str | None = Query(None, description="available or out_of_stock"),
):
    try:
        docs = mobiles_collection.stream()
        results = []

        for doc in docs:
            data = doc.to_dict()
            data["id"] = doc.id
            results.append(data)

        if search:
            search_lower = search.lower()
            results = [
                m for m in results
                if search_lower in m["brand"].lower()
                or search_lower in m["model"].lower()
            ]

        if brand:
            results = [
                m for m in results
                if m["brand"].lower() == brand.lower()
            ]

        if min_price is not None:
            results = [m for m in results if m["price"] >= min_price]

        if max_price is not None:
            results = [m for m in results if m["price"] <= max_price]

        if stock_status:
            results = [
                m for m in results
                if m["stock_status"] == stock_status
            ]

        return MobileListResponse(
            total=len(results),
            mobiles=[MobileResponse(**m) for m in results]
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/{mobile_id}", response_model=MobileResponse)
async def get_mobile(mobile_id: str):
    try:
        doc = mobiles_collection.document(mobile_id).get()

        if not doc.exists:
            raise HTTPException(status_code=404, detail="Mobile not found")

        data = doc.to_dict()
        data["id"] = doc.id

        return MobileResponse(**data)

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))