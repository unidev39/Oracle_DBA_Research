----------------------------------------------------------------
-------------Two Node rac Setup on VM Workstation---------------
----------------------------------------------------------------
-- Step 0 -->> 2 Node rac on VM -->> On both Node
--For OS Oracle Linux 6.10 => boot OracleLinux-R6-U10-Server-x86_64-dvd.iso 

-- Step 0.0 -->>  2 Node rac on VM -->> On both Node
[root@pdbdr1/pdbdr2 ~]# df -Th
/*
Filesystem     Type     Size  Used Avail Use% Mounted on
/dev/sda2      ext4      69G  1.1G   65G   2% /
tmpfs          tmpfs    9.7G   76K  9.7G   1% /dev/shm
/dev/sda1      ext4     2.0G  157M  1.7G   9% /boot
/dev/sda6      ext4      15G   38M   14G   1% /home
/dev/sda3      ext4      57G   52M   54G   1% /opt
/dev/sda7      ext4      15G   38M   14G   1% /tmp
/dev/sda8      ext4      15G  5.9G  8.0G  43% /usr
/dev/sda9      ext4      15G  1.9G   13G  14% /var
/dev/sr0       iso9660  3.8G  3.8G     0 100% /media/OL6.10 x86_64 Disc 1 20180625
*/

-- Step 1 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.168.16.48   pdbdr1.unidev.org.np        pdbdr1
192.168.16.49   pdbdr2.unidev.org.np        pdbdr2

# Private
10.10.10.48     pdbdr1-priv.unidev.org.np   pdbdr1-priv
10.10.10.49     pdbdr2-priv.unidev.org.np   pdbdr2-priv

# Virtual
192.168.16.50   pdbdr1-vip.unidev.org.np    pdbdr1-vip
192.168.16.51   pdbdr2-vip.unidev.org.np    pdbdr2-vip

# SCAN
192.168.16.52   pdbdr-scan.unidev.org.np    pdbdr-scan
192.168.16.53   pdbdr-scan.unidev.org.np    pdbdr-scan
192.168.16.54   pdbdr-scan.unidev.org.np    pdbdr-scan
*/

-- Step 2 -->> On both Node
-- Disable secure linux by editing the "/etc/selinux/config" file, making sure the SELINUX flag is set as follows.
[root@pdbdr1/pdbdr2 ~]# vi /etc/selinux/config
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
[root@pdbdr1 ~]# vi /etc/sysconfig/network
/*
NETWORKING=yes
HOSTNAME=pdbdr1.unidev.org.np
*/

-- Step 4 -->> On Node 2
[root@pdbdr2 ~]# vi /etc/sysconfig/network
/*
NETWORKING=yes
HOSTNAME=pdbdr2.unidev.org.np
*/

