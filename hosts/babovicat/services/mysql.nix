{ config, lib, pkgs, ... }:
{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureUsers = [{
      name = "kartturnier";
      ensurePermissions = {
        "kartturnier.*" = "ALL PRIVILEGES";
      };
    }];
    ensureDatabases = [
      "kartturnier"
    ];
  };
}
