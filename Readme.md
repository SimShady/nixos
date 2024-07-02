## Apply configuration for workstation/notebook
```
sudo nixos-rebuild switch --flake .#workstation
```
```
sudo nixos-rebuild switch --flake .#notebook
```

## Apply configuration for babovic.at
```
sudo nix run .#apps.nixinate.babovicat
```