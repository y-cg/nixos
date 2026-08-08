# Mimir — metrics (Prometheus-compatible). Monolithic single-process mode,
# loopback only; Grafana scrapes/queries it locally.
{ ... }:
let
  ports = import ./ports.nix;
in
{
  services.mimir = {
    enable = true;
    configuration = {
      target = "all"; # monolithic single-process mode
      multitenancy_enabled = false;
      server = {
        http_listen_address = "127.0.0.1";
        http_listen_port = ports.mimir;
        grpc_listen_port = ports.mimirGrpc;
      };
      common.storage = {
        backend = "filesystem";
        filesystem.dir = "/var/lib/mimir/data";
      };
      blocks_storage = {
        backend = "filesystem";
        tsdb.dir = "/var/lib/mimir/tsdb";
        bucket_store.sync_dir = "/var/lib/mimir/tsdb-sync";
      };
      compactor = {
        data_dir = "/var/lib/mimir/compactor";
        sharding_ring.kvstore.store = "inmemory";
      };
      store_gateway.sharding_ring.kvstore.store = "inmemory";
      ruler_storage = {
        backend = "filesystem";
        filesystem.dir = "/var/lib/mimir/rules";
      };
      alertmanager_storage = {
        backend = "filesystem";
        filesystem.dir = "/var/lib/mimir/alertmanager";
      };
    };
  };
}
