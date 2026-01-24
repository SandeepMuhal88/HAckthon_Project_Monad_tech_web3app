# 🚀 Production Deployment Guide

This guide will help you deploy the Proof of Culture application to production.

## 📋 Pre-Deployment Checklist

Before deploying, ensure you have:

- [ ] **Docker Desktop** installed and running
- [ ] **Flutter SDK** installed (version 3.0.0+)
- [ ] **Production environment variables** configured
- [ ] **Monad testnet wallet** with private key
- [ ] **Smart contract addresses** deployed on Monad
- [ ] **(Optional) Domain name** configured with DNS

## 🔧 Configuration Steps

### 1. Update Environment Variables

Edit `.env.production` with your production values:

```bash
# Critical: Update these values!
MONAD_RPC_URL=https://testnet-rpc.monad.xyz/
VERIFIER_PRIVATE_KEY=your_actual_private_key_here
VERIFIER_ADDRESS=0xYourActualAddress
CULTURE_PROOF_ADDRESS=0xYourContractAddress

# Update with your domain (or use IP)
API_URL=https://api.yourdomain.com
DOMAIN=yourdomain.com
```

⚠️ **SECURITY WARNING**: Never commit `.env.production` to version control!

### 2. Update Backend Configuration

The backend is already configured to read from environment variables. No code changes needed!

### 3. Update Frontend API Configuration

The frontend will automatically use the API_URL from `.env.production` during deployment.

## 🐳 Deployment Methods

### Method 1: Automated Deployment (Recommended)

#### On Windows (PowerShell):

```powershell
# Run the deployment script
.\scripts\deploy.ps1
```

This script will:
1. ✅ Load environment variables
2. ✅ Update Flutter API configuration
3. ✅ Build Flutter web application
4. ✅ (Optional) Build Android APK
5. ✅ Build Docker images
6. ✅ Start all services
7. ✅ Perform health checks

#### On Linux/Mac (Bash):

```bash
# Make script executable
chmod +x scripts/deploy.sh

# Run deployment
./scripts/deploy.sh
```

### Method 2: Manual Deployment

#### Step 1: Build Flutter Web

```powershell
cd frontend\poc_engine

# Update API URL in lib\core\api_config.dart
# Change _productionBaseUrl to your production API URL

flutter clean
flutter pub get
flutter build web --release

cd ..\..
```

#### Step 2: Build and Start Docker Services

```powershell
# Build backend image
docker build -t poc_backend:latest .\backend

# Start all services
docker-compose --env-file .env.production up -d
```

#### Step 3: Verify Deployment

```powershell
# Check backend health
curl http://localhost:8000/health

# Check Nginx
curl http://localhost/health

# View running containers
docker-compose ps

# View logs
docker-compose logs -f
```

## 📱 Building Mobile Apps

### Android APK

```powershell
cd frontend\poc_engine

# Build release APK
flutter build apk --release

# APK will be at: build\app\outputs\flutter-apk\app-release.apk
```

### iOS App (Mac only)

```bash
cd frontend/poc_engine

# Build iOS
flutter build ios --release
```

## 🌐 Accessing Your Application

After successful deployment:

| Service | URL | Description |
|---------|-----|-------------|
| **Web App** | `http://localhost/app/` | Flutter web application |
| **API** | `http://localhost/api/` | Backend REST API |
| **API Docs** | `http://localhost/docs` | Swagger documentation |
| **Health Check** | `http://localhost/health` | Service health status |

## 🔐 SSL/HTTPS Configuration

### Using Let's Encrypt (Recommended for Production)

1. **Install Certbot**:
```bash
# On Ubuntu/Debian
sudo apt-get install certbot python3-certbot-nginx

# On Windows, download from: https://certbot.eff.org/
```

2. **Obtain SSL Certificates**:
```bash
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
```

3. **Update Nginx Configuration**:

Edit `nginx/nginx.conf` and uncomment the HTTPS server block:

```nginx
server {
    listen 443 ssl http2;
    server_name yourdomain.com;

    ssl_certificate /etc/ssl/certs/fullchain.pem;
    ssl_certificate_key /etc/ssl/private/privkey.pem;
    
    # ... rest of configuration
}
```

4. **Restart Nginx**:
```bash
docker-compose restart nginx
```

## 📊 Monitoring & Maintenance

