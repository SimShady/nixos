{ pkgs, ...}:{
  environment.systemPackages = with pkgs; [
   (mathematica.override {
     version = "12.1.1";
     lang = "en";
     webdoc = true;
   })
  ];

  #programs.steam = {
  #  enable = true;
  #  dedicatedServer.openFirewall = true;
  #};
}
