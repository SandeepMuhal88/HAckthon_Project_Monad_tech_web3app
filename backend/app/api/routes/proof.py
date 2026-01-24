from fastapi import APIRouter, HTTPException
from ...models.proof import ProofRequest, ProofResponse
from ...services.verifier import verify_qr
from ...services.blockchain import mint_proof
from ...db.database import add_proof, get_user_proofs

router = APIRouter()

@router.post("/verify", response_model=ProofResponse)
def verify_and_mint(data: ProofRequest):
    """Verify QR code and mint proof NFT"""
    
    # Verify QR code
    valid = verify_qr(data.qr)
    if not valid:
        raise HTTPException(status_code=400, detail="Invalid or expired QR code")
    
    try:
        # Mint proof on blockchain
        tx_hash = mint_proof(wallet_address=data.user_address)
        
        # Record proof in database
        add_proof(data.qr, data.user_address, data.event_id, tx_hash)
        
        return ProofResponse(
            success=True,
            message="Proof minted successfully on Monad",
            tx_hash=tx_hash,
            token_id=1
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error minting proof: {str(e)}")

@router.get("/user/{user_address}")
def get_user_proofs_route(user_address: str):
    """Get all proofs for a user"""
    proofs = get_user_proofs(user_address)
    return {
        "success": True,
        "user_address": user_address,
        "proof_count": len(proofs),
        "proofs": proofs
    }

@router.post("/mint")
def direct_mint(user_address: str):
    """Direct mint endpoint for testing"""
    try:
        tx_hash = mint_proof(wallet_address=user_address)
        return {
            "success": True,
            "message": "Proof minted successfully",
            "tx_hash": tx_hash
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error minting: {str(e)}")
