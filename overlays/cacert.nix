final: prev: {
  cacert = prev.cacert.override {
    nssOverride = {
      version = "3.108";
      src = prev.fetchFromGitHub {
        owner = "nss-dev";
        repo = "nss";
        rev = "NSS_3_108_RTM";
        hash = "sha256-L2XRj3D8SsS2QYQFDLwGtaPoZ7tN4kz8hGdVKefFSu8=";
      };
    };
  };
}
