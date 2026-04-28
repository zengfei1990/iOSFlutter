#!/bin/zsh
set -euo pipefail

ROOT_DIR="/Users/zf/Desktop/iOSFlutter"
MODULE_DIR="$ROOT_DIR/flutter_learning_demo"

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter SDK not found. Please install Flutter and make sure 'flutter' is on PATH."
  exit 1
fi

cd "$MODULE_DIR"

if [ ! -d ".ios" ]; then
  flutter create --template module .
fi

flutter pub get

cd "$ROOT_DIR"
pod install

echo "Flutter module setup finished."
