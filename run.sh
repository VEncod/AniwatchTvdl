#!/bin/bash

# Ensure binary/N_m3u8DL-RE is executable
chmod +x binary/N_m3u8DL-RE 2>/dev/null || true

# Verify engines are available
echo "=== Checking Bot Engines ==="
if command -v ffmpeg &>/dev/null; then
    echo "✅ FFmpeg: $(which ffmpeg)"
else
    echo "❌ FFmpeg NOT FOUND - merging will fail!"
fi

if command -v N_m3u8DL-RE &>/dev/null; then
    echo "✅ N_m3u8DL-RE: $(which N_m3u8DL-RE)"
elif [ -x "binary/N_m3u8DL-RE" ]; then
    echo "✅ N_m3u8DL-RE: binary/N_m3u8DL-RE (local)"
else
    echo "❌ N_m3u8DL-RE NOT FOUND - downloading will fail!"
fi
echo "==========================="

python3 -m cantarella
