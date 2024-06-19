{ config, lib, pkgs, ... }:

let
  paperlessEnv = config.services.paperless.settings;
  redisSocketPath = config.services.redis.servers.paperless.unixSocket;
  serverName = "babovic.at";
  vhost = "paperless.${serverName}";
in {
  services.paperless = {
    enable = true;
    address = "[::1]";
    settings = {
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      # also allows importing (most) digitally signed PDFs, at least any  with
      # text already embedded, e.g. Austrian e-gov documents
      PAPERLESS_OCR_SKIP_ARCHIVE_FILE = "with_text";
      PAPERLESS_REDIS = "unix://${redisSocketPath}";
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_DBNAME = "paperless";
      PAPERLESS_DBUSER = "paperless";
      PAPERLESS_SSLMODE = "disable";
      PAPERLESS_URL = "https://${vhost}";
      PAPERLESS_USE_X_FORWARD_HOST = true;
      PAPERLESS_USE_X_FORWARD_PORT = true;
    };
  };

  services.redis.vmOverCommit = true;
  services.redis.servers.paperless = {
    enable = true;
    databases = 16;
    maxclients = 128;
    user = "paperless";
    port = 0; # disable TCP
    settings = {
      maxmemory = "128MB";
      maxmemory-policy = "volatile-ttl";
    };
  };

  services.postgresql = {
    ensureDatabases = [ paperlessEnv.PAPERLESS_DBNAME ];
    ensureUsers = [{
      name = paperlessEnv.PAPERLESS_DBUSER;
      ensureDBOwnership =
        assert paperlessEnv.PAPERLESS_DBNAME == paperlessEnv.PAPERLESS_DBNAME;
        true;
      ensureClauses.login = true;
    }];
  };

  systemd.services = lib.mkMerge [
    # Binds the redis socket into services that need it
    (let services = [ "scheduler" "task-queue" "web" ];
    in builtins.listToAttrs (map (name: {
      name = "paperless-${name}";
      value = {
        serviceConfig.BindReadOnlyPaths = [ redisSocketPath ];
        requires = [ "redis-paperless.service" ];
        after = [ "redis-paperless.service" ];
      };
    }) services))
    {
      # Ensure that redis is available before it starts
      paperless-download-nltk-data = {
        requires = [ "redis-paperless.service" ];
        after = [ "redis-paperless.service" "network-online.target" ];
        wants = [ "network-online.target" ];
        preStart = "${pkgs.toybox}/bin/sleep 10";
      };
    }
  ];

  services.nginx.virtualHosts.${vhost} = {
    onlySSL = true;
    useACMEHost = serverName;
    acmeRoot = config.security.acme.certs."babovic.at".webroot;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://[::1]:${toString config.services.paperless.port}";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 512M;
      '';
    };
  };
}