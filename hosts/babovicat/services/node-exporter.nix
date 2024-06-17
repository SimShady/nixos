{ config, lib, pkgs, ... }:
{
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
    port = 9002;
    # disable a whole bunch of useless/unneeded collectors
    disabledCollectors = [
      "arp"
      "bcache"
      "bonding"
      "fibrechannel"
      "infiniband"
      "ipvs"
      "selinux"
      "tapestats"
      "xfs"
    ];
  };
}
