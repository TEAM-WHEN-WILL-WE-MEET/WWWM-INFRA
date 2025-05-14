kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

kubectl get deployment metrics-server -n kube-system
<< 'END':
NAME             READY   UP-TO-DATE   AVAILABLE   AGE
metrics-server   0/1     1            0           5s
END

kubectl rollout restart deployment metrics-server -n kube-system

kubectl get hpa
