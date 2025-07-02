{ pkgs, lib, ... }:
{
  boot.loader.grub.enable = false;

  # Disable due to the evaluation error:
  # See: https://github.com/NixOS/nixpkgs/issues/154163
  # boot.kernelPackages = pkgs.linuxPackages_rpi4;

  # This fix the problem that rpi fail to reconnect to wifi after reboot in a fresh nixos-rebuild
  # See https://github.com/Robertof/nixos-docker-sd-image-builder/issues/10#issuecomment-646901392
  hardware.enableRedistributableFirmware = true; # Includes wifi kernel modules.
}
