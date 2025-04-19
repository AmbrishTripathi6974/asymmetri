#!/bin/bash
set -e

# Update this Flutter version to match your SDK constraint
FLUTTER_VERSION="3.22.1"
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

# Avoid running as root if possible (Vercel usually isn’t root anyway)
echo "📦 Running flutter pub get..."
flutter pub get

# Build the Flutter web app
echo "🛠️  Building web..."
flutter build web

echo "✅ Build complete! Output in ./build/web"
