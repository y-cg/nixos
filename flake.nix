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
      defaultModules = [
        # https://nixos.wiki/wiki/NixOS_modules
        ./configuration.nix
        ./home-manager
        ./overlays
      ];
      mkExtraConfig =
        {
          system,
          hostname,
          extraModules ? [ ],
          isImage ? false,
        }:
        {
          inherit system;
          inherit hostname;
          inherit extraModules;
          inherit isImage;
        };
      mkNixosConfig =
        { extra }:
        nixpkgs.lib.nixosSystem {
          system = extra.system;
          specialArgs = {
            inherit inputs;
            inherit extra;
          };
          modules = defaultModules ++ extra.extraModules;
        };
    in
    {
      # rpi config
      nixosConfigurations.rpi = mkNixosConfig {
        extra = mkExtraConfig {
          system = "aarch64-linux";
          hostname = "rpi";
          extraModules = [ ./specific/rpi4 ];
        };
      };
      # vps config
      nixosConfigurations.vps = mkNixosConfig {
        extra = mkExtraConfig {
          system = "x86_64-linux";
          hostname = "vps";
        };
      };
      # rpi4 image
      packages.aarch64-linux.rpi4-sdcard = nixos-generators.nixosGenerate {
        system = "aarch64-linux";
        specialArgs = {
          extra = mkExtraConfig {
            system = "aarch64-linux";
            hostname = "rpi";
            isImage = true;
          };
          inherit inputs;
        };
        modules = defaultModules ++ [ ./specific/rpi4 ];
        format = "sd-aarch64";
      };
    };
}
