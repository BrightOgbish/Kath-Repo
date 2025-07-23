#!/bin/bash

# === CONFIGURATION ===
STORAGE_ACCOUNT="engrbright"
CONTAINER_NAME="azuredemoengrbright1"
SAS_TOKEN="<your-SAS-token>"  # Include leading '?' if needed
FILE_NAME="testfile_512MB.bin"
FILE_SIZE_MB=512

# === FILE GENERATION ===
if [ ! -f "$FILE_NAME" ]; then
  echo "Generating $FILE_NAME..."
  dd if=/dev/zero of="$FILE_NAME" bs=1M count=$FILE_SIZE_MB
fi

BLOB_URL="https://${STORAGE_ACCOUNT}.blob.core.windows.net/${CONTAINER_NAME}/${FILE_NAME}${SAS_TOKEN}"

# === UPLOAD TEST ===
echo "Starting upload test..."
START_UPLOAD=$(date +%s)
azcopy copy "$FILE_NAME" "$BLOB_URL" --overwrite=true
END_UPLOAD=$(date +%s)
UPLOAD_TIME=$((END_UPLOAD - START_UPLOAD))
UPLOAD_MBPS=$(awk "BEGIN {print $FILE_SIZE_MB / $UPLOAD_TIME}")
echo "Upload: $UPLOAD_TIME seconds (~$UPLOAD_MBPS MBps)"

# === DOWNLOAD TEST ===
echo "Starting download test..."
START_DOWNLOAD=$(date +%s)
azcopy copy "$BLOB_URL" "./downloaded_$FILE_NAME" --overwrite=true
END_DOWNLOAD=$(date +%s)
DOWNLOAD_TIME=$((END_DOWNLOAD - START_DOWNLOAD))
DOWNLOAD_MBPS=$(awk "BEGIN {print $FILE_SIZE_MB / $DOWNLOAD_TIME}")
echo "Download: $DOWNLOAD_TIME seconds (~$DOWNLOAD_MBPS MBps)"

# === CLEANUP ===
rm "./downloaded_$FILE_NAME"

echo "Performance test complete."
