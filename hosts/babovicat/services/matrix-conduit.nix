{ config, pkgs, ... }:

let
  conduitSettings = config.services.matrix-conduit.settings;
  serverName = "babovic.at";
  matrixHost = "matrix.${serverName}";
in {
  services.matrix-conduit = {
    enable = true;
    settings.global = {
      server_name = serverName;
      address = "::1";
      port = 6167;
      allow_encryption = true;
      allow_federation = true;
      allow_registration = false;
      database_backend = "sqlite";
      trusted_servers = [ "matrix.org" ];
      max_request_size = 32 * 1024 * 1024; # 32 MiB
    };
  };

  services.nginx.virtualHosts.${matrixHost} = {
    onlySSL = true;
    useACMEHost = serverName;
    acmeRoot = config.security.acme.certs."babovic.at".webroot;
    kTLS = true;
    listen = [
      {
        addr = "0.0.0.0";
        port = 443;
        ssl = true;
      }
      {
        addr = " [::0]";
        port = 443;
        ssl = true;
      }
      {
        addr = "0.0.0.0";
        port = 8448;
        ssl = true;
      }
      {
        addr = " [::0]";
        port = 8448;
        ssl = true;
      }
    ];
    locations."/_matrix/" = {
      proxyPass = "http://[${conduitSettings.global.address}]:${
          toString conduitSettings.global.port
        }";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        client_max_body_size 32M;
      '';
    };
    locations."/".return = "301 https://${serverName}";
    extraConfig = ''
      merge_slashes off;
    '';
  };
  services.nginx.virtualHosts.${serverName} = {
    locations."= /.well-known/matrix/server" = let
      contents = pkgs.writeText "well-known-matrix-server" ''
        {
          "m.server": "${matrixHost}"
        }
      '';
    in {
      alias = "${contents}";
      extraConfig = ''
        default_type application/json;
      '';
    };
    locations."= /.well-known/matrix/client" = let
      contents = pkgs.writeText "well-known-matrix-server" ''
        {
          "m.homeserver": {
            "base_url": "https://${matrixHost}"
          }
        }
      '';
    in {
      alias = "${contents}";
      extraConfig = ''
        default_type application/json;

        # https://matrix.org/docs/spec/client_server/r0.4.0#web-browser-clients
        add_header Access-Control-Allow-Origin "*";
      '';
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 8448 ];
    allowedUDPPorts = [ 8448 ];
  };
}