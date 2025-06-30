{ pkgs, ... }:
{
  users.users.ycg = {
    isSystemUser = true;
    # System users in NixOS don't get a login shell by default
    shell = pkgs.zsh;
    # I'm sure I have config the zsh
    ignoreShellProgramCheck = true;
    extraGroups = [ "wheel" ]; # Allow sudo access
    group = "ycg";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHl4c+mtLFx/KtE1OefdP706E/HEbV4+xraGGcxRo6vl"
    ];
  };
  users.groups.ycg = { };
}
