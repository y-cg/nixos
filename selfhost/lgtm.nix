# The LGTM observability stack: Loki, Grafana, Tempo, Mimir.
# All four run as native NixOS systemd services (no containers).
#
# - Grafana is reachable on the LAN (0.0.0.0:3000, opened in the firewall).
# - The backends (Loki/Tempo/Mimir) listen on the loopback interface only;
#   Grafana talks to them locally. Open their ports if you need remote
#   ingestion from other hosts.
{ ... }:
let
  grafanaPort = 3000;
  lokiPort = 3100;
  tempoPort = 3200;
  tempoOtlpGrpc = 4317;
  tempoOtlpHttp = 4318;
  mimirPort = 9009;
  mimirGrpc = 9095;
in
{
  networking.firewall.allowedTCPPorts = [ grafanaPort ];

  services.grafana = {
    enable = true;
    settings.server = {
      http_addr = "0.0.0.0";
      http_port = grafanaPort;
      domain = "localhost";
    };
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Mimir";
          uid = "mimir";
          type = "prometheus";
          access = "proxy";
          url = "http://127.0.0.1:${toString mimirPort}/prometheus";
          isDefault = true;
        }
        {
          name = "Loki";
          uid = "loki";
          type = "loki";
          access = "proxy";
          url = "http://127.0.0.1:${toString lokiPort}";
          jsonData.maxLines = 1000;
        }
        {
          name = "Tempo";
          uid = "tempo";
          type = "tempo";
          access = "proxy";
          url = "http://127.0.0.1:${toString tempoPort}";
          jsonData = {
            serviceMap.enabled = true;
            tracesToLogsV2 = {
              datasourceUid = "loki";
              spanStartTimeShift = "1h";
              spanEndTimeShift = "1h";
              filterByTraceID = true;
              filterBySpanID = true;
              tags = [ "service.name" ];
            };
          };
        }
      ];
    };
  };

  # --- Logs ---------------------------------------------------------------
  services.loki = {
    enable = true;
    configuration = {
      auth_enabled = false; # single-tenant
      server = {
        http_listen_address = "127.0.0.1";
        http_listen_port = lokiPort;
      };
      common = {
        path_prefix = "/var/lib/loki";
        replication_factor = 1;
        ring.kv.store = "inmemory";
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

  # --- Traces -------------------------------------------------------------
  services.tempo = {
    enable = true;
    settings = {
      server = {
        http_listen_address = "127.0.0.1";
        http_listen_port = tempoPort;
      };
      distributor.receivers.otlp.protocols = {
        grpc.endpoint = "127.0.0.1:${toString tempoOtlpGrpc}";
        http.endpoint = "127.0.0.1:${toString tempoOtlpHttp}";
      };
      storage.trace = {
        backend = "local";
        local.path = "/var/lib/tempo/blocks";
        wal.path = "/var/lib/tempo/wal";
      };
      ingester = {
        trace_idle_period = "30s";
        max_block_bytes = 1048576; # 1 MiB, small for the Pi
        max_block_duration = "5m";
      };
    };
  };

  # --- Metrics ------------------------------------------------------------
  services.mimir = {
    enable = true;
    configuration = {
      target = "all"; # monolithic single-process mode
      multitenancy_enabled = false;
      server = {
        http_listen_address = "127.0.0.1";
        http_listen_port = mimirPort;
        grpc_listen_port = mimirGrpc;
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
