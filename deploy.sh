#!/bin/bash

# 🚀 Phone Text Field Demo Deployment Script
# This script helps you test the deployment locally before pushing to GitHub

set -e  # Exit on error

echo "📱 Phone Text Field Demo - Local Deployment Test"
echo "================================================="

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Please run this script from the root of the phone_text_field repository"
    exit 1
fi

# Navigate to example directory
cd example

echo "📦 Installing dependencies..."
flutter pub get

echo "🔍 Running code analysis..."
flutter analyze

echo "🧪 Running tests..."
flutter test

echo "🏗️  Building web application..."
flutter build web --release --base-href="/phone_text_field/"

echo "✅ Build completed successfully!"
echo ""
echo "🌐 To test locally, you can serve the built files:"
echo "   cd example/build/web"
echo "   python3 -m http.server 8000"
echo "   # Then open: http://localhost:8000"
echo ""
echo "🚀 To deploy to GitHub Pages:"
echo "   1. Commit and push your changes to the main branch"
echo "   2. GitHub Actions will automatically deploy to:"
echo "      https://mohamedabd0.github.io/phone_text_field/"
echo ""
echo "📋 Make sure GitHub Pages is configured to use GitHub Actions in your repository settings!"