-- Step 5 -->> On Node 1
[root@pdbdr1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth0 
/*
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.16.48
NETMASK=255.255.255.0
GATEWAY=192.168.16.1
DNS1=192.168.16.11
DNS2=192.168.16.12
*/

-- Step 6 -->> On Node 1
[root@pdbdr1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth1
/*
DEVICE=eth1
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=10.10.10.48
NETMASK=255.255.255.0
*/

-- Step 7 -->> On Node 2
[root@pdbdr2 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth0 
/*
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.16.49
NETMASK=255.255.255.0
GATEWAY=192.168.16.1
DNS1=192.168.16.11
DNS2=192.168.16.12
*/

-- Step 8 -->> On Node 2
[root@pdbdr2 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth1
/*
DEVICE=eth1
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=10.10.10.49
NETMASK=255.255.255.0
*/

-- Step 9 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# service network restart
[root@pdbdr1/pdbdr2 ~]# service NetworkManager stop
[root@pdbdr1/pdbdr2 ~]# service network restart

-- Step 10 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# yum repolist
/*
Loaded plugins: refresh-packagekit, security, ulninfo
repo id                                                repo name                                                              status
public_ol6_UEKR4                                       Latest Unbreakable Enterprise Kernel Release 4 for Oracle Linux 6Ser      191
public_ol6_latest                                      Oracle Linux 6Server Latest (x86_64)                                   12,932
repolist: 13,123
*/

-- Step 10.1 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# uname -a
/*
Linux pdbdr1.unidev.org.np 4.1.12-124.48.6.el6uek.x86_64 #2 SMP Tue Mar 16 15:39:03 PDT 2021 x86_64 x86_64 x86_64 GNU/Linux
*/

-- Step 10.2 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# uname -r
/*
4.1.12-124.48.6.el6uek.x86_64
*/

-- Step 10.3 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# grubby --info=ALL | grep ^kernel
/*
kernel=/vmlinuz-4.1.12-124.48.6.el6uek.x86_64
kernel=/vmlinuz-2.6.32-754.35.1.el6.x86_64
kernel=/vmlinuz-4.1.12-124.16.4.el6uek.x86_64
kernel=/vmlinuz-2.6.32-754.el6.x86_64
*/

-- Step 10.3.1 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# grubby --default-kernel
/*
/boot/vmlinuz-4.1.12-124.48.6.el6uek.x86_64
*/

-- Step 10.4 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# chkconfig --list iptables
/*
iptables  0:off    1:off    2:on    3:on    4:on    5:on    6:off
*/

-- Step 11 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# service iptables stop
/*
iptables: Setting chains to policy ACCEPT: nat mangle filte[  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
*/

-- Step 11.1 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# chkconfig iptables off
[root@pdbdr1/pdbdr2 ~]# iptables -F
[root@pdbdr1/pdbdr2 ~]# service iptables save
/*
iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]
*/

-- Step 11.2 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# /etc/init.d/iptables stop
/*
iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
*/

-- Step 12.1 -->> On Node 1
[root@pdbdr1/pdbdr2 ~]# chkconfig --list iptables
/*
iptables   0:off    1:off    2:off    3:off    4:off    5:off    6:off
*/ 

-- Step 13 -->> On Node 2
[root@pdbdr1/pdbdr2 ~]# service ntpd stop
/*
Shutting down ntpd:                                        [FAILED]
*/

-- Step 13.1 -->> On Node 2
[root@pdbdr1/pdbdr2 ~]# service ntpd status
/*
ntpd is stopped
*/

-- Step 14.1 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# chkconfig ntpd off

-- Step 14.1 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# mv /etc/ntp.conf /etc/ntp.conf.backup
[root@pdbdr1/pdbdr2 ~]# rm -rf /etc/ntp.conf
[root@pdbdr1/pdbdr2 ~]# rm -rf /var/run/ntpd.pid

-- Step 15 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# iptables -F
[root@pdbdr1/pdbdr2 ~]# iptables -X
[root@pdbdr1/pdbdr2 ~]# iptables -t nat -F
[root@pdbdr1/pdbdr2 ~]# iptables -t nat -X
[root@pdbdr1/pdbdr2 ~]# iptables -t mangle -F
[root@pdbdr1/pdbdr2 ~]# iptables -t mangle -X
[root@pdbdr1/pdbdr2 ~]# iptables -P INPUT ACCEPT
[root@pdbdr1/pdbdr2 ~]# iptables -P FORWARD ACCEPT
[root@pdbdr1/pdbdr2 ~]# iptables -P OUTPUT ACCEPT
[root@pdbdr1/pdbdr2 ~]# iptables -L -nv
/*
Chain INPUT (policy ACCEPT 2 packets, 80 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 2 packets, 256 bytes)
 pkts bytes target     prot opt in     out     source               destination
*/

-- Step 16 -->> On Both Node
[root@pdbdr1/pdbdr2 ~ ]# brctl show
/*
bridge name     bridge id               STP enabled     interfaces
virbr0          8000.525400329238       yes             virbr0-nic
*/

-- Step 17 -->> On Both Node
[root@pdbdr1/pdbdr2 ~ ]# virsh net-list
/*
Name                 State      Autostart     Persistent
--------------------------------------------------
default              active     yes           yes
*/

-- Step 17.1 -->> On Both Node
[root@pdbdr1/pdbdr2 ~ ]# service libvirtd stop
/*
Stopping libvirtd daemon:                                  [  OK  ]
*/

-- Step 17.2 -->> On Both Node
[root@pdbdr1/pdbdr2 ~ ]# chkconfig --list | grep libvirtd
/*
libvirtd        0:off   1:off   2:off   3:on    4:on    5:on    6:off
*/

-- Step 17.3 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# chkconfig libvirtd off
[root@pdbdr1/pdbdr2 ~]# ip link set lxcbr0 down
[root@pdbdr1/pdbdr2 ~]# brctl delbr lxcbr0
[root@pdbdr1/pdbdr2 ~]# brctl show

-- Step 17.4 -->> On Node One
[root@pdb1 ~]# ifconfig
/*
eth0      Link encap:Ethernet  HWaddr 00:0C:29:56:21:D9
          inet addr:192.168.16.48  Bcast:192.168.16.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fe56:21d9/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:438 errors:0 dropped:52 overruns:0 frame:0
          TX packets:360 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:48737 (47.5 KiB)  TX bytes:54153 (52.8 KiB)

eth1      Link encap:Ethernet  HWaddr 00:0C:29:56:21:E3
          inet addr:10.10.10.48  Bcast:10.10.10.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fe56:21e3/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:89 errors:0 dropped:47 overruns:0 frame:0
          TX packets:18 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:5523 (5.3 KiB)  TX bytes:1164 (1.1 KiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:16 errors:0 dropped:0 overruns:0 frame:0
          TX packets:16 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:960 (960.0 b)  TX bytes:960 (960.0 b)

virbr0    Link encap:Ethernet  HWaddr 52:54:00:32:92:38
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
eth0      Link encap:Ethernet  HWaddr 00:0C:29:F4:D1:B6
          inet addr:192.168.16.49  Bcast:192.168.16.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fef4:d1b6/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:443 errors:0 dropped:45 overruns:0 frame:0
          TX packets:397 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:48973 (47.8 KiB)  TX bytes:57839 (56.4 KiB)

eth1      Link encap:Ethernet  HWaddr 00:0C:29:F4:D1:C0
          inet addr:10.10.10.49  Bcast:10.10.10.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fef4:d1c0/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:68 errors:0 dropped:38 overruns:0 frame:0
          TX packets:18 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:4263 (4.1 KiB)  TX bytes:1164 (1.1 KiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:16 errors:0 dropped:0 overruns:0 frame:0
          TX packets:16 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:960 (960.0 b)  TX bytes:960 (960.0 b)

virbr0    Link encap:Ethernet  HWaddr 52:54:00:20:83:E9
          inet addr:192.168.122.1  Bcast:192.168.122.255  Mask:255.255.255.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
*/
-- Step 17.6 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# init 6


-- Step 17.7 -->> On Node One
[root@pdb1 ~]# ifconfig
/*
eth0      Link encap:Ethernet  HWaddr 00:0C:29:56:21:D9
          inet addr:192.168.16.48  Bcast:192.168.16.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fe56:21d9/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:331231 errors:0 dropped:31 overruns:0 frame:0
          TX packets:179623 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:499115165 (475.9 MiB)  TX bytes:11285814 (10.7 MiB)

eth1      Link encap:Ethernet  HWaddr 00:0C:29:56:21:E3
          inet addr:10.10.10.48  Bcast:10.10.10.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fe56:21e3/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:55 errors:0 dropped:25 overruns:0 frame:0
          TX packets:18 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:3300 (3.2 KiB)  TX bytes:1164 (1.1 KiB)

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
eth0      Link encap:Ethernet  HWaddr 00:0C:29:F4:D1:B6
          inet addr:192.168.16.49  Bcast:192.168.16.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fef4:d1b6/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:1493 errors:0 dropped:27 overruns:0 frame:0
          TX packets:837 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1972656 (1.8 MiB)  TX bytes:74346 (72.6 KiB)

eth1      Link encap:Ethernet  HWaddr 00:0C:29:F4:D1:C0
          inet addr:10.10.10.49  Bcast:10.10.10.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fef4:d1c0/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:39 errors:0 dropped:18 overruns:0 frame:0
          TX packets:18 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:2340 (2.2 KiB)  TX bytes:1164 (1.1 KiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:16 errors:0 dropped:0 overruns:0 frame:0
          TX packets:16 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:960 (960.0 b)  TX bytes:960 (960.0 b)
*/

-- Step 18 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# brctl show
/*
bridge name     bridge id               STP enabled     interfaces
*/

-- Step 19 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# chkconfig --list | grep libvirtd
/*
libvirtd        0:off   1:off   2:off   3:off   4:off   5:off   6:off
*/


-- Step 20 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# chkconfig --list iptables
/*
iptables        0:off   1:off   2:off   3:off   4:off   5:off   6:off
*/

-- Step 21 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# chkconfig --list ntpd
/*
ntpd            0:off   1:off   2:off   3:off   4:off   5:off   6:off
*/

-- Step 22 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/resolv.conf
/*
# Generated by NetworkManager
search cibnepal.org.np
nameserver 192.168.16.11
nameserver 192.168.16.12
*/

-- Step 31.1 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup 192.168.16.48
/*
Server:         192.168.16.11
Address:        192.168.16.11#53

48.6.16.172.in-addr.arpa        name = pdbdr1.unidev.org.np.
*/

-- Step 31.2 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup 192.168.16.49
/*
Server:         192.168.16.11
Address:        192.168.16.11#53

49.6.16.172.in-addr.arpa        name = pdbdr2.unidev.org.np.
*/

-- Step 31.3 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup pdbdr1
/*
Server:         192.168.16.11
Address:        192.168.16.11#53

Name:   pdbdr1.unidev.org.np
Address: 192.168.16.48
*/

-- Step 31.4 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup pdbdr2
/*
Server:         192.168.16.11
Address:        192.168.16.11#53

Name:   pdbdr2.unidev.org.np
Address: 192.168.16.49
*/

-- Step 31.5 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup pdbdr-scan
/*
Server:         192.168.16.11
Address:        192.168.16.11#53

Name:   pdbdr-scan.unidev.org.np
Address: 192.168.16.54
Name:   pdbdr-scan.unidev.org.np
Address: 192.168.16.52
Name:   pdbdr-scan.unidev.org.np
Address: 192.168.16.53
*/

-- Step 31.6 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup pdbdr2-vip
/*
Server:         192.168.16.11
Address:        192.168.16.11#53

Name:   pdbdr2-vip.unidev.org.np
Address: 192.168.16.51
*/

-- Step 31.7 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup pdbdr1-vip
/*
Server:         192.168.16.11
Address:        192.168.16.11#53

Name:   pdbdr1-vip.unidev.org.np
Address: 192.168.16.50
*/

-- Step 31.8 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# iptables -L -nv
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
[root@pdbdr1/pdbdr2 ~]# cd /media/OL6.10\ x86_64\ Disc\ 1\ 20180625/Server/Packages/
[root@pdbdr1/pdbdr2 Packages]# yum -y install oracle-rdbms-server-11gR2-preinstall
[root@pdbdr1/pdbdr2 Packages]# yum -y update

-- Step 23.1 -->> On Both Node
[root@pdbdr1/pdbdr2 Packages]# yum install -y yum-utils
[root@pdbdr1/pdbdr2 Packages]# yum install -y zip unzip

-- Step 23.2 -->> On Both Node
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh binutils-2*x86_64*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh glibc-2*x86_64* nss-softokn-freebl-3*x86_64*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh glibc-2*i686* nss-softokn-freebl-3*i686*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh compat-libstdc++-33*x86_64*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh glibc-common-2*x86_64*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh glibc-devel-2*x86_64*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh glibc-devel-2*i686*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh glibc-headers-2*x86_64*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh elfutils-libelf-0*x86_64*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh elfutils-libelf-devel-0*x86_64*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh gcc-4*x86_64*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh gcc-c++-4*x86_64*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh ksh-*x86_64*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh libaio-0*x86_64*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh libaio-devel-0*x86_64*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh libaio-0*i686*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh libaio-devel-0*i686*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh libgcc-4*x86_64*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh libgcc-4*i686*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh libstdc++-4*x86_64*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh libstdc++-4*i686*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh libstdc++-devel-4*x86_64*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh make-3.81*x86_64*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh numactl-devel-2*x86_64*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh sysstat-9*x86_64*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh compat-libstdc++-33*i686*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh compat-libcap*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh libaio-devel-0.*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh ksh-2*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh libstdc++-4.*.i686*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh elfutils-libelf-0*i686* elfutils-libelf-devel-0*i686*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh libtool-ltdl*i686*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh ncurses*i686*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh readline*i686*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh unixODBC*
[root@pdbdr1/pdbdr2 Packages]# rpm -iUvh oracleasm*.rpm
[root@pdbdr1/pdbdr2 Packages]# yum -y update

-- Step 23.3 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# cd /root/Oracle_Linux_6_Rpm/
[root@pdbdr1/pdbdr2 Oracle_Linux_6_Rpm]# rpm -iUvh --nodeps --force dtrace-utils-1.0.0-8.el6.x86_64.rpm
[root@pdbdr1/pdbdr2 Oracle_Linux_6_Rpm]# rpm -iUvh --nodeps --force dtrace-utils-devel-1.0.0-8.el6.x86_64.rpm
[root@pdbdr1/pdbdr2 Oracle_Linux_6_Rpm]# rpm -iUvh --nodeps --force dtrace-utils-testsuite-1.0.0-8.el6.x86_64.rpm
[root@pdbdr1/pdbdr2 Oracle_Linux_6_Rpm]# rpm -iUvh elfutils-libelf-devel-static-0.164-2.el6.x86_64.rpm
[root@pdbdr1/pdbdr2 Oracle_Linux_6_Rpm]# rpm -iUvh libdtrace-ctf-0.8.0-1.el6.x86_64.rpm
[root@pdbdr1/pdbdr2 Oracle_Linux_6_Rpm]# rpm -iUvh libdtrace-ctf-devel-0.8.0-1.el6.x86_64.rpm
[root@pdbdr1/pdbdr2 Oracle_Linux_6_Rpm]# rpm -iUvh numactl-2.0.9-2.el6.i686.rpm
[root@pdbdr1/pdbdr2 Oracle_Linux_6_Rpm]# rpm -iUvh numactl-devel-2.0.9-2.el6.i686.rpm
[root@pdbdr1/pdbdr2 Oracle_Linux_6_Rpm]# rpm -iUvh --nodeps --force unixODBC-devel-2.2.14-12.el6_3.x86_64.rpm

-- Step 23.4 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# cd /media/OL6.10\ x86_64\ Disc\ 1\ 20180625/Server/Packages/
[root@pdbdr1/pdbdr2 Packages]# yum -y update

-- Step 23.5 -->> On Both Node
[root@pdbdr1/pdbdr2 Packages]# rpm -q binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel elfutils-libelf-devel-static \
[root@pdbdr1/pdbdr2 Packages]# rpm -q gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers kernel-headers ksh libaio libaio-devel \
[root@pdbdr1/pdbdr2 Packages]# rpm -q libgcc libgomp libstdc++ libstdc++-devel make numactl-devel sysstat unixODBC unixODBC-devel \

-- Step 24 -->> On Both Node
-- Pre-Installation Steps for ASM
[root@pdbdr1/pdbdr2 ~ ]# cd /etc/yum.repos.d
[root@pdbdr1/pdbdr2 yum.repos.d]# uname -ras
/*
Linux pdbdr1.unidev.org.np 4.1.12-124.48.6.el6uek.x86_64 #2 SMP Tue Mar 16 15:39:03 PDT 2021 x86_64 x86_64 x86_64 GNU/Linux
*/

-- Step 24.1 -->> On Both Node
[root@pdbdr1/pdbdr2 yum.repos.d]# cat /etc/os-release 
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
[root@pdbdr1/pdbdr2 yum.repos.d]# wget https://public-yum.oracle.com/public-yum-ol6.repo
/*
--2025-06-25 14:21:56--  https://public-yum.oracle.com/public-yum-ol6.repo
Resolving public-yum.oracle.com... 104.73.165.90, 2600:140f:5:5084::2a7d, 2600:140f:5:508d::2a7d
Connecting to public-yum.oracle.com|104.73.165.90|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 12045 (12K) [text/plain]
Saving to: “public-yum-ol6.repo.1”

100%[====================================================>] 12,045      --.-K/s   in 0s

2025-06-25 14:21:57 (469 MB/s) - “public-yum-ol6.repo.1” saved [12045/12045]
*/

-- Step 24.3 -->> On Both Node
[root@pdbdr1/pdbdr2 yum.repos.d]# yum install -y kmod-oracleasm
[root@pdbdr1/pdbdr2 yum.repos.d]# yum install -y oracleasm-support

-- Step 24.4 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# cd /root/Oracle_Linux_6_Rpm/
[root@pdbdr1/pdbdr2 Oracle_Linux_6_Rpm]# rpm -iUvh oracleasmlib-2.0.4-1.el6.x86_64.rpm
[root@pdbdr1/pdbdr2 Oracle_Linux_6_Rpm]# rpm -qa | grep oracleasm
/*
oracleasmlib-2.0.4-1.el6.x86_64
oracleasm-support-2.1.11-2.el6.x86_64
kmod-oracleasm-2.0.8-16.1.el6_10.x86_64
*/

-- Step 24.5 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# cd /media/OL6.10\ x86_64\ Disc\ 1\ 20180625/Server/Packages/
[root@pdbdr1/pdbdr2 Packages]# yum -y update

-- Step 25 -->> On Both Node
-- Add the kernel parameters file "/etc/sysctl.conf" and add oracle recommended kernel parameters
[root@pdbdr1/pdbdr2 ~]# vi /etc/sysctl.conf
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
[root@pdbdr1/pdbdr2 ~]# sysctl -p /etc/sysctl.conf

-- Step 26 -->> On Both Node
-- Edit "/etc/security/limits.conf" file to limit user processes
[root@pdbdr1/pdbdr2 ~]# vi /etc/security/limits.conf
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
[root@pdbdr1/pdbdr2 ~]# vi /etc/pam.d/login
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
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:
*/

-- Step 28.1 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:
*/

-- Step 28.2 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i oracle
/*
oracle:x:500:
*/

-- Step 28.3 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i oper

-- Step 28.4 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i asm

-- Step 28.5 -->> On both Node
-- 1.Create OS groups using the command below. Enter these commands as the 'root' user:
[root@pdbdr1/pdbdr2 ~]# /usr/sbin/groupadd -g 503 oper
[root@pdbdr1/pdbdr2 ~]# /usr/sbin/groupadd -g 504 asmadmin
[root@pdbdr1/pdbdr2 ~]# /usr/sbin/groupadd -g 506 asmdba
[root@pdbdr1/pdbdr2 ~]# /usr/sbin/groupadd -g 507 asmoper
[root@pdbdr1/pdbdr2 ~]# /usr/sbin/groupadd -g 508 beoper

-- Step 28.6 -->> On both Node
-- 2.Create the users that will own the Oracle software using the commands:
[root@pdbdr1/pdbdr2 ~]# /usr/sbin/useradd -g oinstall -G oinstall,dba,asmadmin,asmdba,asmoper,beoper grid
[root@pdbdr1/pdbdr2 ~]# /usr/sbin/usermod -g oinstall -G oinstall,dba,oper,asmadmin,asmdba oracle

-- Step 28.7 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i grid
/*
oinstall:x:54321:grid,oracle
dba:x:54322:grid,oracle
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 28.8 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/

-- Step 28.9 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i oracle
/*
oracle:x:500:
oinstall:x:54321:grid,oracle
dba:x:54322:grid,oracle
oper:x:503:oracle
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
*/

-- Step 28.10 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i oper
/*
oper:x:503:oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 28.11 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:grid,oracle
*/

-- Step 28.12 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:grid,oracle
asmdba:x:506:grid,oracle
*/

-- Step 29 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# passwd oracle
/*
Changing password for user oracle.
New password: oracle
Retype new password: oracle
passwd: all authentication tokens updated successfully.
*/

-- Step 29.1 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# passwd grid
/*
Changing password for user grid.
New password: grid
Retype new password: grid
passwd: all authentication tokens updated successfully.
*/

-- Step 29.2 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# su - oracle

-- Step 29.3 -->> On both Node
[oracle@pdbdr1/pdbdr2 ~]$ su - grid
/*
Password: grid
*/

-- Step 29.4 -->> On both Node
[grid@pdbdr1/pdbdr2 ~]$ su - oracle
/*
Password: oracle
*/

-- Step 29.5 -->> On both Node
[oracle@pdbdr1/pdbdr2 ~]$ exit
/*
logout
*/

-- Step 29.6 -->> On both Node
[grid@pdbdr1/pdbdr2 ~]$ exit
/*
logout
*/

-- Step 29.7 -->> On both Node
[oracle@pdbdr1/pdbdr2 ~]$ exit
/*
logout
*/

-- Step 30 -->> On both Node
--1.Create the Oracle Inventory Director:
[root@pdbdr1/pdbdr2 ~]# mkdir -p /opt/app/oraInventory
[root@pdbdr1/pdbdr2 ~]# chown -R grid:oinstall /opt/app/oraInventory
[root@pdbdr1/pdbdr2 ~]# chmod -R 775 /opt/app/oraInventory

--2.Creating the Oracle Grid Infrastructure Home Directory:
[root@pdbdr1/pdbdr2 ~]# mkdir -p /opt/app/11.2.0.3.0/grid
[root@pdbdr1/pdbdr2 ~]# chown -R grid:oinstall /opt/app/11.2.0.3.0/grid
[root@pdbdr1/pdbdr2 ~]# chmod -R 775 /opt/app/11.2.0.3.0/grid

--3.Creating the Oracle Base Directory
[root@pdbdr1/pdbdr2 ~]# mkdir -p /opt/app/oracle
[root@pdbdr1/pdbdr2 ~]# mkdir /opt/app/oracle/cfgtoollogs
[root@pdbdr1/pdbdr2 ~]# chown -R oracle:oinstall /opt/app/oracle
[root@pdbdr1/pdbdr2 ~]# chmod -R 775 /opt/app/oracle
[root@pdbdr1/pdbdr2 ~]# chown -R grid:oinstall /opt/app/oracle/cfgtoollogs
[root@pdbdr1/pdbdr2 ~]# chmod -R 775 /opt/app/oracle/cfgtoollogs

--4.Creating the Oracle RDBMS Home Directory
[root@pdbdr1/pdbdr2 ~]# mkdir -p /opt/app/oracle/product/11.2.0.3.0/db_1
[root@pdbdr1/pdbdr2 ~]# chown -R oracle:oinstall /opt/app/oracle/product/11.2.0.3.0/db_1
[root@pdbdr1/pdbdr2 ~]# chmod -R 775 /opt/app/oracle/product/11.2.0.3.0/db_1
[root@pdbdr1/pdbdr2 ~]# cd /opt/app/oracle
[root@pdbdr1/pdbdr2 ~]# chown -R oracle:oinstall product
[root@pdbdr1/pdbdr2 ~]# chmod -R 775 product


-- Step 31 -->> On both Nodes
-- Unzip the files and Copy the ASM rpm to another Nodes.
[root@pdbdr1 ~]# cd /root/11.2.0.3.0/
[root@pdbdr1 11.2.0.3.0]# unzip p10404530_112030_Linux-x86-64_1of7.zip -d /opt/app/oracle/product/11.2.0.3.0/db_1/
[root@pdbdr1 11.2.0.3.0]# unzip p10404530_112030_Linux-x86-64_2of7.zip -d /opt/app/oracle/product/11.2.0.3.0/db_1/
[root@pdbdr1 11.2.0.3.0]# unzip p10404530_112030_Linux-x86-64_3of7-Clusterware.zip -d /opt/app/11.2.0.3.0/

-- Step 32 -->> On Node 2
[root@pdbdr2 ~]# mkdir -p /opt/app/11.2.0.3.0/grid/rpm/

-- Step 32.1 -->> On Node 1
[root@pdbdr1 ~]# cd /opt/app/11.2.0.3.0/grid/rpm/
[root@pdbdr1 rpm]# scp -r cvuqdisk-1.0.9-1.rpm root@pdbdr2:/opt/app/11.2.0.3.0/grid/rpm/
/*
The authenticity of host 'pdbdr2 (192.168.16.49)' can't be established.
RSA key fingerprint is 31:71:c6:61:4f:b5:89:cd:31:39:5d:0c:01:46:3c:d5.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'pdbdr2,192.168.16.49' (RSA) to the list of known hosts.
root@pdbdr2's password: <= P@ssw0rd
cvuqdisk-1.0.9-1.rpm                                       100% 8551     8.4KB/s   00:00
*/

-- Step 33 -->> On both Nodes
[root@pdbdr1/pdbdr2 ~]# chown -R grid:oinstall /opt/app/11.2.0.3.0/grid
[root@pdbdr1/pdbdr2 ~]# chmod -R 775 /opt/app/11.2.0.3.0/grid
[root@pdbdr1/pdbdr2 ~]# chown -R oracle:oinstall /opt/app/oracle/product/11.2.0.3.0/db_1
[root@pdbdr1/pdbdr2 ~]# chmod -R 775 /opt/app/oracle/product/11.2.0.3.0/db_1

-- Step 34 -->> On Node 1
-- Login as the oracle user and add the following lines at the end of the ".bash_profile" file.
[root@pdbdr1 ~]# su - oracle
[oracle@pdbdr1 ~]$ vi .bash_profile
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

ORACLE_HOSTNAME=pdbdr1.unidev.org.np; export ORACLE_HOSTNAME
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
[oracle@pdbdr1 ~]$ . .bash_profile

-- Step 35 -->> On Node 1
-- Login as the grid user and add the following lines at the end of the ".bash_profile" file.
[root@pdbdr1 ~]# su - grid
[grid@pdbdr1 ~]$ vi .bash_profile
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
[grid@pdbdr1 ~]$ . .bash_profile

-- Step 36 -->> On Node 2
-- Login as the oracle user and add the following lines at the end of the ".bash_profile" file.
[root@pdbdr2 ~]# su - oracle
[oracle@pdbdr2 ~]$ vi .bash_profile
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

ORACLE_HOSTNAME=pdbdr2.unidev.org.np; export ORACLE_HOSTNAME
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
[oracle@pdbdr2 ~]$ . .bash_profile

-- Step 37 -->> On Node 2
-- Login as the grid user and add the following lines at the end of the ".bash_profile" file.
[root@pdbdr2 ~]# su - grid
[grid@pdbdr2 ~]$ vi .bash_profile
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
[grid@pdbdr2 ~]$ . .bash_profile

-- Step 38 -->> On Both Nodes
-- To install the cvuqdisk-1.0.10-1.rpm
-- Login from root user
[root@pdbdr1/pdbdr2 ~]# cd /opt/app/11.2.0.3.0/grid/rpm/

-- Step 38.1 -->> On Both Nodes
[root@pdbdr1/pdbdr2 rpm]# ls -ltr
/*
-rwxrwxr-x 1 grid oinstall 8551 Sep 22  2011 cvuqdisk-1.0.9-1.rpm
*/

-- Step 38.2 -->> On Both Nodes
[root@pdbdr1/pdbdr2 rpm]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP

-- Step 38.3 -->> On Both Nodes
[root@pdbdr1/pdbdr2 rpm]# rpm -iUvh cvuqdisk-1.0.9-1.rpm  
/*
Preparing...                ########################################### [100%]
   1:cvuqdisk               ########################################### [100%]
*/

-- Step 39 -->> On Node 1
--SSH user Equivalency configuration (grid and oracle):
[root@pdbdr1 ~]# su - oracle
[oracle@pdbdr1 ~]$ cd /opt/app/oracle/product/11.2.0.3.0/db_1/database/sshsetup/
[oracle@pdbdr1 sshsetup]$ ./sshUserSetup.sh -user oracle -hosts "pdbdr1 pdbdr2" -noPromptPassphrase -confirm -advanced
/*
Password: oracle
*/

-- Step 40 -->> On Both Nodes
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@pdbdr1 date
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@pdbdr2 date
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@pdbdr1 date && ssh oracle@pdbdr2 date
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@pdbdr1.unidev.org.np date
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@pdbdr2.unidev.org.np date
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@pdbdr1.unidev.org.np date && ssh oracle@pdbdr2.unidev.org.np date
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@192.168.16.48 date
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@192.168.16.49 date
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@192.168.16.48 date && ssh oracle@192.168.16.49 date

-- Step 41 -->> On Node 1
[root@pdbdr1 ~]# su - grid
[grid@pdbdr1 ~]$ cd /opt/app/11.2.0.3.0/grid/sshsetup
[grid@pdbdr1 deinstall]$ ./sshUserSetup.sh -user grid -hosts "pdbdr1 pdbdr2" -noPromptPassphrase -confirm -advanced
/*
Password: grid
*/

-- Step 42 -->> On Both Nodes
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@pdbdr1 date
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@pdbdr2 date
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@pdbdr1 date && ssh grid@pdbdr2 date
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@pdbdr1.unidev.org.np date
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@pdbdr2.unidev.org.np date
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@pdbdr1.unidev.org.np date && ssh grid@pdbdr2.unidev.org.np date
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@192.168.16.48 date
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@192.168.16.49 date
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@192.168.16.48 date && ssh grid@192.168.16.49 date

-- Step 43 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# which oracleasm
/*
/usr/sbin/oracleasm
*/

-- Step 43.1 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# oracleasm configure
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
[root@pdbdr1/pdbdr2 ~]# oracleasm status
/*
Checking if ASM is loaded: no
Checking if /dev/oracleasm is mounted: no
*/

-- Step 43.4 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# oracleasm configure -i
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
[root@pdbdr1/pdbdr2 ~]# oracleasm configure
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
[root@pdbdr1/pdbdr2 ~]# oracleasm init
/*
Creating /dev/oracleasm mount point: /dev/oracleasm
Loading module "oracleasm": oracleasm
Configuring "oracleasm" to use device physical block size
Mounting ASMlib driver filesystem: /dev/oracleasm
*/

-- Step 43.7 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 43.8 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 43.9 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# oracleasm listdisks

-- Step 43.10 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# ls -ltr /etc/init.d/ | grep -E "oracle"
/*
-rwxr-xr-x  1 root root  7401 Feb  3  2018 oracleasm
-rwxr--r--  1 root root  1371 Nov  2  2018 oracle-rdbms-server-11gR2-preinstall-firstboot
*/

-- Step 43.11 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# ll /dev/oracleasm/disks/
/*
total 0
*/

-- Step 44 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# ll /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Jun 27 15:05 /dev/sda
brw-rw---- 1 root disk 8,  1 Jun 27 15:05 /dev/sda1
brw-rw---- 1 root disk 8,  2 Jun 27 15:05 /dev/sda2
brw-rw---- 1 root disk 8,  3 Jun 27 15:05 /dev/sda3
brw-rw---- 1 root disk 8,  4 Jun 27 15:05 /dev/sda4
brw-rw---- 1 root disk 8,  5 Jun 27 15:05 /dev/sda5
brw-rw---- 1 root disk 8,  6 Jun 27 15:05 /dev/sda6
brw-rw---- 1 root disk 8,  7 Jun 27 15:05 /dev/sda7
brw-rw---- 1 root disk 8,  8 Jun 27 15:05 /dev/sda8
brw-rw---- 1 root disk 8,  9 Jun 27 15:05 /dev/sda9
brw-rw---- 1 root disk 8, 16 Jun 27 15:05 /dev/sdb
brw-rw---- 1 root disk 8, 32 Jun 27 15:05 /dev/sdc
brw-rw---- 1 root disk 8, 48 Jun 27 15:05 /dev/sdd
*/

--Step 45 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# lsblk
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
[root@pdbdr1/pdbdr2 ~]# fdisk -ll | grep -E "sdb|sdc|sdd"
/*
Disk /dev/sdb: 21.5 GB, 21474836480 bytes
Disk /dev/sdc: 214.7 GB, 214748364800 bytes
Disk /dev/sdd: 429.5 GB, 429496729600 bytes
*/

-- Step 47 -->> On Both Nodes
-- Enable Multipath to resolve oracleasmlibrary v3 issues - (Both Nodes disks not similar after reboot OS)
[root@pdbdr1/pdbdr2 ~]# cd /etc/yum.repos.d/
[root@pdbdr1/pdbdr2 yum.repos.d]# yum install -y device-mapper-multipath

-- Step 47.1 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# which mpathconf
/*
/sbin/mpathconf
*/

-- Step 47.2 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# mpathconf --enable --with_multipathd y
/*
Starting multipathd daemon:                                [  OK  ]
*/

-- Step 47.3 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# multipath -ll
/*
mpathc (36000c2952cee635f69d25fa273461f6d) dm-2 VMware,Virtual disk
size=400G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  `- 3:0:2:0 sdd 8:48 active ready running
mpathb (36000c2900f670669a5a217dc5d17dc90) dm-1 VMware,Virtual disk
size=200G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  `- 3:0:1:0 sdc 8:32 active ready running
mpatha (36000c2936db490d3b57d62fedc47adbf) dm-0 VMware,Virtual disk
size=20G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  `- 3:0:0:0 sdb 8:16 active ready running
*/

-- Step 47.4 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# ls -l /dev/disk/by-id/ | grep -E "sdb|sdc|sdd"
/*
lrwxrwxrwx 1 root root  9 Jun 27 15:05 scsi-36000c2900f670669a5a217dc5d17dc90 -> ../../sdc
lrwxrwxrwx 1 root root  9 Jun 27 15:05 scsi-36000c2936db490d3b57d62fedc47adbf -> ../../sdb
lrwxrwxrwx 1 root root  9 Jun 27 15:05 scsi-36000c2952cee635f69d25fa273461f6d -> ../../sdd
lrwxrwxrwx 1 root root  9 Jun 27 15:05 wwn-0x6000c2900f670669a5a217dc5d17dc90 -> ../../sdc
lrwxrwxrwx 1 root root  9 Jun 27 15:05 wwn-0x6000c2936db490d3b57d62fedc47adbf -> ../../sdb
lrwxrwxrwx 1 root root  9 Jun 27 15:05 wwn-0x6000c2952cee635f69d25fa273461f6d -> ../../sdd
*/

-- Step 47.5 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# which scsi_id
/*
/sbin/scsi_id
*/

-- Step 47.6 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# /sbin/scsi_id -g -u -d /dev/sdb
/*
36000c2936db490d3b57d62fedc47adbf
*/

-- Step 47.7 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# /sbin/scsi_id -g -u -d /dev/sdc
/*
36000c2900f670669a5a217dc5d17dc90
*/

-- Step 47.8 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# /sbin/scsi_id -g -u -d /dev/sdd
/*
36000c2952cee635f69d25fa273461f6d
*/

-- Step 47.9 -->> On Node 1
[root@pdbdr1 ~]# vi /etc/multipath.conf
/*
# device-mapper-multipath configuration file

# For a complete list of the default configuration values, run either:
# # multipath -t
# or
# # multipathd show config

# For a list of configuration options with descriptions, see the
# multipath.conf man page.
blacklist_exceptions {
        devnode "^sd[b-z]"  # Allow storage disks
        wwid "36000c2936db490d3b57d62fedc47adbf"
        wwid "36000c2900f670669a5a217dc5d17dc90"
        wwid "36000c2952cee635f69d25fa273461f6d"
}

defaults {
        user_friendly_names no         # Oracle preferred
        find_multipaths no             # OK for ASMFD
        no_path_retry queue            # Better for Oracle I/O
}

multipaths {
        multipath {
                   wwid 36000c2936db490d3b57d62fedc47adbf
                   alias OCR
        }
        multipath {
                   wwid 36000c2900f670669a5a217dc5d17dc90
                   alias DATA
        }
        multipath {
                   wwid 36000c2952cee635f69d25fa273461f6d
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
[root@pdbdr1 ~]# scp -r /etc/multipath.conf root@pdbdr2:/etc/
/*
root@pdb2's password: <= P@ssw0rd
multipath.conf                                             100% 1337     1.6MB/s   00:00
*/

-- Step 47.11 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# chkconfig multipathd on

-- Step 47.12 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# chkconfig --list multipathd
/*
multipathd      0:off   1:off   2:on    3:on    4:on    5:on    6:off
*/

-- Step 47.13 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# service multipathd restart
/*
ok
Stopping multipathd daemon:                                [  OK  ]
Starting multipathd daemon:                                [  OK  ]
*/

-- Step 47.14 -->> On Node 1
[root@pdbdr1 ~]# service multipathd status
/*
multipathd (pid  6316) is running...
*/

-- Step 47.15 -->> On Node 2
[root@pdbdr2 ~]# service multipathd status
/*
multipathd (pid  5716) is running...
*/

-- Step 47.16 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# multipath -ll
/*
OCR (36000c2936db490d3b57d62fedc47adbf) dm-0 VMware,Virtual disk
size=20G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  `- 3:0:0:0 sdb 8:16 active ready running
ARC (36000c2952cee635f69d25fa273461f6d) dm-2 VMware,Virtual disk
size=400G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  `- 3:0:2:0 sdd 8:48 active ready running
DATA (36000c2900f670669a5a217dc5d17dc90) dm-1 VMware,Virtual disk
size=200G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  `- 3:0:1:0 sdc 8:32 active ready running
*/

-- Step 48 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# lsblk
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
[root@pdbdr1/pdbdr2 ~]# fdisk -ll | grep -E "OCR|DATA|ARC"
/*
Disk /dev/mapper/OCR: 21.5 GB, 21474836480 bytes
Disk /dev/mapper/DATA: 214.7 GB, 214748364800 bytes
Disk /dev/mapper/ARC: 429.5 GB, 429496729600 bytes
*/

-- Step 50 -->> On Node 1
[root@pdbdr1 ~]# fdisk /dev/mapper/OCR
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0x8f8a0016.
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
Disk identifier: 0x8f8a0016

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
Disk identifier: 0x8f8a0016

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
[root@pdbdr1 ~]# fdisk /dev/mapper/DATA
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0x3ddfa2cf.
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
Disk identifier: 0x3ddfa2cf

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
Disk identifier: 0x3ddfa2cf

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
[root@pdbdr1 ~]# fdisk /dev/mapper/ARC
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0x62880f38.
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
Disk identifier: 0x62880f38

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
Disk identifier: 0x62880f38

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

-- Step 52.1 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# partprobe /dev/mapper/OCR
[root@pdbdr1/pdbdr2 ~]# partprobe /dev/mapper/DATA
[root@pdbdr1/pdbdr2 ~]# partprobe /dev/mapper/ARC

-- Step 53 -->> On Both Nodes (Optional)
[root@pdbdr1/pdbdr2 ~]# init 6

-- Step 54 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# lsblk
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
  └─OCRp1 (dm-4)  249:4    0   20G  0 part
sdc                 8:32   0  200G  0 disk
├─sdc1              8:33   0  200G  0 part
└─DATA (dm-1)     249:1    0  200G  0 mpath
  └─DATAp1 (dm-3) 249:3    0  200G  0 part
sdd                 8:48   0  400G  0 disk
├─sdd1              8:49   0  400G  0 part
└─ARC (dm-2)      249:2    0  400G  0 mpath
  └─ARCp1 (dm-5)  249:5    0  400G  0 part
sr0                11:0    1 1024M  0 rom
*/

-- Step 55 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# service oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 56 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# ll /dev/mapper/ | grep -E "OCR|DATA|ARC"
/*
lrwxrwxrwx 1 root root       7 Jun 29 15:08 ARC -> ../dm-2
lrwxrwxrwx 1 root root       7 Jun 29 15:08 ARCp1 -> ../dm-5
lrwxrwxrwx 1 root root       7 Jun 29 15:08 DATA -> ../dm-1
lrwxrwxrwx 1 root root       7 Jun 29 15:08 DATAp1 -> ../dm-3
lrwxrwxrwx 1 root root       7 Jun 29 15:08 OCR -> ../dm-0
lrwxrwxrwx 1 root root       7 Jun 29 15:08 OCRp1 -> ../dm-4
*/

-- Step 57 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# fdisk -ll | grep -E "OCR|DATA|ARC"
/*
Disk /dev/mapper/OCR: 21.5 GB, 21474836480 bytes
/dev/mapper/OCRp1               1        2610    20964793+  83  Linux
Disk /dev/mapper/DATA: 214.7 GB, 214748364800 bytes
/dev/mapper/DATAp1               1       26108   209712478+  83  Linux
Disk /dev/mapper/ARC: 429.5 GB, 429496729600 bytes
/dev/mapper/ARCp1               1       52216   419424988+  83  Linux
*/

-- Step 58 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# mkfs.ext4 /dev/mapper/OCRp1
[root@pdbdr1/pdbdr2 ~]# mkfs.ext4 /dev/mapper/DATAp1
[root@pdbdr1/pdbdr2 ~]# mkfs.ext4 /dev/mapper/ARCp1

-- Step 59 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]#  ll /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Jun 29 15:08 /dev/sda
brw-rw---- 1 root disk 8,  1 Jun 29 15:08 /dev/sda1
brw-rw---- 1 root disk 8,  2 Jun 29 15:08 /dev/sda2
brw-rw---- 1 root disk 8,  3 Jun 29 15:08 /dev/sda3
brw-rw---- 1 root disk 8,  4 Jun 29 15:08 /dev/sda4
brw-rw---- 1 root disk 8,  5 Jun 29 15:08 /dev/sda5
brw-rw---- 1 root disk 8,  6 Jun 29 15:08 /dev/sda6
brw-rw---- 1 root disk 8,  7 Jun 29 15:08 /dev/sda7
brw-rw---- 1 root disk 8,  8 Jun 29 15:08 /dev/sda8
brw-rw---- 1 root disk 8,  9 Jun 29 15:08 /dev/sda9
brw-rw---- 1 root disk 8, 16 Jun 29 15:08 /dev/sdb
brw-rw---- 1 root disk 8, 17 Jun 29 15:08 /dev/sdb1
brw-rw---- 1 root disk 8, 32 Jun 29 15:08 /dev/sdc
brw-rw---- 1 root disk 8, 33 Jun 29 15:08 /dev/sdc1
brw-rw---- 1 root disk 8, 48 Jun 29 15:08 /dev/sdd
brw-rw---- 1 root disk 8, 49 Jun 29 15:08 /dev/sdd1
*/

-- Step 60 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]#  ll /dev/dm*
/*
brw-rw---- 1 root disk 249, 0 Jun 29 15:08 /dev/dm-0
brw-rw---- 1 root disk 249, 1 Jun 29 15:08 /dev/dm-1
brw-rw---- 1 root disk 249, 2 Jun 29 15:08 /dev/dm-2
brw-rw---- 1 root disk 249, 3 Jun 29 15:25 /dev/dm-3
brw-rw---- 1 root disk 249, 4 Jun 29 15:25 /dev/dm-4
brw-rw---- 1 root disk 249, 5 Jun 29 15:25 /dev/dm-5
*/

-- Step 61 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# fdisk -ll | grep -E "OCR|DATA|ARC"
/*
Disk /dev/mapper/OCR: 21.5 GB, 21474836480 bytes
/dev/mapper/OCRp1               1        2610    20964793+  83  Linux
Disk /dev/mapper/DATA: 214.7 GB, 214748364800 bytes
/dev/mapper/DATAp1               1       26108   209712478+  83  Linux
Disk /dev/mapper/ARC: 429.5 GB, 429496729600 bytes
/dev/mapper/ARCp1               1       52216   419424988+  83  Linux
*/


-- Step 62 -->> On Node 1
[root@pdbdr1 ~]# oracleasm createdisk OCR /dev/mapper/OCRp1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 63 -->> On Node 1
[root@pdbdr1 ~]# oracleasm createdisk DATA /dev/mapper/DATAp1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 64 -->> On Node 1
[root@pdbdr1 ~]# oracleasm createdisk ARC /dev/mapper/ARCp1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 65 -->> On Node 1
[root@pdbdr1 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 66 -->> On Node 1
[root@pdbdr1 ~]# oracleasm listdisks
/*
ARC
DATA
OCR
*/

-- Step 67 -->> On Node 2
[root@pdbdr2 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
Instantiating disk "OCR"
Instantiating disk "ARC"
Instantiating disk "DATA"
*/

-- Step 68 -->> On Node 2
[root@pdbdr2 ~]# oracleasm listdisks
/*
ARC
DATA
OCR
*/

-- Step 69 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# ll /dev/oracleasm/disks/
/*
brw-rw---- 1 grid asmadmin 249, 5 Jun 29 15:27 ARC
brw-rw---- 1 grid asmadmin 249, 3 Jun 29 15:26 DATA
brw-rw---- 1 grid asmadmin 249, 4 Jun 29 15:26 OCR
*/

-- Step 70 -->> On Node 1
-- Pre-check for rac Setup
[grid@pdbdr1 ~]$ cd /opt/app/11.2.0.3.0/grid/
[grid@pdbdr1 grid]$ ./runcluvfy.sh stage -pre crsinst -n pdbdr1,pdbdr2 -verbose

-- Step 71 -->> On Node 1
-- To Create a Response File to Install GID
[grid@pdbdr1 ~]$ cp /opt/app/11.2.0.3.0/grid/response/grid_install.rsp /home/grid/
[grid@pdbdr1 ~]$ cd /home/grid/
[grid@pdbdr1 ~]$ ls -ltr | grep grid_install.rsp
/*
-rwxr-xr-x 1 grid oinstall 24485 Jun 29 15:29 grid_install.rsp
*/

-- Step 71.1 -->> On Node 1
[grid@pdbdr1 ~]$ vi grid_install.rsp
/*
oracle.install.responseFileVersion=/oracle/install/rspfmt_crsinstall_response_schema_v11_2_0
ORACLE_HOSTNAME=pdbdr1.unidev.org.np
INVENTORY_LOCATION=/opt/app/oraInventory
SELECTED_LANGUAGES=en
oracle.install.option=CRS_CONFIG
ORACLE_BASE=/opt/app/oracle
ORACLE_HOME=/opt/app/11.2.0.3.0/grid
oracle.install.asm.OSDBA=asmdba
oracle.install.asm.OSOPER=asmoper
oracle.install.asm.OSASM=asmadmin
oracle.install.crs.config.gpnp.scanName=pdbdr-scan
oracle.install.crs.config.gpnp.scanPort=1521
oracle.install.crs.config.clusterName=pdbdr-cluster
oracle.install.crs.config.gpnp.configureGNS=false
oracle.install.crs.config.clusterNodes=pdbdr1:pdbdr1-vip,pdbdr2:pdbdr2-vip
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
[grid@pdbdr1 ~]$ cd /opt/app/11.2.0.3.0/grid/
[grid@pdbdr1 grid]$ ./runInstaller -ignorePrereq -showProgress -silent -responseFile /home/grid/grid_install.rsp
/*
Starting Oracle Universal Installer...

Checking Temp space: must be greater than 120 MB.   Actual 14166 MB    Passed
Checking swap space: must be greater than 150 MB.   Actual 20479 MB    Passed
Preparing to launch Oracle Universal Installer from /tmp/OraInstall2025-06-29_03-36-18PM. Please wait ...[grid@pdbdr1 grid]$ [WARNING] [INS-32016] The selected Oracle home contains directories or files.
   CAUSE: The selected Oracle home contained directories or files.
   ACTION: To start with an empty Oracle home, either remove its contents or choose another location.
You can find the log of this install session at:
 /opt/app/oraInventory/logs/installActions2025-06-29_03-36-18PM.log

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
Please check '/opt/app/oraInventory/logs/silentInstall2025-06-29_03-36-18PM.log' for more details.
..................................................   97% Done.

Execute Root Scripts in progress.

As a root user, execute the following script(s):
        1. /opt/app/oraInventory/orainstRoot.sh
        2. /opt/app/11.2.0.3.0/grid/root.sh

Execute /opt/app/oraInventory/orainstRoot.sh on the following nodes:
[pdbdr1, pdbdr2]
Execute /opt/app/11.2.0.3.0/grid/root.sh on the following nodes:
[pdbdr1, pdbdr2]

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
[root@pdbdr1 ~]# /opt/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 72.2 -->> On Node 2
[root@pdbdr2 ~]# /opt/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 72.3 -->> On Node 1
[root@pdbdr1 ~]# /opt/app/11.2.0.3.0/grid/root.sh
/*
Check /opt/app/11.2.0.3.0/grid/install/root_pdbdr1.unidev.org.np_2025-06-29_15-43-58.log for the output of root script
*/

-- Step 72.3.1 -->> On Node 1
[root@pdbdr1 ~]#  tail -f /opt/app/11.2.0.3.0/grid/install/root_pdbdr1.unidev.org.np_2025-06-29_15-43-58.log
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
CRS-2672: Attempting to start 'ora.mdnsd' on 'pdbdr1'
CRS-2676: Start of 'ora.mdnsd' on 'pdbdr1' succeeded
CRS-2672: Attempting to start 'ora.gpnpd' on 'pdbdr1'
CRS-2676: Start of 'ora.gpnpd' on 'pdbdr1' succeeded
CRS-2672: Attempting to start 'ora.cssdmonitor' on 'pdbdr1'
CRS-2672: Attempting to start 'ora.gipcd' on 'pdbdr1'
CRS-2676: Start of 'ora.cssdmonitor' on 'pdbdr1' succeeded
CRS-2676: Start of 'ora.gipcd' on 'pdbdr1' succeeded
CRS-2672: Attempting to start 'ora.cssd' on 'pdbdr1'
CRS-2672: Attempting to start 'ora.diskmon' on 'pdbdr1'
CRS-2676: Start of 'ora.diskmon' on 'pdbdr1' succeeded
CRS-2676: Start of 'ora.cssd' on 'pdbdr1' succeeded

ASM created and started successfully.

Disk Group OCR created successfully.

clscfg: -install mode specified
Successfully accumulated necessary OCR keys.
Creating OCR keys for user 'root', privgrp 'root'..
Operation successful.
CRS-4256: Updating the profile
Successful addition of voting disk 67ba88de9f6f4f5fbf36705a87ea67f2.
Successfully replaced voting disk group with +OCR.
CRS-4256: Updating the profile
CRS-4266: Voting file(s) successfully replaced
##  STATE    File Universal Id                File Name Disk group
--  -----    -----------------                --------- ---------
 1. ONLINE   67ba88de9f6f4f5fbf36705a87ea67f2 (/dev/oracleasm/disks/OCR) [OCR]
Located 1 voting disk(s).
CRS-2672: Attempting to start 'ora.asm' on 'pdbdr1'
CRS-2676: Start of 'ora.asm' on 'pdbdr1' succeeded
CRS-2672: Attempting to start 'ora.OCR.dg' on 'pdbdr1'
CRS-2676: Start of 'ora.OCR.dg' on 'pdbdr1' succeeded
Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 72.4 -->> On Node 2
[root@pdbdr2 ~]# /opt/app/11.2.0.3.0/grid/root.sh
/*
Check /opt/app/11.2.0.3.0/grid/install/root_pdbdr2.unidev.org.np_2025-06-29_15-50-09.log for the output of root script
*/

-- Step 72.4.1 -->> On Node 2 
[root@pdbdr2 ~]# tail -f /opt/app/11.2.0.3.0/grid/install/root_pdbdr2.unidev.org.np_2025-06-29_15-50-09.log
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
CRS-4402: The CSS daemon was started in exclusive mode but found an active CSS daemon on node pdbdr1, number 1, and is terminating
An active cluster was found during exclusive startup, restarting to join the cluster
Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 72.5 -->> On Node 1
[grid@pdbdr1 ~]$ cd /opt/app/11.2.0.3.0/grid/
[grid@pdbdr1 grid]$ /opt/app/11.2.0.3.0/grid/cfgtoollogs/configToolAllCommands RESPONSE_FILE=/home/grid/grid_install.rsp
/*
Setting the invPtrLoc to /opt/app/11.2.0.3.0/grid/oraInst.loc

perform - mode is starting for action: configure

perform - mode finished for action: configure

You can see the log file: /opt/app/11.2.0.3.0/grid/cfgtoollogs/oui/configActions2025-06-29_03-54-35-PM.log
*/


-- Step 73 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
[root@pdbdr1/pdbdr2 bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/


-- Step 74 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
[root@pdbdr1/pdbdr2 bin]# ./crsctl check cluster -all
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
[root@pdbdr1 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
[root@pdbdr1 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdbdr1                   Started
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       pdbdr1
ora.crf
      1        ONLINE  ONLINE       pdbdr1
ora.crsd
      1        ONLINE  ONLINE       pdbdr1
ora.cssd
      1        ONLINE  ONLINE       pdbdr1
ora.cssdmonitor
      1        ONLINE  ONLINE       pdbdr1
ora.ctssd
      1        ONLINE  ONLINE       pdbdr1                   ACTIVE:0
ora.diskmon
      1        OFFLINE OFFLINE
ora.evmd
      1        ONLINE  ONLINE       pdbdr1
ora.gipcd
      1        ONLINE  ONLINE       pdbdr1
ora.gpnpd
      1        ONLINE  ONLINE       pdbdr1
ora.mdnsd
      1        ONLINE  ONLINE       pdbdr1
*/


-- Step 76 -->> On Node 2
[root@pdbdr2 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
[root@pdbdr2 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdbdr2                   Started
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       pdbdr2
ora.crf
      1        ONLINE  ONLINE       pdbdr2
ora.crsd
      1        ONLINE  ONLINE       pdbdr2
ora.cssd
      1        ONLINE  ONLINE       pdbdr2
ora.cssdmonitor
      1        ONLINE  ONLINE       pdbdr2
ora.ctssd
      1        ONLINE  ONLINE       pdbdr2                   ACTIVE:0
ora.diskmon
      1        OFFLINE OFFLINE
ora.evmd
      1        ONLINE  ONLINE       pdbdr2
ora.gipcd
      1        ONLINE  ONLINE       pdbdr2
ora.gpnpd
      1        ONLINE  ONLINE       pdbdr2
ora.mdnsd
      1        ONLINE  ONLINE       pdbdr2
*/

-- Step 77 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
[root@pdbdr1/pdbdr2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
ora.OCR.dg
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
ora.asm
               ONLINE  ONLINE       pdbdr1                   Started
               ONLINE  ONLINE       pdbdr2                   Started
ora.gsd
               OFFLINE OFFLINE      pdbdr1
               OFFLINE OFFLINE      pdbdr2
ora.net1.network
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
ora.ons
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdbdr2
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdbdr1
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       pdbdr1
ora.cvu
      1        ONLINE  ONLINE       pdbdr1
ora.oc4j
      1        ONLINE  ONLINE       pdbdr1
ora.pdbdr1.vip
      1        ONLINE  ONLINE       pdbdr1
ora.pdbdr2.vip
      1        ONLINE  ONLINE       pdbdr2
ora.scan1.vip
      1        ONLINE  ONLINE       pdbdr2
ora.scan2.vip
      1        ONLINE  ONLINE       pdbdr1
ora.scan3.vip
      1        ONLINE  ONLINE       pdbdr1
*/

-- Step 78 -->> On Both Nodes
[grid@pdbdr1/pdbdr2 ~]$ /opt/app/11.2.0.3.0/grid/OPatch/opatch version
/*
Invoking OPatch 11.2.0.1.7

OPatch Version: 11.2.0.1.7

OPatch succeeded.
*/

-- Step 79 -->> On Both Nodes
[grid@pdbdr1/pdbdr2 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512   4096  4194304     20472    20040                0           20040              0             Y  OCR/
ASMCMD [+] > exit
*/

-- Step 80 -->> On Node 1
[grid@pdbdr1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 29-JUN-2025 16:00:16

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                29-JUN-2025 15:55:30
Uptime                    0 days 0 hr. 4 min. 45 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.48)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.50)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 80.1 -->> On Node 1
[grid@pdbdr1 ~]$ ps -ef | grep SCAN
/*
grid     15842     1  0 15:48 ?        00:00:00 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN2 -inherit
grid     15856     1  0 15:48 ?        00:00:00 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN3 -inherit
grid     17109 17031  0 16:00 pts/0    00:00:00 grep SCAN
*/

-- Step 80.2 -->> On Node 1
[grid@pdbdr1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 29-JUN-2025 16:01:04

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                29-JUN-2025 15:48:45
Uptime                    0 days 0 hr. 12 min. 18 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/11.2.0.3.0/grid/log/diag/tnslsnr/pdbdr1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.53)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 80.3 -->> On Node 1
[grid@pdbdr1 ~]$ lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 29-JUN-2025 16:01:37

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                29-JUN-2025 15:48:46
Uptime                    0 days 0 hr. 12 min. 50 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/11.2.0.3.0/grid/log/diag/tnslsnr/pdbdr1/listener_scan3/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN3)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.54)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 80.4 -->> On Node 2
[grid@pdbdr2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 15-JUN-2025 15:33:03

LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 29-JUN-2025 16:00:43

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                29-JUN-2025 15:55:30
Uptime                    0 days 0 hr. 5 min. 13 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.49)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.51)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 80.5 -->> On Node 2
[grid@pdbdr2 ~]$ ps -ef | grep SCAN
/*
grid     13609     1  0 15:53 ?        00:00:00 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN1 -inherit
grid     14628 14565  0 16:00 pts/0    00:00:00 grep SCAN
*/

-- Step 80.6 -->> On Node 2
[grid@pdbdr2 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 29-JUN-2025 16:02:30

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                29-JUN-2025 15:53:12
Uptime                    0 days 0 hr. 9 min. 18 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/11.2.0.3.0/grid/log/diag/tnslsnr/pdbdr2/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.52)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 81 -->> On Node 1
-- To Create ASM storage for Data and Archive 
[grid@pdbdr1 ~]$ cd /opt/app/11.2.0.3.0/grid/bin

-- Step 81.1 -->> On Node 1
[grid@pdbdr1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName DATA -diskList /dev/oracleasm/disks/DATA -redundancy EXTERNAL
/*
Disk Group DATA created successfully.
*/

-- Step 81.2 -->> On Node 1
[grid@pdbdr1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName ARC -diskList /dev/oracleasm/disks/ARC -redundancy EXTERNAL
/*
Disk Group DATA created successfully.
*/

-- Step 82 -->> On Both Nodes
[grid@pdbdr1/pdbdr2 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 11.2.0.3.0 Production on Sun Jun 29 16:04:14 2025

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
[grid@pdbdr1/pdbdr2 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512   4096  1048576    409594   409496                0          409496              0             N  ARC/
MOUNTED  EXTERN  N         512   4096  1048576    204797   204701                0          204701              0             N  DATA/
MOUNTED  EXTERN  N         512   4096  4194304     20472    20040                0           20040              0             Y  OCR/
ASMCMD [+] > exit
*/

-- Step 84 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# cd /opt/app/11.2.0.3.0/grid/bin
[root@pdbdr1/pdbdr2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.ARC.dg
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
ora.DATA.dg
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
ora.LISTENER.lsnr
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
ora.OCR.dg
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
ora.asm
               ONLINE  ONLINE       pdbdr1                   Started
               ONLINE  ONLINE       pdbdr2                   Started
ora.gsd
               OFFLINE OFFLINE      pdbdr1
               OFFLINE OFFLINE      pdbdr2
ora.net1.network
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
ora.ons
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdbdr2
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdbdr1
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       pdbdr1
ora.cvu
      1        ONLINE  ONLINE       pdbdr1
ora.oc4j
      1        ONLINE  ONLINE       pdbdr1
ora.pdbdr1.vip
      1        ONLINE  ONLINE       pdbdr1
ora.pdbdr2.vip
      1        ONLINE  ONLINE       pdbdr2
ora.scan1.vip
      1        ONLINE  ONLINE       pdbdr2
ora.scan2.vip
      1        ONLINE  ONLINE       pdbdr1
ora.scan3.vip
      1        ONLINE  ONLINE       pdbdr1
*/


-- Step 85 -->> On Node 1
[root@pdbdr1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/11.2.0.3.0/grid:N                # line added by Agent
*/

-- Step 86 -->> On Node 2
[root@pdbdr2 ~]# vi /etc/oratab
/*
+ASM2:/opt/app/11.2.0.3.0/grid:N                # line added by Agent
*/

-- Step 87 -->> On Both Nodes
-- Reboot the Oracle Cluster
[root@pdbdr1 ~]# cd /opt/app/11.2.0.3.0/grid/bin
[root@pdbdr1 ~]# ./crsctl stop cluster -all
[root@pdbdr1 ~]# ./crsctl start cluster -all
[root@pdbdr1/pdbdr2 ~]# ./crsctl stat res -t -init
[root@pdbdr1/pdbdr2 ~]# ./crsctl stat res -t
[root@pdbdr1/pdbdr2 ~]# ./crsctl check cluster -all
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
[oracle@pdbdr1 ~]$ cp /opt/app/oracle/product/11.2.0.3.0/db_1/database/response/db_install.rsp /home/oracle/
[oracle@pdbdr1 ~]$ cd /home/oracle/

-- Step 88.1 -->> On Node 1
[oracle@pdbdr1 ~]$ ll db_install.rsp
/*
-rwxr-xr-x 1 oracle oinstall 24992 Jun 29 16:47 db_install.rsp
*/

-- Step 88.2 -->> On Node 1
[oracle@pdbdr1 ~]$ vi db_install.rsp
/*
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v11_2_0
oracle.install.option=INSTALL_DB_SWONLY
ORACLE_HOSTNAME=pdbdr1.unidev.org.np
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/opt/app/oraInventory
SELECTED_LANGUAGES=en
ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1
ORACLE_BASE=/opt/app/oracle
oracle.install.db.InstallEdition=EE
oracle.install.db.EEOptionsSelection=false
oracle.install.db.OSDBA_GROUP=dba
oracle.install.db.OSOPER_GROUP=oper
oracle.install.db.CLUSTER_NODES=pdbdr1,pdbdr2
oracle.install.db.isRACOneInstall=false
oracle.install.db.config.starterdb.type=GENERAL_PURPOSE
*/

-- Step 89 -->> On Node 1
-- To install Oracle Software with Letest Opatch
[oracle@pdbdr1 ~]$ cd /opt/app/oracle/product/11.2.0.3.0/db_1/database/
[oracle@pdbdr1 db_1]$ ./runInstaller -ignorePrereq -waitforcompletion -silent \
-responseFile /home/oracle/db_install.rsp                                   \
oracle.install.db.isRACOneInstall=false                                     \
oracle.install.db.rac.serverpoolCardinality=0                               \
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false                                  \
DECLINE_SECURITY_UPDATES=true

/*
Starting Oracle Universal Installer...

Checking Temp space: must be greater than 120 MB.   Actual 14166 MB    Passed
Checking swap space: must be greater than 150 MB.   Actual 20479 MB    Passed
Preparing to launch Oracle Universal Installer from /tmp/OraInstall2025-06-29_04-50-56PM. Please wait ...[WARNING] [INS-32016] The selected Oracle home contains directories or files.
   CAUSE: The selected Oracle home contained directories or files.
   ACTION: To start with an empty Oracle home, either remove its contents or choose another location.
You can find the log of this install session at:
 /opt/app/oraInventory/logs/installActions2025-06-29_04-50-56PM.log
The installation of Oracle Database 11g was successful.
Please check '/opt/app/oraInventory/logs/silentInstall2025-06-29_04-50-56PM.log' for more details.

As a root user, execute the following script(s):
        1. /opt/app/oracle/product/11.2.0.3.0/db_1/root.sh

Execute /opt/app/oracle/product/11.2.0.3.0/db_1/root.sh on the following nodes:
[pdbdr1, pdbdr2]

Successfully Setup Software.
*/

-- Step 89.1 -->> On Node 1
[root@pdbdr1 ~]# /opt/app/oracle/product/11.2.0.3.0/db_1/root.sh
/*
Check /opt/app/oracle/product/11.2.0.3.0/db_1/install/root_pdbdr1.unidev.org.np_2025-06-29_17-04-20.log for the output of root script
*/

-- Step 89.2 -->> On Node 1
[root@pdbdr1 ~]# tail -f /opt/app/oracle/product/11.2.0.3.0/db_1/install/root_pdbdr1.unidev.org.np_2025-06-29_17-04-20.log
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
[root@pdbdr2 ~]# /opt/app/oracle/product/11.2.0.3.0/db_1/root.sh
/*
Check /opt/app/oracle/product/11.2.0.3.0/db_1/install/root_pdbdr2.unidev.org.np_2025-06-29_17-05-01.log for the output of root script
*/

-- Step 89.4 -->> On Node 2
[root@pdbdr2 ~]# tail -f /opt/app/oracle/product/11.2.0.3.0/db_1/install/root_pdbdr2.unidev.org.np_2025-06-29_17-05-01.log
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

-------------------------------------------------------------------------------------------------------------
------------------------------------------START--------------------------------------------------------------
--------------------------Oracle Patch for ORA-00976:CONNECT BY PRIOR----------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-- To apply the Oracle 11.2.0.3.0 patchset to, a query having "CONNECT BY PRIOR" clause started to fail with:
-- ORA-00976: Specified pseudo column or operator not allowed here

--Step 1:
[oracle@pdbdr1 ~]$ /opt/app/oracle/product/11.2.0.3.0/db_1/OPatch/opatch lsinventory
/*
Invoking OPatch 11.2.0.1.7

Oracle Interim Patch Installer version 11.2.0.1.7
Copyright (c) 2011, Oracle Corporation.  All rights reserved.


Oracle Home       : /opt/app/oracle/product/11.2.0.3.0/db_1
Central Inventory : /opt/app/oraInventory
   from           : /etc/oraInst.loc
OPatch version    : 11.2.0.1.7
OUI version       : 11.2.0.3.0
Log file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/opatch2025-06-29_17-05-39PM.log

Lsinventory Output file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/lsinv/lsinventory2025-06-29_17-05-39PM.txt

--------------------------------------------------------------------------------
Installed Top-level Products (1):

Oracle Database 11g                                                  11.2.0.3.0
There are 1 products installed in this Oracle Home.


There are no Interim patches installed in this Oracle Home.


Rac system comprising of multiple nodes
  Local node = pdbdr1
  Remote node = pdbdr2

--------------------------------------------------------------------------------

OPatch succeeded.
*/

--Step 2:
[oracle@pdbdr2 ~]$ /opt/app/oracle/product/11.2.0.3.0/db_1/OPatch/opatch lsinventory
/*
Invoking OPatch 11.2.0.1.7

Oracle Interim Patch Installer version 11.2.0.1.7
Copyright (c) 2011, Oracle Corporation.  All rights reserved.


Oracle Home       : /opt/app/oracle/product/11.2.0.3.0/db_1
Central Inventory : /opt/app/oraInventory
   from           : /etc/oraInst.loc
OPatch version    : 11.2.0.1.7
OUI version       : 11.2.0.3.0
Log file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/opatch2025-06-29_17-06-05PM.log

Lsinventory Output file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/lsinv/lsinventory2025-06-29_17-06-05PM.txt

--------------------------------------------------------------------------------
Installed Top-level Products (1):

Oracle Database 11g                                                  11.2.0.3.0
There are 1 products installed in this Oracle Home.


There are no Interim patches installed in this Oracle Home.


Rac system comprising of multiple nodes
  Local node = pdbdr2
  Remote node = pdbdr1

--------------------------------------------------------------------------------

OPatch succeeded.
*/

--Step 3:
[oracle@pdbdr1 ~]$ /opt/app/oracle/product/11.2.0.3.0/db_1/OPatch/opatch version
/*
Invoking OPatch 11.2.0.1.7

OPatch Version: 11.2.0.1.7

OPatch succeeded.
*/

--Step 4:
[oracle@pdbdr2 ~]$ /opt/app/oracle/product/11.2.0.3.0/db_1/OPatch/opatch version
/*
Invoking OPatch 11.2.0.1.7

OPatch Version: 11.2.0.1.7

OPatch succeeded.
*/

--Step 5:
[oracle@pdbdr1 ~]$ cd /tmp/
[oracle@pdbdr1 tmp]$ unzip p14230270_112030_Linux-x86-64.zip
[oracle@pdbdr1 tmp]$ chmod -R 775 14230270
[oracle@pdbdr1 tmp]$ ls -ltr | grep 14230270
/*
drwxrwxr-x  5 oracle oinstall   4096 Aug  8  2012 14230270
-rwxrwxr-x  1 oracle oinstall 216691 Feb 19  2021 p14230270_112030_Linux-x86-64.zip
*/

--Step 6:
-- To applying the Oracle PSU
[oracle@pdbdr1 tmp]$ export ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1
[oracle@pdbdr1 tmp]$ export PATH=${ORACLE_HOME}/bin:$PATH
[oracle@pdbdr1 tmp]$ export PATH=${PATH}:${ORACLE_HOME}/OPatch
[oracle@pdbdr1 tmp]$ which opatch
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/OPatch/opatch
*/

--Step 7:
[oracle@pdbdr1 tmp]$ cd 14230270/
[oracle@pdbdr1 14230270]$ /opt/app/oracle/product/11.2.0.3.0/db_1/OPatch/opatch apply
/*
Invoking OPatch 11.2.0.1.7

Oracle Interim Patch Installer version 11.2.0.1.7
Copyright (c) 2011, Oracle Corporation.  All rights reserved.


Oracle Home       : /opt/app/oracle/product/11.2.0.3.0/db_1
Central Inventory : /opt/app/oraInventory
   from           : /etc/oraInst.loc
OPatch version    : 11.2.0.1.7
OUI version       : 11.2.0.3.0
Log file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/opatch2025-06-29_17-09-21PM.log

Applying interim patch '14230270' to OH '/opt/app/oracle/product/11.2.0.3.0/db_1'
Verifying environment and performing prerequisite checks...

Do you want to proceed? [y|n]
y
User Responded with: Y
All checks passed.

This node is part of an Oracle Real Application Cluster.
Remote nodes: 'pdbdr2'
Local node: 'pdbdr1'
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


The node 'pdbdr2' will be patched next.


Please shutdown Oracle instances running out of this ORACLE_HOME on 'pdbdr2'.
(Oracle Home = '/opt/app/oracle/product/11.2.0.3.0/db_1')

Is the node ready for patching? [y|n]
y
User Responded with: Y
Updating nodes 'pdbdr2'
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
Running command on remote node 'pdbdr2':
cd /opt/app/oracle/product/11.2.0.3.0/db_1/rdbms/lib; /usr/bin/make -f ins_rdbms.mk irenamedg ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1 || echo REMOTE_MAKE_FAILED::>&2

Running command on remote node 'pdbdr2':
cd /opt/app/oracle/product/11.2.0.3.0/db_1/rdbms/lib; /usr/bin/make -f ins_rdbms.mk ioracle ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1 || echo REMOTE_MAKE_FAILED::>&2

Running command on remote node 'pdbdr2':
cd /opt/app/oracle/product/11.2.0.3.0/db_1/rdbms/lib; /usr/bin/make -f ins_rdbms.mk client_sharedlib ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1 || echo REMOTE_MAKE_FAILED::>&2

Running command on remote node 'pdbdr2':
cd /opt/app/oracle/product/11.2.0.3.0/db_1/network/lib; /usr/bin/make -f ins_net_client.mk client_sharedlib ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1 || echo REMOTE_MAKE_FAILED::>&2


The node 'pdbdr2' has been patched.  You can restart Oracle instances on it.

There were relinks on remote nodes.  Remember to check the binary size and timestamp on the nodes 'pdbdr2' .
The following make commands were invoked on remote nodes:
'cd /opt/app/oracle/product/11.2.0.3.0/db_1/rdbms/lib; /usr/bin/make -f ins_rdbms.mk irenamedg ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1
cd /opt/app/oracle/product/11.2.0.3.0/db_1/rdbms/lib; /usr/bin/make -f ins_rdbms.mk ioracle ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1
cd /opt/app/oracle/product/11.2.0.3.0/db_1/rdbms/lib; /usr/bin/make -f ins_rdbms.mk client_sharedlib ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1
cd /opt/app/oracle/product/11.2.0.3.0/db_1/network/lib; /usr/bin/make -f ins_net_client.mk client_sharedlib ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1
'

Patch 14230270 successfully applied
Log file location: /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/opatch2025-06-29_17-09-21PM.log

OPatch succeeded.
*/

--Step 8:
[oracle@pdbdr1 14230270]$ /opt/app/oracle/product/11.2.0.3.0/db_1/OPatch/opatch lsinventory
/*
Invoking OPatch 11.2.0.1.7

Oracle Interim Patch Installer version 11.2.0.1.7
Copyright (c) 2011, Oracle Corporation.  All rights reserved.


Oracle Home       : /opt/app/oracle/product/11.2.0.3.0/db_1
Central Inventory : /opt/app/oraInventory
   from           : /etc/oraInst.loc
OPatch version    : 11.2.0.1.7
OUI version       : 11.2.0.3.0
Log file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/opatch2025-06-29_17-10-33PM.log

Lsinventory Output file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/lsinv/lsinventory2025-06-29_17-10-33PM.txt

--------------------------------------------------------------------------------
Installed Top-level Products (1):

Oracle Database 11g                                                  11.2.0.3.0
There are 1 products installed in this Oracle Home.


Interim patches (1) :

Patch  14230270     : applied on Sun Jun 29 17:09:47 NPT 2025
Unique Patch ID:  15357561
   Created on 7 Aug 2012, 22:20:10 hrs PST8PDT
   Bugs fixed:
     14230270



Rac system comprising of multiple nodes
  Local node = pdbdr1
  Remote node = pdbdr2

--------------------------------------------------------------------------------

OPatch succeeded.
*/

--Step 9:
[oracle@pdbdr2 ~]$ /opt/app/oracle/product/11.2.0.3.0/db_1/OPatch/opatch lsinventory
/*
Invoking OPatch 11.2.0.1.7

Oracle Interim Patch Installer version 11.2.0.1.7
Copyright (c) 2011, Oracle Corporation.  All rights reserved.


Oracle Home       : /opt/app/oracle/product/11.2.0.3.0/db_1
Central Inventory : /opt/app/oraInventory
   from           : /etc/oraInst.loc
OPatch version    : 11.2.0.1.7
OUI version       : 11.2.0.3.0
Log file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/opatch2025-06-29_17-11-03PM.log

Lsinventory Output file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/lsinv/lsinventory2025-06-29_17-11-03PM.txt

--------------------------------------------------------------------------------
Installed Top-level Products (1):

Oracle Database 11g                                                  11.2.0.3.0
There are 1 products installed in this Oracle Home.


Interim patches (1) :

Patch  14230270     : applied on Sun Jun 29 17:09:47 NPT 2025
Unique Patch ID:  15357561
   Created on 7 Aug 2012, 22:20:10 hrs PST8PDT
   Bugs fixed:
     14230270



Rac system comprising of multiple nodes
  Local node = pdbdr2
  Remote node = pdbdr1

--------------------------------------------------------------------------------

OPatch succeeded.
*/
-------------------------------------------------------------------------------------------------------------
---------------------------------------------END-------------------------------------------------------------
--------------------------Oracle Patch for ORA-00976:CONNECT BY PRIOR----------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- Step 90 -->> On Both Nodes (DC and DR)
--########################################################################--
[root@pdb1/pdb2/pdbdr1/pdbdr2 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

##############################DC##################################
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

##############################DR##################################
# Public
192.168.16.48   pdbdr1.unidev.org.np        pdbdr1
192.168.16.49   pdbdr2.unidev.org.np        pdbdr2

# Private
10.10.10.48     pdbdr1-priv.unidev.org.np   pdbdr1-priv
10.10.10.49     pdbdr2-priv.unidev.org.np   pdbdr2-priv

# Virtual
192.168.16.50   pdbdr1-vip.unidev.org.np    pdbdr1-vip
192.168.16.51   pdbdr2-vip.unidev.org.np    pdbdr2-vip

# SCAN
192.168.16.52   pdbdr-scan.unidev.org.np    pdbdr-scan
192.168.16.53   pdbdr-scan.unidev.org.np    pdbdr-scan
192.168.16.54   pdbdr-scan.unidev.org.np    pdbdr-scan
*/

-- Step 91 -->> On Both Nodes - DC & DR
[oracle@pdb1/pdb2/pdbdr1/pdbdr2 ~]$ ping -c 2 pdb1
[oracle@pdb1/pdb2/pdbdr1/pdbdr2 ~]$ ping -c 2 pdb2
[oracle@pdb1/pdb2/pdbdr1/pdbdr2 ~]$ ping -c 2 pdb1-priv
[oracle@pdb1/pdb2/pdbdr1/pdbdr2 ~]$ ping -c 2 pdb2-priv
[oracle@pdb1/pdb2/pdbdr1/pdbdr2 ~]$ ping -c 2 pdb1-vip
[oracle@pdb1/pdb2/pdbdr1/pdbdr2 ~]$ ping -c 2 pdb2-vip
[oracle@pdb1/pdb2/pdbdr1/pdbdr2 ~]$ ping -c 2 pdb-scan
[oracle@pdb1/pdb2/pdbdr1/pdbdr2 ~]$ ping -c 2 pdbdr1
[oracle@pdb1/pdb2/pdbdr1/pdbdr2 ~]$ ping -c 2 pdbdr2
[oracle@pdb1/pdb2/pdbdr1/pdbdr2 ~]$ ping -c 2 pdbdr1-priv
[oracle@pdb1/pdb2/pdbdr1/pdbdr2 ~]$ ping -c 2 pdbdr2-priv
[oracle@pdb1/pdb2/pdbdr1/pdbdr2 ~]$ ping -c 2 pdbdr1-vip
[oracle@pdb1/pdb2/pdbdr1/pdbdr2 ~]$ ping -c 2 pdbdr2-vip
[oracle@pdb1/pdb2/pdbdr1/pdbdr2 ~]$ ping -c 2 pdbdr-scan

-- Step 92 -->> On Both Node's - DC
-- Enable Archive
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is running on node pdb1
Instance pdbdb2 is running on node pdb2
*/

-- Step 93 -->> On Both Node's - DC
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 94 -->> On Node 1 - DC
[oracle@pdb1 ~]$ srvctl stop database -d pdbdb
[oracle@pdb1 ~]$ srvctl start database -d pdbdb -o mount
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Mounted (Closed).
Instance pdbdb2 is running on node pdb2. Instance status: Mounted (Closed).
*/

-- Step 95 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 10:58:53 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PRIMARY          MOUNTED
         2 MOUNTED      pdbdb2           PRIMARY          MOUNTED

SQL> SELECT inst_id,name,log_mode,open_mode,protection_mode FROM gv$database;

   INST_ID NAME      LOG_MODE     OPEN_MODE            PROTECTION_MODE
---------- --------- ------------ -------------------- --------------------
         1 PDBDB     NOARCHIVELOG MOUNTED              MAXIMUM PERFORMANCE
         2 PDBDB     NOARCHIVELOG MOUNTED              MAXIMUM PERFORMANCE

SQL> ALTER DATABASE ARCHIVELOG;

Database altered.

SQL> ALTER SYSTEM SET log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST' SCOPE=BOTH sid='*';
SQL> ALTER SYSTEM SET log_archive_format='pdbdb_%t_%s_%r.arc' SCOPE=spfile sid='*';

SQL> archive log list;

Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     15
Next log sequence to archive   16
Current log sequence           16

SQL> SELECT inst_id,name,log_mode,open_mode,protection_mode FROM gv$database;

   INST_ID NAME      LOG_MODE     OPEN_MODE            PROTECTION_MODE
---------- --------- ------------ -------------------- --------------------
         1 PDBDB     ARCHIVELOG   MOUNTED              MAXIMUM PERFORMANCE
         2 PDBDB     ARCHIVELOG   MOUNTED              MAXIMUM PERFORMANCE

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           MOUNTED      30-JUN-25 pdb1.unidev.org.np      MOUNTED    ARCHIVELOG   PRIMARY          11.2.0.3.0        MAXIMUM PERFORMANCE  NOT ALLOWED
         2 PDBDB     pdbdb2           MOUNTED      30-JUN-25 pdb2.unidev.org.np      MOUNTED    ARCHIVELOG   PRIMARY          11.2.0.3.0        MAXIMUM PERFORMANCE  NOT ALLOWED

SQL> SELECT name, open_mode,force_logging FROM gv$database;

NAME                 OPEN_MODE  FORCE_LOGGING
-------------------- ---------- ---------------------------------------
PDBDB                MOUNTED    NO
PDBDB                MOUNTED    NO

SQL> ALTER DATABASE FORCE LOGGING;

SQL> SELECT name, open_mode,force_logging FROM gv$database;

NAME                 OPEN_MODE  FORCE_LOGGING
-------------------- ---------- ---------------------------------------
PDBDB                MOUNTED    YES
PDBDB                MOUNTED    YES

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           MOUNTED      30-JUN-25 pdb1.unidev.org.np      MOUNTED    ARCHIVELOG   PRIMARY          11.2.0.3.0        MAXIMUM PERFORMANCE  NOT ALLOWED
         2 PDBDB     pdbdb2           MOUNTED      30-JUN-25 pdb2.unidev.org.np      MOUNTED    ARCHIVELOG   PRIMARY          11.2.0.3.0        MAXIMUM PERFORMANCE  NOT ALLOWED

--SQL> ALTER USER sys IDENTIFIED BY "Sys605014";

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 96 -->> On Node 1 - DC
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Mounted (Closed).
Instance pdbdb2 is running on node pdb2. Instance status: Mounted (Closed).
*/

-- Step 97 -->> On Node 1 - DC
[oracle@pdb1 ~]$ srvctl stop database -d pdbdb
[oracle@pdb1 ~]$ srvctl start database -d pdbdb

-- Step 98 -->> On Both Nodes - DC
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is running on node pdb1
Instance pdbdb2 is running on node pdb2
*/

-- Step 98.1 -->> On Both Nodes - DC
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/


-- Step 99 -->> On Node 1 - DC
[oracle@pdb1 ~]$ cd /opt/app/oracle/product/11.2.0.3.0/db_1/dbs/
[oracle@pdb1 dbs]$ cp orapwpdbdb1 orapwpdbdb

-- Step 99.1 -->> On Node 1 - DC
[oracle@pdb1 ~]$ cd /opt/app/oracle/product/11.2.0.3.0/db_1/dbs/
[oracle@pdb1 dbs]$ scp -p orapwpdbdb oracle@pdb2:/opt/app/oracle/product/11.2.0.3.0/db_1/dbs/orapwpdbdb

-- Step 99.2 -->> On Node 1 - DC
[oracle@pdb1 ~]$ cd /opt/app/oracle/product/11.2.0.3.0/db_1/dbs/
[oracle@pdb1 dbs]$ scp -p orapwpdbdb1 oracle@pdbdr1:/opt/app/oracle/product/11.2.0.3.0/db_1/dbs/orapwpdbdb1
/*
The authenticity of host 'pdbdr1 (192.168.16.48)' can't be established.
RSA key fingerprint is 37:22:cd:f3:f8:ec:ef:95:40:22:20:bf:7c:33:8f:07.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'pdbdr1,192.168.16.48' (RSA) to the list of known hosts.
oracle@pdbdr1's password: <= oracle
orapwpdbdb1                                                100% 1536     1.5KB/s   00:00
*/

-- Step 99.3 -->> On Node 1 - DC
[oracle@pdb1 dbs]$ scp -p orapwpdbdb oracle@pdbdr1:/opt/app/oracle/product/11.2.0.3.0/db_1/dbs/orapwpdbdb
/*
oracle@pdbdr1's password: <= oracle
orapwpdbdb                                                 100% 1536     1.5KB/s   00:00
*/

-- Step 100 -->> On Node 1 - DC
[oracle@pdb1 dbs]$ scp -p orapwpdbdb1 oracle@pdbdr2:/opt/app/oracle/product/11.2.0.3.0/db_1/dbs/orapwpdbdb2
/*
The authenticity of host 'pdbdr2 (192.168.16.49)' can't be established.
RSA key fingerprint is 98:60:4c:1e:a3:1b:8b:9a:f0:3f:30:e4:f8:0a:91:d6.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'pdbdr2,192.168.16.49' (RSA) to the list of known hosts.
oracle@pdbdr2's password: <= oracle
orapwpdbdb1                                                100% 1536     1.5KB/s   00:00
*/

-- Step 100.1 -->> On Node 1 - DC
[oracle@pdb1 dbs]$ scp -p orapwpdbdb oracle@pdbdr2:/opt/app/oracle/product/11.2.0.3.0/db_1/dbs/orapwpdbdb
/*
oracle@pdbdr2's password: <= oracle
orapwpdbdb                                                 100% 1536     1.5KB/s   00:00
*/

-- Step 101 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 11:13:13 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> show parameter pfile

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
spfile                               string      +DATA/pdbdb/spfilepdbdb.ora

SQL> create pfile='/home/oracle/spfilepdbdb.ora' from spfile;

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           OPEN         30-JUN-25 pdb1.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          11.2.0.3.0        MAXIMUM PERFORMANCE  NOT ALLOWED
         2 PDBDB     pdbdb2           OPEN         30-JUN-25 pdb2.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          11.2.0.3.0        MAXIMUM PERFORMANCE  NOT ALLOWED

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 102 -->> On Node 1 - DC
[oracle@pdb1 ~]$  sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 11:14:43 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           OPEN         30-JUN-25 pdb1.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          11.2.0.3.0        MAXIMUM PERFORMANCE  NOT ALLOWED
         2 PDBDB     pdbdb2           OPEN         30-JUN-25 pdb2.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          11.2.0.3.0        MAXIMUM PERFORMANCE  NOT ALLOWED

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

SQL> col member for a50

SQL> SELECT * FROM v$logfile a ORDER BY a.type,a.group#;

    GROUP# STATUS  TYPE    MEMBER                                             IS_
---------- ------- ------- -------------------------------------------------- ---
         1         ONLINE  +DATA/pdbdb/onlinelog/group_1.261.1204817395       NO
         1         ONLINE  +ARC/pdbdb/onlinelog/group_1.256.1205147985        NO
         2         ONLINE  +DATA/pdbdb/onlinelog/group_2.262.1204817395       NO
         2         ONLINE  +ARC/pdbdb/onlinelog/group_2.257.1205147987        NO
         3         ONLINE  +ARC/pdbdb/onlinelog/group_3.258.1205147987        NO
         3         ONLINE  +DATA/pdbdb/onlinelog/group_3.265.1204817531       NO
         4         ONLINE  +ARC/pdbdb/onlinelog/group_4.259.1205147987        NO
         4         ONLINE  +DATA/pdbdb/onlinelog/group_4.266.1204817533       NO


SQL> ALTER DATABASE ADD LOGFILE MEMBER '+DATA' ,'+DATA' to group 1;
SQL> ALTER DATABASE ADD LOGFILE MEMBER '+DATA' ,'+DATA' to group 2;
SQL> ALTER DATABASE ADD LOGFILE MEMBER '+DATA' ,'+DATA' to group 3;
SQL> ALTER DATABASE ADD LOGFILE MEMBER '+DATA' ,'+DATA' to group 4;
SQL> ALTER DATABASE ADD LOGFILE THREAD 1 GROUP 5 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD LOGFILE THREAD 2 GROUP 6 ('+DATA' ,'+DATA') SIZE 50M;

--To Clearing group
--ALTER DATABASE CLEAR LOGFILE GROUP 2;
--If the corrupTredo log file has not been archived, use the UNARCHIVED keyword in the statement.
--ALTER DATABASE CLEAR UNARCHIVED LOGFILE GROUP 2;

SQL> SELECT group#, archived, status FROM v$log;

    GROUP# ARC STATUS
---------- --- ----------------
         1 NO  INACTIVE
         2 YES UNUSED
         3 YES UNUSED
         4 NO  CURRENT
         5 NO  CURRENT
         6 YES UNUSED


--Delete the original log member (Note: Switch to a non-current log for deletion)
--alter system switch logfile;
--alter system checkpoint;

SQL> ALTER DATABASE DROP LOGFILE MEMBER '+DATA/pdbdb/onlinelog/group_1.261.1204817395';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+ARC/pdbdb/onlinelog/group_1.256.1205147985';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+DATA/pdbdb/onlinelog/group_2.262.1204817395';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+ARC/pdbdb/onlinelog/group_2.257.1205147987';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+ARC/pdbdb/onlinelog/group_3.258.1205147987';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+DATA/pdbdb/onlinelog/group_3.265.1204817531';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+ARC/pdbdb/onlinelog/group_4.259.1205147987';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+DATA/pdbdb/onlinelog/group_4.266.1204817533';


SQL> SELECT * FROM v$logfile a ORDER BY a.type,a.group#;

    GROUP# STATUS  TYPE    MEMBER                                             IS_
---------- ------- ------- -------------------------------------------------- ---
         1         ONLINE  +DATA/pdbdb/onlinelog/group_1.268.1205148389       NO
         1         ONLINE  +DATA/pdbdb/onlinelog/group_1.269.1205148391       NO
         2         ONLINE  +DATA/pdbdb/onlinelog/group_2.270.1205148391       NO
         2         ONLINE  +DATA/pdbdb/onlinelog/group_2.271.1205148391       NO
         3         ONLINE  +DATA/pdbdb/onlinelog/group_3.272.1205148391       NO
         3         ONLINE  +DATA/pdbdb/onlinelog/group_3.273.1205148391       NO
         4         ONLINE  +DATA/pdbdb/onlinelog/group_4.274.1205148393       NO
         4         ONLINE  +DATA/pdbdb/onlinelog/group_4.275.1205148393       NO
         5         ONLINE  +DATA/pdbdb/onlinelog/group_5.276.1205148393       NO
         5         ONLINE  +DATA/pdbdb/onlinelog/group_5.277.1205148393       NO
         6         ONLINE  +DATA/pdbdb/onlinelog/group_6.278.1205148393       NO
         6         ONLINE  +DATA/pdbdb/onlinelog/group_6.279.1205148393       NO

SQL> SELECT b.thread#,a.group#,a.member,b.bytes FROM v$logfile a, v$log b  WHERE a.group#=b.group# ORDER BY b.group#;

   THREAD#     GROUP# MEMBER                                                  BYTES
---------- ---------- -------------------------------------------------- ----------
         1          1 +DATA/pdbdb/onlinelog/group_1.268.1205148389         52428800
         1          1 +DATA/pdbdb/onlinelog/group_1.269.1205148391         52428800
         1          2 +DATA/pdbdb/onlinelog/group_2.270.1205148391         52428800
         1          2 +DATA/pdbdb/onlinelog/group_2.271.1205148391         52428800
         2          3 +DATA/pdbdb/onlinelog/group_3.272.1205148391         52428800
         2          3 +DATA/pdbdb/onlinelog/group_3.273.1205148391         52428800
         2          4 +DATA/pdbdb/onlinelog/group_4.274.1205148393         52428800
         2          4 +DATA/pdbdb/onlinelog/group_4.275.1205148393         52428800
         1          5 +DATA/pdbdb/onlinelog/group_5.276.1205148393         52428800
         1          5 +DATA/pdbdb/onlinelog/group_5.277.1205148393         52428800
         2          6 +DATA/pdbdb/onlinelog/group_6.278.1205148393         52428800
         2          6 +DATA/pdbdb/onlinelog/group_6.279.1205148393         52428800

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

   THREAD#     GROUP# TYPE    MEMBER                                                  BYTES
---------- ---------- ------- -------------------------------------------------- ----------
         1          7 STANDBY +DATA/pdbdb/onlinelog/group_7.265.1205149301         52428800
         1          7 STANDBY +DATA/pdbdb/onlinelog/group_7.266.1205149301         52428800
         1          8 STANDBY +DATA/pdbdb/onlinelog/group_8.261.1205149303         52428800
         1          8 STANDBY +DATA/pdbdb/onlinelog/group_8.262.1205149301         52428800
         1          9 STANDBY +DATA/pdbdb/onlinelog/group_9.280.1205149303         52428800
         1          9 STANDBY +DATA/pdbdb/onlinelog/group_9.281.1205149303         52428800
         1         10 STANDBY +DATA/pdbdb/onlinelog/group_10.282.1205149303        52428800
         1         10 STANDBY +DATA/pdbdb/onlinelog/group_10.283.1205149303        52428800
         2         11 STANDBY +DATA/pdbdb/onlinelog/group_11.284.1205149303        52428800
         2         11 STANDBY +DATA/pdbdb/onlinelog/group_11.285.1205149303        52428800
         2         12 STANDBY +DATA/pdbdb/onlinelog/group_12.286.1205149303        52428800
         2         12 STANDBY +DATA/pdbdb/onlinelog/group_12.287.1205149303        52428800
         2         13 STANDBY +DATA/pdbdb/onlinelog/group_13.288.1205149305        52428800
         2         13 STANDBY +DATA/pdbdb/onlinelog/group_13.289.1205149305        52428800
         2         14 STANDBY +DATA/pdbdb/onlinelog/group_14.290.1205149305        52428800
         2         14 STANDBY +DATA/pdbdb/onlinelog/group_14.291.1205149305        52428800

--Node 2
SQL> SELECT b.thread#,a.group#, a.type, a.member, b.bytes FROM v$logfile a, v$standby_log b WHERE a.group# = b.group# ORDER BY 2,4;

   THREAD#     GROUP# TYPE    MEMBER                                                  BYTES
---------- ---------- ------- -------------------------------------------------- ----------
         1          7 STANDBY +DATA/pdbdb/onlinelog/group_7.265.1205149301         52428800
         1          7 STANDBY +DATA/pdbdb/onlinelog/group_7.266.1205149301         52428800
         1          8 STANDBY +DATA/pdbdb/onlinelog/group_8.261.1205149303         52428800
         1          8 STANDBY +DATA/pdbdb/onlinelog/group_8.262.1205149301         52428800
         1          9 STANDBY +DATA/pdbdb/onlinelog/group_9.280.1205149303         52428800
         1          9 STANDBY +DATA/pdbdb/onlinelog/group_9.281.1205149303         52428800
         1         10 STANDBY +DATA/pdbdb/onlinelog/group_10.282.1205149303        52428800
         1         10 STANDBY +DATA/pdbdb/onlinelog/group_10.283.1205149303        52428800
         2         11 STANDBY +DATA/pdbdb/onlinelog/group_11.284.1205149303        52428800
         2         11 STANDBY +DATA/pdbdb/onlinelog/group_11.285.1205149303        52428800
         2         12 STANDBY +DATA/pdbdb/onlinelog/group_12.286.1205149303        52428800
         2         12 STANDBY +DATA/pdbdb/onlinelog/group_12.287.1205149303        52428800
         2         13 STANDBY +DATA/pdbdb/onlinelog/group_13.288.1205149305        52428800
         2         13 STANDBY +DATA/pdbdb/onlinelog/group_13.289.1205149305        52428800
         2         14 STANDBY +DATA/pdbdb/onlinelog/group_14.290.1205149305        52428800
         2         14 STANDBY +DATA/pdbdb/onlinelog/group_14.291.1205149305        52428800

SQL> SELECT * FROM v$logfile order by 1;

    GROUP# STATUS  TYPE    MEMBER                                             IS_
---------- ------- ------- -------------------------------------------------- ---
         1         ONLINE  +DATA/pdbdb/onlinelog/group_1.269.1205148391       NO
         1         ONLINE  +DATA/pdbdb/onlinelog/group_1.268.1205148389       NO
         2         ONLINE  +DATA/pdbdb/onlinelog/group_2.270.1205148391       NO
         2         ONLINE  +DATA/pdbdb/onlinelog/group_2.271.1205148391       NO
         3         ONLINE  +DATA/pdbdb/onlinelog/group_3.272.1205148391       NO
         3         ONLINE  +DATA/pdbdb/onlinelog/group_3.273.1205148391       NO
         4         ONLINE  +DATA/pdbdb/onlinelog/group_4.274.1205148393       NO
         4         ONLINE  +DATA/pdbdb/onlinelog/group_4.275.1205148393       NO
         5         ONLINE  +DATA/pdbdb/onlinelog/group_5.277.1205148393       NO
         5         ONLINE  +DATA/pdbdb/onlinelog/group_5.276.1205148393       NO
         6         ONLINE  +DATA/pdbdb/onlinelog/group_6.278.1205148393       NO
         6         ONLINE  +DATA/pdbdb/onlinelog/group_6.279.1205148393       NO
         7         STANDBY +DATA/pdbdb/onlinelog/group_7.266.1205149301       NO
         7         STANDBY +DATA/pdbdb/onlinelog/group_7.265.1205149301       NO
         8         STANDBY +DATA/pdbdb/onlinelog/group_8.261.1205149303       NO
         8         STANDBY +DATA/pdbdb/onlinelog/group_8.262.1205149301       NO
         9         STANDBY +DATA/pdbdb/onlinelog/group_9.281.1205149303       NO
         9         STANDBY +DATA/pdbdb/onlinelog/group_9.280.1205149303       NO
        10         STANDBY +DATA/pdbdb/onlinelog/group_10.282.1205149303      NO
        10         STANDBY +DATA/pdbdb/onlinelog/group_10.283.1205149303      NO
        11         STANDBY +DATA/pdbdb/onlinelog/group_11.284.1205149303      NO
        11         STANDBY +DATA/pdbdb/onlinelog/group_11.285.1205149303      NO
        12         STANDBY +DATA/pdbdb/onlinelog/group_12.286.1205149303      NO
        12         STANDBY +DATA/pdbdb/onlinelog/group_12.287.1205149303      NO
        13         STANDBY +DATA/pdbdb/onlinelog/group_13.288.1205149305      NO
        13         STANDBY +DATA/pdbdb/onlinelog/group_13.289.1205149305      NO
        14         STANDBY +DATA/pdbdb/onlinelog/group_14.290.1205149305      NO
        14         STANDBY +DATA/pdbdb/onlinelog/group_14.291.1205149305      NO


-- Run the below query in both the nodes of primary to find the newly added standby redlog files:
SQL> set lines 999 pages 999
SQL> col inst_id for 9999
SQL> col group# for 9999
SQL> col member for a60
SQL> col archived for a7

SQL> SELECT
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

--At Node 1 (pdb1)
REDOLOG_FILE_TYPE    INST_ID GROUP#    THREAD#  SEQUENCE# MEMBER                                                       STATUS           ARCHIVE    SIZE_MB
-------------------- ------- ------ ---------- ---------- ------------------------------------------------------------ ---------------- ------- ----------
[ ONLINE REDO LOG ]        1      1          1         19 +DATA/pdbdb/onlinelog/group_1.268.1205148389                 INACTIVE         NO              50
[ ONLINE REDO LOG ]        1      1          1         19 +DATA/pdbdb/onlinelog/group_1.269.1205148391                 INACTIVE         NO              50
[ ONLINE REDO LOG ]        1      2          1         21 +DATA/pdbdb/onlinelog/group_2.270.1205148391                 CURRENT          NO              50
[ ONLINE REDO LOG ]        1      2          1         21 +DATA/pdbdb/onlinelog/group_2.271.1205148391                 CURRENT          NO              50
[ ONLINE REDO LOG ]        1      5          1         20 +DATA/pdbdb/onlinelog/group_5.276.1205148393                 INACTIVE         NO              50
[ ONLINE REDO LOG ]        1      5          1         20 +DATA/pdbdb/onlinelog/group_5.277.1205148393                 INACTIVE         NO              50
[ STANDBY REDO LOG ]       1      7          1          0 +DATA/pdbdb/onlinelog/group_7.265.1205149301                 UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      7          1          0 +DATA/pdbdb/onlinelog/group_7.266.1205149301                 UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      8          1          0 +DATA/pdbdb/onlinelog/group_8.261.1205149303                 UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      8          1          0 +DATA/pdbdb/onlinelog/group_8.262.1205149301                 UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      9          1          0 +DATA/pdbdb/onlinelog/group_9.280.1205149303                 UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      9          1          0 +DATA/pdbdb/onlinelog/group_9.281.1205149303                 UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1     10          1          0 +DATA/pdbdb/onlinelog/group_10.282.1205149303                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1     10          1          0 +DATA/pdbdb/onlinelog/group_10.283.1205149303                UNASSIGNED       YES             50

--At Node 2 (pdb2)
REDOLOG_FILE_TYPE    INST_ID GROUP#    THREAD#  SEQUENCE# MEMBER                                                       STATUS           ARCHIVE    SIZE_MB
-------------------- ------- ------ ---------- ---------- ------------------------------------------------------------ ---------------- ------- ----------
[ ONLINE REDO LOG ]        2      3          2          9 +DATA/pdbdb/onlinelog/group_3.272.1205148391                 INACTIVE         NO              50
[ ONLINE REDO LOG ]        2      3          2          9 +DATA/pdbdb/onlinelog/group_3.273.1205148391                 INACTIVE         NO              50
[ ONLINE REDO LOG ]        2      4          2          8 +DATA/pdbdb/onlinelog/group_4.274.1205148393                 INACTIVE         NO              50
[ ONLINE REDO LOG ]        2      4          2          8 +DATA/pdbdb/onlinelog/group_4.275.1205148393                 INACTIVE         NO              50
[ ONLINE REDO LOG ]        2      6          2         10 +DATA/pdbdb/onlinelog/group_6.278.1205148393                 CURRENT          NO              50
[ ONLINE REDO LOG ]        2      6          2         10 +DATA/pdbdb/onlinelog/group_6.279.1205148393                 CURRENT          NO              50
[ STANDBY REDO LOG ]       2     11          2          0 +DATA/pdbdb/onlinelog/group_11.284.1205149303                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     11          2          0 +DATA/pdbdb/onlinelog/group_11.285.1205149303                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     12          2          0 +DATA/pdbdb/onlinelog/group_12.286.1205149303                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     12          2          0 +DATA/pdbdb/onlinelog/group_12.287.1205149303                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     13          2          0 +DATA/pdbdb/onlinelog/group_13.288.1205149305                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     13          2          0 +DATA/pdbdb/onlinelog/group_13.289.1205149305                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     14          2          0 +DATA/pdbdb/onlinelog/group_14.290.1205149305                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     14          2          0 +DATA/pdbdb/onlinelog/group_14.291.1205149305                UNASSIGNED       YES             50

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 103 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 11:46:01 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

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
log_archive_format                       pdbdb_%t_%s_%r.arc
log_archive_max_processes                4
standby_file_management                  MANUAL
remote_login_passwordfile                EXCLUSIVE
audit_file_dest                          /opt/app/oracle/admin/pdbdb/adump
db_name                                  pdbdb
db_unique_name                           pdbdb

SQL> show parameter db_unique_name

NAME                                 TYPE        VALUE
------------------------------------ ----------- -----
db_unique_name                       string      pdbdb

SQL> ALTER system SET log_archive_config='DG_CONFIG=(pdbdb,dr)' scope=both sid='*';
SQL> ALTER system SET log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=pdbdb' scope=both sid='*';
SQL> ALTER system SET LOG_ARCHIVE_DEST_2='SERVICE=dr VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=dr' scope=both sid='*';
SQL> ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_1=ENABLE scope=both sid='*';
SQL> ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2=ENABLE scope=both sid='*';
SQL> ALTER system SET log_archive_format='pdbdb_%t_%s_%r.arc' scope=spfile sid='*';
SQL> ALTER system SET LOG_ARCHIVE_MAX_PROCESSES=30 scope=both sid='*';
SQL> ALTER system SET REMOTE_LOGIN_PASSWORDFILE=EXCLUSIVE scope=spfile sid='*';
SQL> ALTER SYSTEM SET fal_client='pdbdb' scope=both sid='*';
SQL> ALTER system SET fal_server ='dr' scope=both sid='*';
SQL> ALTER system SET STANDBY_FILE_MANAGEMENT=AUTO scope=spfile sid='*';
SQL> ALTER system SET db_file_name_convert='+DATA/PDBDB/','+DATA/DR/', '+ARC/PDBDB/','+ARC/DR/' scope=spfile sid='*';
SQL> ALTER system SET log_file_name_convert='+DATA/PDBDB/','+DATA/DR/', '+ARC/PDBDB/','+ARC/DR/' scope=spfile sid='*';
SQL> ALTER system SET db_recovery_file_dest_size=50G scope=both sid='*';
SQL> ALTER SYSTEM SET DB_RECOVERY_FILE_DEST='+DATA' SCOPE=BOTH SID='*';
SQL> ALTER SYSTEM SET DB_RECOVERY_FILE_DEST_SIZE = 50G SCOPE=BOTH SID='*';

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 104 -->> On Both Nodes - DC
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 104.1 -->> On Node 1 - DC
[oracle@pdb1 ~]$ srvctl stop database -d pdbdb

-- Step 104.2 -->> On Node 1 - DC
[oracle@pdb1 ~]$ srvctl start database -d pdbdb

-- Step 105 -->> On Both Nodes - DC
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is running on node pdb1
Instance pdbdb2 is running on node pdb2
*/

-- Step 105.1 -->> On Both Nodes - DC
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 106 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 12:02:53 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

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
---------------------------------------- --------------------------------------------------------------------------------------------
db_file_name_convert                     +DATA/PDBDB/, +DATA/DR/, +ARC/PDBDB/, +ARC/DR/
log_file_name_convert                    +DATA/PDBDB/, +DATA/DR/, +ARC/PDBDB/, +ARC/DR/
log_archive_dest_1                       LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=pdbdb
log_archive_dest_2                       SERVICE=dr VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=dr
log_archive_dest_state_1                 ENABLE
log_archive_dest_state_2                 ENABLE
fal_client                               pdbdb
fal_server                               dr
log_archive_config                       DG_CONFIG=(pdbdb,dr)
log_archive_format                       pdbdb_%t_%s_%r.arc
log_archive_max_processes                30
standby_file_management                  AUTO
remote_login_passwordfile                EXCLUSIVE
audit_file_dest                          /opt/app/oracle/admin/pdbdb/adump
db_name                                  pdbdb
db_unique_name                           pdbdb

SQL> CREATE PFILE='/home/oracle/initpdbdb.ora' FROM SPFILE;

SQL> !cat /home/oracle/initpdbdb.ora

pdbdb1.__db_cache_size=5234491392
pdbdb2.__db_cache_size=5234491392
pdbdb1.__java_pool_size=16777216
pdbdb2.__java_pool_size=16777216
pdbdb1.__large_pool_size=16777216
pdbdb2.__large_pool_size=16777216
pdbdb1.__pga_aggregate_target=2147483648
pdbdb2.__pga_aggregate_target=2147483648
pdbdb1.__sga_target=6442450944
pdbdb2.__sga_target=6442450944
pdbdb1.__shared_io_pool_size=0
pdbdb2.__shared_io_pool_size=0
pdbdb1.__shared_pool_size=1124073472
pdbdb2.__shared_pool_size=1124073472
pdbdb1.__streams_pool_size=0
pdbdb2.__streams_pool_size=0
*.audit_file_dest='/opt/app/oracle/admin/pdbdb/adump'
*.audit_trail='db'
*.cluster_database=true
*.compatible='11.2.0.0.0'
*.control_files='+DATA/pdbdb/controlfile/current.260.1204817393'
*.db_block_size=8192
*.db_create_file_dest='+DATA'
*.db_domain=''
*.db_file_name_convert='+DATA/PDBDB/','+DATA/DR/','+ARC/PDBDB/','+ARC/DR/'
*.db_name='pdbdb'
*.db_recovery_file_dest='+DATA'
*.db_recovery_file_dest_size=53687091200
*.diagnostic_dest='/opt/app/oracle'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=pdbdbXDB)'
*.fal_client='pdbdb'
*.fal_server='dr'
pdbdb2.instance_number=2
pdbdb1.instance_number=1
*.log_archive_config='DG_CONFIG=(pdbdb,dr)'
*.log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=pdbdb'
*.log_archive_dest_2='SERVICE=dr VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=dr'
*.log_archive_dest_state_1='ENABLE'
*.log_archive_dest_state_2='ENABLE'
*.log_archive_format='pdbdb_%t_%s_%r.arc'
*.log_archive_max_processes=30
*.log_file_name_convert='+DATA/PDBDB/','+DATA/DR/','+ARC/PDBDB/','+ARC/DR/'
*.open_cursors=300
*.pga_aggregate_target=2147483648
*.processes=150
*.remote_listener='pdb-scan:1521'
*.remote_login_passwordfile='EXCLUSIVE'
*.sga_target=6442450944
*.standby_file_management='AUTO'
pdbdb2.thread=2
pdbdb1.thread=1
pdbdb2.undo_tablespace='UNDOTBS2'
pdbdb1.undo_tablespace='UNDOTBS1'

SQL> !ps -ef | grep tns
root        64     2  0 Jun26 ?        00:00:00 [netns]
oracle    1156  1098  0 12:04 pts/0    00:00:00 /bin/bash -c ps -ef | grep tns
oracle    1158  1156  0 12:04 pts/0    00:00:00 grep tns
grid     27773     1  0 Jun27 ?        00:00:05 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN2 -inherit
grid     27778     1  0 Jun27 ?        00:00:05 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN3 -inherit
grid     27793     1  0 Jun27 ?        00:00:05 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER -inherit

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 107 -->> On Node 1 - DC
[grid@pdb1 ~]$ cat /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
/*
LISTENER=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER))))            # line added by Agent
LISTENER_SCAN3=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3))))                # line added by Agent
LISTENER_SCAN2=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2))))                # line added by Agent
LISTENER_SCAN1=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1))))                # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN1=ON                # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN2=ON                # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN3=ON                # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER=ON              # line added by Agent
*/

-- Step 108 -->> On Node 1 - DC
[grid@pdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 12:05:36

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                27-JUN-2025 14:34:13
Uptime                    2 days 21 hr. 31 min. 23 sec
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

-- Step 109 -->> On Node 2 - DC
[grid@pdb2 ~]$ cat /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
/*
LISTENER=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER))))            # line added by Agent
LISTENER_SCAN3=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3))))                # line added by Agent
LISTENER_SCAN2=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2))))                # line added by Agent
LISTENER_SCAN1=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1))))                # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN1=ON                # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN2=ON                # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN3=ON                # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER=ON              # line added by Agent
*/

-- Step 110 -->> On Node 2 - DC
[grid@pdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 12:12:05

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                27-JUN-2025 14:34:17
Uptime                    2 days 21 hr. 37 min. 48 sec
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

-- Step 111 -->> On Node 1 - DC
[oracle@pdb1 ~]$ cd $ORACLE_HOME/network/admin
[oracle@pdb1 admin]$ pwd
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/network/admin
*/

-- Step 111.1 -->> On Node 1 - DC
[oracle@pdb1 admin]$ vi tnsnames.ora
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

DR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr1.unidev.org.np)(PORT = 1541))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = dr)(UR=A)
    )
  )
*/

-- Step 112 -->> On Node 1 - DC
[oracle@pdb1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 112.1 -->> On Node 1 - DC
[oracle@pdb1 admin]$ pwd
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/network/admin
*/

-- Step 112.2 -->> On Node 1 - DC
[oracle@pdb1 admin]$ scp -r tnsnames.ora pdb2:/opt/app/oracle/product/11.2.0.3.0/db_1/network/admin
/*
tnsnames.ora                                                              100%  895     1.2MB/s   00:00
*/

-- Step 113 -->> On Node 2 - DC
[oracle@pdb2 ~]$ cd $ORACLE_HOME/network/admin

-- Step 113.1 -->> On Node 2 - DC
[oracle@pdb2 admin]$ pwd
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/network/admin
*/

-- Step 113.2 -->> On Node 2 - DC
[oracle@pdb2 admin]$ vi tnsnames.ora
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

DR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr1.unidev.org.np)(PORT = 1541))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = dr)(UR=A)
    )
  )
*/

-- Step 114 -->> On Node 1 - DC
[oracle@pdb1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 114.1 -->> On Node 1 - DC
[oracle@pdb1 admin]$ pwd
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/network/admin
*/

-- Step 114.2 -->> On Node 1 - DC
[oracle@pdb1 admin]$ scp -r tnsnames.ora pdbdr1:/opt/app/oracle/product/11.2.0.3.0/db_1/network/admin
/*
oracle@pdbdr1's password: oracle
tnsnames.ora                                               100%  866   127.5KB/s   00:00
*/

-- Step 114.3 -->> On Node 1 - DC
[oracle@pdb1 admin]$ scp -r tnsnames.ora pdbdr2:/opt/app/oracle/product/11.2.0.3.0/db_1/network/admin
/*
oracle@pdbdr2's password: oracle
tnsnames.ora                                               100%  866   369.7KB/s   00:00
*/

-- Step 115 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 115.1 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ pwd
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/network/admin
*/

-- Step 115.2 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ vi tnsnames.ora
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

DR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr1.unidev.org.np)(PORT = 1541))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = dr)(UR=A)
    )
  )
*/

-- Step 116 -->> On Node 2 - DR
[oracle@pdbdr2 ~]$ cd $ORACLE_HOME/network/admin

-- Step 116.1 -->> On Node 2 - DR
[oracle@pdbdr2 admin]$ pwd
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/network/admin
*/

-- Step 116.2 -->> On Node 2 - DR
[oracle@pdbdr2 admin]$ cat tnsnames.ora
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

DR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr1.unidev.org.np)(PORT = 1541))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = dr)(UR=A)
    )
  )
