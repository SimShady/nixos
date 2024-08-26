{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixinate = {
      url = "github:matthewcroughan/nixinate";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixinate, ... }@inputs: {
    apps = nixinate.nixinate.x86_64-linux self;
    nixosConfigurations.workstation = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        (import ./hosts/workstation/configuration.nix)
        inputs.home-manager.nixosModules.default
        {
          nixpkgs.overlays = [
            (import ./packages/python)
            (import ./packages/vscode-extensions)
          ];
        }
      ];
    };
    nixosConfigurations.babovicat = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        (import ./hosts/babovicat/configuration.nix)
        {
          _module.args.nixinate = {
            host = "babovic.at";
            sshUser = "simon";
            buildOn = "remote";
            substituteOnTarget = true;
            hermetic = false;
          };
        }
      ];
    };
  };
}
