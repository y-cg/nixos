# This file is not imported into your NixOS configuration
# It's only used for the agenix CLI tool to know which public keys to use for encryption.
let
  ycg = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHl4c+mtLFx/KtE1OefdP706E/HEbV4+xraGGcxRo6vl";
  users = [ ycg ];
in
{
  "nix-access-token-github.age".publicKeys = users;
}
