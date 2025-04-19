#!/bin/bash
set -e

# Define Flutter version and location
FLUTTER_VERSION="3.19.6"
FLUTTER_DIR="flutter"

# Download Flutter if not already present
if [ ! -d "$FLUTTER_DIR" ]; then
  echo "⬇️  Downloading Flutter SDK..."
  curl -L "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" -o flutter.tar.xz
  tar xf flutter.tar.xz
  rm flutter.tar.xz
fi

# Add flutter to PATH
export PATH="$PWD/flutter/bin:$PATH"

# Check flutter
echo "🚀 Flutter version:"
flutter --version

# Get dependencies
git config --global --add safe.directory "$(pwd)/flutter"
echo "📦 Running flutter pub get..."
flutter pub get

# Build Flutter web app
echo "🛠️  Building web..."
flutter build web

echo "✅ Build complete! Output in ./build/web"
