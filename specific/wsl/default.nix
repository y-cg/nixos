{ inputs, extra, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    {
      wsl = {
        enable = true;
        defaultUser = extra.whoami;
      };
    }
  ];
}
