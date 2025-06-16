----------------------------------------------------------------
-------------Two Node rac Setup on VM Workstation---------------
----------------------------------------------------------------

-- 2 Node rac on VM -->> On both Node
[root@invcdr1/invcdr2 ~]# df -Th
/*
Filesystem     Type      Size  Used Avail Use% Mounted on
devtmpfs       devtmpfs  9.7G     0  9.7G   0% /dev
tmpfs          tmpfs     9.7G     0  9.7G   0% /dev/shm
tmpfs          tmpfs     9.7G  9.7M  9.7G   1% /run
tmpfs          tmpfs     9.7G     0  9.7G   0% /sys/fs/cgroup
/dev/sda2      ext4       79G  316M   75G   1% /
/dev/sda8      ext4       15G  5.9G  8.1G  43% /usr
/dev/sda7      ext4       15G   41M   14G   1% /tmp
/dev/sda5      ext4       15G   41M   14G   1% /home
/dev/sda1      ext4       15G  229M   14G   2% /boot
/dev/sda9      ext4       15G  1.1G   13G   8% /var
/dev/sda3      ext4       79G   57M   75G   1% /opt
tmpfs          tmpfs     2.0G   24K  2.0G   1% /run/user/0
/dev/sr0       iso9660   4.5G  4.5G     0 100% /run/media/root/OL-7.8 Server.x86_64
*/

