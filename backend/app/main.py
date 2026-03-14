from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import auth, mobiles, leads, inquiries

app = FastAPI(title="Mobile Shop API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "https://mobile-shop-mvp-1e4fd.web.app",      # Firebase Hosting
        "https://mobile-shop-mvp-1e4fd.firebaseapp.com", # Firebase Hosting alt
        "http://localhost:8080",                         # Local Flutter Web
        "http://localhost:52631",                        # Local Flutter Web alt port
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(mobiles.router)
app.include_router(leads.router)
app.include_router(inquiries.router)

@app.get("/health")
async def health_check():
    return {"status": "ok"}