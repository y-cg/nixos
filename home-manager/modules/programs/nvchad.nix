{ inputs, pkgs, ... }:
{

  imports = [ inputs.nix4nvchad.homeManagerModule ];
  programs.nvchad = {
    enable = true;
    extraPackages = with pkgs; [ ];
    hm-activation = true;
    backup = true;
    neovim = pkgs.neovim;
  };

}
