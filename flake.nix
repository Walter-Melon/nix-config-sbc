{
  description = "Mel's nix configuration for Pi's";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    hyprland.url = "github:hyprwm/Hyprland";

    # Needed to connect via ssh over VSCode
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, vscode-server, ... }@inputs:
    let
      inherit (self) outputs;
    in
    {
      nixosConfigurations = {
        # Image for a headless SD-Card image
        pi4-installer = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/pi4-installer ];
        };

        # Configuration for the TV
        pi4-tv = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          pkgs = nixpkgs.legacyPackages.aarch64-linux;

          modules = [
            ./hosts/pi4-tv
            
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.tv = import ./users/tv/home.nix;
            }

            {
              wayland.windowManager.hyprland = {
                enable = true;
                # set the flake package
                package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
                portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
              };
            }

            # VSCode server hack
            vscode-server.nixosModules.default
            ({ config, pkgs, ... }: {
              services.vscode-server.enable = true;
            })
          ];
        };
      };
    };
}
