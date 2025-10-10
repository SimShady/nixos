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
        ms-vscode.cpptools-extension-pack
        reditorsupport.r
        reditorsupport.r-syntax
      ];
    })
    postman
    gnome-boxes
    gcc_multi
    gnumake
    openssl
    android-studio
    gcolor3
    adoptopenjdk-icedtea-web
    jdk
    ipmiview
  ];

  environment.variables = {
    JAVA_HOME = "${pkgs.jdk}/lib/openjdk";
  };

  virtualisation.docker.enable = true;

  programs.firefox.enable = true;

  programs.direnv.enable = true;
  
  programs.ssh = {
    startAgent = true;
  };
  services.gnome.gcr-ssh-agent.enable = false;

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

  programs.proxychains = {
    enable = true;
    proxies.snail = {
      enable = true;
      type = "socks5";
      host = "127.0.0.1";
      port = 12347;
    };
  };
}
