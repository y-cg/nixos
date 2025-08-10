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
    ../home-manager
    ../system
    inputs.nixos-raspberrypi.nixosModules.sd-image
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-4.base
  ];

  extraSpecialArgs = {
    nixos-raspberrypi = inputs.nixos-raspberrypi;
  };

  f = inputs.nixos-raspberrypi.lib.nixosSystem;

}
