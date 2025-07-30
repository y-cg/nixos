{ lib, ... }:
{
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
  services.technitium-dns-server = {
    enable = true;
  };
  # see https://github.com/NixOS/nixpkgs/issues/416320
  systemd.services.technitium-dns-server.serviceConfig = {
    WorkingDirectory = lib.mkForce null;
    BindPaths = lib.mkForce null;
  };
}
