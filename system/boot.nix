{
  boot.loader.grub.enable = false;

  # This fix the problem that rpi fail to reconnect to wifi after reboot in a fresh nixos-rebuild
  # See https://github.com/Robertof/nixos-docker-sd-image-builder/issues/10#issuecomment-646901392
  hardware.enableRedistributableFirmware = true; # Includes wifi kernel modules.
}
