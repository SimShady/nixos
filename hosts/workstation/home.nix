{ config, pkgs, ... }:
{
  imports = [
    ./ssh.nix
  ];
  home.username = "simon";
  home.homeDirectory = "/home/simon";

  home.stateVersion = "24.05";

  home.packages = [
    
  ];

  home.file = {

  };

  home.sessionVariables = {
    XDG_DATA_DIRS="/home/simon/.nix-profile/share:$XDG_DATA_DIRS";
  };

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    lfs.enable = true;
    extraConfig = {
      user.name = "Simon Babovic";
      user.email = "simon@babovic.at";
      format.signoff = true;
      init.defaultBranch = "main";
      pull.rebase = true;
      rebase.autoStash = true;
      merge.conflictStyle = "diff3";
      advice.skippedCherryPicks = false;
    };
  };
}
