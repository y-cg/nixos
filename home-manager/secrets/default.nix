{ inputs, ... }:
{
  imports = [
    inputs.agenix.homeManagerModules.default
    ./secrets.nix
  ];
}
