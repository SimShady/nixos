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
        rust-lang.rust-analyzer
        vadimcn.vscode-lldb
        mechatroner.rainbow-csv
        grapecity.gc-excelviewer
        prisma.prisma
        hashicorp.terraform
        # custom vscode extensions
        # custom-vscode-extensions.magicstack.magicpython
      ];
    })
    postman
    gnome-boxes
    gcc_multi
    gnumake
    rustc
    cargo
    openssl
    (python311.withPackages (python-pkgs: with python-pkgs; [
      # pip
      matplotlib
      pylatexenc
      # custom python packages
      # custom-python.scikit-network
      # custom-python.qiskit
    ]))
    nodejs_22
    android-studio
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
