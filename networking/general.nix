{ extra, ... }:
{
  # Hostname
  networking.hostName = extra.hostname;
}
