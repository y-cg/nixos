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
  ];

  # Enable SSH
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken.
  system.stateVersion = "24.11";
}
