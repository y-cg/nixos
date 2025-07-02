{ isImage, ... }:
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

}

// (
  if isImage then
    {
      # Only apply sdImage configuration when building an image
      sdImage = {
        firmwareSize = 512; # 512MB instead of 30MB
      };
    }
  else
    { }
)
