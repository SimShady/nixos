{ config, lib, pkgs, ... }:
{
  security.acme.certs."babovic.at" = {
    webroot = "/var/lib/acme/challenges-babovicat";
    email = "cert+simon@babovic.at";
    group = "nginx";
    extraDomainNames = [
      "paperless.babovic.at"
      "matrix.babovic.at"
      "grafana.babovic.at"
      "kartturnier.babovic.at"
      "mailer.babovic.at"
    ];
  };
  # http to https redirect
  services.nginx.virtualHosts."babovic.at80" = {
    serverName = "babovic.at";
    serverAliases = [ "*.babovic.at" ];
    locations."/.well-known/acme-challenge" = {
      root = config.security.acme.certs."babovic.at".webroot;
      extraConfig = ''
        auth_basic off;
      '';
    };
    locations."/" = { return = "301 https://$host$request_uri"; };
    listen = [ { addr = "0.0.0.0"; port = 80; } { addr = "[::0]"; port = 80; } ];
  };

  # https only
  services.nginx.virtualHosts."kartturnier.babovic.at" = {
    onlySSL = true;
    useACMEHost = "babovic.at";
    acmeRoot = config.security.acme.certs."babovic.at".webroot;
    root = "/var/www/kartturnier";
    locations."/".extraConfig = ''
      try_files = $uri $uri/ $uri.html = 404;
    '';
  };
  services.nginx.virtualHosts."babovic.at" = {
    onlySSL = true;
    useACMEHost = "babovic.at";
    acmeRoot = config.security.acme.certs."babovic.at".webroot;
    root = "/var/www/babovicat";
    locations."/".extraConfig = ''
      try_files = $uri $uri/ $uri.html = 404;
    '';
  };
  services.nginx.virtualHosts."mailer.babovic.at" = {
    onlySSL = true;
    useACMEHost = "babovic.at";
    acmeRoot = config.security.acme.certs."babovic.at".webroot;
    locations."/".extraConfig = ''
      proxy_pass http://127.0.0.1:11110;
    '';
    listen = [ { addr = "0.0.0.0"; port = 443; } { addr = "[::0]"; port = 443; } ];
  };
}