*/

-- Step 117 -->> On Node 1 - DC
[oracle@pdb1 ~]$ cd /home/oracle/

-- Step 117.1 -->> On Node 1 - DC
[oracle@pdb1 ~]$ ll initpdbdb.ora
/*
-rw-r--r-- 1 oracle asmadmin 1907 Jun 30 12:03 initpdbdb.ora
*/

-- Step 117.2 -->> On Node 1 - DC
[oracle@pdb1 ~]$ scp -r initpdbdb.ora pdbdr1:/opt/app/oracle/product/11.2.0.3.0/db_1/dbs/initpdbdb1.ora
/*
oracle@pdbdr1's password:
initpdbdb.ora                                              100% 2518     1.7MB/s   00:00
*/

-- Step 118 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/dbs

-- Step 118.1 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ ll initpdbdb1.ora
/*
-rw-r--r-- 1 oracle oinstall 1907 Jun 17 11:04 initpdbdb1.ora
*/

-- Step 118.2 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ vi initpdbdb1.ora
/*
*.audit_file_dest='/opt/app/oracle/admin/pdbdb/adump'
*.audit_trail='db'
*.cluster_database=false
*.compatible='11.2.0.0.0'
*.control_files='+DATA/DR/controlfile/current.264.1203431331'
*.db_block_size=8192
*.db_create_file_dest='+DATA'
*.db_file_name_convert='+DATA/PDBDB/','+DATA/DR/','+ARC/PDBDB/','+ARC/DR/'
*.db_name='pdbdb'
*.db_unique_name='dr'
*.db_recovery_file_dest='+DATA'
*.db_recovery_file_dest_size=53687091200
*.diagnostic_dest='/opt/app/oracle'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=pdbdbXDB)'
*.fal_client='dr'
*.fal_server='pdbdb'
pdbdb1.instance_number=1
*.log_archive_config='DG_CONFIG=(pdbdb,dr)'
*.log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=dr'
*.log_archive_dest_2='SERVICE=pdbdb VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=pdbdb'
*.log_archive_dest_state_1='ENABLE'
*.log_archive_dest_state_2='ENABLE'
*.log_archive_format='%t_%s_%r.arc'
*.log_archive_max_processes=30
*.log_file_name_convert='+DATA/PDBDB/','+DATA/DR/','+ARC/PDBDB/','+ARC/DR/'
*.nls_language='AMERICAN'
*.nls_territory='AMERICA'
*.open_cursors=300
*.pga_aggregate_target=2147483648
*.processes=640
*.remote_login_passwordfile='EXCLUSIVE'
*.sga_target=6442450944
*.sga_max_size=6442450944
*.standby_file_management='AUTO'
pdbdb1.thread=1
pdbdb1.undo_tablespace='UNDOTBS1'
*/

