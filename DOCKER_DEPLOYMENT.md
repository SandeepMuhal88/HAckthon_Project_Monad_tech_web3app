# 🐳 Docker Deployment Guide

## Quick Start (2 Minutes)

### Prerequisites
- **Docker Desktop** installed and running
  - Download: https://www.docker.com/products/docker-desktop
  - Windows, Mac, or Linux supported

### One-Command Deployment

#### Option 1: PowerShell (Recommended)
```powershell
.\scripts\deploy-docker.ps1
```

#### Option 2: Batch File
```cmd
scripts\deploy-docker.bat
```

#### Option 3: Manual Docker Compose
```bash
docker-compose up --build -d
```

---

## 🌐 Access Your Application

Once deployed, you'll have access to:

| Service | URL | Description |
|---------|-----|-------------|
| **Frontend** | http://localhost:3000 | Flutter Web App |
| **Backend API** | http://localhost:8000 | FastAPI Server |
| **API Docs** | http://localhost:8000/docs | Interactive API Documentation |
| **Health Check** | http://localhost:8000/health | Backend Health Status |

---

## 📁 What Gets Deployed

### 1. Backend Service (`poc_backend`)
- **Technology**: Python 3.11 + FastAPI
- **Port**: 8000
- **Database**: SQLite (persistent volume)
- **Features**:
  - RESTful API endpoints
  - QR code generation
  - Event management
  - Health monitoring

### 2. Frontend Service (`poc_frontend`)
- **Technology**: Flutter Web
- **Port**: 3000
- **Features**:
  - Responsive web interface
  - QR code scanner
  - Event browsing
  - User dashboard

### 3. Nginx (Optional - Production Mode)
- **Port**: 80, 443
- **Features**:
  - Reverse proxy
  - Load balancing
  - SSL/TLS support
  - Static file serving

---

## 🔧 Configuration

### Environment Variables

Create a `.env` file in the project root:

```env
# Blockchain Configuration
MONAD_RPC_URL=https://testnet-rpc.monad.xyz/
CHAIN_ID=1
VERIFIER_PRIVATE_KEY=your_private_key_here
VERIFIER_ADDRESS=your_address_here
CULTURE_PROOF_ADDRESS=0x0000000000000000000000000000000000000000

# QR Configuration
QR_EXPIRY_SECONDS=300
```

**Note**: For development, defaults are used if `.env` is not present.

---

## 📊 Managing Your Deployment

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
```

### Check Status
```bash
docker-compose ps
```

### Stop Services
```bash
docker-compose down
```

### Stop and Remove Data
```bash
docker-compose down -v
```

### Restart Services
```bash
docker-compose restart
```

### Rebuild After Code Changes
```bash
docker-compose up --build -d
```

---

## 🐛 Troubleshooting

### Issue: Docker is not running

**Solution**:
1. Start Docker Desktop
2. Wait for Docker to fully initialize
3. Run the deployment script again

### Issue: Port already in use

**Error**: `bind: address already in use`

**Solution**:
```bash
# Find process using port 8000
netstat -ano | findstr :8000
netstat -ano | findstr :3000

# Kill the process (replace PID)
taskkill /F /PID <PID>
```

Or change ports in `docker-compose.yml`:
```yaml
ports:
  - "8001:8000"  # Change 8000 to 8001
```

### Issue: Build fails for Flutter

**Symptoms**: Frontend container fails to build

**Solution**:
```bash
# Rebuild with no cache
docker-compose build --no-cache frontend

# Or increase Docker memory (Docker Desktop Settings)
# Recommend: 4GB RAM minimum
```

### Issue: Backend database errors

**Solution**:
```bash
# Remove and recreate volume
docker-compose down -v
docker-compose up -d
```

### Issue: Cannot connect to backend from frontend

**Solution**:
Ensure both services are on the same Docker network:
```bash
docker network inspect lnm_hacks_80_hackethon_poc_network
```

---

## 🔄 Development Workflow

### For Backend Changes

1. Edit code in `backend/` directory
2. Rebuild and restart:
   ```bash
   docker-compose up --build -d backend
   ```
3. View logs:
   ```bash
   docker-compose logs -f backend
   ```

### For Frontend Changes

1. Edit code in `frontend/poc_engine/` directory
2. Rebuild and restart:
   ```bash
   docker-compose up --build -d frontend
   ```
3. Clear browser cache and refresh

### For Quick Testing (Without Docker)

Backend:
```bash
cd backend
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

Frontend:
```bash
cd frontend/poc_engine
flutter run -d chrome
```

---

## 🚀 Production Deployment

### With Nginx Reverse Proxy

Enable the nginx service:
```bash
docker-compose --profile production up -d
```

This will:
- Run backend on port 8000 (internal)
- Run frontend on port 3000 (internal)
- Expose nginx on ports 80 and 443
- Handle SSL/TLS termination

### SSL/TLS Configuration

