# FailoverGateway

Inspired by MikroTik "Check gateway" function https://wiki.mikrotik.com/wiki/Manual:IP/Route and this article https://blog.rapellys.biz/2014/10/18/linux-default-gateway-failover-script/

For every 10 seconds there will be checking default and backup gateways availability by ping. There may be only failover between gateways or additionally failback to default gateway by it's avalability.

Installation script will place service, config and uninstall scripts to /opt/fogw/, create systemd oneshot fogw.service and corresponding systemd fogw.timer for executing fogw.sh script every 10 seconds.

Default and backup gateway addresses may be changed at any time by fogwcfg.sh script located in /opt/fogw/

uninstall-fogw.sh located in the same place.

Installation:

1) fping required. install-fogw.sh will install it for you but you can do it manually:

      for Ubuntu/Debian run:
        
                apt-get install fping
                or
                apt install fping
                
      for RedHat/CentOS run:
        
                yum install fping
                or
                dnf install fping
                
      for OpenSuse run:
        
                zypper install fping

2) wget https://github.com/IBeholderI/FailoverGateway/releases/download/1.1.3/fogw-1.1.3.tar.gz

3) tar -zxf fogw-1.1.3.tar.gz

4) Under root
        
        ./install-fogw.sh
        
   Or under sudo user
   
        sudo ./install-fogw.sh
