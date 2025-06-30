{ inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.ycg = ./home.nix;
      # Optionally, use home-manager.extraSpecialArgs to pass
      # arguments to home.nix
    }
    ./auth.nix
  ];
}
