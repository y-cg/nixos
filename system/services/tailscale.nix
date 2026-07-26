{ pkgs-unstable, ... }:
{
  services.tailscale = {
    enable = false; # bug, enable later
    package = pkgs-unstable.tailscale;
    authKeyFile = "/etc/tailscale/key";
    openFirewall = true;
  };
}
