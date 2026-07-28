{ ... }:
{
  programs.television = {
    enable = true;

    # ====================================================================
    # files channel override
    # ====================================================================
    #
    # Television's built-in `files` channel ships two cycleable sources
    # (Ctrl+S):
    #
    #   1. "fd -t f"     (respects .gitignore, hides dotfiles)  <- built-in default
    #   2. "fd -t f -H"  (respects .gitignore, shows dotfiles)
    #
    # `fd` respects .gitignore in both cases, so that part already matches
    # what we want. The only thing missing from the default launch mode is
    # hidden files: the built-in default is source #1, which hides dotfiles
    # like `.envrc` or `.stylua.toml`.
    #
    # We want hidden files *by default* while still honoring .gitignore, so
    # this override reorders the sources to put the hidden-including variant
    # first. Source cycling (Ctrl+S) is preserved — plain `fd -t f` remains
    # available for the rare case where dotfile noise is unwanted.
    #
    # The `--exclude .git` addition is intentional: `fd -H` would otherwise
    # descend into `.git/` and surface 200+ internal plumbing files (HEAD,
    # index, packed objects, ...). Those are hidden but not gitignored, so
    # they slip through `-H` unless we exclude the directory explicitly.
    #
    # Format note: television 0.15.6 uses the array-of-strings cable format
    # for `source.command` (a plain TOML array). The newer array-of-tables
    # format on `main` fails to parse on 0.15.6 with
    # `OneOrMany could not deserialize any variant`. Match the format to the
    # installed version, not to `main`.
    channels.files = {
      metadata = {
        name = "files";
        description = "A channel to select files and directories";
        requirements = [
          "fd"
          "bat"
        ];
      };

      # First entry is the default launch mode; subsequent entries are
      # reachable via Ctrl+S source cycling.
      source.command = [
        "fd -t f -H --exclude .git"
        "fd -t f"
      ];

      preview = {
        command = "bat -n --color=always '{}'";
        env = {
          BAT_THEME = "ansi";
        };
      };

      keybindings = {
        # Override the global `enter = "confirm_selection"` (which only
        # selects and exits) so Enter opens the selection in $EDITOR.
        enter = "actions:edit";
      };

      actions.edit = {
        description = "Opens the selected entries with the default editor (falls back to vim)";
        # `\${...}` escapes Nix string interpolation; the literal `${EDITOR:-vim}`
        # must reach the shell so television can resolve it at runtime.
        command = "\${EDITOR:-nvim} '{}'";
        shell = "bash";
        # use `mode = "fork"` if you want to return to tv afterwards
        mode = "execute";
      };

      # TODO: upstream 0.15.6 `files` cable also ships other actions.
      # Not carried over for now — re-add from upstream if those interactions are wanted later.
    };
  };
}
