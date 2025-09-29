{ inputs, pkgs, ... }:
let
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in
{
  home.packages = with pkgs-unstable; [
    inputs.nix4nvchad.packages."${pkgs.system}".nvchad
    tombi
    prettier
  ];

  imports = [ inputs.nix4nvchad.homeManagerModule ];

  programs.nvchad = {
    enable = true;
    hm-activation = true;
    backup = false;
  };

}
