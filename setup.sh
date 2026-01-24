#!/bin/bash

# Proof of Culture - Quick Start Script

echo "🚀 Proof of Culture - Quick Start Setup"
echo "========================================"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Python
echo -e "${YELLOW}Checking Python...${NC}"
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found. Please install Python 3.10+"
    exit 1
fi
echo -e "${GREEN}✅ Python found$(python3 --version)${NC}"

# Check Flutter
echo -e "${YELLOW}Checking Flutter...${NC}"
if ! command -v flutter &> /dev/null; then
    echo "⚠️  Flutter not found. Install from https://flutter.dev/docs/get-started/install"
else
    echo -e "${GREEN}✅ Flutter found$(flutter --version)${NC}"
fi

# Setup Backend
echo -e "${YELLOW}\n📦 Setting up Backend...${NC}"
cd backend

# Create virtual environment
if [ ! -d "venv" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install dependencies
echo "Installing dependencies..."
pip install -r requirements.txt

# Create .env file if not exists
if [ ! -f ".env" ]; then
    echo "Creating .env file from template..."
    cp .env.example .env
    echo -e "${YELLOW}⚠️  Update .env with your Monad RPC credentials${NC}"
fi

echo -e "${GREEN}✅ Backend setup complete!${NC}"
echo -e "${GREEN}Start with: python -m uvicorn app.main:app --reload${NC}"

# Setup Frontend
echo -e "${YELLOW}\n📱 Setting up Frontend...${NC}"
cd ../frontend/poc_engine

echo "Getting Flutter dependencies..."
flutter pub get

echo -e "${GREEN}✅ Frontend setup complete!${NC}"
echo -e "${GREEN}Start with: flutter run${NC}"

# Summary
echo -e "\n${GREEN}🎉 Setup Complete!${NC}"
echo "========================================"
echo -e "${YELLOW}To start development:${NC}"
echo ""
echo "1. Backend (Terminal 1):"
echo "   cd backend"
echo "   source venv/bin/activate"
echo "   python -m uvicorn app.main:app --reload"
echo ""
echo "2. Frontend (Terminal 2):"
echo "   cd frontend/poc_engine"
echo "   flutter run"
echo ""
echo "3. Visit API Docs:"
echo "   http://localhost:8000/docs"
echo ""
echo -e "${GREEN}Happy hacking! 🚀${NC}"
