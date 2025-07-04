{
  config,
  pkgs,
  hostname,
  ...
}:

{
  imports = [
    ./fs
    ./networking
    ./utils
    ./services
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    cacert
  ];

  # Run unpatched dynamic binaries on NixOS.
  programs.nix-ld.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken.
  system.stateVersion = "25.05";
}
