{ config, lib, pkgs, inputs, outputs, modulesPath, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
  ];

  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;
  boot.supportedFilesystems = lib.mkForce [ "vfat" "btrfs" "tmpfs" ];

  sdImage.compressImage = false;

  networking.hostName = "pi4-installer";

  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  users.users.mel = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJL97Pccb5GMcPYSm3iIAYkhqYOQ8rDLNGVYEqvXKBTs"
    ];
  };

  system.stateVersion = "25.05";
  nixpkgs.hostPlatform = "aarch64-linux";
}
