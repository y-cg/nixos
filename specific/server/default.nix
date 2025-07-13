{ inputs, ... }:
{
  imports = [
    ./boot.nix
    inputs.disko.nixosModules.disko
    ./disk.nix
  ];
}
