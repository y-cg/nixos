{ inputs, ... }:
{
  imports = [
    inputs.agenix.nixosModules.default
    ./secrets.nix
  ];
}
