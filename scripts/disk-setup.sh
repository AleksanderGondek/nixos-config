#!/usr/bin/env sh

set -euo pipefail

oops() {
  echo "$0:" "$@" >&2
  exit 1
}

require_util() {
  command -v "$1" > /dev/null 2>&1 ||
    oops "$1 was not found"
}

readonly DISK_ID=${1:-''}
readonly DISK="/dev/disk/by-id/${DISK_ID}"
if [ -z "${DISK_ID}" ]; then
  oops "You have to provide target disk id (/dev/disk/by-id/<id>) as first parameter"
fi

# This are percentages (avoids issues with parted)
readonly SWAP_PART_SIZE='3'
readonly CONTAINER_PART_SIZE='30'

preflightCheck() {
  if [ ! -e "${DISK}" ]; then
    oops "Disk ${DISK} does not exist"
  fi

  require_util parted
  require_util mkswap
  require_util mkfs
  require_util zpool
  require_util zfs
}

partitionDisk() {
  parted --script "${DISK}" -- mklabel gpt
  parted --script "${DISK}" -- mkpart primary 512MiB -"$(($CONTAINER_PART_SIZE + $SWAP_PART_SIZE)).0%"
  parted --script "${DISK}" -- mkpart primary -"$(($CONTAINER_PART_SIZE + $SWAP_PART_SIZE)).0%" -"${SWAP_PART_SIZE}.0%"
  parted --script "${DISK}" -- mkpart primary linux-swap -"${SWAP_PART_SIZE}.0%" 100%
  parted --script "${DISK}" -- mkpart ESP fat32 1MiB 512MiB
  parted --script "${DISK}" -- set 4 esp on

  mkfs.ext4 -F "${DISK}-part2"
  mkswap -L swap "${DISK}-part3"
  mkfs.fat -F 32 -n EFI "${DISK}-part4"
}

setupZfsPool() {
  zpool create \
    -o ashift=12 \
    -o autotrim=on \
    -R /mnt \
    -O canmount=off \
    -O mountpoint=none \
    -O acltype=posixacl \
    -O compression=lz4 \
    -O dnodesize=auto \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    -O encryption=aes-256-gcm \
    -O keylocation=prompt \
    -O keyformat=passphrase \
    rpool \
    "${DISK}-part1"
}

setupZfsDatasets() {
  # Make sure there is enough space for operations
  zfs create -o refreservation=1G -o mountpoint=none rpool/reserved
  # OS datasets
  zfs create -o canmount=off -o mountpoint=/ rpool/nixos
  zfs create -o canmount=on rpool/nixos/nix
  zfs create -o canmount=on rpool/nixos/etc
  zfs create -o canmount=on rpool/nixos/var
  zfs create -o canmount=on rpool/nixos/var/lib
  zfs create -o canmount=on rpool/nixos/var/log
  # User datasets
  zfs create -o canmount=off -o mountpoint=/ rpool/userdata
  zfs create -o canmount=on rpool/userdata/home
  zfs create -o canmount=on -o mountpoint=/root rpool/userdata/home/root
}

setupZfsSnapshots() {
  zfs set com.sun:auto-snapshot=true rpool/userdata
  zfs set com.sun:auto-snapshot=false rpool/nixos/nix
}

setupZfs() {
  setupZfsPool
  setupZfsDatasets
  setupZfsSnapshots
}

preflightCheck
partitionDisk
mount -t tmpfs none /mnt
setupZfs
mkdir /mnt/boot && mount "${DISK}-part4" /mnt/boot
swapon "${DISK}-part3"
