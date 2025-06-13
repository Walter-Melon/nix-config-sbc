{ lib, inputs, pkgs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    # Currently disabled for hardware config from nix.dev
    #./hardware-configuration.nix
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  nix.settings.trusted-users = [ "tv" ];
  nix.settings.experimental-features = ["nix-command" "flakes"];
  
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

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
  #boot.supportedFilesystems = lib.mkForce [ "vfat" "btrfs" "tmpfs" ];

  time.timeZone = "Europe/Berlin";
  services.xserver.xkb.layout = "de";
  console.useXkbConfig = true;

  services.openssh.enable = true;

  users.users.tv = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    # Allow the graphical user to login without password
    initialHashedPassword = "";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwzVqGPzhMVawuS4KorJI0QIkYaTg8ItV+djB2uiYxT tv@pi4-tv"
    ];
  };

  #programs.hyprland = {
  #  enable = true;
  #  # set the flake package
  #  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  #  # make sure to also set the portal package, so that they are in sync
  #  portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  #};

  system.stateVersion = "25.05";
}
