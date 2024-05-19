----------------------------------------------------------------
-------------Two Node rac Setup on VM Workstation---------------
----------------------------------------------------------------
-- Step 0 -->> 2 Node rac on VM -->> On both Node
--For OS Oracle Linux 8.6 => boot V1020894-01.iso
--And follow 
--https <= public-yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/
--UEKR6 <= https <= public-yum.oracle.com/repo/OracleLinux/OL8/UEKR6/x86_64/
--appstream <= https <= public-yum.oracle.com/repo/OracleLinux/OL8/appstream/x86_64/
--Then for other RPM V1020898-01.iso

-- Step 0.0 -->>  2 Node rac on VM -->> On both Node
[root@pdb1/pdb2 ~]# df -Th
/*
Filesystem               Type      Size  Used Avail Use% Mounted on
devtmpfs                 devtmpfs  9.6G     0  9.6G   0% /dev
tmpfs                    tmpfs     9.7G     0  9.7G   0% /dev/shm
tmpfs                    tmpfs     9.7G  9.5M  9.7G   1% /run
tmpfs                    tmpfs     9.7G     0  9.7G   0% /sys/fs/cgroup
/dev/mapper/ol_pdb1-root xfs        75G  621M   75G   1% /
/dev/mapper/ol_pdb1-usr  xfs        10G  7.2G  2.9G  72% /usr
/dev/mapper/ol_pdb1-var  xfs        10G  777M  9.3G   8% /var
/dev/mapper/ol_pdb1-tmp  xfs        10G  104M  9.9G   2% /tmp
/dev/mapper/ol_pdb1-home xfs        10G  104M  9.9G   2% /home
/dev/mapper/ol_pdb1-opt  xfs        78G  796M   78G   1% /opt
/dev/sda1                xfs      1014M  344M  671M  34% /boot
tmpfs                    tmpfs     2.0G   28K  2.0G   1% /run/user/0
*/

