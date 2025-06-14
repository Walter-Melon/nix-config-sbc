{ pkgs, inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    # VSCode server hack
    inputs.vscode-server.nixosModules.default
    ({ config, pkgs, ... }: {
      services.vscode-server.enable = true;
    })
  ];

  environment.systemPackages = with pkgs; [
    libraspberrypi
    curl
    git
  ];

  programs.hyprland = {
   enable = true;
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs;};
  };
}