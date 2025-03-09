{ pkgs, ... }:{
  environment.systemPackages = with pkgs; [
    age
    sops
    vesktop
    zoom-us
    docker
    element-desktop
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        jnoortheen.nix-ide
        vscode-icons-team.vscode-icons
        james-yu.latex-workshop
        ms-python.python
        ms-python.vscode-pylance
        vadimcn.vscode-lldb
        mechatroner.rainbow-csv
        grapecity.gc-excelviewer
        prisma.prisma
        hashicorp.terraform
      ];
    })
    postman
    gnome-boxes
    gcc_multi
    gnumake
    openssl
    android-studio
    gcolor3
  ];

  environment.variables = {
    # Only applies after restart
  };

  virtualisation.docker.enable = true;

  programs.firefox.enable = true;

  programs.direnv.enable = true;
  
  programs.ssh = {
    startAgent = true;
  };

  programs.bash.shellAliases = {
    l = "ls -alh";
    ll = "ls -la";
    ls = "ls --color=tty";
  };

  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = ["simon"];

  virtualisation.spiceUSBRedirection.enable = true;

  users.users.simon.extraGroups = [ "libvirtd" ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };
}
