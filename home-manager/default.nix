{ inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.ycg = ./home.nix;
      };
      # Optionally, use home-manager.extraSpecialArgs to pass
      # arguments to home.nix
    }
    ./auth.nix
  ];
}
