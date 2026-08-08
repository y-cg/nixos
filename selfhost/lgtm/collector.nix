# OpenTelemetry Collector — the single OTLP ingress point on the LAN
# (4317 gRPC / 4318 HTTP). One endpoint receives every signal from
# OTel-compatible SDKs; the collector then fans them out:
#
#   traces  -> Tempo   (loopback OTLP)
#   metrics -> Mimir   (loopback Prometheus remote_write)
#
# Logs can be added later with a third pipeline using the `loki` exporter
# (hence the -contrib package).
{ pkgs, ... }:
let
  ports = import ./ports.nix;
in
{
  networking.firewall.allowedTCPPorts = [
    ports.otlpGrpc
    ports.otlpHttp
  ];

  services.opentelemetry-collector = {
    enable = true;
    package = pkgs.opentelemetry-collector-contrib;
    settings = {
      receivers.otlp.protocols = {
        grpc.endpoint = "0.0.0.0:${toString ports.otlpGrpc}";
        http.endpoint = "0.0.0.0:${toString ports.otlpHttp}";
      };

      processors = {
        memory_limiter = {
          check_interval = "1s";
          limit_percentage = 80;
          spike_limit_percentage = 25;
        };
        batch = { };
      };

      exporters = {
        # traces -> Tempo
        otlp = {
          endpoint = "127.0.0.1:${toString ports.tempoOtlpGrpc}";
          tls.insecure = true;
        };
        # metrics -> Mimir (Prometheus-compatible remote_write)
        prometheusremotewrite = {
          endpoint = "http://127.0.0.1:${toString ports.mimir}/api/v1/push";
        };
      };

      service.pipelines = {
        traces = {
          receivers = [ "otlp" ];
          processors = [ "memory_limiter" "batch" ];
          exporters = [ "otlp" ];
        };
        metrics = {
          receivers = [ "otlp" ];
          processors = [ "memory_limiter" "batch" ];
          exporters = [ "prometheusremotewrite" ];
        };
      };
    };
  };
}
