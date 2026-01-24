from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .api.routes import events, proof, qr
from .db.database import init_db

app = FastAPI(
    title="Proof of Culture Backend",
    description="Backend for creating and verifying cultural event proofs",
    version="1.0.0"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(events.router, prefix="/api/events", tags=["Events"])
app.include_router(proof.router, prefix="/api/proof", tags=["Proof"])
app.include_router(qr.router, prefix="/api/qr", tags=["QR Code"])

@app.on_event("startup")
def startup_event():
    init_db()

@app.get("/")
def health():
    return {"status": "ok", "message": "Proof of Culture Backend Running"}

@app.get("/health")
def health_check():
    return {"status": "healthy", "service": "Proof of Culture API"}
