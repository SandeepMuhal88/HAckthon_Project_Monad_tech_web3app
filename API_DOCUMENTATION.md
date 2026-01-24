# Proof of Culture - Complete API Documentation

## Project Overview

**Proof of Culture** is a blockchain-based platform for verifying and recording cultural event attendance. Users can attend events, scan QR codes, and mint soulbound NFTs as proof of attendance on the Monad blockchain.

---

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   Flutter Frontend                      │
│  (Login → Events → QR Scan → Mint Proof → Profile)     │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ↓ HTTP/REST
┌─────────────────────────────────────────────────────────┐
│              FastAPI Backend (Port 8000)                │
│  ├─ Events API     (CRUD)                              │
│  ├─ QR Code API    (Generate)                          │
│  ├─ Proof API      (Verify & Mint)                     │
│  └─ User API       (Profile)                           │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ↓ Web3
┌─────────────────────────────────────────────────────────┐
│         Monad Blockchain (Ethereum Compatible)         │
│         CultureProof.sol - ERC721 Soulbound NFT        │
└─────────────────────────────────────────────────────────┘
```

---

## Backend API Endpoints

### Base URL
```
http://localhost:8000/api
```

### 1. Events Endpoints

#### Get All Events
```
GET /events
```

**Response:**
```json
{
  "success": true,
  "count": 4,
  "events": [
    {
      "id": "1",
      "name": "College Tech Fest",
      "location": "Main Campus",
      "description": "Annual technology festival",
      "capacity": 500,
      "attendees": 0,
      "start_time": "2024-02-01T09:00:00",
      "end_time": "2024-02-01T18:00:00"
    }
  ]
}
```

#### Get Specific Event
```
GET /events/{event_id}
```

**Response:**
```json
{
  "success": true,
  "event": {
    "id": "1",
    "name": "College Tech Fest",
    "location": "Main Campus",
    "description": "Annual technology festival",
    "capacity": 500,
    "attendees": 0
  }
}
```

#### Create Event
```
POST /events
```

**Request Body:**
```json
{
  "id": "5",
  "name": "Art Exhibition",
  "location": "Art Center",
  "description": "Contemporary art showcase",
  "capacity": 200,
  "attendees": 0
}
```

**Response:**
```json
{
  "success": true,
  "message": "Event created successfully",
  "event": { ... }
}
```

#### Update Event
```
PUT /events/{event_id}
```

#### Delete Event
```
DELETE /events/{event_id}
```

---

### 2. QR Code Endpoints

#### Generate QR Code for Event
```
GET /qr/generate/{event_id}
```

**Response:**
```json
{
  "success": true,
  "event_id": "1",
  "event_name": "College Tech Fest",
  "qr_data": {
    "qr_string": "1:1706028800:550e8400-e29b-41d4-a716-446655440000",
    "qr_image": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA...",
    "event_id": "1",
    "timestamp": 1706028800,
    "expires_at": 1706029100
  }
}
```

---

### 3. Proof Endpoints

#### Verify QR Code & Mint Proof NFT
```
POST /proof/verify
```

**Request Body:**
```json
{
  "qr": "1:1706028800:550e8400-e29b-41d4-a716-446655440000",
  "user_address": "0x742d35Cc6634C0532925a3b844Bc59e94f5bEdA8",
  "event_id": "1"
}
```

**Response (Success):**
```json
{
  "success": true,
  "message": "Proof minted successfully on Monad",
  "tx_hash": "0x123abc...",
  "token_id": 1
}
```

**Response (Error):**
```json
{
  "detail": "Invalid or expired QR code"
}
```

#### Get User's Proofs
```
GET /proof/user/{user_address}
```

**Response:**
```json
{
  "success": true,
  "user_address": "0x742d35Cc6634C0532925a3b844Bc59e94f5bEdA8",
  "proof_count": 3,
  "proofs": [
    {
      "user_address": "0x742d35Cc6634C0532925a3b844Bc59e94f5bEdA8",
      "event_id": "1",
      "timestamp": "2024-01-24T10:30:45.123456",
      "tx_hash": "0x123abc..."
    }
  ]
}
```

#### Direct Mint (Testing)
```
POST /proof/mint
```

**Query Parameters:**
```
user_address=0x742d35Cc6634C0532925a3b844Bc59e94f5bEdA8
```

---

## Flutter Frontend Screens

### 1. **Login Screen** (`/`)
- **Purpose**: User authentication
- **Fields**: Wallet Address, Full Name, Email
- **Actions**: Login, Register

### 2. **Events Screen** (`/events`)
- **Purpose**: Display all upcoming cultural events
- **Features**: 
  - List of events with details
  - Refresh functionality
  - "Verify Attendance" button per event

### 3. **QR Scanner Screen** (`/qr-scanner`)
- **Purpose**: Scan or paste QR code from event
- **Features**:
  - QR code input field
  - Demo QR code generator
  - Verify & Mint button

### 4. **Proof Status Screen** (`/proof-status`)
- **Purpose**: Show minting result
- **Features**:
  - Success/Failure indicator
  - Transaction hash display
  - Event details
  - Navigation to Profile

### 5. **Profile Screen** (`/profile`)
- **Purpose**: View user profile and earned proofs
- **Features**:
  - User information (name, email, wallet)
  - List of minted proofs
  - Logout functionality

---

## Smart Contract

### CultureProof.sol

**Network**: Monad Blockchain  
**Type**: ERC721 Soulbound NFT

**Key Functions**:

```solidity
contract CultureProof is ERC721, Ownable {
    // Mint a proof for a user (soulbound - non-transferable)
    function mint(address to) external onlyOwner
    
    // Prevents all transfers except initial mint
    function _update(address to, uint256 tokenId, address auth) 
        internal override returns (address)
}
```

**Characteristics**:
- Non-transferable (Soulbound)
- Verifiable on-chain
- One token per user per event
- Event metadata recorded off-chain

---

## Environment Variables

Create `.env` file in the `backend/` directory:

```bash
# Blockchain Configuration
MONAD_RPC_URL=https://testnet-rpc.monad.xyz/
CHAIN_ID=1
VERIFIER_PRIVATE_KEY=your_private_key_here
VERIFIER_ADDRESS=0x...
CULTURE_PROOF_ADDRESS=0x...

