# ⚡ Quick Start Commands

## 🚀 Start Backend (Port 8000)

```bash
cd backend
pip install -r requirements.txt
python -m uvicorn app.main:app --reload
```

**API will be available at**:
- API: http://localhost:8000/api
- Docs: http://localhost:8000/docs (Swagger UI)
- Health: http://localhost:8000/health

---

## 📱 Start Frontend (Flutter)

### Option 1: Run on Device/Emulator
```bash
cd frontend/poc_engine
flutter pub get
flutter run
```

### Option 2: Run on Web (for testing)
```bash
cd frontend/poc_engine
flutter run -d chrome
```

### Option 3: Build APK
```bash
cd frontend/poc_engine
flutter build apk --release
```

---

## 🐳 Start with Docker

```bash
docker-compose up -d
```

Alternatively:
```bash
docker-compose up  # (with logs)
docker-compose down  # (to stop)
```

---

## 🧪 Test the APIs

### 1. Get All Events
```bash
curl http://localhost:8000/api/events
```

### 2. Generate QR Code
```bash
curl http://localhost:8000/api/qr/generate/1
```

### 3. Verify & Mint Proof
```bash
curl -X POST http://localhost:8000/api/proof/verify \
  -H "Content-Type: application/json" \
  -d '{
    "qr": "1:1706028800:demo-nonce",
    "user_address": "0x742d35Cc6634C0532925a3b844Bc59e94f5bEdA8",
    "event_id": "1"
  }'
```

### 4. Get User Proofs
```bash
curl http://localhost:8000/api/proof/user/0x742d35Cc6634C0532925a3b844Bc59e94f5bEdA8
```

---

## 📋 Sample Wallet Addresses for Testing

```
Primary: 0x742d35Cc6634C0532925a3b844Bc59e94f5bEdA8
Secondary: 0x1234567890123456789012345678901234567890
Test: 0xabcdefabcdefabcdefabcdefabcdefabcdefabcd
```

---

## 🎯 Sample Event IDs

```
Event 1: College Tech Fest (Main Campus)
Event 2: Morning Fitness Challenge (Hostel Ground)
Event 3: Cultural Dance Night (Auditorium)
Event 4: Music Competition (Amphitheater)
```

---

## 🔧 Update Configuration

### Backend Config
Edit `.env`:
```bash
MONAD_RPC_URL=https://testnet-rpc.monad.xyz/
CHAIN_ID=1
VERIFIER_PRIVATE_KEY=your_key_here
VERIFIER_ADDRESS=0x...
CULTURE_PROOF_ADDRESS=0x...
```

### Frontend Config
Edit `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://localhost:8000/api';
// Change to:
static const String baseUrl = 'http://192.168.1.100:8000/api';  // For LAN
// Or:
static const String baseUrl = 'https://api.example.com';  // For production
```

---

## 🐛 Debugging

### Backend Logs
```bash
# Watch backend logs
tail -f backend/logs.txt

# Or increase log level
python -m uvicorn app.main:app --reload --log-level debug
```

### Frontend Logs
```bash
# Flutter debug logs
flutter logs

# Verbose output
flutter run -v

# Check device logs
adb logcat | grep flutter
```

---

## 🧹 Clean Up

### Clear Backend Cache
```bash
cd backend
find . -type d -name __pycache__ -exec rm -rf {} +
find . -name "*.pyc" -delete
```

### Clear Flutter Cache
```bash
flutter clean
flutter pub get
```

### Clear Docker
```bash
docker-compose down -v  # Remove volumes
docker system prune     # Clean up
```

---

## 📊 Verify Installation

### Python Version
```bash
python --version  # Should be 3.10+
```

### Flutter Version
```bash
flutter --version
dart --version
```

### Required Packages (Backend)
```bash
cd backend
python -c "import fastapi, web3, qrcode; print('✅ All packages installed')"
```

### Required Packages (Frontend)
```bash
cd frontend/poc_engine
flutter pub list  # Should show http, qr_code_scanner, etc.
```

---

## 🚨 Common Issues & Solutions

### Backend

**Issue**: `ModuleNotFoundError: No module named 'fastapi'`
```bash
pip install -r requirements.txt
```

**Issue**: `Address already in use (:8000)`
```bash
# Find and kill process on port 8000
lsof -i :8000
kill -9 <PID>

# Or use different port
uvicorn app.main:app --port 8001
```

**Issue**: `Web3 connection failed`
```bash
# Check RPC URL in .env
# Verify internet connection
# Check Monad network status
```

### Frontend

**Issue**: `Connection refused`
```bash
# Make sure backend is running
# Check API URL in api_service.dart
# Verify IP address/localhost
```

**Issue**: `No devices found`
```bash
flutter devices
# List available emulators
flutter emulators
# Launch emulator
flutter emulators launch <name>
```

**Issue**: `Build error`
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📚 Documentation Files

| File | Purpose |
|------|---------|
| `COMPLETE_README.md` | Full project guide |
| `API_DOCUMENTATION.md` | API reference |
| `FEATURES_AND_APIS_SUMMARY.md` | Feature overview |
| `setup.sh` | Automated setup script |
| This file | Quick reference |

---

## 🎯 Testing Checklist

### Backend
- [ ] Health check: `curl http://localhost:8000/health`
- [ ] API docs: Open `http://localhost:8000/docs`
- [ ] Get events: `curl http://localhost:8000/api/events`
- [ ] Generate QR: `curl http://localhost:8000/api/qr/generate/1`
- [ ] Verify proof: POST to `/api/proof/verify`

### Frontend
- [ ] App launches
- [ ] Login/Register works
- [ ] Events load from API
- [ ] QR Scanner screen appears
- [ ] Verification succeeds
- [ ] Profile shows proofs

### Integration
- [ ] User login successful
- [ ] Events display correctly
- [ ] QR verification works
- [ ] NFT minting succeeds (or mocks)
- [ ] Profile updates
- [ ] Logout works

---

## 🚀 Production Deployment

### Backend
```bash
# Production build
gunicorn app.main:app \
  --workers 4 \
  --worker-class uvicorn.workers.UvicornWorker \
  --bind 0.0.0.0:8000

# With environment
MONAD_RPC_URL=<production_rpc> \
VERIFIER_PRIVATE_KEY=<secure_key> \
gunicorn app.main:app --workers 4
```

### Frontend
```bash
# Build release APK
flutter build apk --release

# Build iOS
flutter build ios --release

# Build Web
flutter build web --release
```

### Database
```bash
# Backup database
cp proof_of_culture.db proof_of_culture.db.backup

# Setup persistent storage
# Mount volume in docker-compose.yml
```

---

## 📞 Need Help?

1. **API Issues**: Check `API_DOCUMENTATION.md`
2. **Setup Issues**: See `COMPLETE_README.md`
3. **Code Issues**: Review inline comments in source code
4. **Feature Requests**: Check `FEATURES_AND_APIS_SUMMARY.md`

---

## 🎉 You're All Set!

Everything is ready to run. Just:
1. Start backend with `uvicorn`
2. Start frontend with `flutter run`
3. Test using the provided commands
4. Check documentation for details

**Happy coding! 🚀**