-- Step 119 -->> On Both Node's - DR /opt/app/oracle/admin/pdbdb/adump
[root@pdbdr1/pdbdr2 ~]# mkdir -p /opt/app/oracle/admin/pdbdb/adump
[root@pdbdr1/pdbdr2 ~]# cd /opt/app/oracle/admin/
[root@pdbdr1/pdbdr2 admin]# chown -R oracle:oinstall pdbdb/
[root@pdbdr1/pdbdr2 admin]# chmod -R 775 pdbdb/

-- Step 120 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ asmcmd -p
/*
ASMCMD [+] > ls
ARC/
DATA/
OCR/
ASMCMD [+] > cd +ARC
ASMCMD [+ARC] > mkdir DR
ASMCMD [+ARC] > cd DR
ASMCMD [+ARC/DR] > mkdir CONTROLFILE
ASMCMD [+ARC/DR] > cd ../..
ASMCMD [+] > cd +DATA
ASMCMD [+DATA] > mkdir DR
ASMCMD [+DATA] > cd DR
ASMCMD [+DATA/DR] > mkdir CONTROLFILE
ASMCMD [+DATA/DR] > exit
*/

-- Step 121 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ env | grep ORA
/*
ORACLE_UNQNAME=pdbdb
ORACLE_SID=pdbdb1
ORACLE_BASE=/opt/app/oracle
ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1
ORACLE_HOSTNAME=pdbdr1.unidev.org.np
*/

