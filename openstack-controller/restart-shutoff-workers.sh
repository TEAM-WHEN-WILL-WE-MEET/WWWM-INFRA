vim /usr/local/bin/restart-shutoff-workers.sh
: << "END"
# OpenStack 환경 변수 로드
source /root/admin-openrc

# 점검할 인스턴스 목록
WORKERS=("k8s-worker-1" "k8s-worker-2")

for name in "${WORKERS[@]}"; do
  # 상태 조회
  status=$(openstack server show "$name" -f value -c status 2>/dev/null)
  if [[ "$status" == "SHUTOFF" ]]; then
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $name is SHUTOFF, starting..." >> /var/log/restart-workers.log
    openstack server start "$name" >> /var/log/restart-workers.log 2>&1
  fi
done
END

sudo chmod +x /usr/local/bin/restart-shutoff-workers.sh
sudo touch /var/log/restart-workers.log
sudo chown root:root /var/log/restart-workers.log
sudo chmod 600 /var/log/restart-workers.log

sudo crontab -e
* * * * * /usr/local/bin/restart-shutoff-workers.sh