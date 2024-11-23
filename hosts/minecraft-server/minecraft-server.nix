{ pkgs, lib, ... }:
{
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers = {
      simons-server = {
        enable = true;
        package = pkgs.fabricServers.fabric-1_21_3;
        serverProperties = {
          gamemode = "survival";
          difficulty = "normal";
          simulation-distance = 10;
          level-seed = "2335344234";
        };

        symlinks =
        let
          modpack = (pkgs.fetchPackwizModpack {
            url = "https://github.com/Misterio77/Modpack/raw/0.2.9/pack.toml";
            packHash = "sha256-L5RiSktqtSQBDecVfGj1iDaXV+E90zrNEcf4jtsg+wk=";
          });
        in {
          # Modpack example
          # "mods" = "${modpack}/mods";

          # Directories
          # "mods" = ./mods;
          

          # Fetching from the internet
          "mods" = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
            FabricAPI = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/Xhw2LuSh/fabric-api-0.109.0%2B1.21.3.jar"; sha512 = "sha512-3s/LzEzJdIuYIqXgs02tqeFFS798DrHU4BTbJD6O66okCgWkjBvN4jLd7PFQaS/ilfm7FHeUyGHkLSytZhGWVw=="; };
          });
        };
      };
    };
  };
}