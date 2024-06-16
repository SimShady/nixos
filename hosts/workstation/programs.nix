{ pkgs, ... }:{
  environment.systemPackages = with pkgs; [
    vesktop
    docker
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        jnoortheen.nix-ide
        vscode-icons-team.vscode-icons      
      ];
    })
  ];
  virtualisation.docker.enable = true;

  programs.firefox.enable = true;
  
  programs.ssh = {
    startAgent = true;
  };
}
