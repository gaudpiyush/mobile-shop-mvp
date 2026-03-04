import os
from google.cloud import firestore
from dotenv import load_dotenv

load_dotenv()

# Initialize Firestore client using service account
db = firestore.Client.from_service_account_json(
    os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
)

# Collection references — single place to manage collection names
users_collection = db.collection("users")
mobiles_collection = db.collection("mobiles")
leads_collection = db.collection("leads")
inquiries_collection = db.collection("inquiries")