#!/bin/bash
set -e

# Make sure this version matches Dart 3.6.2 or higher
FLUTTER_VERSION="3.22.1"
FLUTTER_DIR="flutter"

echo "📁 Current directory: $(pwd)"

if [ ! -d "$FLUTTER_DIR" ]; then
  echo "⬇️  Downloading Flutter $FLUTTER_VERSION..."
  curl -L "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" -o flutter.tar.xz
  tar xf flutter.tar.xz
  rm flutter.tar.xz
fi

chmod -R +x flutter/bin
export PATH="$PWD/flutter/bin:$PATH"

git config --global --add safe.directory "$PWD/flutter"

echo "🚀 Flutter version:"
flutter --version

echo "📦 Running flutter pub get..."
flutter pub get

echo "🛠️  Building web..."
flutter build web

echo "✅ Build complete! Output in ./build/web"
