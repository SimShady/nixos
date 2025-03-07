{ config, lib, pkgs, secrets, ... }:
let
  serverName = "babovic.at";
  matrixHost = "matrix.${serverName}";
in {
  services.nginx.virtualHosts."matrix.${serverName}".locations = let
    inherit (config.services.maubot) settings;
  in {
    "^~ /_matrix/maubot/" = {
      proxyPass = "http://${settings.server.hostname}:${toString settings.server.port}";
      proxyWebsockets = true;
    };
  };

  sops.secrets."maubot/extra-config" = {
    sopsFile = ../../../secrets/babovicat.yaml;
  };

  systemd.services.maubot = {
    preStart = ''
      mkdir -p /var/lib/maubot/plugins
    '';
    serviceConfig = {
      LoadCredential = "extra-config:${secrets."maubot/extra-config".path}";
    };
  };

  services.maubot = {
    enable = true;
    settings = {
      server.public_url = "https://matrix.${serverName}";
      homeservers = {
        "${serverName}" = {
          url = "https://${matrixHost}";
        };
      };
    };
    extraConfigFile = "/run/credentials/maubot.service/extra-config";
    plugins = with config.services.maubot.package.plugins; [
      webhook
    ];
  };
  environment.systemPackages = [
    pkgs.maubot
  ];
}
