{ pkgs, ...}:{
  environment.systemPackages = with pkgs; [
   (mathematica.override {
    source = pkgs.requireFile {
      # nix-store --query --hash $(nix store add-path Mathematica_13.3.1_LINUX.sh --name 'Mathematica_13.3.1_LINUX.sh')
      # maybe use nix-store --add-root <some_path_here_for_symlink> --indirect --realise /nix/store/...
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
}
