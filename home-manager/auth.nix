{ pkgs, ... }:
{
  security.sudo.wheelNeedsPassword = false;
  users.users.ycg = {
    createHome = true;
    home = "/home/ycg";
    isNormalUser = true; # Seems that agenix works with normal users
    hashedPassword = ""; # Empty password
    # System users in NixOS don't get a login shell by default
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ]; # Allow sudo access
    group = "users";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHl4c+mtLFx/KtE1OefdP706E/HEbV4+xraGGcxRo6vl"
    ];
  };
  programs.zsh.enable = true;
}
