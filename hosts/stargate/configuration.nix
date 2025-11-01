{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "@wheel" ];

  networking.networkmanager.enable = true;

  networking.hostName = "stargate";
  networking.domain = "stargate.homebabo.at";
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  users.users.simon = {
    isNormalUser = true;
    home = "/home/simon";
    description = "Simon Babovic";
    extraGroups = ["wheel" "networkmanager"];
    openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKLMomem1Je4lxzZjYJEBEGj1ImmzbQIfeQcghlau6gU simon@matebook''
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZbFRs6yo0vTwfCHcv+aRUlk+Rlwm5yDRdSw9VPRMB6 simon@workstation''
    ];
  };
  users.mutableUsers = false;

  programs.bash.shellAliases = {
    l = "ls -alh";
    ll = "ls -la";
    ls = "ls --color=tty";
  };

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
  };

  system.stateVersion = "25.05";
}