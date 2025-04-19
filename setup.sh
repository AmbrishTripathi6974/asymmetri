#!/bin/bash
set -e

FLUTTER_VERSION="3.19.6"
FLUTTER_DIR="flutter"

echo "📁 Current directory: $(pwd)"

# Download Flutter SDK
if [ ! -d "$FLUTTER_DIR" ]; then
  echo "⬇️  Downloading Flutter SDK..."
  curl -L "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" -o flutter.tar.xz
  tar xf flutter.tar.xz
  rm flutter.tar.xz
fi

# Make Flutter executable
chmod -R +x flutter/bin

# Add Flutter to PATH
export PATH="$PWD/flutter/bin:$PATH"

# Configure Git safe directory
git config --global --add safe.directory "$PWD/flutter"

# Verify Flutter works
echo "🚀 Flutter version:"
flutter --version

# Get dependencies
echo "📦 Running flutter pub get..."
flutter pub get

# Build the Flutter web app
echo "🛠️  Building web..."
flutter build web

echo "✅ Build complete! Output in ./build/web"
