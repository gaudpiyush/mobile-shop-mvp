from pydantic import BaseModel


class MobileSpecs(BaseModel):
    ram: str
    storage: str
    camera: str
    battery: str


class MobileCreate(BaseModel):
    brand: str
    model: str
    price: float
    stock_status: str  # "available" or "out_of_stock"
    specs: MobileSpecs


class MobileResponse(BaseModel):
    id: str
    brand: str
    model: str
    price: float
    stock_status: str
    specs: MobileSpecs


class MobileListResponse(BaseModel):
    total: int
    mobiles: list[MobileResponse]