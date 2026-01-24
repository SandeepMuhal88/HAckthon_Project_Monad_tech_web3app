import time
import hashlib
from ..db.database import PROOFS

QR_EXPIRY_SECONDS = 300  # 5 minutes

def verify_qr(qr: str) -> bool:
    """
    Verify QR code validity and prevent replay attacks
    
    QR format: event_id:timestamp:nonce
    """
    try:
        parts = qr.split(":")
        if len(parts) != 3:
            return False
            
        event_id, timestamp, nonce = parts
        timestamp = int(timestamp)

        # Check if QR has expired
        if time.time() - timestamp > QR_EXPIRY_SECONDS:
            return False

        # Check for replay attack
        qr_hash = hashlib.sha256(qr.encode()).hexdigest()
        if qr_hash in PROOFS:
            return False

        # Mark as used (replay protection)
        PROOFS[qr_hash] = {"verified_at": time.time(), "event_id": event_id}
        return True

    except Exception as e:
        print(f"QR verification error: {str(e)}")
        return False
