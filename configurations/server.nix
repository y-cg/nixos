{ inputs, ... }:
{
  meta = {
    system = "x86_64-linux";
    hostname = "vps";
    whoami = "ycg";
  };

  # https://nixos.wiki/wiki/NixOS_modules
  nixosModules = [
    ../specific/server
    ../home-manager
    ../system
  ];

}
