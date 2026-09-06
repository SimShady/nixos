{ pkgs, ...}:{
  environment.systemPackages = with pkgs; [
    prismlauncher
  ];

  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
  };
}
