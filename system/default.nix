{
  imports = [
    ./time.nix
    ./nix.nix
    ./general.nix
    ./packages.nix
    ./networking
    ./services
    ./users.nix
    ./boot.nix
    ./fs.nix
    ./bluetooth.nix
    ../selfhost
  ];
}
