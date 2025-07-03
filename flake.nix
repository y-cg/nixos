{
  description = "YCG's NixOS";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # Pin nixpkgs version because devenv fail to build
    # See: https://github.com/nixos/nixpkgs/issues/420134
    nixpkgs.url = "github:NixOS/nixpkgs/?rev=8f49bca3dc47f48ef46511613450364fd82b0b36";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi/main";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      agenix,
      nixos-raspberrypi,
      ...
    }:
    let
      defaultModules = [
        # https://nixos.wiki/wiki/NixOS_modules
        ./configuration.nix
        ./home-manager
        ./overlays
      ];
      rpi4Modules = [
        ./specific/rpi4
        nixos-raspberrypi.nixosModules.raspberry-pi-4.base
        nixos-raspberrypi.nixosModules.sd-image
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
      nixosConfigurations.rpi = nixos-raspberrypi.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          extra = mkExtraConfig {
            system = "aarch64-linux";
            hostname = "rpi";
          };
          inherit inputs;
          inherit nixos-raspberrypi;
        };
        modules = defaultModules ++ rpi4Modules;
      };
      # vps config
      nixosConfigurations.vps = mkNixosConfig {
        extra = mkExtraConfig {
          system = "x86_64-linux";
          hostname = "vps";
        };
      };
      # rpi4 image
      images =
        let
          nixos = self.nixosConfigurations;
          mkImage = nixosConfig: nixosConfig.config.system.build.sdImage;
        in
        {
          rpi4 = mkImage nixos."rpi";
        };
    };
}
