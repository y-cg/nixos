{ nixpkgs, ... }:
{
  imports = [
    {
      nixpkgs.overlays = [
        (import ./cacert.nix)
      ];
    }
  ];
}
