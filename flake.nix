{
  description = "Mel's nix configuration for Pi's";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Needed to connect via ssh over VSCode
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = { self, nixpkgs, vscode-server, ... }@inputs:
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
          modules = [
            ./hosts/pi4-tv

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
