from pydantic import BaseModel
from typing import Optional

class ProofRequest(BaseModel):
    qr: str
    user_address: str
    event_id: str
    
    class Config:
        json_schema_extra = {
            "example": {
                "qr": "https://example.com/qr/abc123",
                "user_address": "0x742d35Cc6634C0532925a3b844Bc59e94f5bEdA8",
                "event_id": "1"
            }
        }

class ProofResponse(BaseModel):
    success: bool
    message: str
    tx_hash: Optional[str] = None
    token_id: Optional[int] = None
    
    class Config:
        json_schema_extra = {
            "example": {
                "success": True,
                "message": "Proof minted on Monad",
                "tx_hash": "0x123abc...",
                "token_id": 1
            }
        }
