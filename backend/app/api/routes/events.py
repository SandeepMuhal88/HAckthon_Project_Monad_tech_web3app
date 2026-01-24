from fastapi import APIRouter, HTTPException
from ...db.database import EVENTS, init_db, add_event, get_event
from ...models.event import Event

router = APIRouter()

@router.get("")
def list_events():
    """Get all events"""
    if not EVENTS:
        init_db()
    return {
        "success": True,
        "count": len(EVENTS),
        "events": EVENTS
    }

@router.get("/{event_id}")
def get_event_detail(event_id: str):
    """Get a specific event by ID"""
    event = get_event(event_id)
    if not event:
        raise HTTPException(status_code=404, detail="Event not found")
    return {
        "success": True,
        "event": event
    }

@router.post("")
def create_event(event: Event):
    """Create a new event"""
    event_dict = event.model_dump()
    add_event(event_dict)
    return {
        "success": True,
        "message": "Event created successfully",
        "event": event_dict
    }

@router.put("/{event_id}")
def update_event(event_id: str, event_data: Event):
    """Update an event"""
    event = get_event(event_id)
    if not event:
        raise HTTPException(status_code=404, detail="Event not found")
    
    # Update event data
    updated_event = event_data.model_dump()
    for key, value in updated_event.items():
        if value is not None:
            event[key] = value
    
    return {
        "success": True,
        "message": "Event updated successfully",
        "event": event
    }

@router.delete("/{event_id}")
def delete_event(event_id: str):
    """Delete an event"""
    global EVENTS
    initial_count = len(EVENTS)
    EVENTS = [e for e in EVENTS if e["id"] != event_id]
    
    if len(EVENTS) == initial_count:
        raise HTTPException(status_code=404, detail="Event not found")
    
    return {
        "success": True,
        "message": "Event deleted successfully"
    }
