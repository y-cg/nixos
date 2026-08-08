# TCP port assignments for the LGTM stack. Shared so Grafana's datasource
# URLs stay in sync with the actual listen ports of the backends.
{
  grafana = 3000;
  loki = 3100;
  tempo = 3200;
  tempoOtlpGrpc = 4317;
  tempoOtlpHttp = 4318;
  mimir = 9009;
  mimirGrpc = 9095;
}
