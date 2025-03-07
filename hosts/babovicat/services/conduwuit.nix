{ config, pkgs, ... }:

let
  cfg = config.services.conduwuit.settings;
  serverName = "babovic.at";
  matrixHost = "matrix.${serverName}";
  conduwuitUrl = "http://[${builtins.head cfg.global.address}]:${
    toString (builtins.head cfg.global.port)
  }";
in {
  services.conduwuit = {
    enable = true;
    settings.global = {
      server_name = serverName;
      address = [ "::1" ];
      port = [ 6167 ];
      allow_encryption = true;
      allow_federation = true;
      allow_registration = false;
      allow_guest_registration = false;
      allow_legacy_media = true;
      database_backend = "rocksdb";
      trusted_servers = [ "matrix.org" "htu.at" ];
      max_request_size = 32 * 1024 * 1024; # 32 MiB
      ip_lookup_strategy = 4; # Ipv6thenIpv4
      new_user_displayname_suffix = "🆕";
      well_known = {
        server = matrixHost;
        client = "https://${matrixHost}";
        # https://spec.matrix.org/v1.13/client-server-api/#getwell-knownmatrixsupport
        support_mxid = "@simon:babovic.at";
        support_role = "m.role.admin";
      };
    };

  };

  services.nginx.virtualHosts= {
    ${matrixHost} = {
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
      locations = {
          "/_matrix/" = {
            proxyPass = conduwuitUrl;
            proxyWebsockets = true;
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_buffering off;
              client_max_body_size 32M;
            '';
          };
          "/.well-known/matrix/".proxyPass = conduwuitUrl;
          "/".return = "301 https://${serverName}";
        };
        extraConfig = ''
          merge_slashes off;
          add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

          # https://spec.matrix.org/v1.13/client-server-api/#web-browser-clients
          # Access-Control-Allow-Origin: * is added by conduwuit already
          add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS" always;
          add_header Access-Control-Allow-Headers "X-Requested-With, Content-Type, Authorization" always;
        '';
      };
    ${serverName}.locations."/.well-known/matrix/".proxyPass = conduwuitUrl;
  };

  networking.firewall = {
    allowedTCPPorts = [ 8448 ];
    allowedUDPPorts = [ 8448 ];
  };
}