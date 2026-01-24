from web3 import Web3
from ..core.config import settings
import json
import os

w3 = Web3(Web3.HTTPProvider(settings.MONAD_RPC_URL))

# Load contract ABI
try:
    abi_path = os.path.join(os.path.dirname(__file__), "../../contracts/artifacts/contracts/CultureProof.sol/CultureProof.json")
    if os.path.exists(abi_path):
        with open(abi_path, 'r') as f:
            contract_data = json.load(f)
            CONTRACT_ABI = contract_data.get("abi", [])
    else:
        CONTRACT_ABI = []
except:
    CONTRACT_ABI = []

def mint_proof(wallet_address: str) -> str:
    """
    Mint a proof NFT for a user on the Monad blockchain
    """
    try:
        # Check if we have a contract address and ABI
        if settings.CULTURE_PROOF_ADDRESS and CONTRACT_ABI:
            contract = w3.eth.contract(
                address=Web3.to_checksum_address(settings.CULTURE_PROOF_ADDRESS),
                abi=CONTRACT_ABI
            )
            
            # Build transaction
            tx = contract.functions.mint(Web3.to_checksum_address(wallet_address)).build_transaction({
                'from': settings.VERIFIER_ADDRESS,
                'nonce': w3.eth.get_transaction_count(settings.VERIFIER_ADDRESS),
                'gas': 100000,
                'gasPrice': w3.eth.gas_price,
            })
            
            # Sign transaction
            signed_tx = w3.eth.account.sign_transaction(tx, settings.VERIFIER_PRIVATE_KEY)
            
            # Send transaction
            tx_hash = w3.eth.send_raw_transaction(signed_tx.rawTransaction)
            return tx_hash.hex()
        else:
            # Fallback: return mock hash for development
            import uuid
            mock_hash = "0x" + uuid.uuid4().hex[:40]
            return mock_hash
            
    except Exception as e:
        print(f"Error minting proof: {str(e)}")
        # Return mock hash on error for development
        import uuid
        mock_hash = "0x" + uuid.uuid4().hex[:40]
        return mock_hash

