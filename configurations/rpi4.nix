{ inputs, ... }:
{
  meta = {
    system = "aarch64-linux";
    hostname = "rpi";
    whoami = "ycg";
  };

  # https://nixos.wiki/wiki/NixOS_modules
  nixosModules = [
    ../specific/rpi4
    ../system
    inputs.nixos-raspberrypi.nixosModules.sd-image
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-4.base
  ];

  homeManagerModules = [
    ../homeManagerModules
  ];

  extraSpecialArgs = {
    nixos-raspberrypi = inputs.nixos-raspberrypi;
  };

  f = inputs.nixos-raspberrypi.lib.nixosSystem;

}
