{ pkgs, ...}:{
  environment.systemPackages = with pkgs; [
    (mathematica.override {
    source = pkgs.requireFile {
      # nix-store --add-root <symlink> --indirect --realise $(nix store add-path Mathematica_13.3.1_LINUX.sh --name 'Mathematica_12.3.1_LINUX.sh')
      name = "Mathematica_12.3.1_LINUX.sh";
      sha256 = "1yfd287kv46a1qr53kdnshl0qb868hyl44mh1r1kl4k90x6kdqnc";
      message = ''
        Your override for Mathematica includes a different src for the installer,
        and it is missing.
      '';
      hashMode = "recursive";
    };
   })
    prismlauncher
    r2modman
    # For Davinci Resolve
    kitty
    mesa-demos
    vulkan-tools
    clinfo
    davinci-resolve
  ];

  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
  };
}