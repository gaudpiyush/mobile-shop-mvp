from fastapi import APIRouter, HTTPException, Query
from app.models.mobile import MobileCreate, MobileResponse, MobileListResponse

router = APIRouter(prefix="/mobiles", tags=["mobiles"])

# Temporary in-memory data until Firestore is wired
MOCK_MOBILES = [
    {
        "id": "1",
        "brand": "Samsung",
        "model": "Galaxy S24",
        "price": 79999.0,
        "stock_status": "available",
        "specs": {
            "ram": "8GB",
            "storage": "256GB",
            "camera": "50MP",
            "battery": "4000mAh"
        }
    },
    {
        "id": "2",
        "brand": "Apple",
        "model": "iPhone 15",
        "price": 89999.0,
        "stock_status": "available",
        "specs": {
            "ram": "6GB",
            "storage": "128GB",
            "camera": "48MP",
            "battery": "3877mAh"
        }
    },
    {
        "id": "3",
        "brand": "OnePlus",
        "model": "12R",
        "price": 42999.0,
        "stock_status": "out_of_stock",
        "specs": {
            "ram": "8GB",
            "storage": "128GB",
            "camera": "50MP",
            "battery": "5500mAh"
        }
    },
]


@router.get("", response_model=MobileListResponse)
async def get_mobiles(
    search: str | None = Query(None, description="Search by brand or model"),
    brand: str | None = Query(None, description="Filter by brand"),
    min_price: float | None = Query(None, description="Minimum price"),
    max_price: float | None = Query(None, description="Maximum price"),
    stock_status: str | None = Query(None, description="available or out_of_stock"),
):
    """
    Returns list of mobiles with optional search and filters.
    """
    # TODO: replace with Firestore query later
    results = MOCK_MOBILES.copy()

    if search:
        search_lower = search.lower()
        results = [
            m for m in results
            if search_lower in m["brand"].lower()
            or search_lower in m["model"].lower()
        ]

    if brand:
        results = [m for m in results if m["brand"].lower() == brand.lower()]

    if min_price is not None:
        results = [m for m in results if m["price"] >= min_price]

    if max_price is not None:
        results = [m for m in results if m["price"] <= max_price]

    if stock_status:
        results = [m for m in results if m["stock_status"] == stock_status]

    return MobileListResponse(
        total=len(results),
        mobiles=[MobileResponse(**m) for m in results]
    )


@router.get("/{mobile_id}", response_model=MobileResponse)
async def get_mobile(mobile_id: str):
    """
    Returns a single mobile by ID.
    """
    # TODO: replace with Firestore read later
    mobile = next((m for m in MOCK_MOBILES if m["id"] == mobile_id), None)

    if not mobile:
        raise HTTPException(status_code=404, detail="Mobile not found")

    return MobileResponse(**mobile)