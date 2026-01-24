from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class Event(BaseModel):
    id: str
    name: str
    location: str
    description: Optional[str] = None
    start_time: Optional[datetime] = None
    end_time: Optional[datetime] = None
    capacity: Optional[int] = None
    attendees: int = 0
    
    class Config:
        json_schema_extra = {
            "example": {
                "id": "1",
                "name": "College Tech Fest",
                "location": "Main Campus",
                "description": "Annual technology festival",
                "capacity": 500,
                "attendees": 150
            }
        }