-- Step 122 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 12:48:21 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> startup nomount pfile='/opt/app/oracle/product/11.2.0.3.0/db_1/dbs/initpdbdb1.ora';
ORACLE instance started.

Total System Global Area 6413680640 bytes
Fixed Size                  2240344 bytes
Variable Size            1107296424 bytes
Database Buffers         5284823040 bytes
Redo Buffers               19320832 bytes

SQL> show parameter db_unique_name

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_unique_name                       string      dr

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, OLAP, Data Mining
and Real Application Testing options
*/

-- Step 123 -->> On Node 1 - DR
--Creating temporary listener 
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 123.1 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ pwd
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/network/admin
*/

-- Step 123.2 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ vi listener.ora
/*
SID_LIST_LISTENER1 =
  (SID_LIST =
    (SID_DESC =
      (GLOBAL_DBNAME = dr)
      (ORACLE_HOME = /opt/app/oracle/product/11.2.0.3.0/db_1)
      (SID_NAME = pdbdb1)
    )
  )

LISTENER1 =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr1.unidev.org.np)(PORT = 1541))
    )
  )
*/

-- Step 123.3 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ ll listener.ora
/*
-rw-r--r-- 1 oracle oinstall 319 Jun 30 12:49 listener.ora
*/

-- Step 123.4 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ lsnrctl start listener1
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 12:50:26

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Starting /opt/app/oracle/product/11.2.0.3.0/db_1/bin/tnslsnr: please wait...

TNSLSNR for Linux: Version 11.2.0.3.0 - Production
System parameter file is /opt/app/oracle/product/11.2.0.3.0/db_1/network/admin/listener.ora
Log messages written to /opt/app/oracle/diag/tnslsnr/pdbdr1/listener1/alert/log.xml
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))
STATUS of the LISTENER
------------------------
Alias                     listener1
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                30-JUN-2025 12:50:26
Uptime                    0 days 0 hr. 0 min. 0 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/oracle/product/11.2.0.3.0/db_1/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))
Services Summary...
Service "dr" has 1 instance(s).
  Instance "pdbdb1", status UNKNOWN, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 123.5 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ lsnrctl status listener1
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 12:50:44

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))
STATUS of the LISTENER
------------------------
Alias                     listener1
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                30-JUN-2025 12:50:26
Uptime                    0 days 0 hr. 0 min. 18 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/oracle/product/11.2.0.3.0/db_1/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))
Services Summary...
Service "dr" has 1 instance(s).
  Instance "pdbdb1", status UNKNOWN, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 123.6 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ sqlplus sys/Sys605014@pdbdb as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 12:51:03 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

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

