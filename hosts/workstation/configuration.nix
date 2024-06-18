{ lib, config, pkgs, inputs, ... }:{
  imports =
    [
      ./hardware-configuration.nix
      ./custom-hardware-configuration.nix
      ./system-programs.nix
      ../../modules/desktop/default.nix
    ];

  simon.desktop = {
    enable = true;
    hostName = "workstation";
    home-manager = {
      customHomePath = ./home.nix;
      extraSpecialArgs = { inherit inputs; };
    };
  };

  system.stateVersion = "24.05";
}
