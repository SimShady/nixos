{ pkgs, ... }:{
  programs.ssh.enable = true;
  programs.ssh.matchBlocks = {
    "gitlab.tuwien.ac.at" = {
      identityFile = "/home/simon/.ssh/id_rsa_fstph";
    };
    "codeberg.org" = {
      identityFile = "/home/simon/.ssh/id_codeberg";
    };
    "*.stammtisch.wien" = {
      user = "simon";
      identityFile = "/home/simon/.ssh/id_stammtisch";
    };
    "server4.physprak.tuwien.ac.at" = {
      hostname = "server4.physprak.tuwien.ac.at";
      user = "babovic";
      extraOptions = {
        PubkeyAuthentication = "no";
      };
    };
    "stargate.fstph.htu.tuwien.ac.at" = {
      dynamicForwards = [
        {
          port = 12346;
        }
      ];
    };
    "bluefire.fstph.htu.tuwien.ac.at" = {
      dynamicForwards = [
        {
          port = 12345;
        }
      ];
    };
    "*.fstph.htu.tuwien.ac.at !cerberos.fstph.htu.tuwien.ac.at !forumalt.fstph.htu.tuwien.ac.at" = {
      user = "admin-simon";
      identityFile = "/home/simon/.ssh/id_rsa_fstph";
    };
    "*.fstph.htu.tuwien.ac.at !stargate.fstph.htu.tuwien.ac.at !bluefire.fstph.htu.tuwien.ac.at" = {
      proxyJump = "stargate.fstph.htu.tuwien.ac.at";
    };
    "cerberos.fstph.htu.tuwien.ac.at" = {
      user = "root";
      extraOptions = {
        PubkeyAuthentication = "no";
      };
    };
    "simon.airlab" = {
      user = "simon";
      identityFile = "/home/simon/.ssh/id_rsa_airlab";
      hostname = "simonbabovic01.airlab";
    };
    "minecraft.babovic.at" = {
      user = "root";
      identityFile = "/home/simon/.ssh/id_hetzner_private";
      hostname = "minecraft.babovic.at";
    };
    "babovic.at" = {
      user = "simon";
      identityFile = "/home/simon/.ssh/id_hetzner_private";
    };
    "deploybot.babovicat" = {
      user = "deploybot";
      identityFile = "/home/simon/.ssh/id_hetzner_deploybot";
      hostname = "babovic.at";
    };
    "simon.minecraft" = {
      user = "simon";
      identityFile = "/home/simon/.ssh/id_hetzner_private";
      hostname = "minecraft.babovic.at";
    };
    "github.com" = {
      identityFile = "/home/simon/.ssh/id_github_private";
    };
  };
}
