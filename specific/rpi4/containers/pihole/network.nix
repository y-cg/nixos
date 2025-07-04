{
  networking.firewall = {
    allowedTCPPorts = [
      53
      80
      443
    ];
    allowedUDPPorts = [ 53 ];
  };
}
