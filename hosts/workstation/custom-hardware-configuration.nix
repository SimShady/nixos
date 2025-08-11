{ config, pkgs, inputs, ... }:{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      libva
      libvdpau-va-gl
      vulkan-loader
      vulkan-validation-layers
      amdvlk
      mesa.opencl
    ];
  };

  services.xserver.videoDrivers = ["amdgpu"];
  services.dbus.enable = true;

  programs.hyprland.enable = true;
}