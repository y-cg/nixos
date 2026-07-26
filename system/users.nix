{ pkgs, meta, ... }:
{
  security.sudo.wheelNeedsPassword = false;
  users.users."${meta.whoami}" = {
    createHome = true;
    home = "/home/${meta.whoami}";
    isNormalUser = true;
    hashedPassword = ""; # Empty password
    # System users in NixOS don't get a login shell by default
    shell = pkgs.zsh;
    extraGroups = [
      "wheel" # allow sudo access
      "docker" # run docker command without sudo
    ];
    group = "users";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHl4c+mtLFx/KtE1OefdP706E/HEbV4+xraGGcxRo6vl"
    ];
  };
  programs.zsh.enable = true;
}
