--https://oracle-base.com/articles/19c/oracle-db-19c-installation-on-oracle-linux-8
----------------------------------------------------------------
-------------One Node rac Setup on Physical Server--------------
----------------------------------------------------------------
-- Step 0 -->> 1 Node rac on Physical Server -->> On Node 1
--For OS Oracle Linux 8.6 => boot V1020894-01.iso
--And follow 
--https <= public-yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/
--UEKR6 <= https <= public-yum.oracle.com/repo/OracleLinux/OL8/UEKR6/x86_64/
--appstream <= https <= public-yum.oracle.com/repo/OracleLinux/OL8/appstream/x86_64/
--Then for other RPM V1020898-01.iso

-- Step 0.0 -->>  1 Node rac on Physical Server -->> On Node 1 - SandBox
[root@pdb ~]# df -Th
/*
Filesystem                Type      Size  Used Avail Use% Mounted on
devtmpfs                  devtmpfs  9.6G     0  9.6G   0% /dev
tmpfs                     tmpfs     9.7G     0  9.7G   0% /dev/shm
tmpfs                     tmpfs     9.7G  9.4M  9.7G   1% /run
tmpfs                     tmpfs     9.7G     0  9.7G   0% /sys/fs/cgroup
/dev/mapper/ol_pdb-root   xfs        70G  586M   70G   1% /
/dev/mapper/ol_pdb-usr    xfs        10G  7.2G  2.9G  72% /usr
/dev/mapper/ol_pdb-home   xfs        10G  104M  9.9G   2% /home
/dev/mapper/ol_pdb-tmp    xfs        10G  104M  9.9G   2% /tmp
/dev/mapper/ol_pdb-var    xfs        10G  809M  9.3G   8% /var
/dev/mapper/ol_pdb-backup xfs        53G  411M   53G   1% /backup
/dev/sda1                 xfs      1014M  343M  672M  34% /boot
/dev/mapper/ol_pdb-opt    xfs        70G  740M   70G   2% /opt
tmpfs                     tmpfs     2.0G   12K  2.0G   1% /run/user/42
tmpfs                     tmpfs     2.0G     0  2.0G   0% /run/user/0
*/

