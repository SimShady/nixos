{ lib, config, pkgs, inputs, ... }:{
  imports =
    [
      ./hardware-configuration.nix
      ./system-programs.nix
      ../../modules/desktop/default.nix
    ];

  simon.desktop = {
    enable = true;
    hostName = "matebook";
    home-manager = {
      customHomePath = ./home.nix;
      extraSpecialArgs = { inherit inputs; };
    };
  };

  sops.age = {
    keyFile = "/var/lib/sops-nix/key.txt";
  };

  system.stateVersion = "24.05";
}
