{ pkgs, ... }:{
  environment.systemPackages = with pkgs; [
    vesktop
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
        # custom vscode extensions
        # custom-vscode-extensions.magicstack.magicpython
      ];
    })
    gnome.gnome-boxes
    gcc_multi
    rustc
    cargo
    (python311.withPackages (python-pkgs: with python-pkgs; [
      pip
      matplotlib
      pylatexenc
      # custom python packages
      custom-python.scikit-network
      custom-python.qiskit
    ]))
  ];

  environment.variables = {
    # For numpy to work in python envs
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  };

  virtualisation.docker.enable = true;

  programs.firefox.enable = true;
  
  programs.ssh = {
    startAgent = true;
  };

  programs.bash.shellAliases = {
    l = "ls -alh";
    ll = "ls -la";
    ls = "ls --color=tty";
  };

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
