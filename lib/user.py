import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Initialize Firebase Admin SDK
cred = credentials.Certificate('path/to/serviceAccountKey.json')
firebase_admin.initialize_app(cred)

# Define function to fetch username from Firestore
def get_username(email):
    db = firestore.client()
    users_ref = db.collection('users')
    query = users_ref.where('email', '==', email)
    user_docs = query.get()
    for doc in user_docs:
        username = doc.get('username')
        return username
    return None
