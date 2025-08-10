{
  pkgs,
}:
[
  (
    with pkgs.python3Packages;
    pkgs.callPackage ./ha-xiaomi-home.nix {
      inherit
        construct
        paho-mqtt
        numpy
        cryptography
        psutil
        ;
    }
  )
]