-- Step 1 -->> On both Node
[root@invcdr1/invcdr2 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.1.1.48   invcdr1.unidev.com        invcdr1
192.1.1.49   invcdr2.unidev.com        invcdr2

# Private
10.0.1.48     invcdr1-priv.unidev.com   invcdr1-priv
10.0.1.49     invcdr2-priv.unidev.com   invcdr2-priv

# Virtual
192.1.1.50   invcdr1-vip.unidev.com    invcdr1-vip
192.1.1.51   invcdr2-vip.unidev.com    invcdr2-vip

# SCAN
192.1.1.52   invcdr-scan.unidev.com    invcdr-scan
192.1.1.53   invcdr-scan.unidev.com    invcdr-scan
192.1.1.54   invcdr-scan.unidev.com    invcdr-scan
*/


-- Step 2 -->> On both Node
-- Disable secure linux by editing the "/etc/selinux/config" file, making sure the SELINUX flag is set as follows.
[root@invcdr1/invcdr2 ~]# vi /etc/selinux/config
/*
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
#SELINUX=enforcing
SELINUX=disabled
# SELINUXTYPE= can take one of these two values:
#     targeted - Targeted processes are protected,
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
*/

-- Step 3 -->> On Node 1
[root@invcdr1 ~]# vi /etc/sysconfig/network
/*
NETWORKING=yes
HOSTNAME=invcdr1.unidev.com
*/

-- Step 4 -->> On Node 2
[root@invcdr2 ~]# vi /etc/sysconfig/network
/*
NETWORKING=yes
HOSTNAME=invcdr2.unidev.com
*/

-- Step 5 -->> On Node 1
[root@invcdr1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens160 
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=ens160
DEVICE=ens160
ONBOOT=yes
IPADDR=192.1.1.48
NETMASK=255.255.255.0
GATEWAY=192.1.1.1
DNS1=127.0.0.1
DNS2=192.1.1.88
*/

-- Step 6 -->> On Node 1
[root@invcdr1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens192
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=ens192
DEVICE=ens192
ONBOOT=yes
IPADDR=10.0.1.48
NETMASK=255.255.255.0
*/

-- Step 7 -->> On Node 2
[root@invcdr2 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens162 
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=ens160
DEVICE=ens160
ONBOOT=yes
IPADDR=192.1.1.49
NETMASK=255.255.255.0
GATEWAY=192.1.1.1
DNS1=127.0.0.1
DNS2=192.1.1.88
*/

-- Step 8 -->> On Node 2
[root@invcdr2 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens192
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=ens192
DEVICE=ens192
ONBOOT=yes
IPADDR=10.0.1.49
NETMASK=255.255.255.0
*/

-- Step 9 -->> On Both Node
[root@invcdr1/invcdr2 ~]# systemctl restart network

-- Step 10 -->> On Both Node
[root@invcdr1/invcdr2 ~]# cat /etc/hostname
/*
localhost.localdomain
*/

-- Step 10.1 -->> On Both Node
[root@invcdr1/invcdr2 ~]# hostnamectl | grep hostname
/*
   Static hostname: localhost.localdomain
Transient hostname: invcdr1/invcdr2.unidev.com
*/

-- Step 10.2 -->> On Both Node
[root@invcdr1/invcdr2 ~]# hostnamectl --static
/*
localhost.localdomain
*/

-- Step 11 -->> On Node 1
[root@invcdr1 ~]# hostnamectl set-hostname invcdr1.unidev.com
-- Step 11.1 -->> On Node 1
[root@invcdr1 ~]# hostnamectl
/*
   Static hostname: invcdr1.unidev.com
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 88227895705442729e6599fa59ea5192
           Boot ID: d641ac5d1e114514b11901260277f4cb
    Virtualization: vmware
  Operating System: Oracle Linux Server 7.8
       CPE OS Name: cpe:/o:oracle:linux:7:8:server
            Kernel: Linux 4.14.35-1902.300.11.el7uek.x86_64
      Architecture: x86-64
*/

-- Step 12 -->> On Node 2
[root@invcdr2 ~]# hostnamectl set-hostname invcdr2.unidev.com
-- Step 12.1 -->> On Node 2
[root@invcdr2 ~]# hostnamectl
/*
   Static hostname: invcdr2.unidev.com
         Icon name: computer-vm
           Chassis: vm
        Machine ID: d25c025de940452fb6f8c81ec2ff22c4
           Boot ID: 4bcb5660714d42ba9fdf8701c6f7c30c
    Virtualization: vmware
  Operating System: Oracle Linux Server 7.8
       CPE OS Name: cpe:/o:oracle:linux:7:8:server
            Kernel: Linux 4.14.35-1902.300.11.el7uek.x86_64
      Architecture: x86-64
*/

--Note: If you are not configure proper hostname then While installation of Grid Software, 
--      you have to face error CLSRSC-180: An error occurred while executing /opt/app/19c/grid/root.sh script.

-- Step 13 -->> On Both Node
[root@invcdr1/invcdr2 ~]# systemctl stop firewalld
[root@invcdr1/invcdr2 ~]# systemctl disable firewalld
/*
Removed /etc/systemd/system/multi-user.target.wants/firewalld.service.
Removed /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.
*/

-- Step 14 -->> On Both Node
[root@invcdr1/invcdr2 ~]# systemctl stop ntpd
[root@invcdr1/invcdr2 ~]# systemctl disable ntpd

-- Step 14.1 -->> On Both Node
[root@invcdr1/invcdr2 ~]# mv /etc/ntp.conf /etc/ntp.conf.backup
[root@invcdr1/invcdr2 ~]# rm -rf /etc/ntp.conf
[root@invcdr1/invcdr2 ~]# rm -rf /var/run/ntpd.pid

-- Step 15 -->> On Both Node
[root@invcdr1/invcdr2 ~]# iptables -F
[root@invcdr1/invcdr2 ~]# iptables -X
[root@invcdr1/invcdr2 ~]# iptables -t nat -F
[root@invcdr1/invcdr2 ~]# iptables -t nat -X
[root@invcdr1/invcdr2 ~]# iptables -t mangle -F
[root@invcdr1/invcdr2 ~]# iptables -t mangle -X
[root@invcdr1/invcdr2 ~]# iptables -P INPUT ACCEPT
[root@invcdr1/invcdr2 ~]# iptables -P FORWARD ACCEPT
[root@invcdr1/invcdr2 ~]# iptables -P OUTPUT ACCEPT
[root@invcdr1/invcdr2 ~]# iptables -L -nv
/*
Chain INPUT (policy ACCEPT 2066 packets, 5110K bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy ACCEPT 1772 packets, 117K bytes)
 pkts bytes target     prot opt in     out     source               destination
*/

-- Step 16 -->> On Both Node
[root@invcdr1/invcdr2 ~ ]# systemctl stop named
[root@invcdr1/invcdr2 ~ ]# systemctl disable named

-- Step 17 -->> On Both Node
-- Enable chronyd service." `date`
[root@invcdr1/invcdr2 ~ ]# systemctl enable chronyd
[root@invcdr1/invcdr2 ~ ]# systemctl restart chronyd
[root@invcdr1/invcdr2 ~ ]# chronyc -a 'burst 4/4'
/*
200 OK
*/

-- Step 17.1 -->> On Both Node
[root@invcdr1/invcdr2 ~ ]# chronyc -a makestep
/*
200 OK
*/

-- Step 17.2 -->> On Both Node
[root@invcdr1/invcdr2 ~ ]# systemctl status chronyd
/*
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: active (running) since Thu 2022-12-22 14:49:59 +0545; 35s left
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 3682 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, status=0/SUCCESS)
  Process: 3675 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 3677 (chronyd)
    Tasks: 1
   CGroup: /system.slice/chronyd.service
           └─3677 /usr/sbin/chronyd

Dec 22 14:49:59 invcdr1.unidev.com systemd[1]: Starting NTP client/server...
Dec 22 14:49:59 invcdr1.unidev.com chronyd[3677]: chronyd version 3.4 starting (+CMDMON +NTP +REFCLOCK +RTC...BUG)
Dec 22 14:49:59 invcdr1.unidev.com systemd[1]: Started NTP client/server.
Dec 22 14:50:05 invcdr1.unidev.com chronyd[3677]: Selected source 162.159.200.123
Dec 22 14:50:05 invcdr1.unidev.com chronyd[3677]: System clock wrong by -54.676926 seconds, adjustment started
Dec 22 14:49:10 invcdr1.unidev.com chronyd[3677]: System clock was stepped by -54.676926 seconds
Dec 22 14:49:16 invcdr1.unidev.com chronyd[3677]: System clock was stepped by 0.000001 seconds
Hint: Some lines were ellipsized, use -l to show in full.
*/

-- Step 18 -->> On Both Node
[root@invcdr1/invcdr2 ~]# cd /run/media/root/OL-7.8\ Server.x86_64/Packages/
[root@invcdr1/invcdr2 Packages]# yum install -y bind
[root@invcdr1/invcdr2 Packages]# yum install -y dnsmasq
[root@invcdr1/invcdr2 ~]# systemctl enable dnsmasq
[root@invcdr1/invcdr2 ~]# systemctl restart dnsmasq
[root@invcdr1/invcdr2 ~]# vi /etc/dnsmasq.conf
/*
listen-address=::1,127.0.0.1

#Add the following Lines
except-interface=virbr0
bind-interfaces
*/

-- Step 18.1 -->> On Both Node
[root@invcdr1/invcdr2 ~]# systemctl restart dnsmasq
[root@invcdr1/invcdr2 ~]# systemctl restart network
[root@invcdr1/invcdr2 ~]# systemctl status dnsmasq
/*
● dnsmasq.service - DNS caching server.
   Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2022-12-22 15:05:59 +0545; 1s ago
 Main PID: 3689 (dnsmasq)
    Tasks: 1
   CGroup: /system.slice/dnsmasq.service
           └─3689 /usr/sbin/dnsmasq -k

Dec 22 15:05:59 invcdr1.unidev.com dnsmasq[3689]: started, version 2.76 cachesize 150
Dec 22 15:05:59 invcdr1.unidev.com dnsmasq[3689]: compile time options: IPv6 GNU-getopt DBus no-i18n IDN DH...tify
Dec 22 15:05:59 invcdr1.unidev.com dnsmasq[3689]: reading /etc/resolv.conf
Dec 22 15:05:59 invcdr1.unidev.com dnsmasq[3689]: ignoring nameserver 127.0.0.1 - local interface
Dec 22 15:05:59 invcdr1.unidev.com dnsmasq[3689]: using nameserver 192.1.1.88#53
Dec 22 15:05:59 invcdr1.unidev.com dnsmasq[3689]: read /etc/hosts - 11 addresses
Dec 22 15:06:00 invcdr1.unidev.com dnsmasq[3689]: no servers found in /etc/resolv.conf, will retry
Dec 22 15:06:01 invcdr1.unidev.com dnsmasq[3689]: reading /etc/resolv.conf
Dec 22 15:06:01 invcdr1.unidev.com dnsmasq[3689]: ignoring nameserver 127.0.0.1 - local interface
Dec 22 15:06:01 invcdr1.unidev.com dnsmasq[3689]: using nameserver 192.1.1.88#53
Hint: Some lines were ellipsized, use -l to show in full.
*/

-- Step 19 -->> On Node 1
[root@invcdr1 ~]# nslookup 192.1.1.48
/*
48.6.16.172.in-addr.arpa        name = invcdr1.unidev.com.
*/

-- Step 19.1 -->> On Node 1
[root@invcdr1 ~]# nslookup 192.1.1.49
/*
48.6.16.172.in-addr.arpa        name = invcdr2.unidev.com.
*/

-- Step 20 -->> On Both Node
[root@invcdr1/invcdr2 ~]# nslookup invcdr1
/*
Server:         192.1.1.88
Address:        192.1.1.88#53

Name:   invcdr1.unidev.com
Address: 192.1.1.48
*/

-- Step 20.1 -->> On Both Node
[root@invcdr1/invcdr2 ~]# nslookup invcdr2
/*
Server:         192.1.1.88
Address:        192.1.1.88#53

Name:   invcdr2.unidev.com
Address: 192.1.1.49
*/

-- Step 20.2 -->> On Both Node
[root@invcdr1/invcdr2 ~]# nslookup invcdr-scan
/*
Server:         192.1.1.88
Address:        192.1.1.88#53

Name:   invcdr-scan.unidev.com
Address: 192.1.1.54
Name:   invcdr-scan.unidev.com
Address: 192.1.1.53
Name:   invcdr-scan.unidev.com
Address: 192.1.1.52
*/
-- Step 21 -->> On Both Node
--Stop avahi-daemon damon if it not configured
[root@invcdr1/invcdr2 ~]# systemctl stop avahi-daemon
[root@invcdr1/invcdr2 ~]# systemctl disable avahi-daemon

-- Step 22 -->> On Both Node
--To Remove virbr0 and lxcbr0 Network Interfac
[root@invcdr1/invcdr2 ~]# systemctl stop libvirtd.service
[root@invcdr1/invcdr2 ~]# systemctl disable libvirtd.service
[root@invcdr1/invcdr2 ~]# virsh net-list
[root@invcdr1/invcdr2 ~]# virsh net-destroy default
[root@invcdr1/invcdr2 ~]# ifconfig virbr0
/*
virbr0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 192.168.122.1  netmask 255.255.255.0  broadcast 192.168.122.255
        ether 52:54:00:21:f5:18  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 22.1 -->> On Both Node
[root@invcdr1/invcdr2 ~]# brctl show
/*
bridge name     bridge id               STP enabled     interfaces
virbr0          8000.52540010038b       yes             virbr0-nic
*/

-- Step 22.2 -->> On Both Node
[root@invcdr1/invcdr2 ~]# ip link set virbr0 down
[root@invcdr1/invcdr2 ~]# brctl delbr virbr0
[root@invcdr1/invcdr2 ~]# brctl show
/*
bridge name     bridge id               STP enabled     interfaces
*/

-- Step 22.3 -->> On Both Node
[root@invcdr1/invcdr2 ~]# ifconfig virbr0
/*
virbr0: error fetching interface information: Device not found
*/

-- Step 22.4 -->> On Both Node
[root@invcdr1 ~]# ifconfig
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.1.1.48  netmask 255.255.255.0  broadcast 192.1.1.255
        inet6 fe80::250:56ff:feac:7a05  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:7a:05  txqueuelen 1000  (Ethernet)
        RX packets 6171  bytes 5063416 (4.8 MiB)
        RX errors 0  dropped 11  overruns 0  frame 0
        TX packets 3414  bytes 512431 (500.4 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.1.48  netmask 255.255.255.0  broadcast 10.0.1.255
        inet6 fe80::250:56ff:feac:bc8  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:0b:c8  txqueuelen 1000  (Ethernet)
        RX packets 414  bytes 35718 (34.8 KiB)
        RX errors 0  dropped 10  overruns 0  frame 0
        TX packets 94  bytes 11252 (10.9 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 146  bytes 11304 (11.0 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 146  bytes 11304 (11.0 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 22.5 -->> On Both Node
[root@invcdr2 ~]# ifconfig
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.1.1.49  netmask 255.255.255.0  broadcast 192.1.1.255
        inet6 fe80::250:56ff:feac:2699  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:26:99  txqueuelen 1000  (Ethernet)
        RX packets 91293  bytes 134007307 (127.7 MiB)
        RX errors 0  dropped 42  overruns 0  frame 0
        TX packets 9342  bytes 867991 (847.6 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.1.49  netmask 255.255.255.0  broadcast 10.0.1.255
        inet6 fe80::250:56ff:feac:619b  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:61:9b  txqueuelen 1000  (Ethernet)
        RX packets 741  bytes 61952 (60.5 KiB)
        RX errors 0  dropped 41  overruns 0  frame 0
        TX packets 97  bytes 11624 (11.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 140  bytes 11190 (10.9 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 140  bytes 11190 (10.9 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 23 -->> On Both Node
[root@invcdr1/invcdr2 ~]# init 6

-- Step 24 -->> On Both Node
[root@invcdr1/invcdr2 ~]# brctl show
/*
bridge name     bridge id               STP enabled     interfaces
*/

-- Step 25 -->> On Both Node
[root@invcdr1/invcdr2 ~]# systemctl status libvirtd.service
/*
? libvirtd.service - Virtualization daemon
   Loaded: loaded (/usr/lib/systemd/system/libvirtd.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:libvirtd(8)
           https://libvirt.org
*/

-- Step 26 -->> On Both Node
[root@invcdr1/invcdr2 ~]# firewall-cmd --list-all
/*
FirewallD is not running
*/

-- Step 26.1 -->> On Both Node
[root@invcdr1/invcdr2 ~]# systemctl status firewalld
/*
? firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; vendor >
   Active: inactive (dead)
     Docs: man:firewalld(1)
*/

-- Step 27 -->> On Both Node
[root@invcdr1/invcdr2 ~]# systemctl status ntpd
/*
? ntpd.service - Network Time Service
   Loaded: loaded (/usr/lib/systemd/system/ntpd.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
*/

-- Step 28 -->> On Both Node
[root@invcdr1/invcdr2 ~]# systemctl status named
/*
? named.service - Berkeley Internet Name Domain (DNS)
   Loaded: loaded (/usr/lib/systemd/system/named.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
*/

-- Step 29 -->> On Both Node
[root@invcdr1/invcdr2 ~]# systemctl status avahi-daemon
/*
? avahi-daemon.service - Avahi mDNS/DNS-SD Stack
   Loaded: loaded (/usr/lib/systemd/system/avahi-daemon.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
*/

-- Step 30 -->> On Both Node
[root@invcdr1/invcdr2 ~ ]# systemctl status chronyd
/*
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: active (running) since Thu 2022-12-22 15:12:02 +0545; 1min 46s ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 1042 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, status=0/SUCCESS)
  Process: 956 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 974 (chronyd)
   CGroup: /system.slice/chronyd.service
           └─974 /usr/sbin/chronyd

Dec 22 15:11:07 invcdr1.unidev.com systemd[1]: Starting NTP client/server...
Dec 22 15:11:07 invcdr1.unidev.com chronyd[974]: chronyd version 3.4 starting (+CMDMON +NTP +REFCLOCK +RTC ...BUG)
Dec 22 15:11:07 invcdr1.unidev.com chronyd[974]: Frequency -8.187 +/- 0.224 ppm read from /var/lib/chrony/drift
Dec 22 15:12:02 invcdr1.unidev.com systemd[1]: Started NTP client/server.
Dec 22 15:12:03 invcdr1.unidev.com chronyd[974]: Forward time jump detected!
Dec 22 15:12:09 invcdr1.unidev.com chronyd[974]: Selected source 82.141.152.3
Dec 22 15:12:09 invcdr1.unidev.com chronyd[974]: System clock wrong by -53.788833 seconds, adjustment started
Dec 22 15:11:15 invcdr1.unidev.com chronyd[974]: System clock was stepped by -53.788833 seconds
Dec 22 15:11:17 invcdr1.unidev.com chronyd[974]: Selected source 167.86.115.96
Dec 22 15:12:21 invcdr1.unidev.com chronyd[974]: Selected source 217.198.219.102
Hint: Some lines were ellipsized, use -l to show in full.
*/

-- Step 31 -->> On Both Node
[root@invcdr1/invcdr2 ~]# systemctl status dnsmasq
/*
● dnsmasq.service - DNS caching server.
   Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2022-12-22 15:12:03 +0545; 2min 26s ago
 Main PID: 1440 (dnsmasq)
   CGroup: /system.slice/dnsmasq.service
           └─1440 /usr/sbin/dnsmasq -k

Dec 22 15:12:03 invcdr1.unidev.com systemd[1]: Started DNS caching server..
Dec 22 15:12:03 invcdr1.unidev.com dnsmasq[1440]: listening on lo(#1): 127.0.0.1
Dec 22 15:12:03 invcdr1.unidev.com dnsmasq[1440]: listening on lo(#1): ::1
Dec 22 15:12:03 invcdr1.unidev.com dnsmasq[1440]: started, version 2.76 cachesize 150
Dec 22 15:12:03 invcdr1.unidev.com dnsmasq[1440]: compile time options: IPv6 GNU-getopt DBus no-i18n IDN DH...tify
Dec 22 15:12:03 invcdr1.unidev.com dnsmasq[1440]: reading /etc/resolv.conf
Dec 22 15:12:03 invcdr1.unidev.com dnsmasq[1440]: ignoring nameserver 127.0.0.1 - local interface
Dec 22 15:12:03 invcdr1.unidev.com dnsmasq[1440]: using nameserver 192.1.1.88#53
Dec 22 15:12:03 invcdr1.unidev.com dnsmasq[1440]: read /etc/hosts - 11 addresses
Hint: Some lines were ellipsized, use -l to show in full.
*/

-- Step 31.1 -->> On Both Node
[root@invcdr1/invcdr2 ~]# nslookup 192.1.1.48
/*
48.6.16.172.in-addr.arpa        name = invcdr1.unidev.com.
*/

-- Step 31.2 -->> On Both Node
[root@invcdr1/invcdr2 ~]# nslookup 192.1.1.49
/*
49.6.16.172.in-addr.arpa        name = invcdr2.unidev.com.
*/

-- Step 31.3 -->> On Both Node
[root@invcdr1/invcdr2 ~]# nslookup invcdr1
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   invcdr1.unidev.com
Address: 192.1.1.48
*/

-- Step 31.4 -->> On Both Node
[root@invcdr1/invcdr2 ~]# nslookup invcdr2
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   invcdr2.unidev.com
Address: 192.1.1.49
*/

-- Step 31.5 -->> On Both Node
[root@invcdr1/invcdr2 ~]# nslookup invcdr-scan
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   invcdr-scan.unidev.com
Address: 192.1.1.54
Name:   invcdr-scan.unidev.com
Address: 192.1.1.52
Name:   invcdr-scan.unidev.com
Address: 192.1.1.53
*/

-- Step 31.6 -->> On Both Node
[root@invcdr1/invcdr2 ~]# nslookup invcdr2-vip
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   invcdr2-vip.unidev.com
Address: 192.1.1.43
*/

-- Step 31.7 -->> On Both Node
[root@invcdr1/invcdr2 ~]# nslookup invcdr1-vip
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   invcdr1-vip.unidev.com
Address: 192.1.1.42
*/

-- Step 31.8 -->> On Both Node
[root@invcdr1/invcdr2 ~]# iptables -L -nv
/*
Chain INPUT (policy ACCEPT 2066 packets, 5110K bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy ACCEPT 1772 packets, 117K bytes)
 pkts bytes target     prot opt in     out     source               destination
*/


-- Step 32 -->> On Both Node
-- Perform either the Automatic Setup or the Manual Setup to complete the basic prerequisites. 
[root@invcdr1/invcdr2 ~]# cd /run/media/root/OL-7.8\ Server.x86_64/Packages/
[root@invcdr1/invcdr2 Packages]# yum update

-- Step 32.1 -->> On Both Node
[root@invcdr1/invcdr2 Packages]# yum install -y yum-utils
[root@invcdr1/invcdr2 Packages]# yum install -y oracle-epel-release-el7
[root@invcdr1/invcdr2 Packages]# yum-config-manager --enable ol7_developer_EPEL
[root@invcdr1/invcdr2 Packages]# yum install -y sshpass zip unzip
[root@invcdr1/invcdr2 Packages]# yum install -y oracle-database-preinstall-19c

-- Step 32.2 -->> On Both Node
[root@invcdr1/invcdr2 Packages]# yum install -y bc    
[root@invcdr1/invcdr2 Packages]# yum install -y binutils
[root@invcdr1/invcdr2 Packages]# yum install -y compat-libcap1
[root@invcdr1/invcdr2 Packages]# yum install -y compat-libstdc++-33
[root@invcdr1/invcdr2 Packages]# yum install -y dtrace-utils
[root@invcdr1/invcdr2 Packages]# yum install -y elfutils-libelf
[root@invcdr1/invcdr2 Packages]# yum install -y elfutils-libelf-devel
[root@invcdr1/invcdr2 Packages]# yum install -y fontconfig-devel
[root@invcdr1/invcdr2 Packages]# yum install -y glibc
[root@invcdr1/invcdr2 Packages]# yum install -y glibc-devel
[root@invcdr1/invcdr2 Packages]# yum install -y ksh
[root@invcdr1/invcdr2 Packages]# yum install -y libaio
[root@invcdr1/invcdr2 Packages]# yum install -y libaio-devel
[root@invcdr1/invcdr2 Packages]# yum install -y libdtrace-ctf-devel
[root@invcdr1/invcdr2 Packages]# yum install -y libXrender
[root@invcdr1/invcdr2 Packages]# yum install -y libXrender-devel
[root@invcdr1/invcdr2 Packages]# yum install -y libX11
[root@invcdr1/invcdr2 Packages]# yum install -y libXau
[root@invcdr1/invcdr2 Packages]# yum install -y libXi
[root@invcdr1/invcdr2 Packages]# yum install -y libXtst
[root@invcdr1/invcdr2 Packages]# yum install -y libgcc
[root@invcdr1/invcdr2 Packages]# yum install -y librdmacm-devel
[root@invcdr1/invcdr2 Packages]# yum install -y libstdc++
[root@invcdr1/invcdr2 Packages]# yum install -y libstdc++-devel
[root@invcdr1/invcdr2 Packages]# yum install -y libxcb
[root@invcdr1/invcdr2 Packages]# yum install -y make
[root@invcdr1/invcdr2 Packages]# yum install -y net-tools
[root@invcdr1/invcdr2 Packages]# yum install -y nfs-utils
[root@invcdr1/invcdr2 Packages]# yum install -y python
[root@invcdr1/invcdr2 Packages]# yum install -y python-configshell
[root@invcdr1/invcdr2 Packages]# yum install -y python-rtslib
[root@invcdr1/invcdr2 Packages]# yum install -y python-six
[root@invcdr1/invcdr2 Packages]# yum install -y targetcli
[root@invcdr1/invcdr2 Packages]# yum install -y smartmontools
[root@invcdr1/invcdr2 Packages]# yum install -y sysstat
[root@invcdr1/invcdr2 Packages]# yum install -y unixODBC
[root@invcdr1/invcdr2 Packages]# yum install -y chrony
[root@invcdr1/invcdr2 Packages]# rpm -iUvh glibc-2*i686* nss-softokn-freebl-3*i686*
[root@invcdr1/invcdr2 Packages]# rpm -iUvh glibc-devel-2*i686*
[root@invcdr1/invcdr2 Packages]# rpm -iUvh libaio-0*i686*
[root@invcdr1/invcdr2 Packages]# rpm -iUvh libaio-devel-0*i686*
[root@invcdr1/invcdr2 Packages]# rpm -iUvh numactl-devel-2*x86_64*
[root@invcdr1/invcdr2 Packages]# rpm -iUvh libtool-ltdl*i686*
[root@invcdr1/invcdr2 Packages]# yum install -y oracleasm*
[root@invcdr1/invcdr2 Packages]# yum -y update


-- Step 33 -->> On Both Node
--https://yum.oracle.com/repo/OracleLinux/OL7/8/base/x86_64/index.html
[root@invcdr1/invcdr2 ~]# cd /root/OracleLinux7_8_RPM/
[root@invcdr1/invcdr2 OracleLinux7_8_RPM]# rpm -iUvh compat-libcap1-1.10-7.el7.i686.rpm
[root@invcdr1/invcdr2 OracleLinux7_8_RPM]# rpm -iUvh glibc-utils-2.17-307.0.1.el7.1.x86_64.rpm
[root@invcdr1/invcdr2 OracleLinux7_8_RPM]# rpm -iUvh ncurses-devel-5.9-14.20130511.el7_4.x86_64.rpm
[root@invcdr1/invcdr2 OracleLinux7_8_RPM]# rpm -iUvh unixODBC-devel-2.3.1-14.0.1.el7.x86_64.rpm
[root@invcdr1/invcdr2 OracleLinux7_8_RPM]# rpm -iUvh oracleasmlib-2.0.12-1.el7.x86_64.rpm

-- Step 33.1 -->> On Both Node
[root@invcdr1/invcdr2 OracleLinux7_8_RPM]# rpm -iUvh --nodeps --force elfutils-libelf-devel-static-0.176-2.el7.x86_64.rpm
[root@invcdr1/invcdr2 OracleLinux7_8_RPM]# rpm -iUvh --nodeps --force numactl-2.0.12-5.el7.x86_64.rpm
[root@invcdr1/invcdr2 OracleLinux7_8_RPM]# rpm -iUvh --nodeps --force numactl-devel-2.0.12-5.el7.i686.rpm
[root@invcdr1/invcdr2 OracleLinux7_8_RPM]# rpm -iUvh --nodeps --force numactl-devel-2.0.12-5.el7.x86_64.rpm
[root@invcdr1/invcdr2 OracleLinux7_8_RPM]# rpm -iUvh --nodeps --force python3-3.6.8-13.0.1.el7.x86_64.rpm
[root@invcdr1/invcdr2 OracleLinux7_8_RPM]# rpm -iUvh --nodeps --force python3-libs-3.6.8-13.0.1.el7.i686.rpm
[root@invcdr1/invcdr2 OracleLinux7_8_RPM]# rpm -iUvh --nodeps --force python3-libs-3.6.8-13.0.1.el7.x86_64.rpm


-- Step 34 -->> On Both Node
[root@invcdr1/invcdr2 ~]# cd /run/media/root/OL-7.8\ Server.x86_64/Packages/
[root@invcdr1/invcdr2 Packages]# yum install compat-libcap1 compat-libstdc++-33 bc binutils elfutils-libelf elfutils-libelf-devel fontconfig-devel glibc glibc-devel ksh libaio libaio-devel libgcc libnsl librdmacm-devel libstdc++ libstdc++-devel libX11 libXau libxcb libXi libXrender libXrender-devel libXtst make net-tools nfs-utils python3 python3-configshell python3-rtslib python3-six smartmontools sysstat targetcli unzip
[root@invcdr1/invcdr2 Packages]# yum -y update

-- Step 35 -->> On Both Node
[root@invcdr1/invcdr2 Packages]# rpm -q binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel elfutils-libelf-devel-static \
[root@invcdr1/invcdr2 Packages]# rpm -q gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers kernel-headers ksh libaio libaio-devel \
[root@invcdr1/invcdr2 Packages]# rpm -q libgcc libgomp libstdc++ libstdc++-devel make numactl-devel sysstat unixODBC unixODBC-devel \


-- Step 36 -->> On Both Node
-- Pre-Installation Steps for ASM
[root@invcdr1/invcdr2 ~ ]# cd /etc/yum.repos.d
[root@invcdr1/invcdr2 yum.repos.d]# uname -ras
/*
Linux invcdr1.unidev.com 4.14.35-1902.300.11.el7uek.x86_64 #2 SMP Tue Mar 17 17:11:47 PDT 2020 x86_64 x86_64 x86_64 GNU/Linux
*/

-- Step 36.1 -->> On Both Node
[root@invcdr1/invcdr2 yum.repos.d]# cat /etc/os-release 
/*
NAME="Oracle Linux Server"
VERSION="7.9"
ID="ol"
ID_LIKE="fedora"
VARIANT="Server"
VARIANT_ID="server"
VERSION_ID="7.9"
PRETTY_NAME="Oracle Linux Server 7.9"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:oracle:linux:7:9:server"
HOME_URL="https://linux.oracle.com/"
BUG_REPORT_URL="https://bugzilla.oracle.com/"

ORACLE_BUGZILLA_PRODUCT="Oracle Linux 7"
ORACLE_BUGZILLA_PRODUCT_VERSION=7.9
ORACLE_SUPPORT_PRODUCT="Oracle Linux"
ORACLE_SUPPORT_PRODUCT_VERSION=7.9
*/

-- Step 36.2 -->> On Both Node
[root@invcdr1/invcdr2 yum.repos.d]# yum install kmod-oracleasm
[root@invcdr1/invcdr2 yum.repos.d]# yum install oracleasm-support

-- Step 36.3 -->> On Both Node
[root@invcdr1/invcdr2 yum.repos.d]# rpm -qa | grep oracleasm
/*
oracleasmlib-2.0.12-1.el7.x86_64
oracleasm-support-2.1.11-2.el7.x86_64
kmod-oracleasm-2.0.8-27.0.1.el7.x86_64
*/

-- Step 37 -->> On Both Node
-- Add the kernel parameters file "/etc/sysctl.conf" and add oracle recommended kernel parameters
[root@invcdr1/invcdr2 ~]# vi /etc/sysctl.conf
/*
fs.file-max = 6815744
kernel.sem = 250 32000 100 128
kernel.shmmni = 65536
kernel.shmall = 1073741824
kernel.shmmax = 4398046511104
kernel.panic_on_oops = 1
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048576
net.ipv4.conf.all.rp_filter = 2
net.ipv4.conf.default.rp_filter = 2
fs.aio-max-nr = 1048576
net.ipv4.ip_local_port_range = 9000 65500
*/

-- Step 37.1 -->> On Both Node
-- Run the following command to change the current kernel parameters.
[root@invcdr1/invcdr2 ~]# sysctl -p /etc/sysctl.conf

-- Step 38 -->> On Both Node
-- Edit “/etc/security/limits.d/oracle-database-preinstall-19c.conf” file to limit user processes
[root@invcdr1/invcdr2 ~]# vi /etc/security/limits.d/oracle-database-preinstall-19c.conf
/*
oracle   soft   nofile  65536
oracle   hard   nofile  65536
oracle   soft   nproc   16384
oracle   hard   nproc   16384
oracle   soft   stack   10240
oracle   hard   stack   32768
oracle   hard   memlock 134217728
oracle   soft   memlock 134217728
oracle   soft   data    unlimited
oracle   hard   data    unlimited

grid    soft    nofile   65536
grid    hard    nofile   65536
grid    soft    nproc    16384
grid    hard    nproc    16384
grid    soft    stack    10240
grid    hard    stack    32768
grid    soft    memlock  134217728
grid    hard    memlock  134217728
grid    soft    data     unlimited
grid    hard    data     unlimited
*/

-- Step 39 -->> On Both Node
-- Add the following line to the "/etc/pam.d/login" file, if it does not already exist.
[root@invcdr1/invcdr2 ~]# vi /etc/pam.d/login
/*
#%PAM-1.0
auth [user_unknown=ignore success=ok ignore=ignore default=bad] pam_securetty.so
auth       include      system-auth
account    required     pam_nologin.so
account    include      system-auth
password   include      system-auth
# pam_selinux.so close should be the first session rule
session    required     pam_selinux.so close
session    required     pam_loginuid.so
session    optional     pam_console.so
# pam_selinux.so open should only be followed by sessions to be executed in the user context
session    required     pam_selinux.so open
session    required     pam_namespace.so
session    optional     pam_keyinit.so force revoke
session    include      system-auth
-session    optional    pam_ck_connector.so
*/

-- Step 40 -->> On both Node
-- Create the new groups and users.
[root@invcdr1/invcdr2 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:
*/

-- Step 40.1 -->> On both Node
[root@invcdr1/invcdr2 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:
backupdba:x:54324:
dgdba:x:54325:
kmdba:x:54326:
invcdrdba:x:54330:
*/

-- Step 40.2 -->> On both Node
[root@invcdr1/invcdr2 ~]# cat /etc/group | grep -i oracle
/*
oracle:x:1000:oracle
*/

-- Step 40.3 -->> On both Node
[root@invcdr1/invcdr2 ~]# cat /etc/group | grep -i asm

-- Step 40.4 -->> On both Node
-- 1.Create OS groups using the command below. Enter these commands as the 'root' user:
[root@invcdr1/invcdr2 ~]# /usr/sbin/groupadd -g 503 oper
[root@invcdr1/invcdr2 ~]# /usr/sbin/groupadd -g 504 asmadmin
[root@invcdr1/invcdr2 ~]# /usr/sbin/groupadd -g 506 asmdba
[root@invcdr1/invcdr2 ~]# /usr/sbin/groupadd -g 507 asmoper
[root@invcdr1/invcdr2 ~]# /usr/sbin/groupadd -g 508 beoper

-- Step 40.5 -->> On both Node
-- 2.Create the users that will own the Oracle software using the commands:
[root@invcdr1/invcdr2 ~]# /usr/sbin/useradd  -g oinstall -G oinstall,dba,asmadmin,asmdba,asmoper,beoper grid
[root@invcdr1/invcdr2 ~]# /usr/sbin/usermod -g oinstall -G oinstall,dba,oper,asmdba,asmadmin,backupdba,dgdba,kmdba,racdba oracle

-- Step 40.6 -->> On both Node
[root@invcdr1/invcdr2 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/

-- Step 40.7 -->> On both Node
[root@invcdr1/invcdr2 ~]# cat /etc/group | grep -i oracle
/*
oracle:x:1000:
oinstall:x:54321:grid,oracle
dba:x:54322:grid,oracle
oper:x:54323:oracle
backupdba:x:54324:oracle
dgdba:x:54325:oracle
kmdba:x:54326:oracle
racdba:x:54330:oracle
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
*/

-- Step 40.8 -->> On both Node
[root@invcdr1/invcdr2 ~]# cat /etc/group | grep -i grid
/*
oinstall:x:54321:grid,oracle
dba:x:54322:grid,oracle
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 40.9 -->> On both Node
[root@invcdr1/invcdr2 ~]# cat /etc/group | grep -i oper
/*
oper:x:54323:oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 40.10 -->> On both Node
[root@invcdr1/invcdr2 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:grid,oracle
*/

-- Step 40.11 -->> On both Node
[root@invcdr1/invcdr2 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:grid,oracle
backupdba:x:54324:oracle
dgdba:x:54325:oracle
kmdba:x:54326:oracle
invcdrdba:x:54330:oracle
asmdba:x:506:grid,oracle
*/

-- Step 40.12 -->> On both Node
[root@invcdr1/invcdr2 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/

-- Step 41 -->> On both Node
[root@invcdr1/invcdr2 ~]# passwd oracle
/*
Changing password for user oracle.
New password: Or@cL5@!Nv#
Retype new password: Or@cL5@!Nv#
passwd: all authentication tokens updated successfully.
*/

-- Step 42 -->> On both Node
[root@invcdr1/invcdr2 ~]# passwd grid
/*
Changing password for user grid.
New password: Gr!D4@!Nv#
Retype new password: Gr!D4@!Nv#
passwd: all authentication tokens updated successfully.
*/

-- Step 42.1 -->> On both Node
[root@invcdr1/invcdr2 ~]# su - oracle

-- Step 42.2 -->> On both Node
[oracle@invcdr1/invcdr2 ~]$ su - grid
/*
Password: Gr!D4@!Nv#
*/

-- Step 42.3 -->> On both Node
[grid@invcdr1/invcdr2 ~]$ su - oracle
/*
Password: Or@cL5@!Nv#
*/

-- Step 42.4 -->> On both Node
[oracle@invcdr1/invcdr2 ~]$ exit
/*
logout
*/

-- Step 42.5 -->> On both Node
[grid@invcdr1/invcdr2 ~]$ exit
/*
logout
*/

-- Step 42.6 -->> On both Node
[oracle@invcdr1/invcdr2 ~]$ exit
/*
logout
*/


-- Step 43 -->> On both Node
--Create the Oracle Inventory Director:
[root@invcdr1/invcdr2 ~]# mkdir -p /opt/app/oraInventory
[root@invcdr1/invcdr2 ~]# chown -R grid:oinstall /opt/app/oraInventory
[root@invcdr1/invcdr2 ~]# chmod -R 775 /opt/app/oraInventory

-- Step 44 -->> On both Node
--Creating the Oracle Grid Infrastructure Home Directory:
[root@invcdr1/invcdr2 ~]# mkdir -p /opt/app/19c/grid
[root@invcdr1/invcdr2 ~]# chown -R grid:oinstall /opt/app/19c/grid
[root@invcdr1/invcdr2 ~]# chmod -R 775 /opt/app/19c/grid

-- Step 45 -->> On both Node
--Creating the Oracle Base Directory
[root@invcdr1/invcdr2 ~]# mkdir -p /opt/app/oracle
[root@invcdr1/invcdr2 ~]# chmod -R 775 /opt/app/oracle
[root@invcdr1/invcdr2 ~]# cd /opt/app/
[root@invcdr1/invcdr2 ~]# chown -R oracle:oinstall /opt/app/oracle

-- Step 46 -->> On Node 1
-- Login as the oracle user and add the following lines at the end of the ".bash_profile" file.
[root@invcdr1 ~]# su - oracle
[oracle@invcdr1 ~]$ vi .bash_profile
/*
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]: then
        . ~/.bashrc
fi

# User specfic environment and startup programs
#PATH=$PATH:$HOME/bin
#export PATH

# Oracle Settings
TMP=/tmp; export TMP
TMPDIR=$TMP; export TMPDIR

ORACLE_HOSTNAME=invcdr1.unidev.com; export ORACLE_HOSTNAME
ORACLE_UNQNAME=invoicedb; export ORACLE_UNQNAME
ORACLE_BASE=/opt/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/19c/db_1; export ORACLE_HOME
ORACLE_SID=invcdr1; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 47 -->> On Node 1
[oracle@invcdr1 ~]$ . .bash_profile

-- Step 48 -->> On Node 1
-- Login as the grid user and add the following lines at the end of the ".bash_profile" file.
[root@invcdr1 ~]# su - grid
[grid@invcdr1 ~]$ vi .bash_profile
/*
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]: then
        . ~/.bashrc
fi

# User specfic environment and startup programs
#PATH=$PATH:$HOME/bin
#export PATH

# Grid Settings
TMP=/tmp; export TMP
TMPDIR=$TMP; export TMPDIR

ORACLE_SID=+ASM1; export ORACLE_SID
ORACLE_BASE=/opt/app/oracle; export ORACLE_BASE
GRID_HOME=/opt/app/19c/grid; export GRID_HOME
ORACLE_HOME=$GRID_HOME; export ORACLE_HOME

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 49 -->> On Node 1
[grid@invcdr1 ~]$ . .bash_profile

-- Step 50 -->> On Node 2
-- Login as the oracle user and add the following lines at the end of the ".bash_profile" file.
[root@invcdr2 ~]# su - oracle
[oracle@invcdr2 ~]$ vi .bash_profile
/*
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]: then
        . ~/.bashrc
fi

# User specfic environment and startup programs
#PATH=$PATH:$HOME/bin
#export PATH

# Oracle Settings
TMP=/tmp; export TMP
TMPDIR=$TMP; export TMPDIR

ORACLE_HOSTNAME=invcdr2.unidev.com; export ORACLE_HOSTNAME
ORACLE_UNQNAME=invoicedb; export ORACLE_UNQNAME
ORACLE_BASE=/opt/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/19c/db_1; export ORACLE_HOME
ORACLE_SID=invcdr2; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 51 -->> On Node 2
[oracle@invcdr2 ~]$ . .bash_profile

-- Step 52 -->> On Node 2
-- Login as the grid user and add the following lines at the end of the ".bash_profile" file.
[root@invcdr2 ~]# su - grid
[grid@invcdr2 ~]$ vi .bash_profile
/*
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]: then
        . ~/.bashrc
fi

# User specfic environment and startup programs
#PATH=$PATH:$HOME/bin
#export PATH

# Grid Settings
TMP=/tmp; export TMP
TMPDIR=$TMP; export TMPDIR

ORACLE_SID=+ASM2; export ORACLE_SID
ORACLE_BASE=/opt/app/oracle; export ORACLE_BASE
GRID_HOME=/opt/app/19c/grid; export GRID_HOME
ORACLE_HOME=$GRID_HOME; export ORACLE_HOME

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 53 -->> On Node 2
[grid@invcdr2 ~]$ . .bash_profile

-- Step 54 -->> On Node 1
-- To Unzio The Oracle Grid Software and lateset Opatch
[root@invcdr1 ~]# cd /opt/app/19c/grid/
[root@invcdr1 grid]# unzip -oq /root/19.3.0.0.0/LINUX.X64_193000_grid_home.zip
[root@invcdr1 grid]# unzip -oq /root/PSU_19.7.0.0.0/p6880880_190000_LINUX.zip

-- Step 55 -->> On Node 1
-- To Unzio The Oracle PSU
[root@invcdr1 ~]# cd /tmp/
[root@invcdr1 tmp]# unzip -oq /root/PSU_19.7.0.0.0/p30783556_190000_Linux-x86-64.zip
[root@invcdr1 tmp]# chown -R oracle:oinstall 30783556
[root@invcdr1 tmp]# chmod -R 775 30783556
[root@invcdr1 tmp]# ls -ltr | grep 30783556
/*
drwxrwxr-x  4 oracle oinstall   4096 Apr 14  2020 30783556
*/

-- Step 56 -->> On Node 1
-- Login as root user and issue the following command at invcdr1
[root@invcdr1 ~]# chown -R grid:oinstall /opt/app/19c/grid/
[root@invcdr1 ~]# chmod -R 775 /opt/app/19c/grid/

-- Step 57 -->> On Node 1
[root@invcdr1 ~]# scp -r /opt/app/19c/grid/cv/rpm/cvuqdisk-1.0.10-1.rpm root@invcdr2:/tmp/
/*
The authenticity of host 'invcdr2 (192.1.1.49)' can't be established.
ECDSA key fingerprint is SHA256:xbrtUbvMFe/Qk3JlBjTr6BA36PUaGkNpW9i/+2IwSTY.
ECDSA key fingerprint is MD5:9c:57:05:c6:13:51:73:97:f7:40:c7:7c:8a:5c:f9:0f.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'invcdr2,192.1.1.49' (ECDSA) to the list of known hosts.
root@invcdr2's password:
cvuqdisk-1.0.10-1.rpm                                                            100%   11KB   9.1MB/s   00:00
*/

-- Step 58 -->> On Node 1
-- To install the cvuqdisk-1.0.10-1.rpm
-- Login from root user
[root@invcdr1 ~]# cd /opt/app/19c/grid/cv/rpm/

-- Step 58.1 -->> On Node 1
[root@invcdr1 rpm]# ls -ltr
/*
-rwxrwxr-x 1 grid oinstall 11412 Mar 13  2019 cvuqdisk-1.0.10-1.rpm
*/

-- Step 58.2 -->> On Node 1
[root@invcdr1 rpm]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP

-- Step 58.3 -->> On Node 1
[root@invcdr1 rpm]# rpm -iUvh cvuqdisk-1.0.10-1.rpm 
/*
Preparing...                          ################################# [100%]
Updating / installing...
   1:cvuqdisk-1.0.10-1                ################################# [100%]
*/

-- Step 59 -->> On Node 2
[root@invcdr2 ~]# cd /tmp/
[root@invcdr2 tmp]# chown -R grid:oinstall cvuqdisk-1.0.10-1.rpm
[root@invcdr2 tmp]# chmod -R 775 cvuqdisk-1.0.10-1.rpm
[root@invcdr2 tmp]# ls -ltr | grep cvuqdisk-1.0.10-1.rpm
/*
-rwxrwxr-x  1 grid oinstall 11412 Nov  7 10:36 cvuqdisk-1.0.10-1.rpm
*/

-- Step 60 -->> On Node 2
-- To install the cvuqdisk-1.0.10-1.rpm
-- Login from root user
[root@invcdr2 ~]# cd /tmp/
[root@invcdr2 tmp]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP
[root@invcdr2 tmp]# rpm -iUvh cvuqdisk-1.0.10-1.rpm 
/*
Preparing...                          ################################# [100%]
Updating / installing...
   1:cvuqdisk-1.0.10-1                ################################# [100%]
*/

-- Step 61 -->> On all Node
[root@invcdr1/invcdr2 ~]# which oracleasm
/*
/usr/sbin/oracleasm
*/

-- Step 62 -->> On all Node
[root@invcdr1/invcdr2 ~]# oracleasm configure
/*
OracLEASM_ENABLED=false
OracLEASM_UID=
OracLEASM_GID=
OracLEASM_SCANBOOT=true
OracLEASM_SCANORDER=""
OracLEASM_SCANEXCLUDE=""
OracLEASM_SCAN_DIRECTORIES=""
OracLEASM_USE_LOGICAL_BLOCK_SIZE="false"
*/

-- Step 63 -->> On all Node
[root@invcdr1/invcdr2 ~]# oracleasm status
/*
Checking if ASM is loaded: no
Checking if /dev/oracleasm is mounted: no
*/

-- Step 64 -->> On all Node
[root@invcdr1/invcdr2 ~]# oracleasm configure -i
/*
Configuring the Oracle ASM library driver.

This will configure the on-boot properties of the Oracle ASM library
driver.  The following questions will determine whether the driver is
loaded on boot and what permissions it will have.  The current values
will be shown in brackets ('[]').  Hitting <ENTER> without typing an
answer will keep that current value.  Ctrl-C will abort.

Default user to own the driver interface []: grid
Default group to own the driver interface []: asmadmin
Start Oracle ASM library driver on boot (y/n) [n]: y
Scan for Oracle ASM disks on boot (y/n) [y]: y
Writing Oracle ASM library driver configuration: done
*/

-- Step 65 -->> On all Node
[root@invcdr1/invcdr2 ~]# oracleasm configure
/*
OracLEASM_ENABLED=true
OracLEASM_UID=grid
OracLEASM_GID=asmadmin
OracLEASM_SCANBOOT=true
OracLEASM_SCANORDER=""
OracLEASM_SCANEXCLUDE=""
OracLEASM_SCAN_DIRECTORIES=""
OracLEASM_USE_LOGICAL_BLOCK_SIZE="false"
*/

-- Step 66 -->> On all Node
[root@invcdr1/invcdr2 ~]# oracleasm init
/*
Creating /dev/oracleasm mount point: /dev/oracleasm
Loading module "oracleasm": oracleasm
Configuring "oracleasm" to use device physical block size
Mounting ASMlib driver filesystem: /dev/oracleasm
*/

-- Step 67 -->> On all Node
[root@invcdr1/invcdr2 ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 68 -->> On all Node
[root@invcdr1/invcdr2 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 69 -->> On all Node
[root@invcdr1/invcdr2 ~]# oracleasm listdisks

[root@invcdr1/invcdr2 ~]# ls -ltr /etc/init.d/
/*
-rwxr-xr-x  1 root root  4954 Feb  3  2018 oracleasm
-rwxr-xr-x. 1 root root  2437 Feb  6  2018 rhnsd
-rwxr-xr-x  1 root root  4569 May 22  2020 netconsole
-rw-r--r--  1 root root 18281 May 22  2020 functions
-rwx------  1 root root  1281 Apr  1  2021 oracle-database-preinstall-19c-firstboot
-rwxr-xr-x  1 root root  9198 Apr 26  2022 network
-rw-r--r--  1 root root  1160 Dec  7 21:36 README
-rwxr-xr-x. 1 root root 40189 Dec 22 12:47 vmware-tools
*/

-- Step 70 -->> On Both Node
[root@invcdr1/invcdr2 ~]# ls -ll /dev/oracleasm/disks/
/*
total 0
*/

-- Step 71 -->> On Both Node
[root@invcdr1/invcdr2 ~]# ls -ll /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Dec 23 12:44 /dev/sda
brw-rw---- 1 root disk 8,  1 Dec 23 12:44 /dev/sda1
brw-rw---- 1 root disk 8,  2 Dec 23 12:44 /dev/sda2
brw-rw---- 1 root disk 8,  3 Dec 23 12:44 /dev/sda3
brw-rw---- 1 root disk 8,  4 Dec 23 12:44 /dev/sda4
brw-rw---- 1 root disk 8,  5 Dec 23 12:44 /dev/sda5
brw-rw---- 1 root disk 8,  6 Dec 23 12:44 /dev/sda6
brw-rw---- 1 root disk 8,  7 Dec 23 12:44 /dev/sda7
brw-rw---- 1 root disk 8,  8 Dec 23 12:44 /dev/sda8
brw-rw---- 1 root disk 8,  9 Dec 23 12:44 /dev/sda9
brw-rw---- 1 root disk 8, 16 Dec 23 12:44 /dev/sdb
brw-rw---- 1 root disk 8, 32 Dec 23 12:44 /dev/sdc
brw-rw---- 1 root disk 8, 48 Dec 23 12:44 /dev/sdd
*/

-- Step 72 -->> On Node 1
[root@invcdr1 ~]# fdisk -ll | grep GB
/*
Disk /dev/sda: 268.4 GB, 268435456000 bytes, 524288000 sectors
Disk /dev/sdd: 536.9 GB, 536870912000 bytes, 1048576000 sectors
Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
Disk /dev/sdc: 161.1 GB, 161061273600 bytes, 314572800 sectors
*/

-- Step 73 -->> On Node 1
[root@invcdr1 ~]# fdisk /dev/sdb
/*
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0x09767603.

Command (m for help): p

Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x09767603

   Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-41943039, default 2048):
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-41943039, default 41943039):
Using default value 41943039
Partition 1 of type Linux and of size 20 GiB is set

Command (m for help): p

Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x09767603

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048    41943039    20970496   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 74 -->> On Node 1
[root@invcdr1 ~]# fdisk  /dev/sdc
/*
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0x64e887c7.

Command (m for help): p

Disk /dev/sdc: 161.1 GB, 161061273600 bytes, 314572800 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x64e887c7

   Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-314572799, default 2048):
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-314572799, default 314572799):
Using default value 314572799
Partition 1 of type Linux and of size 150 GiB is set

Command (m for help): p

Disk /dev/sdc: 161.1 GB, 161061273600 bytes, 314572800 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x64e887c7

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1            2048   314572799   157285376   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 75 -->> On Node 1
[root@invcdr1 ~]# fdisk /dev/sdd
/*
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0xfed23be3.

Command (m for help): p

Disk /dev/sdd: 536.9 GB, 536870912000 bytes, 1048576000 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0xfed23be3

   Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-1048575999, default 2048):
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-1048575999, default 1048575999):
Using default value 1048575999
Partition 1 of type Linux and of size 500 GiB is set

Command (m for help): p

Disk /dev/sdd: 536.9 GB, 536870912000 bytes, 1048576000 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0xfed23be3

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1            2048  1048575999   524286976   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 76 -->> On Node 1
[root@invcdr1 ~]# ls -ll /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Dec 23 12:44 /dev/sda
brw-rw---- 1 root disk 8,  1 Dec 23 12:44 /dev/sda1
brw-rw---- 1 root disk 8,  2 Dec 23 12:44 /dev/sda2
brw-rw---- 1 root disk 8,  3 Dec 23 12:44 /dev/sda3
brw-rw---- 1 root disk 8,  4 Dec 23 12:44 /dev/sda4
brw-rw---- 1 root disk 8,  5 Dec 23 12:44 /dev/sda5
brw-rw---- 1 root disk 8,  6 Dec 23 12:44 /dev/sda6
brw-rw---- 1 root disk 8,  7 Dec 23 12:44 /dev/sda7
brw-rw---- 1 root disk 8,  8 Dec 23 12:44 /dev/sda8
brw-rw---- 1 root disk 8,  9 Dec 23 12:44 /dev/sda9
brw-rw---- 1 root disk 8, 16 Dec 23 13:51 /dev/sdb
brw-rw---- 1 root disk 8, 17 Dec 23 13:51 /dev/sdb1
brw-rw---- 1 root disk 8, 32 Dec 23 13:52 /dev/sdc
brw-rw---- 1 root disk 8, 33 Dec 23 13:52 /dev/sdc1
brw-rw---- 1 root disk 8, 48 Dec 23 13:52 /dev/sdd
brw-rw---- 1 root disk 8, 49 Dec 23 13:52 /dev/sdd1
*/

-- Step 77 -->> On Both Node
[root@invcdr1/invcdr2 ~]# fdisk -ll | grep sd
/*
Disk /dev/sda: 268.4 GB, 268435456000 bytes, 524288000 sectors
/dev/sda1   *        2048    31459327    15728640   83  Linux
/dev/sda2        31459328   199231487    83886080   83  Linux
/dev/sda3       199231488   366991359    83879936   83  Linux
/dev/sda4       366991360   524287999    78648320    5  Extended
/dev/sda5       366995456   398452735    15728640   83  Linux
/dev/sda6       398454784   429912063    15728640   82  Linux swap / Solaris
/dev/sda7       429914112   461371391    15728640   83  Linux
/dev/sda8       461373440   492830719    15728640   83  Linux
/dev/sda9       492832768   524287999    15727616   83  Linux
Disk /dev/sdd: 536.9 GB, 536870912000 bytes, 1048576000 sectors
/dev/sdd1            2048  1048575999   524286976   83  Linux
Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
/dev/sdb1            2048    41943039    20970496   83  Linux
Disk /dev/sdc: 161.1 GB, 161061273600 bytes, 314572800 sectors
/dev/sdc1            2048   314572799   157285376   83  Linux
*/

-- Step 78 -->> On Node 1
[root@invcdr1 ~]# mkfs.ext4 /dev/sdb1
[root@invcdr1 ~]# mkfs.ext4 /dev/sdc1
[root@invcdr1 ~]# mkfs.ext4 /dev/sdd1

-- Step 79 -->> On Node 1
[root@invcdr1 ~]# oracleasm createdisk OCR /dev/sdb1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 80 -->> On Node 1
[root@invcdr1 ~]# oracleasm createdisk ARC /dev/sdc1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 81 -->> On Node 1
[root@invcdr1 ~]# oracleasm createdisk DATA /dev/sdd1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 82 -->> On Node 1
[root@invcdr1 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 83 -->> On Node 1
[root@invcdr1 ~]# oracleasm listdisks
/*
ARC
DATA
OCR
*/

-- Step 84 -->> On Node 2
[root@invcdr2 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
Instantiating disk "OCR"
Instantiating disk "ARC"
Instantiating disk "DATA"
*/

-- Step 85 -->> On Node 2
[root@invcdr2 ~]# oracleasm listdisks
/*
ARC
DATA
OCR
*/

-- Step 86 -->> On Both Node
[root@invcdr1/invcdr2 ~]# ls -ll /dev/oracleasm/disks/
/*
brw-rw---- 1 grid asmadmin 8, 33 Dec 23 13:57 ARC
brw-rw---- 1 grid asmadmin 8, 49 Dec 23 13:57 DATA
brw-rw---- 1 grid asmadmin 8, 17 Dec 23 13:56 OCR

*/

-- Step 87 -->> On Node 1
-- To setup SSH Pass
[root@invcdr1 ~]# su - grid
[grid@invcdr1 ~]$ cd /opt/app/19c/grid/deinstall
[grid@invcdr1 deinstall]$ ./sshUserSetup.sh -user grid -hosts "invcdr1 invcdr2" -noPromptPassphrase -confirm -advanced
/*
Password: Gr!D4@!Nv#
*/
-- Step 88 -->> On Node 1
[grid@invcdr1/invcdr2 ~]$ ssh grid@invcdr1 date
[grid@invcdr1/invcdr2 ~]$ ssh grid@invcdr2 date
[grid@invcdr1/invcdr2 ~]$ ssh grid@invcdr1 date && ssh grid@invcdr2 date
[grid@invcdr1/invcdr2 ~]$ ssh grid@invcdr1.unidev.com date
[grid@invcdr1/invcdr2 ~]$ ssh grid@invcdr2.unidev.com date
[grid@invcdr1/invcdr2 ~]$ ssh grid@invcdr1.unidev.com date && ssh grid@invcdr2.unidev.com date

-- Step 89 -->> On Node 1
-- Pre-check for rac Setup
[grid@invcdr1 ~]$ cd /opt/app/19c/grid/
[grid@invcdr1 grid]$ ./runcluvfy.sh stage -pre crsinst -n invcdr1,invcdr2 -verbose
[grid@invcdr1 grid]$ ./runcluvfy.sh stage -pre crsinst -n invcdr1,invcdr2 -method root
--[grid@invcdr1 grid]$ ./runcluvfy.sh stage -pre crsinst -n invcdr1,invcdr2 -fixup -verbose (If Required)

-- Step 90 -->> On Node 1
-- To Create a Response File to Install GID
[grid@invcdr1 ~]$ cp /opt/app/19c/grid/install/response/gridsetup.rsp /home/grid/
[grid@invcdr1 ~]$ cd /home/grid/
[grid@invcdr1 ~]$ ls -ltr | grep gridsetup.rsp
/*
-rwxr-xr-x 1 grid oinstall 36221 Dec 23 14:47 gridsetup.rsp
*/

-- Step 90.1 -->> On Node 1
[root@invcdr1 grid]# vi gridsetup.rsp
/*
oracle.install.responseFileVersion=/oracle/install/rspfmt_crsinstall_response_schema_v19.0.0
INVENTORY_LOCATION=/opt/app/oraInventory
oracle.install.option=CRS_CONFIG
ORACLE_BASE=/opt/app/oracle
oracle.install.asm.OSDBA=asmdba
oracle.install.asm.OSOPER=asmoper
oracle.install.asm.OSASM=asmadmin
oracle.install.crs.config.scanType=LOCAL_SCAN
oracle.install.crs.config.gpnp.scanName=invcdr-scan
oracle.install.crs.config.gpnp.scanPort=1521
oracle.install.crs.config.ClusterConfiguration=STANDALONE
oracle.install.crs.config.configureAsExtendedCluster=false
oracle.install.crs.config.clusterName=invdr-cluster
oracle.install.crs.config.gpnp.configureGNS=false
oracle.install.crs.config.autoConfigureClusterNodeVIP=false
oracle.install.crs.config.clusterNodes=invcdr1:invcdr1-vip,invcdr2:invcdr2-vip
oracle.install.crs.config.networkInterfaceList=ens160:192.1.1.0:1,ens192:10.0.1.0:5
oracle.install.crs.configureGIMR=false
oracle.install.crs.config.storageOption=FLEX_ASM_STORAGE
oracle.install.crs.config.useIPMI=false
oracle.install.asm.SYSASMPassword=Sys605014
oracle.install.asm.diskGroup.name=OCR
oracle.install.asm.diskGroup.redundancy=EXTERNAL
oracle.install.asm.diskGroup.AUSize=4
oracle.install.asm.diskGroup.disks=/dev/oracleasm/disks/OCR
oracle.install.asm.diskGroup.diskDiscoveryString=/dev/oracleasm/disks/*
oracle.install.asm.monitorPassword=Sys605014
oracle.install.asm.configureAFD=false
oracle.install.crs.configureRHPS=false
oracle.install.crs.config.ignoreDownNodes=false
oracle.install.config.managementOption=NONE
oracle.install.config.omsPort=0
oracle.install.crs.rootconfig.executeRootScript=false
*/

-- Step 91 -->> On Node 1
-- To Install Grid Software with Leteset Opatch
[grid@invcdr1 ~]$ cd /opt/app/19c/grid/
[grid@invcdr1 grid]$ ./gridSetup.sh -ignorePrereq -waitForCompletion -silent -applyRU /tmp/30783556/30899722 -responseFile /home/grid/gridsetup.rsp
/*
Preparing the home to patch...
Applying the patch /tmp/30783556/30899722...
Successfully applied the patch.
The log can be found at: /tmp/GridSetupActions2022-12-23_03-15-33PM/installerPatchActions_2022-12-23_03-15-33PM.log
Launching Oracle Grid Infrastructure Setup Wizard...

[WARNING] [INS-13014] Target environment does not meet some optional requirements.
   CAUSE: Some of the optional prerequisites are not met. See logs for details. gridSetupActions2022-12-23_03-15-33PM.log
   ACTION: Identify the list of failed prerequisite checks from the log: gridSetupActions2022-12-23_03-15-33PM.log. Then either from the log file or from installation manual find the appropriate configuration to meet the prerequisites and fix it manually.
The response file for this session can be found at:
 /opt/app/19c/grid/install/response/grid_2022-12-23_03-15-33PM.rsp

You can find the log of this install session at:
 /tmp/GridSetupActions2022-12-23_03-15-33PM/gridSetupActions2022-12-23_03-15-33PM.log

As a root user, execute the following script(s):
        1. /opt/app/oraInventory/orainstRoot.sh
        2. /opt/app/19c/grid/root.sh

Execute /opt/app/oraInventory/orainstRoot.sh on the following nodes:
[invcdr1, invcdr2]
Execute /opt/app/19c/grid/root.sh on the following nodes:
[invcdr1, invcdr2]

Run the script on the local node first. After successful completion, you can start the script in parallel on all other nodes.

Successfully Setup Software with warning(s).
As install user, execute the following command to complete the configuration.
        /opt/app/19c/grid/gridSetup.sh -executeConfigTools -responseFile /home/grid/gridsetup.rsp [-silent]


Moved the install session logs to:
 /opt/app/oraInventory/logs/GridSetupActions2022-12-23_03-15-33PM
*/

-- Step 92 -->> On Node 1
[root@invcdr1 ~]# /opt/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 93 -->> On Node 2
[root@invcdr2 ~]# /opt/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 94 -->> On Node 1
[root@invcdr1 ~]# /opt/app/19c/grid/root.sh
/*
Check /opt/app/19c/grid/install/root_invcdr1.unidev.com_2022-12-23_15-35-22-255811948.log for the output of root script
*/

-- Step 94.1 -->> On Node 1
[root@invcdr1 ~]# tail -f /opt/app/19c/grid/install/root_invcdr1.unidev.com_2022-12-23_15-35-22-255811948.log
/*
Creating /etc/oratab file...
Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Relinking oracle with rac_on option
Using configuration parameter file: /opt/app/19c/grid/crs/install/crsconfig_params
The log of current session can be found at:
  /opt/app/oracle/crsdata/invcdr1/crsconfig/rootcrs_invcdr1_2022-12-23_03-35-43PM.log
2022/12/23 15:35:56 CLSRSC-594: Executing installation step 1 of 19: 'SetupTFA'.
2022/12/23 15:35:56 CLSRSC-594: Executing installation step 2 of 19: 'ValidateEnv'.
2022/12/23 15:35:56 CLSRSC-363: User ignored prerequisites during installation
2022/12/23 15:35:57 CLSRSC-594: Executing installation step 3 of 19: 'CheckFirstNode'.
2022/12/23 15:35:59 CLSRSC-594: Executing installation step 4 of 19: 'GenSiteGUIDs'.
2022/12/23 15:36:01 CLSRSC-594: Executing installation step 5 of 19: 'SetupOSD'.
2022/12/23 15:36:01 CLSRSC-594: Executing installation step 6 of 19: 'CheckCRSConfig'.
2022/12/23 15:36:01 CLSRSC-594: Executing installation step 7 of 19: 'SetupLocalGPNP'.
2022/12/23 15:36:19 CLSRSC-594: Executing installation step 8 of 19: 'CreateRootCert'.
2022/12/23 15:36:25 CLSRSC-594: Executing installation step 9 of 19: 'ConfigOLR'.
2022/12/23 15:36:47 CLSRSC-4002: Successfully installed Oracle Trace File Analyzer (TFA) Collector.
2022/12/23 15:36:53 CLSRSC-594: Executing installation step 10 of 19: 'ConfigCHMOS'.
2022/12/23 15:36:53 CLSRSC-594: Executing installation step 11 of 19: 'CreateOHASD'.
2022/12/23 15:37:00 CLSRSC-594: Executing installation step 12 of 19: 'ConfigOHASD'.
2022/12/23 15:37:01 CLSRSC-330: Adding Clusterware entries to file 'oracle-ohasd.service'
2022/12/23 15:37:27 CLSRSC-594: Executing installation step 13 of 19: 'InstallAFD'.
2022/12/23 15:37:27 CLSRSC-594: Executing installation step 14 of 19: 'InstallACFS'.
2022/12/23 15:37:34 CLSRSC-594: Executing installation step 15 of 19: 'InstallKA'.
2022/12/23 15:37:42 CLSRSC-594: Executing installation step 16 of 19: 'InitConfig'.
Redirecting to /bin/systemctl restart rsyslog.service

ASM has been created and started successfully.

[DBT-30001] Disk groups created successfully. Check /opt/app/oracle/cfgtoollogs/asmca/asmca-221223PM033814.log for details.

2022/12/23 15:39:11 CLSRSC-482: Running command: '/opt/app/19c/grid/bin/ocrconfig -upgrade grid oinstall'
CRS-4256: Updating the profile
Successful addition of voting disk 223960961cc44f9bbf3f7043b1d9b872.
Successfully replaced voting disk group with +OCR.
CRS-4256: Updating the profile
CRS-4266: Voting file(s) successfully replaced
##  STATE    File Universal Id                File Name Disk group
--  -----    -----------------                --------- ---------
 1. ONLINE   223960961cc44f9bbf3f7043b1d9b872 (/dev/oracleasm/disks/OCR) [OCR]
Located 1 voting disk(s).
2022/12/23 15:40:21 CLSRSC-594: Executing installation step 17 of 19: 'StartCluster'.
2022/12/23 15:41:28 CLSRSC-343: Successfully started Oracle Clusterware stack
2022/12/23 15:41:28 CLSRSC-594: Executing installation step 18 of 19: 'ConfigNode'.
2022/12/23 15:43:10 CLSRSC-594: Executing installation step 19 of 19: 'PostConfig'.
2022/12/23 15:43:42 CLSRSC-325: Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 95 -->> On Node 2
[root@invcdr2 ~]# /opt/app/19c/grid/root.sh
/*
Check /opt/app/19c/grid/install/root_invcdr2.unidev.com_2022-12-23_15-45-37-643865945.log for the output of root script
*/

-- Step 95.1 -->> On Node 2
[root@invcdr2 ~]# tail -f /opt/app/19c/grid/install/root_invcdr2.unidev.com_2022-12-23_15-45-37-643865945.log
/*
Creating /etc/oratab file...
Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Relinking oracle with rac_on option
Using configuration parameter file: /opt/app/19c/grid/crs/install/crsconfig_params
The log of current session can be found at:
  /opt/app/oracle/crsdata/invcdr2/crsconfig/rootcrs_invcdr2_2022-12-23_03-46-04PM.log
2022/12/23 15:46:10 CLSRSC-594: Executing installation step 1 of 19: 'SetupTFA'.
2022/12/23 15:46:11 CLSRSC-594: Executing installation step 2 of 19: 'ValidateEnv'.
2022/12/23 15:46:11 CLSRSC-363: User ignored prerequisites during installation
2022/12/23 15:46:11 CLSRSC-594: Executing installation step 3 of 19: 'CheckFirstNode'.
2022/12/23 15:46:13 CLSRSC-594: Executing installation step 4 of 19: 'GenSiteGUIDs'.
2022/12/23 15:46:13 CLSRSC-594: Executing installation step 5 of 19: 'SetupOSD'.
2022/12/23 15:46:13 CLSRSC-594: Executing installation step 6 of 19: 'CheckCRSConfig'.
2022/12/23 15:46:13 CLSRSC-594: Executing installation step 7 of 19: 'SetupLocalGPNP'.
2022/12/23 15:46:15 CLSRSC-594: Executing installation step 8 of 19: 'CreateRootCert'.
2022/12/23 15:46:15 CLSRSC-594: Executing installation step 9 of 19: 'ConfigOLR'.
2022/12/23 15:46:30 CLSRSC-594: Executing installation step 10 of 19: 'ConfigCHMOS'.
2022/12/23 15:46:30 CLSRSC-594: Executing installation step 11 of 19: 'CreateOHASD'.
2022/12/23 15:46:32 CLSRSC-594: Executing installation step 12 of 19: 'ConfigOHASD'.
2022/12/23 15:46:33 CLSRSC-330: Adding Clusterware entries to file 'oracle-ohasd.service'
2022/12/23 15:46:56 CLSRSC-594: Executing installation step 13 of 19: 'InstallAFD'.
2022/12/23 15:46:56 CLSRSC-594: Executing installation step 14 of 19: 'InstallACFS'.
2022/12/23 15:46:58 CLSRSC-594: Executing installation step 15 of 19: 'InstallKA'.
2022/12/23 15:47:00 CLSRSC-594: Executing installation step 16 of 19: 'InitConfig'.
2022/12/23 15:47:04 CLSRSC-4002: Successfully installed Oracle Trace File Analyzer (TFA) Collector.
Redirecting to /bin/systemctl restart rsyslog.service
2022/12/23 15:47:10 CLSRSC-594: Executing installation step 17 of 19: 'StartCluster'.
2022/12/23 15:47:58 CLSRSC-343: Successfully started Oracle Clusterware stack
2022/12/23 15:47:58 CLSRSC-594: Executing installation step 18 of 19: 'ConfigNode'.
2022/12/23 15:48:13 CLSRSC-594: Executing installation step 19 of 19: 'PostConfig'.
2022/12/23 15:48:25 CLSRSC-325: Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 96 -->> On Node 1
[grid@invcdr1 ~]$ cd /opt/app/19c/grid/
[grid@invcdr1 grid]$ /opt/app/19c/grid/gridSetup.sh -silent -executeConfigTools -responseFile /home/grid/gridsetup.rsp
/*
Launching Oracle Grid Infrastructure Setup Wizard...

You can find the logs of this session at:
/opt/app/oraInventory/logs/GridSetupActions2022-12-23_03-49-44PM

You can find the log of this install session at:
 /opt/app/oraInventory/logs/UpdateNodeList2022-12-23_03-49-44PM.log
Successfully Configured Software.
*/

-- Step 96.1 -->> On Node 1
[root@invcdr1 ~]# tail -f tail -f /opt/app/oraInventory/logs/UpdateNodeList2022-12-23_03-49-44PM.log
/*
INFO: All threads completed its operations
INFO: Checkpoint:Index file written and updated
INFO: Done calling doOperation.
INFO: 'UpdateNodeList' was successful.
*/

-- Step 97 -->> On Both Nodes
[root@invcdr1/invcdr2 ~]# cd /opt/app/19c/grid/bin/
[root@invcdr1/invcdr2 bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/


-- Step 98 -->> On Both Nodes
[root@invcdr1/invcdr2 ~]# cd /opt/app/19c/grid/bin/
[root@invcdr1/invcdr2 bin]# ./crsctl check cluster -all
/*
**************************************************************
invcdr1:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
invcdr2:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/

-- Step 99 -->> On Node 1
[root@invcdr1 ~]# cd /opt/app/19c/grid/bin/
[root@invcdr1 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       invcdr1                  Started,STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.crf
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.crsd
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.cssd
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.ctssd
      1        ONLINE  ONLINE       invcdr1                  OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.evmd
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.gipcd
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.gpnpd
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.mdnsd
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.storage
      1        ONLINE  ONLINE       invcdr1                  STABLE
--------------------------------------------------------------------------------
*/


-- Step 100 -->> On Node 2
[root@invcdr2 ~]# cd /opt/app/19c/grid/bin/
[root@invcdr2 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       invcdr2                  STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       invcdr2                  STABLE
ora.crf
      1        ONLINE  ONLINE       invcdr2                  STABLE
ora.crsd
      1        ONLINE  ONLINE       invcdr2                  STABLE
ora.cssd
      1        ONLINE  ONLINE       invcdr2                  STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       invcdr2                  STABLE
ora.ctssd
      1        ONLINE  ONLINE       invcdr2                  OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.evmd
      1        ONLINE  ONLINE       invcdr2                  STABLE
ora.gipcd
      1        ONLINE  ONLINE       invcdr2                  STABLE
ora.gpnpd
      1        ONLINE  ONLINE       invcdr2                  STABLE
ora.mdnsd
      1        ONLINE  ONLINE       invcdr2                  STABLE
ora.storage
      1        ONLINE  ONLINE       invcdr2                  STABLE
--------------------------------------------------------------------------------
*/

-- Step 101 -->> On Both Nodes
[root@invcdr2/invcdr2 ~]# cd /opt/app/19c/grid/bin/
[root@invcdr1/invcdr2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       invcdr1                  STABLE
               ONLINE  ONLINE       invcdr2                  STABLE
ora.chad
               ONLINE  ONLINE       invcdr1                  STABLE
               ONLINE  ONLINE       invcdr2                  STABLE
ora.net1.network
               ONLINE  ONLINE       invcdr1                  STABLE
               ONLINE  ONLINE       invcdr2                  STABLE
ora.ons
               ONLINE  ONLINE       invcdr1                  STABLE
               ONLINE  ONLINE       invcdr2                  STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       invcdr1                  STABLE
      2        ONLINE  ONLINE       invcdr2                  STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       invcdr2                  STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       invcdr1                  STABLE
      2        ONLINE  ONLINE       invcdr2                  STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       invcdr1                  Started,STABLE
      2        ONLINE  ONLINE       invcdr2                  Started,STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       invcdr1                  STABLE
      2        ONLINE  ONLINE       invcdr2                  STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.cvu
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.invcdr1.vip
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.invcdr2.vip
      1        ONLINE  ONLINE       invcdr2                  STABLE
ora.qosmserver
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       invcdr2                  STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.scan3.vip
      1        ONLINE  ONLINE       invcdr1                  STABLE
--------------------------------------------------------------------------------
*/


-- Step 102 -->> On Both Nodes
[grid@invcdr1/invcdr2 ~]$ asmcmd
/*
ASMCMD> lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20140                0           20140              0             Y  OCR/
ASMCMD> exit
*/

-- Step 103 -->> On Both Nodes
[grid@invcdr1/invcdr2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 23-DEC-2022 15:55:54

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-DEC-2022 15:43:32
Uptime                    0 days 0 hr. 12 min. 21 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/invcdr1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.1.1.48/192.1.1.49)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.1.1.50/192.1.1.51)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1/+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1/+ASM2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/


-- Step 104 -->> On Node 1
-- To Create ASM storage for Data and Archive
[grid@invcdr1 ~]$ cd /opt/app/19c/grid/bin

-- Step 104.1 -->> On Node 1
[grid@invcdr1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName DATA -diskList /dev/oracleasm/disks/DATA -redundancy EXTERNAL

-- Step 104.2 -->> On Node 1
[grid@invcdr1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName ARC -diskList /dev/oracleasm/disks/ARC -redundancy EXTERNAL

-- Step 105 -->> On Both Nodes
[grid@invcdr1/invcdr2 ~]$ sqlplus / as sysasm
/*

SQL*Plus: Release 19.0.0.0.0 - Production on Tue Dec 27 09:36:55 2022
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> set lines 200;
SQL> COLUMN name FORMAT A30
SQL> SELECT inst_id,name,state,type,compatibility,database_compatibility,voting_files FROM gv$asm_diskgroup order by name;

   INST_ID NAME STATE   TYPE   COMPATIBILITY DATABASE_COMPATIBILITY V
---------- ---- ------- ------ ------------- ---------------------- -
         1 ARC  MOUNTED EXTERN 19.0.0.0.0    10.1.0.0.0             N
         2 ARC  MOUNTED EXTERN 19.0.0.0.0    10.1.0.0.0             N
         2 DATA MOUNTED EXTERN 19.0.0.0.0    10.1.0.0.0             N
         1 DATA MOUNTED EXTERN 19.0.0.0.0    10.1.0.0.0             N
         2 OCR  MOUNTED EXTERN 19.0.0.0.0    10.1.0.0.0             Y
         1 OCR  MOUNTED EXTERN 19.0.0.0.0    10.1.0.0.0             Y

6 rows selected.

SQL> set lines 200;
SQL> col path format a40;
SQL> SELECT name,path, group_number group_#, disk_number disk_#, mount_status,header_status, state, total_mb, free_mb FROM v$asm_disk order by group_number;

NAME      PATH                         GROUP_#     DISK_# MOUNT_S HEADER_STATU STATE      TOTAL_MB    FREE_MB
--------- ------------------------- ---------- ---------- ------- ------------ -------- ---------- ----------
OCR_0000  /dev/oracleasm/disks/OCR           1          0 CACHED  MEMBER       NORMAL        20476      20140
DATA_0000 /dev/oracleasm/disks/DATA          2          0 CACHED  MEMBER       NORMAL        511999     511887
ARC_0000  /dev/oracleasm/disks/ARC           3          0 CACHED  MEMBER       NORMAL        153599     153493

SQL> set lines 200;
SQL> col BANNER_FULL format a80;
SQL> col BANNER_LEGACY format a80;
SQL> SELECT inst_id,banner_full,banner_legacy,con_id FROM gv$version;

   INST_ID BANNER_FULL                                                  BANNER_LEGACY                                                          CON_ID
---------- ------------------------------------------------------------ ---------------------------------------------------------------------- ------
         1 Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 -  Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production      0
           Production                                                                                                                          
           Version 19.7.0.0.0                                                                                                                  

         2 Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 -  Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production      0
           Production                                                                                                                         
           Version 19.7.0.0.0      

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 106 -->> On Both Nodes
[root@invcdr1/invcdr2 ~]# cd /opt/app/19c/grid/bin
[root@invcdr1/invcdr2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       invcdr1                  STABLE
               ONLINE  ONLINE       invcdr2                  STABLE
ora.chad
               ONLINE  ONLINE       invcdr1                  STABLE
               ONLINE  ONLINE       invcdr2                  STABLE
ora.net1.network
               ONLINE  ONLINE       invcdr1                  STABLE
               ONLINE  ONLINE       invcdr2                  STABLE
ora.ons
               ONLINE  ONLINE       invcdr1                  STABLE
               ONLINE  ONLINE       invcdr2                  STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ARC.dg(ora.asmgroup)
      1        ONLINE  ONLINE       invcdr1                  STABLE
      2        ONLINE  ONLINE       invcdr2                  STABLE
      3        ONLINE  OFFLINE                               STABLE
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       invcdr1                  STABLE
      2        ONLINE  ONLINE       invcdr2                  STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.DATA.dg(ora.asmgroup)
      1        ONLINE  ONLINE       invcdr1                  STABLE
      2        ONLINE  ONLINE       invcdr2                  STABLE
      3        ONLINE  OFFLINE                               STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       invcdr2                  STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       invcdr1                  STABLE
      2        ONLINE  ONLINE       invcdr2                  STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       invcdr1                  Started,STABLE
      2        ONLINE  ONLINE       invcdr2                  Started,STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       invcdr1                  STABLE
      2        ONLINE  ONLINE       invcdr2                  STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.cvu
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.invcdr1.vip
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.invcdr2.vip
      1        ONLINE  ONLINE       invcdr2                  STABLE
ora.qosmserver
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       invcdr2                  STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.scan3.vip
      1        ONLINE  ONLINE       invcdr1                  STABLE
--------------------------------------------------------------------------------
*/

-- Step 107 -->> On Both Nodes
[grid@invcdr1/invcdr2 ~]$ asmcmd
/*
ASMCMD> lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  1048576    153599   153493                0          153493              0             N  ARC/
MOUNTED  EXTERN  N         512             512   4096  1048576    511999   511887                0          511887              0             N  DATA/
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20116                0           20116              0             Y  OCR/
ASMCMD> exit
*/

-- Step 108 -->> On Node 1
[root@invcdr1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/19c/grid:N
*/

-- Step 109 -->> On Node 2
[root@invcdr2 ~]# vi /etc/oratab
/*
+ASM2:/opt/app/19c/grid:N
*/

-- Step 110 -->> On Both Nodes
-- Creating the Oracle RDBMS Home Directory
[root@invcdr1/invcdr2 ~]# mkdir -p /opt/app/oracle/product/19c/db_1
[root@invcdr1/invcdr2 ~]# chown -R oracle:oinstall /opt/app/oracle/product/19c/db_1
[root@invcdr1/invcdr2 ~]# chmod -R 775 /opt/app/oracle/product/19c/db_1

-- Step 111 -->> On Node 1
-- To unzip the Oracle Binary and Letest Opatch
[root@invcdr1 ~]# cd /opt/app/oracle/product/19c/db_1
[root@invcdr1 db_1]# unzip -oq /root/19.3.0.0.0/LINUX.X64_193000_db_home.zip
[root@invcdr1 db_1]# unzip -oq /root/PSU_19.7.0.0.0/p6880880_190000_LINUX.zip 

-- Step 111.1 -->> On Node 1
[root@invcdr1 ~]# chown -R oracle:oinstall /opt/app/oracle/product/19c/db_1/
[root@invcdr1 ~]# chmod -R 775 /opt/app/oracle/product/19c/db_1/

-- Step 112 -->> On Node 1
-- To Setup the SSH Connectivity 
[root@invcdr1 ~]# su - oracle
[oracle@invcdr1 ~]$ cd /opt/app/oracle/product/19c/db_1/deinstall/
[oracle@invcdr1 deinstall]$ ./sshUserSetup.sh -user oracle -hosts "invcdr1 invcdr2" -noPromptPassphrase -confirm -advanced
/*
Password: Or@cL5@!Nv#
*/
-- Step 113 -->> On Both Nodes
[oracle@invcdr1/invcdr2 ~]$ ssh oracle@invcdr1 date
[oracle@invcdr1/invcdr2 ~]$ ssh oracle@invcdr2 date
[oracle@invcdr1/invcdr2 ~]$ ssh oracle@invcdr1 date && ssh oracle@invcdr2 date
[oracle@invcdr1/invcdr2 ~]$ ssh oracle@invcdr1.unidev.com date
[oracle@invcdr1/invcdr2 ~]$ ssh oracle@invcdr2.unidev.com date
[oracle@invcdr1/invcdr2 ~]$ ssh oracle@invcdr1.unidev.com date && ssh oracle@invcdr2.unidev.com date

-- Step 114 -->> On Node 1
-- To Create a responce file for Oracle Software Installation
[oracle@invcdr1 ~]$ cp /opt/app/oracle/product/19c/db_1/install/response/db_install.rsp /home/oracle/
[oracle@invcdr1 ~]$ cd /home/oracle/

-- Step 114.1 -->> On Node 1
[oracle@invcdr1 ~]$ ls -ltr
/*
-rwxr-xr-x 1 oracle oinstall 19932 Dec 28 10:34 db_install.rsp
*/

-- Step 114.2 -->> On Node 1
[oracle@invcdr1 ~]$  vi db_install.rsp
/*
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v19.0.0
oracle.install.option=INSTALL_DB_SWONLY
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/opt/app/oraInventory
ORACLE_HOME=/opt/app/oracle/product/19c/db_1
ORACLE_BASE=/opt/app/oracle
oracle.install.db.InstallEdition=EE
ORACLE_HOSTNAME=invcdr1.unidev.com
SELECTED_LANGUAGES=en
oracle.install.db.OSDBA_GROUP=dba
oracle.install.db.OSOPER_GROUP=oper
oracle.install.db.OSBACKUPDBA_GROUP=backupdba
oracle.install.db.OSDGDBA_GROUP=dgdba
oracle.install.db.OSKMDBA_GROUP=kmdba
oracle.install.db.OSRACDBA_GROUP=racdba
oracle.install.db.rootconfig.executeRootScript=false
oracle.install.db.CLUSTER_NODES=invcdr1,invcdr2
oracle.install.db.config.starterdb.type=GENERAL_PURPOSE
oracle.install.db.ConfigureAsContainerDB=false
*/

-- Step 115 -->> On Node 1
-- To install Oracle Software with Letest Opatch
[oracle@invcdr1 ~]$ cd /opt/app/oracle/product/19c/db_1/
[oracle@invcdr1 db_1]$ ./runInstaller -ignorePrereq -waitforcompletion -silent \
-applyRU /tmp/30783556/30899722                                             \
-responseFile /home/oracle/db_install.rsp                                   \
oracle.install.db.isRACOneInstall=false                                     \
oracle.install.db.rac.serverpoolCardinality=0                               \
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false                                  \
DECLINE_SECURITY_UPDATES=true

/*
Preparing the home to patch...
Applying the patch /tmp/30783556/30899722...
Successfully applied the patch.
The log can be found at: /opt/app/oraInventory/logs/InstallActions2022-12-28_10-46-22AM/installerPatchActions_2022-12-28_10-46-22AM.log
Launching Oracle Database Setup Wizard...

[WARNING] [INS-13014] Target environment does not meet some optional requirements.
   CAUSE: Some of the optional prerequisites are not met. See logs for details. /opt/app/oraInventory/logs/InstallActions2022-12-28_10-46-22AM/installActions2022-12-28_10-46-22AM.log
   ACTION: Identify the list of failed prerequisite checks from the log: /opt/app/oraInventory/logs/InstallActions2022-12-28_10-46-22AM/installActions2022-12-28_10-46-22AM.log. Then either from the log file or from installation manual find the appropriate configuration to meet the prerequisites and fix it manually.
The response file for this session can be found at:
 /opt/app/oracle/product/19c/db_1/install/response/db_2022-12-28_10-46-22AM.rsp

You can find the log of this install session at:
 /opt/app/oraInventory/logs/InstallActions2022-12-28_10-46-22AM/installActions2022-12-28_10-46-22AM.log

As a root user, execute the following script(s):
        1. /opt/app/oracle/product/19c/db_1/root.sh

Execute /opt/app/oracle/product/19c/db_1/root.sh on the following nodes:
[invcdr1, invcdr2]


Successfully Setup Software with warning(s).
*/

-- Step 116 -->> On Node 1
[root@invcdr1 ~]# /opt/app/oracle/product/19c/db_1/root.sh
/*
Check  /opt/app/oracle/product/19c/db_1/install/root_invcdr1.unidev.com_2022-12-28_11-00-08-846902933.log for the output of root script
*/

-- Step 116.1 -->> On Node 1
[root@invcdr1 ~]# tail -f  /opt/app/oracle/product/19c/db_1/install/root_invcdr1.unidev.com_2022-12-28_11-00-08-846902933.log
/*
   ORACLE_OWNER= oracle
   ORACLE_HOME=  /opt/app/oracle/product/19c/db_1
   Copying dbhome to /usr/local/bin ...
   Copying oraenv to /usr/local/bin ...
   Copying coraenv to /usr/local/bin ...

Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
*/

-- Step 117 -->> On Node 2
[root@invcdr2 ~]# /opt/app/oracle/product/19c/db_1/root.sh
/*
Check /opt/app/oracle/product/19c/db_1/install/root_invcdr2.unidev.com_2022-12-28_11-01-32-992839268.log for the output of root script
*/

-- Step 117.1 -->> On Node 2
[root@invcdr2 ~]# tail -f /opt/app/oracle/product/19c/db_1/install/root_invcdr2.unidev.com_2022-12-28_11-01-32-992839268.log
/* 
 ORACLE_OWNER= oracle
    ORACLE_HOME=  /opt/app/oracle/product/19c/db_1
   Copying dbhome to /usr/local/bin ...
   Copying oraenv to /usr/local/bin ...
   Copying coraenv to /usr/local/bin ...

Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
*/

-- Step 118 -->> On Node 1
-- To applying the Oracle PSU on Node 1
[root@invcdr1 ~]# export ORACLE_HOME=/opt/app/oracle/product/19c/db_1
[root@invcdr1 ~]# export PATH=${ORACLE_HOME}/bin:$PATH
[root@invcdr1 ~]# export PATH=${PATH}:${ORACLE_HOME}/OPatch

-- Step 118.1 -->> On Node 1
[root@invcdr1 ~]# which opatchauto
/*
/opt/app/oracle/product/19c/db_1/OPatch/opatchauto
*/

-- Step 119 -->> On Node 1
[root@invcdr1 ~]# opatchauto apply /tmp/30783556/30805684 -oh /opt/app/oracle/product/19c/db_1 --nonrolling
/*
OPatchauto session is initiated at Thu Dec 29 10:03:58 2022

System initialization log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchautodb/systemconfig2022-12-29_10-04-04AM.log.

Session log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/opatchauto2022-12-29_10-04-40AM.log
The id for this session is QLLH

Executing OPatch prereq operations to verify patch applicability on home /opt/app/oracle/product/19c/db_1
Patch applicability verified successfully on home /opt/app/oracle/product/19c/db_1


Verifying SQL patch applicability on home /opt/app/oracle/product/19c/db_1
No step execution required.........


Preparing to bring down database service on home /opt/app/oracle/product/19c/db_1
No step execution required.........


Bringing down database service on home /opt/app/oracle/product/19c/db_1
Database service successfully brought down on home /opt/app/oracle/product/19c/db_1


Performing prepatch operation on home /opt/app/oracle/product/19c/db_1
Perpatch operation completed successfully on home /opt/app/oracle/product/19c/db_1


Start applying binary patch on home /opt/app/oracle/product/19c/db_1

Binary patch applied successfully on home /opt/app/oracle/product/19c/db_1


Performing postpatch operation on home /opt/app/oracle/product/19c/db_1
Postpatch operation completed successfully on home /opt/app/oracle/product/19c/db_1


Starting database service on home /opt/app/oracle/product/19c/db_1
Database service successfully started on home /opt/app/oracle/product/19c/db_1


Preparing home /opt/app/oracle/product/19c/db_1 after database service restarted
No step execution required.........


Trying to apply SQL patch on home /opt/app/oracle/product/19c/db_1
No step execution required.........

OPatchAuto successful.

--------------------------------Summary--------------------------------

Patching is completed successfully. Please find the summary as follows:

Host:invcdr1
RAC Home:/opt/app/oracle/product/19c/db_1
Version:19.0.0.0.0
Summary:

==Following patches were SUCCESSFULLY applied:

Patch: /tmp/30783556/30805684
Log: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2022-12-29_10-05-08AM_1.log



OPatchauto session completed at Thu Dec 29 10:06:43 2022
Time taken to complete the session 2 minutes, 45 seconds
*/

-- Step 119.1 -->> On Node 1
[root@invcdr1 ~]# tail -f /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2022-12-29_10-05-08AM_1.log
/*
[Dec 29, 2022 10:06:39 AM] [INFO]   [OPSR-TIME] Backup area for restore has been cleaned up. For a complete list of files/directories deleted, Please refer log file.
[Dec 29, 2022 10:06:39 AM] [INFO]   Patch 30805684 successfully applied.
[Dec 29, 2022 10:06:39 AM] [INFO]   UtilSession: N-Apply done.
[Dec 29, 2022 10:06:39 AM] [INFO]   Finishing UtilSession at Thu Dec 29 10:06:39 NPT 2022
[Dec 29, 2022 10:06:39 AM] [INFO]   Log file location: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2022-12-29_10-05-08AM_1.log
[Dec 29, 2022 10:06:39 AM] [INFO]   EXITING METHOD: NApply(IAnalysisReport report)
*/

-- Step 120 -->> On Node 1
[root@invcdr1 ~]# scp -r /tmp/30783556/ root@invcdr2:/tmp/

-- Step 121 -->> On Node 2
[root@invcdr2 ~]# cd /tmp/
[root@invcdr2 tmp]# chown -R oracle:oinstall 30783556
[root@invcdr2 tmp]# chmod -R 775 30783556

-- Step 121.1 -->> On Node 2
[root@invcdr2 tmp]# ls -ltr | grep 30783556
/*
drwxrwxr-x  4 oracle oinstall   4096 Dec 29 10:09 30783556
*/

-- Step 122 -->> On Node 2
-- To applying the Oracle PSU on Remote Node 2
[root@invcdr2 ~]# export ORACLE_HOME=/opt/app/oracle/product/19c/db_1
[root@invcdr2 ~]# export PATH=${ORACLE_HOME}/bin:$PATH
[root@invcdr2 ~]# export PATH=${PATH}:${ORACLE_HOME}/OPatch

-- Step 122.1 -->> On Node 2
[root@invcdr2 ~]# which opatchauto
/*
/opt/app/oracle/product/19c/db_1/OPatch/opatchauto
*/

-- Step 123 -->> On Node 2
[root@invcdr2 ~]# opatchauto apply /tmp/30783556/30805684 -oh /opt/app/oracle/product/19c/db_1 --nonrolling
/*
OPatchauto session is initiated at Thu Dec 29 10:11:44 2022

System initialization log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchautodb/systemconfig2022-12-29_10-11-50AM.log.

Session log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/opatchauto2022-12-29_10-12-08AM.log
The id for this session is 9CZV

Executing OPatch prereq operations to verify patch applicability on home /opt/app/oracle/product/19c/db_1
Patch applicability verified successfully on home /opt/app/oracle/product/19c/db_1


Verifying SQL patch applicability on home /opt/app/oracle/product/19c/db_1
No step execution required.........


Preparing to bring down database service on home /opt/app/oracle/product/19c/db_1
No step execution required.........


Bringing down database service on home /opt/app/oracle/product/19c/db_1
Database service successfully brought down on home /opt/app/oracle/product/19c/db_1


Performing prepatch operation on home /opt/app/oracle/product/19c/db_1
Perpatch operation completed successfully on home /opt/app/oracle/product/19c/db_1


Start applying binary patch on home /opt/app/oracle/product/19c/db_1

Binary patch applied successfully on home /opt/app/oracle/product/19c/db_1


Performing postpatch operation on home /opt/app/oracle/product/19c/db_1
Postpatch operation completed successfully on home /opt/app/oracle/product/19c/db_1


Starting database service on home /opt/app/oracle/product/19c/db_1
Database service successfully started on home /opt/app/oracle/product/19c/db_1


Preparing home /opt/app/oracle/product/19c/db_1 after database service restarted
No step execution required.........


Trying to apply SQL patch on home /opt/app/oracle/product/19c/db_1
No step execution required.........

OPatchAuto successful.

--------------------------------Summary--------------------------------

Patching is completed successfully. Please find the summary as follows:

Host:invcdr2
RAC Home:/opt/app/oracle/product/19c/db_1
Version:19.0.0.0.0
Summary:

==Following patches were SUCCESSFULLY applied:

Patch: /tmp/30783556/30805684
Log: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2022-12-29_10-12-34AM_1.log



OPatchauto session completed at Thu Dec 29 10:14:24 2022
Time taken to complete the session 2 minutes, 41 seconds
*/

-- Step 123.1 -->> On Node 2
[root@invcdr2 ~]# tail -f /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2022-12-29_10-12-34AM_1.log
/*
[Dec 29, 2022 10:14:22 AM] [INFO]   [OPSR-TIME] Backup area for restore has been cleaned up. For a complete list of files/directories deleted, Please refer log file.
[Dec 29, 2022 10:14:22 AM] [INFO]   Patch 30805684 successfully applied.
[Dec 29, 2022 10:14:22 AM] [INFO]   UtilSession: N-Apply done.
[Dec 29, 2022 10:14:22 AM] [INFO]   Finishing UtilSession at Thu Dec 29 10:14:22 NPT 2022
[Dec 29, 2022 10:14:22 AM] [INFO]   Log file location: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2022-12-29_10-12-34AM_1.log
[Dec 29, 2022 10:14:22 AM] [INFO]   EXITING METHOD: NApply(IAnalysisReport report)
*/

-- Step 124 -->> On Both Nodes
--########################################################################--
[root@invoice1/invoice2 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.1.1.48   invcdr1.unidev.com        invcdr1
192.1.1.49   invcdr2.unidev.com        invcdr2

# Private
10.0.1.48     invcdr1-priv.unidev.com   invcdr1-priv
10.0.1.49     invcdr2-priv.unidev.com   invcdr2-priv

# Virtual
192.1.1.50   invcdr1-vip.unidev.com    invcdr1-vip
192.1.1.51   invcdr2-vip.unidev.com    invcdr2-vip

# SCAN
192.1.1.52   invcdr-scan.unidev.com    invcdr-scan
192.1.1.53   invcdr-scan.unidev.com    invcdr-scan
192.1.1.54   invcdr-scan.unidev.com    invcdr-scan

###############################DC################################

# Public
192.1.1.40   invoice1.unidev.com        invoice1
192.1.1.41   invoice2.unidev.com        invoice2

# Private
10.0.1.75     invoice1-priv.unidev.com   invoice1-priv
10.0.1.76     invoice2-priv.unidev.com   invoice2-priv

# Virtual
192.1.1.42   invoice1-vip.unidev.com    invoice1-vip
192.1.1.43   invoice2-vip.unidev.com    invoice2-vip

# SCAN
192.1.1.44   invoice-scan.unidev.com    invoice-scan
192.1.1.45   invoice-scan.unidev.com    invoice-scan
192.1.1.46   invoice-scan.unidev.com    invoice-scan
*/

-- Step 125 -->> On Both Nodes - DC & DR
[oracle@invoice1/invoice2/invcdr1/invcdr2 ~]$ ping -c 2 invoice1
[oracle@invoice1/invoice2/invcdr1/invcdr2 ~]$ ping -c 2 invoice2
[oracle@invoice1/invoice2/invcdr1/invcdr2 ~]$ ping -c 2 invoice1-priv
[oracle@invoice1/invoice2/invcdr1/invcdr2 ~]$ ping -c 2 invoice2-priv
[oracle@invoice1/invoice2/invcdr1/invcdr2 ~]$ ping -c 2 invoice1-vip
[oracle@invoice1/invoice2/invcdr1/invcdr2 ~]$ ping -c 2 invoice2-vip
[oracle@invoice1/invoice2/invcdr1/invcdr2 ~]$ ping -c 2 invoice-scan
[oracle@invoice1/invoice2/invcdr1/invcdr2 ~]$ ping -c 2 invoice-scan
[oracle@invoice1/invoice2/invcdr1/invcdr2 ~]$ ping -c 2 invoice-scan
[oracle@invoice1/invoice2/invcdr1/invcdr2 ~]$ ping -c 2 invcdr1
[oracle@invoice1/invoice2/invcdr1/invcdr2 ~]$ ping -c 2 invcdr2
[oracle@invoice1/invoice2/invcdr1/invcdr2 ~]$ ping -c 2 invcdr1-priv
[oracle@invoice1/invoice2/invcdr1/invcdr2 ~]$ ping -c 2 invcdr2-priv
[oracle@invoice1/invoice2/invcdr1/invcdr2 ~]$ ping -c 2 invcdr1-vip
[oracle@invoice1/invoice2/invcdr1/invcdr2 ~]$ ping -c 2 invcdr2-vip
[oracle@invoice1/invoice2/invcdr1/invcdr2 ~]$ ping -c 2 invcdr-scan
[oracle@invoice1/invoice2/invcdr1/invcdr2 ~]$ ping -c 2 invcdr-scan
[oracle@invoice1/invoice2/invcdr1/invcdr2 ~]$ ping -c 2 invcdr-scan

-- Step 126 -->> On Both Node's - DC
-- Enable Archive
[oracle@invoice1/invoice2 ~]$ srvctl status database -d invoicedb
/*
Instance invoiced1 is running on node invoice1
Instance invoiced2 is running on node invoice2
*/

-- Step 127 -->> On Both Node's - DC
[oracle@invoice1/invoice2 ~]$ srvctl status database -d invoicedb -v
/*
Instance invoiced1 is running on node invoice1. Instance status: Open.
Instance invoiced2 is running on node invoice2. Instance status: Open.
*/

-- Step 128 -->> On Node 1 - DC
[oracle@invoice1 ~]$ srvctl stop database -d invoicedb
[oracle@invoice1 ~]$ srvctl start database -d invoicedb -o mount
[oracle@invoice1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Mon Jan 2 10:35:20 2023
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> show con_name

CON_NAME
------------------------------
CDB$ROOT

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       MOUNTED
         3 INVPDB                         MOUNTED

SQL> select status, instance_name from gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
MOUNTED      invoiced1
MOUNTED      invoiced2

SQL> SELECT inst_id,name,log_mode,open_mode,protection_mode FROM gv$database;

INST_ID NAME  LOG_MODE     OPEN_MODE PROTECTION_MODE
------- ----- ------------ --------- --------------------
      1 invoicedb NOARCHIVELOG MOUNTED   MAXIMUM PERFORMANCE
      2 invoicedb NOARCHIVELOG MOUNTED   MAXIMUM PERFORMANCE

SQL> ALTER DATABASE ARCHIVELOG;

SQL> ALTER SYSTEM SET log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST' SCOPE=BOTH sid='*';
SQL> ALTER SYSTEM SET log_archive_format='invoicedb_%t_%s_%r.arc' SCOPE=spfile sid='*';
SQL> ALTER SYSTEM SET DB_RECOVERY_FILE_DEST='+DATA' SCOPE=BOTH SID='*';
SQL> ALTER SYSTEM SET DB_RECOVERY_FILE_DEST_SIZE=10G SCOPE=BOTH SID='*';


SQL> archive log list;
Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     954
Next log sequence to archive   955
Current log sequence           955

SQL> SELECT inst_id,name,log_mode,open_mode,protection_mode FROM gv$database;
   INST_ID NAME      LOG_MODE     OPEN_MODE            PROTECTION_MODE
---------- --------- ------------ -------------------- --------------------
         1 INVOICED  ARCHIVELOG   MOUNTED              MAXIMUM PERFORMANCE
         2 INVOICED  ARCHIVELOG   MOUNTED              MAXIMUM PERFORMANCE


SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL>  SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 INVOICED  invoiced1        OPEN         10-JAN-23 invoice1.unidev.com     READ WRITE NOARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED
         2 INVOICED  invoiced2        OPEN         10-JAN-23 invoice2.unidev.com     READ WRITE NOARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED

SQL> SELECT name, open_mode,force_logging FROM gv$database;

NAME      OPEN_MODE            FORCE_LOGGING
--------- -------------------- ---------------------------------------
INVOICED  READ WRITE           NO
INVOICED  READ WRITE           NO


SQL> ALTER DATABASE FORCE LOGGING;

Database altered.

SQL> SELECT name, open_mode,force_logging FROM gv$database;

NAME      OPEN_MODE            FORCE_LOGGING
--------- -------------------- ---------------------------------------
INVOICED  READ WRITE           YES
INVOICED  READ WRITE           YES

SQL>  SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 INVOICED  invoiced1        OPEN         10-JAN-23 invoice1.unidev.com     READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED
         2 INVOICED  invoiced2        OPEN         10-JAN-23 invoice2.unidev.com     READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED


--SQL> ALTER USER sys IDENTIFIED BY "P#ssw0rd";
--SQL> ALTER USER sys IDENTIFIED BY "P#ssw0rd" container=all;

SQL> connect sys/P#ssw0rd@invpdb as sysdba
Connected.

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         3 INVPDB                         READ WRITE NO

SQL>  SELECT name, open_mode,force_logging FROM gv$database;

NAME      OPEN_MODE            FORCE_LOGGING
--------- -------------------- ---------------------------------------
INVOICED  READ WRITE           YES
INVOICED  READ WRITE           YES

SQL> exit
*/

-- Step 129 -->> On Node 1 - DC
[oracle@invoice1 ~]$ srvctl stop database -d invoicedb
[oracle@invoice1 ~]$ srvctl start database -d invoicedb

-- Step 130 -->> On Both Nodes - DC
[oracle@invoice1/invoice2 ~]$ srvctl status database -d invoicedb
/*
Instance invoicedb1 is running on node invoice1
Instance invoicedb2 is running on node invoice2
*/

-- Step 130.1 -->> On Both Nodes - DC
[oracle@invoice1 ~]$ srvctl status database -d invoicedb -v
/*
Instance invoiced1 is running on node invoice1. Instance status: Open.
Instance invoiced2 is running on node invoice2. Instance status: Open.
*/

-- Step 131 -->> On Node 1 - DC
[grid@invoice1 ~]$ srvctl config database -d invoicedb | grep pwd
/*
Password file: +DATA/INVOICEDB/PASSWORD/pwdinvoicedb.256.1120150799
*/

-- Step 132 -->> On Node 1 - DC
[grid@invoice1 ~]$ asmcmd -p
/*
ASMCMD [+] > cd +DATA/INVOICEDB/PASSWORD
ASMCMD [+DATA/INVOICEDB/PASSWORD] > ls
pwdinvoicedb.256.1120150799

ASMCMD [+DATA/INVOICEDB/PASSWORD] > ls -lt
Type      Redund  Striped  Time             Sys  Name
PASSWORD  UNPROT  COARSE   NOV 07 16:00:00  Y    pwdinvoicedb.256.1120150799

ASMCMD [+DATA/INVOICEDB/PASSWORD] > pwcopy pwdinvoicedb.256.1120150799 /tmp
copying +DATA/INVOICEDB/PASSWORD/pwdinvoicedb.256.1120150799 -> /tmp/pwdinvoicedb.256.1120150799

ASMCMD [+DATA/INVOICEDB/PASSWORD] > exit
*/

-- Step 133 -->> On Node 1 - DC
[grid@invoice1 ~]$ cd /tmp/
[grid@invoice1 tmp]$ ls -lrth pwdinvoicedb.256.1120150799
/*
-rw-r----- 1 grid oinstall 2.0K Jan 12 15:04 pwdinvoicedb.256.1120150799
*/

-- Step 134 -->> On Node 1 - DC
[grid@invoice1 ~]$ cd /tmp/
[grid@invoice1 tmp]$ scp -p pwdinvoicedb.256.1120150799 oracle@invcdr1:/opt/app/oracle/product/19c/db_1/dbs/orapwinvcdr1
/*
oracle@invcdr1's password: Or@cL5@!Nv#
pwdinvoicedb.256.1120150799                                               100% 2048     3.1MB/s   00:00
*/

-- Step 135 -->> On Node 1 - DC
[grid@invoice1 tmp]$ scp -p pwdinvoicedb.256.1120150799 oracle@invcdr2:/opt/app/oracle/product/19c/db_1/dbs/orapwinvcdr2
/*
oracle@192.1.1.49's password: Or@cL5@!Nv#
pwdinvoicedb.256.1120150799                                               100% 2048     3.0MB/s   00:00
*/

-- Step 136 -->> On Node 1 - DC
[oracle@invoice1 ~]$  sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Mon Jan 2 11:32:36 2023
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL>  SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 INVOICED  invoiced1        OPEN         10-JAN-23 invoice1.unidev.com     READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED
         2 INVOICED  invoiced2        OPEN         10-JAN-23 invoice2.unidev.com     READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED


SQL> SELECT group#,thread#,bytes FROM gv$log order by 1,2;

    GROUP#    THREAD#      BYTES
---------- ---------- ----------
         1          1   52428800
         1          1   52428800
         2          1   52428800
         2          1   52428800
         3          2   52428800
         3          2   52428800
         4          2   52428800

SQL> col member for a50
SQL> SELECT * FROM v$logfile a ORDER BY a.type,a.group#;

    GROUP# TYPE    MEMBER
---------- ------- ------------------------------------------------------------
         1 ONLINE  +ARC/INVOICEDB/ONLINELOG/group_1.257.1120150955
         1 ONLINE  +DATA/INVOICEDB/ONLINELOG/group_1.262.1120150955
         2 ONLINE  +ARC/INVOICEDB/ONLINELOG/group_2.258.1120150955
         2 ONLINE  +DATA/INVOICEDB/ONLINELOG/group_2.263.1120150955
         3 ONLINE  +DATA/INVOICEDB/ONLINELOG/group_3.270.1120152661
         3 ONLINE  +ARC/INVOICEDB/ONLINELOG/group_3.259.1120152663
         4 ONLINE  +DATA/INVOICEDB/ONLINELOG/group_4.271.1120152663
         4 ONLINE  +ARC/INVOICEDB/ONLINELOG/group_4.260.1120152663

SQL> ALTER DATABASE ADD LOGFILE MEMBER '+DATA' ,'+DATA' to group 1;
SQL> ALTER DATABASE ADD LOGFILE MEMBER '+DATA' ,'+DATA' to group 2;
SQL> ALTER DATABASE ADD LOGFILE MEMBER '+DATA' ,'+DATA' to group 3;
SQL> ALTER DATABASE ADD LOGFILE MEMBER '+DATA' ,'+DATA' to group 4;
SQL> ALTER DATABASE ADD LOGFILE THREAD 1 GROUP 5 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD LOGFILE THREAD 2 GROUP 6 ('+DATA' ,'+DATA') SIZE 50M;

SQL> SELECT group#, archived, status FROM v$log;

    GROUP# ARC STATUS
---------- --- ----------------
         1 NO  CURRENT
         2 YES INACTIVE
         3 YES INACTIVE
         4 NO  CURRENT

--Delete the original log member (Note: Switch to a non-current log for deletion)
--alter system switch logfile;
--alter system checkpoint;

SQL> ALTER DATABASE DROP LOGFILE MEMBER '+ARC/INVOICEDB/ONLINELOG/group_1.257.1120150955';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+DATA/INVOICEDB/ONLINELOG/group_1.262.1120150955';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+ARC/INVOICEDB/ONLINELOG/group_2.258.1120150955';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+DATA/INVOICEDB/ONLINELOG/group_2.263.1120150955';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+DATA/INVOICEDB/ONLINELOG/group_3.270.1120152661';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+ARC/INVOICEDB/ONLINELOG/group_3.259.1120152663';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+DATA/INVOICEDB/ONLINELOG/group_4.271.1120152663';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+ARC/INVOICEDB/ONLINELOG/group_4.260.1120152663';


SQL> SELECT * FROM v$logfile a ORDER BY a.type,a.group#;

    GROUP# STATUS  TYPE    MEMBER                                             IS_     CON_ID
---------- ------- ------- -------------------------------------------------- --- ----------
         1         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_1.335.1125230869   NO           0
         1         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_1.334.1125230867   NO           0
         2         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_2.336.1125230875   NO           0
         2         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_2.337.1125230875   NO           0
         3         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_3.338.1125230885   NO           0
         3         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_3.339.1125230885   NO           0
         4         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_4.340.1125230891   NO           0
         4         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_4.341.1125230891   NO           0
         5         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_5.333.1125232099   NO           0
         5         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_5.332.1125232101   NO           0
         6         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_6.330.1125232109   NO           0
         6         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_6.331.1125232109   NO           0

SQL> SELECT b.thread#,a.group#,a.member,b.bytes FROM v$logfile a, v$log b  WHERE a.group#=b.group# ORDER BY b.group#;

   THREAD#     GROUP# MEMBER                                                  BYTES
---------- ---------- -------------------------------------------------- ----------
         1          1 +DATA/INVOICEDB/ONLINELOG/group_1.335.1125230869     52428800
         1          1 +DATA/INVOICEDB/ONLINELOG/group_1.334.1125230867     52428800
         1          2 +DATA/INVOICEDB/ONLINELOG/group_2.336.1125230875     52428800
         1          2 +DATA/INVOICEDB/ONLINELOG/group_2.337.1125230875     52428800
         2          3 +DATA/INVOICEDB/ONLINELOG/group_3.338.1125230885     52428800
         2          3 +DATA/INVOICEDB/ONLINELOG/group_3.339.1125230885     52428800
         2          4 +DATA/INVOICEDB/ONLINELOG/group_4.340.1125230891     52428800
         2          4 +DATA/INVOICEDB/ONLINELOG/group_4.341.1125230891     52428800
         1          5 +DATA/INVOICEDB/ONLINELOG/group_5.333.1125232099     52428800
         1          5 +DATA/INVOICEDB/ONLINELOG/group_5.332.1125232101     52428800
         2          6 +DATA/INVOICEDB/ONLINELOG/group_6.330.1125232109     52428800
         2          6 +DATA/INVOICEDB/ONLINELOG/group_6.331.1125232109     52428800

SQL> SELECT b.thread#,a.group#, a.type, a.member, b.bytes FROM gv$logfile a, gv$standby_log b WHERE a.group# = b.group# ORDER BY 2,4;

no rows selected

SQL> ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 7  ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 8  ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 9  ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 10 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD STANDBY LOGFILE THREAD 2 GROUP 11 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD STANDBY LOGFILE THREAD 2 GROUP 12 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD STANDBY LOGFILE THREAD 2 GROUP 13 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD STANDBY LOGFILE THREAD 2 GROUP 14 ('+DATA' ,'+DATA') SIZE 50M;

--Node 1
SQL> SELECT b.thread#,a.group#, a.type, a.member, b.bytes FROM v$logfile a, v$standby_log b WHERE a.group# = b.group# ORDER BY 2,4;

   THREAD# GROUP# TYPE    MEMBER                                                            BYTES
---------- ------ ------- ------------------------------------------------------------ ----------
         1      7 STANDBY +DATA/INVOICEDB/ONLINELOG/group_7.342.1125935287               52428800
         1      7 STANDBY +DATA/INVOICEDB/ONLINELOG/group_7.343.1125935289               52428800
         1      8 STANDBY +DATA/INVOICEDB/ONLINELOG/group_8.344.1125935295               52428800
         1      8 STANDBY +DATA/INVOICEDB/ONLINELOG/group_8.345.1125935295               52428800
         1      9 STANDBY +DATA/INVOICEDB/ONLINELOG/group_9.346.1125935299               52428800
         1      9 STANDBY +DATA/INVOICEDB/ONLINELOG/group_9.347.1125935299               52428800
         1     10 STANDBY +DATA/INVOICEDB/ONLINELOG/group_10.348.1125935303              52428800
         1     10 STANDBY +DATA/INVOICEDB/ONLINELOG/group_10.349.1125935303              52428800
         2     11 STANDBY +DATA/INVOICEDB/ONLINELOG/group_11.352.1125938135              52428800
         2     11 STANDBY +DATA/INVOICEDB/ONLINELOG/group_11.353.1125938133              52428800
         2     12 STANDBY +DATA/INVOICEDB/ONLINELOG/group_12.350.1125938145              52428800
         2     12 STANDBY +DATA/INVOICEDB/ONLINELOG/group_12.351.1125938145              52428800
         2     13 STANDBY +DATA/INVOICEDB/ONLINELOG/group_13.360.1125938151              52428800
         2     13 STANDBY +DATA/INVOICEDB/ONLINELOG/group_13.361.1125938151              52428800
         2     14 STANDBY +DATA/INVOICEDB/ONLINELOG/group_14.358.1125938163              52428800
         2     14 STANDBY +DATA/INVOICEDB/ONLINELOG/group_14.359.1125938163              52428800

--Node 2
SQL> SELECT b.thread#,a.group#, a.type, a.member, b.bytes FROM v$logfile a, v$standby_log b WHERE a.group# = b.group# ORDER BY 2,4;

   THREAD# GROUP# TYPE    MEMBER                                                            BYTES
---------- ------ ------- ------------------------------------------------------------ ----------
         1      7 STANDBY +DATA/INVOICEDB/ONLINELOG/group_7.342.1125935287               52428800
         1      7 STANDBY +DATA/INVOICEDB/ONLINELOG/group_7.343.1125935289               52428800
         1      8 STANDBY +DATA/INVOICEDB/ONLINELOG/group_8.344.1125935295               52428800
         1      8 STANDBY +DATA/INVOICEDB/ONLINELOG/group_8.345.1125935295               52428800
         1      9 STANDBY +DATA/INVOICEDB/ONLINELOG/group_9.346.1125935299               52428800
         1      9 STANDBY +DATA/INVOICEDB/ONLINELOG/group_9.347.1125935299               52428800
         1     10 STANDBY +DATA/INVOICEDB/ONLINELOG/group_10.348.1125935303              52428800
         1     10 STANDBY +DATA/INVOICEDB/ONLINELOG/group_10.349.1125935303              52428800
         2     11 STANDBY +DATA/INVOICEDB/ONLINELOG/group_11.352.1125938135              52428800
         2     11 STANDBY +DATA/INVOICEDB/ONLINELOG/group_11.353.1125938133              52428800
         2     12 STANDBY +DATA/INVOICEDB/ONLINELOG/group_12.350.1125938145              52428800
         2     12 STANDBY +DATA/INVOICEDB/ONLINELOG/group_12.351.1125938145              52428800
         2     13 STANDBY +DATA/INVOICEDB/ONLINELOG/group_13.360.1125938151              52428800
         2     13 STANDBY +DATA/INVOICEDB/ONLINELOG/group_13.361.1125938151              52428800
         2     14 STANDBY +DATA/INVOICEDB/ONLINELOG/group_14.358.1125938163              52428800
         2     14 STANDBY +DATA/INVOICEDB/ONLINELOG/group_14.359.1125938163              52428800

SQL> SELECT * FROM v$logfile order by 1;

GROUP# STATUS  TYPE    MEMBER                                                       IS_     CON_ID
------ ------- ------- ------------------------------------------------------------ --- ----------
     1         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_1.334.1125230867             NO           0
     1         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_1.335.1125230869             NO           0
     2         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_2.337.1125230875             NO           0
     2         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_2.336.1125230875             NO           0
     3         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_3.339.1125230885             NO           0
     3         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_3.338.1125230885             NO           0
     4         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_4.341.1125230891             NO           0
     4         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_4.340.1125230891             NO           0
     5         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_5.333.1125232099             NO           0
     5         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_5.332.1125232101             NO           0
     6         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_6.331.1125232109             NO           0
     6         ONLINE  +DATA/INVOICEDB/ONLINELOG/group_6.330.1125232109             NO           0
     7         STANDBY +DATA/INVOICEDB/ONLINELOG/group_7.342.1125935287             NO           0
     7         STANDBY +DATA/INVOICEDB/ONLINELOG/group_7.343.1125935289             NO           0
     8         STANDBY +DATA/INVOICEDB/ONLINELOG/group_8.344.1125935295             NO           0
     8         STANDBY +DATA/INVOICEDB/ONLINELOG/group_8.345.1125935295             NO           0
     9         STANDBY +DATA/INVOICEDB/ONLINELOG/group_9.346.1125935299             NO           0
     9         STANDBY +DATA/INVOICEDB/ONLINELOG/group_9.347.1125935299             NO           0
    10         STANDBY +DATA/INVOICEDB/ONLINELOG/group_10.348.1125935303            NO           0
    10         STANDBY +DATA/INVOICEDB/ONLINELOG/group_10.349.1125935303            NO           0
    11         STANDBY +DATA/INVOICEDB/ONLINELOG/group_11.352.1125938135            NO           0
    11         STANDBY +DATA/INVOICEDB/ONLINELOG/group_11.353.1125938133            NO           0
    12         STANDBY +DATA/INVOICEDB/ONLINELOG/group_12.350.1125938145            NO           0
    12         STANDBY +DATA/INVOICEDB/ONLINELOG/group_12.351.1125938145            NO           0
    13         STANDBY +DATA/INVOICEDB/ONLINELOG/group_13.360.1125938151            NO           0
    13         STANDBY +DATA/INVOICEDB/ONLINELOG/group_13.361.1125938151            NO           0
    14         STANDBY +DATA/INVOICEDB/ONLINELOG/group_14.359.1125938163            NO           0
    14         STANDBY +DATA/INVOICEDB/ONLINELOG/group_14.358.1125938163            NO           0


-- Run the below query in both the nodes of primary to find the newly added standby redlog files:
set lines 999 pages 999
col inst_id for 9999
col group# for 9999
col member for a60
col archived for a7

SELECT
     a.* 
FROM (SELECT
           '[ ONLINE REDO LOG ]'  redolog_file_type,
            a.inst_id  inst_id,
            a.group#,
            b.thread#,
            b.sequence#,
            a.member,
            b.status,
            b.archived,
            (b.BYTES/1024/1024) AS size_mb
      FROM gv$logfile a, gv$log b
      WHERE a.group#=b.group#
      and a.inst_id=b.inst_id
      and b.thread#=(SELECT value FROM v$parameter WHERE name = 'thread')
      and a.inst_id=( SELECT instance_number FROM v$instance)
      UNION
      SELECT
           '[ STANDBY REDO LOG ]' redolog_file_type,
           a.inst_id,
           a.group#,
           b.thread#,
           b.sequence#,
           a.member,
           b.status,
           b.archived,
           (b.bytes/1024/1024) size_mb
      FROM gv$logfile a, gv$standby_log b
      WHERE a.group#=b.group#
      and a.inst_id=b.inst_id
      and b.thread#=(SELECT value FROM v$parameter WHERE name = 'thread')
      and a.inst_id=( SELECT instance_number FROM v$instance)
    ) a
ORDER BY 2,3;

--At Node 1 (invoice1)
REDOLOG_FILE_TYPE    INST_ID GROUP#    THREAD#  SEQUENCE# MEMBER                                                       STATUS           ARCHIVE    SIZE_MB
-------------------- ------- ------ ---------- ---------- ------------------------------------------------------------ ---------------- ------- ----------
[ ONLINE REDO LOG ]        1      1          1       1446 +DATA/INVOICEDB/ONLINELOG/group_1.334.1125230867             CURRENT          NO              50
[ ONLINE REDO LOG ]        1      1          1       1446 +DATA/INVOICEDB/ONLINELOG/group_1.335.1125230869             CURRENT          NO              50
[ ONLINE REDO LOG ]        1      2          1       1445 +DATA/INVOICEDB/ONLINELOG/group_2.336.1125230875             INACTIVE         YES             50
[ ONLINE REDO LOG ]        1      2          1       1445 +DATA/INVOICEDB/ONLINELOG/group_2.337.1125230875             INACTIVE         YES             50
[ ONLINE REDO LOG ]        1      5          1       1444 +DATA/INVOICEDB/ONLINELOG/group_5.332.1125232101             INACTIVE         YES             50
[ ONLINE REDO LOG ]        1      5          1       1444 +DATA/INVOICEDB/ONLINELOG/group_5.333.1125232099             INACTIVE         YES             50
[ STANDBY REDO LOG ]       1      7          1          0 +DATA/INVOICEDB/ONLINELOG/group_7.342.1125935287             UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      7          1          0 +DATA/INVOICEDB/ONLINELOG/group_7.343.1125935289             UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      8          1          0 +DATA/INVOICEDB/ONLINELOG/group_8.344.1125935295             UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      8          1          0 +DATA/INVOICEDB/ONLINELOG/group_8.345.1125935295             UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      9          1          0 +DATA/INVOICEDB/ONLINELOG/group_9.346.1125935299             UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      9          1          0 +DATA/INVOICEDB/ONLINELOG/group_9.347.1125935299             UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1     10          1          0 +DATA/INVOICEDB/ONLINELOG/group_10.348.1125935303            UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1     10          1          0 +DATA/INVOICEDB/ONLINELOG/group_10.349.1125935303            UNASSIGNED       YES             50

--At Node 2 (invoice2)
REDOLOG_FILE_TYPE    INST_ID GROUP#    THREAD#  SEQUENCE# MEMBER                                                       STATUS           ARCHIVE    SIZE_MB
-------------------- ------- ------ ---------- ---------- ------------------------------------------------------------ ---------------- ------- ----------
[ ONLINE REDO LOG ]        2      3          2        652 +DATA/INVOICEDB/ONLINELOG/group_3.338.1125230885             INACTIVE         YES             50
[ ONLINE REDO LOG ]        2      3          2        652 +DATA/INVOICEDB/ONLINELOG/group_3.339.1125230885             INACTIVE         YES             50
[ ONLINE REDO LOG ]        2      4          2        653 +DATA/INVOICEDB/ONLINELOG/group_4.340.1125230891             INACTIVE         YES             50
[ ONLINE REDO LOG ]        2      4          2        653 +DATA/INVOICEDB/ONLINELOG/group_4.341.1125230891             INACTIVE         YES             50
[ ONLINE REDO LOG ]        2      6          2        654 +DATA/INVOICEDB/ONLINELOG/group_6.330.1125232109             CURRENT          NO              50
[ ONLINE REDO LOG ]        2      6          2        654 +DATA/INVOICEDB/ONLINELOG/group_6.331.1125232109             CURRENT          NO              50
[ STANDBY REDO LOG ]       2     11          2          0 +DATA/INVOICEDB/ONLINELOG/group_11.352.1125938135            UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     11          2          0 +DATA/INVOICEDB/ONLINELOG/group_11.353.1125938133            UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     12          2          0 +DATA/INVOICEDB/ONLINELOG/group_12.350.1125938145            UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     12          2          0 +DATA/INVOICEDB/ONLINELOG/group_12.351.1125938145            UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     13          2          0 +DATA/INVOICEDB/ONLINELOG/group_13.360.1125938151            UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     13          2          0 +DATA/INVOICEDB/ONLINELOG/group_13.361.1125938151            UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     14          2          0 +DATA/INVOICEDB/ONLINELOG/group_14.358.1125938163            UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     14          2          0 +DATA/INVOICEDB/ONLINELOG/group_14.359.1125938163            UNASSIGNED       YES             50

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 137 -->> On Node 1 - DC
[oracle@invoice1 ~]$  sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Mon Jan 2 11:32:36 2023
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> set lines 999 pages 999
SQL> col name for a40 
SQL> col value for a50
SQL> SELECT
          name,
          value
     FROM v$parameter
     WHERE name IN ('db_name','db_unique_name','log_archive_config', 'log_archive_dest_1','log_archive_dest_2','log_archive_dest_state_1','log_archive_dest_state_2',
     'remote_login_passwordfile','log_archive_format','log_archive_max_processes','fal_server','fal_client','standby_file_management',
     'db_file_name_convert','log_file_name_convert','audit_file_dest');

NAME                                     VALUE
---------------------------------------- --------------------------------------------------
db_file_name_convert
log_file_name_convert
log_archive_dest_1                       LOCATION=USE_DB_RECOVERY_FILE_DEST
log_archive_dest_2
log_archive_dest_state_1                 enable
log_archive_dest_state_2                 enable
fal_client
fal_server
log_archive_config
log_archive_format                       invoicedb_%t_%s_%r.arc
log_archive_max_processes                4
standby_file_management                  MANUAL
remote_login_passwordfile                EXCLUSIVE
audit_file_dest                          /opt/app/oracle/admin/invoicedb/adump
db_name                                  invoiced
db_unique_name                           invoicedb

SQL> show parameter db_unique_name

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_unique_name                       string      invoicedb

--SQL> ALTER system SET db_unique_name='invoicedb' scope=spfile sid='*';
SQL> ALTER system SET log_archive_config='DG_CONFIG=(invoicedb,invcdr)' scope=both sid='*';
SQL> ALTER system SET log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=invoicedb' scope=both sid='*';
SQL> ALTER system SET LOG_ARCHIVE_DEST_2='SERVICE=invcdr VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=invcdr' scope=both sid='*';
SQL> ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_1=ENABLE scope=both sid='*';
SQL> ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2=ENABLE scope=both sid='*';
SQL> ALTER system SET log_archive_format='invoicedb_%t_%s_%r.arc' scope=spfile sid='*';
SQL> ALTER system SET LOG_ARCHIVE_MAX_PROCESSES=30 scope=both sid='*';
SQL> ALTER system SET REMOTE_LOGIN_PASSWORDFILE=EXCLUSIVE scope=spfile sid='*';
SQL> ALTER SYSTEM SET fal_client='invoicedb' scope=both sid='*';
SQL> ALTER system SET fal_server = 'invcdr' sid='*';
SQL> ALTER system SET STANDBY_FILE_MANAGEMENT=AUTO scope=spfile sid='*';
SQL> ALTER system SET db_file_name_convert='+DATA/invoicedb/','+DATA/invcdr/', '+ARC/invoicedb/','+ARC/invcdr/' scope=spfile sid='*';
SQL> ALTER system SET log_file_name_convert='+DATA/invoicedb/','+DATA/invcdr/', '+ARC/invoicedb/','+ARC/invcdr/' scope=spfile sid='*';
SQL> ALTER system SET db_recovery_file_dest_size=50G scope=both sid='*';
SQL> exit

*/

-- Step 138 -->> On Both Nodes - DC
[oracle@invoice1/invoice2 ~]$ srvctl status database -d invoicedb -v
/*
Instance invoiced1 is running on node invoice1. Instance status: Open.
Instance invoiced2 is running on node invoice2. Instance status: Open.
*/

-- Step 138.1 -->> On Node 1 - DC
[oracle@invoice1 ~]$ srvctl stop database -d invoicedb

-- Step 138.2 -->> On Node 1 - DC
[oracle@invoice1 ~]$ srvctl start database -d invoicedb

-- Step 139 -->> On Both Nodes - DC
[oracle@invoice1/invoice2 ~]$ srvctl status database -d invoicedb
/*
Instance invoicedb1 is running on node invoice1
Instance invoicedb2 is running on node invoice2
*/

-- Step 139.1 -->> On Both Nodes - DC
[oracle@invoice1/invoice2 ~]$ srvctl status database -d invoicedb -v
/*
Instance invoiced1 is running on node invoice1. Instance status: Open.
Instance invoiced2 is running on node invoice2. Instance status: Open.
*/

-- Step 140 -->> On Node 1 - DC
[oracle@invoice1 ~]$  sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Mon Jan 2 11:32:36 2023
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> show con_name

CON_NAME
------------------------------
CDB$ROOT
SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 INVPDB                         READ WRITE NO

SQL> set lines 999 pages 999
SQL> col name for a40 
SQL> col value for a200
SQL> SELECT
          name,
          value
     FROM v$parameter
     WHERE name IN ('db_name','db_unique_name','log_archive_config', 'log_archive_dest_1','log_archive_dest_2','log_archive_dest_state_1','log_archive_dest_state_2',
     'remote_login_passwordfile','log_archive_format','log_archive_max_processes','fal_server','fal_client','standby_file_management',
     'db_file_name_convert','log_file_name_convert','audit_file_dest');

NAME                                     VALUE
---------------------------------------- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
db_file_name_convert                     +DATA/invoicedb/, +DATA/invcdr/, +ARC/invoicedb/, +ARC/invcdr/
log_file_name_convert                    +DATA/invoicedb/, +DATA/invcdr/, +ARC/invoicedb/, +ARC/invcdr/
log_archive_dest_1                       LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=invoicedb
log_archive_dest_2                       SERVICE=invcdr VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=invcdr
log_archive_dest_state_1                 ENABLE
log_archive_dest_state_2                 ENABLE
fal_client                               invoicedb
fal_server                               invcdr
log_archive_config                       DG_CONFIG=(invoicedb,invcdr)
log_archive_format                       invoicedb_%t_%s_%r.arc
log_archive_max_processes                30
standby_file_management                  AUTO
remote_login_passwordfile                EXCLUSIVE
audit_file_dest                          /opt/app/oracle/admin/invoicedb/adump
db_name                                  invoiced
db_unique_name                           invoicedb

SQL> CREATE PFILE='/home/oracle/backup/initinvoicedb.ora' FROM SPFILE;

SQL> !cat /home/oracle/backup/initinvoicedb.ora
invoiced2.__data_transfer_cache_size=0
invoiced1.__data_transfer_cache_size=0
invoiced2.__db_cache_size=4294967296
invoiced1.__db_cache_size=4244635648
invoiced2.__inmemory_ext_roarea=0
invoiced1.__inmemory_ext_roarea=0
invoiced2.__inmemory_ext_rwarea=0
invoiced1.__inmemory_ext_rwarea=0
invoiced2.__java_pool_size=16777216
invoiced1.__java_pool_size=16777216
invoiced2.__large_pool_size=83886080
invoiced1.__large_pool_size=83886080
invoiced1.__oracle_base='/opt/app/oracle'#ORACLE_BASE set from environment
invoiced2.__oracle_base='/opt/app/oracle'#ORACLE_BASE set from environment
invoiced2.__pga_aggregate_target=2147483648
invoiced1.__pga_aggregate_target=2147483648
invoiced2.__sga_target=6442450944
invoiced1.__sga_target=6442450944
invoiced2.__shared_io_pool_size=134217728
invoiced1.__shared_io_pool_size=134217728
invoiced2.__shared_pool_size=1879048192
invoiced1.__shared_pool_size=1929379840
invoiced2.__streams_pool_size=16777216
invoiced1.__streams_pool_size=16777216
invoiced2.__unified_pga_pool_size=0
invoiced1.__unified_pga_pool_size=0
*.audit_file_dest='/opt/app/oracle/admin/invoicedb/adump'
*.audit_trail='db'
*.cluster_database=TRUE
*.compatible='19.0.0'
*.control_files='+DATA/INVOICEDB/CONTROLFILE/current.261.1120150949','+ARC/INVOICEDB/CONTROLFILE/current.256.1120150951'
*.db_block_size=8192
*.db_create_file_dest='+DATA'
*.db_file_name_convert='+DATA/invoicedb/','+DATA/invcdr/','+ARC/invoicedb/','+ARC/invcdr/'
*.db_name='invoiced'
*.db_recovery_file_dest='+ARC'
*.db_recovery_file_dest_size=53687091200
*.db_unique_name='invoicedb'
*.diagnostic_dest='/opt/app/oracle'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=invoicedXDB)'
*.enable_pluggable_database=true
*.fal_client='invoicedb'
*.fal_server='invcdr'
family:dw_helper.instance_mode='read-only'
invoiced2.instance_number=2
invoiced1.instance_number=1
*.local_listener='-oraagent-dummy-'
*.log_archive_config='DG_CONFIG=(invoicedb,invcdr)'
*.log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=invoicedb'
*.log_archive_dest_2='SERVICE=invcdr VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=invcdr'
*.log_archive_dest_state_1='ENABLE'
*.log_archive_dest_state_2='ENABLE'
*.log_archive_format='invoicedb_%t_%s_%r.arc'
*.log_archive_max_processes=30
*.log_file_name_convert='+DATA/invoicedb/','+DATA/invcdr/','+ARC/invoicedb/','+ARC/invcdr/'
*.nls_language='AMERICAN'
*.nls_territory='AMERICA'
*.open_cursors=300
*.pga_aggregate_target=2048m
*.processes=2000
*.remote_listener='invoice-scan:1521'
*.remote_login_passwordfile='EXCLUSIVE'
*.sec_case_sensitive_logon=TRUE
*.sga_target=6144m
*.standby_file_management='AUTO'
invoiced2.thread=2
invoiced1.thread=1
invoiced2.undo_tablespace='UNDOTBS2'
invoiced1.undo_tablespace='UNDOTBS1'

SQL> !ps -ef | grep tns
root       107     2  0 Jan12 ?        00:00:00 [netns]
oracle   12760 12441  0 09:40 pts/0    00:00:00 /bin/bash -c ps -ef | grep tns
oracle   12762 12760  0 09:40 pts/0    00:00:00 grep tns
grid     17469     1  0 09:33 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER -no_crs_notify -inherit
grid     17914     1  0 09:33 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr ASMNET1LSNR_ASM -no_crs_notify -inherit
grid     30301     1  0 09:36 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid     30304     1  0 09:36 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 141 -->> On Node 1 - DC
[grid@invoice1 ~]$ cat /opt/app/19c/grid/network/admin/listener.ora
/*
LISTENER=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER))))            # line added by Agent
LISTENER_SCAN3=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3))))                # line added by Agent
LISTENER_SCAN2=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2))))                # line added by Agent
LISTENER_SCAN1=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1))))                # line added by Agent
ASMNET1LSNR_ASM=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=ASMNET1LSNR_ASM))))              # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_ASMNET1LSNR_ASM=ON               # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_ASMNET1LSNR_ASM=SUBNET         # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN1=ON                # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_LISTENER_SCAN1=OFF             # line added by Agent - Disabled by Agent because REMOTE_REGISTRATION_ADDRESS is set
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN2=ON                # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_LISTENER_SCAN2=OFF             # line added by Agent - Disabled by Agent because REMOTE_REGISTRATION_ADDRESS is set
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN3=ON                # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_LISTENER_SCAN3=OFF             # line added by Agent - Disabled by Agent because REMOTE_REGISTRATION_ADDRESS is set
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER=ON              # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_LISTENER=SUBNET                # line added by Agent

ADR_BASE_LISTENER_SCAN3 = /opt/app/oracle
ADR_BASE_LISTENER_SCAN2 = /opt/app/oracle
ADR_BASE_LISTENER_SCAN1 = /opt/app/oracle
*/

-- Step 142 -->> On Node 1 - DC
[grid@invoice1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 13-JAN-2023 10:07:29

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                13-JAN-2023 09:33:27
Uptime                    0 days 0 hr. 34 min. 1 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/invoice1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.1.1.40)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.1.1.42)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "86b637b62fdf7a65e053f706e80a27ca" has 1 instance(s).
  Instance "invoiced1", status READY, has 1 handler(s) for this service...
Service "ece0ff8781ac5725e053290610ac0d82" has 1 instance(s).
  Instance "invoiced1", status READY, has 1 handler(s) for this service...
Service "invoicedXDB" has 1 instance(s).
  Instance "invoiced1", status READY, has 1 handler(s) for this service...
Service "invoicedb" has 1 instance(s).
  Instance "invoiced1", status READY, has 1 handler(s) for this service...
Service "invpdb" has 1 instance(s).
  Instance "invoiced1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 143 -->> On Node 2 - DC
[grid@invoice2 ~]$  cat /opt/app/19c/grid/network/admin/listener.ora
/*
LISTENER=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER))))            # line added by Agent
LISTENER_SCAN3=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3))))                # line added by Agent
LISTENER_SCAN2=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2))))                # line added by Agent
LISTENER_SCAN1=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1))))                # line added by Agent
ASMNET1LSNR_ASM=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=ASMNET1LSNR_ASM))))              # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_ASMNET1LSNR_ASM=ON               # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_ASMNET1LSNR_ASM=SUBNET         # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN1=ON                # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_LISTENER_SCAN1=OFF             # line added by Agent - Disabled by Agent because REMOTE_REGISTRATION_ADDRESS is set
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN2=ON                # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_LISTENER_SCAN2=OFF             # line added by Agent - Disabled by Agent because REMOTE_REGISTRATION_ADDRESS is set
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN3=ON                # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_LISTENER_SCAN3=OFF             # line added by Agent - Disabled by Agent because REMOTE_REGISTRATION_ADDRESS is set
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER=ON              # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_LISTENER=SUBNET                # line added by Agent

ADR_BASE_LISTENER_SCAN3 = /opt/app/oracle
ADR_BASE_LISTENER_SCAN2 = /opt/app/oracle
ADR_BASE_LISTENER_SCAN1 = /opt/app/oracle
*/

-- Step 144 -->> On Node 2 - DC
[grid@invoice2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 13-JAN-2023 10:08:33

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                13-JAN-2023 09:37:53
Uptime                    0 days 0 hr. 30 min. 40 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/invoice2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.1.1.41)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.1.1.43)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "86b637b62fdf7a65e053f706e80a27ca" has 1 instance(s).
  Instance "invoiced2", status READY, has 1 handler(s) for this service...
Service "ece0ff8781ac5725e053290610ac0d82" has 1 instance(s).
  Instance "invoiced2", status READY, has 1 handler(s) for this service...
Service "invoicedXDB" has 1 instance(s).
  Instance "invoiced2", status READY, has 1 handler(s) for this service...
Service "invoicedb" has 1 instance(s).
  Instance "invoiced2", status READY, has 1 handler(s) for this service...
Service "invpdb" has 1 instance(s).
  Instance "invoiced2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 145 -->> On Node 1 - DC
[oracle@invoice1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 145.1 -->> On Node 1 - DC
[oracle@invoice1 admin]$ vi tnsnames.ora
/*
# tnsnames.ora Network Configuration File: /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.

INVOICEDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invoice-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invoicedb)
    )
  )

INVOICED1 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.1.1.40)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invoicedb)
    )
  )

INVPDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invoice-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invpdb)
    )
  )

INVCDR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invcdr1.unidev.com)(PORT = 1541))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invcdr)(UR=A)
    )
  )
*/

-- Step 146 -->> On Node 1 - DC
[oracle@invoice1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 146.1 -->> On Node 1 - DC
[oracle@invoice1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 146.2 -->> On Node 1 - DC
[oracle@invoice1 admin]$ scp -r tnsnames.ora invoice2:/opt/app/oracle/product/19c/db_1/network/admin
/*
tnsnames.ora                                                              100%  895     1.2MB/s   00:00
*/

-- Step 147 -->> On Node 2 - DC
[oracle@invoice2 ~]$ cd $ORACLE_HOME/network/admin

-- Step 147.1 -->> On Node 2 - DC
[oracle@invoice1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 147.2 -->> On Node 2 - DC
[oracle@invoice2 admin]$ vi tnsnames.ora
/*
# tnsnames.ora Network Configuration File: /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.

INVOICEDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invoice-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invoicedb)
    )
  )

INVOICED2 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.1.1.41)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invoicedb)
    )
  )

INVPDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invoice-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invpdb)
    )
  )

INVCDR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invcdr1.unidev.com)(PORT = 1541))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invcdr)(UR=A)
    )
  )
*/

-- Step 148 -->> On Node 1 - DC
[oracle@invoice1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 148.1 -->> On Node 1 - DC
[oracle@invoice1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 148.2 -->> On Node 1 - DC
[oracle@invoice1 admin]$ scp -r tnsnames.ora invcdr1:/opt/app/oracle/product/19c/db_1/network/admin
/*
oracle@invcdr1's password: Or@cL5@!Nv#
tnsnames.ora                                                              100%  895     1.1MB/s   00:00
*/

-- Step 148.3 -->> On Node 1 - DC
[oracle@invoice1 admin]$ scp -r tnsnames.ora invcdr2:/opt/app/oracle/product/19c/db_1/network/admin
/*
oracle@invcdr2's password: Or@cL5@!Nv#
tnsnames.ora                                                              100%  895     1.1MB/s   00:00
*/

-- Step 149 -->> On Node 1 - DR
[oracle@invcdr1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 149.1 -->> On Node 1 - DR
[oracle@invcdr1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 149.2 -->> On Node 1 - DR
[oracle@invcdr1 admin]$ vi tnsnames.ora
/*
# tnsnames.ora Network Configuration File: /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.

INVOICEDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invoice-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invoicedb)
    )
  )

INVCDR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invcdr1.unidev.com)(PORT = 1541))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invcdr)(UR=A)
    )
  )
*/

-- Step 150 -->> On Node 2 - DR
[oracle@invcdr2 ~]$ cd $ORACLE_HOME/network/admin

-- Step 150.1 -->> On Node 2 - DR
[oracle@invcdr2 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 150.2 -->> On Node 2 - DR
[oracle@invcdr2 admin]$ cat tnsnames.ora
/*
# tnsnames.ora Network Configuration File: /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.

INVOICEDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invoice-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invoicedb)
    )
  )

INVCDR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invcdr1.unidev.com)(PORT = 1541))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invcdr)(UR=A)
    )
  )
*/

-- Step 151 -->> On Node 1 - DC
[oracle@invoice1 ~]$ cd /home/oracle/backup/

-- Step 151.1 -->> On Node 1 - DC
[oracle@invoice1 backup]$ ll initinvoicedb.ora
/*
-rw-r--r-- 1 oracle asmadmin 2780 Jan 12 17:35 initinvoicedb.ora
*/

-- Step 151.2 -->> On Node 1 - DC
[oracle@invoice1 backup]$ scp -r initinvoicedb.ora invcdr1:/opt/app/oracle/product/19c/db_1/dbs/initinvcdr1.ora
/*
oracle@invcdr1's password: Or@cL5@!Nv#
initinvcdr1.ora                                                         100% 2780     4.7MB/s   00:00
*/

-- Step 152 -->> On Node 1 - DR
[oracle@invcdr1 ~]$ cd $ORACLE_HOME/dbs

-- Step 152.1 -->> On Node 1 - DR
[oracle@invcdr1 dbs]$ ll initinvcdr1.ora
/*
-rw-r--r-- 1 oracle oinstall 2780 Jan 13 10:38 initinvcdr1.ora
*/

-- Step 152.2 -->> On Node 1 - DR
[oracle@invcdr1 dbs]$ vi initinvcdr1.ora
/*
*.audit_file_dest='/opt/app/oracle/admin/invcdr/adump'
*.audit_trail='db'
*.cluster_database=false
*.compatible='19.0.0'
*.control_files='+DATA/INVCDR/CONTROLFILE/current.261.1120150949','+ARC/INVCDR/CONTROLFILE/current.256.1120150951'
*.db_block_size=8192
*.db_create_file_dest='+DATA'
*.db_file_name_convert='+DATA/invoicedb/','+DATA/invcdr/','+ARC/invoicedb/','+ARC/invcdr/'
*.db_name='invoiced'
*.db_recovery_file_dest='+ARC'
*.db_recovery_file_dest_size=53687091200
*.db_unique_name='invcdr'
*.diagnostic_dest='/opt/app/oracle'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=invoicedXDB)'
*.enable_pluggable_database=true
*.fal_client='invcdr'
*.fal_server='invoicedb'
invcdr1.instance_number=1
*.log_archive_config='DG_CONFIG=(invoicedb,invcdr)'
*.log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=invcdr'
*.log_archive_dest_2='SERVICE=invoicedb VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=invoicedb'
*.log_archive_dest_state_1='ENABLE'
*.log_archive_dest_state_2='DEFER'
*.log_archive_format='%t_%s_%r.arc'
*.log_archive_max_processes=30
*.log_file_name_convert='+DATA/invoicedb/','+DATA/invcdr/','+ARC/invoicedb/','+ARC/invcdr/'
*.nls_language='AMERICAN'
*.nls_territory='AMERICA'
*.open_cursors=300
*.pga_aggregate_target=2048m
*.processes=2000
*.remote_login_passwordfile='EXCLUSIVE'
*.sga_target=6144m
*.standby_file_management='AUTO'
invcdr1.thread=1
invcdr1.undo_tablespace='UNDOTBS1'
*/

-- Step 153 -->> On Both Node's - DR
--[root@invcdr1/invcdr2 ~]# mkdir -p /opt/app/oracle/admin/invcdr/hdump
--[root@invcdr1/invcdr2 ~]# mkdir -p /opt/app/oracle/admin/invcdr/dpdump
--[root@invcdr1/invcdr2 ~]# mkdir -p /opt/app/oracle/admin/invcdr/pfile
[root@invcdr1/invcdr2 ~]# mkdir -p /opt/app/oracle/admin/invcdr/adump
[root@invcdr1/invcdr2 ~]# cd /opt/app/oracle/admin/
[root@invcdr1/invcdr2 admin]# chown -R oracle:oinstall invcdr/
[root@invcdr1/invcdr2 admin]# chmod -R 775 invcdr/

-- Step 154 -->> On Node 1 - DR
[grid@invcdr1 ~]$ asmcmd -p
/*
ASMCMD [+] > ls
ARC/
DATA/
OCR/
ASMCMD [+] > cd +ARC
ASMCMD [+ARC] > mkdir INVCDR
ASMCMD [+ARC] > cd INVCDR
ASMCMD [+ARC/INVCDR] > mkdir CONTROLFILE
ASMCMD [+ARC/INVCDR] > cd ../..
ASMCMD [+] > cd +DATA
ASMCMD [+DATA] > mkdir INVCDR
ASMCMD [+DATA/INVCDR] > cd INVCDR
ASMCMD [+DATA/INVCDR] > mkdir CONTROLFILE
ASMCMD [+DATA/INVCDR] > exit
*/

-- Step 155 -->> On Node 1 - DR
[oracle@invcdr1 ~]$ env | grep ORA
/*
ORACLE_UNQNAME=invoicedb
ORACLE_SID=invcdr1
ORACLE_BASE=/opt/app/oracle
ORACLE_HOSTNAME=invcdr1.unidev.com
ORACLE_HOME=/opt/app/oracle/product/19c/db_1
*/

-- Step 156 -->> On Node 1 - DR
[oracle@invcdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri Jan 13 11:28:47 2023
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> startup nomount pfile='/opt/app/oracle/product/19c/db_1/dbs/initinvcdr1.ora';
ORACLE instance started.

Total System Global Area 6442448976 bytes
Fixed Size                  9152592 bytes
Variable Size            1140850688 bytes
Database Buffers         5284823040 bytes
Redo Buffers                7622656 bytes
*/

-- Step 156 -->> On Node 1 - DR
--Creating temporary listener 
[oracle@invcdr1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 156.1 -->> On Node 1 - DR
[oracle@invcdr1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 156.2 -->> On Node 1 - DR
[oracle@invcdr1 admin]$ vi listener.ora
/*
SID_LIST_LISTENER1 =
  (SID_LIST =
    (SID_DESC =
      (GLOBAL_DBNAME = invcdr)
      (ORACLE_HOME = /opt/app/oracle/product/19c/db_1)
      (SID_NAME = invcdr1)
    )
  )

LISTENER1 =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = invcdr1.unidev.com)(PORT = 1541))
    )
  )
*/

-- Step 156.3 -->> On Node 1 - DR
[oracle@invcdr1 admin]$ ll listener.ora
/*
-rw-r--r-- 1 oracle oinstall 315 Jan 13 11:41 listener.ora
*/

-- Step 156.4 -->> On Node 1 - DR
[oracle@invcdr1 admin]$ lsnrctl start listener1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 13-JAN-2023 11:43:20

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Starting /opt/app/oracle/product/19c/db_1/bin/tnslsnr: please wait...

TNSLSNR for Linux: Version 19.0.0.0.0 - Production
System parameter file is /opt/app/oracle/product/19c/db_1/network/admin/listener.ora
Log messages written to /opt/app/oracle/product/19c/db_1/network/log/listener1.log
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=invcdr1.unidev.com)(PORT=1541)))

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=invcdr1.unidev.com)(PORT=1541)))
The command completed successfully
*/

-- Step 156.5 -->> On Node 1 - DR
[oracle@invcdr1 admin]$ lsnrctl status listener1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 13-JAN-2023 11:44:04

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=invcdr1.unidev.com)(PORT=1541)))
STATUS of the LISTENER
------------------------
Alias                     listener1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                13-JAN-2023 11:43:20
Uptime                    0 days 0 hr. 0 min. 43 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/oracle/product/19c/db_1/network/admin/listener.ora
Listener Log File         /opt/app/oracle/product/19c/db_1/network/log/listener1.log
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=invcdr1.unidev.com)(PORT=1541)))
Services Summary...
Service "invcdr" has 1 instance(s).
  Instance "invcdr1", status UNKNOWN, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 156.6 -->> On Node 1 - DR
[oracle@invcdr1 admin]$ sqlplus sys/P#ssw0rd@invoicedb as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri Jan 13 11:47:18 2023
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> SELECT name,open_mode FROM v$database;

NAME      OPEN_MODE
--------- --------------------
INVOICED  READ WRITE

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 INVPDB                         READ WRITE NO
SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 156.7 -->> On Node 1 - DR
[oracle@invcdr1 admin]$ sqlplus sys/P#ssw0rd@invcdr as sysdba

/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri Jan 13 11:48:06 2023
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> show pdbs

SQL> SELECT name,open_mode FROM v$database;
SELECT name,open_mode FROM v$database
                           *
ERROR at line 1:
ORA-01507: database not mounted


SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 157 -->> On Node 1 - DC
[oracle@invoice1 ~]$ sqlplus sys/P#ssw0rd@invoicedb as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri Jan 13 11:49:18 2023
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> SELECT name,open_mode FROM v$database;

NAME      OPEN_MODE
--------- --------------------
INVOICED  READ WRITE

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 INVPDB                         READ WRITE NO
SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 157.1 -->> On Node 1 - DC
[oracle@invoice1 ~]$ sqlplus sys/P#ssw0rd@invcdr as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri Jan 13 11:50:07 2023
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> show pdbs

SQL> SELECT name,open_mode FROM v$database;
SELECT name,open_mode FROM v$database
                           *
ERROR at line 1:
ORA-01507: database not mounted


SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 158 -->> On Node 1 - DR
[oracle@invcdr1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 158.1 -->> On Node 1 - DR
[oracle@invcdr1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 158.2 -->> On Node 1 - DR
[oracle@invcdr1 admin]$ rman target sys/P#ssw0rd@invoicedb auxiliary sys/P#ssw0rd@invcdr
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Fri Jan 13 12:00:25 2023
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: INVOICED (DBID=3646030117)
connected to auxiliary database: INVOICED (not mounted)


RMAN> duplicate target database for standby from active database nofilenamecheck;

Starting Duplicate Db at 13-JAN-23
using target database control file instead of recovery catalog
allocated channel: ORA_AUX_DISK_1
channel ORA_AUX_DISK_1: SID=570 device type=DISK

contents of Memory Script:
{
   backup as copy reuse
   passwordfile auxiliary format  '/opt/app/oracle/product/19c/db_1/dbs/orapwinvcdr1'   ;
}
executing Memory Script

Starting backup at 13-JAN-23
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=2665 instance=invoiced1 device type=DISK
Finished backup at 13-JAN-23

contents of Memory Script:
{
   sql clone "create spfile from memory";
   shutdown clone immediate;
   startup clone nomount;
   restore clone from service  'invoicedb' standby controlfile;
}
executing Memory Script

sql statement: create spfile from memory

Oracle instance shut down

connected to auxiliary database (not started)
Oracle instance started

Total System Global Area    6442448976 bytes

Fixed Size                     9152592 bytes
Variable Size               1140850688 bytes
Database Buffers            5284823040 bytes
Redo Buffers                   7622656 bytes

Starting restore at 13-JAN-23
allocated channel: ORA_AUX_DISK_1
channel ORA_AUX_DISK_1: SID=572 device type=DISK

channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: restoring control file
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:02
output file name=+DATA/INVCDR/CONTROLFILE/current.332.1126008147
output file name=+ARC/INVCDR/CONTROLFILE/current.390.1126008147
Finished restore at 13-JAN-23

contents of Memory Script:
{
   sql clone 'alter database mount standby database';
}
executing Memory Script

sql statement: alter database mount standby database

RMAN-05529: warning: DB_FILE_NAME_CONVERT resulted in invalid ASM names; names changed to disk group only.

contents of Memory Script:
{
   set newname for tempfile  1 to
 "+DATA";
   set newname for tempfile  2 to
 "+DATA";
   set newname for tempfile  3 to
 "+DATA";
   set newname for tempfile  4 to
 "+DATA";
   set newname for tempfile  5 to
 "+DATA";
   switch clone tempfile all;
   set newname for datafile  1 to
 "+DATA";
   set newname for datafile  3 to
 "+DATA";
   set newname for datafile  4 to
 "+DATA";
   set newname for datafile  5 to
 "+DATA";
   set newname for datafile  6 to
 "+DATA";
   set newname for datafile  7 to
 "+DATA";
   set newname for datafile  8 to
 "+DATA";
   set newname for datafile  9 to
 "+DATA";
   set newname for datafile  10 to
 "+DATA";
   set newname for datafile  11 to
 "+DATA";
   set newname for datafile  12 to
 "+DATA";
   set newname for datafile  13 to
 "+DATA";
   set newname for datafile  14 to
 "+DATA";
   set newname for datafile  20 to
 "+DATA";
   set newname for datafile  21 to
 "+DATA";
   set newname for datafile  22 to
 "+DATA";
   set newname for datafile  23 to
 "+DATA";
   set newname for datafile  24 to
 "+DATA";
   set newname for datafile  25 to
 "+DATA";
   set newname for datafile  26 to
 "+DATA";
   set newname for datafile  27 to
 "+DATA";
   set newname for datafile  28 to
 "+DATA";
   set newname for datafile  29 to
 "+DATA";
   set newname for datafile  30 to
 "+DATA";
   set newname for datafile  31 to
 "+DATA";
   set newname for datafile  32 to
 "+DATA";
   set newname for datafile  33 to
 "+DATA";
   set newname for datafile  34 to
 "+DATA";
   set newname for datafile  35 to
 "+DATA";
   set newname for datafile  36 to
 "+DATA";
   set newname for datafile  37 to
 "+DATA";
   set newname for datafile  38 to
 "+DATA";
   set newname for datafile  39 to
 "+DATA";
   set newname for datafile  40 to
 "+DATA";
   set newname for datafile  41 to
 "+DATA";
   set newname for datafile  42 to
 "+DATA";
   set newname for datafile  43 to
 "+DATA";
   set newname for datafile  44 to
 "+DATA";
   set newname for datafile  45 to
 "+DATA";
   set newname for datafile  46 to
 "+DATA";
   set newname for datafile  47 to
 "+DATA";
   set newname for datafile  48 to
 "+DATA";
   set newname for datafile  49 to
 "+DATA";
   set newname for datafile  50 to
 "+DATA";
   set newname for datafile  51 to
 "+DATA";
   set newname for datafile  52 to
 "+DATA";
   set newname for datafile  53 to
 "+DATA";
   set newname for datafile  54 to
 "+DATA";
   set newname for datafile  55 to
 "+DATA";
   set newname for datafile  56 to
 "+DATA";
   set newname for datafile  57 to
 "+DATA";
   set newname for datafile  58 to
 "+DATA";
   set newname for datafile  59 to
 "+DATA";
   set newname for datafile  60 to
 "+DATA";
   set newname for datafile  61 to
 "+DATA";
   set newname for datafile  62 to
 "+DATA";
   set newname for datafile  63 to
 "+DATA";
   set newname for datafile  64 to
 "+DATA";
   restore
   from  nonsparse   from service
 'invoicedb'   clone database
   ;
   sql 'alter system archive log current';
}
executing Memory Script

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

renamed tempfile 1 to +DATA in control file
renamed tempfile 2 to +DATA in control file
renamed tempfile 3 to +DATA in control file
renamed tempfile 4 to +DATA in control file
renamed tempfile 5 to +DATA in control file

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

Starting restore at 13-JAN-23
using channel ORA_AUX_DISK_1

channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00001 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:15
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00003 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:45
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00004 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:08
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00005 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00006 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:08
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00007 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:01
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00008 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:03
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00009 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:02
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00010 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00011 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:15
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00012 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:02
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00013 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:03
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00014 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:01
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00020 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:02
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00021 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:01
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00022 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:01
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00023 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:01
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00024 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:02
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00025 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00026 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00027 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:08
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00028 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00029 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00030 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:01:36
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00031 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:01:35
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00032 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:08
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00033 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00034 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00035 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00036 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00037 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00038 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:08
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00039 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:04:05
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00040 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:45
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00041 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:04:46
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00042 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00043 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:46
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00044 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:15
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00045 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:15
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00046 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00047 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00048 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:01:46
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00049 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:15
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00050 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00051 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:15
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00052 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00053 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:02:15
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00054 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:01:36
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00055 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00056 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00057 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:46
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00058 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00059 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00060 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:08
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00061 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00062 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:08
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00063 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:15
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service invoicedb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00064 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
Finished restore at 13-JAN-23

sql statement: alter system archive log current

contents of Memory Script:
{
   switch clone datafile all;
}
executing Memory Script

datafile 1 switched to datafile copy
input datafile copy RECID=62 STAMP=1126009746 file name=+DATA/INVCDR/DATAFILE/system.331.1126008165
datafile 3 switched to datafile copy
input datafile copy RECID=63 STAMP=1126009746 file name=+DATA/INVCDR/DATAFILE/sysaux.330.1126008179
datafile 4 switched to datafile copy
input datafile copy RECID=64 STAMP=1126009746 file name=+DATA/INVCDR/DATAFILE/undotbs1.329.1126008225
datafile 5 switched to datafile copy
input datafile copy RECID=65 STAMP=1126009746 file name=+DATA/INVCDR/ECE0BFC1D3B3244BE053280610ACB451/DATAFILE/system.328.1126008233
datafile 6 switched to datafile copy
input datafile copy RECID=66 STAMP=1126009746 file name=+DATA/INVCDR/ECE0BFC1D3B3244BE053280610ACB451/DATAFILE/sysaux.270.1126008241
datafile 7 switched to datafile copy
input datafile copy RECID=67 STAMP=1126009746 file name=+DATA/INVCDR/DATAFILE/users.269.1126008247
datafile 8 switched to datafile copy
input datafile copy RECID=68 STAMP=1126009746 file name=+DATA/INVCDR/ECE0BFC1D3B3244BE053280610ACB451/DATAFILE/undotbs1.268.1126008249
datafile 9 switched to datafile copy
input datafile copy RECID=69 STAMP=1126009746 file name=+DATA/INVCDR/DATAFILE/undotbs2.267.1126008253
datafile 10 switched to datafile copy
input datafile copy RECID=70 STAMP=1126009746 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/system.266.1126008253
datafile 11 switched to datafile copy
input datafile copy RECID=71 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/sysaux.265.1126008261
datafile 12 switched to datafile copy
input datafile copy RECID=72 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/undotbs1.264.1126008277
datafile 13 switched to datafile copy
input datafile copy RECID=73 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/undo_2.263.1126008277
datafile 14 switched to datafile copy
input datafile copy RECID=74 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/users.262.1126008281
datafile 20 switched to datafile copy
input datafile copy RECID=75 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/invdb_ias_opss.261.1126008283
datafile 21 switched to datafile copy
input datafile copy RECID=76 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/invdb_iau.260.1126008283
datafile 22 switched to datafile copy
input datafile copy RECID=77 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/invdb_mds.259.1126008285
datafile 23 switched to datafile copy
input datafile copy RECID=78 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/invdb_stb.257.1126008287
datafile 24 switched to datafile copy
input datafile copy RECID=79 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/invdb_wls.258.1126008287
datafile 25 switched to datafile copy
input datafile copy RECID=80 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/tbs_cas.335.1126008289
datafile 26 switched to datafile copy
input datafile copy RECID=81 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/tbs_cas_index.334.1126008297
datafile 27 switched to datafile copy
input datafile copy RECID=82 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cibaip_data.310.1126008303
datafile 28 switched to datafile copy
input datafile copy RECID=83 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cibaip_indx.306.1126008311
datafile 29 switched to datafile copy
input datafile copy RECID=84 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cibaip_temp.323.1126008319
datafile 30 switched to datafile copy
input datafile copy RECID=85 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cib_egindx.302.1126008325
datafile 31 switched to datafile copy
input datafile copy RECID=86 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cib_egtable.304.1126008421
datafile 32 switched to datafile copy
input datafile copy RECID=87 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cib_egtemp.305.1126008517
datafile 33 switched to datafile copy
input datafile copy RECID=88 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cib_indx.322.1126008523
datafile 34 switched to datafile copy
input datafile copy RECID=89 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cib_table.280.1126008531
datafile 35 switched to datafile copy
input datafile copy RECID=90 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cib_temp.301.1126008539
datafile 36 switched to datafile copy
input datafile copy RECID=91 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cib_temp_table.299.1126008545
datafile 37 switched to datafile copy
input datafile copy RECID=92 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cisjn_data.271.1126008553
datafile 38 switched to datafile copy
input datafile copy RECID=93 STAMP=1126009747 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cisjn_temp.273.1126008561
datafile 39 switched to datafile copy
input datafile copy RECID=94 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cison_aud_data.292.1126008567
datafile 40 switched to datafile copy
input datafile copy RECID=95 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cison_aud_indx.321.1126008813
datafile 41 switched to datafile copy
input datafile copy RECID=96 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cison_data.294.1126008859
datafile 42 switched to datafile copy
input datafile copy RECID=97 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cison_data_stg.298.1126009143
datafile 43 switched to datafile copy
input datafile copy RECID=98 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cison_indx.276.1126009151
datafile 44 switched to datafile copy
input datafile copy RECID=99 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cison_rpt_data.289.1126009197
datafile 45 switched to datafile copy
input datafile copy RECID=100 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cison_rpt_indx.320.1126009213
datafile 46 switched to datafile copy
input datafile copy RECID=101 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cis_acc_data.291.1126009227
datafile 47 switched to datafile copy
input datafile copy RECID=102 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cis_acc_indx.295.1126009235
datafile 48 switched to datafile copy
input datafile copy RECID=103 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cis_aud_data.317.1126009243
datafile 49 switched to datafile copy
input datafile copy RECID=104 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cis_aud_indx.286.1126009347
datafile 50 switched to datafile copy
input datafile copy RECID=105 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/kskl_indx.316.1126009363
datafile 51 switched to datafile copy
input datafile copy RECID=106 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cis_com_data.275.1126009371
datafile 52 switched to datafile copy
input datafile copy RECID=107 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cis_com_indx.256.1126009385
datafile 53 switched to datafile copy
input datafile copy RECID=108 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cis_data.319.1126009393
datafile 54 switched to datafile copy
input datafile copy RECID=109 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cis_indx.288.1126009529
datafile 55 switched to datafile copy
input datafile copy RECID=110 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cis_lob.293.1126009623
datafile 56 switched to datafile copy
input datafile copy RECID=111 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cis_reg_data.283.1126009631
datafile 57 switched to datafile copy
input datafile copy RECID=112 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cis_reg_indx.318.1126009639
datafile 58 switched to datafile copy
input datafile copy RECID=113 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cis_rpt_data.285.1126009683
datafile 59 switched to datafile copy
input datafile copy RECID=114 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cis_rpt_indx.290.1126009691
datafile 60 switched to datafile copy
input datafile copy RECID=115 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/cis_temp01.279.1126009699
datafile 61 switched to datafile copy
input datafile copy RECID=116 STAMP=1126009748 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/indx.277.1126009705
datafile 62 switched to datafile copy
input datafile copy RECID=117 STAMP=1126009749 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/kskl.281.1126009713
datafile 63 switched to datafile copy
input datafile copy RECID=118 STAMP=1126009749 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/tbs_sysmfi.282.1126009721
datafile 64 switched to datafile copy
input datafile copy RECID=119 STAMP=1126009749 file name=+DATA/INVCDR/ECE0FF8781AC5725E053290610AC0D82/DATAFILE/tbs_sysmfi_indexes.287.1126009735
Finished Duplicate Db at 13-JAN-23
RMAN> exit


Recovery Manager complete.
*/

-- Step 159 -->> On Node 1 - DR
[oracle@invcdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri Jan 13 12:37:29 2023
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       MOUNTED
         3 INVPDB                         MOUNTED


SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL>  SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 INVOICED  invcdr1          MOUNTED      13-JAN-23 invcdr1.unidev.com      MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED


SQL> SELECT group#,thread#,bytes FROM gv$log order by 1,2;

    GROUP#    THREAD#      BYTES
---------- ---------- ----------
         1          1   52428800
         2          1   52428800
         3          2   52428800
         4          2   52428800
         5          1   52428800
         6          2   52428800


SQL> col member for a50
SQL> SELECT * FROM v$logfile a ORDER BY a.type,a.group#;

    GROUP# STATUS  TYPE    MEMBER                                             IS_     CON_ID
---------- ------- ------- -------------------------------------------------- --- ----------
         1         ONLINE  +DATA/INVCDR/ONLINELOG/group_1.278.1126009755      NO           0
         1         ONLINE  +ARC/INVCDR/ONLINELOG/group_1.394.1126009755       YES          0
         2         ONLINE  +ARC/INVCDR/ONLINELOG/group_2.395.1126009757       YES          0
         2         ONLINE  +DATA/INVCDR/ONLINELOG/group_2.284.1126009755      NO           0
         3         ONLINE  +ARC/INVCDR/ONLINELOG/group_3.393.1126009757       YES          0
         3         ONLINE  +DATA/INVCDR/ONLINELOG/group_3.309.1126009757      NO           0
         4         ONLINE  +ARC/INVCDR/ONLINELOG/group_4.392.1126009757       YES          0
         4         ONLINE  +DATA/INVCDR/ONLINELOG/group_4.327.1126009757      NO           0
         5         ONLINE  +DATA/INVCDR/ONLINELOG/group_5.312.1126009759      NO           0
         5         ONLINE  +ARC/INVCDR/ONLINELOG/group_5.344.1126009759       YES          0
         6         ONLINE  +DATA/INVCDR/ONLINELOG/group_6.308.1126009759      NO           0
         6         ONLINE  +ARC/INVCDR/ONLINELOG/group_6.343.1126009759       YES          0
         7         STANDBY +DATA/INVCDR/ONLINELOG/group_7.326.1126009759      NO           0
         7         STANDBY +ARC/INVCDR/ONLINELOG/group_7.342.1126009759       YES          0
         8         STANDBY +DATA/INVCDR/ONLINELOG/group_8.311.1126009759      NO           0
         8         STANDBY +ARC/INVCDR/ONLINELOG/group_8.341.1126009761       YES          0
         9         STANDBY +DATA/INVCDR/ONLINELOG/group_9.307.1126009761      NO           0
         9         STANDBY +ARC/INVCDR/ONLINELOG/group_9.340.1126009761       YES          0
        10         STANDBY +DATA/INVCDR/ONLINELOG/group_10.325.1126009761     NO           0
        10         STANDBY +ARC/INVCDR/ONLINELOG/group_10.339.1126009761      YES          0
        11         STANDBY +ARC/INVCDR/ONLINELOG/group_11.262.1126009761      YES          0
        11         STANDBY +DATA/INVCDR/ONLINELOG/group_11.303.1126009761     NO           0
        12         STANDBY +ARC/INVCDR/ONLINELOG/group_12.261.1126009763      YES          0
        12         STANDBY +DATA/INVCDR/ONLINELOG/group_12.324.1126009763     NO           0
        13         STANDBY +ARC/INVCDR/ONLINELOG/group_13.260.1126009763      YES          0
        13         STANDBY +DATA/INVCDR/ONLINELOG/group_13.274.1126009763     NO           0
        14         STANDBY +DATA/INVCDR/ONLINELOG/group_14.315.1126009763     NO           0
        14         STANDBY +ARC/INVCDR/ONLINELOG/group_14.259.1126009765      YES          0


SQL> SELECT b.thread#,a.group#,a.member,b.bytes FROM v$logfile a, v$log b  WHERE a.group#=b.group# ORDER BY b.group#;

   THREAD#     GROUP# MEMBER                                                  BYTES
---------- ---------- -------------------------------------------------- ----------
         1          1 +DATA/INVCDR/ONLINELOG/group_1.278.1126009755        52428800
         1          1 +ARC/INVCDR/ONLINELOG/group_1.394.1126009755         52428800
         1          2 +ARC/INVCDR/ONLINELOG/group_2.395.1126009757         52428800
         1          2 +DATA/INVCDR/ONLINELOG/group_2.284.1126009755        52428800
         2          3 +ARC/INVCDR/ONLINELOG/group_3.393.1126009757         52428800
         2          3 +DATA/INVCDR/ONLINELOG/group_3.309.1126009757        52428800
         2          4 +ARC/INVCDR/ONLINELOG/group_4.392.1126009757         52428800
         2          4 +DATA/INVCDR/ONLINELOG/group_4.327.1126009757        52428800
         1          5 +DATA/INVCDR/ONLINELOG/group_5.312.1126009759        52428800
         1          5 +ARC/INVCDR/ONLINELOG/group_5.344.1126009759         52428800
         2          6 +DATA/INVCDR/ONLINELOG/group_6.308.1126009759        52428800
         2          6 +ARC/INVCDR/ONLINELOG/group_6.343.1126009759         52428800

--Node 1
SQL> SELECT b.thread#,a.group#, a.type, a.member, b.bytes FROM v$logfile a, v$standby_log b WHERE a.group# = b.group# ORDER BY 2,4;

   THREAD#     GROUP# TYPE    MEMBER                                                  BYTES
---------- ---------- ------- -------------------------------------------------- ----------
         1          7 STANDBY +ARC/INVCDR/ONLINELOG/group_7.342.1126009759         52428800
         1          7 STANDBY +DATA/INVCDR/ONLINELOG/group_7.326.1126009759        52428800
         1          8 STANDBY +ARC/INVCDR/ONLINELOG/group_8.341.1126009761         52428800
         1          8 STANDBY +DATA/INVCDR/ONLINELOG/group_8.311.1126009759        52428800
         1          9 STANDBY +ARC/INVCDR/ONLINELOG/group_9.340.1126009761         52428800
         1          9 STANDBY +DATA/INVCDR/ONLINELOG/group_9.307.1126009761        52428800
         1         10 STANDBY +ARC/INVCDR/ONLINELOG/group_10.339.1126009761        52428800
         1         10 STANDBY +DATA/INVCDR/ONLINELOG/group_10.325.1126009761       52428800
         2         11 STANDBY +ARC/INVCDR/ONLINELOG/group_11.262.1126009761        52428800
         2         11 STANDBY +DATA/INVCDR/ONLINELOG/group_11.303.1126009761       52428800
         2         12 STANDBY +ARC/INVCDR/ONLINELOG/group_12.261.1126009763        52428800
         2         12 STANDBY +DATA/INVCDR/ONLINELOG/group_12.324.1126009763       52428800
         2         13 STANDBY +ARC/INVCDR/ONLINELOG/group_13.260.1126009763        52428800
         2         13 STANDBY +DATA/INVCDR/ONLINELOG/group_13.274.1126009763       52428800
         2         14 STANDBY +ARC/INVCDR/ONLINELOG/group_14.259.1126009765        52428800
         2         14 STANDBY +DATA/INVCDR/ONLINELOG/group_14.315.1126009763       52428800

SQL> SELECT * FROM v$logfile order by 1;

    GROUP# STATUS  TYPE    MEMBER                                             IS_     CON_ID
---------- ------- ------- -------------------------------------------------- --- ----------
         1         ONLINE  +DATA/INVCDR/ONLINELOG/group_1.278.1126009755      NO           0
         1         ONLINE  +ARC/INVCDR/ONLINELOG/group_1.394.1126009755       YES          0
         2         ONLINE  +ARC/INVCDR/ONLINELOG/group_2.395.1126009757       YES          0
         2         ONLINE  +DATA/INVCDR/ONLINELOG/group_2.284.1126009755      NO           0
         3         ONLINE  +ARC/INVCDR/ONLINELOG/group_3.393.1126009757       YES          0
         3         ONLINE  +DATA/INVCDR/ONLINELOG/group_3.309.1126009757      NO           0
         4         ONLINE  +ARC/INVCDR/ONLINELOG/group_4.392.1126009757       YES          0
         4         ONLINE  +DATA/INVCDR/ONLINELOG/group_4.327.1126009757      NO           0
         5         ONLINE  +DATA/INVCDR/ONLINELOG/group_5.312.1126009759      NO           0
         5         ONLINE  +ARC/INVCDR/ONLINELOG/group_5.344.1126009759       YES          0
         6         ONLINE  +DATA/INVCDR/ONLINELOG/group_6.308.1126009759      NO           0
         6         ONLINE  +ARC/INVCDR/ONLINELOG/group_6.343.1126009759       YES          0
         7         STANDBY +DATA/INVCDR/ONLINELOG/group_7.326.1126009759      NO           0
         7         STANDBY +ARC/INVCDR/ONLINELOG/group_7.342.1126009759       YES          0
         8         STANDBY +DATA/INVCDR/ONLINELOG/group_8.311.1126009759      NO           0
         8         STANDBY +ARC/INVCDR/ONLINELOG/group_8.341.1126009761       YES          0
         9         STANDBY +DATA/INVCDR/ONLINELOG/group_9.307.1126009761      NO           0
         9         STANDBY +ARC/INVCDR/ONLINELOG/group_9.340.1126009761       YES          0
        10         STANDBY +DATA/INVCDR/ONLINELOG/group_10.325.1126009761     NO           0
        10         STANDBY +ARC/INVCDR/ONLINELOG/group_10.339.1126009761      YES          0
        11         STANDBY +ARC/INVCDR/ONLINELOG/group_11.262.1126009761      YES          0
        11         STANDBY +DATA/INVCDR/ONLINELOG/group_11.303.1126009761     NO           0
        12         STANDBY +ARC/INVCDR/ONLINELOG/group_12.261.1126009763      YES          0
        12         STANDBY +DATA/INVCDR/ONLINELOG/group_12.324.1126009763     NO           0
        13         STANDBY +ARC/INVCDR/ONLINELOG/group_13.260.1126009763      YES          0
        13         STANDBY +DATA/INVCDR/ONLINELOG/group_13.274.1126009763     NO           0
        14         STANDBY +DATA/INVCDR/ONLINELOG/group_14.315.1126009763     NO           0
        14         STANDBY +ARC/INVCDR/ONLINELOG/group_14.259.1126009765      YES          0

-- Run the below query in both the nodes of primary to find the newly added standby redlog files:
set lines 999 pages 999
col inst_id for 9999
col group# for 9999
col member for a60
col archived for a7

SELECT
     a.* 
FROM (SELECT
           '[ ONLINE REDO LOG ]'  redolog_file_type,
            a.inst_id  inst_id,
            a.group#,
            b.thread#,
            b.sequence#,
            a.member,
            b.status,
            b.archived,
            (b.BYTES/1024/1024) AS size_mb
      FROM gv$logfile a, gv$log b
      WHERE a.group#=b.group#
      and a.inst_id=b.inst_id
      and b.thread#=(SELECT value FROM v$parameter WHERE name = 'thread')
      and a.inst_id=( SELECT instance_number FROM v$instance)
      UNION
      SELECT
           '[ STANDBY REDO LOG ]' redolog_file_type,
           a.inst_id,
           a.group#,
           b.thread#,
           b.sequence#,
           a.member,
           b.status,
           b.archived,
           (b.bytes/1024/1024) size_mb
      FROM gv$logfile a, gv$standby_log b
      WHERE a.group#=b.group#
      and a.inst_id=b.inst_id
      and b.thread#=(SELECT value FROM v$parameter WHERE name = 'thread')
      and a.inst_id=( SELECT instance_number FROM v$instance)
    ) a
ORDER BY 2,3;

--At Node 1 (invoice1)
REDOLOG_FILE_TYPE    INST_ID GROUP#    THREAD#  SEQUENCE# MEMBER                                                       STATUS           ARCHIVE    SIZE_MB
-------------------- ------- ------ ---------- ---------- ------------------------------------------------------------ ---------------- ------- ----------
[ ONLINE REDO LOG ]        1      1          1          0 +ARC/INVCDR/ONLINELOG/group_1.394.1126009755                 CURRENT          NO              50
[ ONLINE REDO LOG ]        1      1          1          0 +DATA/INVCDR/ONLINELOG/group_1.278.1126009755                CURRENT          NO              50
[ ONLINE REDO LOG ]        1      2          1          0 +ARC/INVCDR/ONLINELOG/group_2.395.1126009757                 UNUSED           YES             50
[ ONLINE REDO LOG ]        1      2          1          0 +DATA/INVCDR/ONLINELOG/group_2.284.1126009755                UNUSED           YES             50
[ ONLINE REDO LOG ]        1      5          1          0 +ARC/INVCDR/ONLINELOG/group_5.344.1126009759                 UNUSED           YES             50
[ ONLINE REDO LOG ]        1      5          1          0 +DATA/INVCDR/ONLINELOG/group_5.312.1126009759                UNUSED           YES             50
[ STANDBY REDO LOG ]       1      7          1       1486 +ARC/INVCDR/ONLINELOG/group_7.342.1126009759                 ACTIVE           YES             50
[ STANDBY REDO LOG ]       1      7          1       1486 +DATA/INVCDR/ONLINELOG/group_7.326.1126009759                ACTIVE           YES             50
[ STANDBY REDO LOG ]       1      8          1          0 +ARC/INVCDR/ONLINELOG/group_8.341.1126009761                 UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      8          1          0 +DATA/INVCDR/ONLINELOG/group_8.311.1126009759                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      9          1          0 +ARC/INVCDR/ONLINELOG/group_9.340.1126009761                 UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      9          1          0 +DATA/INVCDR/ONLINELOG/group_9.307.1126009761                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1     10          1          0 +ARC/INVCDR/ONLINELOG/group_10.339.1126009761                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1     10          1          0 +DATA/INVCDR/ONLINELOG/group_10.325.1126009761               UNASSIGNED       YES             50

SQL> CREATE SPFILE = '+DATA' FROM PFILE = '/opt/app/oracle/product/19c/db_1/dbs/initinvcdr1.ora';

--SQL> CREATE SPFILE = '+DATA' FROM PFILE ='+DATA'


SQL> shut immediate
ORA-01109: database not open


Database dismounted.
ORACLE instance shut down.
SQL> exit

Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 160 -->> On Node 1 - DR
[oracle@invcdr1 ~]$ cd $ORACLE_HOME/dbs

-- Step 160.1 -->> On Node 1 - DR
[oracle@invcdr1 dbs]$ pwd
/*
/opt/app/oracle/product/19c/db_1/dbs
*/

-- Step 160.2 -->> On Node 1 - DR
[oracle@invcdr1 dbs]$ ll -ltrh initinvcdr1.ora
/*
-rw-r--r-- 1 oracle oinstall 1.5K Jan 13 10:54 initinvcdr1.ora
*/

-- Step 160.2 -->> On Node 1 - DR
[oracle@invcdr1 dbs]$ mv initinvcdr1.ora initinvcdr1.ora.backup
--[oracle@invcdr1 dbs]$  mv spfileinvcdr1.ora spfileinvcdr1.ora.backup

-- Step 161 -->> On Node 2 - DR
[grid@invcdr2 ~]$ asmcmd
/*
ASMCMD> cd +DATA/INVCDR/PARAMETERFILE/
ASMCMD> ls
--spfile.313.1126019717 <= CREATE SPFILE = '+DATA' FROM PFILE ='+DATA'
spfile.331.1126018985 <= CREATE SPFILE = '+DATA' FROM PFILE = '/opt/app/oracle/product/19c/db_1/dbs/initinvcdr1.ora';
ASMCMD> exit
*/

-- Step 162 -->> On Node 1 - DR
[oracle@invcdr1 ~]$ cd $ORACLE_HOME/dbs

-- Step 162.1 -->> On Node 1 - DR
[oracle@invcdr1 dbs]$ pwd
/*
/opt/app/oracle/product/19c/db_1/dbs
*/

-- Step 162.2 -->> On Node 1 - DR
[oracle@invcdr1 dbs]$ echo "SPFILE='+DATA/INVCDR/PARAMETERFILE/spfile.313.1126019717'" > initinvcdr1.ora

-- Step 162.3 -->> On Node 1 - DR
[oracle@invcdr1 dbs]$ ll -ltrh initinvcdr1.ora
/*
-rw-r--r-- 1 oracle oinstall 53 Jan 13 12:55 initinvcdr1.ora
*/

-- Step 162.4 -->> On Node 1 - DR
[oracle@invcdr1 dbs]$ cat initinvcdr1.ora
/*
SPFILE='+DATA/INVCDR/PARAMETERFILE/spfile.313.1126019717'
*/

-- Step 162.5 -->> On Node 1 - DR
[oracle@invcdr1 dbs]$ scp -r initinvcdr1.ora oracle@invcdr2:/opt/app/oracle/product/19c/db_1/dbs/initinvcdr2.ora
/*
initinvcdr2.ora                                                             100%   53    93.5KB/s   00:00
*/

-- Step 162.6 -->> On Node 1 - DR
[oracle@invcdr1 dbs]$ ssh invcdr2

-- Step 162.7 -->> On Node 2 - DR
[oracle@invcdr2 ~]$ cat /opt/app/oracle/product/19c/db_1/dbs/initinvcdr2.ora
/*
SPFILE='+DATA/INVCDR/PARAMETERFILE/spfile.313.1126019717'
*/

-- Step 162.8 -->> On Node 1 - DR
[oracle@invcdr1 dbs]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri Jan 13 13:00:24 2023
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> startup mount
ORACLE instance started.

Total System Global Area 6442448976 bytes
Fixed Size                  9152592 bytes
Variable Size            1140850688 bytes
Database Buffers         5284823040 bytes
Redo Buffers                7622656 bytes
Database mounted.

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       MOUNTED
         3 INVPDB                         MOUNTED

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL>  SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 INVOICED  invcdr1          MOUNTED      13-JAN-23 invcdr1.unidev.com      MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED

SQL> show parameter spfile

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------------------------
spfile                               string      +DATA/INVCDR/PARAMETERFILE/spfile.313.1126019717

SQL> alter system set undo_tablespace=UNDOTBS2 sid='invcdr2' scope=spfile;
SQL> alter system set instance_number=1 sid='invcdr1' scope=spfile;
SQL> alter system set instance_number=2 sid='invcdr2' scope=spfile;
SQL> alter system set instance_name='invcdr1' sid='invcdr1' scope=spfile;
SQL> alter system set instance_name='invcdr2' sid='invcdr2' scope=spfile;
SQL> alter system set thread=1 sid='invcdr1' scope=spfile;
SQL> alter system set thread=2 sid='invcdr2' scope=spfile;
SQL> alter system set cluster_database=TRUE  scope=spfile;
SQL> alter system set remote_listener='invcdr-scan:1521' scope=spfile sid='*';
SQL> alter system set log_archive_dest_state_2=ENABLE scope=both sid='*';

SQL> shut immediate
ORA-01109: database not open


Database dismounted.
ORACLE instance shut down.

SQL> startup mount
ORACLE instance started.

Total System Global Area 6442448976 bytes
Fixed Size                  9152592 bytes
Variable Size            1140850688 bytes
Database Buffers         5284823040 bytes
Redo Buffers                7622656 bytes
Database mounted.

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode,a.cdb FROM gv$database a,v$instance b;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE  CDB
---------- ------------ ---------------- ---------------- ---------- ---
         1 MOUNTED      invcdr1          PHYSICAL STANDBY MOUNTED    YES

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       MOUNTED
         3 INVPDB                         MOUNTED

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 INVOICED  invcdr1          MOUNTED      13-JAN-23 invcdr1.unidev.com      MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED

--> SQL> show spparameter undo_tablespace
--> 
--> SID      NAME                          TYPE        VALUE
--> -------- ----------------------------- ----------- ----------------------------
--> *        undo_tablespace               string      UNDOTBS1
--> invcdr2  undo_tablespace               string      UNDOTBS2
--> 
--> alter system reset undo_tablespace sid='*' scope=spfile;
--> alter system set undo_tablespace=UNDOTBS1 sid='invcdr1' scope=spfile;

SQL> show spparameter undo_tablespace

SID      NAME                          TYPE        VALUE
-------- ----------------------------- ----------- ----------------------------
invcdr1  undo_tablespace               string      UNDOTBS1
invcdr2  undo_tablespace               string      UNDOTBS2

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
[oracle@invcdr1 admin]$
*/

-- Step 163 -->> On Node 1 - DR
[oracle@invcdr1 ~]$ which srvctl
/*
/opt/app/oracle/product/19c/db_1/bin/srvctl
*/

-- Step 163.1 -->> On Node 1 - DR
[oracle@invcdr1 ~]$ srvctl add database -d invcdr -o /opt/app/oracle/product/19c/db_1 -r physical_standby -s mount
[oracle@invcdr1 ~]$ srvctl modify database -d invcdr -spfile +DATA/INVCDR/PARAMETERFILE/spfile.313.1126019717
[oracle@invcdr1 ~]$ srvctl modify database -d invcdr -diskgroup "DATA,ARC"
[oracle@invcdr1 ~]$ srvctl add instance -d invcdr -i invcdr1 -n invcdr1
[oracle@invcdr1 ~]$ srvctl add instance -d invcdr -i invcdr2 -n invcdr2

-- Step 163.2 -->> On Node 1 - DR
[oracle@invcdr1 ~]$ srvctl config database -d invcdr 
/*
Database unique name: invcdr
Database name:
Oracle home: /opt/app/oracle/product/19c/db_1
Oracle user: oracle
Spfile: +DATA/INVCDR/PARAMETERFILE/spfile.313.1126019717
Password file:
Domain:
Start options: mount
Stop options: immediate
Database role: PHYSICAL_STANDBY
Management policy: AUTOMATIC
Server pools:
Disk Groups: DATA,ARC
Mount point paths:
Services:
Type: RAC
Start concurrency:
Stop concurrency:
OSDBA group: dba
OSOPER group: oper
Database instances: invcdr1,invcdr2
Configured nodes: invcdr1,invcdr2
CSS critical: no
CPU count: 0
Memory target: 0
Maximum memory: 0
Default network number for database services:
Database is administrator managed
*/

-- Step 164 -->> On Node 1 - DR
[oracle@invcdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri Jan 13 16:07:00 2023
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> shut immediate
ORA-01109: database not open

Database dismounted.
ORACLE instance shut down.

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 165 -->> On Node 1 - DR
[oracle@invcdr1 ~]$ srvctl start database -d invcdr -o mount
[oracle@invcdr1 ~]$ srvctl status database -d invcdr
/*
Instance invcdr1 is running on node invcdr1
Instance invcdr2 is running on node invcdr2
*/

-- Step 165.1 -->> On Node 1 - DR
[oracle@invcdr1 ~]$ srvctl status database -d invcdr -v
/*
Instance invcdr1 is running on node invcdr1. Instance status: Mounted (Closed).
Instance invcdr2 is running on node invcdr2. Instance status: Mounted (Closed).
*/

-- Step 166 -->> On Node 1 - DR
[oracle@invcdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri Jan 13 13:02:07 2023
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       MOUNTED
         3 INVPDB                         MOUNTED

SQL> select status,instance_name from gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
MOUNTED      invcdr1
MOUNTED      invcdr2

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 INVOICED  invcdr1          MOUNTED      13-JAN-23 invcdr1.unidev.com      MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED
         2 INVOICED  invcdr2          MOUNTED      13-JAN-23 invcdr2.unidev.com      MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 167 -->> On Node 1 - DR
[root@invcdr1/invcdr2 ~]# cd /opt/app/19c/grid/bin/

-- Step 167.1 -->> On Node 1 - DR
[root@invcdr1/invcdr2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       invcdr1                  STABLE
               ONLINE  ONLINE       invcdr2                  STABLE
ora.chad
               ONLINE  ONLINE       invcdr1                  STABLE
               ONLINE  ONLINE       invcdr2                  STABLE
ora.net1.network
               ONLINE  ONLINE       invcdr1                  STABLE
               ONLINE  ONLINE       invcdr2                  STABLE
ora.ons
               ONLINE  ONLINE       invcdr1                  STABLE
               ONLINE  ONLINE       invcdr2                  STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ARC.dg(ora.asmgroup)
      1        ONLINE  ONLINE       invcdr1                  STABLE
      2        ONLINE  ONLINE       invcdr2                  STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       invcdr1                  STABLE
      2        ONLINE  ONLINE       invcdr2                  STABLE
      3        ONLINE  OFFLINE                               STABLE
ora.DATA.dg(ora.asmgroup)
      1        ONLINE  ONLINE       invcdr1                  STABLE
      2        ONLINE  ONLINE       invcdr2                  STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       invcdr2                  STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       invcdr1                  STABLE
      2        ONLINE  ONLINE       invcdr2                  STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       invcdr1                  Started,STABLE
      2        ONLINE  ONLINE       invcdr2                  Started,STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       invcdr1                  STABLE
      2        ONLINE  ONLINE       invcdr2                  STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.cvu
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.invcdr.db
      1        ONLINE  INTERMEDIATE invcdr1                  Mounted (Closed),HOME=/opt/app/oracle/product/19c/db_1,STABLE
      2        ONLINE  INTERMEDIATE invcdr2                  Mounted (Closed),HOME=/opt/app/oracle/product/19c/db_1,STABLE
ora.invcdr1.vip
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.invcdr2.vip
      1        ONLINE  ONLINE       invcdr2                  STABLE
ora.qosmserver
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       invcdr2                  STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       invcdr1                  STABLE
ora.scan3.vip
      1        ONLINE  ONLINE       invcdr1                  STABLE
--------------------------------------------------------------------------------
*/

-- Step 168 -->> On Node 1 - DC
[oracle@invoice1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri Jan 13 16:27:03 2023
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 INVPDB                         READ WRITE NO
SQL>
SQL> select status,instance_name from gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
OPEN         invoiced1
OPEN         invoiced2

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 INVOICED  invoiced1        OPEN         13-JAN-23 invoice1.unidev.com     READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  TO STANDBY
         2 INVOICED  invoiced2        OPEN         13-JAN-23 invoice2.unidev.com     READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  TO STANDBY

SQL> alter system archive log current;

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
          1488          1
           681          2

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 169 -->> On Node 1 - DR
[oracle@invcdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri Jan 13 13:02:07 2023
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       MOUNTED
         3 INVPDB                         MOUNTED

SQL> select status,instance_name from gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
MOUNTED      invcdr1
MOUNTED      invcdr2

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 INVOICED  invcdr1          MOUNTED      13-JAN-23 invcdr1.unidev.com      MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED
         2 INVOICED  invcdr2          MOUNTED      13-JAN-23 invcdr2.unidev.com      MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;
--SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION INSTANCES ALL;

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
          1488          1
           681          2

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
          1488          1
           681          2

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 170 -->> On Node 1 - DR
[grid@invcdr1 ~]$ asmcmd -p
/*
ASMCMD [+] > ls
ARC/
DATA/
OCR/
ASMCMD [+] > cd +DATA/INVCDR
ASMCMD [+DATA/INVCDR] > mkdir PASSWORDFILE
ASMCMD [+DATA/INVCDR] > cd PASSWORDFILE
ASMCMD [+DATA/INVCDR/PASSWORDFILE] > pwd
+DATA/INVCDR/PASSWORDFILE

ASMCMD [+DATA/INVCDR/PASSWORDFILE] > pwcopy /opt/app/oracle/product/19c/db_1/dbs/orapwinvcdr1 +DATA/INVCDR/PASSWORDFILE/orapwinvcdr
copying /opt/app/oracle/product/19c/db_1/dbs/orapwinvcdr1 -> +DATA/INVCDR/PASSWORDFILE/orapwinvcdr

ASMCMD [+DATA/INVCDR/PASSWORDFILE] > ls -l
Type      Redund  Striped  Time             Sys  Name
PASSWORD  UNPROT  COARSE   JAN 13 16:00:00  N    orapwinvcdr => +DATA/DB_UNKNOWN/PASSWORD/pwddb_unknown.314.1126024719

ASMCMD [+DATA/INVCDR/PASSWORDFILE] > exit
*/

-- Step 171 -->> On Node 1 - DR
[oracle@invcdr1 ~]$ srvctl modify database -d invcdr -pwfile +DATA/INVCDR/PASSWORDFILE/orapwinvcdr

-- Step 171.1 -->> On Node 1 - DR
[oracle@invcdr1 ~]$ srvctl config database -d invcdr
/*
Database unique name: invcdr
Database name:
Oracle home: /opt/app/oracle/product/19c/db_1
Oracle user: oracle
Spfile: +DATA/INVCDR/PARAMETERFILE/spfile.313.1126019717
Password file: +DATA/INVCDR/PASSWORDFILE/orapwinvcdr
Domain:
Start options: mount
Stop options: immediate
Database role: PHYSICAL_STANDBY
Management policy: AUTOMATIC
Server pools:
Disk Groups: DATA,ARC
Mount point paths:
Services:
Type: RAC
Start concurrency:
Stop concurrency:
OSDBA group: dba
OSOPER group: oper
Database instances: invcdr1,invcdr2
Configured nodes: invcdr1,invcdr2
CSS critical: no
CPU count: 0
Memory target: 0
Maximum memory: 0
Default network number for database services:
Database is administrator managed
*/

-- Step 172 -->> On Node 1 - DR
[oracle@invcdr1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 172.1 -->> On Node 1 - DR
[oracle@invcdr1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 172.2 -->> On Node 1 - DR
[oracle@invcdr1 admin]$ vi tnsnames.ora
/*
# tnsnames.ora Network Configuration File: /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.

INVOICEDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invoice-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invoicedb)
    )
  )

INVCDR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invcdr-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invcdr)
    )
  )
*/

-- Step 173 -->> On Node 2 - DR
[oracle@invcdr2 ~]$ cd $ORACLE_HOME/network/admin

-- Step 173.1 -->> On Node 1 - DR
[oracle@invcdr2 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 173.2 -->> On Node 1 - DR
[oracle@invcdr2 admin]$ vi tnsnames.ora
/*
# tnsnames.ora Network Configuration File: /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.

INVOICEDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invoice-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invoicedb)
    )
  )

INVCDR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invcdr-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invcdr)
    )
  )
*/

-- Step 174 -->> On Node 1 - DC
[oracle@invoice1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 174.1 -->> On Node 1 - DC
[oracle@invoice1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 174.2 -->> On Node 1 - DC
[oracle@invoice1 admin]$ vi tnsnames.ora
/*
# tnsnames.ora Network Configuration File: /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.

INVOICEDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invoice-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invoicedb)
    )
  )

INVOICED1 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.1.1.40)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invoicedb)
    )
  )

INVPDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invoice-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invpdb)
    )
  )

INVCDR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invcdr-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invcdr)
    )
  )
*/


-- Step 175 -->> On Node 2 - DC
[oracle@invoice2 ~]$ cd $ORACLE_HOME/network/admin

-- Step 175.1 -->> On Node 2 - DC
[oracle@invoice2 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 175.2 -->> On Node 2 - DC
[oracle@invoice2 admin]$ vi tnsnames.ora
/*
# tnsnames.ora Network Configuration File: /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.

INVOICEDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invoice-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invoicedb)
    )
  )

INVOICED2 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.1.1.41)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invoicedb)
    )
  )

INVPDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invoice-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invpdb)
    )
  )

INVCDR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invcdr-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invcdr)
    )
  )
*/

-- Step 176 -->> On Node 1 - DC
[oracle@invcdr1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 176.1 -->> On Node 1 - DC
[oracle@invoice1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 176.2 -->> On Node 1 - DC
[oracle@invcdr1 admin]$ ll | grep listener.ora
/*
-rw-r--r-- 1 oracle oinstall  315 Jan 13 11:41 listener.ora
*/

-- Step 176.3 -->> On Node 1 - DC
[oracle@invcdr1 admin]$ ps -ef | grep tns
/*
root       106     2  0 Jan08 ?        00:00:00 [netns]
grid     23098     1  0 Jan10 ?        00:00:11 /opt/app/19c/grid/bin/tnslsnr LISTENER -inherit
oracle   27761     1  0 11:43 ?        00:00:01 /opt/app/oracle/product/19c/db_1/bin/tnslsnr listener1 -inherit
oracle   29878 19087  0 16:54 pts/0    00:00:00 grep --color=auto tns
grid     31830     1  0 Jan08 ?        00:03:38 /opt/app/19c/grid/bin/tnslsnr ASMNET1LSNR_ASM -no_crs_notify -inherit
grid     32145     1  0 Jan08 ?        00:00:19 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid     32161     1  0 Jan08 ?        00:00:19 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
*/

-- Step 176.4 -->> On Node 1 - DC
[oracle@invcdr1 admin]$ lsnrctl status listener1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 13-JAN-2023 16:56:03

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=invcdr1.unidev.com)(PORT=1541)))
STATUS of the LISTENER
------------------------
Alias                     listener1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                13-JAN-2023 11:43:20
Uptime                    0 days 5 hr. 12 min. 43 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/oracle/product/19c/db_1/network/admin/listener.ora
Listener Log File         /opt/app/oracle/product/19c/db_1/network/log/listener1.log
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=invcdr1.unidev.com)(PORT=1541)))
Services Summary...
Service "invcdr" has 1 instance(s).
  Instance "invcdr1", status UNKNOWN, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 176.5 -->> On Node 1 - DC
[oracle@invcdr1 admin]$ lsnrctl stop listener1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 13-JAN-2023 16:56:11

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=invcdr1.unidev.com)(PORT=1541)))
The command completed successfully
*/

-- Step 176.6 -->> On Node 1 - DC
[oracle@invcdr1 admin]$ lsnrctl status listener1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 13-JAN-2023 16:56:13

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=invcdr1.unidev.com)(PORT=1541)))
TNS-12541: TNS:no listener
 TNS-12560: TNS:protocol adapter error
  TNS-00511: No listener
   Linux Error: 111: Connection refused
*/

-- Step 176.7 -->> On Node 1 - DC
[oracle@invcdr1 admin]$ ps -ef | grep tns
/*
root       106     2  0 Jan08 ?        00:00:00 [netns]
grid     23098     1  0 Jan10 ?        00:00:11 /opt/app/19c/grid/bin/tnslsnr LISTENER -inherit
grid     31830     1  0 Jan08 ?        00:03:38 /opt/app/19c/grid/bin/tnslsnr ASMNET1LSNR_ASM -no_crs_notify -inherit
grid     32145     1  0 Jan08 ?        00:00:19 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid     32161     1  0 Jan08 ?        00:00:19 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
oracle   32653 19087  0 16:57 pts/0    00:00:00 grep --color=auto tns
*/


-- Step 177 -->> On Node 1 - DC
[oracle@invoice1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri Jan 13 16:27:03 2023
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 INVPDB                         READ WRITE NO

SQL> select status,instance_name from gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
OPEN         invoiced1
OPEN         invoiced2

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 INVOICED  invoiced1        OPEN         13-JAN-23 invoice1.unidev.com     READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  TO STANDBY
         2 INVOICED  invoiced2        OPEN         13-JAN-23 invoice2.unidev.com     READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  TO STANDBY

SQL> alter system archive log current;

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
          1491          1
           684          2

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 178 -->> On Node 1 - DR
[oracle@invcdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri Jan 13 13:02:07 2023
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       MOUNTED
         3 INVPDB                         MOUNTED

SQL> select status,instance_name from gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
MOUNTED      invcdr1
MOUNTED      invcdr2

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 INVOICED  invcdr1          MOUNTED      13-JAN-23 invcdr1.unidev.com      MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED
         2 INVOICED  invcdr2          MOUNTED      13-JAN-23 invcdr2.unidev.com      MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
          1491          1
           684          2

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

Database altered.

--SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION INSTANCES all;

Database altered.

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
          1491          1
           684          2

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 INVOICED  invcdr1          MOUNTED      16-JAN-23 invcdr1.unidev.com      MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED
         2 INVOICED  invcdr2          MOUNTED      16-JAN-23 invcdr2.unidev.com      MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 179 -->> On Node 1 - DC
[grid@invoice1 ~]$ ps -ef | grep SCAN
/*
grid     15565 15210  0 17:18 pts/0    00:00:00 grep --color=auto SCAN
grid     30301     1  0 09:36 ?        00:00:01 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid     30304     1  0 09:36 ?        00:00:01 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
*/

-- Step 179.1 -->> On Node 1 - DC
[grid@invoice1 ~]$  lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 13-JAN-2023 17:18:49

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                13-JAN-2023 09:36:20
Uptime                    0 days 7 hr. 42 min. 29 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/invoice1/listener_scan3/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN3)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.1.1.46)(PORT=1521)))
Services Summary...
Service "86b637b62fdf7a65e053f706e80a27ca" has 2 instance(s).
  Instance "invoiced1", status READY, has 1 handler(s) for this service...
  Instance "invoiced2", status READY, has 1 handler(s) for this service...
Service "ece0ff8781ac5725e053290610ac0d82" has 2 instance(s).
  Instance "invoiced1", status READY, has 1 handler(s) for this service...
  Instance "invoiced2", status READY, has 1 handler(s) for this service...
Service "invoicedXDB" has 2 instance(s).
  Instance "invoiced1", status READY, has 1 handler(s) for this service...
  Instance "invoiced2", status READY, has 1 handler(s) for this service...
Service "invoicedb" has 2 instance(s).
  Instance "invoiced1", status READY, has 1 handler(s) for this service...
  Instance "invoiced2", status READY, has 1 handler(s) for this service...
Service "invpdb" has 2 instance(s).
  Instance "invoiced1", status READY, has 1 handler(s) for this service...
  Instance "invoiced2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 179.2 -->> On Node 1 - DC
[grid@invoice1 ~]$  lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 13-JAN-2023 17:18:52

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                13-JAN-2023 09:36:20
Uptime                    0 days 7 hr. 42 min. 33 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/invoice1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.1.1.45)(PORT=1521)))
Services Summary...
Service "86b637b62fdf7a65e053f706e80a27ca" has 2 instance(s).
  Instance "invoiced1", status READY, has 1 handler(s) for this service...
  Instance "invoiced2", status READY, has 1 handler(s) for this service...
Service "ece0ff8781ac5725e053290610ac0d82" has 2 instance(s).
  Instance "invoiced1", status READY, has 1 handler(s) for this service...
  Instance "invoiced2", status READY, has 1 handler(s) for this service...
Service "invoicedXDB" has 2 instance(s).
  Instance "invoiced1", status READY, has 1 handler(s) for this service...
  Instance "invoiced2", status READY, has 1 handler(s) for this service...
Service "invoicedb" has 2 instance(s).
  Instance "invoiced1", status READY, has 1 handler(s) for this service...
  Instance "invoiced2", status READY, has 1 handler(s) for this service...
Service "invpdb" has 2 instance(s).
  Instance "invoiced1", status READY, has 1 handler(s) for this service...
  Instance "invoiced2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 179.3 -->> On Node 2 - DC
[grid@invoice2 ~]$ ps -ef | grep SCAN
/*
grid      6090     1  0 09:37 ?        00:00:01 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid     24677 24585  0 17:22 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 179.4 -->> On Node 2 - DC
[grid@invoice2 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 13-JAN-2023 17:22:48

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                13-JAN-2023 09:37:54
Uptime                    0 days 7 hr. 44 min. 54 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/invoice2/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.1.1.44)(PORT=1521)))
Services Summary...
Service "86b637b62fdf7a65e053f706e80a27ca" has 2 instance(s).
  Instance "invoiced1", status READY, has 1 handler(s) for this service...
  Instance "invoiced2", status READY, has 1 handler(s) for this service...
Service "ece0ff8781ac5725e053290610ac0d82" has 2 instance(s).
  Instance "invoiced1", status READY, has 1 handler(s) for this service...
  Instance "invoiced2", status READY, has 1 handler(s) for this service...
Service "invoicedXDB" has 2 instance(s).
  Instance "invoiced1", status READY, has 1 handler(s) for this service...
  Instance "invoiced2", status READY, has 1 handler(s) for this service...
Service "invoicedb" has 2 instance(s).
  Instance "invoiced1", status READY, has 1 handler(s) for this service...
  Instance "invoiced2", status READY, has 1 handler(s) for this service...
Service "invpdb" has 2 instance(s).
  Instance "invoiced1", status READY, has 1 handler(s) for this service...
  Instance "invoiced2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 180 -->> On Node 1 - DR
[grid@invcdr1 ~]$ ps -ef | grep SCAN
/*
grid     19603 19332  0 17:20 pts/0    00:00:00 grep --color=auto SCAN
grid     32145     1  0 Jan08 ?        00:00:19 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid     32161     1  0 Jan08 ?        00:00:19 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
*/

-- Step 180.1 -->> On Node 1 - DR
[grid@invcdr1 ~]$ lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 13-JAN-2023 17:20:59

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                08-JAN-2023 13:36:57
Uptime                    5 days 3 hr. 44 min. 2 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/invcdr1/listener_scan3/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN3)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.1.1.54)(PORT=1521)))
Services Summary...
Service "invcdr" has 2 instance(s).
  Instance "invcdr1", status READY, has 1 handler(s) for this service...
  Instance "invcdr2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 180.2 -->> On Node 1 - DR
[grid@invcdr1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 13-JAN-2023 17:21:06

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                08-JAN-2023 13:36:57
Uptime                    5 days 3 hr. 44 min. 8 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/invcdr1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.1.1.53)(PORT=1521)))
Services Summary...
Service "invcdr" has 2 instance(s).
  Instance "invcdr1", status READY, has 1 handler(s) for this service...
  Instance "invcdr2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 180.3 -->> On Node 2 - DR
[grid@invcdr2 ~]$ ps -ef | grep SCAN
/*
grid     10493 10326  0 17:23 pts/0    00:00:00 grep --color=auto SCAN
grid     31885     1  0 Jan08 ?        00:00:19 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
*/

-- Step 180.4 -->> On Node 2 - DR
[grid@invcdr2 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 13-JAN-2023 17:23:40

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                08-JAN-2023 13:37:12
Uptime                    5 days 3 hr. 46 min. 28 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/invcdr2/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.1.1.52)(PORT=1521)))
Services Summary...
Service "invcdr" has 2 instance(s).
  Instance "invcdr1", status READY, has 1 handler(s) for this service...
  Instance "invcdr2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 181 -->> On Both Node's - DC
[oracle@invoice1/invoice2 ~]$ rman target /
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Mon Jan 16 14:00:51 2023
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: INVOICED (DBID=3646030117)

RMAN> show all;

using target database control file instead of recovery catalog
RMAN configuration parameters for database with db_unique_name INVOICEDB are:
CONFIGURE RETENTION POLICY TO REDUNDANCY 1; # default
CONFIGURE BACKUP OPTIMIZATION OFF; # default
CONFIGURE DEFAULT DEVICE TYPE TO DISK; # default
CONFIGURE CONTROLFILE AUTOBACKUP ON;
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '%F'; # default
CONFIGURE DEVICE TYPE DISK PARALLELISM 4 BACKUP TYPE TO BACKUPSET;
CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE MAXSETSIZE TO UNLIMITED; # default
CONFIGURE ENCRYPTION FOR DATABASE OFF; # default
CONFIGURE ENCRYPTION ALGORITHM 'AES128'; # default
CONFIGURE COMPRESSION ALGORITHM 'BASIC' AS OF RELEASE 'DEFAULT' OPTIMIZE FOR LOAD TRUE ; # default
CONFIGURE RMAN OUTPUT TO KEEP FOR 7 DAYS; # default
CONFIGURE ARCHIVELOG DELETION POLICY TO APPLIED ON ALL STANDBY;
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/product/19c/db_1/dbs/snapcf_invoiced1.f'; # default

RMAN> exit

Recovery Manager complete.
*/

-- Step 182 -->> On Both Node's - DR
[oracle@invcdr1/invcdr2 ~]$ rman target /
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Mon Jan 16 14:04:06 2023
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: INVOICED (DBID=3646030117, not open)

RMAN> show all;

using target database control file instead of recovery catalog
RMAN configuration parameters for database with db_unique_name INVCDR are:
CONFIGURE RETENTION POLICY TO REDUNDANCY 1; # default
CONFIGURE BACKUP OPTIMIZATION OFF; # default
CONFIGURE DEFAULT DEVICE TYPE TO DISK; # default
CONFIGURE CONTROLFILE AUTOBACKUP ON;
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '%F'; # default
CONFIGURE DEVICE TYPE DISK PARALLELISM 4 BACKUP TYPE TO BACKUPSET;
CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE MAXSETSIZE TO UNLIMITED; # default
CONFIGURE ENCRYPTION FOR DATABASE OFF; # default
CONFIGURE ENCRYPTION ALGORITHM 'AES128'; # default
CONFIGURE COMPRESSION ALGORITHM 'BASIC' AS OF RELEASE 'DEFAULT' OPTIMIZE FOR LOAD TRUE ; # default
CONFIGURE RMAN OUTPUT TO KEEP FOR 7 DAYS; # default
CONFIGURE ARCHIVELOG DELETION POLICY TO APPLIED ON ALL STANDBY;
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/product/19c/db_1/dbs/snapcf_invcdr1.f'; # default

RMAN> exit

Recovery Manager complete.
*/

-- Step 183 -->> On Both Node's - DR
[oracle@invcdr1/invcdr2 ~]$ cd $ORACLE_HOME/network/admin

-- Step 183.1 -->> On Both Node's - DR
[oracle@invcdr1/invcdr2 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 183.2 -->> On Both Node's - DR
[oracle@invcdr1/invcdr2 admin]$ vi tnsnames.ora
/*
# tnsnames.ora Network Configuration File: /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.

INVOICEDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invoice-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invoicedb)
    )
  )

INVCDR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invcdr-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invcdr)
    )
  )

INVPDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = invcdr-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invpdb)
    )
  )
*/

-- Step 184 -->> On Node 1 - DR
[oracle@invcdr1 ~]$ vi /home/oracle/backup/script/invcdr_archivedelete.sh
/*

##SOS to script deletes the applied archivelog file in standby database##

export ORACLE_HOME="/opt/app/oracle/product/19c/db_1"
export ORACLE_SID="invcdr1"
export ORACLE_HOME ORACLE_SID
PATH=$ORACLE_HOME/bin:$PATH

PRE="set pagesize 0 \n set feedback off \n";
SS="$ORACLE_HOME/bin/sqlplus -L -S / as sysdba"
ROLE=$(echo -e "$PRE select database_role from v\$database;" | $SS)
[[ "$ROLE" != "PHYSICAL STANDBY" ]] && { echo "ERROR: database not a physical not standby"; exit 1; }
THREADS=$(echo -e "$PRE select distinct thread# from v\$archived_log;" | $SS)
for THREAD in $THREADS; do
  MAX_APPLIED=$(echo -e "$PRE select max(sequence#) from v\$archived_log where applied='YES' and thread#=$THREAD;" | $SS)
  echo "delete noprompt archivelog until sequence $MAX_APPLIED thread $THREAD;"|rman target /
done

##EOS to script deletes the applied archivelog file in standby database##

*/

----------------------------------------------------------------
--------------Two Nodes DR Drill Senty Testing------------------
----------------------------------------------------------------
Snapshot Standby
Snapshot standby allows the standby database to be opened in read-write mode. 
When switched back into standby mode, all changes made whilst in read-write mode are lost. 
This is achieved using flashback database, but the standby database does not need to have flashback database
explicitly enabled to take advantage of this feature, thought it works just the same if it is.

Note: If you are using RAC-DC/DR, then turn off all RAC-DR db instance but one of the RAC-DR db instances should be UP and running in MOUNT mode.

-- Step 1.1
-- Verify the DB instance status of Primary Database -> DC
[oracle@invoice1 ~]$ srvctl status database -d invoicedb -v
/*
Instance invoiced1 is running on node invoice1. Instance status: Open.
Instance invoiced2 is running on node invoice2. Instance status: Open.
*/

-- Step 1.2
-- Verify the DB instance status of Primary Database -> DC
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
------- ------------ ---------------- ---------------- --------------------
      1 OPEN         invoiced1        PRIMARY          READ WRITE
      2 OPEN         invoiced2        PRIMARY          READ WRITE
*/

-- Step 1.3
-- Verify the PDB's instance status of Primary Database -> DC
SQL> show pdbs
/*
    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 INVPDB                         READ WRITE NO
*/

-- Step 1.4
-- Connect with any user of Primary Database -> DC
SQL> conn hr/oracle@invpdb
/*
Connected.
*/

-- Step 1.5
-- Create a object with relevant user of Primary Database -> DC
SQL> CREATE TABLE hr.snapshot_standby_test AS
SELECT
     LEVEL sn
FROM dual
CONNECT BY LEVEL <=10;
/*
Table created.
*/

-- Step 1.6
-- Verify the Create a object of Primary Database -> DC
SQL> SELECT * FROM  hr.snapshot_standby_test;
/*
        SN
----------
         1
         2
         3
         4
         5
         6
         7
         8
         9
        10

10 rows selected.
*/

-- Step 1.6
-- Connect with sys user of Primary Database -> DC
SQL> conn sys/P#ssw0rd@invoicedb as sysdba
/*
Connected.
*/

-- Step 1.6
-- Verify the connection of Primary Database -> DC
SQL> show con_name
/*
CON_NAME
------------------------------
CDB$ROOT
*/

-- Step 1.6
-- Verify the currect archive of Primary Database -> DC
SQL> alter system switch logfile;
/*
System altered.
*/

-- Step 1.6
-- Verify the currect archive of Primary Database -> DC
SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;
/*
MAX(SEQUENCE#)    THREAD#
-------------- ----------
          1575          1
           796          2
*/

-- Step 2.1
-- Verify the DB instance status of Secondary Database -> DR
[oracle@invcdr1 ~]$ srvctl status database -d invcdr -v
/*
Instance invcdr1 is running on node invcdr1. Instance status: Mounted (Closed).
Instance invcdr2 is running on node invcdr2. Instance status: Mounted (Closed).
*/

-- Step 2.2
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
------- ------------ ---------------- ---------------- --------------------
      1 MOUNTED      invcdr1          PHYSICAL STANDBY MOUNTED
      2 MOUNTED      invcdr2          PHYSICAL STANDBY MOUNTED
*/

-- Step 2.3
-- Verify the DB instance status of Secondary Database -> DR
SQL> show pdbs
/*
    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       MOUNTED
         3 INVPDB                         MOUNTED
*/

-- Step 2.4
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;
/*
MAX(SEQUENCE#)    THREAD#
-------------- ----------
          1575          1
           796          2
*/

-- Step 2.5
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT inst_id,status,instance_name FROM gv$instance;
/*
   INST_ID STATUS       INSTANCE_NAME
---------- ------------ ----------------
         1 MOUNTED      invcdr1
         2 MOUNTED      invcdr2
*/

-- Step 2.6
-- Make sure the db_recovery_file_dest_size and location is set properly -> DR
-- Note The oracle parameter "db_recovery_file_dest_size" should be greater than 5GB -> DR.
SQL> show parameters db_recovery_file_dest 
/*
NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_recovery_file_dest                string      +ARC
db_recovery_file_dest_size           big integer 50G
*/

-- Step 2.7
-- Verify the restore point -> DR
SQL> SELECT inst_id,flashback_on FROM gv$database;
/*
INST_ID FLASHBACK_ON
------- ------------
      1 NO
      2 NO
*/

-- Step 2.8
-- Cancel the managed standby recovery process -> DR
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
/*
Database altered.
*/

-- Step 3
-- To stop the DB services and status Secondary Database -> DR
[oracle@invcdr1 ~]$ srvctl stop database -d invcdr
[oracle@invcdr1 ~]$ srvctl status database -d invcdr
/*
Instance invcdr1 is not running on node invcdr1
Instance invcdr2 is not running on node invcdr2
*/

[oracle@invcdr1 ~]$ srvctl status database -d invcdr -v
/*
Instance invcdr1 is not running on node invcdr1
Instance invcdr2 is not running on node invcdr2
*/
-- Step 3.1
-- To start the DB services for node 1 and status Secondary Database -> DR
[oracle@invcdr1 ~]$ srvctl start instance -d invcdr -i invcdr1 -o mount
[oracle@invcdr1 ~]$ srvctl status database -d invcdr -v
/*
Instance invcdr1 is running on node invcdr1. Instance status: Mounted (Closed).
Instance invcdr2 is not running on node invcdr2
*/

-- Step 3.2
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT inst_id,status,instance_name FROM gv$instance;
/*
INST_ID STATUS       INSTANCE_NAME
------- ------------ ----------------
      1 MOUNTED      invcdr1
*/

-- Step 3.3
--  Covert physical standby database to snapshot standby database -> DR.
SQL> ALTER DATABASE CONVERT TO SNAPSHOT STANDBY;
/*
Database altered.
*/

-- Step 3.4
-- The physical standby database in snapshot standby database status shoud be in mount mode -> DR
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
------- ------------ ---------------- ---------------- --------------------
      1 MOUNTED      invcdr1          SNAPSHOT STANDBY MOUNTED
*/

-- Step 3.5
-- Bring the database in open mode -> DR
SQL> ALTER DATABASE OPEN;
/*
Database altered.
*/

-- Step 3.6
-- Bring the database in open mode -> DR
SQL> alter pluggable database all open;
/*
Pluggable database altered.
*/

-- Step 3.7
-- Bring the database in open mode -> DR
SQL> show pdbs
/*
    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 INVPDB                         READ WRITE NO
*/

-- Step 3.8
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT inst_id,status,instance_name FROM gv$instance;
/*
INST_ID STATUS       INSTANCE_NAME
------- ------------ ----------------
      1 OPEN         invcdr1
*/


-- Step 3.9
-- Verify the restore point of Secondary Database -> DR
SQL> SELECT inst_id,flashback_on FROM gv$database;
/*
INST_ID FLASHBACK_ON
------- ------------------
      1 RESTORE POINT ONLY

*/

-- Step 3.10
-- Verify the Added Data Files on Primary Database -> DC and properly reflected on Secondary Database -> DR 
SQL> conn hr/oracle@invpdb
/*
Connected.
*/

-- Step 3.11
-- Verify the Added Data Files on Primary Database -> DC and properly reflected on Secondary Database -> DR 
SQL> show user
/*
USER is "HR"
*/

-- Step 3.12
-- Verify the Data populated on Primary Database -> DC and properly reflected on Secondary Database -> DR  
SQL> select * from hr.snapshot_standby_test;
/*
        SN
----------
         1
         2
         3
         4
         5
         6
         7
         8
         9
        10

10 rows selected.
*/

-- Step 4
-- Covert back physical standby database from snapshot standby database.
-- Shutdown the DR database -> DR
SQL> conn sys/P#ssw0rd@invcdr as sysdba
/*
Connected.
*/

-- Step 4.1
-- Verify the Added Data Files on Primary Database -> DC and properly reflected on Secondary Database -> DR 
SQL> show pdbs
/*
    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 INVPDB                         READ WRITE NO
*/

-- Step 4.2
-- Verify the Added Data Files on Primary Database -> DC and properly reflected on Secondary Database -> DR 
SQL> shutdown immediate;
/*
Database closed.
Database dismounted.
ORACLE instance shut down.
*/

-- Step 4.3
-- Bring the database in mount mode -> DR
SQL> startup mount;
/*
ORACLE instance started.

Total System Global Area 6442448976 bytes
Fixed Size                  9152592 bytes
Variable Size            1409286144 bytes
Database Buffers         5016387584 bytes
Redo Buffers                7622656 bytes
Database mounted.
*/

-- Step 4.4
-- Covert back physical standby database from snapshot standby database -> DR.
SQL> ALTER DATABASE CONVERT TO PHYSICAL STANDBY;
/*
Database altered.
*/

-- Step 4.5
-- Shutdown the database -> DR
SQL> shutdown immediate;
/*
ORA-01109: database not open


Database dismounted.
ORACLE instance shut down.
*/

-- Step 4.6
-- Bring the database in nomount mode -> DR
SQL> startup nomount;
/*
ORACLE instance started.

Total System Global Area 6442448976 bytes
Fixed Size                  9152592 bytes
Variable Size            1409286144 bytes
Database Buffers         5016387584 bytes
Redo Buffers                7622656 bytes
*/

-- Step 4.7
-- Bring the database in mount mode -> DR
SQL> ALTER DATABASE MOUNT STANDBY DATABASE;
/*
Database altered.
*/

-- Step 4.8
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
------- ------------ ---------------- ---------------- ---------
      1 MOUNTED      invcdr1          PHYSICAL STANDBY MOUNTED
*/

-- Step 4.9
-- Verify the DB services status Secondary Database -> DR
[oracle@invcdr1 ~]$ srvctl status database -d invcdr -v
/*
Instance invcdr1 is running on node invcdr1. Instance status: Dismounted,Mount Initiated.
Instance invcdr2 is not running on node invcdr2
*/

[oracle@invcdr1 ~]$ srvctl status database -d invcdr
/*
Instance invcdr1 is running on node invcdr1
Instance invcdr2 is not running on node invcdr2
*/

-- Step 4.10
-- To stop the DB services and status Secondary Database -> DR
[oracle@invcdr1 ~]$ srvctl stop database -d invcdr
[oracle@invcdr1 ~]$ srvctl status database -d invcdr
/*
Instance invcdr1 is not running on node invcdr1
Instance invcdr2 is not running on node invcdr2
*/

-- Step 4.11
-- To start the DB services and status Secondary Database -> DR
[oracle@invcdr1 ~]$ srvctl start database -d invcdr -o mount
[oracle@invcdr1 ~]$ srvctl status database -d invcdr -v
/*
Instance invcdr1 is running on node invcdr1. Instance status: Mounted (Closed).
Instance invcdr2 is running on node invcdr2. Instance status: Mounted (Closed).
*/

-- Step 4.12
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT inst_id,status,instance_name from gv$instance;
/*
INST_ID STATUS       INSTANCE_NAME
------- ------------ ----------------
      1 MOUNTED      invcdr1
      2 MOUNTED      invcdr2
*/

-- Step 4.13
-- Verify the restore point of Secondary Database -> DR
SQL> SELECT inst_id,flashback_on FROM gv$database;
/*
INST_ID FLASHBACK_ON
------- ------------------
      1 NO
      2 NO
*/

-- Step 4.14
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
------- ------------ ---------------- ---------------- --------------------
      1 MOUNTED      invcdr1        PHYSICAL STANDBY MOUNTED
      2 MOUNTED      invcdr2        PHYSICAL STANDBY MOUNTED
*/

-- Step 4.15
-- Verify the DB instance status of Secondary Database -> DR
SQL> show pdbs
/*
    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       MOUNTED
         3 INVPDB                         MOUNTED
*/

-- Step 4.16
-- Start the Recovery Process in Secondary Database -> DR
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION INSTANCES ALL;
/*
Database altered.
*/

-- Step 4.17
-- Verify the issue in Secondary Database -> DR
SQL> SELECT DISTINCT error FROM gv$archive_dest_status;
/*
ERROR
-----
*/

-- Step 4.18
-- Verify the MRP of Secondary Database -> DR
SELECT inst_id,process,thread#,sequence#,status FROM gv$managed_standby ORDER BY 1;
/*
SQL> SELECT inst_id,process,thread#,sequence#,status FROM gv$managed_standby ORDER BY 1;

   INST_ID PROCESS      THREAD#  SEQUENCE# STATUS
---------- --------- ---------- ---------- ------------
         1 ARCH               0          0 CONNECTED
         1 DGRD               0          0 ALLOCATED
         1 DGRD               0          0 ALLOCATED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               1       1576 CLOSING
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               2        797 CLOSING
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 RFS                2          0 IDLE
         1 RFS                1          0 IDLE
         1 RFS                2        798 IDLE
         1 MRP0               1       1578 APPLYING_LOG
         2 ARCH               0          0 CONNECTED
         2 RFS                1       1578 IDLE
         2 DGRD               0          0 ALLOCATED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               1       1577 CLOSING
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 DGRD               0          0 ALLOCATED

*/

-- Step 4.19
SQL> SELECT * FROM gv$archive_gap;
/*
no rows selected
*/

-- Step 4.20
-- Verify the DB instance status of Primary Database -> DC
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
------- ------------ ---------------- ---------------- --------------------
      1 OPEN         invoiced1        PRIMARY          READ WRITE
      2 OPEN         invoiced2        PRIMARY          READ WRITE
*/

-- Step 4.21
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
------- ------------ ---------------- ---------------- --------------------
      1 MOUNTED      invcdr1        PHYSICAL STANDBY MOUNTED
      2 MOUNTED      invcdr1        PHYSICAL STANDBY MOUNTED
*/
