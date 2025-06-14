{ lib, pkgs, ... }:

{
  boot = {
    kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;
    #supportedFilesystems = lib.mkForce [ "vfat" "btrfs" "tmpfs" ];
  };
}