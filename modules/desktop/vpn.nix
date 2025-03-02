{ pkgs, config, ... }:{
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
    "tu-down" = "sudo systemctl stop openconnect-tuwien.service";
    "tu-up" = "sudo systemctl stop openconnect-tuwien-all.service && sudo systemctl start openconnect-tuwien.service";
    "tuall-down" = "sudo systemctl stop openconnect-tuwien-all.service";
    "tuall-up" = "sudo systemctl stop openconnect-tuwien.service && sudo systemctl start openconnect-tuwien-all.service";
  };
}
