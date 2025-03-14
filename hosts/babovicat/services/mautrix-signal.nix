{ config, pkgs, secrets, ... }:

let
  conduwuitCfg = config.services.conduwuit.settings;
  conduwuitUrl = "http://[${builtins.head conduwuitCfg.global.address}]:${
      toString (builtins.head conduwuitCfg.global.port)
    }";

  homeServer = conduwuitCfg.global.server_name;
  stateDir = "/var/lib/mautrix-signal";
in {
  sops.secrets."mautrix-signal/env" = {
    sopsFile = ../../../secrets/babovicat.yaml;
    restartUnits = [ "mautrix-signal.service" ];
  };

  services.mautrix-signal = {
    enable = true;
    environmentFile = secrets."mautrix-signal/env".path;
    settings = {
      bridge = {
        permissions."@simon:${homeServer}" = "admin";
        relay.enabled = false;
        async_events = false;
        split_portals = false;
        bridge_matrix_leave = false;
        cleanup_on_logout.enabled = false;
      };
      database = {
        type = "sqlite3-fk-wal";
        uri = "file:${stateDir}/mautrix-signal.db?_txlock=immediate";
      };
      homeserver = {
        address = conduwuitUrl;
        domain = homeServer;
      };
      appservices = let
        hostname = "[::1]";
        port = 6200;
      in {
        address = "http://${hostname}:${toString port}";
        inherit hostname port;
        id = "signal";
        ephemeral_events = false;
        async_transactions = false;
      };
      matrix = {
        message_status_events = true;
        delivery_receipts = true;
        message_error_notices = true;
        sync_direct_chat_list = true;
        federate_rooms = false;
      };

      analytics.token = null;

      direct_media.enable = false;

      backfill.enabled = true;

      # https://docs.mau.fi/bridges/general/double-puppeting.html
      double_puppet = {
        servers = [ ];
        allow_discovery = false;
        secrets.${homeServer} = "as_token:$DOUBLE_PUPPET_AS_TOKEN";
      };

      # https://docs.mau.fi/bridges/general/end-to-bridge-encryption.html
      encryption = {
        allow = true;
        default = true;
        require = true;
        appservice = false;
        pickle_key = "$ENCRYPTION_PICKLE_KEY";
        allow_key_sharing = true;
        verification_levels = {
          receive = "unverified";
          send = "cross-signed-tofu";
          share = "cross-signed-tofu";
        };
      };
    };
  };
}
