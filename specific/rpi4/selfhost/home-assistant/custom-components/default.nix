{
  pkgs,
}:
[
  (
    with pkgs.python3Packages;
    pkgs.callPackage ./ha-xiaomi-home.nix {
      inherit construct;
      inherit paho-mqtt;
      inherit numpy;
      inherit cryptography;
      inherit psutil;
    }
  )
]