# Database
DATABASE_URL=sqlite:///proof_of_culture.db
```

---

## Setup Instructions

### Backend Setup

```bash
cd backend/

# Install dependencies
pip install -r requirements.txt

# Run the server
uvicorn app.main:app --reload --port 8000
```

### Frontend Setup

```bash
cd frontend/poc_engine/

# Get dependencies
flutter pub get

# Run the app
flutter run
```

---

## Data Models

### Event Model
```python
{
    "id": str,
    "name": str,
    "location": str,
    "description": str (optional),
    "start_time": datetime (optional),
    "end_time": datetime (optional),
    "capacity": int (optional),
    "attendees": int
}
```

### ProofRequest Model
```python
{
    "qr": str,              # QR code data
    "user_address": str,    # User's wallet address
    "event_id": str         # Event ID
}
```

### ProofResponse Model
```python
{
    "success": bool,
    "message": str,
    "tx_hash": str (optional),  # Transaction hash
    "token_id": int (optional)  # NFT token ID
}
```

---

## Workflow

### User Journey

```
1. User Login/Register
   ↓
2. Browse Cultural Events
   ↓
3. Attend Event & Receive QR Code
   ↓
4. Scan QR Code in App
   ↓
5. Verify QR Code
   ↓
6. Mint NFT Proof on Blockchain
   ↓
7. View Proof in Profile
```

### QR Code Format

```
{event_id}:{timestamp}:{nonce}

Example: 1:1706028800:550e8400-e29b-41d4-a716-446655440000
```

**QR Code Validity**: 5 minutes  
**Replay Protection**: Each QR code can only be used once

---

## Testing the Application

### 1. Start Backend
```bash
cd backend
python -m uvicorn app.main:app --reload
```

### 2. Test API with cURL

```bash
# Get all events
curl http://localhost:8000/api/events

# Generate QR code
curl http://localhost:8000/api/qr/generate/1

# Verify QR and mint
curl -X POST http://localhost:8000/api/proof/verify \
  -H "Content-Type: application/json" \
  -d '{
    "qr": "1:1706028800:demo-nonce",
    "user_address": "0x742d35Cc6634C0532925a3b844Bc59e94f5bEdA8",
    "event_id": "1"
  }'
```

### 3. Run Flutter App

```bash
cd frontend/poc_engine
flutter run
```

---

## Features Implemented

✅ **Complete Backend API**
- Event CRUD operations
- QR code generation with expiry
- Proof verification and minting
- User profile management
- Replay attack prevention

✅ **Complete Flutter Frontend**
- Authentication & Registration
- Event listing with real API integration
- QR code scanning interface
- Proof status display
- User profile with proof history

✅ **Smart Contract**
- ERC721 Soulbound NFT
- Non-transferable proofs
- Owner-based minting

✅ **Security Features**
- QR code expiry (5 minutes)
- Replay protection
- Wallet address validation

---

## Future Enhancements

1. **Database**: SQLite/PostgreSQL integration
2. **Auth**: Web3 wallet integration (MetaMask)
3. **Real QR**: Integrate camera-based QR scanning
4. **Events**: Admin panel for event management
5. **Analytics**: User statistics and proof analytics
6. **Notifications**: Push notifications for events
7. **Marketplace**: NFT gallery and trading
8. **MultiChain**: Support multiple blockchains

---

## Support & Deployment

### Docker Setup

```bash
docker-compose up
```

### Production Deployment

```bash
# Backend
gunicorn app.main:app --workers 4 --bind 0.0.0.0:8000

# Frontend
flutter build apk  # For Android
flutter build ios  # For iOS
flutter build web  # For Web
```

---

## Contact & Attribution

Project: **Proof of Culture** - LNM Hackathon 8.0  
Blockchain: **Monad Network**  
Technologies: **Flutter, FastAPI, Solidity, Web3**
