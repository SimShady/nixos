## Apply configuration for workstation/matebook
```
sudo nixos-rebuild switch --flake .#workstation
```
```
sudo nixos-rebuild switch --flake .#matebook
```

## Apply configuration for babovic.at
```
sudo nix run .#apps.nixinate.babovicat
```
