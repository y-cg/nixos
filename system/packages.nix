{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nix-search-cli
    nixfmt-rfc-style
    nixd
    nix-output-monitor
  ];
}
