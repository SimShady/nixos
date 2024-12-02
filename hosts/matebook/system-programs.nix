{ pkgs, ...}:{
  environment.systemPackages = with pkgs; [
   (mathematica.override {
    source = pkgs.requireFile {
      name = "Mathematica_13.3.1_LINUX.sh";
      sha256 = "1xl6ji8qg6bfz4z72b8czl0cx36fzfkxhygsn0m8xd0qgkkpjqfg";
      message = ''
        Your override for Mathematica includes a different src for the installer,
        and it is missing.
      '';
      hashMode = "recursive";
    };
   })
  ];

  #programs.steam = {
  #  enable = true;
  #  dedicatedServer.openFirewall = true;
  #};
}
