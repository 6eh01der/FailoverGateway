# FailoverGateway

Inspired by MikroTik "Check gateway" https://wiki.mikrotik.com/wiki/Manual:IP/Route function and this article https://blog.rapellys.biz/2014/10/18/linux-default-gateway-failover-script/

For every 10 seconds there will be checking default and backup gateways availability by ping. There may be only failover between gateways or additionally failback to default gateway by it's avalability.

Installation script will create systemd fogw.timer and corresponding oneshot fogw.service for executing fogw.sh script from /opt/fogw/ .

Default and backup gateway addresses may be changed at any time by fogwcfg.sh script located in /opt/fogw/

uninstall-fogw.sh located in same place.
