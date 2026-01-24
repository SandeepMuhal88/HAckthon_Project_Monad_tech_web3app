from fastapi import APIRouter, HTTPException
from ...services.qr_service import generate_qr
from ...db.database import get_event

router = APIRouter()

@router.get("/generate/{event_id}")
def get_qr_code(event_id: str):
    """Generate a QR code for an event"""
    event = get_event(event_id)
    if not event:
        raise HTTPException(status_code=404, detail="Event not found")
    
    qr_data = generate_qr(event_id)
    return {
        "success": True,
        "event_id": event_id,
        "event_name": event.get("name"),
        "qr_data": qr_data
    }
