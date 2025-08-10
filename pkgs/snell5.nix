{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

let
  version = "5.0.0";

  sources = {
    "x86_64-linux" = {
      url = "https://dl.nssurge.com/snell/snell-server-v${version}-linux-amd64.zip";
      sha256 = "sha256-iTp75PxeaVuXrLgK+aSpm5mGf4y0dnhHJaP4n6I5QOE=";
    };
    "i686-linux" = {
      url = "https://dl.nssurge.com/snell/snell-server-v${version}-linux-i386.zip";
      sha256 = "sha256-Hw+nIHS8FEXGgGYq+AgTvB9orxN3ptj0GTnI88r4nog=";
    };
    "aarch64-linux" = {
      url = "https://dl.nssurge.com/snell/snell-server-v${version}-linux-aarch64.zip";
      sha256 = "sha256-dnCQMqjRBD+m8B4fu7cnFI13U0qDKT1zVkpWksOWcpI=";
    };
    "armv7l-linux" = {
      url = "https://dl.nssurge.com/snell/snell-server-v${version}-linux-armv7l.zip";
      sha256 = "sha256-oFBM69L1uD/lid6n9xdraBoT9XeNGhDY1JzwYZl8FWQ=";
    };
  };

  src-info =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in

stdenv.mkDerivation {
  pname = "snell-server-v5";
  inherit version;

  src = fetchurl {
    url = src-info.url;
    sha256 = src-info.sha256;
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -D -m755 snell-server $out/bin/snell-server
  '';

  meta = with lib; {
    description = "A fast tunnel proxy that helps you bypass firewalls";
    homepage = "https://nssurge.com/";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
      "armv7l-linux"
    ];
    maintainers = [ ];
  };
}
