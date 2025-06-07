# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# Raspberry Pi specific options are documented on the nixos-raspberrypi repository:
# https://github.com/nvmd/nixos-raspberrypi

{ config, lib, pkgs, nixos-raspberrypi, disko, username, ... }:

{
  imports = with nixos-raspberrypi.nixosModules; [
    # Hardware configuration
    raspberry-pi-4.base
    raspberry-pi-4.display-vc4
    raspberry-pi-4.bluetooth

    # Disk configuration
    disko.nixosModules.disko
    # WARNING: formatting disk with disko is DESTRUCTIVE, check if
    # `disko.devices.disk.main.device` is set correctly!
    ./disko-usb-btrfs.nix

    ../../modules/system.nix
    ./networking.nix
  ];

  # Automatically log in at the virtual consoles.
  services.getty.autologinUser = username;

  # Allow passwordless sudo from user
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };
  
  services.udev.extraRules = ''
    # Ignore partitions with "Required Partition" GPT partition attribute
    # On our RPis this is firmware (/boot/firmware) partition
    ENV{ID_PART_ENTRY_SCHEME}=="gpt", \
      ENV{ID_PART_ENTRY_FLAGS}=="0x1", \
      ENV{UDISKS_IGNORE}="1"
  '';

  boot.tmp.useTmpfs = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
