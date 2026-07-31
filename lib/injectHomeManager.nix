# turn home-manager modules to nixos modules
{
  whoami,
  homeManagerModules,
  extraSpecialArgs,
}:
{
  imports = [
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        users."${whoami}" = {
          imports = homeManagerModules;
        };
        inherit extraSpecialArgs;
      };
    }
  ];
}
