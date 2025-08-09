{
  networking.networkmanager = {
    enable = true;
    wifi = {
      powersave = false;
    };
    ensureProfiles = {
      profiles = (import ./wifi.nix);
    };
  };
}
