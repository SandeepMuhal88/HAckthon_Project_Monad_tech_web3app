import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    # Blockchain Configuration
    MONAD_RPC_URL = os.getenv("MONAD_RPC_URL", "https://testnet-rpc.monad.xyz/")
    CHAIN_ID = int(os.getenv("CHAIN_ID", "1"))
    VERIFIER_PRIVATE_KEY = os.getenv("VERIFIER_PRIVATE_KEY", "")
    VERIFIER_ADDRESS = os.getenv("VERIFIER_ADDRESS", "")
    CULTURE_PROOF_ADDRESS = os.getenv("CULTURE_PROOF_ADDRESS", "")
    
    # API Configuration
    API_TITLE = "Proof of Culture API"
    API_VERSION = "1.0.0"
    API_DESCRIPTION = "Backend API for cultural event proof and NFT minting"
    
    # Database Configuration
    DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///proof_of_culture.db")
    
    # QR Configuration
    QR_EXPIRY_SECONDS = 300
    
    # CORS Configuration
    ALLOWED_ORIGINS = ["*"]

settings = Settings()
