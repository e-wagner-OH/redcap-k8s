# setup of prom, grafana, and uptime kuma

```
5855  helm install argocd argo/argo-cd --namespace argocd
 5978* helm install prometheus prometheus-community/prometheus\n
 5982* helm install grafana prometheus-community/grafana
 5984* helm install grafana prometheus-community/grafana
 5987* helm install grafana grafana/grafana --namespace monitoring --create-namespace
 6053* helm install uptime-kuma uptime-kuma/uptime-kuma --namespace monitoring --create-namespace\n
```