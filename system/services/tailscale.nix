{ pkgs-unstable, ... }:
{
  services.tailscale = {
    enable = true;
    package = pkgs-unstable.tailscale;
    authKeyFile = "/etc/tailscale/key";
    openFirewall = true;
  };
}
