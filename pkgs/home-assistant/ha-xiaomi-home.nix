{
  stdenv,
  pkgs,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  construct,
  paho-mqtt,
  numpy,
  cryptography,
  psutil,
}:

buildHomeAssistantComponent rec {

  owner = "XiaoMi";
  domain = "xiaomi_home";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "XiaoMi";
    repo = "ha_xiaomi_home";
    rev = "v${version}";
    sha256 = "sha256-GcGZogdFrLzsWtQytOrZBj3Jh5TZf07wP5x6NjjNN3c=";
  };

  dependencies = [
    construct
    paho-mqtt
    numpy
    cryptography
    psutil
  ];
}