-- Step 1 -->> On Node 1 - SandBox
[root@pdb ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.16.6.30   pdb.unidev.org.np        pdb

# Private
10.10.10.30   pdb-priv.unidev.org.np   pdb-priv

# Virtual
192.16.6.31   pdb-vip.unidev.org.np    pdb-vip

# SCAN
192.16.6.32   pdbm-scan.unidev.org.np    pdbm-scan
192.16.6.33   pdbm-scan.unidev.org.np    pdbm-scan
192.16.6.34   pdbm-scan.unidev.org.np    pdbm-scan
*/


-- Step 2 -->> On Node 1 - SandBox
-- Disable secure linux by editing the "/etc/selinux/config" file, making sure the SELINUX flag is set as follows.
[root@pdb ~]# vi /etc/selinux/config
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

-- Step 3 -->> On Node 1 - SandBox
[root@pdb ~]# vi /etc/sysconfig/network
/*
NETWORKING=yes
HOSTNAME=pdb.unidev.org.np
*/

-- Step 4 -->> On Node 1 - SandBox
[root@pdb ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens160
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=ens160
DEVICE=ens160
ONBOOT=yes
IPADDR=192.16.6.30
NETMASK=255.255.255.0
GATEWAY=192.16.6.1
DNS1=127.0.0.1
DNS2=192.16.4.11
DNS3=192.16.4.12
*/

-- Step 4.1 -->> On Node 1 - SandBox
[root@pdb ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens192
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=ens192
DEVICE=ens192
ONBOOT=yes
IPADDR=10.10.10.30
NETMASK=255.255.255.0
*/

-- Step 5 -->> On Node 1 - SandBox
[root@pdb ~]# systemctl restart network-online.target

-- Step 6 -->> On Node 1 - SandBox
[root@pdb ~]# systemctl restart NetworkManager

-- Step 7 -->> On Node 1 - SandBox
[root@pdb ~]# dnf repolist
/*
repo id                       repo name
ol8_UEKR6                     Latest Unbreakable Enterprise Kernel Release 6 for Oracle Linux 8 (x86_64)
ol8_appstream                 Oracle Linux 8 Application Stream (x86_64)
ol8_baseos_latest             Oracle Linux 8 BaseOS Latest (x86_64)
*/

-- Step 7.1 -->> On Node 1 - SandBox
[root@pdb ~]# uname -a
/*
Linux pdb.unidev.org.np 5.4.17-2136.335.4.el8uek.x86_64 #3 SMP Thu Aug 22 12:18:30 PDT 2024 x86_64 x86_64 x86_64 GNU/Linux
*/

-- Step 7.2 -->> On Node 1 - SandBox
[root@pdb ~]# uname -r
/*
5.4.17-2136.335.4.el8uek.x86_64
*/

-- Step 7.3 -->> On Node 1 - SandBox
[root@pdb ~]# grubby --info=ALL | grep ^kernel
/*
kernel="/boot/vmlinuz-5.4.17-2136.335.4.el8uek.x86_64"
kernel="/boot/vmlinuz-4.18.0-553.16.1.el8_10.x86_64"
kernel="/boot/vmlinuz-0-rescue-9867dd74d1d4439293c340965293538d"
*/

-- Step 7.4 -->> On Node 1 - SandBox
[root@pdb ~]# grubby --default-kernel
/*
/boot/vmlinuz-5.4.17-2136.335.4.el8uek.x86_64
*/

-- Step 8 -->> On Node 1 - SandBox
[root@pdb ~]# cat /etc/hostname
/*
pdb.unidev.org.np
*/

-- Step 8.1 -->> On Node 1 - SandBox
[root@pdb ~]# hostnamectl | grep hostname
/*
Static hostname: pdb.unidev.org.np
*/

-- Step 8.2 -->> On Node 1 - SandBox
[root@pdb ~]# hostnamectl --static
/*
pdb.unidev.org.np
*/

-- Step 9 -->> On Node 1 - SandBox
[root@pdb ~]# hostnamectl set-hostname pdb.unidev.org.np

--Note: If you are not configure proper hostname then While installation of Grid Software, 
--you have to face error CLSRSC-180: An error occurred while executing /opt/app/19c/grid/root.sh script.
-- Step 9.1 -->> On Node 1 - SandBox
[root@pdb ~]# hostnamectl
/*
   Static hostname: pdb.unidev.org.np
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 9867dd74d1d4439293c340965293538d
           Boot ID: f5dde3eb432a47cd864033afcc189acb
    Virtualization: vmware
  Operating System: Oracle Linux Server 8.10
       CPE OS Name: cpe:/o:oracle:linux:8:10:server
            Kernel: Linux 5.4.17-2136.335.4.el8uek.x86_64
      Architecture: x86-64
*/

-- Step 10 -->> On Node 1 - SandBox
[root@pdb ~]# systemctl stop firewalld
[root@pdb ~]# systemctl disable firewalld
/*
Removed /etc/systemd/system/multi-user.target.wants/firewalld.service.
Removed /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.
*/

-- Step 11 -->> On Node 1df  - SandBox
[root@pdb ~]# mv /etc/ntp.conf /etc/ntp.conf.backup
[root@pdb ~]# rm -rf /etc/ntp.conf
[root@pdb ~]# rm -rf /var/run/ntpd.pid

-- Step 12 -->> On Node 1 - SandBox
[root@pdb ~]# iptables -F
[root@pdb ~]# iptables -X
[root@pdb ~]# iptables -t nat -F
[root@pdb ~]# iptables -t nat -X
[root@pdb ~]# iptables -t mangle -F
[root@pdb ~]# iptables -t mangle -X
[root@pdb ~]# iptables -P INPUT ACCEPT
[root@pdb ~]# iptables -P FORWARD ACCEPT
[root@pdb ~]# iptables -P OUTPUT ACCEPT
[root@pdb ~]# iptables -L -nv
/*
Chain INPUT (policy ACCEPT 3 packets, 120 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 2 packets, 320 bytes)
 pkts bytes target     prot opt in     out     source               destination
*/

-- Step 13 -->> On Node 1 - SandBox
[root@pdb ~ ]# systemctl stop named
[root@pdb ~ ]# systemctl disable named

-- Step 14 -->> On Node 1 - SandBox
-- Enable chronyd service." `date`
[root@pdb ~ ]# systemctl enable chronyd
[root@pdb ~ ]# systemctl restart chronyd
[root@pdb ~ ]# chronyc -a 'burst 4/4'
/*
200 OK
*/

-- Step 14.1 -->> On Node 1 - SandBox
[root@pdb ~ ]# chronyc -a makestep
/*
200 OK
*/

-- Step 14.2 -->> On Node 1 - SandBox
[root@pdb ~ ]# systemctl status chronyd
/*
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2024-09-25 15:00:05 +0545; 30s ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 6567 ExecStopPost=/usr/libexec/chrony-helper remove-daemon-state (code=exited, sta>
  Process: 6577 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, status=0>
  Process: 6573 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 6575 (chronyd)
    Tasks: 1 (limit: 125778)
   Memory: 900.0K
   CGroup: /system.slice/chronyd.service
           └─6575 /usr/sbin/chronyd

Sep 25 15:00:05 pdb.unidev.org.np systemd[1]: Starting NTP client/server...
Sep 25 15:00:05 pdb.unidev.org.np chronyd[6575]: chronyd version 4.5 starting (+CMDMON +NTP>
Sep 25 15:00:05 pdb.unidev.org.np chronyd[6575]: Loaded 0 symmetric keys
Sep 25 15:00:05 pdb.unidev.org.np chronyd[6575]: Frequency -9.082 +/- 0.885 ppm read from />
Sep 25 15:00:05 pdb.unidev.org.np chronyd[6575]: Using right/UTC timezone to obtain leap se>
Sep 25 15:00:05 pdb.unidev.org.np systemd[1]: Started NTP client/server.
Sep 25 15:00:10 pdb.unidev.org.np chronyd[6575]: Selected source 162.159.200.123 (2.pool.nt>
Sep 25 15:00:10 pdb.unidev.org.np chronyd[6575]: System clock TAI offset set to 37 seconds
Sep 25 15:00:18 pdb.unidev.org.np chronyd[6575]: System clock was stepped by 0.000090 secon>
*/

-- Step 15 -->> On Node 1 - SandBox
[root@pdb ~]# cd /etc/yum.repos.d/
[root@pdb yum.repos.d]# ll
/*
-rw-r--r--. 1 root root 4107 May 22 16:13 oracle-linux-ol8.repo
-rw-r--r--. 1 root root  941 May 23 14:02 uek-ol8.repo
-rw-r--r--. 1 root root  243 May 23 14:02 virt-ol8.repo
*/

-- Step 15.1 -->> On Node 1 - SandBox
[root@pdb ~]# cd /etc/yum.repos.d/
[root@pdb yum.repos.d]# dnf -y update
[root@pdb yum.repos.d]# dnf install -y bind
[root@pdb yum.repos.d]# dnf install -y dnsmasq

-- Step 15.2 -->> On Node 1 - SandBox
[root@pdb ~]# systemctl enable dnsmasq
[root@pdb ~]# systemctl restart dnsmasq
[root@pdb ~]# vi /etc/dnsmasq.conf
/*
listen-address=::1,127.0.0.1

#Add the following Lines
except-interface=virbr0
bind-interfaces
*/

-- Step 15.3 -->> On Node 1 - SandBox
[root@pdb ~]# cat /etc/dnsmasq.conf | grep -E 'listen-address|except-interface|bind-interfaces'
/*
except-interface=virbr0
listen-address=::1,127.0.0.1
bind-interfaces
*/

-- Step 15.4 -->> On Node 1 - SandBox
[root@pdb ~]# systemctl restart dnsmasq
[root@pdb ~]# systemctl restart network-online.target
[root@pdb ~]# systemctl restart NetworkManager
[root@pdb ~]# systemctl status NetworkManager
/*
● NetworkManager.service - Network Manager
   Loaded: loaded (/usr/lib/systemd/system/NetworkManager.service; enabled; vendor preset: en>
   Active: active (running) since Wed 2024-09-25 15:21:41 +0545; 2s ago
     Docs: man:NetworkManager(8)
 Main PID: 55988 (NetworkManager)
    Tasks: 4 (limit: 125778)
   Memory: 5.5M
   CGroup: /system.slice/NetworkManager.service
           └─55988 /usr/sbin/NetworkManager --no-daemon

Sep 25 15:21:41 pdb.unidev.org.np NetworkManager[55988]: <info>  [1727257001.6149] device (>
Sep 25 15:21:41 pdb.unidev.org.np NetworkManager[55988]: <info>  [1727257001.6153] manager:>
Sep 25 15:21:41 pdb.unidev.org.np NetworkManager[55988]: <info>  [1727257001.6156] device (>
Sep 25 15:21:41 pdb.unidev.org.np NetworkManager[55988]: <info>  [1727257001.6163] device (>
Sep 25 15:21:41 pdb.unidev.org.np NetworkManager[55988]: <info>  [1727257001.6166] manager:>
Sep 25 15:21:41 pdb.unidev.org.np NetworkManager[55988]: <info>  [1727257001.6169] device (>
Sep 25 15:21:41 pdb.unidev.org.np NetworkManager[55988]: <info>  [1727257001.6174] manager:>
Sep 25 15:21:41 pdb.unidev.org.np NetworkManager[55988]: <info>  [1727257001.6176] device (>
Sep 25 15:21:41 pdb.unidev.org.np NetworkManager[55988]: <info>  [1727257001.6181] device (>
Sep 25 15:21:41 pdb.unidev.org.np NetworkManager[55988]: <info>  [1727257001.6262] manager:>
*/

-- Step 15.5 -->> On Node 1 - SandBox
[root@pdb ~]# systemctl status dnsmasq
/*
● dnsmasq.service - DNS caching server.
   Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2024-09-25 15:21:41 +0545; 40s ago
 Main PID: 55974 (dnsmasq)
    Tasks: 1 (limit: 125778)
   Memory: 696.0K
   CGroup: /system.slice/dnsmasq.service
           └─55974 /usr/sbin/dnsmasq -k

Sep 25 15:21:41 pdb.unidev.org.np dnsmasq[55974]: compile time options: IPv6 GNU-getopt DBu>
Sep 25 15:21:41 pdb.unidev.org.np dnsmasq[55974]: reading /etc/resolv.conf
Sep 25 15:21:41 pdb.unidev.org.np dnsmasq[55974]: ignoring nameserver 127.0.0.1 - local int>
Sep 25 15:21:41 pdb.unidev.org.np dnsmasq[55974]: using nameserver 192.16.4.11#53
Sep 25 15:21:41 pdb.unidev.org.np dnsmasq[55974]: using nameserver 192.16.4.12#53
Sep 25 15:21:41 pdb.unidev.org.np dnsmasq[55974]: read /etc/hosts - 8 addresses
Sep 25 15:21:41 pdb.unidev.org.np dnsmasq[55974]: reading /etc/resolv.conf
Sep 25 15:21:41 pdb.unidev.org.np dnsmasq[55974]: ignoring nameserver 127.0.0.1 - local int>
Sep 25 15:21:41 pdb.unidev.org.np dnsmasq[55974]: using nameserver 192.16.4.11#53
Sep 25 15:21:41 pdb.unidev.org.np dnsmasq[55974]: using nameserver 192.16.4.12#53
*/

-- Step 15.6 -->> On Node 1 - SandBox
[root@pdb ~]# cat /etc/resolv.conf
/*
# Generated by NetworkManager
search cibnepal.org.np
nameserver 127.0.0.1
nameserver 192.16.20.180
nameserver 192.16.20.181
*/

-- Step 16 -->> On Node 1 - SandBox
[root@pdb ~]# nslookup 192.16.6.30
/*
30.6.16.192.in-addr.arpa name = pdb.unidev.org.np.
*/

-- Step 16.1 -->> On Node 1 - SandBox
[root@pdb ~]# nslookup pdb
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb.unidev.org.np
Address: 192.16.6.30
*/

-- Step 16.2 -->> On Node 1 - SandBox
[root@pdb ~]# nslookup pdbm-scan
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdbm-scan.unidev.org.np
Address: 192.16.6.34
Name:   pdbm-scan.unidev.org.np
Address: 192.16.6.32
Name:   pdbm-scan.unidev.org.np
Address: 192.16.6.33
*/

-- Step 17 -->> On Node 1 - SandBox
--Stop avahi-daemon damon if it not configured
[root@pdb ~]# systemctl stop avahi-daemon
[root@pdb ~]# systemctl disable avahi-daemon

-- Step 18 -->> On Node 1 - SandBox
--To Remove virbr0 and lxcbr0 Network Interfac
[root@pdb ~]# systemctl stop libvirtd.service
[root@pdb ~]# systemctl disable libvirtd.service
[root@pdb ~]# virsh net-list
/*
 Name      State    Autostart   Persistent
--------------------------------------------
 default   active   yes         yes
*/

-- Step 18.1 -->> On Node 1 - SandBox
[root@pdb ~]# virsh net-destroy default
/*
Network default destroyed
*/

-- Step 18.2 -->> On Node 1 - SandBox
[root@pdb ~]# ifconfig virbr0
/*
virbr0: error fetching interface information: Device not found
*/

-- Step 18.3 -->> On Node One - SandBox
[root@pdb ~]# ifconfig
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.16.6.30  netmask 255.255.255.0  broadcast 192.16.6.255
        inet6 fe80::250:56ff:feac:822  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:08:22  txqueuelen 1000  (Ethernet)
        RX packets 10451151  bytes 15167116250 (14.1 GiB)
        RX errors 0  dropped 21  overruns 0  frame 0
        TX packets 2383117  bytes 175784767 (167.6 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.30  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::250:56ff:feac:e3d  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:0e:3d  txqueuelen 1000  (Ethernet)
        RX packets 219  bytes 21508 (21.0 KiB)
        RX errors 0  dropped 19  overruns 0  frame 0
        TX packets 92  bytes 10593 (10.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 682  bytes 45255 (44.1 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 682  bytes 45255 (44.1 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 19 -->> On Node 1 - SandBox
[root@pdb ~]# init 6


-- Step 20 -->> On Node 1 - SandBox
[root@pdb ~]# ifconfig
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.16.6.30  netmask 255.255.255.0  broadcast 192.16.6.255
        inet6 fe80::250:56ff:feac:822  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:08:22  txqueuelen 1000  (Ethernet)
        RX packets 107  bytes 14926 (14.5 KiB)
        RX errors 0  dropped 28  overruns 0  frame 0
        TX packets 83  bytes 10266 (10.0 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.30  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::250:56ff:feac:e3d  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:0e:3d  txqueuelen 1000  (Ethernet)
        RX packets 43  bytes 2580 (2.5 KiB)
        RX errors 0  dropped 26  overruns 0  frame 0
        TX packets 13  bytes 922 (922.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 62  bytes 4798 (4.6 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 62  bytes 4798 (4.6 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 20.1 -->> On Node 1 - SandBox
[root@pdb ~]# ifconfig | grep -E 'UP'
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
*/

-- Step 20.2 -->> On Node One - SandBox
[root@pdb ~]# ifconfig | grep -E 'RUNNING'
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
*/

-- Step 21 -->> On Node 1 - SandBox
[root@pdb ~]# systemctl status libvirtd.service
/*
● libvirtd.service - Virtualization daemon
   Loaded: loaded (/usr/lib/systemd/system/libvirtd.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:libvirtd(8)
           https://libvirt.org
*/

-- Step 22 -->> On Node 1 - SandBox
[root@pdb ~]# firewall-cmd --list-all
/*
FirewallD is not running
*/

-- Step 22.1 -->> On Node 1 - SandBox
[root@pdb ~]# systemctl status firewalld
/*
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:firewalld(1)
*/

-- Step 23 -->> On Node 1 - SandBox
[root@pdb ~]# systemctl status named
/*
● named.service - Berkeley Internet Name Domain (DNS)
   Loaded: loaded (/usr/lib/systemd/system/named.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
*/

-- Step 24 -->> On Node 1 - SandBox
[root@pdb ~]# systemctl status avahi-daemon
/*
● avahi-daemon.service - Avahi mDNS/DNS-SD Stack
   Loaded: loaded (/usr/lib/systemd/system/avahi-daemon.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
*/

-- Step 25 -->> On Node 1 - SandBox
[root@pdb ~ ]# systemctl status chronyd
/*
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2024-09-25 15:27:28 +0545; 5min ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 1373 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, status=0>
  Process: 1325 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 1358 (chronyd)
    Tasks: 1 (limit: 125778)
   Memory: 1.3M
   CGroup: /system.slice/chronyd.service
           └─1358 /usr/sbin/chronyd

Sep 25 15:27:28 pdb.unidev.org.np systemd[1]: Starting NTP client/server...
Sep 25 15:27:28 pdb.unidev.org.np chronyd[1358]: chronyd version 4.5 starting (+CMDMON +NTP>
Sep 25 15:27:28 pdb.unidev.org.np chronyd[1358]: Loaded 0 symmetric keys
Sep 25 15:27:28 pdb.unidev.org.np chronyd[1358]: Frequency -10.032 +/- 0.663 ppm read from >
Sep 25 15:27:28 pdb.unidev.org.np chronyd[1358]: Using right/UTC timezone to obtain leap se>
Sep 25 15:27:28 pdb.unidev.org.np systemd[1]: Started NTP client/server.
Sep 25 15:27:33 pdb.unidev.org.np chronyd[1358]: Selected source 162.159.200.1 (2.pool.ntp.>
Sep 25 15:27:33 pdb.unidev.org.np chronyd[1358]: System clock TAI offset set to 37 seconds
*/

-- Step 26 -->> On Node 1 - SandBox
[root@pdb ~]# systemctl status dnsmasq
/*
● dnsmasq.service - DNS caching server.
   Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2024-09-25 15:27:27 +0545; 6min ago
 Main PID: 1254 (dnsmasq)
    Tasks: 1 (limit: 125778)
   Memory: 1.3M
   CGroup: /system.slice/dnsmasq.service
           └─1254 /usr/sbin/dnsmasq -k

Sep 25 15:27:27 pdb.unidev.org.np dnsmasq[1254]: compile time options: IPv6 GNU-getopt DBus>
Sep 25 15:27:27 pdb.unidev.org.np dnsmasq[1254]: reading /etc/resolv.conf
Sep 25 15:27:27 pdb.unidev.org.np dnsmasq[1254]: ignoring nameserver 127.0.0.1 - local inte>
Sep 25 15:27:27 pdb.unidev.org.np dnsmasq[1254]: using nameserver 192.16.4.11#53
Sep 25 15:27:27 pdb.unidev.org.np dnsmasq[1254]: using nameserver 192.16.4.12#53
Sep 25 15:27:27 pdb.unidev.org.np dnsmasq[1254]: read /etc/hosts - 8 addresses
Sep 25 15:27:28 pdb.unidev.org.np dnsmasq[1254]: reading /etc/resolv.conf
Sep 25 15:27:28 pdb.unidev.org.np dnsmasq[1254]: ignoring nameserver 127.0.0.1 - local inte>
Sep 25 15:27:28 pdb.unidev.org.np dnsmasq[1254]: using nameserver 192.16.4.11#53
Sep 25 15:27:28 pdb.unidev.org.np dnsmasq[1254]: using nameserver 192.16.4.12#53
*/

-- Step 27 -->> On Node 1 - SandBox
[root@pdb ~]# nslookup 192.16.6.30
/*
30.6.16.192.in-addr.arpa name = pdb.unidev.org.np.
*/

-- Step 27.1 -->> On Node 1 - SandBox
[root@pdb ~]# nslookup pdb
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb.unidev.org.np
Address: 192.16.6.30
*/

-- Step 27.2 -->> On Node 1 - SandBox
[root@pdb ~]# nslookup pdbm-scan
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdbm-scan.unidev.org.np
Address: 192.16.6.34
Name:   pdbm-scan.unidev.org.np
Address: 192.16.6.32
Name:   pdbm-scan.unidev.org.np
Address: 192.16.6.33
*/

-- Step 27.8 -->> On Node 1 - SandBox
[root@pdb ~]# nslookup pdb-vip
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb-vip.unidev.org.np
Address: 192.16.6.31
*/

-- Step 27.9 -->> On Node 1 - SandBox
[root@pdb ~]# nslookup pdb-priv
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb-priv.unidev.org.np
Address: 10.10.10.30
*/

-- Step 28 -->> On Node 1 - SandBox
[root@pdb ~]# iptables -L -nv
/*
Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination
*/


-- Step 29 -->> On Node 1 - SandBox
-- Perform either the Automatic Setup or the Manual Setup to complete the basic prerequisites. 
[root@pdb ~]# cd /etc/yum.repos.d/
[root@pdb yum.repos.d]# dnf -y update

-- Step 29.1 -->> On Node 1 - SandBox
[root@pdb yum.repos.d]# dnf install -y yum-utils
[root@pdb yum.repos.d]# dnf install -y dnf-utils
[root@pdb yum.repos.d]# dnf install -y oracle-epel-release-el8
[root@pdb yum.repos.d]# dnf install -y sshpass zip unzip
[root@pdb yum.repos.d]# dnf install -y oracle-database-preinstall-19c

-- Step 29.2 -->> On Node 1 - SandBox
[root@pdb yum.repos.d]# dnf install -y bc
[root@pdb yum.repos.d]# dnf install -y binutils
[root@pdb yum.repos.d]# dnf install -y compat-libcap1
[root@pdb yum.repos.d]# dnf install -y compat-libstdc++-33
[root@pdb yum.repos.d]# dnf install -y dtrace-utils
[root@pdb yum.repos.d]# dnf install -y elfutils-libelf
[root@pdb yum.repos.d]# dnf install -y elfutils-libelf-devel
[root@pdb yum.repos.d]# dnf install -y fontconfig-devel
[root@pdb yum.repos.d]# dnf install -y glibc
[root@pdb yum.repos.d]# dnf install -y glibc-devel
[root@pdb yum.repos.d]# dnf install -y ksh
[root@pdb yum.repos.d]# dnf install -y libaio
[root@pdb yum.repos.d]# dnf install -y libaio-devel
[root@pdb yum.repos.d]# dnf install -y libdtrace-ctf-devel
[root@pdb yum.repos.d]# dnf install -y libXrender
[root@pdb yum.repos.d]# dnf install -y libXrender-devel
[root@pdb yum.repos.d]# dnf install -y libX11
[root@pdb yum.repos.d]# dnf install -y libXau
[root@pdb yum.repos.d]# dnf install -y libXi
[root@pdb yum.repos.d]# dnf install -y libXtst
[root@pdb yum.repos.d]# dnf install -y libgcc
[root@pdb yum.repos.d]# dnf install -y librdmacm-devel
[root@pdb yum.repos.d]# dnf install -y libstdc++
[root@pdb yum.repos.d]# dnf install -y libstdc++-devel
[root@pdb yum.repos.d]# dnf install -y libxcb
[root@pdb yum.repos.d]# dnf install -y make
[root@pdb yum.repos.d]# dnf install -y net-tools
[root@pdb yum.repos.d]# dnf install -y nfs-utils
[root@pdb yum.repos.d]# dnf install -y python
[root@pdb yum.repos.d]# dnf install -y python-configshell
[root@pdb yum.repos.d]# dnf install -y python-rtslib
[root@pdb yum.repos.d]# dnf install -y python-six
[root@pdb yum.repos.d]# dnf install -y targetcli
[root@pdb yum.repos.d]# dnf install -y smartmontools
[root@pdb yum.repos.d]# dnf install -y sysstat
[root@pdb yum.repos.d]# dnf install -y libnsl
[root@pdb yum.repos.d]# dnf install -y libnsl.i686
[root@pdb yum.repos.d]# dnf install -y libnsl2
[root@pdb yum.repos.d]# dnf install -y libnsl2.i686
[root@pdb yum.repos.d]# dnf install -y chrony
[root@pdb yum.repos.d]# dnf install -y unixODBC
[root@pdb yum.repos.d]# dnf -y update

-- Step 29.3 -->> On Node 1 - SandBox
[root@pdb ~]# cd /tmp
--Bug 29772579
[root@pdb tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libcap1-1.10-7.el7.i686.rpm
[root@pdb tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libcap1-1.10-7.el7.x86_64.rpm
[root@pdb tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libstdc++-33-3.2.3-72.el7.i686.rpm
[root@pdb tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm

-- Step 29.4 -->> On Node 1 - SandBox
[root@pdb tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/elfutils-libelf-devel-0.189-3.el8.i686.rpm
[root@pdb tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/elfutils-libelf-devel-0.189-3.el8.x86_64.rpm
[root@pdb tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/numactl-2.0.12-13.el8.x86_64.rpm
[root@pdb tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/numactl-devel-2.0.12-13.el8.x86_64.rpm
[root@pdb tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/numactl-devel-2.0.12-13.el8.i686.rpm
[root@pdb tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/python3-libs-3.6.8-56.0.1.el8_9.i686.rpm
[root@pdb tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/python3-libs-3.6.8-56.0.1.el8_9.x86_64.rpm

/* -- On Physical Server (If the ASMLib-8 we installed)
https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=364500837732007&id=2789052.1&_adf.ctrl-state=11vbxw8jk2_58

--OL8/RHEL8: ASMLib: root.sh is failing with CRS-1705: Found 0 Configured Voting Files But 1 Voting Files Are Required (Doc ID 2789052.1)
Bug 32410237 - oracleasm configure -p not discovering disks on RHEL8
Bug 32812376 - ROOT.SH IS FAILING WTH THE ERRORS CLSRSC-119: START OF THE EXCLUSIVE MODE CLUSTER FAILED
*/

--[root@pdb tmp]# wget https://download.oracle.com/otn_software/asmlib/oracleasmlib-2.0.17-1.el8.x86_64.rpm
--[root@pdb tmp]# wget https://public-yum.oracle.com/repo/OracleLinux/OL8/addons/x86_64/getPackage/oracleasm-support-2.1.12-1.el8.x86_64.rpm

-- Step 29.5 -->> On Node 1 - SandBox
[root@pdb tmp]# wget https://download.oracle.com/otn_software/asmlib/oracleasmlib-2.0.12-1.el7.x86_64.rpm
[root@pdb tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/oracleasm-support-2.1.11-2.el7.x86_64.rpm

-- Step 29.6 -->> On Node 1 - SandBox
--Bug 29772579
[root@pdb tmp]# yum -y localinstall ./compat-libcap1-1.10-7.el7.i686.rpm
[root@pdb tmp]# yum -y localinstall ./compat-libcap1-1.10-7.el7.x86_64.rpm
[root@pdb tmp]# yum -y localinstall ./compat-libstdc++-33-3.2.3-72.el7.i686.rpm
[root@pdb tmp]# yum -y localinstall ./compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm

-- Step 29.7 -->> On Node 1 - SandBox
[root@pdb tmp]# yum -y localinstall ./elfutils-libelf-devel-0.189-3.el8.i686.rpm
[root@pdb tmp]# yum -y localinstall ./elfutils-libelf-devel-0.189-3.el8.x86_64.rpm
[root@pdb tmp]# yum -y localinstall ./numactl-2.0.12-13.el8.x86_64.rpm
[root@pdb tmp]# yum -y localinstall ./numactl-devel-2.0.12-13.el8.i686.rpm
[root@pdb tmp]# yum -y localinstall ./numactl-devel-2.0.12-13.el8.x86_64.rpm
[root@pdb tmp]# yum -y localinstall ./python3-libs-3.6.8-56.0.1.el8_9.i686.rpm
[root@pdb tmp]# yum -y localinstall ./python3-libs-3.6.8-56.0.1.el8_9.x86_64.rpm

/* -- On Physical Server (If the ASMLib-8 we installed)
https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=364500837732007&id=2789052.1&_adf.ctrl-state=11vbxw8jk2_58

--OL8/RHEL8: ASMLib: root.sh is failing with CRS-1705: Found 0 Configured Voting Files But 1 Voting Files Are Required (Doc ID 2789052.1)
Bug 32410237 - oracleasm configure -p not discovering disks on RHEL8
Bug 32812376 - ROOT.SH IS FAILING WTH THE ERRORS CLSRSC-119: START OF THE EXCLUSIVE MODE CLUSTER FAILED
*/

--[root@pdb tmp]# yum -y localinstall ./oracleasm-support-2.1.12-1.el8.x86_64.rpm ./oracleasmlib-2.0.17-1.el8.x86_64.rpm

-- Step 29.8 -->> On Node 1 - SandBox
[root@pdb tmp]# yum -y localinstall ./oracleasm-support-2.1.11-2.el7.x86_64.rpm ./oracleasmlib-2.0.12-1.el7.x86_64.rpm
[root@pdb tmp]# rm -rf *.rpm

-- Step 30 -->> On Node 1 - SandBox
[root@pdb ~]# cd /etc/yum.repos.d/
[root@pdb yum.repos.d]# dnf -y install compat-libcap1 compat-libstdc++-33 bc binutils elfutils-libelf elfutils-libelf-devel fontconfig-devel glibc glibc-devel ksh libaio libaio-devel libgcc libnsl librdmacm-devel libstdc++ libstdc++-devel libX11 libXau libxcb libXi libXrender libXrender-devel libXtst make net-tools nfs-utils python3 python3-configshell python3-rtslib python3-six smartmontools sysstat targetcli unzip
[root@pdb yum.repos.d]# dnf -y install bash bc bind-utils binutils ethtool glibc glibc-devel initscripts ksh libaio libaio-devel libgcc libnsl libstdc++ libstdc++-devel make module-init-tools net-tools nfs-utils openssh-clients openssl-libs pam procps psmisc smartmontools sysstat tar unzip util-linux-ng xorg-x11-utils xorg-x11-xauth 
[root@pdb yum.repos.d]# dnf -y update

-- Step 31 -->> On Node 1 - SandBox
[root@pdb yum.repos.d]# rpm -q binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel elfutils-libelf-devel-static \
[root@pdb yum.repos.d]# rpm -q gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers kernel-headers ksh libaio libaio-devel \
[root@pdb yum.repos.d]# rpm -q libgcc libgomp libstdc++ libstdc++-devel make numactl-devel sysstat unixODBC unixODBC-devel \

-- Step 32 -->> On Node 1 - SandBox
[root@pdb ~]# rpm -qa | grep oracleasm
/*
oracleasm-support-2.1.11-2.el7.x86_64
oracleasmlib-2.0.12-1.el7.x86_64
*/

-- Step 33 -->> On Node 1 - SandBox
-- Add the kernel parameters file "/etc/sysctl.conf" and add oracle recommended kernel parameters
[root@pdb ~]# vi /etc/sysctl.conf
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

-- Step 33.1 -->> On Node 1 - SandBox
-- Run the following command to change the current kernel parameters.
[root@pdb ~]# sysctl -p /etc/sysctl.conf

-- Step 34 -->> On Node 1 - SandBox
-- Edit “/etc/security/limits.d/oracle-database-preinstall-19c.conf” file to limit user processes
[root@pdb ~]# vi /etc/security/limits.d/oracle-database-preinstall-19c.conf
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

-- Step 35 -->> On Node 1 - SandBox
-- Add the following line to the "/etc/pam.d/login" file, if it does not already exist.
[root@pdb ~]# vi /etc/pam.d/login
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

-- Step 36 -->> On Node 1 - SandBox
-- Create the new groups and users.
[root@pdb ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:
*/

-- Step 36.1 -->> On Node 1 - SandBox
[root@pdb ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:
backupdba:x:54324:
dgdba:x:54325:
kmdba:x:54326:
racdba:x:54330:
*/

-- Step 36.2 -->> On Node 1 - SandBox
[root@pdb ~]# cat /etc/group | grep -i oracle
/*
oracle:x:1000:
*/

-- Step 36.3 -->> On Node 1 - SandBox
[root@pdb ~]# cat /etc/group | grep -i oper
/*
oper:x:54323:
*/

-- Step 36.4 -->> On Node 1 - SandBox
[root@pdb ~]# cat /etc/group | grep -i asm

-- Step 37 -->> On Node 1
-- 1.Create OS groups using the command below. Enter these commands as the 'root' user:
--[root@pdb ~]# /usr/sbin/groupadd -g 503 oper
[root@pdb ~]# /usr/sbin/groupadd -g 504 asmadmin
[root@pdb ~]# /usr/sbin/groupadd -g 506 asmdba
[root@pdb ~]# /usr/sbin/groupadd -g 507 asmoper
[root@pdb ~]# /usr/sbin/groupadd -g 508 beoper

-- Step 38 -->> On Node 1 - SandBox
-- 2.Create the users that will own the Oracle software using the commands:
[root@pdb ~]# /usr/sbin/useradd  -g oinstall -G oinstall,dba,asmadmin,asmdba,asmoper,beoper grid
[root@pdb ~]# /usr/sbin/usermod -g oinstall -G oinstall,dba,oper,asmdba,asmadmin,backupdba,dgdba,kmdba,racdba oracle

-- Step 39.1 -->> On Node 1 - SandBox
[root@pdb ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/

-- Step 39.2 -->> On Node 1 - SandBox
[root@pdb ~]# cat /etc/group | grep -i oracle
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

-- Step 39.3 -->> On Node 1 - SandBox
[root@pdb ~]# cat /etc/group | grep -i grid
/*
oinstall:x:54321:grid,oracle
dba:x:54322:grid,oracle
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 39.4 -->> On Node 1 - SandBox
[root@pdb ~]# cat /etc/group | grep -i oper
/*
oper:x:54323:oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 39.5 -->> On Node 1 - SandBox
[root@pdb ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:grid,oracle
*/

-- Step 39.6 -->> On Node 1 - SandBox
[root@pdb ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:grid,oracle
backupdba:x:54324:oracle
dgdba:x:54325:oracle
kmdba:x:54326:oracle
racdba:x:54330:oracle
asmdba:x:506:grid,oracle
*/

-- Step 40 -->> On Node 1 - SandBox
[root@pdb ~]# passwd oracle
/*
Changing password for user oracle.
New password: C#L!5nSI#nG#OraclE#Db#
Retype new password: C#L!5nSI#nG#OraclE#Db#
passwd: all authentication tokens updated successfully.
*/

-- Step 41 -->> On Node 1 - SandBox
[root@pdb ~]# passwd grid
/*
Changing password for user grid.
New password: grid
Retype new password: grid
passwd: all authentication tokens updated successfully.
*/

-- Step 42 -->> On Node 1 - SandBox
[root@pdb ~]# su - oracle

-- Step 42.1 -->> On Node 1 - SandBox
[oracle@pdb ~]$ su - grid
/*
Password: grid
*/

-- Step 42.2 -->> On Node 1 - SandBox
[grid@pdb ~]$ su - oracle
/*
Password: C#L!5nSI#nG#OraclE#Db#
*/

-- Step 42.3 -->> On Node 1 - SandBox
[oracle@pdb ~]$ exit
/*
logout
*/

-- Step 42.4 -->> On Node 1 - SandBox
[grid@pdb ~]$ exit
/*
logout
*/

-- Step 42.5 -->> On Node 1 - SandBox
[oracle@pdb ~]$ exit
/*
logout
*/

-- Step 43 -->> On Node 1 - SandBox
--Create the Oracle Inventory Director:
[root@pdb ~]# mkdir -p /opt/app/oraInventory
[root@pdb ~]# chown -R grid:oinstall /opt/app/oraInventory
[root@pdb ~]# chmod -R 775 /opt/app/oraInventory

-- Step 44 -->> On Node 1 - SandBox
--Creating the Oracle Grid Infrastructure Home Directory:
[root@pdb ~]# mkdir -p /opt/app/19c/grid
[root@pdb ~]# chown -R grid:oinstall /opt/app/19c/grid
[root@pdb ~]# chmod -R 775 /opt/app/19c/grid

-- Step 45 -->> On Node 1 - SandBox
--Creating the Oracle Base Directory
[root@pdb ~]# mkdir -p /opt/app/oracle
[root@pdb ~]# chmod -R 775 /opt/app/oracle
[root@pdb ~]# cd /opt/app/
[root@pdb app]# chown -R oracle:oinstall /opt/app/oracle

-- Step 46 -->> On Node 1 - SandBox
-- Login as the oracle user and add the following lines at the end of the ".bash_profile" file.
[root@pdb ~]# su - oracle
[oracle@pdb ~]$ vi .bash_profile
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

ORACLE_HOSTNAME=pdb.unidev.org.np; export ORACLE_HOSTNAME
ORACLE_UNQNAME=pdbdb; export ORACLE_UNQNAME
ORACLE_BASE=/opt/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/19c/db_1; export ORACLE_HOME
ORACLE_SID=pdbdb1; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 47 -->> On Node 1 - SandBox
[oracle@pdb ~]$ . .bash_profile

-- Step 48 -->> On Node 1 - SandBox
-- Login as the grid user and add the following lines at the end of the ".bash_profile" file.
[root@pdb ~]# su - grid
[grid@pdb ~]$ vi .bash_profile
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

-- Step 49 -->> On Node 1 - SandBox
[grid@pdb ~]$ . .bash_profile

-- Step 50 -->> On Node 1
-- To Unzio The Oracle Grid Software and lateset Opatch
[root@pdb ~]# cd /opt/app/19c/grid/
[root@pdb grid]# unzip -oq /root/Oracle_19C/19.3.0.0.0_Grid_Binary/LINUX.X64_193000_grid_home.zip
[root@pdb grid]# unzip -oq /root/Oracle_19C/OPATCH_19c/p6880880_190000_Linux-x86-64.zip

-- Step 51 -->> On Node 1 - SandBox
-- To Unzio The Oracle PSU
[root@pdb ~]# cd /tmp/
[root@pdb tmp]# unzip -oq /root/Oracle_19C/PSU_19.23.0.0.0/p36209493_190000_Linux-x86-64.zip
[root@pdb tmp]# chown -R oracle:oinstall 36209493
[root@pdb tmp]# chmod -R 775 36209493
[root@pdb tmp]# ls -ltr | grep 36209493
/*
drwxrwxr-x 4 oracle oinstall      80 Apr 16  2024 36209493
*/

-- Step 52 -->> On Node 1 - SandBox
-- Login as root user and issue the following command at pdb1
[root@pdb ~]# chown -R grid:oinstall /opt/app/19c/grid/
[root@pdb ~]# chmod -R 775 /opt/app/19c/grid/

-- Step 53 -->> On Node 1 - SandBox
[root@pdb ~]# su - grid
[grid@pdb ~]$ cd /opt/app/19c/grid/OPatch/
[grid@pdb OPatch]$ ./opatch version
/*
OPatch Version: 12.2.0.1.43

OPatch succeeded.
*/

-- Step 54 -->> On Node 1 - SandBox
-- To install the cvuqdisk-1.0.10-1.rpm
-- Login from root user
[root@pdb ~]# cd /opt/app/19c/grid/cv/rpm/

-- Step 54.1 -->> On Node 1 - SandBox
[root@pdb rpm]# ll
/*
-rwxrwxr-x 1 grid oinstall 11412 Mar 13  2019 cvuqdisk-1.0.10-1.rpm
*/

-- Step 54.2 -->> On Node 1 - SandBox
--[root@pdb rpm]# export CV_ASSUME_DISTID=OEL7.6
[root@pdb rpm]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP

-- Step 54.3 -->> On Node 1 - SandBox
[root@pdb rpm]# rpm -iUvh cvuqdisk-1.0.10-1.rpm 
/*
Verifying...                          ################################# [100%]
Preparing...                          ################################# [100%]
Updating / installing...
   1:cvuqdisk-1.0.10-1                ################################# [100%]
*/

-- Step 55 -->> On Node 1 - SandBox
[root@pdb ~]# which oracleasm
/*
/usr/sbin/oracleasm
*/

-- Step 55.1 -->> On Node 1 - SandBox
[root@pdb ~]# oracleasm configure
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

-- Step 55.2 -->> On Node 1 - SandBox
[root@pdb ~]# oracleasm status
/*
Checking if ASM is loaded: no
Checking if /dev/oracleasm is mounted: no
*/

-- Step 55.3 -->> On Node 1 - SandBox
[root@pdb ~]# oracleasm configure -i
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

-- Step 55.4 -->> On Node 1 - SandBox
[root@pdb ~]# oracleasm configure
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

-- Step 55.4.1 -->> On Node 1 - SandBox
[root@pdb ~]# oracleasm configure -p
/*
Writing Oracle ASM library driver configuration: done
*/

-- Step 55.5 -->> On Node 1 - SandBox
[root@pdb ~]# oracleasm init
/*
Creating /dev/oracleasm mount point: /dev/oracleasm
Loading module "oracleasm": oracleasm
Configuring "oracleasm" to use device physical block size
Mounting ASMlib driver filesystem: /dev/oracleasm
*/

-- Step 55.6 -->> On Node 1 - SandBox
[root@pdb ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 55.7 -->> On Node 1 - SandBox
[root@pdb ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 55.8 -->> On Node 1 - SandBox
[root@pdb ~]# oracleasm listdisks

-- Step 56 -->> On Node 1 - SandBox
[root@pdb ~]# ll /etc/init.d/
/*
-rw-r--r--. 1 root root 18434 Aug 10  2022 functions
-rwxr-xr-x  1 root root  4954 Feb  3  2018 oracleasm
-rwx------  1 root root  1281 Feb 17  2021 oracle-database-preinstall-19c-firstboot
-rw-r--r--. 1 root root  1161 Jun  5 18:53 README
*/

-- Step 57 -->> On Node 1 - SandBox
[root@pdb ~]# ll /dev/oracleasm/disks/
/*
total 0
*/

-- Step 58 -->> On Node 1 - SandBox
[root@pdb ~]# ll /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Oct 21 10:35 /dev/sda
brw-rw---- 1 root disk 8,  1 Oct 21 10:35 /dev/sda1
brw-rw---- 1 root disk 8,  2 Oct 21 10:35 /dev/sda2
brw-rw---- 1 root disk 8, 16 Oct 21 10:35 /dev/sdb
brw-rw---- 1 root disk 8, 32 Oct 21 10:35 /dev/sdc
brw-rw---- 1 root disk 8, 48 Oct 21 10:35 /dev/sdd
*/

--Step 58.1 -->> On Node 1 - SandBox
[root@pdb ~]# lsblk
/*
NAME              MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                 8:0    0  250G  0 disk
├─sda1              8:1    0    1G  0 part /boot
└─sda2              8:2    0  249G  0 part
  ├─ol_pdb-root   252:0    0   70G  0 lvm  /
  ├─ol_pdb-swap   252:1    0   16G  0 lvm  [SWAP]
  ├─ol_pdb-usr    252:2    0   10G  0 lvm  /usr
  ├─ol_pdb-opt    252:3    0   70G  0 lvm  /opt
  ├─ol_pdb-home   252:4    0   10G  0 lvm  /home
  ├─ol_pdb-var    252:5    0   10G  0 lvm  /var
  ├─ol_pdb-tmp    252:6    0   10G  0 lvm  /tmp
  └─ol_pdb-backup 252:7    0   53G  0 lvm  /backup
sdb                 8:16   0   20G  0 disk
sdc                 8:32   0  400G  0 disk
sdd                 8:48   0  200G  0 disk
sr0                11:0    1  891M  0 rom
*/

-- Step 58.2 -->> On Node 1 - SandBox
[root@pdb ~]# fdisk -ll | grep GiB
/*
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
Disk /dev/sdc: 400 GiB, 429496729600 bytes, 838860800 sectors
Disk /dev/sdd: 200 GiB, 214748364800 bytes, 419430400 sectors
*/

-- Step 58.3 -->> On Node 1 - SandBox
[root@pdb ~]# fdisk /dev/sdb
/*
Welcome to fdisk (util-linux 2.32.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0xf1e1ea37.

Command (m for help): p
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xf1e1ea37

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-41943039, default 2048):
Last sector, +sectors or +size{K,M,G,T,P} (2048-41943039, default 41943039):

Created a new partition 1 of type 'Linux' and of size 20 GiB.

Command (m for help): p
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xf1e1ea37

Device     Boot Start      End  Sectors Size Id Type
/dev/sdb1        2048 41943039 41940992  20G 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 58.4 -->> On Node 1 - SandBox
[root@pdb ~]# fdisk /dev/sdc
/*
Welcome to fdisk (util-linux 2.32.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x444144fe.

Command (m for help): p
Disk /dev/sdc: 400 GiB, 429496729600 bytes, 838860800 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x444144fe

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-838860799, default 2048):
Last sector, +sectors or +size{K,M,G,T,P} (2048-838860799, default 838860799):

Created a new partition 1 of type 'Linux' and of size 400 GiB.

Command (m for help): p
Disk /dev/sdc: 400 GiB, 429496729600 bytes, 838860800 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x444144fe

Device     Boot Start       End   Sectors  Size Id Type
/dev/sdc1        2048 838860799 838858752  400G 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 58.5 -->> On Node 1 - SandBox
[root@pdb ~]# fdisk /dev/sdd
/*
Welcome to fdisk (util-linux 2.32.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x96e68b70.

Command (m for help): p
Disk /dev/sdd: 200 GiB, 214748364800 bytes, 419430400 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x96e68b70

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-419430399, default 2048):
Last sector, +sectors or +size{K,M,G,T,P} (2048-419430399, default 419430399):

Created a new partition 1 of type 'Linux' and of size 200 GiB.

Command (m for help): p
Disk /dev/sdd: 200 GiB, 214748364800 bytes, 419430400 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x96e68b70

Device     Boot Start       End   Sectors  Size Id Type
/dev/sdd1        2048 419430399 419428352  200G 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/


-- Step 58.7 -->> On Node 1 - SandBox
[root@pdb ~]# ll /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Oct 21 10:35 /dev/sda
brw-rw---- 1 root disk 8,  1 Oct 21 10:35 /dev/sda1
brw-rw---- 1 root disk 8,  2 Oct 21 10:35 /dev/sda2
brw-rw---- 1 root disk 8, 16 Oct 22 14:08 /dev/sdb
brw-rw---- 1 root disk 8, 17 Oct 22 14:08 /dev/sdb1
brw-rw---- 1 root disk 8, 32 Oct 22 14:09 /dev/sdc
brw-rw---- 1 root disk 8, 33 Oct 22 14:09 /dev/sdc1
brw-rw---- 1 root disk 8, 48 Oct 22 14:09 /dev/sdd
brw-rw---- 1 root disk 8, 49 Oct 22 14:09 /dev/sdd1
*/

-- Step 58.8 -->> On Node 1 - SandBox
[root@pdb ~]# fdisk -ll | grep sd
/*
Disk /dev/sdc: 400 GiB, 429496729600 bytes, 838860800 sectors
/dev/sdc1        2048 838860799 838858752  400G 83 Linux
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
/dev/sdb1        2048 41943039 41940992  20G 83 Linux
Disk /dev/sda: 250 GiB, 268435456000 bytes, 524288000 sectors
/dev/sda1  *       2048   2099199   2097152    1G 83 Linux
/dev/sda2       2099200 524287999 522188800  249G 8e Linux LVM
Disk /dev/sdd: 200 GiB, 214748364800 bytes, 419430400 sectors
/dev/sdd1        2048 419430399 419428352  200G 83 Linux
*/

-- Step 58.9 -->> On Node 1 - SandBox
[root@pdb ~]# lsblk
/*
NAME              MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                 8:0    0  250G  0 disk
├─sda1              8:1    0    1G  0 part /boot
└─sda2              8:2    0  249G  0 part
  ├─ol_pdb-root   252:0    0   70G  0 lvm  /
  ├─ol_pdb-swap   252:1    0   16G  0 lvm  [SWAP]
  ├─ol_pdb-usr    252:2    0   10G  0 lvm  /usr
  ├─ol_pdb-opt    252:3    0   70G  0 lvm  /opt
  ├─ol_pdb-home   252:4    0   10G  0 lvm  /home
  ├─ol_pdb-var    252:5    0   10G  0 lvm  /var
  ├─ol_pdb-tmp    252:6    0   10G  0 lvm  /tmp
  └─ol_pdb-backup 252:7    0   53G  0 lvm  /backup
sdb                 8:16   0   20G  0 disk
└─sdb1              8:17   0   20G  0 part
sdc                 8:32   0  400G  0 disk
└─sdc1              8:33   0  400G  0 part
sdd                 8:48   0  200G  0 disk
└─sdd1              8:49   0  200G  0 part
sr0                11:0    1  891M  0 rom
*/

-- Step 58.10 -->> On Node 1 - SandBox
[root@pdb ~]# mkfs.xfs -f /dev/sdb1
[root@pdb ~]# mkfs.xfs -f /dev/sdc1
[root@pdb ~]# mkfs.xfs -f /dev/sdd1

-- Step 59 -->> On Node 1 - SandBox
[root@pdb ~]# /usr/sbin/oracleasm createdisk OCR /dev/sdb1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 59.1 -->> On Node 1 - SandBox
[root@pdb ~]# /usr/sbin/oracleasm createdisk DATA /dev/sdd1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 59.2 -->> On Node 1 - SandBox
[root@pdb ~]# /usr/sbin/oracleasm createdisk ARC /dev/sdc1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 59.3 -->> On Node 1 - SandBox
[root@pdb ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 59.4 -->> On Node 1 - SandBox
[root@pdb ~]# oracleasm listdisks
/*
ARC
DATA
OCR
*/

-- Step 60 -->> On Node 1 - SandBox
[root@pdb ~]# ll /dev/oracleasm/disks/
/*
brw-rw---- 1 grid asmadmin 8, 33 Oct 22 14:13 ARC
brw-rw---- 1 grid asmadmin 8, 49 Oct 22 14:13 DATA
brw-rw---- 1 grid asmadmin 8, 17 Oct 22 14:13 OCR
*/

-- Step 61 -->> On Node 1 - SandBox
-- To setup SSH Pass
[root@pdb ~]# su - grid
[grid@pdb ~]$ cd /opt/app/19c/grid/deinstall
[grid@pdb deinstall]$ ./sshUserSetup.sh -user grid -hosts "pdb" -noPromptPassphrase -confirm -advanced
/*
Password: grid
*/

-- Step 62 -->> On Node 1 - SandBox
[grid@pdb ~]$ ssh grid@pdb date
[grid@pdb ~]$ ssh grid@pdb.unidev.org.np date
[grid@pdb ~]$ ssh grid@pdb date && ssh grid@pdb.unidev.org.np date

-- Step 63 -->> On Node 1 - SandBox
-- Bug 30286976: To Solve the Pre-check or any Oracle relavant Installation for rac Setup make compatible version CV_ASSUME_DISTID=OEL7.8
[grid@pdb ~]$ vi /opt/app/19c/grid/cv/admin/cvu_config
/*
# Configuration file for Cluster Verification Utility(CVU)
# Version: 011405
#
# NOTE:
# 1._ Any line without a '=' will be ignored
# 2._ Since the fallback option will look into the environment variables,
#     please have a component prefix(CV_) for each property to define a
#     namespace.
#


#Nodes for the cluster. If CRS home is not installed, this list will be
#picked up when -n all is mentioned in the commandline argument.
#CV_NODE_ALL=

#if enabled, cvuqdisk rpm is required on all nodes
CV_RAW_CHECK_ENABLED=TRUE

# Fallback to this distribution id
CV_ASSUME_DISTID=OEL7.6

#Complete file system path of sudo binary file, default is /usr/local/bin/sudo
CV_SUDO_BINARY_LOCATION=/usr/local/bin/sudo

#Complete file system path of pbrun binary file, default is /usr/local/bin/pbrun
CV_PBRUN_BINARY_LOCATION=/usr/local/bin/pbrun

# Whether X-Windows check should be performed for user equivalence with SSH
#CV_XCHK_FOR_SSH_ENABLED=TRUE

# To override SSH location
#ORACLE_SRVM_REMOTESHELL=/usr/bin/ssh

# To override SCP location
#ORACLE_SRVM_REMOTECOPY=/usr/bin/scp

# To override version used by command line parser
CV_ASSUME_CL_VERSION=19.1.0.0.0

# Location of the browser to be used to display HTML report
#CV_DEFAULT_BROWSER_LOCATION=/usr/bin/mozilla

# Maximum number of retries for discover DHCP server
#CV_MAX_RETRIES_DHCP_DISCOVERY=5

# Maximum CVU trace files size (in multiples of 100 MB)
#CV_TRACE_SIZE_MULTIPLIER=1
*/

-- Step 63.1 -->> On Node 1 - SandBox
[grid@pdb ~]$ cat /opt/app/19c/grid/cv/admin/cvu_config | grep -E CV_ASSUME_DISTID
/*
CV_ASSUME_DISTID=OEL7.6
*/

-- Step 64 -->> On Node 1
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

-- Step 64.1 -->> On Node 1 - SandBox
[root@pdb ~]# cp -p /usr/bin/scp /usr/bin/scp-original

-- Step 64.2 -->> On Node 1 - SandBox
[root@pdb ~]# echo "/usr/bin/scp-original -T \$*" > /usr/bin/scp

-- Step 64.3 -->> On Node 1 - SandBox
[root@pdb ~]# cat /usr/bin/scp
/*
/usr/bin/scp-original -T $*
*/

-- Step 65 -->> On Node 1 - SandBox
-- Pre-check for rac Setup
[grid@pdb ~]$ cd /opt/app/19c/grid/
[grid@pdb grid]$ export CV_ASSUME_DISTID=OEL7.6
[grid@pdb grid]$ ./runcluvfy.sh stage -pre crsinst -n pdb -verbose
[grid@pdb grid]$ export CV_ASSUME_DISTID=OEL7.6
[grid@pdb grid]$ ./runcluvfy.sh stage -pre crsinst -n pdb -method root
--[grid@pdb grid]$ ./runcluvfy.sh stage -pre crsinst -n pdb1,pdb2 -fixup -verbose (If Required)
-- grid

-- Step 66 -->> On Node 1 - SandBox
-- To Create a Response File to Install GID
[grid@pdb ~]$ cp /opt/app/19c/grid/install/response/gridsetup.rsp /home/grid/
[grid@pdb ~]$ cd /home/grid/
[grid@pdb ~]$ ll gridsetup.rsp
/*
-rwxr-xr-x 1 grid oinstall 36221 Oct 22 14:21 gridsetup.rsp
*/

-- Step 66.1 -->> On Node 1 - SandBox
[grid@pdb ~]$ vi gridsetup.rsp
--Bug 30878668
--The sudo option for running root configuration scripts does not work during Oracle Database 19c 
--or Oracle Grid Infrastructure 19c installations on Oracle Linux 8 
--or Red Hat Enterprise Linux 8 systems.
/*
oracle.install.responseFileVersion=/oracle/install/rspfmt_crsinstall_response_schema_v19.0.0
INVENTORY_LOCATION=/opt/app/oraInventory
SELECTED_LANGUAGES=en,en_GB
oracle.install.option=CRS_CONFIG
ORACLE_BASE=/opt/app/oracle
oracle.install.asm.OSDBA=asmdba
oracle.install.asm.OSOPER=asmoper
oracle.install.asm.OSASM=asmadmin
oracle.install.crs.config.scanType=LOCAL_SCAN
oracle.install.crs.config.gpnp.scanName=pdbm-scan
oracle.install.crs.config.gpnp.scanPort=1521
oracle.install.crs.config.ClusterConfiguration=STANDALONE
oracle.install.crs.config.configureAsExtendedCluster=false
oracle.install.crs.config.clusterName=Clean-Cluster
oracle.install.crs.config.gpnp.configureGNS=false
oracle.install.crs.config.autoConfigureClusterNodeVIP=false
oracle.install.crs.config.clusterNodes=pdb:pdb-vip
oracle.install.crs.config.networkInterfaceList=ens160:192.16.6.0:1,ens192:10.10.10.0:5
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

-- Step 67 -->> On Node 1 - SandBox
[grid@pdb ~]$ cd /opt/app/19c/grid/
[grid@pdb grid]$ OPatch/opatch version
/*
OPatch Version: 12.2.0.1.43

OPatch succeeded.
*/

-- Step 68 -->> On Node 1 - SandBox
-- To Install Grid Software with Leteset Opatch
[grid@pdb ~]$ cd /opt/app/19c/grid/
[grid@pdb grid]$ export CV_ASSUME_DISTID=OEL7.6
[grid@pdb grid]$ ./gridSetup.sh -ignorePrereq -waitForCompletion -silent -applyRU /tmp/36209493/36233126 -responseFile /home/grid/gridsetup.rsp
/*
Preparing the home to patch...
Applying the patch /tmp/36209493/36233126...
Successfully applied the patch.
The log can be found at: /tmp/GridSetupActions2024-10-22_02-36-53PM/installerPatchActions_2024-10-22_02-36-53PM.log
Launching Oracle Grid Infrastructure Setup Wizard...

[WARNING] [INS-13014] Target environment does not meet some optional requirements.
   CAUSE: Some of the optional prerequisites are not met. See logs for details. gridSetupActions2024-10-22_02-36-53PM.log
   ACTION: Identify the list of failed prerequisite checks from the log: gridSetupActions2024-10-22_02-36-53PM.log. Then either from the log file or from installation manual find the appropriate configuration to meet the prerequisites and fix it manually.
The response file for this session can be found at:
 /opt/app/19c/grid/install/response/grid_2024-10-22_02-36-53PM.rsp

You can find the log of this install session at:
 /tmp/GridSetupActions2024-10-22_02-36-53PM/gridSetupActions2024-10-22_02-36-53PM.log

As a root user, execute the following script(s):
        1. /opt/app/oraInventory/orainstRoot.sh
        2. /opt/app/19c/grid/root.sh

Execute /opt/app/oraInventory/orainstRoot.sh on the following nodes:
[pdb]
Execute /opt/app/19c/grid/root.sh on the following nodes:
[pdb]



Successfully Setup Software with warning(s).
As install user, execute the following command to complete the configuration.
        /opt/app/19c/grid/gridSetup.sh -executeConfigTools -responseFile /home/grid/gridsetup.rsp [-silent]


Moved the install session logs to:
 /opt/app/oraInventory/logs/GridSetupActions2024-10-22_02-36-53PM
*/

-- Step 69 -->> On Node 1 - SandBox
--[root@pdb ~]# export CV_ASSUME_DISTID=OEL7.6
[root@pdb ~]# /opt/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 70 -->> On Node 1 - SandBox
--[root@pdb ~]# export CV_ASSUME_DISTID=OEL7.6
[root@pdb ~]# /opt/app/19c/grid/root.sh
/*
Check  /opt/app/19c/grid/install/root_pdb.unidev.org.np_2024-10-22_14-54-25-199775901.log for the output of root script
*/

-- Step 70.1 -->> On Node 1 - SandBox 
[root@pdb ~]# tail -f /opt/app/19c/grid/install/root_pdb.unidev.org.np_2024-10-22_14-54-25-199775901.log
/*
Creating /etc/oratab file...
Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Relinking oracle with rac_on option
Smartmatch is deprecated at /opt/app/19c/grid/crs/install/crsupgrade.pm line 6512.
Using configuration parameter file: /opt/app/19c/grid/crs/install/crsconfig_params
The log of current session can be found at:
  /opt/app/oracle/crsdata/pdb/crsconfig/rootcrs_pdb_2024-10-22_02-54-46PM.log
2024/10/22 14:54:54 CLSRSC-594: Executing installation step 1 of 19: 'ValidateEnv'.
2024/10/22 14:54:54 CLSRSC-363: User ignored prerequisites during installation
2024/10/22 14:54:54 CLSRSC-594: Executing installation step 2 of 19: 'CheckFirstNode'.
2024/10/22 14:54:57 CLSRSC-594: Executing installation step 3 of 19: 'GenSiteGUIDs'.
2024/10/22 14:54:58 CLSRSC-594: Executing installation step 4 of 19: 'SetupOSD'.
Redirecting to /bin/systemctl restart rsyslog.service
2024/10/22 14:54:58 CLSRSC-594: Executing installation step 5 of 19: 'CheckCRSConfig'.
2024/10/22 14:54:58 CLSRSC-594: Executing installation step 6 of 19: 'SetupLocalGPNP'.
2024/10/22 14:55:14 CLSRSC-594: Executing installation step 7 of 19: 'CreateRootCert'.
2024/10/22 14:55:18 CLSRSC-594: Executing installation step 8 of 19: 'ConfigOLR'.
2024/10/22 14:55:33 CLSRSC-594: Executing installation step 9 of 19: 'ConfigCHMOS'.
2024/10/22 14:55:33 CLSRSC-594: Executing installation step 10 of 19: 'CreateOHASD'.
2024/10/22 14:55:39 CLSRSC-594: Executing installation step 11 of 19: 'ConfigOHASD'.
2024/10/22 14:55:39 CLSRSC-330: Adding Clusterware entries to file 'oracle-ohasd.service'
2024/10/22 14:56:05 CLSRSC-594: Executing installation step 12 of 19: 'SetupTFA'.
2024/10/22 14:56:05 CLSRSC-594: Executing installation step 13 of 19: 'InstallAFD'.
2024/10/22 14:56:05 CLSRSC-594: Executing installation step 14 of 19: 'InstallACFS'.
2024/10/22 14:56:54 CLSRSC-594: Executing installation step 15 of 19: 'InstallKA'.
2024/10/22 14:56:59 CLSRSC-594: Executing installation step 16 of 19: 'InitConfig'.

ASM has been created and started successfully.

[DBT-30001] Disk groups created successfully. Check /opt/app/oracle/cfgtoollogs/asmca/asmca-241022PM025745.l            og for details.

2024/10/22 14:58:44 CLSRSC-482: Running command: '/opt/app/19c/grid/bin/ocrconfig -upgrade grid oinstall'
CRS-4256: Updating the profile
Successful addition of voting disk 9cb3c1dc8b694f48bf50532c0907e357.
Successfully replaced voting disk group with +OCR.
CRS-4256: Updating the profile
CRS-4266: Voting file(s) successfully replaced
##  STATE    File Universal Id                File Name Disk group
--  -----    -----------------                --------- ---------
 1. ONLINE   9cb3c1dc8b694f48bf50532c0907e357 (/dev/oracleasm/disks/OCR) [OCR]
Located 1 voting disk(s).
2024/10/22 14:59:38 CLSRSC-594: Executing installation step 17 of 19: 'StartCluster'.
2024/10/22 14:59:45 CLSRSC-4002: Successfully installed Oracle Trace File Analyzer (TFA) Collector.
2024/10/22 15:00:45 CLSRSC-343: Successfully started Oracle Clusterware stack
2024/10/22 15:00:45 CLSRSC-594: Executing installation step 18 of 19: 'ConfigNode'.
2024/10/22 15:02:18 CLSRSC-594: Executing installation step 19 of 19: 'PostConfig'.
2024/10/22 15:02:46 CLSRSC-325: Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 71 -->> On Node 1 - SandBox
[grid@pdb ~]$ cd /opt/app/19c/grid/
[grid@pdb grid]$ export CV_ASSUME_DISTID=OEL7.6
[grid@pdb grid]$ /opt/app/19c/grid/gridSetup.sh -silent -executeConfigTools -responseFile /home/grid/gridsetup.rsp
/*
Launching Oracle Grid Infrastructure Setup Wizard...

You can find the logs of this session at:
/opt/app/oraInventory/logs/GridSetupActions2024-10-22_03-03-43PM

You can find the log of this install session at:
 /opt/app/oraInventory/logs/UpdateNodeList2024-10-22_03-03-43PM.log
Successfully Configured Software.
*/

-- Step 71.1 -->> On Node 1 - SandBox
[root@pdb ~]# tail -f /opt/app/oraInventory/logs/UpdateNodeList2024-10-22_03-03-43PM.log
/*
                Interim Patch# 29585399
                Interim Patch# 36233263
                Interim Patch# 36233343
                Interim Patch# 36240578
                Interim Patch# 36383196
                Interim Patch# 36460248

INFO: Checkpoint:Index file written and updated
INFO: Done calling doOperation.
INFO: 'UpdateNodeList' was successful.
*/

-- Step 72 -->> On Node 1 - SandBox
[root@pdb ~]# cd /opt/app/19c/grid/bin/
[root@pdb bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/


-- Step 73 -->> On Node 1 - SandBox
[root@pdb ~]# cd /opt/app/19c/grid/bin/
[root@pdb bin]# ./crsctl check cluster -all
/*
**************************************************************
pdb:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/

-- Step 74 -->> On Node 1 - SandBox
[root@pdb ~]# cd /opt/app/19c/grid/bin/
[root@pdb bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdb                      Started,STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       pdb                      STABLE
ora.crf
      1        ONLINE  ONLINE       pdb                      STABLE
ora.crsd
      1        ONLINE  ONLINE       pdb                      STABLE
ora.cssd
      1        ONLINE  ONLINE       pdb                      STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       pdb                      STABLE
ora.ctssd
      1        ONLINE  ONLINE       pdb                      OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.drivers.acfs
      1        ONLINE  ONLINE       pdb                      STABLE
ora.evmd
      1        ONLINE  ONLINE       pdb                      STABLE
ora.gipcd
      1        ONLINE  ONLINE       pdb                      STABLE
ora.gpnpd
      1        ONLINE  ONLINE       pdb                      STABLE
ora.mdnsd
      1        ONLINE  ONLINE       pdb                      STABLE
ora.storage
      1        ONLINE  ONLINE       pdb                      STABLE
--------------------------------------------------------------------------------
*/


-- Step 75 -->> On Node 1 - SandBox
[root@pdb ~]# cd /opt/app/19c/grid/bin/
[root@pdb bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       pdb                      STABLE
ora.chad
               ONLINE  ONLINE       pdb                      STABLE
ora.net1.network
               ONLINE  ONLINE       pdb                      STABLE
ora.ons
               ONLINE  ONLINE       pdb                      STABLE
ora.proxy_advm
               OFFLINE OFFLINE      pdb                      STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdb                      STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdb                      STABLE
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       pdb                      STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      Started,STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      STABLE
ora.cvu
      1        ONLINE  ONLINE       pdb                      STABLE
ora.pdb.vip
      1        ONLINE  ONLINE       pdb                      STABLE
ora.qosmserver
      1        ONLINE  ONLINE       pdb                      STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       pdb                      STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       pdb                      STABLE
ora.scan3.vip
      1        ONLINE  ONLINE       pdb                      STABLE
--------------------------------------------------------------------------------
*/

-- Step 76 -->> On Node 1 - SandBox
[grid@pdb ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20180                0           20180              0             Y  OCR/
ASMCMD [+] > exit
*/

-- Step 77 -->> On Node 1 - SandBox
[grid@pdb ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 22-OCT-2024 15:07:35

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                22-OCT-2024 15:02:39
Uptime                    0 days 0 hr. 4 min. 57 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.30)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.31)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 77.1 -->> On Node 1 - SandBox
[grid@pdb ~]$ ps -ef | grep SCAN
/*
grid      109381       1  0 15:01 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid      109480       1  0 15:02 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid      109516       1  0 15:02 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid      133961  132672  0 15:07 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 77.2 -->> On Node 1 - SandBox
[grid@pdb ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 22-OCT-2024 15:08:11

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                22-OCT-2024 15:02:00
Uptime                    0 days 0 hr. 6 min. 11 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.32)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 77.3 -->> On Node 1 - SandBox
[grid@pdb ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 22-OCT-2024 15:08:23

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                22-OCT-2024 15:02:02
Uptime                    0 days 0 hr. 6 min. 21 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.33)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 77.3 -->> On Node 1 - SandBox
[grid@pdb ~]$ lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 22-OCT-2024 15:08:51

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                22-OCT-2024 15:02:03
Uptime                    0 days 0 hr. 6 min. 47 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb/listener_scan3/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN3)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.34)(PORT=1521)))
The listener supports no services
The command completed successfully
*/
-- Step 78 -->> On Node 1 - SandBox
-- To Create ASM storage for Data and Archive 
[grid@pdb ~]$ cd /opt/app/19c/grid/bin
[grid@pdb bin]$ export CV_ASSUME_DISTID=OEL7.6

-- Step 78.1 -->> On Node 1 - SandBox
[grid@pdb bin]$ ./asmca -silent -createDiskGroup -diskGroupName DATA -diskList /dev/oracleasm/disks/DATA -redundancy EXTERNAL

-- Step 78.2 -->> On Node 1 - SandBox
[grid@pdb bin]$ ./asmca -silent -createDiskGroup -diskGroupName ARC -diskList /dev/oracleasm/disks/ARC -redundancy EXTERNAL

-- Step 79 -->> On Node 1 - SandBox
[grid@pdb ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue Oct 22 15:10:58 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> set lines 200;
SQL> COLUMN name FORMAT A30
SQL> SELECT inst_id,name,state,type,compatibility,database_compatibility,voting_files FROM gv$asm_diskgroup order by name;

   INST_ID NAME   STATE       TYPE   COMPATIBILITY DATABASE_COMPATIBILITY V
---------- ------ ----------- ------ ------------- ---------------------- -
         1 ARC    MOUNTED     EXTERN 19.0.0.0.0    10.1.0.0.0             N
         1 DATA   MOUNTED     EXTERN 19.0.0.0.0    10.1.0.0.0             N
         1 OCR    MOUNTED     EXTERN 19.0.0.0.0    10.1.0.0.0             Y

SQL> set lines 200;
SQL> col path format a40;
SQL> SELECT name,path, group_number group_#, disk_number disk_#, mount_status,header_status, state, total_mb, free_mb FROM v$asm_disk order by group_number;

NAME      PATH                      GROUP_# DISK_# MOUNT_S HEADER_STATU STATE  TOTAL_MB FREE_MB
--------- ------------------------- ------- ------ ------- ------------ ------ -------- --------
OCR_0000  /dev/oracleasm/disks/OCR        1      0 CACHED  MEMBER       NORMAL    20476   20180
DATA_0000 /dev/oracleasm/disks/DATA       2      0 CACHED  MEMBER       NORMAL   204799  204733
ARC_0000  /dev/oracleasm/disks/ARC        3      0 CACHED  MEMBER       NORMAL   409599  409529


SQL> set lines 200;
SQL> col BANNER_FULL format a80;
SQL> col BANNER_LEGACY format a80;
SQL> SELECT inst_id,banner_full,banner_legacy,con_id FROM gv$version;

   INST_ID BANNER_FULL                                                                      BANNER_LEGACY                                                                        CON_ID
---------- -------------------------------------------------------------------------------- -------------------------------------------------------------------------------- ----------
         1 Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production           Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production                    0
           Version 19.23.0.0.0

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 80 -->> On Node 1 - SandBox
[root@pdb ~]# cd /opt/app/19c/grid/bin
[root@pdb bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       pdb                      STABLE
ora.chad
               ONLINE  ONLINE       pdb                      STABLE
ora.net1.network
               ONLINE  ONLINE       pdb                      STABLE
ora.ons
               ONLINE  ONLINE       pdb                      STABLE
ora.proxy_advm
               OFFLINE OFFLINE      pdb                      STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ARC.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      STABLE
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      STABLE
ora.DATA.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdb                      STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdb                      STABLE
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       pdb                      STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      Started,STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      STABLE
ora.cvu
      1        ONLINE  ONLINE       pdb                      STABLE
ora.pdb.vip
      1        ONLINE  ONLINE       pdb                      STABLE
ora.qosmserver
      1        ONLINE  ONLINE       pdb                      STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       pdb                      STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       pdb                      STABLE
ora.scan3.vip
      1        ONLINE  ONLINE       pdb                      STABLE
--------------------------------------------------------------------------------
*/

-- Step 81 -->> On Node 1 - SandBox
[grid@pdb ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  1048576    409599   409529                0          409529              0             N  ARC/
MOUNTED  EXTERN  N         512             512   4096  1048576    204799   204733                0          204733              0             N  DATA/
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20180                0           20180              0             Y  OCR/
ASMCMD [+] > exit
*/

-- Step 82 -->> On Node 1 - SandBox
[root@pdb ~]# vi /etc/oratab
/*
+ASM1:/opt/app/19c/grid:N
*/

-- Step 83 -->> On Node 1 - SandBox
-- Creating the Oracle RDBMS Home Directory
[root@pdb ~]# mkdir -p /opt/app/oracle/product/19c/db_1
[root@pdb ~]# chown -R oracle:oinstall /opt/app/oracle/product/19c/db_1
[root@pdb ~]# chmod -R 775 /opt/app/oracle/product/19c/db_1

-- Step 84 -->> On Node 1 - SandBox
-- To unzip the Oracle Binary and Letest Opatch
[root@pdb ~]# cd /opt/app/oracle/product/19c/db_1
[root@pdb db_1]# unzip -oq /root/Oracle_19C/19.3.0.0.0_DB_Binary/LINUX.X64_193000_db_home.zip
[root@pdb db_1]# unzip -oq /root/Oracle_19C/OPATCH_19c/p6880880_190000_Linux-x86-64.zip

-- Step 84.1 -->> On Node 1 - SandBox
[root@pdb ~]# chown -R oracle:oinstall /opt/app/oracle/product/19c/db_1/
[root@pdb ~]# chmod -R 775 /opt/app/oracle/product/19c/db_1/

-- Step 85 -->> On Node 1 - SandBox
[root@pdb ~]# su - oracle
[oracle@pdb ~]$ /opt/app/oracle/product/19c/db_1/OPatch/opatch version
/*
OPatch Version: 12.2.0.1.43

OPatch succeeded.
*/

-- Step 86 -->> On Node 1 - SandBox
-- To Setup the SSH Connectivity 
[root@pdb ~]# su - oracle
[oracle@pdb ~]$ cd /opt/app/oracle/product/19c/db_1/deinstall/
[oracle@pdb deinstall]$ ./sshUserSetup.sh -user oracle -hosts "pdb" -noPromptPassphrase -confirm -advanced
/*
Password: oracle
*/

-- Step 87 -->> On Node 1 - SandBox
[oracle@pdb ~]$ ssh oracle@pdb date
[oracle@pdb ~]$ ssh oracle@pdb.unidev.org.np date
[oracle@pdb ~]$ ssh oracle@pdb date && ssh oracle@pdb.unidev.org.np date

-- Step 88 -->> On Node 1 - SandBox
-- To Create a responce file for Oracle Software Installation
[oracle@pdb ~]$ cp /opt/app/oracle/product/19c/db_1/install/response/db_install.rsp /home/oracle/
[oracle@pdb ~]$ cd /home/oracle/

-- Step 88.1 -->> On Node 1 - SandBox
[oracle@pdb ~]$ ll db_install.rsp
/*
-rwxr-xr-x 1 oracle oinstall 19932 Oct 22 15:18 db_install.rsp
*/

-- Step 88.2 -->> On Node 1 - SandBox
[oracle@pdb ~]$ vi db_install.rsp
/*
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v19.0.0
oracle.install.option=INSTALL_DB_SWONLY
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/opt/app/oraInventory
ORACLE_HOME=/opt/app/oracle/product/19c/db_1
ORACLE_BASE=/opt/app/oracle
oracle.install.db.InstallEdition=EE
ORACLE_HOSTNAME=pdb.unidev.org.np
SELECTED_LANGUAGES=en,en_GB
oracle.install.db.OSDBA_GROUP=dba
oracle.install.db.OSOPER_GROUP=oper
oracle.install.db.OSBACKUPDBA_GROUP=backupdba
oracle.install.db.OSDGDBA_GROUP=dgdba
oracle.install.db.OSKMDBA_GROUP=kmdba
oracle.install.db.OSRACDBA_GROUP=racdba
oracle.install.db.rootconfig.executeRootScript=false
oracle.install.db.CLUSTER_NODES=pdb
oracle.install.db.config.starterdb.type=GENERAL_PURPOSE
oracle.install.db.ConfigureAsContainerDB=false
*/

-- Step 89 -->> On Node 1 - SandBox
[oracle@pdb ~]$ vi /opt/app/oracle/product/19c/db_1/cv/admin/cvu_config
/*
# Configuration file for Cluster Verification Utility(CVU)
# Version: 011405
#
# NOTE:
# 1._ Any line without a '=' will be ignored
# 2._ Since the fallback option will look into the environment variables,
#     please have a component prefix(CV_) for each property to define a
#     namespace.
#


#Nodes for the cluster. If CRS home is not installed, this list will be
#picked up when -n all is mentioned in the commandline argument.
#CV_NODE_ALL=

#if enabled, cvuqdisk rpm is required on all nodes
CV_RAW_CHECK_ENABLED=TRUE

# Fallback to this distribution id
CV_ASSUME_DISTID=OEL7.6

#Complete file system path of sudo binary file, default is /usr/local/bin/sudo
CV_SUDO_BINARY_LOCATION=/usr/local/bin/sudo

#Complete file system path of pbrun binary file, default is /usr/local/bin/pbrun
CV_PBRUN_BINARY_LOCATION=/usr/local/bin/pbrun

# Whether X-Windows check should be performed for user equivalence with SSH
#CV_XCHK_FOR_SSH_ENABLED=TRUE

# To override SSH location
#ORACLE_SRVM_REMOTESHELL=/usr/bin/ssh

# To override SCP location
#ORACLE_SRVM_REMOTECOPY=/usr/bin/scp

# To override version used by command line parser
CV_ASSUME_CL_VERSION=19.1.0.0.0

# Location of the browser to be used to display HTML report
#CV_DEFAULT_BROWSER_LOCATION=/usr/bin/mozilla

# Maximum number of retries for discover DHCP server
#CV_MAX_RETRIES_DHCP_DISCOVERY=5

# Maximum CVU trace files size (in multiples of 100 MB)
#CV_TRACE_SIZE_MULTIPLIER=1
*/

-- Step 89.1 -->> On Node 1 - SandBox
[oracle@pdb ~]$ cat /opt/app/oracle/product/19c/db_1/cv/admin/cvu_config | grep -E 'CV_ASSUME_DISTID'
/*
CV_ASSUME_DISTID=OEL7.6
*/

-- Step 90 -->> On Node 1 - SandBox
-- To install Oracle Software with Letest Opatch
[oracle@pdb ~]$ cd /opt/app/oracle/product/19c/db_1/
[oracle@pdb db_1]$ export CV_ASSUME_DISTID=OEL7.6
[oracle@pdb db_1]$ ./runInstaller -ignorePrereq -waitforcompletion -silent \
-applyRU /tmp/36209493/36233126                                             \
-responseFile /home/oracle/db_install.rsp                                   \
oracle.install.db.isRACOneInstall=false                                     \
oracle.install.db.rac.serverpoolCardinality=0                               \
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false                                  \
DECLINE_SECURITY_UPDATES=true

/*
Preparing the home to patch...
Applying the patch /tmp/36209493/36233126...
Successfully applied the patch.
The log can be found at: /opt/app/oraInventory/logs/InstallActions2024-10-22_03-23-08PM/installerPatchActions_2024-10-22_03-23-08PM.log
Launching Oracle Database Setup Wizard...

The response file for this session can be found at:
 /opt/app/oracle/product/19c/db_1/install/response/db_2024-10-22_03-23-08PM.rsp

You can find the log of this install session at:
 /opt/app/oraInventory/logs/InstallActions2024-10-22_03-23-08PM/installActions2024-10-22_03-23-08PM.log

As a root user, execute the following script(s):
        1. /opt/app/oracle/product/19c/db_1/root.sh

Execute /opt/app/oracle/product/19c/db_1/root.sh on the following nodes:
[pdb]


Successfully Setup Software.
*/

-- Step 90.1 -->> On Node 1 - SandBox
[root@pdb ~]# /opt/app/oracle/product/19c/db_1/root.sh
/*
Check /opt/app/oracle/product/19c/db_1/install/root_pdb.unidev.org.np_2024-10-22_15-44-28-135570242.log for the output of root script
*/

-- Step 90.2 -->> On Node 1 - SandBox
[root@pdb ~]# tail -f /opt/app/oracle/product/19c/db_1/install/root_pdb.unidev.org.np_2024-10-22_15-44-28-135570242.log
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

-- Step 91 -->> On Node 1 - SandBox
-- To applying the Oracle PSU on Node 1
[root@pdb ~]# cd /tmp/
[root@pdb tmp]$ export CV_ASSUME_DISTID=OEL7.6
[root@pdb tmp]# export ORACLE_HOME=/opt/app/oracle/product/19c/db_1
[root@pdb tmp]# export PATH=${ORACLE_HOME}/bin:$PATH
[root@pdb tmp]# export PATH=${PATH}:${ORACLE_HOME}/OPatch

-- Step 91.1 -->> On Node 1 - SandBox
[root@pdb tmp]# which opatchauto
/*
/opt/app/oracle/product/19c/db_1/OPatch/opatchauto
*/

-- Step 91.2 -->> On Node 1 - SandBox
[root@pdb tmp]# opatchauto apply /tmp/36209493/36199232 -oh /opt/app/oracle/product/19c/db_1 --nonrolling
/*

OPatchauto session is initiated at Sat Nov  2 11:41:24 2024

System initialization log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchautodb/systemconfig2024-11-02_11-41-30AM.log.

Session log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/opatchauto2024-11-02_11-41-37AM.log
The id for this session is YGLP

Executing OPatch prereq operations to verify patch applicability on home /opt/app/oracle/product/19c/db_1
Patch applicability verified successfully on home /opt/app/oracle/product/19c/db_1


Executing patch validation checks on home /opt/app/oracle/product/19c/db_1
Patch validation checks successfully completed on home /opt/app/oracle/product/19c/db_1


Verifying SQL patch applicability on home /opt/app/oracle/product/19c/db_1
No sqlpatch prereq operations are required on the local node for this home
No step execution required.........


Preparing to bring down database service on home /opt/app/oracle/product/19c/db_1
No step execution required.........


Bringing down database service on home /opt/app/oracle/product/19c/db_1
Database service successfully brought down on home /opt/app/oracle/product/19c/db_1


Performing prepatch operation on home /opt/app/oracle/product/19c/db_1
Prepatch operation completed successfully on home /opt/app/oracle/product/19c/db_1


Start applying binary patch on home /opt/app/oracle/product/19c/db_1

Binary patch applied successfully on home /opt/app/oracle/product/19c/db_1


Running rootadd_rdbms.sh on home /opt/app/oracle/product/19c/db_1
Successfully executed rootadd_rdbms.sh on home /opt/app/oracle/product/19c/db_1


Performing postpatch operation on home /opt/app/oracle/product/19c/db_1
Postpatch operation completed successfully on home /opt/app/oracle/product/19c/db_1


Starting database service on home /opt/app/oracle/product/19c/db_1
Database service successfully started on home /opt/app/oracle/product/19c/db_1


Preparing home /opt/app/oracle/product/19c/db_1 after database service restarted
No step execution required.........


Trying to apply SQL patch on home /opt/app/oracle/product/19c/db_1
No SQL patch operations are required on local node for this home

OPatchAuto successful.

--------------------------------Summary--------------------------------

Patching is completed successfully. Please find the summary as follows:

Host:pdb
RAC Home:/opt/app/oracle/product/19c/db_1
Version:19.0.0.0.0
Summary:

==Following patches were SUCCESSFULLY applied:

Patch: /tmp/36209493/36199232
Log: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2024-11-02_11-42-47AM_1.log



OPatchauto session completed at Sat Nov  2 11:45:18 2024
Time taken to complete the session 3 minutes, 54 seconds
*/

-- Step 91.3 -->> On Node 1 - SandBox
[root@pdb ~]#  tail -f /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2024-11-02_11-42-47AM_1.log
/*
[Nov 2, 2024 11:45:16 AM] [INFO]    Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/NApply/2024-11-02_11-42-47AM/restore.sh"
[Nov 2, 2024 11:45:16 AM] [INFO]    Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/NApply/2024-11-02_11-42-47AM/make.txt"
[Nov 2, 2024 11:45:16 AM] [INFO]    Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/36199232_Mar_12_2024_17_07_05/scratch/joxwtp.o"
[Nov 2, 2024 11:45:16 AM] [INFO]    [OPSR-TIME] Backup area for restore has been cleaned up. For a complete list of files/directories deleted, Please refer log file.
[Nov 2, 2024 11:45:16 AM] [INFO]    Patch 36199232 successfully applied.
[Nov 2, 2024 11:45:16 AM] [INFO]    UtilSession: N-Apply done.
[Nov 2, 2024 11:45:16 AM] [INFO]    Finishing UtilSession at Sat Nov 02 11:45:16 NPT 2024
[Nov 2, 2024 11:45:16 AM] [INFO]    Log file location: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2024-11-02_11-42-47AM_1.log
[Nov 2, 2024 11:45:16 AM] [INFO]    EXITING METHOD: NApply(patches,options)
*/

-- Step 92 -->> On Node 1 - SandBox
-- To Create a Oracle Database
[root@pdb ~]# mkdir -p /opt/app/oracle/admin/pdbdb/adump
[root@pdb ~]# cd /opt/app/oracle/admin/
[root@pdb ~]# chown -R oracle:oinstall pdbdb/
[root@pdb ~]# chmod -R 775 pdbdb/

-- Step 93 -->> On Node 1 - SandBox
[root@pdb ~]# su - oracle
[oracle@pdb ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 02-NOV-2024 11:59:22

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                22-OCT-2024 15:02:39
Uptime                    10 days 20 hr. 56 min. 44 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.30)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.31)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 94 -->> On Node 1 - SandBox
[root@pdb ~]# su - grid
[grid@pdb ~]$ asmcmd -p
/*
ASMCMD [+] > ls
ARC/
DATA/
OCR/

ASMCMD [+] > cd +ARC
ASMCMD [+ARC] > ls
ASMCMD [+ARC] > mkdir PDBDB
ASMCMD [+ARC] > ls
PDBDB/
ASMCMD [+ARC] > cd PDBDB/
ASMCMD [+ARC/PDBDB] > mkdir CONTROLFILE
ASMCMD [+ARC/PDBDB] > mkdir AUTOBACKUP
ASMCMD [+ARC/PDBDB] > mkdir ARCHIVELOG
ASMCMD [+ARC/PDBDB] > ls
ARCHIVELOG/
AUTOBACKUP/
CONTROLFILE/
ASMCMD [+ARC/PDBDB] > cd ..
ASMCMD [+ARC] > cd ..
ASMCMD [+] > ls
ARC/
DATA/
OCR/

ASMCMD [+] > cd +DATA
ASMCMD [+DATA] > ls
ASMCMD [+DATA] > mkdir PDBDB
ASMCMD [+DATA] > ls
PDBDB/
ASMCMD [+DATA] > cd PDBDB
ASMCMD [+DATA/PDBDB] > ls
ASMCMD [+DATA/PDBDB] > mkdir CONTROLFILE
ASMCMD [+DATA/PDBDB] > mkdir DATAFILE
ASMCMD [+DATA/PDBDB] > mkdir ONLINELOG
ASMCMD [+DATA/PDBDB] > mkdir PARAMETERFILE
ASMCMD [+DATA/PDBDB] > mkdir PASSWORD
ASMCMD [+DATA/PDBDB] > mkdir TEMPFILE
ASMCMD [+DATA/PDBDB] > ls
CONTROLFILE/
DATAFILE/
ONLINELOG/
PARAMETERFILE/
PASSWORD/
TEMPFILE/
ASMCMD [+DATA/PDBDB] > mkdir 23519278369E2978E063150610ACF012/
ASMCMD [+DATA/PDBDB] > mkdir 2351E15D26626035E063150610AC7E23/
ASMCMD [+DATA/PDBDB] > mkdir 86B637B62FE07A65E053F706E80A27CA/
ASMCMD [+DATA/PDBDB] > ls
23519278369E2978E063150610ACF012/
2351E15D26626035E063150610AC7E23/
86B637B62FE07A65E053F706E80A27CA/
CONTROLFILE/
DATAFILE/
ONLINELOG/
PARAMETERFILE/
PASSWORD/
TEMPFILE/
ASMCMD [+DATA/PDBDB] > cd 23519278369E2978E063150610ACF012/
ASMCMD [+DATA/PDBDB/23519278369E2978E063150610ACF012] > ls
ASMCMD [+DATA/PDBDB/23519278369E2978E063150610ACF012] > mkdir TEMPFILE/
ASMCMD [+DATA/PDBDB/23519278369E2978E063150610ACF012] > ls
TEMPFILE/
ASMCMD [+DATA/PDBDB/23519278369E2978E063150610ACF012] > cd ..
ASMCMD [+DATA/PDBDB] > cd 2351E15D26626035E063150610AC7E23/
ASMCMD [+DATA/PDBDB/2351E15D26626035E063150610AC7E23] > ls
ASMCMD [+DATA/PDBDB/2351E15D26626035E063150610AC7E23] > mkdir DATAFILE/
ASMCMD [+DATA/PDBDB/2351E15D26626035E063150610AC7E23] > mkdir TEMPFILE/
ASMCMD [+DATA/PDBDB/2351E15D26626035E063150610AC7E23] > ls
DATAFILE/
TEMPFILE/
ASMCMD [+DATA/PDBDB/2351E15D26626035E063150610AC7E23] > cd ..
ASMCMD [+DATA/PDBDB] > cd 86B637B62FE07A65E053F706E80A27CA/
ASMCMD [+DATA/PDBDB/86B637B62FE07A65E053F706E80A27CA] > ls
ASMCMD [+DATA/PDBDB/86B637B62FE07A65E053F706E80A27CA] > mkdir DATAFILE/
ASMCMD [+DATA/PDBDB/86B637B62FE07A65E053F706E80A27CA] > ls
DATAFILE/
ASMCMD [+DATA/PDBDB/86B637B62FE07A65E053F706E80A27CA] > cd ..
ASMCMD [+DATA/PDBDB] > ls
23519278369E2978E063150610ACF012/
2351E15D26626035E063150610AC7E23/
86B637B62FE07A65E053F706E80A27CA/
CONTROLFILE/
DATAFILE/
ONLINELOG/
PARAMETERFILE/
PASSWORD/
TEMPFILE/
ASMCMD [+DATA/PDBDB] > exit
*/

-- Step 95 -->> On Node 1 - DC
[oracle@pdb1 ~]$ mkdir -p /backup/configfiles
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sat Nov 2 12:25:52 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> create pfile='/backup/configfiles/spfilepdbdb.ora' from spfile;

File created.

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 96 -->> On Node 1 - DC
[root@pdb1 ~]# su - grid
[grid@pdb1 ~]$ asmcmd -p
/*
ASMCMD [+] > cd +DATA/PDBDB/PASSWORD

ASMCMD [+DATA/PDBDB/PASSWORD] > ls -lt
Type      Redund  Striped  Time             Sys  Name
PASSWORD  UNPROT  COARSE   SEP 30 12:00:00  Y    pwdpdbdb.256.1181045219

ASMCMD [+DATA/PDBDB/PASSWORD] > pwcopy pwdpdbdb.256.1181045219 /tmp
copying +DATA/PDBDB/PASSWORD/pwdpdbdb.256.1181045219 -> /tmp/pwdpdbdb.256.1181045219

ASMCMD [+DATA/PDBDB/PASSWORD] > exit
*/

-- Step 97 -->> On Node 1 - DC
[root@pdb1 ~]# su - oracle
[oracle@pdb1 ~]$ cd /tmp/
[oracle@pdb1 tmp]$ ll pwdpdbdb.256.1181045219
/*
-rw-r----- 1 grid oinstall 2048 Nov  2 12:34 pwdpdbdb.256.1181045219
*/

-- Step 97.1 -->> On Node 1 - DC
[oracle@pdb1 tmp]$ cp -p pwdpdbdb.256.1181045219 /backup/configfiles/orapwpdbdb1
[oracle@pdb1 tmp]$ ll /backup/configfiles/
/*
-rw-r----- 1 oracle oinstall 2048 Nov  2 12:34 orapwpdbdb1
-rw-r--r-- 1 oracle asmadmin 2463 Nov  2 12:26 spfilepdbdb.ora
*/

-- Step 98 -->> On Node 1 - DC
[oracle@pdb1 ~]$ mkdir -p /backup/fullbackup
[oracle@pdb1 ~]$ rman target / nocatalog
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Sun Nov 3 11:28:12 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB (DBID=3239152647)
using target database control file instead of recovery catalog

-- Step 98.1 -->> On Node 1 - DC
RMAN> run
{
  ALLOCATE CHANNEL c1 DEVICE TYPE DISK MAXPIECESIZE 10G;
  ALLOCATE CHANNEL c2 DEVICE TYPE DISK MAXPIECESIZE 10G;
  ALLOCATE CHANNEL c3 DEVICE TYPE DISK MAXPIECESIZE 10G;

  SQL "ALTER SYSTEM SWITCH LOGFILE";
  BACKUP DATABASE FORMAT '/backup/fullbackup/database_%d_%u_%s';

  SQL "ALTER SYSTEM ARCHIVE LOG CURRENT";
  BACKUP ARCHIVELOG ALL FORMAT '/backup/fullbackup/arch_%d_%u_%s';

  BACKUP CURRENT CONTROLFILE FOR STANDBY FORMAT '/backup/fullbackup/Control_%d_%u_%s';
  release channel c1;
  release channel c2;
  release channel c3;
}

allocated channel: c1
channel c1: SID=173 instance=pdbdb1 device type=DISK

allocated channel: c2
channel c2: SID=298 instance=pdbdb1 device type=DISK

allocated channel: c3
channel c3: SID=394 instance=pdbdb1 device type=DISK

sql statement: ALTER SYSTEM SWITCH LOGFILE

Starting backup at 03-NOV-24
channel c1: starting full datafile backup set
channel c1: specifying datafile(s) in backup set
input datafile file number=00003 name=+DATA/PDBDB/DATAFILE/sysaux.258.1181045291
channel c1: starting piece 1 at 03-NOV-24
channel c2: starting full datafile backup set
channel c2: specifying datafile(s) in backup set
input datafile file number=00015 name=+DATA/PDBDB/2351E15D26626035E063150610AC7E23/DATAFILE/tbs_backup.279.1181217557
input datafile file number=00012 name=+DATA/PDBDB/2351E15D26626035E063150610AC7E23/DATAFILE/undotbs1.273.1181048049
channel c2: starting piece 1 at 03-NOV-24
channel c3: starting full datafile backup set
channel c3: specifying datafile(s) in backup set
input datafile file number=00016 name=+DATA/PDBDB/2351E15D26626035E063150610AC7E23/DATAFILE/tbs_snapshot.304.1182439785
input datafile file number=00013 name=+DATA/PDBDB/2351E15D26626035E063150610AC7E23/DATAFILE/undo_2.277.1181048079
channel c3: starting piece 1 at 03-NOV-24
channel c2: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/database_PDBDB_2j396rb3_83 tag=TAG20241103T112834 comment=NONE
channel c2: backup set complete, elapsed time: 00:00:07
channel c2: starting full datafile backup set
channel c2: specifying datafile(s) in backup set
input datafile file number=00001 name=+DATA/PDBDB/DATAFILE/system.257.1181045247
input datafile file number=00007 name=+DATA/PDBDB/DATAFILE/users.260.1181045319
channel c2: starting piece 1 at 03-NOV-24
channel c3: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/database_PDBDB_2k396rb3_84 tag=TAG20241103T112834 comment=NONE
channel c3: backup set complete, elapsed time: 00:00:08
channel c3: starting full datafile backup set
channel c3: specifying datafile(s) in backup set
input datafile file number=00004 name=+DATA/PDBDB/DATAFILE/undotbs1.259.1181045317
input datafile file number=00009 name=+DATA/PDBDB/DATAFILE/undotbs2.269.1181046999
channel c3: starting piece 1 at 03-NOV-24
channel c3: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/database_PDBDB_2m396rbb_86 tag=TAG20241103T112834 comment=NONE
channel c3: backup set complete, elapsed time: 00:00:03
channel c3: starting full datafile backup set
channel c3: specifying datafile(s) in backup set
input datafile file number=00011 name=+DATA/PDBDB/2351E15D26626035E063150610AC7E23/DATAFILE/sysaux.275.1181048049
input datafile file number=00010 name=+DATA/PDBDB/2351E15D26626035E063150610AC7E23/DATAFILE/system.274.1181048049
input datafile file number=00014 name=+DATA/PDBDB/2351E15D26626035E063150610AC7E23/DATAFILE/users.278.1181048083
channel c3: starting piece 1 at 03-NOV-24
channel c1: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/database_PDBDB_2i396rb3_82 tag=TAG20241103T112834 comment=NONE
channel c1: backup set complete, elapsed time: 00:00:20
channel c1: starting full datafile backup set
channel c1: specifying datafile(s) in backup set
input datafile file number=00006 name=+DATA/PDBDB/86B637B62FE07A65E053F706E80A27CA/DATAFILE/sysaux.266.1181046729
channel c1: starting piece 1 at 03-NOV-24
channel c2: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/database_PDBDB_2l396rbb_85 tag=TAG20241103T112834 comment=NONE
channel c2: backup set complete, elapsed time: 00:00:15
channel c2: starting full datafile backup set
channel c2: specifying datafile(s) in backup set
input datafile file number=00005 name=+DATA/PDBDB/86B637B62FE07A65E053F706E80A27CA/DATAFILE/system.265.1181046729
channel c2: starting piece 1 at 03-NOV-24
channel c1: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/database_PDBDB_2o396rbn_88 tag=TAG20241103T112834 comment=NONE
channel c1: backup set complete, elapsed time: 00:00:07
channel c1: starting full datafile backup set
channel c1: specifying datafile(s) in backup set
input datafile file number=00008 name=+DATA/PDBDB/86B637B62FE07A65E053F706E80A27CA/DATAFILE/undotbs1.267.1181046729
channel c1: starting piece 1 at 03-NOV-24
channel c2: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/database_PDBDB_2p396rbr_89 tag=TAG20241103T112834 comment=NONE
channel c2: backup set complete, elapsed time: 00:00:06
channel c1: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/database_PDBDB_2q396rbu_90 tag=TAG20241103T112834 comment=NONE
channel c1: backup set complete, elapsed time: 00:00:07
channel c3: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/database_PDBDB_2n396rbf_87 tag=TAG20241103T112834 comment=NONE
channel c3: backup set complete, elapsed time: 00:00:21
Finished backup at 03-NOV-24

Starting Control File and SPFILE Autobackup at 03-NOV-24
piece handle=+ARC/PDBDB/AUTOBACKUP/2024_11_03/s_1184066950.411.1184066951 comment=NONE
Finished Control File and SPFILE Autobackup at 03-NOV-24

sql statement: ALTER SYSTEM ARCHIVE LOG CURRENT

Starting backup at 03-NOV-24
current log archived
channel c1: starting archived log backup set
channel c1: specifying archived log(s) in backup set
input archived log thread=2 sequence=314 RECID=1197 STAMP=1183999580
input archived log thread=1 sequence=417 RECID=1202 STAMP=1184010305
input archived log thread=2 sequence=315 RECID=1200 STAMP=1184006721
input archived log thread=2 sequence=316 RECID=1204 STAMP=1184013907
input archived log thread=1 sequence=418 RECID=1206 STAMP=1184021257
input archived log thread=2 sequence=317 RECID=1208 STAMP=1184021257
input archived log thread=1 sequence=419 RECID=1212 STAMP=1184033662
input archived log thread=2 sequence=318 RECID=1210 STAMP=1184028323
channel c1: starting piece 1 at 03-NOV-24
channel c2: starting archived log backup set
channel c2: specifying archived log(s) in backup set
input archived log thread=2 sequence=319 RECID=1214 STAMP=1184042395
input archived log thread=1 sequence=420 RECID=1215 STAMP=1184042711
input archived log thread=2 sequence=320 RECID=1218 STAMP=1184046627
input archived log thread=1 sequence=421 RECID=1224 STAMP=1184047230
input archived log thread=2 sequence=321 RECID=1220 STAMP=1184046631
input archived log thread=2 sequence=322 RECID=1222 STAMP=1184047228
input archived log thread=2 sequence=323 RECID=1226 STAMP=1184047261
channel c2: starting piece 1 at 03-NOV-24
channel c3: starting archived log backup set
channel c3: specifying archived log(s) in backup set
input archived log thread=1 sequence=422 RECID=1230 STAMP=1184057122
input archived log thread=2 sequence=324 RECID=1228 STAMP=1184052461
input archived log thread=2 sequence=325 RECID=1232 STAMP=1184061642
input archived log thread=1 sequence=423 RECID=1238 STAMP=1184063356
input archived log thread=2 sequence=326 RECID=1234 STAMP=1184063351
input archived log thread=2 sequence=327 RECID=1235 STAMP=1184063355
input archived log thread=2 sequence=328 RECID=1239 STAMP=1184063358
input archived log thread=1 sequence=424 RECID=1241 STAMP=1184063366
input archived log thread=2 sequence=329 RECID=1247 STAMP=1184063373
input archived log thread=1 sequence=425 RECID=1243 STAMP=1184063367
input archived log thread=1 sequence=426 RECID=1245 STAMP=1184063370
input archived log thread=1 sequence=427 RECID=1252 STAMP=1184064708
input archived log thread=2 sequence=330 RECID=1249 STAMP=1184063376
input archived log thread=2 sequence=331 RECID=1258 STAMP=1184064903
input archived log thread=1 sequence=428 RECID=1253 STAMP=1184064715
channel c3: starting piece 1 at 03-NOV-24
channel c1: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/arch_PDBDB_2s396rcf_92 tag=TAG20241103T112918 comment=NONE
channel c1: backup set complete, elapsed time: 00:00:03
channel c1: starting archived log backup set
channel c1: specifying archived log(s) in backup set
input archived log thread=1 sequence=429 RECID=1255 STAMP=1184064901
input archived log thread=1 sequence=430 RECID=1259 STAMP=1184064904
input archived log thread=2 sequence=332 RECID=1261 STAMP=1184064906
input archived log thread=1 sequence=431 RECID=1263 STAMP=1184064907
input archived log thread=2 sequence=333 RECID=1269 STAMP=1184066814
input archived log thread=1 sequence=432 RECID=1266 STAMP=1184066777
input archived log thread=1 sequence=433 RECID=1267 STAMP=1184066813
input archived log thread=1 sequence=434 RECID=1271 STAMP=1184066815
input archived log thread=2 sequence=334 RECID=1273 STAMP=1184066817
input archived log thread=1 sequence=435 RECID=1275 STAMP=1184066914
input archived log thread=2 sequence=335 RECID=1279 STAMP=1184066955
input archived log thread=1 sequence=436 RECID=1277 STAMP=1184066953
input archived log thread=1 sequence=437 RECID=1281 STAMP=1184066956
input archived log thread=2 sequence=336 RECID=1283 STAMP=1184066958
channel c1: starting piece 1 at 03-NOV-24
channel c2: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/arch_PDBDB_2t396rcf_93 tag=TAG20241103T112918 comment=NONE
channel c2: backup set complete, elapsed time: 00:00:04
channel c1: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/arch_PDBDB_2v396rci_95 tag=TAG20241103T112918 comment=NONE
channel c1: backup set complete, elapsed time: 00:00:01
channel c3: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/arch_PDBDB_2u396rcf_94 tag=TAG20241103T112918 comment=NONE
channel c3: backup set complete, elapsed time: 00:00:02
Finished backup at 03-NOV-24

Starting backup at 03-NOV-24
channel c1: starting full datafile backup set
channel c1: specifying datafile(s) in backup set
including standby control file in backup set
channel c1: starting piece 1 at 03-NOV-24
channel c1: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/Control_PDBDB_30396rcm_96 tag=TAG20241103T112926 comment=NONE
channel c1: backup set complete, elapsed time: 00:00:01
Finished backup at 03-NOV-24

Starting Control File and SPFILE Autobackup at 03-NOV-24
piece handle=+ARC/PDBDB/AUTOBACKUP/2024_11_03/s_1184066968.400.1184066969 comment=NONE
Finished Control File and SPFILE Autobackup at 03-NOV-24

released channel: c1

released channel: c2

released channel: c3

RMAN> exit


Recovery Manager complete.
*/

-- Step 99 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Nov 3 11:30:13 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> alter system switch logfile;

System altered.

SQL> alter system switch logfile;

System altered.

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           439          1
           338          2

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 100 -->> On Node 1 - DC
[oracle@pdb1 ~]$ rman target /
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Sun Nov 3 11:32:42 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB (DBID=3239152647)

RMAN> run
{
  ALLOCATE CHANNEL c1 DEVICE TYPE DISK MAXPIECESIZE 10G;
  ALLOCATE CHANNEL c2 DEVICE TYPE DISK MAXPIECESIZE 10G;
  ALLOCATE CHANNEL c3 DEVICE TYPE DISK MAXPIECESIZE 10G;

  SQL "ALTER SYSTEM SWITCH LOGFILE";

  SQL "ALTER SYSTEM ARCHIVE LOG CURRENT";
  BACKUP ARCHIVELOG ALL FORMAT '/backup/fullbackup/arch_%d_%u_%s';

  release channel c1;
  release channel c2;
  release channel c3;
}

using target database control file instead of recovery catalog
allocated channel: c1
channel c1: SID=174 instance=pdbdb1 device type=DISK

allocated channel: c2
channel c2: SID=298 instance=pdbdb1 device type=DISK

allocated channel: c3
channel c3: SID=426 instance=pdbdb1 device type=DISK

sql statement: ALTER SYSTEM SWITCH LOGFILE

sql statement: ALTER SYSTEM ARCHIVE LOG CURRENT

Starting backup at 03-NOV-24
current log archived
channel c1: starting archived log backup set
channel c1: specifying archived log(s) in backup set
input archived log thread=2 sequence=314 RECID=1197 STAMP=1183999580
input archived log thread=1 sequence=417 RECID=1202 STAMP=1184010305
input archived log thread=2 sequence=315 RECID=1200 STAMP=1184006721
input archived log thread=2 sequence=316 RECID=1204 STAMP=1184013907
input archived log thread=1 sequence=418 RECID=1206 STAMP=1184021257
input archived log thread=2 sequence=317 RECID=1208 STAMP=1184021257
input archived log thread=1 sequence=419 RECID=1212 STAMP=1184033662
input archived log thread=2 sequence=318 RECID=1210 STAMP=1184028323
channel c1: starting piece 1 at 03-NOV-24
channel c2: starting archived log backup set
channel c2: specifying archived log(s) in backup set
input archived log thread=2 sequence=319 RECID=1214 STAMP=1184042395
input archived log thread=1 sequence=420 RECID=1215 STAMP=1184042711
input archived log thread=2 sequence=320 RECID=1218 STAMP=1184046627
input archived log thread=1 sequence=421 RECID=1224 STAMP=1184047230
input archived log thread=2 sequence=321 RECID=1220 STAMP=1184046631
input archived log thread=2 sequence=322 RECID=1222 STAMP=1184047228
input archived log thread=2 sequence=323 RECID=1226 STAMP=1184047261
channel c2: starting piece 1 at 03-NOV-24
channel c3: starting archived log backup set
channel c3: specifying archived log(s) in backup set
input archived log thread=1 sequence=422 RECID=1230 STAMP=1184057122
input archived log thread=2 sequence=324 RECID=1228 STAMP=1184052461
input archived log thread=2 sequence=325 RECID=1232 STAMP=1184061642
input archived log thread=1 sequence=423 RECID=1238 STAMP=1184063356
input archived log thread=2 sequence=326 RECID=1234 STAMP=1184063351
input archived log thread=2 sequence=327 RECID=1235 STAMP=1184063355
input archived log thread=2 sequence=328 RECID=1239 STAMP=1184063358
input archived log thread=1 sequence=424 RECID=1241 STAMP=1184063366
input archived log thread=2 sequence=329 RECID=1247 STAMP=1184063373
input archived log thread=1 sequence=425 RECID=1243 STAMP=1184063367
input archived log thread=1 sequence=426 RECID=1245 STAMP=1184063370
input archived log thread=1 sequence=427 RECID=1252 STAMP=1184064708
input archived log thread=2 sequence=330 RECID=1249 STAMP=1184063376
input archived log thread=2 sequence=331 RECID=1258 STAMP=1184064903
input archived log thread=1 sequence=428 RECID=1253 STAMP=1184064715
input archived log thread=1 sequence=429 RECID=1255 STAMP=1184064901
input archived log thread=1 sequence=430 RECID=1259 STAMP=1184064904
input archived log thread=2 sequence=332 RECID=1261 STAMP=1184064906
channel c3: starting piece 1 at 03-NOV-24
channel c1: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/arch_PDBDB_32396rk9_98 tag=TAG20241103T113328 comment=NONE
channel c1: backup set complete, elapsed time: 00:00:09
channel c1: starting archived log backup set
channel c1: specifying archived log(s) in backup set
input archived log thread=1 sequence=431 RECID=1263 STAMP=1184064907
input archived log thread=2 sequence=333 RECID=1269 STAMP=1184066814
input archived log thread=1 sequence=432 RECID=1266 STAMP=1184066777
input archived log thread=1 sequence=433 RECID=1267 STAMP=1184066813
input archived log thread=1 sequence=434 RECID=1271 STAMP=1184066815
input archived log thread=2 sequence=334 RECID=1273 STAMP=1184066817
input archived log thread=1 sequence=435 RECID=1275 STAMP=1184066914
input archived log thread=2 sequence=335 RECID=1279 STAMP=1184066955
input archived log thread=1 sequence=436 RECID=1277 STAMP=1184066953
input archived log thread=1 sequence=437 RECID=1281 STAMP=1184066956
input archived log thread=2 sequence=336 RECID=1283 STAMP=1184066958
input archived log thread=1 sequence=438 RECID=1285 STAMP=1184067028
input archived log thread=2 sequence=337 RECID=1289 STAMP=1184067037
input archived log thread=1 sequence=439 RECID=1287 STAMP=1184067029
input archived log thread=1 sequence=440 RECID=1293 STAMP=1184067199
input archived log thread=2 sequence=338 RECID=1291 STAMP=1184067040
input archived log thread=2 sequence=339 RECID=1297 STAMP=1184067204
input archived log thread=1 sequence=441 RECID=1295 STAMP=1184067199
channel c1: starting piece 1 at 03-NOV-24
channel c2: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/arch_PDBDB_33396rk9_99 tag=TAG20241103T113328 comment=NONE
channel c2: backup set complete, elapsed time: 00:00:09
channel c2: starting archived log backup set
channel c2: specifying archived log(s) in backup set
input archived log thread=1 sequence=442 RECID=1301 STAMP=1184067207
input archived log thread=2 sequence=340 RECID=1299 STAMP=1184067207
channel c2: starting piece 1 at 03-NOV-24
channel c3: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/arch_PDBDB_34396rk9_100 tag=TAG20241103T113328 comment=NONE
channel c3: backup set complete, elapsed time: 00:00:08
channel c1: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/arch_PDBDB_35396rki_101 tag=TAG20241103T113328 comment=NONE
channel c1: backup set complete, elapsed time: 00:00:01
channel c2: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/arch_PDBDB_36396rki_102 tag=TAG20241103T113328 comment=NONE
channel c2: backup set complete, elapsed time: 00:00:01
Finished backup at 03-NOV-24

Starting Control File and SPFILE Autobackup at 03-NOV-24
piece handle=+ARC/PDBDB/AUTOBACKUP/2024_11_03/s_1184067219.359.1184067221 comment=NONE
Finished Control File and SPFILE Autobackup at 03-NOV-24

released channel: c1

released channel: c2

released channel: c3

RMAN> exit


Recovery Manager complete.
*/

-- Step 101 -->> On Node 1 - DC
[oracle@pdb1 ~]$ ll /backup/configfiles/
/*
-rw-r----- 1 oracle oinstall 2048 Nov  2 12:34 orapwpdbdb1
-rw-r--r-- 1 oracle asmadmin 2463 Nov  2 12:26 spfilepdbdb.ora
*/

-- Step 101.1 -->> On Node 1 - DC
[oracle@pdb1 ~]$ ll /backup/fullbackup/
/*
-rw-r----- 1 oracle asmadmin  193468928 Nov  3 11:29 arch_PDBDB_2s396rcf_92
-rw-r----- 1 oracle asmadmin  184230912 Nov  3 11:29 arch_PDBDB_2t396rcf_93
-rw-r----- 1 oracle asmadmin  136041472 Nov  3 11:29 arch_PDBDB_2u396rcf_94
-rw-r----- 1 oracle asmadmin    3262464 Nov  3 11:29 arch_PDBDB_2v396rci_95
-rw-r----- 1 oracle asmadmin  193468928 Nov  3 11:33 arch_PDBDB_32396rk9_98
-rw-r----- 1 oracle asmadmin  184230912 Nov  3 11:33 arch_PDBDB_33396rk9_99
-rw-r----- 1 oracle asmadmin  136208896 Nov  3 11:33 arch_PDBDB_34396rk9_100
-rw-r----- 1 oracle asmadmin    3442688 Nov  3 11:33 arch_PDBDB_35396rki_101
-rw-r----- 1 oracle asmadmin      12800 Nov  3 11:33 arch_PDBDB_36396rki_102
-rw-r----- 1 oracle asmadmin   20643840 Nov  3 11:29 Control_PDBDB_30396rcm_96
-rw-r----- 1 oracle asmadmin 1941118976 Nov  3 11:28 database_PDBDB_2i396rb3_82
-rw-r----- 1 oracle asmadmin   77725696 Nov  3 11:28 database_PDBDB_2j396rb3_83
-rw-r----- 1 oracle asmadmin   23715840 Nov  3 11:28 database_PDBDB_2k396rb3_84
-rw-r----- 1 oracle asmadmin 1046446080 Nov  3 11:28 database_PDBDB_2l396rbb_85
-rw-r----- 1 oracle asmadmin    3121152 Nov  3 11:28 database_PDBDB_2m396rbb_86
-rw-r----- 1 oracle asmadmin  889520128 Nov  3 11:28 database_PDBDB_2n396rbf_87
-rw-r----- 1 oracle asmadmin  377528320 Nov  3 11:28 database_PDBDB_2o396rbn_88
-rw-r----- 1 oracle asmadmin  407199744 Nov  3 11:29 database_PDBDB_2p396rbr_89
-rw-r----- 1 oracle asmadmin  265617408 Nov  3 11:29 database_PDBDB_2q396rbu_90
*/

-- Step 102 -->> On Node 1 - SandBox
[oracle@pdb ~]$ mkdir -p /backup/configfiles
[oracle@pdb ~]$ mkdir -p /backup/fullbackup

-- Step 102.1 -->> On Node 1 - DC
[oracle@pdb1 ~]$ scp -r /backup/configfiles/* oracle@192.16.6.30:/backup/configfiles/
/*
oracle@192.16.6.30's password: <- oracle
orapwpdbdb1                                                100% 2048   312.0KB/s   00:00
spfilepdbdb.ora                                            100% 2463   460.1KB/s   00:00
*/

-- Step 102.3 -->> On Node 1 - DC
[oracle@pdb1 ~]$ scp -r /backup/fullbackup/* oracle@192.16.6.30:/backup/fullbackup/
/*
oracle@192.16.6.30's password: <- oracle
arch_PDBDB_2s396rcf_92                                     100%  185MB 138.7MB/s   00:01
arch_PDBDB_2t396rcf_93                                     100%  176MB 150.0MB/s   00:01
arch_PDBDB_2u396rcf_94                                     100%  130MB 161.4MB/s   00:00
arch_PDBDB_2v396rci_95                                     100% 3186KB 156.7MB/s   00:00
arch_PDBDB_32396rk9_98                                     100%  185MB 171.6MB/s   00:01
arch_PDBDB_33396rk9_99                                     100%  176MB 136.8MB/s   00:01
arch_PDBDB_34396rk9_100                                    100%  130MB 167.4MB/s   00:00
arch_PDBDB_35396rki_101                                    100% 3362KB 137.9MB/s   00:00
arch_PDBDB_36396rki_102                                    100%   13KB   1.6MB/s   00:00
Control_PDBDB_30396rcm_96                                  100%   20MB  71.3MB/s   00:00
database_PDBDB_2i396rb3_82                                 100% 1851MB 104.5MB/s   00:17
database_PDBDB_2j396rb3_83                                 100%   74MB  92.6MB/s   00:00
database_PDBDB_2k396rb3_84                                 100%   23MB  95.8MB/s   00:00
database_PDBDB_2l396rbb_85                                 100%  998MB  92.5MB/s   00:10
database_PDBDB_2m396rbb_86                                 100% 3048KB  52.4MB/s   00:00
database_PDBDB_2n396rbf_87                                 100%  848MB  90.9MB/s   00:09
database_PDBDB_2o396rbn_88                                 100%  360MB  69.4MB/s   00:05
database_PDBDB_2p396rbr_89                                 100%  388MB  66.7MB/s   00:05
database_PDBDB_2q396rbu_90                                 100%  253MB  67.8MB/s   00:03
*/

-- Step 102.4 -->> On Node 1 - SandBox
[oracle@pdb ~]$ ll /backup/configfiles/
/*
-rw-r----- 1 oracle oinstall 2048 Nov  3 11:35 orapwpdbdb1
-rw-r--r-- 1 oracle oinstall 2463 Nov  3 11:35 spfilepdbdb.ora
*/

-- Step 102.5 -->> On Node 1 - SandBox
[oracle@pdb ~]$ ll /backup/fullbackup/
/*
-rw-r----- 1 oracle oinstall  193468928 Nov  3 11:35 arch_PDBDB_2s396rcf_92
-rw-r----- 1 oracle oinstall  184230912 Nov  3 11:35 arch_PDBDB_2t396rcf_93
-rw-r----- 1 oracle oinstall  136041472 Nov  3 11:35 arch_PDBDB_2u396rcf_94
-rw-r----- 1 oracle oinstall    3262464 Nov  3 11:35 arch_PDBDB_2v396rci_95
-rw-r----- 1 oracle oinstall  193468928 Nov  3 11:35 arch_PDBDB_32396rk9_98
-rw-r----- 1 oracle oinstall  184230912 Nov  3 11:35 arch_PDBDB_33396rk9_99
-rw-r----- 1 oracle oinstall  136208896 Nov  3 11:35 arch_PDBDB_34396rk9_100
-rw-r----- 1 oracle oinstall    3442688 Nov  3 11:35 arch_PDBDB_35396rki_101
-rw-r----- 1 oracle oinstall      12800 Nov  3 11:35 arch_PDBDB_36396rki_102
-rw-r----- 1 oracle oinstall   20643840 Nov  3 11:35 Control_PDBDB_30396rcm_96
-rw-r----- 1 oracle oinstall 1941118976 Nov  3 11:35 database_PDBDB_2i396rb3_82
-rw-r----- 1 oracle oinstall   77725696 Nov  3 11:35 database_PDBDB_2j396rb3_83
-rw-r----- 1 oracle oinstall   23715840 Nov  3 11:35 database_PDBDB_2k396rb3_84
-rw-r----- 1 oracle oinstall 1046446080 Nov  3 11:36 database_PDBDB_2l396rbb_85
-rw-r----- 1 oracle oinstall    3121152 Nov  3 11:36 database_PDBDB_2m396rbb_86
-rw-r----- 1 oracle oinstall  889520128 Nov  3 11:36 database_PDBDB_2n396rbf_87
-rw-r----- 1 oracle oinstall  377528320 Nov  3 11:36 database_PDBDB_2o396rbn_88
-rw-r----- 1 oracle oinstall  407199744 Nov  3 11:36 database_PDBDB_2p396rbr_89
-rw-r----- 1 oracle oinstall  265617408 Nov  3 11:36 database_PDBDB_2q396rbu_90
*/

-- Step 103 -->> On Node 1 - SandBox
[oracle@pdb ~]$ vi /backup/configfiles/spfilepdbdb.ora
/*
pdbdb2.__data_transfer_cache_size=0
pdbdb1.__data_transfer_cache_size=0
pdbdb1.__db_cache_size=7482638336
pdbdb2.__db_cache_size=7616856064
pdbdb2.__inmemory_ext_roarea=0
pdbdb1.__inmemory_ext_roarea=0
pdbdb2.__inmemory_ext_rwarea=0
pdbdb1.__inmemory_ext_rwarea=0
pdbdb2.__java_pool_size=0
pdbdb1.__java_pool_size=0
pdbdb2.__large_pool_size=33554432
pdbdb1.__large_pool_size=33554432
pdbdb1.__oracle_base='/opt/app/oracle'#ORACLE_BASE set from environment
pdbdb2.__oracle_base='/opt/app/oracle'#ORACLE_BASE set from environment
pdbdb2.__pga_aggregate_target=3221225472
pdbdb1.__pga_aggregate_target=3221225472
pdbdb2.__sga_target=9663676416
pdbdb1.__sga_target=9663676416
pdbdb2.__shared_io_pool_size=134217728
pdbdb1.__shared_io_pool_size=134217728
pdbdb1.__shared_pool_size=1979711488
pdbdb2.__shared_pool_size=1845493760
pdbdb2.__streams_pool_size=0
pdbdb1.__streams_pool_size=0
pdbdb2.__unified_pga_pool_size=0
pdbdb1.__unified_pga_pool_size=0
*.audit_file_dest='/opt/app/oracle/admin/pdbdb/adump'
*.audit_trail='db'
*.cluster_database=true
*.compatible='19.0.0'
*.control_files='+DATA/PDBDB/CONTROLFILE/current.261.1181045383','+ARC/PDBDB/CONTROLFILE/current.256.1181045383'
*.db_block_size=8192
*.db_create_file_dest='+DATA'
*.db_name='pdbdb'
*.db_recovery_file_dest='+ARC'
*.db_recovery_file_dest_size=53687091200
*.diagnostic_dest='/opt/app/oracle'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=pdbdbXDB)'
*.enable_pluggable_database=true
family:dw_helper.instance_mode='read-only'
pdbdb2.instance_number=2
pdbdb1.instance_number=1
*.local_listener='-oraagent-dummy-'
*.log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=pdbdb'
*.log_archive_dest_state_1='ENABLE'
*.log_archive_format='pdbdb_%t_%s_%r.arc'
*.log_archive_max_processes=30
*.nls_language='AMERICAN'
*.nls_territory='AMERICA'
*.open_cursors=300
*.pga_aggregate_target=3072m
*.processes=320
*.remote_listener='pdbm-scan:1521'
*.remote_login_passwordfile='EXCLUSIVE'
*.sga_target=9216m
*.standby_file_management='AUTO'
pdbdb2.thread=2
pdbdb1.thread=1
pdbdb2.undo_tablespace='UNDOTBS2'
pdbdb1.undo_tablespace='UNDOTBS1'
*/

-- Step 104 -->> On Node 1 - SandBox
[root@pdb ~]# mkdir -p /opt/app/oracle/admin/pdbdb/adump
[root@pdb ~]# cd /opt/app/oracle/admin/
[root@pdb admin]# chown -R oracle:oinstall pdbdb/
[root@pdb admin]# chmod -R 775 pdbdb/

-- Step 105 -->> On Node 1 - SandBox
[root@pdb ~]# vi /etc/oratab
/*
#

# This file is used by ORACLE utilities.  It is created by root.sh
# and updated by either Database Configuration Assistant while creating
# a database or ASM Configuration Assistant while creating ASM instance.

# A colon, ':', is used as the field terminator.  A new line terminates
# the entry.  Lines beginning with a pound sign, '#', are comments.
#
# Entries are of the form:
#   $ORACLE_SID:$ORACLE_HOME:<N|Y>:
#
# The first and second fields are the system identifier and home
# directory of the database respectively.  The third field indicates
# to the dbstart utility that the database should , "Y", or should not,
# "N", be brought up at system boot time.
#
# Multiple entries with the same $ORACLE_SID are not allowed.
#
#
+ASM1:/opt/app/19c/grid:N
pdbdb:/opt/app/oracle/product/19c/db_1:N
pdbdb1:/opt/app/oracle/product/19c/db_1:N
*/

-- Step 106 -->> On Node 1 - SandBox
[root@pdb ~]# su - oracle
[oracle@pdb ~]$ vi /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
/*
# tnsnames.ora Network Configuration File: /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.

PDBDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdbm-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = pdbdb)
    )
  )

PDBDB1 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.16.6.30)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = pdbdb)
    )
  )

SBXPDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdbm-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = sbxpdb)
    )
  )
*/

-- Step 107 -->> On Node 1 - SandBox
[oracle@pdb ~]$ vi /opt/app/oracle/product/19c/db_1/dbs/initpdbdb1.ora
/*
SPFILE='+DATA/PDBDB/PARAMETERFILE/spfilepdbdb.ora'
*/

-- Step 107.1 -->> On Node 1 - SandBox
[oracle@pdb ~]$ ll /opt/app/oracle/product/19c/db_1/dbs/initpdbdb1.ora
/*
-rw-r--r-- 1 oracle oinstall 51 Nov  2 13:39 /opt/app/oracle/product/19c/db_1/dbs/initpdbdb1.ora
*/

-- Step 108 -->> On Node 1 - SandBox
[oracle@pdb ~]$ env | grep ORA
/*
ORACLE_UNQNAME=pdbdb
ORACLE_SID=pdbdb1
ORACLE_BASE=/opt/app/oracle
ORACLE_HOME=/opt/app/oracle/product/19c/db_1
ORACLE_HOSTNAME=pdb.unidev.org.np
*/

-- Step 109 -->> On Node 1 - SandBox
[oracle@pdb ~]$ cd /backup/configfiles/
[oracle@pdb configfiles]$ ll
/*
-rw-r----- 1 oracle oinstall 2048 Nov  3 11:35 orapwpdbdb1
-rw-r--r-- 1 oracle oinstall 2135 Nov  3 11:39 spfilepdbdb.ora
*/

-- Step 109.1 -->> On Node 1 - SandBox
[oracle@pdb configfiles]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Nov 3 11:46:55 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> !ls
orapwpdbdb1  spfilepdbdb.ora

SQL> startup nomount pfile='/backup/configfiles/spfilepdbdb.ora';
ORACLE instance started.

Total System Global Area 9663672664 bytes
Fixed Size                  9187672 bytes
Variable Size            2013265920 bytes
Database Buffers         7616856064 bytes
Redo Buffers               24363008 bytes

SQL> create SPFILE='+DATA/PDBDB/PARAMETERFILE/spfilepdbdb.ora' from pfile='/backup/configfiles/spfilepdbdb.ora';

File created.

SQL> shut immediate;
ORA-01507: database not mounted


ORACLE instance shut down.

SQL> startup nomount;
ORACLE instance started.

Total System Global Area 9663672664 bytes
Fixed Size                  9187672 bytes
Variable Size            2013265920 bytes
Database Buffers         7616856064 bytes
Redo Buffers               24363008 bytes

SQL> set linesize 9999
SQL> show parameter pfile

NAME   TYPE   VALUE
------ ------ -----------------------------------------
spfile string +DATA/PDBDB/PARAMETERFILE/spfilepdbdb.ora


SQL> select status,instance_name from gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
STARTED      pdbdb1

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 110 -->> On Node 1 - SandBox
[oracle@pdb ~]$ ps -ef | grep pmon
/*
grid      876758       1  0 Nov02 ?        00:00:06 asm_pmon_+ASM1
oracle   1642107       1  0 11:48 ?        00:00:00 ora_pmon_pdbdb1
oracle   1642648 1638420  0 11:49 pts/0    00:00:00 grep --color=auto pmon
*/

-- Step 111 -->> On Node 1 - SandBox
[oracle@pdb ~]$ ll /backup/fullbackup/
/*
-rw-r----- 1 oracle oinstall  193468928 Nov  3 11:35 arch_PDBDB_2s396rcf_92
-rw-r----- 1 oracle oinstall  184230912 Nov  3 11:35 arch_PDBDB_2t396rcf_93
-rw-r----- 1 oracle oinstall  136041472 Nov  3 11:35 arch_PDBDB_2u396rcf_94
-rw-r----- 1 oracle oinstall    3262464 Nov  3 11:35 arch_PDBDB_2v396rci_95
-rw-r----- 1 oracle oinstall  193468928 Nov  3 11:35 arch_PDBDB_32396rk9_98
-rw-r----- 1 oracle oinstall  184230912 Nov  3 11:35 arch_PDBDB_33396rk9_99
-rw-r----- 1 oracle oinstall  136208896 Nov  3 11:35 arch_PDBDB_34396rk9_100
-rw-r----- 1 oracle oinstall    3442688 Nov  3 11:35 arch_PDBDB_35396rki_101
-rw-r----- 1 oracle oinstall      12800 Nov  3 11:35 arch_PDBDB_36396rki_102
-rw-r----- 1 oracle oinstall   20643840 Nov  3 11:35 Control_PDBDB_30396rcm_96
-rw-r----- 1 oracle oinstall 1941118976 Nov  3 11:35 database_PDBDB_2i396rb3_82
-rw-r----- 1 oracle oinstall   77725696 Nov  3 11:35 database_PDBDB_2j396rb3_83
-rw-r----- 1 oracle oinstall   23715840 Nov  3 11:35 database_PDBDB_2k396rb3_84
-rw-r----- 1 oracle oinstall 1046446080 Nov  3 11:36 database_PDBDB_2l396rbb_85
-rw-r----- 1 oracle oinstall    3121152 Nov  3 11:36 database_PDBDB_2m396rbb_86
-rw-r----- 1 oracle oinstall  889520128 Nov  3 11:36 database_PDBDB_2n396rbf_87
-rw-r----- 1 oracle oinstall  377528320 Nov  3 11:36 database_PDBDB_2o396rbn_88
-rw-r----- 1 oracle oinstall  407199744 Nov  3 11:36 database_PDBDB_2p396rbr_89
-rw-r----- 1 oracle oinstall  265617408 Nov  3 11:36 database_PDBDB_2q396rbu_90
*/

-- Step 111.1 -->> On Node 1 - SandBox
[oracle@pdb ~]$ rman target /
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Sun Nov 3 11:49:59 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB (not mounted)

-- Step 111.1.1 -->> On Node 1 - SandBox
RMAN> RESTORE STANDBY CONTROLFILE FROM '/backup/fullbackup/Control_PDBDB_30396rcm_96';

Starting restore at 03-NOV-24
using target database control file instead of recovery catalog
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=393 instance=pdbdb1 device type=DISK

channel ORA_DISK_1: restoring control file
channel ORA_DISK_1: restore complete, elapsed time: 00:00:04
output file name=+DATA/PDBDB/CONTROLFILE/current.279.1184068223
output file name=+ARC/PDBDB/CONTROLFILE/current.264.1184068223
Finished restore at 03-NOV-24

-- Step 111.1.2 -->> On Node 1 - SandBox
RMAN> SQL 'ALTER DATABASE MOUNT STANDBY DATABASE';

sql statement: ALTER DATABASE MOUNT STANDBY DATABASE
released channel: ORA_DISK_1

-- Step 111.1.3 -->> On Node 1 - SandBox
RMAN> show all;

RMAN configuration parameters for database with db_unique_name PDBDB are:
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
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/product/19c/db_1/dbs/snapcf_pdbdb1.f'; # default

-- Step 111.1.4 -->> On Node 1 - SandBox
RMAN> CONFIGURE DEVICE TYPE DISK PARALLELISM 4  BACKUP TYPE TO BACKUPSET;

new RMAN configuration parameters:
CONFIGURE DEVICE TYPE DISK PARALLELISM 4 BACKUP TYPE TO BACKUPSET;
new RMAN configuration parameters are successfully stored

-- Step 111.1.5 -->> On Node 1 - SandBox
RMAN> show all;

RMAN configuration parameters for database with db_unique_name PDBDB are:
CONFIGURE RETENTION POLICY TO REDUNDANCY 1; # default
CONFIGURE BACKUP OPTIMIZATION OFF; # default
CONFIGURE DEFAULT DEVICE TYPE TO DISK; # default
CONFIGURE CONTROLFILE AUTOBACKUP ON; # default
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '%F'; # default
CONFIGURE DEVICE TYPE DISK PARALLELISM 4 BACKUP TYPE TO BACKUPSET;
CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE MAXSETSIZE TO UNLIMITED; # default
CONFIGURE ENCRYPTION FOR DATABASE OFF; # default
CONFIGURE ENCRYPTION ALGORITHM 'AES128'; # default
CONFIGURE COMPRESSION ALGORITHM 'BASIC' AS OF RELEASE 'DEFAULT' OPTIMIZE FOR LOAD TRUE ; # default
CONFIGURE RMAN OUTPUT TO KEEP FOR 7 DAYS; # default
CONFIGURE ARCHIVELOG DELETION POLICY TO NONE; # default
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/product/19c/db_1/dbs/snapcf_pdbdb1.f'; # default

-- Step 111.1.6 -->> On Node 1 - SandBox
RMAN> CATALOG START WITH '/backup/fullbackup/';

Starting implicit crosscheck backup at 03-NOV-24
allocated channel: ORA_DISK_1
allocated channel: ORA_DISK_2
allocated channel: ORA_DISK_3
allocated channel: ORA_DISK_4
Crosschecked 17 objects
Crosschecked 21 objects
Crosschecked 19 objects
Crosschecked 23 objects
Finished implicit crosscheck backup at 03-NOV-24

Starting implicit crosscheck copy at 03-NOV-24
using channel ORA_DISK_1
using channel ORA_DISK_2
using channel ORA_DISK_3
using channel ORA_DISK_4
Finished implicit crosscheck copy at 03-NOV-24

searching for all files in the recovery area
cataloging files...
no files cataloged

searching for all files that match the pattern /backup/fullbackup/

List of Files Unknown to the Database
=====================================
File Name: /backup/fullbackup/arch_PDBDB_32396rk9_98
File Name: /backup/fullbackup/arch_PDBDB_33396rk9_99
File Name: /backup/fullbackup/arch_PDBDB_34396rk9_100
File Name: /backup/fullbackup/arch_PDBDB_35396rki_101
File Name: /backup/fullbackup/arch_PDBDB_36396rki_102
File Name: /backup/fullbackup/Control_PDBDB_30396rcm_96

Do you really want to catalog the above files (enter YES or NO)? YES
cataloging files...
cataloging done

List of Cataloged Files
=======================
File Name: /backup/fullbackup/arch_PDBDB_32396rk9_98
File Name: /backup/fullbackup/arch_PDBDB_33396rk9_99
File Name: /backup/fullbackup/arch_PDBDB_34396rk9_100
File Name: /backup/fullbackup/arch_PDBDB_35396rki_101
File Name: /backup/fullbackup/arch_PDBDB_36396rki_102
File Name: /backup/fullbackup/Control_PDBDB_30396rcm_96

-- Step 111.1.7 -->> On Node 1 - SandBox
RMAN> LIST BACKUP OF ARCHIVELOG ALL;


List of Backup Sets
===================


BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
14      49.33M     DISK        00:00:01     02-NOV-24
        BP Key: 14   Status: EXPIRED  Compressed: NO  Tag: TAG20241102T124712
        Piece Name: /backup/fullbackup/arch_PDBDB_0t394big_29

  List of Archived Logs in backup set 14
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    398     13509344   02-NOV-24 13540812   02-NOV-24
  1    399     13540812   02-NOV-24 13554257   02-NOV-24
  2    304     13540809   02-NOV-24 13580536   02-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
15      6.89M      DISK        00:00:00     02-NOV-24
        BP Key: 15   Status: EXPIRED  Compressed: NO  Tag: TAG20241102T124712
        Piece Name: /backup/fullbackup/arch_PDBDB_0v394bih_31

  List of Archived Logs in backup set 15
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    402     13591757   02-NOV-24 13592049   02-NOV-24
  1    403     13592049   02-NOV-24 13592073   02-NOV-24
  2    305     13580536   02-NOV-24 13592056   02-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
16      31.53M     DISK        00:00:01     02-NOV-24
        BP Key: 16   Status: EXPIRED  Compressed: NO  Tag: TAG20241102T124712
        Piece Name: /backup/fullbackup/arch_PDBDB_0u394big_30

  List of Archived Logs in backup set 16
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    400     13554257   02-NOV-24 13580529   02-NOV-24
  1    401     13580529   02-NOV-24 13591757   02-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
17      5.00K      DISK        00:00:00     02-NOV-24
        BP Key: 17   Status: EXPIRED  Compressed: NO  Tag: TAG20241102T124712
        Piece Name: /backup/fullbackup/arch_PDBDB_10394bii_32

  List of Archived Logs in backup set 17
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  2    306     13592056   02-NOV-24 13592080   02-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
20      51.59M     DISK        00:00:00     02-NOV-24
        BP Key: 20   Status: EXPIRED  Compressed: NO  Tag: TAG20241102T160632
        Piece Name: /backup/fullbackup/arch_PDBDB_14394n89_36

  List of Archived Logs in backup set 20
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    404     13592073   02-NOV-24 13645547   02-NOV-24
  2    307     13592080   02-NOV-24 13624514   02-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
21      74.14M     DISK        00:00:00     02-NOV-24
        BP Key: 21   Status: EXPIRED  Compressed: NO  Tag: TAG20241102T160632
        Piece Name: /backup/fullbackup/arch_PDBDB_13394n89_35

  List of Archived Logs in backup set 21
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    398     13509344   02-NOV-24 13540812   02-NOV-24
  1    399     13540812   02-NOV-24 13554257   02-NOV-24
  1    400     13554257   02-NOV-24 13580529   02-NOV-24
  2    304     13540809   02-NOV-24 13580536   02-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
22      13.61M     DISK        00:00:01     02-NOV-24
        BP Key: 22   Status: EXPIRED  Compressed: NO  Tag: TAG20241102T160632
        Piece Name: /backup/fullbackup/arch_PDBDB_15394n89_37

  List of Archived Logs in backup set 22
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    401     13580529   02-NOV-24 13591757   02-NOV-24
  1    402     13591757   02-NOV-24 13592049   02-NOV-24
  1    403     13592049   02-NOV-24 13592073   02-NOV-24
  2    305     13580536   02-NOV-24 13592056   02-NOV-24
  2    306     13592056   02-NOV-24 13592080   02-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
23      11.33M     DISK        00:00:00     02-NOV-24
        BP Key: 23   Status: EXPIRED  Compressed: NO  Tag: TAG20241102T160632
        Piece Name: /backup/fullbackup/arch_PDBDB_16394n8b_38

  List of Archived Logs in backup set 23
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    405     13645547   02-NOV-24 13645562   02-NOV-24
  1    406     13645562   02-NOV-24 13645595   02-NOV-24
  2    308     13624514   02-NOV-24 13645569   02-NOV-24
  2    309     13645569   02-NOV-24 13645588   02-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
35      74.14M     DISK        00:00:00     02-NOV-24
        BP Key: 35   Status: EXPIRED  Compressed: NO  Tag: TAG20241102T161513
        Piece Name: /backup/fullbackup/arch_PDBDB_1i394noi_50

  List of Archived Logs in backup set 35
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    398     13509344   02-NOV-24 13540812   02-NOV-24
  1    399     13540812   02-NOV-24 13554257   02-NOV-24
  1    400     13554257   02-NOV-24 13580529   02-NOV-24
  2    304     13540809   02-NOV-24 13580536   02-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
36      65.20M     DISK        00:00:01     02-NOV-24
        BP Key: 36   Status: EXPIRED  Compressed: NO  Tag: TAG20241102T161513
        Piece Name: /backup/fullbackup/arch_PDBDB_1j394noi_51

  List of Archived Logs in backup set 36
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    401     13580529   02-NOV-24 13591757   02-NOV-24
  1    402     13591757   02-NOV-24 13592049   02-NOV-24
  1    403     13592049   02-NOV-24 13592073   02-NOV-24
  1    404     13592073   02-NOV-24 13645547   02-NOV-24
  2    305     13580536   02-NOV-24 13592056   02-NOV-24
  2    306     13592056   02-NOV-24 13592080   02-NOV-24
  2    307     13592080   02-NOV-24 13624514   02-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
37      8.50K      DISK        00:00:00     02-NOV-24
        BP Key: 37   Status: EXPIRED  Compressed: NO  Tag: TAG20241102T161513
        Piece Name: /backup/fullbackup/arch_PDBDB_1l394noj_53

  List of Archived Logs in backup set 37
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    409     13647499   02-NOV-24 13647529   02-NOV-24
  2    311     13647510   02-NOV-24 13647536   02-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
38      11.99M     DISK        00:00:01     02-NOV-24
        BP Key: 38   Status: EXPIRED  Compressed: NO  Tag: TAG20241102T161513
        Piece Name: /backup/fullbackup/arch_PDBDB_1k394noi_52

  List of Archived Logs in backup set 38
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    405     13645547   02-NOV-24 13645562   02-NOV-24
  1    406     13645562   02-NOV-24 13645595   02-NOV-24
  1    407     13645595   02-NOV-24 13647259   02-NOV-24
  1    408     13647259   02-NOV-24 13647499   02-NOV-24
  2    308     13624514   02-NOV-24 13645569   02-NOV-24
  2    309     13645569   02-NOV-24 13645588   02-NOV-24
  2    310     13645588   02-NOV-24 13647510   02-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
41      74.14M     DISK        00:00:01     02-NOV-24
        BP Key: 41   Status: EXPIRED  Compressed: NO  Tag: TAG20241102T164620
        Piece Name: /backup/fullbackup/arch_PDBDB_1o394pit_56

  List of Archived Logs in backup set 41
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    398     13509344   02-NOV-24 13540812   02-NOV-24
  1    399     13540812   02-NOV-24 13554257   02-NOV-24
  1    400     13554257   02-NOV-24 13580529   02-NOV-24
  2    304     13540809   02-NOV-24 13580536   02-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
42      65.20M     DISK        00:00:01     02-NOV-24
        BP Key: 42   Status: EXPIRED  Compressed: NO  Tag: TAG20241102T164620
        Piece Name: /backup/fullbackup/arch_PDBDB_1p394pit_57

  List of Archived Logs in backup set 42
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    401     13580529   02-NOV-24 13591757   02-NOV-24
  1    402     13591757   02-NOV-24 13592049   02-NOV-24
  1    403     13592049   02-NOV-24 13592073   02-NOV-24
  1    404     13592073   02-NOV-24 13645547   02-NOV-24
  2    305     13580536   02-NOV-24 13592056   02-NOV-24
  2    306     13592056   02-NOV-24 13592080   02-NOV-24
  2    307     13592080   02-NOV-24 13624514   02-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
43      13.02M     DISK        00:00:02     02-NOV-24
        BP Key: 43   Status: EXPIRED  Compressed: NO  Tag: TAG20241102T164620
        Piece Name: /backup/fullbackup/arch_PDBDB_1q394pit_58

  List of Archived Logs in backup set 43
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    405     13645547   02-NOV-24 13645562   02-NOV-24
  1    406     13645562   02-NOV-24 13645595   02-NOV-24
  1    407     13645595   02-NOV-24 13647259   02-NOV-24
  1    408     13647259   02-NOV-24 13647499   02-NOV-24
  1    409     13647499   02-NOV-24 13647529   02-NOV-24
  1    410     13647529   02-NOV-24 13653257   02-NOV-24
  2    308     13624514   02-NOV-24 13645569   02-NOV-24
  2    309     13645569   02-NOV-24 13645588   02-NOV-24
  2    310     13645588   02-NOV-24 13647510   02-NOV-24
  2    311     13647510   02-NOV-24 13647536   02-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
44      11.60M     DISK        00:00:00     02-NOV-24
        BP Key: 44   Status: EXPIRED  Compressed: NO  Tag: TAG20241102T164620
        Piece Name: /backup/fullbackup/arch_PDBDB_1r394pj0_59

  List of Archived Logs in backup set 44
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    411     13653257   02-NOV-24 13653320   02-NOV-24
  1    412     13653320   02-NOV-24 13653331   02-NOV-24
  1    413     13653331   02-NOV-24 13653351   02-NOV-24
  1    414     13653351   02-NOV-24 13654852   02-NOV-24
  1    415     13654852   02-NOV-24 13654873   02-NOV-24
  1    416     13654873   02-NOV-24 13654891   02-NOV-24
  2    312     13647536   02-NOV-24 13653346   02-NOV-24
  2    313     13653346   02-NOV-24 13654869   02-NOV-24
  2    314     13654869   02-NOV-24 13654903   02-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
46      184.51M    DISK        00:00:00     03-NOV-24
        BP Key: 46   Status: EXPIRED  Compressed: NO  Tag: TAG20241103T105507
        Piece Name: /backup/fullbackup/arch_PDBDB_1t396pcc_61

  List of Archived Logs in backup set 46
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    417     13654891   02-NOV-24 13704391   02-NOV-24
  1    418     13704391   02-NOV-24 13750023   02-NOV-24
  1    419     13750023   02-NOV-24 13809350   03-NOV-24
  2    314     13654869   02-NOV-24 13654903   02-NOV-24
  2    315     13654903   02-NOV-24 13686829   02-NOV-24
  2    316     13686829   02-NOV-24 13717491   02-NOV-24
  2    317     13717491   02-NOV-24 13750404   02-NOV-24
  2    318     13750404   02-NOV-24 13788460   03-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
47      175.70M    DISK        00:00:02     03-NOV-24
        BP Key: 47   Status: EXPIRED  Compressed: NO  Tag: TAG20241103T105507
        Piece Name: /backup/fullbackup/arch_PDBDB_1u396pcc_62

  List of Archived Logs in backup set 47
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    420     13809350   03-NOV-24 13847659   03-NOV-24
  1    421     13847659   03-NOV-24 13874106   03-NOV-24
  2    319     13788460   03-NOV-24 13845644   03-NOV-24
  2    320     13845644   03-NOV-24 13866066   03-NOV-24
  2    321     13866066   03-NOV-24 13866256   03-NOV-24
  2    322     13866256   03-NOV-24 13873989   03-NOV-24
  2    323     13873989   03-NOV-24 13878104   03-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
48      6.80M      DISK        00:00:00     03-NOV-24
        BP Key: 48   Status: EXPIRED  Compressed: NO  Tag: TAG20241103T105507
        Piece Name: /backup/fullbackup/arch_PDBDB_20396pcf_64

  List of Archived Logs in backup set 48
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    428     13974810   03-NOV-24 13974835   03-NOV-24
  1    429     13974835   03-NOV-24 13975462   03-NOV-24
  1    430     13975462   03-NOV-24 13975486   03-NOV-24
  1    431     13975486   03-NOV-24 13975507   03-NOV-24
  2    330     13960533   03-NOV-24 13960545   03-NOV-24
  2    331     13960545   03-NOV-24 13975479   03-NOV-24
  2    332     13975479   03-NOV-24 13975501   03-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
49      123.10M    DISK        00:00:03     03-NOV-24
        BP Key: 49   Status: EXPIRED  Compressed: NO  Tag: TAG20241103T105507
        Piece Name: /backup/fullbackup/arch_PDBDB_1v396pcc_63

  List of Archived Logs in backup set 49
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    422     13874106   03-NOV-24 13929439   03-NOV-24
  1    423     13929439   03-NOV-24 13960433   03-NOV-24
  1    424     13960433   03-NOV-24 13960491   03-NOV-24
  1    425     13960491   03-NOV-24 13960504   03-NOV-24
  1    426     13960504   03-NOV-24 13960519   03-NOV-24
  1    427     13960519   03-NOV-24 13974810   03-NOV-24
  2    324     13878104   03-NOV-24 13910736   03-NOV-24
  2    325     13910736   03-NOV-24 13949254   03-NOV-24
  2    326     13949254   03-NOV-24 13960401   03-NOV-24
  2    327     13960401   03-NOV-24 13960422   03-NOV-24
  2    328     13960422   03-NOV-24 13960442   03-NOV-24
  2    329     13960442   03-NOV-24 13960533   03-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
61      175.70M    DISK        00:00:02     03-NOV-24
        BP Key: 61   Status: EXPIRED  Compressed: NO  Tag: TAG20241103T112657
        Piece Name: /backup/fullbackup/arch_PDBDB_2d396r82_77

  List of Archived Logs in backup set 61
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    420     13809350   03-NOV-24 13847659   03-NOV-24
  1    421     13847659   03-NOV-24 13874106   03-NOV-24
  2    319     13788460   03-NOV-24 13845644   03-NOV-24
  2    320     13845644   03-NOV-24 13866066   03-NOV-24
  2    321     13866066   03-NOV-24 13866256   03-NOV-24
  2    322     13866256   03-NOV-24 13873989   03-NOV-24
  2    323     13873989   03-NOV-24 13878104   03-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
62      184.51M    DISK        00:00:01     03-NOV-24
        BP Key: 62   Status: EXPIRED  Compressed: NO  Tag: TAG20241103T112657
        Piece Name: /backup/fullbackup/arch_PDBDB_2c396r82_76

  List of Archived Logs in backup set 62
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    417     13654891   02-NOV-24 13704391   02-NOV-24
  1    418     13704391   02-NOV-24 13750023   02-NOV-24
  1    419     13750023   02-NOV-24 13809350   03-NOV-24
  2    314     13654869   02-NOV-24 13654903   02-NOV-24
  2    315     13654903   02-NOV-24 13686829   02-NOV-24
  2    316     13686829   02-NOV-24 13717491   02-NOV-24
  2    317     13717491   02-NOV-24 13750404   02-NOV-24
  2    318     13750404   02-NOV-24 13788460   03-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
63      123.10M    DISK        00:00:04     03-NOV-24
        BP Key: 63   Status: EXPIRED  Compressed: NO  Tag: TAG20241103T112657
        Piece Name: /backup/fullbackup/arch_PDBDB_2e396r82_78

  List of Archived Logs in backup set 63
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    422     13874106   03-NOV-24 13929439   03-NOV-24
  1    423     13929439   03-NOV-24 13960433   03-NOV-24
  1    424     13960433   03-NOV-24 13960491   03-NOV-24
  1    425     13960491   03-NOV-24 13960504   03-NOV-24
  1    426     13960504   03-NOV-24 13960519   03-NOV-24
  1    427     13960519   03-NOV-24 13974810   03-NOV-24
  2    324     13878104   03-NOV-24 13910736   03-NOV-24
  2    325     13910736   03-NOV-24 13949254   03-NOV-24
  2    326     13949254   03-NOV-24 13960401   03-NOV-24
  2    327     13960401   03-NOV-24 13960422   03-NOV-24
  2    328     13960422   03-NOV-24 13960442   03-NOV-24
  2    329     13960442   03-NOV-24 13960533   03-NOV-24
  2    330     13960533   03-NOV-24 13960545   03-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
64      9.54M      DISK        00:00:01     03-NOV-24
        BP Key: 64   Status: EXPIRED  Compressed: NO  Tag: TAG20241103T112657
        Piece Name: /backup/fullbackup/arch_PDBDB_2f396r85_79

  List of Archived Logs in backup set 64
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    428     13974810   03-NOV-24 13974835   03-NOV-24
  1    429     13974835   03-NOV-24 13975462   03-NOV-24
  1    430     13975462   03-NOV-24 13975486   03-NOV-24
  1    431     13975486   03-NOV-24 13975507   03-NOV-24
  1    432     13975507   03-NOV-24 13982887   03-NOV-24
  1    433     13982887   03-NOV-24 13983058   03-NOV-24
  1    434     13983058   03-NOV-24 13983072   03-NOV-24
  2    331     13960545   03-NOV-24 13975479   03-NOV-24
  2    332     13975479   03-NOV-24 13975501   03-NOV-24
  2    333     13975501   03-NOV-24 13983063   03-NOV-24
  2    334     13983063   03-NOV-24 13983081   03-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
77      184.51M    DISK        00:00:01     03-NOV-24
        BP Key: 77   Status: AVAILABLE  Compressed: NO  Tag: TAG20241103T112918
        Piece Name: /backup/fullbackup/arch_PDBDB_2s396rcf_92

  List of Archived Logs in backup set 77
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    417     13654891   02-NOV-24 13704391   02-NOV-24
  1    418     13704391   02-NOV-24 13750023   02-NOV-24
  1    419     13750023   02-NOV-24 13809350   03-NOV-24
  2    314     13654869   02-NOV-24 13654903   02-NOV-24
  2    315     13654903   02-NOV-24 13686829   02-NOV-24
  2    316     13686829   02-NOV-24 13717491   02-NOV-24
  2    317     13717491   02-NOV-24 13750404   02-NOV-24
  2    318     13750404   02-NOV-24 13788460   03-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
78      175.70M    DISK        00:00:02     03-NOV-24
        BP Key: 78   Status: AVAILABLE  Compressed: NO  Tag: TAG20241103T112918
        Piece Name: /backup/fullbackup/arch_PDBDB_2t396rcf_93

  List of Archived Logs in backup set 78
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    420     13809350   03-NOV-24 13847659   03-NOV-24
  1    421     13847659   03-NOV-24 13874106   03-NOV-24
  2    319     13788460   03-NOV-24 13845644   03-NOV-24
  2    320     13845644   03-NOV-24 13866066   03-NOV-24
  2    321     13866066   03-NOV-24 13866256   03-NOV-24
  2    322     13866256   03-NOV-24 13873989   03-NOV-24
  2    323     13873989   03-NOV-24 13878104   03-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
79      3.11M      DISK        00:00:01     03-NOV-24
        BP Key: 79   Status: AVAILABLE  Compressed: NO  Tag: TAG20241103T112918
        Piece Name: /backup/fullbackup/arch_PDBDB_2v396rci_95

  List of Archived Logs in backup set 79
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    429     13974835   03-NOV-24 13975462   03-NOV-24
  1    430     13975462   03-NOV-24 13975486   03-NOV-24
  1    431     13975486   03-NOV-24 13975507   03-NOV-24
  1    432     13975507   03-NOV-24 13982887   03-NOV-24
  1    433     13982887   03-NOV-24 13983058   03-NOV-24
  1    434     13983058   03-NOV-24 13983072   03-NOV-24
  1    435     13983072   03-NOV-24 13983610   03-NOV-24
  1    436     13983610   03-NOV-24 13983807   03-NOV-24
  1    437     13983807   03-NOV-24 13983827   03-NOV-24
  2    332     13975479   03-NOV-24 13975501   03-NOV-24
  2    333     13975501   03-NOV-24 13983063   03-NOV-24
  2    334     13983063   03-NOV-24 13983081   03-NOV-24
  2    335     13983081   03-NOV-24 13983818   03-NOV-24
  2    336     13983818   03-NOV-24 13983840   03-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
80      129.74M    DISK        00:00:04     03-NOV-24
        BP Key: 80   Status: AVAILABLE  Compressed: NO  Tag: TAG20241103T112918
        Piece Name: /backup/fullbackup/arch_PDBDB_2u396rcf_94

  List of Archived Logs in backup set 80
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    422     13874106   03-NOV-24 13929439   03-NOV-24
  1    423     13929439   03-NOV-24 13960433   03-NOV-24
  1    424     13960433   03-NOV-24 13960491   03-NOV-24
  1    425     13960491   03-NOV-24 13960504   03-NOV-24
  1    426     13960504   03-NOV-24 13960519   03-NOV-24
  1    427     13960519   03-NOV-24 13974810   03-NOV-24
  1    428     13974810   03-NOV-24 13974835   03-NOV-24
  2    324     13878104   03-NOV-24 13910736   03-NOV-24
  2    325     13910736   03-NOV-24 13949254   03-NOV-24
  2    326     13949254   03-NOV-24 13960401   03-NOV-24
  2    327     13960401   03-NOV-24 13960422   03-NOV-24
  2    328     13960422   03-NOV-24 13960442   03-NOV-24
  2    329     13960442   03-NOV-24 13960533   03-NOV-24
  2    330     13960533   03-NOV-24 13960545   03-NOV-24
  2    331     13960545   03-NOV-24 13975479   03-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
81      184.51M    DISK        00:00:00     03-NOV-24
        BP Key: 81   Status: AVAILABLE  Compressed: NO  Tag: TAG20241103T113328
        Piece Name: /backup/fullbackup/arch_PDBDB_32396rk9_98

  List of Archived Logs in backup set 81
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    417     13654891   02-NOV-24 13704391   02-NOV-24
  1    418     13704391   02-NOV-24 13750023   02-NOV-24
  1    419     13750023   02-NOV-24 13809350   03-NOV-24
  2    314     13654869   02-NOV-24 13654903   02-NOV-24
  2    315     13654903   02-NOV-24 13686829   02-NOV-24
  2    316     13686829   02-NOV-24 13717491   02-NOV-24
  2    317     13717491   02-NOV-24 13750404   02-NOV-24
  2    318     13750404   02-NOV-24 13788460   03-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
82      175.70M    DISK        00:00:01     03-NOV-24
        BP Key: 82   Status: AVAILABLE  Compressed: NO  Tag: TAG20241103T113328
        Piece Name: /backup/fullbackup/arch_PDBDB_33396rk9_99

  List of Archived Logs in backup set 82
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    420     13809350   03-NOV-24 13847659   03-NOV-24
  1    421     13847659   03-NOV-24 13874106   03-NOV-24
  2    319     13788460   03-NOV-24 13845644   03-NOV-24
  2    320     13845644   03-NOV-24 13866066   03-NOV-24
  2    321     13866066   03-NOV-24 13866256   03-NOV-24
  2    322     13866256   03-NOV-24 13873989   03-NOV-24
  2    323     13873989   03-NOV-24 13878104   03-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
83      129.90M    DISK        00:00:03     03-NOV-24
        BP Key: 83   Status: AVAILABLE  Compressed: NO  Tag: TAG20241103T113328
        Piece Name: /backup/fullbackup/arch_PDBDB_34396rk9_100

  List of Archived Logs in backup set 83
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    422     13874106   03-NOV-24 13929439   03-NOV-24
  1    423     13929439   03-NOV-24 13960433   03-NOV-24
  1    424     13960433   03-NOV-24 13960491   03-NOV-24
  1    425     13960491   03-NOV-24 13960504   03-NOV-24
  1    426     13960504   03-NOV-24 13960519   03-NOV-24
  1    427     13960519   03-NOV-24 13974810   03-NOV-24
  1    428     13974810   03-NOV-24 13974835   03-NOV-24
  1    429     13974835   03-NOV-24 13975462   03-NOV-24
  1    430     13975462   03-NOV-24 13975486   03-NOV-24
  2    324     13878104   03-NOV-24 13910736   03-NOV-24
  2    325     13910736   03-NOV-24 13949254   03-NOV-24
  2    326     13949254   03-NOV-24 13960401   03-NOV-24
  2    327     13960401   03-NOV-24 13960422   03-NOV-24
  2    328     13960422   03-NOV-24 13960442   03-NOV-24
  2    329     13960442   03-NOV-24 13960533   03-NOV-24
  2    330     13960533   03-NOV-24 13960545   03-NOV-24
  2    331     13960545   03-NOV-24 13975479   03-NOV-24
  2    332     13975479   03-NOV-24 13975501   03-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
84      3.28M      DISK        00:00:00     03-NOV-24
        BP Key: 84   Status: AVAILABLE  Compressed: NO  Tag: TAG20241103T113328
        Piece Name: /backup/fullbackup/arch_PDBDB_35396rki_101

  List of Archived Logs in backup set 84
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    431     13975486   03-NOV-24 13975507   03-NOV-24
  1    432     13975507   03-NOV-24 13982887   03-NOV-24
  1    433     13982887   03-NOV-24 13983058   03-NOV-24
  1    434     13983058   03-NOV-24 13983072   03-NOV-24
  1    435     13983072   03-NOV-24 13983610   03-NOV-24
  1    436     13983610   03-NOV-24 13983807   03-NOV-24
  1    437     13983807   03-NOV-24 13983827   03-NOV-24
  1    438     13983827   03-NOV-24 13984149   03-NOV-24
  1    439     13984149   03-NOV-24 13984159   03-NOV-24
  1    440     13984159   03-NOV-24 13984771   03-NOV-24
  1    441     13984771   03-NOV-24 13984784   03-NOV-24
  2    333     13975501   03-NOV-24 13983063   03-NOV-24
  2    334     13983063   03-NOV-24 13983081   03-NOV-24
  2    335     13983081   03-NOV-24 13983818   03-NOV-24
  2    336     13983818   03-NOV-24 13983840   03-NOV-24
  2    337     13983840   03-NOV-24 13984188   03-NOV-24
  2    338     13984188   03-NOV-24 13984202   03-NOV-24
  2    339     13984202   03-NOV-24 13984806   03-NOV-24

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
85      12.00K     DISK        00:00:00     03-NOV-24
        BP Key: 85   Status: AVAILABLE  Compressed: NO  Tag: TAG20241103T113328
        Piece Name: /backup/fullbackup/arch_PDBDB_36396rki_102

  List of Archived Logs in backup set 85
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    442     13984784   03-NOV-24 13984845   03-NOV-24
  2    340     13984806   03-NOV-24 13984842   03-NOV-24

-- Step 111.1.8 -->> On Node 1 - SandBox
RMAN> run
{
 ALLOCATE CHANNEL t1 TYPE DISK;
 ALLOCATE CHANNEL t2 TYPE DISK;
 ALLOCATE CHANNEL t3 TYPE DISK;
 ALLOCATE CHANNEL t4 TYPE DISK;
 RESTORE DATABASE;
 RECOVER DATABASE until sequence 442 thread 1;
 RECOVER DATABASE until sequence 340 thread 2;
 RELEASE CHANNEL t1;
 RELEASE CHANNEL t2;
 RELEASE CHANNEL t3;
 RELEASE CHANNEL t4;
}

released channel: ORA_DISK_1
released channel: ORA_DISK_2
released channel: ORA_DISK_3
released channel: ORA_DISK_4
allocated channel: t1
channel t1: SID=152 instance=pdbdb1 device type=DISK

allocated channel: t2
channel t2: SID=280 instance=pdbdb1 device type=DISK

allocated channel: t3
channel t3: SID=403 instance=pdbdb1 device type=DISK

allocated channel: t4
channel t4: SID=26 instance=pdbdb1 device type=DISK

Starting restore at 03-NOV-24

channel t1: starting datafile backup set restore
channel t1: specifying datafile(s) to restore from backup set
channel t1: restoring datafile 00013 to +DATA/PDBDB/2351E15D26626035E063150610AC7E23/DATAFILE/undo_2.277.1181048079
channel t1: restoring datafile 00016 to +DATA/PDBDB/2351E15D26626035E063150610AC7E23/DATAFILE/tbs_snapshot.304.1182439785
channel t1: reading from backup piece /backup/fullbackup/database_PDBDB_2k396rb3_84
channel t2: starting datafile backup set restore
channel t2: specifying datafile(s) to restore from backup set
channel t2: restoring datafile 00012 to +DATA/PDBDB/2351E15D26626035E063150610AC7E23/DATAFILE/undotbs1.273.1181048049
channel t2: restoring datafile 00015 to +DATA/PDBDB/2351E15D26626035E063150610AC7E23/DATAFILE/tbs_backup.279.1181217557
channel t2: reading from backup piece /backup/fullbackup/database_PDBDB_2j396rb3_83
channel t3: starting datafile backup set restore
channel t3: specifying datafile(s) to restore from backup set
channel t3: restoring datafile 00004 to +DATA/PDBDB/DATAFILE/undotbs1.259.1181045317
channel t3: restoring datafile 00009 to +DATA/PDBDB/DATAFILE/undotbs2.269.1181046999
channel t3: reading from backup piece /backup/fullbackup/database_PDBDB_2m396rbb_86
channel t4: starting datafile backup set restore
channel t4: specifying datafile(s) to restore from backup set
channel t4: restoring datafile 00003 to +DATA/PDBDB/DATAFILE/sysaux.258.1181045291
channel t4: reading from backup piece /backup/fullbackup/database_PDBDB_2i396rb3_82
channel t3: piece handle=/backup/fullbackup/database_PDBDB_2m396rbb_86 tag=TAG20241103T112834
channel t3: restored backup piece 1
channel t3: restore complete, elapsed time: 00:00:25
channel t3: starting datafile backup set restore
channel t3: specifying datafile(s) to restore from backup set
channel t3: restoring datafile 00001 to +DATA/PDBDB/DATAFILE/system.257.1181045247
channel t3: restoring datafile 00007 to +DATA/PDBDB/DATAFILE/users.260.1181045319
channel t3: reading from backup piece /backup/fullbackup/database_PDBDB_2l396rbb_85
channel t1: piece handle=/backup/fullbackup/database_PDBDB_2k396rb3_84 tag=TAG20241103T112834
channel t1: restored backup piece 1
channel t1: restore complete, elapsed time: 00:00:28
channel t1: starting datafile backup set restore
channel t1: specifying datafile(s) to restore from backup set
channel t1: restoring datafile 00006 to +DATA/PDBDB/86B637B62FE07A65E053F706E80A27CA/DATAFILE/sysaux.266.1181046729
channel t1: reading from backup piece /backup/fullbackup/database_PDBDB_2o396rbn_88
channel t2: piece handle=/backup/fullbackup/database_PDBDB_2j396rb3_83 tag=TAG20241103T112834
channel t2: restored backup piece 1
channel t2: restore complete, elapsed time: 00:00:28
channel t2: starting datafile backup set restore
channel t2: specifying datafile(s) to restore from backup set
channel t2: restoring datafile 00005 to +DATA/PDBDB/86B637B62FE07A65E053F706E80A27CA/DATAFILE/system.265.1181046729
channel t2: reading from backup piece /backup/fullbackup/database_PDBDB_2p396rbr_89
channel t4: piece handle=/backup/fullbackup/database_PDBDB_2i396rb3_82 tag=TAG20241103T112834
channel t4: restored backup piece 1
channel t4: restore complete, elapsed time: 00:00:28
channel t4: starting datafile backup set restore
channel t4: specifying datafile(s) to restore from backup set
channel t4: restoring datafile 00008 to +DATA/PDBDB/86B637B62FE07A65E053F706E80A27CA/DATAFILE/undotbs1.267.1181046729
channel t4: reading from backup piece /backup/fullbackup/database_PDBDB_2q396rbu_90
channel t1: piece handle=/backup/fullbackup/database_PDBDB_2o396rbn_88 tag=TAG20241103T112834
channel t1: restored backup piece 1
channel t1: restore complete, elapsed time: 00:00:07
channel t1: starting datafile backup set restore
channel t1: specifying datafile(s) to restore from backup set
channel t1: restoring datafile 00010 to +DATA/PDBDB/2351E15D26626035E063150610AC7E23/DATAFILE/system.274.1181048049
channel t1: restoring datafile 00011 to +DATA/PDBDB/2351E15D26626035E063150610AC7E23/DATAFILE/sysaux.275.1181048049
channel t1: restoring datafile 00014 to +DATA/PDBDB/2351E15D26626035E063150610AC7E23/DATAFILE/users.278.1181048083
channel t1: reading from backup piece /backup/fullbackup/database_PDBDB_2n396rbf_87
channel t4: piece handle=/backup/fullbackup/database_PDBDB_2q396rbu_90 tag=TAG20241103T112834
channel t4: restored backup piece 1
channel t4: restore complete, elapsed time: 00:00:08
channel t2: piece handle=/backup/fullbackup/database_PDBDB_2p396rbr_89 tag=TAG20241103T112834
channel t2: restored backup piece 1
channel t2: restore complete, elapsed time: 00:00:08
channel t3: piece handle=/backup/fullbackup/database_PDBDB_2l396rbb_85 tag=TAG20241103T112834
channel t3: restored backup piece 1
channel t3: restore complete, elapsed time: 00:00:18
channel t1: piece handle=/backup/fullbackup/database_PDBDB_2n396rbf_87 tag=TAG20241103T112834
channel t1: restored backup piece 1
channel t1: restore complete, elapsed time: 00:00:16
Finished restore at 03-NOV-24

Starting recover at 03-NOV-24

starting media recovery

channel t1: starting archived log restore to default destination
channel t1: restoring archived log
archived log thread=2 sequence=335
channel t1: restoring archived log
archived log thread=1 sequence=436
channel t1: restoring archived log
archived log thread=1 sequence=437
channel t1: restoring archived log
archived log thread=2 sequence=336
channel t1: restoring archived log
archived log thread=1 sequence=438
channel t1: restoring archived log
archived log thread=2 sequence=337
channel t1: restoring archived log
archived log thread=1 sequence=439
channel t1: restoring archived log
archived log thread=1 sequence=440
channel t1: restoring archived log
archived log thread=2 sequence=338
channel t1: restoring archived log
archived log thread=2 sequence=339
channel t1: restoring archived log
archived log thread=1 sequence=441
channel t1: reading from backup piece /backup/fullbackup/arch_PDBDB_35396rki_101
channel t2: starting archived log restore to default destination
channel t2: restoring archived log
archived log thread=2 sequence=340
channel t2: reading from backup piece /backup/fullbackup/arch_PDBDB_36396rki_102
channel t1: piece handle=/backup/fullbackup/arch_PDBDB_35396rki_101 tag=TAG20241103T113328
channel t1: restored backup piece 1
channel t1: restore complete, elapsed time: 00:00:01
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_436.265.1184068523 thread=1 sequence=436
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_335.260.1184068523 thread=2 sequence=335
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_436.265.1184068523 RECID=7 STAMP=1184068522
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_437.282.1184068523 thread=1 sequence=437
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_335.260.1184068523 RECID=5 STAMP=1184068522
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_336.256.1184068523 thread=2 sequence=336
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_437.282.1184068523 RECID=12 STAMP=1184068523
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_438.258.1184068523 thread=1 sequence=438
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_336.256.1184068523 RECID=11 STAMP=1184068523
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_337.259.1184068523 thread=2 sequence=337
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_438.258.1184068523 RECID=4 STAMP=1184068522
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_439.292.1184068523 thread=1 sequence=439
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_439.292.1184068523 RECID=8 STAMP=1184068522
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_440.262.1184068523 thread=1 sequence=440
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_337.259.1184068523 RECID=6 STAMP=1184068522
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_338.274.1184068523 thread=2 sequence=338
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_338.274.1184068523 RECID=9 STAMP=1184068522
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_339.261.1184068523 thread=2 sequence=339
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_440.262.1184068523 RECID=2 STAMP=1184068522
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_441.288.1184068523 thread=1 sequence=441
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_441.288.1184068523 RECID=10 STAMP=1184068522
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_339.261.1184068523 RECID=3 STAMP=1184068522
media recovery complete, elapsed time: 00:00:03
channel t2: piece handle=/backup/fullbackup/arch_PDBDB_36396rki_102 tag=TAG20241103T113328
channel t2: restored backup piece 1
channel t2: restore complete, elapsed time: 00:00:04
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_340.263.1184068523 RECID=1 STAMP=1184068522
Finished recover at 03-NOV-24

Starting recover at 03-NOV-24

starting media recovery

channel t1: starting archived log restore to default destination
channel t1: restoring archived log
archived log thread=2 sequence=339
channel t1: reading from backup piece /backup/fullbackup/arch_PDBDB_35396rki_101
channel t2: starting archived log restore to default destination
channel t2: restoring archived log
archived log thread=1 sequence=442
channel t2: reading from backup piece /backup/fullbackup/arch_PDBDB_36396rki_102
channel t1: piece handle=/backup/fullbackup/arch_PDBDB_35396rki_101 tag=TAG20241103T113328
channel t1: restored backup piece 1
channel t1: restore complete, elapsed time: 00:00:01
channel t2: piece handle=/backup/fullbackup/arch_PDBDB_36396rki_102 tag=TAG20241103T113328
channel t2: restored backup piece 1
channel t2: restore complete, elapsed time: 00:00:01
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_442.261.1184068529 thread=1 sequence=442
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_339.263.1184068529 thread=2 sequence=339
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_339.263.1184068529 RECID=13 STAMP=1184068528
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_442.261.1184068529 RECID=14 STAMP=1184068528
media recovery complete, elapsed time: 00:00:01
Finished recover at 03-NOV-24

released channel: t1

released channel: t2

released channel: t3

released channel: t4

-- Step 111.1.9 -->> On Node 1 - SandBox
RMAN> recover database;

Starting recover at 03-NOV-24
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=152 instance=pdbdb1 device type=DISK
allocated channel: ORA_DISK_2
channel ORA_DISK_2: SID=280 instance=pdbdb1 device type=DISK
allocated channel: ORA_DISK_3
channel ORA_DISK_3: SID=403 instance=pdbdb1 device type=DISK
allocated channel: ORA_DISK_4
channel ORA_DISK_4: SID=26 instance=pdbdb1 device type=DISK

starting media recovery

channel ORA_DISK_1: starting archived log restore to default destination
channel ORA_DISK_1: restoring archived log
archived log thread=1 sequence=442
channel ORA_DISK_1: restoring archived log
archived log thread=2 sequence=340
channel ORA_DISK_1: reading from backup piece /backup/fullbackup/arch_PDBDB_36396rki_102
channel ORA_DISK_1: piece handle=/backup/fullbackup/arch_PDBDB_36396rki_102 tag=TAG20241103T113328
channel ORA_DISK_1: restored backup piece 1
channel ORA_DISK_1: restore complete, elapsed time: 00:00:01
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_340.263.1184068601 thread=2 sequence=340
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_442.261.1184068601 thread=1 sequence=442
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_340.263.1184068601 RECID=16 STAMP=1184068600
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_442.261.1184068601 RECID=15 STAMP=1184068600
media recovery complete, elapsed time: 00:00:00
Finished recover at 03-NOV-24

-- Step 111.1.10 -->> On Node 1 - SandBox
RMAN> recover database;

Starting recover at 03-NOV-24
using channel ORA_DISK_1
using channel ORA_DISK_2
using channel ORA_DISK_3
using channel ORA_DISK_4

starting media recovery

media recovery complete, elapsed time: 00:00:00
channel ORA_DISK_1: starting archived log restore to default destination
channel ORA_DISK_1: restoring archived log
archived log thread=1 sequence=442
channel ORA_DISK_1: reading from backup piece /backup/fullbackup/arch_PDBDB_36396rki_102
channel ORA_DISK_1: piece handle=/backup/fullbackup/arch_PDBDB_36396rki_102 tag=TAG20241103T113328
channel ORA_DISK_1: restored backup piece 1
channel ORA_DISK_1: restore complete, elapsed time: 00:00:01
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_442.261.1184068667 RECID=18 STAMP=1184068666
media recovery complete, elapsed time: 00:00:00
Finished recover at 03-NOV-24

RMAN> exit


Recovery Manager complete.
*/

-- Step 112 -->> On Node 1 - SandBox
[oracle@pdb ~]$ which srvctl
/*
/opt/app/oracle/product/19c/db_1/bin/srvctl
*/

-- Step 112.1 -->> On Node 1 - SandBox
[oracle@pdb ~]$ srvctl add database -d pdbdb -o /opt/app/oracle/product/19c/db_1 -r physical_standby -s mount

-- Step 112.2 -->> On Node 1 - SandBox
[oracle@pdb ~]$ srvctl modify database -d pdbdb -spfile +DATA/PDBDB/PARAMETERFILE/spfilepdbdb.ora

-- Step 112.3 -->> On Node 1 - SandBox
[oracle@pdb ~]$ srvctl modify database -d pdbdb -diskgroup "DATA,ARC"

-- Step 112.4 -->> On Node 1 - SandBox
[oracle@pdb ~]$ srvctl add instance -d pdbdb -i pdbdb1 -n pdb

-- Step 112.5 -->> On Node 1 - SandBox
[oracle@pdb ~]$ srvctl config database -d pdbdb
/*
Database unique name: pdbdb
Database name:
Oracle home: /opt/app/oracle/product/19c/db_1
Oracle user: oracle
Spfile: +DATA/PDBDB/PARAMETERFILE/spfilepdbdb.ora
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
Database instances: pdbdb1
Configured nodes: pdb
CSS critical: no
CPU count: 0
Memory target: 0
Maximum memory: 0
Default network number for database services:
Database is administrator managed
*/

-- Step 113 -->> On Node 1 - SandBox
[oracle@pdb ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Nov 3 11:59:58 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> shut immediate
ORA-01109: database not open


Database dismounted.
ORACLE instance shut down.
SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 114 -->> On Node 1 - SandBox
[oracle@pdb ~]$ srvctl start database -d pdbdb -o mount

-- Step 114.1 -->> On Node 1 - SandBox
[oracle@pdb ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is running on node pdb
*/

-- Step 114.2 -->> On Node 1 - SandBox
[oracle@pdb ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb. Instance status: Mounted (Closed).
*/

-- Step 115 -->> On Node 1 - SandBox
[oracle@pdb ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Nov 3 12:03:16 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       MOUNTED
         3 SBXPDB                         MOUNTED

SQL> select status,instance_name from gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
MOUNTED      pdbdb1

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           MOUNTED      03-NOV-24 pdb.unidev.org.np       MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           442          1
           340          2

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           441          1
           340          2

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 116 -->> On Node 1 - SandBox
[root@pdb ~]# su - grid
[grid@pdb ~]$ asmcmd -p
/*
ASMCMD [+] > cd +DATA/PDBDB/PASSWORD

ASMCMD [+DATA/PDBDB/PASSWORD] > pwcopy /backup/configfiles/orapwpdbdb1 +DATA/PDBDB/PASSWORD/orapwpdbdb
copying /backup/configfiles/orapwpdbdb1 -> +DATA/PDBDB/PASSWORD/orapwpdbdb

ASMCMD [+DATA/PDBDB/PASSWORD] > ls -l
Type      Redund  Striped  Time             Sys  Name
PASSWORD  UNPROT  COARSE   NOV 03 12:00:00  N    orapwpdbdb => +DATA/DB_UNKNOWN/PASSWORD/pwddb_unknown.265.1184069213

ASMCMD [+DATA/PDBDB/PASSWORD] > ls
orapwpdbdb

ASMCMD [+DATA/PDBDB/PASSWORD] > exit
*/

-- Step 116.1 -->> On Node 1 - SandBox
[oracle@pdb ~]$ srvctl modify database -d pdbdb -pwfile +DATA/PDBDB/PASSWORD/orapwpdbdb

-- Step 116.2 -->> On Node 1 - SandBox
[oracle@pdb ~]$ srvctl config database -d pdbdb
/*
Database unique name: pdbdb
Database name:
Oracle home: /opt/app/oracle/product/19c/db_1
Oracle user: oracle
Spfile: +DATA/PDBDB/PARAMETERFILE/spfilepdbdb.ora
Password file: +DATA/PDBDB/PASSWORD/orapwpdbdb
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
Database instances: pdbdb1
Configured nodes: pdb
CSS critical: no
CPU count: 0
Memory target: 0
Maximum memory: 0
Default network number for database services:
Database is administrator managed
*/

-- Step 117 -->> On Node 1 - SandBox
[oracle@pdb ~]$ tnsping pdbdb
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 03-NOV-2024 12:08:04

Copyright (c) 1997, 2024, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbm-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = pdbdb)))
OK (0 msec)
*/

-- Step 117.1 -->> On Node 1 - SandBox
[oracle@pdb ~]$ tnsping pdbdb1
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 03-NOV-2024 12:08:17

Copyright (c) 1997, 2024, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = 192.16.6.30)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = pdbdb)))
OK (0 msec)
*/

-- Step 117.2 -->> On Node 1 - SandBox
[oracle@pdb ~]$ tnsping sbxpdb
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 03-NOV-2024 12:08:36

Copyright (c) 1997, 2024, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbm-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = sbxpdb)))
OK (10 msec)
*/

-- Step 118 -->> On Node 1 - SandBox
[oracle@pdb ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 03-NOV-2024 12:08:57

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                02-NOV-2024 14:49:22
Uptime                    0 days 21 hr. 19 min. 34 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.30)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.31)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 119 -->> On Node 1 - SandBox
[root@pdb ~]# cd /opt/app/19c/grid/bin/

-- Step 119.1 -->> On Node 1 - SandBox
[root@pdb bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/

-- Step 119.2 -->> On Node 1 - SandBox
[root@pdb bin]# ./crsctl check cluster -all
/*
**************************************************************
pdb:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/

-- Step 119.3 -->> On Node 1 - SandBox
[root@pdb bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       pdb                      STABLE
ora.chad
               ONLINE  ONLINE       pdb                      STABLE
ora.net1.network
               ONLINE  ONLINE       pdb                      STABLE
ora.ons
               ONLINE  ONLINE       pdb                      STABLE
ora.proxy_advm
               OFFLINE OFFLINE      pdb                      STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ARC.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      STABLE
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      STABLE
ora.DATA.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdb                      STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdb                      STABLE
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       pdb                      STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      Started,STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      STABLE
ora.cvu
      1        ONLINE  ONLINE       pdb                      STABLE
ora.pdb.vip
      1        ONLINE  ONLINE       pdb                      STABLE
ora.pdbdb.db
      1        ONLINE  INTERMEDIATE pdb                      Mounted (Closed),HOME=/opt/app/oracle/product/19c/db_1,STABLE
ora.qosmserver
      1        ONLINE  ONLINE       pdb                      STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       pdb                      STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       pdb                      STABLE
ora.scan3.vip
      1        ONLINE  ONLINE       pdb                      STABLE
--------------------------------------------------------------------------------
*/

-- Step 120 -->> On Node 1 - SandBox
[oracle@pdb ~]$ adrci
/*
ADRCI: Release 19.0.0.0.0 - Production on Sat Nov 2 14:37:10 2024

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

No ADR base is set
adrci> exit
*/

-- Step 120.1 -->> On Node 1 - SandBox
[oracle@pdb ~]$ cd /opt/app/oracle/product/19c/db_1/
[oracle@pdb db_1]$ mkdir -p log/diag
[oracle@pdb db_1]$ mkdir -p log/pdbdb1/client
[oracle@pdb db_1]$ cd log
[oracle@pdb log]$ chown -R oracle:asmadmin diag

-- Step 120.2 -->> On Node 1 - DC
[oracle@pdb1 ~]$ scp -r /opt/app/oracle/product/19c/db_1/log/diag/adrci_dir.mif oracle@192.16.6.30:/opt/app/oracle/product/19c/db_1/log/diag/
/*
oracle@192.16.6.30's password:
adrci_dir.mif                                                                                                                                              100%   16     1.7KB/s   00:00
*/

-- Step 120.3 -->> On Node 1 - SandBox
[oracle@pdb ~]$ adrci
/*
ADRCI: Release 19.0.0.0.0 - Production on Sat Nov 2 14:38:57 2024

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

ADR base = "/opt/app/oracle"
adrci> show home
ADR Homes:
diag/rdbms/pdbdb/pdbdb1
diag/asm/+asm/+ASM1
diag/crs/pdb/crs
diag/clients/user_grid/host_3517462433_110
diag/clients/user_root/host_3517462433_110
diag/tnslsnr/pdb/asmnet1lsnr_asm
diag/tnslsnr/pdb/listener_scan1
diag/tnslsnr/pdb/listener_scan2
diag/tnslsnr/pdb/listener_scan3
diag/tnslsnr/pdb/listener
diag/asmcmd/user_grid/pdb.unidev.org.np
diag/kfod/pdb/kfod
adrci> exit
*/

-- Step 121 -->> On Node 1 - SandBox
[root@pdb ~]# cd /opt/app/19c/grid/bin/

-- Step 121.1 -->> On Node 1 - SandBox
[root@pdb bin]# ./crsctl stop cluster -all

-- Step 121.2 -->> On Node 1 - SandBox
[root@pdb bin]# ./crsctl start cluster -all

-- Step 121.3 -->> On Node 1 - SandBox
[root@pdb bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/

-- Step 121.4 -->> On Node 1 - SandBox
[root@pdb bin]# ./crsctl check cluster -all
/*
**************************************************************
pdb:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/

-- Step 121.5 -->> On Node 1 - SandBox
[root@pdb bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdb                      STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       pdb                      STABLE
ora.crf
      1        ONLINE  ONLINE       pdb                      STABLE
ora.crsd
      1        ONLINE  ONLINE       pdb                      STABLE
ora.cssd
      1        ONLINE  ONLINE       pdb                      STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       pdb                      STABLE
ora.ctssd
      1        ONLINE  ONLINE       pdb                      OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.drivers.acfs
      1        ONLINE  ONLINE       pdb                      STABLE
ora.evmd
      1        ONLINE  ONLINE       pdb                      STABLE
ora.gipcd
      1        ONLINE  ONLINE       pdb                      STABLE
ora.gpnpd
      1        ONLINE  ONLINE       pdb                      STABLE
ora.mdnsd
      1        ONLINE  ONLINE       pdb                      STABLE
ora.storage
      1        ONLINE  ONLINE       pdb                      STABLE
--------------------------------------------------------------------------------
*/

-- Step 121.6 -->> On Node 1 - SandBox
[root@pdb bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       pdb                      STABLE
ora.chad
               ONLINE  ONLINE       pdb                      STABLE
ora.net1.network
               ONLINE  ONLINE       pdb                      STABLE
ora.ons
               ONLINE  ONLINE       pdb                      STABLE
ora.proxy_advm
               OFFLINE OFFLINE      pdb                      STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ARC.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      STABLE
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      STABLE
ora.DATA.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdb                      STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdb                      STABLE
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       pdb                      STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      Started,STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       pdb                      STABLE
ora.cvu
      1        ONLINE  ONLINE       pdb                      STABLE
ora.pdb.vip
      1        ONLINE  ONLINE       pdb                      STABLE
ora.pdbdb.db
      1        ONLINE  INTERMEDIATE pdb                      Mounted (Closed),HOME=/opt/app/oracle/product/19c/db_1,STABLE
ora.qosmserver
      1        ONLINE  ONLINE       pdb                      STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       pdb                      STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       pdb                      STABLE
ora.scan3.vip
      1        ONLINE  ONLINE       pdb                      STABLE
--------------------------------------------------------------------------------
*/

-- Step 122 -->> On Node 1 - SandBox
[grid@pdb ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): pdb
*/

-- Step 123 -->> On Node 1 - SandBox
[grid@pdb ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 03-NOV-2024 12:14:23

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                03-NOV-2024 12:12:07
Uptime                    0 days 0 hr. 2 min. 16 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.30)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.31)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 124 -->> On Node 1 - SandBox
[grid@pdb ~]$ ps -ef | grep SCAN
/*
grid     1658385       1  0 12:12 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid     1658390       1  0 12:12 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid     1658393       1  0 12:12 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid     1669712 1669355  0 12:14 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 124.1 -->> On Node 1 - SandBox
[grid@pdb ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 03-NOV-2024 12:14:48

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                03-NOV-2024 12:12:08
Uptime                    0 days 0 hr. 2 min. 40 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.32)(PORT=1521)))
Services Summary...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 124.2 -->> On Node 1 - SandBox
[grid@pdb ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 03-NOV-2024 12:14:59

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                03-NOV-2024 12:12:08
Uptime                    0 days 0 hr. 2 min. 51 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.33)(PORT=1521)))
Services Summary...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 124.3 -->> On Node 1 - SandBox
[grid@pdb ~]$ lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 03-NOV-2024 12:15:19

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                03-NOV-2024 12:12:07
Uptime                    0 days 0 hr. 3 min. 11 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb/listener_scan3/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN3)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.34)(PORT=1521)))
Services Summary...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 125 -->> On Node 1 - SandBox
[oracle@pdb ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): pdb
*/

-- Step 126 -->> On Node 1 - SandBox
[oracle@pdb ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 03-NOV-2024 12:15:42

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                03-NOV-2024 12:12:07
Uptime                    0 days 0 hr. 3 min. 35 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.30)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.31)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 127 -->> On Node 1 - SandBox
[oracle@pdb ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is running on node pdb
*/

-- Step 127.1 -->> On Node 1 - SandBox
[oracle@pdb ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb. Instance status: Mounted (Closed).
*/

-- Step 128 -->> On Node 1 - SandBox
[oracle@pdb ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Nov 3 12:16:20 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           442          1
           340          2

SQL> SELECT inst_id,process,thread#,sequence#,block#,status FROM gv$managed_standby;

   INST_ID PROCESS      THREAD#  SEQUENCE#     BLOCK# STATUS
---------- --------- ---------- ---------- ---------- ------------
         1 ARCH               0          0          0 CONNECTED
         1 DGRD               0          0          0 ALLOCATED
         1 DGRD               0          0          0 ALLOCATED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               0          0          0 CONNECTED


SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           MOUNTED      03-NOV-24 pdb.unidev.org.np       MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED


SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

----------------------------------------------------------------
----------------Snapshot Standby Syncing------------------------
----------------------------------------------------------------

-- Step 129 -->> On Node 1 - SandBox
-- Verify the DB instance status
[oracle@pdb ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb. Instance status: Mounted (Closed).
*/

-- Step 129.1 -->> On Node 1 - SandBox
-- Verify the DB instance status
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
*/

-- Step 129.2 -->> On Node 1 - SandBox
-- Verify the DB instance status
SQL> show pdbs
/*
    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       MOUNTED
         3 SBXPDB                         MOUNTED
*/

-- Step 129.3 -->> On Node 1 - SandBox
-- Verify the DB instance status
SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;
/*
MAX(SEQUENCE#)    THREAD#
-------------- ----------
           441          1
           340          2
*/

-- Step 129.4 -->> On Node 1 - SandBox
-- Verify the DB instance status
SQL> SELECT inst_id,status,instance_name FROM gv$instance;
/*
   INST_ID STATUS       INSTANCE_NAME
---------- ------------ ----------------
         1 MOUNTED      pdbdb1
*/

-- Step 129.5 -->> On Node 1 - SandBox
-- Make sure the db_recovery_file_dest_size and location is set properly
-- Note The oracle parameter "db_recovery_file_dest_size" should be greater than 5GB
SQL> show parameters db_recovery_file_dest 
/*
NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_recovery_file_dest                string      +ARC
db_recovery_file_dest_size           big integer 50G
*/

-- Step 129.6 -->> On Node 1 - SandBox
-- Verify the restore point
SQL> SELECT inst_id,flashback_on FROM gv$database;
/*
   INST_ID FLASHBACK_ON
---------- ------------------
         1 NO
*/


-- Step 129.7 -->> On Node 1 - SandBox
--  Covert physical standby database to snapshot standby database
SQL> ALTER DATABASE CONVERT TO SNAPSHOT STANDBY;
/*
Database altered.
*/

-- Step 129.8 -->> On Node 1 - SandBox
-- The physical standby database in snapshot standby database status shoud be in mount mode
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           SNAPSHOT STANDBY MOUNTED
*/

-- Step 129.9 -->> On Node 1 - SandBox
-- Bring the database in open mode
SQL> ALTER DATABASE OPEN;
/*
Database altered.
*/

-- Step 129.10 -->> On Node 1 - SandBox
-- Bring the database in open mode
SQL> alter pluggable database all open;
/*
Pluggable database altered.
*/

-- Step 129.11 -->> On Node 1 - SandBox
-- Bring the database in open mode
SQL> show pdbs
/*
    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 SBXPDB                         READ WRITE NO
*/

-- Step 129.12 -->> On Node 1 - SandBox
-- Verify the DB instance status
SQL> SELECT inst_id,status,instance_name FROM gv$instance;
/*
   INST_ID STATUS       INSTANCE_NAME
---------- ------------ ----------------
         1 OPEN         pdbdb1
*/


-- Step 129.13 -->> On Node 1 - SandBox
-- Verify the restore point
SQL> SELECT inst_id,flashback_on FROM gv$database;
/*
   INST_ID FLASHBACK_ON
---------- ------------------
         1 RESTORE POINT ONLY
*/

-- Step 129.14 -->> On Node 1 - SandBox
-- Verify the Added objects on Primary Database -> DC and properly reflected on Syncing Database
SQL>  conn sys/Sys605014@SBXPDB as sysdba
/*
Connected.
*/

-- Step 129.15 -->> On Node 1 - SandBox
-- Verify the Added objects on Primary Database -> DC and properly reflected on Syncing Database
SQL> show user
/*
USER is "SYS"
*/

-- Step 129.16 -->> On Node 1 - SandBox
-- Verify the Added objects on Primary Database -> DC and properly reflected on Syncing Database
SQL> SELECT owner,table_name,status FROM dba_tables WHERE owner IN ('BACKUP','SNAPSHOT');
/*
OWNER    TABLE_NAME                 STATUS
-------- -------------------------- ------
BACKUP   TBL_IMPORT_HEAP            VALID 
BACKUP   TBL_TEST                   VALID 
BACKUP   TBL_NODE1                  VALID 
BACKUP   TBL_NODE2                  VALID 
SNAPSHOT SNAPSHOT_STANDBY_TEST      VALID 
BACKUP   TBL_TBL_BIG_ALBUM_SALES_PT VALID 
*/

-- Step 129.17 -->> On Node 1 - SandBox
-- Verification of object created from DC Node 1
SQL> SELECT * FROM backup.tbl_node1;
/*
C1   
-----
Node1
*/

-- Step 129.18 -->> On Node 1 - SandBox
-- Verification of object created from DC Node 2
SQL> SELECT * FROM backup.tbl_node2;
/*
C1   
-----
Node2
*/


-- Step 130 -->> On Node 1 - SandBox =>> (Covert back physical standby database from snapshot standby database.)
-- Shutdown the Syncing database
SQL> conn sys/Sys605014@PDBDB as sysdba
/*
Connected.
*/

-- Step 130.1 -->> On Node 1 - SandBox
SQL> show pdbs
/*
    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 SBXPDB                         READ WRITE NO
*/

-- Step 130.2 -->> On Node 1 - SandBox
SQL> shutdown immediate;
/*
Database closed.
Database dismounted.
ORACLE instance shut down.
*/

-- Step 130.3 -->> On Node 1 - SandBox
-- Bring the database in mount mode
SQL> startup mount;
/*
ORACLE instance started.

Total System Global Area 9663672664 bytes
Fixed Size                  9187672 bytes
Variable Size            2013265920 bytes
Database Buffers         7616856064 bytes
Redo Buffers               24363008 bytes
Database mounted.
*/

-- Step 130.4 -->> On Node 1 - SandBox
-- Covert back physical standby database from snapshot standby database
SQL> ALTER DATABASE CONVERT TO PHYSICAL STANDBY;
/*
Database altered.
*/

-- Step 130.5 -->> On Node 1 - SandBox
-- Shutdown the database
SQL> shutdown immediate;
/*
ORA-01109: database not open


Database dismounted.
ORACLE instance shut down.
*/

-- Step 130.6 -->> On Node 1 - SandBox
-- Bring the database in nomount mode
SQL> startup nomount;
/*
ORACLE instance started.

Total System Global Area 9663675432 bytes
Fixed Size                 13921320 bytes
Variable Size            1509949440 bytes
Database Buffers         8120172544 bytes
Redo Buffers               19632128 bytes
*/

-- Step 130.7 -->> On Node 1 - SandBox
-- Bring the database in mount mode
SQL> ALTER DATABASE MOUNT STANDBY DATABASE;
/*
Database altered.
*/

-- Step 130.8 -->> On Node 1 - SandBox
-- Verify the DB instance status
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
*/

-- Step 130.9 -->> On Node 1 - SandBox
-- Verify the DB services status
[oracle@pdb ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb. Instance status: Dismounted,Mount Initiated.
*/

-- Step 130.10 -->> On Node 1 - SandBox
-- To stop the DB services and status
[oracle@pdb ~]$ srvctl stop database -d pdbdb
[oracle@pdb ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is not running on node pdb
*/

-- Step 130.11 -->> On Node 1 - SandBox
-- To start the DB services and status
[oracle@pdb ~]$ srvctl start database -d pdbdb -o mount
[oracle@pdb ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb. Instance status: Mounted (Closed).
*/

-- Step 131 -->> On Node 1 - SandBox
[oracle@pdb ~]$ cd /backup/fullbackup/

-- Step 131.1 -->> On Node 1 - SandBox
[oracle@pdb fullbackup]$ rm -rf *

-- Step 131.2 -->> On Node 1 - SandBox
[oracle@pdb fullbackup]$ rman target /
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Sun Nov 3 13:00:02 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB (DBID=3239152647, not open)

RMAN> crosscheck backup;
RMAN> delete expired backup;
RMAN> crosscheck archivelog all;
RMAN> delete expired archivelog all;
RMAN> delete noprompt archivelog all;
RMAN> exit
Recovery Manager complete.
*/

-- Step 132 -->> On Node 1 - DC
-- Make changes on DC from Node1 and Node2
[oracle@pdb1 ~]$ sqlplus sys/Sys605014@sbxpdb as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Nov 3 13:03:44 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         3 SBXPDB                         READ WRITE NO

SQL> CREATE TABLE backup.tbl_test_node1 TABLESPACE tbs_backup
     AS
     SELECT LEVEL C1, LEVEL||'Node1' C2, LEVEL||SYSDATE C3
     FROM dual CONNECT BY LEVEL <=4;

Table created.

SQL> INSERT INTO backup.tbl_node1
     SELECT 'N1-v' c1 from dual;  2

1 row created.

SQL> COMMIT;

Commit complete.

SQL> conn sys/Sys605014@PDBDB as sysdba
Connected.

SQL> alter system switch logfile;

System altered.

SQL> alter system switch logfile;

System altered.

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           447          1
           344          2

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 132.1 -->> On Node 2 - DC
[oracle@pdb2 ~]$  sqlplus sys/Sys605014@sbxpdb as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Nov 3 13:03:54 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         3 SBXPDB                         READ WRITE NO

SQL> CREATE TABLE backup.tbl_test_node2 TABLESPACE tbs_backup
     AS
     SELECT LEVEL C1, LEVEL||'Node2' C2, LEVEL||SYSDATE C3
     FROM dual CONNECT BY LEVEL <=4;

Table created.

SQL> INSERT INTO backup.tbl_node1
     SELECT 'N2-v' c1 from dual;  2

1 row created.

SQL> COMMIT;

Commit complete.

SQL> DROP TABLE backup.tbl_node2 PURGE;

Table dropped.

SQL> conn sys/Sys605014@PDBDB as sysdba
Connected.

SQL> alter system switch logfile;

System altered.

SQL> alter system switch logfile;

System altered.

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           447          1
           344          2

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 132.2 -->> On Node 1 - DC
[oracle@pdb1 ~]$ rman target /
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Sun Nov 3 13:14:36 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB (DBID=3239152647)

-- Step 132.2.1 -->> On Node 1 - DC
RMAN> run
{
  ALLOCATE CHANNEL c1 DEVICE TYPE DISK MAXPIECESIZE 10G;
  ALLOCATE CHANNEL c2 DEVICE TYPE DISK MAXPIECESIZE 10G;
  ALLOCATE CHANNEL c3 DEVICE TYPE DISK MAXPIECESIZE 10G;

  SQL "ALTER SYSTEM SWITCH LOGFILE";

  SQL "ALTER SYSTEM ARCHIVE LOG CURRENT";
  BACKUP ARCHIVELOG ALL FORMAT '/backup/fullbackup/arch_%d_%u_%s';

  release channel c1;
  release channel c2;
  release channel c3;
}

using target database control file instead of recovery catalog
allocated channel: c1
channel c1: SID=426 instance=pdbdb1 device type=DISK

allocated channel: c2
channel c2: SID=36 instance=pdbdb1 device type=DISK

allocated channel: c3
channel c3: SID=170 instance=pdbdb1 device type=DISK

sql statement: ALTER SYSTEM SWITCH LOGFILE

sql statement: ALTER SYSTEM ARCHIVE LOG CURRENT

Starting backup at 03-NOV-24
current log archived
channel c1: starting archived log backup set
channel c1: specifying archived log(s) in backup set
input archived log thread=1 sequence=443 RECID=1308 STAMP=1184073062
channel c1: starting piece 1 at 03-NOV-24
channel c2: starting archived log backup set
channel c2: specifying archived log(s) in backup set
input archived log thread=1 sequence=442 RECID=1301 STAMP=1184067207
input archived log thread=2 sequence=341 RECID=1304 STAMP=1184073045
channel c2: starting piece 1 at 03-NOV-24
channel c3: starting archived log backup set
channel c3: specifying archived log(s) in backup set
input archived log thread=2 sequence=342 RECID=1305 STAMP=1184073047
input archived log thread=2 sequence=343 RECID=1315 STAMP=1184073313
input archived log thread=1 sequence=444 RECID=1309 STAMP=1184073062
input archived log thread=1 sequence=445 RECID=1311 STAMP=1184073308
channel c3: starting piece 1 at 03-NOV-24
channel c1: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/arch_PDBDB_383971j8_104 tag=TAG20241103T131519 comment=NONE
channel c1: backup set complete, elapsed time: 00:00:00
channel c1: starting archived log backup set
channel c1: specifying archived log(s) in backup set
input archived log thread=1 sequence=446 RECID=1313 STAMP=1184073308
input archived log thread=1 sequence=447 RECID=1317 STAMP=1184073316
input archived log thread=2 sequence=344 RECID=1319 STAMP=1184073319
channel c1: starting piece 1 at 03-NOV-24
channel c2: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/arch_PDBDB_393971j8_105 tag=TAG20241103T131519 comment=NONE
channel c2: backup set complete, elapsed time: 00:00:00
channel c3: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/arch_PDBDB_3a3971j8_106 tag=TAG20241103T131519 comment=NONE
channel c3: backup set complete, elapsed time: 00:00:00
channel c1: finished piece 1 at 03-NOV-24
piece handle=/backup/fullbackup/arch_PDBDB_3b3971j8_107 tag=TAG20241103T131519 comment=NONE
channel c1: backup set complete, elapsed time: 00:00:01
Finished backup at 03-NOV-24

Starting Control File and SPFILE Autobackup at 03-NOV-24
piece handle=+ARC/PDBDB/AUTOBACKUP/2024_11_03/s_1184073322.398.1184073323 comment=NONE
Finished Control File and SPFILE Autobackup at 03-NOV-24

released channel: c1

released channel: c2

released channel: c3

RMAN> exit

Recovery Manager complete.
*/

-- Step 132.3 -->> On Node 1 - DC
[oracle@pdb1 ~]$ scp -r /backup/fullbackup/* oracle@192.16.6.30:/backup/fullbackup/
/*
oracle@192.16.6.30's password: <- oracle
arch_PDBDB_383971j8_104                                    100%   14MB 153.8MB/s   00:00
arch_PDBDB_393971j8_105                                    100%   14MB 124.8MB/s   00:00
arch_PDBDB_3a3971j8_106                                    100%  420KB  72.5MB/s   00:00
arch_PDBDB_3b3971j8_107                                    100%   24KB  16.6MB/s   00:00
*/

-- Step 133 -->> On Node 1 - SandBox
[oracle@pdb ~]$ ll /backup/fullbackup/
/*
-rw-r----- 1 oracle oinstall 15188480 Nov  3 13:16 arch_PDBDB_383971j8_104
-rw-r----- 1 oracle oinstall 14356992 Nov  3 13:16 arch_PDBDB_393971j8_105
-rw-r----- 1 oracle oinstall   430080 Nov  3 13:16 arch_PDBDB_3a3971j8_106
-rw-r----- 1 oracle oinstall    24576 Nov  3 13:16 arch_PDBDB_3b3971j8_107
*/

-- Step 133.1 -->> On Node 1 - SandBox
[oracle@pdb ~]$ rman target /
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Sun Nov 3 13:17:41 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB (DBID=3239152647, not open)

-- Step 133.1.1 -->> On Node 1 - SandBox
RMAN> CATALOG START WITH '/backup/fullbackup/';

using target database control file instead of recovery catalog
searching for all files that match the pattern /backup/fullbackup/

List of Files Unknown to the Database
=====================================
File Name: /backup/fullbackup/arch_PDBDB_383971j8_104
File Name: /backup/fullbackup/arch_PDBDB_393971j8_105
File Name: /backup/fullbackup/arch_PDBDB_3a3971j8_106
File Name: /backup/fullbackup/arch_PDBDB_3b3971j8_107

Do you really want to catalog the above files (enter YES or NO)? YES
cataloging files...
cataloging done

List of Cataloged Files
=======================
File Name: /backup/fullbackup/arch_PDBDB_383971j8_104
File Name: /backup/fullbackup/arch_PDBDB_393971j8_105
File Name: /backup/fullbackup/arch_PDBDB_3a3971j8_106
File Name: /backup/fullbackup/arch_PDBDB_3b3971j8_107

-- Step 133.1.2 -->> On Node 1 - SandBox
RMAN> RECOVER DATABASE;

Starting recover at 03-NOV-24
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=279 instance=pdbdb1 device type=DISK
allocated channel: ORA_DISK_2
channel ORA_DISK_2: SID=393 instance=pdbdb1 device type=DISK
allocated channel: ORA_DISK_3
channel ORA_DISK_3: SID=26 instance=pdbdb1 device type=DISK
allocated channel: ORA_DISK_4
channel ORA_DISK_4: SID=154 instance=pdbdb1 device type=DISK

starting media recovery

channel ORA_DISK_1: starting archived log restore to default destination
channel ORA_DISK_1: restoring archived log
archived log thread=1 sequence=442
channel ORA_DISK_1: restoring archived log
archived log thread=2 sequence=341
channel ORA_DISK_1: reading from backup piece /backup/fullbackup/arch_PDBDB_393971j8_105
channel ORA_DISK_2: starting archived log restore to default destination
channel ORA_DISK_2: restoring archived log
archived log thread=1 sequence=443
channel ORA_DISK_2: reading from backup piece /backup/fullbackup/arch_PDBDB_383971j8_104
channel ORA_DISK_3: starting archived log restore to default destination
channel ORA_DISK_3: restoring archived log
archived log thread=2 sequence=342
channel ORA_DISK_3: restoring archived log
archived log thread=2 sequence=343
channel ORA_DISK_3: restoring archived log
archived log thread=1 sequence=444
channel ORA_DISK_3: restoring archived log
archived log thread=1 sequence=445
channel ORA_DISK_3: reading from backup piece /backup/fullbackup/arch_PDBDB_3a3971j8_106
channel ORA_DISK_4: starting archived log restore to default destination
channel ORA_DISK_4: restoring archived log
archived log thread=1 sequence=446
channel ORA_DISK_4: restoring archived log
archived log thread=1 sequence=447
channel ORA_DISK_4: restoring archived log
archived log thread=2 sequence=344
channel ORA_DISK_4: reading from backup piece /backup/fullbackup/arch_PDBDB_3b3971j8_107
channel ORA_DISK_1: piece handle=/backup/fullbackup/arch_PDBDB_393971j8_105 tag=TAG20241103T131519
channel ORA_DISK_1: restored backup piece 1
channel ORA_DISK_1: restore complete, elapsed time: 00:00:01
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_341.265.1184073533 thread=2 sequence=341
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_442.256.1184073533 thread=1 sequence=442
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_442.256.1184073533 RECID=21 STAMP=1184073533
channel ORA_DISK_2: piece handle=/backup/fullbackup/arch_PDBDB_383971j8_104 tag=TAG20241103T131519
channel ORA_DISK_2: restored backup piece 1
channel ORA_DISK_2: restore complete, elapsed time: 00:00:01
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_443.263.1184073533 thread=1 sequence=443
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_341.265.1184073533 RECID=23 STAMP=1184073533
channel ORA_DISK_3: piece handle=/backup/fullbackup/arch_PDBDB_3a3971j8_106 tag=TAG20241103T131519
channel ORA_DISK_3: restored backup piece 1
channel ORA_DISK_3: restore complete, elapsed time: 00:00:02
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_342.273.1184073533 thread=2 sequence=342
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_342.273.1184073533 RECID=29 STAMP=1184073533
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_343.291.1184073533 thread=2 sequence=343
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_443.263.1184073533 RECID=22 STAMP=1184073533
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_444.285.1184073533 thread=1 sequence=444
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_444.285.1184073533 RECID=30 STAMP=1184073533
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_445.261.1184073533 thread=1 sequence=445
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_445.261.1184073533 RECID=25 STAMP=1184073533
channel ORA_DISK_4: piece handle=/backup/fullbackup/arch_PDBDB_3b3971j8_107 tag=TAG20241103T131519
channel ORA_DISK_4: restored backup piece 1
channel ORA_DISK_4: restore complete, elapsed time: 00:00:03
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_446.287.1184073533 thread=1 sequence=446
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_446.287.1184073533 RECID=24 STAMP=1184073533
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_447.282.1184073533 thread=1 sequence=447
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_343.291.1184073533 RECID=27 STAMP=1184073533
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_344.269.1184073533 thread=2 sequence=344
channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_1_seq_447.282.1184073533 RECID=26 STAMP=1184073533
archived log thread=2 sequence=344
ORA-15028: ASM file '+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_344.269.1184073533' not dropped; currently being accessed

channel default: deleting archived log(s)
archived log file name=+ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_344.269.1184073533 RECID=28 STAMP=1184073533
media recovery complete, elapsed time: 00:00:01
Finished recover at 03-NOV-24

-- Step 133.1.3 -->> On Node 1 - SandBox
RMAN> RECOVER DATABASE;

Starting recover at 03-NOV-24
using channel ORA_DISK_1
using channel ORA_DISK_2
using channel ORA_DISK_3
using channel ORA_DISK_4

starting media recovery

archived log for thread 2 with sequence 344 is already on disk as file +ARC/PDBDB/ARCHIVELOG/2024_11_03/thread_2_seq_344.269.1184073533
media recovery complete, elapsed time: 00:00:00
Finished recover at 03-NOV-24

RMAN> exit

Recovery Manager complete.
*/

----------------------------------------------------------------
-------------Snapshot Standby Continue-Syncing------------------
----------------------------------------------------------------

-- Step 134 -->> On Node 1 - SandBox
-- Verify the DB instance status
[oracle@pdb ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb. Instance status: Mounted (Closed).
*/

-- Step 134.1 -->> On Node 1 - SandBox
-- Verify the DB instance status
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
*/

-- Step 134.2 -->> On Node 1 - SandBox
-- Verify the DB instance status
SQL> show pdbs
/*
    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       MOUNTED
         3 SBXPDB                         MOUNTED
*/

-- Step 134.3 -->> On Node 1 - SandBox
-- Verify the DB archive status
SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

/*
MAX(SEQUENCE#)    THREAD#
-------------- ----------
           447          1
           344          2
*/

-- Step 134.4 -->> On Node 1 - SandBox
-- Verify the DB archive status
SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;
/*
MAX(SEQUENCE#)    THREAD#
-------------- ----------
           447          1
           343          2
*/

-- Step 134.5 -->> On Node 1 - SandBox
-- Verify the restore point
SQL> SELECT inst_id,flashback_on FROM gv$database;
/*
   INST_ID FLASHBACK_ON
---------- ------------------
         1 NO
*/


-- Step 134.6 -->> On Node 1 - SandBox
--  Covert physical standby database to snapshot standby database
SQL> ALTER DATABASE CONVERT TO SNAPSHOT STANDBY;
/*
Database altered.
*/

-- Step 134.7 -->> On Node 1 - SandBox
-- The physical standby database in snapshot standby database status shoud be in mount mode
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           SNAPSHOT STANDBY MOUNTED
*/

-- Step 134.8 -->> On Node 1 - SandBox
-- Bring the database in open mode
SQL> ALTER DATABASE OPEN;
/*
Database altered.
*/

-- Step 134.9 -->> On Node 1 - SandBox
-- Bring the database in open mode
SQL> alter pluggable database all open;
/*
Pluggable database altered.
*/

-- Step 134.10 -->> On Node 1 - SandBox
-- Bring the database in open mode
SQL> show pdbs
/*
    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 SBXPDB                         READ WRITE NO
*/

-- Step 134.11 -->> On Node 1 - SandBox
-- Verify the DB instance status
SQL> SELECT inst_id,status,instance_name FROM gv$instance;
/*
   INST_ID STATUS       INSTANCE_NAME
---------- ------------ ----------------
         1 OPEN         pdbdb1
*/


-- Step 134.12 -->> On Node 1 - SandBox
-- Verify the restore point
SQL> SELECT inst_id,flashback_on FROM gv$database;
/*
   INST_ID FLASHBACK_ON
---------- ------------------
         1 RESTORE POINT ONLY
*/

-- Step 134.13 -->> On Node 1 - SandBox
-- Verify the Added objects on Primary Database -> DC and properly reflected on Syncing Database
SQL>  conn sys/Sys605014@SBXPDB as sysdba
/*
Connected.
*/

-- Step 134.14 -->> On Node 1 - SandBox
-- Verify the Added objects on Primary Database -> DC and properly reflected on Syncing Database
SQL> show user
/*
USER is "SYS"
*/

-- Step 134.15 -->> On Node 1 - SandBox
-- Verify the Added objects on Primary Database -> DC and properly reflected on Syncing Database
SQL> SELECT owner,table_name,status FROM dba_tables WHERE owner IN ('BACKUP','SNAPSHOT');
/*
OWNER    TABLE_NAME                 STATUS
-------- -------------------------- ------
BACKUP   TBL_IMPORT_HEAP            VALID 
BACKUP   TBL_TEST                   VALID 
BACKUP   TBL_NODE1                  VALID 
BACKUP   TBL_TEST_NODE2             VALID 
BACKUP   TBL_TEST_NODE1             VALID 
SNAPSHOT SNAPSHOT_STANDBY_TEST      VALID 
BACKUP   TBL_TBL_BIG_ALBUM_SALES_PT VALID 
*/

-- Step 134.16 -->> On Node 1 - SandBox
-- Verification of object created from DC Node 1
SQL> SELECT * FROM backup.tbl_node1;
/*
C1   
-----
Node1
N2-v 
N1-v 
*/

-- Step 134.17 -->> On Node 1 - SandBox
-- Verification of object created from DC Node 2
SQL> SELECT * FROM backup.tbl_node2;
/*
ORA-00942: table or view does not exist
*/

-- Step 134.18 -->> On Node 1 - SandBox
SQL> SELECT * FROM backup.tbl_test_node1;
/*
C1 C2     C3        
-- ------ ----------
 1 1Node1 103-NOV-24
 2 2Node1 203-NOV-24
 3 3Node1 303-NOV-24
 4 4Node1 403-NOV-24
*/

-- Step 134.19 -->> On Node 1 - SandBox
SQL> SELECT * FROM backup.tbl_test_node2;
/*
C1 C2     C3        
-- ------ ----------
 1 1Node2 103-NOV-24
 2 2Node2 203-NOV-24
 3 3Node2 303-NOV-24
 4 4Node2 403-NOV-24
*/

-- Step 134.20 -->> On Node 1 - SandBox =>> (Covert back physical standby database from snapshot standby database.)
-- Shutdown the DR database
SQL> conn sys/Sys605014@PDBDB as sysdba
/*
Connected.
*/

-- Step 134.21 -->> On Node 1 - SandBox
SQL> show pdbs
/*
    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 SBXPDB                         READ WRITE NO
*/

-- Step 134.22 -->> On Node 1 - SandBox
SQL> shutdown immediate;
/*
Database closed.
Database dismounted.
ORACLE instance shut down.
*/

-- Step 134.23 -->> On Node 1 - SandBox
-- Bring the database in mount mode
SQL> startup mount;
/*
ORACLE instance started.

Total System Global Area 9663672664 bytes
Fixed Size                  9187672 bytes
Variable Size            2013265920 bytes
Database Buffers         7616856064 bytes
Redo Buffers               24363008 bytes
Database mounted.
*/

-- Step 134.24 -->> On Node 1 - SandBox
-- Covert back physical standby database from snapshot standby database
SQL> ALTER DATABASE CONVERT TO PHYSICAL STANDBY;
/*
Database altered.
*/

-- Step 134.25 -->> On Node 1 - SandBox
-- Shutdown the database
SQL> shutdown immediate;
/*
ORA-01109: database not open


Database dismounted.
ORACLE instance shut down.
*/

-- Step 134.26 -->> On Node 1 - SandBox
-- Bring the database in nomount mode
SQL> startup nomount;
/*
ORACLE instance started.

Total System Global Area 9663672664 bytes
Fixed Size                  9187672 bytes
Variable Size            2013265920 bytes
Database Buffers         7616856064 bytes
Redo Buffers               24363008 bytes
*/

-- Step 134.27 -->> On Node 1 - SandBox
-- Bring the database in mount mode
SQL> ALTER DATABASE MOUNT STANDBY DATABASE;
/*
Database altered.
*/

-- Step 134.28 -->> On Node 1 - SandBox
-- Verify the DB instance status
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
*/

-- Step 134.29 -->> On Node 1 - SandBox
-- Verify the DB services status
[oracle@pdb ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb. Instance status: Dismounted,Mount Initiated.
*/

-- Step 134.30 -->> On Node 1 - SandBox
-- To stop the DB services and status
[oracle@pdb ~]$ srvctl stop database -d pdbdb
[oracle@pdb ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is not running on node pdb
*/

-- Step 134.31 -->> On Node 1 - SandBox
-- To start the DB services and status
[oracle@pdb ~]$ srvctl start database -d pdbdb -o mount
[oracle@pdb ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb. Instance status: Mounted (Closed).
*/

-- Step 135 -->> On Node 1 - SandBox
[oracle@pdb ~]$ cd /backup/fullbackup/

-- Step 135.1 -->> On Node 1 - SandBox
[oracle@pdb fullbackup]$ rm -rf *

-- Step 135.2 -->> On Node 1 - SandBox
[oracle@pdb fullbackup]$ rman target /
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Sun Nov 3 13:00:02 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB (DBID=3239152647, not open)

RMAN> crosscheck backup;
RMAN> delete expired backup;
RMAN> crosscheck archivelog all;
RMAN> delete expired archivelog all;
RMAN> delete noprompt archivelog all;
RMAN> exit

Recovery Manager complete.
*/