-- Step 123.7 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ sqlplus sys/Sys605014@dr as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 12:51:34 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;
SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id
                                                                           *
ERROR at line 1:
ORA-01507: database not mounted

SQL> select status,instance_name from gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
STARTED      pdbdb1

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 123.8 -->> On Node 1 - DC
[oracle@pdb1 ~]$ tnsping dr
/*
TNS Ping Utility for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 12:52:12

Copyright (c) 1997, 2011, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr1.unidev.org.np)(PORT = 1541)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = dr)(UR=A)))
OK (0 msec)
*/

-- Step 123.9 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ tnsping pdbdb
/*
TNS Ping Utility for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 12:52:46

Copyright (c) 1997, 2011, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdb-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = pdbdb)))
OK (10 msec)
*/

-- Step 124 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus sys/Sys605014@pdbdb as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 12:53:01 2025

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

SQL> select status,instance_name from gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
OPEN         pdbdb1
OPEN         pdbdb2

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 124.1 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus sys/Sys605014@dr as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 12:53:31 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;
SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id
                                                                           *
ERROR at line 1:
ORA-01507: database not mounted

SQL> select status,instance_name from gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
STARTED      pdbdb1

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 125 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 125.1 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ pwd
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/network/admin
*/

-- Step 125.2 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ rman target sys/Sys605014@pdbdb auxiliary sys/Sys605014@dr
/*
Recovery Manager: Release 11.2.0.3.0 - Production on Mon Jun 30 12:54:30 2025

Copyright (c) 1982, 2011, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB (DBID=3262924656)
connected to auxiliary database: PDBDB (not mounted)

RMAN> duplicate target database for standby from active database DB_FILE_NAME_CONVERT '+DATA/PDBDB/','+DATA/DR/','+ARC/PDBDB/','+ARC/DR/';

Starting Duplicate Db at 30-JUN-25
using target database control file instead of recovery catalog
allocated channel: ORA_AUX_DISK_1
channel ORA_AUX_DISK_1: SID=742 device type=DISK

contents of Memory Script:
{
   backup as copy reuse
   targetfile  '/opt/app/oracle/product/11.2.0.3.0/db_1/dbs/orapwpdbdb1' auxiliary format
 '/opt/app/oracle/product/11.2.0.3.0/db_1/dbs/orapwpdbdb1'   ;
}
executing Memory Script

Starting backup at 30-JUN-25
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=196 instance=pdbdb1 device type=DISK
Finished backup at 30-JUN-25

contents of Memory Script:
{
   backup as copy current controlfile for standby auxiliary format  '+DATA/dr/controlfile/current.256.1205153693';
   sql clone "create spfile from memory";
   shutdown clone immediate;
   startup clone nomount;
   sql clone "alter system set  control_files =
  ''+DATA/dr/controlfile/current.256.1205153693'' comment=
 ''Set by RMAN'' scope=spfile";
   shutdown clone immediate;
   startup clone nomount;
}
executing Memory Script

Starting backup at 30-JUN-25
using channel ORA_DISK_1
channel ORA_DISK_1: starting datafile copy
copying standby control file
output file name=/opt/app/oracle/product/11.2.0.3.0/db_1/dbs/snapcf_pdbdb1.f tag=TAG20250630T125450 RECID=1 STAMP=1205153691
channel ORA_DISK_1: datafile copy complete, elapsed time: 00:00:01
Finished backup at 30-JUN-25

sql statement: create spfile from memory

Oracle instance shut down

connected to auxiliary database (not started)
Oracle instance started

Total System Global Area    6413680640 bytes

Fixed Size                     2240344 bytes
Variable Size               1107296424 bytes
Database Buffers            5284823040 bytes
Redo Buffers                  19320832 bytes

sql statement: alter system set  control_files =   ''+DATA/dr/controlfile/current.256.1205153693'' comment= ''Set by RMAN'' scope=spfile

Oracle instance shut down

connected to auxiliary database (not started)
Oracle instance started

Total System Global Area    6413680640 bytes

Fixed Size                     2240344 bytes
Variable Size               1107296424 bytes
Database Buffers            5284823040 bytes
Redo Buffers                  19320832 bytes

contents of Memory Script:
{
   sql clone 'alter database mount standby database';
}
executing Memory Script

sql statement: alter database mount standby database
RMAN-05529: WARNING: DB_FILE_NAME_CONVERT resulted in invalid ASM names; names changed to disk group only.

contents of Memory Script:
{
   set newname for tempfile  1 to
 "+data";
   switch clone tempfile all;
   set newname for datafile  1 to
 "+data";
   set newname for datafile  2 to
 "+data";
   set newname for datafile  3 to
 "+data";
   set newname for datafile  4 to
 "+data";
   set newname for datafile  5 to
 "+data";
   backup as copy reuse
   datafile  1 auxiliary format
 "+data"   datafile
 2 auxiliary format
 "+data"   datafile
 3 auxiliary format
 "+data"   datafile
 4 auxiliary format
 "+data"   datafile
 5 auxiliary format
 "+data"   ;
   sql 'alter system archive log current';
}
executing Memory Script

executing command: SET NEWNAME

renamed tempfile 1 to +data in control file

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

Starting backup at 30-JUN-25
using channel ORA_DISK_1
channel ORA_DISK_1: starting datafile copy
input datafile file number=00001 name=+DATA/pdbdb/datafile/system.256.1204817317
output file name=+DATA/dr/datafile/system.257.1205153739 tag=TAG20250630T125536
channel ORA_DISK_1: datafile copy complete, elapsed time: 00:00:07
channel ORA_DISK_1: starting datafile copy
input datafile file number=00002 name=+DATA/pdbdb/datafile/sysaux.257.1204817319
output file name=+DATA/dr/datafile/sysaux.258.1205153745 tag=TAG20250630T125536
channel ORA_DISK_1: datafile copy complete, elapsed time: 00:00:07
channel ORA_DISK_1: starting datafile copy
input datafile file number=00003 name=+DATA/pdbdb/datafile/undotbs1.258.1204817319
output file name=+DATA/dr/datafile/undotbs1.259.1205153753 tag=TAG20250630T125536
channel ORA_DISK_1: datafile copy complete, elapsed time: 00:00:01
channel ORA_DISK_1: starting datafile copy
input datafile file number=00005 name=+DATA/pdbdb/datafile/undotbs2.264.1204817485
output file name=+DATA/dr/datafile/undotbs2.260.1205153753 tag=TAG20250630T125536
channel ORA_DISK_1: datafile copy complete, elapsed time: 00:00:02
channel ORA_DISK_1: starting datafile copy
input datafile file number=00004 name=+DATA/pdbdb/datafile/users.259.1204817319
output file name=+DATA/dr/datafile/users.261.1205153755 tag=TAG20250630T125536
channel ORA_DISK_1: datafile copy complete, elapsed time: 00:00:01
Finished backup at 30-JUN-25

sql statement: alter system archive log current

contents of Memory Script:
{
   switch clone datafile all;
}
executing Memory Script

datafile 1 switched to datafile copy
input datafile copy RECID=1 STAMP=1205153762 file name=+DATA/dr/datafile/system.257.1205153739
datafile 2 switched to datafile copy
input datafile copy RECID=2 STAMP=1205153762 file name=+DATA/dr/datafile/sysaux.258.1205153745
datafile 3 switched to datafile copy
input datafile copy RECID=3 STAMP=1205153762 file name=+DATA/dr/datafile/undotbs1.259.1205153753
datafile 4 switched to datafile copy
input datafile copy RECID=4 STAMP=1205153762 file name=+DATA/dr/datafile/users.261.1205153755
datafile 5 switched to datafile copy
input datafile copy RECID=5 STAMP=1205153762 file name=+DATA/dr/datafile/undotbs2.260.1205153753
Finished Duplicate Db at 30-JUN-25

RMAN> exit

Recovery Manager complete.
*/

-- Step 126 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 12:57:09 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           MOUNTED      30-JUN-25 pdbdr1.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 11.2.0.3.0        MAXIMUM PERFORMANCE   RECOVERY NEEDED


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

    GROUP# STATUS  TYPE    MEMBER                                             IS_
---------- ------- ------- -------------------------------------------------- ---
         1         ONLINE  +DATA/dr/onlinelog/group_1.263.1205153763          YES
         1         ONLINE  +DATA/dr/onlinelog/group_1.262.1205153763          NO
         2         ONLINE  +DATA/dr/onlinelog/group_2.264.1205153763          NO
         2         ONLINE  +DATA/dr/onlinelog/group_2.265.1205153763          YES
         3         ONLINE  +DATA/dr/onlinelog/group_3.266.1205153763          NO
         3         ONLINE  +DATA/dr/onlinelog/group_3.267.1205153765          YES
         4         ONLINE  +DATA/dr/onlinelog/group_4.268.1205153765          NO
         4         ONLINE  +DATA/dr/onlinelog/group_4.269.1205153765          YES
         5         ONLINE  +DATA/dr/onlinelog/group_5.271.1205153765          YES
         5         ONLINE  +DATA/dr/onlinelog/group_5.270.1205153765          NO
         6         ONLINE  +DATA/dr/onlinelog/group_6.272.1205153765          NO
         6         ONLINE  +DATA/dr/onlinelog/group_6.273.1205153765          YES
         7         STANDBY +DATA/dr/onlinelog/group_7.274.1205153767          NO
         7         STANDBY +DATA/dr/onlinelog/group_7.275.1205153767          YES
         8         STANDBY +DATA/dr/onlinelog/group_8.277.1205153767          YES
         8         STANDBY +DATA/dr/onlinelog/group_8.276.1205153767          NO
         9         STANDBY +DATA/dr/onlinelog/group_9.279.1205153767          YES
         9         STANDBY +DATA/dr/onlinelog/group_9.278.1205153767          NO
        10         STANDBY +DATA/dr/onlinelog/group_10.280.1205153767         NO
        10         STANDBY +DATA/dr/onlinelog/group_10.281.1205153769         YES
        11         STANDBY +DATA/dr/onlinelog/group_11.282.1205153769         NO
        11         STANDBY +DATA/dr/onlinelog/group_11.283.1205153769         YES
        12         STANDBY +DATA/dr/onlinelog/group_12.284.1205153769         NO
        12         STANDBY +DATA/dr/onlinelog/group_12.285.1205153769         YES
        13         STANDBY +DATA/dr/onlinelog/group_13.286.1205153769         NO
        13         STANDBY +DATA/dr/onlinelog/group_13.287.1205153769         YES
        14         STANDBY +DATA/dr/onlinelog/group_14.288.1205153769         NO
        14         STANDBY +DATA/dr/onlinelog/group_14.289.1205153771         YES

SQL> SELECT b.thread#,a.group#,a.member,b.bytes FROM v$logfile a, v$log b  WHERE a.group#=b.group# ORDER BY b.group#;

   THREAD#     GROUP# MEMBER                                                  BYTES
---------- ---------- -------------------------------------------------- ----------
         1          1 +DATA/dr/onlinelog/group_1.263.1205153763            52428800
         1          1 +DATA/dr/onlinelog/group_1.262.1205153763            52428800
         1          2 +DATA/dr/onlinelog/group_2.264.1205153763            52428800
         1          2 +DATA/dr/onlinelog/group_2.265.1205153763            52428800
         2          3 +DATA/dr/onlinelog/group_3.266.1205153763            52428800
         2          3 +DATA/dr/onlinelog/group_3.267.1205153765            52428800
         2          4 +DATA/dr/onlinelog/group_4.268.1205153765            52428800
         2          4 +DATA/dr/onlinelog/group_4.269.1205153765            52428800
         1          5 +DATA/dr/onlinelog/group_5.271.1205153765            52428800
         1          5 +DATA/dr/onlinelog/group_5.270.1205153765            52428800
         2          6 +DATA/dr/onlinelog/group_6.272.1205153765            52428800
         2          6 +DATA/dr/onlinelog/group_6.273.1205153765            52428800

--Node 1
SQL> SELECT b.thread#,a.group#, a.type, a.member, b.bytes FROM v$logfile a, v$standby_log b WHERE a.group# = b.group# ORDER BY 2,4;

   THREAD#     GROUP# TYPE    MEMBER                                                  BYTES
---------- ---------- ------- -------------------------------------------------- ----------
         1          7 STANDBY +DATA/dr/onlinelog/group_7.274.1205153767            52428800
         1          7 STANDBY +DATA/dr/onlinelog/group_7.275.1205153767            52428800
         1          8 STANDBY +DATA/dr/onlinelog/group_8.276.1205153767            52428800
         1          8 STANDBY +DATA/dr/onlinelog/group_8.277.1205153767            52428800
         1          9 STANDBY +DATA/dr/onlinelog/group_9.278.1205153767            52428800
         1          9 STANDBY +DATA/dr/onlinelog/group_9.279.1205153767            52428800
         1         10 STANDBY +DATA/dr/onlinelog/group_10.280.1205153767           52428800
         1         10 STANDBY +DATA/dr/onlinelog/group_10.281.1205153769           52428800
         2         11 STANDBY +DATA/dr/onlinelog/group_11.282.1205153769           52428800
         2         11 STANDBY +DATA/dr/onlinelog/group_11.283.1205153769           52428800
         2         12 STANDBY +DATA/dr/onlinelog/group_12.284.1205153769           52428800
         2         12 STANDBY +DATA/dr/onlinelog/group_12.285.1205153769           52428800
         2         13 STANDBY +DATA/dr/onlinelog/group_13.286.1205153769           52428800
         2         13 STANDBY +DATA/dr/onlinelog/group_13.287.1205153769           52428800
         2         14 STANDBY +DATA/dr/onlinelog/group_14.288.1205153769           52428800
         2         14 STANDBY +DATA/dr/onlinelog/group_14.289.1205153771           52428800

SQL> SELECT * FROM v$logfile order by 1;

    GROUP# STATUS  TYPE    MEMBER                                             IS_
---------- ------- ------- -------------------------------------------------- ---
         1         ONLINE  +DATA/dr/onlinelog/group_1.263.1205153763          YES
         1         ONLINE  +DATA/dr/onlinelog/group_1.262.1205153763          NO
         2         ONLINE  +DATA/dr/onlinelog/group_2.264.1205153763          NO
         2         ONLINE  +DATA/dr/onlinelog/group_2.265.1205153763          YES
         3         ONLINE  +DATA/dr/onlinelog/group_3.266.1205153763          NO
         3         ONLINE  +DATA/dr/onlinelog/group_3.267.1205153765          YES
         4         ONLINE  +DATA/dr/onlinelog/group_4.268.1205153765          NO
         4         ONLINE  +DATA/dr/onlinelog/group_4.269.1205153765          YES
         5         ONLINE  +DATA/dr/onlinelog/group_5.271.1205153765          YES
         5         ONLINE  +DATA/dr/onlinelog/group_5.270.1205153765          NO
         6         ONLINE  +DATA/dr/onlinelog/group_6.272.1205153765          NO
         6         ONLINE  +DATA/dr/onlinelog/group_6.273.1205153765          YES
         7         STANDBY +DATA/dr/onlinelog/group_7.274.1205153767          NO
         7         STANDBY +DATA/dr/onlinelog/group_7.275.1205153767          YES
         8         STANDBY +DATA/dr/onlinelog/group_8.277.1205153767          YES
         8         STANDBY +DATA/dr/onlinelog/group_8.276.1205153767          NO
         9         STANDBY +DATA/dr/onlinelog/group_9.279.1205153767          YES
         9         STANDBY +DATA/dr/onlinelog/group_9.278.1205153767          NO
        10         STANDBY +DATA/dr/onlinelog/group_10.280.1205153767         NO
        10         STANDBY +DATA/dr/onlinelog/group_10.281.1205153769         YES
        11         STANDBY +DATA/dr/onlinelog/group_11.282.1205153769         NO
        11         STANDBY +DATA/dr/onlinelog/group_11.283.1205153769         YES
        12         STANDBY +DATA/dr/onlinelog/group_12.284.1205153769         NO
        12         STANDBY +DATA/dr/onlinelog/group_12.285.1205153769         YES
        13         STANDBY +DATA/dr/onlinelog/group_13.286.1205153769         NO
        13         STANDBY +DATA/dr/onlinelog/group_13.287.1205153769         YES
        14         STANDBY +DATA/dr/onlinelog/group_14.288.1205153769         NO
        14         STANDBY +DATA/dr/onlinelog/group_14.289.1205153771         YES

-- Run the below query in both the nodes of primary to find the newly added standby redlog files:
SQL> set lines 999 pages 999
SQL> col inst_id for 9999
SQL> col group# for 9999
SQL> col member for a60
SQL> col archived for a7

SQL> SELECT
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

--At Node 1 (pdbdr1)
REDOLOG_FILE_TYPE    INST_ID GROUP#    THREAD#  SEQUENCE# MEMBER                                                       STATUS           ARCHIVE    SIZE_MB
-------------------- ------- ------ ---------- ---------- ------------------------------------------------------------ ---------------- ------- ----------
[ ONLINE REDO LOG ]        1      1          1          0 +DATA/dr/onlinelog/group_1.262.1205153763                    CURRENT          NO              50
[ ONLINE REDO LOG ]        1      1          1          0 +DATA/dr/onlinelog/group_1.263.1205153763                    CURRENT          NO              50
[ ONLINE REDO LOG ]        1      2          1          0 +DATA/dr/onlinelog/group_2.264.1205153763                    UNUSED           YES             50
[ ONLINE REDO LOG ]        1      2          1          0 +DATA/dr/onlinelog/group_2.265.1205153763                    UNUSED           YES             50
[ ONLINE REDO LOG ]        1      5          1          0 +DATA/dr/onlinelog/group_5.270.1205153765                    UNUSED           YES             50
[ ONLINE REDO LOG ]        1      5          1          0 +DATA/dr/onlinelog/group_5.271.1205153765                    UNUSED           YES             50
[ STANDBY REDO LOG ]       1      7          1          0 +DATA/dr/onlinelog/group_7.274.1205153767                    UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      7          1          0 +DATA/dr/onlinelog/group_7.275.1205153767                    UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      8          1          0 +DATA/dr/onlinelog/group_8.276.1205153767                    UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      8          1          0 +DATA/dr/onlinelog/group_8.277.1205153767                    UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      9          1          0 +DATA/dr/onlinelog/group_9.278.1205153767                    UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      9          1          0 +DATA/dr/onlinelog/group_9.279.1205153767                    UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1     10          1          0 +DATA/dr/onlinelog/group_10.280.1205153767                   UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1     10          1          0 +DATA/dr/onlinelog/group_10.281.1205153769                   UNASSIGNED       YES             50

SQL> show parameter spfile

NAME                                 TYPE        VALUE
------------------------------------ ----------- -----------------------------------------------------
spfile                               string      /opt/app/oracle/product/11.2.0.3.0/db_1/dbs/spfilepdbdb1.ora

SQL> !ls /opt/app/oracle/product/11.2.0.3.0/db_1/dbs/
hc_pdbdb1.dat  init.ora  initpdbdb1.ora  orapwpdbdb orapwpdbdb1  spfilepdbdb1.ora

SQL> CREATE PFILE='+DATA' FROM SPFILE='/opt/app/oracle/product/11.2.0.3.0/db_1/dbs/spfilepdbdb1.ora';
SQL> CREATE SPFILE='+DATA' FROM PFILE ='+DATA';


SQL> shut immediate
ORA-01109: database not open


Database dismounted.
ORACLE instance shut down.

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 127 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/dbs

-- Step 128.1 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ pwd
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/dbs
*/

-- Step 128.2 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ ll 
/*
-rw-r--r-- 1 oracle oinstall  6922 Jun 30 13:00 +DATA
-rw-rw---- 1 oracle oinstall  1544 Jun 30 13:00 hc_pdbdb1.dat
-rw-r--r-- 1 oracle oinstall  2851 May 15  2009 init.ora
-rw-r--r-- 1 oracle oinstall  1338 Jun 30 12:23 initpdbdb1.ora
-rw-r----- 1 oracle oinstall  1536 Jun 30 11:04 orapwpdbdb
-rw-r----- 1 oracle oinstall  1536 Jun 30 12:54 orapwpdbdb1
-rw-r----- 1 oracle oinstall 15872 Jun 30 12:55 spfilepdbdb1.ora
*/

-- Step 128.3 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ mv initpdbdb1.ora initpdbdb1.ora.backup
[oracle@pdbdr1 dbs]$ mv spfilepdbdb1.ora spfilepdbdb1.ora.backup

-- Step 129 -->> On Node 2 - DR
[grid@pdbdr1 ~]$ asmcmd
/*
ASMCMD> cd +DATA/DR/PARAMETERFILE/
ASMCMD> ls
spfile.290.1205154041
ASMCMD> exit
*/

-- Step 129.1 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/dbs

-- Step 129.2 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ pwd
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/dbs
*/

-- Step 129.3 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ echo "SPFILE='+DATA/DR/PARAMETERFILE/spfile.290.1205154041'" > initpdbdb1.ora

-- Step 129.4 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ ll -ltrh initpdbdb1.ora
/*
-rw-r--r-- 1 oracle oinstall 54 Jun 30 13:03 initpdbdb1.ora
*/

-- Step 129.5 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ cat initpdbdb1.ora
/*
SPFILE='+DATA/DR/PARAMETERFILE/spfile.290.1205154041'
*/

-- Step 129.6 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ scp -r initpdbdb1.ora oracle@pdbdr2:/opt/app/oracle/product/11.2.0.3.0/db_1/dbs/initpdbdb2.ora
/*
initpdbdb1.ora                                                             100%   57    45.3KB/s   00:00
*/

-- Step 129.7 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ ssh oracle@pdbdr2

[oracle@pdbdr2 ~]$ ll /opt/app/oracle/product/11.2.0.3.0/db_1/dbs/ | grep initpdbdb2.ora
/*
-rw-r--r-- 1 oracle oinstall   54 Jun 30 13:04 initpdbdb2.ora
*/

-- Step 129.8 -->> On Node 2 - DR
[oracle@pdbdr2 ~]$ cat /opt/app/oracle/product/11.2.0.3.0/db_1/dbs/initpdbdb2.ora
/*
SPFILE='+DATA/DR/PARAMETERFILE/spfile.290.1205154041'
*/

-- Step 129.9 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 13:05:30 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> !ls
+DATA_Backup  hc_pdbdb1.dat  init.ora  initpdbdb1.ora  initpdbdb1.ora.backup  orapwpdbdb  orapwpdbdb1  spfilepdbdb1.ora.backup

SQL> startup mount
ORACLE instance started.

Total System Global Area 6413680640 bytes
Fixed Size                  2240344 bytes
Variable Size            1107296424 bytes
Database Buffers         5284823040 bytes
Redo Buffers               19320832 bytes
Database mounted.

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           MOUNTED      30-JUN-25 pdbdr1.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 11.2.0.3.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED

SQL> show parameter spfile

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
spfile                               string      +DATA/DR/PARAMETERFILE/spfile.290.1205154041

SQL> show parameter control_files

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
control_files                        string      +DATA/dr/controlfile/current.256.1205153693

SQL> alter system set undo_tablespace=UNDOTBS2 sid='pdbdb2' scope=spfile;
SQL> alter system set instance_number=1 sid='pdbdb1' scope=spfile;
SQL> alter system set instance_number=2 sid='pdbdb2' scope=spfile;
SQL> alter system set instance_name='pdbdb1' sid='pdbdb1' scope=spfile;
SQL> alter system set instance_name='pdbdb2' sid='pdbdb2' scope=spfile;
SQL> alter system set thread=1 sid='pdbdb1' scope=spfile;
SQL> alter system set thread=2 sid='pdbdb2' scope=spfile;
SQL> alter system set cluster_database=TRUE  scope=spfile;
SQL> alter system set remote_listener='pdbdr-scan:1521' scope=spfile sid='*';
SQL> alter system set log_archive_dest_state_2=ENABLE scope=both sid='*';

SQL> shut immediate
ORA-01109: database not open


Database dismounted.
ORACLE instance shut down.

SQL> startup mount
ORACLE instance started.

Total System Global Area 6413680640 bytes
Fixed Size                  2240344 bytes
Variable Size            1107296424 bytes
Database Buffers         5284823040 bytes
Redo Buffers               19320832 bytes
Database mounted.

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,v$instance b;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE 
---------- ------------ ---------------- ---------------- ----------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED   

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           MOUNTED      30-JUN-25 pdbdr1.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 11.2.0.3.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED

