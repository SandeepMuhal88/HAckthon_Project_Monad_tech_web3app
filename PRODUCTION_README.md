# 🚀 PRODUCTION READY - Deployment Instructions

## 📁 What Has Been Created

Your project is now **production-ready** with the following deployment infrastructure:

### 🐳 Docker & Container Configuration
- ✅ `docker-compose.yml` - Full orchestration for backend + Nginx
- ✅ `backend/Dockerfile` - Production-optimized backend image
- ✅ `backend/.dockerignore` - Minimized image size
- ✅ `nginx/nginx.conf` - Reverse proxy with rate limiting & security

### 🔧 Configuration Files
- ✅ `.env.production` - Production environment template
- ✅ `frontend/poc_engine/lib/core/api_config.dart` - Environment-aware API config
- ✅ Updated `api_service.dart` - Using centralized configuration

### 📜 Deployment Scripts
- ✅ `scripts/deploy.ps1` - **Windows deployment script** (PowerShell)
- ✅ `scripts/deploy.sh` - Linux/Mac deployment script (Bash)
- ✅ `scripts/validate.ps1` - Pre-deployment validation

### 📚 Documentation
- ✅ `DEPLOYMENT_GUIDE.md` - Comprehensive deployment guide
- ✅ This file - Quick start instructions

---

## 🎯 Quick Start - Deploy in 3 Steps

### Step 1: Configure Your Environment

Edit `.env.production` with your actual values:

```bash
# REQUIRED: Update these before deploying!
VERIFIER_PRIVATE_KEY=your_actual_private_key
VERIFIER_ADDRESS=0xYourWalletAddress
CULTURE_PROOF_ADDRESS=0xYourContractAddress
API_URL=http://localhost/api  # Or your domain
```

### Step 2: Validate Configuration

```powershell
# Run pre-deployment checks
.\scripts\validate.ps1
```

This will verify:
- All required files exist
- Environment variables are configured
- Docker is running
- Flutter is installed
- Ports are available
- Code has no syntax errors

### Step 3: Deploy!

```powershell
# Deploy everything automatically
.\scripts\deploy.ps1
```

The script will:
1. Build Flutter web app
2. Update API URLs for production
3. Build Docker images
4. Start all services
5. Run health checks
6. Open your browser

**That's it! Your app is now running! 🎉**

---

## 🌐 Access Your Application

After deployment:

| Service | URL | Description |
|---------|-----|-------------|
| **Web App** | http://localhost/app/ | Main application |
| **API** | http://localhost/api/ | REST API |
| **Docs** | http://localhost/docs | Swagger UI |
| **Health** | http://localhost/health | Status check |

---

## 📱 Mobile App Deployment

### Android APK

The deployment script will ask if you want to build the APK:

```powershell
Do you want to build Android APK? (y/N): y
```

Or build manually:

```powershell
cd frontend\poc_engine
flutter build apk --release
```

APK location: `frontend\poc_engine\build\app\outputs\flutter-apk\app-release.apk`

---

## 🔄 Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│                    Your Domain                       │
│                 (or localhost:80)                    │
└───────────────────┬─────────────────────────────────┘
                    │
            ┌───────▼────────┐
            │  Nginx Proxy   │  Port 80/443
            │  (Container)   │  - Reverse Proxy
            └───┬────────┬───┘  - Rate Limiting
                │        │      - SSL Termination
    ┌───────────┘        └──────────┐
    │                               │
┌───▼──────────┐          ┌────────▼────────┐
│   Backend    │          │  Static Files   │
│   FastAPI    │  :8000   │  Flutter Web    │
│ (Container)  │          │  (Nginx Served) │
└──────┬───────┘          └─────────────────┘
       │
       │ SQLite
┌──────▼────────┐
│   Database    │
│   (Volume)    │
└───────────────┘
```

---

## 🔧 Common Tasks

### View Logs

```powershell
# All services
docker-compose logs -f

# Backend only
docker-compose logs -f backend

# Last 50 lines
docker-compose logs --tail=50
```

### Restart Services

```powershell
# Restart everything
docker-compose restart

# Restart specific service
docker-compose restart backend
docker-compose restart nginx
```

### Stop Services

```powershell
# Stop all
docker-compose down

