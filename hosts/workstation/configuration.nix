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
  
  nixpkgs.config.allowUnfree = true;

  boot.initrd.kernelModules = ["amdgpu"];

  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
    ROC_ENABLE_PRE_VEGA = "1";
  };

  system.stateVersion = "24.05";
}
