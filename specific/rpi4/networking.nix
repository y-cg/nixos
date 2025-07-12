{ config, lib, ... }:

{
  # help nixos infer the fqdn
  networking.domain = lib.mkIf config.services.avahi.enable config.services.avahi.domainName;
}
