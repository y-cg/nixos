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

  # nixos-26.05 removed Grafana's default `secret_key`. We must provide one,
  # but it must NOT live in the world-readable Nix store. Instead we generate
  # a random key into a root/grafana-owned file on first boot and reference it
  # via Grafana's file-provider (`$__file{...}`).
  # See https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#file-provider
  systemd.services.grafana-secret-key = {
    description = "Generate Grafana secret_key file";
    before = [ "grafana.service" ];
    requiredBy = [ "grafana.service" ];
    unitConfig = {
      # grafana.service declares Restart=on-failure and is wanted by
      # multi-user.target; regenerate-or-leave alone is idempotent either way.
      ConditionPathExists = "!/var/lib/grafana/secret_key";
    };
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      UMask = "0077";
    };
    script = ''
      install -d -o grafana -g grafana -m 0750 /var/lib/grafana
      # 32 random bytes -> 64 hex chars (pure coreutils, works on the target)
      key=$(head -c 32 /dev/urandom | od -An -tx1 | tr -d ' \n')
      install -o grafana -g grafana -m 0400 /dev/stdin /var/lib/grafana/secret_key <<<"$key"
    '';
  };

  services.grafana = {
    enable = true;
    settings = {
      security.secret_key = "$__file{/var/lib/grafana/secret_key}";
      server = {
        http_addr = "0.0.0.0";
        http_port = grafanaPort;
        domain = "localhost";
      };
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
