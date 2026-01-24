#!/bin/bash

# Production Deployment Script
# This script builds and deploys the Proof of Culture application

set -e  # Exit on error

echo "🚀 Starting Production Deployment..."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored output
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if .env.production exists
if [ ! -f .env.production ]; then
    log_error ".env.production file not found!"
    log_info "Please create .env.production with your production configuration"
    exit 1
fi

# Load environment variables
log_info "Loading environment variables..."
export $(cat .env.production | grep -v '^#' | xargs)
log_success "Environment variables loaded"

# Step 1: Build Flutter Web App
log_info "Building Flutter web application..."
cd frontend/poc_engine

# Update API URL in api_service.dart
log_info "Updating API URL to production..."
API_SERVICE_FILE="lib/services/api_service.dart"
if [ ! -z "$API_URL" ]; then
    sed -i.bak "s|http://localhost:8000/api|$API_URL|g" $API_SERVICE_FILE
    log_success "API URL updated to: $API_URL"
else
    log_error "API_URL not set in .env.production"
    exit 1
fi

# Build Flutter web
flutter clean
flutter pub get
flutter build web --release

log_success "Flutter web build completed"
cd ../..

# Step 2: Build Backend Docker Image
log_info "Building backend Docker image..."
docker build -t poc_backend:latest ./backend
log_success "Backend image built"

# Step 3: Stop existing containers
log_info "Stopping existing containers..."
docker-compose down || true
log_success "Existing containers stopped"

# Step 4: Start services
log_info "Starting production services..."
docker-compose --env-file .env.production up -d

# Wait for services to be healthy
log_info "Waiting for services to be healthy..."
sleep 10

# Step 5: Check service health
log_info "Checking backend health..."
if curl -f http://localhost:8000/health > /dev/null 2>&1; then
    log_success "Backend is healthy"
else
    log_error "Backend health check failed"
    docker-compose logs backend
    exit 1
fi

log_info "Checking Nginx..."
if curl -f http://localhost/health > /dev/null 2>&1; then
    log_success "Nginx is healthy"
else
    log_error "Nginx health check failed"
    docker-compose logs nginx
    exit 1
fi

# Step 6: Display deployment info
echo ""
log_success "🎉 Deployment successful!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Service URLs:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 Frontend App:    http://localhost/app/"
echo "🔧 API Endpoint:    http://localhost/api/"
echo "📚 API Docs:        http://localhost/docs"
echo "❤️  Health Check:   http://localhost/health"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 Useful Commands:"
echo "  View logs:        docker-compose logs -f"
echo "  Stop services:    docker-compose down"
echo "  Restart:          docker-compose restart"
echo "  View status:      docker-compose ps"
echo ""
log_success "All systems operational! 🚀"
