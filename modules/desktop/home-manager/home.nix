{ config, pkgs, ... }:{
  programs.home-manager.enable = true;

  home.username = "simon";
  home.homeDirectory = "/home/simon";

  home.packages = with pkgs; [
    texlive.combined.scheme-full
  ];

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
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

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      source ~/.nix-profile/share/git/contrib/completion/git-prompt.sh
      PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\] @ \[\033[0;36m\]\h \w\[\033[0;32m\]$(__git_ps1)\n\[\033[0;32m\]└─\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\] ▶\[\033[0m\] '
    '';
  };

  home.stateVersion = "24.05";
}