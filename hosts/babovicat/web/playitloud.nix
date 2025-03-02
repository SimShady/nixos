{ config, lib, pkgs, private-pkgs, ... }:
{
  security.acme.certs."playitloud-musikunterricht.de" = {
    webroot = "/var/lib/acme/challenges-playitloud";
    group = "nginx";
    extraDomainNames = [
      "www.playitloud-musikunterricht.de"
    ];
  };
  
  # http to https redirect
  services.nginx.virtualHosts."playitloud-musikunterricht.de80" = {
    serverName = "playitloud-musikunterricht.de";
    serverAliases = [ "*.playitloud-musikunterricht.de" ];
    locations."/.well-known/acme-challenge" = {
      root = config.security.acme.certs."playitloud-musikunterricht.de".webroot;
      extraConfig = ''
        auth_basic off;
      '';
    };
    locations."/" = { return = "301 https://$host$request_uri"; };
    listen = [ { addr = "0.0.0.0"; port = 80; } { addr = "[::0]"; port = 80; } ];
  };

  services.nginx.virtualHosts."playitloud-musikunterricht.de" = {
    onlySSL = true;
    serverAliases = ["www.playitloud-musikunterricht.de"];
    useACMEHost = "playitloud-musikunterricht.de";
    acmeRoot = config.security.acme.certs."playitloud-musikunterricht.de".webroot;
    root = "${private-pkgs.playitloud}/www";
    locations."/".extraConfig = ''
      try_files = $uri $uri/ $uri.html = 404; 
    '';
  };
}
