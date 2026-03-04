from app.services.firestore import mobiles_collection

mobiles = [
    {
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
    {
        "brand": "Google",
        "model": "Pixel 8",
        "price": 59999.0,
        "stock_status": "available",
        "specs": {
            "ram": "8GB",
            "storage": "128GB",
            "camera": "50MP",
            "battery": "4575mAh"
        }
    },
    {
        "brand": "Xiaomi",
        "model": "14 Pro",
        "price": 49999.0,
        "stock_status": "available",
        "specs": {
            "ram": "12GB",
            "storage": "256GB",
            "camera": "50MP",
            "battery": "4880mAh"
        }
    },
]

def seed():
    for mobile in mobiles:
        doc_ref = mobiles_collection.add(mobile)
        print(f"Added: {mobile['brand']} {mobile['model']} with ID: {doc_ref[1].id}")

if __name__ == "__main__":
    seed()