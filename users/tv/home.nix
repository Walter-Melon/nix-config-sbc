{pkgs, ...}: {
  imports = [
    ../../home/core.nix
  ];

  programs.git = {
    enable = true;
    userName = "Walter-Melon";
    userEmail = "mc.walter.melon@gmail.com";
  };
}