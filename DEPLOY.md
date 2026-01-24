# 🚀 Deployment Quick Start

Choose your deployment method:

## 🐳 Option 1: Docker Deployment (Recommended)

**Best for**: Production, easy setup, consistent environment

### Requirements
- Docker Desktop installed

### Deploy in 30 seconds
```bash
.\scripts\deploy-docker.ps1
```

**Full Guide**: See [DOCKER_DEPLOYMENT.md](DOCKER_DEPLOYMENT.md)

**Services**:
- Frontend: http://localhost:3000
- Backend: http://localhost:8000
- API Docs: http://localhost:8000/docs

---

## 💻 Option 2: Local Deployment

**Best for**: Development, testing, no Docker

### Requirements
- Python 3.10+
- Flutter SDK (optional, for frontend)

### Deploy Backend
```bash
.\scripts\start-backend.bat
```

### Deploy Frontend
```bash
.\scripts\build-flutter.bat
```

**Full Guide**: See [LOCAL_DEPLOYMENT.md](LOCAL_DEPLOYMENT.md)

---

## 📊 Comparison

| Feature | Docker | Local |
|---------|--------|-------|
| **Setup Time** | 2 minutes | 5 minutes |
| **Requirements** | Docker Desktop | Python + Flutter |
| **Production Ready** | ✅ Yes | ⚠️ Dev only |
| **Easy Updates** | ✅ One command | ⚠️ Manual |
| **Isolation** | ✅ Containerized | ❌ Local system |
| **Resource Usage** | Higher | Lower |

---

## 🎯 Quick Decision Guide

**Choose Docker if**:
- You want the easiest setup
- You're deploying to production
- You want isolation from your system
- You have Docker installed

**Choose Local if**:
- You're actively developing
- You don't have Docker
- You want faster reload times
- You want to conserve resources

---

## 📚 Additional Documentation

- `DOCKER_DEPLOYMENT.md` - Complete Docker guide
- `LOCAL_DEPLOYMENT.md` - Complete local guide  
- `API_DOCUMENTATION.md` - API reference
- `COMPLETE_README.md` - Project overview

---

**Need help?** Check the deployment guides above for detailed instructions!
