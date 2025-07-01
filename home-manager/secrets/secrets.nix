{ config, ... }:
{
  age = {
    secrets = {
      "nix-access-token-github" = {
        file = ./storage/nix-access-token-github.age;
      };
    };
    # see https://github.com/ryantm/agenix/issues/300
    secretsDir = "${config.home.homeDirectory}/.secrets";
    # I believe it uses ~/.ssh/id_rsa by default
    identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
  };
}
