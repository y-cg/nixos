{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nix-search-cli
    nixfmt-rfc-style
    nixd
    nil
    nix-output-monitor
  ];
}
