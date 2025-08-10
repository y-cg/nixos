{ inputs, meta, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    {
      wsl = {
        enable = true;
        defaultUser = meta.whoami;
      };
    }
  ];
}
