## Installation using this image
Heavily based on [Installing headless NixOS on Raspberry Pi](https://blog.krishu.moe/posts/nixos-raspberry-pi/)

### Notes
- Test installing the image without changing the pi's boot order and just remove the SD-Card
- After install the ``configuration``-Files are located in ``/nix/persist/etc/nixos``

### Building the image (WSL2)
- Inside NixOS-WSL2
    - Clone repo and ``cd`` into it
    - Build the SD-Card Image
        ```sh
        nix build .#nixosConfigurations.nixos-pi-installer.config.system.build.sdImage --show-trace -L -v
        ```
- Copy the created image to a folder on the windows host
- Flash a USB-Drive using Rufus

### Loading the image and partition
- Remove the SD-Card from the pi and plug the USB-Drive in
- Power on the system and boot from USB
- Once powered, access via SSH
- Plug the SD-Card back in and check with ``lsblk``
- Partion the SD-Card using the following (copied from Kris Hu's post)
- Note: For SD-Cards it's p1, p2, ... not like USB or SSD just a number
```sh
wipefs -a /dev/mmcblk0
parted /dev/mmcblk0 -- mklabel msdos
parted /dev/mmcblk0 -- mkpart primary fat32 1M 512M
parted /dev/mmcblk0 -- set 1 boot on
parted /dev/mmcblk0 -- mkpart primary btrfs 512MiB 100%
mkfs.vfat -F32 -n BOOT /dev/mmcblk0p1
mkfs.btrfs -L NIXOS /dev/mmcblk0p2 -f

mkdir -p /mnt/{boot,nix,swap}
mount /dev/mmcblk0p1 /mnt/boot
mount -o compress=zstd /dev/mmcblk0p2 /mnt/nix
btrfs subvolume create /mnt/nix/swap
mount -o noatime,subvol=swap /dev/mmcblk0p2 /mnt/swap
btrfs filesystem mkswapfile --size 4g /mnt/swap/swapfile
```

### Installing NixOS
- Create and mount the folders where the actual install lives
```sh
mkdir -p /mnt/etc/nixos
mkdir -p /mnt/nix/persist/etc/nixos
mount -o bind /mnt/nix/persist/etc/nixos /mnt/etc/nixos
```
- Clone this repo into ``/mnt/etc/nixos``
```sh
git clone https://github.com/Walter-Melon/nix-config-sbc /mnt/etc/nixos
```
- Install the pi you want with ``nixos-install``, replace ``VERSION``
```sh
nixos-install --flake /mnt/etc/nixos#pi4-VERSION --no-root-password
```

### Installing Bootloader and restart
- Copy the bootloader from the USB-Stick ``sda``
```sh
mkdir /firmware
mount /dev/sda1 /firmware
cp /firmware/* /mnt/boot
```
- Shutdown the pi using ``poweroff``
- Disconnect the USB-Drive and power on