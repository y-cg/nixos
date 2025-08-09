{
  description = "YCG's NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nvchad-starter.follows = "nvchad-config";
    };
    nvchad-config = {
      url = "github:y-cg/nvchad";
      flake = false;
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
      nixpkgs-unstable,
      home-manager,
      agenix,
      nixos-raspberrypi,
      nixos-wsl,
      disko,
      nix4nvchad,
      nvchad-config,
      ...
    }:
    let
      mkNixosSystem =
        {
          meta,
          nixosModules,
          extraSpecialArgs ? { },
          f ? nixpkgs.lib.nixosSystem,
          ...
        }:
        f {
          system = meta.system;
          specialArgs = {
            inherit inputs;
            inherit nixpkgs-unstable;
            extra = meta;
          } // extraSpecialArgs;
          modules = nixosModules;
        };
    in
    {
      # rpi config
      nixosConfigurations.rpi = mkNixosSystem (import ./configurations/rpi4.nix { inherit inputs; });
      # vps config
      nixosConfigurations.vps = mkNixosSystem (import ./configurations/server.nix { inherit inputs; });
      # wsl config
      nixosConfigurations.wsl = mkNixosSystem (import ./configurations/wsl.nix { inherit inputs; });

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
