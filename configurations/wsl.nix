{ inputs, ... }:
{
  meta = {
    system = "x86_64-linux";
    hostname = "wsl";
    whoami = "ycg";
  };

  # https://nixos.wiki/wiki/NixOS_modules
  nixosModules = [
    ../specific/wsl
    ../home-manager
    ../overlays
    ../system
  ];

}
