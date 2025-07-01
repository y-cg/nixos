{ config, ... }:
let home = config.home-manager.users.ycg.home.homeDirectory; in
{
  age = {
    secrets = {
      "nix-access-token-github" = {
        file = ./storage/nix-access-token-github.age;
      };
    };
    # see https://github.com/ryantm/agenix/issues/300
    secretsDir = "${home}/.secrets"; # better place?
    identityPaths = [ "${home}/.ssh/id_ed25519" ]; # I think it uses ~/.ssh/id_rsa by default
  };
}
