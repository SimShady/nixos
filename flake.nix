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

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    sops-nix = {
      url = "github:Mic92/sops-nix";
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
    nixosConfigurations.matebook = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        inputs.sops-nix.nixosModules.sops
        (import ./hosts/matebook/configuration.nix)
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
    nixosConfigurations.minecraft-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        (import ./hosts/minecraft-server/configuration.nix)
        # inputs.nix-minecraft.nixosModules.minecraft-servers
        # {
        #   nixpkgs.overlays = [
        #     inputs.nix-minecraft.overlay
        #   ];
        # }
        {
          _module.args.nixinate = {
            host = "minecraft.babovic.at";
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