### View Logs

```powershell
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f nginx

# Last 100 lines
docker-compose logs --tail=100 backend
```

### Service Management

```powershell
# Check service status
docker-compose ps

# Restart a service
docker-compose restart backend

# Stop all services
docker-compose down

# Start services
docker-compose up -d

# Rebuild and restart
docker-compose up -d --build
```

### Database Backup

```powershell
# Backup SQLite database
docker exec poc_backend cp /app/data/proof_of_culture.db /app/data/backup_$(date +%Y%m%d).db

# Copy to host
docker cp poc_backend:/app/data/proof_of_culture.db ./backup/
```

## 🔄 Updating the Application

### Update Backend Code

```powershell
# Pull latest changes
git pull

# Rebuild backend
docker-compose up -d --build backend
```

### Update Frontend

```powershell
# Rebuild Flutter web
cd frontend\poc_engine
flutter build web --release
cd ..\..

# Restart Nginx to serve new files
docker-compose restart nginx
```

## 🐛 Troubleshooting

### Backend Issues

**Problem**: Backend container won't start
```powershell
# Check logs
docker-compose logs backend

# Common issues:
# - Invalid environment variables
# - Database permissions
# - Port already in use
```

**Solution**:
```powershell
# Check port availability
netstat -ano | findstr :8000

# Verify environment variables
docker-compose config

# Restart with fresh state
docker-compose down -v
docker-compose up -d
```

### Frontend Issues

**Problem**: API connection failed
```powershell
# Check if backend is running
curl http://localhost:8000/health

# Verify API URL in browser console
# Check CORS headers in browser network tab
```

**Solution**:
- Verify `API_URL` in `.env.production`
- Check Nginx proxy configuration
- Ensure CORS is properly configured in backend

### Docker Issues

**Problem**: Docker out of space
```powershell
# Clean up
docker system prune -a

# Remove unused volumes
docker volume prune
```

**Problem**: Port conflicts
```powershell
# Find process using port
netstat -ano | findstr :80
netstat -ano | findstr :8000

# Kill process
taskkill /PID <process_id> /F

# Or change port in docker-compose.yml
```

## 📈 Performance Optimization

### Backend Optimization

1. **Use Production WSGI Server**:

Update `backend/Dockerfile` command:
```dockerfile
CMD ["gunicorn", "app.main:app", "-w", "4", "-k", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:8000"]
```

2. **Add Database Connection Pooling**:
Already configured in the backend for optimal performance.

3. **Enable Response Caching**:
Nginx already configured with caching headers.

### Frontend Optimization

1. **Enable PWA** (Optional):
```dart
// Add to pubspec.yaml
flutter_web_plugins:
  sdk: flutter
```

2. **Optimize Assets**:
```powershell
# Already done during flutter build web --release
# - Tree shaking
# - Minification
# - Asset optimization
```

## 🔒 Security Best Practices

1. **Environment Variables**: Never commit `.env.production` to git
2. **Private Keys**: Store in secure vault (Azure Key Vault, AWS Secrets Manager)
3. **HTTPS**: Always use SSL in production
4. **Rate Limiting**: Already configured in Nginx (10 req/s)
5. **CORS**: Restrict origins in production (update nginx.conf)
6. **Security Headers**: Already configured in Nginx

## 📞 Support & Resources

- **Backend API Docs**: `http://localhost/docs`
- **Project README**: `COMPLETE_README.md`
- **API Documentation**: `API_DOCUMENTATION.md`
- **Quick Start**: `QUICK_START.md`

## ✅ Deployment Verification Checklist

After deployment, verify:

- [ ] Backend health check responds: `curl http://localhost/health`
- [ ] API documentation accessible: `http://localhost/docs`
- [ ] Web app loads: `http://localhost/app/`
- [ ] Can fetch events from API
- [ ] QR code generation works
- [ ] Proof verification works
- [ ] Mobile app connects to API (if deployed)
- [ ] Logs show no errors: `docker-compose logs`
- [ ] Database is persisting data
- [ ] SSL certificates valid (if configured)

## 🎉 Success!

Your Proof of Culture application is now deployed and running in production!

For any issues, check:
1. Service logs: `docker-compose logs -f`
2. Health endpoints
3. Environment variables
4. Database connectivity

**Happy Deploying! 🚀**
