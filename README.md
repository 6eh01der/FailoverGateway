# Failover Gateway

Inspired by MikroTik "Check gateway" function https://wiki.mikrotik.com/wiki/Manual:IP/Route and this article https://blog.rapellys.biz/2014/10/18/linux-default-gateway-failover-script/

For every 10 seconds there will be checking default and backup gateways availability by ping. There may be only failover between gateways or additionally failback to default gateway by it's avalability.

Installation script will create systemd fogw.timer and corresponding oneshot fogw.service for executing fogw.sh script from /opt/fogw/ .

Default and backup gateway addresses may be changed at any time by fogwcfg.sh script located in /opt/fogw/

uninstall-fogw.sh located in the same place.

Installation:

1) wget https://github.com/IBeholderI/FailoverGateway/files/5830972/fogw.tar.gz

2) tar -zxf fogw.tar.gz

3) ./install-fogw.sh
