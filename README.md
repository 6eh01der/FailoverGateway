# FailoverGateway

Inspired by MikroTik "Check gateway" function https://wiki.mikrotik.com/wiki/Manual:IP/Route and this article https://blog.rapellys.biz/2014/10/18/linux-default-gateway-failover-script/

For every 10 seconds there will be checking of default and backup gateway availability by ping. There possible only failover between gateways or additionally failback to default gateway by it's avalability.

Installation script will place service, config and uninstall scripts to /opt/fogw/, create systemd oneshot fogw.service and corresponding systemd fogw.timer for executing fogw.sh script every 10 seconds.

Default and backup gateway's addresses, timeout and failback action may be changed at any time by fogwcfg.sh script located in /opt/fogw/

uninstall-fogw.sh located in the same place.

Installation:

fping required. install-fogw.sh will install it for you but also you can do it manually:

1)

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

2)
```bash
wget https://github.com/6eh01der/FailoverGateway/archive/refs/tags/1.1.6.tar.gz
```
3)
```bash
tar -zxf FailoverGateway-1.1.6.tar.gz
```

4) Under root
        
        ./install-fogw.sh
        
   Or under sudo user
   
        sudo ./install-fogw.sh
