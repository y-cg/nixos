{ lib, ... }:
{
  fileSystems."/" = {
    device = lib.mkDefault "/dev/sda1";
    fsType = lib.mkDefault "ext4"; # or whatever your filesystem type is
  };
}
