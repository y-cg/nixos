{
  inputs,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  pi-pkg = inputs.llm-agents.packages.${system}.pi;
in
{
  home.packages = [ pi-pkg ];
}
