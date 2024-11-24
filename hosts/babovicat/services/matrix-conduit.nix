{ config, pkgs, ... }:

let
  conduitSettings = config.services.matrix-conduit.settings;
  serverName = "babovic.at";
  matrixHost = "matrix.${serverName}";
  conduitUrl = "http://[${conduitSettings.global.address}]:${
    toString conduitSettings.global.port
  }";
in {
  services.matrix-conduit = {
    enable = true;
    package = pkgs.conduwuit.overrideAttrs (oldAttrs: {
      patches = oldAttrs.patches ++ [
        (pkgs.fetchpatch {
          name = "allow-conduit-database-version-16.patch";
          url =
            "https://codeberg.org/girlbossceo/conduwuit/commit/7e828440f948ce38005105dd498f0e1f9048c02b.patch";
          hash = "sha256-whC38Thj9v/HO8ZoGJofHjcZN3EN5pHx8CFizq0QKvU=";
        })
      ];
    });
    settings.global = {
      server_name = serverName;
      address = "::1";
      port = 6167;
      allow_encryption = true;
      allow_federation = true;
      allow_registration = false;
      database_backend = "rocksdb";
      allow_guest_registration = true;
      ip_lookup_strategy = 4; #Ipv6thenIpv4
      trusted_servers = [ "matrix.org" ];
      max_request_size = 32 * 1024 * 1024; # 32 MiB
      new_user_displayname_suffix = "🆕";
      well_known.server = matrixHost;
      well_known.client = "https://${matrixHost}";
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
      locations."/_matrix/" = {
        proxyPass = conduitUrl;
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_buffering off;
          client_max_body_size 32M;
        '';
      };
      locations."/".return = "301 https://${serverName}";
      extraConfig = ''
        merge_slashes off;
      '';
    };
    ${serverName}.locations."/.well-known/matrix".proxyPass = conduitUrl;
  };

  networking.firewall = {
    allowedTCPPorts = [ 8448 ];
    allowedUDPPorts = [ 8448 ];
  };
}