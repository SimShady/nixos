{ pkgs, config, ... }:{
  # networking.firewall = {
  #   allowedUDPPorts = [ 51820 ];
  # };
  # networking.wg-quick.interfaces = {
  #   airlab = {
  #     autostart = false;
  #     address = [ "172.17.0.35/24" ];
  #     dns = [ "172.16.0.1" ];
  #     mtu = 1420;
  #     privateKeyFile = "/home/simon/vpn-keys/airlab/private";

  #     peers = [{
  #       publicKey = "IJyjCwYBeEglglA77zZNfaOthB8Gpyy2TnwVw39Pj2k=";
  #       presharedKeyFile = "/home/simon/vpn-keys/airlab/preshared";
  #       allowedIPs = [
  #         "0.0.0.0/0"
  #         #"::/0" # TODO: Make IPV6 work
  #       ];
  #       persistentKeepalive = 0;
  #       endpoint = "vpn.robo4you.at:51820";
  #     }];
  #   };
  # };

  # systemd.network = {
  #   enable = true;
  #   netdevs = {
  #     airlab = {
  #       netdevConfig = {
  #         Kind = "wireguard";
  #         Name = "airlab";
  #         Description = "Wireguard device config for airlab vpn";
  #         MTUBytes = "1420";
  #       };
  #       wireguardConfig.PrivateKeyFile = "/home/simon/vpn-keys/airlab/private";
  #       wireguardPeers = [{
  #         PublicKey = "IJyjCwYBeEglglA77zZNfaOthB8Gpyy2TnwVw39Pj2k=";
  #         PresharedKeyFile = "/home/simon/vpn-keys/airlab/preshared";
  #         AllowedIPs = [ "0.0.0.0/0" "::/0" ];
  #         Endpoint = "vpn.robo4you.at:51820";
  #       }];
  #     };
  #   };
  #   networks = {
  #     airlab = {
  #       address = [ "172.17.0.35/24" ];
  #       dns = [ "172.16.0.1" ];
  #       linkConfig.ActivationPolicy = "manual";
  #       name = "airlab";
        
  #       networkConfig = {
  #         Description = "Wireguard network config for airlab vpn";
  #         DNSOverTLS = "opportunistic";
  #       };
  #     };
  #   };
  # };

  sops.secrets."tuwien/networkpass" = {
    sopsFile = ../../secrets/personal.yaml;
    restartUnits = [ "network.target" ];
  };

  networking.openconnect = {
    package = pkgs.openconnect;
    interfaces = {
      tuwien = {
        autoStart = false;
        gateway = "vpn.tuwien.ac.at";
        passwordFile = config.sops.secrets."tuwien/networkpass".path;
        protocol = "anyconnect";
        user = "e12002084@student.tuwien.ac.at";
        extraOptions = {
          authgroup = "1_TU_getunnelt";
        };
      };
      tuwien-all = {
        autoStart = false;
        gateway = "vpn.tuwien.ac.at";
        passwordFile = config.sops.secrets."tuwien/networkpass".path;
        protocol = "anyconnect";
        user = "e12002084@student.tuwien.ac.at";
        extraOptions = {
          authgroup = "2_Alles_getunnelt";
        };
      };
    };
  };

  programs.bash.shellAliases = {
    # "airlab-up" = "sudo systemctl start wg-quick-airlab.service";
    # "airlab-down" = "sudo systemctl stop wg-quick-airlab.service";
    "tu-down" = "sudo systemctl stop openconnect-tuwien.service";
    "tu-up" = "sudo systemctl stop openconnect-tuwien-all.service && sudo systemctl start openconnect-tuwien.service";
    "tuall-down" = "sudo systemctl stop openconnect-tuwien-all.service";
    "tuall-up" = "sudo systemctl stop openconnect-tuwien.service && sudo systemctl start openconnect-tuwien-all.service";
  };
}
