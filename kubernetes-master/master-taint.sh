# MetalLB가 Taint로 인해 구동되지 못하는 문제를
# 일시적으로 우회하기 위해  deployment controller에 Toleration 추가
kubectl -n metallb-system patch deployment controller \
  --patch '{"spec":{"template":{"spec":{"tolerations":[
    {"key":"node-role.kubernetes.io/control-plane","operator":"Exists","effect":"NoSchedule"}
  ]}}}}'

# 테스트를 위해 Master Node의 Taint 일시적으로 제거
kubectl taint node master node-role.kubernetes.io/control-plane:NoSchedule-