### Install Helm
dnf install -y git tar
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

### Install prometheus-stack
kubectl create namespace monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set grafana.enabled=true \
  --set prometheus.resources.requests.cpu="100m" \
  --set prometheus.resources.requests.memory="200Mi" \
  --set grafana.resources.requests.cpu="50m" \
  --set grafana.resources.requests.memory="100Mi"
  --set grafana.service.type=NodePort \
  --set grafana.service.nodePort=30200
  --set nodeExporter.enabled=true \
  --set server.tolerations[0].key="node-role.kubernetes.io/control-plane" \
  --set server.tolerations[0].operator="Exists" \
  --set server.tolerations[0].effect="NoSchedule"\
  --set server.persistentVolume.enabled=true

### Grafana Secret
kubectl get secret kube-prometheus-stack-grafana \
  -n monitoring \
  -o jsonpath="{.data.admin-password}" | base64 -d && echo

: << "END"
[root@k3s ~]# curl localhost:30200
<a href="/login">Found</a>.
END
