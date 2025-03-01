{ config, lib, pkgs, ... }:
{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3031;
        domain = "grafana.babovic.at";
        root_url = "https://grafana.babovic.at";
      };
    };
  };
  services.nginx.virtualHosts."grafana.babovic.at" = {
    onlySSL = true;
    useACMEHost = "babovic.at";
    acmeRoot = config.security.acme.certs."babovic.at".webroot;
    locations."/" = {
      proxyPass = "http://${config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };
}
