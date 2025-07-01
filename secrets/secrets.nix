{

  age = {
    secrets = {
      "nix-access-token-github" = {
        file = ./storage/nix-access-token-github.age;
      };
    };
    # see https://github.com/ryantm/agenix/issues/300
    secretsDir = "/.secrets";
    identityPaths = [ "/home/ycg/.ssh/id_ed25519" ]; # I believe it uses ~/.ssh/id_rsa by default
  };
}
