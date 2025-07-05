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
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
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
      nixos-wsl,
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
      mkNixosConfig =
        {
          system,
          hostname,
          extraModules ? [ ],
          extraSpecialArgs ? { },
          isImage ? false,
        }:
        {
          inherit system;
          specialArgs = {
            inherit inputs;
            extra = {
              inherit system;
              inherit hostname;
              inherit isImage;
            };
          } // extraSpecialArgs;
          modules = defaultModules ++ extraModules;
        };
    in
    {
      # rpi config
      nixosConfigurations.rpi = nixos-raspberrypi.lib.nixosSystem (mkNixosConfig {
        system = "aarch64-linux";
        hostname = "rpi";
        extraModules = rpi4Modules;
        extraSpecialArgs = { inherit nixos-raspberrypi; };
      });
      # vps config
      nixosConfigurations.vps = nixpkgs.lib.nixosSystem (mkNixosConfig {
        system = "x86_64-linux";
        hostname = "vps";
        extraModules = [ ./specific/server ];
      });
      nixosConfigurations.wsl = nixpkgs.lib.nixosSystem (mkNixosConfig {
        system = "x86_64-linux";
        hostname = "wsl";
        extraModules = [ ./specific/wsl ];
      });
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
