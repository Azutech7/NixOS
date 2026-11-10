# NixOS Drive Preparation & Btrfs Subvolume Setup Guide
<sup>(guide produced by Gemini)</sup>

This guide covers how to completely clear, partition, format, and mount a storage drive (supporting both NVMe and SATA drives) with a customized Btrfs subvolume and swapfile layout for NixOS.

---

## 1. Important Notes on Clearing a Drive (Start Here)
Before partitioning a drive that has been used previously, you must clear existing partition tables, filesystem signatures, and sometimes securely erase blocks (especially on SSDs/NVMe drives). 

Replace `/dev/nvme0n1` (or `/dev/sda` for SATA) with your actual target drive in the commands below:

```bash
# 1. Wipe all filesystem signatures and partition tables
sudo wipefs -a /dev/nvme0n1

# 2. Zero out the beginning and end of the drive to clear stubborn GPT/MBR remnants
sudo dd if=/dev/zero of=/dev/nvme0n1 bs=1M count=10 status=progress
sudo sgdisk --zap-all /dev/nvme0n1

# 3. (Optional for SSDs/NVMe) Securely trim/discard existing blocks to restore peak performance
sudo blkdiscard /dev/nvme0n1
```

---

## 2. Drive Naming Conventions: NVMe vs. SATA
Depending on the type of storage hardware you are using, Linux names your drives and partitions differently:

| Feature | NVMe Drives (e.g., modern M.2 SSDs) | SATA Drives (e.g., traditional SSDs & HDDs) |
| :--- | :--- | :--- |
| **Base Device Name** | `/dev/nvme0n1` *(Controller 0, Namespace 1)* | `/dev/sda`, `/dev/sdb`, etc. |
| **Partition Naming** | `/dev/nvme0n1p1`, `/dev/nvme0n1p2` *(Uses `p` before the number)* | `/dev/sda1`, `/dev/sda2` *(Appends number directly)* |

> ⚠️ **Note:** Ensure you substitute `nvme0n1` with your correct drive identifier (e.g., `sda`) throughout this guide if you are using a SATA drive.

---

## 3. Environment Setup (Nix Shell)
To perform these steps, spawn a temporary shell containing all required disk management utilities (`parted`, `btrfs-progs`, `util-linux`, `gdisk`) without installing them permanently:

```bash
nix-shell -p parted btrfs-progs util-linux gdisk
```

---

## 4. Identify Your Drive
List your storage devices, verify your drive identifier, and note your partition UUIDs once formatted:

```bash
lsblk -f
```

---

## 5. Partition the Drive

### For NVMe Drives (`/dev/nvme0n1`):
```bash
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 1G
parted /dev/nvme0n1 -- mkpart primary btrfs 1G 100%
```

### For SATA Drives (`/dev/sda`):
```bash
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart ESP fat32 1MiB 1G
parted /dev/sda -- mkpart primary btrfs 1G 100%
```

---

## 6. Format the Partitions & Setup Subvolumes

### Format Partitions (NVMe Example)
```bash
mkfs.fat -F 32 -n boot /dev/nvme0n1p1
mkfs.btrfs -f -L nixos /dev/nvme0n1p2
```
*(For SATA, replace `nvme0n1p1` / `nvme0n1p2` with `sda1` / `sda2`).*

### Create Btrfs Subvolumes
Temporarily mount the root Btrfs partition to structure your subvolumes:

```bash
mount /dev/nvme0n1p2 /mnt

btrfs subvolume create /mnt/rootfs
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/swap

umount /mnt
```

---

## 7. Mount Filesystems & Configure Swap

### Mount Points
```bash
mount -o subvol=rootfs /dev/nvme0n1p2 /mnt
mkdir -p /mnt/{home,nix,.swapvol,boot}

mount -o subvol=home,compress=zstd /dev/nvme0n1p2 /mnt/home
mount -o subvol=nix,compress=zstd,noatime /dev/nvme0n1p2 /mnt/nix
mount -o subvol=swap /dev/nvme0n1p2 /mnt/.swapvol
mount /dev/nvme0n1p1 /mnt/boot
```

### Create and Activate the Btrfs Swapfile
Btrfs requires Copy-on-Write (CoW) and compression to be disabled on swap files:

```bash
touch /mnt/.swapvol/swapfile
chattr +C /mnt/.swapvol/swapfile
btrfs property set /mnt/.swapvol/swapfile compression ""

# Allocate size (e.g., 8GB swapfile via count=8192)
dd if=/dev/zero of=/mnt/.swapvol/swapfile bs=1M count=8192 status=progress
chmod 600 /mnt/.swapvol/swapfile

mkswap /mnt/.swapvol/swapfile
swapon /mnt/.swapvol/swapfile
```

---

## 8. Deploy NixOS from Your Remote Flake
Once your partitions are mounted and your flake configuration is updated with the correct partition UUIDs (found via `lsblk -f`), trigger your remote deployment:

```bash
sudo nixos-rebuild switch --refresh --no-write-lock-file --flake github:Azutech7/NixOS#<insert_hostname>
```