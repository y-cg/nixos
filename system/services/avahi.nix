{
  # Enable mDNS with avahi
  # Then it is accessible via ssh username@hostname.local
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    # ref: https://www.reddit.com/r/NixOS/comments/qszvd4/comment/hkgai7j/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };
}
