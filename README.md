# NixOS

[![Built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

## Known issues

- agenix does not support ssh key with passphrase
- agenix might need a reboot after the ssh key is set to make sure the secrets are setup correctly
- may not securely visit some websites hosted on cloudflare because the root certificate (AAA certificate service, which is the root of certificate chain) has been removed in cacert v3.111, and rolling back to cacert v3.108 triggers an unbearable rebuild.

## Known issues (Resolved)

- Nixos-rebuild switch generation not picked upon reboot on rpi [^user-reports]

The issue is that the generation is not picked up on reboot, and it resets to the generation that flushed into the sd card.
This is possibly caused by the boot option, we switch to uboot instead of using the default bootloader.
This should be already resolved in [bf54024](https://github.com/y-cg/nixos/commit/bf54024e70b10d9567e35f0eac7df4c788591f5e) by using [nixos-raspberrypi](https://github.com/nvmd/nixos-raspberrypi) instead of the default NixOS Raspberry Pi module.

[^user-reports]: Users' reports: [
    [1](https://discourse.nixos.org/t/nixos-rebuild-switch-generation-not-picked-upon-reboot/26474/1),
    [2](https://www.reddit.com/r/NixOS/comments/o2x8lj/nixos_on_raspberry_pi_4_resets_the_generation_on/),
    [3](https://discourse.nixos.org/t/generation-resets-on-reboot-on-raspberry-pi-5/59703)
]
