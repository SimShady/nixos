{ config
, lib
, pkgs
, ... }:

let
  serverName = "babovic.at";
in {
  services.nginx.virtualHosts."matrix.${serverName}".locations = let
    inherit (config.services.maubot) settings;
  in {
    "^~ /_matrix/maubot/" = {
      proxyPass = "http://${settings.server.hostname}:${toString settings.server.port}";
      proxyWebsockets = true;
    };
  };

  services.maubot = {
    enable = true;
    settings = {
      server.public_url = "https://matrix.${serverName}";
      admins = {
        root = "";
        test = "test";
      };
      homeservers = {
        "babovic.at" = {
          url = "https://matrix.babovic.at";
        };
      };
    };
    plugins = with config.services.maubot.package.plugins; [
      webhook
    ];
  };
  environment.systemPackages = [
    pkgs.maubot
  ];
}
