{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
    ./services/systemd.nix
    ./services/docker.nix
    ./services/acme.nix
    ./services/mysql.nix
    ./services/nginx.nix
    ./services/node-exporter.nix
    ./services/prometheus.nix
    ./services/grafana.nix
    ./services/matrix-continuwuity.nix
    ./services/maubot.nix
    ./services/roundcube.nix
    # ./services/mautrix-signal.nix
    ./web/babovic.nix
    ./web/playitloud.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "@wheel" ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "simon";
  networking.domain = "";
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  users.groups.deploybots = {};

  users.users.simon = {
    isNormalUser = true;
    home = "/home/simon";
    description = "Simon Babovic";
    extraGroups = ["wheel" "networkmanager" "docker"];
    openssh.authorizedKeys.keys = [''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDL2htIqQZr7zjGT/k357+sp7R4Bl2MNg0mkbGYHe4rWmPbHBU2WIGGqH7qZbmhjYBxnoXNO3I42hOiPonOf5O2ab58vogT7pmYqxor26la02cueZ34CtYcocpH8LCiyq9Ex5XJCUWpQ7FqLBML94/e+vpA3qMXIXkI8dk0/P439A6WpW6IFK/Ee2/+mpZjKzWcEvQK3ESuKx9/Igm/RnYBnKRlrPPQD/Bja47VVfFmeEbq1001ZyTSIGYE5uRls+Yb+HccNEXpm4l9VrZQu/VGc2WGguYaNZ7KpUignwDVhP3ldRNtOKMUOCwKmR8nJ+s9w6V0xWzIGjuaLwd/r/INHn8sdBiCK71HX1PngjkNkG51MHxoNnuNq2M3dmjozLOFt1xbAn7IECJF07QTEYnzOe1u7JTWJVfnVsc73LXYjMgD3bmb1EOu4Dj9ADt+eDkqgKoFusHvthdKiNtCSLFILZwV7/dedcRDZn7HffKhZp97jrxcY90RlfXC2hf3mF8='' ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDADlxD8+dzAXnSx0ZCzmvafEHLNHdM/MA8+g9rQN0SNAeEJX1xMEIUnbfhfExEKsd0/A9g59rsszKDSReoZEF5VTcrlW7uSxWfdcIYEeq/+/EdmO/kgrxpCRKcHAGouvDqdFUoG8JArTMMZs9+KNec9DS0kHgAqbbuELzFNxLds/hYuZmijXvSQK0YUf+rkGDC+se/rgWgbkGRK3qrChJzTodcK6FlCkX+pUDWsOOUsX8YoYhu7DDbvSCkNq/A3o9ZlD4xsSzQlQzzwy4822oBq0SWEpwREdfVIaYVOpNcsUUvLtVU/3D+OcZ3Q1s2w0XytOXwgJEpQjIfQ70tX3uAT0e+NgDDIzaA2gbZmNwEMCOB1QkHeE7Ir2CZmOgLBB7+JjF5hU1NNhg87ypdwiDqO1HnXaSpNlRisI5eZD1gHsSo5KyEaph3t1fmsJ1vVJj9ks5P8i1CMKrXRpabsDprZzTHBJEm6BVm0O1oPTxpafp4reNfAR9nRldYMr4Q4YM= simon@fedora'' ];
  };
  users.users.deploybot = {
    isNormalUser = true;
    home = "/home/deploybot";
    description = "Deployment bot user";
    extraGroups = ["deploybots" "docker"];
    openssh.authorizedKeys.keys = [''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCcHHdSlW111q58F3lGxwbPrqJ2fCMbL159ba8Hdi4uLwPBReIV0Hj6rkS6md3/Ngug1mbSI9wXrumgeN3YnIUMAZNA5oZJtglKc6+UtZ962uV2UtSTzvEz31GlejFADwpacnN0+K1cQfptMJ617GolWCcf0WSuQq0YxsA3Od7PzMRiJN2jp6kvPrKFIm92/6ksrKUKJ6HQFvuxdnqq5MbzG2wjfYONWUay4QbIrgykRzTga9hvaqSU3oi5O+V33XJkd5KxHNFSwixWk1N058sscP2wnBMKSIwoIcft8Xm0vEkJB+CKC+FzbvFg50xCkuzQtCtmwB9I2Y4v2j5ID+ZhDtUYGMIIBxfBcASgY4bA6Q3feJIdhGh3LtIm728oI6Glv6LsimHa6gBoyocz7kjb6eVaPX2faSeOkCKXnAi1P700CslH95Tf13+SWi2pDiTyVv5ZhBO2QIggqpDF1Ql4IzmJ9JkS5FqiesZp2RQpihci8jkA3/NX1fgn3RNCcdU= sbabovic@fedora''
    ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDOlE3IKE+1D4D7gW14QAoZ9xSJtrDq0nz88BMr0Pq9WXb6UGL8vggNhhTs7sikdZvU59kwUNR5/8AMMLi2TJbskgMhWjykXjvZq49jZ84t9niwjrUJnBZpsTyZbw4zNvn0PuqRYzfErNehgvBW1JTx3ZspEuuXrEpLejKK0tNLE7x1I1A0aaBj7EgJAHtheOr2OWukoUlTHYs/1CUKdlDkJJrKB0xgu9BdWcRtbX/SV6epXjjrIqrP5Kg8X66Q2NY2I5ZpslgsmZa8hj5VPurkL4wwRrs8UfSh/9bg6LwmgHkR+AAoHnIehgKAFGw0pZsUSFVg5DwSTXtqe9fiwBy9Gx6alMK2uy7KCueyENA0sKpSAdSy0LotxMQXF+Rli7YMPA2clQWUgVgb78SSu0dWUgltiVL9F9TmOMOwp5qt21dxzsIGB3Vo1aRbfJyVbl0kiSlbe7E2NL7CueuMM4dnGMHIVkdtFS0f6bq5BCb9flFAQ27nH7X2Paat/2kSh970/pHJ8gSRPvyPpdvraZyMpKRokF2PdEuJK8GoueSnv4/0vIYesvbzq7u2MMc+ya4Vvyo1IbReVls4v8rqTA1f7sUfhxcRzeQOAgdNv7hBcLpMWRoyp3vljpJARUp8sgTvaY6a3WlIoRvvgner2sUvXaijSsmhOUQ4S4pRJpmMLw== simon@matebook''];
  };
  users.mutableUsers = false;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };

  programs.bash.shellAliases = {
    l = "ls -alh";
    ll = "ls -la";
    ls = "ls --color=tty";
  };

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
  };

  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  system.stateVersion = "23.11";
}
