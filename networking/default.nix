{ hostname, ... }:
{
  # Hostname
  networking.hostName = hostname;

  # Enable networking
  networking.networkmanager.enable = true;
}
