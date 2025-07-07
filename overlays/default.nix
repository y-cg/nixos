{
  imports = [
    # This lead to cache miss and trigger lots of rebuild
    # ./cacert.nix
    ./home-assistant.nix
  ];
}