1. Obtain SSL certificates (Let's Encrypt recommended)
2. Place certificates in `nginx/ssl/`:
   - `fullchain.pem`
   - `privkey.pem`
3. Uncomment HTTPS section in `nginx/nginx.conf`
4. Restart nginx:
   ```bash
   docker-compose restart nginx
   ```

### Environment Variables for Production

Create a `.env.production` file:
```env
MONAD_RPC_URL=https://mainnet-rpc.monad.xyz/
CHAIN_ID=1
VERIFIER_PRIVATE_KEY=<secure_key>
VERIFIER_ADDRESS=<your_address>
CULTURE_PROOF_ADDRESS=<deployed_contract_address>
```

Deploy with production config:
```bash
docker-compose --env-file .env.production up -d
```

---

## 📦 Docker Architecture

```
┌─────────────────────────────────────────┐
│           Docker Network                │
│         (poc_network)                   │
│                                         │
│  ┌──────────────┐   ┌───────────────┐  │
│  │   Backend    │   │   Frontend    │  │
│  │   (FastAPI)  │   │   (Flutter)   │  │
│  │   Port 8000  │   │   Port 3000   │  │
│  └──────────────┘   └───────────────┘  │
│         │                    │          │
│         └────────┬───────────┘          │
│                  │                      │
│         ┌────────┴──────────┐           │
│         │      Nginx        │           │
│         │   (Production)    │           │
│         │   Port 80, 443    │           │
│         └───────────────────┘           │
└─────────────────────────────────────────┘
                   │
                   ▼
              Internet
```

---

## 🔒 Security Best Practices

### 1. Environment Variables
- Never commit `.env` files
- Use different keys for dev/prod
- Rotate keys regularly

### 2. Docker Security
- Run containers as non-root (already configured)
- Keep images updated
- Use specific version tags

### 3. API Security
- Enable rate limiting (configured in nginx)
- Use HTTPS in production
- Validate all inputs

### 4. Database
- Regular backups of `backend_data` volume
- Encrypt sensitive data
- Use proper access controls

---

## 📈 Performance Optimization

### Docker Resource Limits

Add to `docker-compose.yml`:
```yaml
services:
  backend:
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 512M
```

### Build Optimization

Use BuildKit for faster builds:
```bash
DOCKER_BUILDKIT=1 docker-compose build
```

### Image Size Reduction

Both Dockerfiles use multi-stage builds to minimize size:
- Backend: ~150MB (Python slim)
- Frontend: ~50MB (Nginx alpine + Flutter web)

---

## 📋 Deployment Checklist

### Before First Deployment
- [ ] Docker Desktop installed and running
- [ ] Project code cloned/downloaded
- [ ] `.env` file created (optional)
- [ ] Ports 3000 and 8000 available

### For Production
- [ ] SSL certificates obtained
- [ ] Production environment variables set
- [ ] Domain name configured
- [ ] Firewall rules configured
- [ ] Monitoring setup
- [ ] Backup strategy in place

### After Deployment
- [ ] Frontend accessible at http://localhost:3000
- [ ] Backend accessible at http://localhost:8000
- [ ] API docs accessible at http://localhost:8000/docs
- [ ] Health check passes: http://localhost:8000/health
- [ ] Logs show no errors
- [ ] Database persists after restart

---

## 🆘 Getting Help

### View Service Logs
```bash
docker-compose logs -f [service_name]
```

### Inspect Service
```bash
docker inspect poc_backend
docker inspect poc_frontend
```

### Enter Container Shell
```bash
docker exec -it poc_backend /bin/bash
docker exec -it poc_frontend /bin/sh
```

### Check Network
```bash
docker network ls
docker network inspect lnm_hacks_80_hackethon_poc_network
```

---

## 🎯 Quick Reference

### Start Everything
```bash
docker-compose up -d
```

### Stop Everything
```bash
docker-compose down
```

### View Logs
```bash
docker-compose logs -f
```

### Rebuild and Restart
```bash
docker-compose up --build -d
```

### Clean Everything
```bash
docker-compose down -v
docker system prune -a
```

---

## ✅ Success Indicators

Your deployment is successful when:

1. ✅ `docker-compose ps` shows all services as "Up"
2. ✅ http://localhost:3000 loads the Flutter app
3. ✅ http://localhost:8000/docs shows API documentation
4. ✅ http://localhost:8000/health returns `{"status":"healthy"}`
5. ✅ No errors in `docker-compose logs`

---

## 🚀 What's Next?

After successful deployment:

1. **Test the API**: Visit http://localhost:8000/docs
2. **Explore the Frontend**: Open http://localhost:3000
3. **Monitor Logs**: Run `docker-compose logs -f`
4. **Configure Environment**: Update `.env` as needed
5. **Deploy to Production**: Follow production deployment steps

---

## 📞 Support

- **Documentation**: See `LOCAL_DEPLOYMENT.md` for non-Docker deployment
- **API Reference**: Check `API_DOCUMENTATION.md`
- **Project Overview**: Read `COMPLETE_README.md`
- **GitHub Issues**: Report bugs and request features

---

**Ready to deploy! Run `.\scripts\deploy-docker.ps1` and you're live in minutes! 🚀**
