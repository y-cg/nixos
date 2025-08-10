{
  inputs,
  pkgs,
  ...
}:
let
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in
{
  home.packages = [
    inputs.nix4nvchad.packages."${pkgs.system}".nvchad
  ];
  imports = [ inputs.nix4nvchad.homeManagerModule ];
  programs.nvchad = {
    enable = true;
    extraPackages = with pkgs-unstable; [
      prettier
      tombi
    ];
    hm-activation = true;
    backup = false;
    neovim = pkgs.neovim;
  };

}
