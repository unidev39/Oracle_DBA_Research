--https://oracle-base.com/articles/19c/oracle-db-19c-installation-on-oracle-linux-8
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------Additon of Node 3 to make 3-Node-DC and 2-Node-DR-----------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- Step 0 -->> 1 Node rac on Physical Server -->> On Node 3
--For OS Oracle Linux 8.6 => boot V1020894-01.iso
--And follow 
--https <= public-yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/
--UEKR6 <= https <= public-yum.oracle.com/repo/OracleLinux/OL8/UEKR6/x86_64/
--appstream <= https <= public-yum.oracle.com/repo/OracleLinux/OL8/appstream/x86_64/
--Then for other RPM V1020898-01.iso

-- Step 0.0 -->>  1 Node rac on Physical Server -->> On Node 3
[root@pdb3 ~]# df -Th
/*
Filesystem                 Type      Size  Used Avail Use% Mounted on
devtmpfs                   devtmpfs  9.6G     0  9.6G   0% /dev
tmpfs                      tmpfs     9.7G     0  9.7G   0% /dev/shm
tmpfs                      tmpfs     9.7G  9.3M  9.7G   1% /run
tmpfs                      tmpfs     9.7G     0  9.7G   0% /sys/fs/cgroup
/dev/mapper/ol_pdb3-root   xfs        70G  585M   70G   1% /
/dev/mapper/ol_pdb3-usr    xfs        10G  7.2G  2.9G  72% /usr
/dev/mapper/ol_pdb3-tmp    xfs        10G  104M  9.9G   2% /tmp
/dev/mapper/ol_pdb3-var    xfs        10G  811M  9.2G   8% /var
/dev/mapper/ol_pdb3-home   xfs        10G  104M  9.9G   2% /home
/dev/mapper/ol_pdb3-backup xfs        53G  411M   53G   1% /backup
/dev/sda1                  xfs      1014M  343M  672M  34% /boot
/dev/mapper/ol_pdb3-opt    xfs        70G  740M   70G   2% /opt
tmpfs                      tmpfs     2.0G   12K  2.0G   1% /run/user/42
tmpfs                      tmpfs     2.0G     0  2.0G   0% /run/user/0
*/

