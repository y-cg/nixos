{ inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.ycg = ./home.nix;
      # Optionally, use home-manager.extraSpecialArgs to pass
      # arguments to home.nix
    }
    # setup user group
    {
      users.users.ycg = {
        isSystemUser = true;
        extraGroups = [ "wheel" ]; # Allow sudo access
        group = "ycg";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHl4c+mtLFx/KtE1OefdP706E/HEbV4+xraGGcxRo6vl"
        ];
      };
      users.groups.ycg = { };
    }
  ];
}
