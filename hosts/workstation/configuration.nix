{ lib, config, pkgs, inputs, ... }:{
  imports =
    [
      ./hardware-configuration.nix
      ./custom-hardware-configuration.nix
      ../../modules/desktop/default.nix
    ];

  simon.desktop = {
    enable = true;
    hostName = "workstation";
    home-manager = {
      modulePath = inputs.home-manager.nixosModules.default;
      customHomePath = ./home.nix;
      extraSpecialArgs = { inherit inputs; };
    };
  };

  system.stateVersion = "24.05";
}
