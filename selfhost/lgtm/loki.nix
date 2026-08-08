# Loki — log aggregation. Single-tenant, loopback only; Grafana queries it
# locally. Open the port if you want remote ingestion.
{ ... }:
let
  ports = import ./ports.nix;
in
{
  services.loki = {
    enable = true;
    configuration = {
      auth_enabled = false; # single-tenant
      server = {
        http_listen_address = "127.0.0.1";
        http_listen_port = ports.loki;
      };
      common = {
        path_prefix = "/var/lib/loki";
        replication_factor = 1;
        ring.kvstore.store = "inmemory";
        storage.filesystem = {
          chunks_directory = "/var/lib/loki/chunks";
          rules_directory = "/var/lib/loki/rules";
        };
      };
      schema_config.configs = [
        {
          from = "2024-01-01";
          store = "tsdb";
          object_store = "filesystem";
          schema = "v13";
          index = {
            prefix = "index_";
            period = "24h";
          };
        }
      ];
      limits_config.allow_structured_metadata = true;
    };
  };
}
