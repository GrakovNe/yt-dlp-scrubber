#!/bin/bash

CHANNELS_FILE="/opt/ytaudio/channels.txt"
OUTPUT_DIR="/mnt/external/podcasts"
LOG_FILE="/opt/ytaudio/yt-dlp.log"
ARCHIVE_FILE="/opt/ytaudio/archive.txt"

COOKIES_YT="/opt/ytaudio/youtube_cookies.txt"
COOKIES_VK="/opt/ytaudio/vk_cookies.txt"

mkdir -p "$OUTPUT_DIR"

while read -r CHANNEL DAYS; do
    [ -z "$CHANNEL" ] && continue
    [ -z "$DAYS" ] && DAYS=-1

    if [[ "$CHANNEL" == *"vk.com"* || "$CHANNEL" == *"vkvideo.ru"* ]]; then
        COOKIES="$COOKIES_VK"
    else
        COOKIES="$COOKIES_YT"
    fi

    if [[ "$DAYS" -ge 0 ]]; then
        DATEAFTER="--dateafter now-${DAYS}days"
    else
        DATEAFTER=""
    fi

    yt-dlp \
      --yes-playlist \
      --extract-audio \
      --cookies "$COOKIES" \
      --audio-format mp3 \
      --audio-quality 0 \
      $DATEAFTER \
      --lazy-playlist \
      --download-archive "$ARCHIVE_FILE" \
      --output "$OUTPUT_DIR/%(uploader)s/%(upload_date>%Y-%m-%d)s - %(title)s.%(ext)s" \
      "$CHANNEL" >> "$LOG_FILE" 2>&1

done < "$CHANNELS_FILE"
