{
  fileSystems = {
    # There is no U-Boot on the Pi 4 (yet) -- the firmware partition has to be mounted as /boot.
    "/boot" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  sdImage = {
    firmwareSize = 512; # 256MB instead of 30MB
  };
}
