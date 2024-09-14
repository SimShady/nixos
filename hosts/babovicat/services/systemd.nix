{ config, lib, pkgs, ... }:
{
  systemd.services.mailjet-mailer = {
    description = "Run mailjet-mailer container";
    wants = [ "network-online.target" ];
    after = [ "docker.service" "network-online.target" ];
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "/bin/sh /var/services/mailjet-mailer/start.sh";
      ExecStop = "/bin/sh /var/services/mailjet-mailer/stop.sh";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
