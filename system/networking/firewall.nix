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
      # docker related
      "docker0"
      "br-+" # docker bridge start with `br-`
    ];
    checkReversePath = false;
  };
}
