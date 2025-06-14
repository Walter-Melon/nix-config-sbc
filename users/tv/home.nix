{pkgs, ...}: 

{
  imports = [
    ../../modules/home/chromium.nix
    ../../modules/home/hyprland
    ../../modules/home/git.nix
    ../../modules/home/kitty.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "tv";
    homeDirectory = "/home/tv";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "25.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}