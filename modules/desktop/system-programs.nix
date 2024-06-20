{ pkgs, ... }:{
  environment.systemPackages = with pkgs; [
    vesktop
    docker
    element-desktop
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        jnoortheen.nix-ide
        vscode-icons-team.vscode-icons
        james-yu.latex-workshop
      ];
    })
  ];
  virtualisation.docker.enable = true;

  programs.firefox.enable = true;
  
  programs.ssh = {
    startAgent = true;
  };

  programs.bash.shellAliases = {
    l = "ls -alh";
    ll = "ls -la";
    ls = "ls --color=tty";
    code = "codium";
  };
}
