
({ ... }: {
  fileSystems = {
    "/boot/firmware" = {
      device = "/dev/disk/by-uuid/6746-792F";
      fsType = "vfat";
      options = [
        "noatime"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=1min"
      ];
    };
    "/" = {
      device = "/dev/disk/by-uuid/18604e4f-3c80-471d-9a28-9c51952d808a";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };
  swapDevices = [
    { device = "/dev/disk/by-uuid/69f241f8-e6c5-40e6-92de-4519e5c09bb4"; }
  ];
})