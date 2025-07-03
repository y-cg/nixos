{ pkgs, ... }:

let
  tmux-nord = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "nord";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "nordtheme";
      repo = "tmux";
      rev = "f7b6da07ab55fe32ee5f7d62da56d8e5ac691a92";
      hash = "sha256-mcmVYNWOUoQLiu4eM/EUudRg67Gcou13xuC6zv9aMKA=";
    };
    patchPhase = ''
      sed -i '1i\#!/usr/bin/env bash' nord.tmux
    '';
  };
in
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "xterm-256color";
    plugins = with pkgs; [
      {
        plugin = tmux-nord;
        extraConfig = '''';
      }
    ];
    extraConfig = ''
      # faster command sequences
      set -s escape-time 10

      # increase repeat timeout
      set -sg repeat-time 600

      set -g default-terminal "screen-256color"

      # Vim-like keymapping
      setw -g mode-keys vi

      # Vim-like pane switching
      bind -n -r C-p select-pane -t :.+

      # Switch between windows
      bind -n M-l select-window -t :+1
      bind -n M-h select-window -t :-1

      # Fix color
      set -ga terminal-overrides ",xterm-256color:Tc"
      set -g default-terminal "xterm-256color"

      # use mouse in tmux
      set -g mouse on
    '';
  };
}
