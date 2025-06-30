{
  description = "YCG's NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      mkNixosConfig =
        { system, hostname }:

        nixpkgs.lib.nixosSystem {

          inherit system;

          specialArgs = {
            inherit hostname;
          };

          modules = [
            # https://nixos.wiki/wiki/NixOS_modules
            ./configuration.nix
          ];
        };
    in
    {
      # rpi config
      nixosConfigurations.rpi = mkNixosConfig {
        system = "aarch64-linux";
        hostname = "rpi";
      };
      # vps config
      nixosConfigurations.vps = mkNixosConfig {
        system = "x86_64-linux";
        hostname = "vps";
      };
    };
}
