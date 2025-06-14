{ ... }:

{
  nix.settings.trusted-users = [ "tv" ];

  users.users.tv = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    # Allow the graphical user to login without password
    initialHashedPassword = "";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwzVqGPzhMVawuS4KorJI0QIkYaTg8ItV+djB2uiYxT tv@pi4-tv"
    ];
  };
}