# nix-conf
NixOS Configuration files

## Setup

`sudo nixos-rebuild switch --flake '.#myNixos'`

## Bare-setup with BTRFS and LUKS

Adjusted from [c8h4](https://c8h4.io/nixos-btrfs):

### 1. Create GPT partitions

```bash
fdisk /dev/sdX
```
```
fdisk> g
fdisk> n
# <enter>, <enter>, +512M
# primary partition, number 1, from sector 2048 with size 512MiB
fdisk> n
# <enter>, <enter>, <enter> or add size
# primary partition, number 2
# if necesseary, adjust partition 1 type to EFI System
fdisk> t
fdisk> 1
# write setup
fdisk> w
```

### 1.5. Add encryption

```bash
cryptsetup -y -v luksFormat /dev/sdX2
cryptsetup open /dev/sdX2 nixos-root
```

### 2. Create Filesystems

```bash
mkfs.vfat -F32 -n nixos-boot /dev/sdX1
mkfs.btrfs -L nixos /dev/sdX2 # or /dev/mapper/nixos-root if encrypted
```

### 3. Create Subvolumens

```bash
mount /dev/sdX2 /mnt # or /dev/mapper/nixos-root
btrfs subvolume create /mnt/@
btrfs subv cr /mnt/@home
btrfs subv cr /mnt/@nix
btrfs subv cr /mnt/@log
umount /mnt
```

### 4. Mount BTRFS

```bash
mount -o noatime,subvol=@ /dev/disk/by-uuid/<uuid> /mnt # or /dev/mapper/nixos-root
mkdir -p /mnt/{boot,home,nix,var/log}
mount /dev/disk/by-uuid/<esp-uuid> /mnt/boot
mount -o subvol=@home /dev/disk/by-uuid/<uuid> /mnt/home
mount -o noatime,compress=zstd,subvol=@nix /dev/disk/by-uuid/<uuid> /mnt/nix
mount -o noatime,compress=zstd,subvol=@log /dev/disk/by-uuid/<uuid> /mnt/var/log
```

### 5. Install

```bash
nixos-install --flake ".#desktop"
reboot
```
