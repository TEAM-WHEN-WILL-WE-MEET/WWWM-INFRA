### SELinux Configuration
sudo semanage port -a -t http_port_t -p tcp 33306
sudo setsebool -P httpd_can_network_connect 1

### Firewall Configuration
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --add-service=https --permanent
sudo firewall-cmd --zone=public --add-port=33306/tcp --permanent
sudo firewall-cmd --reload