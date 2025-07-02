{ ... }:
{
  networking.firewall = {
    enable = true;
    # make sure mihomo won't be blocked
    # https://blog.nyaw.xyz/nixos-inwall-install
    trustedInterfaces = [
      # common interface name used by mihomo
      "Meta"
      "Mihomo"
      "utun0"
    ];
    checkReversePath = false;
  };
}
