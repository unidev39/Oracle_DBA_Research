----------------------------------------------------------------
-------------Two Node rac Setup on VM Workstation---------------
----------------------------------------------------------------
-- Step 0 -->> 2 Node rac on VM -->> On both Node
--For OS Oracle Linux 6.10 => boot OracleLinux-R6-U10-Server-x86_64-dvd.iso 

-- Step 0.0 -->>  2 Node rac on VM -->> On both Node
[root@pdb1/pdb2 ~]# df -Th
/*
Filesystem     Type     Size  Used Avail Use% Mounted on
/dev/sda2      ext4      69G  1.1G   65G   2% /
tmpfs          tmpfs    9.7G   76K  9.7G   1% /dev/shm
/dev/sda1      ext4     2.0G  157M  1.7G   9% /boot
/dev/sda6      ext4      15G   38M   14G   1% /home
/dev/sda3      ext4      57G   52M   54G   1% /opt
/dev/sda7      ext4      15G   38M   14G   1% /tmp
/dev/sda8      ext4      15G  5.9G  8.0G  43% /usr
/dev/sda9      ext4      15G  2.3G   12G  17% /var
/dev/sr0       iso9660  3.8G  3.8G     0 100% /media/OL6.10 x86_64 Disc 1 20180625
*/

-- Step 1 -->> On both Node
[root@pdb1/pdb2 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.168.16.21   pdb1.unidev.org.np        pdb1
192.168.16.22   pdb2.unidev.org.np        pdb2

# Private
10.10.10.21     pdb1-priv.unidev.org.np   pdb1-priv
10.10.10.22     pdb2-priv.unidev.org.np   pdb2-priv

# Virtual
192.168.16.23   pdb1-vip.unidev.org.np    pdb1-vip
192.168.16.24   pdb2-vip.unidev.org.np    pdb2-vip

# SCAN
192.168.16.25   pdb-scan.unidev.org.np    pdb-scan
192.168.16.26   pdb-scan.unidev.org.np    pdb-scan
192.168.16.27   pdb-scan.unidev.org.np    pdb-scan
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
[root@pdb1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth0  
/*
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.16.21
NETMASK=255.255.255.0
GATEWAY=192.168.16.1
DNS1=192.168.16.11
DNS2=192.168.16.12
*/

-- Step 6 -->> On Node 1
[root@pdb1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth1
/*
DEVICE=eth1
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=10.10.10.21
NETMASK=255.255.255.0
*/

-- Step 7 -->> On Node 2
[root@pdb2 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth0
/*
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.16.22
NETMASK=255.255.255.0
GATEWAY=192.168.16.1
DNS1=192.168.16.11
DNS2=192.168.16.12
*/

-- Step 8 -->> On Node 2
[root@pdb2 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth1
/*
DEVICE=eth1
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=10.10.10.22
NETMASK=255.255.255.0
*/

-- Step 9 -->> On Both Node
[root@pdb1/pdb2 ~]# service network restart
[root@pdb1/pdb2 ~]# service NetworkManager stop
[root@pdb1/pdb2 ~]# service network restart

-- Step 10 -->> On Both Node
[root@pdb1/pdb2 ~]# yum repolist
/*
Loaded plugins: refresh-packagekit, security, ulninfo
repo id                                               repo name                                                                           status
public_ol6_UEKR4                                      Latest Unbreakable Enterprise Kernel Release 4 for Oracle Linux 6Server (x86_64)       191
public_ol6_latest                                     Oracle Linux 6Server Latest (x86_64)                                                12,932
repolist: 13,123
*/

-- Step 10.1 -->> On Both Node
[root@pdb1/pdb2 ~]# uname -a
/*
Linux pdb1.cibneapl.org.np 4.1.12-124.48.6.el6uek.x86_64 #2 SMP Tue Mar 16 15:39:03 PDT 2021 x86_64 x86_64 x86_64 GNU/Linux
*/

-- Step 10.2 -->> On Both Node
[root@pdb1/pdb2 ~]# uname -r
/*
4.1.12-124.48.6.el6uek.x86_64
*/

-- Step 10.3 -->> On Both Node
[root@pdb1/pdb2 ~]# grubby --info=ALL | grep ^kernel
/*
kernel=/vmlinuz-4.1.12-124.48.6.el6uek.x86_64
kernel=/vmlinuz-2.6.32-754.35.1.el6.x86_64
kernel=/vmlinuz-4.1.12-124.16.4.el6uek.x86_64
kernel=/vmlinuz-2.6.32-754.el6.x86_64
*/

-- Step 10.3.1 -->> On Both Node
[root@pdb1/pdb2 ~]# grubby --default-kernel
/*
/boot/vmlinuz-4.1.12-124.48.6.el6uek.x86_64
*/

-- Step 10.4 -->> On Both Node
[root@pdb1/pdb2 ~]# chkconfig --list iptables
/*
iptables  0:off    1:off    2:on    3:on    4:on    5:on    6:off
*/

-- Step 11 -->> On Both Node
[root@pdb1/pdb2 ~]# service iptables stop
/*
iptables: Setting chains to policy ACCEPT: nat mangle filte[  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
*/

-- Step 11.1 -->> On Both Node
[root@pdb1/pdb2 ~]# chkconfig iptables off
[root@pdb1/pdb2 ~]# iptables -F
[root@pdb1/pdb2 ~]# service iptables save
/*
iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]
*/

-- Step 11.2 -->> On Both Node
[root@pdb1/pdb2 ~]# /etc/init.d/iptables stop
/*
iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
*/

-- Step 12.1 -->> On Node 1
[root@pdb1/pdb2 ~]# chkconfig --list iptables
/*
iptables   0:off    1:off    2:off    3:off    4:off    5:off    6:off
*/ 

-- Step 13 -->> On Node 2
[root@pdb1/pdb2 ~]# service ntpd stop
/*
Shutting down ntpd:                                        [FAILED]
*/

-- Step 13.1 -->> On Node 2
[root@pdb1/pdb2 ~]# service ntpd status
/*
ntpd is stopped
*/

-- Step 14.1 -->> On Both Node
[root@pdb1/pdb2 ~]# chkconfig ntpd off

-- Step 14.1 -->> On Both Node
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
Chain INPUT (policy ACCEPT 2 packets, 80 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 2 packets, 256 bytes)
 pkts bytes target     prot opt in     out     source               destination
*/

-- Step 16 -->> On Both Node
[root@pdb1/pdb2 ~ ]# brctl show
/*
bridge name     bridge id               STP enabled     interfaces
virbr0          8000.525400d03447       yes             virbr0-nic
*/

-- Step 17 -->> On Both Node
[root@pdb1/pdb2 ~ ]# virsh net-list
/*
Name                 State      Autostart     Persistent
--------------------------------------------------
default              active     yes           yes
*/

-- Step 17.1 -->> On Both Node
[root@pdb1/pdb2 ~ ]# service libvirtd stop
/*
Stopping libvirtd daemon:                                  [  OK  ]
*/

-- Step 17.2 -->> On Both Node
[root@pdb1/pdb2 ~ ]# chkconfig --list | grep libvirtd
/*
libvirtd        0:off   1:off   2:off   3:on    4:on    5:on    6:off
*/

-- Step 17.3 -->> On Both Node
[root@pdb1/pdb2 ~]# chkconfig libvirtd off
[root@pdb1/pdb2 ~]# ip link set lxcbr0 down
[root@pdb1/pdb2 ~]# brctl delbr lxcbr0
[root@pdb1/pdb2 ~]# brctl show

-- Step 17.4 -->> On Node One
[root@pdb1 ~]# ifconfig
/*
eth0      Link encap:Ethernet  HWaddr 00:0C:29:F4:BC:32
          inet addr:192.168.16.21  Bcast:192.168.16.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fef4:bc32/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:496 errors:0 dropped:52 overruns:0 frame:0
          TX packets:391 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:53606 (52.3 KiB)  TX bytes:58071 (56.7 KiB)

eth1      Link encap:Ethernet  HWaddr 00:0C:29:F4:BC:3C
          inet addr:10.10.10.21  Bcast:10.10.10.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fef4:bc3c/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:108 errors:0 dropped:47 overruns:0 frame:0
          TX packets:17 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:7038 (6.8 KiB)  TX bytes:1122 (1.0 KiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:16 errors:0 dropped:0 overruns:0 frame:0
          TX packets:16 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:960 (960.0 b)  TX bytes:960 (960.0 b)

virbr0    Link encap:Ethernet  HWaddr 52:54:00:D0:34:47
          inet addr:192.168.122.1  Bcast:192.168.122.255  Mask:255.255.255.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
*/

-- Step 17.5 -->> On Node Two
[root@pdb2 ~]# ifconfig
/*
eth0      Link encap:Ethernet  HWaddr 00:0C:29:64:B4:57
          inet addr:192.168.16.22  Bcast:192.168.16.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fe64:b457/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:501 errors:0 dropped:46 overruns:0 frame:0
          TX packets:431 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:54089 (52.8 KiB)  TX bytes:62915 (61.4 KiB)

eth1      Link encap:Ethernet  HWaddr 00:0C:29:64:B4:61
          inet addr:10.10.10.22  Bcast:10.10.10.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fe64:b461/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:86 errors:0 dropped:38 overruns:0 frame:0
          TX packets:17 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:5718 (5.5 KiB)  TX bytes:1122 (1.0 KiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:16 errors:0 dropped:0 overruns:0 frame:0
          TX packets:16 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:960 (960.0 b)  TX bytes:960 (960.0 b)

virbr0    Link encap:Ethernet  HWaddr 52:54:00:4C:07:1D
          inet addr:192.168.122.1  Bcast:192.168.122.255  Mask:255.255.255.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
*/
-- Step 17.6 -->> On Both Node
[root@pdb1/pdb2 ~]# init 6


-- Step 17.7 -->> On Node One
[root@pdb1 ~]# ifconfig
/*
eth0      Link encap:Ethernet  HWaddr 00:0C:29:F4:BC:32
          inet addr:192.168.16.21  Bcast:192.168.16.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fef4:bc32/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:117 errors:0 dropped:28 overruns:0 frame:0
          TX packets:69 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:12424 (12.1 KiB)  TX bytes:8560 (8.3 KiB)

eth1      Link encap:Ethernet  HWaddr 00:0C:29:F4:BC:3C
          inet addr:10.10.10.21  Bcast:10.10.10.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fef4:bc3c/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:46 errors:0 dropped:21 overruns:0 frame:0
          TX packets:16 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:2760 (2.6 KiB)  TX bytes:1080 (1.0 KiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:16 errors:0 dropped:0 overruns:0 frame:0
          TX packets:16 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:960 (960.0 b)  TX bytes:960 (960.0 b)
*/

-- Step 17.8 -->> On Node Two
[root@pdb2 ~]# ifconfig
/*
eth0      Link encap:Ethernet  HWaddr 00:0C:29:64:B4:57
          inet addr:192.168.16.22  Bcast:192.168.16.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fe64:b457/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:100 errors:0 dropped:25 overruns:0 frame:0
          TX packets:61 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:10846 (10.5 KiB)  TX bytes:7804 (7.6 KiB)

eth1      Link encap:Ethernet  HWaddr 00:0C:29:64:B4:61
          inet addr:10.10.10.22  Bcast:10.10.10.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fe64:b461/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:29 errors:0 dropped:14 overruns:0 frame:0
          TX packets:17 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1740 (1.6 KiB)  TX bytes:1122 (1.0 KiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:12 errors:0 dropped:0 overruns:0 frame:0
          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:720 (720.0 b)  TX bytes:720 (720.0 b)
*/

-- Step 18 -->> On Both Node
[root@pdb1/pdb2 ~]# brctl show
/*
bridge name     bridge id               STP enabled     interfaces
*/

-- Step 19 -->> On Both Node
[root@pdb1/pdb2 ~]# chkconfig --list | grep libvirtd
/*
libvirtd        0:off   1:off   2:off   3:off   4:off   5:off   6:off
*/


-- Step 20 -->> On Both Node
[root@pdb1/pdb2 ~]# chkconfig --list iptables
/*
iptables        0:off   1:off   2:off   3:off   4:off   5:off   6:off
*/

-- Step 21 -->> On Both Node
[root@pdb1/pdb2 ~]# chkconfig --list ntpd
/*
ntpd            0:off   1:off   2:off   3:off   4:off   5:off   6:off
*/

-- Step 22 -->> On Both Node
[root@pdb1/pdb2 ~]# cat /etc/resolv.conf
/*
# Generated by NetworkManager
search cibnepal.org.np
nameserver 192.168.16.11
nameserver 192.168.16.12
*/

-- Step 22.1 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup 192.168.16.21
/*
Server:         192.168.16.11
Address:        192.168.16.11#53

21.6.16.172.in-addr.arpa        name = pdb1.unidev.org.np.
*/

-- Step 22.2 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup 192.168.16.22
/*
Server:         192.168.16.11
Address:        192.168.16.11#53

22.6.16.172.in-addr.arpa        name = pdb2.unidev.org.np.
*/

-- Step 22.3 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb1
/*
Server:         192.168.16.11
Address:        192.168.16.11#53

Name:   pdb1.unidev.org.np
Address: 192.168.16.21
*/

-- Step 22.4 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb2
/*
Server:         192.168.16.11
Address:        192.168.16.11#53

Name:   pdb2.unidev.org.np
Address: 192.168.16.22
*/

-- Step 22.5 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb-scan
/*
Server:         192.168.16.11
Address:        192.168.16.11#53

Name:   pdb-scan.unidev.org.np
Address: 192.168.16.26
Name:   pdb-scan.unidev.org.np
Address: 192.168.16.27
Name:   pdb-scan.unidev.org.np
Address: 192.168.16.25
*/

-- Step 22.6 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb2-vip
/*
Server:         192.168.16.11
Address:        192.168.16.11#53

Name:   pdb2-vip.unidev.org.np
Address: 192.168.16.24
*/

-- Step 22.7 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb1-vip
/*
Server:         192.168.16.11
Address:        192.168.16.11#53

Name:   pdb1-vip.unidev.org.np
Address: 192.168.16.23
*/

-- Step 22.8 -->> On Both Node
[root@pdb1/pdb2 ~]# iptables -L -nv
/*
Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination
*/


-- Step 23 -->> On Both Node
-- Perform either the Automatic Setup or the Manual Setup to complete the basic prerequisites. 
[root@pdb1/pdb2 ~]# cd /media/OL6.10\ x86_64\ Disc\ 1\ 20180625/Server/Packages/
[root@pdb1/pdb2 Packages]# yum -y install oracle-rdbms-server-11gR2-preinstall
[root@pdb1/pdb2 Packages]# yum -y update

-- Step 23.1 -->> On Both Node
[root@pdb1/pdb2 Packages]# yum install -y yum-utils
[root@pdb1/pdb2 Packages]# yum install -y zip unzip

-- Step 23.2 -->> On Both Node
[root@pdb1/pdb2 Packages]# rpm -iUvh binutils-2*x86_64*
[root@pdb1/pdb2 Packages]# rpm -iUvh glibc-2*x86_64* nss-softokn-freebl-3*x86_64*
[root@pdb1/pdb2 Packages]# rpm -iUvh glibc-2*i686* nss-softokn-freebl-3*i686*
[root@pdb1/pdb2 Packages]# rpm -iUvh compat-libstdc++-33*x86_64*
[root@pdb1/pdb2 Packages]# rpm -iUvh glibc-common-2*x86_64*
[root@pdb1/pdb2 Packages]# rpm -iUvh glibc-devel-2*x86_64*
[root@pdb1/pdb2 Packages]# rpm -iUvh glibc-devel-2*i686*
[root@pdb1/pdb2 Packages]# rpm -iUvh glibc-headers-2*x86_64*
[root@pdb1/pdb2 Packages]# rpm -iUvh elfutils-libelf-0*x86_64*
[root@pdb1/pdb2 Packages]# rpm -iUvh elfutils-libelf-devel-0*x86_64*
[root@pdb1/pdb2 Packages]# rpm -iUvh gcc-4*x86_64*
[root@pdb1/pdb2 Packages]# rpm -iUvh gcc-c++-4*x86_64*
[root@pdb1/pdb2 Packages]# rpm -iUvh ksh-*x86_64*
[root@pdb1/pdb2 Packages]# rpm -iUvh libaio-0*x86_64*
[root@pdb1/pdb2 Packages]# rpm -iUvh libaio-devel-0*x86_64*
[root@pdb1/pdb2 Packages]# rpm -iUvh libaio-0*i686*
[root@pdb1/pdb2 Packages]# rpm -iUvh libaio-devel-0*i686*
[root@pdb1/pdb2 Packages]# rpm -iUvh libgcc-4*x86_64*
[root@pdb1/pdb2 Packages]# rpm -iUvh libgcc-4*i686*
[root@pdb1/pdb2 Packages]# rpm -iUvh libstdc++-4*x86_64*
[root@pdb1/pdb2 Packages]# rpm -iUvh libstdc++-4*i686*
[root@pdb1/pdb2 Packages]# rpm -iUvh libstdc++-devel-4*x86_64*
[root@pdb1/pdb2 Packages]# rpm -iUvh make-3.81*x86_64*
[root@pdb1/pdb2 Packages]# rpm -iUvh numactl-devel-2*x86_64*
[root@pdb1/pdb2 Packages]# rpm -iUvh sysstat-9*x86_64*
[root@pdb1/pdb2 Packages]# rpm -iUvh compat-libstdc++-33*i686*
[root@pdb1/pdb2 Packages]# rpm -iUvh compat-libcap*
[root@pdb1/pdb2 Packages]# rpm -iUvh libaio-devel-0.*
[root@pdb1/pdb2 Packages]# rpm -iUvh ksh-2*
[root@pdb1/pdb2 Packages]# rpm -iUvh libstdc++-4.*.i686*
[root@pdb1/pdb2 Packages]# rpm -iUvh elfutils-libelf-0*i686* elfutils-libelf-devel-0*i686*
[root@pdb1/pdb2 Packages]# rpm -iUvh libtool-ltdl*i686*
[root@pdb1/pdb2 Packages]# rpm -iUvh ncurses*i686*
[root@pdb1/pdb2 Packages]# rpm -iUvh readline*i686*
[root@pdb1/pdb2 Packages]# rpm -iUvh unixODBC*
[root@pdb1/pdb2 Packages]# rpm -iUvh oracleasm*.rpm
[root@pdb1/pdb2 Packages]# yum -y update

-- Step 23.3 -->> On Both Node
[root@pdb1/pdb2 ~]# cd /root/Oracle_Linux_6_Rpm/
[root@pdb1/pdb2 Oracle_Linux_6_Rpm]# rpm -iUvh --nodeps --force dtrace-utils-1.0.0-8.el6.x86_64.rpm
[root@pdb1/pdb2 Oracle_Linux_6_Rpm]# rpm -iUvh --nodeps --force dtrace-utils-devel-1.0.0-8.el6.x86_64.rpm
[root@pdb1/pdb2 Oracle_Linux_6_Rpm]# rpm -iUvh --nodeps --force dtrace-utils-testsuite-1.0.0-8.el6.x86_64.rpm
[root@pdb1/pdb2 Oracle_Linux_6_Rpm]# rpm -iUvh elfutils-libelf-devel-static-0.164-2.el6.x86_64.rpm
[root@pdb1/pdb2 Oracle_Linux_6_Rpm]# rpm -iUvh libdtrace-ctf-0.8.0-1.el6.x86_64.rpm
[root@pdb1/pdb2 Oracle_Linux_6_Rpm]# rpm -iUvh libdtrace-ctf-devel-0.8.0-1.el6.x86_64.rpm
[root@pdb1/pdb2 Oracle_Linux_6_Rpm]# rpm -iUvh numactl-2.0.9-2.el6.i686.rpm
[root@pdb1/pdb2 Oracle_Linux_6_Rpm]# rpm -iUvh numactl-devel-2.0.9-2.el6.i686.rpm
[root@pdb1/pdb2 Oracle_Linux_6_Rpm]# rpm -iUvh --nodeps --force unixODBC-devel-2.2.14-12.el6_3.x86_64.rpm

-- Step 23.4 -->> On Both Node
[root@pdb1/pdb2 ~]# cd /media/OL6.10\ x86_64\ Disc\ 1\ 20180625/Server/Packages/
[root@pdb1/pdb2 Packages]# yum -y update

-- Step 23.5 -->> On Both Node
[root@pdb1/pdb2 Packages]# rpm -q binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel elfutils-libelf-devel-static \
[root@pdb1/pdb2 Packages]# rpm -q gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers kernel-headers ksh libaio libaio-devel \
[root@pdb1/pdb2 Packages]# rpm -q libgcc libgomp libstdc++ libstdc++-devel make numactl-devel sysstat unixODBC unixODBC-devel \

-- Step 24 -->> On Both Node
-- Pre-Installation Steps for ASM
[root@pdb1/pdb2 ~ ]# cd /etc/yum.repos.d
[root@pdb1/pdb2 yum.repos.d]# uname -ras
/*
Linux pdb1.unidev.org.np 4.1.12-124.48.6.el6uek.x86_64 #2 SMP Tue Mar 16 15:39:03 PDT 2021 x86_64 x86_64 x86_64 GNU/Linux
*/

-- Step 24.1 -->> On Both Node
[root@pdb1/pdb2 yum.repos.d]# cat /etc/os-release 
/*
NAME="Oracle Linux Server"
VERSION="6.10"
ID="ol"
VERSION_ID="6.10"
PRETTY_NAME="Oracle Linux Server 6.10"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:oracle:linux:6:10:server"
HOME_URL="https://linux.oracle.com/"
BUG_REPORT_URL="https://bugzilla.oracle.com/"

ORACLE_BUGZILLA_PRODUCT="Oracle Linux 6"
ORACLE_BUGZILLA_PRODUCT_VERSION=6.10
ORACLE_SUPPORT_PRODUCT="Oracle Linux"
ORACLE_SUPPORT_PRODUCT_VERSION=6.10
*/

-- Step 24.2 -->> On Both Node
[root@pdb1/pdb2 yum.repos.d]# wget https://public-yum.oracle.com/public-yum-ol6.repo
/*
--2025-06-25 13:05:38--  https://public-yum.oracle.com/public-yum-ol6.repo
Resolving public-yum.oracle.com... 104.73.165.90, 2600:140f:5:5084::2a7d, 2600:140f:5:508d::2a7d
Connecting to public-yum.oracle.com|104.73.165.90|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 12045 (12K) [text/plain]
Saving to: “public-yum-ol6.repo.1”

100%[===================================================>] 12,045      --.-K/s   in 0s

2025-06-25 13:05:40 (292 MB/s) - “public-yum-ol6.repo.1” saved [12045/12045]
*/

-- Step 24.3 -->> On Both Node
[root@pdb1/pdb2 yum.repos.d]# yum install -y kmod-oracleasm
[root@pdb1/pdb2 yum.repos.d]# yum install -y oracleasm-support

-- Step 24.4 -->> On Both Node
[root@pdb1/pdb2 ~]# cd /root/Oracle_Linux_6_Rpm/
[root@pdb1/pdb2 Oracle_Linux_6_Rpm]# rpm -iUvh oracleasmlib-2.0.4-1.el6.x86_64.rpm
[root@pdb1/pdb2 Oracle_Linux_6_Rpm]# rpm -qa | grep oracleasm
/*
oracleasmlib-2.0.4-1.el6.x86_64
oracleasm-support-2.1.11-2.el6.x86_64
kmod-oracleasm-2.0.8-16.1.el6_10.x86_64
*/

-- Step 24.5 -->> On Both Node
[root@pdb1/pdb2 ~]# cd /media/OL6.10\ x86_64\ Disc\ 1\ 20180625/Server/Packages/
[root@pdb1/pdb2 Packages]# yum -y update


-- Step 25 -->> On Both Node
-- Add the kernel parameters file "/etc/sysctl.conf" and add oracle recommended kernel parameters
[root@pdb1/pdb2 ~]# vi /etc/sysctl.conf
/*
net.ipv4.ip_forward = 0
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
net.ipv4.tcp_syncookies = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
fs.file-max = 6815744
kernel.sem = 250 32000 100 128
kernel.shmmni = 65536
kernel.shmall = 4294967296
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

-- Step 25.1 -->> On Both Node
-- Run the following command to change the current kernel parameters.
[root@pdb1/pdb2 ~]# sysctl -p /etc/sysctl.conf

-- Step 26 -->> On Both Node
-- Edit "/etc/security/limits.conf" file to limit user processes
[root@pdb1/pdb2 ~]# vi /etc/security/limits.conf
/*
# Oracle Setup
oracle   soft   nofile  65536
oracle   hard   nofile  65536
oracle   soft   nproc   16384
oracle   hard   nproc   16384
oracle   soft   stack   10240
oracle   hard   stack   32768
oracle   hard   memlock 134217728
oracle   soft   memlock 134217728

# Grid Setup
grid    soft    nofile   65536
grid    hard    nofile   65536
grid    soft    nproc    16384
grid    hard    nproc    16384
grid    soft    stack    10240
grid    hard    stack    32768
grid    soft    memlock  134217728
grid    hard    memlock  134217728
*/

-- Step 27 -->> On Both Node
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
-session   optional     pam_ck_connector.so
session    required     pam_limits.so
*/

-- Step 28 -->> On both Node
-- Create the new groups and users.
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:
*/

-- Step 28.1 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:
*/

-- Step 28.2 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i oracle
/*
oracle:x:500:
*/

-- Step 28.3 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i oper

-- Step 28.4 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i asm

-- Step 28.5 -->> On both Node
-- 1.Create OS groups using the command below. Enter these commands as the 'root' user:
[root@pdb1/pdb2 ~]# /usr/sbin/groupadd -g 503 oper
[root@pdb1/pdb2 ~]# /usr/sbin/groupadd -g 504 asmadmin
[root@pdb1/pdb2 ~]# /usr/sbin/groupadd -g 506 asmdba
[root@pdb1/pdb2 ~]# /usr/sbin/groupadd -g 507 asmoper
[root@pdb1/pdb2 ~]# /usr/sbin/groupadd -g 508 beoper

-- Step 28.6 -->> On both Node
-- 2.Create the users that will own the Oracle software using the commands:
[root@pdb1/pdb2 ~]# /usr/sbin/useradd -g oinstall -G oinstall,dba,asmadmin,asmdba,asmoper,beoper grid
[root@pdb1/pdb2 ~]# /usr/sbin/usermod -g oinstall -G oinstall,dba,oper,asmadmin,asmdba oracle

-- Step 28.7 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i grid
/*
oinstall:x:54321:grid,oracle
dba:x:54322:grid,oracle
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 28.8 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/

-- Step 28.9 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i oracle
/*
oracle:x:500:
oinstall:x:54321:grid,oracle
dba:x:54322:grid,oracle
oper:x:503:oracle
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
*/

-- Step 28.10 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i oper
/*
oper:x:503:oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 28.11 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:grid,oracle
*/

-- Step 28.12 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:grid,oracle
asmdba:x:506:grid,oracle
*/

-- Step 29 -->> On both Node
[root@pdb1/pdb2 ~]# passwd oracle
/*
Changing password for user oracle.
New password: oracle
Retype new password: oracle
passwd: all authentication tokens updated successfully.
*/

-- Step 29.1 -->> On both Node
[root@pdb1/pdb2 ~]# passwd grid
/*
Changing password for user grid.
New password: grid
Retype new password: grid
passwd: all authentication tokens updated successfully.
*/

-- Step 29.2 -->> On both Node
[root@pdb1/pdb2 ~]# su - oracle

-- Step 29.3 -->> On both Node
[oracle@pdb1/pdb2 ~]$ su - grid
/*
Password: grid
*/

-- Step 29.4 -->> On both Node
[grid@pdb1/pdb2 ~]$ su - oracle
/*
Password: oracle
*/

-- Step 29.5 -->> On both Node
[oracle@pdb1/pdb2 ~]$ exit
/*
logout
*/

-- Step 29.6 -->> On both Node
[grid@pdb1/pdb2 ~]$ exit
/*
logout
*/

-- Step 29.7 -->> On both Node
[oracle@pdb1/pdb2 ~]$ exit
/*
logout
*/

-- Step 30 -->> On both Node
--1.Create the Oracle Inventory Director:
[root@pdb1/pdb2 ~]# mkdir -p /opt/app/oraInventory
[root@pdb1/pdb2 ~]# chown -R grid:oinstall /opt/app/oraInventory
[root@pdb1/pdb2 ~]# chmod -R 775 /opt/app/oraInventory

--2.Creating the Oracle Grid Infrastructure Home Directory:
[root@pdb1/pdb2 ~]# mkdir -p /opt/app/11.2.0.3.0/grid
[root@pdb1/pdb2 ~]# chown -R grid:oinstall /opt/app/11.2.0.3.0/grid
[root@pdb1/pdb2 ~]# chmod -R 775 /opt/app/11.2.0.3.0/grid

--3.Creating the Oracle Base Directory
[root@pdb1/pdb2 ~]# mkdir -p /opt/app/oracle
[root@pdb1/pdb2 ~]# mkdir /opt/app/oracle/cfgtoollogs
[root@pdb1/pdb2 ~]# chown -R oracle:oinstall /opt/app/oracle
[root@pdb1/pdb2 ~]# chmod -R 775 /opt/app/oracle
[root@pdb1/pdb2 ~]# chown -R grid:oinstall /opt/app/oracle/cfgtoollogs
[root@pdb1/pdb2 ~]# chmod -R 775 /opt/app/oracle/cfgtoollogs

--4.Creating the Oracle RDBMS Home Directory
[root@pdb1/pdb2 ~]# mkdir -p /opt/app/oracle/product/11.2.0.3.0/db_1
[root@pdb1/pdb2 ~]# chown -R oracle:oinstall /opt/app/oracle/product/11.2.0.3.0/db_1
[root@pdb1/pdb2 ~]# chmod -R 775 /opt/app/oracle/product/11.2.0.3.0/db_1
[root@pdb1/pdb2 ~]# cd /opt/app/oracle
[root@pdb1/pdb2 ~]# chown -R oracle:oinstall product
[root@pdb1/pdb2 ~]# chmod -R 775 product


-- Step 31 -->> On both Nodes
-- Unzip the files and Copy the ASM rpm to another Nodes.
[root@pdb1 ~]# cd /root/11.2.0.3.0/
[root@pdb1 11.2.0.3.0]# unzip p10404530_112030_Linux-x86-64_1of7.zip -d /opt/app/oracle/product/11.2.0.3.0/db_1/
[root@pdb1 11.2.0.3.0]# unzip p10404530_112030_Linux-x86-64_2of7.zip -d /opt/app/oracle/product/11.2.0.3.0/db_1/
[root@pdb1 11.2.0.3.0]# unzip p10404530_112030_Linux-x86-64_3of7-Clusterware.zip -d /opt/app/11.2.0.3.0/

-- Step 32 -->> On Node 2
[root@pdb2 ~]# mkdir -p /opt/app/11.2.0.3.0/grid/rpm/

-- Step 32.1 -->> On Node 1
[root@pdb1 ~]# cd /opt/app/11.2.0.3.0/grid/rpm/
[root@pdb1 rpm]# scp -r cvuqdisk-1.0.9-1.rpm root@pdb2:/opt/app/11.2.0.3.0/grid/rpm/
/*
The authenticity of host 'pdb2 (192.168.16.22)' can't be established.
RSA key fingerprint is 0c:8c:de:2c:fd:ea:e1:c4:89:d8:f7:4f:e0:f1:83:38.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'pdb2,192.168.16.22' (RSA) to the list of known hosts.
root@pdb2's password:
cvuqdisk-1.0.9-1.rpm                                       100% 8551     8.4KB/s   00:00
*/

-- Step 33 -->> On both Nodes
[root@pdb1/pdb2 ~]# chown -R grid:oinstall /opt/app/11.2.0.3.0/grid
[root@pdb1/pdb2 ~]# chmod -R 775 /opt/app/11.2.0.3.0/grid
[root@pdb1/pdb2 ~]# chown -R oracle:oinstall /opt/app/oracle/product/11.2.0.3.0/db_1
[root@pdb1/pdb2 ~]# chmod -R 775 /opt/app/oracle/product/11.2.0.3.0/db_1

-- Step 34 -->> On Node 1
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
ORACLE_HOME=$ORACLE_BASE/product/11.2.0.3.0/db_1; export ORACLE_HOME
ORACLE_SID=pdbdb1; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 34.1 -->> On Node 1
[oracle@pdb1 ~]$ . .bash_profile

-- Step 35 -->> On Node 1
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
GRID_HOME=/opt/app/11.2.0.3.0/grid; export GRID_HOME
ORACLE_HOME=$GRID_HOME; export ORACLE_HOME

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 35.1 -->> On Node 1
[grid@pdb1 ~]$ . .bash_profile

-- Step 36 -->> On Node 2
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
ORACLE_HOME=$ORACLE_BASE/product/11.2.0.3.0/db_1; export ORACLE_HOME
ORACLE_SID=pdbdb2; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 36.1 -->> On Node 2
[oracle@pdb2 ~]$ . .bash_profile

-- Step 37 -->> On Node 2
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
GRID_HOME=/opt/app/11.2.0.3.0/grid; export GRID_HOME
ORACLE_HOME=$GRID_HOME; export ORACLE_HOME

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 37.1 -->> On Node 2
[grid@pdb2 ~]$ . .bash_profile

-- Step 38 -->> On Both Nodes
-- To install the cvuqdisk-1.0.10-1.rpm
-- Login from root user
[root@pdb1/pdb2 ~]# cd /opt/app/11.2.0.3.0/grid/rpm/

-- Step 38.1 -->> On Both Nodes
[root@pdb1/pdb2 rpm]# ls -ltr
/*
-rwxrwxr-x 1 grid oinstall 8551 Sep 22  2011 cvuqdisk-1.0.9-1.rpm
*/

-- Step 38.2 -->> On Both Nodes
[root@pdb1/pdb2 rpm]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP

-- Step 38.3 -->> On Both Nodes
[root@pdb1/pdb2 rpm]# rpm -iUvh cvuqdisk-1.0.9-1.rpm  
/*
Preparing...                ########################################### [100%]
   1:cvuqdisk               ########################################### [100%]
*/

-- Step 39 -->> On Node 1
--SSH user Equivalency configuration (grid and oracle):
[root@pdb1 ~]# su - oracle
[oracle@pdb1 ~]$ cd /opt/app/oracle/product/11.2.0.3.0/db_1/database/sshsetup/
[oracle@pdb1 sshsetup]$ ./sshUserSetup.sh -user oracle -hosts "pdb1 pdb2" -noPromptPassphrase -confirm -advanced
/*
Password: oracle
*/

-- Step 40 -->> On Both Nodes
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb1 date
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb2 date
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb1 date && ssh oracle@pdb2 date
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb1.unidev.org.np date
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb2.unidev.org.np date
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb1.unidev.org.np date && ssh oracle@pdb2.unidev.org.np date
[oracle@pdb1/pdb2 ~]$ ssh oracle@192.168.16.21 date
[oracle@pdb1/pdb2 ~]$ ssh oracle@192.168.16.22 date
[oracle@pdb1/pdb2 ~]$ ssh oracle@192.168.16.21 date && ssh oracle@192.168.16.22 date

-- Step 41 -->> On Node 1
[root@pdb1 ~]# su - grid
[grid@pdb1 ~]$ cd /opt/app/11.2.0.3.0/grid/sshsetup
[grid@pdb1 deinstall]$ ./sshUserSetup.sh -user grid -hosts "pdb1 pdb2" -noPromptPassphrase -confirm -advanced
/*
Password: grid
*/

-- Step 42 -->> On Both Nodes
[grid@pdb1/pdb2 ~]$ ssh grid@pdb1 date
[grid@pdb1/pdb2 ~]$ ssh grid@pdb2 date
[grid@pdb1/pdb2 ~]$ ssh grid@pdb1 date && ssh grid@pdb2 date
[grid@pdb1/pdb2 ~]$ ssh grid@pdb1.unidev.org.np date
[grid@pdb1/pdb2 ~]$ ssh grid@pdb2.unidev.org.np date
[grid@pdb1/pdb2 ~]$ ssh grid@pdb1.unidev.org.np date && ssh grid@pdb2.unidev.org.np date
[grid@pdb1/pdb2 ~]$ ssh grid@192.168.16.21 date
[grid@pdb1/pdb2 ~]$ ssh grid@192.168.16.22 date
[grid@pdb1/pdb2 ~]$ ssh grid@192.168.16.21 date && ssh grid@192.168.16.22 date

-- Step 43 -->> On Both Nodes
[root@pdb1/pdb2 ~]# which oracleasm
/*
/usr/sbin/oracleasm
*/

-- Step 43.1 -->> On Both Nodes
[root@pdb1/pdb2 ~]# oracleasm configure
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

-- Step 43.2 -->> On Both Nodes
[root@pdb1/pdb2 ~]# oracleasm status
/*
Checking if ASM is loaded: no
Checking if /dev/oracleasm is mounted: no
*/

-- Step 43.4 -->> On Both Nodes
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

-- Step 43.5 -->> On Both Nodes
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

-- Step 43.6 -->> On Both Nodes
[root@pdb1/pdb2 ~]# oracleasm init
/*
Creating /dev/oracleasm mount point: /dev/oracleasm
Loading module "oracleasm": oracleasm
Configuring "oracleasm" to use device physical block size
Mounting ASMlib driver filesystem: /dev/oracleasm
*/

-- Step 43.7 -->> On Both Nodes
[root@pdb1/pdb2 ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 43.8 -->> On Both Nodes
[root@pdb1/pdb2 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 43.9 -->> On Both Nodes
[root@pdb1/pdb2 ~]# oracleasm listdisks

-- Step 43.10 -->> On Both Nodes
[root@pdb1/pdb2 ~]# ls -ltr /etc/init.d/ | grep -E "oracle"
/*
-rwxr-xr-x  1 root root  7401 Feb  3  2018 oracleasm
-rwxr--r--  1 root root  1371 Nov  2  2018 oracle-rdbms-server-11gR2-preinstall-firstboot
*/

-- Step 43.11 -->> On Both Node
[root@pdb1/pdb2 ~]# ll /dev/oracleasm/disks/
/*
total 0
*/

-- Step 44 -->> On Both Node
[root@pdb1/pdb2 ~]# ll /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Jun 26 11:35 /dev/sda
brw-rw---- 1 root disk 8,  1 Jun 26 11:35 /dev/sda1
brw-rw---- 1 root disk 8,  2 Jun 26 11:35 /dev/sda2
brw-rw---- 1 root disk 8,  3 Jun 26 11:35 /dev/sda3
brw-rw---- 1 root disk 8,  4 Jun 26 11:35 /dev/sda4
brw-rw---- 1 root disk 8,  5 Jun 26 11:35 /dev/sda5
brw-rw---- 1 root disk 8,  6 Jun 26 11:35 /dev/sda6
brw-rw---- 1 root disk 8,  7 Jun 26 11:35 /dev/sda7
brw-rw---- 1 root disk 8,  8 Jun 26 11:35 /dev/sda8
brw-rw---- 1 root disk 8,  9 Jun 26 11:35 /dev/sda9
brw-rw---- 1 root disk 8, 16 Jun 26 11:35 /dev/sdb
brw-rw---- 1 root disk 8, 32 Jun 26 11:35 /dev/sdc
brw-rw---- 1 root disk 8, 48 Jun 26 11:35 /dev/sdd
*/

--Step 45 -->> On Both Node
[root@pdb1/pdb2 ~]# lsblk
/*
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
fd0      2:0    1    4K  0 disk
sda      8:0    0  210G  0 disk
├─sda1   8:1    0    2G  0 part /boot
├─sda2   8:2    0   70G  0 part /
├─sda3   8:3    0   58G  0 part /opt
├─sda4   8:4    0    1K  0 part
├─sda5   8:5    0   20G  0 part [SWAP]
├─sda6   8:6    0   15G  0 part /home
├─sda7   8:7    0   15G  0 part /tmp
├─sda8   8:8    0   15G  0 part /usr
└─sda9   8:9    0   15G  0 part /var
sdb      8:16   0   20G  0 disk
sdc      8:32   0  200G  0 disk
sdd      8:48   0  400G  0 disk
sr0     11:0    1 1024M  0 rom
*/

-- Step 46 -->> On Both Nodes
[root@pdb1/pdb2 ~]# fdisk -ll | grep -E "sdb|sdc|sdd"
/*
Disk /dev/sdb: 21.5 GB, 21474836480 bytes
Disk /dev/sdd: 429.5 GB, 429496729600 bytes
Disk /dev/sdc: 214.7 GB, 214748364800 bytes
*/

-- Step 47 -->> On Both Nodes
-- Enable Multipath to resolve oracleasmlibrary v3 issues - (Both Nodes disks not similar after reboot OS)
[root@pdb1/pdb2 ~]# cd /etc/yum.repos.d/
[root@pdb1/pdb2 yum.repos.d]# yum install -y device-mapper-multipath

-- Step 47.1 -->> On Both Nodes
[root@pdb1/pdb2 ~]# which mpathconf
/*
/sbin/mpathconf
*/

-- Step 47.2 -->> On Both Nodes
[root@pdb1/pdb2 ~]# mpathconf --enable --with_multipathd y
/*
Starting multipathd daemon:                                [  OK  ]
*/

-- Step 47.3 -->> On Both Nodes
[root@pdb1/pdb2 ~]# multipath -ll
/*
mpathc (36000c2991137c9097275f10cb1b67a9e) dm-2 VMware,Virtual disk
size=400G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  `- 3:0:2:0 sdd 8:48 active ready running
mpathb (36000c29df49724b2c639967308843c0c) dm-1 VMware,Virtual disk
size=200G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  `- 3:0:1:0 sdc 8:32 active ready running
mpatha (36000c291af7e96b9f320160f7132e880) dm-0 VMware,Virtual disk
size=20G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  `- 3:0:0:0 sdb 8:16 active ready running
*/

-- Step 47.4 -->> On Both Nodes
[root@pdb1/pdb2 ~]# ls -l /dev/disk/by-id/ | grep -E "sdb|sdc|sdd"
/*
lrwxrwxrwx 1 root root  9 Jun 26 11:35 scsi-36000c291af7e96b9f320160f7132e880 -> ../../sdb
lrwxrwxrwx 1 root root  9 Jun 26 11:35 scsi-36000c2991137c9097275f10cb1b67a9e -> ../../sdd
lrwxrwxrwx 1 root root  9 Jun 26 11:35 scsi-36000c29df49724b2c639967308843c0c -> ../../sdc
lrwxrwxrwx 1 root root  9 Jun 26 11:35 wwn-0x6000c291af7e96b9f320160f7132e880 -> ../../sdb
lrwxrwxrwx 1 root root  9 Jun 26 11:35 wwn-0x6000c2991137c9097275f10cb1b67a9e -> ../../sdd
lrwxrwxrwx 1 root root  9 Jun 26 11:35 wwn-0x6000c29df49724b2c639967308843c0c -> ../../sdc
*/

-- Step 47.5 -->> On Both Nodes
[root@pdb1/pdb2 ~]# which scsi_id
/*
/sbin/scsi_id
*/

-- Step 47.6 -->> On Both Nodes
[root@pdb1/pdb2 ~]# /sbin/scsi_id -g -u -d /dev/sdb
/*
36000c291af7e96b9f320160f7132e880
*/

-- Step 47.7 -->> On Both Nodes
[root@pdb1/pdb2 ~]# /sbin/scsi_id -g -u -d /dev/sdc
/*
36000c29df49724b2c639967308843c0c
*/

-- Step 47.8 -->> On Both Nodes
[root@pdb1/pdb2 ~]# /sbin/scsi_id -g -u -d /dev/sdd
/*
36000c2991137c9097275f10cb1b67a9e
*/

-- Step 47.9 -->> On Node 1
[root@pdb1 ~]# vi /etc/multipath.conf
/*
# This is a basic configuration file with some examples, for device mapper
# multipath.
# For a complete list of the default configuration values, see
# /usr/share/doc/device-mapper-multipath-0.4.9/multipath.conf.defaults
# For a list of configuration options with descriptions, see
# /usr/share/doc/device-mapper-multipath-0.4.9/multipath.conf.annotated
#
# REMEMBER: After updating multipath.conf, you must run
#
# service multipathd reload
#
# for the changes to take effect in multipathd

blacklist_exceptions {
        devnode "^sd[b-z]"  # Allow storage disks
        wwid "36000c291af7e96b9f320160f7132e880"
        wwid "36000c29df49724b2c639967308843c0c"
        wwid "36000c2991137c9097275f10cb1b67a9e"
}

defaults {
        user_friendly_names no         # Oracle preferred
        find_multipaths no             # OK for ASMFD
        no_path_retry queue            # Better for Oracle I/O
}

multipaths {
        multipath {
                   wwid 36000c291af7e96b9f320160f7132e880
                   alias OCR
        }
        multipath {
                   wwid 36000c29df49724b2c639967308843c0c
                   alias DATA
        }
        multipath {
                   wwid 36000c2991137c9097275f10cb1b67a9e
                   alias ARC
        }
}

devices {
    device {
        vendor "VMware"
        product "Virtual disk"
        path_checker "tur"
        path_grouping_policy "multibus"
        failback "immediate"
        rr_weight "uniform"
        no_path_retry "queue"
    }
}

blacklist {
        devnode "^sd[a]" # Exclude the system disk
        devnode "^sr[0-9]"   # Blacklist CD/DVD drives
        devnode "^dm-[0-9]"  # Blacklist LVM devices
}
*/

-- Step 47.10 -->> On Node 1
[root@pdb1 ~]# scp -r /etc/multipath.conf root@pdb2:/etc/
/*
root@pdb2's password: <= P@ssw0rd
multipath.conf                                             100% 1337     1.6MB/s   00:00
*/

-- Step 47.11 -->> On Both Nodes
[root@pdb1/pdb2 ~]# chkconfig multipathd on

-- Step 47.12 -->> On Both Nodes
[root@pdb1/pdb2 ~]# chkconfig --list multipathd
/*
multipathd      0:off   1:off   2:on    3:on    4:on    5:on    6:off
*/

-- Step 47.13 -->> On Both Nodes
[root@pdb1/pdb2 ~]# service multipathd restart
/*
ok
Stopping multipathd daemon:                                [  OK  ]
Starting multipathd daemon:                                [  OK  ]
*/

-- Step 47.14 -->> On Node 1
[root@pdb1 ~]# service multipathd status
/*
multipathd (pid  6718) is running...
*/

-- Step 47.15 -->> On Node 2
[root@pdb2 ~]# service multipathd status
/*
multipathd (pid  6039) is running...
*/

-- Step 47.16 -->> On Both Nodes
[root@pdb1/pdb2 ~]# multipath -ll
/*
OCR (36000c291af7e96b9f320160f7132e880) dm-0 VMware,Virtual disk
size=20G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  `- 3:0:0:0 sdb 8:16 active ready running
ARC (36000c2991137c9097275f10cb1b67a9e) dm-2 VMware,Virtual disk
size=400G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  `- 3:0:2:0 sdd 8:48 active ready running
DATA (36000c29df49724b2c639967308843c0c) dm-1 VMware,Virtual disk
size=200G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  `- 3:0:1:0 sdc 8:32 active ready running
*/

-- Step 48 -->> On Both Nodes
[root@pdb1/pdb2 ~]# lsblk
/*
NAME          MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
fd0             2:0    1    4K  0 disk
sda             8:0    0  210G  0 disk
├─sda1          8:1    0    2G  0 part  /boot
├─sda2          8:2    0   70G  0 part  /
├─sda3          8:3    0   58G  0 part  /opt
├─sda4          8:4    0    1K  0 part
├─sda5          8:5    0   20G  0 part  [SWAP]
├─sda6          8:6    0   15G  0 part  /home
├─sda7          8:7    0   15G  0 part  /tmp
├─sda8          8:8    0   15G  0 part  /usr
└─sda9          8:9    0   15G  0 part  /var
sdb             8:16   0   20G  0 disk
└─OCR (dm-0)  249:0    0   20G  0 mpath
sdc             8:32   0  200G  0 disk
└─DATA (dm-1) 249:1    0  200G  0 mpath
sdd             8:48   0  400G  0 disk
└─ARC (dm-2)  249:2    0  400G  0 mpath
sr0            11:0    1 1024M  0 rom
*/

-- Step 49 -->> On Both Nodes
[root@pdb1/pdb2 ~]# fdisk -ll | grep -E "OCR|DATA|ARC"
/*
Disk /dev/mapper/OCR: 21.5 GB, 21474836480 bytes
Disk /dev/mapper/DATA: 214.7 GB, 214748364800 bytes
Disk /dev/mapper/ARC: 429.5 GB, 429496729600 bytes
*/

-- Step 50 -->> On Node 1
[root@pdb1 ~]# fdisk /dev/mapper/OCR
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0x51c5d03a.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/mapper/OCR: 21.5 GB, 21474836480 bytes
255 heads, 63 sectors/track, 2610 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x51c5d03a

          Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-2610, default 1):
Using default value 1
Last cylinder, +cylinders or +size{K,M,G} (1-2610, default 2610):
Using default value 2610

Command (m for help): p

Disk /dev/mapper/OCR: 21.5 GB, 21474836480 bytes
255 heads, 63 sectors/track, 2610 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x51c5d03a

          Device Boot      Start         End      Blocks   Id  System
/dev/mapper/OCRp1               1        2610    20964793+  83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.

WARNING: Re-reading the partition table failed with error 22: Invalid argument.
The kernel still uses the old table. The new table will be used at
the next reboot or after you run partprobe(8) or kpartx(8)
Syncing disks.
*/

-- Step 51 -->> On Node 1
[root@pdb1 ~]# fdisk /dev/mapper/DATA
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0x80806350.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/mapper/DATA: 214.7 GB, 214748364800 bytes
255 heads, 63 sectors/track, 26108 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x80806350

           Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-26108, default 1):
Using default value 1
Last cylinder, +cylinders or +size{K,M,G} (1-26108, default 26108):
Using default value 26108

Command (m for help): p

Disk /dev/mapper/DATA: 214.7 GB, 214748364800 bytes
255 heads, 63 sectors/track, 26108 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x80806350

           Device Boot      Start         End      Blocks   Id  System
/dev/mapper/DATAp1               1       26108   209712478+  83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.

WARNING: Re-reading the partition table failed with error 22: Invalid argument.
The kernel still uses the old table. The new table will be used at
the next reboot or after you run partprobe(8) or kpartx(8)
Syncing disks.
*/

-- Step 52 -->> On Node 1
[root@pdb1 ~]# fdisk /dev/mapper/ARC
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0xaffec176.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/mapper/ARC: 429.5 GB, 429496729600 bytes
255 heads, 63 sectors/track, 52216 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xaffec176

          Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-52216, default 1):
Using default value 1
Last cylinder, +cylinders or +size{K,M,G} (1-52216, default 52216):
Using default value 52216

Command (m for help): p

Disk /dev/mapper/ARC: 429.5 GB, 429496729600 bytes
255 heads, 63 sectors/track, 52216 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xaffec176

          Device Boot      Start         End      Blocks   Id  System
/dev/mapper/ARCp1               1       52216   419424988+  83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.

WARNING: Re-reading the partition table failed with error 22: Invalid argument.
The kernel still uses the old table. The new table will be used at
the next reboot or after you run partprobe(8) or kpartx(8)
Syncing disks.
*/

-- Step 52 -->> On Both Nodes
[root@pdb1/pdb2 ~]# partprobe /dev/mapper/OCR
[root@pdb1/pdb2 ~]# partprobe /dev/mapper/DATA
[root@pdb1/pdb2 ~]# partprobe /dev/mapper/ARC

-- Step 53 -->> On Both Nodes (Optional)
[root@pdb1/pdb2 ~]# init 6

-- Step 54 -->> On Both Nodes
[root@pdb1/pdb2 ~]# lsblk
/*
NAME              MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
fd0                 2:0    1    4K  0 disk
sda                 8:0    0  210G  0 disk
├─sda1              8:1    0    2G  0 part  /boot
├─sda2              8:2    0   70G  0 part  /
├─sda3              8:3    0   58G  0 part  /opt
├─sda4              8:4    0    1K  0 part
├─sda5              8:5    0   20G  0 part  [SWAP]
├─sda6              8:6    0   15G  0 part  /home
├─sda7              8:7    0   15G  0 part  /tmp
├─sda8              8:8    0   15G  0 part  /usr
└─sda9              8:9    0   15G  0 part  /var
sdb                 8:16   0   20G  0 disk
├─sdb1              8:17   0   20G  0 part
└─OCR (dm-0)      249:0    0   20G  0 mpath
  └─OCRp1 (dm-3)  249:3    0   20G  0 part
sdc                 8:32   0  200G  0 disk
├─sdc1              8:33   0  200G  0 part
└─DATA (dm-1)     249:1    0  200G  0 mpath
  └─DATAp1 (dm-4) 249:4    0  200G  0 part
sdd                 8:48   0  400G  0 disk
├─sdd1              8:49   0  400G  0 part
└─ARC (dm-2)      249:2    0  400G  0 mpath
  └─ARCp1 (dm-5)  249:5    0  400G  0 part
sr0                11:0    1 1024M  0 rom
*/

-- Step 55 -->> On Both Nodes
[root@pdb1/pdb2 ~]# service oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 56 -->> On Both Nodes
[root@pdb1/pdb2 ~]# ll /dev/mapper/ | grep -E "OCR|DATA|ARC"
/*
lrwxrwxrwx 1 root root       7 Jun 26 12:03 ARC -> ../dm-2
lrwxrwxrwx 1 root root       7 Jun 26 12:03 ARCp1 -> ../dm-5
lrwxrwxrwx 1 root root       7 Jun 26 12:03 DATA -> ../dm-1
lrwxrwxrwx 1 root root       7 Jun 26 12:03 DATAp1 -> ../dm-4
lrwxrwxrwx 1 root root       7 Jun 26 12:03 OCR -> ../dm-0
lrwxrwxrwx 1 root root       7 Jun 26 12:03 OCRp1 -> ../dm-3
*/

-- Step 57 -->> On Both Nodes
[root@pdb1/pdb2 ~]# fdisk -ll | grep -E "OCR|DATA|ARC"
/*
Disk /dev/mapper/OCR: 21.5 GB, 21474836480 bytes
/dev/mapper/OCRp1               1        2610    20964793+  83  Linux
Disk /dev/mapper/DATA: 214.7 GB, 214748364800 bytes
/dev/mapper/DATAp1               1       26108   209712478+  83  Linux
Disk /dev/mapper/ARC: 429.5 GB, 429496729600 bytes
/dev/mapper/ARCp1               1       52216   419424988+  83  Linux
*/

-- Step 58 -->> On Both Nodes
[root@pdb1/pdb2 ~]# mkfs.ext4 /dev/mapper/OCRp1
[root@pdb1/pdb2 ~]# mkfs.ext4 /dev/mapper/DATAp1
[root@pdb1/pdb2 ~]# mkfs.ext4 /dev/mapper/ARCp1

-- Step 59 -->> On Both Nodes
[root@pdb1/pdb2 ~]#  ll /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Jun 26 12:03 /dev/sda
brw-rw---- 1 root disk 8,  1 Jun 26 12:03 /dev/sda1
brw-rw---- 1 root disk 8,  2 Jun 26 12:03 /dev/sda2
brw-rw---- 1 root disk 8,  3 Jun 26 12:03 /dev/sda3
brw-rw---- 1 root disk 8,  4 Jun 26 12:03 /dev/sda4
brw-rw---- 1 root disk 8,  5 Jun 26 12:03 /dev/sda5
brw-rw---- 1 root disk 8,  6 Jun 26 12:03 /dev/sda6
brw-rw---- 1 root disk 8,  7 Jun 26 12:03 /dev/sda7
brw-rw---- 1 root disk 8,  8 Jun 26 12:03 /dev/sda8
brw-rw---- 1 root disk 8,  9 Jun 26 12:03 /dev/sda9
brw-rw---- 1 root disk 8, 16 Jun 26 12:04 /dev/sdb
brw-rw---- 1 root disk 8, 17 Jun 26 12:04 /dev/sdb1
brw-rw---- 1 root disk 8, 32 Jun 26 12:04 /dev/sdc
brw-rw---- 1 root disk 8, 33 Jun 26 12:04 /dev/sdc1
brw-rw---- 1 root disk 8, 48 Jun 26 12:04 /dev/sdd
brw-rw---- 1 root disk 8, 49 Jun 26 12:04 /dev/sdd1
*/

-- Step 60 -->> On Both Nodes
[root@pdb1/pdb2 ~]#  ll /dev/dm*
/*
brw-rw---- 1 root disk 249, 0 Jun 26 12:03 /dev/dm-0
brw-rw---- 1 root disk 249, 1 Jun 26 12:03 /dev/dm-1
brw-rw---- 1 root disk 249, 2 Jun 26 12:03 /dev/dm-2
brw-rw---- 1 root disk 249, 3 Jun 26 12:17 /dev/dm-3
brw-rw---- 1 root disk 249, 4 Jun 26 12:17 /dev/dm-4
brw-rw---- 1 root disk 249, 5 Jun 26 12:17 /dev/dm-5
*/

-- Step 61 -->> On Both Node
[root@pdb1/pdb2 ~]# fdisk -ll | grep -E "OCR|DATA|ARC"
/*
Disk /dev/mapper/OCR: 21.5 GB, 21474836480 bytes
/dev/mapper/OCRp1               1        2610    20964793+  83  Linux
Disk /dev/mapper/DATA: 214.7 GB, 214748364800 bytes
/dev/mapper/DATAp1               1       26108   209712478+  83  Linux
Disk /dev/mapper/ARC: 429.5 GB, 429496729600 bytes
/dev/mapper/ARCp1               1       52216   419424988+  83  Linux
*/


-- Step 62 -->> On Node 1
[root@pdb1 ~]# oracleasm createdisk OCR /dev/mapper/OCRp1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 63 -->> On Node 1
[root@pdb1 ~]# oracleasm createdisk DATA /dev/mapper/DATAp1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 64 -->> On Node 1
[root@pdb1 ~]# oracleasm createdisk ARC /dev/mapper/ARCp1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 65 -->> On Node 1
[root@pdb1 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 66 -->> On Node 1
[root@pdb1 ~]# oracleasm listdisks
/*
ARC
DATA
OCR
*/

-- Step 67 -->> On Node 2
[root@pdb2 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
Instantiating disk "OCR"
Instantiating disk "ARC"
Instantiating disk "DATA"
*/

-- Step 68 -->> On Node 2
[root@pdb2 ~]# oracleasm listdisks
/*
ARC
DATA
OCR
*/

-- Step 69 -->> On Both Node
[root@pdb1/pdb2 ~]# ll /dev/oracleasm/disks/
/*
brw-rw---- 1 grid asmadmin 249, 5 Jun 10 10:44 ARC
brw-rw---- 1 grid asmadmin 249, 3 Jun 10 10:44 DATA
brw-rw---- 1 grid asmadmin 249, 4 Jun 10 10:44 OCR
*/

-- Step 70 -->> On Node 1
-- Pre-check for rac Setup
[grid@pdb1 ~]$ cd /opt/app/11.2.0.3.0/grid/
[grid@pdb1 grid]$ ./runcluvfy.sh stage -pre crsinst -n pdb1,pdb2 -verbose

-- Step 71 -->> On Node 1
-- To Create a Response File to Install GID
[grid@pdb1 ~]$ cp /opt/app/11.2.0.3.0/grid/response/grid_install.rsp /home/grid/
[grid@pdb1 ~]$ cd /home/grid/
[grid@pdb1 ~]$ ls -ltr | grep grid_install.rsp
/*
-rwxr-xr-x 1 grid oinstall 24485 Jun 26 12:41 grid_install.rsp
*/

-- Step 71.1 -->> On Node 1
[grid@pdb1 ~]$ vi grid_install.rsp
/*
oracle.install.responseFileVersion=/oracle/install/rspfmt_crsinstall_response_schema_v11_2_0
ORACLE_HOSTNAME=pdb1.unidev.org.np
INVENTORY_LOCATION=/opt/app/oraInventory
SELECTED_LANGUAGES=en
oracle.install.option=CRS_CONFIG
ORACLE_BASE=/opt/app/oracle
ORACLE_HOME=/opt/app/11.2.0.3.0/grid
oracle.install.asm.OSDBA=asmdba
oracle.install.asm.OSOPER=asmoper
oracle.install.asm.OSASM=asmadmin
oracle.install.crs.config.gpnp.scanName=pdb-scan
oracle.install.crs.config.gpnp.scanPort=1521
oracle.install.crs.config.clusterName=pdb-cluster
oracle.install.crs.config.gpnp.configureGNS=false
oracle.install.crs.config.clusterNodes=pdb1:pdb1-vip,pdb2:pdb2-vip
oracle.install.crs.config.networkInterfaceList=eth0:192.168.16.0:1,eth1:10.10.10.0:2
oracle.install.crs.config.storageOption=ASM_STORAGE
oracle.install.crs.config.sharedFileSystemStorage.votingDiskRedundancy=NORMAL
oracle.install.crs.config.sharedFileSystemStorage.ocrRedundancy=NORMAL
oracle.install.crs.config.useIPMI=false
oracle.install.asm.SYSASMPassword=Sys605014
oracle.install.asm.diskGroup.name=OCR
oracle.install.asm.diskGroup.redundancy=EXTERNAL
oracle.install.asm.diskGroup.AUSize=4
oracle.install.asm.diskGroup.disks=/dev/oracleasm/disks/OCR
oracle.install.asm.diskGroup.diskDiscoveryString=/dev/oracleasm/disks/*
oracle.install.asm.monitorPassword=Sys605014
oracle.install.asm.upgradeASM=false
oracle.installer.autoupdates.option=SKIP_UPDATES
*/

-- Step 72 -->> On Node 1
-- To Install Grid Software with Leteset Opatch
[grid@pdb1 ~]$ cd /opt/app/11.2.0.3.0/grid/
[grid@pdb1 grid]$ ./runInstaller -ignorePrereq -showProgress -silent -responseFile /home/grid/grid_install.rsp
/*
Starting Oracle Universal Installer...

Checking Temp space: must be greater than 120 MB.   Actual 14166 MB    Passed
Checking swap space: must be greater than 150 MB.   Actual 20479 MB    Passed
Preparing to launch Oracle Universal Installer from /tmp/OraInstall2025-06-26_12-46-45PM. Please wait ...[grid@pdb1 grid]$ [WARNING] [INS-32016] The selected Oracle home contains directories or files.
   CAUSE: The selected Oracle home contained directories or files.
   ACTION: To start with an empty Oracle home, either remove its contents or choose another location.
You can find the log of this install session at:
 /opt/app/oraInventory/logs/installActions2025-06-26_12-46-45PM.log

Prepare in progress.
..................................................   5% Done.

Prepare successful.

Copy files in progress.
..................................................   10% Done.
..................................................   16% Done.
..................................................   21% Done.
..................................................   26% Done.

Copy files successful.
..........
Link binaries in progress.

Link binaries successful.
..................................................   34% Done.

Setup files in progress.

Setup files successful.
..................................................   41% Done.

Perform remote operations in progress.
..................................................   48% Done.

Perform remote operations successful.
The installation of Oracle Grid Infrastructure was successful.
Please check '/opt/app/oraInventory/logs/silentInstall2025-06-26_12-46-45PM.log' for more details.
..................................................   97% Done.

Execute Root Scripts in progress.

As a root user, execute the following script(s):
        1. /opt/app/oraInventory/orainstRoot.sh
        2. /opt/app/11.2.0.3.0/grid/root.sh

Execute /opt/app/oraInventory/orainstRoot.sh on the following nodes:
[pdb1, pdb2]
Execute /opt/app/11.2.0.3.0/grid/root.sh on the following nodes:
[pdb1, pdb2]

..................................................   100% Done.

Execute Root Scripts successful.
As install user, execute the following script to complete the configuration.
        1. /opt/app/11.2.0.3.0/grid/cfgtoollogs/configToolAllCommands

        Note:
        1. This script must be run on the same system from where installer was run.
        2. This script needs a small password properties file for configuration assistants that require passwords (refer to install guide documentation).


Successfully Setup Software.
*/

-- Step 72.1 -->> On Node 1
[root@pdb1 ~]# /opt/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 72.2 -->> On Node 2
[root@pdb2 ~]# /opt/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 72.3 -->> On Node 1
[root@pdb1 ~]# /opt/app/11.2.0.3.0/grid/root.sh
/*
Check /opt/app/11.2.0.3.0/grid/install/root_pdb1.unidev.org.np_2025-06-26_12-55-33.log for the output of root script
*/

-- Step 72.3.1 -->> On Node 1
[root@pdb1 ~]#  tail -f /opt/app/11.2.0.3.0/grid/install/root_pdb1.unidev.org.np_2025-06-26_12-55-33.log
/*
Performing root user operation for Oracle 11g

The following environment variables are set as:
    ORACLE_OWNER= grid
    ORACLE_HOME=  /opt/app/11.2.0.3.0/grid

Creating /etc/oratab file...
Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Using configuration parameter file: /opt/app/11.2.0.3.0/grid/crs/install/crsconfig_params
Creating trace directory
User ignored Prerequisites during installation
OLR initialization - successful
  root wallet
  root wallet cert
  root cert export
  peer wallet
  profile reader wallet
  pa wallet
  peer wallet keys
  pa wallet keys
  peer cert request
  pa cert request
  peer cert
  pa cert
  peer root cert TP
  profile reader root cert TP
  pa root cert TP
  peer pa cert TP
  pa peer cert TP
  profile reader pa cert TP
  profile reader peer cert TP
  peer user cert
  pa user cert
Adding Clusterware entries to upstart
CRS-2672: Attempting to start 'ora.mdnsd' on 'pdb1'
CRS-2676: Start of 'ora.mdnsd' on 'pdb1' succeeded
CRS-2672: Attempting to start 'ora.gpnpd' on 'pdb1'
CRS-2676: Start of 'ora.gpnpd' on 'pdb1' succeeded
CRS-2672: Attempting to start 'ora.cssdmonitor' on 'pdb1'
CRS-2672: Attempting to start 'ora.gipcd' on 'pdb1'
CRS-2676: Start of 'ora.cssdmonitor' on 'pdb1' succeeded
CRS-2676: Start of 'ora.gipcd' on 'pdb1' succeeded
CRS-2672: Attempting to start 'ora.cssd' on 'pdb1'
CRS-2672: Attempting to start 'ora.diskmon' on 'pdb1'
CRS-2676: Start of 'ora.diskmon' on 'pdb1' succeeded
CRS-2676: Start of 'ora.cssd' on 'pdb1' succeeded

ASM created and started successfully.

Disk Group OCR created successfully.

clscfg: -install mode specified
Successfully accumulated necessary OCR keys.
Creating OCR keys for user 'root', privgrp 'root'..
Operation successful.
CRS-4256: Updating the profile
Successful addition of voting disk 47e1fadf575f4f43bff6b7549afed055.
Successfully replaced voting disk group with +OCR.
CRS-4256: Updating the profile
CRS-4266: Voting file(s) successfully replaced
##  STATE    File Universal Id                File Name Disk group
--  -----    -----------------                --------- ---------
 1. ONLINE   47e1fadf575f4f43bff6b7549afed055 (/dev/oracleasm/disks/OCR) [OCR]
Located 1 voting disk(s).
CRS-2672: Attempting to start 'ora.asm' on 'pdb1'
CRS-2676: Start of 'ora.asm' on 'pdb1' succeeded
CRS-2672: Attempting to start 'ora.OCR.dg' on 'pdb1'
CRS-2676: Start of 'ora.OCR.dg' on 'pdb1' succeeded
Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 72.4 -->> On Node 2
[root@pdb2 ~]# /opt/app/11.2.0.3.0/grid/root.sh
/*
Check /opt/app/11.2.0.3.0/grid/install/root_pdb2.unidev.org.np_2025-06-26_13-01-40.log for the output of root script
*/

-- Step 72.4.1 -->> On Node 2 
[root@pdb2 ~]# tail -f /opt/app/11.2.0.3.0/grid/install/root_pdb2.unidev.org.np_2025-06-26_13-01-40.log
/*
Performing root user operation for Oracle 11g

The following environment variables are set as:
    ORACLE_OWNER= grid
    ORACLE_HOME=  /opt/app/11.2.0.3.0/grid

Creating /etc/oratab file...
Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Using configuration parameter file: /opt/app/11.2.0.3.0/grid/crs/install/crsconfig_params
Creating trace directory
User ignored Prerequisites during installation
OLR initialization - successful
Adding Clusterware entries to upstart
CRS-4402: The CSS daemon was started in exclusive mode but found an active CSS daemon on node pdb1, number 1, and is terminating
An active cluster was found during exclusive startup, restarting to join the cluster
Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 72.5 -->> On Node 1
[grid@pdb1 ~]$ cd /opt/app/11.2.0.3.0/grid/
[grid@pdb1 grid]$ /opt/app/11.2.0.3.0/grid/cfgtoollogs/configToolAllCommands RESPONSE_FILE=/home/grid/grid_install.rsp
/*
Setting the invPtrLoc to /opt/app/11.2.0.3.0/grid/oraInst.loc

perform - mode is starting for action: configure

perform - mode finished for action: configure

You can see the log file: /opt/app/11.2.0.3.0/grid/cfgtoollogs/oui/configActions2025-06-26_01-05-54-PM.log
*/


-- Step 73 -->> On Both Nodes
[root@pdb1/pdb2 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
[root@pdb1/pdb2 bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/


-- Step 74 -->> On Both Nodes
[root@pdb1/pdb2 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
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

-- Step 75 -->> On Node 1
[root@pdb1 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
[root@pdb1 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdb1                     Started
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       pdb1
ora.crf
      1        ONLINE  ONLINE       pdb1
ora.crsd
      1        ONLINE  ONLINE       pdb1
ora.cssd
      1        ONLINE  ONLINE       pdb1
ora.cssdmonitor
      1        ONLINE  ONLINE       pdb1
ora.ctssd
      1        ONLINE  ONLINE       pdb1                     ACTIVE:0
ora.diskmon
      1        OFFLINE OFFLINE
ora.evmd
      1        ONLINE  ONLINE       pdb1
ora.gipcd
      1        ONLINE  ONLINE       pdb1
ora.gpnpd
      1        ONLINE  ONLINE       pdb1
ora.mdnsd
      1        ONLINE  ONLINE       pdb1
*/


-- Step 76 -->> On Node 2
[root@pdb2 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
[root@pdb2 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdb2                     Started
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       pdb2
ora.crf
      1        ONLINE  ONLINE       pdb2
ora.crsd
      1        ONLINE  ONLINE       pdb2
ora.cssd
      1        ONLINE  ONLINE       pdb2
ora.cssdmonitor
      1        ONLINE  ONLINE       pdb2
ora.ctssd
      1        ONLINE  ONLINE       pdb2                     ACTIVE:0
ora.diskmon
      1        OFFLINE OFFLINE
ora.evmd
      1        ONLINE  ONLINE       pdb2
ora.gipcd
      1        ONLINE  ONLINE       pdb2
ora.gpnpd
      1        ONLINE  ONLINE       pdb2
ora.mdnsd
      1        ONLINE  ONLINE       pdb2
*/

-- Step 77 -->> On Both Nodes
[root@pdb1/pdb2 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
[root@pdb1/pdb2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
ora.OCR.dg
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
ora.asm
               ONLINE  ONLINE       pdb1                     Started
               ONLINE  ONLINE       pdb2                     Started
ora.gsd
               OFFLINE OFFLINE      pdb1
               OFFLINE OFFLINE      pdb2
ora.net1.network
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
ora.ons
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdb2
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdb1
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       pdb1
ora.cvu
      1        ONLINE  ONLINE       pdb1
ora.oc4j
      1        ONLINE  ONLINE       pdb1
ora.pdb1.vip
      1        ONLINE  ONLINE       pdb1
ora.pdb2.vip
      1        ONLINE  ONLINE       pdb2
ora.scan1.vip
      1        ONLINE  ONLINE       pdb2
ora.scan2.vip
      1        ONLINE  ONLINE       pdb1
ora.scan3.vip
      1        ONLINE  ONLINE       pdb1
*/

-- Step 78 -->> On Both Nodes
[grid@pdb1/pdb2 ~]$ /opt/app/11.2.0.3.0/grid/OPatch/opatch version
/*
Invoking OPatch 11.2.0.1.7

OPatch Version: 11.2.0.1.7

OPatch succeeded.
*/

-- Step 79 -->> On Both Nodes
[grid@pdb1/pdb2 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512   4096  4194304     20472    20040                0           20040              0             Y  OCR/
ASMCMD [+] > exit
*/

-- Step 80 -->> On Node 1
[grid@pdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 26-JUN-2025 13:12:05

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                26-JUN-2025 13:06:49
Uptime                    0 days 0 hr. 5 min. 15 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.21)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.23)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 80.1 -->> On Node 1
[grid@pdb1 ~]$ ps -ef | grep SCAN
/*
grid     15984     1  0 13:00 ?        00:00:00 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN2 -inherit
grid     16012     1  0 13:00 ?        00:00:00 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN3 -inherit
grid     17463 17160  0 13:12 pts/0    00:00:00 grep SCAN
*/

-- Step 80.2 -->> On Node 1
[grid@pdb1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 26-JUN-2025 13:12:35

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                26-JUN-2025 13:00:25
Uptime                    0 days 0 hr. 12 min. 10 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/11.2.0.3.0/grid/log/diag/tnslsnr/pdb1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.26)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 80.3 -->> On Node 1
[grid@pdb1 ~]$ lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 26-JUN-2025 13:12:51

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                26-JUN-2025 13:00:27
Uptime                    0 days 0 hr. 12 min. 24 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/11.2.0.3.0/grid/log/diag/tnslsnr/pdb1/listener_scan3/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN3)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.27)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 80.4 -->> On Node 2
[grid@pdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 26-JUN-2025 13:12:05

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                26-JUN-2025 13:06:49
Uptime                    0 days 0 hr. 5 min. 16 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.22)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.24)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 80.5 -->> On Node 2
[grid@pdb2 ~]$ ps -ef | grep SCAN
/*
grid     14125     1  0 13:04 ?        00:00:00 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN1 -inherit
grid     15167 15073  0 13:12 pts/0    00:00:00 grep SCAN
*/

-- Step 80.6 -->> On Node 2
[grid@pdb2 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 26-JUN-2025 13:13:24

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                26-JUN-2025 13:04:38
Uptime                    0 days 0 hr. 8 min. 46 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/11.2.0.3.0/grid/log/diag/tnslsnr/pdb2/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.25)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 81 -->> On Node 1
-- To Create ASM storage for Data and Archive 
[grid@pdb1 ~]$ cd /opt/app/11.2.0.3.0/grid/bin

-- Step 81.1 -->> On Node 1
[grid@pdb1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName DATA -diskList /dev/oracleasm/disks/DATA -redundancy EXTERNAL
/*
Disk Group DATA created successfully.
*/

-- Step 81.2 -->> On Node 1
[grid@pdb1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName ARC -diskList /dev/oracleasm/disks/ARC -redundancy EXTERNAL
/*
Disk Group DATA created successfully.
*/

-- Step 82 -->> On Both Nodes
[grid@pdb1/pdb2 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 11.2.0.3.0 Production on Thu Jun 26 14:43:41 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Real Application Clusters and Automatic Storage Management options

SQL> set lines 200;
SQL> COLUMN name FORMAT A30
SQL> SELECT inst_id,name,state,type,compatibility,database_compatibility,voting_files FROM gv$asm_diskgroup order by name;

INST_ID NAME STATE   TYPE   COMPATIBILITY DATABASE_COMPATIBILITY V
------- ---- ------- ------ ------------- ---------------------- -
      1 ARC  MOUNTED EXTERN 11.2.0.0.0    10.1.0.0.0             N
      2 ARC  MOUNTED EXTERN 11.2.0.0.0    10.1.0.0.0             N
      2 DATA MOUNTED EXTERN 11.2.0.0.0    10.1.0.0.0             N
      1 DATA MOUNTED EXTERN 11.2.0.0.0    10.1.0.0.0             N
      2 OCR  MOUNTED EXTERN 11.2.0.0.0    10.1.0.0.0             Y
      1 OCR  MOUNTED EXTERN 11.2.0.0.0    10.1.0.0.0             Y

6 rows selected.

SQL> set lines 200;
SQL> col path format a40;
SQL> SELECT name,path, group_number group_#, disk_number disk_#, mount_status,header_status, state, total_mb, free_mb FROM v$asm_disk order by group_number;

NAME      PATH                      GROUP_# DISK_# MOUNT_S HEADER_STATU STATE  TOTAL_MB FREE_MB
--------- ------------------------- ------- ------ ------- ------------ ------ -------- -------
OCR_0000  /dev/oracleasm/disks/OCR        1      0 CACHED  MEMBER       NORMAL    20472   20040
DATA_0000 /dev/oracleasm/disks/DATA       2      0 CACHED  MEMBER       NORMAL   204797  204701
ARC_0000  /dev/oracleasm/disks/ARC        3      0 CACHED  MEMBER       NORMAL   409594  409496

SQL> set lines 200;
SQL> col BANNER_FULL format a80;
SQL> col BANNER_LEGACY format a80;
SQL> SELECT * FROM gv$version;

   INST_ID BANNER
---------- --------------------------------------------------------------------------------
         1 Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
         1 PL/SQL Release 11.2.0.3.0 - Production
         1 CORE 11.2.0.3.0      Production
         1 TNS for Linux: Version 11.2.0.3.0 - Production
         1 NLSRTL Version 11.2.0.3.0 - Production
         2 Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
         2 PL/SQL Release 11.2.0.3.0 - Production
         2 CORE 11.2.0.3.0      Production
         2 TNS for Linux: Version 11.2.0.3.0 - Production
         2 NLSRTL Version 11.2.0.3.0 - Production

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Real Application Clusters and Automatic Storage Management options
*/

-- Step 83 -->> On Both Nodes
[grid@pdb1/pdb2 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512   4096  1048576    409594   409496                0          409496              0             N  ARC/
MOUNTED  EXTERN  N         512   4096  1048576    204797   204701                0          204701              0             N  DATA/
MOUNTED  EXTERN  N         512   4096  4194304     20472    20040                0           20040              0             Y  OCR/
ASMCMD [+] > exit
*/

-- Step 84 -->> On Both Nodes
[root@pdb1/pdb2 ~]# cd /opt/app/11.2.0.3.0/grid/bin
[root@pdb1/pdb2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.ARC.dg
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
ora.DATA.dg
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
ora.LISTENER.lsnr
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
ora.OCR.dg
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
ora.asm
               ONLINE  ONLINE       pdb1                     Started
               ONLINE  ONLINE       pdb2                     Started
ora.gsd
               OFFLINE OFFLINE      pdb1
               OFFLINE OFFLINE      pdb2
ora.net1.network
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
ora.ons
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdb2
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdb1
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       pdb1
ora.cvu
      1        ONLINE  ONLINE       pdb1
ora.oc4j
      1        ONLINE  ONLINE       pdb1
ora.pdb1.vip
      1        ONLINE  ONLINE       pdb1
ora.pdb2.vip
      1        ONLINE  ONLINE       pdb2
ora.scan1.vip
      1        ONLINE  ONLINE       pdb2
ora.scan2.vip
      1        ONLINE  ONLINE       pdb1
ora.scan3.vip
      1        ONLINE  ONLINE       pdb1
*/


-- Step 85 -->> On Node 1
[root@pdb1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/11.2.0.3.0/grid:N                # line added by Agent
*/

-- Step 86 -->> On Node 2
[root@pdb2 ~]# vi /etc/oratab
/*
+ASM2:/opt/app/11.2.0.3.0/grid:N                # line added by Agent
*/

-- Step 87 -->> On Both Nodes
-- Reboot the Oracle Cluster
[root@pdb1 ~]# cd /opt/app/11.2.0.3.0/grid/bin
[root@pdb1 ~]# ./crsctl stop cluster -all
[root@pdb1 ~]# ./crsctl start cluster -all
[root@pdb1/pdb2 ~]# ./crsctl stat res -t -init
[root@pdb1/pdb2 ~]# ./crsctl stat res -t
[root@pdb1/pdb2 ~]# ./crsctl check cluster -all
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

-- Step 88 -->> On Node 1
-- To Create a responce file for Oracle Software Installation
[oracle@pdb1 ~]$ cp /opt/app/oracle/product/11.2.0.3.0/db_1/database/response/db_install.rsp /home/oracle/
[oracle@pdb1 ~]$ cd /home/oracle/

-- Step 88.1 -->> On Node 1
[oracle@pdb1 ~]$ ll db_install.rsp
/*
-rwxr-xr-x 1 oracle oinstall 24992 Jun 26 14:51 db_install.rsp
*/

-- Step 88.2 -->> On Node 1
[oracle@pdb1 ~]$ vi db_install.rsp
/*
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v11_2_0
oracle.install.option=INSTALL_DB_SWONLY
ORACLE_HOSTNAME=pdb1.unidev.org.np
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/opt/app/oraInventory
SELECTED_LANGUAGES=en
ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1
ORACLE_BASE=/opt/app/oracle
oracle.install.db.InstallEdition=EE
oracle.install.db.EEOptionsSelection=false
oracle.install.db.OSDBA_GROUP=dba
oracle.install.db.OSOPER_GROUP=oper
oracle.install.db.CLUSTER_NODES=pdb1,pdb2
oracle.install.db.isRACOneInstall=false
oracle.install.db.config.starterdb.type=GENERAL_PURPOSE
*/

-- Step 89 -->> On Node 1
-- To install Oracle Software with Letest Opatch
[oracle@pdb1 ~]$ cd /opt/app/oracle/product/11.2.0.3.0/db_1/database/
[oracle@pdb1 db_1]$ ./runInstaller -ignorePrereq -waitforcompletion -silent \
-responseFile /home/oracle/db_install.rsp                                   \
oracle.install.db.isRACOneInstall=false                                     \
oracle.install.db.rac.serverpoolCardinality=0                               \
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false                                  \
DECLINE_SECURITY_UPDATES=true

/*
Starting Oracle Universal Installer...

Checking Temp space: must be greater than 120 MB.   Actual 14166 MB    Passed
Checking swap space: must be greater than 150 MB.   Actual 20479 MB    Passed
Preparing to launch Oracle Universal Installer from /tmp/OraInstall2025-06-26_02-53-41PM. Please wait ...[WARNING] [INS-32016] The selected Oracle home contains directories or files.
   CAUSE: The selected Oracle home contained directories or files.
   ACTION: To start with an empty Oracle home, either remove its contents or choose another location.
You can find the log of this install session at:
 /opt/app/oraInventory/logs/installActions2025-06-26_02-53-41PM.log
The installation of Oracle Database 11g was successful.
Please check '/opt/app/oraInventory/logs/silentInstall2025-06-26_02-53-41PM.log' for more details.

As a root user, execute the following script(s):
        1. /opt/app/oracle/product/11.2.0.3.0/db_1/root.sh

Execute /opt/app/oracle/product/11.2.0.3.0/db_1/root.sh on the following nodes:
[pdb1, pdb2]

Successfully Setup Software.
*/

-- Step 89.1 -->> On Node 1
[root@pdb1 ~]# /opt/app/oracle/product/11.2.0.3.0/db_1/root.sh
/*
Check /opt/app/oracle/product/11.2.0.3.0/db_1/install/root_pdb1.unidev.org.np_2025-06-26_15-07-31.log for the output of root script
*/

-- Step 89.2 -->> On Node 1
[root@pdb1 ~]# tail -f  /opt/app/oracle/product/11.2.0.3.0/db_1/install/root_pdb1.unidev.org.np_2025-06-26_15-07-31.log
/*
Performing root user operation for Oracle 11g

The following environment variables are set as:
    ORACLE_OWNER= oracle
    ORACLE_HOME=  /opt/app/oracle/product/11.2.0.3.0/db_1
Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Finished product-specific root actions.
*/

-- Step 89.3 -->> On Node 2
[root@pdb2 ~]# /opt/app/oracle/product/11.2.0.3.0/db_1/root.sh
/*
Check /opt/app/oracle/product/11.2.0.3.0/db_1/install/root_pdb2.unidev.org.np_2025-06-26_15-08-12.log for the output of root script
*/

-- Step 89.4 -->> On Node 2
[root@pdb2 ~]# tail -f /opt/app/oracle/product/11.2.0.3.0/db_1/install/root_pdb2.unidev.org.np_2025-06-26_15-08-12.log
/* 
Performing root user operation for Oracle 11g

The following environment variables are set as:
    ORACLE_OWNER= oracle
    ORACLE_HOME=  /opt/app/oracle/product/11.2.0.3.0/db_1
Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Finished product-specific root actions.
*/

-- Step 90 -->> On Both Nodes
-- To Create a Oracle Database
[root@pdb1/pdb2 ~]# mkdir -p /opt/app/oracle/admin/pdbdb/adump
[root@pdb1/pdb2 ~]# cd /opt/app/oracle/admin/
[root@pdb1/pdb2 ~]# chown -R oracle:oinstall pdbdb
[root@pdb1/pdb2 ~]# chmod -R 775 pdbdb

-- Step 91 -->> On Node 1
-- To prepare the responce file
[root@pdb1 ~]# su - oracle
[oracle@pdb1 ~]$ cp /opt/app/oracle/product/11.2.0.3.0/db_1/database/response/dbca.rsp /home/oracle/
[oracle@pdb1 ~]$ cd /home/oracle/
[oracle@pdb1 ~]$ ll dbca.rsp
/*
-rwxr-xr-x 1 oracle oinstall 44533 Jun 26 15:09 dbca.rsp
*/

-- Step 91.1 -->> On Node 1 (Remove parammeters/lines except those)
[oracle@pdb1 ~]$ vi dbca.rsp
/*
[GENERAL]
RESPONSEFILE_VERSION = "11.2.0"
OPERATION_TYPE = "createDatabase"
[CREATEDATABASE]
GDBNAME = "pdbdb"
SID = "pdbdb"
TEMPLATENAME = "General_Purpose.dbc"
SYSPASSWORD = "Sys605014"
SYSTEMPASSWORD = "Sys605014"
SYSMANPASSWORD = "Sys605014"
DBSNMPPASSWORD = "Sys605014"
STORAGETYPE=ASM
DISKGROUPNAME=DATA
INITPARAMS=control_files='+DATA','+ARC'
CHARACTERSET = "AL32UTF8"
MEMORYPERCENTAGE = "40"
DATABASETYPE = "MULTIPURPOSE"
AUTOMATICMEMORYMANAGEMENT = "FALSE"
TOTALMEMORY = "8192"
NODELIST = "pdb1,pdb2"
INSTANCE_NAMES = "pdbdb1,pdbdb2"
*/

-- Step 91.2 -->> On Node 1
[oracle@pdb1 ~]$ cd /opt/app/oracle/product/11.2.0.3.0/db_1/bin
[oracle@pdb1 bin]$ ./dbca -silent -responseFile /home/oracle/dbca.rsp
/*
Copying database files
1% complete
3% complete
9% complete
15% complete
21% complete
30% complete
Creating and starting Oracle instance
32% complete
36% complete
40% complete
44% complete
45% complete
48% complete
50% complete
Creating cluster database views
52% complete
70% complete
Completing Database Creation
73% complete
76% complete
85% complete
94% complete
100% complete
Look at the log file "/opt/app/oracle/cfgtoollogs/dbca/pdbdb/pdbdb.log" for further details.
*/  

-- Step 91.3 -->> On Node 1
[oracle@pdb1 ~]$  tail -f /opt/app/oracle/cfgtoollogs/dbca/pdbdb/pdbdb.log
/*
Copying database files
DBCA_PROGRESS : 1%
DBCA_PROGRESS : 3%
DBCA_PROGRESS : 9%
DBCA_PROGRESS : 15%
DBCA_PROGRESS : 21%
DBCA_PROGRESS : 30%
Creating and starting Oracle instance
DBCA_PROGRESS : 32%
DBCA_PROGRESS : 36%
DBCA_PROGRESS : 40%
DBCA_PROGRESS : 44%
DBCA_PROGRESS : 45%
DBCA_PROGRESS : 48%
DBCA_PROGRESS : 50%
Creating cluster database views
DBCA_PROGRESS : 52%
DBCA_PROGRESS : 70%
Completing Database Creation
DBCA_PROGRESS : 73%
DBCA_PROGRESS : 76%
DBCA_PROGRESS : 85%
DBCA_PROGRESS : 94%
DBCA_PROGRESS : 100%
Database creation complete. For details check the logfiles at:
 /opt/app/oracle/cfgtoollogs/dbca/pdbdb.
Database Information:
Global Database Name:pdbdb
System Identifier(SID) Prefix:pdbdb
*/

-- Step 92 -->> On Both Nodes 
[oracle@pdb1/pdb2 ~]$ srvctl config database -d pdbdb
/*
Database unique name: pdbdb
Database name: pdbdb
Oracle home: /opt/app/oracle/product/11.2.0.3.0/db_1
Oracle user: oracle
Spfile: +DATA/pdbdb/spfilepdbdb.ora
Domain:
Start options: open
Stop options: immediate
Database role: PRIMARY
Management policy: AUTOMATIC
Server pools: pdbdb
Database instances: pdbdb1,pdbdb2
Disk Groups: DATA
Mount point paths:
Services:
Type: RAC
Database is administrator managed
*/

-- Step 92.1 -->> On Node 1
[oracle@pdb1 ~]$ srvctl modify database -d pdbdb -a "DATA,ARC"

-- Step 92.2 -->> On Both Nodes 
[oracle@pdb1/pdb2 ~]$ srvctl config database -d pdbdb
/*
Database unique name: pdbdb
Database name: pdbdb
Oracle home: /opt/app/oracle/product/11.2.0.3.0/db_1
Oracle user: oracle
Spfile: +DATA/pdbdb/spfilepdbdb.ora
Domain:
Start options: open
Stop options: immediate
Database role: PRIMARY
Management policy: AUTOMATIC
Server pools: pdbdb
Database instances: pdbdb1,pdbdb2
Disk Groups: DATA,ARC
Mount point paths:
Services:
Type: RAC
Database is administrator managed
*/

-- Step 93 -->> On Both Nodes 
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Thu Jun 26 17:04:22 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT * FROM gv$version;

   INST_ID BANNER
---------- --------------------------------------------------------------------------------
         1 Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
         1 PL/SQL Release 11.2.0.3.0 - Production
         1 CORE 11.2.0.3.0      Production
         1 TNS for Linux: Version 11.2.0.3.0 - Production
         1 NLSRTL Version 11.2.0.3.0 - Production
         2 Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
         2 PL/SQL Release 11.2.0.3.0 - Production
         2 CORE 11.2.0.3.0      Production
         2 TNS for Linux: Version 11.2.0.3.0 - Production
         2 NLSRTL Version 11.2.0.3.0 - Production

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 94 -->> On Both Nodes 
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 95 -->> On Both Nodes 
[oracle@pdb1/pdb2 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): pdb2,pdb1
*/

-- Step 96 -->> On Node 1 
[oracle@pdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 26-JUN-2025 17:07:15

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                26-JUN-2025 14:49:34
Uptime                    0 days 2 hr. 17 min. 41 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.21)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.23)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 97 -->> On Node 2 
[oracle@pdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 26-JUN-2025 17:07:16

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                26-JUN-2025 14:49:37
Uptime                    0 days 2 hr. 17 min. 38 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.22)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.24)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 98 -->> On Node 1
[root@pdb1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/11.2.0.3.0/grid:N
pdbdb:/opt/app/oracle/product/11.2.0.3.0/db_1:N
pdbdb1:/opt/app/oracle/product/11.2.0.3.0/db_1:N
*/

-- Step 99 -->> On Node 2
[root@pdb2 ~]# vi /etc/oratab 
/*
+ASM2:/opt/app/11.2.0.3.0/grid:N
pdbdb:/opt/app/oracle/product/11.2.0.3.0/db_1:N
pdbdb2:/opt/app/oracle/product/11.2.0.3.0/db_1:N
*/

-- Step 100 -->> On Node 1
[oracle@pdb1 ~]$ vi /opt/app/oracle/product/11.2.0.3.0/db_1/network/admin/tnsnames.ora
/*
# tnsnames.ora Network Configuration File: /opt/app/oracle/product/11.2.0.3.0/db_1/network/admin/tnsnames.ora
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
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.16.21)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = pdbdb)
    )
  )
*/

-- Step 101 -->> On Node 2
[oracle@pdb2 ~]$ vi /opt/app/oracle/product/11.2.0.3.0/db_1/network/admin/tnsnames.ora
/*
# tnsnames.ora Network Configuration File: /opt/app/oracle/product/11.2.0.3.0/db_1/network/admin/tnsnames.ora
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
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.16.22)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = pdbdb)
    )
  )
*/

-- Step 102 -->> On Both Node
[oracle@pdb1/pdb2 ~]$ tnsping pdbdb
/*
TNS Ping Utility for Linux: Version 11.2.0.3.0 - Production on 26-JUN-2025 17:09:24

Copyright (c) 1997, 2011, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdb-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = pdbdb)))
OK (0 msec)
*/

-- Step 102.1 -->> On Both Node
[oracle@pdb1 ~]$ tnsping pdbdb1
/*
TNS Ping Utility for Linux: Version 11.2.0.3.0 - Production on 26-JUN-2025 17:09:35

Copyright (c) 1997, 2011, Oracle.  All rights reserved.

Used parameter files:

Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.16.21)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = pdbdb)))
OK (0 msec)
*/

-- Step 102.2 -->> On Both Node
[oracle@pdb2 ~]$ tnsping pdbdb2
/*
TNS Ping Utility for Linux: Version 11.2.0.3.0 - Production on 26-JUN-2025 17:09:47

Copyright (c) 1997, 2011, Oracle.  All rights reserved.

Used parameter files:

Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.16.22)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = pdbdb)))
OK (0 msec)
*/

-- Step 103 -->> On Both Nodes
[oracle@pdb1 ~]$ sqlplus sys/Sys605014@pdbdb as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Thu Jun 26 17:10:13 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         2 OPEN         pdbdb2           PRIMARY          READ WRITE
         1 OPEN         pdbdb1           PRIMARY          READ WRITE

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 104 -->> On Node 1
[root@pdb1 ~]# cd /opt/app/11.2.0.3.0/grid/bin
[root@pdb1 ~]# ./crsctl stop cluster -all
[root@pdb1 ~]# ./crsctl start cluster -all

-- Step 105 -->> On Node 1
[root@pdb1 ~]# cd /opt/app/11.2.0.3.0/grid/bin
[root@pdb1 ~]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdb1                     Started
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       pdb1
ora.crf
      1        ONLINE  ONLINE       pdb1
ora.crsd
      1        ONLINE  ONLINE       pdb1
ora.cssd
      1        ONLINE  ONLINE       pdb1
ora.cssdmonitor
      1        ONLINE  ONLINE       pdb1
ora.ctssd
      1        ONLINE  ONLINE       pdb1                     ACTIVE:0
ora.diskmon
      1        OFFLINE OFFLINE
ora.evmd
      1        ONLINE  ONLINE       pdb1
ora.gipcd
      1        ONLINE  ONLINE       pdb1
ora.gpnpd
      1        ONLINE  ONLINE       pdb1
ora.mdnsd
      1        ONLINE  ONLINE       pdb1
*/

-- Step 106 -->> On Node 2
[root@pdb2 ~]# cd /opt/app/11.2.0.3.0/grid/bin
[root@pdb2 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdb2                     Started
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       pdb2
ora.crf
      1        ONLINE  ONLINE       pdb2
ora.crsd
      1        ONLINE  ONLINE       pdb2
ora.cssd
      1        ONLINE  ONLINE       pdb2
ora.cssdmonitor
      1        ONLINE  ONLINE       pdb2
ora.ctssd
      1        ONLINE  ONLINE       pdb2                     ACTIVE:0
ora.diskmon
      1        OFFLINE OFFLINE
ora.evmd
      1        ONLINE  ONLINE       pdb2
ora.gipcd
      1        ONLINE  ONLINE       pdb2
ora.gpnpd
      1        ONLINE  ONLINE       pdb2
ora.mdnsd
      1        ONLINE  ONLINE       pdb2
*/

-- Step 107 -->> On Both Nodes
[root@pdb1/pdb2 ~]# cd /opt/app/11.2.0.3.0/grid/bin
[root@pdb1/pdb2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.ARC.dg
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
ora.DATA.dg
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
ora.LISTENER.lsnr
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
ora.OCR.dg
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
ora.asm
               ONLINE  ONLINE       pdb1                     Started
               ONLINE  ONLINE       pdb2                     Started
ora.gsd
               OFFLINE OFFLINE      pdb1
               OFFLINE OFFLINE      pdb2
ora.net1.network
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
ora.ons
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdb2
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdb1
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       pdb1
ora.cvu
      1        ONLINE  ONLINE       pdb1
ora.oc4j
      1        ONLINE  ONLINE       pdb1
ora.pdb1.vip
      1        ONLINE  ONLINE       pdb1
ora.pdb2.vip
      1        ONLINE  ONLINE       pdb2
ora.pdbdb.db
      1        ONLINE  ONLINE       pdb1                     Open
      2        ONLINE  ONLINE       pdb2                     Open
ora.scan1.vip
      1        ONLINE  ONLINE       pdb2
ora.scan2.vip
      1        ONLINE  ONLINE       pdb1
ora.scan3.vip
      1        ONLINE  ONLINE       pdb1
*/

-- Step 108 -->> On Both Nodes
[root@pdb1/pdb2 ~]# cd /opt/app/11.2.0.3.0/grid/bin
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

-- Step 109 -->> On Both Nodes
-- ASM Verification
[root@pdb1/pdb2 ~]# su - grid
[grid@pdb1/pdb2 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512   4096  1048576    409594   409496                0          409496              0             N  ARC/
MOUNTED  EXTERN  N         512   4096  1048576    204797   203062                0          203062              0             N  DATA/
MOUNTED  EXTERN  N         512   4096  4194304     20472    20040                0           20040              0             Y  OCR/
ASMCMD [+] > exit

*/

-- Step 110 -->> On Node 1
[grid@pdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 27-JUN-2025 14:39:42

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                27-JUN-2025 14:34:13
Uptime                    0 days 0 hr. 5 min. 28 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.21)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.23)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 111 -->> On Node 2
[grid@pdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 27-JUN-2025 14:39:42

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                27-JUN-2025 14:34:17
Uptime                    0 days 0 hr. 5 min. 25 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.22)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.24)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 112 -->> On Node 1
[grid@pdb1 ~]$ ps -ef | grep SCAN
/*
grid     27773     1  0 14:34 ?        00:00:00 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN2 -inherit
grid     27778     1  0 14:34 ?        00:00:00 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN3 -inherit
grid     28490 28407  0 14:40 pts/0    00:00:00 grep SCAN
*/

-- Step 112.1 -->> On Node 1
[grid@pdb1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 27-JUN-2025 14:40:34

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                27-JUN-2025 14:34:13
Uptime                    0 days 0 hr. 6 min. 21 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/11.2.0.3.0/grid/log/diag/tnslsnr/pdb1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.26)(PORT=1521)))
Services Summary...
Service "pdbdb" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 112.2 -->> On Node 1
[grid@pdb1 ~]$ lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 27-JUN-2025 14:40:47

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                27-JUN-2025 14:34:13
Uptime                    0 days 0 hr. 6 min. 34 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/11.2.0.3.0/grid/log/diag/tnslsnr/pdb1/listener_scan3/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN3)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.27)(PORT=1521)))
Services Summary...
Service "pdbdb" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 113 -->> On Node 2
[grid@pdb2 ~]$ ps -ef | grep SCAN
/*
grid     22386     1  0 14:34 ?        00:00:00 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN1 -inherit
grid     22771 22696  0 14:40 pts/0    00:00:00 grep SCAN
*/

-- Step 113.1 -->> On Node 2
[grid@pdb2 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 27-JUN-2025 14:41:14

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                27-JUN-2025 14:34:47
Uptime                    0 days 0 hr. 6 min. 26 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/11.2.0.3.0/grid/log/diag/tnslsnr/pdb2/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.25)(PORT=1521)))
Services Summary...
Service "pdbdb" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/


-- Step 114 -->> On Both Nodes
[grid@pdb1/pdb2 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 11.2.0.3.0 Production on Fri Jun 27 14:41:28 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Real Application Clusters and Automatic Storage Management options

SQL> set lines 200;
SQL> SELECT * FROM gv$version;

   INST_ID BANNER
---------- --------------------------------------------------------------------------------
         2 Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
         2 PL/SQL Release 11.2.0.3.0 - Production
         2 CORE 11.2.0.3.0      Production
         2 TNS for Linux: Version 11.2.0.3.0 - Production
         2 NLSRTL Version 11.2.0.3.0 - Production
         1 Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
         1 PL/SQL Release 11.2.0.3.0 - Production
         1 CORE 11.2.0.3.0      Production
         1 TNS for Linux: Version 11.2.0.3.0 - Production
         1 NLSRTL Version 11.2.0.3.0 - Production

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Real Application Clusters and Automatic Storage Management options
*/

-- Step 115 -->> On Both Nodes
-- DB Service Verification
[root@pdb1/pdb2 ~]# su - oracle
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 116 -->> On Both Nodes
-- Listener Service Verification
[oracle@pdb1/pdb2 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): pdb2,pdb1
*/

-- Step 117 -->> On Both Nodes
[oracle@pdb1/pdb2 ~]$ rman target sys/Sys605014@pdbdb
--OR--
[oracle@pdb1/pdb2 ~]$ rman target /
/*
Recovery Manager: Release 11.2.0.3.0 - Production on Fri Jun 27 14:43:47 2025

Copyright (c) 1982, 2011, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB (DBID=3262924656)

RMAN> show all;

using target database control file instead of recovery catalog
RMAN configuration parameters for database with db_unique_name PDBDB are:
CONFIGURE RETENTION POLICY TO REDUNDANCY 1; # default
CONFIGURE BACKUP OPTIMIZATION OFF; # default
CONFIGURE DEFAULT DEVICE TYPE TO DISK; # default
CONFIGURE CONTROLFILE AUTOBACKUP OFF; # default
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '%F'; # default
CONFIGURE DEVICE TYPE DISK PARALLELISM 1 BACKUP TYPE TO BACKUPSET; # default
CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE MAXSETSIZE TO UNLIMITED; # default
CONFIGURE ENCRYPTION FOR DATABASE OFF; # default
CONFIGURE ENCRYPTION ALGORITHM 'AES128'; # default
CONFIGURE COMPRESSION ALGORITHM 'BASIC' AS OF RELEASE 'DEFAULT' OPTIMIZE FOR LOAD TRUE ; # default
CONFIGURE ARCHIVELOG DELETION POLICY TO NONE; # default
--Node 1
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/product/11.2.0.3.0/db_1/dbs/snapcf_pdbdb1.f'; # default
--Node 2
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/product/11.2.0.3.0/db_1/dbs/snapcf_pdbdb2.f'; # default

RMAN> exit

Recovery Manager complete.
*/

-- Step 118 -->> On Both Nodes
-- To connnect DB using TNS
[oracle@pdb1/pdb2 ~]$ sqlplus sys/Sys605014@pdbdb as sysdba

-- Step 119 -->> On Node 1
[oracle@pdb1 ~]$ sqlplus sys/Sys605014@pdbdb1 as sysdba

-- Step 120 -->> On Node 2
[oracle@pdb2 ~]$ sqlplus sys/Sys605014@pdbdb2 as sysdba

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
--------------------------Oracle Patch for ORA-00976:CONNECT BY PRIOR----------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-- To apply the Oracle 11.2.0.3.0 patchset to, a query having "CONNECT BY PRIOR" clause started to fail with:
-- ORA-00976: Specified pseudo column or operator not allowed here

--Step 1:
[oracle@pdb1 ~]$ /opt/app/oracle/product/11.2.0.3.0/db_1/OPatch/opatch lsinventory
/*
Invoking OPatch 11.2.0.1.7

Oracle Interim Patch Installer version 11.2.0.1.7
Copyright (c) 2011, Oracle Corporation.  All rights reserved.


Oracle Home       : /opt/app/oracle/product/11.2.0.3.0/db_1
Central Inventory : /opt/app/oraInventory
   from           : /etc/oraInst.loc
OPatch version    : 11.2.0.1.7
OUI version       : 11.2.0.3.0
Log file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/opatch2025-06-27_14-46-48PM.log

Lsinventory Output file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/lsinv/lsinventory2025-06-27_14-46-48PM.txt

--------------------------------------------------------------------------------
Installed Top-level Products (1):

Oracle Database 11g                                                  11.2.0.3.0
There are 1 products installed in this Oracle Home.


There are no Interim patches installed in this Oracle Home.


Rac system comprising of multiple nodes
  Local node = pdb1
  Remote node = pdb2

--------------------------------------------------------------------------------

OPatch succeeded.
*/

--Step 2:
[oracle@pdb2 ~]$ /opt/app/oracle/product/11.2.0.3.0/db_1/OPatch/opatch lsinventory
/*
Invoking OPatch 11.2.0.1.7

Oracle Interim Patch Installer version 11.2.0.1.7
Copyright (c) 2011, Oracle Corporation.  All rights reserved.


Oracle Home       : /opt/app/oracle/product/11.2.0.3.0/db_1
Central Inventory : /opt/app/oraInventory
   from           : /etc/oraInst.loc
OPatch version    : 11.2.0.1.7
OUI version       : 11.2.0.3.0
Log file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/opatch2025-06-27_14-46-59PM.log

Lsinventory Output file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/lsinv/lsinventory2025-06-27_14-46-59PM.txt

--------------------------------------------------------------------------------
Installed Top-level Products (1):

Oracle Database 11g                                                  11.2.0.3.0
There are 1 products installed in this Oracle Home.


There are no Interim patches installed in this Oracle Home.


Rac system comprising of multiple nodes
  Local node = pdb2
  Remote node = pdb1

--------------------------------------------------------------------------------

OPatch succeeded.
*/

Step 3:
[oracle@pdb1 ~]$ /opt/app/oracle/product/11.2.0.3.0/db_1/OPatch/opatch version
/*
Invoking OPatch 11.2.0.1.7

OPatch Version: 11.2.0.1.7

OPatch succeeded.
*/

[oracle@pdb2 ~]$ /opt/app/oracle/product/11.2.0.3.0/db_1/OPatch/opatch version
/*
Invoking OPatch 11.2.0.1.7

OPatch Version: 11.2.0.1.7

OPatch succeeded.
*/

--Step 4:
[oracle@pdb1 ~]$ srvctl stop database -d pdbdb
[oracle@pdb1 ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is not running on node pdb1
Instance pdbdb2 is not running on node pdb2
*/

--Step 5:
[oracle@pdb1 ~]$ cd /tmp/
[oracle@pdb1 tmp]$ unzip p14230270_112030_Linux-x86-64.zip
[oracle@pdb1 tmp]$ chmod -R 775 14230270
[oracle@pdb1 tmp]$ ls -ltr | grep 14230270
/*
drwxrwxr-x  5 oracle oinstall   4096 Aug  8  2012 14230270
-rwxrwxr-x  1 oracle oinstall 216691 Feb 19  2021 p14230270_112030_Linux-x86-64.zip
*/

--Step 6:
-- To applying the Oracle PSU
[oracle@pdb1 tmp]$ export ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1
[oracle@pdb1 tmp]$ export PATH=${ORACLE_HOME}/bin:$PATH
[oracle@pdb1 tmp]$ export PATH=${PATH}:${ORACLE_HOME}/OPatch
[oracle@pdb1 tmp]$ which opatch
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/OPatch/opatch
*/

--Step 7:
[oracle@pdb1 tmp]$ cd 14230270/
[oracle@pdb1 14230270]$ /opt/app/oracle/product/11.2.0.3.0/db_1/OPatch/opatch apply
/*
Invoking OPatch 11.2.0.1.7

Oracle Interim Patch Installer version 11.2.0.1.7
Copyright (c) 2011, Oracle Corporation.  All rights reserved.


Oracle Home       : /opt/app/oracle/product/11.2.0.3.0/db_1
Central Inventory : /opt/app/oraInventory
   from           : /etc/oraInst.loc
OPatch version    : 11.2.0.1.7
OUI version       : 11.2.0.3.0
Log file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/opatch2025-06-27_15-01-13PM.log

Applying interim patch '14230270' to OH '/opt/app/oracle/product/11.2.0.3.0/db_1'
Verifying environment and performing prerequisite checks...

Do you want to proceed? [y|n]
y
User Responded with: Y
All checks passed.

This node is part of an Oracle Real Application Cluster.
Remote nodes: 'pdb2'
Local node: 'pdb1'
Please shutdown Oracle instances running out of this ORACLE_HOME on the local system.
(Oracle Home = '/opt/app/oracle/product/11.2.0.3.0/db_1')


Is the local system ready for patching? [y|n]
y
User Responded with: Y
Backing up files...

Patching component oracle.rdbms, 11.2.0.3.0...

Patching component oracle.rdbms.rsf, 11.2.0.3.0...

The local system has been patched.  You can restart Oracle instances on it.


Patching in rolling mode.


The node 'pdb2' will be patched next.


Please shutdown Oracle instances running out of this ORACLE_HOME on 'pdb2'.
(Oracle Home = '/opt/app/oracle/product/11.2.0.3.0/db_1')

Is the node ready for patching? [y|n]
y
User Responded with: Y
Updating nodes 'pdb2'
   Apply-related files are:
     FP = "/opt/app/oracle/product/11.2.0.3.0/db_1/.patch_storage/14230270_Aug_7_2012_22_20_10/rac/copy_files.txt"
     DP = "/opt/app/oracle/product/11.2.0.3.0/db_1/.patch_storage/14230270_Aug_7_2012_22_20_10/rac/copy_dirs.txt"
     MP = "/opt/app/oracle/product/11.2.0.3.0/db_1/.patch_storage/14230270_Aug_7_2012_22_20_10/rac/make_cmds.txt"
     RC = "/opt/app/oracle/product/11.2.0.3.0/db_1/.patch_storage/14230270_Aug_7_2012_22_20_10/rac/remote_cmds.txt"

Instantiating the file "/opt/app/oracle/product/11.2.0.3.0/db_1/.patch_storage/14230270_Aug_7_2012_22_20_10/rac/copy_files.txt.instantiated" by replacing $ORACLE_HOME in "/opt/app/oracle/product/11.2.0.3.0/db_1/.patch_storage/14230270_Aug_7_2012_22_20_10/rac/copy_files.txt" with actual path.
Propagating files to remote nodes...
Instantiating the file "/opt/app/oracle/product/11.2.0.3.0/db_1/.patch_storage/14230270_Aug_7_2012_22_20_10/rac/copy_dirs.txt.instantiated" by replacing $ORACLE_HOME in "/opt/app/oracle/product/11.2.0.3.0/db_1/.patch_storage/14230270_Aug_7_2012_22_20_10/rac/copy_dirs.txt" with actual path.
Propagating directories to remote nodes...
Instantiating the file "/opt/app/oracle/product/11.2.0.3.0/db_1/.patch_storage/14230270_Aug_7_2012_22_20_10/rac/make_cmds.txt.instantiated" by replacing $ORACLE_HOME in "/opt/app/oracle/product/11.2.0.3.0/db_1/.patch_storage/14230270_Aug_7_2012_22_20_10/rac/make_cmds.txt" with actual path.
Running command on remote node 'pdb2':
cd /opt/app/oracle/product/11.2.0.3.0/db_1/rdbms/lib; /usr/bin/make -f ins_rdbms.mk irenamedg ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1 || echo REMOTE_MAKE_FAILED::>&2

Running command on remote node 'pdb2':
cd /opt/app/oracle/product/11.2.0.3.0/db_1/rdbms/lib; /usr/bin/make -f ins_rdbms.mk ioracle ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1 || echo REMOTE_MAKE_FAILED::>&2

Running command on remote node 'pdb2':
cd /opt/app/oracle/product/11.2.0.3.0/db_1/rdbms/lib; /usr/bin/make -f ins_rdbms.mk client_sharedlib ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1 || echo REMOTE_MAKE_FAILED::>&2

Running command on remote node 'pdb2':
cd /opt/app/oracle/product/11.2.0.3.0/db_1/network/lib; /usr/bin/make -f ins_net_client.mk client_sharedlib ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1 || echo REMOTE_MAKE_FAILED::>&2


The node 'pdb2' has been patched.  You can restart Oracle instances on it.

There were relinks on remote nodes.  Remember to check the binary size and timestamp on the nodes 'pdb2' .
The following make commands were invoked on remote nodes:
'cd /opt/app/oracle/product/11.2.0.3.0/db_1/rdbms/lib; /usr/bin/make -f ins_rdbms.mk irenamedg ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1
cd /opt/app/oracle/product/11.2.0.3.0/db_1/rdbms/lib; /usr/bin/make -f ins_rdbms.mk ioracle ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1
cd /opt/app/oracle/product/11.2.0.3.0/db_1/rdbms/lib; /usr/bin/make -f ins_rdbms.mk client_sharedlib ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1
cd /opt/app/oracle/product/11.2.0.3.0/db_1/network/lib; /usr/bin/make -f ins_net_client.mk client_sharedlib ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1
'

Patch 14230270 successfully applied
Log file location: /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/opatch2025-06-27_15-01-13PM.log

OPatch succeeded.
*/

--Step 8:
[oracle@pdb1 14230270]$ /opt/app/oracle/product/11.2.0.3.0/db_1/OPatch/opatch lsinventory
/*
Invoking OPatch 11.2.0.1.7

Oracle Interim Patch Installer version 11.2.0.1.7
Copyright (c) 2011, Oracle Corporation.  All rights reserved.


Oracle Home       : /opt/app/oracle/product/11.2.0.3.0/db_1
Central Inventory : /opt/app/oraInventory
   from           : /etc/oraInst.loc
OPatch version    : 11.2.0.1.7
OUI version       : 11.2.0.3.0
Log file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/opatch2025-06-27_15-02-30PM.log

Lsinventory Output file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/lsinv/lsinventory2025-06-27_15-02-30PM.txt

--------------------------------------------------------------------------------
Installed Top-level Products (1):

Oracle Database 11g                                                  11.2.0.3.0
There are 1 products installed in this Oracle Home.


Interim patches (1) :

Patch  14230270     : applied on Fri Jun 27 15:01:40 NPT 2025
Unique Patch ID:  15357561
   Created on 7 Aug 2012, 22:20:10 hrs PST8PDT
   Bugs fixed:
     14230270



Rac system comprising of multiple nodes
  Local node = pdb1
  Remote node = pdb2

--------------------------------------------------------------------------------

OPatch succeeded.
*/

--Step 9:
[oracle@pdb2 ~]$ /opt/app/oracle/product/11.2.0.3.0/db_1/OPatch/opatch lsinventory
/*
Invoking OPatch 11.2.0.1.7

Oracle Interim Patch Installer version 11.2.0.1.7
Copyright (c) 2011, Oracle Corporation.  All rights reserved.


Oracle Home       : /opt/app/oracle/product/11.2.0.3.0/db_1
Central Inventory : /opt/app/oraInventory
   from           : /etc/oraInst.loc
OPatch version    : 11.2.0.1.7
OUI version       : 11.2.0.3.0
Log file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/opatch2025-06-27_15-03-03PM.log

Lsinventory Output file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/lsinv/lsinventory2025-06-27_15-03-03PM.txt

--------------------------------------------------------------------------------
Installed Top-level Products (1):

Oracle Database 11g                                                  11.2.0.3.0
There are 1 products installed in this Oracle Home.


Interim patches (1) :

Patch  14230270     : applied on Fri Jun 27 15:01:40 NPT 2025
Unique Patch ID:  15357561
   Created on 7 Aug 2012, 22:20:10 hrs PST8PDT
   Bugs fixed:
     14230270



Rac system comprising of multiple nodes
  Local node = pdb2
  Remote node = pdb1

--------------------------------------------------------------------------------

OPatch succeeded.
*/

--Step 10:
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is not running on node pdb1
Instance pdbdb2 is not running on node pdb2
*/

--Step 11:
[oracle@pdb1 ~]$ srvctl start database -d pdbdb
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is running on node pdb1
Instance pdbdb2 is running on node pdb2
*/

--Step 12:
[oracle@pdb1/pdb2 ~]$  srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

--Step 13:
[oracle@pdb1/pdb2 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): pdb1,pdb2
*/