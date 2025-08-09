{
  # Allow unfree packages (some firmware might need this)
  nixpkgs.config.allowUnfree = true;

  # Run unpatched dynamic binaries on NixOS.
  programs.nix-ld.enable = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      # Enable flakes
      "flakes"
    ];
    trusted-users = [
      "root"
      "@wheel"
    ];
  };
}
