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
        users."${whoami}" = {
          imports = homeManagerModules;
        };
        inherit extraSpecialArgs;
      };
    }
  ];
}
