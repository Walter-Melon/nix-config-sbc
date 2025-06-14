{ lib, pkgs, ... }:

{
  boot = {
    kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    #supportedFilesystems = lib.mkForce [ "vfat" "btrfs" "tmpfs" ];
  };
}