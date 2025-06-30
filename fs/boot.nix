{ lib, ... }:
{
  boot.loader = {
    # assuming we use arm single board computer
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };
}
