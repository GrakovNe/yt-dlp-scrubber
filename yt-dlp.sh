#!/bin/bash

CHANNELS_FILE="/opt/ytaudio/channels.txt"
OUTPUT_DIR="/mnt/external/podcasts"
LOG_FILE="/opt/ytaudio/yt-dlp.log"
ARCHIVE_FILE="/opt/ytaudio/archive.txt"

mkdir -p "$OUTPUT_DIR"

while read -r CHANNEL; do
    [ -z "$CHANNEL" ] && continue
    yt-dlp \
      --extract-audio \
      --audio-format mp3 \
      --audio-quality 0 \
      --dateafter now-180days \
      --break-on-reject \
      --lazy-playlist \
      --download-archive "$ARCHIVE_FILE" \
      --output "$OUTPUT_DIR/%(uploader)s/%(upload_date>%Y-%m-%d)s - %(title)s.%(ext)s" \
      "$CHANNEL" >> "$LOG_FILE" 2>&1
done < "$CHANNELS_FILE"

