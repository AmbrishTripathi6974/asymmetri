#!/bin/bash

# Exit on error
set -e

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Installing Dart SDK...${NC}"
# Dart install (Linux/macOS)
# For latest install instructions: https://dart.dev/get-dart
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  sudo apt update
  sudo apt install apt-transport-https
  sudo sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /usr/share/keyrings/dart.gpg'
  sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/dart.gpg] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main" > /etc/apt/sources.list.d/dart_stable.list'
  sudo apt update
  sudo apt install dart
elif [[ "$OSTYPE" == "darwin"* ]]; then
  brew tap dart-lang/dart
  brew install dart
else
  echo "Unsupported OS for automatic Dart installation."
fi

echo -e "${GREEN}Installing Flutter SDK...${NC}"
# Clone Flutter repo
git clone https://github.com/flutter/flutter.git -b stable

# Add flutter to PATH for current session
export PATH="$PATH:`pwd`/flutter/bin"

# Optionally add permanently
if ! grep -q "flutter/bin" ~/.bashrc; then
  echo 'export PATH="$PATH:'"`pwd`/flutter/bin"'"' >> ~/.bashrc
  echo 'Flutter path added to ~/.bashrc'
fi

echo -e "${GREEN}Running flutter doctor...${NC}"
flutter doctor

echo -e "${GREEN}Getting dependencies...${NC}"
flutter pub get

echo -e "${GREEN}Building Flutter web project...${NC}"
flutter build web

echo -e "${GREEN}✅ Done! Web build is in ./build/web${NC}"
