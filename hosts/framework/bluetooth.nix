{...}:
{
  # Bluetooth aktivieren
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;  # für neue Codecs wie aptX/LDAC, optional
  };

  services.blueman.enable = true;  # GUI-Applet, wenn du eine Desktop-Umgebung nutzt

  # Firmware (wichtig beim Framework, sonst läuft der Intel-Bluetooth-Chip evtl. nicht)
  hardware.enableRedistributableFirmware = true;
}