--| SQL> show spparameter undo_tablespace
--| 
--| SID      NAME                          TYPE        VALUE
--| -------- ----------------------------- ----------- ----------------------------
--| *        undo_tablespace               string      UNDOTBS1
--| pdbdb2   undo_tablespace               string      UNDOTBS2
--| 
--| alter system reset undo_tablespace sid='*' scope=spfile;
--| alter system set undo_tablespace=UNDOTBS1 sid='pdbdb1' scope=spfile;

SQL> show spparameter undo_tablespace

SID      NAME                          TYPE        VALUE
-------- ----------------------------- ----------- ----------------------------
pdbdb1   undo_tablespace               string      UNDOTBS1
pdbdb2   undo_tablespace               string      UNDOTBS2

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 130 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ which srvctl
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/bin/srvctl
*/

-- Step 130.1 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ srvctl add database -d pdbdb -o /opt/app/oracle/product/11.2.0.3.0/db_1 -r physical_standby -s mount
[oracle@pdbdr1 ~]$ srvctl modify database -d pdbdb -p +DATA/DR/PARAMETERFILE/spfile.290.1205154041
[oracle@pdbdr1 ~]$ srvctl modify database -d pdbdb -a "DATA,ARC"
[oracle@pdbdr1 ~]$ srvctl add instance -d pdbdb -i pdbdb1 -n pdbdr1
[oracle@pdbdr1 ~]$ srvctl add instance -d pdbdb -i pdbdb2 -n pdbdr2

-- Step 130.2 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ srvctl config database -d pdbdb 
/*
Database unique name: pdbdb
Database name:
Oracle home: /opt/app/oracle/product/11.2.0.3.0/db_1
Oracle user: oracle
Spfile: +DATA/DR/PARAMETERFILE/spfile.290.1205154041
Domain:
Start options: mount
Stop options: immediate
Database role: PHYSICAL_STANDBY
Management policy: AUTOMATIC
Server pools: pdbdb
Database instances: pdbdb1,pdbdb2
Disk Groups: DATA,ARC
Mount point paths:
Services:
Type: RAC
Database is administrator managed
*/

-- Step 131 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 13:12:27 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> shut immediate
ORA-01109: database not open


Database dismounted.
ORACLE instance shut down.

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 132 -->> On Node 1 - DR
[oracle@pdbdr1/pdbdr2 ~]$ srvctl start database -d pdbdb -o mount
[oracle@pdbdr1/pdbdr2 ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is running on node pdbdr1
Instance pdbdb2 is running on node pdbdr2
*/

-- Step 132.1 -->> On Node 1 - DR
[oracle@pdbdr1/pdbdr2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdbdr1. Instance status: Mounted (Closed).
Instance pdbdb2 is running on node pdbdr2. Instance status: Mounted (Closed).
*/

-- Step 133 -->> On Node 1 - DR
[oracle@pdbdr1/pdbdr2 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 13:14:50 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> select status,instance_name from gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
MOUNTED      pdbdb1
MOUNTED      pdbdb2


SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           MOUNTED      30-JUN-25 pdbdr1.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 11.2.0.3.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED
         2 PDBDB     pdbdb2           MOUNTED      30-JUN-25 pdbdr2.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 11.2.0.3.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 11.2.0.3.0 - Production
Version 11.2.0.3.0
*/

-- Step 134 -->> On Node 1 - DR
[root@pdbdr1/pdbdr2 ~]# cd /opt/app/11.2.0.3.0/grid/bin/

-- Step 134.1 -->> On Node 1 - DR
[root@pdbdr1/pdbdr2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.ARC.dg
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
ora.DATA.dg
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
ora.LISTENER.lsnr
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
ora.OCR.dg
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
ora.asm
               ONLINE  ONLINE       pdbdr1                   Started
               ONLINE  ONLINE       pdbdr2                   Started
ora.gsd
               OFFLINE OFFLINE      pdbdr1
               OFFLINE OFFLINE      pdbdr2
ora.net1.network
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
ora.ons
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdbdr2
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdbdr1
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       pdbdr1
ora.cvu
      1        ONLINE  ONLINE       pdbdr1
ora.oc4j
      1        ONLINE  ONLINE       pdbdr1
ora.pdbdb.db
      1        ONLINE  INTERMEDIATE pdbdr1                   Mounted (Closed)
      2        ONLINE  INTERMEDIATE pdbdr2                   Mounted (Closed)
ora.pdbdr1.vip
      1        ONLINE  ONLINE       pdbdr1
ora.pdbdr2.vip
      1        ONLINE  ONLINE       pdbdr2
ora.scan1.vip
      1        ONLINE  ONLINE       pdbdr2
ora.scan2.vip
      1        ONLINE  ONLINE       pdbdr1
ora.scan3.vip
      1        ONLINE  ONLINE       pdbdr1
*/

-- Step 135 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 13:16:19 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> select status,instance_name from gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
OPEN         pdbdb1
OPEN         pdbdb2

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           OPEN         30-JUN-25 pdb1.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          11.2.0.3.0        MAXIMUM PERFORMANCE  TO STANDBY
         2 PDBDB     pdbdb2           OPEN         30-JUN-25 pdb2.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          11.2.0.3.0        MAXIMUM PERFORMANCE  TO STANDBY

SQL> alter system archive log current;

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
            39          1
            30          2

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 136 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 13:17:52 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> select status,instance_name from gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
MOUNTED      pdbdb1
MOUNTED      pdbdb2

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           MOUNTED      17-JUN-25 pdbdr1.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 11.2.0.3.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED
         2 PDBDB     pdbdb2           MOUNTED      17-JUN-25 pdbdr2.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 11.2.0.3.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
            39          1
            30          2

SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         2         31 APPLYING_LOG        119 MRP0

SQL> SELECT sequence#,status,block#,process FROM v$managed_standby ;

 SEQUENCE# STATUS           BLOCK# PROCESS
---------- ------------ ---------- ---------
        29 CLOSING               1 ARCH
        38 CLOSING               1 ARCH
         0 CONNECTED             0 ARCH
        39 CLOSING               1 ARCH
        30 CLOSING               1 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 IDLE                  0 RFS
         0 IDLE                  0 RFS
        31 IDLE                136 RFS
         0 IDLE                  0 RFS
        40 IDLE                136 RFS
         0 IDLE                  0 RFS
        31 APPLYING_LOG        135 MRP0

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/


-- Step 137 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 137.1 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ pwd
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/network/admin
*/

-- Step 137.2 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ vi tnsnames.ora
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

DR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = dr)
    )
  )
*/

-- Step 137.3 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ tnsping dr
/*
TNS Ping Utility for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 13:22:08

Copyright (c) 1997, 2011, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = dr)))
OK (0 msec)
*/

-- Step 138 -->> On Node 2 - DR
[oracle@pdbdr2 ~]$ cd $ORACLE_HOME/network/admin

-- Step 138.1 -->> On Node 1 - DR
[oracle@pdbdr2 admin]$ pwd
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/network/admin
*/

-- Step 138.2 -->> On Node 1 - DR
[oracle@pdbdr2 admin]$ vi tnsnames.ora
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

DR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = dr)
    )
  )
*/

-- Step 138.3 -->> On Node 1 - DR
[oracle@pdbdr2 admin]$ tnsping dr
/*
TNS Ping Utility for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 13:22:09

Copyright (c) 1997, 2011, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = dr)))
OK (0 msec)
*/

-- Step 139 -->> On Node 1 - DC
[oracle@pdb1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 139.1 -->> On Node 1 - DC
[oracle@pdb1 admin]$ pwd
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/network/admin
*/

-- Step 139.2 -->> On Node 1 - DC
[oracle@pdb1 admin]$ vi tnsnames.ora
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

DR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = dr)
    )
  )
*/

-- Step 139.3 -->> On Node 1 - DC
[oracle@pdb1 admin]$ tnsping dr
/*
TNS Ping Utility for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 13:24:22

Copyright (c) 1997, 2011, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = dr)))
OK (0 msec)
*/

-- Step 140 -->> On Node 2 - DC
[oracle@pdb2 ~]$ cd $ORACLE_HOME/network/admin

-- Step 140.1 -->> On Node 2 - DC
[oracle@pdb2 admin]$ pwd
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/network/admin
*/

-- Step 140.2 -->> On Node 2 - DC
[oracle@pdb2 admin]$ vi tnsnames.ora
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

DR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = dr)
    )
  )
*/

-- Step 140.3 -->> On Node 2 - DC
[oracle@pdb2 admin]$ tnsping dr
/*
TNS Ping Utility for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 13:24:24

Copyright (c) 1997, 2011, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = dr)))
OK (0 msec)
*/

-- Step 141 -->> On Node 1 - DC
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 141.1 -->> On Node 1 - DC
[oracle@pdb1 admin]$ pwd
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/network/admin
*/

-- Step 141.2 -->> On Node 1 - DC
[oracle@pdbdr1 admin]$ ll | grep listener.ora
/*
-rw-r--r-- 1 oracle oinstall  319 Jun 30 12:49 listener.ora
*/

-- Step 141.3 -->> On Node 1 - DC
[oracle@pdbdr1 admin]$ ps -ef | grep tns
/*
root        64     2  0 Jun29 ?        00:00:00 [netns]
oracle   14471     1  0 12:50 ?        00:00:00 /opt/app/oracle/product/11.2.0.3.0/db_1/bin/tnslsnr listener1 -inherit
oracle   17551 17205  0 13:25 pts/0    00:00:00 grep tns
grid     18444     1  0 Jun29 ?        00:00:01 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN3 -inherit
grid     18451     1  0 Jun29 ?        00:00:01 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN2 -inherit
grid     18464     1  0 Jun29 ?        00:00:01 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER -inherit
*/

-- Step 141.4 -->> On Node 1 - DC
[oracle@pdbdr1 admin]$ lsnrctl status listener1
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 13:25:31

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))
STATUS of the LISTENER
------------------------
Alias                     listener1
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                30-JUN-2025 12:50:26
Uptime                    0 days 0 hr. 35 min. 5 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/oracle/product/11.2.0.3.0/db_1/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))
Services Summary...
Service "dr" has 1 instance(s).
  Instance "pdbdb1", status UNKNOWN, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 141.5 -->> On Node 1 - DC
[oracle@pdbdr1 admin]$ lsnrctl stop listener1
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 13:25:47

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))
The command completed successfully
*/

-- Step 141.6 -->> On Node 1 - DC
[oracle@pdbdr1 admin]$ lsnrctl status listener1
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 13:26:07

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))
TNS-12541: TNS:no listener
 TNS-12560: TNS:protocol adapter error
  TNS-00511: No listener
   Linux Error: 111: Connection refused
*/

-- Step 141.7 -->> On Node 1 - DC
[oracle@pdbdr1 admin]$ ps -ef | grep tns
/*
root        64     2  0 Jun29 ?        00:00:00 [netns]
oracle   17606 17205  0 13:26 pts/0    00:00:00 grep tns
grid     18444     1  0 Jun29 ?        00:00:01 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN3 -inherit
grid     18451     1  0 Jun29 ?        00:00:01 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN2 -inherit
grid     18464     1  0 Jun29 ?        00:00:01 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER -inherit
*/

-- Step 142 -->> On Node 1 - DR
--To Resolve the "ORA-16191: Primary log shipping client not logged on standby" genrally the issue arived in place when we made DR using duplicate command on 11gR2
[grid@pdbdr1 ~]$ vi /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
/*
LISTENER_SCAN3=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3))))     # line added by Agent
LISTENER_SCAN2=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2))))     # line added by Agent
LISTENER=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER))))            # line added by Agent
LISTENER_SCAN1=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1))))     # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN1=ON                # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER=ON              # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN2=ON                # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN3=ON                # line added by Agent

SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
      (GLOBAL_DBNAME = dr)
      (ORACLE_HOME = /opt/app/oracle/product/11.2.0.3.0/db_1)
      (SID_NAME = pdbdb)
    )
  )
*/

-- Step 142.1 -->> On Node 2 - DR
[grid@pdbdr2 ~]$ vi /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
/*
LISTENER_SCAN3=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3))))     # line added by Agent
LISTENER_SCAN2=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2))))     # line added by Agent
LISTENER=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER))))            # line added by Agent
LISTENER_SCAN1=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1))))     # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN1=ON                # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER=ON              # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN2=ON                # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN3=ON                # line added by Agent

SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
      (GLOBAL_DBNAME = dr)
      (ORACLE_HOME = /opt/app/oracle/product/11.2.0.3.0/db_1)
      (SID_NAME = pdbdb)
    )
  )
*/

-- Step 143 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 13:29:20 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> select status,instance_name from gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
OPEN         pdbdb1
OPEN         pdbdb2

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           OPEN         30-JUN-25 pdb1.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          11.2.0.3.0        MAXIMUM PERFORMANCE  TO STANDBY
         2 PDBDB     pdbdb2           OPEN         30-JUN-25 pdb2.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          11.2.0.3.0        MAXIMUM PERFORMANCE  TO STANDBY

SQL> alter system archive log current;
SQL> alter system switch logfile;

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
            43          1
            34          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 144 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 13:30:10 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> select status,instance_name from gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
MOUNTED      pdbdb1
MOUNTED      pdbdb2

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           MOUNTED      30-JUN-25 pdbdr1.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 11.2.0.3.0        MAXIMUM PERFORMANCE  NOT ALLOWED
         2 PDBDB     pdbdb2           MOUNTED      30-JUN-25 pdbdr2.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 11.2.0.3.0        MAXIMUM PERFORMANCE  NOT ALLOWED

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
            43          1
            34          2

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
            43          1
            33          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         2         35 APPLYING_LOG        109 MRP0

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

Database altered.

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;

Database altered.

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
            43          1
            34          2

SQL>  SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL>  SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         2         35 APPLYING_LOG        177 MRP0

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 11.2.0.3.0 - Production
Version 11.2.0.3.0
*/

-- Step 145 -->> On Node 1 - DC
[grid@pdb1 ~]$ ps -ef | grep SCAN
/*
grid     10050 10013  0 14:38 pts/0    00:00:00 grep SCAN
grid     27773     1  0 Jun27 ?        00:00:05 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN2 -inherit
grid     27778     1  0 Jun27 ?        00:00:05 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN3 -inherit
*/

-- Step 145.1 -->> On Node 1 - DC
[grid@pdb1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 14:38:50

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                27-JUN-2025 14:34:13
Uptime                    3 days 0 hr. 4 min. 37 sec
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

-- Step 145.2 -->> On Node 1 - DC
[grid@pdb1 ~]$ lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 14:39:08

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                27-JUN-2025 14:34:13
Uptime                    3 days 0 hr. 4 min. 54 sec
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

-- Step 145.3 -->> On Node 1 - DC
[grid@pdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 14:39:25

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                27-JUN-2025 14:34:13
Uptime                    3 days 0 hr. 5 min. 11 sec
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

-- Step 145.4 -->> On Node 2 - DC
[grid@pdb2 ~]$ ps -ef | grep SCAN
/*
grid     22386     1  0 Jun27 ?        00:00:06 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN1 -inherit
grid     25763 25736  0 14:38 pts/0    00:00:00 grep SCAN
*/

-- Step 145.5 -->> On Node 2 - DC
[grid@pdb2 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 14:40:08

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                27-JUN-2025 14:34:47
Uptime                    3 days 0 hr. 5 min. 20 sec
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

-- Step 145.6 -->> On Node 2 - DC
[grid@pdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 14:40:25

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                27-JUN-2025 14:34:17
Uptime                    3 days 0 hr. 6 min. 8 sec
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

-- Step 146 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ ps -ef | grep SCAN
/*
grid     18444     1  0 Jun29 ?        00:00:01 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN3 -inherit
grid     18451     1  0 Jun29 ?        00:00:01 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN2 -inherit
grid     20812 20786  0 14:40 pts/0    00:00:00 grep SCAN
*/

-- Step 146.1 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 14:41:16

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                29-JUN-2025 16:12:55
Uptime                    0 days 22 hr. 28 min. 21 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/11.2.0.3.0/grid/log/diag/tnslsnr/pdbdr1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.53)(PORT=1521)))
Services Summary...
Service "dr" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 146.2 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 14:41:41

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                29-JUN-2025 16:12:55
Uptime                    0 days 22 hr. 28 min. 46 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/11.2.0.3.0/grid/log/diag/tnslsnr/pdbdr1/listener_scan3/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN3)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.54)(PORT=1521)))
Services Summary...
Service "dr" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/
-- Step 146.3 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ lsnrctl status
/*

LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 14:42:15

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                29-JUN-2025 16:12:55
Uptime                    0 days 22 hr. 29 min. 20 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.48)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.50)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "dr" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 146.4 -->> On Node 2 - DR
[grid@pdbdr2 ~]$ ps -ef | grep SCAN
/*
grid       912   884  0 14:41 pts/0    00:00:00 grep SCAN
grid     15707     1  0 Jun29 ?        00:00:01 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN1 -inherit
*/

-- Step 146.5 -->> On Node 2 - DR
[grid@pdbdr2 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 14:43:13

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                29-JUN-2025 16:13:21
Uptime                    0 days 22 hr. 29 min. 52 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/11.2.0.3.0/grid/log/diag/tnslsnr/pdbdr2/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.52)(PORT=1521)))
Services Summary...
Service "dr" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 146.6 -->> On Node 2 - DR
[grid@pdbdr2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 14:43:37

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                29-JUN-2025 16:12:58
Uptime                    0 days 22 hr. 30 min. 38 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.49)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.51)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "dr" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 147 -->> On Both Node's - DC
[oracle@pdb1/pdb2 ~]$ rman target /
/*
Recovery Manager: Release 11.2.0.3.0 - Production on Mon Jun 30 14:44:44 2025

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

-- Step 148 -->> On Both Node's - DR
[oracle@pdbdr1/pdbdr2 ~]$ rman target /
/*
Recovery Manager: Release 11.2.0.3.0 - Production on Tue Jun 17 16:11:12 2025

Copyright (c) 1982, 2011, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB (DBID=3261538595, not open)

RMAN> show all;

using target database control file instead of recovery catalog
RMAN configuration parameters for database with db_unique_name DR are:
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

-- Step 149 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ mkdir -p /backup/script
[oracle@pdbdr1 ~]$ chmod -R 775 /backup/script

-- Step 149.1 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ vi /backup/script/dr_archivedelete.sh
/*

##SOS to script deletes the applied archivelog file in standby database##

export ORACLE_HOME="/opt/app/oracle/product/11.2.0.3.0/db_1"
export ORACLE_SID=""pdbdb1""
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

-- Step 149.2 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ /backup/script/dr_archivedelete.sh

-- Step 150 -->> On Node 1 - DR
[root@pdbdr1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/11.2.0.3.0/grid:N
pdbdb:/opt/app/oracle/product/11.2.0.3.0/db_1:N
pdbdb1:/opt/app/oracle/product/11.2.0.3.0/db_1:N
*/

-- Step 151 -->> On Node 2 - DR
[root@pdbdr2 ~]# vi /etc/oratab
/*
+ASM2:/opt/app/11.2.0.3.0/grid:N
pdbdb:/opt/app/oracle/product/11.2.0.3.0/db_1:N
pdbdb2:/opt/app/oracle/product/11.2.0.3.0/db_1:N
*/

-- Step 152 -->> On Node 2 - DR
-- To Fix the ADRCI log if occured in remote nodes
-- Step Fix.1 -->> On Node 2
[oracle@pdbdr2 ~]$ adrci
/*
ADRCI: Release 11.2.0.3.0 - Production on Tue Jun 17 16:16:27 2025

Copyright (c) 1982, 2011, Oracle and/or its affiliates.  All rights reserved.

No ADR base is set

adrci> exit
*/

-- Step Fix.2 -->> On Node 2
[oracle@pdbdr1 ~]$ ls -ltr /opt/app/oracle/product/11.2.0.3.0/db_1/log/diag/
/*
-rw-r----- 1 oracle asmadmin 16 Oct  8 10:59 adrci_dir.mif
*/

-- Step Fix.3 -->> On Node 2
[oracle@pdbdr2 ~]$ cd /opt/app/oracle/product/11.2.0.3.0/db_1/
[oracle@pdbdr2 db_1]$ mkdir -p log/diag
[oracle@pdbdr2 db_1]$ mkdir -p log/pdbdr2/client
[oracle@pdbdr2 db_1]$ cd log
[oracle@pdbdr2 db_1]$ chown -R oracle:asmadmin diag
-- Step Fix.4 -->> On Node 1
[oracle@pdbdr1 ~]$ scp -r /opt/app/oracle/product/11.2.0.3.0/db_1/log/diag/adrci_dir.mif oracle@pdbdr2:/opt/app/oracle/product/11.2.0.3.0/db_1/log/diag/

-- Step Fix.5 -->> On Node 2
[oracle@pdbdr2 ~]$ adrci
/*
ADRCI: Release 11.2.0.3.0 - Production on Tue Jun 17 16:16:27 2025

Copyright (c) 1982, 2011, Oracle and/or its affiliates.  All rights reserved.

ADR base = "/opt/app/oracle"

adrci> exit
*/

-- Step 153 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 14:50:17 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options


SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

Database altered.

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 11.2.0.3.0 - Production
Version 11.2.0.3.0
*/

-- Step 154 -->> On Node 1 - DR
[root@pdbdr1 ~]# cd /opt/app/11.2.0.3.0/grid/bin/

-- Step 154.1 -->> On Node 1 - DR
[root@pdbdr1 bin]# ./crsctl stop cluster -all

-- Step 154.2 -->> On Node 1 - DR
[root@pdbdr1 bin]# ./crsctl start cluster -all

-- Step 154.3 -->> On Node 1 - DR
[root@pdbdr1 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdbdr1                   Started
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       pdbdr1
ora.crf
      1        ONLINE  ONLINE       pdbdr1
ora.crsd
      1        ONLINE  ONLINE       pdbdr1
ora.cssd
      1        ONLINE  ONLINE       pdbdr1
ora.cssdmonitor
      1        ONLINE  ONLINE       pdbdr1
ora.ctssd
      1        ONLINE  ONLINE       pdbdr1                   ACTIVE:0
ora.diskmon
      1        OFFLINE OFFLINE
ora.evmd
      1        ONLINE  ONLINE       pdbdr1
ora.gipcd
      1        ONLINE  ONLINE       pdbdr1
ora.gpnpd
      1        ONLINE  ONLINE       pdbdr1
ora.mdnsd
      1        ONLINE  ONLINE       pdbdr1
*/

-- Step 154.4 -->> On Node 2 - DR
[root@pdbdr2 ~]# cd /opt/app/11.2.0.3.0/grid/bin/

-- Step 154.5 -->> On Node 2 - DR
[root@pdbdr2 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdbdr2                   Started
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       pdbdr2
ora.crf
      1        ONLINE  ONLINE       pdbdr2
ora.crsd
      1        ONLINE  ONLINE       pdbdr2
ora.cssd
      1        ONLINE  ONLINE       pdbdr2
ora.cssdmonitor
      1        ONLINE  ONLINE       pdbdr2
ora.ctssd
      1        ONLINE  ONLINE       pdbdr2                   ACTIVE:0
ora.diskmon
      1        OFFLINE OFFLINE
ora.evmd
      1        ONLINE  ONLINE       pdbdr2
ora.gipcd
      1        ONLINE  ONLINE       pdbdr2
ora.gpnpd
      1        ONLINE  ONLINE       pdbdr2
ora.mdnsd
      1        ONLINE  ONLINE       pdbdr2
*/

-- Step 155 -->> On Both Nodes - DR
[root@pdbdr1/pdbdr2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.ARC.dg
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
ora.DATA.dg
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
ora.LISTENER.lsnr
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
ora.OCR.dg
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
ora.asm
               ONLINE  ONLINE       pdbdr1                   Started
               ONLINE  ONLINE       pdbdr2                   Started
ora.gsd
               OFFLINE OFFLINE      pdbdr1
               OFFLINE OFFLINE      pdbdr2
ora.net1.network
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
ora.ons
               ONLINE  ONLINE       pdbdr1
               ONLINE  ONLINE       pdbdr2
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdbdr2
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdbdr1
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       pdbdr1
ora.cvu
      1        ONLINE  ONLINE       pdbdr1
ora.oc4j
      1        ONLINE  ONLINE       pdbdr1
ora.pdbdb.db
      1        ONLINE  INTERMEDIATE pdbdr1                   Mounted (Closed)
      2        ONLINE  INTERMEDIATE pdbdr2                   Mounted (Closed)
ora.pdbdr1.vip
      1        ONLINE  ONLINE       pdbdr1
ora.pdbdr2.vip
      1        ONLINE  ONLINE       pdbdr2
ora.scan1.vip
      1        ONLINE  ONLINE       pdbdr2
ora.scan2.vip
      1        ONLINE  ONLINE       pdbdr1
ora.scan3.vip
      1        ONLINE  ONLINE       pdbdr1
*/

-- Step 156 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 15:12:18

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                30-JUN-2025 15:02:50
Uptime                    0 days 0 hr. 9 min. 27 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.48)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.50)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "dr" has 2 instance(s).
  Instance "pdbdb", status UNKNOWN, has 1 handler(s) for this service...
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 156.1 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ ps -ef | grep SCAN
/*
grid     22603     1  0 15:06 ?        00:00:00 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN3 -inherit
grid     22616     1  0 15:06 ?        00:00:00 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN2 -inherit
grid     23044 22544  0 15:14 pts/0    00:00:00 grep SCAN
*/

-- Step 156.2 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 15:14:23

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                30-JUN-2025 15:06:52
Uptime                    0 days 0 hr. 7 min. 31 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/11.2.0.3.0/grid/log/diag/tnslsnr/pdbdr1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.53)(PORT=1521)))
Services Summary...
Service "dr" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 156.3 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 15:14:40

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                30-JUN-2025 15:06:51
Uptime                    0 days 0 hr. 7 min. 49 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/11.2.0.3.0/grid/log/diag/tnslsnr/pdbdr1/listener_scan3/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN3)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.54)(PORT=1521)))
Services Summary...
Service "dr" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 157 -->> On Node 2 - DR
[grid@pdbdr2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 15:12:25

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                30-JUN-2025 15:10:04
Uptime                    0 days 0 hr. 2 min. 20 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.49)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.51)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "dr" has 2 instance(s).
  Instance "pdbdb", status UNKNOWN, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