-- Step 1 -->> On both Node
[root@pdb1/pdb2 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.168.6.21   pdb1.unidev.org.np        pdb1
192.168.6.22   pdb2.unidev.org.np        pdb2

# Private
10.10.10.21   pdb1-priv.unidev.org.np   pdb1-priv
10.10.10.22   pdb2-priv.unidev.org.np   pdb2-priv

# Virtual
192.168.6.23   pdb1-vip.unidev.org.np    pdb1-vip
192.168.6.24   pdb2-vip.unidev.org.np    pdb2-vip

# SCAN
192.168.6.25   pdb-scan.unidev.org.np    pdb-scan
192.168.6.26   pdb-scan.unidev.org.np    pdb-scan
*/


-- Step 2 -->> On both Node
-- Disable secure linux by editing the "/etc/selinux/config" file, making sure the SELINUX flag is set as follows.
[root@pdb1/pdb2 ~]# vi /etc/selinux/config
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
[root@pdb1 ~]# vi /etc/sysconfig/network
/*
NETWORKING=yes
HOSTNAME=pdb1.unidev.org.np
*/

-- Step 4 -->> On Node 2
[root@pdb2 ~]# vi /etc/sysconfig/network
/*
NETWORKING=yes
HOSTNAME=pdb2.unidev.org.np
*/

-- Step 5 -->> On Node 1
[root@pdb1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens160 
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=ens160
DEVICE=ens160
ONBOOT=yes
IPADDR=192.168.6.21
NETMASK=255.255.255.0
GATEWAY=192.168.6.1
DNS1=127.0.0.1
DNS2=192.168.4.11
DNS3=192.168.4.12
*/

-- Step 6 -->> On Node 1
[root@pdb1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens192
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=ens192
DEVICE=ens192
ONBOOT=yes
IPADDR=10.10.10.21
NETMASK=255.255.255.0
*/

-- Step 7 -->> On Node 2
[root@pdb2 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens160
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=ens160
DEVICE=ens160
ONBOOT=yes
IPADDR=192.168.6.22
NETMASK=255.255.255.0
GATEWAY=192.168.6.1
DNS1=127.0.0.1
DNS2=192.168.4.11
DNS3=192.168.4.12
*/

-- Step 8 -->> On Node 2
[root@pdb2 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens192
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=ens192
DEVICE=ens192
ONBOOT=yes
IPADDR=10.10.10.22
NETMASK=255.255.255.0
*/

-- Step 9 -->> On Both Node
[root@pdb1/pdb2 ~]# systemctl restart network-online.target

-- Step 10 -->> On Both Node
[root@pdb1/pdb2 ~]# dnf repolist
/*
repo id           repo name
ol8_UEKR6         Latest Unbreakable Enterprise Kernel Release 6 for Oracle Linux 8 (x86_64)
ol8_appstream     Oracle Linux 8 Application Stream (x86_64)
ol8_baseos_latest Oracle Linux 8 BaseOS Latest (x86_64)
*/

-- Step 10.1 -->> On Both Node
[root@pdb1/pdb2 ~]# uname -a
/*
Linux pdb1.unidev.org.np 5.4.17-2136.331.7.el8uek.x86_64 #3 SMP Mon May 6 15:17:51 PDT 2024 x86_64 x86_64 x86_64 GNU/Linux
*/

-- Step 10.2 -->> On Both Node
[root@pdb1/pdb2 ~]# uname -r
/*
5.4.17-2136.331.7.el8uek.x86_64
*/

-- Step 10.3 -->> On Both Node
[root@pdb1/pdb2 ~]# grubby --info=ALL | grep ^kernel
/*
kernel="/boot/vmlinuz-5.4.17-2136.331.7.el8uek.x86_64"
kernel="/boot/vmlinuz-4.18.0-513.24.1.el8_9.x86_64"
kernel="/boot/vmlinuz-0-rescue-7ee47c999d564f048273091128dea7fd"
*/

-- Step 10.4 -->> On Both Node
[root@pdb1/pdb2 ~]# grubby --default-kernel
/*
/boot/vmlinuz-5.4.17-2136.331.7.el8uek.x86_64
*/

-- Step 11 -->> On Both Node
[root@pdb1/pdb2 ~]# cat /etc/hostname
/*
localhost.localdomain
*/

-- Step 11.1 -->> On Both Node
[root@pdb1/pdb2 ~]# hostnamectl | grep hostname
/*
   Static hostname: localhost.localdomain
Transient hostname: pdb1/pdb2.unidev.org.np
*/

-- Step 11.2 -->> On Both Node
[root@pdb1/pdb2 ~]# hostnamectl --static
/*
localhost.localdomain
*/

-- Step 12 -->> On Node 1
[root@pdb1 ~]# hostnamectl set-hostname pdb1.unidev.org.np

-- Step 12.1 -->> On Node 1
[root@pdb1 ~]# hostnamectl
/*
   Static hostname: pdb1.unidev.org.np
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 7ee47c999d564f048273091128dea7fd
           Boot ID: 5c1b4a3a19de4d1eb338d92d1394f49f
    Virtualization: vmware
  Operating System: Oracle Linux Server 8.9
       CPE OS Name: cpe:/o:oracle:linux:8:9:server
            Kernel: Linux 5.4.17-2136.331.7.el8uek.x86_64
      Architecture: x86-64
*/

-- Step 13 -->> On Node 2
[root@pdb2 ~]# hostnamectl set-hostname pdb2.unidev.org.np

-- Step 13.1 -->> On Node 2
[root@pdb2 ~]# hostnamectl
/*
   Static hostname: pdb2.unidev.org.np
         Icon name: computer-vm
           Chassis: vm
        Machine ID: b1f071eaec97490497225b06fe758aa3
           Boot ID: 97fad4242ea448e8b7e251edeba164c4
    Virtualization: vmware
  Operating System: Oracle Linux Server 8.9
       CPE OS Name: cpe:/o:oracle:linux:8:9:server
            Kernel: Linux 5.4.17-2136.331.7.el8uek.x86_64
      Architecture: x86-64
*/

--Note: If you are not configure proper hostname then While installation of Grid Software, 
--you have to face error CLSRSC-180: An error occurred while executing /opt/app/21c/grid/root.sh script.

-- Step 14 -->> On Both Node
[root@pdb1/pdb2 ~]# systemctl stop firewalld
[root@pdb1/pdb2 ~]# systemctl disable firewalld
/*
Removed /etc/systemd/system/multi-user.target.wants/firewalld.service.
Removed /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.
*/

-- Step 14.1 -->> On Both Nodedf 
[root@pdb1/pdb2 ~]# mv /etc/ntp.conf /etc/ntp.conf.backup
[root@pdb1/pdb2 ~]# rm -rf /etc/ntp.conf
[root@pdb1/pdb2 ~]# rm -rf /var/run/ntpd.pid

-- Step 15 -->> On Both Node
[root@pdb1/pdb2 ~]# iptables -F
[root@pdb1/pdb2 ~]# iptables -X
[root@pdb1/pdb2 ~]# iptables -t nat -F
[root@pdb1/pdb2 ~]# iptables -t nat -X
[root@pdb1/pdb2 ~]# iptables -t mangle -F
[root@pdb1/pdb2 ~]# iptables -t mangle -X
[root@pdb1/pdb2 ~]# iptables -P INPUT ACCEPT
[root@pdb1/pdb2 ~]# iptables -P FORWARD ACCEPT
[root@pdb1/pdb2 ~]# iptables -P OUTPUT ACCEPT
[root@pdb1/pdb2 ~]# iptables -L -nv
/*
Chain INPUT (policy ACCEPT 1 packets, 40 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 9 packets, 968 bytes)
 pkts bytes target     prot opt in     out     source               destination
*/

-- Step 16 -->> On Both Node
[root@pdb1/pdb2 ~ ]# systemctl stop named
[root@pdb1/pdb2 ~ ]# systemctl disable named

-- Step 17 -->> On Both Node
-- Enable chronyd service." `date`
[root@pdb1/pdb2 ~ ]# systemctl enable chronyd
[root@pdb1/pdb2 ~ ]# systemctl restart chronyd
[root@pdb1/pdb2 ~ ]# chronyc -a 'burst 4/4'
/*
200 OK
*/

-- Step 17.1 -->> On Both Node
[root@pdb1/pdb2 ~ ]# chronyc -a makestep
/*
200 OK
*/

-- Step 17.2 -->> On Both Node
[root@pdb1/pdb2 ~ ]# systemctl status chronyd
/*
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue 2024-05-14 16:26:41 +0545; 14s ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 7130 ExecStopPost=/usr/libexec/chrony-helper remove-daemon-state (code=exited, st>
  Process: 7139 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, status=>
  Process: 7135 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 7137 (chronyd)
    Tasks: 1 (limit: 125782)
   Memory: 904.0K
   CGroup: /system.slice/chronyd.service
           └─7137 /usr/sbin/chronyd

May 14 16:26:40 pdb1.unidev.org.np systemd[1]: Starting NTP client/server...
May 14 16:26:40 pdb1.unidev.org.np chronyd[7137]: chronyd version 4.2 starting (+CMDMON +N>
May 14 16:26:40 pdb1.unidev.org.np chronyd[7137]: Frequency -9.440 +/- 0.348 ppm read from>
May 14 16:26:40 pdb1.unidev.org.np chronyd[7137]: Using right/UTC timezone to obtain leap >
May 14 16:26:41 pdb1.unidev.org.np systemd[1]: Started NTP client/server.
May 14 16:26:45 pdb1.unidev.org.np chronyd[7137]: Selected source 162.159.200.1 (2.pool.nt>
May 14 16:26:45 pdb1.unidev.org.np chronyd[7137]: System clock TAI offset set to 37 seconds
May 14 16:26:50 pdb1.unidev.org.np chronyd[7137]: System clock was stepped by 0.000131 sec>
*/

-- Step 18 -->> On Both Node
[root@pdb1 ~]# cd /etc/yum.repos.d/
[root@pdb1 yum.repos.d]# ll
/*
-rw-r--r--. 1 root root 3882 Nov 17 23:25 oracle-linux-ol8.repo
-rw-r--r--. 1 root root  941 Nov 18 00:42 uek-ol8.repo
-rw-r--r--. 1 root root  243 Nov 18 00:42 virt-ol8.repo
*/

-- Step 18.1 -->> On Both Node
[root@pdb1 ~]# cd /etc/yum.repos.d/
[root@pdb1/pdb2 yum.repos.d]# dnf -y update
[root@pdb1/pdb2 yum.repos.d]# dnf install -y bind
[root@pdb1/pdb2 yum.repos.d]# dnf install -y dnsmasq

-- Step 18.2 -->> On Both Node
[root@pdb1/pdb2 ~]# systemctl enable dnsmasq
[root@pdb1/pdb2 ~]# systemctl restart dnsmasq
[root@pdb1/pdb2 ~]# vi /etc/dnsmasq.conf
/*
listen-address=::1,127.0.0.1

#Add the following Lines
except-interface=virbr0
bind-interfaces
*/

-- Step 18.3 -->> On Both Node
[root@pdb1 ~]# cat /etc/dnsmasq.conf | grep -E 'listen-address|except-interface|bind-interfaces'
/*
except-interface=virbr0
listen-address=::1,127.0.0.1
bind-interfaces
*/

-- Step 18.4 -->> On Both Node
[root@pdb1/pdb2 ~]# systemctl restart dnsmasq
[root@pdb1/pdb2 ~]# systemctl restart network-online.target
[root@pdb1/pdb2 ~]# systemctl status dnsmasq
/*
● dnsmasq.service - DNS caching server.
   Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; vendor preset: disabled)
   Active: active (running) since Tue 2024-05-14 16:47:15 +0545; 11s ago
 Main PID: 57644 (dnsmasq)
    Tasks: 1 (limit: 125782)
   Memory: 688.0K
   CGroup: /system.slice/dnsmasq.service
           └─57644 /usr/sbin/dnsmasq -k

May 14 16:47:15 pdb1.unidev.org.np systemd[1]: Started DNS caching server..
May 14 16:47:15 pdb1.unidev.org.np dnsmasq[57644]: listening on lo(#1): 127.0.0.1
May 14 16:47:15 pdb1.unidev.org.np dnsmasq[57644]: listening on lo(#1): ::1
May 14 16:47:15 pdb1.unidev.org.np dnsmasq[57644]: started, version 2.79 cachesize 150
May 14 16:47:15 pdb1.unidev.org.np dnsmasq[57644]: compile time options: IPv6 GNU-getopt D>
May 14 16:47:15 pdb1.unidev.org.np dnsmasq[57644]: reading /etc/resolv.conf
May 14 16:47:15 pdb1.unidev.org.np dnsmasq[57644]: ignoring nameserver 127.0.0.1 - local i>
May 14 16:47:15 pdb1.unidev.org.np dnsmasq[57644]: using nameserver 192.168.4.11#53
May 14 16:47:15 pdb1.unidev.org.np dnsmasq[57644]: using nameserver 192.168.4.12#53
May 14 16:47:15 pdb1.unidev.org.np dnsmasq[57644]: read /etc/hosts - 10 addresses
*/

-- Step 19 -->> On Node 1
[root@pdb1 ~]# nslookup 192.168.6.21
/*
21.6.16.172.in-addr.arpa        name = pdb1.unidev.org.np.
*/

-- Step 19.1 -->> On Node 1
[root@pdb1 ~]# nslookup 192.168.6.22
/*
22.6.16.172.in-addr.arpa        name = pdb2.unidev.org.np.
*/

-- Step 20 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb1
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb1.unidev.org.np
Address: 192.168.6.21
*/

-- Step 20.1 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb2
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb2.unidev.org.np
Address: 192.168.6.22
*/

-- Step 20.2 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb-scan
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb-scan.unidev.org.np
Address: 192.168.6.26
Name:   pdb-scan.unidev.org.np
Address: 192.168.6.25
*/

-- Step 21 -->> On Both Node
--Stop avahi-daemon damon if it not configured
[root@pdb1/pdb2 ~]# systemctl stop avahi-daemon
[root@pdb1/pdb2 ~]# systemctl disable avahi-daemon

-- Step 22 -->> On Both Node
--To Remove virbr0 and lxcbr0 Network Interfac
[root@pdb1/pdb2 ~]# systemctl stop libvirtd.service
[root@pdb1/pdb2 ~]# systemctl disable libvirtd.service
[root@pdb1/pdb2 ~]# virsh net-list
/*
 Name      State    Autostart   Persistent
--------------------------------------------
 default   active   yes         yes
*/

-- Step 22.1 -->> On Both Node
[root@pdb1/pdb2 ~]# virsh net-destroy default
/*
Network default destroyed
*/

-- Step 22.2 -->> On Both Node
[root@pdb1/pdb2 ~]# ifconfig virbr0
/*
virbr0: error fetching interface information: Device not found
*/

-- Step 22.3 -->> On Node One
[root@pdb1 ~]# ifconfig
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.6.21  netmask 255.255.255.0  broadcast 192.168.6.255
        inet6 fe80::250:56ff:feac:623c  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:62:3c  txqueuelen 1000  (Ethernet)
        RX packets 218031  bytes 327271106 (312.1 MiB)
        RX errors 0  dropped 35  overruns 0  frame 0
        TX packets 26216  bytes 2003576 (1.9 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.21  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::250:56ff:feac:1a66  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:1a:66  txqueuelen 1000  (Ethernet)
        RX packets 300  bytes 29383 (28.6 KiB)
        RX errors 0  dropped 33  overruns 0  frame 0
        TX packets 72  bytes 7744 (7.5 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 692  bytes 44541 (43.4 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 692  bytes 44541 (43.4 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 22.4 -->> On Node Two
[root@pdb2 ~]# ifconfig
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.6.22  netmask 255.255.255.0  broadcast 192.168.6.255
        inet6 fe80::250:56ff:feac:5458  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:54:58  txqueuelen 1000  (Ethernet)
        RX packets 218031  bytes 327244663 (312.0 MiB)
        RX errors 0  dropped 13  overruns 0  frame 0
        TX packets 39046  bytes 2955252 (2.8 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.22  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::250:56ff:feac:73e6  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:73:e6  txqueuelen 1000  (Ethernet)
        RX packets 181  bytes 17205 (16.8 KiB)
        RX errors 0  dropped 10  overruns 0  frame 0
        TX packets 69  bytes 7492 (7.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 644  bytes 41038 (40.0 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 644  bytes 41038 (40.0 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/
-- Step 23 -->> On Both Node
[root@pdb1/pdb2 ~]# init 6


-- Step 24 -->> On Node One
[root@pdb1 ~]# ifconfig
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.6.21  netmask 255.255.255.0  broadcast 192.168.6.255
        inet6 fe80::250:56ff:feac:623c  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:62:3c  txqueuelen 1000  (Ethernet)
        RX packets 156  bytes 30038 (29.3 KiB)
        RX errors 0  dropped 30  overruns 0  frame 0
        TX packets 125  bytes 15170 (14.8 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.21  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::250:56ff:feac:1a66  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:1a:66  txqueuelen 1000  (Ethernet)
        RX packets 53  bytes 3363 (3.2 KiB)
        RX errors 0  dropped 29  overruns 0  frame 0
        TX packets 14  bytes 992 (992.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 104  bytes 7874 (7.6 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 104  bytes 7874 (7.6 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 24.1 -->> On Node Two
[root@pdb2 ~]# ifconfig
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.6.22  netmask 255.255.255.0  broadcast 192.168.6.255
        inet6 fe80::250:56ff:feac:5458  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:54:58  txqueuelen 1000  (Ethernet)
        RX packets 139  bytes 28969 (28.2 KiB)
        RX errors 0  dropped 21  overruns 0  frame 0
        TX packets 127  bytes 15352 (14.9 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.22  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::250:56ff:feac:73e6  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:73:e6  txqueuelen 1000  (Ethernet)
        RX packets 36  bytes 2343 (2.2 KiB)
        RX errors 0  dropped 19  overruns 0  frame 0
        TX packets 14  bytes 992 (992.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 100  bytes 7716 (7.5 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 100  bytes 7716 (7.5 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 25 -->> On Both Node
[root@pdb1/pdb2 ~]# systemctl status libvirtd.service
/*
● libvirtd.service - Virtualization daemon
   Loaded: loaded (/usr/lib/systemd/system/libvirtd.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:libvirtd(8)
           https://libvirt.org
*/

-- Step 26 -->> On Both Node
[root@pdb1/pdb2 ~]# firewall-cmd --list-all
/*
FirewallD is not running
*/

-- Step 27 -->> On Both Node
[root@pdb1/pdb2 ~]# systemctl status firewalld
/*
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:firewalld(1)
*/

-- Step 28 -->> On Both Node
[root@pdb1/pdb2 ~]# systemctl status named
/*
● named.service - Berkeley Internet Name Domain (DNS)
   Loaded: loaded (/usr/lib/systemd/system/named.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
*/

-- Step 29 -->> On Both Node
[root@pdb1/pdb2 ~]# systemctl status avahi-daemon
/*
● avahi-daemon.service - Avahi mDNS/DNS-SD Stack
   Loaded: loaded (/usr/lib/systemd/system/avahi-daemon.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
*/

-- Step 30 -->> On Both Node
[root@pdb1/pdb2 ~ ]# systemctl status chronyd
/*
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue 2024-05-14 16:50:11 +0545; 4min 59s ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 1278 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, status=>
  Process: 1218 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 1237 (chronyd)
    Tasks: 1 (limit: 125782)
   Memory: 2.1M
   CGroup: /system.slice/chronyd.service
           └─1237 /usr/sbin/chronyd

May 14 16:50:10 pdb1.unidev.org.np systemd[1]: Starting NTP client/server...
May 14 16:50:10 pdb1.unidev.org.np chronyd[1237]: chronyd version 4.2 starting (+CMDMON +N>
May 14 16:50:10 pdb1.unidev.org.np chronyd[1237]: Frequency -9.960 +/- 0.113 ppm read from>
May 14 16:50:10 pdb1.unidev.org.np chronyd[1237]: Using right/UTC timezone to obtain leap >
May 14 16:50:11 pdb1.unidev.org.np systemd[1]: Started NTP client/server.
May 14 16:50:16 pdb1.unidev.org.np chronyd[1237]: Selected source 162.159.200.123 (2.pool.>
May 14 16:50:16 pdb1.unidev.org.np chronyd[1237]: System clock TAI offset set to 37 seconds
*/

-- Step 31 -->> On Both Node
[root@pdb1/pdb2 ~]# systemctl status dnsmasq
/*
● dnsmasq.service - DNS caching server.
   Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; vendor preset: disabled)
   Active: active (running) since Tue 2024-05-14 16:50:11 +0545; 5min ago
 Main PID: 1292 (dnsmasq)
    Tasks: 1 (limit: 125782)
   Memory: 1.3M
   CGroup: /system.slice/dnsmasq.service
           └─1292 /usr/sbin/dnsmasq -k

May 14 16:50:11 pdb1.unidev.org.np dnsmasq[1292]: compile time options: IPv6 GNU-getopt DB>
May 14 16:50:11 pdb1.unidev.org.np dnsmasq[1292]: reading /etc/resolv.conf
May 14 16:50:11 pdb1.unidev.org.np dnsmasq[1292]: ignoring nameserver 127.0.0.1 - local in>
May 14 16:50:11 pdb1.unidev.org.np dnsmasq[1292]: using nameserver 192.168.4.11#53
May 14 16:50:11 pdb1.unidev.org.np dnsmasq[1292]: using nameserver 192.168.4.12#53
May 14 16:50:11 pdb1.unidev.org.np dnsmasq[1292]: read /etc/hosts - 10 addresses
May 14 16:50:11 pdb1.unidev.org.np dnsmasq[1292]: reading /etc/resolv.conf
May 14 16:50:11 pdb1.unidev.org.np dnsmasq[1292]: ignoring nameserver 127.0.0.1 - local in>
May 14 16:50:11 pdb1.unidev.org.np dnsmasq[1292]: using nameserver 192.168.4.11#53
May 14 16:50:11 pdb1.unidev.org.np dnsmasq[1292]: using nameserver 192.168.4.12#53
*/

-- Step 31.1 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup 192.168.6.21
/*
21.6.16.172.in-addr.arpa        name = pdb1.unidev.org.np.
*/

-- Step 31.2 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup 192.168.6.22
/*
22.6.16.172.in-addr.arpa        name = pdb2.unidev.org.np.
*/

-- Step 31.3 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb1
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb1.unidev.org.np
Address: 192.168.6.21
*/

-- Step 31.4 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb2
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb2.unidev.org.np
Address: 192.168.6.22
*/

-- Step 31.5 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb-scan
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb-scan.unidev.org.np
Address: 192.168.6.26
Name:   pdb-scan.unidev.org.np
Address: 192.168.6.25
*/

-- Step 31.6 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb2-vip
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb2-vip.unidev.org.np
Address: 192.168.6.24
*/

-- Step 31.7 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb1-vip
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb1-vip.unidev.org.np
Address: 192.168.6.23
*/

-- Step 31.8 -->> On Both Node
[root@pdb1/pdb2 ~]# iptables -L -nv
/*
Chain INPUT (policy ACCEPT 3 packets, 12672 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 3 packets, 172 bytes)
 pkts bytes target     prot opt in     out     source               destination
*/


-- Step 32 -->> On Both Node
-- Perform either the Automatic Setup or the Manual Setup to complete the basic prerequisites. 
[root@pdb1/pdb2 ~]# cd /etc/yum.repos.d/
[root@pdb1/pdb2 yum.repos.d]# dnf -y update

-- Step 32.1 -->> On Both Node
[root@pdb1/pdb2 yum.repos.d]# dnf install -y yum-utils
[root@pdb1/pdb2 yum.repos.d]# dnf install -y dnf-utils
[root@pdb1/pdb2 yum.repos.d]# dnf install -y oracle-epel-release-el8
[root@pdb1/pdb2 yum.repos.d]# dnf install -y sshpass zip unzip
[root@pdb1/pdb2 yum.repos.d]# dnf install -y oracle-database-preinstall-21c

-- Step 32.2 -->> On Both Node
[root@pdb1/pdb2 yum.repos.d]# dnf install -y bc    
[root@pdb1/pdb2 yum.repos.d]# dnf install -y binutils
[root@pdb1/pdb2 yum.repos.d]# dnf install -y compat-libcap1
[root@pdb1/pdb2 yum.repos.d]# dnf install -y compat-libstdc++-33
[root@pdb1/pdb2 yum.repos.d]# dnf install -y compat-openssl10
[root@pdb1/pdb2 yum.repos.d]# dnf install -y dtrace-utils
[root@pdb1/pdb2 yum.repos.d]# dnf install -y elfutils-libelf
[root@pdb1/pdb2 yum.repos.d]# dnf install -y elfutils-libelf-devel
[root@pdb1/pdb2 yum.repos.d]# dnf install -y fontconfig-devel
[root@pdb1/pdb2 yum.repos.d]# dnf install -y glibc
[root@pdb1/pdb2 yum.repos.d]# dnf install -y glibc-devel
[root@pdb1/pdb2 yum.repos.d]# dnf install -y ksh
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libaio
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libaio-devel
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libdtrace-ctf-devel
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libXrender
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libXrender-devel
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libX11
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libXau
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libXi
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libXtst
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libgcc
[root@pdb1/pdb2 yum.repos.d]# dnf install -y librdmacm-devel
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libstdc++
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libstdc++-devel
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libxcb
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libibverbs
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libasan
[root@pdb1/pdb2 yum.repos.d]# dnf install -y liblsan
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libubsan
[root@pdb1/pdb2 yum.repos.d]# dnf install -y make
[root@pdb1/pdb2 yum.repos.d]# dnf install -y net-tools
[root@pdb1/pdb2 yum.repos.d]# dnf install -y nfs-utils
[root@pdb1/pdb2 yum.repos.d]# dnf install -y python
[root@pdb1/pdb2 yum.repos.d]# dnf install -y python-configshell
[root@pdb1/pdb2 yum.repos.d]# dnf install -y python-rtslib
[root@pdb1/pdb2 yum.repos.d]# dnf install -y python-six
[root@pdb1/pdb2 yum.repos.d]# dnf install -y targetcli
[root@pdb1/pdb2 yum.repos.d]# dnf install -y policycoreutils
[root@pdb1/pdb2 yum.repos.d]# dnf install -y policycoreutils-python-utils
[root@pdb1/pdb2 yum.repos.d]# dnf install -y smartmontools
[root@pdb1/pdb2 yum.repos.d]# dnf install -y sysstat
[root@pdb1/pdb2 yum.repos.d]# dnf install -y unixODBC
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libnsl
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libnsl.i686
[root@pdb1/pdb2 yum.repos.d]# dnf install -y ipmiutil 
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libnsl2
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libnsl2.i686
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libnsl2-devel
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libvirt-libs
[root@pdb1/pdb2 yum.repos.d]# dnf install -y chrony
[root@pdb1/pdb2 yum.repos.d]# dnf -y update

-- Step 32.3 -->> On Both Node
[root@pdb1/pdb2 ~]# cd /tmp
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/elfutils-libelf-devel-0.189-3.el8.i686.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/elfutils-libelf-devel-0.189-3.el8.x86_64.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/numactl-2.0.12-13.el8.x86_64.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/numactl-devel-2.0.12-13.el8.x86_64.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/numactl-devel-2.0.12-13.el8.i686.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/python3-libs-3.6.8-56.0.1.el8_9.i686.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/python3-libs-3.6.8-56.0.1.el8_9.x86_64.rpm
[root@pdb1/pdb2 tmp]# wget https://download.oracle.com/otn_software/asmlib/oracleasmlib-2.0.17-1.el8.x86_64.rpm
[root@pdb1/pdb2 tmp]# wget https://public-yum.oracle.com/repo/OracleLinux/OL8/addons/x86_64/getPackage/oracleasm-support-2.1.12-1.el8.x86_64.rpm

-- Step 33 -->> On Both Node
[root@pdb1/pdb2 ~]# cd /tmp
[root@pdb1/pdb2 tmp]# yum -y localinstall ./elfutils-libelf-devel-0.189-3.el8.i686.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./elfutils-libelf-devel-0.189-3.el8.x86_64.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./numactl-2.0.12-13.el8.x86_64.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./numactl-devel-2.0.12-13.el8.i686.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./numactl-devel-2.0.12-13.el8.x86_64.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./python3-libs-3.6.8-56.0.1.el8_9.i686.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./python3-libs-3.6.8-56.0.1.el8_9.x86_64.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./oracleasm-support-2.1.12-1.el8.x86_64.rpm ./oracleasmlib-2.0.17-1.el8.x86_64.rpm
[root@pdb1/pdb2 tmp]# rm -rf *.rpm

-- Step 34 -->> On Both Node
[root@pdb1/pdb2 ~]# cd /etc/yum.repos.d/
[root@pdb1/pdb2 yum.repos.d]# dnf -y install python2 python3.11 python36 python38 python39
[root@pdb1/pdb2 yum.repos.d]# dnf -y install compat-libcap1 compat-libstdc++-33 bc binutils elfutils-libelf elfutils-libelf-devel fontconfig-devel glibc glibc-devel ksh libaio libaio-devel libgcc libnsl librdmacm-devel libstdc++ libstdc++-devel libX11 libXau libxcb libXi libXrender libXrender-devel libXtst make net-tools nfs-utils python3 python3-configshell python3-rtslib python3-six smartmontools sysstat targetcli unzip
[root@pdb1/pdb2 yum.repos.d]# dnf -y install bash bc bind-utils binutils ethtool glibc glibc-devel initscripts ksh libaio libaio-devel libgcc libnsl libstdc++ libstdc++-devel make module-init-tools net-tools nfs-utils openssh-clients openssl-libs pam procps psmisc smartmontools sysstat tar unzip util-linux-ng xorg-x11-utils xorg-x11-xauth 
[root@pdb1/pdb2 yum.repos.d]# dnf -y install bc binutils compat-libcap1 compat-libstdc++-33 compat-openssl10 dtrace-utils elfutils-libelf elfutils-libelf-devel fontconfig-devel glibc glibc-devel ksh libaio libaio-devel libdtrace-ctf-devel libXrender libXrender-devel libX11 libXau libXi libXtst libgcc librdmacm-devel libstdc++ libstdc++-devel libxcb libibverbs libasan liblsan libubsan make net-tools nfs-utils python python-configshell python-rtslib python-six targetcli policycoreutils policycoreutils-python-utils smartmontools sysstat unixODBC libnsl libnsl.i686 ipmiutil libnsl2 libnsl2.i686 libnsl2-devel libvirt-libs chrony 
[root@pdb1/pdb2 yum.repos.d]# dnf -y update

-- Step 35 -->> On Both Node
[root@pdb1/pdb2 yum.repos.d]# rpm -q binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel elfutils-libelf-devel-static \
[root@pdb1/pdb2 yum.repos.d]# rpm -q gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers kernel-headers ksh libaio libaio-devel \
[root@pdb1/pdb2 yum.repos.d]# rpm -q libgcc libgomp libstdc++ libstdc++-devel make numactl-devel sysstat unixODBC unixODBC-devel \
[root@pdb1/pdb2 yum.repos.d]# rpm -q bc binutils compat-libcap1 compat-libstdc++-33 compat-openssl10 dtrace-utils elfutils-libelf elfutils-libelf-devel fontconfig-devel glibc glibc-devel ksh libaio libaio-devel libdtrace-ctf-devel libXrender libXrender-devel libX11 libXau libXi libXtst libgcc librdmacm-devel libstdc++ libstdc++-devel libxcb libibverbs libasan liblsan libubsan make net-tools nfs-utils python python-configshell python-rtslib python-six targetcli policycoreutils policycoreutils-python-utils smartmontools sysstat unixODBC libnsl libnsl.i686 ipmiutil libnsl2 libnsl2.i686 libnsl2-devel libvirt-libs chrony \

-- Step 36.3 -->> On Both Node
[root@pdb1/pdb2 ~]# rpm -qa | grep oracleasm
/*
oracleasm-support-2.1.12-1.el8.x86_64
oracleasmlib-2.0.17-1.el8.x86_64
*/

-- Step 37 -->> On Both Node
-- Add the kernel parameters file "/etc/sysctl.conf" and add oracle recommended kernel parameters
[root@pdb1/pdb2 ~]# vi /etc/sysctl.conf
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

-- Step 37.1 -->> On Both Node
-- Run the following command to change the current kernel parameters.
[root@pdb1/pdb2 ~]# sysctl -p /etc/sysctl.conf

-- Step 38 -->> On Both Node
-- Edit “/etc/security/limits.d/oracle-database-preinstall-19c.conf” file to limit user processes
[root@pdb1/pdb2 ~]# vi /etc/security/limits.d/oracle-database-preinstall-21c.conf
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
[root@pdb1/pdb2 ~]# vi /etc/pam.d/login
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
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:
*/

-- Step 40.1 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:
backupdba:x:54324:
dgdba:x:54325:
kmdba:x:54326:
pdbdba:x:54330:
*/

-- Step 40.2 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i oracle
/*
oracle:x:1000:oracle
*/

-- Step 40.3 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i oper
/*
oper:x:54323:oracle
*/

-- Step 40.4 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i asm

-- Step 40.5 -->> On both Node
-- 1.Create OS groups using the command below. Enter these commands as the 'root' user:
--[root@pdb1/pdb2 ~]# /usr/sbin/groupadd -g 503 oper
[root@pdb1/pdb2 ~]# /usr/sbin/groupadd -g 504 asmadmin
[root@pdb1/pdb2 ~]# /usr/sbin/groupadd -g 506 asmdba
[root@pdb1/pdb2 ~]# /usr/sbin/groupadd -g 507 asmoper
[root@pdb1/pdb2 ~]# /usr/sbin/groupadd -g 508 beoper

-- Step 40.6 -->> On both Node
-- 2.Create the users that will own the Oracle software using the commands:
[root@pdb1/pdb2 ~]# /usr/sbin/useradd  -g oinstall -G oinstall,dba,asmadmin,asmdba,asmoper,beoper grid
[root@pdb1/pdb2 ~]# /usr/sbin/usermod -g oinstall -G oinstall,dba,oper,asmdba,asmadmin,backupdba,dgdba,kmdba,racdba oracle

-- Step 40.7 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/

-- Step 40.8 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i oracle
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

-- Step 40.9 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i grid
/*
oinstall:x:54321:grid,oracle
dba:x:54322:grid,oracle
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 40.10 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i oper
/*
oper:x:54323:oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 40.11 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:grid,oracle
*/

-- Step 40.12 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:grid,oracle
backupdba:x:54324:oracle
dgdba:x:54325:oracle
kmdba:x:54326:oracle
pdbdba:x:54330:oracle
asmdba:x:506:grid,oracle
*/

-- Step 40.13 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/

-- Step 41 -->> On both Node
[root@pdb1/pdb2 ~]# passwd oracle
/*
Changing password for user oracle.
New password: oracle
Retype new password: oracle
passwd: all authentication tokens updated successfully.
*/

-- Step 42 -->> On both Node
[root@pdb1/pdb2 ~]# passwd grid
/*
Changing password for user grid.
New password: grid
Retype new password: grid
passwd: all authentication tokens updated successfully.
*/

-- Step 42.1 -->> On both Node
[root@pdb1/pdb2 ~]# su - oracle

-- Step 42.2 -->> On both Node
[oracle@pdb1/pdb2 ~]$ su - grid
/*
Password: grid
*/

-- Step 42.3 -->> On both Node
[grid@pdb1/pdb2 ~]$ su - oracle
/*
Password: oracle
*/

-- Step 42.4 -->> On both Node
[oracle@pdb1/pdb2 ~]$ exit
/*
logout
*/

-- Step 42.5 -->> On both Node
[grid@pdb1/pdb2 ~]$ exit
/*
logout
*/

-- Step 42.6 -->> On both Node
[oracle@pdb1/pdb2 ~]$ exit
/*
logout
*/

-- Step 43 -->> On both Node
--Create the Oracle Inventory Director:
[root@pdb1/pdb2 ~]# mkdir -p /opt/app/oraInventory
[root@pdb1/pdb2 ~]# chown -R grid:oinstall /opt/app/oraInventory
[root@pdb1/pdb2 ~]# chmod -R 775 /opt/app/oraInventory

-- Step 44 -->> On both Node
--Creating the Oracle Grid Infrastructure Home Directory:
[root@pdb1/pdb2 ~]# mkdir -p /opt/app/21c/grid
[root@pdb1/pdb2 ~]# chown -R grid:oinstall /opt/app/21c/grid
[root@pdb1/pdb2 ~]# chmod -R 775 /opt/app/21c/grid

-- Step 45 -->> On both Node
--Creating the Oracle Base Directory
[root@pdb1/pdb2 ~]#   mkdir -p /opt/app/oracle
[root@pdb1/pdb2 ~]#   chmod -R 775 /opt/app/oracle
[root@pdb1/pdb2 ~]#   cd /opt/app/
[root@pdb1/pdb2 app]# chown -R oracle:oinstall /opt/app/oracle

-- Step 46 -->> On Node 1
-- Login as the oracle user and add the following lines at the end of the ".bash_profile" file.
[root@pdb1 ~]# su - oracle
[oracle@pdb1 ~]$ vi .bash_profile
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

ORACLE_HOSTNAME=pdb1.unidev.org.np; export ORACLE_HOSTNAME
ORACLE_UNQNAME=pdbdb; export ORACLE_UNQNAME
ORACLE_BASE=/opt/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/21c/db_1; export ORACLE_HOME
ORACLE_SID=pdbdb1; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 47 -->> On Node 1
[oracle@pdb1 ~]$ . .bash_profile

-- Step 48 -->> On Node 1
-- Login as the grid user and add the following lines at the end of the ".bash_profile" file.
[root@pdb1 ~]# su - grid
[grid@pdb1 ~]$ vi .bash_profile
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
GRID_HOME=/opt/app/21c/grid; export GRID_HOME
ORACLE_HOME=$GRID_HOME; export ORACLE_HOME

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 49 -->> On Node 1
[grid@pdb1 ~]$ . .bash_profile

-- Step 50 -->> On Node 2
-- Login as the oracle user and add the following lines at the end of the ".bash_profile" file.
[root@pdb2 ~]# su - oracle
[oracle@pdb2 ~]$ vi .bash_profile
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

ORACLE_HOSTNAME=pdb2.unidev.org.np; export ORACLE_HOSTNAME
ORACLE_UNQNAME=pdbdb; export ORACLE_UNQNAME
ORACLE_BASE=/opt/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/21c/db_1; export ORACLE_HOME
ORACLE_SID=pdbdb2; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 51 -->> On Node 2
[oracle@pdb2 ~]$ . .bash_profile

-- Step 52 -->> On Node 2
-- Login as the grid user and add the following lines at the end of the ".bash_profile" file.
[root@pdb2 ~]# su - grid
[grid@pdb2 ~]$ vi .bash_profile
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
GRID_HOME=/opt/app/21c/grid; export GRID_HOME
ORACLE_HOME=$GRID_HOME; export ORACLE_HOME

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 53 -->> On Node 2
[grid@pdb2 ~]$ . .bash_profile

-- Step 54 -->> On Node 1
-- To Unzio The Oracle Grid Software and lateset Opatch
[root@pdb1 ~]# cd /opt/app/21c/grid/
[root@pdb1 grid]# unzip -oq /root/Oracle_21C/21.3.0.0.0_Grid_Binary/LINUX.X64_213000_grid_home.zip
[root@pdb1 grid]# unzip -oq /root/Oracle_21C/OPATCH_21c/p6880880_210000_Linux-x86-64.zip

-- Step 55 -->> On Node 1
-- To Unzio The Oracle PSU
[root@pdb1 ~]# cd /tmp/
[root@pdb1 tmp]# unzip -oq /root/Oracle_21C/PSU_21.14.0.0.0/p36031790_210000_Linux-x86-64.zip
[root@pdb1 tmp]# chown -R oracle:oinstall 36031790
[root@pdb1 tmp]# chmod -R 775 36031790
[root@pdb1 tmp]# ls -ltr | grep 36031790
/*
drwxrwxr-x  9 oracle oinstall  175 Jan  9 08:24 36031790
*/

-- Step 56 -->> On Node 1
-- Login as root user and issue the following command at pdb1
[root@pdb1 ~]# chown -R grid:oinstall /opt/app/21c/grid/
[root@pdb1 ~]# chmod -R 775 /opt/app/21c/grid/

[root@pdb1 ~]# su - grid
[grid@pdb1 ~]$ cd /opt/app/21c/grid/OPatch/
[grid@pdb1 OPatch]$ ./opatch version
/*
OPatch Version: 12.2.0.1.42

OPatch succeeded.
*/

-- Step 57 -->> On Node 1
[root@pdb1 ~]# scp -r /opt/app/21c/grid/cv/rpm/cvuqdisk-1.0.10-1.rpm root@pdb2:/tmp/
/*
The authenticity of host 'pdb2 (192.168.6.22)' can't be established.
ECDSA key fingerprint is SHA256:43Yoy1f8J7c9cLLuyTE2gP5DMQPYJT/fQaxNCoaQ0rs.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'pdb2,192.168.6.22' (ECDSA) to the list of known hosts.
root@pdb2's password:
cvuqdisk-1.0.10-1.rpm                                      100%   11KB   6.7MB/s   00:00
*/

-- Step 58 -->> On Node 1
-- To install the cvuqdisk-1.0.10-1.rpm
-- Login from root user
[root@pdb1 ~]# cd /opt/app/21c/grid/cv/rpm/

-- Step 58.1 -->> On Node 1
[root@pdb1 rpm]# ls -ltr
/*
-rwxrwxr-x 1 grid oinstall 11904 Jul  8  2021 cvuqdisk-1.0.10-1.rpm
*/

-- Step 58.2 -->> On Node 1
[root@pdb1 rpm]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP

-- Step 58.3 -->> On Node 1
[root@pdb1 rpm]# rpm -iUvh cvuqdisk-1.0.10-1.rpm 
/*
Preparing...                          ################################# [100%]
Updating / installing...
   1:cvuqdisk-1.0.10-1                ################################# [100%]
*/

-- Step 59 -->> On Node 2
[root@pdb2 ~]# cd /tmp/
[root@pdb2 tmp]# chown -R grid:oinstall cvuqdisk-1.0.10-1.rpm
[root@pdb2 tmp]# chmod -R 775 cvuqdisk-1.0.10-1.rpm
[root@pdb2 tmp]# ls -ltr | grep cvuqdisk-1.0.10-1.rpm
/*
-rwxrwxr-x  1 grid oinstall 11904 May 15 16:46 cvuqdisk-1.0.10-1.rpm
*/

-- Step 60 -->> On Node 2
-- To install the cvuqdisk-1.0.10-1.rpm
-- Login from root user
[root@pdb2 ~]# cd /tmp/
[root@pdb2 tmp]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP
[root@pdb2 tmp]# rpm -iUvh cvuqdisk-1.0.10-1.rpm 
/*
Preparing...                          ################################# [100%]
Updating / installing...
   1:cvuqdisk-1.0.10-1                ################################# [100%]
*/

-- Step 61 -->> On all Node
[root@pdb1/pdb2 ~]# which oracleasm
/*
/usr/sbin/oracleasm
*/

-- Step 62 -->> On all Node
[root@pdb1/pdb2 ~]# oracleasm configure
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
[root@pdb1/pdb2 ~]# oracleasm status
/*
Checking if ASM is loaded: no
Checking if /dev/oracleasm is mounted: no
*/

-- Step 64 -->> On all Node
[root@pdb1/pdb2 ~]# oracleasm configure -i
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
[root@pdb1/pdb2 ~]# oracleasm configure
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

-- Step 66 -->> On all Node
[root@pdb1/pdb2 ~]# oracleasm init
/*
Creating /dev/oracleasm mount point: /dev/oracleasm
Loading module "oracleasm": oracleasm
Configuring "oracleasm" to use device physical block size
Mounting ASMlib driver filesystem: /dev/oracleasm
*/

-- Step 67 -->> On all Node
[root@pdb1/pdb2 ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 68 -->> On all Node
[root@pdb1/pdb2 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 69 -->> On all Node
[root@pdb1/pdb2 ~]# oracleasm listdisks

[root@pdb1/pdb2 ~]# ls -ltr /etc/init.d/
/*
-rwxr-xr-x  1 root root  4954 Feb 29  2020 oracleasm
-rwx------  1 root root  1281 Jul 13  2021 oracle-database-preinstall-21c-firstboot
-rw-r--r--. 1 root root 18434 Aug 10  2022 functions
-rw-r--r--. 1 root root  1161 Feb 29 12:52 README
*/

-- Step 70 -->> On Both Node
[root@pdb1/pdb2 ~]# ls -ll /dev/oracleasm/disks/
/*
total 0
*/


-- Step 71 -->> On Both Node
[root@pdb1/pdb2 ~]# ls -ll /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 May 16 11:00 /dev/sda
brw-rw---- 1 root disk 8,  1 May 16 11:00 /dev/sda1
brw-rw---- 1 root disk 8,  2 May 16 11:00 /dev/sda2
brw-rw---- 1 root disk 8, 16 May 16 11:00 /dev/sdb
brw-rw---- 1 root disk 8, 32 May 16 11:00 /dev/sdc
brw-rw---- 1 root disk 8, 48 May 16 11:00 /dev/sdd
*/

--Step 71.1 -->> Both Node
[root@pdb1 ~]# lsblk
/*
NAME             MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                8:0    0  210G  0 disk
├─sda1             8:1    0    1G  0 part /boot
└─sda2             8:2    0  209G  0 part
  ├─ol_pdb1-root 252:0    0   75G  0 lvm  /
  ├─ol_pdb1-swap 252:1    0   16G  0 lvm  [SWAP]
  ├─ol_pdb1-usr  252:2    0   10G  0 lvm  /usr
  ├─ol_pdb1-tmp  252:3    0   10G  0 lvm  /tmp
  ├─ol_pdb1-var  252:4    0   10G  0 lvm  /var
  ├─ol_pdb1-home 252:5    0   10G  0 lvm  /home
  └─ol_pdb1-opt  252:6    0   78G  0 lvm  /opt
sdb                8:16   0   20G  0 disk
sdc                8:32   0  200G  0 disk
sdd                8:48   0  400G  0 disk
sr0               11:0    1 1024M  0 rom
*/

-- Step 72 -->> On Node 1
[root@pdb1 ~]# fdisk -ll | grep GiB
/*
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
Disk /dev/sdc: 200 GiB, 214748364800 bytes, 419430400 sectors
Disk /dev/sdd: 400 GiB, 429496729600 bytes, 838860800 sectors
*/

-- Step 73 -->> On Node 1
[root@pdb1 ~]# fdisk /dev/sdb
/*
Welcome to fdisk (util-linux 2.32.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0xf11459ca.

Command (m for help): p
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xf11459ca

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-41943039, default 2048):
Last sector, +sectors or +size{K,M,G,T,P} (2048-41943039, default 41943039):

Created a new partition 1 of type 'Linux' and of size 20 GiB.

Command (m for help): p
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xf11459ca

Device     Boot Start      End  Sectors Size Id Type
/dev/sdb1        2048 41943039 41940992  20G 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 74 -->> On Node 1
[root@pdb1 ~]# fdisk  /dev/sdc
/*
Welcome to fdisk (util-linux 2.32.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x98d65450.

Command (m for help): p
Disk /dev/sdc: 200 GiB, 214748364800 bytes, 419430400 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x98d65450

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-419430399, default 2048):
Last sector, +sectors or +size{K,M,G,T,P} (2048-419430399, default 419430399):

Created a new partition 1 of type 'Linux' and of size 200 GiB.

Command (m for help): p
Disk /dev/sdc: 200 GiB, 214748364800 bytes, 419430400 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x98d65450

Device     Boot Start       End   Sectors  Size Id Type
/dev/sdc1        2048 419430399 419428352  200G 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 75 -->> On Node 1
[root@pdb1 ~]# fdisk /dev/sdd
/*
Welcome to fdisk (util-linux 2.32.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0xe493ecab.

Command (m for help): p
Disk /dev/sdd: 400 GiB, 429496729600 bytes, 838860800 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xe493ecab

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-838860799, default 2048):
Last sector, +sectors or +size{K,M,G,T,P} (2048-838860799, default 838860799):

Created a new partition 1 of type 'Linux' and of size 400 GiB.

Command (m for help): p
Disk /dev/sdd: 400 GiB, 429496729600 bytes, 838860800 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xe493ecab

Device     Boot Start       End   Sectors  Size Id Type
/dev/sdd1        2048 838860799 838858752  400G 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 76 -->> On Node 1
[root@pdb1 ~]# ls -ll /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 May 16 11:15 /dev/sda
brw-rw---- 1 root disk 8,  1 May 16 11:15 /dev/sda1
brw-rw---- 1 root disk 8,  2 May 16 11:15 /dev/sda2
brw-rw---- 1 root disk 8, 16 May 16 11:18 /dev/sdb
brw-rw---- 1 root disk 8, 17 May 16 11:18 /dev/sdb1
brw-rw---- 1 root disk 8, 32 May 16 11:19 /dev/sdc
brw-rw---- 1 root disk 8, 33 May 16 11:19 /dev/sdc1
brw-rw---- 1 root disk 8, 48 May 16 11:19 /dev/sdd
brw-rw---- 1 root disk 8, 49 May 16 11:19 /dev/sdd1
*/

-- Step 77 -->> On Both Node
[root@pdb1/pdb2 ~]# fdisk -ll | grep sd
/*
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
/dev/sdb1        2048 41943039 41940992  20G 83 Linux
Disk /dev/sdc: 200 GiB, 214748364800 bytes, 419430400 sectors
/dev/sdc1        2048 419430399 419428352  200G 83 Linux
Disk /dev/sdd: 400 GiB, 429496729600 bytes, 838860800 sectors
/dev/sdd1        2048 838860799 838858752  400G 83 Linux
*/

-- Step 77.1 -->> On Both Node
[root@pdb1 ~]# lsblk
/*
NAME             MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                8:0    0  210G  0 disk
├─sda1             8:1    0    1G  0 part /boot
└─sda2             8:2    0  209G  0 part
  ├─ol_pdb1-root 252:0    0   75G  0 lvm  /
  ├─ol_pdb1-swap 252:1    0   16G  0 lvm  [SWAP]
  ├─ol_pdb1-usr  252:2    0   10G  0 lvm  /usr
  ├─ol_pdb1-tmp  252:3    0   10G  0 lvm  /tmp
  ├─ol_pdb1-var  252:4    0   10G  0 lvm  /var
  ├─ol_pdb1-home 252:5    0   10G  0 lvm  /home
  └─ol_pdb1-opt  252:6    0   78G  0 lvm  /opt
sdb                8:16   0   20G  0 disk
└─sdb1             8:17   0   20G  0 part
sdc                8:32   0  200G  0 disk
└─sdc1             8:33   0  200G  0 part
sdd                8:48   0  400G  0 disk
└─sdd1             8:49   0  400G  0 part
sr0               11:0    1 1024M  0 rom
*/

-- Step 78 -->> On Node 1
[root@pdb1 ~]# mkfs.xfs /dev/sdb1
[root@pdb1 ~]# mkfs.xfs /dev/sdc1
[root@pdb1 ~]# mkfs.xfs /dev/sdd1

-- Step 79 -->> On Node 1
[root@pdb1 ~]# oracleasm createdisk OCR /dev/sdb1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 80 -->> On Node 1
[root@pdb1 ~]# oracleasm createdisk DATA /dev/sdc1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 81 -->> On Node 1
[root@pdb1 ~]# oracleasm createdisk ARC /dev/sdd1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 82 -->> On Node 1
[root@pdb1 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 83 -->> On Node 1
[root@pdb1 ~]# oracleasm listdisks
/*
ARC
DATA
OCR
*/

-- Step 84 -->> On Node 2
[root@pdb2 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
Instantiating disk "OCR"
Instantiating disk "ARC"
Instantiating disk "DATA"
*/

-- Step 85 -->> On Node 2
[root@pdb2 ~]# oracleasm listdisks
/*
ARC
DATA
OCR
*/

-- Step 86 -->> On Both Node
[root@pdb1/pdb2 ~]# ls -ll /dev/oracleasm/disks/
/*
brw-rw---- 1 grid asmadmin 8, 49 May 16 11:21 ARC
brw-rw---- 1 grid asmadmin 8, 33 May 16 11:21 DATA
brw-rw---- 1 grid asmadmin 8, 17 May 16 11:21 OCR
*/

-- Step 87 -->> On Node 1
-- To setup SSH Pass
[root@pdb1 ~]# su - grid
[grid@pdb1 ~]$ cd /opt/app/21c/grid/deinstall
[grid@pdb1 deinstall]$ ./sshUserSetup.sh -user grid -hosts "pdb1 pdb2" -noPromptPassphrase -confirm -advanced
/*
Password: grid
*/

-- Step 88 -->> On Node 1
[grid@pdb1/pdb2 ~]$ ssh grid@pdb1 date
[grid@pdb1/pdb2 ~]$ ssh grid@pdb2 date
[grid@pdb1/pdb2 ~]$ ssh grid@pdb1 date && ssh grid@pdb2 date
[grid@pdb1/pdb2 ~]$ ssh grid@pdb1.unidev.org.np date
[grid@pdb1/pdb2 ~]$ ssh grid@pdb2.unidev.org.np date
[grid@pdb1/pdb2 ~]$ ssh grid@pdb1.unidev.org.np date && ssh grid@pdb2.unidev.org.np date

-- Step 89 -->> On Node 1
-- Pre-check for rac Setup
[grid@pdb1 ~]$ cd /opt/app/21c/grid/
[grid@pdb1 grid]$ ./runcluvfy.sh stage -pre crsinst -n pdb1,pdb2 -verbose
[grid@pdb1 grid]$ ./runcluvfy.sh stage -pre crsinst -n pdb1,pdb2 -method root
--[grid@pdb1 grid]$ ./runcluvfy.sh stage -pre crsinst -n pdb1,pdb2 -fixup -method root (If Required)

-- Step 90 -->> On Node 1
-- To Create a Response File to Install GID
[grid@pdb1 ~]$ cp /opt/app/21c/grid/install/response/gridsetup.rsp /home/grid/
[grid@pdb1 ~]$ cd /home/grid/
[grid@pdb1 ~]$ ls -ltr | grep gridsetup.rsp
/*
-rwxr-xr-x 1 grid oinstall 36221 May  6 10:43 gridsetup.rsp
*/

-- Step 90.1 -->> On Node 1
[grid@pdb1 grid]$ vi gridsetup.rsp
/*
oracle.install.responseFileVersion=/oracle/install/rspfmt_crsinstall_response_schema_v21.0.0
INVENTORY_LOCATION=/opt/app/oraInventory
SELECTED_LANGUAGES=en,en_GB
oracle.install.option=CRS_CONFIG
ORACLE_BASE=/opt/app/oracle
oracle.install.asm.OSDBA=asmdba
oracle.install.asm.OSOPER=asmoper
oracle.install.asm.OSASM=asmadmin
oracle.install.crs.config.scanType=LOCAL_SCAN
oracle.install.crs.config.gpnp.scanName=pdb-scan
oracle.install.crs.config.gpnp.scanPort=1521
oracle.install.crs.config.ClusterConfiguration=STANDALONE
oracle.install.crs.config.configureAsExtendedCluster=false
oracle.install.crs.config.clusterName=pdb-cluster
oracle.install.crs.config.gpnp.configureGNS=false
oracle.install.crs.config.autoConfigureClusterNodeVIP=false
oracle.install.crs.config.clusterNodes=pdb1:pdb1-vip,pdb2:pdb2-vip
oracle.install.crs.config.networkInterfaceList=ens160:192.168.6.0:1,ens192:10.10.10.0:5
--oracle.install.crs.configureGIMR=false
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

-- Step 90.2 -->> On Node 1
[grid@pdb1 ~]$ cd /opt/app/21c/grid/
[grid@pdb1 grid]$ OPatch/opatch version
/*
OPatch Version: 12.2.0.1.42

OPatch succeeded.
*/

-- Step 91 -->> On Node 1
-- To Install Grid Software with Leteset Opatch
[grid@pdb1 ~]$ cd /opt/app/21c/grid/
[grid@pdb1 grid]$ ./gridSetup.sh -ignorePrereq -waitForCompletion -silent -applyRU /tmp/36031790 -responseFile /home/grid/gridsetup.rsp
/*
Preparing the home to patch...
Applying the patch /tmp/36031790...
Successfully applied the patch.
The log can be found at: /tmp/GridSetupActions2024-05-16_03-32-54PM/installerPatchActions_2024-05-16_03-32-54PM.log
Launching Oracle Grid Infrastructure Setup Wizard...

[WARNING] [INS-13014] Target environment does not meet some optional requirements.
   CAUSE: Some of the optional prerequisites are not met. See logs for details. gridSetupActions2024-05-16_03-32-54PM.log
   ACTION: Identify the list of failed prerequisite checks from the log: gridSetupActions2024-05-16_03-32-54PM.log. Then either from the log file or from installation manual find the appropriate configuration to meet the prerequisites and fix it manually.
The response file for this session can be found at:
 /opt/app/21c/grid/install/response/grid_2024-05-16_03-32-54PM.rsp

You can find the log of this install session at:
 /tmp/GridSetupActions2024-05-16_03-32-54PM/gridSetupActions2024-05-16_03-32-54PM.log

As a root user, execute the following script(s):
        1. /opt/app/oraInventory/orainstRoot.sh
        2. /opt/app/21c/grid/root.sh

Execute /opt/app/oraInventory/orainstRoot.sh on the following nodes:
[pdb1, pdb2]
Execute /opt/app/21c/grid/root.sh on the following nodes:
[pdb1, pdb2]

Run the script on the node pdb1 first. After successful completion, you can start the script in parallel on all other nodes.

Successfully Setup Software with warning(s).
As install user, execute the following command to complete the configuration.
        /opt/app/21c/grid/gridSetup.sh -executeConfigTools -responseFile /home/grid/gridsetup.rsp [-silent]


Moved the install session logs to:
 /opt/app/oraInventory/logs/GridSetupActions2024-05-16_03-32-54PM
*/

-- Step 92 -->> On Node 1
[root@pdb1 ~]# /opt/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 93 -->> On Node 2
[root@pdb2 ~]# /opt/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 94 -->> On Node 1
[root@pdb1 ~]# /opt/app/21c/grid/root.sh
/*
Check /opt/app/21c/grid/install/root_pdb1.unidev.org.np_2024-05-16_15-57-58-559333482.log for the output of root script
*/

-- Step 94.1 -->> On Node 1
[root@pdb1 ~]#  tail -f /opt/app/21c/grid/install/root_pdb1.unidev.org.np_2024-05-16_15-57-58-559333482.log
/*
Creating /etc/oratab file...
Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Relinking oracle with rac_on option
Using configuration parameter file: /opt/app/21c/grid/crs/install/crsconfig_params
2024-05-16 15:58:30: Got permissions of file /opt/app/oracle/crsdata/pdb1/crsconfig: 0775
2024-05-16 15:58:30: Got permissions of file /opt/app/oracle/crsdata: 0775
2024-05-16 15:58:30: Got permissions of file /opt/app/oracle/crsdata/pdb1: 0775
The log of current session can be found at:
  /opt/app/oracle/crsdata/pdb1/crsconfig/rootcrs_pdb1_2024-05-16_03-58-30PM.log
2024/05/16 15:58:45 CLSRSC-594: Executing installation step 1 of 19: 'ValidateEnv'.
2024/05/16 15:58:45 CLSRSC-363: User ignored prerequisites during installation
2024/05/16 15:58:45 CLSRSC-594: Executing installation step 2 of 19: 'CheckFirstNode'.
2024/05/16 15:58:49 CLSRSC-594: Executing installation step 3 of 19: 'GenSiteGUIDs'.
2024/05/16 15:58:51 CLSRSC-594: Executing installation step 4 of 19: 'SetupOSD'.
Redirecting to /bin/systemctl restart rsyslog.service
2024/05/16 15:58:52 CLSRSC-594: Executing installation step 5 of 19: 'CheckCRSConfig'.
2024/05/16 15:58:52 CLSRSC-594: Executing installation step 6 of 19: 'SetupLocalGPNP'.
2024/05/16 15:59:07 CLSRSC-594: Executing installation step 7 of 19: 'CreateRootCert'.
2024/05/16 15:59:13 CLSRSC-594: Executing installation step 8 of 19: 'ConfigOLR'.
2024/05/16 15:59:33 CLSRSC-594: Executing installation step 9 of 19: 'ConfigCHMOS'.
2024/05/16 15:59:33 CLSRSC-594: Executing installation step 10 of 19: 'CreateOHASD'.
2024/05/16 15:59:42 CLSRSC-594: Executing installation step 11 of 19: 'ConfigOHASD'.
2024/05/16 15:59:43 CLSRSC-330: Adding Clusterware entries to file 'oracle-ohasd.service'
2024/05/16 16:00:11 CLSRSC-594: Executing installation step 12 of 19: 'SetupTFA'.
2024/05/16 16:00:11 CLSRSC-594: Executing installation step 13 of 19: 'InstallAFD'.
2024/05/16 16:00:12 CLSRSC-594: Executing installation step 14 of 19: 'InstallACFS'.
2024/05/16 16:00:22 CLSRSC-594: Executing installation step 15 of 19: 'InstallKA'.
2024/05/16 16:00:29 CLSRSC-594: Executing installation step 16 of 19: 'InitConfig'.
2024/05/16 16:00:30 CLSRSC-4004: Failed to install Oracle Autonomous Health Framework (AHF).
Grid Infrastructure operations will continue.
2024/05/16 16:01:38 CLSRSC-482: Running command: '/opt/app/21c/grid/bin/ocrconfig -upgrade grid oinstall'
CRS-4256: Updating the profile
Successful addition of voting disk d14e36ebf21e4f10bf3f13459d7a18c4.
Successfully replaced voting disk group with +OCR.
CRS-4256: Updating the profile
CRS-4266: Voting file(s) successfully replaced
##  STATE    File Universal Id                File Name Disk group
--  -----    -----------------                --------- ---------
 1. ONLINE   d14e36ebf21e4f10bf3f13459d7a18c4 (/dev/oracleasm/disks/OCR) [OCR]
Located 1 voting disk(s).
2024/05/16 16:02:52 CLSRSC-594: Executing installation step 17 of 19: 'StartCluster'.
2024/05/16 16:03:59 CLSRSC-343: Successfully started Oracle Clusterware stack
2024/05/16 16:03:59 CLSRSC-594: Executing installation step 18 of 19: 'ConfigNode'.
2024/05/16 16:05:40 CLSRSC-594: Executing installation step 19 of 19: 'PostConfig'.
2024/05/16 16:06:02 CLSRSC-325: Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 95 -->> On Node 2
[root@pdb2 ~]# /opt/app/21c/grid/root.sh
/*
Check /opt/app/21c/grid/install/root_pdb2.unidev.org.np_2024-05-16_16-09-42-635067576.log for the output of root script
*/

-- Step 95.1 -->> On Node 2 
[root@pdb2 ~]#  tail -f /opt/app/21c/grid/install/root_pdb2.unidev.org.np_2024-05-16_16-09-42-635067576.log
/*
Creating /etc/oratab file...
Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Relinking oracle with rac_on option
Using configuration parameter file: /opt/app/21c/grid/crs/install/crsconfig_params
2024-05-16 16:10:21: Got permissions of file /opt/app/oracle/crsdata/pdb2/crsconfig: 0775
2024-05-16 16:10:21: Got permissions of file /opt/app/oracle/crsdata: 0775
2024-05-16 16:10:21: Got permissions of file /opt/app/oracle/crsdata/pdb2: 0775
The log of current session can be found at:
  /opt/app/oracle/crsdata/pdb2/crsconfig/rootcrs_pdb2_2024-05-16_04-10-21PM.log
2024/05/16 16:10:28 CLSRSC-594: Executing installation step 1 of 19: 'ValidateEnv'.
2024/05/16 16:10:28 CLSRSC-363: User ignored prerequisites during installation
2024/05/16 16:10:28 CLSRSC-594: Executing installation step 2 of 19: 'CheckFirstNode'.
2024/05/16 16:10:30 CLSRSC-594: Executing installation step 3 of 19: 'GenSiteGUIDs'.
2024/05/16 16:10:30 CLSRSC-594: Executing installation step 4 of 19: 'SetupOSD'.
Redirecting to /bin/systemctl restart rsyslog.service
2024/05/16 16:10:31 CLSRSC-594: Executing installation step 5 of 19: 'CheckCRSConfig'.
2024/05/16 16:10:32 CLSRSC-594: Executing installation step 6 of 19: 'SetupLocalGPNP'.
2024/05/16 16:10:33 CLSRSC-594: Executing installation step 7 of 19: 'CreateRootCert'.
2024/05/16 16:10:34 CLSRSC-594: Executing installation step 8 of 19: 'ConfigOLR'.
2024/05/16 16:10:47 CLSRSC-594: Executing installation step 9 of 19: 'ConfigCHMOS'.
2024/05/16 16:10:47 CLSRSC-594: Executing installation step 10 of 19: 'CreateOHASD'.
2024/05/16 16:10:48 CLSRSC-594: Executing installation step 11 of 19: 'ConfigOHASD'.
2024/05/16 16:10:49 CLSRSC-330: Adding Clusterware entries to file 'oracle-ohasd.service'
2024/05/16 16:11:11 CLSRSC-594: Executing installation step 12 of 19: 'SetupTFA'.
2024/05/16 16:11:12 CLSRSC-594: Executing installation step 13 of 19: 'InstallAFD'.
2024/05/16 16:11:12 CLSRSC-594: Executing installation step 14 of 19: 'InstallACFS'.
2024/05/16 16:11:14 CLSRSC-594: Executing installation step 15 of 19: 'InstallKA'.
2024/05/16 16:11:16 CLSRSC-594: Executing installation step 16 of 19: 'InitConfig'.
2024/05/16 16:11:27 CLSRSC-4004: Failed to install Oracle Autonomous Health Framework (AHF).
Grid Infrastructure operations will continue.
2024/05/16 16:11:27 CLSRSC-594: Executing installation step 17 of 19: 'StartCluster'.
2024/05/16 16:12:16 CLSRSC-343: Successfully started Oracle Clusterware stack
2024/05/16 16:12:16 CLSRSC-594: Executing installation step 18 of 19: 'ConfigNode'.
2024/05/16 16:12:25 CLSRSC-594: Executing installation step 19 of 19: 'PostConfig'.
2024/05/16 16:12:32 CLSRSC-325: Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 96 -->> On Node 1
[grid@pdb1 ~]$ cd /opt/app/21c/grid/
[grid@pdb1 grid]$ /opt/app/21c/grid/gridSetup.sh -silent -executeConfigTools -responseFile /home/grid/gridsetup.rsp
/*
Launching Oracle Grid Infrastructure Setup Wizard...

You can find the logs of this session at:
/opt/app/oraInventory/logs/GridSetupActions2024-05-16_04-14-06PM

Successfully Configured Software.
*/

-- Step 96.1 -->> On Node 1
[root@pdb1 ~]# tail -f  /opt/app/oraInventory/logs/UpdateNodeList2024-05-16_04-14-06PM.log
/*
INFO: All threads completed its operations
INFO: Checkpoint:Index file written and updated
INFO: Done calling doOperation.
INFO: 'UpdateNodeList' was successful.
*/

-- Step 96.2 -->> On Node 1
/*
CLSRSC-04004
Failed to install Oracle Autonomous Health Framework (AHF). Grid Infrastructure operations will continue.
Cause
The Installation of Oracle Autonomous Health Framework (AHF) failed with the accompanying errors.

Action
The Oracle Autonomous Health Framework (AHF) will not be available, but Grid Infrastructure operation is unaffected. Address the issues reported by accompanying messages 
and retry using the command '<GI_Home>/crs/install/ahf_setup -crshome <GI_Home>'. If the problem persists, contact Oracle Support Services for further action.
*/
[grid@pdb1 ~]$ cd /opt/app/21c/grid/

-- Step 96.3 -->> On Node 1
[grid@pdb1 grid]$ /opt/app/21c/grid/crs/install/ahf_setup -crshome /opt/app/21c/grid/
/*
AHF Installer for Platform Generic Architecture Generic

AHF Installation Log : /tmp/ahf_install_239500_81142_2024_05_16-16_18_23.log

Starting Autonomous Health Framework (AHF) Installation

AHF Version: 23.9.5 Build Date: 202312042117

AHF Location : /home/grid/oracle.ahf

AHF Data Directory : /home/grid/oracle.ahf/data

Extracting AHF to /home/grid/oracle.ahf

Configuring TFA in Standalone Mode...

Build Version : 2309500  Build Date : 202312042117

Discovering Nodes and Oracle Resources

.-----------------------------------------------------------.
|                Summary of TFA Configuration               |
+----------------+------------------------------------------+
| Parameter      | Value                                    |
+----------------+------------------------------------------+
| TFA Location   | /home/grid/oracle.ahf/tfa                |
| Data Directory | /home/grid/oracle.ahf/data/pdb1/tfa      |
| Repository     | /home/grid/oracle.ahf/data/repository    |
| Diag Directory | /home/grid/oracle.ahf/data/pdb1/diag/tfa |
| Java Home      | /opt/app/21c/grid//jdk/jre               |
'----------------+------------------------------------------'

.----------------------------------------------------------------------------------------------.
| Host | Status of TFA | PID | Port    | Version    | Build ID              | Inventory Status |
+------+---------------+-----+---------+------------+-----------------------+------------------+
| pdb1 | RUNNING       | -   | OFFLINE | 23.9.5.0.0 | 230950020231204211744 | COMPLETED        |
'------+---------------+-----+---------+------------+-----------------------+------------------'

AHF is deployed at /home/grid/oracle.ahf

Setting up AHF CLI and SDK
/bin/ln: failed to create symbolic link '/opt/app/21c/grid//bin/tfactl': Permission denied

ORAchk is available at /home/grid/oracle.ahf/bin/orachk

AHF binaries are available in /home/grid/oracle.ahf/bin

AHF is successfully Installed

Moving /tmp/ahf_install_239500_81142_2024_05_16-16_18_23.log to /home/grid/oracle.ahf/data/pdb1/diag/ahf/
*/

-- Step 96.4 -->> On Node 2
[grid@pdb2 ~]$ cd /opt/app/21c/grid/

-- Step 96.5 -->> On Node 2
[grid@pdb2 grid]$ /opt/app/21c/grid/crs/install/ahf_setup -crshome /opt/app/21c/grid/
/*
AHF Installer for Platform Generic Architecture Generic

AHF Installation Log : /tmp/ahf_install_239500_121934_2024_05_16-16_22_16.log

Starting Autonomous Health Framework (AHF) Installation

AHF Version: 23.9.5 Build Date: 202312042117

AHF Location : /home/grid/oracle.ahf

AHF Data Directory : /home/grid/oracle.ahf/data

Extracting AHF to /home/grid/oracle.ahf

Configuring TFA in Standalone Mode...

Build Version : 2309500  Build Date : 202312042117

Discovering Nodes and Oracle Resources

.-----------------------------------------------------------.
|                Summary of TFA Configuration               |
+----------------+------------------------------------------+
| Parameter      | Value                                    |
+----------------+------------------------------------------+
| TFA Location   | /home/grid/oracle.ahf/tfa                |
| Data Directory | /home/grid/oracle.ahf/data/pdb2/tfa      |
| Repository     | /home/grid/oracle.ahf/data/repository    |
| Diag Directory | /home/grid/oracle.ahf/data/pdb2/diag/tfa |
| Java Home      | /opt/app/21c/grid//jdk/jre               |
'----------------+------------------------------------------'

.----------------------------------------------------------------------------------------------.
| Host | Status of TFA | PID | Port    | Version    | Build ID              | Inventory Status |
+------+---------------+-----+---------+------------+-----------------------+------------------+
| pdb2 | RUNNING       | -   | OFFLINE | 23.9.5.0.0 | 230950020231204211744 | COMPLETED        |
'------+---------------+-----+---------+------------+-----------------------+------------------'

AHF is deployed at /home/grid/oracle.ahf

Setting up AHF CLI and SDK
/bin/ln: failed to create symbolic link '/opt/app/21c/grid//bin/tfactl': Permission denied

ORAchk is available at /home/grid/oracle.ahf/bin/orachk

AHF binaries are available in /home/grid/oracle.ahf/bin

AHF is successfully Installed

Moving /tmp/ahf_install_239500_121934_2024_05_16-16_22_16.log to /home/grid/oracle.ahf/data/pdb2/diag/ahf/
*/

-- Step 97 -->> On Both Nodes
[root@pdb1/pdb2 ~]# cd /opt/app/21c/grid/bin/
[root@pdb1/pdb2 bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/


-- Step 98 -->> On Both Nodes
[root@pdb1/pdb2 ~]# cd /opt/app/21c/grid/bin/
[root@pdb1/pdb2 bin]# ./crsctl check cluster -all
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
*/

-- Step 99 -->> On Node 1
[root@pdb1 ~]# cd /opt/app/21c/grid/bin/
[root@pdb1 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdb1                     Started,STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.crf
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.crsd
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.cssd
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.ctssd
      1        ONLINE  ONLINE       pdb1                     OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.evmd
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.gipcd
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.gpnpd
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.mdnsd
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.storage
      1        ONLINE  ONLINE       pdb1                     STABLE
--------------------------------------------------------------------------------
*/


-- Step 100 -->> On Node 2
[root@pdb2 ~]# cd /opt/app/21c/grid/bin/
[root@pdb2 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.crf
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.crsd
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.cssd
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.ctssd
      1        ONLINE  ONLINE       pdb2                     OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.evmd
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.gipcd
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.gpnpd
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.mdnsd
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.storage
      1        ONLINE  ONLINE       pdb2                     STABLE
--------------------------------------------------------------------------------
*/

-- Step 101 -->> On Both Nodes
[root@pdb1/pdb2 ~]# cd /opt/app/21c/grid/bin/
[root@pdb1/pdb2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       pdb1                     STABLE
               ONLINE  ONLINE       pdb2                     STABLE
ora.chad
               ONLINE  ONLINE       pdb1                     STABLE
               ONLINE  ONLINE       pdb2                     STABLE
ora.net1.network
               ONLINE  ONLINE       pdb1                     STABLE
               ONLINE  ONLINE       pdb2                     STABLE
ora.ons
               ONLINE  ONLINE       pdb1                     STABLE
               ONLINE  ONLINE       pdb2                     STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     Started,STABLE
      2        ONLINE  ONLINE       pdb2                     Started,STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.cdp1.cdp
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.cdp2.cdp
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.cvu
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.pdb1.vip
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.pdb2.vip
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.qosmserver
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       pdb2                     STABLE
--------------------------------------------------------------------------------
*/


-- Step 102 -->> On Both Nodes
[grid@pdb1/pdb2 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20136                0           20136              0             Y  OCR/
ASMCMD [+] > exit
*/

-- Step 103 -->> On Node 1
[grid@pdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 21.0.0.0.0 - Production on 16-MAY-2024 16:34:24

Copyright (c) 1991, 2021, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 21.0.0.0.0 - Production
Start Date                16-MAY-2024 16:05:53
Uptime                    0 days 0 hr. 28 min. 31 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/21c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.21)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.23)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 103.1 -->> On Node 1
[grid@pdb1 ~]$ ps -ef | grep SCAN
/*
grid       53851       1  0 16:04 ?        00:00:00 /opt/app/21c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid       86083   85901  0 16:34 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 103.2 -->> On Node 1
[grid@pdb1 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 21.0.0.0.0 - Production on 16-MAY-2024 16:34:56

Copyright (c) 1991, 2021, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 21.0.0.0.0 - Production
Start Date                16-MAY-2024 16:04:47
Uptime                    0 days 0 hr. 30 min. 8 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/21c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.25)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 103.3 -->> On Node 2
[grid@pdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 21.0.0.0.0 - Production on 16-MAY-2024 16:35:23

Copyright (c) 1991, 2021, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 21.0.0.0.0 - Production
Start Date                16-MAY-2024 16:12:28
Uptime                    0 days 0 hr. 22 min. 54 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/21c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.22)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.24)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 103.4 -->> On Node 2
[grid@pdb2 ~]$ ps -ef | grep SCAN
/*
grid      100968       1  0 16:12 ?        00:00:00 /opt/app/21c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid      125195  125128  0 16:35 pts/1    00:00:00 grep --color=auto SCAN
*/

-- Step 103.5 -->> On Node 2
[grid@pdb2 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 21.0.0.0.0 - Production on 16-MAY-2024 16:35:56

Copyright (c) 1991, 2021, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 21.0.0.0.0 - Production
Start Date                16-MAY-2024 16:12:19
Uptime                    0 days 0 hr. 23 min. 37 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/21c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.26)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 104 -->> On Node 1
-- To Create ASM storage for Data and Archive 
[grid@pdb1 ~]$ cd /opt/app/21c/grid/bin

-- Step 104.1 -->> On Node 1
[grid@pdb1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName DATA -diskList /dev/oracleasm/disks/DATA -redundancy EXTERNAL

-- Step 104.2 -->> On Node 1
[grid@pdb1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName ARC -diskList /dev/oracleasm/disks/ARC -redundancy EXTERNAL

-- Step 105 -->> On Both Nodes
[grid@pdb1/pdb2 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 21.0.0.0.0 - Production on Thu May 16 16:37:54 2024
Version 21.13.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.


Connected to:
Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production
Version 21.13.0.0.0

SQL> set lines 200;
SQL> COLUMN name FORMAT A30
SQL> SELECT inst_id,name,state,type,compatibility,database_compatibility,voting_files FROM gv$asm_diskgroup order by name;

   INST_ID NAME STATE   TYPE   COMPATIBILITY DATABASE_COMPATIBILITY V
---------- ---- ------- ------ ------------- ---------------------- -
         2 ARC  MOUNTED EXTERN 21.0.0.0.0    10.1.0.0.0             N
         1 ARC  MOUNTED EXTERN 21.0.0.0.0    10.1.0.0.0             N
         1 DATA MOUNTED EXTERN 21.0.0.0.0    10.1.0.0.0             N
         2 DATA MOUNTED EXTERN 21.0.0.0.0    10.1.0.0.0             N
         1 OCR  MOUNTED EXTERN 21.0.0.0.0    10.1.0.0.0             Y
         2 OCR  MOUNTED EXTERN 21.0.0.0.0    10.1.0.0.0             Y

6 rows selected.

SQL> set lines 200;
SQL> col path format a40;
SQL> SELECT name,path, group_number group_#, disk_number disk_#, mount_status,header_status, state, total_mb, free_mb FROM v$asm_disk order by group_number;

NAME      PATH                      GROUP_# DISK_# MOUNT_S HEADER_STATU STATE  TOTAL_MB FREE_MB
--------- ------------------------- ------- ------ ------- ------------ ------ -------- -------
OCR_0000  /dev/oracleasm/disks/OCR        1      0 CACHED  MEMBER       NORMAL    20476   20136
DATA_0000 /dev/oracleasm/disks/DATA       2      0 CACHED  MEMBER       NORMAL   204799  204689
ARC_0000  /dev/oracleasm/disks/ARC        3      0 CACHED  MEMBER       NORMAL   409599  409485

SQL> set lines 200;
SQL> col BANNER_FULL format a80;
SQL> col BANNER_LEGACY format a80;
SQL> SELECT inst_id,banner_full,banner_legacy,con_id FROM gv$version;

   INST_ID BANNER_FULL                                                                      BANNER_LEGACY                                                                        CON_ID
---------- -------------------------------------------------------------------------------- -------------------------------------------------------------------------------- ----------
         1 Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production           Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production                    0
           Version 21.13.0.0.0

         2 Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production           Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production                    0
           Version 21.13.0.0.0

SQL> exit
Disconnected from Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production
Version 21.13.0.0.0
*/

-- Step 106 -->> On Both Nodes
[root@pdb1/pdb2 ~]# cd /opt/app/21c/grid/bin
[root@pdb1/pdb2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       pdb1                     STABLE
               ONLINE  ONLINE       pdb2                     STABLE
ora.chad
               ONLINE  ONLINE       pdb1                     STABLE
               ONLINE  ONLINE       pdb2                     STABLE
ora.net1.network
               ONLINE  ONLINE       pdb1                     STABLE
               ONLINE  ONLINE       pdb2                     STABLE
ora.ons
               ONLINE  ONLINE       pdb1                     STABLE
               ONLINE  ONLINE       pdb2                     STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ARC.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.DATA.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     Started,STABLE
      2        ONLINE  ONLINE       pdb2                     Started,STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.cdp1.cdp
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.cdp2.cdp
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.cvu
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.pdb1.vip
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.pdb2.vip
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.qosmserver
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       pdb2                     STABLE
--------------------------------------------------------------------------------
*/

-- Step 107 -->> On Both Nodes
[grid@pdb1/pdb2 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  1048576    409599   409485                0          409485              0             N  ARC/
MOUNTED  EXTERN  N         512             512   4096  1048576    204799   204689                0          204689              0             N  DATA/
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20136                0           20136              0             Y  OCR/
ASMCMD [+] > exit
*/

-- Step 108 -->> On Node 1
[root@pdb1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/21c/grid:N
*/

-- Step 109 -->> On Node 2
[root@pdb2 ~]# vi /etc/oratab
/*
+ASM2:/opt/app/21c/grid:N
*/

-- Step 110 -->> On Both Nodes
-- Creating the Oracle RDBMS Home Directory
[root@pdb1/pdb2 ~]# mkdir -p /opt/app/oracle/product/21c/db_1
[root@pdb1/pdb2 ~]# chown -R oracle:oinstall /opt/app/oracle/product/21c/db_1
[root@pdb1/pdb2 ~]# chmod -R 775 /opt/app/oracle/product/21c/db_1

-- Step 110.1 -->> On Node 1
-- To unzip the Oracle Binary and Letest Opatch
[root@pdb1 ~]# cd /opt/app/oracle/product/21c/db_1
[root@pdb1 db_1]# unzip -oq /root/Oracle_21C/21.3.0.0.0_DB_Binary/LINUX.X64_213000_db_home.zip
[root@pdb1 db_1]# unzip -oq /root/Oracle_21C/OPATCH_21c/p6880880_210000_Linux-x86-64.zip

-- Step 110.2 -->> On Node 1
[root@pdb1 ~]# chown -R oracle:oinstall /opt/app/oracle/product/21c/db_1/
[root@pdb1 ~]# chmod -R 775 /opt/app/oracle/product/21c/db_1/

-- Step 110.3 -->> On Node 1
[root@pdb1 ~]# su - oracle
[oracle@pdb1 ~]$ /opt/app/oracle/product/21c/db_1/OPatch/opatch version
/*
OPatch Version: 12.2.0.1.42

OPatch succeeded.
*/

-- Step 111 -->> On Node 1
-- To Setup the SSH Connectivity 
[root@pdb1 ~]# su - oracle
[oracle@pdb1 ~]$ cd /opt/app/oracle/product/21c/db_1/deinstall/
[oracle@pdb1 deinstall]$ ./sshUserSetup.sh -user oracle -hosts "pdb1 pdb2" -noPromptPassphrase -confirm -advanced
/*
Password: oracle
*/
-- Step 112 -->> On Both Nodes
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb1 date
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb2 date
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb1 date && ssh oracle@pdb2 date
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb1.unidev.org.np date
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb2.unidev.org.np date
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb1.unidev.org.np date && ssh oracle@pdb2.unidev.org.np date

-- Step 113 -->> On Node 1
-- To Create a responce file for Oracle Software Installation
[oracle@pdb1 ~]$ cp /opt/app/oracle/product/21c/db_1/install/response/db_install.rsp /home/oracle/
[oracle@pdb1 ~]$ cd /home/oracle/

-- Step 113.1 -->> On Node 1
[oracle@pdb1 ~]$ ls -ltr
/*
-rwxr-xr-x 1 oracle oinstall 19932 May 13 11:55 db_install.rsp
*/

-- Step 113.2 -->> On Node 1
[oracle@pdb1 ~]$ vi db_install.rsp
/*
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v21.0.0
oracle.install.option=INSTALL_DB_SWONLY
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/opt/app/oraInventory
ORACLE_HOME=/opt/app/oracle/product/21c/db_1
ORACLE_BASE=/opt/app/oracle
oracle.install.db.InstallEdition=EE
ORACLE_HOSTNAME=pdb1.unidev.org.np
SELECTED_LANGUAGES=en
oracle.install.db.OSDBA_GROUP=dba
oracle.install.db.OSOPER_GROUP=oper
oracle.install.db.OSBACKUPDBA_GROUP=backupdba
oracle.install.db.OSDGDBA_GROUP=dgdba
oracle.install.db.OSKMDBA_GROUP=kmdba
oracle.install.db.OSRACDBA_GROUP=racdba
oracle.install.db.rootconfig.executeRootScript=false
oracle.install.db.CLUSTER_NODES=pdb1,pdb2
oracle.install.db.config.starterdb.type=GENERAL_PURPOSE
*/

-- Step 114 -->> On Node 1
-- To install Oracle Software with Letest Opatch
[oracle@pdb1 ~]$ cd /opt/app/oracle/product/21c/db_1/
[oracle@pdb1 db_1]$ ./runInstaller -ignorePrereq -waitforcompletion -silent \
-applyRU /tmp/36031790                                                      \
-responseFile /home/oracle/db_install.rsp                                   \
oracle.install.db.isRACOneInstall=false                                     \
oracle.install.db.rac.serverpoolCardinality=0                               \
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false                                  \
DECLINE_SECURITY_UPDATES=true

/*
Preparing the home to patch...
Applying the patch /tmp/36031790...
Successfully applied the patch.
The log can be found at: /opt/app/oraInventory/logs/InstallActions2024-05-17_12-31-36PM/installerPatchActions_2024-05-17_12-31-36PM.log
Launching Oracle Database Setup Wizard...

[WARNING] [INS-13014] Target environment does not meet some optional requirements.
   CAUSE: Some of the optional prerequisites are not met. See logs for details. /opt/app/oraInventory/logs/InstallActions2024-05-17_12-31-36PM/installActions2024-05-17_12-31-36PM.log
   ACTION: Identify the list of failed prerequisite checks from the log: /opt/app/oraInventory/logs/InstallActions2024-05-17_12-31-36PM/installActions2024-05-17_12-31-36PM.log. Then either from the log file or from installation manual find the appropriate configuration to meet the prerequisites and fix it manually.
The response file for this session can be found at:
 /opt/app/oracle/product/21c/db_1/install/response/db_2024-05-17_12-31-36PM.rsp

You can find the log of this install session at:
 /opt/app/oraInventory/logs/InstallActions2024-05-17_12-31-36PM/installActions2024-05-17_12-31-36PM.log

As a root user, execute the following script(s):
        1. /opt/app/oracle/product/21c/db_1/root.sh

Execute /opt/app/oracle/product/21c/db_1/root.sh on the following nodes:
[pdb1, pdb2]


Successfully Setup Software with warning(s).
*/

-- Step 115 -->> On Node 1
[root@pdb1 ~]# /opt/app/oracle/product/21c/db_1/root.sh
/*
Check /opt/app/oracle/product/21c/db_1/install/root_pdb1.unidev.org.np_2024-05-17_12-48-46-697231810.log for the output of root script
*/

-- Step 115.1 -->> On Node 1
[root@pdb1 ~]# tail -f  /opt/app/oracle/product/21c/db_1/install/root_pdb1.unidev.org.np_2024-05-17_12-48-46-697231810.log
/*
    ORACLE_OWNER= oracle
    ORACLE_HOME=  /opt/app/oracle/product/21c/db_1
   Copying dbhome to /usr/local/bin ...
   Copying oraenv to /usr/local/bin ...
   Copying coraenv to /usr/local/bin ...

Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
*/

-- Step 116 -->> On Node 2
[root@pdb2 ~]# /opt/app/oracle/product/21c/db_1/root.sh
/*
Check /opt/app/oracle/product/21c/db_1/install/root_pdb2.unidev.org.np_2024-05-17_12-50-10-713685284.log for the output of root script
*/

-- Step 116.1 -->> On Node 2
[root@pdb2 ~]# tail -f /opt/app/oracle/product/21c/db_1/install/root_pdb2.unidev.org.np_2024-05-17_12-50-10-713685284.log
/*
    ORACLE_OWNER= oracle
    ORACLE_HOME=  /opt/app/oracle/product/21c/db_1
   Copying dbhome to /usr/local/bin ...
   Copying oraenv to /usr/local/bin ...
   Copying coraenv to /usr/local/bin ...

Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
*/

-- Step 117 -->> On Both Nodes
[grid@pdb1/pdb2 ~]$ cd /opt/app/21c/grid/OPatch/

-- Step 118 -->> On Both Nodes
[grid@pdb1/pdb2 OPatch]$ ./opatch lsinventory
/*
Oracle Interim Patch Installer version 12.2.0.1.42
Copyright (c) 2024, Oracle Corporation.  All rights reserved.


Oracle Home       : /opt/app/21c/grid
Central Inventory : /opt/app/oraInventory
   from           : /opt/app/21c/grid/oraInst.loc
OPatch version    : 12.2.0.1.42
OUI version       : 12.2.0.9.0
Log file location : /opt/app/21c/grid/cfgtoollogs/opatch/opatch2024-05-17_13-25-43PM_1.log

Lsinventory Output file location : /opt/app/21c/grid/cfgtoollogs/opatch/lsinv/lsinventory2024-05-17_13-25-43PM.txt
--------------------------------------------------------------------------------
Local Machine Information::
Hostname: pdb1.unidev.org.np
ARU platform id: 226
ARU platform description:: Linux x86-64

Installed Top-level Products (1):

Oracle Grid Infrastructure 21c                                       21.0.0.0.0
There are 1 products installed in this Oracle Home.


Interim patches (6) :

Patch  36115667     : applied on Thu May 16 15:42:27 NPT 2024
Unique Patch ID:  25496189
Patch description:  "DBWLM RELEASE UPDATE 21.0.0.0.0 (36115667)"
   Created on 16 Dec 2023, 08:49:53 hrs PST8PDT
   Bugs fixed:
     33442268, 33442297, 34302291, 34425459, 34877524, 35175940, 35457574
     35462334, 35462362, 35645028, 35840636, 36020742

Patch  36115660     : applied on Thu May 16 15:42:16 NPT 2024
Unique Patch ID:  25496121
Patch description:  "TOMCAT RELEASE UPDATE 21.0.0.0.0 (36115660)"
   Created on 16 Dec 2023, 08:46:37 hrs PST8PDT
   Bugs fixed:
     33121445, 33655429, 33846688, 34300543, 34519419, 34816344, 34970057
     35229376, 35538576, 35779899, 35926707, 36066696

Patch  36080534     : applied on Thu May 16 15:42:03 NPT 2024
Unique Patch ID:  25489146
Patch description:  "ACFS RELEASE UPDATE 21.13.0.0.0 (36080534)"
   Created on 12 Dec 2023, 01:01:59 hrs PST8PDT
   Bugs fixed:
     14219141, 27092156, 29007848, 29312860, 30401348, 30669150, 30763780
     31240893, 31373680, 31469859, 31480840, 31650488, 31785427, 31887695
     31972780, 32009557, 32053624, 32060190, 32170491, 32171442, 32181415
     32229168, 32229318, 32229425, 32260279, 32299146, 32316917, 32340237
     32340931, 32367529, 32408906, 32415157, 32422929, 32494784, 32502202
     32512835, 32544056, 32545085, 32545630, 32551355, 32556232, 32564270
     32572545, 32582925, 32588318, 32607749, 32609787, 32637925, 32667452
     32675860, 32675965, 32710991, 32755668, 32755942, 32759909, 32762522
     32764540, 32804687, 32806752, 32809324, 32837913, 32848142, 32867876
     32868385, 32869666, 32894246, 32922419, 32923286, 32923327, 32931932
     32933327, 32936642, 32952575, 32953519, 32969945, 32974328, 32974639
     32974833, 32977444, 32981539, 32981794, 32992816, 32992829, 32994270
     32994280, 32994281, 32994291, 33005145, 33021179, 33021202, 33026062
     33026375, 33030584, 33031625, 33038446, 33048670, 33060354, 33064281
     33065181, 33066603, 33073375, 33075589, 33085757, 33105622, 33109733
     33130785, 33130827, 33130965, 33132294, 33133009, 33133024, 33133038
     33137661, 33138482, 33142914, 33144454, 33145412, 33145561, 33145717
     33147256, 33147501, 33170384, 33175565, 33190879, 33191896, 33193878
     33195219, 33205396, 33207533, 33210641, 33210802, 33212101, 33218049
     33219621, 33220908, 33223810, 33224465, 33224481, 33233798, 33235118
     33249415, 33251065, 33251130, 33260930, 33263512, 33278283, 33324868
     33325909, 33329308, 33332620, 33360728, 33363986, 33365073, 33368387
     33371176, 33396072, 33401564, 33410632, 33410971, 33461780, 33470070
     33472585, 33482573, 33486421, 33489636, 33489748, 33497706, 33508529
     33532057, 33535435, 33539507, 33556752, 33569912, 33602480, 33634715
     33675718, 33691463, 33703585, 33718130, 33735792, 33742657, 33744273
     33784974, 33794311, 33836872, 33840684, 33841923, 33850838, 33901088
     33935150, 33937856, 33968140, 33975945, 33994001, 34007139, 34007365
     34089564, 34212005, 34234011, 34295413, 34329842, 34334714, 34362192
     34399866, 34457130, 34461665, 34469255, 34514670, 34522576, 34525437
     34534028, 34599358, 34619603, 34633823, 34635944, 34704099, 34718455
     34738118, 34739092, 34979052, 35068505, 36055114

Patch  36041222     : applied on Thu May 16 15:39:21 NPT 2024
Unique Patch ID:  25517168
Patch description:  "Database Release Update : 21.13.0.0.240116 (36041222)"
   Created on 8 Jan 2024, 09:57:54 hrs UTC
   Bugs fixed:
     19884953, 19958239, 24559425, 24597536, 24916492, 25562258, 25655012
     26139817, 26352569, 26950182, 27162036, 27751518, 27897090, 27979632
     28044739, 28089112, 28294439, 28337860, 28513129, 28632799, 28882751
     28994721, 29027914, 29413205, 29524043, 29587488, 29591661, 29617414
     29811720, 29900186, 29927360, 29948154, 30082402, 30343750, 30481004
     30610097, 30706073, 30710917, 30722105, 30747820, 30771009, 30808364
     30840150, 30846263, 30876666, 30933117, 30961824, 31006259, 31006953
     31026870, 31044504, 31073424, 31079198, 31110887, 31113682, 31138371
     31192261, 31243859, 31251325, 31287296, 31356954, 31385668, 31387123
     31414524, 31429692, 31487775, 31488085, 31504723, 31526250, 31531079
     31535516, 31562484, 31588631, 31596817, 31615736, 31628975, 31649223
     31652763, 31656601, 31676324, 31720377, 31725154, 31731407, 31768866
     31773909, 31780567, 31781944, 31800059, 31800139, 31824792, 31827584
     31834214, 31834611, 31834677, 31841210, 31843716, 31843845, 31844137
     31844357, 31844557, 31872320, 31897178, 31912834, 31918462, 31923463
     31927078, 31932042, 31933842, 31933846, 31933914, 31938116, 31939767
     31951628, 31954223, 31959140, 31960603, 31969646, 31974187, 31982879
     31986827, 31987278, 31987922, 31988833, 31992242, 31992615, 31992953
     31993051, 31994298, 31996331, 31997660, 32003908, 32008408, 32008716
     32009197, 32012400, 32013253, 32015642, 32017570, 32017635, 32020701
     32041003, 32055692, 32056529, 32057565, 32069508, 32071457, 32075130
     32078078, 32081381, 32092797, 32097767, 32102542, 32102722, 32104578
     32114541, 32114746, 32115403, 32118543, 32119144, 32122804, 32132504
     32133898, 32159343, 32161381, 32166950, 32178966, 32183102, 32183756
     32184235, 32184577, 32184844, 32185296, 32190419, 32196943, 32198292
     32198368, 32198396, 32199681, 32205514, 32212062, 32219835, 32224140
     32225117, 32225742, 32233406, 32234148, 32240272, 32249371, 32254686
     32255529, 32255753, 32255762, 32258388, 32258423, 32277793, 32284608
     32285563, 32287989, 32292805, 32294031, 32297469, 32297849, 32298173
     32298782, 32300822, 32302470, 32312412, 32335257, 32338919, 32342345
     32343092, 32345050, 32346254, 32346649, 32357412, 32361175, 32361677
     32362072, 32365085, 32366303, 32368480, 32371828, 32372554, 32372725
     32373696, 32374616, 32377901, 32379001, 32380591, 32382021, 32386720
     32390629, 32393137, 32394623, 32396326, 32408640, 32417301, 32423678
     32423985, 32424465, 32425778, 32425862, 32426213, 32427158, 32427583
     32427953, 32428097, 32431049, 32431251, 32432078, 32432245, 32436460
     32436721, 32439726, 32441128, 32441671, 32442229, 32449909, 32459632
     32460145, 32462153, 32465193, 32465209, 32465495, 32468643, 32471100
     32471251, 32472485, 32478452, 32481807, 32486955, 32492382, 32498569
     32498752, 32503790, 32506166, 32506473, 32506809, 32507542, 32509814
     32514516, 32515850, 32523613, 32524841, 32526703, 32529396, 32530202
     32531647, 32533461, 32535156, 32538824, 32540706, 32540772, 32544740
     32546937, 32549277, 32550894, 32551246, 32555592, 32556165, 32556311
     32561841, 32573197, 32579075, 32580852, 32583315, 32583355, 32583692
     32584375, 32584505, 32585832, 32587305, 32587793, 32587994, 32588656
     32593877, 32594965, 32597099, 32597637, 32602194, 32602990, 32603092
     32606093, 32607991, 32608583, 32609512, 32610185, 32610271, 32618819
     32619195, 32620859, 32621140, 32621309, 32625160, 32625356, 32626756
     32626830, 32628168, 32629028, 32630060, 32634049, 32635881, 32635931
     32639432, 32639860, 32642587, 32645139, 32649737, 32649749, 32651063
     32651773, 32652605, 32653470, 32662165, 32665836, 32669149, 32672057
     32674819, 32675095, 32677000, 32682586, 32685286, 32685989, 32690400
     32692372, 32697157, 32697859, 32698508, 32700455, 32701048, 32703155
     32704013, 32705734, 32709170, 32710534, 32712791, 32712916, 32719288
     32719445, 32719456, 32720344, 32724505, 32726772, 32728984, 32730701
     32732179, 32733845, 32734021, 32734171, 32734800, 32735915, 32736370
     32737827, 32737969, 32740515, 32743290, 32747680, 32747738, 32748806
     32750940, 32753472, 32754044, 32754574, 32755517, 32760868, 32761294
     32761932, 32763050, 32763283, 32763544, 32764690, 32766397, 32766407
     32766916, 32768752, 32769880, 32770651, 32771735, 32775512, 32775526
     32776891, 32781826, 32782851, 32786308, 32789228, 32790012, 32794261
     32797486, 32800137, 32800539, 32801192, 32801303, 32801337, 32802926
     32803807, 32804609, 32806069, 32806915, 32809152, 32810125, 32818545
     32822436, 32822847, 32823545, 32823692, 32827206, 32829563, 32831451
     32831901, 32834394, 32834426, 32838028, 32838533, 32842415, 32843672
     32846876, 32848060, 32848816, 32850174, 32851615, 32852484, 32852504
     32856375, 32856640, 32857881, 32863795, 32864736, 32866089, 32868344
     32868369, 32869560, 32874225, 32874773, 32875003, 32875118, 32879447
     32880390, 32881057, 32881462, 32883252, 32883853, 32887649, 32888458
     32889096, 32891500, 32893951, 32897184, 32897679, 32898672, 32898678
     32898971, 32901237, 32903472, 32903625, 32904867, 32907741, 32908249
     32908946, 32909255, 32910846, 32912828, 32913527, 32913610, 32914711
     32915747, 32915760, 32915847, 32916025, 32918041, 32918585, 32920489
     32922090, 32924796, 32925703, 32926513, 32926653, 32930360, 32930665
     32931078, 32931941, 32935045, 32935932, 32936005, 32936402, 32936424
     32936537, 32937167, 32937338, 32940440, 32940955, 32941096, 32941792
     32943694, 32945404, 32946347, 32947264, 32947268, 32952285, 32955962
     32956896, 32958616, 32961142, 32962378, 32965460, 32966389, 32967871
     32968221, 32968634, 32969863, 32970478, 32972633, 32973406, 32974802
     32976022, 32977489, 32978151, 32980826, 32982562, 32983419, 32983750
     32983871, 32984625, 32984679, 32985908, 32987004, 32987308, 32988028
     32989794, 32991289, 32991527, 32993522, 32994080, 32995206, 32995242
     32995863, 32996974, 32998659, 32999086, 33000440, 33000980, 33001615
     33004888, 33005241, 33005831, 33009224, 33009351, 33010444, 33011078
     33011198, 33013379, 33015716, 33016007, 33018951, 33020088, 33020510
     33021036, 33021642, 33022043, 33022140, 33022926, 33023671, 33025005
     33026313, 33026533, 33026796, 33027377, 33027525, 33027553, 33028013
     33028286, 33028462, 33028480, 33032299, 33032579, 33034642, 33034846
     33035201, 33035710, 33037531, 33037895, 33038120, 33038479, 33038537
     33039277, 33040335, 33042780, 33043590, 33043881, 33044062, 33045137
     33047645, 33047827, 33048074, 33049012, 33050587, 33050622, 33050626
     33051299, 33053538, 33056383, 33056579, 33059891, 33060161, 33061152
     33061339, 33061595, 33063919, 33064324, 33064565, 33065343, 33065437
     33065526, 33065979, 33068672, 33069366, 33069889, 33072392, 33075093
     33075133, 33075246, 33075452, 33076129, 33080651, 33085296, 33085361
     33088863, 33089096, 33089556, 33090110, 33090127, 33090781, 33090848
     33092087, 33096609, 33097433, 33098505, 33100270, 33100352, 33101055
     33101058, 33102477, 33105276, 33105656, 33106822, 33106897, 33107872
     33109335, 33110192, 33110580, 33110642, 33110992, 33111729, 33113848
     33114640, 33115438, 33116481, 33120828, 33120920, 33121866, 33121880
     33121934, 33123402, 33123404, 33123985, 33126216, 33127141, 33127312
     33131526, 33131742, 33132050, 33134819, 33135083, 33135374, 33136252
     33136601, 33137328, 33139230, 33140218, 33141420, 33142123, 33142479
     33142533, 33142739, 33145153, 33146001, 33147065, 33150236, 33152388
     33153797, 33156632, 33157547, 33161424, 33161535, 33161726, 33163159
     33163187, 33165183, 33165391, 33166116, 33166125, 33166242, 33166560
     33168480, 33169254, 33172549, 33172631, 33172679, 33176672, 33177660
     33178223, 33178248, 33179718, 33181349, 33181498, 33182152, 33182656
     33184467, 33185231, 33185773, 33186650, 33188597, 33189199, 33190454
     33190694, 33190761, 33191073, 33191584, 33193293, 33195897, 33196009
     33196035, 33196475, 33197565, 33199431, 33199858, 33201415, 33203951
     33205229, 33205781, 33207143, 33208644, 33210231, 33211160, 33212112
     33216590, 33216667, 33218194, 33219840, 33220282, 33223248, 33225584
     33225678, 33227044, 33230882, 33232128, 33233560, 33234302, 33235620
     33239083, 33241118, 33241692, 33242408, 33243077, 33244297, 33245879
     33245940, 33247372, 33251004, 33251111, 33252648, 33253466, 33253504
     33254019, 33261707, 33261786, 33266449, 33268162, 33271125, 33271941
     33273598, 33273638, 33278133, 33278440, 33278509, 33279489, 33281287
     33282502, 33282504, 33282605, 33282971, 33287418, 33288427, 33289442
     33289734, 33292174, 33292175, 33292429, 33292896, 33294123, 33295267
     33297275, 33298903, 33300422, 33304435, 33304775, 33304830, 33305175
     33305254, 33306852, 33307945, 33308107, 33308736, 33309324, 33312816
     33312823, 33312932, 33313554, 33314122, 33314523, 33315230, 33316711
     33316815, 33317279, 33317740, 33317752, 33317996, 33318949, 33319065
     33320455, 33322041, 33322672, 33323634, 33323903, 33324226, 33325981
     33326105, 33327118, 33329192, 33330508, 33331329, 33332612, 33332891
     33334340, 33334404, 33334957, 33335201, 33335941, 33337385, 33338247
     33338891, 33339444, 33339868, 33344767, 33345269, 33347947, 33349744
     33351136, 33351978, 33352740, 33353474, 33354011, 33355007, 33357283
     33360246, 33364012, 33367076, 33367184, 33367909, 33370332, 33372080
     33373644, 33373693, 33375194, 33376694, 33380058, 33380871, 33381652
     33381839, 33382108, 33382224, 33382529, 33382620, 33384092, 33384505
     33387767, 33388473, 33389651, 33390717, 33390917, 33390925, 33392448
     33392926, 33393503, 33397495, 33397605, 33398383, 33401519, 33402361
     33402406, 33402456, 33407135, 33408858, 33409163, 33409759, 33409841
     33410321, 33416405, 33417145, 33417828, 33417987, 33418112, 33418443
     33420096, 33420490, 33421108, 33421305, 33421440, 33422596, 33422877
     33424192, 33425127, 33426135, 33427823, 33427991, 33428316, 33428795
     33435313, 33440442, 33440899, 33441073, 33444647, 33446226, 33447015
     33447957, 33448908, 33451134, 33454288, 33454299, 33455225, 33456703
     33456848, 33457235, 33457584, 33457842, 33458732, 33460521, 33460870
     33462620, 33463044, 33464061, 33466822, 33467715, 33470092, 33470254
     33471858, 33473795, 33474916, 33479703, 33480765, 33480963, 33482590
     33485134, 33486067, 33489699, 33491676, 33492066, 33492136, 33497132
     33498037, 33499125, 33499867, 33500486, 33503732, 33504158, 33504432
     33504626, 33504902, 33505158, 33507610, 33507953, 33510171, 33513526
     33513906, 33514179, 33514440, 33516571, 33517445, 33517703, 33520658
     33522799, 33523982, 33525448, 33527630, 33527663, 33531067, 33531364
     33532517, 33532755, 33533269, 33534589, 33536809, 33537229, 33538063
     33540746, 33545633, 33545698, 33548709, 33548869, 33550827, 33553452
     33553902, 33555482, 33558058, 33558087, 33558391, 33559316, 33561671
     33561845, 33562255, 33563137, 33563167, 33566611, 33568355, 33571225
     33575100, 33580595, 33581395, 33584404, 33584585, 33584637, 33586107
     33589615, 33596056, 33596361, 33596364, 33598703, 33599734, 33601195
     33601673, 33601849, 33607613, 33613512, 33617587, 33617685, 33618962
     33621794, 33622325, 33624052, 33624356, 33630464, 33631068, 33631562
     33632754, 33633875, 33637219, 33641592, 33647716, 33647820, 33651003
     33651993, 33655399, 33656104, 33656679, 33657553, 33660093, 33660782
     33661960, 33663444, 33664959, 33664976, 33666803, 33674035, 33676296
     33677163, 33679665, 33681814, 33681832, 33684377, 33695048, 33704431
     33705050, 33708958, 33710568, 33711151, 33714000, 33718848, 33726682
     33727390, 33727406, 33727922, 33729569, 33729692, 33734040, 33736618
     33737965, 33738702, 33742827, 33743745, 33743884, 33746114, 33749984
     33750344, 33751080, 33753873, 33755161, 33757064, 33759379, 33761538
     33763570, 33764761, 33767425, 33768421, 33770883, 33770960, 33774856
     33777176, 33780001, 33785175, 33786208, 33794088, 33794281, 33796040
     33798328, 33805155, 33809062, 33809642, 33809904, 33810177, 33810360
     33813849, 33814415, 33817717, 33817746, 33822187, 33833554, 33843512
     33845824, 33848060, 33848294, 33850437, 33852823, 33853330, 33860895
     33861312, 33863150, 33863183, 33863261, 33865116, 33865495, 33866472
     33867208, 33867451, 33867491, 33870373, 33870888, 33871591, 33871761
     33875167, 33876357, 33879054, 33886862, 33890694, 33893127, 33896341
     33896412, 33897055, 33901168, 33902235, 33909838, 33915925, 33916081
     33921410, 33928944, 33932721, 33933784, 33937333, 33937705, 33945728
     33947516, 33947548, 33954999, 33957025, 33959377, 33959383, 33960647
     33967599, 33970659, 33973695, 33978449, 33987170, 33987636, 33987734
     33988974, 33990985, 33993386, 33998365, 34001406, 34003643, 34004063
     34010877, 34019087, 34023644, 34024924, 34030468, 34033430, 34034279
     34053514, 34054215, 34058951, 34060425, 34066251, 34069959, 34088194
     34094291, 34100909, 34103647, 34106567, 34110342, 34110724, 34113643
     34116531, 34118219, 34139110, 34139217, 34146833, 34149263, 34154060
     34162325, 34164828, 34170459, 34171855, 34177554, 34183461, 34191990
     34208572, 34220943, 34229442, 34233694, 34238278, 34238626, 34240339
     34244147, 34248786, 34256079, 34256867, 34257221, 34259389, 34261947
     34264633, 34266633, 34269255, 34271874, 34276007, 34279907, 34291104
     34301719, 34304388, 34309783, 34310198, 34310304, 34314448, 34319499
     34324384, 34324942, 34326245, 34330164, 34339332, 34339511, 34351706
     34363214, 34363828, 34366627, 34387852, 34398456, 34400514, 34411060
     34421053, 34422622, 34454450, 34461697, 34473578, 34491739, 34509863
     34536480, 34538832, 34539284, 34545148, 34545238, 34559195, 34559432
     34570620, 34574048, 34574650, 34580665, 34587326, 34596863, 34598617
     34599800, 34602706, 34604941, 34629086, 34635086, 34651385, 34659006
     34680126, 34681779, 34692403, 34694304, 34698475, 34700228, 34713413
     34714760, 34715072, 34720762, 34721689, 34738737, 34740434, 34743869
     34763622, 34773547, 34777399, 34782365, 34785277, 34786432, 34787623
     34798436, 34810533, 34813568, 34816792, 34820652, 34830523, 34839112
     34843376, 34847038, 34855429, 34872784, 34873945, 34884137, 34891346
     34913418, 34922278, 34929834, 34930370, 34957489, 34977125, 34993116
     34996911, 34997341, 34998034, 35001950, 35004964, 35021301, 35034357
     35066263, 35075219, 35079982, 35097019, 35116995, 35121905, 35122349
     35123829, 35154926, 35157812, 35163085, 35167216, 35171598, 35175684
     35176667, 35176824, 35177608, 35185281, 35185582, 35194313, 35209504
     35225526, 35251084, 35257415, 35278276, 35280309, 35285795, 35314366
     35325831, 35331461, 35336148, 35336918, 35354098, 35360571, 35393406
     35414664, 35428646, 35464439, 35572071, 35585502, 35598272, 35598910
     35598911, 35608957, 35610741, 35618472, 35627067, 35635081, 35637915
     35638302, 35642546, 35644675, 35646719, 35649519, 35654499, 35656066
     35665871, 35671663, 35698030, 35717077, 35737047, 35748468, 35754528
     35770294, 35786885, 35806962, 35829615, 35908011, 35914430, 35949725
     36138120

Patch  36031897     : applied on Thu May 16 15:35:41 NPT 2024
Unique Patch ID:  25498880
Patch description:  "OCW RELEASE UPDATE 21.13.0.0.0 (36031897)"
   Created on 19 Dec 2023, 04:31:21 hrs PST8PDT
   Bugs fixed:
     25642320, 27912364, 28124441, 31099090, 31114091, 31157663, 31166407
     31287159, 31292080, 31498533, 31585436, 31793410, 31897727, 31936615
     31944150, 31944156, 31978890, 31996917, 32000258, 32172412, 32200759
     32200765, 32215536, 32229662, 32254917, 32291571, 32328547, 32367954
     32368203, 32422416, 32423836, 32428383, 32447985, 32464986, 32471589
     32472118, 32485454, 32486295, 32501963, 32516907, 32524497, 32534757
     32590225, 32609238, 32621437, 32647140, 32657378, 32682516, 32682579
     32716346, 32719485, 32729378, 32739052, 32746342, 32757224, 32761541
     32776439, 32776711, 32792819, 32796019, 32813496, 32818183, 32820416
     32841520, 32843834, 32846699, 32868047, 32879465, 32881761, 32910643
     32917360, 32919502, 32926013, 32926804, 32928033, 32929045, 32931221
     32932194, 32932416, 32942182, 32951624, 32952830, 32978651, 32988011
     32988478, 32989901, 33001347, 33003656, 33004703, 33005343, 33011524
     33013375, 33016253, 33025445, 33032935, 33033831, 33050544, 33051442
     33053296, 33061319, 33066659, 33074745, 33075192, 33078519, 33083394
     33107582, 33114825, 33115756, 33116825, 33120758, 33124590, 33129533
     33132334, 33143034, 33145535, 33148406, 33150079, 33151222, 33152737
     33161292, 33168374, 33169877, 33172512, 33174232, 33179685, 33182177
     33190595, 33190831, 33196572, 33196778, 33213078, 33216086, 33232179
     33267289, 33271268, 33275105, 33276334, 33277972, 33278411, 33278486
     33279556, 33283918, 33287532, 33293146, 33294656, 33299467, 33306395
     33310824, 33324113, 33324336, 33330594, 33331048, 33350934, 33352397
     33360086, 33360476, 33360753, 33366250, 33376854, 33406013, 33412603
     33418587, 33431263, 33436825, 33461634, 33476502, 33480555, 33482291
     33487682, 33494621, 33495668, 33506235, 33509880, 33511451, 33512379
     33514553, 33514890, 33525877, 33527058, 33531173, 33536579, 33542280
     33563477, 33570824, 33576618, 33583827, 33587785, 33594197, 33601071
     33601397, 33610957, 33617820, 33626113, 33627433, 33627656, 33637683
     33637732, 33641686, 33642857, 33649468, 33673600, 33676268, 33676506
     33678098, 33697074, 33702104, 33708418, 33708467, 33708500, 33708521
     33708530, 33708536, 33709004, 33724304, 33729619, 33731331, 33732544
     33738482, 33738796, 33744602, 33746904, 33753633, 33766334, 33770058
     33773395, 33774883, 33775509, 33780467, 33783193, 33783815, 33796338
     33798463, 33799144, 33799941, 33804502, 33816142, 33819038, 33821186
     33833724, 33837467, 33837975, 33842755, 33842823, 33845961, 33848626
     33851570, 33853115, 33853788, 33862667, 33870335, 33872428, 33876838
     33877861, 33878973, 33880539, 33881331, 33883004, 33886620, 33889757
     33890925, 33901178, 33907349, 33922415, 33937521, 33938028, 33940293
     33947339, 33949242, 33956158, 33961101, 33969404, 33970432, 33975331
     33991040, 33994936, 33995943, 34007347, 34013266, 34014215, 34019425
     34040036, 34045091, 34078146, 34087210, 34091660, 34100074, 34121103
     34122773, 34126375, 34135158, 34142961, 34143916, 34149284, 34167172
     34171384, 34177775, 34181487, 34184266, 34202416, 34208046, 34209155
     34223562, 34248728, 34270679, 34283387, 34288316, 34291960, 34311758
     34339952, 34362089, 34467707, 34489041, 34504999, 34534868, 34603823
     34624116, 34707916, 34710446, 34711597, 34732777, 34756480, 34774527
     34789053, 34793976, 34877557, 34918859, 34925718, 34960001, 34975519
     35013187, 35048264, 35110038, 35219076, 35242249, 35365743, 35419491
     35570510, 35906583

Patch  36031881     : applied on Thu May 16 15:35:24 NPT 2024
Unique Patch ID:  25507991
Patch description:  "RHP RELEASE UPDATE 21.13.0.0.0 (36031881)"
   Created on 25 Dec 2023, 23:25:52 hrs PST8PDT
   Bugs fixed:
     31136914, 31334756, 31897016, 32513064, 32626289, 32644956, 32702917
     32705588, 32728027, 32739176, 32749586, 32760140, 32796411, 32841358
     32845477, 32915232, 32917826, 33022913, 33025395, 33040465, 33063960
     33072675, 33075843, 33093153, 33144621, 33170508, 33181968, 33232617
     33279794, 33297203, 33300332, 33326399, 33339916, 33352657, 33365240
     33383972, 33386394, 33415331, 33422133, 33527926, 33546946, 33558780
     33563893, 33565731, 33593847, 33606242, 33641668, 33680479, 33683482
     33790234, 33831943, 33875376, 33955785, 34008143, 34088985, 34125424
     34133257, 34211888, 34246296, 34630685, 34637614, 34856442, 34865527
     34946077, 35011514, 35147957, 35571653, 35619774, 36071492

--------------------------------------------------------------------------------

OPatch succeeded.
*/

-- Step 119 -->> On Both Nodes
[oracle@pdb1/pdb2 ~]$ cd /opt/app/oracle/product/21c/db_1/OPatch/

-- Step 120 -->> On Both Nodes
[oracle@pdb1/pdb2 OPatch]$ ./opatch lsinventory
/*
Oracle Interim Patch Installer version 12.2.0.1.42
Copyright (c) 2024, Oracle Corporation.  All rights reserved.


Oracle Home       : /opt/app/oracle/product/21c/db_1
Central Inventory : /opt/app/oraInventory
   from           : /opt/app/oracle/product/21c/db_1/oraInst.loc
OPatch version    : 12.2.0.1.42
OUI version       : 12.2.0.9.0
Log file location : /opt/app/oracle/product/21c/db_1/cfgtoollogs/opatch/opatch2024-05-17_13-29-07PM_1.log

Lsinventory Output file location : /opt/app/oracle/product/21c/db_1/cfgtoollogs/opatch/lsinv/lsinventory2024-05-17_13-29-07PM.txt
--------------------------------------------------------------------------------
Local Machine Information::
Hostname: pdb1.unidev.org.np
ARU platform id: 226
ARU platform description:: Linux x86-64

Installed Top-level Products (1):

Oracle Database 21c                                                  21.0.0.0.0
There are 1 products installed in this Oracle Home.


Interim patches (3) :

Patch  36041222     : applied on Fri May 17 12:37:50 NPT 2024
Unique Patch ID:  25517168
Patch description:  "Database Release Update : 21.13.0.0.240116 (36041222)"
   Created on 8 Jan 2024, 09:57:54 hrs UTC
   Bugs fixed:
     19884953, 19958239, 24559425, 24597536, 24916492, 25562258, 25655012
     26139817, 26352569, 26950182, 27162036, 27751518, 27897090, 27979632
     28044739, 28089112, 28294439, 28337860, 28513129, 28632799, 28882751
     28994721, 29027914, 29413205, 29524043, 29587488, 29591661, 29617414
     29811720, 29900186, 29927360, 29948154, 30082402, 30343750, 30481004
     30610097, 30706073, 30710917, 30722105, 30747820, 30771009, 30808364
     30840150, 30846263, 30876666, 30933117, 30961824, 31006259, 31006953
     31026870, 31044504, 31073424, 31079198, 31110887, 31113682, 31138371
     31192261, 31243859, 31251325, 31287296, 31356954, 31385668, 31387123
     31414524, 31429692, 31487775, 31488085, 31504723, 31526250, 31531079
     31535516, 31562484, 31588631, 31596817, 31615736, 31628975, 31649223
     31652763, 31656601, 31676324, 31720377, 31725154, 31731407, 31768866
     31773909, 31780567, 31781944, 31800059, 31800139, 31824792, 31827584
     31834214, 31834611, 31834677, 31841210, 31843716, 31843845, 31844137
     31844357, 31844557, 31872320, 31897178, 31912834, 31918462, 31923463
     31927078, 31932042, 31933842, 31933846, 31933914, 31938116, 31939767
     31951628, 31954223, 31959140, 31960603, 31969646, 31974187, 31982879
     31986827, 31987278, 31987922, 31988833, 31992242, 31992615, 31992953
     31993051, 31994298, 31996331, 31997660, 32003908, 32008408, 32008716
     32009197, 32012400, 32013253, 32015642, 32017570, 32017635, 32020701
     32041003, 32055692, 32056529, 32057565, 32069508, 32071457, 32075130
     32078078, 32081381, 32092797, 32097767, 32102542, 32102722, 32104578
     32114541, 32114746, 32115403, 32118543, 32119144, 32122804, 32132504
     32133898, 32159343, 32161381, 32166950, 32178966, 32183102, 32183756
     32184235, 32184577, 32184844, 32185296, 32190419, 32196943, 32198292
     32198368, 32198396, 32199681, 32205514, 32212062, 32219835, 32224140
     32225117, 32225742, 32233406, 32234148, 32240272, 32249371, 32254686
     32255529, 32255753, 32255762, 32258388, 32258423, 32277793, 32284608
     32285563, 32287989, 32292805, 32294031, 32297469, 32297849, 32298173
     32298782, 32300822, 32302470, 32312412, 32335257, 32338919, 32342345
     32343092, 32345050, 32346254, 32346649, 32357412, 32361175, 32361677
     32362072, 32365085, 32366303, 32368480, 32371828, 32372554, 32372725
     32373696, 32374616, 32377901, 32379001, 32380591, 32382021, 32386720
     32390629, 32393137, 32394623, 32396326, 32408640, 32417301, 32423678
     32423985, 32424465, 32425778, 32425862, 32426213, 32427158, 32427583
     32427953, 32428097, 32431049, 32431251, 32432078, 32432245, 32436460
     32436721, 32439726, 32441128, 32441671, 32442229, 32449909, 32459632
     32460145, 32462153, 32465193, 32465209, 32465495, 32468643, 32471100
     32471251, 32472485, 32478452, 32481807, 32486955, 32492382, 32498569
     32498752, 32503790, 32506166, 32506473, 32506809, 32507542, 32509814
     32514516, 32515850, 32523613, 32524841, 32526703, 32529396, 32530202
     32531647, 32533461, 32535156, 32538824, 32540706, 32540772, 32544740
     32546937, 32549277, 32550894, 32551246, 32555592, 32556165, 32556311
     32561841, 32573197, 32579075, 32580852, 32583315, 32583355, 32583692
     32584375, 32584505, 32585832, 32587305, 32587793, 32587994, 32588656
     32593877, 32594965, 32597099, 32597637, 32602194, 32602990, 32603092
     32606093, 32607991, 32608583, 32609512, 32610185, 32610271, 32618819
     32619195, 32620859, 32621140, 32621309, 32625160, 32625356, 32626756
     32626830, 32628168, 32629028, 32630060, 32634049, 32635881, 32635931
     32639432, 32639860, 32642587, 32645139, 32649737, 32649749, 32651063
     32651773, 32652605, 32653470, 32662165, 32665836, 32669149, 32672057
     32674819, 32675095, 32677000, 32682586, 32685286, 32685989, 32690400
     32692372, 32697157, 32697859, 32698508, 32700455, 32701048, 32703155
     32704013, 32705734, 32709170, 32710534, 32712791, 32712916, 32719288
     32719445, 32719456, 32720344, 32724505, 32726772, 32728984, 32730701
     32732179, 32733845, 32734021, 32734171, 32734800, 32735915, 32736370
     32737827, 32737969, 32740515, 32743290, 32747680, 32747738, 32748806
     32750940, 32753472, 32754044, 32754574, 32755517, 32760868, 32761294
     32761932, 32763050, 32763283, 32763544, 32764690, 32766397, 32766407
     32766916, 32768752, 32769880, 32770651, 32771735, 32775512, 32775526
     32776891, 32781826, 32782851, 32786308, 32789228, 32790012, 32794261
     32797486, 32800137, 32800539, 32801192, 32801303, 32801337, 32802926
     32803807, 32804609, 32806069, 32806915, 32809152, 32810125, 32818545
     32822436, 32822847, 32823545, 32823692, 32827206, 32829563, 32831451
     32831901, 32834394, 32834426, 32838028, 32838533, 32842415, 32843672
     32846876, 32848060, 32848816, 32850174, 32851615, 32852484, 32852504
     32856375, 32856640, 32857881, 32863795, 32864736, 32866089, 32868344
     32868369, 32869560, 32874225, 32874773, 32875003, 32875118, 32879447
     32880390, 32881057, 32881462, 32883252, 32883853, 32887649, 32888458
     32889096, 32891500, 32893951, 32897184, 32897679, 32898672, 32898678
     32898971, 32901237, 32903472, 32903625, 32904867, 32907741, 32908249
     32908946, 32909255, 32910846, 32912828, 32913527, 32913610, 32914711
     32915747, 32915760, 32915847, 32916025, 32918041, 32918585, 32920489
     32922090, 32924796, 32925703, 32926513, 32926653, 32930360, 32930665
     32931078, 32931941, 32935045, 32935932, 32936005, 32936402, 32936424
     32936537, 32937167, 32937338, 32940440, 32940955, 32941096, 32941792
     32943694, 32945404, 32946347, 32947264, 32947268, 32952285, 32955962
     32956896, 32958616, 32961142, 32962378, 32965460, 32966389, 32967871
     32968221, 32968634, 32969863, 32970478, 32972633, 32973406, 32974802
     32976022, 32977489, 32978151, 32980826, 32982562, 32983419, 32983750
     32983871, 32984625, 32984679, 32985908, 32987004, 32987308, 32988028
     32989794, 32991289, 32991527, 32993522, 32994080, 32995206, 32995242
     32995863, 32996974, 32998659, 32999086, 33000440, 33000980, 33001615
     33004888, 33005241, 33005831, 33009224, 33009351, 33010444, 33011078
     33011198, 33013379, 33015716, 33016007, 33018951, 33020088, 33020510
     33021036, 33021642, 33022043, 33022140, 33022926, 33023671, 33025005
     33026313, 33026533, 33026796, 33027377, 33027525, 33027553, 33028013
     33028286, 33028462, 33028480, 33032299, 33032579, 33034642, 33034846
     33035201, 33035710, 33037531, 33037895, 33038120, 33038479, 33038537
     33039277, 33040335, 33042780, 33043590, 33043881, 33044062, 33045137
     33047645, 33047827, 33048074, 33049012, 33050587, 33050622, 33050626
     33051299, 33053538, 33056383, 33056579, 33059891, 33060161, 33061152
     33061339, 33061595, 33063919, 33064324, 33064565, 33065343, 33065437
     33065526, 33065979, 33068672, 33069366, 33069889, 33072392, 33075093
     33075133, 33075246, 33075452, 33076129, 33080651, 33085296, 33085361
     33088863, 33089096, 33089556, 33090110, 33090127, 33090781, 33090848
     33092087, 33096609, 33097433, 33098505, 33100270, 33100352, 33101055
     33101058, 33102477, 33105276, 33105656, 33106822, 33106897, 33107872
     33109335, 33110192, 33110580, 33110642, 33110992, 33111729, 33113848
     33114640, 33115438, 33116481, 33120828, 33120920, 33121866, 33121880
     33121934, 33123402, 33123404, 33123985, 33126216, 33127141, 33127312
     33131526, 33131742, 33132050, 33134819, 33135083, 33135374, 33136252
     33136601, 33137328, 33139230, 33140218, 33141420, 33142123, 33142479
     33142533, 33142739, 33145153, 33146001, 33147065, 33150236, 33152388
     33153797, 33156632, 33157547, 33161424, 33161535, 33161726, 33163159
     33163187, 33165183, 33165391, 33166116, 33166125, 33166242, 33166560
     33168480, 33169254, 33172549, 33172631, 33172679, 33176672, 33177660
     33178223, 33178248, 33179718, 33181349, 33181498, 33182152, 33182656
     33184467, 33185231, 33185773, 33186650, 33188597, 33189199, 33190454
     33190694, 33190761, 33191073, 33191584, 33193293, 33195897, 33196009
     33196035, 33196475, 33197565, 33199431, 33199858, 33201415, 33203951
     33205229, 33205781, 33207143, 33208644, 33210231, 33211160, 33212112
     33216590, 33216667, 33218194, 33219840, 33220282, 33223248, 33225584
     33225678, 33227044, 33230882, 33232128, 33233560, 33234302, 33235620
     33239083, 33241118, 33241692, 33242408, 33243077, 33244297, 33245879
     33245940, 33247372, 33251004, 33251111, 33252648, 33253466, 33253504
     33254019, 33261707, 33261786, 33266449, 33268162, 33271125, 33271941
     33273598, 33273638, 33278133, 33278440, 33278509, 33279489, 33281287
     33282502, 33282504, 33282605, 33282971, 33287418, 33288427, 33289442
     33289734, 33292174, 33292175, 33292429, 33292896, 33294123, 33295267
     33297275, 33298903, 33300422, 33304435, 33304775, 33304830, 33305175
     33305254, 33306852, 33307945, 33308107, 33308736, 33309324, 33312816
     33312823, 33312932, 33313554, 33314122, 33314523, 33315230, 33316711
     33316815, 33317279, 33317740, 33317752, 33317996, 33318949, 33319065
     33320455, 33322041, 33322672, 33323634, 33323903, 33324226, 33325981
     33326105, 33327118, 33329192, 33330508, 33331329, 33332612, 33332891
     33334340, 33334404, 33334957, 33335201, 33335941, 33337385, 33338247
     33338891, 33339444, 33339868, 33344767, 33345269, 33347947, 33349744
     33351136, 33351978, 33352740, 33353474, 33354011, 33355007, 33357283
     33360246, 33364012, 33367076, 33367184, 33367909, 33370332, 33372080
     33373644, 33373693, 33375194, 33376694, 33380058, 33380871, 33381652
     33381839, 33382108, 33382224, 33382529, 33382620, 33384092, 33384505
     33387767, 33388473, 33389651, 33390717, 33390917, 33390925, 33392448
     33392926, 33393503, 33397495, 33397605, 33398383, 33401519, 33402361
     33402406, 33402456, 33407135, 33408858, 33409163, 33409759, 33409841
     33410321, 33416405, 33417145, 33417828, 33417987, 33418112, 33418443
     33420096, 33420490, 33421108, 33421305, 33421440, 33422596, 33422877
     33424192, 33425127, 33426135, 33427823, 33427991, 33428316, 33428795
     33435313, 33440442, 33440899, 33441073, 33444647, 33446226, 33447015
     33447957, 33448908, 33451134, 33454288, 33454299, 33455225, 33456703
     33456848, 33457235, 33457584, 33457842, 33458732, 33460521, 33460870
     33462620, 33463044, 33464061, 33466822, 33467715, 33470092, 33470254
     33471858, 33473795, 33474916, 33479703, 33480765, 33480963, 33482590
     33485134, 33486067, 33489699, 33491676, 33492066, 33492136, 33497132
     33498037, 33499125, 33499867, 33500486, 33503732, 33504158, 33504432
     33504626, 33504902, 33505158, 33507610, 33507953, 33510171, 33513526
     33513906, 33514179, 33514440, 33516571, 33517445, 33517703, 33520658
     33522799, 33523982, 33525448, 33527630, 33527663, 33531067, 33531364
     33532517, 33532755, 33533269, 33534589, 33536809, 33537229, 33538063
     33540746, 33545633, 33545698, 33548709, 33548869, 33550827, 33553452
     33553902, 33555482, 33558058, 33558087, 33558391, 33559316, 33561671
     33561845, 33562255, 33563137, 33563167, 33566611, 33568355, 33571225
     33575100, 33580595, 33581395, 33584404, 33584585, 33584637, 33586107
     33589615, 33596056, 33596361, 33596364, 33598703, 33599734, 33601195
     33601673, 33601849, 33607613, 33613512, 33617587, 33617685, 33618962
     33621794, 33622325, 33624052, 33624356, 33630464, 33631068, 33631562
     33632754, 33633875, 33637219, 33641592, 33647716, 33647820, 33651003
     33651993, 33655399, 33656104, 33656679, 33657553, 33660093, 33660782
     33661960, 33663444, 33664959, 33664976, 33666803, 33674035, 33676296
     33677163, 33679665, 33681814, 33681832, 33684377, 33695048, 33704431
     33705050, 33708958, 33710568, 33711151, 33714000, 33718848, 33726682
     33727390, 33727406, 33727922, 33729569, 33729692, 33734040, 33736618
     33737965, 33738702, 33742827, 33743745, 33743884, 33746114, 33749984
     33750344, 33751080, 33753873, 33755161, 33757064, 33759379, 33761538
     33763570, 33764761, 33767425, 33768421, 33770883, 33770960, 33774856
     33777176, 33780001, 33785175, 33786208, 33794088, 33794281, 33796040
     33798328, 33805155, 33809062, 33809642, 33809904, 33810177, 33810360
     33813849, 33814415, 33817717, 33817746, 33822187, 33833554, 33843512
     33845824, 33848060, 33848294, 33850437, 33852823, 33853330, 33860895
     33861312, 33863150, 33863183, 33863261, 33865116, 33865495, 33866472
     33867208, 33867451, 33867491, 33870373, 33870888, 33871591, 33871761
     33875167, 33876357, 33879054, 33886862, 33890694, 33893127, 33896341
     33896412, 33897055, 33901168, 33902235, 33909838, 33915925, 33916081
     33921410, 33928944, 33932721, 33933784, 33937333, 33937705, 33945728
     33947516, 33947548, 33954999, 33957025, 33959377, 33959383, 33960647
     33967599, 33970659, 33973695, 33978449, 33987170, 33987636, 33987734
     33988974, 33990985, 33993386, 33998365, 34001406, 34003643, 34004063
     34010877, 34019087, 34023644, 34024924, 34030468, 34033430, 34034279
     34053514, 34054215, 34058951, 34060425, 34066251, 34069959, 34088194
     34094291, 34100909, 34103647, 34106567, 34110342, 34110724, 34113643
     34116531, 34118219, 34139110, 34139217, 34146833, 34149263, 34154060
     34162325, 34164828, 34170459, 34171855, 34177554, 34183461, 34191990
     34208572, 34220943, 34229442, 34233694, 34238278, 34238626, 34240339
     34244147, 34248786, 34256079, 34256867, 34257221, 34259389, 34261947
     34264633, 34266633, 34269255, 34271874, 34276007, 34279907, 34291104
     34301719, 34304388, 34309783, 34310198, 34310304, 34314448, 34319499
     34324384, 34324942, 34326245, 34330164, 34339332, 34339511, 34351706
     34363214, 34363828, 34366627, 34387852, 34398456, 34400514, 34411060
     34421053, 34422622, 34454450, 34461697, 34473578, 34491739, 34509863
     34536480, 34538832, 34539284, 34545148, 34545238, 34559195, 34559432
     34570620, 34574048, 34574650, 34580665, 34587326, 34596863, 34598617
     34599800, 34602706, 34604941, 34629086, 34635086, 34651385, 34659006
     34680126, 34681779, 34692403, 34694304, 34698475, 34700228, 34713413
     34714760, 34715072, 34720762, 34721689, 34738737, 34740434, 34743869
     34763622, 34773547, 34777399, 34782365, 34785277, 34786432, 34787623
     34798436, 34810533, 34813568, 34816792, 34820652, 34830523, 34839112
     34843376, 34847038, 34855429, 34872784, 34873945, 34884137, 34891346
     34913418, 34922278, 34929834, 34930370, 34957489, 34977125, 34993116
     34996911, 34997341, 34998034, 35001950, 35004964, 35021301, 35034357
     35066263, 35075219, 35079982, 35097019, 35116995, 35121905, 35122349
     35123829, 35154926, 35157812, 35163085, 35167216, 35171598, 35175684
     35176667, 35176824, 35177608, 35185281, 35185582, 35194313, 35209504
     35225526, 35251084, 35257415, 35278276, 35280309, 35285795, 35314366
     35325831, 35331461, 35336148, 35336918, 35354098, 35360571, 35393406
     35414664, 35428646, 35464439, 35572071, 35585502, 35598272, 35598910
     35598911, 35608957, 35610741, 35618472, 35627067, 35635081, 35637915
     35638302, 35642546, 35644675, 35646719, 35649519, 35654499, 35656066
     35665871, 35671663, 35698030, 35717077, 35737047, 35748468, 35754528
     35770294, 35786885, 35806962, 35829615, 35908011, 35914430, 35949725
     36138120

Patch  36031897     : applied on Fri May 17 12:33:51 NPT 2024
Unique Patch ID:  25498880
Patch description:  "OCW RELEASE UPDATE 21.13.0.0.0 (36031897)"
   Created on 19 Dec 2023, 04:31:21 hrs PST8PDT
   Bugs fixed:
     25642320, 27912364, 28124441, 31099090, 31114091, 31157663, 31166407
     31287159, 31292080, 31498533, 31585436, 31793410, 31897727, 31936615
     31944150, 31944156, 31978890, 31996917, 32000258, 32172412, 32200759
     32200765, 32215536, 32229662, 32254917, 32291571, 32328547, 32367954
     32368203, 32422416, 32423836, 32428383, 32447985, 32464986, 32471589
     32472118, 32485454, 32486295, 32501963, 32516907, 32524497, 32534757
     32590225, 32609238, 32621437, 32647140, 32657378, 32682516, 32682579
     32716346, 32719485, 32729378, 32739052, 32746342, 32757224, 32761541
     32776439, 32776711, 32792819, 32796019, 32813496, 32818183, 32820416
     32841520, 32843834, 32846699, 32868047, 32879465, 32881761, 32910643
     32917360, 32919502, 32926013, 32926804, 32928033, 32929045, 32931221
     32932194, 32932416, 32942182, 32951624, 32952830, 32978651, 32988011
     32988478, 32989901, 33001347, 33003656, 33004703, 33005343, 33011524
     33013375, 33016253, 33025445, 33032935, 33033831, 33050544, 33051442
     33053296, 33061319, 33066659, 33074745, 33075192, 33078519, 33083394
     33107582, 33114825, 33115756, 33116825, 33120758, 33124590, 33129533
     33132334, 33143034, 33145535, 33148406, 33150079, 33151222, 33152737
     33161292, 33168374, 33169877, 33172512, 33174232, 33179685, 33182177
     33190595, 33190831, 33196572, 33196778, 33213078, 33216086, 33232179
     33267289, 33271268, 33275105, 33276334, 33277972, 33278411, 33278486
     33279556, 33283918, 33287532, 33293146, 33294656, 33299467, 33306395
     33310824, 33324113, 33324336, 33330594, 33331048, 33350934, 33352397
     33360086, 33360476, 33360753, 33366250, 33376854, 33406013, 33412603
     33418587, 33431263, 33436825, 33461634, 33476502, 33480555, 33482291
     33487682, 33494621, 33495668, 33506235, 33509880, 33511451, 33512379
     33514553, 33514890, 33525877, 33527058, 33531173, 33536579, 33542280
     33563477, 33570824, 33576618, 33583827, 33587785, 33594197, 33601071
     33601397, 33610957, 33617820, 33626113, 33627433, 33627656, 33637683
     33637732, 33641686, 33642857, 33649468, 33673600, 33676268, 33676506
     33678098, 33697074, 33702104, 33708418, 33708467, 33708500, 33708521
     33708530, 33708536, 33709004, 33724304, 33729619, 33731331, 33732544
     33738482, 33738796, 33744602, 33746904, 33753633, 33766334, 33770058
     33773395, 33774883, 33775509, 33780467, 33783193, 33783815, 33796338
     33798463, 33799144, 33799941, 33804502, 33816142, 33819038, 33821186
     33833724, 33837467, 33837975, 33842755, 33842823, 33845961, 33848626
     33851570, 33853115, 33853788, 33862667, 33870335, 33872428, 33876838
     33877861, 33878973, 33880539, 33881331, 33883004, 33886620, 33889757
     33890925, 33901178, 33907349, 33922415, 33937521, 33938028, 33940293
     33947339, 33949242, 33956158, 33961101, 33969404, 33970432, 33975331
     33991040, 33994936, 33995943, 34007347, 34013266, 34014215, 34019425
     34040036, 34045091, 34078146, 34087210, 34091660, 34100074, 34121103
     34122773, 34126375, 34135158, 34142961, 34143916, 34149284, 34167172
     34171384, 34177775, 34181487, 34184266, 34202416, 34208046, 34209155
     34223562, 34248728, 34270679, 34283387, 34288316, 34291960, 34311758
     34339952, 34362089, 34467707, 34489041, 34504999, 34534868, 34603823
     34624116, 34707916, 34710446, 34711597, 34732777, 34756480, 34774527
     34789053, 34793976, 34877557, 34918859, 34925718, 34960001, 34975519
     35013187, 35048264, 35110038, 35219076, 35242249, 35365743, 35419491
     35570510, 35906583

Patch  36031881     : applied on Fri May 17 12:33:37 NPT 2024
Unique Patch ID:  25507991
Patch description:  "RHP RELEASE UPDATE 21.13.0.0.0 (36031881)"
   Created on 25 Dec 2023, 23:25:52 hrs PST8PDT
   Bugs fixed:
     31136914, 31334756, 31897016, 32513064, 32626289, 32644956, 32702917
     32705588, 32728027, 32739176, 32749586, 32760140, 32796411, 32841358
     32845477, 32915232, 32917826, 33022913, 33025395, 33040465, 33063960
     33072675, 33075843, 33093153, 33144621, 33170508, 33181968, 33232617
     33279794, 33297203, 33300332, 33326399, 33339916, 33352657, 33365240
     33383972, 33386394, 33415331, 33422133, 33527926, 33546946, 33558780
     33563893, 33565731, 33593847, 33606242, 33641668, 33680479, 33683482
     33790234, 33831943, 33875376, 33955785, 34008143, 34088985, 34125424
     34133257, 34211888, 34246296, 34630685, 34637614, 34856442, 34865527
     34946077, 35011514, 35147957, 35571653, 35619774, 36071492

--------------------------------------------------------------------------------

OPatch succeeded.
*/

-- Step 121 -->> On Both Nodes
-- To Create a Oracle Database
[root@pdb1/pdb2 ~]# mkdir -p /opt/app/oracle/admin/pdbdb/adump
[root@pdb1/pdb2 ~]# cd /opt/app/oracle/admin/
[root@pdb1/pdb2 ~]# chown -R oracle:oinstall pdbdb/
[root@pdb1/pdb2 ~]# chmod -R 775 pdbdb/

-- Step 122 -->> On Node 1
-- To prepare the responce file
[root@pdb1 ~]# su - oracle

-- Step 123 -->> On Node 1
[oracle@pdb1 db_1]$ cd /opt/app/oracle/product/21c/db_1/assistants/dbca
[oracle@pdb1 dbca]$ dbca -silent -createDatabase \
-templateName General_Purpose.dbc             \
-gdbname pdbdb -responseFile NO_VALUE         \
-characterSet AL32UTF8                        \
-sysPassword Sys605014                        \
-systemPassword Sys605014                     \
-createAsContainerDatabase true               \
-numberOfPDBs 1                               \
-pdbName invpdb                               \
-pdbAdminPassword Sys605014                   \
-databaseType MULTIPURPOSE                    \
-automaticMemoryManagement false              \
-totalMemory 12288                            \
-redoLogFileSize 50                           \
-emConfiguration NONE                         \
-ignorePreReqs                                \
-nodelist pdb1,pdb2                   \
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
 /opt/app/oracle/cfgtoollogs/dbca/pdbdb.
Database Information:
Global Database Name:pdbdb
System Identifier(SID) Prefix:pdbdb
Look at the log file "/opt/app/oracle/cfgtoollogs/dbca/pdbdb/pdbdb.log" for further details.
*/  

-- Step 123.1 -->> On Node 1
[oracle@pdb1 ~]$  tail -f /opt/app/oracle/cfgtoollogs/dbca/pdbdb/pdbdb.log
/*
[ 2024-05-17 13:33:54.126 NPT ] Prepare for db operation
DBCA_PROGRESS : 7%
[ 2024-05-17 13:34:22.185 NPT ] Copying database files
DBCA_PROGRESS : 27%
[ 2024-05-17 13:36:05.470 NPT ] Creating and starting Oracle instance
DBCA_PROGRESS : 28%
DBCA_PROGRESS : 31%
DBCA_PROGRESS : 35%
DBCA_PROGRESS : 37%
DBCA_PROGRESS : 40%
[ 2024-05-17 13:47:41.607 NPT ] Creating cluster database views
DBCA_PROGRESS : 41%
DBCA_PROGRESS : 53%
[ 2024-05-17 13:49:39.779 NPT ] Completing Database Creation
DBCA_PROGRESS : 57%
DBCA_PROGRESS : 59%
DBCA_PROGRESS : 60%
[ 2024-05-17 13:55:44.630 NPT ] Creating Pluggable Databases
DBCA_PROGRESS : 64%
DBCA_PROGRESS : 80%
[ 2024-05-17 13:56:24.997 NPT ] Executing Post Configuration Actions
DBCA_PROGRESS : 100%
[ 2024-05-17 13:56:25.000 NPT ] Database creation complete. For details check the logfiles at:
 /opt/app/oracle/cfgtoollogs/dbca/pdbdb.
Database Information:
Global Database Name:pdbdb
System Identifier(SID) Prefix:pdbdb
*/

-- Step 124 -->> On Node 1  
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 21.0.0.0.0 - Production on Fri May 17 14:03:09 2024
Version 21.13.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.


Connected to:
Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production
Version 21.13.0.0.0

SQL> show con_name

CON_NAME
------------------------------
CDB$ROOT

SQL> alter pluggable database invpdb open;
SQL> alter pluggable database all open;
SQL> alter pluggable database invpdb save state;

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 INVPDB                         READ WRITE NO

SQL> SELECT status ,instance_name FROM gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
OPEN         pdbdb1
OPEN         pdbdb2

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE

SQL> exit
Disconnected from Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production
Version 21.13.0.0.0
*/

-- Step 125 -->> On Both Nodes 
[oracle@pdb1/pdb2 ~]$ srvctl config database -d pdbdb
/*
Database unique name: pdbdb
Database name: pdbdb
Oracle home: /opt/app/oracle/product/21c/db_1
Oracle user: oracle
Spfile: +DATA/PDBDB/PARAMETERFILE/spfile.272.1169214845
Password file: +DATA/PDBDB/PASSWORD/pwdpdbdb.256.1169213665
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

-- Step 126 -->> On Both Nodes 
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open,HOME=/opt/app/oracle/product/21c/db_1.
Instance pdbdb2 is running on node pdb2. Instance status: Open,HOME=/opt/app/oracle/product/21c/db_1.
*/

-- Step 127 -->> On Both Nodes 
[oracle@pdb1/pdb2 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): pdb2,pdb1
*/

-- Step 128 -->> On Node 1 
[oracle@pdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 21.0.0.0.0 - Production on 17-MAY-2024 14:07:27

Copyright (c) 1991, 2021, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 21.0.0.0.0 - Production
Start Date                17-MAY-2024 13:23:14
Uptime                    0 days 0 hr. 44 min. 12 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/21c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.21)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.23)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "18a2e36e57c85e79e063150610ac4dd9" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "c8209f27c6b16005e053362ee80ae60e" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "invpdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 129 -->> On Node 2 
[oracle@pdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 21.0.0.0.0 - Production on 17-MAY-2024 14:07:45

Copyright (c) 1991, 2021, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 21.0.0.0.0 - Production
Start Date                17-MAY-2024 13:23:36
Uptime                    0 days 0 hr. 44 min. 9 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/21c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.22)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.24)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "18a2e36e57c85e79e063150610ac4dd9" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "c8209f27c6b16005e053362ee80ae60e" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "invpdb" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- To Fix the ADRCI log if occured in remote nodes
-- Step Fix.1 -->> On Node 2
[oracle@pdb2 ~]$ adrci
/*
ADRCI: Release 21.0.0.0.0 - Production on Fri May 17 14:08:11 2024

Copyright (c) 1982, 2021, Oracle and/or its affiliates.  All rights reserved.

No ADR base is set
adrci> exit
*/

-- Step Fix.2 -->> On Both Nodes
[oracle@pdb1/pdb2 ~]$ vi .bash_profile
/*
export ADR_BASE=/opt/app/oracle
*/

-- Step Fix.3 -->> On Both Nodes
[oracle@pdb1/pdb2 ~]$ . .bash_profile

-- Step Fix.4 -->> On Node 2
[oracle@pdb2 ~]$ adrci
/*

ADRCI: Release 19.0.0.0.0 - Production on Mon May 13 17:19:12 2024

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

ADR base = "/opt/app/oracle"
adrci> exit
*/

-- Step 130 -->> On Node 1
[root@pdb1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/21c/grid:N
pdbdb:/opt/app/oracle/product/21c/db_1:N
pdbdb1:/opt/app/oracle/product/21c/db_1:N
*/

-- Step 131 -->> On Node 2
[root@pdb2 ~]# vi /etc/oratab 
/*
+ASM2:/opt/app/21c/grid:N
pdbdb:/opt/app/oracle/product/21c/db_1:N
pdbdb2:/opt/app/oracle/product/21c/db_1:N
*/

-- Step 132 -->> On Node 1
[oracle@pdb1 ~]$ vi /opt/app/oracle/product/21c/db_1/network/admin/tnsnames.ora
/*
# tnsnames.ora Network Configuration File: /opt/app/oracle/product/21c/db_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.

PDBDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdb-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = pdbdb)
    )
  )

PDBDB1 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.6.21)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = pdbdb)
    )
  )

INVPDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdb-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invpdb)
    )
  )
*/

-- Step 133 -->> On Node 1
[grid@pdb1 ~]$ vi /opt/app/21c/grid/network/admin/tnsnames.ora
/*
# tnsnames.ora Network Configuration File: /opt/app/21c/grid/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.

PDBDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdb-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = pdbdb)
    )
  )

PDBDB1 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.6.21)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = pdbdb)
    )
  )

INVPDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdb-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invpdb)
    )
  )
*/

-- Step 134 -->> On Node 2
[oracle@pdb2 ~]$ vi /opt/app/oracle/product/21c/db_1/network/admin/tnsnames.ora
/*
# tnsnames.ora Network Configuration File: /opt/app/oracle/product/21c/db_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.

PDBDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdb-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = pdbdb)
    )
  )

PDBDB2 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.6.22)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = pdbdb)
    )
  )

INVPDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdb-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invpdb)
    )
  )
*/

-- Step 135 -->> On Node 2
[grid@pdb2 ~]$ cat /opt/app/21c/grid/network/admin/tnsnames.ora
/*
# tnsnames.ora Network Configuration File: /opt/app/21c/grid/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.

PDBDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdb-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = pdbdb)
    )
  )

PDBDB2 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.6.22)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = pdbdb)
    )
  )

INVPDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdb-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invpdb)
    )
  )
*/

-- Step 136 -->> On Both Node (If Required)
-- To run the oracle tools (Till 11gR2 - If Required)
-- To Connect lower version tools
-- 1. Copy the contains of /etc/hosts
-- 2. Past on host file of relevant PC C:\Windows\System32\drivers\etc\hosts
[grid@pdb1/pdb2 ~]$ vi /opt/app/21c/grid/network/admin/sqlnet.ora
/*
# sqlnet.ora.pdb1/PDB-DC-N2 Network Configuration File: /opt/app/21c/grid/network/admin/sqlnet.ora
# Generated by Oracle configuration tools.

NAMES.DIRECTORY_PATH= (TNSNAMES, EZCONNECT)

SQLNET.ALLOWED_LOGON_VERSION_SERVER=8
SQLNET.ALLOWED_LOGON_VERSION_CLIENT=8
*/

-- Step 136.1 -->> On Both Node
[oracle@pdb1/pdb2 ~]$ vi /opt/app/oracle/product/21c/db_1/network/admin/sqlnet.ora
/*
# sqlnet.ora.pdb1 Network Configuration File: /opt/app/oracle/product/21c/db_1/network/admin/sqlnet.ora
# Generated by Oracle configuration tools.

NAMES.DIRECTORY_PATH= (TNSNAMES, EZCONNECT)

SQLNET.ALLOWED_LOGON_VERSION_SERVER=8
SQLNET.ALLOWED_LOGON_VERSION_CLIENT=8
*/

-- Step 136.2 -->> On Both Node
[oracle@pdb1/pdb2 ~]$ vi .bash_profile
/*
export TNS_ADMIN=/opt/app/oracle/product/21c/db_1/network/admin/
*/

-- Step 136.3 -->> On Both Node
[oracle@pdb1/pdb2 ~]$ . .bash_profile


-- Step 137 -->> On Both Node
[oracle@pdb1/pdb2 ~]$ srvctl stop listener
[oracle@pdb1/pdb2 ~]$ srvctl start listener
[oracle@pdb1/pdb2 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): pdb2,pdb1
*/

-- Step 138 -->> On Node 1
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 21.0.0.0.0 - Production on Fri May 17 15:34:27 2024
Version 21.13.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.


Connected to:
Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production
Version 21.13.0.0.0

SQL> ALTER USER sys IDENTIFIED BY "P#ssw0rd";

User altered.

SQL> ALTER USER sys IDENTIFIED BY "P#ssw0rd" container=all;

User altered.

SQL> show con_name

CON_NAME
------------------------------
CDB$ROOT
SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 INVPDB                         READ WRITE NO
SQL> exit
Disconnected from Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production
Version 21.13.0.0.0
*/

-- Step 138.1 -->> On Node 1
[oracle@pdb1 ~]$ sqlplus sys/P#ssw0rd@pdbdb as sysdba
/*
SQL*Plus: Release 21.0.0.0.0 - Production on Sun May 19 11:57:50 2024
Version 21.13.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.


Connected to:
Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production
Version 21.13.0.0.0

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
Disconnected from Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production
Version 21.13.0.0.0
*/

-- Step 139 -->> On Node 1
[root@pdb1 ~]# cd /opt/app/21c/grid/bin
[root@pdb1 ~]# ./crsctl stop cluster -all
[root@pdb1 ~]# ./crsctl start cluster -all

-- Step 140 -->> On Node 1
[root@pdb1 ~]# cd /opt/app/21c/grid/bin
[root@pdb1 ~]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.crf
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.crsd
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.cssd
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.ctssd
      1        ONLINE  ONLINE       pdb1                     OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.evmd
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.gipcd
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.gpnpd
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.mdnsd
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.storage
      1        ONLINE  ONLINE       pdb1                     STABLE
--------------------------------------------------------------------------------
*/

-- Step 141 -->> On Node 2
[root@pdb2 ~]# cd /opt/app/21c/grid/bin
[root@pdb2 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.crf
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.crsd
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.cssd
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.ctssd
      1        ONLINE  ONLINE       pdb2                     OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.evmd
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.gipcd
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.gpnpd
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.mdnsd
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.storage
      1        ONLINE  ONLINE       pdb2                     STABLE
--------------------------------------------------------------------------------
*/

-- Step 142 -->> On Both Nodes
[root@pdb1/pdb2 ~]# cd /opt/app/21c/grid/bin
[root@pdb1/pdb2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       pdb1                     STABLE
               ONLINE  ONLINE       pdb2                     STABLE
ora.chad
               ONLINE  ONLINE       pdb1                     STABLE
               ONLINE  ONLINE       pdb2                     STABLE
ora.net1.network
               ONLINE  ONLINE       pdb1                     STABLE
               ONLINE  ONLINE       pdb2                     STABLE
ora.ons
               ONLINE  ONLINE       pdb1                     STABLE
               ONLINE  ONLINE       pdb2                     STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ARC.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.DATA.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     Started,STABLE
      2        ONLINE  ONLINE       pdb2                     Started,STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.cdp1.cdp
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.cdp2.cdp
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.cvu
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.pdb1.vip
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.pdb2.vip
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.pdbdb.db
      1        ONLINE  ONLINE       pdb1                     Open,HOME=/opt/app/oracle/product/21c/db_1,STABLE
      2        ONLINE  ONLINE       pdb2                     Open,HOME=/opt/app/oracle/product/21c/db_1,STABLE
ora.pdbdb.invpdb.pdb
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.qosmserver
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       pdb2                     STABLE
--------------------------------------------------------------------------------
*/

-- Step 143 -->> On Both Nodes
[root@pdb1/pdb2 ~]# cd /opt/app/21c/grid/bin
[root@pdb1/pdb2 bin]# ./crsctl check cluster -all
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
*/

-- Step 144 -->> On Both Nodes
-- ASM Verification
[root@pdb1/pdb2 ~]# su - grid
[grid@pdb1/pdb2 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  1048576    409599   409256                0          409256              0             N  ARC/
MOUNTED  EXTERN  N         512             512   4096  1048576    204799   199224                0          199224              0             N  DATA/
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20112                0           20112              0             Y  OCR/
ASMCMD [+] > exit
*/

-- Step 145 -->> On Node 1
[grid@pdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 21.0.0.0.0 - Production on 19-MAY-2024 12:04:16

Copyright (c) 1991, 2021, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 21.0.0.0.0 - Production
Start Date                19-MAY-2024 12:00:53
Uptime                    0 days 0 hr. 3 min. 22 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/21c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.21)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.23)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "18a2e36e57c85e79e063150610ac4dd9" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "c8209f27c6b16005e053362ee80ae60e" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "invpdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 146 -->> On Node 2
[grid@pdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 21.0.0.0.0 - Production on 19-MAY-2024 12:04:52

Copyright (c) 1991, 2021, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 21.0.0.0.0 - Production
Start Date                19-MAY-2024 12:01:15
Uptime                    0 days 0 hr. 3 min. 37 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/21c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.22)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.24)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "18a2e36e57c85e79e063150610ac4dd9" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "c8209f27c6b16005e053362ee80ae60e" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "invpdb" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 147 -->> On Node 1
[grid@pdb1 ~]$ ps -ef | grep SCAN
/*
grid       38564       1  0 12:00 ?        00:00:00 /opt/app/21c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid       53397   51139  0 12:05 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 147.1 -->> On Node 1
[grid@pdb1 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 21.0.0.0.0 - Production on 19-MAY-2024 12:05:43

Copyright (c) 1991, 2021, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 21.0.0.0.0 - Production
Start Date                19-MAY-2024 12:00:55
Uptime                    0 days 0 hr. 4 min. 48 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/21c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.25)(PORT=1521)))
Services Summary...
Service "18a2e36e57c85e79e063150610ac4dd9" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "c8209f27c6b16005e053362ee80ae60e" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "invpdb" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 148 -->> On Node 2
[grid@pdb2 ~]$ ps -ef | grep SCAN
/*
grid       31837       1  0 12:01 ?        00:00:00 /opt/app/21c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid       51621   51446  0 12:05 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 148.1 -->> On Node 2
[grid@pdb2 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 21.0.0.0.0 - Production on 19-MAY-2024 12:06:15

Copyright (c) 1991, 2021, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 21.0.0.0.0 - Production
Start Date                19-MAY-2024 12:01:35
Uptime                    0 days 0 hr. 4 min. 39 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/21c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.26)(PORT=1521)))
Services Summary...
Service "18a2e36e57c85e79e063150610ac4dd9" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "c8209f27c6b16005e053362ee80ae60e" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "invpdb" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 149 -->> On Both Nodes
[grid@pdb1/pdb2 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 21.0.0.0.0 - Production on Sun May 19 12:06:35 2024
Version 21.13.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.


Connected to:
Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production
Version 21.13.0.0.0

SQL> set lines 200;
SQL> col BANNER_FULL format a80;
SQL> col BANNER_LEGACY format a80;
SQL> SELECT inst_id,banner_full,banner_legacy,con_id FROM gv$version;

   INST_ID BANNER_FULL                                                                      BANNER_LEGACY                                                                        CON_ID
---------- -------------------------------------------------------------------------------- -------------------------------------------------------------------------------- ----------
         1 Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production           Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production                    0
           Version 21.13.0.0.0

         2 Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production           Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production                    0
           Version 21.13.0.0.0

SQL> exit
Disconnected from Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production
Version 21.13.0.0.0
*/

-- Step 150 -->> On Both Nodes
-- DB Service Verification
[root@pdb1/pdb2 ~]# su - oracle
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open,HOME=/opt/app/oracle/product/21c/db_1.
Instance pdbdb2 is running on node pdb2. Instance status: Open,HOME=/opt/app/oracle/product/21c/db_1.
*/

-- Step 151 -->> On Both Nodes
-- Listener Service Verification
[oracle@pdb1/pdb2 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): pdb2,pdb1
*/

-- Step 152 -->> On Both Nodes
[oracle@pdb1/pdb2 ~]$ rman target sys/P#ssw0rd@pdbdb
--OR--
[oracle@pdb1/pdb2 ~]$ rman target /
/*
Recovery Manager: Release 21.0.0.0.0 - Production on Sun May 19 12:08:40 2024
Version 21.13.0.0.0

Copyright (c) 1982, 2021, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB (DBID=3227321046)

RMAN> show all;

using target database control file instead of recovery catalog
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
--Node 1
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/dbs/snapcf_pdbdb2.f'; # default
--Node 2
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/dbs/snapcf_pdbdb2.f'; # default

RMAN> exit

Recovery Manager complete.
*/

-- Step 153 -->> On Both Nodes
[oracle@pdb1 ~]$ rman target sys/P#ssw0rd@invpdb
/*
Recovery Manager: Release 21.0.0.0.0 - Production on Sun May 19 12:09:59 2024
Version 21.13.0.0.0

Copyright (c) 1982, 2021, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB:INVPDB (DBID=2464239429)

RMAN> show all;

using target database control file instead of recovery catalog
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
--Node 1
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/dbs/snapcf_pdbdb1.f'; # default
--Node 2
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/dbs/snapcf_pdbdb2.f'; # default

RMAN> exit

Recovery Manager complete.
*/
-- Step 154 -->> On Both Nodes
-- To connnect CDB$ROOT using TNS
[oracle@pdb1/pdb2 ~]$ sqlplus sys/P#ssw0rd@pdbdb as sysdba

-- Step 155 -->> On Node 1
[oracle@pdb1 ~]$ sqlplus sys/P#ssw0rd@pdbdb1 as sysdba

-- Step 156 -->> On Node 2
[oracle@pdb2 ~]$ sqlplus sys/P#ssw0rd@pdbdb2 as sysdba

-- Step 157 -->> On Both Nodes
-- To connnect PDB using TNS
[oracle@pdb1/pdb2 ~]$ sqlplus sys/P#ssw0rd@invpdb as sysdba