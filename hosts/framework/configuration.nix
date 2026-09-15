{ lib, config, pkgs, inputs, ... }:{
  imports =
    [
      ./hardware-configuration.nix
      ./system-programs.nix
      ../../modules/desktop/default.nix
    ];

  simon.desktop = {
    enable = true;
    hostName = "framework";
    home-manager = {
      customHomePath = ./home.nix;
      extraSpecialArgs = { inherit inputs; };
    };
  };

  services.fprintd.enable = true;

  system.stateVersion = "26.05";
}
