# 🚀 Proof of Culture - Complete Platform

> **Verify cultural event attendance and mint soulbound NFTs on blockchain**

## 📋 Table of Contents
- [Project Overview](#project-overview)
- [Features](#features)
- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [API Documentation](#api-documentation)
- [Development](#development)
- [Testing](#testing)
- [Deployment](#deployment)

---

## 🎯 Project Overview

**Proof of Culture** is a blockchain-enabled platform that allows users to:
1. **Discover** cultural events happening around them
2. **Attend** events and receive QR codes
3. **Verify** attendance by scanning QR codes
4. **Mint** soulbound NFTs as proof of participation on the Monad blockchain
5. **Showcase** their cultural participation on their profile

**Built for**: LNM Hackathon 8.0  
**Blockchain**: Monad Network (EVM-compatible)  
**Frontend**: Flutter  
**Backend**: FastAPI + Web3.py

---

## ✨ Features

### ✅ Backend Features
- **Event Management**: Full CRUD operations for events
- **QR Code Generation**: Time-bound, single-use QR codes
- **Proof Verification**: Verify QR codes and prevent replay attacks
- **NFT Minting**: Mint soulbound ERC721 tokens on Monad
- **User Proofs**: Track user's accumulated proofs
- **REST API**: Comprehensive REST API with CORS support
- **In-Memory Database**: Fast event and proof storage

### ✅ Frontend Features
- **Authentication**: User login/registration with wallet
- **Event Discovery**: Browse and filter cultural events
- **QR Scanning Interface**: Demo-ready QR scanning (ready for camera integration)
- **Proof Minting**: Interactive proof minting with status tracking
- **Profile Dashboard**: View user info and proof history
- **Local Storage**: Persist user data locally
- **Material Design**: Modern, responsive UI with Indigo theme

### ✅ Smart Contract Features
- **Soulbound NFTs**: Non-transferable proof tokens
- **ERC721 Compliance**: Standard NFT interface
- **Access Control**: Owner-based minting
- **Gas Efficient**: Optimized for Monad network

---

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ (for Hardhat compilation)
- Python 3.10+ (for backend)
- Flutter SDK (for frontend)
- MetaMask or compatible Web3 wallet

### 1. Backend Setup (5 minutes)

```bash
# Navigate to backend
cd backend

# Install Python dependencies
pip install -r requirements.txt

# Copy environment template
cp .env.example .env

# Edit .env with your Monad RPC credentials
# IMPORTANT: Add your contract address and verifier address

# Run the backend
python -m uvicorn app.main:app --reload --port 8000
```

**Backend will be available at**: `http://localhost:8000`  
**API Docs**: `http://localhost:8000/docs` (Swagger UI)

### 2. Frontend Setup (5 minutes)

```bash
# Navigate to frontend
cd frontend/poc_engine

# Get dependencies
flutter pub get

# Update API URL (if not localhost)
# Edit lib/services/api_service.dart -> baseUrl

# Run the app
flutter run

# Or build APK
flutter build apk --release
```

### 3. Smart Contract (Optional - Already Compiled)

```bash
# Navigate to contracts
cd contracts

# Install dependencies
npm install

# Compile (if needed)
npx hardhat compile

# Deploy (requires RPC URL and funds)
npx hardhat run deploy/deploy.ts --network monad
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────┐
│         FRONTEND (Flutter Mobile App)          │
│  ┌─────────────────────────────────────────┐  │
│  │ Login → Events → QR Scan → Mint → Profile│  │
│  └─────────────────────────────────────────┘  │
└─────────────────┬───────────────────────────────┘
                  │ REST API (HTTP)
┌─────────────────────────────────────────────────┐
│       BACKEND (FastAPI - Port 8000)            │
│  ┌─────────────────────────────────────────┐  │
│  │ Events API │ QR API │ Proof API │ Auth  │  │
│  └─────────────────────────────────────────┘  │
│  ┌─────────────────────────────────────────┐  │
│  │ Database (In-Memory) │ Services         │  │
│  └─────────────────────────────────────────┘  │
└─────────────────┬───────────────────────────────┘
                  │ Web3.py
┌─────────────────────────────────────────────────┐
│    BLOCKCHAIN (Monad - EVM Compatible)         │
│  ┌─────────────────────────────────────────┐  │
│  │      CultureProof.sol (ERC721)          │  │
│  │   Soulbound NFT Smart Contract          │  │
│  └─────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
```

### Database Schema

**In-Memory Storage**:
```
EVENTS = [
  { id, name, location, description, capacity, attendees, timestamps }
]

PROOFS = {
  qr_hash: { user_address, event_id, timestamp, tx_hash }
}

USERS = {
  user_address: { name, email, created_at, proofs_count }
}
```

---

## 📡 API Documentation

### Base URL
```
http://localhost:8000/api
```

### Events API

```bash
# Get all events
GET /events

# Get specific event
GET /events/{event_id}

# Create event
POST /events
Body: { name, location, description, capacity }

# Update event
PUT /events/{event_id}

# Delete event
DELETE /events/{event_id}
```

### QR Code API

```bash
# Generate QR code for event
GET /qr/generate/{event_id}

# Returns QR string + base64 image valid for 5 minutes
```

### Proof API

```bash
# Verify QR and mint NFT
POST /proof/verify
Body: {
  qr: string,
  user_address: string,
  event_id: string
}

# Get user's proofs
GET /proof/user/{user_address}

# Direct mint (testing)
POST /proof/mint?user_address=0x...
```

### Full API Documentation

Visit: `http://localhost:8000/docs` for interactive Swagger UI

---

## 👨‍💻 Development

### Project Structure

```
project/
├── backend/
│   ├── app/
│   │   ├── main.py                 # FastAPI app
│   │   ├── api/routes/
│   │   │   ├── events.py          # Event endpoints
│   │   │   ├── proof.py           # Proof endpoints
│   │   │   └── qr.py              # QR code endpoints
│   │   ├── models/
│   │   │   ├── event.py           # Event model
│   │   │   └── proof.py           # Proof model
│   │   ├── services/
│   │   │   ├── blockchain.py      # Web3 integration
│   │   │   ├── qr_service.py      # QR generation
│   │   │   └── verifier.py        # QR verification
│   │   ├── db/
│   │   │   └── database.py        # In-memory DB
│   │   └── core/
│   │       └── config.py          # Configuration
│   ├── requirements.txt            # Dependencies
│   └── .env.example               # Environment template
│
├── frontend/poc_engine/
│   ├── lib/
│   │   ├── main.dart              # Entry point
│   │   ├── app.dart               # App config
│   │   ├── services/
│   │   │   ├── api_service.dart   # API calls
│   │   │   └── storage_service.dart # Local storage
│   │   ├── routes/
│   │   │   └── app_routes.dart    # Navigation
│   │   └── features/
│   │       ├── auth/screens/      # Login/Register
│   │       ├── events/screens/    # Events list
│   │       ├── proof/screens/     # QR & Status
│   │       └── profile/screens/   # User profile
│   └── pubspec.yaml               # Dependencies
│
├── contracts/
│   ├── contracts/
│   │   └── CultureProof.sol       # NFT contract
│   ├── deploy/
│   │   └── deploy.ts              # Deployment script
│   ├── hardhat.config.ts          # Hardhat config
│   └── package.json
│
├── docker-compose.yml             # Docker setup
├── API_DOCUMENTATION.md           # Complete API docs
└── README.md                      # This file
```

### Adding New Features

#### Add New API Endpoint

1. Create model in `backend/app/models/`
2. Create route in `backend/app/api/routes/`
3. Add to `backend/app/main.py` router
4. Update API documentation

#### Add New Frontend Screen

1. Create screen in `lib/features/{feature}/screens/`
2. Add route in `lib/routes/app_routes.dart`
3. Create API calls in `lib/services/api_service.dart`
4. Import and use in other screens

---

## 🧪 Testing

### Backend Testing

```bash
cd backend

# Test API
python -m pytest tests/

# Or manually test endpoints
curl http://localhost:8000/api/events
curl http://localhost:8000/health
```

### Frontend Testing

```bash
cd frontend/poc_engine

# Run tests
flutter test

# Build and run on device
flutter run -d <device_id>
```

### E2E Flow Testing

1. **Start Backend**
   ```bash
   cd backend && python -m uvicorn app.main:app --reload
   ```

2. **Start Frontend**
   ```bash
   cd frontend/poc_engine && flutter run
   ```

3. **Test User Flow**
   - Login with test wallet: `0x742d35Cc6634C0532925a3b844Bc59e94f5bEdA8`
   - View events (should show 4 demo events)
   - Click "Verify Attendance"
   - Click "Use Demo QR Code"
   - Verify & Mint
   - Check Profile for proof

---

## 🚢 Deployment

### Docker Deployment

```bash
# Build and run with Docker
docker-compose up -d

# Check logs
docker-compose logs -f backend

# Stop
docker-compose down
```

### Backend Deployment (Production)

```bash
# Install production dependencies
pip install gunicorn

# Run with Gunicorn
gunicorn app.main:app \
  --workers 4 \
  --worker-class uvicorn.workers.UvicornWorker \
  --bind 0.0.0.0:8000 \
  --env PYTHONUNBUFFERED=1
```

### Frontend Deployment

```bash
# Build APK (Android)
flutter build apk --release

# Build iOS
flutter build ios --release

# Build Web
flutter build web --release

# Upload to Play Store / App Store
# Use respective deployment tools
```

### Smart Contract Deployment

```bash
cd contracts

# Deploy to Monad testnet
npx hardhat run deploy/deploy.ts --network monad

# Verify contract
npx hardhat verify --network monad <CONTRACT_ADDRESS>
```

---

## 🔒 Security Considerations

### Implemented
- ✅ QR code expiry (5 minutes)
- ✅ Replay attack prevention (one-time use)
- ✅ User wallet validation
- ✅ Event ownership verification

### Recommended for Production
- 🔜 Web3 wallet authentication
- 🔜 HTTPS/TLS for API
- 🔜 Rate limiting
- 🔜 Input validation & sanitization
- 🔜 Database encryption
- 🔜 Private key management (Vault/AWS Secrets)
- 🔜 Smart contract audit

---

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📝 Environment Variables

Copy `.env.example` to `.env` and fill in:

```bash
# Blockchain
MONAD_RPC_URL=https://testnet-rpc.monad.xyz/
CHAIN_ID=1
VERIFIER_PRIVATE_KEY=your_private_key
VERIFIER_ADDRESS=0x...
CULTURE_PROOF_ADDRESS=0x...

# Database
DATABASE_URL=sqlite:///proof_of_culture.db
```

---

## 📚 Resources

- **Monad Documentation**: https://docs.monad.xyz/
- **FastAPI Docs**: https://fastapi.tiangolo.com/
- **Flutter Docs**: https://flutter.dev/docs
- **OpenZeppelin Contracts**: https://docs.openzeppelin.com/contracts/
- **Hardhat Guide**: https://hardhat.org/getting-started/

---

## 📞 Support

For questions or issues:
1. Check API_DOCUMENTATION.md
2. Review inline code comments
3. Check test files for examples
4. Open an issue in the repository

---

## 📄 License

MIT License - See LICENSE file for details

---

## 🎉 Acknowledgments

- **LNM Hackathon 8.0** - For the platform and support
- **Monad Network** - For blockchain infrastructure
- **OpenZeppelin** - For secure smart contract libraries
- **Flutter & FastAPI communities** - For excellent documentation

---

## 🚀 Next Steps

1. ✅ Deploy backend to cloud (Heroku, AWS, GCP)
2. ✅ Deploy smart contract to Monad mainnet
3. ✅ Implement real QR code camera scanning
4. ✅ Add Web3 wallet integration (MetaMask)
5. ✅ Build admin panel for event management
6. ✅ Add event categories and filtering
7. ✅ Implement notification system
8. ✅ Create NFT gallery/showcase

---

**Happy hacking! 🚀**

Built with ❤️ for the Proof of Culture platform
