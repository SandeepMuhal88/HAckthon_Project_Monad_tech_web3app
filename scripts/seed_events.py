from app.db.database import EVENTS
from app.models.event import Event

def seed():
    if EVENTS:
        print("ℹ️ Events already seeded")
        return

    EVENTS.extend([
        Event(
            id="event_college_fest",
            name="College Tech Fest",
            location="Main Auditorium"
        ),
        Event(
            id="event_fitness",
            name="Morning Fitness Challenge",
            location="Hostel Ground"
        ),
        Event(
            id="event_coding",
            name="Daily Coding Sprint",
            location="Computer Lab"
        )
    ])

    print("✅ Demo events seeded")

if __name__ == "__main__":
    seed()
