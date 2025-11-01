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

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    playitloud = {
      url = "git+ssh://git@github.com/SimShady/playitloud-frontend.git?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  outputs = { self, nixpkgs, nixinate, nixos-raspberrypi, ... }@inputs: {
    apps = nixinate.nixinate.x86_64-linux self;
    nixosConfigurations.workstation = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        { nixpkgs.overlays = [ (_: super: import ./pkgs super) ]; }
        (import ./hosts/workstation/configuration.nix)
        inputs.sops-nix.nixosModules.sops
        inputs.home-manager.nixosModules.default
        (
          { config, ... }:{
            _module.args = {
              inherit (config.sops) secrets;
              private-pkgs = {
                playitloud = inputs.playitloud.packages.x86_64-linux.playitloud;
              };
            };
            sops.age = {
              keyFile = "/var/lib/sops-nix/key.txt";
            };
          }
        )
      ];
    };
    nixosConfigurations.matebook = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        { nixpkgs.overlays = [ (_: super: import ./pkgs super) ]; }
        (import ./hosts/matebook/configuration.nix)
        inputs.sops-nix.nixosModules.sops
        inputs.home-manager.nixosModules.default
        (
          { config, ... }:{
            _module.args = {
              inherit (config.sops) secrets;
              private-pkgs = {
                playitloud = inputs.playitloud.packages.x86_64-linux.playitloud;
              };
            };
            sops.age = {
              keyFile = "/var/lib/sops-nix/key.txt";
            };
          }
        )
      ];
    };
    nixosConfigurations.babovicat = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        { nixpkgs.overlays = [ (_: super: import ./pkgs super) ]; }
        (import ./hosts/babovicat/configuration.nix)
        inputs.sops-nix.nixosModules.sops
        (
          { config, ... }:{
            _module.args = {
              inherit (config.sops) secrets;
              private-pkgs = {
                playitloud = inputs.playitloud.packages.x86_64-linux.playitloud;
              };
              nixinate = {
                host = "babovic.at";
                sshUser = "simon";
                buildOn = "local";
                substituteOnTarget = true;
                hermetic = false;
              };
            };
            sops.age = {
              sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
              keyFile = "/var/lib/sops-nix/key.txt";
              generateKey = true;
            };
          }
        )
      ];
    };
    nixosConfigurations.stargate = nixos-raspberrypi.lib.nixosSystem {
      specialArgs = inputs;
      modules = [
        { nixpkgs.overlays = [ (_: super: import ./pkgs super) ]; }
        inputs.sops-nix.nixosModules.sops
        ({...}: {
          imports = with nixos-raspberrypi.nixosModules; [
            raspberry-pi-5.base
            raspberry-pi-5.bluetooth
          ];
        })
        (import(./hosts/stargate/configuration.nix))
        (
          { config, ... }:{
            _module.args = {
              inherit (config.sops) secrets;
              nixinate = {
                host = "stargate.homebabo.at";
                sshUser = "simon";
                buildOn = "remote";
                substituteOnTarget = true;
                hermetic = false;
              };
            };
            sops.age = {
              sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
              keyFile = "/var/lib/sops-nix/key.txt";
              generateKey = true;
            };
          }
        )
      ];
    };
  };
}
