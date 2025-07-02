# NixOS

[![Built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

## Known issues

- agenix does not support ssh key with passphrase
- agenix might need a reboot after the ssh key is set to make sure the secrets are setup correctly
- may not securely visit some websites hosted on cloudflare because the root certificate (AAA certificate service, which is the root of certificate chain) has been removed in cacert v3.111, and rolling back to cacert v3.108 triggers an unbearable rebuild.
