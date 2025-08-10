{ inputs, pkgs, ... }:
{
  home.packages = [
    inputs.nix4nvchad.packages."${pkgs.system}".nvchad
  ];
  imports = [ inputs.nix4nvchad.homeManagerModule ];
  programs.nvchad = {
    enable = true;
    extraPackages = with pkgs; [ ];
    hm-activation = true;
    backup = false;
    neovim = pkgs.neovim;
  };

}
