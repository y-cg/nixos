# paho-mqtt tests are flaky (esp. on aarch64); disable so HA/xiaomi_home
# can build. See https://github.com/NixOS/nixpkgs/issues/542586
final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (pyfinal: pyprev: {
      paho-mqtt = pyprev.paho-mqtt.overridePythonAttrs (_: {
        doCheck = false;
      });
    })
  ];
}
