{ lib, ... }: {
  systemd.network = {
    enable = true;
    links."10-wan" = {
      matchConfig = {
        PermanentMACAddress = "96:00:03:58:a4:ae";
        Type = "ether";
      };
      linkConfig.Name = "wan";
    };
    networks."10-wan" = {
      matchConfig.Name = "wan";
      addresses = [
        { Address = "94.130.186.30/32"; }
        { Address = "2a01:4f8:1c1e:c61a::1/64"; }
      ];
      routes = [
        {
          Gateway = "172.31.1.1";
          GatewayOnLink = true;
        }
        { Gateway = "fe80::1"; }
      ];
      dns = [
        "185.12.64.1"
        "185.12.64.2"
      ];
      linkConfig.RequiredForOnline = "routable";
    };
  };
}