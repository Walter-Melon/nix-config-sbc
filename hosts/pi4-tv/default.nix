{ lib, inputs, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./network.nix
    ./packages.nix
    ./services.nix
    ./system.nix
  ];

  # nixpkgs.overlays = [
  #   (final: super: {
  #     makeModulesClosure = x:
  #       super.makeModulesClosure (x // { allowMissing = true; });
  #   })
  # ];

  system.stateVersion = "25.05";
}
