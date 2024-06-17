{ config, lib, pkgs, ... }:
{
  services.nginx = {
    enable = true;
    package = pkgs.nginxMainline;
    recommendedBrotliSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedZstdSettings = true;
    clientMaxBodySize = lib.mkDefault "16M";
    appendHttpConfig = ''
      # avoid hitting the disk
      proxy_max_temp_file_size 0;
    '';

  };
  users.users.nginx.extraGroups = [ "acme" ];
}
