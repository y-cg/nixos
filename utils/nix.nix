{
  # Allow unfree packages (some firmware might need this)
  nixpkgs.config.allowUnfree = true;

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
