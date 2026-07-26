{
  inputs,
  ...
}:
let
  lib = import ../lib;
  inherit (inputs) nixpkgs nixpkgs-unstable;
  mkNixosSystem =
    {
      meta,
      nixosModules,
      homeManagerModules,
      extraSpecialArgs ? { },
      f ? nixpkgs.lib.nixosSystem,
      ...
    }:
    let
      # paho-mqtt tests are flaky (esp. on aarch64); disable so HA/xiaomi_home
      # can build. See https://github.com/NixOS/nixpkgs/issues/542586
      pkgs-unstable = import nixpkgs-unstable {
        system = meta.system;
        config.allowUnfree = true;
        overlays = [
          (final: prev: {
            pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
              (pyfinal: pyprev: {
                paho-mqtt = pyprev.paho-mqtt.overridePythonAttrs (_: {
                  doCheck = false;
                });
              })
            ];
          })
        ];
      };
      specialArgs = {
        inherit
          inputs
          nixpkgs-unstable
          pkgs-unstable
          meta
          ;
      }
      // extraSpecialArgs;
      homeManagerInjection = lib.injectHomeManager {
        inherit (meta) whoami;
        inherit homeManagerModules;
        extraSpecialArgs = specialArgs;
      };
    in
    f {
      inherit (meta) system;
      inherit specialArgs;
      modules = nixosModules ++ [
        inputs.home-manager.nixosModules.default
        homeManagerInjection
      ];
    };
in
{
  systems = [ ];
  flake =
    { ... }:
    {
      nixosConfigurations = {
        rpi = mkNixosSystem (import ../configurations/rpi4.nix { inherit inputs; });
      };
    };
}
