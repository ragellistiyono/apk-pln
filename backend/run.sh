#!/bin/bash

# Quick start script for PLN Ticket API

echo "🚀 Starting PLN Ticket API Setup..."

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo "📥 Installing dependencies..."
pip install -r requirements.txt

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "⚙️  Creating .env file from template..."
    cp .env.example .env
    echo "⚠️  Please update .env with your database credentials!"
fi

# Initialize database
echo "🗄️  Initializing database..."
python -c "from src.database import init_db; init_db()"

# Seed data
echo "🌱 Seeding initial data..."
python scripts/seed_data.py

# Start server
echo "✅ Starting FastAPI server..."
echo "📍 API will be available at: http://localhost:8000"
echo "📚 API Docs: http://localhost:8000/docs"
echo ""
uvicorn src.main:app --reload --host 0.0.0.0 --port 8000