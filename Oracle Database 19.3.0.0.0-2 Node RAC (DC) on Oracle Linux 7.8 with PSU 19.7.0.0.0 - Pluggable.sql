----------------------------------------------------------------
-------------Two Node rac Setup on VM Workstation---------------
----------------------------------------------------------------

-- 2 Node rac on VM -->> On both Node
[root@rac1/rac2 ~]# df -Th
/*
Filesystem     Type      Size  Used Avail Use% Mounted on
devtmpfs       devtmpfs  4.8G     0  4.8G   0% /dev
tmpfs          tmpfs     4.8G     0  4.8G   0% /dev/shm
tmpfs          tmpfs     4.8G  9.8M  4.8G   1% /run
tmpfs          tmpfs     4.8G     0  4.8G   0% /sys/fs/cgroup
/dev/sda3      ext4       50G  123M   47G   1% /
/dev/sda5      ext4       15G  5.7G  8.3G  41% /usr
/dev/sda6      ext4       15G  669M   14G   5% /var
/dev/sda1      ext4      9.8G  225M  9.0G   3% /boot
/dev/sda7      ext4      9.8G   37M  9.2G   1% /home
/dev/sda2      ext4       79G   57M   75G   1% /opt
/dev/sda8      ext4      9.8G   37M  9.2G   1% /tmp
/dev/sr0       iso9660   4.5G  4.5G     0 100% /run/media/root/OL-7.8 Server.x86_64
tmpfs          tmpfs     971M  8.0K  971M   1% /run/user/42
tmpfs          tmpfs     971M     0  971M   0% /run/user/0
*/

