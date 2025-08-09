{
  config,
  pkgs,
  hostname,
  ...
}:

{
  imports = [
    ./services
    ./system
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    cacert
  ];

}
