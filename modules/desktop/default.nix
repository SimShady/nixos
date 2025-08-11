{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.simon.desktop;
in {
  imports = [
    ./grub.nix
    ./locale.nix
    ./display.nix
    ./audio.nix
    ./mysql.nix
    ./system-programs.nix
    ./vpn.nix
    ./fonts.nix
  ];

  options.simon.desktop = with types; {
    enable = mkEnableOption "Simons Desktop";
    hostName = mkOption {
      type = str;
    };
    additionalGroups = mkOption {
      type = listOf str;
      default = [];
    };
    hashedPassword = mkOption {
      type = str;
      default = "$y$j9T$33a2GN1EBs3bltnz60I7h0$/LJc/yVogLQ61cJGgCEBpCdoM6LnqkUJvXvG5fwarr1";
    };
    home-manager = {
      customHomePath = mkOption {
        type = path;
      };
      extraSpecialArgs = mkOption {
        type = attrs;
      };
    };
  };

  config = mkIf cfg.enable {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    users.mutableUsers = false;
    services.printing.enable = true;
    networking.networkmanager.enable = true;
    networking.hostName = cfg.hostName;
    nixpkgs.config.allowUnfree = true;
      
    nix.gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };

    users.users.simon = {
      isNormalUser = true;
      description = "Simon Babovic";
      extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ] ++ cfg.additionalGroups;
      hashedPassword = cfg.hashedPassword;
    };

    home-manager = {
      extraSpecialArgs = cfg.home-manager.extraSpecialArgs;
      users = {
        "simon" = {...}:{
          imports = [
            ./home-manager/home.nix
            cfg.home-manager.customHomePath 
          ];
        };
      };
    };
  };
}