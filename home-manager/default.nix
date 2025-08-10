{ inputs, extra, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users."${extra.whoami}" = ./home.nix;
        extraSpecialArgs = {
          inherit inputs;
          inherit extra;
        };
      };
      # Optionally, use home-manager.extraSpecialArgs to pass
      # arguments to home.nix
    }
    ./me.nix
  ];
}
