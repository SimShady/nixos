{ config, lib, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.docker
  ];
  virtualisation.docker.enable = true;
}
