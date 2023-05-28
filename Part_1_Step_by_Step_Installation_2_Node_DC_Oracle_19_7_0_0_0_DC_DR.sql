----------------------------------------------------------------
-------------Two Node rac Setup on VM Workstation---------------
----------------------------------------------------------------

-- 2 Node rac on VM -->> On both Node
[root@invoice1/invoice2 ~]# df -Th
/*
Filesystem     Type      Size  Used Avail Use% Mounted on
devtmpfs       devtmpfs  9.7G     0  9.7G   0% /dev
tmpfs          tmpfs     9.7G     0  9.7G   0% /dev/shm
tmpfs          tmpfs     9.7G  9.5M  9.7G   1% /run
tmpfs          tmpfs     9.7G     0  9.7G   0% /sys/fs/cgroup
/dev/sda2      ext4       79G  126M   75G   1% /
/dev/sda8      ext4       15G  5.7G  8.3G  41% /usr
/dev/sda1      ext4       15G  229M   14G   2% /boot
/dev/sda5      ext4       15G   41M   14G   1% /home
/dev/sda3      ext4       79G   57M   75G   1% /opt
/dev/sda7      ext4       15G   41M   14G   1% /tmp
/dev/sda9      ext4       15G  1.1G   13G   8% /var
tmpfs          tmpfs     2.0G  8.0K  2.0G   1% /run/user/0
/dev/sr0       iso9660   4.5G  4.5G     0 100% /run/media/root/OL-7.8 Server.x86_64
tmpfs          tmpfs     2.0G  8.0K  2.0G   1% /run/user/42
*/

