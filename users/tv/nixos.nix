{ config, lib, pkgs, nixos-raspberrypi, disko, username, ... }:

{
  users.users."${user}" = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"
      "networkmanager"
      "video"
    ];
    # Allow the graphical user to login without password
    initialHashedPassword = "";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwzVqGPzhMVawuS4KorJI0QIkYaTg8ItV+djB2uiYxT tv@pi4-tv"
    ];
  };
}