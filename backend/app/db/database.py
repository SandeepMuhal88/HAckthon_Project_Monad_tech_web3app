from datetime import datetime

EVENTS = []
PROOFS = {}  # {qr_hash: {user_address, event_id, timestamp, tx_hash}}
USERS = {}   # {user_address: {name, email, proofs_count}}

def init_db():
    """Initialize database with sample events"""
    global EVENTS
    if not EVENTS:
        EVENTS = [
            {
                "id": "1",
                "name": "College Tech Fest",
                "location": "Main Campus",
                "description": "Annual technology festival showcasing student innovations",
                "capacity": 500,
                "attendees": 0,
                "start_time": "2024-02-01T09:00:00",
                "end_time": "2024-02-01T18:00:00"
            },
            {
                "id": "2",
                "name": "Morning Fitness Challenge",
                "location": "Hostel Ground",
                "description": "Daily fitness and wellness challenge",
                "capacity": 100,
                "attendees": 0,
                "start_time": "2024-02-01T06:00:00",
                "end_time": "2024-02-01T07:00:00"
            },
            {
                "id": "3",
                "name": "Cultural Dance Night",
                "location": "Auditorium",
                "description": "Celebration of diverse cultural performances",
                "capacity": 300,
                "attendees": 0,
                "start_time": "2024-02-02T19:00:00",
                "end_time": "2024-02-02T22:00:00"
            },
            {
                "id": "4",
                "name": "Music Competition",
                "location": "Amphitheater",
                "description": "Inter-hostel music competition",
                "capacity": 200,
                "attendees": 0,
                "start_time": "2024-02-03T18:00:00",
                "end_time": "2024-02-03T21:00:00"
            }
        ]

def add_event(event: dict):
    """Add a new event"""
    EVENTS.append(event)
    return event

def get_event(event_id: str):
    """Get event by ID"""
    for event in EVENTS:
        if event["id"] == event_id:
            return event
    return None

def add_proof(qr_hash: str, user_address: str, event_id: str, tx_hash: str):
    """Record a proof"""
    PROOFS[qr_hash] = {
        "user_address": user_address,
        "event_id": event_id,
        "timestamp": datetime.now().isoformat(),
        "tx_hash": tx_hash
    }

def get_user_proofs(user_address: str):
    """Get all proofs for a user"""
    return [p for p in PROOFS.values() if p["user_address"] == user_address]

def register_user(user_address: str, name: str, email: str):
    """Register a new user"""
    USERS[user_address] = {
        "name": name,
        "email": email,
        "created_at": datetime.now().isoformat(),
        "proofs_count": 0
    }

def get_user(user_address: str):
    """Get user data"""
    return USERS.get(user_address)
