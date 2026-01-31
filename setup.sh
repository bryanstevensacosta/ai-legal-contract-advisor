#!/bin/bash
# LexConductor - Development Environment Setup
# IBM Dev Day AI Demystified Hackathon 2026
# Team: AI Kings 👑

set -e  # Exit on error

echo "🚀 LexConductor - Setting up development environment..."
echo ""

# Check Python version
echo "📋 Checking Python version..."
python_version=$(python3 --version 2>&1 | awk '{print $2}')
echo "   Found Python $python_version"

if ! python3 -c 'import sys; exit(0 if sys.version_info >= (3, 11) else 1)' 2>/dev/null; then
    echo "❌ Error: Python 3.11+ required"
    exit 1
fi

# Create virtual environment
echo ""
echo "📦 Creating virtual environment..."
if [ -d ".venv" ]; then
    echo "   .venv already exists, skipping creation"
else
    python3 -m venv .venv
    echo "   ✅ Virtual environment created"
fi

# Activate virtual environment
echo ""
echo "🔌 Activating virtual environment..."
source .venv/bin/activate

# Upgrade pip
echo ""
echo "⬆️  Upgrading pip..."
pip install --upgrade pip --quiet

# Install dependencies
echo ""
echo "📥 Installing dependencies from requirements.txt..."
pip install -r requirements.txt --quiet
echo "   ✅ All dependencies installed"

# Setup pre-commit hooks
echo ""
echo "🪝 Setting up pre-commit hooks..."
pre-commit install
echo "   ✅ Pre-commit hooks installed"

# Create .env from template if it doesn't exist
echo ""
if [ ! -f ".env" ]; then
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    echo "   ✅ .env created - REMEMBER TO ADD YOUR API KEYS!"
    echo "   ⚠️  Edit .env and add your IBM Cloud credentials"
else
    echo "📝 .env file already exists"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "📌 Next steps:"
echo "   1. Activate the virtual environment:"
echo "      source .venv/bin/activate"
echo ""
echo "   2. Edit .env and add your IBM Cloud credentials"
echo ""
echo "   3. Start development!"
echo ""
echo "🎯 Hackathon Deadline: February 1, 2026 - 10:00 AM ET"
echo ""
