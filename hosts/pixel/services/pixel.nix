{ lib, config, ... }: {
  services.pixelfed = {
    enable = true;
    domain = "pixel.eurojumbo.at";
    secretFile = "/home/simon/pixel-secrets.env";
    nginx = {
      onlySSL = true;
      useACMEHost = "eurojumbo.at";
      acmeRoot = config.security.acme.certs."eurojumbo.at".webroot;
    };
  };

  security.acme.certs."eurojumbo.at" = {
    webroot = "/var/lib/acme/challenges-eurojumbo";
    email = "cert+simon@babovic.at";
    group = "nginx";
    extraDomainNames = [
      "pixel.eurojumbo.at"
    ];
  };
  # http to https redirect
  services.nginx.virtualHosts."eurojumbo.at80" = {
    serverName = "eurojumbo.at";
    serverAliases = [ "*.eurojumbo.at" ];
    locations."/.well-known/acme-challenge" = {
      root = config.security.acme.certs."eurojumbo.at".webroot;
      extraConfig = ''
        auth_basic off;
      '';
    };
    locations."/" = { return = "301 https://$host$request_uri"; };
    listen = [ { addr = "0.0.0.0"; port = 80; } { addr = "[::0]"; port = 80; } ];
  };
}
