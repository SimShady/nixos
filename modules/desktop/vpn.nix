{ pkgs, config, secrets, ... }:
let 
  vpnuser = "e12002084@student.tuwien.ac.at";
  vpnprotocol = "anyconnect";
  vpngateway = "vpn.tuwien.ac.at";
in {
  environment.systemPackages = with pkgs; [
    openconnect
  ];
  sops.secrets."tuwien/networkpass" = {
    sopsFile = ../../secrets/personal.yaml;
    restartUnits = [ "network.target" ];
  };

  services.netbird.clients.default = {
    port = 51820;
    name = "netbird";
    interface = "wt0";
    hardened = false;
    autoStart = false;
  };

  # TODO: try to find out how to automate vpn network password
  programs.bash.shellAliases = {
    "tu-up" = "sudo openconnect --protocol=${vpnprotocol} --user=${vpnuser} --authgroup=1_TU_getunnelt ${vpngateway}";
    "tuall-up" = "sudo openconnect --protocol=${vpnprotocol} --user=${vpnuser} --authgroup=2_Alles_getunnelt ${vpngateway}";
  };
}