-- Step 1 -->> On both Node
[root@invoice1/invoice2 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

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


-- Step 2 -->> On both Node
-- Disable secure linux by editing the "/etc/selinux/config" file, making sure the SELINUX flag is set as follows.
[root@invoice1/invoice2 ~]# vi /etc/selinux/config
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
[root@invoice1 ~]# vi /etc/sysconfig/network
/*
NETWORKING=yes
HOSTNAME=invoice1.unidev.com
*/

-- Step 4 -->> On Node 2
[root@invoice2 ~]# vi /etc/sysconfig/network
/*
NETWORKING=yes
HOSTNAME=invoice2.unidev.com
*/

-- Step 5 -->> On Node 1
[root@invoice1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens32 
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=ens32
DEVICE=ens32
ONBOOT=yes
IPADDR=192.1.1.40
NETMASK=255.255.255.0
GATEWAY=192.1.1.1
DNS1=127.0.0.1
DNS2=192.1.1.88
*/

-- Step 6 -->> On Node 1
[root@invoice1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens33
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=ens33
DEVICE=ens33
ONBOOT=yes
IPADDR=10.0.1.40
NETMASK=255.255.255.0
*/

-- Step 7 -->> On Node 2
[root@invoice2 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens32 
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=ens32
DEVICE=ens32
ONBOOT=yes
IPADDR=192.1.1.41
NETMASK=255.255.255.0
GATEWAY=192.1.1.1
DNS1=127.0.0.1
DNS2=192.1.1.88
*/

-- Step 8 -->> On Node 2
[root@invoice2 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens33
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=ens33
DEVICE=ens33
ONBOOT=yes
IPADDR=10.0.1.41
NETMASK=255.255.255.0
*/

-- Step 9 -->> On Both Node
[root@invoice1/invoice2 ~]# systemctl restart network

-- Step 10 -->> On Both Node
[root@invoice1/invoice2 ~]# cat /etc/hostname
/*
localhost.localdomain
*/

-- Step 10.1 -->> On Both Node
[root@invoice1/invoice2 ~]# hostnamectl | grep hostname
/*
   Static hostname: localhost.localdomain
Transient hostname: invoice1/invoice2.unidev.com
*/

-- Step 10.2 -->> On Both Node
[root@invoice1/invoice2 ~]# hostnamectl --static
/*
localhost.localdomain
*/

-- Step 11 -->> On Node 1
[root@invoice1 ~]# hostnamectl set-hostname invoice1.unidev.com

-- Step 11.1 -->> On Node 1
[root@invoice1 ~]# hostnamectl
/*
   Static hostname: invoice1.unidev.com
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 426af079139045efa83c49a7f70b8211
           Boot ID: ba16428b309d47d99576af092661d4f9
    Virtualization: vmware
  Operating System: Oracle Linux Server 7.8
       CPE OS Name: cpe:/o:oracle:linux:7:8:server
            Kernel: Linux 4.14.35-1902.300.11.el7uek.x86_64
      Architecture: x86-64
*/

-- Step 12 -->> On Node 2
[root@invoice2 ~]# hostnamectl set-hostname invoice2.unidev.com

-- Step 12.1 -->> On Node 2
[root@invoice2 ~]# hostnamectl
/*
   Static hostname: invoice2.unidev.com
         Icon name: computer-vm
           Chassis: vm
        Machine ID: ffabbde2003846d291f4413657ba52f2
           Boot ID: 0e8341df9a394a0086c04e027e7f69f6
    Virtualization: vmware
  Operating System: Oracle Linux Server 7.8
       CPE OS Name: cpe:/o:oracle:linux:7:8:server
            Kernel: Linux 4.14.35-1902.300.11.el7uek.x86_64
      Architecture: x86-64
*/

--Note: If you are not configure proper hostname then While installation of Grid Software, 
--      you have to face error CLSRSC-180: An error occurred while executing /opt/app/19c/grid/root.sh script.

-- Step 13 -->> On Both Node
[root@invoice1/invoice2 ~]# systemctl stop firewalld
[root@invoice1/invoice2 ~]# systemctl disable firewalld
/*
Removed /etc/systemd/system/multi-user.target.wants/firewalld.service.
Removed /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.
*/

-- Step 14 -->> On Both Node
[root@invoice1/invoice2 ~]# systemctl stop ntpd
[root@invoice1/invoice2 ~]# systemctl disable ntpd

-- Step 14.1 -->> On Both Nodedf 
[root@invoice1/invoice2 ~]# mv /etc/ntp.conf /etc/ntp.conf.backup
[root@invoice1/invoice2 ~]# rm -rf /etc/ntp.conf
[root@invoice1/invoice2 ~]# rm -rf /var/run/ntpd.pid

-- Step 15 -->> On Both Node
[root@invoice1/invoice2 ~]# iptables -F
[root@invoice1/invoice2 ~]# iptables -X
[root@invoice1/invoice2 ~]# iptables -t nat -F
[root@invoice1/invoice2 ~]# iptables -t nat -X
[root@invoice1/invoice2 ~]# iptables -t mangle -F
[root@invoice1/invoice2 ~]# iptables -t mangle -X
[root@invoice1/invoice2 ~]# iptables -P INPUT ACCEPT
[root@invoice1/invoice2 ~]# iptables -P FORWARD ACCEPT
[root@invoice1/invoice2 ~]# iptables -P OUTPUT ACCEPT
[root@invoice1/invoice2 ~]# iptables -L -nv
/*
Chain INPUT (policy ACCEPT 2066 packets, 5110K bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy ACCEPT 1772 packets, 117K bytes)
 pkts bytes target     prot opt in     out     source               destination
*/

-- Step 16 -->> On Both Node
[root@invoice1/invoice2 ~ ]# systemctl stop named
[root@invoice1/invoice2 ~ ]# systemctl disable named

-- Step 17 -->> On Both Node
-- Enable chronyd service." `date`
[root@invoice1/invoice2 ~ ]# systemctl enable chronyd
[root@invoice1/invoice2 ~ ]# systemctl restart chronyd
[root@invoice1/invoice2 ~ ]# chronyc -a 'burst 4/4'
/*
200 OK
*/

-- Step 17.1 -->> On Both Node
[root@invoice1/invoice2 ~ ]# chronyc -a makestep
/*
200 OK
*/

-- Step 17.2 -->> On Both Node
[root@invoice1/invoice2 ~ ]# systemctl status chronyd
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
Sep 11 12:24:46 invoice1.unidev.com chronyd[3406]: Source 162.159.200.1 online
Sep 11 12:24:46 invoice1.unidev.com chronyd[3406]: Source 162.159.200.123 online
Sep 11 12:28:23 invoice1.unidev.com chronyd[3406]: Selected source 162.159.200.1
Sep 11 12:28:30 localhost.localdomain chronyd[3406]: Source 162.159.200.123 offline
Sep 11 12:28:30 localhost.localdomain chronyd[3406]: Source 162.159.200.1 offline
Sep 11 12:28:30 localhost.localdomain chronyd[3406]: Can't synchronise: no selectable sources
Sep 11 12:28:31 invoice1.unidev.com chronyd[3406]: Source 162.159.200.1 online
Sep 11 12:28:31 invoice1.unidev.com chronyd[3406]: Source 162.159.200.123 online
Sep 11 12:31:37 invoice1.unidev.com chronyd[3406]: Selected source 162.159.200.123
Hint: Some lines were ellipsized, use -l to show in full.
*/

-- Step 18 -->> On Both Node
[root@invoice1/invoice2 ~]# cd /run/media/root/OL-7.8\ Server.x86_64/Packages/
[root@invoice1/invoice2 Packages]# yum install -y bind
[root@invoice1/invoice2 Packages]# yum install -y dnsmasq
[root@invoice1/invoice2 ~]# systemctl enable dnsmasq
[root@invoice1/invoice2 ~]# systemctl restart dnsmasq
[root@invoice1/invoice2 ~]# vi /etc/dnsmasq.conf
/*
listen-address=::1,127.0.0.1

#Add the following Lines
except-interface=virbr0
bind-interfaces
*/

-- Step 18.1 -->> On Both Node
[root@invoice1/invoice2 ~]# systemctl restart dnsmasq
[root@invoice1/invoice2 ~]# systemctl restart network
[root@invoice1/invoice2 ~]# systemctl status dnsmasq
/*
● dnsmasq.service - DNS caching server.
   Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2022-11-06 16:43:59 +0545; 16s ago
 Main PID: 4533 (dnsmasq)
    Tasks: 1
   CGroup: /system.slice/dnsmasq.service
           └─4533 /usr/sbin/dnsmasq -k

Nov 06 16:43:59 invoice1.unidev.com dnsmasq[4533]: started, version 2.76 cachesize 150
Nov 06 16:43:59 invoice1.unidev.com dnsmasq[4533]: compile time options: IPv6 GNU-getopt DBus no-i18n IDN ...tify
Nov 06 16:43:59 invoice1.unidev.com dnsmasq[4533]: reading /etc/resolv.conf
Nov 06 16:43:59 invoice1.unidev.com dnsmasq[4533]: ignoring nameserver 127.0.0.1 - local interface
Nov 06 16:43:59 invoice1.unidev.com dnsmasq[4533]: using nameserver 192.1.1.88#53
Nov 06 16:43:59 invoice1.unidev.com dnsmasq[4533]: read /etc/hosts - 11 addresses
Nov 06 16:44:06 invoice1.unidev.com dnsmasq[4533]: no servers found in /etc/resolv.conf, will retry
Nov 06 16:44:07 invoice1.unidev.com dnsmasq[4533]: reading /etc/resolv.conf
Nov 06 16:44:07 invoice1.unidev.com dnsmasq[4533]: ignoring nameserver 127.0.0.1 - local interface
Nov 06 16:44:07 invoice1.unidev.com dnsmasq[4533]: using nameserver 192.1.1.88#53
Hint: Some lines were ellipsized, use -l to show in full.
*/

-- Step 18 -->> On Node 1
[root@invoice1 ~]# nslookup 192.1.1.40
/*
40.6.16.172.in-addr.arpa        name = invoice1.unidev.com.
*/

-- Step 18.1 -->> On Node 1
[root@invoice1 ~]# nslookup 192.1.1.41
/*
40.6.16.172.in-addr.arpa        name = invoice2.unidev.com.
*/

-- Step 20 -->> On Both Node
[root@invoice1/invoice2 ~]# nslookup invoice1
/*
Server:         192.1.1.88
Address:        192.1.1.88#53

Name:   invoice1.unidev.com
Address: 192.1.1.40
*/

-- Step 20.1 -->> On Both Node
[root@invoice1/invoice2 ~]# nslookup invoice2
/*
Server:         192.1.1.88
Address:        192.1.1.88#53

Name:   invoice2.unidev.com
Address: 192.1.1.41
*/

-- Step 20.2 -->> On Both Node
[root@invoice1/invoice2 ~]# nslookup invoice-scan
/*
Server:         192.1.1.88
Address:        192.1.1.88#53

Name:   invoice-scan.unidev.com
Address: 192.1.1.46
Name:   invoice-scan.unidev.com
Address: 192.1.1.45
Name:   invoice-scan.unidev.com
Address: 192.1.1.44
*/

-- Step 21 -->> On Both Node
--Stop avahi-daemon damon if it not configured
[root@invoice1/invoice2 ~]# systemctl stop avahi-daemon
[root@invoice1/invoice2 ~]# systemctl disable avahi-daemon

-- Step 22 -->> On Both Node
--To Remove virbr0 and lxcbr0 Network Interfac
[root@invoice1/invoice2 ~]# systemctl stop libvirtd.service
[root@invoice1/invoice2 ~]# systemctl disable libvirtd.service
[root@invoice1/invoice2 ~]# virsh net-list
[root@invoice1/invoice2 ~]# virsh net-destroy default
[root@invoice1/invoice2 ~]# ifconfig virbr0
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
[root@invoice1/invoice2 ~]# brctl show
/*
bridge name     bridge id               STP enabled     interfaces
virbr0          8000.52540010038b       yes             virbr0-nic
*/

-- Step 22.2 -->> On Both Node
[root@invoice1/invoice2 ~]# ip link set virbr0 down
[root@invoice1/invoice2 ~]# brctl delbr virbr0
[root@invoice1/invoice2 ~]# brctl show
/*
bridge name     bridge id               STP enabled     interfaces
*/

-- Step 22.3 -->> On Both Node
[root@invoice1/invoice2 ~]# ifconfig virbr0
/*
virbr0: error fetching interface information: Device not found
*/

-- Step 22.4 -->> On Both Node
[root@invoice1 ~]# ifconfig
/*
ens32: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.1.1.40  netmask 255.255.255.0  broadcast 192.1.1.255
        inet6 fe80::250:56ff:feac:31ab  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:31:ab  txqueuelen 1000  (Ethernet)
        RX packets 89337  bytes 130757686 (124.7 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 8860  bytes 824493 (805.1 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens33: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.1.40  netmask 255.255.255.0  broadcast 10.0.1.255
        inet6 fe80::250:56ff:feac:49fa  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:49:fa  txqueuelen 1000  (Ethernet)
        RX packets 817  bytes 72453 (70.7 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 98  bytes 11688 (11.4 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 132  bytes 10422 (10.1 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 132  bytes 10422 (10.1 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 22.5 -->> On Both Node
[root@invoice2 ~]# ifconfig
/*
ens32: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.1.1.41  netmask 255.255.255.0  broadcast 192.1.1.255
        inet6 fe80::250:56ff:feac:3b08  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:3b:08  txqueuelen 1000  (Ethernet)
        RX packets 88659  bytes 130691261 (124.6 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 8818  bytes 824834 (805.5 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens33: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.1.41  netmask 255.255.255.0  broadcast 10.0.1.255
        inet6 fe80::250:56ff:feac:1c86  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:1c:86  txqueuelen 1000  (Ethernet)
        RX packets 527  bytes 44113 (43.0 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 83  bytes 10511 (10.2 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 128  bytes 10126 (9.8 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 128  bytes 10126 (9.8 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/
-- Step 23 -->> On Both Node
[root@invoice1/invoice2 ~]# init 6

-- Step 24 -->> On Both Node
[root@invoice1/invoice2 ~]# brctl show
/*
bridge name     bridge id               STP enabled     interfaces
*/

-- Step 25 -->> On Both Node
[root@invoice1/invoice2 ~]# systemctl status libvirtd.service
/*
? libvirtd.service - Virtualization daemon
   Loaded: loaded (/usr/lib/systemd/system/libvirtd.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:libvirtd(8)
           https://libvirt.org
*/

-- Step 26 -->> On Both Node
[root@invoice1/invoice2 ~]# firewall-cmd --list-all
/*
FirewallD is not running
*/

-- Step 26.1 -->> On Both Node
[root@invoice1/invoice2 ~]# systemctl status firewalld
/*
? firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; vendor >
   Active: inactive (dead)
     Docs: man:firewalld(1)
*/

-- Step 27 -->> On Both Node
[root@invoice1/invoice2 ~]# systemctl status ntpd
/*
? ntpd.service - Network Time Service
   Loaded: loaded (/usr/lib/systemd/system/ntpd.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
*/

-- Step 28 -->> On Both Node
[root@invoice1/invoice2 ~]# systemctl status named
/*
? named.service - Berkeley Internet Name Domain (DNS)
   Loaded: loaded (/usr/lib/systemd/system/named.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
*/

-- Step 29 -->> On Both Node
[root@invoice1/invoice2 ~]# systemctl status avahi-daemon
/*
? avahi-daemon.service - Avahi mDNS/DNS-SD Stack
   Loaded: loaded (/usr/lib/systemd/system/avahi-daemon.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
*/

-- Step 30 -->> On Both Node
[root@invoice1/invoice2 ~ ]# systemctl status chronyd
/*
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: active (running) since Sun 2022-11-06 16:49:23 +0545; 3min 7s ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 996 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, status=0/SUCCESS)
  Process: 942 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 956 (chronyd)
   CGroup: /system.slice/chronyd.service
           └─956 /usr/sbin/chronyd

Nov 06 16:49:22 invoice1.unidev.com systemd[1]: Starting NTP client/server...
Nov 06 16:49:22 invoice1.unidev.com chronyd[956]: chronyd version 3.4 starting (+CMDMON +NTP +REFCLOCK +RT...BUG)
Nov 06 16:49:22 invoice1.unidev.com chronyd[956]: Frequency -6.521 +/- 3.590 ppm read from /var/lib/chrony/drift
Nov 06 16:49:23 invoice1.unidev.com systemd[1]: Started NTP client/server.
Nov 06 16:49:29 invoice1.unidev.com chronyd[956]: Selected source 162.159.200.123
Nov 06 16:51:48 invoice1.unidev.com chronyd[956]: Source 185.103.216.7 replaced with 103.104.28.105
Hint: Some lines were ellipsized, use -l to show in full.
*/

-- Step 31 -->> On Both Node
[root@invoice1/invoice2 ~]# systemctl status dnsmasq
/*
● dnsmasq.service - DNS caching server.
   Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2022-11-06 16:49:24 +0545; 3min 45s ago
 Main PID: 1310 (dnsmasq)
   CGroup: /system.slice/dnsmasq.service
           └─1310 /usr/sbin/dnsmasq -k

Nov 06 16:49:24 invoice1.unidev.com systemd[1]: Started DNS caching server..
Nov 06 16:49:24 invoice1.unidev.com dnsmasq[1310]: listening on lo(#1): 127.0.0.1
Nov 06 16:49:24 invoice1.unidev.com dnsmasq[1310]: listening on lo(#1): ::1
Nov 06 16:49:24 invoice1.unidev.com dnsmasq[1310]: started, version 2.76 cachesize 150
Nov 06 16:49:24 invoice1.unidev.com dnsmasq[1310]: compile time options: IPv6 GNU-getopt DBus no-i18n IDN ...tify
Nov 06 16:49:24 invoice1.unidev.com dnsmasq[1310]: reading /etc/resolv.conf
Nov 06 16:49:24 invoice1.unidev.com dnsmasq[1310]: ignoring nameserver 127.0.0.1 - local interface
Nov 06 16:49:24 invoice1.unidev.com dnsmasq[1310]: using nameserver 192.1.1.88#53
Nov 06 16:49:24 invoice1.unidev.com dnsmasq[1310]: read /etc/hosts - 11 addresses
Hint: Some lines were ellipsized, use -l to show in full.
*/

-- Step 31.1 -->> On Both Node
[root@invoice1/invoice2 ~]# nslookup 192.1.1.40
/*
40.6.16.172.in-addr.arpa        name = invoice1.unidev.com.
*/

-- Step 31.2 -->> On Both Node
[root@invoice1/invoice2 ~]# nslookup 192.1.1.41
/*
41.6.16.172.in-addr.arpa        name = invoice2.unidev.com.
*/

-- Step 31.3 -->> On Both Node
[root@invoice1/invoice2 ~]# nslookup invoice1
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   invoice1.unidev.com
Address: 192.1.1.40
*/

-- Step 31.4 -->> On Both Node
[root@invoice1/invoice2 ~]# nslookup invoice2
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   invoice2.unidev.com
Address: 192.1.1.41
*/

-- Step 31.5 -->> On Both Node
[root@invoice1/invoice2 ~]# nslookup invoice-scan
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   invoice-scan.unidev.com
Address: 192.1.1.46
Name:   invoice-scan.unidev.com
Address: 192.1.1.44
Name:   invoice-scan.unidev.com
Address: 192.1.1.45
*/

-- Step 31.6 -->> On Both Node
[root@invoice1/invoice2 ~]# nslookup invoice2-vip
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   invoice2-vip.unidev.com
Address: 192.1.1.43
*/

-- Step 31.7 -->> On Both Node
[root@invoice1/invoice2 ~]# nslookup invoice1-vip
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   invoice1-vip.unidev.com
Address: 192.1.1.42
*/

-- Step 31.8 -->> On Both Node
[root@invoice1/invoice2 ~]# iptables -L -nv
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
[root@invoice1/invoice2 ~]# cd /run/media/root/OL-7.8\ Server.x86_64/Packages/
[root@invoice1/invoice2 Packages]# yum update

-- Step 32.1 -->> On Both Node
[root@invoice1/invoice2 Packages]# yum install -y yum-utils
[root@invoice1/invoice2 Packages]# yum install -y oracle-epel-release-el7
[root@invoice1/invoice2 Packages]# yum-config-manager --enable ol7_developer_EPEL
[root@invoice1/invoice2 Packages]# yum install -y sshpass zip unzip
[root@invoice1/invoice2 Packages]# yum install -y oracle-database-preinstall-19c

-- Step 32.2 -->> On Both Node
[root@invoice1/invoice2 Packages]# yum install -y bc    
[root@invoice1/invoice2 Packages]# yum install -y binutils
[root@invoice1/invoice2 Packages]# yum install -y compat-libcap1
[root@invoice1/invoice2 Packages]# yum install -y compat-libstdc++-33
[root@invoice1/invoice2 Packages]# yum install -y dtrace-utils
[root@invoice1/invoice2 Packages]# yum install -y elfutils-libelf
[root@invoice1/invoice2 Packages]# yum install -y elfutils-libelf-devel
[root@invoice1/invoice2 Packages]# yum install -y fontconfig-devel
[root@invoice1/invoice2 Packages]# yum install -y glibc
[root@invoice1/invoice2 Packages]# yum install -y glibc-devel
[root@invoice1/invoice2 Packages]# yum install -y ksh
[root@invoice1/invoice2 Packages]# yum install -y libaio
[root@invoice1/invoice2 Packages]# yum install -y libaio-devel
[root@invoice1/invoice2 Packages]# yum install -y libdtrace-ctf-devel
[root@invoice1/invoice2 Packages]# yum install -y libXrender
[root@invoice1/invoice2 Packages]# yum install -y libXrender-devel
[root@invoice1/invoice2 Packages]# yum install -y libX11
[root@invoice1/invoice2 Packages]# yum install -y libXau
[root@invoice1/invoice2 Packages]# yum install -y libXi
[root@invoice1/invoice2 Packages]# yum install -y libXtst
[root@invoice1/invoice2 Packages]# yum install -y libgcc
[root@invoice1/invoice2 Packages]# yum install -y librdmacm-devel
[root@invoice1/invoice2 Packages]# yum install -y libstdc++
[root@invoice1/invoice2 Packages]# yum install -y libstdc++-devel
[root@invoice1/invoice2 Packages]# yum install -y libxcb
[root@invoice1/invoice2 Packages]# yum install -y make
[root@invoice1/invoice2 Packages]# yum install -y net-tools
[root@invoice1/invoice2 Packages]# yum install -y nfs-utils
[root@invoice1/invoice2 Packages]# yum install -y python
[root@invoice1/invoice2 Packages]# yum install -y python-configshell
[root@invoice1/invoice2 Packages]# yum install -y python-rtslib
[root@invoice1/invoice2 Packages]# yum install -y python-six
[root@invoice1/invoice2 Packages]# yum install -y targetcli
[root@invoice1/invoice2 Packages]# yum install -y smartmontools
[root@invoice1/invoice2 Packages]# yum install -y sysstat
[root@invoice1/invoice2 Packages]# yum install -y unixODBC
[root@invoice1/invoice2 Packages]# yum install -y chrony
[root@invoice1/invoice2 Packages]# rpm -iUvh glibc-2*i686* nss-softokn-freebl-3*i686*
[root@invoice1/invoice2 Packages]# rpm -iUvh glibc-devel-2*i686*
[root@invoice1/invoice2 Packages]# rpm -iUvh libaio-0*i686*
[root@invoice1/invoice2 Packages]# rpm -iUvh libaio-devel-0*i686*
[root@invoice1/invoice2 Packages]# rpm -iUvh numactl-devel-2*x86_64*
[root@invoice1/invoice2 Packages]# rpm -iUvh libtool-ltdl*i686*
[root@invoice1/invoice2 Packages]# yum install -y oracleasm*
[root@invoice1/invoice2 Packages]# yum -y update


-- Step 33 -->> On Both Node
--https://yum.oracle.com/repo/OracleLinux/OL7/8/base/x86_64/index.html
[root@invoice1/invoice2 ~]# cd /root/OracleLinux7_8_RPM/
[root@invoice1/invoice2 OracleLinux7_8_RPM]# rpm -iUvh compat-libcap1-1.10-7.el7.i686.rpm
[root@invoice1/invoice2 OracleLinux7_8_RPM]# rpm -iUvh glibc-utils-2.17-307.0.1.el7.1.x86_64.rpm
[root@invoice1/invoice2 OracleLinux7_8_RPM]# rpm -iUvh ncurses-devel-5.9-14.20130511.el7_4.x86_64.rpm
[root@invoice1/invoice2 OracleLinux7_8_RPM]# rpm -iUvh unixODBC-devel-2.3.1-14.0.1.el7.x86_64.rpm
[root@invoice1/invoice2 OracleLinux7_8_RPM]# rpm -iUvh oracleasmlib-2.0.12-1.el7.x86_64.rpm

-- Step 33.1 -->> On Both Node
[root@invoice1/invoice2 OracleLinux7_8_RPM]# rpm -iUvh --nodeps --force elfutils-libelf-devel-static-0.176-2.el7.x86_64.rpm
[root@invoice1/invoice2 OracleLinux7_8_RPM]# rpm -iUvh --nodeps --force numactl-2.0.12-5.el7.x86_64.rpm
[root@invoice1/invoice2 OracleLinux7_8_RPM]# rpm -iUvh --nodeps --force numactl-devel-2.0.12-5.el7.i686.rpm
[root@invoice1/invoice2 OracleLinux7_8_RPM]# rpm -iUvh --nodeps --force numactl-devel-2.0.12-5.el7.x86_64.rpm
[root@invoice1/invoice2 OracleLinux7_8_RPM]# rpm -iUvh --nodeps --force python3-3.6.8-13.0.1.el7.x86_64.rpm
[root@invoice1/invoice2 OracleLinux7_8_RPM]# rpm -iUvh --nodeps --force python3-libs-3.6.8-13.0.1.el7.i686.rpm
[root@invoice1/invoice2 OracleLinux7_8_RPM]# rpm -iUvh --nodeps --force python3-libs-3.6.8-13.0.1.el7.x86_64.rpm



-- Step 34 -->> On Both Node
[root@invoice1/invoice2 ~]# cd /run/media/root/OL-7.8\ Server.x86_64/Packages/
[root@invoice1/invoice2 Packages]# yum install compat-libcap1 compat-libstdc++-33 bc binutils elfutils-libelf elfutils-libelf-devel fontconfig-devel glibc glibc-devel ksh libaio libaio-devel libgcc libnsl librdmacm-devel libstdc++ libstdc++-devel libX11 libXau libxcb libXi libXrender libXrender-devel libXtst make net-tools nfs-utils python3 python3-configshell python3-rtslib python3-six smartmontools sysstat targetcli unzip
[root@invoice1/invoice2 Packages]# yum -y update

-- Step 35 -->> On Both Node
[root@invoice1/invoice2 Packages]# rpm -q binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel elfutils-libelf-devel-static \
[root@invoice1/invoice2 Packages]# rpm -q gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers kernel-headers ksh libaio libaio-devel \
[root@invoice1/invoice2 Packages]# rpm -q libgcc libgomp libstdc++ libstdc++-devel make numactl-devel sysstat unixODBC unixODBC-devel \


-- Step 36 -->> On Both Node
-- Pre-Installation Steps for ASM
[root@invoice1/invoice2 ~ ]# cd /etc/yum.repos.d
[root@invoice1/invoice2 yum.repos.d]# uname -ras
/*
Linux invoice2.unidev.com 4.14.35-1902.300.11.el7uek.x86_64 #2 SMP Tue Mar 17 17:11:47 PDT 2020 x86_64 x86_64 x86_64 GNU/Linux
*/

-- Step 36.1 -->> On Both Node
[root@invoice1/invoice2 yum.repos.d]# cat /etc/os-release 
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
[root@invoice1/invoice2 yum.repos.d]# yum install kmod-oracleasm
[root@invoice1/invoice2 yum.repos.d]# yum install oracleasm-support

-- Step 36.3 -->> On Both Node
[root@invoice1/invoice2 yum.repos.d]# rpm -qa | grep oracleasm
/*
oracleasmlib-2.0.12-1.el7.x86_64
oracleasm-support-2.1.11-2.el7.x86_64
kmod-oracleasm-2.0.8-27.0.1.el7.x86_64
*/

-- Step 37 -->> On Both Node
-- Add the kernel parameters file "/etc/sysctl.conf" and add oracle recommended kernel parameters
[root@invoice1/invoice2 ~]# vi /etc/sysctl.conf
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
[root@invoice1/invoice2 ~]# sysctl -p /etc/sysctl.conf

-- Step 38 -->> On Both Node
-- Edit “/etc/security/limits.d/oracle-database-preinstall-19c.conf” file to limit user processes
[root@invoice1/invoice2 ~]# vi /etc/security/limits.d/oracle-database-preinstall-19c.conf
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
[root@invoice1/invoice2 ~]# vi /etc/pam.d/login
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
[root@invoice1/invoice2 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:
*/

-- Step 40.1 -->> On both Node
[root@invoice1/invoice2 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:
backupdba:x:54324:
dgdba:x:54325:
kmdba:x:54326:
invoicedba:x:54330:
*/

-- Step 40.2 -->> On both Node
[root@invoice1/invoice2 ~]# cat /etc/group | grep -i oracle
/*
oracle:x:1000:oracle
*/

-- Step 40.3 -->> On both Node
[root@invoice1/invoice2 ~]# cat /etc/group | grep -i asm

-- Step 40.4 -->> On both Node
-- 1.Create OS groups using the command below. Enter these commands as the 'root' user:
[root@invoice1/invoice2 ~]# /usr/sbin/groupadd -g 503 oper
[root@invoice1/invoice2 ~]# /usr/sbin/groupadd -g 504 asmadmin
[root@invoice1/invoice2 ~]# /usr/sbin/groupadd -g 506 asmdba
[root@invoice1/invoice2 ~]# /usr/sbin/groupadd -g 507 asmoper
[root@invoice1/invoice2 ~]# /usr/sbin/groupadd -g 508 beoper

-- Step 40.5 -->> On both Node
-- 2.Create the users that will own the Oracle software using the commands:
[root@invoice1/invoice2 ~]# /usr/sbin/useradd  -g oinstall -G oinstall,dba,asmadmin,asmdba,asmoper,beoper grid
[root@invoice1/invoice2 ~]# /usr/sbin/usermod -g oinstall -G oinstall,dba,oper,asmdba,asmadmin,backupdba,dgdba,kmdba,racdba oracle

-- Step 40.6 -->> On both Node
[root@invoice1/invoice2 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/

-- Step 40.7 -->> On both Node
[root@invoice1/invoice2 ~]# cat /etc/group | grep -i oracle
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
[root@invoice1/invoice2 ~]# cat /etc/group | grep -i grid
/*
oinstall:x:54321:grid,oracle
dba:x:54322:grid,oracle
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 40.9 -->> On both Node
[root@invoice1/invoice2 ~]# cat /etc/group | grep -i oper
/*
oper:x:54323:oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 40.10 -->> On both Node
[root@invoice1/invoice2 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:grid,oracle
*/

-- Step 40.11 -->> On both Node
[root@invoice1/invoice2 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:grid,oracle
backupdba:x:54324:oracle
dgdba:x:54325:oracle
kmdba:x:54326:oracle
invoicedba:x:54330:oracle
asmdba:x:506:grid,oracle
*/

-- Step 40.12 -->> On both Node
[root@invoice1/invoice2 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/

-- Step 41 -->> On both Node
[root@invoice1/invoice2 ~]# passwd oracle
/*
Changing password for user oracle.
New password: Or@cL5@!Nv#
Retype new password: Or@cL5@!Nv#
passwd: all authentication tokens updated successfully.
*/

-- Step 42 -->> On both Node
[root@invoice1/invoice2 ~]# passwd grid
/*
Changing password for user grid.
New password: Gr!D4@!Nv#
Retype new password: Gr!D4@!Nv#
passwd: all authentication tokens updated successfully.
*/

-- Step 42.1 -->> On both Node
[root@invoice1/invoice2 ~]# su - oracle

-- Step 42.2 -->> On both Node
[oracle@invoice1/invoice2 ~]$ su - grid
/*
Password: Gr!D4@!Nv#
*/

-- Step 42.3 -->> On both Node
[grid@invoice1/invoice2 ~]$ su - oracle
/*
Password: Or@cL5@!Nv#
*/

-- Step 42.4 -->> On both Node
[oracle@invoice1/invoice2 ~]$ exit
/*
logout
*/

-- Step 42.5 -->> On both Node
[grid@invoice1/invoice2 ~]$ exit
/*
logout
*/

-- Step 42.6 -->> On both Node
[oracle@invoice1/invoice2 ~]$ exit
/*
logout
*/


-- Step 43 -->> On both Node
--Create the Oracle Inventory Director:
[root@invoice1/invoice2 ~]# mkdir -p /opt/app/oraInventory
[root@invoice1/invoice2 ~]# chown -R grid:oinstall /opt/app/oraInventory
[root@invoice1/invoice2 ~]# chmod -R 775 /opt/app/oraInventory

-- Step 44 -->> On both Node
--Creating the Oracle Grid Infrastructure Home Directory:
[root@invoice1/invoice2 ~]# mkdir -p /opt/app/19c/grid
[root@invoice1/invoice2 ~]# chown -R grid:oinstall /opt/app/19c/grid
[root@invoice1/invoice2 ~]# chmod -R 775 /opt/app/19c/grid

-- Step 45 -->> On both Node
--Creating the Oracle Base Directory
[root@invoice1/invoice2 ~]# mkdir -p /opt/app/oracle
[root@invoice1/invoice2 ~]# chmod -R 775 /opt/app/oracle
[root@invoice1/invoice2 ~]# cd /opt/app/
[root@invoice1/invoice2 ~]# chown -R oracle:oinstall /opt/app/oracle

-- Step 46 -->> On Node 1
-- Login as the oracle user and add the following lines at the end of the ".bash_profile" file.
[root@invoice1 ~]# su - oracle
[oracle@invoice1 ~]$ vi .bash_profile
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

ORACLE_HOSTNAME=invoice1.unidev.com; export ORACLE_HOSTNAME
ORACLE_UNQNAME=invoicedb; export ORACLE_UNQNAME
ORACLE_BASE=/opt/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/19c/db_1; export ORACLE_HOME
ORACLE_SID=invoiced1; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 47 -->> On Node 1
[oracle@invoice1 ~]$ . .bash_profile

-- Step 48 -->> On Node 1
-- Login as the grid user and add the following lines at the end of the ".bash_profile" file.
[root@invoice1 ~]# su - grid
[grid@invoice1 ~]$ vi .bash_profile
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
[grid@invoice1 ~]$ . .bash_profile

-- Step 50 -->> On Node 2
-- Login as the oracle user and add the following lines at the end of the ".bash_profile" file.
[root@invoice2 ~]# su - oracle
[oracle@invoice2 ~]$ vi .bash_profile
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

ORACLE_HOSTNAME=invoice2.unidev.com; export ORACLE_HOSTNAME
ORACLE_UNQNAME=invoicedb; export ORACLE_UNQNAME
ORACLE_BASE=/opt/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/19c/db_1; export ORACLE_HOME
ORACLE_SID=invoiced2; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 51 -->> On Node 2
[oracle@invoice2 ~]$ . .bash_profile

-- Step 52 -->> On Node 2
-- Login as the grid user and add the following lines at the end of the ".bash_profile" file.
[root@invoice2 ~]# su - grid
[grid@invoice2 ~]$ vi .bash_profile
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
[grid@invoice2 ~]$ . .bash_profile

-- Step 54 -->> On Node 1
-- To Unzio The Oracle Grid Software and lateset Opatch
[root@invoice1 ~]# cd /opt/app/19c/grid/
[root@invoice1 grid]# unzip -oq /root/19.3.0.0.0/LINUX.X64_193000_grid_home.zip
[root@invoice1 grid]# unzip -oq /root/PSU_19.7.0.0.0/p6880880_190000_LINUX.zip

-- Step 55 -->> On Node 1
-- To Unzio The Oracle PSU
[root@invoice1 ~]# cd /tmp/
[root@invoice1 tmp]# unzip -oq /root/PSU_19.7.0.0.0/p30783556_190000_Linux-x86-64.zip
[root@invoice1 tmp]# chown -R oracle:oinstall 30783556
[root@invoice2 tmp]# chmod -R 775 30783556
[root@invoice1 tmp]# ls -ltr | grep 30783556
/*
drwxrwxrwx  4 oracle oinstall   4096 Apr 14 20:35 30783556
*/

-- Step 56 -->> On Node 1
-- Login as root user and issue the following command at invoice1
[root@invoice1 ~]# chown -R grid:oinstall /opt/app/19c/grid/
[root@invoice1 ~]# chmod -R 775 /opt/app/19c/grid/

-- Step 57 -->> On Node 1
[root@invoice1 ~]# scp -r /opt/app/19c/grid/cv/rpm/cvuqdisk-1.0.10-1.rpm root@invoice2:/tmp/
/*
The authenticity of host 'invoice2 (192.1.1.41)' can't be established.
ECDSA key fingerprint is SHA256:xbrtUbvMFe/Qk3JlBjTr6BA36PUaGkNpW9i/+2IwSTY.
ECDSA key fingerprint is MD5:9c:57:05:c6:13:51:73:97:f7:40:c7:7c:8a:5c:f9:0f.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'invoice2,192.1.1.41' (ECDSA) to the list of known hosts.
root@invoice2's password:
cvuqdisk-1.0.10-1.rpm                                                            100%   11KB   9.1MB/s   00:00
*/

-- Step 58 -->> On Node 1
-- To install the cvuqdisk-1.0.10-1.rpm
-- Login from root user
[root@invoice1 ~]# cd /opt/app/19c/grid/cv/rpm/

-- Step 58.1 -->> On Node 1
[root@invoice1 rpm]# ls -ltr
/*
-rwxrwxr-x 1 grid oinstall 11412 Mar 13  2019 cvuqdisk-1.0.10-1.rpm
*/

-- Step 58.2 -->> On Node 1
[root@invoice1 rpm]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP

-- Step 58.3 -->> On Node 1
[root@invoice1 rpm]# rpm -iUvh cvuqdisk-1.0.10-1.rpm 
/*
Preparing...                          ################################# [100%]
Updating / installing...
   1:cvuqdisk-1.0.10-1                ################################# [100%]
*/

-- Step 59 -->> On Node 2
[root@invoice2 ~]# cd /tmp/
[root@invoice2 tmp]# chown -R grid:oinstall cvuqdisk-1.0.10-1.rpm
[root@invoice2 tmp]# chmod -R 775 cvuqdisk-1.0.10-1.rpm
[root@invoice2 tmp]# ls -ltr | grep cvuqdisk-1.0.10-1.rpm
/*
-rwxrwxr-x  1 grid oinstall 11412 Nov  7 10:36 cvuqdisk-1.0.10-1.rpm
*/

-- Step 60 -->> On Node 2
-- To install the cvuqdisk-1.0.10-1.rpm
-- Login from root user
[root@invoice2 ~]# cd /tmp/
[root@invoice2 tmp]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP
[root@invoice2 tmp]# rpm -iUvh cvuqdisk-1.0.10-1.rpm 
/*
Preparing...                          ################################# [100%]
Updating / installing...
   1:cvuqdisk-1.0.10-1                ################################# [100%]
*/

-- Step 61 -->> On all Node
[root@invoice1/invoice2 ~]# which oracleasm
/*
/usr/sbin/oracleasm
*/

-- Step 62 -->> On all Node
[root@invoice1/invoice2 ~]# oracleasm configure
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
[root@invoice1/invoice2 ~]# oracleasm status
/*
Checking if ASM is loaded: no
Checking if /dev/oracleasm is mounted: no
*/

-- Step 64 -->> On all Node
[root@invoice1/invoice2 ~]# oracleasm configure -i
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
[root@invoice1/invoice2 ~]# oracleasm configure
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
[root@invoice1/invoice2 ~]# oracleasm init
/*
Creating /dev/oracleasm mount point: /dev/oracleasm
Loading module "oracleasm": oracleasm
Configuring "oracleasm" to use device physical block size
Mounting ASMlib driver filesystem: /dev/oracleasm
*/

-- Step 67 -->> On all Node
[root@invoice1/invoice2 ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 68 -->> On all Node
[root@invoice1/invoice2 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 69 -->> On all Node
[root@invoice1/invoice2 ~]# oracleasm listdisks

[root@invoice1/invoice2 ~]# ls -ltr /etc/init.d/
/*
-rwxr-xr-x  1 root root  4954 Feb  3  2018 oracleasm
-rwxr-xr-x. 1 root root  2437 Feb  6  2018 rhnsd
-rwxr-xr-x  1 root root  4569 May 22  2020 netconsole
-rw-r--r--  1 root root 18281 May 22  2020 functions
-rwx------  1 root root  1281 Apr  1  2021 oracle-database-preinstall-19c-firstboot
-rwxr-xr-x  1 root root  9198 Apr 26  2022 network
-rw-r--r--  1 root root  1160 Aug 25 07:36 README
*/

-- Step 70 -->> On Both Node
[root@invoice1/invoice2 ~]# ls -ll /dev/oracleasm/disks/
/*
total 0
*/

-- Step 71 -->> On Both Node
[root@invoice1/invoice2 ~]# ls -ll /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Nov  7 13:25 /dev/sda
brw-rw---- 1 root disk 8,  1 Nov  7 13:25 /dev/sda1
brw-rw---- 1 root disk 8,  2 Nov  7 13:25 /dev/sda2
brw-rw---- 1 root disk 8,  3 Nov  7 13:25 /dev/sda3
brw-rw---- 1 root disk 8,  4 Nov  7 13:25 /dev/sda4
brw-rw---- 1 root disk 8,  5 Nov  7 13:25 /dev/sda5
brw-rw---- 1 root disk 8,  6 Nov  7 13:25 /dev/sda6
brw-rw---- 1 root disk 8,  7 Nov  7 13:25 /dev/sda7
brw-rw---- 1 root disk 8,  8 Nov  7 13:25 /dev/sda8
brw-rw---- 1 root disk 8,  9 Nov  7 13:25 /dev/sda9
brw-rw---- 1 root disk 8, 16 Nov  7 13:25 /dev/sdb
brw-rw---- 1 root disk 8, 32 Nov  7 13:25 /dev/sdc
brw-rw---- 1 root disk 8, 48 Nov  7 13:25 /dev/sdd
*/

-- Step 72 -->> On Node 1
[root@invoice1 ~]# fdisk -ll | grep GB
/*
Disk /dev/sdd: 536.9 GB, 536870912000 bytes, 1048576000 sectors
Disk /dev/sda: 268.4 GB, 268435456000 bytes, 524288000 sectors
Disk /dev/sdc: 161.1 GB, 161061273600 bytes, 314572800 sectors
Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
*/

-- Step 73 -->> On Node 1
[root@invoice1 ~]# fdisk /dev/sdb
/*
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0x0625fb88.

Command (m for help): p

Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x0625fb88

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
Disk identifier: 0x0625fb88

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048    41943039    20970496   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 74 -->> On Node 1
[root@invoice1 ~]# fdisk  /dev/sdc
/*
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0x197654f8.

Command (m for help): p

Disk /dev/sdc: 161.1 GB, 161061273600 bytes, 314572800 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x197654f8

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
Disk identifier: 0x197654f8

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1            2048   314572799   157285376   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 75 -->> On Node 1
[root@invoice1 ~]# fdisk /dev/sdd
/*
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0x3c886d5c.

Command (m for help): p

Disk /dev/sdd: 536.9 GB, 536870912000 bytes, 1048576000 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x3c886d5c

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
Disk identifier: 0x3c886d5c

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1            2048  1048575999   524286976   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 76 -->> On Node 1
[root@invoice1 ~]# ls -ll /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Nov  7 13:25 /dev/sda
brw-rw---- 1 root disk 8,  1 Nov  7 13:25 /dev/sda1
brw-rw---- 1 root disk 8,  2 Nov  7 13:25 /dev/sda2
brw-rw---- 1 root disk 8,  3 Nov  7 13:25 /dev/sda3
brw-rw---- 1 root disk 8,  4 Nov  7 13:25 /dev/sda4
brw-rw---- 1 root disk 8,  5 Nov  7 13:25 /dev/sda5
brw-rw---- 1 root disk 8,  6 Nov  7 13:25 /dev/sda6
brw-rw---- 1 root disk 8,  7 Nov  7 13:25 /dev/sda7
brw-rw---- 1 root disk 8,  8 Nov  7 13:25 /dev/sda8
brw-rw---- 1 root disk 8,  9 Nov  7 13:25 /dev/sda9
brw-rw---- 1 root disk 8, 16 Nov  7 13:29 /dev/sdb
brw-rw---- 1 root disk 8, 17 Nov  7 13:29 /dev/sdb1
brw-rw---- 1 root disk 8, 32 Nov  7 13:30 /dev/sdc
brw-rw---- 1 root disk 8, 33 Nov  7 13:30 /dev/sdc1
brw-rw---- 1 root disk 8, 48 Nov  7 13:30 /dev/sdd
brw-rw---- 1 root disk 8, 49 Nov  7 13:30 /dev/sdd1
*/

-- Step 77 -->> On Both Node
[root@invoice1/invoice2 ~]# fdisk -ll | grep sd
/*
Disk /dev/sdd: 536.9 GB, 536870912000 bytes, 1048576000 sectors
/dev/sdd1            2048  1048575999   524286976   83  Linux
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
Disk /dev/sdc: 161.1 GB, 161061273600 bytes, 314572800 sectors
/dev/sdc1            2048   314572799   157285376   83  Linux
Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
/dev/sdb1            2048    41943039    20970496   83  Linux
*/

-- Step 78 -->> On Node 1
[root@invoice1 ~]# mkfs.ext4 /dev/sdb1
[root@invoice1 ~]# mkfs.ext4 /dev/sdc1
[root@invoice1 ~]# mkfs.ext4 /dev/sdd1

-- Step 79 -->> On Node 1
[root@invoice1 ~]# oracleasm createdisk OCR /dev/sdb1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 80 -->> On Node 1
[root@invoice1 ~]# oracleasm createdisk ARC /dev/sdc1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 81 -->> On Node 1
[root@invoice1 ~]# oracleasm createdisk DATA /dev/sdd1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 82 -->> On Node 1
[root@invoice1 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 83 -->> On Node 1
[root@invoice1 ~]# oracleasm listdisks
/*
ARC
DATA
OCR
*/

-- Step 84 -->> On Node 2
[root@invoice2 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
Instantiating disk "OCR"
Instantiating disk "ARC"
Instantiating disk "DATA"
*/

-- Step 85 -->> On Node 2
[root@invoice2 ~]# oracleasm listdisks
/*
ARC
DATA
OCR
*/

-- Step 86 -->> On Both Node
[root@invoice1/invoice2 ~]# ls -ll /dev/oracleasm/disks/
/*
brw-rw---- 1 grid asmadmin 8, 33 Nov  7 13:35 ARC
brw-rw---- 1 grid asmadmin 8, 49 Nov  7 13:35 DATA
brw-rw---- 1 grid asmadmin 8, 17 Nov  7 13:34 OCR
*/

-- Step 87 -->> On Node 1
-- To setup SSH Pass
[root@invoice1 ~]# su - grid
[grid@invoice1 ~]$ cd /opt/app/19c/grid/deinstall
[grid@invoice1 deinstall]$ ./sshUserSetup.sh -user grid -hosts "invoice1 invoice2" -noPromptPassphrase -confirm -advanced
/*
Password: Gr!D4@!Nv#
*/
-- Step 88 -->> On Node 1
[grid@invoice1/invoice2 ~]$ ssh grid@invoice1 date
[grid@invoice1/invoice2 ~]$ ssh grid@invoice2 date
[grid@invoice1/invoice2 ~]$ ssh grid@invoice1 date && ssh grid@invoice2 date
[grid@invoice1/invoice2 ~]$ ssh grid@invoice1.unidev.com date
[grid@invoice1/invoice2 ~]$ ssh grid@invoice2.unidev.com date
[grid@invoice1/invoice2 ~]$ ssh grid@invoice1.unidev.com date && ssh grid@invoice2.unidev.com date

-- Step 89 -->> On Node 1
-- Pre-check for rac Setup
[grid@invoice1 ~]$ cd /opt/app/19c/grid/
[grid@invoice1 grid]$ ./runcluvfy.sh stage -pre crsinst -n invoice1,invoice2 -verbose
[grid@invoice1 grid]$ ./runcluvfy.sh stage -pre crsinst -n invoice1,invoice2 -method root
--[grid@invoice1 grid]$ ./runcluvfy.sh stage -pre crsinst -n invoice1,invoice2 -fixup -verbose (If Required)

-- Step 90 -->> On Node 1
-- To Create a Response File to Install GID
[grid@invoice1 ~]$ cp /opt/app/19c/grid/install/response/gridsetup.rsp /home/grid/
[grid@invoice1 ~]$ cd /home/grid/
[grid@invoice1 ~]$ ls -ltr | grep gridsetup.rsp
/*
-rwxr-xr-x 1 grid oinstall 36221 Sep 17 12:35 gridsetup.rsp
*/

-- Step 90.1 -->> On Node 1
[root@invoice1 grid]# vi gridsetup.rsp
/*
oracle.install.responseFileVersion=/oracle/install/rspfmt_crsinstall_response_schema_v19.0.0
INVENTORY_LOCATION=/opt/app/oraInventory
oracle.install.option=CRS_CONFIG
ORACLE_BASE=/opt/app/oracle
oracle.install.asm.OSDBA=asmdba
oracle.install.asm.OSOPER=asmoper
oracle.install.asm.OSASM=asmadmin
oracle.install.crs.config.scanType=LOCAL_SCAN
oracle.install.crs.config.gpnp.scanName=invoice-scan
oracle.install.crs.config.gpnp.scanPort=1521
oracle.install.crs.config.ClusterConfiguration=STANDALONE
oracle.install.crs.config.configureAsExtendedCluster=false
oracle.install.crs.config.clusterName=inv-cluster
oracle.install.crs.config.gpnp.configureGNS=false
oracle.install.crs.config.autoConfigureClusterNodeVIP=false
oracle.install.crs.config.clusterNodes=invoice1:invoice1-vip,invoice2:invoice2-vip
oracle.install.crs.config.networkInterfaceList=ens32:192.1.1.0:1,ens33:10.0.1.0:5
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
[grid@invoice1 ~]$ cd /opt/app/19c/grid/
[grid@invoice1 grid]$ ./gridSetup.sh -ignorePrereq -waitForCompletion -silent -applyRU /tmp/30783556/30899722 -responseFile /home/grid/gridsetup.rsp
/*
Preparing the home to patch...
Applying the patch /tmp/30783556/30899722...
Successfully applied the patch.
The log can be found at: /tmp/GridSetupActions2022-11-07_02-30-14PM/installerPatchActions_2022-11-07_02-30-14PM.log
Launching Oracle Grid Infrastructure Setup Wizard...

[WARNING] [INS-13014] Target environment does not meet some optional requirements.
   CAUSE: Some of the optional prerequisites are not met. See logs for details. gridSetupActions2022-11-07_02-30-14PM.log
   ACTION: Identify the list of failed prerequisite checks from the log: gridSetupActions2022-11-07_02-30-14PM.log. Then either from the log file or from installation manual find the appropriate configuration to meet the prerequisites and fix it manually.
The response file for this session can be found at:
 /opt/app/19c/grid/install/response/grid_2022-11-07_02-30-14PM.rsp

You can find the log of this install session at:
 /tmp/GridSetupActions2022-11-07_02-30-14PM/gridSetupActions2022-11-07_02-30-14PM.log

As a root user, execute the following script(s):
        1. /opt/app/oraInventory/orainstRoot.sh
        2. /opt/app/19c/grid/root.sh

Execute /opt/app/oraInventory/orainstRoot.sh on the following nodes:
[invoice1, invoice2]
Execute /opt/app/19c/grid/root.sh on the following nodes:
[invoice1, invoice2]

Run the script on the local node first. After successful completion, you can start the script in parallel on all other nodes.

Successfully Setup Software with warning(s).
As install user, execute the following command to complete the configuration.
        /opt/app/19c/grid/gridSetup.sh -executeConfigTools -responseFile /home/grid/gridsetup.rsp [-silent]


Moved the install session logs to:
 /opt/app/oraInventory/logs/GridSetupActions2022-11-07_02-30-14PM
*/

-- Step 92 -->> On Node 1
[root@invoice1 ~]# /opt/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 93 -->> On Node 2
[root@invoice2 ~]# /opt/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 94 -->> On Node 1
[root@invoice1 ~]# /opt/app/19c/grid/root.sh
/*
Check /opt/app/19c/grid/install/root_invoice1.unidev.com_2022-11-07_14-39-52-308884089.log for the output of root script
*/

-- Step 94.1 -->> On Node 1
[root@invoice1 ~]# tail -f /opt/app/19c/grid/install/root_invoice1.unidev.com_2022-11-07_14-39-52-308884089.log
/*
Creating /etc/oratab file...
Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Relinking oracle with rac_on option
Using configuration parameter file: /opt/app/19c/grid/crs/install/crsconfig_params
The log of current session can be found at:
  /opt/app/oracle/crsdata/invoice1/crsconfig/rootcrs_invoice1_2022-11-07_02-40-12PM.log
2022/11/07 14:40:26 CLSRSC-594: Executing installation step 1 of 19: 'SetupTFA'.
2022/11/07 14:40:26 CLSRSC-594: Executing installation step 2 of 19: 'ValidateEnv'.
2022/11/07 14:40:26 CLSRSC-363: User ignored prerequisites during installation
2022/11/07 14:40:26 CLSRSC-594: Executing installation step 3 of 19: 'CheckFirstNode'.
2022/11/07 14:40:29 CLSRSC-594: Executing installation step 4 of 19: 'GenSiteGUIDs'.
2022/11/07 14:40:30 CLSRSC-594: Executing installation step 5 of 19: 'SetupOSD'.
2022/11/07 14:40:30 CLSRSC-594: Executing installation step 6 of 19: 'CheckCRSConfig'.
2022/11/07 14:40:30 CLSRSC-594: Executing installation step 7 of 19: 'SetupLocalGPNP'.
2022/11/07 14:40:47 CLSRSC-594: Executing installation step 8 of 19: 'CreateRootCert'.
2022/11/07 14:40:52 CLSRSC-594: Executing installation step 9 of 19: 'ConfigOLR'.
2022/11/07 14:41:10 CLSRSC-4002: Successfully installed Oracle Trace File Analyzer (TFA) Collector.
2022/11/07 14:41:11 CLSRSC-594: Executing installation step 10 of 19: 'ConfigCHMOS'.
2022/11/07 14:41:11 CLSRSC-594: Executing installation step 11 of 19: 'CreateOHASD'.
2022/11/07 14:41:18 CLSRSC-594: Executing installation step 12 of 19: 'ConfigOHASD'.
2022/11/07 14:41:19 CLSRSC-330: Adding Clusterware entries to file 'oracle-ohasd.service'
2022/11/07 14:41:44 CLSRSC-594: Executing installation step 13 of 19: 'InstallAFD'.
2022/11/07 14:41:44 CLSRSC-594: Executing installation step 14 of 19: 'InstallACFS'.
2022/11/07 14:41:51 CLSRSC-594: Executing installation step 15 of 19: 'InstallKA'.
2022/11/07 14:41:58 CLSRSC-594: Executing installation step 16 of 19: 'InitConfig'.
Redirecting to /bin/systemctl restart rsyslog.service

ASM has been created and started successfully.

[DBT-30001] Disk groups created successfully. Check /opt/app/oracle/cfgtoollogs/asmca/asmca-221107PM024231.log for details.

2022/11/07 14:43:19 CLSRSC-482: Running command: '/opt/app/19c/grid/bin/ocrconfig -upgrade grid oinstall'
CRS-4256: Updating the profile
Successful addition of voting disk 675045c626564fa1bfc94b2bad87e6ff.
Successfully replaced voting disk group with +OCR.
CRS-4256: Updating the profile
CRS-4266: Voting file(s) successfully replaced
##  STATE    File Universal Id                File Name Disk group
--  -----    -----------------                --------- ---------
 1. ONLINE   675045c626564fa1bfc94b2bad87e6ff (/dev/oracleasm/disks/OCR) [OCR]
Located 1 voting disk(s).
2022/11/07 14:44:23 CLSRSC-594: Executing installation step 17 of 19: 'StartCluster'.
2022/11/07 14:45:30 CLSRSC-343: Successfully started Oracle Clusterware stack
2022/11/07 14:45:30 CLSRSC-594: Executing installation step 18 of 19: 'ConfigNode'.
2022/11/07 14:47:06 CLSRSC-594: Executing installation step 19 of 19: 'PostConfig'.
2022/11/07 14:47:35 CLSRSC-325: Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 95 -->> On Node 2
[root@invoice2 ~]# /opt/app/19c/grid/root.sh
/*
Check /opt/app/19c/grid/install/root_invoice2.unidev.com_2022-11-07_14-54-45-647181579.log for the output of root script
*/

-- Step 95.1 -->> On Node 2
[root@invoice2 ~]# tail -f /opt/app/19c/grid/install/root_invoice2.unidev.com_2022-11-07_14-54-45-647181579.log
/*
Creating /etc/oratab file...
Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Relinking oracle with rac_on option
Using configuration parameter file: /opt/app/19c/grid/crs/install/crsconfig_params
The log of current session can be found at:
  /opt/app/oracle/crsdata/invoice2/crsconfig/rootcrs_invoice2_2022-11-07_02-55-0PM.log
2022/11/07 14:55:11 CLSRSC-594: Executing installation step 1 of 19: 'SetupTFA'.
2022/11/07 14:55:11 CLSRSC-594: Executing installation step 2 of 19: 'ValidateEnv'.
2022/11/07 14:55:11 CLSRSC-363: User ignored prerequisites during installation
2022/11/07 14:55:11 CLSRSC-594: Executing installation step 3 of 19: 'CheckFirstNode'.
2022/11/07 14:55:13 CLSRSC-594: Executing installation step 4 of 19: 'GenSiteGUIDs'.
2022/11/07 14:55:13 CLSRSC-594: Executing installation step 5 of 19: 'SetupOSD'.
2022/11/07 14:55:13 CLSRSC-594: Executing installation step 6 of 19: 'CheckCRSConfig'.
2022/11/07 14:55:14 CLSRSC-594: Executing installation step 7 of 19: 'SetupLocalGPNP'.
2022/11/07 14:55:16 CLSRSC-594: Executing installation step 8 of 19: 'CreateRootCert'.
2022/11/07 14:55:16 CLSRSC-594: Executing installation step 9 of 19: 'ConfigOLR'.
2022/11/07 14:55:29 CLSRSC-594: Executing installation step 10 of 19: 'ConfigCHMOS'.
2022/11/07 14:55:29 CLSRSC-594: Executing installation step 11 of 19: 'CreateOHASD'.
2022/11/07 14:55:31 CLSRSC-594: Executing installation step 12 of 19: 'ConfigOHASD'.
2022/11/07 14:55:31 CLSRSC-330: Adding Clusterware entries to file 'oracle-ohasd.service'
2022/11/07 14:55:53 CLSRSC-594: Executing installation step 13 of 19: 'InstallAFD'.
2022/11/07 14:55:53 CLSRSC-594: Executing installation step 14 of 19: 'InstallACFS'.
2022/11/07 14:55:56 CLSRSC-594: Executing installation step 15 of 19: 'InstallKA'.
2022/11/07 14:55:57 CLSRSC-594: Executing installation step 16 of 19: 'InitConfig'.
2022/11/07 14:56:03 CLSRSC-4002: Successfully installed Oracle Trace File Analyzer (TFA) Collector.
Redirecting to /bin/systemctl restart rsyslog.service
2022/11/07 14:56:06 CLSRSC-594: Executing installation step 17 of 19: 'StartCluster'.
2022/11/07 14:56:54 CLSRSC-343: Successfully started Oracle Clusterware stack
2022/11/07 14:56:54 CLSRSC-594: Executing installation step 18 of 19: 'ConfigNode'.
2022/11/07 14:57:09 CLSRSC-594: Executing installation step 19 of 19: 'PostConfig'.
2022/11/07 14:57:18 CLSRSC-325: Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 96 -->> On Node 1
[grid@invoice1 ~]$ cd /opt/app/19c/grid/
[grid@invoice1 grid]$ /opt/app/19c/grid/gridSetup.sh -silent -executeConfigTools -responseFile /home/grid/gridsetup.rsp
/*
Launching Oracle Grid Infrastructure Setup Wizard...

You can find the logs of this session at:
/opt/app/oraInventory/logs/GridSetupActions2022-11-07_02-59-22PM

You can find the log of this install session at:
 /opt/app/oraInventory/logs/UpdateNodeList2022-11-07_02-59-22PM.log
Successfully Configured Software.
*/

[root@invoice1 ~]# tail -f /opt/app/oraInventory/logs/UpdateNodeList2022-11-07_02-59-22PM.log
/*
INFO: All threads completed its operations
INFO: Checkpoint:Index file written and updated
INFO: Done calling doOperation.
INFO: 'UpdateNodeList' was successful.
*/

-- Step 97 -->> On Both Nodes
[root@invoice1/invoice2 ~]# cd /opt/app/19c/grid/bin/
[root@invoice1/invoice2 bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/


-- Step 98 -->> On Both Nodes
[root@invoice1/invoice2 ~]# cd /opt/app/19c/grid/bin/
[root@invoice1/invoice2 bin]# ./crsctl check cluster -all
/*
**************************************************************
invoice1:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
invoice2:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/

-- Step 99 -->> On Node 1
[root@invoice1 ~]# cd /opt/app/19c/grid/bin/
[root@invoice1 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       invoice1                 Started,STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.crf
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.crsd
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.cssd
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.ctssd
      1        ONLINE  ONLINE       invoice1                 OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.evmd
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.gipcd
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.gpnpd
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.mdnsd
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.storage
      1        ONLINE  ONLINE       invoice1                 STABLE
--------------------------------------------------------------------------------
*/


-- Step 100 -->> On Node 2
[root@invoice2 ~]# cd /opt/app/19c/grid/bin/
[root@invoice2 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.crf
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.crsd
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.cssd
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.ctssd
      1        ONLINE  ONLINE       invoice2                 OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.evmd
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.gipcd
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.gpnpd
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.mdnsd
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.storage
      1        ONLINE  ONLINE       invoice2                 STABLE
--------------------------------------------------------------------------------
*/

-- Step 101 -->> On Both Nodes
[root@invoice1/invoice2 ~]# cd /opt/app/19c/grid/bin/
[root@invoice1/invoice2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       invoice1                 STABLE
               ONLINE  ONLINE       invoice2                 STABLE
ora.chad
               ONLINE  ONLINE       invoice1                 STABLE
               ONLINE  ONLINE       invoice2                 STABLE
ora.net1.network
               ONLINE  ONLINE       invoice1                 STABLE
               ONLINE  ONLINE       invoice2                 STABLE
ora.ons
               ONLINE  ONLINE       invoice1                 STABLE
               ONLINE  ONLINE       invoice2                 STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       invoice1                 STABLE
      2        ONLINE  ONLINE       invoice2                 STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       invoice1                 STABLE
      2        ONLINE  ONLINE       invoice2                 STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       invoice1                 Started,STABLE
      2        ONLINE  ONLINE       invoice2                 Started,STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       invoice1                 STABLE
      2        ONLINE  ONLINE       invoice2                 STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.cvu
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.invoice1.vip
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.invoice2.vip
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.qosmserver
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.scan3.vip
      1        ONLINE  ONLINE       invoice1                 STABLE
--------------------------------------------------------------------------------
*/


-- Step 102 -->> On Both Nodes
[grid@invoice1/invoice2 ~]$ asmcmd
/*
ASMCMD> lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20140                0           20140              0             Y  OCR/
ASMCMD> exit
*/

-- Step 103 -->> On Both Nodes
[grid@invoice1/invoice2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 07-NOV-2022 15:06:58

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                07-NOV-2022 14:47:27
Uptime                    0 days 0 hr. 19 min. 30 sec
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
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/


-- Step 104 -->> On Node 1
-- To Create ASM storage for Data and Archive
[grid@invoice1 ~]$ cd /opt/app/19c/grid/bin

-- Step 104.1 -->> On Node 1
[grid@invoice1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName DATA -diskList /dev/oracleasm/disks/DATA -redundancy EXTERNAL

-- Step 104.2 -->> On Node 1
[grid@invoice1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName ARC -diskList /dev/oracleasm/disks/ARC -redundancy EXTERNAL

-- Step 105 -->> On Both Nodes
[grid@invoice1/invoice2 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Mon Nov 7 15:11:43 2022
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
[root@invoice1/invoice2 ~]# cd /opt/app/19c/grid/bin
[root@invoice1/invoice2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       invoice1                 STABLE
               ONLINE  ONLINE       invoice2                 STABLE
ora.chad
               ONLINE  ONLINE       invoice1                 STABLE
               ONLINE  ONLINE       invoice2                 STABLE
ora.net1.network
               ONLINE  ONLINE       invoice1                 STABLE
               ONLINE  ONLINE       invoice2                 STABLE
ora.ons
               ONLINE  ONLINE       invoice1                 STABLE
               ONLINE  ONLINE       invoice2                 STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ARC.dg(ora.asmgroup)
      1        ONLINE  ONLINE       invoice1                 STABLE
      2        ONLINE  ONLINE       invoice2                 STABLE
      3        ONLINE  OFFLINE                               STABLE
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       invoice1                 STABLE
      2        ONLINE  ONLINE       invoice2                 STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.DATA.dg(ora.asmgroup)
      1        ONLINE  ONLINE       invoice1                 STABLE
      2        ONLINE  ONLINE       invoice2                 STABLE
      3        ONLINE  OFFLINE                               STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       invoice1                 STABLE
      2        ONLINE  ONLINE       invoice2                 STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       invoice1                 Started,STABLE
      2        ONLINE  ONLINE       invoice2                 Started,STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       invoice1                 STABLE
      2        ONLINE  ONLINE       invoice2                 STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.cvu
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.invoice1.vip
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.invoice2.vip
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.qosmserver
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.scan3.vip
      1        ONLINE  ONLINE       invoice1                 STABLE
--------------------------------------------------------------------------------
*/

-- Step 107 -->> On Both Nodes
[grid@invoice1/invoice2 ~]$ asmcmd
/*
ASMCMD> lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  1048576    153599   153493                0          153493              0             N  ARC/
MOUNTED  EXTERN  N         512             512   4096  1048576    511999   511887                0          511887              0             N  DATA/
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20140                0           20140              0             Y  OCR/
ASMCMD> exit
*/

-- Step 108 -->> On Node 1
[root@invoice1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/19c/grid:N
*/

-- Step 109 -->> On Node 2
[root@invoice2 ~]# vi /etc/oratab
/*
+ASM2:/opt/app/19c/grid:N
*/

-- Step 110 -->> On Both Nodes
-- Creating the Oracle RDBMS Home Directory
[root@invoice1/invoice2 ~]# mkdir -p /opt/app/oracle/product/19c/db_1
[root@invoice1/invoice2 ~]# chown -R oracle:oinstall /opt/app/oracle/product/19c/db_1
[root@invoice1/invoice2 ~]# chmod -R 775 /opt/app/oracle/product/19c/db_1

-- Step 111 -->> On Node 1
-- To unzip the Oracle Binary and Letest Opatch
[root@invoice1 ~]# cd /opt/app/oracle/product/19c/db_1
[root@invoice1 db_1]# unzip -oq /root/19.3.0.0.0/LINUX.X64_193000_db_home.zip
[root@invoice1 db_1]# unzip -oq /root/PSU_19.7.0.0.0/p6880880_190000_LINUX.zip 

-- Step 111.1 -->> On Node 1
[root@invoice1 ~]# chown -R oracle:oinstall /opt/app/oracle/product/19c/db_1/
[root@invoice1 ~]# chmod -R 775 /opt/app/oracle/product/19c/db_1/

-- Step 112 -->> On Node 1
-- To Setup the SSH Connectivity 
[root@invoice1 ~]# su - oracle
[oracle@invoice1 ~]$ cd /opt/app/oracle/product/19c/db_1/deinstall/
[oracle@invoice1 deinstall]$ ./sshUserSetup.sh -user oracle -hosts "invoice1 invoice2" -noPromptPassphrase -confirm -advanced
/*
Password: Or@cL5@!Nv#
*/
-- Step 113 -->> On Both Nodes
[oracle@invoice1/invoice2 ~]$ ssh oracle@invoice1 date
[oracle@invoice1/invoice2 ~]$ ssh oracle@invoice2 date
[oracle@invoice1/invoice2 ~]$ ssh oracle@invoice1 date && ssh oracle@invoice2 date
[oracle@invoice1/invoice2 ~]$ ssh oracle@invoice1.unidev.com date
[oracle@invoice1/invoice2 ~]$ ssh oracle@invoice2.unidev.com date
[oracle@invoice1/invoice2 ~]$ ssh oracle@invoice1.unidev.com date && ssh oracle@invoice2.unidev.com date

-- Step 114 -->> On Node 1
-- To Create a responce file for Oracle Software Installation
[oracle@invoice1 ~]$ cp /opt/app/oracle/product/19c/db_1/install/response/db_install.rsp /home/oracle/
[oracle@invoice1 ~]$ cd /home/oracle/

-- Step 114.1 -->> On Node 1
[oracle@invoice1 ~]$ ls -ltr
/*
-rwxr-xr-x 1 oracle oinstall 19932 Sep 20 14:56 db_install.rsp
*/

-- Step 114.2 -->> On Node 1
[oracle@invoice1 ~]$  vi db_install.rsp
/*
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v19.0.0
oracle.install.option=INSTALL_DB_SWONLY
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/opt/app/oraInventory
ORACLE_HOME=/opt/app/oracle/product/19c/db_1
ORACLE_BASE=/opt/app/oracle
oracle.install.db.InstallEdition=EE
ORACLE_HOSTNAME=invoice1.unidev.com
SELECTED_LANGUAGES=en
oracle.install.db.OSDBA_GROUP=dba
oracle.install.db.OSOPER_GROUP=oper
oracle.install.db.OSBACKUPDBA_GROUP=backupdba
oracle.install.db.OSDGDBA_GROUP=dgdba
oracle.install.db.OSKMDBA_GROUP=kmdba
oracle.install.db.OSRACDBA_GROUP=racdba
oracle.install.db.rootconfig.executeRootScript=false
oracle.install.db.CLUSTER_NODES=invoice1,invoice2
oracle.install.db.config.starterdb.type=GENERAL_PURPOSE
oracle.install.db.ConfigureAsContainerDB=false
*/

-- Step 115 -->> On Node 1
-- To install Oracle Software with Letest Opatch
[oracle@invoice1 ~]$ cd /opt/app/oracle/product/19c/db_1/
[oracle@invoice1 db_1]$ ./runInstaller -ignorePrereq -waitforcompletion -silent \
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
The log can be found at: /opt/app/oraInventory/logs/InstallActions2022-11-07_03-44-54PM/installerPatchActions_2022-11-07_03-44-54PM.log
Launching Oracle Database Setup Wizard...

[WARNING] [INS-13014] Target environment does not meet some optional requirements.
   CAUSE: Some of the optional prerequisites are not met. See logs for details. /opt/app/oraInventory/logs/InstallActions2022-11-07_03-44-54PM/installActions2022-11-07_03-44-54PM.log
   ACTION: Identify the list of failed prerequisite checks from the log: /opt/app/oraInventory/logs/InstallActions2022-11-07_03-44-54PM/installActions2022-11-07_03-44-54PM.log. Then either from the log file or from installation manual find the appropriate configuration to meet the prerequisites and fix it manually.
The response file for this session can be found at:
 /opt/app/oracle/product/19c/db_1/install/response/db_2022-11-07_03-44-54PM.rsp

You can find the log of this install session at:
 /opt/app/oraInventory/logs/InstallActions2022-11-07_03-44-54PM/installActions2022-11-07_03-44-54PM.log

As a root user, execute the following script(s):
        1. /opt/app/oracle/product/19c/db_1/root.sh

Execute /opt/app/oracle/product/19c/db_1/root.sh on the following nodes:
[invoice1, invoice2]


Successfully Setup Software with warning(s).
*/

-- Step 116 -->> On Node 1
[root@invoice1 ~]# /opt/app/oracle/product/19c/db_1/root.sh
/*
Check  /opt/app/oracle/product/19c/db_1/install/root_invoice1.unidev.com_2022-11-07_16-07-11-167292929.log for the output of root script
*/

-- Step 116.1 -->> On Node 1
[root@invoice1 ~]# tail -f  /opt/app/oracle/product/19c/db_1/install/root_invoice1.unidev.com_2022-11-07_16-07-11-167292929.log
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
[root@invoice2 ~]# /opt/app/oracle/product/19c/db_1/root.sh
/*
Check /opt/app/oracle/product/19c/db_1/install/root_invoice2.unidev.com_2022-11-07_16-08-39-572161054.log for the output of root script
*/

-- Step 117.1 -->> On Node 2
[root@invoice2 ~]# tail -f /opt/app/oracle/product/19c/db_1/install/root_invoice2.unidev.com_2022-11-07_16-08-39-572161054.log
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
[root@invoice1 ~]# export ORACLE_HOME=/opt/app/oracle/product/19c/db_1
[root@invoice1 ~]# export PATH=${ORACLE_HOME}/bin:$PATH
[root@invoice1 ~]# export PATH=${PATH}:${ORACLE_HOME}/OPatch

-- Step 118.1 -->> On Node 1
[root@invoice1 ~]# which opatchauto
/*
/opt/app/oracle/product/19c/db_1/OPatch/opatchauto
*/

-- Step 119 -->> On Node 1
[root@invoice1 ~]# opatchauto apply /tmp/30783556/30805684 -oh /opt/app/oracle/product/19c/db_1 --nonrolling
/*
OPatchauto session is initiated at Mon Nov  7 16:11:13 2022

System initialization log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchautodb/systemconfig2022-11-07_                                                                                                  04-11-19PM.log.

Session log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/opatchauto2022-11-07_04-11-51PM.log
The id for this session is WNRI

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

Host:invoice1
RAC Home:/opt/app/oracle/product/19c/db_1
Version:19.0.0.0.0
Summary:

==Following patches were SUCCESSFULLY applied:

Patch: /tmp/30783556/30805684
Log: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2022-11-07_16-12-15PM_1.log



OPatchauto session completed at Mon Nov  7 16:13:42 2022
Time taken to complete the session 2 minutes, 29 seconds
*/

-- Step 119.1 -->> On Node 1
[root@invoice1 ~]# tail -f /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2022-11-07_15-45-04PM_1.log
/*
[Nov 7, 2022 3:50:41 PM] [INFO]     [OPSR-TIME] Backup area for restore has been cleaned up. For a complete list of files/directoriesdeleted, Please refer log file.
[Nov 7, 2022 3:50:41 PM] [INFO]     Patch 30894985 successfully applied.
[Nov 7, 2022 3:50:41 PM] [INFO]     Sub-set patch [29585399] has become inactive due to the application of a super-set patch [30894985].Sub-set patch [29517242] has become inactive due to the application of a super-set patch [30869156].Please refer to Doc ID 2161861.1 for any possible further required actions.
[Nov 7, 2022 3:50:41 PM] [INFO]     UtilSession: N-Apply done.
[Nov 7, 2022 3:50:41 PM] [INFO]     Finishing UtilSession at Mon Nov 07 15:50:41 NPT 2022
[Nov 7, 2022 3:50:41 PM] [INFO]     Log file location: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2022-11-07_15-45-04PM_1.log
[Nov 7, 2022 3:50:41 PM] [INFO]     EXITING METHOD: NApply(IAnalysisReport report)
*/

-- Step 120 -->> On Node 1
[root@invoice1 ~]# scp -r /tmp/30783556/ root@invoice2:/tmp/

-- Step 121 -->> On Node 2
[root@invoice2 ~]# cd /tmp/
[root@invoice2 tmp]# chown -R oracle:oinstall 30783556
[root@invoice2 tmp]# chmod -R 775 30783556

-- Step 121.1 -->> On Node 2
[root@invoice2 tmp]# ls -ltr | grep 30783556
/*
drwxrwxr-x  4 oracle oinstall   4096 Sep 20 16:15 30783556
*/

-- Step 122 -->> On Node 2
-- To applying the Oracle PSU on Remote Node 2
[root@invoice2 ~]# export ORACLE_HOME=/opt/app/oracle/product/19c/db_1
[root@invoice2 ~]# export PATH=${ORACLE_HOME}/bin:$PATH
[root@invoice2 ~]# export PATH=${PATH}:${ORACLE_HOME}/OPatch

-- Step 122.1 -->> On Node 2
[root@invoice2 ~]# which opatchauto
/*
/opt/app/oracle/product/19c/db_1/OPatch/opatchauto
*/

-- Step 123 -->> On Node 2
[root@invoice2 ~]# opatchauto apply /tmp/30783556/30805684 -oh /opt/app/oracle/product/19c/db_1 --nonrolling
/*
OPatchauto session is initiated at Mon Nov  7 16:20:44 2022

System initialization log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchautodb/systemconfig2022-11-07_04-20-49PM.log.

Session log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/opatchauto2022-11-07_04-21-06PM.log
The id for this session is IL6L

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

Host:invoice2
RAC Home:/opt/app/oracle/product/19c/db_1
Version:19.0.0.0.0
Summary:

==Following patches were SUCCESSFULLY applied:

Patch: /tmp/30783556/30805684
Log: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2022-11-07_16-21-29PM_1.log



OPatchauto session completed at Mon Nov  7 16:23:06 2022
Time taken to complete the session 2 minutes, 22 seconds
*/

-- Step 123 -->> On Node 2
[root@invoice2 ~]# tail -f /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2022-11-07_16-21-29PM_1.log
/*
[Nov 7, 2022 4:23:04 PM] [INFO]     Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/NApply/2022-11-07_16-21-32PM/restore.sh"
[Nov 7, 2022 4:23:04 PM] [INFO]     Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/NApply/2022-11-07_16-21-32PM/make.txt"
[Nov 7, 2022 4:23:04 PM] [INFO]     Deleted the directory "/opt/app/oracle/product/19c/db_1/.patch_storage/30805684_Feb_21_2020_20_52_36/backup"
[Nov 7, 2022 4:23:05 PM] [INFO]     [OPSR-TIME] Backup area for restore has been cleaned up. For a complete list of files/directoriesdeleted, Please refer log file.
[Nov 7, 2022 4:23:05 PM] [INFO]     Patch 30805684 successfully applied.
[Nov 7, 2022 4:23:05 PM] [INFO]     UtilSession: N-Apply done.
[Nov 7, 2022 4:23:05 PM] [INFO]     Finishing UtilSession at Mon Nov 07 16:23:05 NPT 2022
[Nov 7, 2022 4:23:05 PM] [INFO]     Log file location: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2022-11-07_16-21-29PM_1.log
[Nov 7, 2022 4:23:05 PM] [INFO]     EXITING METHOD: NApply(IAnalysisReport report)
*/

-- Step 124 -->> On Both Nodes
-- To Create a Oracle Database
[root@invoice1/invoice2 ~]# mkdir -p /opt/app/oracle/admin/invoicedb/adump
[root@invoice1/invoice2 ~]# cd /opt/app/oracle/admin/
[root@invoice1/invoice2 ~]# chown -R oracle:oinstall invoicedb/
[root@invoice1/invoice2 ~]# chmod -R 775 invoicedb/

-- Step 125 -->> On Node 1
-- To prepare the responce file
[root@invoice1 ~]# su - oracle

-- Step 126 -->> On Node 1
[oracle@invoice1 db_1]$ cd /opt/app/oracle/product/19c/db_1/assistants/dbca
[oracle@invoice1 dbca]$ dbca -silent -createDatabase \
-templateName General_Purpose.dbc             \
-gdbname invoicedb -responseFile NO_VALUE         \
-characterSet AL32UTF8                        \
-sysPassword Sys605014                        \
-systemPassword Sys605014                     \
-createAsContainerDatabase true               \
-numberOfPDBs 1                               \
-pdbName invpdb                               \
-pdbAdminPassword Sys605014                   \
-databaseType MULTIPURPOSE                    \
-automaticMemoryManagement false              \
-totalMemory 8192                             \
-redoLogFileSize 50                           \
-emConfiguration NONE                         \
-ignorePreReqs                                \
-nodelist invoice1,invoice2                   \
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
 /opt/app/oracle/cfgtoollogs/dbca/invoicedb.
Database Information:
Global Database Name:invoicedb
System Identifier(SID) Prefix:invoiced
Look at the log file "/opt/app/oracle/cfgtoollogs/dbca/invoicedb/invoicedb.log" for further details.
*/  

-- Step 126.1 -->> On Node 1
[oracle@invoice1 ~]$ tail -f /opt/app/oracle/cfgtoollogs/dbca/invoicedb/invoicedb.log
/*
[ 2022-11-07 16:59:35.761 NPT ] Prepare for db operation
DBCA_PROGRESS : 7%
[ 2022-11-07 16:59:56.469 NPT ] Copying database files
DBCA_PROGRESS : 27%
[ 2022-11-07 17:01:34.060 NPT ] Creating and starting Oracle instance
DBCA_PROGRESS : 28%
DBCA_PROGRESS : 31%
DBCA_PROGRESS : 35%
DBCA_PROGRESS : 37%
DBCA_PROGRESS : 40%
[ 2022-11-07 17:20:12.361 NPT ] Creating cluster database views
DBCA_PROGRESS : 41%
DBCA_PROGRESS : 53%
[ 2022-11-07 17:23:20.293 NPT ] Completing Database Creation
DBCA_PROGRESS : 57%
DBCA_PROGRESS : 59%
DBCA_PROGRESS : 60%
[ 2022-11-07 17:33:12.401 NPT ] Creating Pluggable Databases
DBCA_PROGRESS : 64%
DBCA_PROGRESS : 80%
[ 2022-11-07 17:33:44.013 NPT ] Executing Post Configuration Actions
DBCA_PROGRESS : 100%
[ 2022-11-07 17:33:44.016 NPT ] Database creation complete. For details check the logfiles at:
 /opt/app/oracle/cfgtoollogs/dbca/invoicedb.
Database Information:
Global Database Name:invoicedb
System Identifier(SID) Prefix:invoiced
*/

-- Step 127 -->> On Node 1  
[oracle@invoice1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Sep 20 17:42:39 2020
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> alter pluggable database invpdb open;
SQL> alter pluggable database all open;
SQL> alter pluggable database invpdb save state;

Pluggable database altered.

SQL> SELECT status ,instance_name FROM gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
OPEN         invoiced2
OPEN         invoiced1

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 128 -->> On Both Nodes 
[oracle@invoice1/invoice2 ~]$ srvctl config database -d invoicedb
/*
Database unique name: invoicedb
Database name: invoiced
Oracle home: /opt/app/oracle/product/19c/db_1
Oracle user: oracle
Spfile: +DATA/INVOICEDB/PARAMETERFILE/spfile.272.1120152663
Password file: +DATA/INVOICEDB/PASSWORD/pwdinvoicedb.256.1120150799
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
Database instances: invoiced1,invoiced2
Configured nodes: invoice1,invoice2
CSS critical: no
CPU count: 0
Memory target: 0
Maximum memory: 0
Default network number for database services:
Database is administrator managed
*/

-- Step 129 -->> On Both Nodes 
[oracle@invoice1/invoice2 ~]$ srvctl status database -d invoicedb -v
/*
Instance invoiced1 is running on node invoice1. Instance status: Open.
Instance invoiced2 is running on node invoice2. Instance status: Open.
*/

-- Step 130 -->> On Both Nodes 
[oracle@invoice1/invoice2 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): invoice1,invoice2
*/

-- Step 131 -->> On Node 1 
[oracle@invoice1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 22-DEC-2022 11:15:05

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                20-DEC-2022 10:49:36
Uptime                    2 days 0 hr. 25 min. 29 sec
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

-- Step 132 -->> On Node 2 
[oracle@invoice2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 22-DEC-2022 11:15:53

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                20-DEC-2022 10:50:20
Uptime                    2 days 0 hr. 25 min. 32 sec
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

-- To Fix the ADRCI log if occured in remote nodes
-- Step Fix.1 -->> On Node 2
[oracle@invoice2 ~]$ adrci
/*
ADRCI: Release 19.0.0.0.0 - Production on Mon Sep 21 12:38:51 2020

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

No ADR base is set
adrci> exit
*/

-- Step Fix.2 -->> On Node 2
[oracle@invoice1 ~]$ ls -ltr /opt/app/oracle/product/19c/db_1/log/diag/
/*
-rw-r----- 1 oracle asmadmin 16 Dec 20 10:49 adrci_dir.mif
*/

-- Step Fix.3 -->> On Node 2
[oracle@invoice2 ~]$ cd /opt/app/oracle/product/19c/db_1/
[oracle@invoice2 db_1]$ mkdir -p log/diag
[oracle@invoice2 db_1]$ mkdir -p log/invoice1/client
[oracle@invoice2 db_1]$ cd log
[oracle@invoice2 db_1]$ chown -R oracle:asmadmin diag
-- Step Fix.4 -->> On Node 2
[oracle@invoice1 ~]$ scp -r /opt/app/oracle/product/19c/db_1/log/diag/adrci_dir.mif oracle@invoice2:/opt/app/oracle/product/19c/db_1/log/diag/

-- Step Fix.5 -->> On Node 2
[oracle@invoice2 ~]$ adrci
/*
ADRCI: Release 19.0.0.0.0 - Production on Sun Apr 9 10:57:34 2023

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

ADR base = "/opt/app/oracle"
adrci> exit
*/

-- Step 133 -->> On Node 1
[root@invoice1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/19c/grid:N
invoicedb:/opt/app/oracle/product/19c/db_1:N
invoiced1:/opt/app/oracle/product/19c/db_1:N
*/

-- Step 134 -->> On Node 2
[root@invoice2 ~]# vi /etc/oratab 
/*
+ASM2:/opt/app/19c/grid:N
invoicedb:/opt/app/oracle/product/19c/db_1:N
invoiced2:/opt/app/oracle/product/19c/db_1:N
*/

-- Step 135 -->> On Node 1
[root@invoice1 ~]# vi /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
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
*/

-- Step 136 -->> On Node 2
[root@invoice2 ~]# vi /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
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
*/

-- Step 137 -->> On Both Node (If Required)
-- To run the oracle tools (Till 11gR2 - If Required)
-- To Connect lower version tools
-- 1. Copy the contains of /etc/hosts
-- 2. Past on host file of relevant PC C:\Windows\System32\drivers\etc\hosts
[root@invoice1/invoice2 ~]# vi /opt/app/19c/grid/network/admin/sqlnet.ora
/*
# sqlnet.ora.invoice1/invoice2 Network Configuration File: /opt/app/19c/grid/network/admin/sqlnet.ora
# Generated by Oracle configuration tools.

NAMES.DIRECTORY_PATH= (TNSNAMES, EZCONNECT)

SQLNET.ALLOWED_LOGON_VERSION_SERVER=8
SQLNET.ALLOWED_LOGON_VERSION_CLIENT=8
*/

-- Step 137.1 -->> On Both Node
[root@invoice1/invoice2 ~]# vi /opt/app/oracle/product/19c/db_1/network/admin/sqlnet.ora
/*
# sqlnet.ora.invoice1/invoice2 Network Configuration File: /opt/app/oracle/product/19c/db_1/network/admin/sqlnet.ora
# Generated by Oracle configuration tools.

NAMES.DIRECTORY_PATH= (TNSNAMES, EZCONNECT)

SQLNET.ALLOWED_LOGON_VERSION_SERVER=8
SQLNET.ALLOWED_LOGON_VERSION_CLIENT=8
*/

-- Step 137.2 -->> On Both Node
[oracle@invoice1/invoice2 ~]$ srvctl stop listener
[oracle@invoice1/invoice2 ~]$ srvctl start listener

-- Step 138 -->> On Node 1
[oracle@invoice1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Thu Sep 24 17:06:09 2020
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> ALTER USER sys IDENTIFIED BY "P#ssw0rd";

User altered.

SQL> ALTER USER sys IDENTIFIED BY "P#ssw0rd" container=all;

User altered.

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 138.1 -->> On Node 1
[oracle@invoice1 ~]$ sqlplus sys/P#ssw0rd@invoicedb as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue Nov 8 11:56:14 2022
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

SQL> connect sys/P#ssw0rd@invpdb as sysdba
Connected.

SQL> show con_name

CON_NAME
------------------------------
INVPDB

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         3 INVPDB                         READ WRITE NO
SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 139 -->> On Node 1
[root@invoice1 ~]# cd /opt/app/19c/grid/bin
[root@invoice1 ~]# ./crsctl stop cluster -all
[root@invoice1 ~]# ./crsctl start cluster -all

-- Step 140 -->> On Node 1
[root@invoice1 ~]# cd /opt/app/19c/grid/bin
[root@invoice1 ~]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.crf
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.crsd
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.cssd
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.ctssd
      1        ONLINE  ONLINE       invoice1                 OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.evmd
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.gipcd
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.gpnpd
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.mdnsd
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.storage
      1        ONLINE  ONLINE       invoice1                 STABLE
--------------------------------------------------------------------------------
*/

-- Step 141 -->> On Node 2
[root@invoice2 ~]# cd /opt/app/19c/grid/bin
[root@invoice2 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.crf
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.crsd
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.cssd
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.ctssd
      1        ONLINE  ONLINE       invoice2                 OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.evmd
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.gipcd
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.gpnpd
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.mdnsd
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.storage
      1        ONLINE  ONLINE       invoice2                 STABLE
--------------------------------------------------------------------------------
*/

-- Step 142 -->> On Both Nodes
[root@invoice1/invoice2 ~]# cd /opt/app/19c/grid/bin
[root@invoice1/invoice2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       invoice1                 STABLE
               ONLINE  ONLINE       invoice2                 STABLE
ora.chad
               ONLINE  ONLINE       invoice1                 STABLE
               ONLINE  ONLINE       invoice2                 STABLE
ora.net1.network
               ONLINE  ONLINE       invoice1                 STABLE
               ONLINE  ONLINE       invoice2                 STABLE
ora.ons
               ONLINE  ONLINE       invoice1                 STABLE
               ONLINE  ONLINE       invoice2                 STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ARC.dg(ora.asmgroup)
      1        ONLINE  ONLINE       invoice1                 STABLE
      2        ONLINE  ONLINE       invoice2                 STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       invoice1                 STABLE
      2        ONLINE  ONLINE       invoice2                 STABLE
      3        ONLINE  OFFLINE                               STABLE
ora.DATA.dg(ora.asmgroup)
      1        ONLINE  ONLINE       invoice1                 STABLE
      2        ONLINE  ONLINE       invoice2                 STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       invoice1                 STABLE
      2        ONLINE  ONLINE       invoice2                 STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       invoice1                 Started,STABLE
      2        ONLINE  ONLINE       invoice2                 Started,STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       invoice1                 STABLE
      2        ONLINE  ONLINE       invoice2                 STABLE
      3        OFFLINE OFFLINE                               STABLE
ora.cvu
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.invoice1.vip
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.invoice2.vip
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.invoicedb.db
      1        ONLINE  ONLINE       invoice1                 Open,HOME=/opt/app/oracle/product/19c/db_1,STABLE
      2        ONLINE  ONLINE       invoice2                 Open,HOME=/opt/app/oracle/product/19c/db_1,STABLE
ora.qosmserver
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       invoice2                 STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       invoice1                 STABLE
ora.scan3.vip
      1        ONLINE  ONLINE       invoice1                 STABLE
--------------------------------------------------------------------------------
*/

-- Step 143 -->> On Both Nodes
[root@invoice1/invoice2 ~]# cd /opt/app/19c/grid/bin
[root@invoice1/invoice2 bin]# ./crsctl check cluster -all
/*
**************************************************************
invoice1:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
invoice2:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/

-- Step 144 -->> On Both Nodes
-- ASM Verification
[root@invoice1/invoice2 ~]# su - grid
[grid@invoice1/invoice2 ~]$ asmcmd
ASMCMD> lsdg
/*
ASMCMD> lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  1048576    153599   153264                0          153264              0             N  ARC/
MOUNTED  EXTERN  N         512             512   4096  1048576    511999   507098                0          507098              0             N  DATA/
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20116                0           20116              0             Y  OCR/
ASMCMD> exit
*/

-- Step 145 -->> On Node 1
[grid@invoice1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 22-DEC-2022 11:23:51

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                20-DEC-2022 10:49:36
Uptime                    2 days 0 hr. 34 min. 14 sec
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

-- Step 146 -->> On Node 2
[grid@invoice2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 22-DEC-2022 11:23:53

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                20-DEC-2022 10:50:20
Uptime                    2 days 0 hr. 33 min. 33 sec
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

-- Step 147 -->> On Node 1
[grid@invoice1 ~]$ ps -ef | grep SCAN
/*
grid      5400     1  0 10:57 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid      5405     1  0 10:57 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid     16667 11102  0 12:09 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 148 -->> On Node 2
[grid@invoice2 ~]$ ps -ef | grep SCAN
/*
grid     10980     1  0 10:58 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid     11483  6417  0 12:09 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 149 -->> On Both Nodes
[grid@invoice1/invoice2 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Thu Dec 22 11:25:11 2022
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> set lines 200;
SQL> col BANNER_FULL format a80;
SQL> col BANNER_LEGACY format a80;
SQL> SELECT inst_id,banner_full,banner_legacy,con_id FROM gv$version;

   INST_ID BANNER_FULL                                                            BANNER_LEGACY                                                          CON_ID
---------- ---------------------------------------------------------------------- ---------------------------------------------------------------------- ------
         1 Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production 0
           Version 19.7.0.0.0

         2 Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production 0
           Version 19.7.0.0.0
 

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 150 -->> On Both Nodes
-- DB Service Verification
[root@invoice1/invoice2 ~]# su - oracle
[oracle@invoice1/invoice2 ~]$ srvctl status database -d invoicedb -v
/*
Instance invoiced1 is running on node invoice1. Instance status: Open.
Instance invoiced2 is running on node invoice2. Instance status: Open.
*/

-- Step 151 -->> On Both Nodes
-- Listener Service Verification
[oracle@invoice1/invoice2 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): invoice1,invoice2
*/

-- Step 152 -->> On Both Nodes
[oracle@invoice1/invoice2 ~]$ rman target sys/P#ssw0rd@invoicedb
--OR--
[oracle@invoice1/invoice2 ~]$ rman target /
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Thu Dec 22 11:29:47 2022
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: INVOICED (DBID=3646030117)

RMAN> show all;

using target database control file instead of recovery catalog
RMAN configuration parameters for database with db_unique_name invoicedb are:
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
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/product/19c/db_1/dbs/snapcf_invoicedb1.f'; # default
-- Node 2
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/product/19c/db_1/dbs/snapcf_invoicedb2.f'; # default

RMAN> exit

Recovery Manager complete.
*/

-- Step 153 -->> On Both Nodes
[oracle@invoice1 ~]$ rman target sys/P#ssw0rd@invpdb
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Thu Dec 22 11:31:16 2022
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: INVOICED:INVPDB (DBID=1095721678)

RMAN> show all;

using target database control file instead of recovery catalog
RMAN configuration parameters for database with db_unique_name INVOICEDB are:
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
--Node1
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/product/19c/db_1/dbs/snapcf_invoiced1.f'; # default
--Node 2
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/product/19c/db_1/dbs/snapcf_invoiced2.f'; # default
RMAN> exit


Recovery Manager complete.
*/
-- Step 154 -->> On Both Nodes
-- To connnect CDB$ROOT using TNS
[oracle@invoice1/invoice2 ~]$ sqlplus sys/P#ssw0rd@invoicedb as sysdba

-- Step 155 -->> On Node 1
[oracle@invoice1 ~]$ sqlplus sys/P#ssw0rd@invoiced1 as sysdba

-- Step 156 -->> On Node 2
[oracle@invoice2 ~]$ sqlplus sys/P#ssw0rd@invoiced2 as sysdba

-- Step 157 -->> On Both Nodes
-- To connnect PDB using TNS
[oracle@invoice1/invoice2 ~]$ sqlplus sys/P#ssw0rd@invpdb as sysdba