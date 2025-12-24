{
  services.tailscale = {
    enable = true;
    authKeyFile = "/etc/tailscale/key";
    openFirewall = true;
  };
}
