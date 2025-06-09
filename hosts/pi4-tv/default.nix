{ lib, inputs, pkgs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    ./hardware-configuration
  ];

  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  nix.settings.trusted-users = [ "tv" ];
  nix.settings.experimental-features = ["nix-command" "flakes"];

  hardware.raspberry-pi."4".fkms-3d.enable = true;

  environment.systemPackages = with pkgs; [
    libraspberrypi
    wget
    curl
    git
  ];

  networking.hostName = "pi4-tv";
  networking.networkmanager.wifi.powersave = false;

  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;
  boot.supportedFilesystems = lib.mkForce [ "vfat" "btrfs" "tmpfs" ];

  time.timeZone = "Europe/Berlin";
  services.xserver.xkb.layout = "de";
  console.useXkbConfig = true;

  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  users.users.tv = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwzVqGPzhMVawuS4KorJI0QIkYaTg8ItV+djB2uiYxT tv@pi4-tv"
    ];
  };

  system.stateVersion = "25.05";
}
