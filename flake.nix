{
  description = "YCG's NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    {

      # rpi config
      nixosConfigurations.rpi = nixpkgs.lib.nixosSystem {

        system = "aarch64-linux";

        specialArgs = {
          hostname = "rpi";
        };

        modules = [
          # https://nixos.wiki/wiki/NixOS_modules
          ./configuration.nix
        ];
      };
    };
}
