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

  # make sure the ca cert up to date
  security.pki.certificateFiles = [ "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken.
  system.stateVersion = "24.11";
}