*/

-- Step 157.1 -->> On Node 2 - DR
[grid@pdbdr2 ~]$ ps -ef | grep SCAN
/*
grid      3657     1  0 15:10 ?        00:00:00 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN1 -inherit
grid      4128  4047  0 15:14 pts/0    00:00:00 grep SCAN
*/

-- Step 157.2 -->> On Node 2 - DR
[grid@pdbdr2 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 15:15:25

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                30-JUN-2025 15:10:04
Uptime                    0 days 0 hr. 5 min. 20 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/11.2.0.3.0/grid/log/diag/tnslsnr/pdbdr2/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.52)(PORT=1521)))
Services Summary...
Service "dr" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 158 -->> On Both Nodes - DR
[oracle@pdbdr1/pdbdr2 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): pdbdr2,pdbdr1
*/

-- Step 159 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 15:16:26

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                30-JUN-2025 15:02:50
Uptime                    0 days 0 hr. 13 min. 36 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.48)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.50)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "dr" has 2 instance(s).
  Instance "pdbdb", status UNKNOWN, has 1 handler(s) for this service...
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 160 -->> On Node 2 - DR
[oracle@pdbdr2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 30-JUN-2025 15:16:27

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                30-JUN-2025 15:10:04
Uptime                    0 days 0 hr. 6 min. 23 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.49)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.51)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "dr" has 2 instance(s).
  Instance "pdbdb", status UNKNOWN, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 161 -->> On Both Nodes - DR
[oracle@pdbdr1/pdbdr2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdbdr1. Instance status: Mounted (Closed).
Instance pdbdb2 is running on node pdbdr2. Instance status: Mounted (Closed).
*/

-- Step 162 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 15:17:25 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;

Database altered.

SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         1         48 APPLYING_LOG        937 MRP0

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
            47          1
            39          2

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
            46          1
            39          2

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

---------------------------------------------------------------------------------------------------------------
--------------------------------------Two Nodes DR Drill Senty Testing-----------------------------------------
---------------------------------------------------------------------------------------------------------------
----------------------------------------------Snapshot Standby-------------------------------------------------
---------------------------------------------------------------------------------------------------------------
Snapshot standby allows the standby database to be opened in read-write mode. 
When switched back into standby mode, all changes made whilst in read-write mode are lost. 
This is achieved using flashback database, but the standby database does not need to have flashback database
explicitly enabled to take advantage of this feature, thought it works just the same if it is.

Note: If you are using RAC-DC/DR, then turn off all RAC-DR db instance but one of the RAC-DR db instances should be UP and running in MOUNT mode.

-- Step 1.1
-- Verify the DB instance status of Primary Database -> DC
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 1.2
-- Verify the DB instance status of Primary Database -> DC
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE
*/

-- Step 1.3
-- Connect the DB instance to Create Objects on Primary Database -> DC
-- Step 1.3.1
SQL> CREATE TABLESPACE tbs_snapshot
     DATAFILE '+DATA'
     SIZE 1g
     AUTOEXTEND ON NEXT 512m MAXSIZE UNLIMITED
     SEGMENT SPACE MANAGEMENT AUTO;

Tablespace created.

-- Step 1.3.2
SQL> CREATE USER snapshot IDENTIFIED BY "Sn#P#5h0#T"
     DEFAULT TABLESPACE tbs_snapshot
     TEMPORARY TABLESPACE TEMP
     QUOTA UNLIMITED ON tbs_snapshot;

User created.

-- Step 1.3.3
SQL> GRANT CONNECT,RESOURCE TO snapshot;

Grant succeeded.

-- Step 1.3.4
-- Connect with any user of Primary Database -> DC
SQL> conn snapshot/"Sn#P#5h0#T"
/*
Connected.
*/

-- Step 1.3.5
SQL> show user
USER is "SNAPSHOT"

-- Step 1.3.6
-- Create a object with relevant user of Primary Database -> DC
SQL> CREATE TABLE snapshot.snapshot_standby_test AS
     SELECT
          LEVEL sn
     FROM dual
     CONNECT BY LEVEL <=10;
/*
Table created.
*/

-- Step 1.3.7
-- Verify the Create a object of Primary Database -> DC
SQL> SELECT * FROM  snapshot.snapshot_standby_test;
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

-- Step 1.4
-- Connect with sys user of Primary Database -> DC
SQL> conn sys/Sys605014 as sysdba
/*
Connected.
*/

-- Step 1.5
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
            56          1
            42          2
*/

-- Step 2.1
-- Verify the DB instance status of Secondary Database -> DR
[oracle@pdbdr1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdbdr1. Instance status: Mounted (Closed).
Instance pdbdb2 is running on node pdbdr2. Instance status: Mounted (Closed).
*/

-- Step 2.2
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED
*/

-- Step 2.4
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;
/*
MAX(SEQUENCE#)    THREAD#
-------------- ----------
            55          1
            42          2
*/

-- Step 2.5
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT inst_id,status,instance_name FROM gv$instance;
/*
   INST_ID STATUS       INSTANCE_NAME
---------- ------------ ----------------
         1 MOUNTED      pdbdb1
         2 MOUNTED      pdbdb2
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
[oracle@pdbdr1 ~]$ srvctl stop database -d pdbdb
[oracle@pdbdr1 ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is not running on node pdbdr1
Instance pdbdb2 is not running on node pdbdr2
*/

-- Step 3.1
[oracle@pdbdr1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is not running on node pdbdr1
Instance pdbdb2 is not running on node pdbdr2
*/
-- Step 3.2
-- To start the DB services for node 1 and status Secondary Database -> DR
[oracle@pdbdr1 ~]$ srvctl start instance -d pdbdb -i pdbdb1 -o mount
[oracle@pdbdr1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdbdr1. Instance status: Mounted (Closed).
Instance pdbdb2 is not running on node pdbdr2
*/

-- Step 3.3
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT inst_id,status,instance_name FROM gv$instance;
/*
   INST_ID STATUS       INSTANCE_NAME
---------- ------------ ----------------
         1 MOUNTED      pdbdb1
*/

-- Step 3.4
--  Covert physical standby database to snapshot standby database -> DR.
SQL> ALTER DATABASE CONVERT TO SNAPSHOT STANDBY;
/*
Database altered.
*/

-- Step 3.5
-- The physical standby database in snapshot standby database status shoud be in mount mode -> DR
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           SNAPSHOT STANDBY MOUNTED
*/

-- Step 3.6
-- Bring the database in open mode -> DR
SQL> ALTER DATABASE OPEN;
/*
Database altered.
*/

-- Step 3.7
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT inst_id,status,instance_name FROM gv$instance;
/*
   INST_ID STATUS       INSTANCE_NAME
---------- ------------ ----------------
         1 OPEN         pdbdb1
*/


-- Step 3.8
-- Verify the restore point of Secondary Database -> DR
SQL> SELECT inst_id,flashback_on FROM gv$database;
/*
   INST_ID FLASHBACK_ON
---------- ------------------
         1 RESTORE POINT ONLY
*/

-- Step 3.9
-- Verify the Added Data Files on Primary Database -> DC and properly reflected on Secondary Database -> DR 
SQL> conn snapshot/"Sn#P#5h0#T"
/*
Connected.
*/

-- Step 3.10
-- Verify the Added Data Files on Primary Database -> DC and properly reflected on Secondary Database -> DR 
SQL> show user
/*
USER is "SNAPSHOT"
*/

-- Step 3.11
-- Verify the Data populated on Primary Database -> DC and properly reflected on Secondary Database -> DR  
SQL> select * from snapshot.snapshot_standby_test;
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

-- Step 4 =>> (Covert back physical standby database from snapshot standby database.)
-- Shutdown the DR database -> DR
SQL> conn sys/Sys605014@dr as sysdba
/*
Connected.
*/

-- Step 4.1
-- Verify the Added Data Files on Primary Database -> DC and properly reflected on Secondary Database -> DR 
SQL> shutdown immediate;
/*
Database closed.
Database dismounted.
ORACLE instance shut down.
*/

-- Step 4.2
-- Bring the database in mount mode -> DR
SQL> startup mount;
/*
ORACLE instance started.

Total System Global Area 6413680640 bytes
Fixed Size                  2240344 bytes
Variable Size            1107296424 bytes
Database Buffers         5284823040 bytes
Redo Buffers               19320832 bytes
Database mounted.
*/

-- Step 4.3
-- Covert back physical standby database from snapshot standby database -> DR.
SQL> ALTER DATABASE CONVERT TO PHYSICAL STANDBY;
/*
Database altered.
*/

-- Step 4.4
-- Shutdown the database -> DR
SQL> shutdown immediate;
/*
ORA-01109: database not open


Database dismounted.
ORACLE instance shut down.
*/

-- Step 4.5
-- Bring the database in nomount mode -> DR
SQL> startup nomount;
/*
ORACLE instance started.

Total System Global Area 6413680640 bytes
Fixed Size                  2240344 bytes
Variable Size            1107296424 bytes
Database Buffers         5284823040 bytes
Redo Buffers               19320832 bytes
*/

-- Step 4.6
-- Bring the database in mount mode -> DR
SQL> ALTER DATABASE MOUNT STANDBY DATABASE;
/*
Database altered.
*/

-- Step 4.7
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
*/

-- Step 4.8
-- Verify the DB services status Secondary Database -> DR
[oracle@pdbdr1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdbdr1. Instance status: Mounted (Closed).
Instance pdbdb2 is not running on node pdbdr2
*/

-- Step 4.9
-- To stop the DB services and status Secondary Database -> DR
[oracle@pdbdr1 ~]$ srvctl stop database -d pdbdb
[oracle@pdbdr1 ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is not running on node pdbdr1
Instance pdbdb2 is not running on node pdbdr2
*/

-- Step 4.10
-- To start the DB services and status Secondary Database -> DR
[oracle@pdbdr1 ~]$ srvctl start database -d pdbdb -o mount
[oracle@pdbdr1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdbdr1. Instance status: Mounted (Closed).
Instance pdbdb2 is running on node pdbdr2. Instance status: Mounted (Closed).
*/

-- Step 4.11
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT inst_id,status,instance_name from gv$instance;
/*
   INST_ID STATUS       INSTANCE_NAME
---------- ------------ ----------------
         1 MOUNTED      pdbdb1
         2 MOUNTED      pdbdb2
*/

-- Step 4.12
-- Verify the restore point of Secondary Database -> DR
SQL> SELECT inst_id,flashback_on FROM gv$database;
/*
INST_ID FLASHBACK_ON
------- ------------------
      1 NO
      2 NO
*/

-- Step 4.13
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED
*/

-- Step 4.14
-- Start the Recovery Process in Secondary Database -> DR
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;
/*
Database altered.
*/

-- Step 4.15
-- Verify the issue in Secondary Database -> DR
SQL> SELECT DISTINCT error FROM gv$archive_dest_status;
/*
ERROR
-----
*/

-- Step 4.16
-- Verify the MRP of Secondary Database -> DR
SELECT inst_id,process,thread#,sequence#,status FROM gv$managed_standby ORDER BY 1;
/*
SQL> SELECT inst_id,process,thread#,sequence#,status FROM gv$managed_standby ORDER BY 1;

   INST_ID PROCESS      THREAD#  SEQUENCE# STATUS
---------- --------- ---------- ---------- ------------
         1 ARCH               0          0 CONNECTED
         1 ARCH               1         57 CLOSING
         1 ARCH               2         43 CLOSING
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               1         65 CLOSING
         1 ARCH               2         50 CLOSING
         1 ARCH               2         51 CLOSING
         1 ARCH               0          0 CONNECTED
         1 ARCH               1         66 CLOSING
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               2         57 CLOSING
         1 ARCH               1         73 CLOSING
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
         1 MRP0               1         74 APPLYING_LOG
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                2         58 IDLE
         1 RFS                0          0 IDLE
         1 RFS                1         74 IDLE
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
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
*/

-- Step 4.17
SQL> SELECT * FROM gv$archive_gap;
/*
no rows selected
*/

-- Step 4.18
-- Verify the DB instance status of Primary Database -> DC
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE
*/

-- Step 4.19
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED
*/

---------------------------------------------------------------------------------------------------------------
------------------------------------Two Nodes DR Drill Senty Testing-------------------------------------------
---------------------------------------------------------------------------------------------------------------
-------------------------------Perform Manual Switchover on Physical Standby-----------------------------------
---------------------------------------------------------------------------------------------------------------
-- Step 1
--Verify the switchover status on the primary database:
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 2
--Verify the switchover status on the primary database:
[oracle@pdbdr1 ~]$  srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdbdr1. Instance status: Mounted (Closed).
Instance pdbdb2 is running on node pdbdr2. Instance status: Mounted (Closed).
*/

-- Step 3
--Verify the switchover status on the primary database:
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 15:39:38 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
            73          1
            57          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> set linesize 9999
SQL> select STATUS, GAP_STATUS from V$ARCHIVE_DEST_STATUS where DEST_ID = 2;

STATUS    GAP_STATUS
--------- ------------------------
VALID     NO GAP

SQL> select SWITCHOVER_STATUS from V$DATABASE;

SWITCHOVER_STATUS
--------------------
TO STANDBY <= (Must see TO STANDBY or SESSIONS ACTIVE)

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 4
--Verify the switchover status on the primary database:
[oracle@pdbdr1 ~]$  sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 15:39:41 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
            73          1
            57          2

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
            72          1
            57          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         1         74 APPLYING_LOG        373 MRP0

SQL> set linesize 9999
SQL> select NAME, VALUE, DATUM_TIME from V$DATAGUARD_STATS;

NAME                   VALUE            DATUM_TIME
---------------------- ---------------- -------------------
transport lag          +00 00:00:00     06/30/2025 15:43:12
apply lag              +00 00:00:00     06/30/2025 15:43:12
apply finish time      +00 00:00:00.000
estimated startup time 112


SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 5
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 5.1
[oracle@pdb1 ~]$ srvctl stop instance -d pdbdb -i pdbdb2

-- Step 5.2
--Commit to switchover to primary with session shutdown:
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 15:44:24 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> select name, open_mode, db_unique_name, database_role from v$database;

NAME      OPEN_MODE            DB_UNIQUE_NAME                 DATABASE_ROLE
--------- -------------------- ------------------------------ ----------------
PDBDB     READ WRITE           pdbdb                          PRIMARY

SQL> alter database commit to switchover to physical standby with session shutdown;

Database altered.

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 11.2.0.3.0 - Production
Version 11.2.0.3.0
*/

-- Step 6
--Verify the switchover status on the primary database:
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is not running on node pdb2
*/

-- Step 7
--Start the switchover primary database:
[oracle@pdb1 ~]$ srvctl stop database -d pdbdb
[oracle@pdb1 ~]$ srvctl start database -d pdbdb -o mount

-- Step 8
--Verify the switchover status of old primary database:
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Mounted (Closed).
Instance pdbdb2 is running on node pdb2. Instance status: Mounted (Closed).
*/

-- Step 9
--Verify the switchover status of old primary database:
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Thu Jun 19 15:52:32 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> select name, open_mode, db_unique_name, database_role from v$database;

NAME      OPEN_MODE            DB_UNIQUE_NAME                 DATABASE_ROLE
--------- -------------------- ------------------------------ ----------------
PDBDB     MOUNTED              pdbdb                          PHYSICAL STANDBY

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 11.2.0.3.0 - Production
Version 11.2.0.3.0
*/

-- Step 10
--Commit to switchover to primary with session shutdown:
[oracle@pdbdr1 ~]$  sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 15:48:41 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> select name, open_mode, db_unique_name, database_role from v$database;

NAME      OPEN_MODE            DB_UNIQUE_NAME                 DATABASE_ROLE
--------- -------------------- ------------------------------ ----------------
PDBDB     MOUNTED              dr                             PHYSICAL STANDBY

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED

SQL> select SWITCHOVER_STATUS from V$DATABASE;

SWITCHOVER_STATUS
--------------------
TO PRIMARY

SQL> alter database commit to switchover to primary with session shutdown;

Database altered.

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 11
-- Verify the DB services status of Old Secondary Database
[oracle@pdbdr1 ~]$  srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdbdr1. Instance status: Mounted (Closed).
Instance pdbdb2 is running on node pdbdr2. Instance status: Mounted (Closed).
*/

-- Step 12
-- Stop the DB services status of Old Secondary Database
[oracle@pdbdr1 ~]$  srvctl stop database -d pdbdb
[oracle@pdbdr1 ~]$  srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is not running on node pdbdr1
Instance pdbdb2 is not running on node pdbdr2
*/

-- Step 12.1
-- Start the DB services status of Old Secondary Database as New Primary Database
[oracle@pdbdr1 ~]$  srvctl start database -d pdbdb -o open
[oracle@pdbdr1 ~]$  srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdbdr1. Instance status: Open.
Instance pdbdb2 is running on node pdbdr2. Instance status: Open.
*/

-- Step 13
-- Verify the DB status of Old Secondary Database as New Primary Database
[oracle@pdbdr1 ~]$  sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 15:51:34 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> alter system switch logfile;

System altered.

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
            80          1
            64          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 14
-- On the new standby (initially the primary), start the MRP:
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Thu Jun 19 15:55:42 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;

Database altered.

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
            80          1
            64          2

SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby;

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         2         61 CLOSING               1 ARCH
         2         62 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         2         63 CLOSING               1 ARCH
         1         78 CLOSING               1 ARCH
         1         79 CLOSING               1 ARCH
         1         80 CLOSING               1 ARCH
         2         64 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         1         81 IDLE                137 RFS
         2         65 IDLE                133 RFS
         0          0 IDLE                  0 RFS
         2         65 APPLYING_LOG        131 MRP0
         1         76 CLOSING               1 ARCH
         2         60 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         1         77 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
            80          1
            63          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

---------------------------------------------------------------------------------------------------------------
--------------2 Node DC and DR - Manual SwitchBack on Physical Standby from New Primary------------------------
---------------------------------------------------------------------------------------------------------------

-- Step 15 =>> (Perform Manual SwitchBack on Physical Standby from New Primary)
-- Verify the SwitchBack status on the primary database:
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Mounted (Closed).
Instance pdbdb2 is running on node pdb2. Instance status: Mounted (Closed).
*/

-- Step 16
--Verify the SwitchBack status on the primary database:
[oracle@pdbdr1 ~]$  srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdbdr1. Instance status: Open.
Instance pdbdb2 is running on node pdbdr2. Instance status: Open.
*/

-- Step 17
--Verify the SwitchBack status on the primary database:
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 15:58:20 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
            87          1
            69          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> set linesize 9999
SQL> select STATUS, GAP_STATUS from V$ARCHIVE_DEST_STATUS where DEST_ID = 2;

STATUS    GAP_STATUS
--------- ------------------------
VALID     NO GAP

SQL> select SWITCHOVER_STATUS from V$DATABASE;

SWITCHOVER_STATUS
--------------------
TO STANDBY <= (You must see TO STANDBY or SESSIONS ACTIVE)

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 18
-- Verify the SwitchBack status on the primary database:
[oracle@pdb1 ~]$  sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 16:00:24 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options


SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
            87          1
            69          2

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
            87          1
            68          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         2         70 APPLYING_LOG        329 MRP0

SQL> set linesize 9999
SQL> select NAME, VALUE, DATUM_TIME from V$DATAGUARD_STATS;

NAME                   VALUE            DATUM_TIME
---------------------- ---------------- -------------------
transport lag          +00 00:00:00     06/30/2025 16:01:24
apply lag              +00 00:00:00     06/30/2025 16:01:24
apply finish time      +00 00:00:00.000
estimated startup time 112


SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 19
[oracle@pdbdr1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdbdr1. Instance status: Open.
Instance pdbdb2 is running on node pdbdr2. Instance status: Open.
*/

-- Step 19.1
[oracle@pdbdr1 ~]$ srvctl stop instance -d pdbdb -i pdbdb2

-- Step 19.2
--Commit to switchover to physical standby with session shutdown
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 16:03:24 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> select name, open_mode, db_unique_name, database_role from v$database;

NAME      OPEN_MODE            DB_UNIQUE_NAME                 DATABASE_ROLE
--------- -------------------- ------------------------------ ----------------
PDBDB     READ WRITE           dr                             PRIMARY

SQL> alter database commit to switchover to physical standby with session shutdown;

Database altered.

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 20
-- Verify the DB services and status of Old Secondary Database
[oracle@pdbdr1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdbdr1. Instance status: Open.
Instance pdbdb2 is not running on node pdbdr2
*/

-- Step 21
-- Start the DB services of Secondary Database
[oracle@pdbdr1 ~]$ srvctl stop database -d pdbdb
[oracle@pdbdr1 ~]$ srvctl start database -d pdbdb -o mount

-- Step 22
-- Verify the DB services and status of Secondary Database
[oracle@pdbdr1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdbdr1. Instance status: Mounted (Closed).
Instance pdbdb2 is running on node pdbdr2. Instance status: Mounted (Closed).
*/

-- Step 23
-- Verify the DB status of Secondary Database
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 16:05:36 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> select name, open_mode, db_unique_name, database_role from v$database;

NAME      OPEN_MODE            DB_UNIQUE_NAME                 DATABASE_ROLE
--------- -------------------- ------------------------------ ----------------
PDBDB     MOUNTED              dr                             PHYSICAL STANDBY

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 24
--Commit to switchover to primary with session shutdown:
[oracle@pdb1 ~]$  sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 16:06:16 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> select name, open_mode, db_unique_name, database_role from v$database;

NAME      OPEN_MODE            DB_UNIQUE_NAME                 DATABASE_ROLE
--------- -------------------- ------------------------------ ----------------
PDBDB     MOUNTED              pdbdb                          PHYSICAL STANDBY

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED

SQL> select SWITCHOVER_STATUS from V$DATABASE;

SWITCHOVER_STATUS
--------------------
TO PRIMARY

SQL> alter database commit to switchover to primary with session shutdown;

Database altered.

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 25
-- Verify the DB status of New Secondary Database as Old Primary Database
[oracle@pdb1 ~]$  srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Mounted (Closed).
Instance pdbdb2 is running on node pdb2. Instance status: Mounted (Closed).
*/

-- Step 26
-- Stop the DB services of New Secondary Database
[oracle@pdb1 ~]$ srvctl stop database -d pdbdb
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is not running on node pdb1
Instance pdbdb2 is not running on node pdb2
*/

-- Step 27
-- Start the DB Services of New Secondary Database as Old Primary Database
[oracle@pdb1 ~]$ srvctl start database -d pdbdb -o open
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 28
-- Verify the DB status of Primary Database
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 16:09:26 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> alter system switch logfile;

System altered.

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
            94          1
            76          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 29
-- On the old standby, start the MRP:
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 30 16:09:50 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;

Database altered.

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
            94          1
            76          2

SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby;


   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         1         90 CLOSING               1 ARCH
         2         72 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         1         91 CLOSING               1 ARCH
         2         73 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         1         95 APPLYING_LOG         86 MRP0
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         1         92 CLOSING               1 ARCH
         2         74 CLOSING               1 ARCH
         2         75 CLOSING               1 ARCH
         2         76 CLOSING               1 ARCH
         1         93 CLOSING               1 ARCH
         1         94 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 IDLE                  0 RFS
         1         95 IDLE                 87 RFS
         2         77 IDLE                101 RFS

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
            93          1
            76          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/