{
  systems = [ ];
  flake =
    { ... }:
    {
      homeManagerModules.default = import ../homeManagerModules/default.nix;
    };
}
