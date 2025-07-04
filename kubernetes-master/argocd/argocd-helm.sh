# Helm Repo 등록 및 업데이트
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# argocd 네임스페이스 생성
kubectl create namespace argocd

vim values.yaml

helm install argocd argo/argo-cd \
  -n argocd \
  -f values.yaml \
  --wait=false

# argocd 비밀번호 확인
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# 서비스 확인
kubectl get svc -n argocd