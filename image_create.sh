#!/bin/bash
# stupid script made by appleflyer
set -e

IMG_NAME="icarus_ba.img"
MOUNT_DIR="mnt_point"
SIZE_MB=100

truncate -s ${SIZE_MB}M "$IMG_NAME"
mkfs.ext4 "$IMG_NAME"
mkdir -p "$MOUNT_DIR"
sudo mount -o loop "$IMG_NAME" "$MOUNT_DIR"

sudo cp -r PKIMetadata/ icarus_ba_mmc.sh icarus_ba_nvme.sh "$MOUNT_DIR"/
sync
sudo umount "$MOUNT_DIR"
rmdir "$MOUNT_DIR"

USED_BLOCKS=$(dumpe2fs -h "$IMG_NAME" | awk '/Block count:/ {print $3}')
BLOCK_SIZE=$(dumpe2fs -h "$IMG_NAME" | awk '/Block size:/ {print $3}')
NEW_SIZE=$((USED_BLOCKS * BLOCK_SIZE))
truncate -s "$NEW_SIZE" "$IMG_NAME"
e2fsck -f "$IMG_NAME"
resize2fs -M "$IMG_NAME"

echo "created and shrunk ext4 image: $IMG_NAME"
