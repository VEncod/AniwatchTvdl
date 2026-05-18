FROM python:3.11-slim

# ─── Install FFmpeg and system dependencies ───
RUN apt-get update && apt-get install -y \
    ffmpeg \
    git \
    wget \
    libicu-dev \
    && rm -rf /var/lib/apt/lists/*

# ─── Verify FFmpeg is installed ───
RUN ffmpeg -version | head -1

# ─── Install N_m3u8DL-RE (the download engine) ───
RUN wget -q https://github.com/nilaoda/N_m3u8DL-RE/releases/download/v0.2.1-beta/N_m3u8DL-RE_Beta_linux-x64_20240828.tar.gz && \
    tar -xzf N_m3u8DL-RE_Beta_linux-x64_20240828.tar.gz && \
    mv N_m3u8DL-RE_Beta_linux-x64/N_m3u8DL-RE /usr/local/bin/ && \
    chmod +x /usr/local/bin/N_m3u8DL-RE && \
    rm -rf N_m3u8DL-RE_Beta_linux-x64*

# ─── Verify N_m3u8DL-RE is installed ───
RUN N_m3u8DL-RE --version || echo "N_m3u8DL-RE installed at /usr/local/bin/"

WORKDIR /app
COPY . /app

# ─── Ensure binary/N_m3u8DL-RE is executable (used as fallback path by the bot) ───
RUN chmod +x binary/N_m3u8DL-RE 2>/dev/null || true

# ─── Install Python dependencies ───
RUN pip install --no-cache-dir -r requirements.txt

# ─── Print confirmation of engines ───
RUN echo "=== Bot Engines ===" && \
    echo "FFmpeg: $(which ffmpeg)" && \
    echo "N_m3u8DL-RE: $(which N_m3u8DL-RE || echo 'binary/N_m3u8DL-RE')" && \
    echo "==================="

CMD ["python3", "-m", "cantarella"]
