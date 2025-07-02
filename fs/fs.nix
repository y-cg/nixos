{ lib, ... }:
{
  fileSystems."/" = {
    device = lib.mkDefault "/dev/disk/by-label/NIXOS_SD";
    fsType = lib.mkDefault "ext4"; # or whatever your filesystem type is
  };
}
