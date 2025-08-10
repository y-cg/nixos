{ inputs, pkgs, ... }:
let
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in
{
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # compilers
    gcc
    gnumake
    # git
    gh
    git
    lazygit
    # utils
    fastfetch
    btop
    ripgrep
    fd
    dust
    otree
    flamelens
    nettools
    tlrc
    # fixme: mitmproxy broken in 25.05
    pkgs-unstable.mitmproxy
    # shell
    starship
    zsh
    eza
    zoxide
    fzf
    tmux
    # nix
    nix-search-cli
    devenv
    direnv
    nixfmt-rfc-style
    nixd
    nix-output-monitor
    # docker
    lazydocker
    dive
    # python
    uv
    # cryptography tools
    age
    sops
    ssh-to-age
    openssl
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
}
