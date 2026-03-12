#!/bin/bash
set -e

cd "$(dirname "$0")"

NAME=$(node -p "require('./package.json').name")
VERSION=$(node -p "require('./package.json').version")
OUTPUT="releases/${NAME}-v${VERSION}.zip"

npm install --silent
npx grunt

rm -f "$OUTPUT"
zip -r "$OUTPUT" dist/ images/ libs/ manifest.json offscreen.html popup.html

echo ""
echo "Build complete: $OUTPUT"
