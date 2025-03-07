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
  };

  outputs = { self, nixpkgs, nixinate, ... }@inputs: {
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
  };
}
