{ inputs, meta, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users."${meta.whoami}" = ./home.nix;
        extraSpecialArgs = {
          inherit inputs meta;
        };
      };
      # Optionally, use home-manager.extraSpecialArgs to pass
      # arguments to home.nix
    }
    ./me.nix
  ];
}
