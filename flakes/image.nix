{ self, ... }:
{
  systems = [ "aarch64-linux" ];
  perSystem =
    {
      ...
    }:
    let
      nixos = self.nixosConfigurations;
      mkImage = nixosConfig: nixosConfig.config.system.build.sdImage;
    in
    {
      packages.rpi4-image = mkImage nixos.rpi;
    };
}