-- Step 1 -->> On both Node
[root@rac1/rac2 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.168.1.75   rac1.mydomain        rac1
192.168.1.76   rac2.mydomain        rac2

# Private
192.0.1.75     rac1-priv.mydomain   rac1-priv
192.0.1.76     rac2-priv.mydomain   rac2-priv

# Virtual
192.168.1.77   rac1-vip.mydomain    rac1-vip
192.168.1.78   rac2-vip.mydomain    rac2-vip

# SCAN
192.168.1.79   rac-scan.mydomain    rac-scan
192.168.1.80   rac-scan.mydomain    rac-scan
*/


-- Step 2 -->> On both Node
-- Disable secure linux by editing the "/etc/selinux/config" file, making sure the SELINUX flag is set as follows.
[root@rac1/rac2 ~]# vi /etc/selinux/config
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
[root@rac1 network-scripts ~]# vi /etc/sysconfig/network
/*
NETWORKING=yes
HOSTNAME=rac1.mydomain
*/

-- Step 4 -->> On Node 2
[root@rac2 network-scripts ~]# vi /etc/sysconfig/network
/*
NETWORKING=yes
HOSTNAME=rac2.mydomain
*/

-- Step 5 -->> On Node 1
[root@rac1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens192 
/*
DEVICE=ens192
TYPE=Ethernet
BOOTPROTO=staticONBOOT=yes
IPADDR=192.168.1.75
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=127.0.0.1
DNS2=192.168.1.85
*/

-- Step 6 -->> On Node 1
[root@rac1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens224
/*
DEVICE=ens224
TYPE=Ethernet
BOOTPROTO=static
ONBOOT=yes
IPADDR=192.0.1.75
NETMASK=255.255.255.0
*/

-- Step 7 -->> On Node 2
[root@rac2 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens192 
/*
DEVICE=ens192
BOOTPROTO=static
TYPE=Ethernet
ONBOOT=yes
IPADDR=192.168.1.76
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=127.0.0.1
DNS2=192.168.1.85
*/

-- Step 8 -->> On Node 2
[root@rac2 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens224
/*
DEVICE=ens224
BOOTPROTO=static
TYPE=Ethernet
ONBOOT=yes
IPADDR=192.0.1.76
NETMASK=255.255.255.0
*/

-- Step 9 -->> On Both Node
[root@rac1/rac2 network-scripts]# systemctl restart network

-- Step 10 -->> On Both Node
[root@rac1/rac2 ~]# cat /etc/hostname
/*
localhost.localdomain
*/
[root@rac1/rac2 ~]# hostnamectl | grep hostname
/*
   Static hostname: localhost.localdomain
Transient hostname: rac1/rac2-vip.mydomain
*/

[root@rac1/rac2 ~]# hostnamectl --static
/*
localhost.localdomain
*/

-- Step 11 -->> On Node 1
[root@rac1 ~]# hostnamectl set-hostname rac1.mydomain
[root@rac1 ~]# hostnamectl
/*
   Static hostname: rac1.mydomain
         Icon name: computer-vm
           Chassis: vm
        Machine ID: f7695909115f4bf2aef1b6a10ae1b58b
           Boot ID: 14cdfceb128c488da8785c547bb1e220
    Virtualization: vmware
  Operating System: Oracle Linux Server 7.8
       CPE OS Name: cpe:/o:oracle:linux:7:8:server
            Kernel: Linux 4.14.35-1902.300.11.el7uek.x86_64
      Architecture: x86-64
*/

-- Step 12 -->> On Node 2
[root@rac2 ~]# hostnamectl set-hostname rac2.mydomain
[root@rac2 ~]# hostnamectl
/*
   Static hostname: rac2.mydomain
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 056c622c5bed4d849ff2c0cfee36c960
           Boot ID: 1f1334d2831748e891d83eb3a64133f8
    Virtualization: vmware
  Operating System: Oracle Linux Server 7.8
       CPE OS Name: cpe:/o:oracle:linux:7:8:server
            Kernel: Linux 4.14.35-1902.300.11.el7uek.x86_64
      Architecture: x86-64
*/

--Note: If you are not configure proper hostname then While installation of Grid Software, 
--      you have to face error CLSRSC-180: An error occurred while executing /opt/app/19c/grid/root.sh script.

-- Step 13 -->> On Both Node
[root@rac1/rac2 network-scripts]# systemctl stop firewalld
[root@rac1/rac2 network-scripts]# systemctl disable firewalld
/*
Removed /etc/systemd/system/multi-user.target.wants/firewalld.service.
Removed /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.
*/

-- Step 14 -->> On Both Node
[root@rac1/rac2 ~]# systemctl stop ntpd
[root@rac1/rac2 ~]# systemctl disable ntpd

[root@rac1/rac2 ~]# cd /etc/
[root@rac1/rac2 etc]# mv /etc/ntp.conf /etc/ntp.conf.backup
[root@rac1/rac2 etc]# ls | grep ntp
/*
ntp
ntp.conf.backup
*/
[root@rac1/rac2 ~]# rm -rf /etc/ntp.conf
[root@rac1/rac2 ~]# rm -rf /var/run/ntpd.pid

-- Step 15 -->> On Both Node
[root@rac1/rac2 ~]# iptables -F
[root@rac1/rac2 ~]# iptables -X
[root@rac1/rac2 ~]# iptables -t nat -F
[root@rac1/rac2 ~]# iptables -t nat -X
[root@rac1/rac2 ~]# iptables -t mangle -F
[root@rac1/rac2 ~]# iptables -t mangle -X
[root@rac1/rac2 ~]# iptables -P INPUT ACCEPT
[root@rac1/rac2 ~]# iptables -P FORWARD ACCEPT
[root@rac1/rac2 ~]# iptables -P OUTPUT ACCEPT
[root@rac1/rac2 ~]# iptables -L -nv
/*
Chain INPUT (policy ACCEPT 2066 packets, 5110K bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy ACCEPT 1772 packets, 117K bytes)
 pkts bytes target     prot opt in     out     source               destination
*/

-- Step 16 -->> On Both Node
[root@rac1/rac2 ~ ]# systemctl stop named
[root@rac1/rac2 ~ ]# systemctl disable named

-- Step 17 -->> On Both Node
-- Enable chronyd service." `date`
[root@rac1/rac2 ~ ]# systemctl enable chronyd
[root@rac1/rac2 ~ ]# systemctl restart chronyd
[root@rac1/rac2 ~ ]# chronyc -a 'burst 4/4'
/*
200 OK
*/
[root@rac1/rac2 ~ ]# chronyc -a makestep
/*
200 OK
*/

[root@rac1/rac2 ~ ]# systemctl status chronyd
/*
? chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: active (running) since Fri 2020-09-11 11:47:36 +0545; 50min ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
 Main PID: 3406 (chronyd)
   CGroup: /system.slice/chronyd.service
           +-3406 /usr/sbin/chronyd

Sep 11 12:24:45 localhost.localdomain chronyd[3406]: Can't synchronise: no selectable sources
Sep 11 12:24:46 rac1.mydomain chronyd[3406]: Source 162.159.200.1 online
Sep 11 12:24:46 rac1.mydomain chronyd[3406]: Source 162.159.200.123 online
Sep 11 12:28:23 rac1.mydomain chronyd[3406]: Selected source 162.159.200.1
Sep 11 12:28:30 localhost.localdomain chronyd[3406]: Source 162.159.200.123 offline
Sep 11 12:28:30 localhost.localdomain chronyd[3406]: Source 162.159.200.1 offline
Sep 11 12:28:30 localhost.localdomain chronyd[3406]: Can't synchronise: no selectable sources
Sep 11 12:28:31 rac1.mydomain chronyd[3406]: Source 162.159.200.1 online
Sep 11 12:28:31 rac1.mydomain chronyd[3406]: Source 162.159.200.123 online
Sep 11 12:31:37 rac1.mydomain chronyd[3406]: Selected source 162.159.200.123
Hint: Some lines were ellipsized, use -l to show in full.
*/

-- Step 18 -->> On Both Node
[root@rac1/rac2 ~]# cd /run/media/root/OL-7.8\ Server.x86_64/Packages/
[root@rac1/rac2 Packages]# yum install -y bind
[root@rac1/rac2 Packages]# yum install -y dnsmasq
[root@rac1/rac2 ~]# systemctl enable dnsmasq
[root@rac1/rac2 ~]# systemctl restart dnsmasq
[root@rac1/rac2 ~]# vi /etc/dnsmasq.conf
/*
listen-address=::1,127.0.0.1

#Add the following Lines
except-interface=virbr0
bind-interfaces
*/
[root@rac1/rac2 ~]# systemctl restart dnsmasq
[root@rac1/rac2 ~]# systemctl restart network
[root@rac1/rac2 ~]# systemctl status dnsmasq
/*
? dnsmasq.service - DNS caching server.
   Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2020-09-16 12:10:09 +0545; 26min ago
 Main PID: 48646 (dnsmasq)
    Tasks: 1
   CGroup: /system.slice/dnsmasq.service
           +-48646 /usr/sbin/dnsmasq -k

Sep 16 12:10:09 rac1.mydomain systemd[1]: Started DNS caching server..
Sep 16 12:10:09 rac1.mydomain dnsmasq[48646]: listening on lo(#1): 127.0.0.1
Sep 16 12:10:09 rac1.mydomain dnsmasq[48646]: listening on lo(#1): ::1
Sep 16 12:10:09 rac1.mydomain dnsmasq[48646]: started, version 2.76 cachesize 150
Sep 16 12:10:09 rac1.mydomain dnsmasq[48646]: compile time options: IPv6 GNU-getopt DBus no-i18n IDN DHCP ...tify
Sep 16 12:10:09 rac1.mydomain dnsmasq[48646]: reading /etc/resolv.conf
Sep 16 12:10:09 rac1.mydomain dnsmasq[48646]: ignoring nameserver 127.0.0.1 - local interface
Sep 16 12:10:09 rac1.mydomain dnsmasq[48646]: using nameserver 192.168.1.85#53
Sep 16 12:10:09 rac1.mydomain dnsmasq[48646]: read /etc/hosts - 10 addresses
Hint: Some lines were ellipsized, use -l to show in full.
*/

[root@rac1 Packages]# nslookup 192.168.1.75
/*
75.1.168.192.in-addr.arpa        name = rac1.mydomain.
*/
[root@rac1 Packages]# nslookup 192.168.1.76
/*
76.1.168.192.in-addr.arpa        name = rac2.mydomain.
*/

-- Step 19 -->> On Both Node
--Stop avahi-daemon damon if it not configured
[root@rac1/rac2 ~]# systemctl stop avahi-daemon
[root@rac1/rac2 ~]# systemctl disable avahi-daemon

-- Step 20 -->> On Both Node
--To Remove virbr0 and lxcbr0 Network Interfac
[root@rac1/rac2 ~]# systemctl stop libvirtd.service
[root@rac1/rac2 ~]# systemctl disable libvirtd.service
[root@rac1/rac2 ~]# virsh net-list
[root@rac1/rac2 ~]# virsh net-destroy default
[root@rac1/rac2 ~]# ifconfig virbr0
/*
virbr0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 192.168.122.1  netmask 255.255.255.0  broadcast 192.168.122.255
        ether 52:54:00:10:03:8b  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

[root@rac1/rac2 ~]# brctl show
/*
bridge name     bridge id               STP enabled     interfaces
virbr0          8000.52540010038b       yes             virbr0-nic
*/

[root@rac1/rac2 ~]# ip link set virbr0 down
[root@rac1/rac2 ~]# brctl delbr virbr0
[root@rac1/rac2 ~]# brctl show
/*
bridge name     bridge id               STP enabled     interfaces
*/

[root@rac1/rac2 ~]# ifconfig virbr0
/*
virbr0: error fetching interface information: Device not found
*/

[root@rac1 ~]# ifconfig
/*
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.1.75  netmask 255.255.255.0  broadcast 192.168.1.255
        inet6 fe80::20c:29ff:feea:be94  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:ea:be:94  txqueuelen 1000  (Ethernet)
        RX packets 525633  bytes 655089095 (624.7 MiB)
        RX errors 0  dropped 39  overruns 0  frame 0
        TX packets 185724  bytes 14928881 (14.2 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens224: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.0.1.75  netmask 255.255.255.0  broadcast 192.0.1.255
        inet6 fe80::20c:29ff:feea:be9e  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:ea:be:9e  txqueuelen 1000  (Ethernet)
        RX packets 84027  bytes 5484991 (5.2 MiB)
        RX errors 0  dropped 35  overruns 0  frame 0
        TX packets 57  bytes 4026 (3.9 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 152  bytes 13151 (12.8 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 152  bytes 13151 (12.8 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

*/

[root@rac2 ~]# ifconfig
/*
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.1.76  netmask 255.255.255.0  broadcast 192.168.1.255
        inet6 fe80::20c:29ff:feb7:b975  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:b7:b9:75  txqueuelen 1000  (Ethernet)
        RX packets 522593  bytes 649629397 (619.5 MiB)
        RX errors 0  dropped 26  overruns 0  frame 0
        TX packets 173945  bytes 14289252 (13.6 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens224: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.0.1.76  netmask 255.255.255.0  broadcast 192.0.1.255
        inet6 fe80::20c:29ff:feb7:b97f  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:b7:b9:7f  txqueuelen 1000  (Ethernet)
        RX packets 84003  bytes 5483541 (5.2 MiB)
        RX errors 0  dropped 22  overruns 0  frame 0
        TX packets 59  bytes 4166 (4.0 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 167  bytes 14799 (14.4 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 167  bytes 14799 (14.4 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

*/
-- Step 21 -->> On Both Node
[root@rac1/rac2 ~]# init 6

-- Step 22 -->> On Both Node
[root@rac1/rac2 ~]# brctl show
/*
bridge name     bridge id               STP enabled     interfaces
*/

-- Step 23 -->> On Both Node
[root@rac1/rac2 ~]# systemctl status libvirtd.service
/*
? libvirtd.service - Virtualization daemon
   Loaded: loaded (/usr/lib/systemd/system/libvirtd.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:libvirtd(8)
           https://libvirt.org
*/

-- Step 24 -->> On Both Node
[root@rac1/rac2 ~]# firewall-cmd --list-all
/*
FirewallD is not running
*/
[root@rac1/rac2 ~]# systemctl status firewalld
/*
? firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; vendor >
   Active: inactive (dead)
     Docs: man:firewalld(1)
*/

-- Step 25 -->> On Both Node
[root@rac1/rac2 ~]# systemctl status ntpd
/*
? ntpd.service - Network Time Service
   Loaded: loaded (/usr/lib/systemd/system/ntpd.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
*/

-- Step 26 -->> On Both Node
[root@rac1/rac2 ~]# systemctl status named
/*
? named.service - Berkeley Internet Name Domain (DNS)
   Loaded: loaded (/usr/lib/systemd/system/named.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
*/

-- Step 27 -->> On Both Node
[root@rac1/rac2 ~]# systemctl status avahi-daemon
/*
? avahi-daemon.service - Avahi mDNS/DNS-SD Stack
   Loaded: loaded (/usr/lib/systemd/system/avahi-daemon.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
*/

-- Step 28 -->> On Both Node
[root@rac1/rac2 ~ ]# systemctl status chronyd
/*
? chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2020-09-16 17:13:16 +0545; 8min ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 897 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, status=0/SUCCESS)
  Process: 873 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 894 (chronyd)
    Tasks: 1
   CGroup: /system.slice/chronyd.service
           +-894 /usr/sbin/chronyd

Sep 16 17:13:16 localhost.localdomain systemd[1]: Starting NTP client/server...
Sep 16 17:13:16 localhost.localdomain chronyd[894]: chronyd version 3.4 starting (+CMDMON ...G)
Sep 16 17:13:16 localhost.localdomain chronyd[894]: Frequency -98.580 +/- 101.594 ppm read...ft
Sep 16 17:13:16 localhost.localdomain systemd[1]: Started NTP client/server.
Sep 16 17:13:21 rac1.mydomain chronyd[894]: Selected source 162.159.200.1
Hint: Some lines were ellipsized, use -l to show in full.
*/

-- Step 29 -->> On Both Node
[root@rac1/rac2 ~]# systemctl status dnsmasq
/*
? dnsmasq.service - DNS caching server.
   Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2020-09-16 12:10:09 +0545; 29min ago
 Main PID: 48646 (dnsmasq)
    Tasks: 1
   CGroup: /system.slice/dnsmasq.service
           +-48646 /usr/sbin/dnsmasq -k

Sep 16 12:10:09 rac1.mydomain systemd[1]: Started DNS caching server..
Sep 16 12:10:09 rac1.mydomain dnsmasq[48646]: listening on lo(#1): 127.0.0.1
Sep 16 12:10:09 rac1.mydomain dnsmasq[48646]: listening on lo(#1): ::1
Sep 16 12:10:09 rac1.mydomain dnsmasq[48646]: started, version 2.76 cachesize 150
Sep 16 12:10:09 rac1.mydomain dnsmasq[48646]: compile time options: IPv6 GNU-getopt DBus no-i18n IDN DHCP ...tify
Sep 16 12:10:09 rac1.mydomain dnsmasq[48646]: reading /etc/resolv.conf
Sep 16 12:10:09 rac1.mydomain dnsmasq[48646]: ignoring nameserver 127.0.0.1 - local interface
Sep 16 12:10:09 rac1.mydomain dnsmasq[48646]: using nameserver 192.168.1.85#53
Sep 16 12:10:09 rac1.mydomain dnsmasq[48646]: read /etc/hosts - 10 addresses
Hint: Some lines were ellipsized, use -l to show in full.
*/

-- Step 30 -->> On Both Node
[root@rac1 Packages]# nslookup 192.168.1.75
/*
75.1.168.192.in-addr.arpa        name = rac1.mydomain.
*/
[root@rac1 Packages]# nslookup 192.168.1.76
/*
76.1.168.192.in-addr.arpa        name = rac2.mydomain.
*/

[root@rac1/rac2 ~]# nslookup rac1
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   rac1.mydomain
Address: 192.168.1.75
*/

[root@rac1/rac2 ~]# nslookup rac2
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   rac2.mydomain
Address: 192.168.1.76
*/

[root@rac1/rac2 ~]# nslookup rac-scan
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   rac-scan.mydomain
Address: 192.168.1.80
Name:   rac-scan.mydomain
Address: 192.168.1.79
*/

-- Step 31 -->> On Both Node
[root@rac1/rac2 ~]# iptables -L -nv
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
[root@rac1/rac2 ~]# cd /run/media/root/OL-7.8\ Server.x86_64/Packages/
[root@rac1/rac2 Packages]# yum update

[root@rac1/rac2 Packages]# yum install -y yum-utils
[root@rac1/rac2 Packages]# yum install -y oracle-epel-release-el7
[root@rac1/rac2 Packages]# yum-config-manager --enable ol7_developer_EPEL
[root@rac1/rac2 Packages]# yum install -y sshpass zip unzip
[root@rac1/rac2 Packages]# yum install -y oracle-database-preinstall-19c

[root@rac1/rac2 Packages]# yum install -y bc    
[root@rac1/rac2 Packages]# yum install -y binutils
[root@rac1/rac2 Packages]# yum install -y compat-libcap1
[root@rac1/rac2 Packages]# yum install -y compat-libstdc++-33
[root@rac1/rac2 Packages]# yum install -y dtrace-utils
[root@rac1/rac2 Packages]# yum install -y elfutils-libelf
[root@rac1/rac2 Packages]# yum install -y elfutils-libelf-devel
[root@rac1/rac2 Packages]# yum install -y fontconfig-devel
[root@rac1/rac2 Packages]# yum install -y glibc
[root@rac1/rac2 Packages]# yum install -y glibc-devel
[root@rac1/rac2 Packages]# yum install -y ksh
[root@rac1/rac2 Packages]# yum install -y libaio
[root@rac1/rac2 Packages]# yum install -y libaio-devel
[root@rac1/rac2 Packages]# yum install -y libdtrace-ctf-devel
[root@rac1/rac2 Packages]# yum install -y libXrender
[root@rac1/rac2 Packages]# yum install -y libXrender-devel
[root@rac1/rac2 Packages]# yum install -y libX11
[root@rac1/rac2 Packages]# yum install -y libXau
[root@rac1/rac2 Packages]# yum install -y libXi
[root@rac1/rac2 Packages]# yum install -y libXtst
[root@rac1/rac2 Packages]# yum install -y libgcc
[root@rac1/rac2 Packages]# yum install -y librdmacm-devel
[root@rac1/rac2 Packages]# yum install -y libstdc++
[root@rac1/rac2 Packages]# yum install -y libstdc++-devel
[root@rac1/rac2 Packages]# yum install -y libxcb
[root@rac1/rac2 Packages]# yum install -y make
[root@rac1/rac2 Packages]# yum install -y net-tools
[root@rac1/rac2 Packages]# yum install -y nfs-utils
[root@rac1/rac2 Packages]# yum install -y python
[root@rac1/rac2 Packages]# yum install -y python-configshell
[root@rac1/rac2 Packages]# yum install -y python-rtslib
[root@rac1/rac2 Packages]# yum install -y python-six
[root@rac1/rac2 Packages]# yum install -y targetcli
[root@rac1/rac2 Packages]# yum install -y smartmontools
[root@rac1/rac2 Packages]# yum install -y sysstat
[root@rac1/rac2 Packages]# yum install -y unixODBC
[root@rac1/rac2 Packages]# yum install -y chrony
[root@rac1/rac2 Packages]# rpm -iUvh glibc-2*i686* nss-softokn-freebl-3*i686*
[root@rac1/rac2 Packages]# rpm -iUvh glibc-devel-2*i686*
[root@rac1/rac2 Packages]# rpm -iUvh libaio-0*i686*
[root@rac1/rac2 Packages]# rpm -iUvh libaio-devel-0*i686*
[root@rac1/rac2 Packages]# rpm -iUvh numactl-devel-2*x86_64*
[root@rac1/rac2 Packages]# rpm -iUvh libtool-ltdl*i686*
[root@rac1/rac2 Packages]# yum install -y oracleasm*
[root@rac1/rac2 Packages]# yum -y update


-- Step 33 -->> On Both Node
--https://yum.oracle.com/repo/OracleLinux/OL7/8/base/x86_64/index.html
[root@rac1/rac2 ~]# cd /root/OracleLinux7_8_RPM/
[root@rac1/rac2 OracleLinux7_8_RPM]# rpm -iUvh compat-libcap1-1.10-7.el7.i686.rpm
[root@rac1/rac2 OracleLinux7_8_RPM]# rpm -iUvh glibc-utils-2.17-307.0.1.el7.1.x86_64.rpm
[root@rac1/rac2 OracleLinux7_8_RPM]# rpm -iUvh ncurses-devel-5.9-14.20130511.el7_4.x86_64.rpm
[root@rac1/rac2 OracleLinux7_8_RPM]# rpm -iUvh unixODBC-devel-2.3.1-14.0.1.el7.x86_64.rpm
[root@rac1/rac2 OracleLinux7_8_RPM]# rpm -iUvh oracleasmlib-2.0.12-1.el7.x86_64.rpm


-- Step 34 -->> On Both Node
[root@rac1/rac2 ~]# cd /run/media/root/OL-7.8\ Server.x86_64/Packages/
[root@rac1/rac2 Packages]# yum install compat-libcap1 compat-libstdc++-33 bc binutils elfutils-libelf elfutils-libelf-devel fontconfig-devel glibc glibc-devel ksh libaio libaio-devel libgcc libnsl librdmacm-devel libstdc++ libstdc++-devel libX11 libXau libxcb libXi libXrender libXrender-devel libXtst make net-tools nfs-utils python3 python3-configshell python3-rtslib python3-six smartmontools sysstat targetcli unzip
[root@rac1/rac2 Packages]# yum -y update

-- Step 35 -->> On Both Node
[root@rac1/rac2 Packages]# rpm -q binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel elfutils-libelf-devel-static \
[root@rac1/rac2 Packages]# rpm -q gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers kernel-headers ksh libaio libaio-devel \
[root@rac1/rac2 Packages]# rpm -q libgcc libgomp libstdc++ libstdc++-devel make numactl-devel sysstat unixODBC unixODBC-devel \


-- Step 36 -->> On Both Node
-- Pre-Installation Steps for ASM
[root@rac1/rac2 ~ ]# cd /etc/yum.repos.d
[root@rac1/rac2 yum.repos.d]# uname -ras
/*
Linux rac2.mydomain 4.14.35-1902.300.11.el7uek.x86_64 #2 SMP Tue Mar 17 17:11:47 PDT 2020 x86_64 x86_64 x86_64 GNU/Linux
*/

[root@rac1/rac2 yum.repos.d]# cat /etc/os-release 
/*
NAME="Oracle Linux Server"
VERSION="7.8"
ID="ol"
ID_LIKE="fedora"
VARIANT="Server"
VARIANT_ID="server"
VERSION_ID="7.8"
PRETTY_NAME="Oracle Linux Server 7.8"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:oracle:linux:7:8:server"
HOME_URL="https://linux.oracle.com/"
BUG_REPORT_URL="https://bugzilla.oracle.com/"

ORACLE_BUGZILLA_PRODUCT="Oracle Linux 7"
ORACLE_BUGZILLA_PRODUCT_VERSION=7.8
ORACLE_SUPPORT_PRODUCT="Oracle Linux"
ORACLE_SUPPORT_PRODUCT_VERSION=7.8
*/

[root@rac1/rac2 yum.repos.d]# yum install kmod-oracleasm
[root@rac1/rac2 yum.repos.d]# yum install oracleasm-support

[root@rac1/rac2 yum.repos.d]# rpm -qa | grep oracleasm
/*
oracleasmlib-2.0.12-1.el7.x86_64
oracleasm-support-2.1.11-2.el7.x86_64
kmod-oracleasm-2.0.8-27.0.1.el7.x86_64
*/

-- Step 37 -->> On Both Node
-- Add the kernel parameters file "/etc/sysctl.conf" and add oracle recommended kernel parameters
[root@rac1/rac2 ~]# vim /etc/sysctl.conf
/*
fs.file-max = 6815744
kernel.sem = 250 32000 100 128
kernel.shmmni = 4096
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

-- Run the following command to change the current kernel parameters.
[root@rac1/rac2 ~]# sysctl -p /etc/sysctl.conf

-- Step 38 -->> On Both Node
-- Edit /etc/security/limits.d/oracle-database-preinstall-19c.conf file to limit user processes
[root@rac1/rac2 ~]# vi /etc/security/limits.d/oracle-database-preinstall-19c.conf
/*
oracle   soft   nofile  1024
oracle   hard   nofile  65536
oracle   soft   nproc   16384
oracle   hard   nproc   16384
oracle   soft   stack   10240
oracle   hard   stack   32768
oracle   hard   memlock 134217728
oracle   soft   memlock 134217728
oracle   soft   data    unlimited
oracle   hard   data    unlimited

grid    soft    nofile   1024
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
[root@rac1/rac2 ~]# vim /etc/pam.d/login
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
[root@rac1/rac2 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:
*/
[root@rac1/rac2 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:
backupdba:x:54324:
dgdba:x:54325:
kmdba:x:54326:
racdba:x:54330:
*/

[root@rac1/rac2 ~]# cat /etc/group | grep -i oracle
/*
oracle:x:1000:oracle
*/

[root@rac1/rac2 ~]# cat /etc/group | grep -i asm

-- 1.Create OS groups using the command below. Enter these commands as the 'root' user:
[root@rac1/rac2 ~]# /usr/sbin/groupadd -g 503 oper
[root@rac1/rac2 ~]# /usr/sbin/groupadd -g 504 asmadmin
[root@rac1/rac2 ~]# /usr/sbin/groupadd -g 506 asmdba
[root@rac1/rac2 ~]# /usr/sbin/groupadd -g 507 asmoper
[root@rac1/rac2 ~]# /usr/sbin/groupadd -g 508 beoper

-- 2.Create the users that will own the Oracle software using the commands:
[root@rac1/rac2 ~]# /usr/sbin/useradd  -g oinstall -G oinstall,dba,asmadmin,asmdba,asmoper,beoper grid
[root@rac1/rac2 ~]# /usr/sbin/usermod -g oinstall -G oinstall,dba,oper,asmdba,asmadmin,backupdba,dgdba,kmdba,racdba oracle

[root@rac1/rac2 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/

[root@rac1/rac2 ~]# cat /etc/group | grep -i oracle
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

[root@rac1/rac2 ~]# cat /etc/group | grep -i grid
/*
oinstall:x:54321:grid,oracle
dba:x:54322:grid,oracle
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

[root@rac1/rac2 ~]# cat /etc/group | grep -i oper
/*
oper:x:54323:oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

[root@rac1/rac2 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:grid,oracle
*/

[root@rac1/rac2 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:grid,oracle
backupdba:x:54324:oracle
dgdba:x:54325:oracle
kmdba:x:54326:oracle
racdba:x:54330:oracle
asmdba:x:506:grid,oracle
*/

[root@rac1/rac2 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/

-- Step 41 -->> On both Node
[root@rac1/rac2 ~]# passwd oracle
/*
Changing password for user oracle.
New password:
BAD PASSWORD: The password is shorter than 8 characters
Retype new password:
passwd: all authentication tokens updated successfully.
*/

-- Step 42 -->> On both Node
[root@rac1/rac2 ~]# passwd grid
/*
Changing password for user grid.
New password:
BAD PASSWORD: The password is shorter than 8 characters
Retype new password:
passwd: all authentication tokens updated successfully.
*/

[root@rac1/rac2 ~]# su - oracle
[root@rac1/rac2 ~]# su - grid


-- Step 43 -->> On both Node
--Create the Oracle Inventory Director:
[root@rac1/rac2 ~]# mkdir -p /opt/app/oraInventory
[root@rac1/rac2 ~]# chown -R grid:oinstall /opt/app/oraInventory
[root@rac1/rac2 ~]# chmod -R 775 /opt/app/oraInventory

-- Step 44 -->> On both Node
--Creating the Oracle Grid Infrastructure Home Directory:
[root@rac1/rac2 ~]# mkdir -p /opt/app/19c/grid
[root@rac1/rac2 ~]# chown -R grid:oinstall /opt/app/19c/grid
[root@rac1/rac2 ~]# chmod -R 775 /opt/app/19c/grid

-- Step 45 -->> On both Node
--Creating the Oracle Base Directory
[root@rac1/rac2 ~]# mkdir -p /opt/app/oracle
[root@rac1/rac2 ~]# chmod -R 775 /opt/app/oracle
[root@rac1/rac2 ~]# cd /opt/app/
[root@rac1/rac2 ~]# chown -R oracle:oinstall /opt/app/oracle

-- Step 46 -->> On Node 1
-- Login as the oracle user and add the following lines at the end of the ".bash_profile" file.
[root@rac1 ~]# su - oracle
[oracle@rac1 ~]$ vim .bash_profile
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

ORACLE_HOSTNAME=rac1.mydomain; export ORACLE_HOSTNAME
ORACLE_UNQNAME=racdb; export ORACLE_UNQNAME
ORACLE_BASE=/opt/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/19c/db_1; export ORACLE_HOME
ORACLE_SID=racdb1; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 47 -->> On Node 1
[oracle@rac1 ~]$ . .bash_profile

-- Step 48 -->> On Node 1
-- Login as the grid user and add the following lines at the end of the ".bash_profile" file.
[root@rac1 ~]# su - grid
[grid@rac1 ~]$ vim .bash_profile
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
[grid@rac1 ~]$ . .bash_profile

-- Step 50 -->> On Node 2
-- Login as the oracle user and add the following lines at the end of the ".bash_profile" file.
[root@rac2 ~]# su - oracle
[oracle@rac2 ~]$ vim .bash_profile
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

ORACLE_HOSTNAME=rac2.mydomain; export ORACLE_HOSTNAME
ORACLE_UNQNAME=racdb; export ORACLE_UNQNAME
ORACLE_BASE=/opt/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/19c/db_1; export ORACLE_HOME
ORACLE_SID=racdb2; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 51 -->> On Node 2
[oracle@rac2 ~]$ . .bash_profile

-- Step 52 -->> On Node 2
-- Login as the grid user and add the following lines at the end of the ".bash_profile" file.
[root@rac2 ~]# su - grid
[grid@rac2 ~]$ vim .bash_profile
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
[grid@rac2 ~]$ . .bash_profile

-- Step 54 -->> On Node 1
-- To Unzio The Oracle Grid Software and lateset Opatch
[root@rac1 ~]# cd /opt/app/19c/grid/
[root@rac1 grid]# unzip -oq /root/19.3.0.0.0/LINUX.X64_193000_grid_home.zip
[root@rac1 grid]# unzip -oq /root/PSU_19.7.0.0.0/p6880880_190000_LINUX.zip

-- Step 55 -->> On Node 1
-- To Unzio The Oracle PSU
[root@rac1 ~]# cd /tmp/
[root@rac1 tmp]# unzip -oq /root/PSU_19.7.0.0.0/p30783556_190000_Linux-x86-64.zip
[root@rac1 tmp]# chown -R oracle:oinstall 30783556
[root@rac2 tmp]# chmod -R 775 30783556
[root@rac1 tmp]# ls -ltr | grep 30783556
/*
drwxrwxrwx  4 oracle oinstall   4096 Apr 14 20:35 30783556
*/

-- Step 56 -->> On Node 1
-- Login as root user and issue the following command at rac1
[root@rac1 ~]# chown -R grid:oinstall /opt/app/19c/grid/
[root@rac1 ~]# chmod -R 775 /opt/app/19c/grid/

-- Step 57 -->> On Node 1
[root@rac1 ~]# scp -r /opt/app/19c/grid/cv/rpm/cvuqdisk-1.0.10-1.rpm root@rac2:/tmp/
/*
The authenticity of host 'rac2 (192.168.1.76)' can't be established.
ECDSA key fingerprint is SHA256:TKeXS9QMOu+IokyrkZb0n210H3jrXWRDADBpAO8wqa4.
ECDSA key fingerprint is MD5:ed:06:ec:98:db:42:dd:71:63:a6:fc:fd:3f:dd:bf:f6.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'rac2,192.168.1.76' (ECDSA) to the list of known hosts.
root@rac2's password:
cvuqdisk-1.0.10-1.rpm                                        100%   11KB   7.2MB/s   00:00
*/

-- Step 58 -->> On Node 1
-- To install the cvuqdisk-1.0.10-1.rpm
-- Login from root user
[root@rac1 ~]# cd /opt/app/19c/grid/cv/rpm/
[root@rac1 rpm]# ls -ltr
/*
-rwxrwxr-x 1 grid oinstall 8551 Sep 22  2011 cvuqdisk-1.0.10-1.rpm
*/

[root@rac1 rpm]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP
[root@rac1 rpm]# rpm -iUvh cvuqdisk-1.0.10-1.rpm 
/*
Preparing...                          ################################# [100%]
Updating / installing...
   1:cvuqdisk-1.0.10-1                ################################# [100%]
*/

-- Step 59 -->> On Node 2
[root@rac2 ~]# cd /tmp/
[root@rac2 tmp]# chown -R grid:oinstall cvuqdisk-1.0.10-1.rpm
[root@rac2 tmp]# chmod -R 775 cvuqdisk-1.0.10-1.rpm
[root@rac2 tmp]# ls -ltr | grep cvuqdisk-1.0.10-1.rpm
/*
-rwxrwxr-x  1 grid   oinstall 11412 Jul 24 11:17 cvuqdisk-1.0.10-1.rpm
*/

-- Step 60 -->> On Node 2
-- To install the cvuqdisk-1.0.10-1.rpm
-- Login from root user
[root@rac2 ~]# cd /tmp/
[root@rac2 tmp]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP
[root@rac2 tmp]# rpm -iUvh cvuqdisk-1.0.10-1.rpm 
/*
Preparing...                          ################################# [100%]
Updating / installing...
   1:cvuqdisk-1.0.10-1                ################################# [100%]
*/

-- Step 61 -->> On all Node
[root@rac1/rac2 ~]# which oracleasm
/*
/usr/sbin/oracleasm
*/

-- Step 62 -->> On all Node
[root@rac1/rac2 ~]# oracleasm configure
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
[root@rac1/rac2 ~]# oracleasm status
/*
Checking if ASM is loaded: no
Checking if /dev/oracleasm is mounted: no
*/

-- Step 64 -->> On all Node
[root@rac1/rac2 ~]# oracleasm configure -i
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
[root@rac1/rac2 ~]# oracleasm configure
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
[root@rac1/rac2 ~]# oracleasm init
/*
Creating /dev/oracleasm mount point: /dev/oracleasm
Loading module "oracleasm": oracleasm
Configuring "oracleasm" to use device physical block size
Mounting ASMlib driver filesystem: /dev/oracleasm
*/

-- Step 67 -->> On all Node
[root@rac1/rac2 ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 68 -->> On all Node
[root@rac1/rac2 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 69 -->> On all Node
[root@rac1/rac2 ~]# oracleasm listdisks

[root@rac1/rac2 ~]# ls -ltr /etc/init.d/
/*
-rwxr-xr-x  1 root root  4954 Feb  3  2018 oracleasm
-rwxr-xr-x. 1 root root  2437 Feb  6  2018 rhnsd
-rwxr-xr-x. 1 root root  4569 Aug 19  2019 netconsole
-rw-r--r--. 1 root root 18281 Aug 19  2019 functions
-rwx------  1 root root  1281 Mar 12  2020 oracle-database-preinstall-19c-firstboot
-rwxr-xr-x. 1 root root  9198 Apr  7 23:42 network
-rw-r--r--  1 root root  1160 Aug  6 23:34 README
*/

-- Step 70 -->> On Both Node
[root@rac1/rac2 ~]# ls -ltr /dev/oracleasm/disks/
/*
total 0
*/

-- Step 71 -->> On Both Node
[root@rac1/rac2 ~]# ls -ltr /dev/sd*
/*
brw-rw---- 1 root disk 8, 48 Sep  3 13:59 /dev/sdd
brw-rw---- 1 root disk 8, 16 Sep  3 13:59 /dev/sdb
brw-rw---- 1 root disk 8, 32 Sep  3 13:59 /dev/sdc
brw-rw---- 1 root disk 8,  0 Sep  3 13:59 /dev/sda
brw-rw---- 1 root disk 8,  8 Sep  3 13:59 /dev/sda8
brw-rw---- 1 root disk 8,  4 Sep  3 13:59 /dev/sda4
brw-rw---- 1 root disk 8,  3 Sep  3 13:59 /dev/sda3
brw-rw---- 1 root disk 8,  5 Sep  3 13:59 /dev/sda5
brw-rw---- 1 root disk 8,  9 Sep  3 13:59 /dev/sda9
brw-rw---- 1 root disk 8,  6 Sep  3 13:59 /dev/sda6
brw-rw---- 1 root disk 8,  7 Sep  3 13:59 /dev/sda7
brw-rw---- 1 root disk 8,  2 Sep  3 13:59 /dev/sda2
brw-rw---- 1 root disk 8,  1 Sep  3 13:59 /dev/sda1
*/

-- Step 72 -->> On Node 1
[root@rac1 ~]# fdisk -ll
/*
Disk /dev/sda: 220.1 GB, 220117073920 bytes, 429916160 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x0000db4b

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048    20973567    10485760   83  Linux
/dev/sda2        20973568   188733439    83879936   83  Linux
/dev/sda3       188733440   293591039    52428800   83  Linux
/dev/sda4       293591040   429916159    68162560    5  Extended
/dev/sda5       293595136   325052415    15728640   83  Linux
/dev/sda6       325054464   356511743    15728640   83  Linux
/dev/sda7       356513792   387971071    15728640   83  Linux
/dev/sda8       387973120   408944639    10485760   83  Linux
/dev/sda9       408946688   429916159    10484736   82  Linux swap / Solaris

Disk /dev/sdc: 85.9 GB, 85899345920 bytes, 167772160 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sdd: 53.7 GB, 53687091200 bytes, 104857600 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

*/

-- Step 73 -->> On Node 1
[root@rac1 ~]# fdisk /dev/sdb
/*
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0x7b887cad.

Command (m for help): p

Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x7b887cad

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
Disk identifier: 0x7b887cad

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048    41943039    20970496   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 74 -->> On Node 1
[root@rac1 ~]# fdisk  /dev/sdc
/*
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0xc274eecb.

Command (m for help): p

Disk /dev/sdc: 85.9 GB, 85899345920 bytes, 167772160 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0xc274eecb

   Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-167772159, default 2048):
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-167772159, default 167772159):
Using default value 167772159
Partition 1 of type Linux and of size 80 GiB is set

Command (m for help): p

Disk /dev/sdc: 85.9 GB, 85899345920 bytes, 167772160 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0xc274eecb

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1            2048   167772159    83885056   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 75 -->> On Node 1
[root@rac1 ~]# fdisk /dev/sdd
/*
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0x351dc42b.

Command (m for help): p

Disk /dev/sdd: 53.7 GB, 53687091200 bytes, 104857600 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x351dc42b

   Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-104857599, default 2048):
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-104857599, default 104857599):
Using default value 104857599
Partition 1 of type Linux and of size 50 GiB is set

Command (m for help): p

Disk /dev/sdd: 53.7 GB, 53687091200 bytes, 104857600 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x351dc42b

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1            2048   104857599    52427776   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 76 -->> On Node 1
[root@rac1 ~]# ls -ltr /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Sep  3 13:59 /dev/sda
brw-rw---- 1 root disk 8,  8 Sep  3 13:59 /dev/sda8
brw-rw---- 1 root disk 8,  4 Sep  3 13:59 /dev/sda4
brw-rw---- 1 root disk 8,  3 Sep  3 13:59 /dev/sda3
brw-rw---- 1 root disk 8,  5 Sep  3 13:59 /dev/sda5
brw-rw---- 1 root disk 8,  9 Sep  3 13:59 /dev/sda9
brw-rw---- 1 root disk 8,  6 Sep  3 13:59 /dev/sda6
brw-rw---- 1 root disk 8,  7 Sep  3 13:59 /dev/sda7
brw-rw---- 1 root disk 8,  2 Sep  3 13:59 /dev/sda2
brw-rw---- 1 root disk 8,  1 Sep  3 13:59 /dev/sda1
brw-rw---- 1 root disk 8, 16 Sep  3 14:10 /dev/sdb
brw-rw---- 1 root disk 8, 17 Sep  3 14:10 /dev/sdb1
brw-rw---- 1 root disk 8, 32 Sep  3 14:11 /dev/sdc
brw-rw---- 1 root disk 8, 33 Sep  3 14:11 /dev/sdc1
brw-rw---- 1 root disk 8, 48 Sep  3 14:12 /dev/sdd
brw-rw---- 1 root disk 8, 49 Sep  3 14:12 /dev/sdd1
*/

-- Step 77 -->> On Both Node
[root@rac1/rac2 ~]# fdisk -ll
/*

Disk /dev/sda: 220.1 GB, 220117073920 bytes, 429916160 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x0000db4b

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048    20973567    10485760   83  Linux
/dev/sda2        20973568   188733439    83879936   83  Linux
/dev/sda3       188733440   293591039    52428800   83  Linux
/dev/sda4       293591040   429916159    68162560    5  Extended
/dev/sda5       293595136   325052415    15728640   83  Linux
/dev/sda6       325054464   356511743    15728640   83  Linux
/dev/sda7       356513792   387971071    15728640   83  Linux
/dev/sda8       387973120   408944639    10485760   83  Linux
/dev/sda9       408946688   429916159    10484736   82  Linux swap / Solaris

Disk /dev/sdc: 85.9 GB, 85899345920 bytes, 167772160 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x7024a86d

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1            2048   167772159    83885056   83  Linux

Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x609ffd99

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048    41943039    20970496   83  Linux

Disk /dev/sdd: 53.7 GB, 53687091200 bytes, 104857600 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x0ff80c58

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1            2048   104857599    52427776   83  Linux

*/

-- Step 78 -->> On Node 1
[root@rac1 ~]# mkfs.ext4 /dev/sdb1
[root@rac1 ~]# mkfs.ext4 /dev/sdc1
[root@rac1 ~]# mkfs.ext4 /dev/sdd1

-- Step 79 -->> On Node 1
[root@rac1 ~]# oracleasm createdisk OCR /dev/sdb1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 80 -->> On Node 1
[root@rac1 ~]# oracleasm createdisk DATA /dev/sdc1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 81 -->> On Node 1
[root@rac1 ~]# oracleasm createdisk ARC /dev/sdd1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 82 -->> On Node 1
[root@rac1 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 83 -->> On Node 1
[root@rac1 ~]# oracleasm listdisks
/*
ARC
DATA
OCR
*/

-- Step 84 -->> On Node 2
[root@rac2 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
Instantiating disk "OCR"
Instantiating disk "ARC"
Instantiating disk "DATA"
*/

-- Step 85 -->> On Node 2
[root@rac2 ~]# oracleasm listdisks
/*
ARC
DATA
OCR
*/

-- Step 86 -->> On Both Node
[root@rac1/rac2 ~]# ls -ltr /dev/oracleasm/disks/
/*
brw-rw---- 1 grid asmadmin 8, 17 Sep  3 14:18 OCR
brw-rw---- 1 grid asmadmin 8, 33 Sep  3 14:18 DATA
brw-rw---- 1 grid asmadmin 8, 49 Sep  3 14:18 ARC
*/

-- Step 87 -->> On Node 1
-- To setup SSH Pass
[root@rac1 ~]# su - grid
[grid@rac1 ~]$ cd /opt/app/19c/grid/deinstall
[grid@rac1 deinstall]$ ./sshUserSetup.sh -user grid -hosts "rac1 rac2" -noPromptPassphrase -confirm -advanced

-- Step 88 -->> On Node 1
[grid@rac1/rac2 ~]$ ssh grid@rac1 date
[grid@rac1/rac2 ~]$ ssh grid@rac2 date
[grid@rac1/rac2 ~]$ ssh grid@rac1 date && ssh grid@rac2 date
[grid@rac1/rac2 ~]$ ssh grid@rac1.mydomain date
[grid@rac1/rac2 ~]$ ssh grid@rac2.mydomain date
[grid@rac1/rac2 ~]$ ssh grid@rac1.mydomain date && ssh grid@rac2.mydomain date

-- Step 89 -->> On Node 1
-- Pre-check for rac Setup
[grid@rac1 ~]$ cd /opt/app/19c/grid/
[grid@rac1 grid]$ ./runcluvfy.sh stage -pre crsinst -n rac1,rac2 -verbose
[grid@rac1 grid]$ ./runcluvfy.sh stage -pre crsinst -n rac1,rac2 -method root
--[grid@rac1 grid]$ ./runcluvfy.sh stage -pre crsinst -n rac1,rac2 -fixup -verbose (If Required)

-- Step 90 -->> On Node 1
-- To Create a Response File to Install GID
[grid@rac1 ~]$ cp /opt/app/19c/grid/install/response/gridsetup.rsp /home/grid/
[grid@rac1 ~]$ cd /home/grid/
[grid@rac1 ~]$ ls -ltr | grep gridsetup.rsp
/*
-rwxr-xr-x 1 grid oinstall 36221 Sep 17 12:35 gridsetup.rsp
*/
[root@rac1 grid]# vim gridsetup.rsp
/*
oracle.install.responseFileVersion=/oracle/install/rspfmt_crsinstall_response_schema_v19.0.0
INVENTORY_LOCATION=/opt/app/oraInventory
oracle.install.option=CRS_CONFIG
ORACLE_BASE=/opt/app/oracle
oracle.install.asm.OSDBA=asmdba
oracle.install.asm.OSOPER=asmoper
oracle.install.asm.OSASM=asmadmin
oracle.install.crs.config.scanType=LOCAL_SCAN
oracle.install.crs.config.gpnp.scanName=rac-scan
oracle.install.crs.config.gpnp.scanPort=1521
oracle.install.crs.config.ClusterConfiguration=STANDALONE
oracle.install.crs.config.configureAsExtendedCluster=false
oracle.install.crs.config.clusterName=rac-cluster
oracle.install.crs.config.gpnp.configureGNS=false
oracle.install.crs.config.autoConfigureClusterNodeVIP=false
oracle.install.crs.config.clusterNodes=rac1:rac1-vip,rac2:rac2-vip
oracle.install.crs.config.networkInterfaceList=ens192:192.168.1.0:1,ens224:192.0.1.0:5
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
[grid@rac1 ~]$ cd /opt/app/19c/grid/
[grid@rac1 grid]$ ./gridSetup.sh -ignorePrereq -waitForCompletion -silent -applyRU /tmp/30783556/30899722 -responseFile /home/grid/gridsetup.rsp
/*
Preparing the home to patch...
Applying the patch /tmp/30783556/30899722...
Successfully applied the patch.
The log can be found at: /tmp/GridSetupActions2020-09-20_12-30-32PM/installerPatchActions_2020-09-20_12-30-32PM.log
Launching Oracle Grid Infrastructure Setup Wizard...

[WARNING] [INS-13014] Target environment does not meet some optional requirements.
   CAUSE: Some of the optional prerequisites are not met. See logs for details. gridSetupActions2020-09-20_12-30-32PM.log
   ACTION: Identify the list of failed prerequisite checks from the log: gridSetupActions2020-09-20_12-30-32PM.log. Then either from the log file or from installation manual find the appropriate configuration to meet the prerequisites and fix it manually.
The response file for this session can be found at:
 /opt/app/19c/grid/install/response/grid_2020-09-20_12-30-32PM.rsp

You can find the log of this install session at:
 /tmp/GridSetupActions2020-09-20_12-30-32PM/gridSetupActions2020-09-20_12-30-32PM.log

As a root user, execute the following script(s):
        1. /opt/app/oraInventory/orainstRoot.sh
        2. /opt/app/19c/grid/root.sh

Execute /opt/app/oraInventory/orainstRoot.sh on the following nodes:
[rac1, rac2]
Execute /opt/app/19c/grid/root.sh on the following nodes:
[rac1, rac2]

Run the script on the local node first. After successful completion, you can start the script in parallel on all other nodes.

Successfully Setup Software with warning(s).
As install user, execute the following command to complete the configuration.
        /opt/app/19c/grid/gridSetup.sh -executeConfigTools -responseFile /home/grid/gridsetup.rsp [-silent]


Moved the install session logs to:
 /opt/app/oraInventory/logs/GridSetupActions2020-09-20_12-30-32PM

*/

-- Step 92 -->> On Node 1
[root@rac1 ~]# /opt/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 93 -->> On Node 2
[root@rac2 ~]# /opt/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 94 -->> On Node 1
[root@rac1 ~]# /opt/app/19c/grid/root.sh
/*
Check /opt/app/19c/grid/install/root_rac1.mydomain_2020-09-20_12-45-52-422635885.log for the output of root script
*/

[root@rac1 ~]# tail -f /opt/app/19c/grid/install/root_rac1.mydomain_2020-09-20_12-45-52-422635885.log
/*
Creating /etc/oratab file...
Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Relinking oracle with rac_on option
Using configuration parameter file: /opt/app/19c/grid/crs/install/crsconfig_params
The log of current session can be found at:
  /opt/app/oracle/crsdata/rac1/crsconfig/rootcrs_rac1_2020-09-20_12-46-08AM.log
2020/09/20 12:46:18 CLSRSC-594: Executing installation step 1 of 19: 'SetupTFA'.
2020/09/20 12:46:18 CLSRSC-594: Executing installation step 2 of 19: 'ValidateEnv'.
2020/09/20 12:46:19 CLSRSC-363: User ignored prerequisites during installation
2020/09/20 12:46:19 CLSRSC-594: Executing installation step 3 of 19: 'CheckFirstNode'.
2020/09/20 12:46:21 CLSRSC-594: Executing installation step 4 of 19: 'GenSiteGUIDs'.
2020/09/20 12:46:22 CLSRSC-594: Executing installation step 5 of 19: 'SetupOSD'.
2020/09/20 12:46:22 CLSRSC-594: Executing installation step 6 of 19: 'CheckCRSConfig'.
2020/09/20 12:46:23 CLSRSC-594: Executing installation step 7 of 19: 'SetupLocalGPNP'.
2020/09/20 12:46:42 CLSRSC-594: Executing installation step 8 of 19: 'CreateRootCert'.
2020/09/20 12:46:47 CLSRSC-594: Executing installation step 9 of 19: 'ConfigOLR'.
2020/09/20 12:47:03 CLSRSC-4002: Successfully installed Oracle Trace File Analyzer (TFA) Collector.
2020/09/20 12:47:05 CLSRSC-594: Executing installation step 10 of 19: 'ConfigCHMOS'.
2020/09/20 12:47:05 CLSRSC-594: Executing installation step 11 of 19: 'CreateOHASD'.
2020/09/20 12:47:12 CLSRSC-594: Executing installation step 12 of 19: 'ConfigOHASD'.
2020/09/20 12:47:13 CLSRSC-330: Adding Clusterware entries to file 'oracle-ohasd.service'
2020/09/20 12:47:39 CLSRSC-594: Executing installation step 13 of 19: 'InstallAFD'.
2020/09/20 12:47:39 CLSRSC-594: Executing installation step 14 of 19: 'InstallACFS'.
2020/09/20 12:49:04 CLSRSC-594: Executing installation step 15 of 19: 'InstallKA'.
2020/09/20 12:49:10 CLSRSC-594: Executing installation step 16 of 19: 'InitConfig'.
Redirecting to /bin/systemctl restart rsyslog.service

ASM has been created and started successfully.

[DBT-30001] Disk groups created successfully. Check /opt/app/oracle/cfgtoollogs/asmca/asmca-200920PM124945.log for details.

2020/09/20 12:50:39 CLSRSC-482: Running command: '/opt/app/19c/grid/bin/ocrconfig -upgrade grid oinstall'
CRS-4256: Updating the profile
Successful addition of voting disk 3e71729c8bc34f70bfd954cf3231a962.
Successfully replaced voting disk group with +OCR.
CRS-4256: Updating the profile
CRS-4266: Voting file(s) successfully replaced
##  STATE    File Universal Id                File Name Disk group
--  -----    -----------------                --------- ---------
 1. ONLINE   3e71729c8bc34f70bfd954cf3231a962 (/dev/oracleasm/disks/OCR) [OCR]
Located 1 voting disk(s).
2020/09/20 12:51:46 CLSRSC-594: Executing installation step 17 of 19: 'StartCluster'.
2020/09/20 12:52:52 CLSRSC-343: Successfully started Oracle Clusterware stack
2020/09/20 12:52:52 CLSRSC-594: Executing installation step 18 of 19: 'ConfigNode'.
2020/09/20 12:54:13 CLSRSC-594: Executing installation step 19 of 19: 'PostConfig'.
2020/09/20 12:54:39 CLSRSC-325: Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 95 -->> On Node 2
[root@rac2 ~]# /opt/app/19c/grid/root.sh
/*
Check /opt/app/19c/grid/install/root_rac2.mydomain_2020-09-20_12-55-28-725889958.log for the output of root script
*/

[root@rac2 ~]# tail -f /opt/app/19c/grid/install/root_rac2.mydomain_2020-09-20_12-55-28-725889958.log
/*
Creating /etc/oratab file...
Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Relinking oracle with rac_on option
Using configuration parameter file: /opt/app/19c/grid/crs/install/crsconfig_params
The log of current session can be found at:
  /opt/app/oracle/crsdata/rac2/crsconfig/rootcrs_rac1_2020-09-20_12-57-19AM.log -46-08AM.log
2020/09/20 12:55:52 CLSRSC-594: Executing installation step 1 of 19: 'SetupTFA'.
2020/09/20 12:55:52 CLSRSC-594: Executing installation step 2 of 19: 'ValidateEnv'.
2020/09/20 12:55:52 CLSRSC-363: User ignored prerequisites during installation
2020/09/20 12:55:52 CLSRSC-594: Executing installation step 3 of 19: 'CheckFirstNode'.
2020/09/20 12:55:53 CLSRSC-594: Executing installation step 4 of 19: 'GenSiteGUIDs'.
2020/09/20 12:55:54 CLSRSC-594: Executing installation step 5 of 19: 'SetupOSD'.
2020/09/20 12:55:54 CLSRSC-594: Executing installation step 6 of 19: 'CheckCRSConfig'.
2020/09/20 12:55:55 CLSRSC-594: Executing installation step 7 of 19: 'SetupLocalGPNP'.
2020/09/20 12:55:56 CLSRSC-594: Executing installation step 8 of 19: 'CreateRootCert'.
2020/09/20 12:55:56 CLSRSC-594: Executing installation step 9 of 19: 'ConfigOLR'.
2020/09/20 12:56:08 CLSRSC-594: Executing installation step 10 of 19: 'ConfigCHMOS'.
2020/09/20 12:56:08 CLSRSC-594: Executing installation step 11 of 19: 'CreateOHASD'.
2020/09/20 12:56:10 CLSRSC-594: Executing installation step 12 of 19: 'ConfigOHASD'.
2020/09/20 12:56:10 CLSRSC-330: Adding Clusterware entries to file 'oracle-ohasd.service'
2020/09/20 12:56:31 CLSRSC-594: Executing installation step 13 of 19: 'InstallAFD'.
2020/09/20 12:56:31 CLSRSC-594: Executing installation step 14 of 19: 'InstallACFS'.
2020/09/20 12:56:40 CLSRSC-4002: Successfully installed Oracle Trace File Analyzer (TFA) Collector.
2020/09/20 12:58:04 CLSRSC-594: Executing installation step 15 of 19: 'InstallKA'.
2020/09/20 12:58:06 CLSRSC-594: Executing installation step 16 of 19: 'InitConfig'.
Redirecting to /bin/systemctl restart rsyslog.service
2020/09/20 12:58:15 CLSRSC-594: Executing installation step 17 of 19: 'StartCluster'.
2020/09/20 12:59:00 CLSRSC-343: Successfully started Oracle Clusterware stack
2020/09/20 12:59:00 CLSRSC-594: Executing installation step 18 of 19: 'ConfigNode'.
2020/09/20 12:59:13 CLSRSC-594: Executing installation step 19 of 19: 'PostConfig'.
2020/09/20 12:59:18 CLSRSC-325: Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 96 -->> On Node 1
[grid@rac1 ~]$ cd /opt/app/19c/grid/
[grid@rac1 grid]$ /opt/app/19c/grid/gridSetup.sh -silent -executeConfigTools -responseFile /home/grid/gridsetup.rsp
/*
Launching Oracle Grid Infrastructure Setup Wizard...

You can find the logs of this session at:
/opt/app/oraInventory/logs/GridSetupActions2020-09-20_01-01-44PM

You can find the log of this install session at:
 /opt/app/oraInventory/logs/UpdateNodeList2020-09-20_01-01-44PM.log
Successfully Configured Software.
*/

[root@rac1 ~]# tail -f  /opt/app/oraInventory/logs/UpdateNodeList2020-09-20_01-01-44PM.log
/*
INFO: All threads completed its operations
INFO: Checkpoint:Index file written and updated
INFO: Done calling doOperation.
INFO: 'UpdateNodeList' was successful.
*/

-- Step 97 -->> On Both Nodes
[root@rac1/rac2 ~]# cd /opt/app/19c/grid/bin/
[root@rac1/rac2 bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/


-- Step 98 -->> On Both Nodes
[root@rac1 bin]# ./crsctl check cluster -all
/*
**************************************************************
rac1:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
rac2:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/

-- Step 99 -->> On Node 1
[root@rac1 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       rac1                     Started,STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       rac1                     STABLE
ora.crf
      1        ONLINE  ONLINE       rac1                     STABLE
ora.crsd
      1        ONLINE  ONLINE       rac1                     STABLE
ora.cssd
      1        ONLINE  ONLINE       rac1                     STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       rac1                     STABLE
ora.ctssd
      1        ONLINE  ONLINE       rac1                     OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.evmd
      1        ONLINE  ONLINE       rac1                     STABLE
ora.gipcd
      1        ONLINE  ONLINE       rac1                     STABLE
ora.gpnpd
      1        ONLINE  ONLINE       rac1                     STABLE
ora.mdnsd
      1        ONLINE  ONLINE       rac1                     STABLE
ora.storage
      1        ONLINE  ONLINE       rac1                     STABLE
--------------------------------------------------------------------------------
*/


-- Step 100 -->> On Node 2
[root@rac2 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       rac2                     STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       rac2                     STABLE
ora.crf
      1        ONLINE  ONLINE       rac2                     STABLE
ora.crsd
      1        ONLINE  ONLINE       rac2                     STABLE
ora.cssd
      1        ONLINE  ONLINE       rac2                     STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       rac2                     STABLE
ora.ctssd
      1        ONLINE  ONLINE       rac2                     OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.evmd
      1        ONLINE  ONLINE       rac2                     STABLE
ora.gipcd
      1        ONLINE  ONLINE       rac2                     STABLE
ora.gpnpd
      1        ONLINE  ONLINE       rac2                     STABLE
ora.mdnsd
      1        ONLINE  ONLINE       rac2                     STABLE
ora.storage
      1        ONLINE  ONLINE       rac2                     STABLE
--------------------------------------------------------------------------------
*/

-- Step 101 -->> On Both Nodes
[root@rac1/rac2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       rac1                     STABLE
               ONLINE  ONLINE       rac2                     STABLE
ora.chad
               ONLINE  ONLINE       rac1                     STABLE
               ONLINE  ONLINE       rac2                     STABLE
ora.net1.network
               ONLINE  ONLINE       rac1                     STABLE
               ONLINE  ONLINE       rac2                     STABLE
ora.ons
               ONLINE  ONLINE       rac1                     STABLE
               ONLINE  ONLINE       rac2                     STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       rac1                     STABLE
      2        ONLINE  ONLINE       rac2                     STABLE
      3        ONLINE  OFFLINE                               STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       rac2                     STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       rac1                     STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       rac1                     STABLE
      2        ONLINE  ONLINE       rac2                     STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       rac1                     Started,STABLE
      2        ONLINE  ONLINE       rac2                     Started,STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       rac1                     STABLE
      2        ONLINE  ONLINE       rac2                     STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.cvu
      1        ONLINE  ONLINE       rac1                     STABLE
ora.qosmserver
      1        ONLINE  ONLINE       rac1                     STABLE
ora.rac1.vip
      1        ONLINE  ONLINE       rac1                     STABLE
ora.rac2.vip
      1        ONLINE  ONLINE       rac2                     STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       rac2                     STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       rac1                     STABLE
--------------------------------------------------------------------------------
*/


-- Step 102 -->> On Both Nodes
[grid@rac1/rac2 ~]$ asmcmd
/*
ASMCMD> lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20140                0           20140              0             Y  OCR/
ASMCMD> exit
*/

-- Step 103 -->> On Both Nodes
[grid@rac1/rac2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 20-SEP-2020 13:07:44

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                20-SEP-2020 12:54:31
Uptime                    0 days 0 hr. 13 min. 12 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/rac1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.75)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.77)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1/+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1/+ASM2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/


-- Step 104 -->> On Node 1
-- To Create ASM storage for Data and Archive
[grid@rac1 ~]$ cd /opt/app/19c/grid/bin
[grid@rac1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName DATA -diskList /dev/oracleasm/disks/DATA -redundancy EXTERNAL
[grid@rac1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName ARC -diskList /dev/oracleasm/disks/ARC -redundancy EXTERNAL

-- Step 105 -->> On Both Nodes
[grid@rac1/rac2 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Sep 20 13:15:19 2020
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> set lines 200;
SQL> COLUMN name FORMAT A30
SQL> SELECT inst_id,name,state,type,compatibility,database_compatibility,voting_files from gv$asm_diskgroup order by name;

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
SQL> select name,path, group_number group_#, disk_number disk_#, mount_status,header_status, state, total_mb, free_mb from v$asm_disk order by group_number;

NAME      PATH                         GROUP_#     DISK_# MOUNT_S HEADER_STATU STATE      TOTAL_MB    FREE_MB
--------- ------------------------- ---------- ---------- ------- ------------ -------- ---------- ----------
OCR_0000  /dev/oracleasm/disks/OCR           1          0 CACHED  MEMBER       NORMAL        20476      20140
DATA_0000 /dev/oracleasm/disks/DATA          2          0 CACHED  MEMBER       NORMAL        81919      81815
ARC_0000  /dev/oracleasm/disks/ARC           3          0 CACHED  MEMBER       NORMAL        51199      51095

SQL> set lines 200;
SQL> col BANNER_FULL format a80;
SQL> col BANNER_LEGACY format a80;
SQL> SELECT INST_ID,BANNER_FULL,BANNER_LEGACY,CON_ID FROM gv$version;

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

-- Or --

[grid@rac1 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Sep 20 13:15:19 2020
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> set lines 200;
SQL> COLUMN name FORMAT A30
SQL> SELECT inst_id,name,state,type,compatibility,database_compatibility,voting_files from gv$asm_diskgroup order by name;

   INST_ID NAME STATE   TYPE   COMPATIBILITY DATABASE_COMPATIBILITY V
---------- ---- ------- ------ ------------- ---------------------- -
         2 OCR  MOUNTED EXTERN 19.0.0.0.0    10.1.0.0.0             Y
         1 OCR  MOUNTED EXTERN 19.0.0.0.0    10.1.0.0.0             Y

SQL> CREATE DISKGROUP DATA EXTERNAL REDUNDANCY DISK '/dev/oracleasm/disks/DATA' ATTRIBUTE 'compatible.asm'='19.0','compatible.rdbms'='19.0';

Diskgroup created.

SQL> CREATE DISKGROUP ARC EXTERNAL REDUNDANCY DISK '/dev/oracleasm/disks/ARC' ATTRIBUTE 'compatible.asm'='19.0','compatible.rdbms'='19.0';

Diskgroup created.

SQL> set lines 200;
SQL> COLUMN name FORMAT A30
SQL> SELECT inst_id,name,state,type,compatibility,database_compatibility,voting_files from gv$asm_diskgroup order by name;

   INST_ID NAME STATE   TYPE   COMPATIBILITY DATABASE_COMPATIBILITY V
---------- ---- ------- ------ ------------- ---------------------- -
         1 ARC  MOUNTED EXTERN 19.0.0.0.0    19.0.0.0.0             N
         2 ARC  MOUNTED EXTERN 19.0.0.0.0    19.0.0.0.0             N
         2 DATA MOUNTED EXTERN 19.0.0.0.0    19.0.0.0.0             N
         1 DATA MOUNTED EXTERN 19.0.0.0.0    19.0.0.0.0             N
         2 OCR  MOUNTED EXTERN 19.0.0.0.0    10.1.0.0.0             Y
         1 OCR  MOUNTED EXTERN 19.0.0.0.0    10.1.0.0.0             Y

SQL> set lines 200;
SQL> col path format a40;
SQL> select name,path, group_number group_#, disk_number disk_#, mount_status,header_status, state, total_mb, free_mb from v$asm_disk order by group_number;

NAME      PATH                         GROUP_#     DISK_# MOUNT_S HEADER_STATU STATE      TOTAL_MB    FREE_MB
--------- ------------------------- ---------- ---------- ------- ------------ -------- ---------- ----------
OCR_0000  /dev/oracleasm/disks/OCR           1          0 CACHED  MEMBER       NORMAL        20476      20140
DATA_0000 /dev/oracleasm/disks/DATA          2          0 CACHED  MEMBER       NORMAL        81919      81815
ARC_0000  /dev/oracleasm/disks/ARC           3          0 CACHED  MEMBER       NORMAL        51199      51095

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
[root@rac1/rac2 ~]# cd /opt/app/19c/grid/bin
[root@rac1/rac2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       rac1                     STABLE
               ONLINE  ONLINE       rac2                     STABLE
ora.chad
               ONLINE  ONLINE       rac1                     STABLE
               ONLINE  ONLINE       rac2                     STABLE
ora.net1.network
               ONLINE  ONLINE       rac1                     STABLE
               ONLINE  ONLINE       rac2                     STABLE
ora.ons
               ONLINE  ONLINE       rac1                     STABLE
               ONLINE  ONLINE       rac2                     STABLE
ora.proxy_advm
               OFFLINE OFFLINE      rac1                     STABLE
               OFFLINE OFFLINE      rac2                     STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ARC.dg(ora.asmgroup)
      1        ONLINE  ONLINE       rac1                     STABLE
      2        ONLINE  ONLINE       rac2                     STABLE
      3        ONLINE  OFFLINE                               STABLE
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       rac1                     STABLE
      2        ONLINE  ONLINE       rac2                     STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.DATA.dg(ora.asmgroup)
      1        ONLINE  ONLINE       rac1                     STABLE
      2        ONLINE  ONLINE       rac2                     STABLE
      3        ONLINE  OFFLINE                               STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       rac2                     STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       rac1                     STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       rac1                     STABLE
      2        ONLINE  ONLINE       rac2                     STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       rac1                     Started,STABLE
      2        ONLINE  ONLINE       rac2                     Started,STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       rac1                     STABLE
      2        ONLINE  ONLINE       rac2                     STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.cvu
      1        ONLINE  ONLINE       rac1                     STABLE
ora.qosmserver
      1        ONLINE  ONLINE       rac1                     STABLE
ora.rac1.vip
      1        ONLINE  ONLINE       rac1                     STABLE
ora.rac2.vip
      1        ONLINE  ONLINE       rac2                     STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       rac2                     STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       rac1                     STABLE
--------------------------------------------------------------------------------
*/

-- Step 107 -->> On Both Nodes
[grid@rac1/rac2 ~]$ asmcmd
/*
ASMCMD> lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  1048576     51199    51101                0           51101              0             N  ARC/
MOUNTED  EXTERN  N         512             512   4096  1048576     81919    81821                0           81821              0             N  DATA/
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20140                0           20140              0             Y  OCR/
*/

-- Step 108 -->> On Node 1
[root@rac1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/19c/grid:N
*/

-- Step 109 -->> On Node 2
[root@rac2 ~]# vi /etc/oratab
/*
+ASM2:/opt/app/19c/grid:N
*/

-- Step 110 -->> On Both Nodes
-- Creating the Oracle RDBMS Home Directory
[root@rac1/rac2 ~]# mkdir -p /opt/app/oracle/product/19c/db_1
[root@rac1/rac2 ~]# chown -R oracle:oinstall /opt/app/oracle/product/19c/db_1
[root@rac1/rac2 ~]# chmod -R 775 /opt/app/oracle/product/19c/db_1

-- Step 111 -->> On Node 1
-- To unzip the Oracle Binary and Letest Opatch
[root@rac1 ~]# cd /opt/app/oracle/product/19c/db_1
[root@rac1 db_1]# unzip -oq /root/19.3.0.0.0/LINUX.X64_193000_db_home.zip
[root@rac1 db_1]# unzip -oq /root/PSU_19.7.0.0.0/p6880880_190000_LINUX.zip 

[root@rac1 ~]# chown -R oracle:oinstall /opt/app/oracle/product/19c/db_1/
[root@rac1 ~]# chmod -R 775 /opt/app/oracle/product/19c/db_1/

-- Step 112 -->> On Node 1
-- To Setup the SSH Connectivity 
[root@rac1 ~]# su - oracle
[oracle@rac1 ~]$ cd /opt/app/oracle/product/19c/db_1/deinstall/
[oracle@rac1 deinstall]$ ./sshUserSetup.sh -user oracle -hosts "rac1 rac2" -noPromptPassphrase -confirm -advanced

-- Step 113 -->> On Both Nodes
[oracle@rac1/rac2 ~]$ ssh oracle@rac1 date
[oracle@rac1/rac2 ~]$ ssh oracle@rac2 date
[oracle@rac1/rac2 ~]$ ssh oracle@rac1 date && ssh oracle@rac2 date
[oracle@rac1/rac2 ~]$ ssh oracle@rac1.mydomain date
[oracle@rac1/rac2 ~]$ ssh oracle@rac2.mydomain date
[oracle@rac1/rac2 ~]$ ssh oracle@rac1.mydomain date && ssh oracle@rac2.mydomain date

-- Step 114 -->> On Node 1
-- To Create a responce file for Oracle Software Installation
[oracle@rac1 ~]$ cp /opt/app/oracle/product/19c/db_1/install/response/db_install.rsp /home/oracle/
[oracle@rac1 ~]$ cd /home/oracle/
[oracle@rac1 ~]$ ls -ltr
/*
-rwxr-xr-x 1 oracle oinstall 19932 Sep 20 14:56 db_install.rsp
*/
[oracle@rac1 ~]$  vim db_install.rsp
/*
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v19.0.0
oracle.install.option=INSTALL_DB_SWONLY
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/opt/app/oraInventory
ORACLE_HOME=/opt/app/oracle/product/19c/db_1
ORACLE_BASE=/opt/app/oracle
ORACLE_HOSTNAME=rac1.mydomain
SELECTED_LANGUAGES=en
oracle.install.db.InstallEdition=EE
oracle.install.db.OSDBA_GROUP=dba
oracle.install.db.OSOPER_GROUP=oper
oracle.install.db.OSBACKUPDBA_GROUP=backupdba
oracle.install.db.OSDGDBA_GROUP=dgdba
oracle.install.db.OSKMDBA_GROUP=kmdba
oracle.install.db.OSRACDBA_GROUP=racdba
oracle.install.db.rootconfig.executeRootScript=false
oracle.install.db.CLUSTER_NODES=rac1,rac2
oracle.install.db.config.starterdb.type=GENERAL_PURPOSE
oracle.install.db.ConfigureAsContainerDB=false
*/

-- Step 115 -->> On Node 1
-- To install Oracle Software with Letest Opatch
[oracle@rac1 ~]$ cd /opt/app/oracle/product/19c/db_1/
[oracle@rac1 db_1]$ ./runInstaller -ignorePrereq -waitforcompletion -silent \
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
The log can be found at: /opt/app/oraInventory/logs/InstallActions2020-09-20_03-24-28PM/installerPatchActions_2020-09-20_03-24-28PM.log
Launching Oracle Database Setup Wizard...

[WARNING] [INS-13014] Target environment does not meet some optional requirements.
   CAUSE: Some of the optional prerequisites are not met. See logs for details. /opt/app/oraInventory/logs/InstallActions2020-09-20_03-24-28PM/installActions2020-09-20_03-24-28PM.log
   ACTION: Identify the list of failed prerequisite checks from the log: /opt/app/oraInventory/logs/InstallActions2020-09-20_03-24-28PM/installActions2020-09-20_03-24-28PM.log. Then either from the log file or from installation manual find the appropriate configuration to meet the prerequisites and fix it manually.
The response file for this session can be found at:
 /opt/app/oracle/product/19c/db_1/install/response/db_2020-09-20_03-24-28PM.rsp

You can find the log of this install session at:
 /opt/app/oraInventory/logs/InstallActions2020-09-20_03-24-28PM/installActions2020-09-20_03-24-28PM.log

As a root user, execute the following script(s):
        1. /opt/app/oracle/product/19c/db_1/root.sh

Execute /opt/app/oracle/product/19c/db_1/root.sh on the following nodes:
[rac1, rac2]


Successfully Setup Software with warning(s).
*/

-- Step 116 -->> On Node 1
[root@rac1 ~]# /opt/app/oracle/product/19c/db_1/root.sh
/*
Check /opt/app/oracle/product/19c/db_1/install/root_rac1.mydomain_2020-09-20_15-36-52-795621808.log for the output of root script
*/

[root@rac1 ~]# tail -f /opt/app/oracle/product/19c/db_1/install/root_rac1.mydomain_2020-09-20_15-36-52-795621808.log
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
[root@rac2 ~]# /opt/app/oracle/product/19c/db_1/root.sh
/*
Check /opt/app/oracle/product/19c/db_1/install/root_rac2.mydomain_2020-09-20_15-39-32-795397705.log for the output of root script
*/

[root@rac2 ~]# tail -f /opt/app/oracle/product/19c/db_1/install/root_rac2.mydomain_2020-09-20_15-39-32-795397705.log
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
[root@rac1 ~]# export ORACLE_HOME=/opt/app/oracle/product/19c/db_1
[root@rac1 ~]# export PATH=${ORACLE_HOME}/bin:$PATH
[root@rac1 ~]# export PATH=${PATH}:${ORACLE_HOME}/OPatch
[root@rac1 ~]# which opatchauto
/*
/opt/app/oracle/product/19c/db_1/OPatch/opatchauto
*/

-- Step 119 -->> On Node 1
[root@rac1 ~]# opatchauto apply /tmp/30783556/30805684 -oh /opt/app/oracle/product/19c/db_1 --nonrolling
/*
OPatchauto session is initiated at Sun Sep 20 16:07:02 2020

System initialization log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchautodb/systemconfig2020-09-20_04-07-10PM.log.

Session log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/opatchauto2020-09-20_04-07-52PM.log
The id for this session is F6J9

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

Host:rac1
RAC Home:/opt/app/oracle/product/19c/db_1
Version:19.0.0.0.0
Summary:

==Following patches were SUCCESSFULLY applied:

Patch: /tmp/30783556/30805684
Log: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2020-09-20_16-08-11PM_1.log



OPatchauto session completed at Sun Sep 20 16:09:22 2020
Time taken to complete the session 2 minutes, 20 seconds

*/

[root@rac1 ~]# tail -f /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opat       ch2020-09-20_16-08-11PM_1.log
/*
[Sep 20, 2020 4:09:19 PM] [INFO]    Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_s       torage/NApply/2020-09-20_16-08-13PM/make.txt"
[Sep 20, 2020 4:09:19 PM] [INFO]    Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_s       torage/NApply/2020-09-20_15-28-35PM/make.txt"
[Sep 20, 2020 4:09:19 PM] [INFO]    Deleted the directory "/opt/app/oracle/product/19c/db_1/.pa       tch_storage/30805684_Feb_21_2020_20_52_36/backup"
[Sep 20, 2020 4:09:19 PM] [INFO]    [OPSR-TIME] Backup area for restore has been cleaned up. Fo       r a complete list of files/directories
                                    deleted, Please refer log file.
[Sep 20, 2020 4:09:19 PM] [INFO]    Patch 30805684 successfully applied.
[Sep 20, 2020 4:09:19 PM] [INFO]    UtilSession: N-Apply done.
[Sep 20, 2020 4:09:19 PM] [INFO]    Finishing UtilSession at Sun Sep 20 16:09:19 NPT 2020
[Sep 20, 2020 4:09:19 PM] [INFO]    Log file location: /opt/app/oracle/product/19c/db_1/cfgtool       logs/opatchauto/core/opatch/opatch2020-09-20_16-08-11PM_1.log
[Sep 20, 2020 4:09:19 PM] [INFO]    EXITING METHOD: NApply(IAnalysisReport report)
*/

-- Step 120 -->> On Node 1
[root@rac1 ~]# scp -r /tmp/30783556/ root@rac2:/tmp/

-- Step 121 -->> On Node 2
[root@rac2 ~]# cd /tmp/
[root@rac2 tmp]# chown -R oracle:oinstall 30783556
[root@rac2 tmp]# chmod -R 775 30783556
[root@rac2 tmp]# ls -ltr | grep 30783556
/*
drwxrwxr-x  4 oracle oinstall   4096 Sep 20 16:15 30783556
*/

-- Step 122 -->> On Node 2
-- To applying the Oracle PSU on Remote Node 2
[root@rac2 ~]# export ORACLE_HOME=/opt/app/oracle/product/19c/db_1
[root@rac2 ~]# export PATH=${ORACLE_HOME}/bin:$PATH
[root@rac2 ~]# export PATH=${PATH}:${ORACLE_HOME}/OPatch
[root@rac2 ~]# which opatchauto
/*
/opt/app/oracle/product/19c/db_1/OPatch/opatchauto
*/

-- Step 123 -->> On Node 2
[root@rac2 ~]# opatchauto apply /tmp/30783556/30805684 -oh /opt/app/oracle/product/19c/db_1 --nonrolling
/*
OPatchauto session is initiated at Sun Sep 20 16:17:56 2020

System initialization log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchautodb/systemconfig2020-09-20_04-18-03PM.log.

Session log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/opatchauto2020-09-20_04-18-23PM.log
The id for this session is YJNJ

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

Host:rac2
RAC Home:/opt/app/oracle/product/19c/db_1
Version:19.0.0.0.0
Summary:

==Following patches were SUCCESSFULLY applied:

Patch: /tmp/30783556/30805684
Log: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2020-09-20_16-18-46PM_1.log

OPatchauto session completed at Sun Sep 20 16:19:58 2020
Time taken to complete the session 2 minutes, 2 seconds
*/


[root@rac2 ~]# tail -f /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2020-09-20_16-18-46PM_1.log
/*
[Sep 20, 2020 4:19:56 PM] [INFO]    Deleted the directory "/opt/app/oracle/product/19c/db_1/.patch_storage/NApply/2020-09-20_16-19-02PM/backup"
[Sep 20, 2020 4:19:56 PM] [INFO]    Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/NApply/2020-09-20_16-19-02PM/restore.sh"
[Sep 20, 2020 4:19:56 PM] [INFO]    Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/NApply/2020-09-20_16-19-02PM/make.txt"
[Sep 20, 2020 4:19:56 PM] [INFO]    [OPSR-TIME] Backup area for restore has been cleaned up. For a complete list of files/directories
                                    deleted, Please refer log file.
[Sep 20, 2020 4:19:56 PM] [INFO]    Patch 30805684 successfully applied.
[Sep 20, 2020 4:19:56 PM] [INFO]    UtilSession: N-Apply done.
[Sep 20, 2020 4:19:56 PM] [INFO]    Finishing UtilSession at Sun Sep 20 16:19:56 NPT 2020
[Sep 20, 2020 4:19:56 PM] [INFO]    Log file location: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2020-09-20_16-18-46PM_1.log
[Sep 20, 2020 4:19:56 PM] [INFO]    EXITING METHOD: NApply(IAnalysisReport report)
*/

-- Step 124 -->> On Both Nodes
-- To Create a Oracle Database
[root@rac1/rac2 ~]# mkdir -p /opt/app/oracle/admin/racdb/adump
[root@rac1/rac2 ~]# cd /opt/app/oracle/admin/
[root@rac1/rac2 ~]# chown -R oracle:oinstall racdb/
[root@rac1/rac2 ~]# chmod -R 775 racdb/

-- Step 125 -->> On Node 1
-- To prepare the responce file
[root@rac1 ~]# su - oracle
[oracle@rac1 ~]$ cp /opt/app/oracle/product/19c/db_1/assistants/dbca/dbca.rsp /home/oracle/
[oracle@rac1 ~]$ cd /home/oracle/
[oracle@rac1 ~]$ chmod -R 755 dbca.rsp
[oracle@rac1 ~]$ ls -ltr | grep dbca
/*
-rwxr-xr-x 1 oracle oinstall 25502 Sep 20 17:07 dbca.rsp
*/
 
-- Step 126 -->> On Node 1
[oracle@rac1 ~]$ vi dbca.rsp
/*
responseFileVersion=/oracle/assistants/rspfmt_dbca_response_schema_v19.0.0
gdbname=racdb
sid=racdb
databaseConfigType=RAC
force=FALSE
createAsContainerDatabase=true
numberOfPDBs=1
pdbName=racpdb
pdbAdminPassword=Sys605014
nodelist=rac1,rac2
templateName=/opt/app/oracle/product/19c/db_1/assistants/dbca/templates/General_Purpose.dbc
sysPassword=Sys605014
systemPassword=Sys605014
emConfiguration=NONE
datafileDestination=+DATA
recoveryAreaDestination=+DATA
storageType=ASM
diskGroupName=+DATA/{DB_UNIQUE_NAME}/
asmsnmpPassword=Sys605014
recoveryGroupName=+ARC
characterSet=AL32UTF8
listeners=LISTENER
sampleSchema=fasle
databaseType=MULTIPURPOSE
automaticMemoryManagement=fasle 
totalMemory=2048
*/

-- OR --
[oracle@rac1 bin]$ dbca -silent -createDatabase \
  -templateName General_Purpose.dbc             \
  -gdbname racdb -responseFile NO_VALUE         \
  -characterSet AL32UTF8                        \
  -sysPassword Sys605014                        \
  -systemPassword Sys605014                     \
  -createAsContainerDatabase true               \
  -numberOfPDBs 1                               \
  -pdbName racpdb                               \
  -pdbAdminPassword Sys605014                   \
  -databaseType MULTIPURPOSE                    \
  -automaticMemoryManagement false              \
  -totalMemory 2048                             \
  -redoLogFileSize 50                           \
  -emConfiguration NONE                         \
  -ignorePreReqs                                \
  -nodelist rac1,rac2                           \
  -storageType ASM                              \
  -diskGroupName +DATA/{DB_UNIQUE_NAME}/        \
  -recoveryGroupName +ARC                       \
  -useOMF true                                  \
  -asmsnmpPassword Sys605014

/*
Prepare for db operation
7% complete
Copying database files
27% complete
Creating and starting Oracle instance
28% complete
31% complete
35% complete
37% complete
40% complete
Creating cluster database views
41% complete
53% complete
Completing Database Creation
57% complete
59% complete
60% complete
Creating Pluggable Databases
64% complete
80% complete
Executing Post Configuration Actions
100% complete
Database creation complete. For details check the logfiles at:
 /opt/app/oracle/cfgtoollogs/dbca/racdb.
Database Information:
Global Database Name:racdb
System Identifier(SID) Prefix:racdb
Look at the log file "/opt/app/oracle/cfgtoollogs/dbca/racdb/racdb.log" for further details.
*/  

[oracle@rac1 ~]$ tail -f /opt/app/oracle/cfgtoollogs/dbca/racdb/racdb.log
/*
[ 2020-09-20 16:51:14.438 NPT ] Prepare for db operation
DBCA_PROGRESS : 7%
[ 2020-09-20 16:51:41.631 NPT ] Copying database files
DBCA_PROGRESS : 27%
[ 2020-09-20 16:53:18.738 NPT ] Creating and starting Oracle instance
DBCA_PROGRESS : 28%
DBCA_PROGRESS : 31%
DBCA_PROGRESS : 35%
DBCA_PROGRESS : 37%
DBCA_PROGRESS : 40%
[ 2020-09-20 17:19:41.868 NPT ] Creating cluster database views
DBCA_PROGRESS : 41%
DBCA_PROGRESS : 53%
[ 2020-09-20 17:21:17.705 NPT ] Completing Database Creation
DBCA_PROGRESS : 57%
DBCA_PROGRESS : 59%
DBCA_PROGRESS : 60%
[ 2020-09-20 17:33:07.570 NPT ] Creating Pluggable Databases
DBCA_PROGRESS : 64%
DBCA_PROGRESS : 80%
[ 2020-09-20 17:33:43.013 NPT ] Executing Post Configuration Actions
DBCA_PROGRESS : 100%
[ 2020-09-20 17:33:43.016 NPT ] Database creation complete. For details check the logfiles at:
 /opt/app/oracle/cfgtoollogs/dbca/racdb.
Database Information:
Global Database Name:racdb
System Identifier(SID) Prefix:racdb
*/

-- Step 127 -->> On Node 1  
[oracle@rac1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Sep 20 17:42:39 2020
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> ALTER PLUGGABLE DATABASE racpdb SAVE STATE;

Pluggable database altered.

SQL> SELECT status ,instance_name FROM gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
OPEN         racdb2
OPEN         racdb1

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 128 -->> On Both Nodes 
[oracle@rac1/rac2 ~]$ srvctl config database -d racdb
/*
Database unique name: racdb
Database name: racdb
Oracle home: /opt/app/oracle/product/19c/db_1
Oracle user: oracle
Spfile: +DATA/RACDB/PARAMETERFILE/spfile.272.1051637423
Password file: +DATA/RACDB/PASSWORD/pwdracdb.256.1051635105
Domain:
Start options: open
Stop options: immediate
Database role: PRIMARY
Management policy: AUTOMATIC
Server pools:
Disk Groups: ARC,DATA
Mount point paths:
Services:
Type: RAC
Start concurrency:
Stop concurrency:
OSDBA group: dba
OSOPER group: oper
Database instances: racdb1,racdb2
Configured nodes: rac1,rac2
CSS critical: no
CPU count: 0
Memory target: 0
Maximum memory: 0
Default network number for database services:
Database is administrator managed
*/

-- Step 129 -->> On Both Nodes 
[oracle@rac1/rac2 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node rac1
Instance racdb2 is running on node rac2
*/

-- Step 130 -->> On Both Nodes 
[oracle@rac1 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): rac1,rac2
*/

-- Step 131 -->> On Node 1 
[oracle@rac1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 20-SEP-2020 17:48:09

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                20-SEP-2020 12:54:31
Uptime                    0 days 4 hr. 53 min. 38 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/rac1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.75)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.77)(PORT=1521)))
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
  Instance "racdb1", status READY, has 1 handler(s) for this service...
Service "afbe4eb41920eeaee0534b0110ac0ed9" has 1 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
Service "racdb" has 1 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
Service "racdbXDB" has 1 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
Service "racpdb" has 1 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 132 -->> On Node 2 
[oracle@rac2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 20-SEP-2020 17:50:44

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                20-SEP-2020 12:59:15
Uptime                    0 days 4 hr. 51 min. 28 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/rac2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.76)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.78)(PORT=1521)))
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
  Instance "racdb2", status READY, has 1 handler(s) for this service...
Service "afbe4eb41920eeaee0534b0110ac0ed9" has 1 instance(s).
  Instance "racdb2", status READY, has 1 handler(s) for this service...
Service "racdb" has 1 instance(s).
  Instance "racdb2", status READY, has 1 handler(s) for this service...
Service "racdbXDB" has 1 instance(s).
  Instance "racdb2", status READY, has 1 handler(s) for this service...
Service "racpdb" has 1 instance(s).
  Instance "racdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- To Fix the if occured in remote nodes
[oracle@rac2 ~]$ adrci
/*
ADRCI: Release 19.0.0.0.0 - Production on Mon Sep 21 12:38:51 2020

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

No ADR base is set
adrci> exit
*/

[oracle@rac1 ~]$ ls -ltr /opt/app/oracle/product/19c/db_1/log/diag/
/*
-rw-r----- 1 oracle asmadmin 16 Sep 21 12:25 adrci_dir.mif
*/

[oracle@rac2 ~]$ cd /opt/app/oracle/product/19c/db_1/
[oracle@rac2 db_1]$ mkdir -p log/diag
[oracle@rac2 db_1]$ mkdir -p log/rac1/client
[oracle@rac2 db_1]$ cd log
[oracle@rac2 db_1]$ chown -R oracle:asmadmin diag
[oracle@rac1 ~]$ scp -r /opt/app/oracle/product/19c/db_1/log/diag/adrci_dir.mif oracle@rac2:/opt/app/oracle/product/19c/db_1/log/diag/


-- Step 133 -->> On Node 1
[root@rac1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/19c/grid:N
racdb:/opt/app/oracle/product/19c/db_1:N
racdb1:/opt/app/oracle/product/19c/db_1:N
*/

-- Step 134 -->> On Node 2
[root@rac2 ~]# vi /etc/oratab 
/*
+ASM2:/opt/app/19c/grid:N
racdb:/opt/app/oracle/product/19c/db_1:N
racdb2:/opt/app/oracle/product/19c/db_1:N
*/

-- Step 135 -->> On Node 1
[root@rac1 ~]# vi /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
/*
# tnsnames.ora Network Configuration File: /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.

RACDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = rac-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = racdb)
    )
  )

RACDB1 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.1.75)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = racdb)
    )
  )

RACPDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = rac-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = racpdb)
    )
  )
*/

-- Step 136 -->> On Node 2
[root@rac2 ~]# vi /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
/*
# tnsnames.ora Network Configuration File: /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.

RACDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = rac-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = racdb)
    )
  )

RACDB2 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.1.76)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = racdb)
    )
  )

RACPDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = rac-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = racpdb)
    )
  )
*/

-- To run the oracle tools (Till 11gR2 - If Required)
[root@rac1/rac2 ~]# vi /opt/app/19c/grid/network/admin/sqlnet.ora
/*
# sqlnet.ora.rac1/rac2 Network Configuration File: /opt/app/19c/grid/network/admin/sqlnet.ora
# Generated by Oracle configuration tools.

NAMES.DIRECTORY_PATH= (TNSNAMES, EZCONNECT)

SQLNET.ALLOWED_LOGON_VERSION_SERVER=11
SQLNET.ALLOWED_LOGON_VERSION_CLIENT=11
*/

[root@rac1/rac2 ~]# vi /opt/app/oracle/product/19c/db_1/network/admin/sqlnet.ora
/*
# sqlnet.ora.rac1/rac2 Network Configuration File: /opt/app/oracle/product/19c/db_1/network/admin/sqlnet.ora
# Generated by Oracle configuration tools.

NAMES.DIRECTORY_PATH= (TNSNAMES, EZCONNECT)

SQLNET.ALLOWED_LOGON_VERSION_SERVER=11
SQLNET.ALLOWED_LOGON_VERSION_CLIENT=11
*/

[oracle@rac1/rac2 ~]$ srvctl stop listener
[oracle@rac1/rac2 ~]$ srvctl start listener
[oracle@rac1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Thu Sep 24 17:06:09 2020
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> ALTER USER sys IDENTIFIED BY "Sys605014";

User altered.

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 137 -->> On Both Nodes
[root@rac1/rac2 ~]# cd /opt/app/19c/grid/bin
[root@rac1/rac2 ~]# ./crsctl stop crs
[root@rac1/rac2 ~]# ./crsctl start crs

-- Step 138 -->> On Node 1
[root@rac1 ~]# cd /opt/app/19c/grid/bin
[root@rac1 ~]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       rac1                     Started,STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       rac1                     STABLE
ora.crf
      1        ONLINE  ONLINE       rac1                     STABLE
ora.crsd
      1        ONLINE  ONLINE       rac1                     STABLE
ora.cssd
      1        ONLINE  ONLINE       rac1                     STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       rac1                     STABLE
ora.ctssd
      1        ONLINE  ONLINE       rac1                     OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.drivers.acfs
      1        ONLINE  ONLINE       rac1                     STABLE
ora.evmd
      1        ONLINE  ONLINE       rac1                     STABLE
ora.gipcd
      1        ONLINE  ONLINE       rac1                     STABLE
ora.gpnpd
      1        ONLINE  ONLINE       rac1                     STABLE
ora.mdnsd
      1        ONLINE  ONLINE       rac1                     STABLE
ora.storage
      1        ONLINE  ONLINE       rac1                     STABLE
--------------------------------------------------------------------------------
*/

-- Step 139 -->> On Node 2
[root@rac2 ~]# cd /opt/app/19c/grid/bin
[root@rac2 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       rac2                     STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       rac2                     STABLE
ora.crf
      1        ONLINE  ONLINE       rac2                     STABLE
ora.crsd
      1        ONLINE  ONLINE       rac2                     STABLE
ora.cssd
      1        ONLINE  ONLINE       rac2                     STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       rac2                     STABLE
ora.ctssd
      1        ONLINE  ONLINE       rac2                     OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.drivers.acfs
      1        ONLINE  ONLINE       rac2                     STABLE
ora.evmd
      1        ONLINE  ONLINE       rac2                     STABLE
ora.gipcd
      1        ONLINE  ONLINE       rac2                     STABLE
ora.gpnpd
      1        ONLINE  ONLINE       rac2                     STABLE
ora.mdnsd
      1        ONLINE  ONLINE       rac2                     STABLE
ora.storage
      1        ONLINE  ONLINE       rac2                     STABLE
--------------------------------------------------------------------------------
*/

-- Step 140 -->> On Both Nodes
[root@rac1/rac2 ~]# cd /opt/app/19c/grid/bin
[root@rac1/rac2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       rac1                     STABLE
               ONLINE  ONLINE       rac2                     STABLE
ora.chad
               ONLINE  ONLINE       rac1                     STABLE
               ONLINE  ONLINE       rac2                     STABLE
ora.net1.network
               ONLINE  ONLINE       rac1                     STABLE
               ONLINE  ONLINE       rac2                     STABLE
ora.ons
               ONLINE  ONLINE       rac1                     STABLE
               ONLINE  ONLINE       rac2                     STABLE
ora.proxy_advm
               OFFLINE OFFLINE      rac1                     STABLE
               OFFLINE OFFLINE      rac2                     STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ARC.dg(ora.asmgroup)
      1        ONLINE  ONLINE       rac1                     STABLE
      2        ONLINE  ONLINE       rac2                     STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       rac1                     STABLE
      2        ONLINE  ONLINE       rac2                     STABLE
      3        ONLINE  OFFLINE                               STABLE
ora.DATA.dg(ora.asmgroup)
      1        ONLINE  ONLINE       rac1                     STABLE
      2        ONLINE  ONLINE       rac2                     STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       rac2                     STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       rac1                     STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       rac1                     STABLE
      2        ONLINE  ONLINE       rac2                     STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       rac1                     Started,STABLE
      2        ONLINE  ONLINE       rac2                     Started,STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       rac1                     STABLE
      2        ONLINE  ONLINE       rac2                     STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.cvu
      1        ONLINE  ONLINE       rac1                     STABLE
ora.qosmserver
      1        ONLINE  ONLINE       rac1                     STABLE
ora.rac1.vip
      1        ONLINE  ONLINE       rac1                     STABLE
ora.rac2.vip
      1        ONLINE  ONLINE       rac2                     STABLE
ora.racdb.db
      1        ONLINE  ONLINE       rac1                     Open,HOME=/opt/app/oracle/product/19c/db_1,STABLE
      2        ONLINE  ONLINE       rac2                     Open,HOME=/opt/app/oracle/product/19c/db_1,STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       rac2                     STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       rac1                     STABLE
--------------------------------------------------------------------------------
*/

-- Step 141 -->> On Both Nodes
[root@rac1/rac2 ~]# cd /opt/app/19c/grid/bin
[root@rac1/rac2 bin]# ./crsctl check cluster -all
/*
**************************************************************
rac1:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
rac2:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/

-- Step 142 -->> On Both Nodes
-- ASM Verification
[root@rac1/rac2 ~]# su - grid
[grid@rac1/rac2 ~]$ asmcmd
ASMCMD> lsdg
/*
ASMCMD> lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  1048576     51199    50866                0           50866              0             N  ARC/
MOUNTED  EXTERN  N         512             512   4096  1048576     81919    77210                0           77210              0             N  DATA/
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20128                0           20128              0             Y  OCR/
ASMCMD> exit
*/

-- Step 143 -->> On Both Nodes
[grid@rac1/rac2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 21-SEP-2020 13:22:40

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                21-SEP-2020 13:11:55
Uptime                    0 days 0 hr. 10 min. 45 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/rac1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.75)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.77)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1"/"+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM1"/"+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "86b637b62fdf7a65e053f706e80a27ca" has 1 instance(s).
  Instance "racdb1"/"racdb2", status READY, has 1 handler(s) for this service...
Service "afbe4eb41920eeaee0534b0110ac0ed9" has 1 instance(s).
  Instance "racdb1"/"racdb2", status READY, has 1 handler(s) for this service...
Service "racdb" has 1 instance(s).
  Instance "racdb1"/"racdb2", status READY, has 1 handler(s) for this service...
Service "racdbXDB" has 1 instance(s).
  Instance "racdb1"/"racdb2", status READY, has 1 handler(s) for this service...
Service "racpdb" has 1 instance(s).
  Instance "racdb1"/"racdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 144 -->> On Both Nodes
[grid@rac1/rac2 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Mon Sep 21 13:24:02 2020
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

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

-- Step 145 -->> On Both Nodes
-- DB Service Verification
[root@rac1/rac2 ~]# su - oracle
[oracle@rac1/rac2 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node rac1
Instance racdb2 is running on node rac2
*/

-- Step 146 -->> On Both Nodes
-- Listener Service Verification
[oracle@rac1/rac2 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): rac1,rac2
*/

-- Step 147 -->> On Node 1
-- Enable Archive
[oracle@rac1 ~]$ srvctl stop database -d racdb
[oracle@rac1 ~]$ srvctl start database -d racdb -o mount
[oracle@rac1 ~]$ sqlplus sys/Sys605014 as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Mon Sep 21 13:34:05 2020
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> select status, instance_name from gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
MOUNTED      racdb1
MOUNTED      racdb2

SQL> SELECT inst_id,name,log_mode,open_mode,protection_mode FROM gv$database;

INST_ID NAME  LOG_MODE     OPEN_MODE PROTECTION_MODE
------- ----- ------------ --------- --------------------
      1 RACDB NOARCHIVELOG MOUNTED   MAXIMUM PERFORMANCE
      2 RACDB NOARCHIVELOG MOUNTED   MAXIMUM PERFORMANCE

SQL> ALTER DATABASE ARCHIVELOG;
SQL> ALTER SYSTEM SET log_archive_dest_1='LOCATION=+ARC/racdb' scope=both sid='*';
SQL> ALTER SYSTEM SET log_archive_format='racdb_%t_%s_%r.arc' SCOPE=spfile sid='*';


SQL> archive log list;
Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            +ARC/racdb
Oldest online log sequence     5
Next log sequence to archive   6
Current log sequence           6

SQL> SELECT inst_id,name,log_mode,open_mode,protection_mode FROM gv$database;

INST_ID NAME  LOG_MODE   OPEN_MODE PROTECTION_MODE
------- ----- ---------- --------- --------------------
      1 racDB ARCHIVELOG MOUNTED   MAXIMUM PERFORMANCE
      2 racDB ARCHIVELOG MOUNTED   MAXIMUM PERFORMANCE

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

-- Step 148 -->> On Node 1
[oracle@rac1 ~]$ srvctl stop database -d racdb
[oracle@rac1 ~]$ srvctl start database -d racdb

-- Step 149 -->> On Both Nodes
[oracle@rac1/rac2 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node rac1
Instance racdb2 is running on node rac2
*/

-- Step 150 -->> On Both Nodes
[oracle@rac1/rac2 ~]$ rman target /
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Mon Sep 21 13:41:58 2020
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: RACDB (DBID=1049252019)

RMAN> show all;

using target database control file instead of recovery catalog
RMAN configuration parameters for database with db_unique_name RACDB are:
CONFIGURE RETENTION POLICY TO REDUNDANCY 1; # default
CONFIGURE BACKUP OPTIMIZATION OFF; # default
CONFIGURE DEFAULT DEVICE TYPE TO DISK; # default
CONFIGURE CONTROLFILE AUTOBACKUP ON; # default
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '%F'; # default
CONFIGURE DEVICE TYPE DISK PARALLELISM 1 BACKUP TYPE TO BACKUPSET; # default
CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE MAXSETSIZE TO UNLIMITED; # default
CONFIGURE ENCRYPTION FOR DATABASE OFF; # default
CONFIGURE ENCRYPTION ALGORITHM 'AES128'; # default
CONFIGURE COMPRESSION ALGORITHM 'BASIC' AS OF RELEASE 'DEFAULT' OPTIMIZE FOR LOAD TRUE ; # default
CONFIGURE RMAN OUTPUT TO KEEP FOR 7 DAYS; # default
CONFIGURE ARCHIVELOG DELETION POLICY TO NONE; # default
-- Node 1
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/product/19c/db_1/dbs/snapcf_racdb1.f'; # default
-- Node 2
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/product/19c/db_1/dbs/snapcf_racdb2.f'; # default

RMAN> exit

Recovery Manager complete.
*/

-- Step 151 -->> On Both Nodes
-- To connnect CDB$ROOT using TNS
[oracle@rac1/rac2 ~]$ sqlplus sys/Sys605014@racdb as sysdba

-- Step 152 -->> On Node 1
[oracle@rac1 ~]$ sqlplus sys/Sys605014@racdb1 as sysdba

-- Step 153 -->> On Node 2
[oracle@rac2 ~]$ sqlplus sys/Sys605014@racdb2 as sysdba

-- Step 154 -->> On Both Nodes
-- To connnect PDB using TNS
[oracle@rac1/rac2 ~]$ sqlplus sys/Sys605014@racpdb as sysdba

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

-- To Delete All The DataBase (If required)
[oracle@rac1 ~]$ cd /opt/app/oracle/product/19c/db_1/bin/
[oracle@rac1 bin]$ dbca -silent -deleteDatabase -sourceDB racdb -sysDBAUserName sys -sysDBAPassword Sys605014
/*
[WARNING] [DBT-19202] The Database Configuration Assistant will delete the Oracle instances and datafiles for your database. All information in the database will be destroyed.
Prepare for db operation
32% complete
Connecting to database
39% complete
42% complete
45% complete
48% complete
52% complete
55% complete
58% complete
65% complete
Updating network configuration files
68% complete
Deleting instances and datafiles
77% complete
87% complete
97% complete
100% complete
Database deletion completed.
Look at the log file "/opt/app/oracle/cfgtoollogs/dbca/racdb/racdb0.log" for further details.
*/