# Stop and remove volumes (fresh start)
docker-compose down -v
```

### Update Code

```powershell
# Pull latest code
git pull

# Rebuild and deploy
.\scripts\deploy.ps1
```

---

## 🐛 Troubleshooting

### Problem: "Port already in use"

```powershell
# Find what's using port 80
netstat -ano | findstr :80

# Kill the process (replace PID)
taskkill /PID <process_id> /F

# Or change port in docker-compose.yml
```

### Problem: "Docker is not running"

1. Open **Docker Desktop**
2. Wait for it to start
3. Run validation: `.\scripts\validate.ps1`
4. Try deployment again

### Problem: "Backend health check failed"

```powershell
# Check backend logs
docker-compose logs backend

# Common causes:
# - Invalid environment variables
# - Database permission issues
# - Missing dependencies
```

### Problem: "Flutter build failed"

```powershell
cd frontend\poc_engine

# Clean and rebuild
flutter clean
flutter pub get
flutter build web --release
```

---

## 🔒 Security Checklist

Before going to production:

- [ ] Update **all** placeholder values in `.env.production`
- [ ] Never commit `.env.production` to version control
- [ ] Use **strong** private keys for blockchain
- [ ] Enable **SSL/HTTPS** (see DEPLOYMENT_GUIDE.md)
- [ ] Restrict **CORS** origins in nginx.conf
- [ ] Set up **firewall** rules on your server
- [ ] Enable **rate limiting** (already configured)
- [ ] Review **Nginx security headers** (already configured)
- [ ] Set up **database backups**
- [ ] Monitor **logs** for suspicious activity

---

## 📊 What's Different from Development?

| Aspect | Development | Production |
|--------|-------------|------------|
| **API URL** | localhost:8000 | Your domain |
| **Environment** | Debug mode | Release mode |
| **Docker** | Optional | Required |
| **SSL** | HTTP | HTTPS |
| **Logging** | Verbose | Essential only |
| **Assets** | Unoptimized | Minified |
| **Database** | Local file | Docker volume |

---

## 🎓 Next Steps

1. **Configure Environment**: Update `.env.production`
2. **Run Validation**: `.\scripts\validate.ps1`
3. **Deploy**: `.\scripts\deploy.ps1`
4. **Test**: Open http://localhost/app/
5. **Monitor**: Check logs with `docker-compose logs -f`
6. **SSL Setup**: Follow DEPLOYMENT_GUIDE.md for HTTPS
7. **Domain**: Configure your DNS and update nginx.conf

---

## 📚 Additional Resources

- **Full Deployment Guide**: `DEPLOYMENT_GUIDE.md`
- **API Documentation**: `API_DOCUMENTATION.md`
- **Project README**: `COMPLETE_README.md`
- **Quick Start**: `QUICK_START.md`

---

## 🆘 Need Help?

1. Run validation script: `.\scripts\validate.ps1`
2. Check logs: `docker-compose logs`
3. Review DEPLOYMENT_GUIDE.md
4. Check backend health: `curl http://localhost:8000/health`

---

## ✅ Deployment Verification

After deployment, verify these work:

```powershell
# Health check
curl http://localhost/health

# API endpoint
curl http://localhost/api/events

# Open web app
start http://localhost/app/

# View API docs
start http://localhost/docs
```

---

## 🎉 Success!

If all checks pass, your application is:
- ✅ **Running** in production mode
- ✅ **Accessible** via web browser
- ✅ **API** ready for mobile app
- ✅ **Logged** for monitoring
- ✅ **Secured** with rate limiting
- ✅ **Optimized** for performance

**You're ready for production! 🚀**

---

## 📝 Important Notes

1. **Data Persistence**: Database is stored in Docker volume `backend_data`
2. **Logs**: Available via `docker-compose logs`
3. **Backups**: Set up automated database backups (see DEPLOYMENT_GUIDE.md)
4. **Updates**: Simply run `.\scripts\deploy.ps1` again
5. **Rollback**: Keep database backups before major updates

---

**For detailed instructions, troubleshooting, and advanced configuration, see `DEPLOYMENT_GUIDE.md`**