-- Step 1 -->> On Node 3
[root@pdb3 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.160.6.21   pdb1.unidev.org.np        pdb1
192.160.6.22   pdb2.unidev.org.np        pdb2
192.160.6.28   pdb3.unidev.org.np        pdb3

# Private
10.10.10.21   pdb1-priv.unidev.org.np   pdb1-priv
10.10.10.22   pdb2-priv.unidev.org.np   pdb2-priv
10.10.10.28   pdb3-priv.unidev.org.np   pdb3-priv

# Virtual
192.160.6.23   pdb1-vip.unidev.org.np    pdb1-vip
192.160.6.24   pdb2-vip.unidev.org.np    pdb2-vip
192.160.6.29   pdb3-vip.unidev.org.np    pdb3-vip

# SCAN
192.160.6.25   pdb-scan.unidev.org.np    pdb-scan
192.160.6.26   pdb-scan.unidev.org.np    pdb-scan
192.160.6.27   pdb-scan.unidev.org.np    pdb-scan
*/


-- Step 2 -->> On Node 3
-- Disable secure linux by editing the "/etc/selinux/config" file, making sure the SELINUX flag is set as follows.
[root@pdb3 ~]# vi /etc/selinux/config
/*
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
#SELINUX=enforcing
SELINUX=disabled
# SELINUXTYPE= can take one of these three values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
*/

-- Step 3 -->> On Node 3
[root@pdb3 ~]# vi /etc/sysconfig/network
/*
NETWORKING=yes
HOSTNAME=pdb3.unidev.org.np
*/

-- Step 4 -->> On Node 3
[root@pdb3 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens160
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=ens160
DEVICE=ens160
ONBOOT=yes
IPADDR=192.160.6.28
NETMASK=255.255.255.0
GATEWAY=192.160.6.1
DNS1=127.0.0.1
DNS2=192.160.4.11
DNS3=192.160.4.12
*/

-- Step 4.1 -->> On Node 3
[root@pdb3 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens192
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=ens192
DEVICE=ens192
ONBOOT=yes
IPADDR=10.10.10.28
NETMASK=255.255.255.0
*/

-- Step 5 -->> On Node 3
[root@pdb3 ~]# systemctl restart network-online.target

-- Step 6 -->> On Node 3
[root@pdb3 ~]# systemctl restart NetworkManager

-- Step 7 -->> On Node 3
[root@pdb3 ~]# dnf repolist
/*
repo id                         repo name
ol8_UEKR6                       Latest Unbreakable Enterprise Kernel Release 6 for Oracle Linux 8 (x86_64)
ol8_appstream                   Oracle Linux 8 Application Stream (x86_64)
ol8_baseos_latest               Oracle Linux 8 BaseOS Latest (x86_64)
*/

-- Step 7.1 -->> On Node 3
[root@pdb3 ~]# uname -a
/*
Linux pdb3.unidev.org.np 5.4.17-2136.335.4.el8uek.x86_64 #3 SMP Thu Aug 22 12:18:30 PDT 2024 x86_64 x86_64 x86_64 GNU/Linux
*/

-- Step 7.2 -->> On Node 3
[root@pdb3 ~]# uname -r
/*
5.4.17-2136.335.4.el8uek.x86_64
*/

-- Step 7.3 -->> On Node 3
[root@pdb3 ~]# grubby --info=ALL | grep ^kernel
/*
kernel="/boot/vmlinuz-5.4.17-2136.335.4.el8uek.x86_64"
kernel="/boot/vmlinuz-4.18.0-553.16.1.el8_10.x86_64"
kernel="/boot/vmlinuz-0-rescue-ab6ab6efd5464fdd9caeea7cdcc143f3"
*/

-- Step 7.4 -->> On Node 3
[root@pdb3 ~]# grubby --default-kernel
/*
/boot/vmlinuz-5.4.17-2136.335.4.el8uek.x86_64
*/

-- Step 8 -->> On Node 3
[root@pdb3 ~]# cat /etc/hostname
/*
pdb3.unidev.org.np
*/

-- Step 8.1 -->> On Node 3
[root@pdb3 ~]# hostnamectl | grep hostname
/*
Static hostname: pdb3.unidev.org.np
*/

-- Step 8.2 -->> On Node 3
[root@pdb3 ~]# hostnamectl --static
/*
pdb3.unidev.org.np
*/

-- Step 9 -->> On Node 3
[root@pdb3 ~]# hostnamectl set-hostname pdb3.unidev.org.np

--Note: If you are not configure proper hostname then While installation of Grid Software, 
--you have to face error CLSRSC-180: An error occurred while executing /opt/app/19c/grid/root.sh script.
-- Step 9.1 -->> On Node 3
[root@pdb3 ~]# hostnamectl
/*
   Static hostname: pdb3.unidev.org.np
         Icon name: computer-vm
           Chassis: vm
        Machine ID: ab6ab6efd5464fdd9caeea7cdcc143f3
           Boot ID: 098a6ad7e6ad4bf48009ea4bc3a77904
    Virtualization: vmware
  Operating System: Oracle Linux Server 8.10
       CPE OS Name: cpe:/o:oracle:linux:8:10:server
            Kernel: Linux 5.4.17-2136.335.4.el8uek.x86_64
      Architecture: x86-64
*/

-- Step 10 -->> On Node 3
[root@pdb3 ~]# systemctl stop firewalld
[root@pdb3 ~]# systemctl disable firewalld
/*
Removed /etc/systemd/system/multi-user.target.wants/firewalld.service.
Removed /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.
*/

-- Step 11 -->> On Node 3df 
[root@pdb3 ~]# mv /etc/ntp.conf /etc/ntp.conf.backup
[root@pdb3 ~]# rm -rf /etc/ntp.conf
[root@pdb3 ~]# rm -rf /var/run/ntpd.pid

-- Step 12 -->> On Node 3
[root@pdb3 ~]# iptables -F
[root@pdb3 ~]# iptables -X
[root@pdb3 ~]# iptables -t nat -F
[root@pdb3 ~]# iptables -t nat -X
[root@pdb3 ~]# iptables -t mangle -F
[root@pdb3 ~]# iptables -t mangle -X
[root@pdb3 ~]# iptables -P INPUT ACCEPT
[root@pdb3 ~]# iptables -P FORWARD ACCEPT
[root@pdb3 ~]# iptables -P OUTPUT ACCEPT
[root@pdb3 ~]# iptables -L -nv
/*
Chain INPUT (policy ACCEPT 3 packets, 120 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 2 packets, 320 bytes)
 pkts bytes target     prot opt in     out     source               destination
*/

-- Step 13 -->> On Node 3
[root@pdb3 ~ ]# systemctl stop named
[root@pdb3 ~ ]# systemctl disable named

-- Step 14 -->> On Node 3
-- Enable chronyd service." `date`
[root@pdb3 ~ ]# systemctl enable chronyd
[root@pdb3 ~ ]# systemctl restart chronyd
[root@pdb3 ~ ]# chronyc -a 'burst 4/4'
/*
200 OK
*/

-- Step 14.1 -->> On Node 3
[root@pdb3 ~ ]# chronyc -a makestep
/*
200 OK
*/

-- Step 14.2 -->> On Node 3
[root@pdb3 ~ ]# systemctl status chronyd
/*
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2024-09-25 15:00:06 +0545; 30s ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 6597 ExecStopPost=/usr/libexec/chrony-helper remove-daemon-state (code=exited, st>
  Process: 6606 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, status=>
  Process: 6602 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 6604 (chronyd)
    Tasks: 1 (limit: 125778)
   Memory: 920.0K
   CGroup: /system.slice/chronyd.service
           └─6604 /usr/sbin/chronyd

Sep 25 15:00:06 pdb3.unidev.org.np systemd[1]: Starting NTP client/server...
Sep 25 15:00:06 pdb3.unidev.org.np chronyd[6604]: chronyd version 4.5 starting (+CMDMON +N>
Sep 25 15:00:06 pdb3.unidev.org.np chronyd[6604]: Loaded 0 symmetric keys
Sep 25 15:00:06 pdb3.unidev.org.np chronyd[6604]: Frequency -9.791 +/- 0.840 ppm read from>
Sep 25 15:00:06 pdb3.unidev.org.np chronyd[6604]: Using right/UTC timezone to obtain leap >
Sep 25 15:00:06 pdb3.unidev.org.np systemd[1]: Started NTP client/server.
Sep 25 15:00:11 pdb3.unidev.org.np chronyd[6604]: Selected source 162.159.200.123 (2.pool.>
Sep 25 15:00:11 pdb3.unidev.org.np chronyd[6604]: System clock TAI offset set to 37 seconds
Sep 25 15:00:18 pdb3.unidev.org.np chronyd[6604]: System clock was stepped by 0.000236 sec>
*/

-- Step 15 -->> On Node 3
[root@pdb3 ~]# cd /etc/yum.repos.d/
[root@pdb3 yum.repos.d]# ll
/*
-rw-r--r--. 1 root root 4107 May 22 16:13 oracle-linux-ol8.repo
-rw-r--r--. 1 root root  941 May 23 14:02 uek-ol8.repo
-rw-r--r--. 1 root root  243 May 23 14:02 virt-ol8.repo
*/

-- Step 15.1 -->> On Node 3
[root@pdb3 ~]# cd /etc/yum.repos.d/
[root@pdb3 yum.repos.d]# dnf -y update
[root@pdb3 yum.repos.d]# dnf install -y bind
[root@pdb3 yum.repos.d]# dnf install -y dnsmasq

-- Step 15.2 -->> On Node 3
[root@pdb3 ~]# systemctl enable dnsmasq
[root@pdb3 ~]# systemctl restart dnsmasq
[root@pdb3 ~]# vi /etc/dnsmasq.conf
/*
listen-address=::1,127.0.0.1

#Add the following Lines
except-interface=virbr0
bind-interfaces
*/

-- Step 15.3 -->> On Node 3
[root@pdb3 ~]# cat /etc/dnsmasq.conf | grep -E 'listen-address|except-interface|bind-interfaces'
/*
except-interface=virbr0
listen-address=::1,127.0.0.1
bind-interfaces
*/

-- Step 15.4 -->> On Node 3
[root@pdb3 ~]# systemctl restart dnsmasq
[root@pdb3 ~]# systemctl restart network-online.target
[root@pdb3 ~]# systemctl restart NetworkManager
[root@pdb3 ~]# systemctl status NetworkManager
/*
● NetworkManager.service - Network Manager
   Loaded: loaded (/usr/lib/systemd/system/NetworkManager.service; enabled; vendor preset: e>
   Active: active (running) since Wed 2024-09-25 15:21:38 +0545; 7s ago
     Docs: man:NetworkManager(8)
 Main PID: 56071 (NetworkManager)
    Tasks: 4 (limit: 125778)
   Memory: 5.5M
   CGroup: /system.slice/NetworkManager.service
           └─56071 /usr/sbin/NetworkManager --no-daemon

Sep 25 15:21:39 pdb3.unidev.org.np NetworkManager[56071]: <info>  [1727256999.1169] device>
Sep 25 15:21:39 pdb3.unidev.org.np NetworkManager[56071]: <info>  [1727256999.1257] device>
Sep 25 15:21:39 pdb3.unidev.org.np NetworkManager[56071]: <info>  [1727256999.1259] device>
Sep 25 15:21:39 pdb3.unidev.org.np NetworkManager[56071]: <info>  [1727256999.1260] device>
Sep 25 15:21:39 pdb3.unidev.org.np NetworkManager[56071]: <info>  [1727256999.1264] manage>
Sep 25 15:21:39 pdb3.unidev.org.np NetworkManager[56071]: <info>  [1727256999.1266] device>
Sep 25 15:21:39 pdb3.unidev.org.np NetworkManager[56071]: <info>  [1727256999.1270] manage>
Sep 25 15:21:39 pdb3.unidev.org.np NetworkManager[56071]: <info>  [1727256999.1272] device>
Sep 25 15:21:39 pdb3.unidev.org.np NetworkManager[56071]: <info>  [1727256999.1277] device>
Sep 25 15:21:39 pdb3.unidev.org.np NetworkManager[56071]: <info>  [1727256999.1282] manage>
*/

-- Step 15.5 -->> On Node 3
[root@pdb3 ~]# systemctl status dnsmasq
/*
● dnsmasq.service - DNS caching server.
   Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2024-09-25 15:21:38 +0545; 43s ago
 Main PID: 56055 (dnsmasq)
    Tasks: 1 (limit: 125778)
   Memory: 700.0K
   CGroup: /system.slice/dnsmasq.service
           └─56055 /usr/sbin/dnsmasq -k

Sep 25 15:21:38 pdb3.unidev.org.np dnsmasq[56055]: compile time options: IPv6 GNU-getopt D>
Sep 25 15:21:38 pdb3.unidev.org.np dnsmasq[56055]: reading /etc/resolv.conf
Sep 25 15:21:38 pdb3.unidev.org.np dnsmasq[56055]: ignoring nameserver 127.0.0.1 - local i>
Sep 25 15:21:38 pdb3.unidev.org.np dnsmasq[56055]: using nameserver 192.160.4.11#53
Sep 25 15:21:38 pdb3.unidev.org.np dnsmasq[56055]: using nameserver 192.160.4.12#53
Sep 25 15:21:38 pdb3.unidev.org.np dnsmasq[56055]: read /etc/hosts - 14 addresses
Sep 25 15:21:39 pdb3.unidev.org.np dnsmasq[56055]: reading /etc/resolv.conf
Sep 25 15:21:39 pdb3.unidev.org.np dnsmasq[56055]: ignoring nameserver 127.0.0.1 - local i>
Sep 25 15:21:39 pdb3.unidev.org.np dnsmasq[56055]: using nameserver 192.160.4.11#53
Sep 25 15:21:39 pdb3.unidev.org.np dnsmasq[56055]: using nameserver 192.160.4.12#53
*/

-- Step 15.6 -->> On Node 3
[root@pdb3 ~]# cat /etc/resolv.conf
/*
# Generated by NetworkManager
search cibnepal.org.np
nameserver 127.0.0.1
nameserver 192.160.4.11
nameserver 192.160.4.12
*/

-- Step 16 -->> On Node 3
[root@pdb3 ~]# nslookup 192.160.6.28
/*
28.6.160.192.in-addr.arpa name = pdb3.unidev.org.np.
*/

-- Step 16.1 -->> On Node 3
[root@pdb3 ~]# nslookup pdb3
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb3.unidev.org.np
Address: 192.160.7.5
*/

-- Step 16.2 -->> On Node 3
[root@pdb3 ~]# nslookup pdb-scan
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb-scan.unidev.org.np
Address: 192.160.6.27
Name:   pdb-scan.unidev.org.np
Address: 192.160.6.25
Name:   pdb-scan.unidev.org.np
Address: 192.160.6.26
*/

-- Step 17 -->> On Node 3
--Stop avahi-daemon damon if it not configured
[root@pdb3 ~]# systemctl stop avahi-daemon
[root@pdb3 ~]# systemctl disable avahi-daemon

-- Step 18 -->> On Node 3
--To Remove virbr0 and lxcbr0 Network Interfac
[root@pdb3 ~]# systemctl stop libvirtd.service
[root@pdb3 ~]# systemctl disable libvirtd.service
[root@pdb3 ~]# virsh net-list
/*
 Name      State    Autostart   Persistent
--------------------------------------------
 default   active   yes         yes
*/

-- Step 18.1 -->> On Node 3
[root@pdb3 ~]# virsh net-destroy default
/*
Network default destroyed
*/

-- Step 18.2 -->> On Node 3
[root@pdb3 ~]# ifconfig virbr0
/*
virbr0: error fetching interface information: Device not found
*/

-- Step 18.3 -->> On Node One
[root@pdb3 ~]# ifconfig
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.160.6.28  netmask 255.255.255.0  broadcast 192.160.6.255
        inet6 fe80::250:56ff:feac:4f89  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:4f:89  txqueuelen 1000  (Ethernet)
        RX packets 10448781  bytes 15171871869 (14.1 GiB)
        RX errors 0  dropped 42  overruns 0  frame 0
        TX packets 2334071  bytes 172854647 (164.8 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.28  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::250:56ff:feac:6e18  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:6e:18  txqueuelen 1000  (Ethernet)
        RX packets 295  bytes 30945 (30.2 KiB)
        RX errors 0  dropped 41  overruns 0  frame 0
        TX packets 92  bytes 10590 (10.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 680  bytes 44125 (43.0 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 680  bytes 44125 (43.0 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 19 -->> On Node 3
[root@pdb3 ~]# init 6


-- Step 20 -->> On Node One
[root@pdb3 ~]# ifconfig
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.160.6.28  netmask 255.255.255.0  broadcast 192.160.6.255
        inet6 fe80::250:56ff:feac:4f89  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:4f:89  txqueuelen 1000  (Ethernet)
        RX packets 91  bytes 13969 (13.6 KiB)
        RX errors 0  dropped 19  overruns 0  frame 0
        TX packets 83  bytes 10282 (10.0 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.28  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::250:56ff:feac:6e18  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:6e:18  txqueuelen 1000  (Ethernet)
        RX packets 27  bytes 1620 (1.5 KiB)
        RX errors 0  dropped 18  overruns 0  frame 0
        TX packets 13  bytes 922 (922.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 56  bytes 4342 (4.2 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 56  bytes 4342 (4.2 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 20.1 -->> On Node One
[root@pdb3 ~]# ifconfig | grep -E 'UP'
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
*/

-- Step 20.2 -->> On Node One
[root@pdb3 ~]# ifconfig | grep -E 'RUNNING'
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
*/

-- Step 21 -->> On Node 3
[root@pdb3 ~]# systemctl status libvirtd.service
/*
● libvirtd.service - Virtualization daemon
   Loaded: loaded (/usr/lib/systemd/system/libvirtd.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:libvirtd(8)
           https://libvirt.org
*/

-- Step 22 -->> On Node 3
[root@pdb3 ~]# firewall-cmd --list-all
/*
FirewallD is not running
*/

-- Step 22.1 -->> On Node 3
[root@pdb3 ~]# systemctl status firewalld
/*
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:firewalld(1)
*/

-- Step 23 -->> On Node 3
[root@pdb3 ~]# systemctl status named
/*
● named.service - Berkeley Internet Name Domain (DNS)
   Loaded: loaded (/usr/lib/systemd/system/named.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
*/

-- Step 24 -->> On Node 3
[root@pdb3 ~]# systemctl status avahi-daemon
/*
● avahi-daemon.service - Avahi mDNS/DNS-SD Stack
   Loaded: loaded (/usr/lib/systemd/system/avahi-daemon.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
*/

-- Step 25 -->> On Node 3
[root@pdb3 ~ ]# systemctl status chronyd
/*
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2024-09-25 15:27:34 +0545; 5min ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 1365 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, status=>
  Process: 1328 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 1356 (chronyd)
    Tasks: 1 (limit: 125778)
   Memory: 1.3M
   CGroup: /system.slice/chronyd.service
           └─1356 /usr/sbin/chronyd

Sep 25 15:27:34 pdb3.unidev.org.np systemd[1]: Starting NTP client/server...
Sep 25 15:27:34 pdb3.unidev.org.np chronyd[1356]: chronyd version 4.5 starting (+CMDMON +N>
Sep 25 15:27:34 pdb3.unidev.org.np chronyd[1356]: Loaded 0 symmetric keys
Sep 25 15:27:34 pdb3.unidev.org.np chronyd[1356]: Frequency -9.768 +/- 0.285 ppm read from>
Sep 25 15:27:34 pdb3.unidev.org.np chronyd[1356]: Using right/UTC timezone to obtain leap >
Sep 25 15:27:34 pdb3.unidev.org.np systemd[1]: Started NTP client/server.
Sep 25 15:27:39 pdb3.unidev.org.np chronyd[1356]: Selected source 103.104.28.105 (2.pool.n>
Sep 25 15:27:39 pdb3.unidev.org.np chronyd[1356]: System clock TAI offset set to 37 seconds
*/

-- Step 26 -->> On Node 3
[root@pdb3 ~]# systemctl status dnsmasq
/*
● dnsmasq.service - DNS caching server.
   Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2024-09-25 15:27:33 +0545; 6min ago
 Main PID: 1244 (dnsmasq)
    Tasks: 1 (limit: 125778)
   Memory: 1.3M
   CGroup: /system.slice/dnsmasq.service
           └─1244 /usr/sbin/dnsmasq -k

Sep 25 15:27:33 pdb3.unidev.org.np dnsmasq[1244]: compile time options: IPv6 GNU-getopt DB>
Sep 25 15:27:33 pdb3.unidev.org.np dnsmasq[1244]: reading /etc/resolv.conf
Sep 25 15:27:33 pdb3.unidev.org.np dnsmasq[1244]: ignoring nameserver 127.0.0.1 - local in>
Sep 25 15:27:33 pdb3.unidev.org.np dnsmasq[1244]: using nameserver 192.160.4.11#53
Sep 25 15:27:33 pdb3.unidev.org.np dnsmasq[1244]: using nameserver 192.160.4.12#53
Sep 25 15:27:33 pdb3.unidev.org.np dnsmasq[1244]: read /etc/hosts - 14 addresses
Sep 25 15:27:34 pdb3.unidev.org.np dnsmasq[1244]: reading /etc/resolv.conf
Sep 25 15:27:34 pdb3.unidev.org.np dnsmasq[1244]: ignoring nameserver 127.0.0.1 - local in>
Sep 25 15:27:34 pdb3.unidev.org.np dnsmasq[1244]: using nameserver 192.160.4.11#53
Sep 25 15:27:34 pdb3.unidev.org.np dnsmasq[1244]: using nameserver 192.160.4.12#53
*/

-- Step 27 -->> On Node 3
[root@pdb3 ~]# nslookup 192.160.6.28
/*
28.6.160.192.in-addr.arpa name = pdb3.unidev.org.np.
*/

-- Step 27.1 -->> On Node 3
[root@pdb3 ~]# nslookup pdb3
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb3.unidev.org.np
Address: 192.160.7.5
*/

-- Step 27.2 -->> On Node 3
[root@pdb3 ~]# nslookup pdb-scan
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb-scan.unidev.org.np
Address: 192.160.6.27
Name:   pdb-scan.unidev.org.np
Address: 192.160.6.25
Name:   pdb-scan.unidev.org.np
Address: 192.160.6.26
*/

-- Step 27.8 -->> On Node 3
[root@pdb3 ~]# nslookup pdb3-vip
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb3-vip.unidev.org.np
Address: 192.160.6.29
*/

-- Step 27.9 -->> On Node 3
[root@pdb3 ~]# nslookup pdb3-priv
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb3-priv.unidev.org.np
Address: 10.10.10.28
*/

-- Step 28 -->> On Node 3
[root@pdb3 ~]# iptables -L -nv
/*
Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination
*/


-- Step 29 -->> On Node 3
-- Perform either the Automatic Setup or the Manual Setup to complete the basic prerequisites. 
[root@pdb3 ~]# cd /etc/yum.repos.d/
[root@pdb3 yum.repos.d]# dnf -y update

-- Step 29.1 -->> On Node 3
[root@pdb3 yum.repos.d]# dnf install -y yum-utils
[root@pdb3 yum.repos.d]# dnf install -y dnf-utils
[root@pdb3 yum.repos.d]# dnf install -y oracle-epel-release-el8
[root@pdb3 yum.repos.d]# dnf install -y sshpass zip unzip
[root@pdb3 yum.repos.d]# dnf install -y oracle-database-preinstall-19c

-- Step 29.2 -->> On Node 3
[root@pdb3 yum.repos.d]# dnf install -y bc
[root@pdb3 yum.repos.d]# dnf install -y binutils
[root@pdb3 yum.repos.d]# dnf install -y compat-libcap1
[root@pdb3 yum.repos.d]# dnf install -y compat-libstdc++-33
[root@pdb3 yum.repos.d]# dnf install -y dtrace-utils
[root@pdb3 yum.repos.d]# dnf install -y elfutils-libelf
[root@pdb3 yum.repos.d]# dnf install -y elfutils-libelf-devel
[root@pdb3 yum.repos.d]# dnf install -y fontconfig-devel
[root@pdb3 yum.repos.d]# dnf install -y glibc
[root@pdb3 yum.repos.d]# dnf install -y glibc-devel
[root@pdb3 yum.repos.d]# dnf install -y ksh
[root@pdb3 yum.repos.d]# dnf install -y libaio
[root@pdb3 yum.repos.d]# dnf install -y libaio-devel
[root@pdb3 yum.repos.d]# dnf install -y libdtrace-ctf-devel
[root@pdb3 yum.repos.d]# dnf install -y libXrender
[root@pdb3 yum.repos.d]# dnf install -y libXrender-devel
[root@pdb3 yum.repos.d]# dnf install -y libX11
[root@pdb3 yum.repos.d]# dnf install -y libXau
[root@pdb3 yum.repos.d]# dnf install -y libXi
[root@pdb3 yum.repos.d]# dnf install -y libXtst
[root@pdb3 yum.repos.d]# dnf install -y libgcc
[root@pdb3 yum.repos.d]# dnf install -y librdmacm-devel
[root@pdb3 yum.repos.d]# dnf install -y libstdc++
[root@pdb3 yum.repos.d]# dnf install -y libstdc++-devel
[root@pdb3 yum.repos.d]# dnf install -y libxcb
[root@pdb3 yum.repos.d]# dnf install -y make
[root@pdb3 yum.repos.d]# dnf install -y net-tools
[root@pdb3 yum.repos.d]# dnf install -y nfs-utils
[root@pdb3 yum.repos.d]# dnf install -y python
[root@pdb3 yum.repos.d]# dnf install -y python-configshell
[root@pdb3 yum.repos.d]# dnf install -y python-rtslib
[root@pdb3 yum.repos.d]# dnf install -y python-six
[root@pdb3 yum.repos.d]# dnf install -y targetcli
[root@pdb3 yum.repos.d]# dnf install -y smartmontools
[root@pdb3 yum.repos.d]# dnf install -y sysstat
[root@pdb3 yum.repos.d]# dnf install -y libnsl
[root@pdb3 yum.repos.d]# dnf install -y libnsl.i686
[root@pdb3 yum.repos.d]# dnf install -y libnsl2
[root@pdb3 yum.repos.d]# dnf install -y libnsl2.i686
[root@pdb3 yum.repos.d]# dnf install -y chrony
[root@pdb3 yum.repos.d]# dnf install -y unixODBC
[root@pdb3 yum.repos.d]# dnf -y update

-- Step 29.3 -->> On Node 3
[root@pdb3 ~]# cd /tmp
--Bug 29772579
[root@pdb3 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libcap1-1.10-7.el7.i686.rpm
[root@pdb3 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libcap1-1.10-7.el7.x86_64.rpm
[root@pdb3 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libstdc++-33-3.2.3-72.el7.i686.rpm
[root@pdb3 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm

-- Step 29.4 -->> On Node 3
[root@pdb3 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/elfutils-libelf-devel-0.189-3.el8.i686.rpm
[root@pdb3 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/elfutils-libelf-devel-0.189-3.el8.x86_64.rpm
[root@pdb3 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/numactl-2.0.12-13.el8.x86_64.rpm
[root@pdb3 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/numactl-devel-2.0.12-13.el8.x86_64.rpm
[root@pdb3 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/numactl-devel-2.0.12-13.el8.i686.rpm
[root@pdb3 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/python3-libs-3.6.8-56.0.1.el8_9.i686.rpm
[root@pdb3 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/python3-libs-3.6.8-56.0.1.el8_9.x86_64.rpm

/* -- On Physical Server (If the ASMLib-8 we installed)
https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=364500837732007&id=2789052.1&_adf.ctrl-state=11vbxw8jk2_58

--OL8/RHEL8: ASMLib: root.sh is failing with CRS-1705: Found 0 Configured Voting Files But 1 Voting Files Are Required (Doc ID 2789052.1)
Bug 32410237 - oracleasm configure -p not discovering disks on RHEL8
Bug 32812376 - ROOT.SH IS FAILING WTH THE ERRORS CLSRSC-119: START OF THE EXCLUSIVE MODE CLUSTER FAILED
*/

--[root@pdb3 tmp]# wget https://download.oracle.com/otn_software/asmlib/oracleasmlib-2.0.17-1.el8.x86_64.rpm
--[root@pdb3 tmp]# wget https://public-yum.oracle.com/repo/OracleLinux/OL8/addons/x86_64/getPackage/oracleasm-support-2.1.12-1.el8.x86_64.rpm

-- Step 29.5 -->> On Node 3
[root@pdb3 tmp]# wget https://download.oracle.com/otn_software/asmlib/oracleasmlib-2.0.12-1.el7.x86_64.rpm
[root@pdb3 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/oracleasm-support-2.1.11-2.el7.x86_64.rpm

-- Step 29.6 -->> On Node 3
--Bug 29772579
[root@pdb3 tmp]# yum -y localinstall ./compat-libcap1-1.10-7.el7.i686.rpm
[root@pdb3 tmp]# yum -y localinstall ./compat-libcap1-1.10-7.el7.x86_64.rpm
[root@pdb3 tmp]# yum -y localinstall ./compat-libstdc++-33-3.2.3-72.el7.i686.rpm
[root@pdb3 tmp]# yum -y localinstall ./compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm

-- Step 29.7 -->> On Node 3
[root@pdb3 tmp]# yum -y localinstall ./elfutils-libelf-devel-0.189-3.el8.i686.rpm
[root@pdb3 tmp]# yum -y localinstall ./elfutils-libelf-devel-0.189-3.el8.x86_64.rpm
[root@pdb3 tmp]# yum -y localinstall ./numactl-2.0.12-13.el8.x86_64.rpm
[root@pdb3 tmp]# yum -y localinstall ./numactl-devel-2.0.12-13.el8.i686.rpm
[root@pdb3 tmp]# yum -y localinstall ./numactl-devel-2.0.12-13.el8.x86_64.rpm
[root@pdb3 tmp]# yum -y localinstall ./python3-libs-3.6.8-56.0.1.el8_9.i686.rpm
[root@pdb3 tmp]# yum -y localinstall ./python3-libs-3.6.8-56.0.1.el8_9.x86_64.rpm

/* -- On Physical Server (If the ASMLib-8 we installed)
https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=364500837732007&id=2789052.1&_adf.ctrl-state=11vbxw8jk2_58

--OL8/RHEL8: ASMLib: root.sh is failing with CRS-1705: Found 0 Configured Voting Files But 1 Voting Files Are Required (Doc ID 2789052.1)
Bug 32410237 - oracleasm configure -p not discovering disks on RHEL8
Bug 32812376 - ROOT.SH IS FAILING WTH THE ERRORS CLSRSC-119: START OF THE EXCLUSIVE MODE CLUSTER FAILED
*/

--[root@pdb3 tmp]# yum -y localinstall ./oracleasm-support-2.1.12-1.el8.x86_64.rpm ./oracleasmlib-2.0.17-1.el8.x86_64.rpm

-- Step 29.8 -->> On Node 3
[root@pdb3 tmp]# yum -y localinstall ./oracleasm-support-2.1.11-2.el7.x86_64.rpm ./oracleasmlib-2.0.12-1.el7.x86_64.rpm
[root@pdb3 tmp]# rm -rf *.rpm

-- Step 30 -->> On Node 3
[root@pdb3 ~]# cd /etc/yum.repos.d/
[root@pdb3 yum.repos.d]# dnf -y install compat-libcap1 compat-libstdc++-33 bc binutils elfutils-libelf elfutils-libelf-devel fontconfig-devel glibc glibc-devel ksh libaio libaio-devel libgcc libnsl librdmacm-devel libstdc++ libstdc++-devel libX11 libXau libxcb libXi libXrender libXrender-devel libXtst make net-tools nfs-utils python3 python3-configshell python3-rtslib python3-six smartmontools sysstat targetcli unzip
[root@pdb3 yum.repos.d]# dnf -y install bash bc bind-utils binutils ethtool glibc glibc-devel initscripts ksh libaio libaio-devel libgcc libnsl libstdc++ libstdc++-devel make module-init-tools net-tools nfs-utils openssh-clients openssl-libs pam procps psmisc smartmontools sysstat tar unzip util-linux-ng xorg-x11-utils xorg-x11-xauth 
[root@pdb3 yum.repos.d]# dnf -y update

-- Step 31 -->> On Node 3
[root@pdb3 yum.repos.d]# rpm -q binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel elfutils-libelf-devel-static \
[root@pdb3 yum.repos.d]# rpm -q gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers kernel-headers ksh libaio libaio-devel \
[root@pdb3 yum.repos.d]# rpm -q libgcc libgomp libstdc++ libstdc++-devel make numactl-devel sysstat unixODBC unixODBC-devel \

-- Step 32 -->> On Node 3
[root@pdb3 ~]# rpm -qa | grep oracleasm
/*
oracleasm-support-2.1.11-2.el7.x86_64
oracleasmlib-2.0.12-1.el7.x86_64
*/

-- Step 33 -->> On Node 3
-- Add the kernel parameters file "/etc/sysctl.conf" and add oracle recommended kernel parameters
[root@pdb3 ~]# vi /etc/sysctl.conf
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
net.ipv4.ip_local_port_range = 49152 65535
*/

-- Step 33.1 -->> On Node 3
-- Run the following command to change the current kernel parameters.
[root@pdb3 ~]# sysctl -p /etc/sysctl.conf

-- Step 34 -->> On Node 3
-- Edit “/etc/security/limits.d/oracle-database-preinstall-19c.conf” file to limit user processes
[root@pdb3 ~]# vi /etc/security/limits.d/oracle-database-preinstall-19c.conf
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

# Grid Configuration
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

-- Step 35 -->> On Node 3
-- Add the following line to the "/etc/pam.d/login" file, if it does not already exist.
[root@pdb3 ~]# vi /etc/pam.d/login
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

-- Step 36 -->> On Node 3
-- Create the new groups and users.
[root@pdb3 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:
*/

-- Step 36.1 -->> On Node 3
[root@pdb3 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:
backupdba:x:54324:
dgdba:x:54325:
kmdba:x:54326:
racdba:x:54330:
*/

-- Step 36.2 -->> On Node 3
[root@pdb3 ~]# cat /etc/group | grep -i oracle
/*
oracle:x:1000:
*/

-- Step 36.3 -->> On Node 3
[root@pdb3 ~]# cat /etc/group | grep -i oper
/*
oper:x:54323:
*/

-- Step 36.4 -->> On Node 3
[root@pdb3 ~]# cat /etc/group | grep -i asm

-- Step 37 -->> On Node 3
-- 1.Create OS groups using the command below. Enter these commands as the 'root' user:
--[root@pdb3 ~]# /usr/sbin/groupadd -g 503 oper
[root@pdb3 ~]# /usr/sbin/groupadd -g 504 asmadmin
[root@pdb3 ~]# /usr/sbin/groupadd -g 506 asmdba
[root@pdb3 ~]# /usr/sbin/groupadd -g 507 asmoper
[root@pdb3 ~]# /usr/sbin/groupadd -g 508 beoper

-- Step 38 -->> On Node 3
-- 2.Create the users that will own the Oracle software using the commands:
[root@pdb3 ~]# /usr/sbin/useradd  -g oinstall -G oinstall,dba,asmadmin,asmdba,asmoper,beoper grid
[root@pdb3 ~]# /usr/sbin/usermod -g oinstall -G oinstall,dba,oper,asmdba,asmadmin,backupdba,dgdba,kmdba,racdba oracle

-- Step 39.1 -->> On Node 3
[root@pdb3 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/

-- Step 39.2 -->> On Node 3
[root@pdb3 ~]# cat /etc/group | grep -i oracle
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

-- Step 39.3 -->> On Node 3
[root@pdb3 ~]# cat /etc/group | grep -i grid
/*
oinstall:x:54321:grid,oracle
dba:x:54322:grid,oracle
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 39.4 -->> On Node 3
[root@pdb3 ~]# cat /etc/group | grep -i oper
/*
oper:x:54323:oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 39.5 -->> On Node 3
[root@pdb3 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:grid,oracle
*/

-- Step 39.6 -->> On Node 3
[root@pdb3 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:grid,oracle
backupdba:x:54324:oracle
dgdba:x:54325:oracle
kmdba:x:54326:oracle
racdba:x:54330:oracle
asmdba:x:506:grid,oracle
*/

-- Step 40 -->> On Node 3
[root@pdb3 ~]# passwd oracle
/*
Changing password for user oracle.
New password: C#L!5nSI#nG#OraclE#Db#
Retype new password: C#L!5nSI#nG#OraclE#Db#
passwd: all authentication tokens updated successfully.
*/

-- Step 41 -->> On Node 3
[root@pdb3 ~]# passwd grid
/*
Changing password for user grid.
New password: grid
Retype new password: grid
passwd: all authentication tokens updated successfully.
*/

-- Step 42 -->> On Node 3
[root@pdb3 ~]# su - oracle

-- Step 42.1 -->> On Node 3
[oracle@pdb3 ~]$ su - grid
/*
Password: grid
*/

-- Step 42.2 -->> On Node 3
[grid@pdb3 ~]$ su - oracle
/*
Password: C#L!5nSI#nG#OraclE#Db#
*/

-- Step 42.3 -->> On Node 3
[oracle@pdb3 ~]$ exit
/*
logout
*/

-- Step 42.4 -->> On Node 3
[grid@pdb3 ~]$ exit
/*
logout
*/

-- Step 42.5 -->> On Node 3
[oracle@pdb3 ~]$ exit
/*
logout
*/

-- Step 43 -->> On Node 3
--Create the Oracle Inventory Director:
[root@pdb3 ~]# mkdir -p /opt/app/oraInventory
[root@pdb3 ~]# chown -R grid:oinstall /opt/app/oraInventory
[root@pdb3 ~]# chmod -R 775 /opt/app/oraInventory

-- Step 44 -->> On Node 3
--Creating the Oracle Grid Infrastructure Home Directory:
[root@pdb3 ~]# mkdir -p /opt/app/19c/grid
[root@pdb3 ~]# chown -R grid:oinstall /opt/app/19c/grid
[root@pdb3 ~]# chmod -R 775 /opt/app/19c/grid

-- Step 45 -->> On Node 3
--Creating the Oracle Base Directory
[root@pdb3 ~]#   mkdir -p /opt/app/oracle
[root@pdb3 ~]#   chmod -R 775 /opt/app/oracle
[root@pdb3 ~]#   cd /opt/app/
[root@pdb3 app]# chown -R oracle:oinstall /opt/app/oracle

-- Step 46 -->> On Node 3
-- Login as the oracle user and add the following lines at the end of the ".bash_profile" file.
[root@pdb3 ~]# su - oracle
[oracle@pdb3 ~]$ vi .bash_profile
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

ORACLE_HOSTNAME=pdb3.unidev.org.np; export ORACLE_HOSTNAME
ORACLE_UNQNAME=pdbdb; export ORACLE_UNQNAME
ORACLE_BASE=/opt/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/19c/db_1; export ORACLE_HOME
ORACLE_SID=pdbdb3; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 47 -->> On Node 3
[oracle@pdb3 ~]$ . .bash_profile

-- Step 48 -->> On Node 3
-- Login as the grid user and add the following lines at the end of the ".bash_profile" file.
[root@pdb3 ~]# su - grid
[grid@pdb3 ~]$ vi .bash_profile
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

ORACLE_SID=+ASM3; export ORACLE_SID
ORACLE_BASE=/opt/app/oracle; export ORACLE_BASE
GRID_HOME=/opt/app/19c/grid; export GRID_HOME
ORACLE_HOME=$GRID_HOME; export ORACLE_HOME

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 49 -->> On Node 3
[grid@pdb3 ~]$ . .bash_profile

-- Step 50 -->> On Node 3
-- To Unzio The Oracle Grid Software and lateset Opatch
[root@pdb3 ~]# cd /opt/app/19c/grid/
[root@pdb3 grid]# unzip -oq /root/Oracle_19C/19.3.0.0.0_Grid_Binary/LINUX.X64_193000_grid_home.zip
[root@pdb3 grid]# unzip -oq /root/Oracle_19C/OPATCH_19c/p6880880_190000_Linux-x86-64.zip

-- Step 51 -->> On Node 3
-- To Unzio The Oracle PSU
[root@pdb3 ~]# cd /tmp/
[root@pdb3 tmp]# unzip -oq /root/Oracle_19C/PSU_19.23.0.0.0/p36209493_190000_Linux-x86-64.zip
[root@pdb3 tmp]# chown -R oracle:oinstall 36209493
[root@pdb3 tmp]# chmod -R 775 36209493
[root@pdb3 tmp]# ls -ltr | grep 36209493
/*
drwxrwxr-x  4 oracle oinstall      80 Apr 16 16:14 36209493
*/

-- Step 52 -->> On Node 3
-- Login as root user and issue the following command at pdb1
[root@pdb3 ~]# chown -R grid:oinstall /opt/app/19c/grid/
[root@pdb3 ~]# chmod -R 775 /opt/app/19c/grid/

-- Step 53 -->> On Node 3
[root@pdb3 ~]# su - grid
[grid@pdb3 ~]$ cd /opt/app/19c/grid/OPatch/
[grid@pdb3 OPatch]$ ./opatch version
/*
OPatch Version: 12.2.0.1.43

OPatch succeeded.
*/

-- Step 54 -->> On Node 3
-- To install the cvuqdisk-1.0.10-1.rpm
-- Login from root user
[root@pdb3 ~]# cd /opt/app/19c/grid/cv/rpm/
--[grid@pdb3 ~]$ mkdir -p /opt/app/19c/grid/cv/rpm/
--[grid@pdb1 ~]$ scp -r /opt/app/19c/grid/cv/rpm/cvuqdisk-1.0.10-1.rpm grid@pdb3:/opt/app/19c/grid/cv/rpm/

-- Step 54.1 -->> On Node 3
[root@pdb3 rpm]# ll
/*
-rwxrwxr-x 1 grid oinstall 11412 Mar 13  2019 cvuqdisk-1.0.10-1.rpm
*/

-- Step 54.2 -->> On Node 3
--[root@pdb3 rpm]# export CV_ASSUME_DISTID=OEL7.6
[root@pdb3 rpm]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP

-- Step 54.3 -->> On Node 3
[root@pdb3 rpm]# rpm -iUvh cvuqdisk-1.0.10-1.rpm 
/*
Verifying...                          ################################# [100%]
Preparing...                          ################################# [100%]
Updating / installing...
   1:cvuqdisk-1.0.10-1                ################################# [100%]
*/

-- Step 55 -->> On Node 3
[root@pdb3 ~]# which oracleasm
/*
/usr/sbin/oracleasm
*/

-- Step 55.1 -->> On Node 3
[root@pdb3 ~]# oracleasm configure
/*
ORACLEASM_ENABLED=false
ORACLEASM_UID=
ORACLEASM_GID=
ORACLEASM_SCANBOOT=true
ORACLEASM_SCANORDER=""
ORACLEASM_SCANEXCLUDE=""
ORACLEASM_SCAN_DIRECTORIES=""
ORACLEASM_USE_LOGICAL_BLOCK_SIZE="false"
*/

-- Step 55.2 -->> On Node 3
[root@pdb3 ~]# oracleasm status
/*
Checking if ASM is loaded: no
Checking if /dev/oracleasm is mounted: no
*/

-- Step 55.3 -->> On Node 3
[root@pdb3 ~]# oracleasm configure -i
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

-- Step 55.4 -->> On Node 3
[root@pdb3 ~]# oracleasm configure
/*
ORACLEASM_ENABLED=true
ORACLEASM_UID=grid
ORACLEASM_GID=asmadmin
ORACLEASM_SCANBOOT=true
ORACLEASM_SCANORDER=""
ORACLEASM_SCANEXCLUDE=""
ORACLEASM_SCAN_DIRECTORIES=""
ORACLEASM_USE_LOGICAL_BLOCK_SIZE="false"
*/

[root@pdb3 ~]# oracleasm configure -p
/*
Writing Oracle ASM library driver configuration: done
*/

-- Step 55.5 -->> On Node 3
[root@pdb3 ~]# oracleasm init
/*
Creating /dev/oracleasm mount point: /dev/oracleasm
Loading module "oracleasm": oracleasm
Configuring "oracleasm" to use device physical block size
Mounting ASMlib driver filesystem: /dev/oracleasm
*/

-- Step 55.6 -->> On Node 3
[root@pdb3 ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 55.7 -->> On Node 3
[root@pdb3 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 55.8 -->> On Node 3
[root@pdb3 ~]# oracleasm listdisks

-- Step 56 -->> On Node 3
[root@pdb3 ~]# ll /etc/init.d/
/*
-rw-r--r--. 1 root root 18434 Aug 10  2022 functions
-rwxr-xr-x  1 root root  4954 Feb  3  2018 oracleasm
-rwx------  1 root root  1281 Feb 17  2021 oracle-database-preinstall-19c-firstboot
-rw-r--r--. 1 root root  1161 Jun  5 18:53 README
*/

-- Step 57 -->> On Node 3
[root@pdb3 ~]# ll /dev/oracleasm/disks/
/*
total 0
*/

-- Step 58 -->> On Node 3
[root@pdb3 ~]# ll /dev/sd*
/*
brw-rw---- 1 root disk 8, 0 Nov 19 15:24 /dev/sda
brw-rw---- 1 root disk 8, 1 Nov 19 15:24 /dev/sda1
brw-rw---- 1 root disk 8, 2 Nov 19 15:24 /dev/sda2
*/

--Step 58.1 -->> On Node 3
[root@pdb3 ~]# lsblk
/*
NAME               MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                  8:0    0  250G  0 disk
├─sda1               8:1    0    1G  0 part /boot
└─sda2               8:2    0  249G  0 part
  ├─ol_pdb3-root   252:0    0   70G  0 lvm  /
  ├─ol_pdb3-swap   252:1    0   16G  0 lvm  [SWAP]
  ├─ol_pdb3-usr    252:2    0   10G  0 lvm  /usr
  ├─ol_pdb3-opt    252:3    0   70G  0 lvm  /opt
  ├─ol_pdb3-home   252:4    0   10G  0 lvm  /home
  ├─ol_pdb3-var    252:5    0   10G  0 lvm  /var
  ├─ol_pdb3-tmp    252:6    0   10G  0 lvm  /tmp
  └─ol_pdb3-backup 252:7    0   53G  0 lvm  /backup
sr0                 11:0    1  891M  0 rom
*/

-- Step 58.2 -->> On Node 3
[root@pdb3 ~]# init 0

-- Step 58.3 -->> On Node 3
-- Add the existing ASM disk on Node3 with proper Node1 and Node2 configuration

-- Step 58.4 -->> On Nodes
[root@pdb1/pdb2/pdb3 ~]# fdisk -ll | grep GiB
/*
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
Disk /dev/sdc: 400 GiB, 429496729600 bytes, 838860800 sectors
Disk /dev/sdd: 200 GiB, 214748364800 bytes, 419430400 sectors
*/

-- Step 58.5 -->> On Nodes
[root@pdb1/pdb2/pdb3 ~]# lsblk
/*
NAME               MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                  8:0    0  250G  0 disk
├─sda1               8:1    0    1G  0 part /boot
└─sda2               8:2    0  249G  0 part
  ├─ol_pdb3-root   252:0    0   70G  0 lvm  /
  ├─ol_pdb3-swap   252:1    0   16G  0 lvm  [SWAP]
  ├─ol_pdb3-usr    252:2    0   10G  0 lvm  /usr
  ├─ol_pdb3-opt    252:3    0   70G  0 lvm  /opt
  ├─ol_pdb3-home   252:4    0   10G  0 lvm  /home
  ├─ol_pdb3-var    252:5    0   10G  0 lvm  /var
  ├─ol_pdb3-tmp    252:6    0   10G  0 lvm  /tmp
  └─ol_pdb3-backup 252:7    0   53G  0 lvm  /backup
sdb                  8:16   0   20G  0 disk
└─sdb1               8:17   0   20G  0 part
sdc                  8:32   0  400G  0 disk
└─sdc1               8:33   0  400G  0 part
sdd                  8:48   0  200G  0 disk
└─sdd1               8:49   0  200G  0 part
sr0                 11:0    1  891M  0 rom
*/

-- Step 58.6 -->> On Node 3
[root@pdb3 ~]# oracleasm configure -i
/*
Configuring the Oracle ASM library driver.

This will configure the on-boot properties of the Oracle ASM library
driver.  The following questions will determine whether the driver is
loaded on boot and what permissions it will have.  The current values
will be shown in brackets ('[]').  Hitting <ENTER> without typing an
answer will keep that current value.  Ctrl-C will abort.

Default user to own the driver interface [grid]:
Default group to own the driver interface [asmadmin]:
Start Oracle ASM library driver on boot (y/n) [y]:
Scan for Oracle ASM disks on boot (y/n) [y]:
Writing Oracle ASM library driver configuration: done
*/

-- Step 58.7 -->> On Node 3
[root@pdb3 ~]# oracleasm init

-- Step 58.8 -->> On Node 3
[root@pdb3 ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 58.9 -->> On Node 3
[root@pdb3 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 58.10 -->> On Node 3
[root@pdb3 ~]# oracleasm listdisks
/*
ARC
DATA
OCR
*/

-- Step 58.11 -->> On Nodes
[root@pdb1/pdb2/pdb3 ~]# ll /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Nov 24 10:39 /dev/sda
brw-rw---- 1 root disk 8,  1 Nov 24 10:39 /dev/sda1
brw-rw---- 1 root disk 8,  2 Nov 24 10:39 /dev/sda2
brw-rw---- 1 root disk 8, 16 Nov 24 10:41 /dev/sdb
brw-rw---- 1 root disk 8, 17 Nov 24 10:41 /dev/sdb1
brw-rw---- 1 root disk 8, 32 Nov 24 10:41 /dev/sdc
brw-rw---- 1 root disk 8, 33 Nov 24 10:41 /dev/sdc1
brw-rw---- 1 root disk 8, 48 Nov 24 10:41 /dev/sdd
brw-rw---- 1 root disk 8, 49 Nov 24 10:41 /dev/sdd1
*/

-- Step 58.12 -->> On Nodes
[root@pdb1/pdb2/pdb3 ~]# ll /dev/oracleasm/disks/
/*
brw-rw---- 1 grid asmadmin 8, 33 Nov 24 10:52 ARC
brw-rw---- 1 grid asmadmin 8, 49 Nov 24 10:52 DATA
brw-rw---- 1 grid asmadmin 8, 17 Nov 24 10:52 OCR
*/


-- Step 59 -->> On Nodes
[root@pdb1/pdb2/pdb3 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.160.6.21   pdb1.unidev.org.np        pdb1
192.160.6.22   pdb2.unidev.org.np        pdb2
192.160.6.28   pdb3.unidev.org.np        pdb3

# Private
10.10.10.21   pdb1-priv.unidev.org.np   pdb1-priv
10.10.10.22   pdb2-priv.unidev.org.np   pdb2-priv
10.10.10.28   pdb3-priv.unidev.org.np   pdb3-priv

# Virtual
192.160.6.23   pdb1-vip.unidev.org.np    pdb1-vip
192.160.6.24   pdb2-vip.unidev.org.np    pdb2-vip
192.160.6.29   pdb3-vip.unidev.org.np    pdb3-vip

# SCAN
192.160.6.25   pdb-scan.unidev.org.np    pdb-scan
192.160.6.26   pdb-scan.unidev.org.np    pdb-scan
192.160.6.27   pdb-scan.unidev.org.np    pdb-scan
*/


-- Step 59.1 -->> On Nodes
[root@pdb1/pdb2/pdb3 ~]# ping -c 2 pdb1
[root@pdb1/pdb2/pdb3 ~]# ping -c 2 pdb2
[root@pdb1/pdb2/pdb3 ~]# ping -c 2 pdb3
[root@pdb1/pdb2/pdb3 ~]# ping -c 2 pdb1-priv
[root@pdb1/pdb2/pdb3 ~]# ping -c 2 pdb2-priv
[root@pdb1/pdb2/pdb3 ~]# ping -c 2 pdb3-priv
[root@pdb1/pdb2/pdb3 ~]# ping -c 2 pdb1-vip
[root@pdb1/pdb2/pdb3 ~]# ping -c 2 pdb2-vip
[root@pdb1/pdb2/pdb3 ~]# ping -c 2 pdb3-vip
[root@pdb1/pdb2/pdb3 ~]# ping -c 2 pdb-scan


-- Step 60 -->> On Node 1
-- To setup SSH Pass
[root@pdb1 ~]# su - grid
[grid@pdb1 ~]$ cd /opt/app/19c/grid/deinstall
[grid@pdb1 deinstall]$ ./sshUserSetup.sh -user grid -hosts "pdb1 pdb2 pdb3" -noPromptPassphrase -confirm -advanced
/*
Password: grid
*/

-- Step 60.1 -->> On Node 1
-- To setup SSH Pass
[root@pdb1 ~]# su - oracle
[oracle@pdb1 ~]$ cd /opt/app/oracle/product/19c/db_1/deinstall
[oracle@pdb1 deinstall]$ ./sshUserSetup.sh -user oracle -hosts "pdb1 pdb2 pdb3" -noPromptPassphrase -confirm -advanced
/*
Password: oracle
*/

-- Step 61 -->> On Node 3
[grid@pdb1/pdb2/pdb3 ~]$ ssh grid@pdb1 date
[grid@pdb1/pdb2/pdb3 ~]$ ssh grid@pdb1.unidev.org.np date
[grid@pdb1/pdb2/pdb3 ~]$ ssh grid@pdb1 date && ssh grid@pdb1.unidev.org.np date
[grid@pdb1/pdb2/pdb3 ~]$ ssh grid@pdb2 date
[grid@pdb1/pdb2/pdb3 ~]$ ssh grid@pdb2.unidev.org.np date
[grid@pdb1/pdb2/pdb3 ~]$ ssh grid@pdb2 date && ssh grid@pdb2.unidev.org.np date
[grid@pdb1/pdb2/pdb3 ~]$ ssh grid@pdb3 date
[grid@pdb1/pdb2/pdb3 ~]$ ssh grid@pdb3.unidev.org.np date
[grid@pdb1/pdb2/pdb3 ~]$ ssh grid@pdb3 date && ssh grid@pdb3.unidev.org.np date

-- Step 61.1 -->> On Node 3
[oracle@pdb1/pdb2/pdb3 ~]$ ssh oracle@pdb1 date
[oracle@pdb1/pdb2/pdb3 ~]$ ssh oracle@pdb1.unidev.org.np date
[oracle@pdb1/pdb2/pdb3 ~]$ ssh oracle@pdb1 date && ssh oracle@pdb1.unidev.org.np date
[oracle@pdb1/pdb2/pdb3 ~]$ ssh oracle@pdb2 date
[oracle@pdb1/pdb2/pdb3 ~]$ ssh oracle@pdb2.unidev.org.np date
[oracle@pdb1/pdb2/pdb3 ~]$ ssh oracle@pdb2 date && ssh oracle@pdb2.unidev.org.np date
[oracle@pdb1/pdb2/pdb3 ~]$ ssh oracle@pdb3 date
[oracle@pdb1/pdb2/pdb3 ~]$ ssh oracle@pdb3.unidev.org.np date
[oracle@pdb1/pdb2/pdb3 ~]$ ssh oracle@pdb3 date && ssh oracle@pdb3.unidev.org.np date

-- Step 62 -->> On Node 1
[grid@pdb1 ~]$ which cluvfy
/*
/opt/app/19c/grid/bin/cluvfy
*/

-- Step 63 -->> On Node 1
[grid@pdb1 ~]$ cd /opt/app/19c/grid/bin
[grid@pdb1 bin]$ export CV_ASSUME_DISTID=OEL7.6
[grid@pdb1 bin]$ cluvfy stage -pre nodeadd -n pdb3 -fixup -verbose
/*
This software is "241" days old. It is a best practice to update the CRS home by downloading and applying the latest release update. Refer to MOS note 756671.1 for more details.

Performing following verification checks ...

  Physical Memory ...
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          19.2521GB (2.0187292E7KB)  8GB (8388608.0KB)         passed
  pdb1          19.2521GB (2.0187292E7KB)  8GB (8388608.0KB)         passed
  Physical Memory ...PASSED
  Available Physical Memory ...
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          18.6943GB (1.96024E7KB)   50MB (51200.0KB)          passed
  pdb1          14.8647GB (1.5586788E7KB)  50MB (51200.0KB)          passed
  Available Physical Memory ...PASSED
  Swap Size ...
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          15.9961GB (1.6773116E7KB)  16GB (1.6777216E7KB)      passed
  pdb1          16GB (1.6777212E7KB)      16GB (1.6777216E7KB)      passed
  Swap Size ...PASSED
  Free Space: pdb3:/usr,pdb3:/sbin ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /usr              pdb3          /usr          2.7139GB      25MB          passed
  /sbin             pdb3          /usr          2.7139GB      10MB          passed
  Free Space: pdb3:/usr,pdb3:/sbin ...PASSED
  Free Space: pdb3:/var ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /var              pdb3          /var          8.8506GB      5MB           passed
  Free Space: pdb3:/var ...PASSED
  Free Space: pdb3:/etc ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /etc              pdb3          /             58.9014GB     25MB          passed
  Free Space: pdb3:/etc ...PASSED
  Free Space: pdb3:/opt/app/19c/grid ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /opt/app/19c/grid  pdb3          /opt          66.2686GB     6.9GB         passed
  Free Space: pdb3:/opt/app/19c/grid ...PASSED
  Free Space: pdb3:/tmp ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /tmp              pdb3          /tmp          10.3545GB     1GB           passed
  Free Space: pdb3:/tmp ...PASSED
  Free Space: pdb1:/usr,pdb1:/sbin ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /usr              pdb1          /usr          2.5732GB      25MB          passed
  /sbin             pdb1          /usr          2.5732GB      10MB          passed
  Free Space: pdb1:/usr,pdb1:/sbin ...PASSED
  Free Space: pdb1:/var ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /var              pdb1          /var          7.7939GB      5MB           passed
  Free Space: pdb1:/var ...PASSED
  Free Space: pdb1:/etc ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /etc              pdb1          /             58.8965GB     25MB          passed
  Free Space: pdb1:/etc ...PASSED
  Free Space: pdb1:/opt/app/19c/grid ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /opt/app/19c/grid  pdb1          /opt          41.4541GB     6.9GB         passed
  Free Space: pdb1:/opt/app/19c/grid ...PASSED
  Free Space: pdb1:/tmp ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /tmp              pdb1          /tmp          10.3389GB     1GB           passed
  Free Space: pdb1:/tmp ...PASSED
  User Existence: oracle ...
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdb3          passed                    exists(1000)
  pdb1          passed                    exists(1000)

    Users With Same UID: 1000 ...PASSED
  User Existence: oracle ...PASSED
  User Existence: grid ...
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdb3          passed                    exists(1001)
  pdb1          passed                    exists(1001)

    Users With Same UID: 1001 ...PASSED
  User Existence: grid ...PASSED
  User Existence: root ...
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdb3          passed                    exists(0)
  pdb1          passed                    exists(0)

    Users With Same UID: 0 ...PASSED
  User Existence: root ...PASSED
  Group Existence: asmadmin ...
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdb3          passed                    exists
  pdb1          passed                    exists
  Group Existence: asmadmin ...PASSED
  Group Existence: asmoper ...
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdb3          passed                    exists
  pdb1          passed                    exists
  Group Existence: asmoper ...PASSED
  Group Existence: asmdba ...
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdb3          passed                    exists
  pdb1          passed                    exists
  Group Existence: asmdba ...PASSED
  Group Existence: oinstall ...
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdb3          passed                    exists
  pdb1          passed                    exists
  Group Existence: oinstall ...PASSED
  Group Membership: oinstall ...
  Node Name         User Exists   Group Exists  User in Group  Status
  ----------------  ------------  ------------  ------------  ----------------
  pdb3              yes           yes           yes           passed
  pdb1              yes           yes           yes           passed
  Group Membership: oinstall ...PASSED
  Group Membership: asmdba ...
  Node Name         User Exists   Group Exists  User in Group  Status
  ----------------  ------------  ------------  ------------  ----------------
  pdb3              yes           yes           yes           passed
  pdb1              yes           yes           yes           passed
  Group Membership: asmdba ...PASSED
  Group Membership: asmadmin ...
  Node Name         User Exists   Group Exists  User in Group  Status
  ----------------  ------------  ------------  ------------  ----------------
  pdb3              yes           yes           yes           passed
  pdb1              yes           yes           yes           passed
  Group Membership: asmadmin ...PASSED
  Group Membership: asmoper ...
  Node Name         User Exists   Group Exists  User in Group  Status
  ----------------  ------------  ------------  ------------  ----------------
  pdb3              yes           yes           yes           passed
  pdb1              yes           yes           yes           passed
  Group Membership: asmoper ...PASSED
  Run Level ...
  Node Name     run level                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          5                         3,5,3,5                   passed
  pdb1          5                         3,5,3,5                   passed
  Run Level ...PASSED
  Hard Limit: maximum open file descriptors ...
  Node Name         Type          Available     Required      Status
  ----------------  ------------  ------------  ------------  ----------------
  pdb3              hard          65536         65536         passed
  pdb1              hard          65536         65536         passed
  Hard Limit: maximum open file descriptors ...PASSED
  Soft Limit: maximum open file descriptors ...
  Node Name         Type          Available     Required      Status
  ----------------  ------------  ------------  ------------  ----------------
  pdb3              soft          65536         1024          passed
  pdb1              soft          65536         1024          passed
  Soft Limit: maximum open file descriptors ...PASSED
  Hard Limit: maximum user processes ...
  Node Name         Type          Available     Required      Status
  ----------------  ------------  ------------  ------------  ----------------
  pdb3              hard          16384         16384         passed
  pdb1              hard          16384         16384         passed
  Hard Limit: maximum user processes ...PASSED
  Soft Limit: maximum user processes ...
  Node Name         Type          Available     Required      Status
  ----------------  ------------  ------------  ------------  ----------------
  pdb3              soft          16384         2047          passed
  pdb1              soft          16384         2047          passed
  Soft Limit: maximum user processes ...PASSED
  Soft Limit: maximum stack size ...
  Node Name         Type          Available     Required      Status
  ----------------  ------------  ------------  ------------  ----------------
  pdb3              soft          10240         10240         passed
  pdb1              soft          10240         10240         passed
  Soft Limit: maximum stack size ...PASSED
  Users With Same UID: 0 ...PASSED
  Current Group ID ...PASSED
  Root user consistency ...
  Node Name                             Status
  ------------------------------------  ------------------------
  pdb3                                  passed
  pdb1                                  passed
  Root user consistency ...PASSED
  Package: cvuqdisk-1.0.10-1 ...
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          cvuqdisk-1.0.10-1         cvuqdisk-1.0.10-1         passed
  pdb2          cvuqdisk-1.0.10-1         cvuqdisk-1.0.10-1         passed
  pdb1          cvuqdisk-1.0.10-1         cvuqdisk-1.0.10-1         passed
  Package: cvuqdisk-1.0.10-1 ...PASSED
  Node Addition ...
    CRS Integrity ...PASSED
    Clusterware Version Consistency ...PASSED
    '/opt/app/19c/grid' ...PASSED
  Node Addition ...PASSED
  Host name ...PASSED
  Node Connectivity ...
    Hosts File ...
  Node Name                             Status
  ------------------------------------  ------------------------
  pdb2                                  passed
  pdb1                                  passed
  pdb3                                  passed
    Hosts File ...PASSED

Interface information for node "pdb2"

 Name   IP Address      Subnet          Gateway         Def. Gateway    HW Address        MTU 
 ------ --------------- --------------- --------------- --------------- ----------------- ------
 ens160 192.160.6.22     192.160.6.0      0.0.0.0         192.160.6.1      00:0C:29:CE:D9:77 1500
 ens160 192.160.6.24     192.160.6.0      0.0.0.0         192.160.6.1      00:0C:29:CE:D9:77 1500
 ens160 192.160.6.25     192.160.6.0      0.0.0.0         192.160.6.1      00:0C:29:CE:D9:77 1500
 ens192 10.10.10.22     10.10.10.0      0.0.0.0         192.160.6.1      00:50:56:AC:1D:97 1500

Interface information for node "pdb3"

 Name   IP Address      Subnet          Gateway         Def. Gateway    HW Address        MTU 
 ------ --------------- --------------- --------------- --------------- ----------------- ------
 ens160 192.160.6.28     192.160.6.0      0.0.0.0         192.160.6.1      00:50:56:AC:4F:89 1500
 ens192 10.10.10.28     10.10.10.0      0.0.0.0         192.160.6.1      00:50:56:AC:6E:18 1500

Interface information for node "pdb1"

 Name   IP Address      Subnet          Gateway         Def. Gateway    HW Address        MTU 
 ------ --------------- --------------- --------------- --------------- ----------------- ------
 ens160 192.160.6.21     192.160.6.0      0.0.0.0         192.160.6.1      00:0C:29:59:74:F2 1500
 ens160 192.160.6.23     192.160.6.0      0.0.0.0         192.160.6.1      00:0C:29:59:74:F2 1500
 ens160 192.160.6.26     192.160.6.0      0.0.0.0         192.160.6.1      00:0C:29:59:74:F2 1500
 ens160 192.160.6.27     192.160.6.0      0.0.0.0         192.160.6.1      00:0C:29:59:74:F2 1500
 ens192 10.10.10.21     10.10.10.0      0.0.0.0         192.160.6.1      00:50:56:AC:60:6B 1500

Check: MTU consistency on the private interfaces of subnet "10.10.10.0"

  Node              Name          IP Address    Subnet        MTU
  ----------------  ------------  ------------  ------------  ----------------
  pdb3              ens192        10.10.10.28   10.10.10.0    1500
  pdb2              ens192        10.10.10.22   10.10.10.0    1500
  pdb1              ens192        10.10.10.21   10.10.10.0    1500

Check: MTU consistency of the subnet "192.160.6.0".

  Node              Name          IP Address    Subnet        MTU
  ----------------  ------------  ------------  ------------  ----------------
  pdb2              ens160        192.160.6.22   192.160.6.0    1500
  pdb2              ens160        192.160.6.24   192.160.6.0    1500
  pdb2              ens160        192.160.6.25   192.160.6.0    1500
  pdb3              ens160        192.160.6.28   192.160.6.0    1500
  pdb1              ens160        192.160.6.21   192.160.6.0    1500
  pdb1              ens160        192.160.6.23   192.160.6.0    1500
  pdb1              ens160        192.160.6.26   192.160.6.0    1500
  pdb1              ens160        192.160.6.27   192.160.6.0    1500

  Source                          Destination                     Connected?
  ------------------------------  ------------------------------  ----------------
  pdb1[ens192:10.10.10.21]        pdb2[ens192:10.10.10.22]        yes
  pdb1[ens192:10.10.10.21]        pdb3[ens192:10.10.10.28]        yes
  pdb2[ens192:10.10.10.22]        pdb3[ens192:10.10.10.28]        yes

  Source                          Destination                     Connected?
  ------------------------------  ------------------------------  ----------------
  pdb1[ens160:192.160.6.21]        pdb2[ens160:192.160.6.24]        yes
  pdb1[ens160:192.160.6.21]        pdb2[ens160:192.160.6.25]        yes
  pdb1[ens160:192.160.6.21]        pdb3[ens160:192.160.6.28]        yes
  pdb1[ens160:192.160.6.21]        pdb2[ens160:192.160.6.22]        yes
  pdb1[ens160:192.160.6.21]        pdb1[ens160:192.160.6.23]        yes
  pdb1[ens160:192.160.6.21]        pdb1[ens160:192.160.6.26]        yes
  pdb1[ens160:192.160.6.21]        pdb1[ens160:192.160.6.27]        yes
  pdb2[ens160:192.160.6.24]        pdb2[ens160:192.160.6.25]        yes
  pdb2[ens160:192.160.6.24]        pdb3[ens160:192.160.6.28]        yes
  pdb2[ens160:192.160.6.24]        pdb2[ens160:192.160.6.22]        yes
  pdb2[ens160:192.160.6.24]        pdb1[ens160:192.160.6.23]        yes
  pdb2[ens160:192.160.6.24]        pdb1[ens160:192.160.6.26]        yes
  pdb2[ens160:192.160.6.24]        pdb1[ens160:192.160.6.27]        yes
  pdb2[ens160:192.160.6.25]        pdb3[ens160:192.160.6.28]        yes
  pdb2[ens160:192.160.6.25]        pdb2[ens160:192.160.6.22]        yes
  pdb2[ens160:192.160.6.25]        pdb1[ens160:192.160.6.23]        yes
  pdb2[ens160:192.160.6.25]        pdb1[ens160:192.160.6.26]        yes
  pdb2[ens160:192.160.6.25]        pdb1[ens160:192.160.6.27]        yes
  pdb3[ens160:192.160.6.28]        pdb2[ens160:192.160.6.22]        yes
  pdb3[ens160:192.160.6.28]        pdb1[ens160:192.160.6.23]        yes
  pdb3[ens160:192.160.6.28]        pdb1[ens160:192.160.6.26]        yes
  pdb3[ens160:192.160.6.28]        pdb1[ens160:192.160.6.27]        yes
  pdb2[ens160:192.160.6.22]        pdb1[ens160:192.160.6.23]        yes
  pdb2[ens160:192.160.6.22]        pdb1[ens160:192.160.6.26]        yes
  pdb2[ens160:192.160.6.22]        pdb1[ens160:192.160.6.27]        yes
  pdb1[ens160:192.160.6.23]        pdb1[ens160:192.160.6.26]        yes
  pdb1[ens160:192.160.6.23]        pdb1[ens160:192.160.6.27]        yes
  pdb1[ens160:192.160.6.26]        pdb1[ens160:192.160.6.27]        yes
    Check that maximum (MTU) size packet goes through subnet ...PASSED
    subnet mask consistency for subnet "10.10.10.0" ...PASSED
    subnet mask consistency for subnet "192.160.6.0" ...PASSED
  Node Connectivity ...PASSED
  Multicast or broadcast check ...
Checking subnet "10.10.10.0" for multicast communication with multicast group "224.0.0.251"
  Multicast or broadcast check ...PASSED
  ASM Integrity ...PASSED
  Device Checks for ASM ...Disks "/dev/oracleasm/disks/DATA,/dev/oracleasm/disks/ARC,/dev/oracleasm/disks/OCR" are managed by ASM.
  Device Checks for ASM ...PASSED
  Database home availability ...PASSED
  ASMLib installation and configuration verification. ...
    '/etc/init.d/oracleasm' ...PASSED
    '/dev/oracleasm' ...PASSED
    '/etc/sysconfig/oracleasm' ...PASSED

  Node Name                             Status
  ------------------------------------  ------------------------
  pdb1                                  passed
  pdb3                                  passed
  ASMLib installation and configuration verification. ...PASSED
  OCR Integrity ...PASSED
  Time zone consistency ...PASSED
  Network Time Protocol (NTP) ...
    '/etc/chrony.conf' ...
  Node Name                             File exists?
  ------------------------------------  ------------------------
  pdb3                                  yes
  pdb1                                  yes

    '/etc/chrony.conf' ...PASSED
    Daemon 'chronyd' ...
  Node Name                             Running?
  ------------------------------------  ------------------------
  pdb3                                  yes
  pdb1                                  yes

    Daemon 'chronyd' ...PASSED
    NTP daemon or service using UDP port 123 ...
  Node Name                             Port Open?
  ------------------------------------  ------------------------
  pdb3                                  yes
  pdb1                                  yes

    NTP daemon or service using UDP port 123 ...PASSED
    chrony daemon is synchronized with at least one external time source ...PASSED
  Network Time Protocol (NTP) ...PASSED
  User Not In Group "root": grid ...
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdb3          passed                    does not exist
  pdb1          passed                    does not exist
  User Not In Group "root": grid ...PASSED
  Time offset between nodes ...PASSED
  resolv.conf Integrity ...
  Node Name                             Status
  ------------------------------------  ------------------------
  pdb3                                  passed
  pdb1                                  passed

checking response for name "pdb1" from each of the name servers specified in
"/etc/resolv.conf"

  Node Name     Source                    Comment                   Status
  ------------  ------------------------  ------------------------  ----------
  pdb1          127.0.0.1                 IPv4                      passed
  pdb1          192.160.4.11               IPv4                      passed
  pdb1          192.160.4.12               IPv4                      passed

checking response for name "pdb3" from each of the name servers specified in
"/etc/resolv.conf"

  Node Name     Source                    Comment                   Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          127.0.0.1                 IPv4                      passed
  pdb3          192.160.4.11               IPv4                      passed
  pdb3          192.160.4.12               IPv4                      passed
  resolv.conf Integrity ...PASSED
  DNS/NIS name service ...PASSED
  User Equivalence ...
  Node Name                             Status
  ------------------------------------  ------------------------
  pdb3                                  passed
  pdb2                                  passed
  User Equivalence ...PASSED
  Software home: /opt/app/19c/grid ...
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdb1          passed                    1247 files verified
  Software home: /opt/app/19c/grid ...PASSED
  /dev/shm mounted as temporary file system ...PASSED
  zeroconf check ...PASSED

Pre-check for node addition was successful.

CVU operation performed:      stage -pre nodeadd
Date:                         Nov 24, 2024 2:43:12 PM
CVU version:                  19.23.0.0.0 (032824x8664)
Clusterware version:          19.0.0.0.0
CVU home:                     /opt/app/19c/grid
Grid home:                    /opt/app/19c/grid
User:                         grid
Operating system:             Linux5.4.17-2136.335.4.el8uek.x86_64
*/


-- Step 64 -->> On Node 3
-- To solve the Pre-check for rac Setup, from remote nodes PRVG-2002
/*
Verifying resolv.conf Integrity ...FAILED
pdb2: PRVG-2002 : Encountered error in copying file "/etc/resolv.conf" from
      node "pdb2" to node "pdb1"
      protocol error: filename does not match request

Verifying DNS/NIS name service ...FAILED
pdb2: PRVG-2002 : Encountered error in copying file "/etc/nsswitch.conf" from
      node "pdb2" to node "pdb1"
      protocol error: filename does not match request
*/

-- Step 64.1 -->> On Node 3
[root@pdb3 ~]# cp -p /usr/bin/scp /usr/bin/scp-original

-- Step 64.2 -->> On Node 3
[root@pdb3 ~]# echo "/usr/bin/scp-original -T \$*" > /usr/bin/scp

-- Step 64.3 -->> On Node 3
[root@pdb3 ~]# cat /usr/bin/scp
/*
/usr/bin/scp-original -T $*
*/

-- Step 65 -->> On Node 1
[grid@pdb1 ~]$ echo $GRID_HOME
/*
/opt/app/19c/grid
*/

-- Step 66 -->> On Node 1
[grid@pdb1 ~]$ export CV_ASSUME_DISTID=OEL7.6
[grid@pdb1 ~]$ $GRID_HOME/addnode/addnode.sh -silent "CLUSTER_NEW_NODES={pdb3}" "CLUSTER_NEW_VIRTUAL_HOSTNAMES={pdb3-vip}" "CLUSTER_NEW_NODE_ROLES={hub}"
/*
[WARNING] [INS-43055] The Oracle home location is not registered in the central inventory and is not empty in following remote nodes: [pdb3].
   ACTION: Ensure the Oracle home location is empty in such nodes. If not, the Oracle home location would be overwritten with new software.

Copy Files to Remote Nodes in progress.
..................................................   6% Done.
..................................................   11% Done.
....................
Copy Files to Remote Nodes successful.

Prepare Configuration in progress.

Prepare Configuration successful.
..................................................   21% Done.
You can find the log of this install session at:
 /opt/app/oraInventory/logs/addNodeActions2024-11-25_11-37-51AM.log

Instantiate files in progress.

Instantiate files successful.
..................................................   49% Done.

Saving cluster inventory in progress.
..................................................   83% Done.

Saving cluster inventory successful.
The Cluster Node Addition of /opt/app/19c/grid was successful.
Please check '/opt/app/oraInventory/logs/silentInstall2024-11-25_11-37-51AM.log' for more details.

Setup Oracle Base in progress.

Setup Oracle Base successful.
..................................................   90% Done.

Update Inventory in progress.
You can find the log of this install session at:
 /opt/app/oraInventory/logs/addNodeActions2024-11-25_11-37-51AM.log

Update Inventory successful.
..................................................   97% Done.

As a root user, execute the following script(s):
        1. /opt/app/oraInventory/orainstRoot.sh
        2. /opt/app/19c/grid/root.sh

Execute /opt/app/oraInventory/orainstRoot.sh on the following nodes:
[pdb3]
Execute /opt/app/19c/grid/root.sh on the following nodes:
[pdb3]

The scripts can be executed in parallel on all the nodes.

Successfully Setup Software.
..................................................   100% Done.
*/

-- Step 66.1 -->> On Node 1
[root@pdb1 ~]# tail -f /opt/app/oraInventory/logs/addNodeActions2024-11-25_11-37-51AM.log
/*
INFO: New thread started for node : pdb3
INFO: Running command '/opt/app/19c/grid/oui/bin/runInstaller  -paramFile /opt/app/19c/grid/oui/clusterparam.ini  -silent -ignoreSysPrereqs -updateNodeList -setCustomNodelist -noClusterEnabled ORACLE_HOME=/opt/app/19c/grid "CLUSTER_NODES={pdb1,pdb3}" "NODES_TO_SET={pdb3}" CRS=true  -invPtrLoc "/opt/app/19c/grid/oraInst.loc" LOCAL_NODE=pdb3 -remoteInvocation -invokingNodeName pdb1 -logFilePath "/opt/app/oraInventory/logs" -timestamp 2024-11-25_11-37-51AM -doNotUpdateNodeList ' on the nodes 'pdb3'.
INFO: Invoking OUI on cluster nodes pdb3
INFO: /opt/app/19c/grid/oui/bin/runInstaller  -paramFile /opt/app/19c/grid/oui/clusterparam.ini  -silent -ignoreSysPrereqs -updateNodeList -setCustomNodelist -noClusterEnabled ORACLE_HOME=/opt/app/19c/grid "CLUSTER_NODES={pdb1,pdb3}" "NODES_TO_SET={pdb3}" CRS=true  -invPtrLoc "/opt/app/19c/grid/oraInst.loc" LOCAL_NODE=pdb3 -remoteInvocation -invokingNodeName pdb1 -logFilePath "/opt/app/oraInventory/logs" -timestamp 2024-11-25_11-37-51AM -doNotUpdateNodeList
INFO: Command execution completes for node : pdb3
INFO: Command execution sucess for node : pdb3
INFO: All threads completed its operations
INFO: Checkpoint:Index file written and updated
INFO: Done calling doOperation.
INFO: 'UpdateNodeList' was successful.
*/

-- Step 66.2 -->> On Node 3
[root@pdb3 ~]# sh /opt/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 66.3 -->> On Node 3
[root@pdb3 ~]# sh /opt/app/19c/grid/root.sh
/*
Check /opt/app/19c/grid/install/root_pdb3.unidev.org.np_2024-11-25_11-47-15-319253197.log for the output of root script
*/

-- Step 66.4 -->> On Node 3
[root@pdb3 ~]# tail -f /opt/app/19c/grid/install/root_pdb3.unidev.org.np_2024-11-25_11-47-15-319253197.log
/*
Performing root user operation.

The following environment variables are set as:
    ORACLE_OWNER= grid
    ORACLE_HOME=  /opt/app/19c/grid
   Copying dbhome to /usr/local/bin ...
   Copying oraenv to /usr/local/bin ...
   Copying coraenv to /usr/local/bin ...

Creating /etc/oratab file...
Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Relinking oracle with rac_on option
Smartmatch is deprecated at /opt/app/19c/grid/crs/install/crsupgrade.pm line 651                                                                             2.
Using configuration parameter file: /opt/app/19c/grid/crs/install/crsconfig_para                                                                             ms
The log of current session can be found at:
  /opt/app/oracle/crsdata/pdb3/crsconfig/rootcrs_pdb3_2024-11-25_11-47-44AM.log
2024/11/25 11:47:48 CLSRSC-594: Executing installation step 1 of 19: 'ValidateEnv'.
2024/11/25 11:47:49 CLSRSC-363: User ignored prerequisites during installation
2024/11/25 11:47:49 CLSRSC-594: Executing installation step 2 of 19: 'CheckFirstNode'.
2024/11/25 11:47:49 CLSRSC-594: Executing installation step 3 of 19: 'GenSiteGUIDs'.
2024/11/25 11:47:55 CLSRSC-594: Executing installation step 4 of 19: 'SetupOSD'.
Redirecting to /bin/systemctl restart rsyslog.service
2024/11/25 11:47:56 CLSRSC-594: Executing installation step 5 of 19: 'CheckCRSConfig'.
2024/11/25 11:47:58 CLSRSC-594: Executing installation step 6 of 19: 'SetupLocalGPNP'.
2024/11/25 11:48:00 CLSRSC-594: Executing installation step 7 of 19: 'CreateRootCert'.
2024/11/25 11:48:00 CLSRSC-594: Executing installation step 8 of 19: 'ConfigOLR'.
2024/11/25 11:48:11 CLSRSC-594: Executing installation step 9 of 19: 'ConfigCHMOS'.
2024/11/25 11:48:12 CLSRSC-594: Executing installation step 10 of 19: 'CreateOHASD'.
2024/11/25 11:48:14 CLSRSC-594: Executing installation step 11 of 19: 'ConfigOHASD'.
2024/11/25 11:48:14 CLSRSC-330: Adding Clusterware entries to file 'oracle-ohasd.service'
2024/11/25 11:48:39 CLSRSC-594: Executing installation step 12 of 19: 'SetupTFA'.
2024/11/25 11:48:39 CLSRSC-594: Executing installation step 13 of 19: 'InstallAFD'.
2024/11/25 11:48:40 CLSRSC-594: Executing installation step 14 of 19: 'InstallACFS'.
2024/11/25 11:49:27 CLSRSC-594: Executing installation step 15 of 19: 'InstallKA'.
2024/11/25 11:49:28 CLSRSC-594: Executing installation step 16 of 19: 'InitConfig'.
2024/11/25 11:49:38 CLSRSC-594: Executing installation step 17 of 19: 'StartCluster'.
2024/11/25 11:50:46 CLSRSC-343: Successfully started Oracle Clusterware stack
2024/11/25 11:50:46 CLSRSC-594: Executing installation step 18 of 19: 'ConfigNode'.
clscfg: EXISTING configuration version 19 detected.
Successfully accumulated necessary OCR keys.
Creating OCR keys for user 'root', privgrp 'root'..
Operation successful.
2024/11/25 11:51:19 CLSRSC-594: Executing installation step 19 of 19: 'PostConfig'.
2024/11/25 11:52:05 CLSRSC-325: Configure Oracle Grid Infrastructure for a Cluster ... succeeded
2024/11/25 11:52:37 CLSRSC-4002: Successfully installed Oracle Trace File Analyzer (TFA) Collector.
*/

-- Step 67 -->> On All Nodes
[root@pdb1/pdb2/pdb3 ~]# cd /opt/app/19c/grid/bin/
[root@pdb1/pdb2/pdb3 bin]# ./crsctl check cluster -all
/*
**************************************************************
pdb1:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
pdb2:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
pdb3:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/

-- Step 67.1 -->> On All Nodes
[root@pdb1/pdb2/pdb3 ~]# su - grid
[grid@pdb1/pdb2/pdb3 ~]$ which olsnodes
/*
/opt/app/19c/grid/bin/olsnodes
*/

-- Step 67.1.1 -->> On All Nodes
[grid@pdb1/pdb2/pdb3 ~]$ olsnodes -n -s -t
/*
pdb1    1       Active  Unpinned
pdb2    2       Active  Unpinned
pdb3    3       Active  Unpinned
*/

-- Step 68 -->> On Node 1
[root@pdb1 ~]# ps -ef | grep pmon
/*
grid        7505       1  0 Nov24 ?        00:00:06 asm_pmon_+ASM1
oracle      9784       1  0 Nov24 ?        00:00:09 ora_pmon_pdbdb1
root      931924  895111  0 12:14 pts/0    00:00:00 grep --color=auto pmon
*/

-- Step 69 -->> On Node 2
[root@pdb2 ~]# ps -ef | grep pmon
/*
grid        9147       1  0 Nov24 ?        00:00:06 asm_pmon_+ASM2
oracle     13651       1  0 Nov24 ?        00:00:09 ora_pmon_pdbdb2
root      905881  876217  0 12:14 pts/0    00:00:00 grep --color=auto pmon
*/

-- Step 70 -->> On Node 3
[root@pdb3 ~]# ps -ef | grep pmon
/*
grid       99431       1  0 11:51 ?        00:00:00 asm_pmon_+ASM3
root      119067   73031  0 12:14 pts/0    00:00:00 grep --color=auto pmon
*/

-- Step 71 -->> On Node 1
[root@pdb1 ~]# su - oracle
[oracle@pdb1 ~]$ echo $ORACLE_HOME
/*
/opt/app/oracle/product/19c/db_1
*/

-- Step 71.1 -->> On Node 1
[oracle@pdb1 ~]$ export CV_ASSUME_DISTID=OEL7.6
[oracle@pdb1 ~]$ $ORACLE_HOME/addnode/addnode.sh -silent "CLUSTER_NEW_NODES={pdb3}"
/*

Prepare Configuration in progress.

Prepare Configuration successful.
..................................................   7% Done.

Copy Files to Remote Nodes in progress.
..................................................   12% Done.
..................................................   18% Done.
..............................
Copy Files to Remote Nodes successful.
You can find the log of this install session at:
 /opt/app/oraInventory/logs/addNodeActions2024-11-25_12-16-20PM.log

Instantiate files in progress.

Instantiate files successful.
..................................................   52% Done.

Saving cluster inventory in progress.
..................................................   89% Done.

Saving cluster inventory successful.
The Cluster Node Addition of /opt/app/oracle/product/19c/db_1 was successful.
Please check '/opt/app/oraInventory/logs/silentInstall2024-11-25_12-16-20PM.log' for more details.

Setup Oracle Base in progress.

Setup Oracle Base successful.
..................................................   96% Done.

As a root user, execute the following script(s):
        1. /opt/app/oracle/product/19c/db_1/root.sh

Execute /opt/app/oracle/product/19c/db_1/root.sh on the following nodes:
[pdb3]


Successfully Setup Software.
..................................................   100% Done.
*/

-- Step 71.2 -->> On Node 1
[root@pdb1 ~]# tail -f /opt/app/oraInventory/logs/addNodeActions2024-11-25_12-16-20PM.log
/*
INFO:  [Nov 25, 2024 12:21:24 PM] Removing file inventory.xml.pdb232 from scratch path /opt/app/oracle/product/19c/db_1/inventory/Scripts
INFO:  [Nov 25, 2024 12:21:24 PM] Removing file oraInst.loc.pdb3 from scratch path /opt/app/oracle/product/19c/db_1/inventory/Scripts
INFO:  [Nov 25, 2024 12:21:24 PM] Removing file inventory.xml.pdb332 from scratch path /opt/app/oracle/product/19c/db_1/inventory/Scripts
INFO: Dispose the current Session instance
INFO: Dispose the install area control object
INFO: Update the state machine to STATE_CLEAN
INFO:  [Nov 25, 2024 12:21:24 PM] Finding the most appropriate exit status for the current application
INFO:  [Nov 25, 2024 12:21:24 PM] Exit Status is 0
INFO:  [Nov 25, 2024 12:21:24 PM] Shutdown Oracle Database 19c Installer
INFO:  [Nov 25, 2024 12:21:24 PM] Unloading Setup Driver
*/

-- Step 71.3 -->> On Node 3
[root@pdb3 ~]# sh /opt/app/oracle/product/19c/db_1/root.sh
/*
Check /opt/app/oracle/product/19c/db_1/install/root_pdb3.unidev.org.np_2024-11-25_12-24-31-585567898.log for the output of root script
*/

-- Step 71.4 -->> On Node 3
[root@pdb3 ~]# tail -f /opt/app/oracle/product/19c/db_1/install/root_pdb3.unidev.org.np_2024-11-25_12-24-31-585567898.log
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

-- Step 71.5 -->> On Node 3
[root@pdb3 ~]# su - oracle
[oracle@pdb3 ~]$ sqlplus -v
/*
SQL*Plus: Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 72 -->> On Node 1
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Mon Nov 25 12:26:30 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

-- Step 72.1.1 -->> On Node 1
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE

-- Step 72.1.2 -->> On Node 1
SQL> show parameter undo_tablespace

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
undo_tablespace                      string      UNDOTBS1

-- Step 72.1.3 -->> On Node 1
SQL> show parameter instance_number

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
instance_number                      integer     1

-- Step 72.1.4 -->> On Node 1
SQL> show parameter instance_name

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
instance_name                        string      pdbdb1

-- Step 72.1.5 -->> On Node 1
SQL>  show parameter thread

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
ofs_threads                          integer     4
parallel_threads_per_cpu             integer     1
thread                               integer     1
threaded_execution                   boolean     FALSE


-- Step 72.1.6 -->> On Node 1
SQL> alter system set undo_tablespace=UNDOTBS3 sid='pdbdb3' scope=spfile;
SQL> alter system set instance_number=3 sid='pdbdb3' scope=spfile;
SQL> alter system set instance_name='pdbdb3' sid='pdbdb3' scope=spfile;
SQL> alter system set thread=3 sid='pdbdb3' scope=spfile;
--SQL> alter system set log_archive_dest_state_3=ENABLE scope=both sid='*';

-- Step 72.1.7 -->> On Node 1
SQL> set lines 999 pages 999
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
         4          2   52428800
         5          1   52428800
         5          1   52428800
         6          2   52428800
         6          2   52428800

-- Step 72.1.8 -->> On Node 1
SQL> col member for a50
SQL> SELECT * FROM v$logfile a ORDER BY a.type,a.group#;

    GROUP# STATUS  TYPE    MEMBER                                             IS_     CON_ID
---------- ------- ------- -------------------------------------------------- --- ----------
         1         ONLINE  +DATA/PDBDB/ONLINELOG/group_1.281.1181480709       NO           0
         1         ONLINE  +DATA/PDBDB/ONLINELOG/group_1.280.1181480709       NO           0
         2         ONLINE  +DATA/PDBDB/ONLINELOG/group_2.282.1181480715       NO           0
         2         ONLINE  +DATA/PDBDB/ONLINELOG/group_2.283.1181480715       NO           0
         3         ONLINE  +DATA/PDBDB/ONLINELOG/group_3.284.1181480719       NO           0
         3         ONLINE  +DATA/PDBDB/ONLINELOG/group_3.285.1181480719       NO           0
         4         ONLINE  +DATA/PDBDB/ONLINELOG/group_4.286.1181480725       NO           0
         4         ONLINE  +DATA/PDBDB/ONLINELOG/group_4.287.1181480725       NO           0
         5         ONLINE  +DATA/PDBDB/ONLINELOG/group_5.289.1181480731       NO           0
         5         ONLINE  +DATA/PDBDB/ONLINELOG/group_5.288.1181480731       NO           0
         6         ONLINE  +DATA/PDBDB/ONLINELOG/group_6.290.1181480737       NO           0
         6         ONLINE  +DATA/PDBDB/ONLINELOG/group_6.291.1181480737       NO           0
         7         STANDBY +DATA/PDBDB/ONLINELOG/group_7.263.1181481203       NO           0
         7         STANDBY +DATA/PDBDB/ONLINELOG/group_7.262.1181481203       NO           0
         8         STANDBY +DATA/PDBDB/ONLINELOG/group_8.270.1181481205       NO           0
         8         STANDBY +DATA/PDBDB/ONLINELOG/group_8.271.1181481203       NO           0
         9         STANDBY +DATA/PDBDB/ONLINELOG/group_9.293.1181481205       NO           0
         9         STANDBY +DATA/PDBDB/ONLINELOG/group_9.292.1181481205       NO           0
        10         STANDBY +DATA/PDBDB/ONLINELOG/group_10.294.1181481205      NO           0
        10         STANDBY +DATA/PDBDB/ONLINELOG/group_10.295.1181481205      NO           0
        11         STANDBY +DATA/PDBDB/ONLINELOG/group_11.296.1181481205      NO           0
        11         STANDBY +DATA/PDBDB/ONLINELOG/group_11.297.1181481205      NO           0
        12         STANDBY +DATA/PDBDB/ONLINELOG/group_12.298.1181481205      NO           0
        12         STANDBY +DATA/PDBDB/ONLINELOG/group_12.299.1181481207      NO           0
        13         STANDBY +DATA/PDBDB/ONLINELOG/group_13.300.1181481207      NO           0
        13         STANDBY +DATA/PDBDB/ONLINELOG/group_13.301.1181481207      NO           0
        14         STANDBY +DATA/PDBDB/ONLINELOG/group_14.302.1181481207      NO           0
        14         STANDBY +DATA/PDBDB/ONLINELOG/group_14.303.1181481207      NO           0

-- Step 72.1.9 -->> On Node 1
SQL> ALTER DATABASE ADD LOGFILE THREAD 3 GROUP 15 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD LOGFILE THREAD 3 GROUP 16 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD LOGFILE THREAD 3 GROUP 17 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ENABLE PUBLIC THREAD 3;
SQL> ALTER DATABASE ADD STANDBY LOGFILE THREAD 3 GROUP 18 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD STANDBY LOGFILE THREAD 3 GROUP 19 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD STANDBY LOGFILE THREAD 3 GROUP 20 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD STANDBY LOGFILE THREAD 3 GROUP 21 ('+DATA' ,'+DATA') SIZE 50M;


-- Step 72.1.10 -->> On Node 1
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
         4          2   52428800
         5          1   52428800
         5          1   52428800
         6          2   52428800
         6          2   52428800
        15          3   52428800
        15          3   52428800
        16          3   52428800
        16          3   52428800
        17          3   52428800
        17          3   52428800

-- Step 72.1.11 -->> On Node 1
SQL> SELECT * FROM v$logfile a ORDER BY a.type,a.group#;

    GROUP# STATUS  TYPE    MEMBER                                             IS_     CON_ID
---------- ------- ------- -------------------------------------------------- --- ----------
         1         ONLINE  +DATA/PDBDB/ONLINELOG/group_1.281.1181480709       NO           0
         1         ONLINE  +DATA/PDBDB/ONLINELOG/group_1.280.1181480709       NO           0
         2         ONLINE  +DATA/PDBDB/ONLINELOG/group_2.283.1181480715       NO           0
         2         ONLINE  +DATA/PDBDB/ONLINELOG/group_2.282.1181480715       NO           0
         3         ONLINE  +DATA/PDBDB/ONLINELOG/group_3.284.1181480719       NO           0
         3         ONLINE  +DATA/PDBDB/ONLINELOG/group_3.285.1181480719       NO           0
         4         ONLINE  +DATA/PDBDB/ONLINELOG/group_4.287.1181480725       NO           0
         4         ONLINE  +DATA/PDBDB/ONLINELOG/group_4.286.1181480725       NO           0
         5         ONLINE  +DATA/PDBDB/ONLINELOG/group_5.289.1181480731       NO           0
         5         ONLINE  +DATA/PDBDB/ONLINELOG/group_5.288.1181480731       NO           0
         6         ONLINE  +DATA/PDBDB/ONLINELOG/group_6.290.1181480737       NO           0
         6         ONLINE  +DATA/PDBDB/ONLINELOG/group_6.291.1181480737       NO           0
        15         ONLINE  +DATA/PDBDB/ONLINELOG/group_15.306.1185972479      NO           0
        15         ONLINE  +DATA/PDBDB/ONLINELOG/group_15.305.1185972479      NO           0
        16         ONLINE  +DATA/PDBDB/ONLINELOG/group_16.307.1185972485      NO           0
        16         ONLINE  +DATA/PDBDB/ONLINELOG/group_16.308.1185972485      NO           0
        17         ONLINE  +DATA/PDBDB/ONLINELOG/group_17.310.1185972525      NO           0
        17         ONLINE  +DATA/PDBDB/ONLINELOG/group_17.309.1185972525      NO           0
         7         STANDBY +DATA/PDBDB/ONLINELOG/group_7.263.1181481203       NO           0
         7         STANDBY +DATA/PDBDB/ONLINELOG/group_7.262.1181481203       NO           0
         8         STANDBY +DATA/PDBDB/ONLINELOG/group_8.270.1181481205       NO           0
         8         STANDBY +DATA/PDBDB/ONLINELOG/group_8.271.1181481203       NO           0
         9         STANDBY +DATA/PDBDB/ONLINELOG/group_9.292.1181481205       NO           0
         9         STANDBY +DATA/PDBDB/ONLINELOG/group_9.293.1181481205       NO           0
        10         STANDBY +DATA/PDBDB/ONLINELOG/group_10.295.1181481205      NO           0
        10         STANDBY +DATA/PDBDB/ONLINELOG/group_10.294.1181481205      NO           0
        11         STANDBY +DATA/PDBDB/ONLINELOG/group_11.297.1181481205      NO           0
        11         STANDBY +DATA/PDBDB/ONLINELOG/group_11.296.1181481205      NO           0
        12         STANDBY +DATA/PDBDB/ONLINELOG/group_12.299.1181481207      NO           0
        12         STANDBY +DATA/PDBDB/ONLINELOG/group_12.298.1181481205      NO           0
        13         STANDBY +DATA/PDBDB/ONLINELOG/group_13.301.1181481207      NO           0
        13         STANDBY +DATA/PDBDB/ONLINELOG/group_13.300.1181481207      NO           0
        14         STANDBY +DATA/PDBDB/ONLINELOG/group_14.302.1181481207      NO           0
        14         STANDBY +DATA/PDBDB/ONLINELOG/group_14.303.1181481207      NO           0
        18         STANDBY +DATA/PDBDB/ONLINELOG/group_18.312.1185975713      NO           0
        18         STANDBY +DATA/PDBDB/ONLINELOG/group_18.313.1185975713      NO           0
        19         STANDBY +DATA/PDBDB/ONLINELOG/group_19.314.1185975719      NO           0
        19         STANDBY +DATA/PDBDB/ONLINELOG/group_19.315.1185975719      NO           0
        20         STANDBY +DATA/PDBDB/ONLINELOG/group_20.316.1185975723      NO           0
        20         STANDBY +DATA/PDBDB/ONLINELOG/group_20.317.1185975723      NO           0
        21         STANDBY +DATA/PDBDB/ONLINELOG/group_21.318.1185975727      NO           0
        21         STANDBY +DATA/PDBDB/ONLINELOG/group_21.319.1185975729      NO           0

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 73 -->> On Node 1
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 74 -->> On Node 1
[oracle@pdb1 ~]$ srvctl config database -d pdbdb
/*
Database unique name: pdbdb
Database name: pdbdb
Oracle home: /opt/app/oracle/product/19c/db_1
Oracle user: oracle
Spfile: +DATA/PDBDB/PARAMETERFILE/spfile.272.1181047863
Password file: +DATA/PDBDB/PASSWORD/pwdpdbdb.256.1181045219
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
Database instances: pdbdb1,pdbdb2
Configured nodes: pdb1,pdb2
CSS critical: no
CPU count: 0
Memory target: 0
Maximum memory: 0
Default network number for database services:
Database is administrator managed
*/

-- Step 75 -->> On Node 1
[oracle@pdb1 ~]$ srvctl add instance -d pdbdb -i pdbdb3 -n pdb3

-- Step 76 -->> On Node 1
[oracle@pdb1 ~]$ srvctl config database -d pdbdb
/*
Database unique name: pdbdb
Database name: pdbdb
Oracle home: /opt/app/oracle/product/19c/db_1
Oracle user: oracle
Spfile: +DATA/PDBDB/PARAMETERFILE/spfile.272.1181047863
Password file: +DATA/PDBDB/PASSWORD/pwdpdbdb.256.1181045219
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
Database instances: pdbdb1,pdbdb2,pdbdb3
Configured nodes: pdb1,pdb2,pdb3
CSS critical: no
CPU count: 0
Memory target: 0
Maximum memory: 0
Default network number for database services:
Database is administrator managed
*/

-- Step 77 -->> On Node 1
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
Instance pdbdb3 is not running on node pdb3
*/

-- Step 78 -->> On Node 3
[root@pdb3 ~]# mkdir -p /opt/app/oracle/admin/pdbdb/adump
[root@pdb3 ~]# cd /opt/app/oracle/admin/
[root@pdb3 admin]# chown -R oracle:oinstall pdbdb/
[root@pdb3 admin]# chmod -R 775 pdbdb/

-- Step 79 -->> On Node 1
[oracle@pdb1 ~]$ srvctl start instance -i pdbdb3 -d pdbdb

-- Step 80 -->> On Node 1
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
Instance pdbdb3 is running on node pdb3. Instance status: Open.
*/

-- Step 81 -->> On Node 3
[oracle@pdb3 ~]$ vi /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
/*
[oracle@pdb3 ~]$  cat /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
# tnsnames.ora Network Configuration File: /opt/app/oracle/product/19c/db_1/network/admin/tns                                                                                                names.ora
# Generated by Oracle configuration tools.

PDBDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdb-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = pdbdb)
    )
  )

PDBDB3 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.160.6.28)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = pdbdb)
    )
  )

SBXPDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdb-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = sbxpdb)
    )
  )

DR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = dr)
    )
  )
*/

-- Step 81.1 -->> On Node 3
[oracle@pdb3 ~]$ tnsping PDBDB
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 25-NOV-2024 13:33:24

Copyright (c) 1997, 2024, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdb-scan)(PORT = 1521                                                                                                )) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = pdbdb)))
OK (10 msec)
*/

-- Step 81.2 -->> On Node 3
[oracle@pdb3 ~]$ tnsping PDBDB3
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 25-NOV-2024 13:33:32

Copyright (c) 1997, 2024, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = 192.160.6.28)(PORT = 1                                                                                                521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = pdbdb)))
OK (0 msec)
*/

-- Step 81.3 -->> On Node 3
[oracle@pdb3 ~]$ tnsping SBXPDB
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 25-NOV-2024 13:33:41

Copyright (c) 1997, 2024, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdb-scan)(PORT = 1521                                                                                                )) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = sbxpdb)))
OK (10 msec)
*/

-- Step 81.4 -->> On Node 3
[oracle@pdb3 ~]$ tnsping DR
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 25-NOV-2024 13:33:44

Copyright (c) 1997, 2024, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr-scan)(PORT = 15                                                                                                21)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = dr)))
OK (20 msec)
*/

-- Step 82 -->> On Node 1
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
Instance pdbdb3 is running on node pdb3. Instance status: Open.
*/

-- Step 83 -->> On Node 1 (DR)
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Mon Nov 25 12:58:47 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

-- Step 83.1.1 -->> On Node 1 (DR)
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED

-- Step 83.1.2 -->> On Node 1 (DR)
SQL> set lines 999 pages 999
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
         4          2   52428800
         5          1   52428800
         5          1   52428800
         6          2   52428800
         6          2   52428800

-- Step 83.1.3 -->> On Node 1 (DR)
SQL> col member for a50
SQL> SELECT * FROM v$logfile a ORDER BY a.type,a.group#;

    GROUP# STATUS  TYPE    MEMBER                                             IS_     CON_ID
---------- ------- ------- -------------------------------------------------- --- ----------
         1         ONLINE  +ARC/DR/ONLINELOG/group_1.258.1181668197           YES          0
         1         ONLINE  +DATA/DR/ONLINELOG/group_1.272.1181668197          NO           0
         2         ONLINE  +ARC/DR/ONLINELOG/group_2.259.1181668197           YES          0
         2         ONLINE  +DATA/DR/ONLINELOG/group_2.273.1181668197          NO           0
         3         ONLINE  +DATA/DR/ONLINELOG/group_3.274.1181668197          NO           0
         3         ONLINE  +ARC/DR/ONLINELOG/group_3.260.1181668199           YES          0
         4         ONLINE  +ARC/DR/ONLINELOG/group_4.261.1181668199           YES          0
         4         ONLINE  +DATA/DR/ONLINELOG/group_4.275.1181668199          NO           0
         5         ONLINE  +ARC/DR/ONLINELOG/group_5.262.1181668199           YES          0
         5         ONLINE  +DATA/DR/ONLINELOG/group_5.276.1181668199          NO           0
         6         ONLINE  +DATA/DR/ONLINELOG/group_6.277.1181668199          NO           0
         6         ONLINE  +ARC/DR/ONLINELOG/group_6.263.1181668199           YES          0
         7         STANDBY +DATA/DR/ONLINELOG/group_7.278.1181668201          NO           0
         7         STANDBY +ARC/DR/ONLINELOG/group_7.264.1181668201           YES          0
         8         STANDBY +ARC/DR/ONLINELOG/group_8.265.1181668201           YES          0
         8         STANDBY +DATA/DR/ONLINELOG/group_8.279.1181668201          NO           0
         9         STANDBY +DATA/DR/ONLINELOG/group_9.280.1181668201          NO           0
         9         STANDBY +ARC/DR/ONLINELOG/group_9.266.1181668201           YES          0
        10         STANDBY +ARC/DR/ONLINELOG/group_10.267.1181668203          YES          0
        10         STANDBY +DATA/DR/ONLINELOG/group_10.281.1181668201         NO           0
        11         STANDBY +ARC/DR/ONLINELOG/group_11.268.1181668203          YES          0
        11         STANDBY +DATA/DR/ONLINELOG/group_11.282.1181668203         NO           0
        12         STANDBY +ARC/DR/ONLINELOG/group_12.269.1181668203          YES          0
        12         STANDBY +DATA/DR/ONLINELOG/group_12.283.1181668203         NO           0
        13         STANDBY +ARC/DR/ONLINELOG/group_13.270.1181668203          YES          0
        13         STANDBY +DATA/DR/ONLINELOG/group_13.284.1181668203         NO           0
        14         STANDBY +DATA/DR/ONLINELOG/group_14.285.1181668205         NO           0
        14         STANDBY +ARC/DR/ONLINELOG/group_14.271.1181668205          YES          0

-- Step 83.1.4 -->> On Node 1 (DR)
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
SQL> ALTER SYSTEM SET STANDBY_FILE_MANAGEMENT=MANUAL;
SQL> ALTER DATABASE ADD LOGFILE THREAD 3 GROUP 15 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD LOGFILE THREAD 3 GROUP 16 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD LOGFILE THREAD 3 GROUP 17 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD STANDBY LOGFILE THREAD 3 GROUP 18 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD STANDBY LOGFILE THREAD 3 GROUP 19 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD STANDBY LOGFILE THREAD 3 GROUP 20 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD STANDBY LOGFILE THREAD 3 GROUP 21 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER SYSTEM SET STANDBY_FILE_MANAGEMENT=AUTO;
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION INSTANCES ALL;

-- Step 83.1.5 -->> On Node 1 (DR)
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
         4          2   52428800
         5          1   52428800
         5          1   52428800
         6          2   52428800
         6          2   52428800
        15          3   52428800
        15          3   52428800
        16          3   52428800
        16          3   52428800
        17          3   52428800
        17          3   52428800

-- Step 83.1.6 -->> On Node 1 (DR)
SQL> SELECT * FROM v$logfile a ORDER BY a.type,a.group#;

    GROUP# STATUS  TYPE    MEMBER                                             IS_     CON_ID
---------- ------- ------- -------------------------------------------------- --- ----------
         1         ONLINE  +ARC/DR/ONLINELOG/group_1.258.1181668197           YES          0
         1         ONLINE  +DATA/DR/ONLINELOG/group_1.272.1181668197          NO           0
         2         ONLINE  +ARC/DR/ONLINELOG/group_2.259.1181668197           YES          0
         2         ONLINE  +DATA/DR/ONLINELOG/group_2.273.1181668197          NO           0
         3         ONLINE  +DATA/DR/ONLINELOG/group_3.274.1181668197          NO           0
         3         ONLINE  +ARC/DR/ONLINELOG/group_3.260.1181668199           YES          0
         4         ONLINE  +ARC/DR/ONLINELOG/group_4.261.1181668199           YES          0
         4         ONLINE  +DATA/DR/ONLINELOG/group_4.275.1181668199          NO           0
         5         ONLINE  +ARC/DR/ONLINELOG/group_5.262.1181668199           YES          0
         5         ONLINE  +DATA/DR/ONLINELOG/group_5.276.1181668199          NO           0
         6         ONLINE  +DATA/DR/ONLINELOG/group_6.277.1181668199          NO           0
         6         ONLINE  +ARC/DR/ONLINELOG/group_6.263.1181668199           YES          0
        15         ONLINE  +ARC/DR/ONLINELOG/group_15.362.1185974285          YES          0
        15         ONLINE  +DATA/DR/ONLINELOG/group_15.293.1185974283         NO           0
        16         ONLINE  +DATA/DR/ONLINELOG/group_16.294.1185974285         NO           0
        16         ONLINE  +ARC/DR/ONLINELOG/group_16.343.1185974285          YES          0
        17         ONLINE  +DATA/DR/ONLINELOG/group_17.296.1185982199         NO           0
        17         ONLINE  +DATA/DR/ONLINELOG/group_17.295.1185982199         NO           0
         7         STANDBY +DATA/DR/ONLINELOG/group_7.278.1181668201          NO           0
         7         STANDBY +ARC/DR/ONLINELOG/group_7.264.1181668201           YES          0
         8         STANDBY +ARC/DR/ONLINELOG/group_8.265.1181668201           YES          0
         8         STANDBY +DATA/DR/ONLINELOG/group_8.279.1181668201          NO           0
         9         STANDBY +DATA/DR/ONLINELOG/group_9.280.1181668201          NO           0
         9         STANDBY +ARC/DR/ONLINELOG/group_9.266.1181668201           YES          0
        10         STANDBY +ARC/DR/ONLINELOG/group_10.267.1181668203          YES          0
        10         STANDBY +DATA/DR/ONLINELOG/group_10.281.1181668201         NO           0
        11         STANDBY +ARC/DR/ONLINELOG/group_11.268.1181668203          YES          0
        11         STANDBY +DATA/DR/ONLINELOG/group_11.282.1181668203         NO           0
        12         STANDBY +ARC/DR/ONLINELOG/group_12.269.1181668203          YES          0
        12         STANDBY +DATA/DR/ONLINELOG/group_12.283.1181668203         NO           0
        13         STANDBY +ARC/DR/ONLINELOG/group_13.270.1181668203          YES          0
        13         STANDBY +DATA/DR/ONLINELOG/group_13.284.1181668203         NO           0
        14         STANDBY +DATA/DR/ONLINELOG/group_14.285.1181668205         NO           0
        14         STANDBY +ARC/DR/ONLINELOG/group_14.271.1181668205          YES          0
        18         STANDBY +DATA/DR/ONLINELOG/group_18.297.1185982215         NO           0
        18         STANDBY +DATA/DR/ONLINELOG/group_18.298.1185982215         NO           0
        19         STANDBY +DATA/DR/ONLINELOG/group_19.299.1185982219         NO           0
        19         STANDBY +DATA/DR/ONLINELOG/group_19.300.1185982219         NO           0
        20         STANDBY +DATA/DR/ONLINELOG/group_20.301.1185982225         NO           0
        20         STANDBY +DATA/DR/ONLINELOG/group_20.302.1185982225         NO           0
        21         STANDBY +DATA/DR/ONLINELOG/group_21.303.1185982229         NO           0
        21         STANDBY +DATA/DR/ONLINELOG/group_21.304.1185982229         NO           0

-- Step 83.1.7 -->> On Node 1 (DR)
SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           746          1
           639          2
            41          3

-- Step 83.1.8 -->> On Node 1 (DR)
SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby;

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         0          0 CONNECTED             0 ARCH
         0          0 ALLOCATED             0 DGRD
         0          0 ALLOCATED             0 DGRD
         0          0 CONNECTED             0 ARCH
         1        741 CLOSING            6144 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         1        739 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         1        746 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         1        743 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         1        737 CLOSING           65536 ARCH
         1        740 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         1        745 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         1        744 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         1        738 CLOSING            2048 ARCH
         0          0 CONNECTED             0 ARCH
         1        742 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         1        747 IDLE                115 RFS
         0          0 IDLE                  0 RFS
         2          0 IDLE                  0 RFS
         3         42 APPLYING_LOG       1172 MRP0
         3         40 CLOSING               1 ARCH
         0          0 ALLOCATED             0 DGRD
         0          0 ALLOCATED             0 DGRD
         0          0 CONNECTED             0 ARCH
         1        734 CLOSING               1 ARCH
         3         32 CLOSING               1 ARCH
         2        623 CLOSING               1 ARCH
         2        636 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         3         34 CLOSING               1 ARCH
         2        629 CLOSING               1 ARCH
         2        630 CLOSING            6144 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         3         41 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         2        635 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         3         37 CLOSING               1 ARCH
         3         39 CLOSING               1 ARCH
         2        626 CLOSING           63488 ARCH
         3         36 CLOSING            8192 ARCH
         2        637 CLOSING               1 ARCH
         2        633 CLOSING               1 ARCH
         2        638 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         2        639 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         3         42 IDLE               1172 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         3          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         1          0 IDLE                  0 RFS
         2        640 IDLE                118 RFS

-- Step 83.1.9 -->> On Node 1 (DR)
SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           746          1
           639          2
            41          3

-- Step 83.1.10 -->> On Node 1 (DR)
SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

-- Step 83.1.11 -->> On Node 1 (DR)
SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
---------------------Deleting Node 3 from 3-Node-DC and 2-Node-DR-----------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

-- Step 01 -->> On Node 3 (Pre-verifications)
[root@pdb3 ~]# su - grid
[grid@pdb3 ~]$ olsnodes -n -s -t
/*
pdb1    1       Active  Unpinned
pdb2    2       Active  Unpinned
pdb3    3       Active  Unpinned
*/

-- Step 01.01 -->> On Node 1 (Pre-verifications)
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Thu Nov 28 15:17:17 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE
         3 OPEN         pdbdb3           PRIMARY          READ WRITE

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 01.02 -->> On Node 1 (Pre-verifications)
[oracle@pdb1 ~]$ srvctl config database -d pdbdb
/*
Database unique name: pdbdb
Database name: pdbdb
Oracle home: /opt/app/oracle/product/19c/db_1
Oracle user: oracle
Spfile: +DATA/PDBDB/PARAMETERFILE/spfile.272.1181047863
Password file: +DATA/PDBDB/PASSWORD/pwdpdbdb.256.1181045219
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
Database instances: pdbdb1,pdbdb2,pdbdb3
Configured nodes: pdb1,pdb2,pdb3
CSS critical: no
CPU count: 0
Memory target: 0
Maximum memory: 0
Default network number for database services:
Database is administrator managed
*/

-- Step 01.03 -->> On Node 1 (Pre-verifications)
[oracle@pdb1 ~]$ env | grep ORA
/*
ORACLE_UNQNAME=pdbdb
ORACLE_SID=pdbdb1
ORACLE_BASE=/opt/app/oracle
ORACLE_HOME=/opt/app/oracle/product/19c/db_1
ORACLE_HOSTNAME=pdb1.unidev.org.np
*/

-- Step 01.04 -->> On Node 3 (Pre-verifications)
[oracle@pdb3 ~]$ env | grep ORA
/*
ORACLE_UNQNAME=pdbdb
ORACLE_SID=pdbdb3
ORACLE_BASE=/opt/app/oracle
ORACLE_HOME=/opt/app/oracle/product/19c/db_1
ORACLE_HOSTNAME=pdb3.unidev.org.np
*/

-- Step 02 -->> On Node 1
--Delete the Oracle Instance -(Use the Database Configuration Assistant (DBCA) in silent mode)
[oracle@pdb1 ~]$ which dbca
/*
/opt/app/oracle/product/19c/db_1/bin/dbca
*/

-- Step 02.1 -->> On Node 1
[oracle@pdb1 ~]$ export CV_ASSUME_DISTID=OEL7.6
[oracle@pdb1 ~]$ dbca -silent -deleteInstance -nodeList pdb3 -gdbName pdbdb -instanceName pdbdb3 -sysDBAUserName sys -sysDBAPassword Sys605014
/*
[WARNING] [DBT-19203] The Database Configuration Assistant will delete the Oracle instance and its associated OFA directory structure. All information about this instance will be deleted.

Prepare for db operation
40% complete
Deleting instance
48% complete
52% complete
56% complete
60% complete
64% complete
68% complete
72% complete
76% complete
80% complete
Completing instance management.
100% complete
Instance "pdbdb3" deleted successfully from node "pdb3".
Look at the log file "/opt/app/oracle/cfgtoollogs/dbca/pdbdb/pdbdb0.log" for further details.
*/

-- Step 02.2 -->> On Node 1
[oracle@pdb1 ~]$ cat /opt/app/oracle/cfgtoollogs/dbca/pdbdb/pdbdb0.log
/*
[ 2024-11-28 15:13:50.574 NPT ] [WARNING] [DBT-19203] The Database Configuration Assistant will delete the Oracle instance and its associated OFA directory structure. All information about this instance will be deleted.

[ 2024-11-28 15:13:50.846 NPT ] Prepare for db operation
DBCA_PROGRESS : 40%
[ 2024-11-28 15:13:50.936 NPT ] Deleting instance
DBCA_PROGRESS : 48%
DBCA_PROGRESS : 52%
DBCA_PROGRESS : 56%
DBCA_PROGRESS : 60%
DBCA_PROGRESS : 64%
DBCA_PROGRESS : 68%
DBCA_PROGRESS : 72%
DBCA_PROGRESS : 76%
DBCA_PROGRESS : 80%
[ 2024-11-28 15:14:48.993 NPT ] Completing instance management.
DBCA_PROGRESS : 100%
[ 2024-11-28 15:14:49.267 NPT ] Instance "pdbdb3" deleted successfully from node "pdb3".
*/

-- Step 03 -->> On Node 1 (Verification)
[oracle@pdb1 ~]$ srvctl config database -d pdbdb
/*
Database unique name: pdbdb
Database name: pdbdb
Oracle home: /opt/app/oracle/product/19c/db_1
Oracle user: oracle
Spfile: +DATA/PDBDB/PARAMETERFILE/spfile.272.1181047863
Password file: +DATA/PDBDB/PASSWORD/pwdpdbdb.256.1181045219
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
Database instances: pdbdb1,pdbdb2
Configured nodes: pdb1,pdb2
CSS critical: no
CPU count: 0
Memory target: 0
Maximum memory: 0
Default network number for database services:
Database is administrator managed
*/

-- Step 03.01 -->> On Node 1 (Verification)
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Thu Nov 28 15:17:17 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 04 -->> On Node 3 (Deinstall Oracle Database Home)
[oracle@pdb3 ~]$ echo $ORACLE_HOME
/*
/opt/app/oracle/product/19c/db_1
*/

-- Step 04.01 -->> On Node 3 (Deinstall Oracle Database Home)
[oracle@pdb3 ~]$ cd /opt/app/oracle/product/19c/db_1
[oracle@pdb3 db_1]$ cd deinstall/
[oracle@pdb3 deinstall]$ ./deinstall  -local
/*
Checking for required files and bootstrapping ...
Please wait ...
Location of logs /opt/app/oraInventory/logs/

############ ORACLE DECONFIG TOOL START ############


######################### DECONFIG CHECK OPERATION START #########################
## [START] Install check configuration ##


Checking for existence of the Oracle home location /opt/app/oracle/product/19c/db_1
Oracle Home type selected for deinstall is: Oracle Real Application Cluster Database
Oracle Base selected for deinstall is: /opt/app/oracle
Checking for existence of central inventory location /opt/app/oraInventory
Checking for existence of the Oracle Grid Infrastructure home /opt/app/19c/grid
The following nodes are part of this cluster: pdb3,pdb2,pdb1
Checking for sufficient temp space availability on node(s) : 'pdb3'

## [END] Install check configuration ##


Network Configuration check config START

Network de-configuration trace file location: /opt/app/oraInventory/logs/netdc_check2024-11-28_03-26-44PM.log

Network Configuration check config END

Database Check Configuration START

Database de-configuration trace file location: /opt/app/oraInventory/logs/databasedc_check2024-11-28_03-26-44PM.log

Use comma as separator when specifying list of values as input

Specify the list of database names that are configured locally on this node for this Oracle home. Local configurations of the discovered databases will be removed []: yes
Database Check Configuration END

######################### DECONFIG CHECK OPERATION END #########################


####################### DECONFIG CHECK OPERATION SUMMARY #######################
Oracle Grid Infrastructure Home is: /opt/app/19c/grid
The following nodes are part of this cluster: pdb3,pdb2,pdb1
The cluster node(s) on which the Oracle home deinstallation will be performed are:pdb3
Oracle Home selected for deinstall is: /opt/app/oracle/product/19c/db_1
Inventory Location where the Oracle home registered is: /opt/app/oraInventory
The option -local will not modify any database configuration for this Oracle home.
Do you want to continue (y - yes, n - no)? [n]: y
A log of this session will be written to: '/opt/app/oraInventory/logs/deinstall_deconfig2024-11-28_03-26-37-PM.out'
Any error messages from this session will be written to: '/opt/app/oraInventory/logs/deinstall_deconfig2024-11-28_03-26-37-PM.err'

######################## DECONFIG CLEAN OPERATION START ########################
Database de-configuration trace file location: /opt/app/oraInventory/logs/databasedc_clean2024-11-28_03-26-44PM.log

Network Configuration clean config START

Network de-configuration trace file location: /opt/app/oraInventory/logs/netdc_clean2024-11-28_03-26-44PM.log

Network Configuration clean config END


######################### DECONFIG CLEAN OPERATION END #########################


####################### DECONFIG CLEAN OPERATION SUMMARY #######################
#######################################################################


############# ORACLE DECONFIG TOOL END #############

Using properties file /tmp/deinstall2024-11-28_03-26-26PM/response/deinstall_2024-11-28_03-26-37-PM.rsp
Location of logs /opt/app/oraInventory/logs/

############ ORACLE DEINSTALL TOOL START ############


####################### DEINSTALL CHECK OPERATION SUMMARY #######################
A log of this session will be written to: '/opt/app/oraInventory/logs/deinstall_deconfig2024-11-28_03-26-37-PM.out'
Any error messages from this session will be written to: '/opt/app/oraInventory/logs/deinstall_deconfig2024-11-28_03-26-37-PM.err'

######################## DEINSTALL CLEAN OPERATION START ########################
## [START] Preparing for Deinstall ##
Setting LOCAL_NODE to pdb3
Setting CLUSTER_NODES to pdb3
Setting CRS_HOME to false
Setting oracle.installer.invPtrLoc to /tmp/deinstall2024-11-28_03-26-26PM/oraInst.loc
Setting oracle.installer.local to true

## [END] Preparing for Deinstall ##

Setting the force flag to false
Setting the force flag to cleanup the Oracle Base
Oracle Universal Installer clean START

Detach Oracle home '/opt/app/oracle/product/19c/db_1' from the central inventory on the local node : Done

Delete directory '/opt/app/oracle/product/19c/db_1' on the local node : Done

The Oracle Base directory '/opt/app/oracle' will not be removed on local node. The directory is in use by Oracle Home '/opt/app/19c/grid'.

Oracle Universal Installer cleanup was successful.

Oracle Universal Installer clean END


## [START] Oracle install clean ##


## [END] Oracle install clean ##


######################### DEINSTALL CLEAN OPERATION END #########################


####################### DEINSTALL CLEAN OPERATION SUMMARY #######################
Successfully detached Oracle home '/opt/app/oracle/product/19c/db_1' from the central inventory on the local node.
Successfully deleted directory '/opt/app/oracle/product/19c/db_1' on the local node.
Oracle Universal Installer cleanup was successful.

Review the permissions and contents of '/opt/app/oracle' on nodes(s) 'pdb3'.
If there are no Oracle home(s) associated with '/opt/app/oracle', manually delete '/opt/app/oracle' and its contents.
Oracle deinstall tool successfully cleaned up temporary directories.
#######################################################################


############# ORACLE DEINSTALL TOOL END #############
*/

-- Step 04.02 -->> On Node 3 (Deinstall Oracle Database Home - Verification)
[oracle@pdb3 ~]$ ps -ef | grep pmon
/*
grid      271588       1  0 Nov25 ?        00:00:32 asm_pmon_+ASM3
oracle   2774600 2755814  0 15:31 pts/0    00:00:00 grep --color=auto pmon
*/

-- Step 05 -->> On Node 3 (Deinstall Grid Infrastructure Home)
[root@pdb3 ~]# su - grid
[grid@pdb3 ~]$ echo $GRID_HOME
/*
/opt/app/19c/grid
*/

-- Step 05.01 -->> On Node 3 (Deinstall Grid Infrastructure Home)
[grid@pdb3 ~]$ cd /opt/app/19c/grid/
[grid@pdb3 grid]$ cd deinstall/
[grid@pdb3 deinstall]$ ./deinstall -local
/*
Checking for required files and bootstrapping ...
Please wait ...
Location of logs /tmp/deinstall2024-11-28_03-34-58PM/logs/

############ ORACLE DECONFIG TOOL START ############


######################### DECONFIG CHECK OPERATION START #########################
## [START] Install check configuration ##


Checking for existence of the Oracle home location /opt/app/19c/grid
Oracle Home type selected for deinstall is: Oracle Grid Infrastructure for a Cluster
Oracle Base selected for deinstall is: /opt/app/oracle
Checking for existence of central inventory location /opt/app/oraInventory
Checking for existence of the Oracle Grid Infrastructure home /opt/app/19c/grid
The following nodes are part of this cluster: pdb3,pdb2,pdb1
Checking for sufficient temp space availability on node(s) : 'pdb3'

## [END] Install check configuration ##

Traces log file: /tmp/deinstall2024-11-28_03-34-58PM/logs//crsdc_2024-11-28_03-35-32-PM.log

Network Configuration check config START

Network de-configuration trace file location: /tmp/deinstall2024-11-28_03-34-58PM/logs/netdc_check2024-11-28_03-35-32PM.log

Network Configuration check config END

Asm Check Configuration START

ASM de-configuration trace file location: /tmp/deinstall2024-11-28_03-34-58PM/logs/asmcadc_check2024-11-28_03-35-32PM.log

Database Check Configuration START

Database de-configuration trace file location: /tmp/deinstall2024-11-28_03-34-58PM/logs/databasedc_check2024-11-28_03-35-32PM.log

Oracle Grid Management database was not found in this Grid Infrastructure home

Database Check Configuration END

######################### DECONFIG CHECK OPERATION END #########################


####################### DECONFIG CHECK OPERATION SUMMARY #######################
Oracle Grid Infrastructure Home is: /opt/app/19c/grid
The following nodes are part of this cluster: pdb3,pdb2,pdb1
The cluster node(s) on which the Oracle home deinstallation will be performed are:pdb3
Oracle Home selected for deinstall is: /opt/app/19c/grid
Inventory Location where the Oracle home registered is: /opt/app/oraInventory
Option -local will not modify any ASM configuration.
Oracle Grid Management database was not found in this Grid Infrastructure home
Do you want to continue (y - yes, n - no)? [n]: y
A log of this session will be written to: '/tmp/deinstall2024-11-28_03-34-58PM/logs/deinstall_deconfig2024-11-28_03-35-29-PM.out'
Any error messages from this session will be written to: '/tmp/deinstall2024-11-28_03-34-58PM/logs/deinstall_deconfig2024-11-28_03-35-29-PM.err'

######################## DECONFIG CLEAN OPERATION START ########################
Database de-configuration trace file location: /tmp/deinstall2024-11-28_03-34-58PM/logs/databasedc_clean2024-11-28_03-35-32PM.log
ASM de-configuration trace file location: /tmp/deinstall2024-11-28_03-34-58PM/logs/asmcadc_clean2024-11-28_03-35-32PM.log
ASM Clean Configuration END

Network Configuration clean config START

Network de-configuration trace file location: /tmp/deinstall2024-11-28_03-34-58PM/logs/netdc_clean2024-11-28_03-35-32PM.log

Network Configuration clean config END


Run the following command as the root user or the administrator on node "pdb3".

/opt/app/19c/grid/crs/install/rootcrs.sh -force  -deconfig -paramfile "/tmp/deinstall2024-11-28_03-34-58PM/response/deinstall_OraGI19Home1.rsp"

Press Enter after you finish running the above commands

<----------------------------------------
*/

-- Step 05.01.01 -->> On Node 3 (Deinstall Grid Infrastructure Home - Use another terminal)
[root@pdb3 ~]# sh /opt/app/19c/grid/crs/install/rootcrs.sh -force  -deconfig -paramfile "/tmp/deinstall2024-11-28_03-34-58PM/response/deinstall_OraGI19Home1.rsp"
/*
Smartmatch is deprecated at /opt/app/19c/grid/crs/install/crsupgrade.pm line 6512.
Using configuration parameter file: /tmp/deinstall2024-11-28_03-34-58PM/response/deinstall_OraGI19Home1.rsp
The log of current session can be found at:
  /tmp/deinstall2024-11-28_03-34-58PM/logs/crsdeconfig_pdb3_2024-11-28_03-36-25PM.log
Redirecting to /bin/systemctl restart rsyslog.service
2024/11/28 15:38:12 CLSRSC-4006: Removing Oracle Trace File Analyzer (TFA) Collector.
2024/11/28 15:39:43 CLSRSC-4007: Successfully removed Oracle Trace File Analyzer (TFA) Collector.
2024/11/28 15:39:53 CLSRSC-336: Successfully deconfigured Oracle Clusterware stack on this node
*/

-- Step 05.01.02 -->> On Node 3 (Deinstall Grid Infrastructure Home - Use another terminal)
[root@pdb3 ~]# tail -f /tmp/deinstall2024-11-28_03-34-58PM/logs/crsdeconfig_pdb3_2024-11-28_03-36-25PM.log
/*
2024-11-28 15:39:58: /bin/su successfully executed

2024-11-28 15:39:58: FALSE

2024-11-28 15:39:58: Output: FALSE

2024-11-28 15:39:58: The path [/opt/app/oracle/crsdata] is not shared
2024-11-28 15:39:58: Attempt to remove the node specific dir '/opt/app/oracle/crsdata'
2024-11-28 15:39:58: Remove /opt/app/oracle/crsdata
2024-11-28 15:39:58: deinstall or deconfig cleanup completed successfully
*/

-- Step 05.02 -->> On Node 3 (Deinstall Grid Infrastructure Home - Continue with running terminal)
[grid@pdb3 deinstall]$
/*
/opt/app/19c/grid/crs/install/rootcrs.sh -force  -deconfig -paramfile "/tmp/deinstall2024-11-28_03-34-58PM/response/deinstall_OraGI19Home1.rsp"

Press Enter after you finish running the above commands

<---------------------------------------- <<= Press Enter


######################### DECONFIG CLEAN OPERATION END #########################


####################### DECONFIG CLEAN OPERATION SUMMARY #######################
There is no Oracle Grid Management database to de-configure in this Grid Infrastructure home
Oracle Clusterware is stopped and successfully de-configured on node "pdb3"
Oracle Clusterware is stopped and de-configured successfully.
#######################################################################


############# ORACLE DECONFIG TOOL END #############

Using properties file /tmp/deinstall2024-11-28_03-34-58PM/response/deinstall_2024-11-28_03-35-29-PM.rsp
Location of logs /tmp/deinstall2024-11-28_03-34-58PM/logs/

############ ORACLE DEINSTALL TOOL START ############


####################### DEINSTALL CHECK OPERATION SUMMARY #######################
A log of this session will be written to: '/tmp/deinstall2024-11-28_03-34-58PM/logs/deinstall_deconfig2024-11-28_03-35-29-PM.out'
Any error messages from this session will be written to: '/tmp/deinstall2024-11-28_03-34-58PM/logs/deinstall_deconfig2024-11-28_03-35-29-PM.err'

######################## DEINSTALL CLEAN OPERATION START ########################
## [START] Preparing for Deinstall ##
Setting LOCAL_NODE to pdb3
Setting CLUSTER_NODES to pdb3
Setting CRS_HOME to true
Setting oracle.installer.invPtrLoc to /tmp/deinstall2024-11-28_03-34-58PM/oraInst.loc
Setting oracle.installer.local to true

## [END] Preparing for Deinstall ##

Setting the force flag to false
Setting the force flag to cleanup the Oracle Base
Oracle Universal Installer clean START

Detach Oracle home '/opt/app/19c/grid' from the central inventory on the local node : Done

Delete directory '/opt/app/19c/grid' on the local node : Done

Delete directory '/opt/app/oraInventory' on the local node : Done

Delete directory '/opt/app/oracle' on the local node : Done

Oracle Universal Installer cleanup was successful.

Oracle Universal Installer clean END


## [START] Oracle install clean ##


## [END] Oracle install clean ##


######################### DEINSTALL CLEAN OPERATION END #########################


####################### DEINSTALL CLEAN OPERATION SUMMARY #######################
Successfully detached Oracle home '/opt/app/19c/grid' from the central inventory on the local node.
Successfully deleted directory '/opt/app/19c/grid' on the local node.
Successfully deleted directory '/opt/app/oraInventory' on the local node.
Successfully deleted directory '/opt/app/oracle' on the local node.
Oracle Universal Installer cleanup was successful.


Run 'rm -r /etc/oraInst.loc' as root on node(s) 'pdb3' at the end of the session.

Run 'rm -r /opt/ORCLfmap' as root on node(s) 'pdb3' at the end of the session.
Oracle deinstall tool successfully cleaned up temporary directories.
#######################################################################


############# ORACLE DEINSTALL TOOL END #############
*/

-- Step 05.03 -->> On Node 3 (Deinstall Grid Infrastructure Home - Remove file and directories)
[root@pdb3 ~]# rm -rf /opt/app/oracle
[root@pdb3 ~]# rm -rf /etc/oraInst.loc
[root@pdb3 ~]# rm -rf /opt/ORCLfmap

-- Step 05.04 -->> On Node 3 (Deinstall Grid Infrastructure Home - Verification)
[root@pdb3 ~]# ps -ef | grep pmon
/*
root     2798852 2745266  0 15:48 pts/0    00:00:00 grep --color=auto pmon
*/

-- Step 06 -->> On Node 1 (Remove the node from the cluster configuration)
[root@pdb1 ~]# cd /opt/app/19c/grid/bin/
[root@pdb1 bin]# ./crsctl delete node -n pdb3
/*
CRS-4661: Node pdb3 successfully deleted.
*/

-- Step 07 -->> On Node 1 (Update Configuration for remmaning nodes using grid user)
[grid@pdb1 ~]$ echo $GRID_HOME
/*
/opt/app/19c/grid
*/

-- Step 07.01 -->> On Node 1 (Update Configuration for remmaning nodes using grid user)
[grid@pdb1 ~]$ echo $ORACLE_HOME
/*
/opt/app/19c/grid
*/

-- Step 07.02 -->> On Node 1 (Update Configuration for remmaning nodes using grid user)
[grid@pdb1 ~]$ $GRID_HOME/oui/bin/runInstaller -updateNodeList ORACLE_HOME=$ORACLE_HOME cluster_nodes={pdb1,pdb2} CRS=TRUE -silent
/*
Starting Oracle Universal Installer...

Checking swap space: must be greater than 500 MB.   Actual 16226 MB    Passed
The inventory pointer is located at /etc/oraInst.loc
You can find the log of this install session at:
 /opt/app/oraInventory/logs/UpdateNodeList2024-11-28_03-54-51PM.log
'UpdateNodeList' was successful.
*/

-- Step 07.03 -->> On Node 1 (Update Configuration for remmaning nodes using grid user)
[grid@pdb1 ~]$ tail -f /opt/app/oraInventory/logs/UpdateNodeList2024-11-28_03-54-51PM.log
/*
INFO: New thread started for node : pdb2
INFO: Running command '/opt/app/19c/grid/oui/bin/runInstaller  -paramFile /opt/app/19c/grid/oui/clusterparam.ini  -silent -ignoreSysPrereqs -updateNodeList -noClusterEnabled ORACLE_HOME=/opt/app/19c/grid "CLUSTER_NODES={pdb2}" CRS=true  LOCAL_NODE=pdb2 -remoteInvocation -invokingNodeName pdb1 -logFilePath "/opt/app/oraInventory/logs" -timestamp 2024-11-28_03-54-51PM' on the nodes 'pdb2'.
INFO: Invoking OUI on cluster nodes pdb2
INFO: /opt/app/19c/grid/oui/bin/runInstaller  -paramFile /opt/app/19c/grid/oui/clusterparam.ini  -silent -ignoreSysPrereqs -updateNodeList -noClusterEnabled ORACLE_HOME=/opt/app/19c/grid "CLUSTER_NODES={pdb2}" CRS=true  LOCAL_NODE=pdb2 -remoteInvocation -invokingNodeName pdb1 -logFilePath "/opt/app/oraInventory/logs" -timestamp 2024-11-28_03-54-51PM
INFO: Command execution completes for node : pdb2
INFO: Command execution sucess for node : pdb2
INFO: All threads completed its operations
INFO: Checkpoint:Index file written and updated
INFO: Done calling doOperation.
INFO: 'UpdateNodeList' was successful.
*/

-- Step 08 -->> On Node 1 (Update Configuration for remmaning nodes using oracle user)
[oracle@pdb1 ~]$ echo $ORACLE_HOME
/*
/opt/app/oracle/product/19c/db_1
*/

-- Step 08.01 -->> On Node 1 (Update Configuration for remmaning nodes using oracle user)
[oracle@pdb1 ~]$ $ORACLE_HOME/oui/bin/runInstaller -updateNodeList ORACLE_HOME=$ORACLE_HOME cluster_nodes={pdb1,pdb2} CRS=TRUE -silent
/*
Starting Oracle Universal Installer...

Checking swap space: must be greater than 500 MB.   Actual 16226 MB    Passed
The inventory pointer is located at /etc/oraInst.loc
You can find the log of this install session at:
 /opt/app/oraInventory/logs/UpdateNodeList2024-11-28_03-58-01PM.log
'UpdateNodeList' was successful.
*/

-- Step 08.02 -->> On Node 1 (Update Configuration for remmaning nodes using oracle user)
[oracle@pdb1 ~]$ tail -f /opt/app/oraInventory/logs/UpdateNodeList2024-11-28_03-58-01PM.log
/*
INFO: New thread started for node : pdb2
INFO: Running command '/opt/app/oracle/product/19c/db_1/oui/bin/runInstaller  -paramFile /opt/app/oracle/product/19c/db_1/oui/clusterparam.ini  -silent -ignoreSysPrereqs -updateNodeList -noClusterEnabled ORACLE_HOME=/opt/app/oracle/product/19c/db_1 "CLUSTER_NODES={pdb2}" CRS=true  LOCAL_NODE=pdb2 -remoteInvocation -invokingNodeName pdb1 -logFilePath "/opt/app/oraInventory/logs" -timestamp 2024-11-28_03-58-01PM' on the nodes 'pdb2'.
INFO: Invoking OUI on cluster nodes pdb2
INFO: /opt/app/oracle/product/19c/db_1/oui/bin/runInstaller  -paramFile /opt/app/oracle/product/19c/db_1/oui/clusterparam.ini  -silent -ignoreSysPrereqs -updateNodeList -noClusterEnabled ORACLE_HOME=/opt/app/oracle/product/19c/db_1 "CLUSTER_NODES={pdb2}" CRS=true  LOCAL_NODE=pdb2 -remoteInvocation -invokingNodeName pdb1 -logFilePath "/opt/app/oraInventory/logs" -timestamp 2024-11-28_03-58-01PM
INFO: Command execution completes for node : pdb2
INFO: Command execution sucess for node : pdb2
INFO: All threads completed its operations
INFO: Checkpoint:Index file written and updated
INFO: Done calling doOperation.
INFO: 'UpdateNodeList' was successful.
*/

-- Step 09 -->> On Node 1 (Verify the node has been successfully removed for grid user)
[grid@pdb1 ~]$ which cluvfy
/*
/opt/app/19c/grid/bin/cluvfy
*/

-- Step 09.01 -->> On Node 1 (Verify the node has been successfully removed for grid user)
[grid@pdb1 ~]$ export CV_ASSUME_DISTID=OEL7.6
[grid@pdb1 ~]$ cluvfy stage -post nodedel -n pdb3 -verbose
/*
This software is "245" days old. It is a best practice to update the CRS home by downloading and applying the latest release update. Refer to MOS note 756671.1 for more details.

Performing following verification checks ...

  Node Removal ...
    CRS Integrity ...PASSED
    Clusterware Version Consistency ...PASSED
  Node Removal ...PASSED

Post-check for node removal was successful.

CVU operation performed:      stage -post nodedel
Date:                         Nov 28, 2024 4:00:46 PM
CVU version:                  19.23.0.0.0 (032824x8664)
Clusterware version:          19.0.0.0.0
CVU home:                     /opt/app/19c/grid
Grid home:                    /opt/app/19c/grid
User:                         grid
Operating system:             Linux5.4.17-2136.335.4.el8uek.x86_64
*/

-- Step 09.02 -->> On Node 1 (Verify the node has been successfully removed for grid user)
[grid@pdb1 ~]$ olsnodes -n -s -t
/*
pdb1    1       Active  Unpinned
pdb2    2       Active  Unpinned
*/

-- Step 10 -->> On Node 1 (Verify the node has been successfully removed for oracle user)
[oracle@pdb1 ~]$ which cluvfy
/*
/opt/app/oracle/product/19c/db_1/bin/cluvfy
*/

-- Step 10.01 -->> On Node 1 (Verify the node has been successfully removed for oracle user)
[oracle@pdb1 ~]$ export CV_ASSUME_DISTID=OEL7.6
[oracle@pdb1 ~]$ cluvfy stage -post nodedel -n pdb3 -verbose
/*
This software is "245" days old. It is a best practice to update the CRS home by downloading and applying the latest release update. Refer to MOS note 756671.1 for more details.

Performing following verification checks ...

  Node Removal ...
    CRS Integrity ...PASSED
    Clusterware Version Consistency ...PASSED
  Node Removal ...PASSED

Post-check for node removal was successful.

CVU operation performed:      stage -post nodedel
Date:                         Nov 28, 2024 4:01:45 PM
CVU version:                  19.23.0.0.0 (032824x8664)
Clusterware version:          19.0.0.0.0
CVU home:                     /opt/app/19c/grid
Grid home:                    /opt/app/19c/grid
User:                         oracle
Operating system:             Linux5.4.17-2136.335.4.el8uek.x86_64
*/

-- Step 11 -->> On All Nodes (De-Configure)
[root@pdb1/pdb2 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.160.6.21   pdb1.unidev.org.np        pdb1
192.160.6.22   pdb2.unidev.org.np        pdb2

# Private
10.10.10.21   pdb1-priv.unidev.org.np   pdb1-priv
10.10.10.22   pdb2-priv.unidev.org.np   pdb2-priv

# Virtual
192.160.6.23   pdb1-vip.unidev.org.np    pdb1-vip
192.160.6.24   pdb2-vip.unidev.org.np    pdb2-vip

# SCAN
192.160.6.25   pdb-scan.unidev.org.np    pdb-scan
192.160.6.26   pdb-scan.unidev.org.np    pdb-scan
192.160.6.27   pdb-scan.unidev.org.np    pdb-scan
*/

-- Step 12 -->> On Node 1 (DC - Remove added log files)
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Thu Nov 28 16:11:42 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

-- Step 12.01 -->> On Node 1 (DC - Remove added log files)
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE

-- Step 12.02 -->> On Node 1 (DC - Remove added log files)
SQL> set lines 999 pages 999
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
         4          2   52428800
         5          1   52428800
         5          1   52428800
         6          2   52428800
         6          2   52428800

12 rows selected.

-- Step 12.03 -->> On Node 1 (DC - Remove added log files)
SQL> col member for a50
SQL> SELECT b.thread#,a.group#, a.type, a.member, b.bytes FROM gv$logfile a, gv$standby_log b WHERE a.group# = b.group# ORDER BY 2,4;

   THREAD#     GROUP# TYPE    MEMBER                                                            BYTES
---------- ---------- ------- ------------------------------------------------------------ ----------
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.262.1181481203                   52428800
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.262.1181481203                   52428800
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.262.1181481203                   52428800
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.262.1181481203                   52428800
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.263.1181481203                   52428800
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.263.1181481203                   52428800
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.263.1181481203                   52428800
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.263.1181481203                   52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.270.1181481205                   52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.270.1181481205                   52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.270.1181481205                   52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.270.1181481205                   52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.271.1181481203                   52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.271.1181481203                   52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.271.1181481203                   52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.271.1181481203                   52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.292.1181481205                   52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.292.1181481205                   52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.292.1181481205                   52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.292.1181481205                   52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.293.1181481205                   52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.293.1181481205                   52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.293.1181481205                   52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.293.1181481205                   52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.294.1181481205                  52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.294.1181481205                  52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.294.1181481205                  52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.294.1181481205                  52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.295.1181481205                  52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.295.1181481205                  52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.295.1181481205                  52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.295.1181481205                  52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.296.1181481205                  52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.296.1181481205                  52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.296.1181481205                  52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.296.1181481205                  52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.297.1181481205                  52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.297.1181481205                  52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.297.1181481205                  52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.297.1181481205                  52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.298.1181481205                  52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.298.1181481205                  52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.298.1181481205                  52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.298.1181481205                  52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.299.1181481207                  52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.299.1181481207                  52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.299.1181481207                  52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.299.1181481207                  52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.300.1181481207                  52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.300.1181481207                  52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.300.1181481207                  52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.300.1181481207                  52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.301.1181481207                  52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.301.1181481207                  52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.301.1181481207                  52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.301.1181481207                  52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.302.1181481207                  52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.302.1181481207                  52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.302.1181481207                  52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.302.1181481207                  52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.303.1181481207                  52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.303.1181481207                  52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.303.1181481207                  52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.303.1181481207                  52428800
         3         18 STANDBY +DATA/PDBDB/ONLINELOG/group_18.312.1185975713                  52428800
         3         18 STANDBY +DATA/PDBDB/ONLINELOG/group_18.312.1185975713                  52428800
         3         18 STANDBY +DATA/PDBDB/ONLINELOG/group_18.312.1185975713                  52428800
         3         18 STANDBY +DATA/PDBDB/ONLINELOG/group_18.312.1185975713                  52428800
         3         18 STANDBY +DATA/PDBDB/ONLINELOG/group_18.313.1185975713                  52428800
         3         18 STANDBY +DATA/PDBDB/ONLINELOG/group_18.313.1185975713                  52428800
         3         18 STANDBY +DATA/PDBDB/ONLINELOG/group_18.313.1185975713                  52428800
         3         18 STANDBY +DATA/PDBDB/ONLINELOG/group_18.313.1185975713                  52428800
         3         19 STANDBY +DATA/PDBDB/ONLINELOG/group_19.314.1185975719                  52428800
         3         19 STANDBY +DATA/PDBDB/ONLINELOG/group_19.314.1185975719                  52428800
         3         19 STANDBY +DATA/PDBDB/ONLINELOG/group_19.314.1185975719                  52428800
         3         19 STANDBY +DATA/PDBDB/ONLINELOG/group_19.314.1185975719                  52428800
         3         19 STANDBY +DATA/PDBDB/ONLINELOG/group_19.315.1185975719                  52428800
         3         19 STANDBY +DATA/PDBDB/ONLINELOG/group_19.315.1185975719                  52428800
         3         19 STANDBY +DATA/PDBDB/ONLINELOG/group_19.315.1185975719                  52428800
         3         19 STANDBY +DATA/PDBDB/ONLINELOG/group_19.315.1185975719                  52428800
         3         20 STANDBY +DATA/PDBDB/ONLINELOG/group_20.316.1185975723                  52428800
         3         20 STANDBY +DATA/PDBDB/ONLINELOG/group_20.316.1185975723                  52428800
         3         20 STANDBY +DATA/PDBDB/ONLINELOG/group_20.316.1185975723                  52428800
         3         20 STANDBY +DATA/PDBDB/ONLINELOG/group_20.316.1185975723                  52428800
         3         20 STANDBY +DATA/PDBDB/ONLINELOG/group_20.317.1185975723                  52428800
         3         20 STANDBY +DATA/PDBDB/ONLINELOG/group_20.317.1185975723                  52428800
         3         20 STANDBY +DATA/PDBDB/ONLINELOG/group_20.317.1185975723                  52428800
         3         20 STANDBY +DATA/PDBDB/ONLINELOG/group_20.317.1185975723                  52428800
         3         21 STANDBY +DATA/PDBDB/ONLINELOG/group_21.318.1185975727                  52428800
         3         21 STANDBY +DATA/PDBDB/ONLINELOG/group_21.318.1185975727                  52428800
         3         21 STANDBY +DATA/PDBDB/ONLINELOG/group_21.318.1185975727                  52428800
         3         21 STANDBY +DATA/PDBDB/ONLINELOG/group_21.318.1185975727                  52428800
         3         21 STANDBY +DATA/PDBDB/ONLINELOG/group_21.319.1185975729                  52428800
         3         21 STANDBY +DATA/PDBDB/ONLINELOG/group_21.319.1185975729                  52428800
         3         21 STANDBY +DATA/PDBDB/ONLINELOG/group_21.319.1185975729                  52428800
         3         21 STANDBY +DATA/PDBDB/ONLINELOG/group_21.319.1185975729                  52428800

-- Step 12.04 -->> On Node 1 (DC - Remove added log files)
SQL> alter database drop standby logfile group 18;
SQL> alter database drop standby logfile group 19;
SQL> alter database drop standby logfile group 20;
SQL> alter database drop standby logfile group 21;

-- Step 12.05 -->> On Node 1 (DC - Remove added log files)
SQL> col member for a50
SQL> SELECT b.thread#,a.group#, a.type, a.member, b.bytes FROM gv$logfile a, gv$standby_log b WHERE a.group# = b.group# ORDER BY 2,4;

   THREAD#     GROUP# TYPE    MEMBER                                                            BYTES
---------- ---------- ------- ------------------------------------------------------------ ----------
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.262.1181481203                   52428800
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.262.1181481203                   52428800
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.262.1181481203                   52428800
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.262.1181481203                   52428800
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.263.1181481203                   52428800
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.263.1181481203                   52428800
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.263.1181481203                   52428800
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.263.1181481203                   52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.270.1181481205                   52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.270.1181481205                   52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.270.1181481205                   52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.270.1181481205                   52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.271.1181481203                   52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.271.1181481203                   52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.271.1181481203                   52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.271.1181481203                   52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.292.1181481205                   52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.292.1181481205                   52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.292.1181481205                   52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.292.1181481205                   52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.293.1181481205                   52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.293.1181481205                   52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.293.1181481205                   52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.293.1181481205                   52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.294.1181481205                  52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.294.1181481205                  52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.294.1181481205                  52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.294.1181481205                  52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.295.1181481205                  52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.295.1181481205                  52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.295.1181481205                  52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.295.1181481205                  52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.296.1181481205                  52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.296.1181481205                  52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.296.1181481205                  52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.296.1181481205                  52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.297.1181481205                  52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.297.1181481205                  52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.297.1181481205                  52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.297.1181481205                  52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.298.1181481205                  52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.298.1181481205                  52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.298.1181481205                  52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.298.1181481205                  52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.299.1181481207                  52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.299.1181481207                  52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.299.1181481207                  52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.299.1181481207                  52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.300.1181481207                  52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.300.1181481207                  52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.300.1181481207                  52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.300.1181481207                  52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.301.1181481207                  52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.301.1181481207                  52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.301.1181481207                  52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.301.1181481207                  52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.302.1181481207                  52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.302.1181481207                  52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.302.1181481207                  52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.302.1181481207                  52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.303.1181481207                  52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.303.1181481207                  52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.303.1181481207                  52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.303.1181481207                  52428800

64 rows selected.

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 13 -->> On Node 1 (DR - Remove added log files)
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Thu Nov 28 16:25:44 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

-- Step 13.01 -->> On Node 1 (DR - Remove added log files)
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED

-- Step 13.02 -->> On Node 1 (DR - Remove added log files)
SQL> set lines 999 pages 999
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
         4          2   52428800
         5          1   52428800
         5          1   52428800
         6          2   52428800
         6          2   52428800
        15          3  104857600
        15          3  104857600
        16          3  104857600
        16          3  104857600
        17          3   52428800
        17          3   52428800

18 rows selected.

-- Step 13.03 -->> On Node 1 (DR - Remove added log files)
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
SQL> ALTER SYSTEM SET STANDBY_FILE_MANAGEMENT=MANUAL;

-- Step 13.04 -->> On Node 1 (DR - Remove added log files)
SQL> alter database drop logfile group 15;
SQL> alter database drop logfile group 16;
SQL> alter database drop logfile group 17;

-- Step 13.05 -->> On Node 1 (DR - Remove added log files)
SQL> set lines 999 pages 999
SQL>  SELECT group#,thread#,bytes FROM gv$log order by 1,2;

    GROUP#    THREAD#      BYTES
---------- ---------- ----------
         1          1   52428800
         1          1   52428800
         2          1   52428800
         2          1   52428800
         3          2   52428800
         3          2   52428800
         4          2   52428800
         4          2   52428800
         5          1   52428800
         5          1   52428800
         6          2   52428800
         6          2   52428800

12 rows selected.

-- Step 13.06 -->> On Node 1 (DR - Remove added log files)
SQL> col member for a50
SQL> SELECT b.thread#,a.group#, a.type, a.member, b.bytes FROM gv$logfile a, gv$standby_log b WHERE a.group# = b.group# ORDER BY 2,4;

   THREAD#     GROUP# TYPE    MEMBER                                                  BYTES
---------- ---------- ------- -------------------------------------------------- ----------
         1          7 STANDBY +ARC/DR/ONLINELOG/group_7.264.1181668201             52428800
         1          7 STANDBY +ARC/DR/ONLINELOG/group_7.264.1181668201             52428800
         1          7 STANDBY +ARC/DR/ONLINELOG/group_7.264.1181668201             52428800
         1          7 STANDBY +ARC/DR/ONLINELOG/group_7.264.1181668201             52428800
         1          7 STANDBY +DATA/DR/ONLINELOG/group_7.278.1181668201            52428800
         1          7 STANDBY +DATA/DR/ONLINELOG/group_7.278.1181668201            52428800
         1          7 STANDBY +DATA/DR/ONLINELOG/group_7.278.1181668201            52428800
         1          7 STANDBY +DATA/DR/ONLINELOG/group_7.278.1181668201            52428800
         1          8 STANDBY +ARC/DR/ONLINELOG/group_8.265.1181668201             52428800
         1          8 STANDBY +ARC/DR/ONLINELOG/group_8.265.1181668201             52428800
         1          8 STANDBY +ARC/DR/ONLINELOG/group_8.265.1181668201             52428800
         1          8 STANDBY +ARC/DR/ONLINELOG/group_8.265.1181668201             52428800
         1          8 STANDBY +DATA/DR/ONLINELOG/group_8.279.1181668201            52428800
         1          8 STANDBY +DATA/DR/ONLINELOG/group_8.279.1181668201            52428800
         1          8 STANDBY +DATA/DR/ONLINELOG/group_8.279.1181668201            52428800
         1          8 STANDBY +DATA/DR/ONLINELOG/group_8.279.1181668201            52428800
         1          9 STANDBY +ARC/DR/ONLINELOG/group_9.266.1181668201             52428800
         1          9 STANDBY +ARC/DR/ONLINELOG/group_9.266.1181668201             52428800
         1          9 STANDBY +ARC/DR/ONLINELOG/group_9.266.1181668201             52428800
         1          9 STANDBY +ARC/DR/ONLINELOG/group_9.266.1181668201             52428800
         1          9 STANDBY +DATA/DR/ONLINELOG/group_9.280.1181668201            52428800
         1          9 STANDBY +DATA/DR/ONLINELOG/group_9.280.1181668201            52428800
         1          9 STANDBY +DATA/DR/ONLINELOG/group_9.280.1181668201            52428800
         1          9 STANDBY +DATA/DR/ONLINELOG/group_9.280.1181668201            52428800
         1         10 STANDBY +ARC/DR/ONLINELOG/group_10.267.1181668203            52428800
         1         10 STANDBY +ARC/DR/ONLINELOG/group_10.267.1181668203            52428800
         1         10 STANDBY +ARC/DR/ONLINELOG/group_10.267.1181668203            52428800
         1         10 STANDBY +ARC/DR/ONLINELOG/group_10.267.1181668203            52428800
         1         10 STANDBY +DATA/DR/ONLINELOG/group_10.281.1181668201           52428800
         1         10 STANDBY +DATA/DR/ONLINELOG/group_10.281.1181668201           52428800
         1         10 STANDBY +DATA/DR/ONLINELOG/group_10.281.1181668201           52428800
         1         10 STANDBY +DATA/DR/ONLINELOG/group_10.281.1181668201           52428800
         2         11 STANDBY +ARC/DR/ONLINELOG/group_11.268.1181668203            52428800
         2         11 STANDBY +ARC/DR/ONLINELOG/group_11.268.1181668203            52428800
         2         11 STANDBY +ARC/DR/ONLINELOG/group_11.268.1181668203            52428800
         2         11 STANDBY +ARC/DR/ONLINELOG/group_11.268.1181668203            52428800
         2         11 STANDBY +DATA/DR/ONLINELOG/group_11.282.1181668203           52428800
         2         11 STANDBY +DATA/DR/ONLINELOG/group_11.282.1181668203           52428800
         2         11 STANDBY +DATA/DR/ONLINELOG/group_11.282.1181668203           52428800
         2         11 STANDBY +DATA/DR/ONLINELOG/group_11.282.1181668203           52428800
         2         12 STANDBY +ARC/DR/ONLINELOG/group_12.269.1181668203            52428800
         2         12 STANDBY +ARC/DR/ONLINELOG/group_12.269.1181668203            52428800
         2         12 STANDBY +ARC/DR/ONLINELOG/group_12.269.1181668203            52428800
         2         12 STANDBY +ARC/DR/ONLINELOG/group_12.269.1181668203            52428800
         2         12 STANDBY +DATA/DR/ONLINELOG/group_12.283.1181668203           52428800
         2         12 STANDBY +DATA/DR/ONLINELOG/group_12.283.1181668203           52428800
         2         12 STANDBY +DATA/DR/ONLINELOG/group_12.283.1181668203           52428800
         2         12 STANDBY +DATA/DR/ONLINELOG/group_12.283.1181668203           52428800
         2         13 STANDBY +ARC/DR/ONLINELOG/group_13.270.1181668203            52428800
         2         13 STANDBY +ARC/DR/ONLINELOG/group_13.270.1181668203            52428800
         2         13 STANDBY +ARC/DR/ONLINELOG/group_13.270.1181668203            52428800
         2         13 STANDBY +ARC/DR/ONLINELOG/group_13.270.1181668203            52428800
         2         13 STANDBY +DATA/DR/ONLINELOG/group_13.284.1181668203           52428800
         2         13 STANDBY +DATA/DR/ONLINELOG/group_13.284.1181668203           52428800
         2         13 STANDBY +DATA/DR/ONLINELOG/group_13.284.1181668203           52428800
         2         13 STANDBY +DATA/DR/ONLINELOG/group_13.284.1181668203           52428800
         2         14 STANDBY +ARC/DR/ONLINELOG/group_14.271.1181668205            52428800
         2         14 STANDBY +ARC/DR/ONLINELOG/group_14.271.1181668205            52428800
         2         14 STANDBY +ARC/DR/ONLINELOG/group_14.271.1181668205            52428800
         2         14 STANDBY +ARC/DR/ONLINELOG/group_14.271.1181668205            52428800
         2         14 STANDBY +DATA/DR/ONLINELOG/group_14.285.1181668205           52428800
         2         14 STANDBY +DATA/DR/ONLINELOG/group_14.285.1181668205           52428800
         2         14 STANDBY +DATA/DR/ONLINELOG/group_14.285.1181668205           52428800
         2         14 STANDBY +DATA/DR/ONLINELOG/group_14.285.1181668205           52428800
         3         18 STANDBY +DATA/DR/ONLINELOG/group_18.297.1185982215           52428800
         3         18 STANDBY +DATA/DR/ONLINELOG/group_18.297.1185982215           52428800
         3         18 STANDBY +DATA/DR/ONLINELOG/group_18.297.1185982215           52428800
         3         18 STANDBY +DATA/DR/ONLINELOG/group_18.297.1185982215           52428800
         3         18 STANDBY +DATA/DR/ONLINELOG/group_18.298.1185982215           52428800
         3         18 STANDBY +DATA/DR/ONLINELOG/group_18.298.1185982215           52428800
         3         18 STANDBY +DATA/DR/ONLINELOG/group_18.298.1185982215           52428800
         3         18 STANDBY +DATA/DR/ONLINELOG/group_18.298.1185982215           52428800
         3         19 STANDBY +DATA/DR/ONLINELOG/group_19.299.1185982219           52428800
         3         19 STANDBY +DATA/DR/ONLINELOG/group_19.299.1185982219           52428800
         3         19 STANDBY +DATA/DR/ONLINELOG/group_19.299.1185982219           52428800
         3         19 STANDBY +DATA/DR/ONLINELOG/group_19.299.1185982219           52428800
         3         19 STANDBY +DATA/DR/ONLINELOG/group_19.300.1185982219           52428800
         3         19 STANDBY +DATA/DR/ONLINELOG/group_19.300.1185982219           52428800
         3         19 STANDBY +DATA/DR/ONLINELOG/group_19.300.1185982219           52428800
         3         19 STANDBY +DATA/DR/ONLINELOG/group_19.300.1185982219           52428800
         3         20 STANDBY +DATA/DR/ONLINELOG/group_20.301.1185982225           52428800
         3         20 STANDBY +DATA/DR/ONLINELOG/group_20.301.1185982225           52428800
         3         20 STANDBY +DATA/DR/ONLINELOG/group_20.301.1185982225           52428800
         3         20 STANDBY +DATA/DR/ONLINELOG/group_20.301.1185982225           52428800
         3         20 STANDBY +DATA/DR/ONLINELOG/group_20.302.1185982225           52428800
         3         20 STANDBY +DATA/DR/ONLINELOG/group_20.302.1185982225           52428800
         3         20 STANDBY +DATA/DR/ONLINELOG/group_20.302.1185982225           52428800
         3         20 STANDBY +DATA/DR/ONLINELOG/group_20.302.1185982225           52428800
         3         21 STANDBY +DATA/DR/ONLINELOG/group_21.303.1185982229           52428800
         3         21 STANDBY +DATA/DR/ONLINELOG/group_21.303.1185982229           52428800
         3         21 STANDBY +DATA/DR/ONLINELOG/group_21.303.1185982229           52428800
         3         21 STANDBY +DATA/DR/ONLINELOG/group_21.303.1185982229           52428800
         3         21 STANDBY +DATA/DR/ONLINELOG/group_21.304.1185982229           52428800
         3         21 STANDBY +DATA/DR/ONLINELOG/group_21.304.1185982229           52428800
         3         21 STANDBY +DATA/DR/ONLINELOG/group_21.304.1185982229           52428800
         3         21 STANDBY +DATA/DR/ONLINELOG/group_21.304.1185982229           52428800

96 rows selected.

-- Step 13.07 -->> On Node 1 (DR - Remove added log files)
SQL> alter database drop standby logfile group 18;
SQL> alter database drop standby logfile group 19;
SQL> alter database drop standby logfile group 20;
SQL> alter database drop standby logfile group 21;

-- Step 13.08 -->> On Node 1 (DR - Remove added log files)
SQL> col member for a50
SQL> SELECT b.thread#,a.group#, a.type, a.member, b.bytes FROM gv$logfile a, gv$standby_log b WHERE a.group# = b.group# ORDER BY 2,4;

   THREAD#     GROUP# TYPE    MEMBER                                                  BYTES
---------- ---------- ------- -------------------------------------------------- ----------
         1          7 STANDBY +ARC/DR/ONLINELOG/group_7.264.1181668201             52428800
         1          7 STANDBY +ARC/DR/ONLINELOG/group_7.264.1181668201             52428800
         1          7 STANDBY +ARC/DR/ONLINELOG/group_7.264.1181668201             52428800
         1          7 STANDBY +ARC/DR/ONLINELOG/group_7.264.1181668201             52428800
         1          7 STANDBY +DATA/DR/ONLINELOG/group_7.278.1181668201            52428800
         1          7 STANDBY +DATA/DR/ONLINELOG/group_7.278.1181668201            52428800
         1          7 STANDBY +DATA/DR/ONLINELOG/group_7.278.1181668201            52428800
         1          7 STANDBY +DATA/DR/ONLINELOG/group_7.278.1181668201            52428800
         1          8 STANDBY +ARC/DR/ONLINELOG/group_8.265.1181668201             52428800
         1          8 STANDBY +ARC/DR/ONLINELOG/group_8.265.1181668201             52428800
         1          8 STANDBY +ARC/DR/ONLINELOG/group_8.265.1181668201             52428800
         1          8 STANDBY +ARC/DR/ONLINELOG/group_8.265.1181668201             52428800
         1          8 STANDBY +DATA/DR/ONLINELOG/group_8.279.1181668201            52428800
         1          8 STANDBY +DATA/DR/ONLINELOG/group_8.279.1181668201            52428800
         1          8 STANDBY +DATA/DR/ONLINELOG/group_8.279.1181668201            52428800
         1          8 STANDBY +DATA/DR/ONLINELOG/group_8.279.1181668201            52428800
         1          9 STANDBY +ARC/DR/ONLINELOG/group_9.266.1181668201             52428800
         1          9 STANDBY +ARC/DR/ONLINELOG/group_9.266.1181668201             52428800
         1          9 STANDBY +ARC/DR/ONLINELOG/group_9.266.1181668201             52428800
         1          9 STANDBY +ARC/DR/ONLINELOG/group_9.266.1181668201             52428800
         1          9 STANDBY +DATA/DR/ONLINELOG/group_9.280.1181668201            52428800
         1          9 STANDBY +DATA/DR/ONLINELOG/group_9.280.1181668201            52428800
         1          9 STANDBY +DATA/DR/ONLINELOG/group_9.280.1181668201            52428800
         1          9 STANDBY +DATA/DR/ONLINELOG/group_9.280.1181668201            52428800
         1         10 STANDBY +ARC/DR/ONLINELOG/group_10.267.1181668203            52428800
         1         10 STANDBY +ARC/DR/ONLINELOG/group_10.267.1181668203            52428800
         1         10 STANDBY +ARC/DR/ONLINELOG/group_10.267.1181668203            52428800
         1         10 STANDBY +ARC/DR/ONLINELOG/group_10.267.1181668203            52428800
         1         10 STANDBY +DATA/DR/ONLINELOG/group_10.281.1181668201           52428800
         1         10 STANDBY +DATA/DR/ONLINELOG/group_10.281.1181668201           52428800
         1         10 STANDBY +DATA/DR/ONLINELOG/group_10.281.1181668201           52428800
         1         10 STANDBY +DATA/DR/ONLINELOG/group_10.281.1181668201           52428800
         2         11 STANDBY +ARC/DR/ONLINELOG/group_11.268.1181668203            52428800
         2         11 STANDBY +ARC/DR/ONLINELOG/group_11.268.1181668203            52428800
         2         11 STANDBY +ARC/DR/ONLINELOG/group_11.268.1181668203            52428800
         2         11 STANDBY +ARC/DR/ONLINELOG/group_11.268.1181668203            52428800
         2         11 STANDBY +DATA/DR/ONLINELOG/group_11.282.1181668203           52428800
         2         11 STANDBY +DATA/DR/ONLINELOG/group_11.282.1181668203           52428800
         2         11 STANDBY +DATA/DR/ONLINELOG/group_11.282.1181668203           52428800
         2         11 STANDBY +DATA/DR/ONLINELOG/group_11.282.1181668203           52428800
         2         12 STANDBY +ARC/DR/ONLINELOG/group_12.269.1181668203            52428800
         2         12 STANDBY +ARC/DR/ONLINELOG/group_12.269.1181668203            52428800
         2         12 STANDBY +ARC/DR/ONLINELOG/group_12.269.1181668203            52428800
         2         12 STANDBY +ARC/DR/ONLINELOG/group_12.269.1181668203            52428800
         2         12 STANDBY +DATA/DR/ONLINELOG/group_12.283.1181668203           52428800
         2         12 STANDBY +DATA/DR/ONLINELOG/group_12.283.1181668203           52428800
         2         12 STANDBY +DATA/DR/ONLINELOG/group_12.283.1181668203           52428800
         2         12 STANDBY +DATA/DR/ONLINELOG/group_12.283.1181668203           52428800
         2         13 STANDBY +ARC/DR/ONLINELOG/group_13.270.1181668203            52428800
         2         13 STANDBY +ARC/DR/ONLINELOG/group_13.270.1181668203            52428800
         2         13 STANDBY +ARC/DR/ONLINELOG/group_13.270.1181668203            52428800
         2         13 STANDBY +ARC/DR/ONLINELOG/group_13.270.1181668203            52428800
         2         13 STANDBY +DATA/DR/ONLINELOG/group_13.284.1181668203           52428800
         2         13 STANDBY +DATA/DR/ONLINELOG/group_13.284.1181668203           52428800
         2         13 STANDBY +DATA/DR/ONLINELOG/group_13.284.1181668203           52428800
         2         13 STANDBY +DATA/DR/ONLINELOG/group_13.284.1181668203           52428800
         2         14 STANDBY +ARC/DR/ONLINELOG/group_14.271.1181668205            52428800
         2         14 STANDBY +ARC/DR/ONLINELOG/group_14.271.1181668205            52428800
         2         14 STANDBY +ARC/DR/ONLINELOG/group_14.271.1181668205            52428800
         2         14 STANDBY +ARC/DR/ONLINELOG/group_14.271.1181668205            52428800
         2         14 STANDBY +DATA/DR/ONLINELOG/group_14.285.1181668205           52428800
         2         14 STANDBY +DATA/DR/ONLINELOG/group_14.285.1181668205           52428800
         2         14 STANDBY +DATA/DR/ONLINELOG/group_14.285.1181668205           52428800
         2         14 STANDBY +DATA/DR/ONLINELOG/group_14.285.1181668205           52428800

-- Step 13.09 -->> On Node 1 (DR - Remove added log files)
SQL> ALTER SYSTEM SET STANDBY_FILE_MANAGEMENT=AUTO;

-- Step 13.10 -->> On Node 1 (DR - Remove added log files)
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION INSTANCES ALL;

-- Step 13.11 -->> On Node 1 (DR - Remove added log files)
SQL> SELECT inst_id,process,thread#,sequence#,block#,status FROM gv$managed_standby;

   INST_ID PROCESS      THREAD#  SEQUENCE#     BLOCK# STATUS
---------- --------- ---------- ---------- ---------- ------------
         1 ARCH               1        773      55296 CLOSING
         1 DGRD               0          0          0 ALLOCATED
         1 DGRD               0          0          0 ALLOCATED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               1        741       6144 CLOSING
         1 ARCH               1        771      49152 CLOSING
         1 ARCH               1        753      55296 CLOSING
         1 ARCH               1        739          1 CLOSING
         1 ARCH               1        755      51200 CLOSING
         1 ARCH               1        767      57344 CLOSING
         1 ARCH               1        746          1 CLOSING
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               1        756      49152 CLOSING
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               1        743          1 CLOSING
         1 ARCH               1        769      53248 CLOSING
         1 ARCH               1        737      65536 CLOSING
         1 ARCH               1        740          1 CLOSING
         1 ARCH               1        761      49152 CLOSING
         1 ARCH               1        770      53248 CLOSING
         1 ARCH               1        775      53248 CLOSING
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               1        744          1 CLOSING
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               1        760      51200 CLOSING
         1 ARCH               1        748      51200 CLOSING
         1 ARCH               1        766      53248 CLOSING
         1 ARCH               3         71      14336 CLOSING
         1 ARCH               1        768      55296 CLOSING
         1 ARCH               1        776      49152 CLOSING
         1 ARCH               0          0          0 CONNECTED
         1 RFS                1        777      18872 IDLE
         1 RFS                0          0          0 IDLE
         1 RFS                2          0          0 IDLE
         1 MRP0               1        777      18872 APPLYING_LOG
         1 RFS                0          0          0 IDLE
         1 RFS                0          0          0 IDLE
         1 RFS                3          0          0 IDLE
         2 ARCH               2        661      28672 CLOSING
         2 DGRD               0          0          0 ALLOCATED
         2 DGRD               0          0          0 ALLOCATED
         2 ARCH               2        660      59392 CLOSING
         2 ARCH               3         59      49152 CLOSING
         2 ARCH               2        657      53248 CLOSING
         2 ARCH               2        623          1 CLOSING
         2 ARCH               2        654      53248 CLOSING
         2 ARCH               1        774      57344 CLOSING
         2 ARCH               2        659      49152 CLOSING
         2 ARCH               3         56      61440 CLOSING
         2 ARCH               3         57      55296 CLOSING
         2 ARCH               2        630       6144 CLOSING
         2 ARCH               2        656      34816 CLOSING
         2 ARCH               2        647      55296 CLOSING
         2 ARCH               3         46      67584 CLOSING
         2 ARCH               3         66      51200 CLOSING
         2 ARCH               0          0          0 CONNECTED
         2 ARCH               1        772      53248 CLOSING
         2 ARCH               3         70      53248 CLOSING
         2 ARCH               3         47      57344 CLOSING
         2 ARCH               2        653      49152 CLOSING
         2 ARCH               3         43      30720 CLOSING
         2 ARCH               3         68      53248 CLOSING
         2 ARCH               3         62      51200 CLOSING
         2 ARCH               3         67      73728 CLOSING
         2 ARCH               3         60      49152 CLOSING
         2 ARCH               3         65      53248 CLOSING
         2 ARCH               3         45      53248 CLOSING
         2 ARCH               2        639          1 CLOSING
         2 ARCH               3         69      55296 CLOSING
         2 ARCH               2        652      40960 CLOSING
         2 RFS                0          0          0 IDLE
         2 RFS                1          0          0 IDLE
         2 RFS                2        662      18076 IDLE

74 rows selected.

-- Step 13.12 -->> On Node 1 (DR - Remove added log files)
-- The third last applied logs seen from Oracle DataDictionary Vew only
SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           783          1
           668          2
            72          3

-- Step 13.13 -->> On Node 1 (DR - Remove added log files)
-- The third last applied logs seen from Oracle DataDictionary Vew only
SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           782          1
           667          2
            72          3

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 14 -->> On Node 3
[root@pdb3 ~]$ init 0

-- Step 15 -->> On Node 3
-- Remove the added shared drive after server down.