# 🚀 LOCAL DEPLOYMENT GUIDE (No Docker Required)

## ✅ Your Project is Ready for Local Deployment!

Since Docker is not available on your system, I've created **simple scripts** to deploy your application directly on Windows.

---

## 📋 Prerequisites

Make sure you have these installed:

1. **Python 3.10+** - [Download Here](https://www.python.org/downloads/)
   - ✅ Check: Run `python --version` in Command Prompt
   
2. **Flutter SDK** (Optional, for mobile/web builds) - [Download Here](https://flutter.dev/)
   - ✅ Check: Run `flutter --version` in Command Prompt

---

## 🚀 Quick Start - 2 Simple Steps

### Step 1: Start Backend Server

**Double-click** or run:
```
scripts\start-backend.bat
```

This will:
- ✅ Create a Python virtual environment
- ✅ Install all dependencies
- ✅ Start the FastAPI backend server on **http://localhost:8000**

**Keep this window open** - the backend runs here!

### Step 2: Test the Backend

Open your browser and go to:
- **API Documentation**: http://localhost:8000/docs
- **Health Check**: http://localhost:8000/health
- **Get Events**: http://localhost:8000/api/events

---

## 📱 Optional: Build Flutter App

### Build Web App

**Double-click** or run:
```
scripts\build-flutter.bat
```

This will:
- ✅ Install Flutter dependencies
- ✅ Build the web application
- ✅ Optionally build Android APK

### Run Flutter App (Alternative)

```cmd
cd frontend\poc_engine
flutter run -d chrome
```

This starts a **live development** version of the app (with hot-reload)

---

## 🌐 Service URLs

After starting the backend:

| Service | URL | Description |
|---------|-----|-------------|
| **API Documentation** | http://localhost:8000/docs | Interactive Swagger UI |
| **Backend API** | http://localhost:8000/api/ | REST API endpoints |
| **Health Check** | http://localhost:8000/health | Service status |
| **Get Events** | http://localhost:8000/api/events | List all events |

---

## 📝 Manual Deployment Steps (Alternative)

If the scripts don't work, you can deploy manually:

### Backend (Manual)

```cmd
cd backend

# Create virtual environment
python -m venv .venv

# Activate it
.venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Start server
python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

### Flutter Web (Manual)

```cmd
cd frontend\poc_engine

# Get dependencies
flutter pub get

# Build web
flutter build web --release

# Or run development mode
flutter run -d chrome
```

### Flutter Android APK (Manual)

```cmd
cd frontend\poc_engine

# Build APK
flutter build apk --release

# APK location:
# build\app\outputs\flutter-apk\app-release.apk
```

---

## 🎯 What Each Script Does

### `scripts\start-backend.bat`
- Creates Python virtual environment (`.venv` folder)
- Installs all Python dependencies from `requirements.txt`
- Starts FastAPI server with auto-reload
- **Keeps running** - press Ctrl+C to stop

### `scripts\build-flutter.bat`
- Installs Flutter packages
- Builds optimized web application
- Optionally builds Android APK
- Opens APK folder when done

---

## 🔧 Configuration

### Backend Configuration

The backend reads configuration from `backend\.env`:

```env
MONAD_RPC_URL=https://rpc3.monad.xyz
CHAIN_ID=12345
VERIFIER_PRIVATE_KEY=0xYOUR_PRIVATE_KEY
CULTURE_PROOF_ADDRESS=0xCONTRACT_ADDRESS
```

**For local testing**, you can use these placeholder values. The backend will start fine.

### Frontend Configuration

The frontend API URL is configured in:
```
frontend\poc_engine\lib\core\api_config.dart
```

Default: `http://localhost:8000/api` (perfect for local development)

---

## 🧪 Testing the Deployment

### 1. Test Backend Health

```cmd
curl http://localhost:8000/health
```

Expected response:
```json
{"status":"healthy","service":"Proof of Culture API"}
```

### 2. Test Events API

```cmd
curl http://localhost:8000/api/events
```

### 3. View API Documentation

Open browser: **http://localhost:8000/docs**

You can test all API endpoints interactively!

---

## 🐛 Troubleshooting

### Problem: "Python not found"
**Solution:**
1. Install Python from https://www.python.org/downloads/
2. During installation, check **"Add Python to PATH"**
3. Restart your terminal/Command Prompt
4. Verify: `python --version`

---

### Problem: "Port 8000 already in use"
**Solution:**
1. Find process using port:
   ```cmd
   netstat -ano | findstr :8000
   ```
2. Kill the process (replace PID):
   ```cmd
   taskkill /PID <process_id> /F
   ```
3. Or change the port in start-backend.bat:
   ```
   # Change --port 8000 to --port 8001
   ```

---

### Problem: "pip install fails"
**Solution:**
1. Make sure you're in the virtual environment:
   ```cmd
   cd backend
   .venv\Scripts\activate
   ```
2. Upgrade pip:
   ```cmd
   python -m pip install --upgrade pip
   ```
3. Try installing again:
   ```cmd
   pip install -r requirements.txt
   ```

---

### Problem: "Flutter not found"
**Solution:**
- Install Flutter SDK: https://flutter.dev/
- Add Flutter to PATH (installer does this)
- Verify: `flutter doctor`
- **Note**: Flutter is optional - backend works without it!

---

## 📊 Project Structure

```
backend/
  ├── app/              # Your FastAPI application
  ├── .venv/            # Python virtual environment (created by script)
  ├── .env              # Environment configuration
  └── requirements.txt  # Python dependencies

frontend/poc_engine/
  ├── lib/              # Flutter source code
  ├── build/web/        # Built web application (after build)
  └── pubspec.yaml      # Flutter dependencies

scripts/
  ├── start-backend.bat      # Start backend server
  ├── build-flutter.bat      # Build Flutter apps
  ├── deploy-local.ps1       # PowerShell deployment (if available)
  └── deploy.ps1             # Docker deployment (requires Docker)
```

---

## 🔄 Development Workflow

### Day-to-Day Development

1. **Start Backend:**
   ```cmd
   scripts\start-backend.bat
   ```

2. **Run Flutter in Development Mode:**
   ```cmd
   cd frontend\poc_engine
   flutter run -d chrome
   ```

3. **Make Changes** - Both will hot-reload automatically!

4. **Test APIs** - Use http://localhost:8000/docs

---

## 🎯 What You Can Do Now

✅ **Backend API** - Running on http://localhost:8000
✅ **API Documentation** - Interactive Swagger UI at /docs
✅ **Test Endpoints** - Use curl or the Swagger UI
✅ **Develop Flutter** - Live reload with `flutter run`
✅ **Build APKs** - Production Android builds
✅ **Build Web** - Optimized web application

---

## 📱 Mobile App Testing

### On Android Device/Emulator

1. Build APK:
   ```cmd
   scripts\build-flutter.bat
   ```

2. Install the APK:
   ```
   build\app\outputs\flutter-apk\app-release.apk
   ```

3. **Important**: Update API URL in the app to your computer's IP:
   - Find your IP: `ipconfig` (look for IPv4)
   - Example: `192.168.1.100`
   - Update `api_config.dart` to use `http://192.168.1.100:8000/api`

---

## 🆘 Getting More Help

- **Backend Issues**: Check the backend window for error messages
- **Flutter Issues**: Run `flutter doctor` to diagnose
- **API Testing**: Use the Swagger UI at http://localhost:8000/docs
- **Configuration**: See `backend\.env` for backend settings

---

## ✅ Deployment Checklist

### Initial Setup
- [ ] Python installed (`python --version` works)
- [ ] (Optional) Flutter installed (`flutter --version` works)
- [ ] Backend .env file configured (can use defaults for local testing)

### Running
- [ ] Start backend: `scripts\start-backend.bat`
- [ ] Verify: Open http://localhost:8000/docs
- [ ] Test: Click "Try it out" on any API endpoint
- [ ] (Optional) Build Flutter: `scripts\build-flutter.bat`

---

## 🎉 You're All Set!

**Your backend is running!** (or will be shortly)

### Next Steps:

1. **Wait for backend to finish installing dependencies**
2. **Open**: http://localhost:8000/docs
3. **Test APIs** using the Swagger UI
4. **Build Flutter** (optional): Run `scripts\build-flutter.bat`

---

## 🚀 Quick Reference

### Start Backend
```cmd
scripts\start-backend.bat
```

### Build Flutter
```cmd
scripts\build-flutter.bat
```

### Run Flutter Dev Mode
```cmd
cd frontend\poc_engine
flutter run -d chrome
```

### Stop Backend
- Press `Ctrl + C` in the backend window
- Or close the window

---

**Happy Coding! 🎊**

For full documentation, see:
- `COMPLETE_README.md` - Full project guide
- `API_DOCUMENTATION.md` - API reference
- `QUICK_START.md` - Development quick start
