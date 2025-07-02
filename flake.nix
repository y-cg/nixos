{
  description = "YCG's NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-generators,
      home-manager,
      agenix,
      ...
    }:
    let
      modules = [
        # https://nixos.wiki/wiki/NixOS_modules
        ./configuration.nix
        ./home-manager
        ./overlays
      ];
      mkNixosConfig =
        { system, hostname }:

        nixpkgs.lib.nixosSystem {

          inherit system;

          specialArgs = {
            inherit hostname;
            inherit system;
            inherit inputs;
          };

          modules = modules;
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
      # rpi4 image
      packages.aarch64-linux.rpi4-sdcard = nixos-generators.nixosGenerate {
        system = "aarch64-linux";
        specialArgs = {
          hostname = "rpi";
          system = "aarch64-linux";
          inherit inputs;
        };
        modules = modules;
        format = "sd-aarch64";
      };
    };
}
