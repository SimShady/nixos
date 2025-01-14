{ pkgs, ... }:{
  programs.ssh.enable = true;
  programs.ssh.matchBlocks = {
    "server4.physprak.tuwien.ac.at" = {
      hostname = "server4.physprak.tuwien.ac.at";
      user = "babovic";
      extraOptions = {
        PubkeyAuthentication = "no";
      };
    };
    "*.fstph.htu.tuwien.ac.at" = {
      user = "admin-simon";
      identityFile = "/home/simon/.ssh/id_rsa_fstph";
    };
    "*.fstph.htu.tuwien.ac.at !stargate.fstph.htu.tuwien.ac.at" = {
      proxyJump = "stargate.fstph.htu.tuwien.ac.at";
    };
    "forumalt.fstph.htu.tuwien.ac.at" = {
      user = "root";
    };
    "simon.airlab" = {
      user = "simon";
      identityFile = "/home/simon/.ssh/id_rsa_airlab";
      hostname = "simonbabovic01.airlab";
    };
    "simon.babovicat" = {
      user = "simon";
      identityFile = "/home/simon/.ssh/id_hetzner_private";
      hostname = "babovic.at";
    };
    "deploybot.babovicat" = {
      user = "deploybot";
      identityFile = "/home/simon/.ssh/id_hetzner_deploybot";
      hostname = "babovic.at";
    };
    "minecraft.babovic.at" = {
      user = "root";
      identityFile = "/home/simon/.ssh/id_hetzner_private";
      hostname = "minecraft.babovic.at";
    };
    "simon.nandevelopment" = {
      user = "simon";
      identityFile = "/home/simon/.ssh/id_nandevelopment";
      hostname = "nan-development.com";
    };
    "simon.bbo" = {
      user = "simon";
      identityFile = "/home/simon/.ssh/id_nandevelopment";
      hostname = "49.13.234.145";
    };
    "pixel.eurojumbo.at" = {
      user = "simon";
      identityFile = "/home/simon/.ssh/id_hetzner_private";
    };
    "github.com" = {
      identityFile = "/home/simon/.ssh/id_github_private";
    };
  };
}
