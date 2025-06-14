{
  description = "Mel's nix configuration for Pi's";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Needed to connect via ssh over VSCode
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = { nixpkgs, home-manager, ... } @ inputs:  
  {
    nixosConfigurations = {
      # Image for a headless SD-Card image
      pi4-installer = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/pi4-installer ];
      };

      # Configuration for the TV
      pi4-tv = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; };

        modules = [
          ./hosts/pi4-tv
          ./users/tv/nixos.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.users.tv = import ./users/tv/home.nix;
          }
        ];
      };
    };
  };
}
