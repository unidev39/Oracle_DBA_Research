----------------------------------------------------------------
-------------Three Node rac Setup on VM Workstation---------------
----------------------------------------------------------------
-- Step 0 -->> 3 Node rac on VM
--For OS Oracle Linux 6.10 => boot OracleLinux-R6-U10-Server-x86_64-dvd.iso 

-- Step 0.0 -->>  3 Node rac on Physical Server -->> On Node 3
[root@pdb3 ~]# df -Th
/*
Filesystem     Type     Size  Used Avail Use% Mounted on
/dev/sda2      ext4      69G  1.1G   65G   2% /
tmpfs          tmpfs    9.7G   76K  9.7G   1% /dev/shm
/dev/sda1      ext4     2.0G  157M  1.7G   9% /boot
/dev/sda6      ext4      15G   38M   14G   1% /home
/dev/sda3      ext4      57G   52M   54G   1% /opt
/dev/sda7      ext4      15G   38M   14G   1% /tmp
/dev/sda8      ext4      15G  5.9G  8.0G  43% /usr
/dev/sda9      ext4      15G  1.7G   13G  12% /var
/dev/sr0       iso9660  3.8G  3.8G     0 100% /media/OL6.10 x86_64 Disc 1 20180625
*/

-- Step 1 -->> On Node 3
[root@pdb3 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.168.16.21   pdb1.unidev.org.np        pdb1
192.168.16.22   pdb2.unidev.org.np        pdb2
192.168.16.28   pdb3.unidev.org.np        pdb3

# Private
10.10.10.21     pdb1-priv.unidev.org.np   pdb1-priv
10.10.10.22     pdb2-priv.unidev.org.np   pdb2-priv
10.10.10.28     pdb3-priv.unidev.org.np   pdb3-priv

# Virtual
192.168.16.23   pdb1-vip.unidev.org.np    pdb1-vip
192.168.16.24   pdb2-vip.unidev.org.np    pdb2-vip
192.168.16.29   pdb3-vip.unidev.org.np    pdb3-vip

# SCAN
192.168.16.25   pdb-scan.unidev.org.np    pdb-scan
192.168.16.26   pdb-scan.unidev.org.np    pdb-scan
192.168.16.27   pdb-scan.unidev.org.np    pdb-scan
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
# SELINUXTYPE= can take one of these two values:
#     targeted - Targeted processes are protected,
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
[root@pdb3 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth0
/*
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.16.28
NETMASK=255.255.255.0
GATEWAY=192.168.16.1
DNS1=192.168.16.11
DNS2=192.168.16.12
*/

-- Step 4.1 -->> On Node 3
[root@pdb3 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth1
/*
DEVICE=eth1
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=10.10.10.28
NETMASK=255.255.255.0
*/

-- Step 5 -->> On Node 3
[root@pdb3 ~]# service network restart
[root@pdb3 ~]# service NetworkManager stop
[root@pdb3 ~]# service network restart

-- Step 6 -->> On Node 3
[root@pdb3 ~]# yum repolist
/*
Loaded plugins: refresh-packagekit, security, ulninfo
repo id                                               repo name                                                                           status
public_ol6_UEKR4                                      Latest Unbreakable Enterprise Kernel Release 4 for Oracle Linux 6Server (x86_64)       191
public_ol6_latest                                     Oracle Linux 6Server Latest (x86_64)                                                12,932
repolist: 13,123
*/

-- Step 6.1 -->> On Node 3
[root@pdb3 ~]# uname -a
/*
Linux pdb3.unidev.org.np 4.1.12-124.48.6.el6uek.x86_64 #2 SMP Tue Mar 16 15:39:03 PDT 2021 x86_64 x86_64 x86_64 GNU/Linux
*/

-- Step 6.2 -->> On Node 3
[root@pdb3 ~]# uname -r
/*
4.1.12-124.48.6.el6uek.x86_64
*/

-- Step 6.3 -->> On Node 3
[root@pdb3 ~]# grubby --info=ALL | grep ^kernel
/*
kernel=/vmlinuz-4.1.12-124.48.6.el6uek.x86_64
kernel=/vmlinuz-2.6.32-754.35.1.el6.x86_64
kernel=/vmlinuz-4.1.12-124.16.4.el6uek.x86_64
kernel=/vmlinuz-2.6.32-754.el6.x86_64
*/

-- Step 6.3.1 -->> On Node 3
[root@pdb3 ~]# grubby --default-kernel
/*
/boot/vmlinuz-4.1.12-124.48.6.el6uek.x86_64
*/

-- Step 6.4 -->> On Node 3
[root@pdb3 ~]# chkconfig --list iptables
/*
iptables  0:off    1:off    2:on    3:on    4:on    5:on    6:off
*/

-- Step 7 -->> On Node 3
[root@pdb3 ~]# service iptables stop
/*
iptables: Setting chains to policy ACCEPT: nat mangle filte[  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
*/

-- Step 8 -->> On Node 3
[root@pdb3 ~]# chkconfig iptables off
[root@pdb3 ~]# iptables -F
[root@pdb3 ~]# service iptables save
/*
iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]
*/

-- Step 9 -->> On Node 3
[root@pdb3 ~]# /etc/init.d/iptables stop
/*
iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
*/

-- Step 9.1 -->> On Node 3
[root@pdb3 ~]# chkconfig --list iptables
/*
iptables   0:off    1:off    2:off    3:off    4:off    5:off    6:off
*/ 

-- Step 10 -->> On Node 3
[root@pdb3 ~]# service ntpd stop
/*
Shutting down ntpd:                                        [FAILED]
*/

-- Step 10.1 -->> On Node 3
[root@pdb3 ~]# service ntpd status
/*
ntpd is stopped
*/

-- Step 10.2 -->> On Node 3
[root@pdb3 ~]# chkconfig ntpd off

-- Step 10.3 -->> On Node 3
[root@pdb3 ~]# mv /etc/ntp.conf /etc/ntp.conf.backup
[root@pdb3 ~]# rm -rf /etc/ntp.conf
[root@pdb3 ~]# rm -rf /var/run/ntpd.pid

-- Step 11 -->> On Node 3
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
Chain INPUT (policy ACCEPT 1 packets, 40 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 1 packets, 152 bytes)
 pkts bytes target     prot opt in     out     source               destination
*/

-- Step 12 -->> On Node 3
[root@pdb3 ~ ]# brctl show
/*
bridge name     bridge id               STP enabled     interfaces
virbr0          8000.52540070d58f       yes             virbr0-nic
*/

-- Step 12.1 -->> On Node 3
[root@pdb3 ~ ]# virsh net-list
/*
Name                 State      Autostart     Persistent
--------------------------------------------------
default              active     yes           yes
*/

-- Step 13 -->> On Node 3
[root@pdb3 ~ ]# service libvirtd stop
/*
Stopping libvirtd daemon:                                  [  OK  ]
*/

-- Step 14 -->> On Node 3
[root@pdb3 ~ ]# chkconfig --list | grep libvirtd
/*
libvirtd        0:off   1:off   2:off   3:on    4:on    5:on    6:off
*/

-- Step 15 -->> On Node 3
[root@pdb3 ~]# chkconfig libvirtd off
[root@pdb3 ~]# ip link set lxcbr0 down
[root@pdb3 ~]# brctl delbr lxcbr0
[root@pdb3 ~]# brctl show

-- Step 16 -->> On Node One
[root@pdb3 ~]# ifconfig
/*
eth0      Link encap:Ethernet  HWaddr 00:0C:29:57:2D:AF
          inet addr:192.168.16.28  Bcast:192.168.16.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fe57:2daf/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:379 errors:0 dropped:18 overruns:0 frame:0
          TX packets:349 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:36333 (35.4 KiB)  TX bytes:57009 (55.6 KiB)

eth1      Link encap:Ethernet  HWaddr 00:0C:29:57:2D:B9
          inet addr:10.10.10.28  Bcast:10.10.10.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fe57:2db9/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:31 errors:0 dropped:13 overruns:0 frame:0
          TX packets:17 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1860 (1.8 KiB)  TX bytes:1122 (1.0 KiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:16 errors:0 dropped:0 overruns:0 frame:0
          TX packets:16 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:960 (960.0 b)  TX bytes:960 (960.0 b)

virbr0    Link encap:Ethernet  HWaddr 52:54:00:70:D5:8F
          inet addr:192.168.122.1  Bcast:192.168.122.255  Mask:255.255.255.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
*/

-- Step 17 -->> On Node 3
[root@pdb3 ~]# init 6

-- Step 17.1 -->> On Node 3
[root@pdb3 ~]# ifconfig
/*
eth0      Link encap:Ethernet  HWaddr 00:0C:29:57:2D:AF
          inet addr:192.168.16.28  Bcast:192.168.16.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fe57:2daf/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:95 errors:0 dropped:11 overruns:0 frame:0
          TX packets:58 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:10702 (10.4 KiB)  TX bytes:7484 (7.3 KiB)

eth1      Link encap:Ethernet  HWaddr 00:0C:29:57:2D:B9
          inet addr:10.10.10.28  Bcast:10.10.10.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fe57:2db9/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:38 errors:0 dropped:5 overruns:0 frame:0
          TX packets:18 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:2463 (2.4 KiB)  TX bytes:1164 (1.1 KiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:16 errors:0 dropped:0 overruns:0 frame:0
          TX packets:16 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:960 (960.0 b)  TX bytes:960 (960.0 b)
*/

-- Step 18 -->> On Node 3
[root@pdb3 ~]# brctl show
/*
bridge name     bridge id               STP enabled     interfaces
*/

-- Step 19 -->> On Node 3
[root@pdb3 ~]# chkconfig --list | grep libvirtd
/*
libvirtd        0:off   1:off   2:off   3:off   4:off   5:off   6:off
*/


-- Step 20 -->> On Node 3
[root@pdb3 ~]# chkconfig --list iptables
/*
iptables        0:off   1:off   2:off   3:off   4:off   5:off   6:off
*/

-- Step 21 -->> On Node 3
[root@pdb3 ~]# chkconfig --list ntpd
/*
ntpd            0:off   1:off   2:off   3:off   4:off   5:off   6:off
*/

-- Step 22 -->> On Node 3
[root@pdb3 ~]# cat /etc/resolv.conf
/*
# Generated by NetworkManager
search cibnepal.org.np
nameserver 192.168.16.11
nameserver 192.168.16.12
*/

-- Step 22.1 -->> On Node 3
[root@pdb3 ~]# nslookup 192.168.16.28
/*
Server:         192.168.16.11
Address:        192.168.16.11#53

28.6.16.172.in-addr.arpa        name = pdb3.unidev.org.np.
*/

-- Step 22.2 -->> On Node 3
[root@pdb3 ~]# nslookup pdb3
/*
Server:         192.168.16.11
Address:        192.168.16.11#53

Name:   pdb3.unidev.org.np
Address: 192.168.16.28
*/

-- Step 22.3 -->> On Node 3
[root@pdb3 ~]# nslookup pdb-scan
/*
Server:         192.168.16.11
Address:        192.168.16.11#53

Name:   pdb-scan.unidev.org.np
Address: 192.168.16.26
Name:   pdb-scan.unidev.org.np
Address: 192.168.16.25
Name:   pdb-scan.unidev.org.np
Address: 192.168.16.27
*/

-- Step 22.4 -->> On Node 3
[root@pdb3 ~]# nslookup pdb3-vip
/*
Server:         192.168.16.11
Address:        192.168.16.11#53

Name:   pdb3-vip.unidev.org.np
Address: 192.168.16.29
*/

-- Step 22.5 -->> On Node 3
[root@pdb3 ~]# nslookup pdb3-priv
/*
Server:         192.168.16.11
Address:        192.168.16.11#53

Name:   pdb3-priv.unidev.org.np
Address: 10.10.10.28
*/

-- Step 22.6 -->> On Node 3
[root@pdb3 ~]# iptables -L -nv
/*
Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination
*/


-- Step 23 -->> On Node 3
-- Perform either the Automatic Setup or the Manual Setup to complete the basic prerequisites. 
[root@pdb3 ~]# cd /media/OL6.10\ x86_64\ Disc\ 1\ 20180625/Server/Packages/
[root@pdb3 Packages]# yum -y install oracle-rdbms-server-11gR2-preinstall
[root@pdb3 Packages]# yum -y update

-- Step 23.1 -->> On Node 3
[root@pdb3 Packages]# yum install -y yum-utils
[root@pdb3 Packages]# yum install -y zip unzip

-- Step 23.2 -->> On Node 3
[root@pdb3 Packages]# rpm -iUvh binutils-2*x86_64*
[root@pdb3 Packages]# rpm -iUvh glibc-2*x86_64* nss-softokn-freebl-3*x86_64*
[root@pdb3 Packages]# rpm -iUvh glibc-2*i686* nss-softokn-freebl-3*i686*
[root@pdb3 Packages]# rpm -iUvh compat-libstdc++-33*x86_64*
[root@pdb3 Packages]# rpm -iUvh glibc-common-2*x86_64*
[root@pdb3 Packages]# rpm -iUvh glibc-devel-2*x86_64*
[root@pdb3 Packages]# rpm -iUvh glibc-devel-2*i686*
[root@pdb3 Packages]# rpm -iUvh glibc-headers-2*x86_64*
[root@pdb3 Packages]# rpm -iUvh elfutils-libelf-0*x86_64*
[root@pdb3 Packages]# rpm -iUvh elfutils-libelf-devel-0*x86_64*
[root@pdb3 Packages]# rpm -iUvh gcc-4*x86_64*
[root@pdb3 Packages]# rpm -iUvh gcc-c++-4*x86_64*
[root@pdb3 Packages]# rpm -iUvh ksh-*x86_64*
[root@pdb3 Packages]# rpm -iUvh libaio-0*x86_64*
[root@pdb3 Packages]# rpm -iUvh libaio-devel-0*x86_64*
[root@pdb3 Packages]# rpm -iUvh libaio-0*i686*
[root@pdb3 Packages]# rpm -iUvh libaio-devel-0*i686*
[root@pdb3 Packages]# rpm -iUvh libgcc-4*x86_64*
[root@pdb3 Packages]# rpm -iUvh libgcc-4*i686*
[root@pdb3 Packages]# rpm -iUvh libstdc++-4*x86_64*
[root@pdb3 Packages]# rpm -iUvh libstdc++-4*i686*
[root@pdb3 Packages]# rpm -iUvh libstdc++-devel-4*x86_64*
[root@pdb3 Packages]# rpm -iUvh make-3.81*x86_64*
[root@pdb3 Packages]# rpm -iUvh numactl-devel-2*x86_64*
[root@pdb3 Packages]# rpm -iUvh sysstat-9*x86_64*
[root@pdb3 Packages]# rpm -iUvh compat-libstdc++-33*i686*
[root@pdb3 Packages]# rpm -iUvh compat-libcap*
[root@pdb3 Packages]# rpm -iUvh libaio-devel-0.*
[root@pdb3 Packages]# rpm -iUvh ksh-2*
[root@pdb3 Packages]# rpm -iUvh libstdc++-4.*.i686*
[root@pdb3 Packages]# rpm -iUvh elfutils-libelf-0*i686* elfutils-libelf-devel-0*i686*
[root@pdb3 Packages]# rpm -iUvh libtool-ltdl*i686*
[root@pdb3 Packages]# rpm -iUvh ncurses*i686*
[root@pdb3 Packages]# rpm -iUvh readline*i686*
[root@pdb3 Packages]# rpm -iUvh unixODBC*
[root@pdb3 Packages]# rpm -iUvh oracleasm*.rpm
[root@pdb3 Packages]# yum -y update

-- Step 23.3 -->> On Node 3
[root@pdb3 ~]# cd /root/Oracle_Linux_6_Rpm/
[root@pdb3 Oracle_Linux_6_Rpm]# rpm -iUvh --nodeps --force dtrace-utils-1.0.0-8.el6.x86_64.rpm
[root@pdb3 Oracle_Linux_6_Rpm]# rpm -iUvh --nodeps --force dtrace-utils-devel-1.0.0-8.el6.x86_64.rpm
[root@pdb3 Oracle_Linux_6_Rpm]# rpm -iUvh --nodeps --force dtrace-utils-testsuite-1.0.0-8.el6.x86_64.rpm
[root@pdb3 Oracle_Linux_6_Rpm]# rpm -iUvh elfutils-libelf-devel-static-0.164-2.el6.x86_64.rpm
[root@pdb3 Oracle_Linux_6_Rpm]# rpm -iUvh libdtrace-ctf-0.8.0-1.el6.x86_64.rpm
[root@pdb3 Oracle_Linux_6_Rpm]# rpm -iUvh libdtrace-ctf-devel-0.8.0-1.el6.x86_64.rpm
[root@pdb3 Oracle_Linux_6_Rpm]# rpm -iUvh numactl-2.0.9-2.el6.i686.rpm
[root@pdb3 Oracle_Linux_6_Rpm]# rpm -iUvh numactl-devel-2.0.9-2.el6.i686.rpm
[root@pdb3 Oracle_Linux_6_Rpm]# rpm -iUvh --nodeps --force unixODBC-devel-2.2.14-12.el6_3.x86_64.rpm

-- Step 23.4 -->> On Node 3
[root@pdb3 ~]# cd /media/OL6.10\ x86_64\ Disc\ 1\ 20180625/Server/Packages/
[root@pdb3 Packages]# yum -y update

-- Step 23.5 -->> On Node 3
[root@pdb3 Packages]# rpm -q binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel elfutils-libelf-devel-static \
[root@pdb3 Packages]# rpm -q gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers kernel-headers ksh libaio libaio-devel \
[root@pdb3 Packages]# rpm -q libgcc libgomp libstdc++ libstdc++-devel make numactl-devel sysstat unixODBC unixODBC-devel \

-- Step 24 -->> On Node 3
-- Pre-Installation Steps for ASM
[root@pdb3 ~ ]# cd /etc/yum.repos.d
[root@pdb3 yum.repos.d]# uname -ras
/*
Linux pdb3.unidev.org.np 4.1.12-124.48.6.el6uek.x86_64 #2 SMP Tue Mar 16 15:39:03 PDT 2021 x86_64 x86_64 x86_64 GNU/Linux
*/

-- Step 24.1 -->> On Node 3
[root@pdb3 yum.repos.d]# cat /etc/os-release 
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

-- Step 24.2 -->> On Node 3
[root@pdb3 yum.repos.d]# wget https://public-yum.oracle.com/public-yum-ol6.repo
/*
--2025-06-25 11:54:18--  https://public-yum.oracle.com/public-yum-ol6.repo
Resolving public-yum.oracle.com... 23.219.57.243, 2600:140f:5:508d::2a7d, 2600:140f:5:5084::2a7d
Connecting to public-yum.oracle.com|23.219.57.243|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 12045 (12K) [text/plain]
Saving to: “public-yum-ol6.repo.1”

100%[===================================================================================================================================================>] 12,045      --.-K/s   in 0s

2025-06-25 11:54:20 (350 MB/s) - “public-yum-ol6.repo.1” saved [12045/12045]
*/

-- Step 24.3 -->> On Node 3
[root@pdb3 yum.repos.d]# yum install -y kmod-oracleasm
[root@pdb3 yum.repos.d]# yum install -y oracleasm-support

-- Step 24.4 -->> On Node 3
[root@pdb3 ~]# cd /root/Oracle_Linux_6_Rpm/
[root@pdb3 Oracle_Linux_6_Rpm]# rpm -iUvh oracleasmlib-2.0.4-1.el6.x86_64.rpm
[root@pdb3 Oracle_Linux_6_Rpm]# rpm -qa | grep oracleasm
/*
oracleasmlib-2.0.4-1.el6.x86_64
oracleasm-support-2.1.11-2.el6.x86_64
kmod-oracleasm-2.0.8-16.1.el6_10.x86_64
*/

-- Step 24.5 -->> On Node 3
[root@pdb3 ~]# cd /media/OL6.10\ x86_64\ Disc\ 1\ 20180625/Server/Packages/
[root@pdb3 Packages]# yum -y update


-- Step 25 -->> On Node 3
-- Add the kernel parameters file "/etc/sysctl.conf" and add oracle recommended kernel parameters
[root@pdb3 ~]# vi /etc/sysctl.conf
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

-- Step 25.1 -->> On Node 3
-- Run the following command to change the current kernel parameters.
[root@pdb3 ~]# sysctl -p /etc/sysctl.conf

-- Step 26 -->> On Node 3
-- Edit "/etc/security/limits.conf" file to limit user processes
[root@pdb3 ~]# vi /etc/security/limits.conf
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

-- Step 27 -->> On Node 3
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
-session   optional     pam_ck_connector.so
session    required     pam_limits.so
*/

-- Step 28 -->> On Node 3
-- Create the new groups and users.
[root@pdb3 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:
*/

-- Step 28.1 -->> On Node 3
[root@pdb3 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:
*/

-- Step 28.2 -->> On Node 3
[root@pdb3 ~]# cat /etc/group | grep -i oracle
/*
oracle:x:500:
*/

-- Step 28.3 -->> On Node 3
[root@pdb3 ~]# cat /etc/group | grep -i oper

-- Step 28.4 -->> On Node 3
[root@pdb3 ~]# cat /etc/group | grep -i asm

-- Step 28.5 -->> On Node 3
-- 1.Create OS groups using the command below. Enter these commands as the 'root' user:
[root@pdb3 ~]# /usr/sbin/groupadd -g 503 oper
[root@pdb3 ~]# /usr/sbin/groupadd -g 504 asmadmin
[root@pdb3 ~]# /usr/sbin/groupadd -g 506 asmdba
[root@pdb3 ~]# /usr/sbin/groupadd -g 507 asmoper
[root@pdb3 ~]# /usr/sbin/groupadd -g 508 beoper

-- Step 28.6 -->> On Node 3
-- 2.Create the users that will own the Oracle software using the commands:
[root@pdb3 ~]# /usr/sbin/useradd -g oinstall -G oinstall,dba,asmadmin,asmdba,asmoper,beoper grid
[root@pdb3 ~]# /usr/sbin/usermod -g oinstall -G oinstall,dba,oper,asmadmin,asmdba oracle

-- Step 28.7 -->> On Node 3
[root@pdb3 ~]# cat /etc/group | grep -i grid
/*
oinstall:x:54321:grid,oracle
dba:x:54322:grid,oracle
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 28.8 -->> On Node 3
[root@pdb3 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/

-- Step 28.9 -->> On Node 3
[root@pdb3 ~]# cat /etc/group | grep -i oracle
/*
oracle:x:500:
oinstall:x:54321:grid,oracle
dba:x:54322:grid,oracle
oper:x:503:oracle
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
*/

-- Step 28.10 -->> On Node 3
[root@pdb3 ~]# cat /etc/group | grep -i oper
/*
oper:x:503:oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 28.11 -->> On Node 3
[root@pdb3 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:grid,oracle
*/

-- Step 28.12 -->> On Node 3
[root@pdb3 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:grid,oracle
asmdba:x:506:grid,oracle
*/

-- Step 29 -->> On Node 3
[root@pdb3 ~]# passwd oracle
/*
Changing password for user oracle.
New password: oracle
Retype new password: oracle
passwd: all authentication tokens updated successfully.
*/

-- Step 29.1 -->> On Node 3
[root@pdb3 ~]# passwd grid
/*
Changing password for user grid.
New password: grid
Retype new password: grid
passwd: all authentication tokens updated successfully.
*/

-- Step 29.2 -->> On Node 3
[root@pdb3 ~]# su - oracle

-- Step 29.3 -->> On Node 3
[oracle@pdb3 ~]$ su - grid
/*
Password: grid
*/

-- Step 29.4 -->> On Node 3
[grid@pdb3 ~]$ su - oracle
/*
Password: oracle
*/

-- Step 29.5 -->> On Node 3
[oracle@pdb3 ~]$ exit
/*
logout
*/

-- Step 29.6 -->> On Node 3
[grid@pdb3 ~]$ exit
/*
logout
*/

-- Step 29.7 -->> On Node 3
[oracle@pdb3 ~]$ exit
/*
logout
*/

-- Step 30 -->> On Node 3
--1.Create the Oracle Inventory Director:
[root@pdb3 ~]# mkdir -p /opt/app/oraInventory
[root@pdb3 ~]# chown -R grid:oinstall /opt/app/oraInventory
[root@pdb3 ~]# chmod -R 775 /opt/app/oraInventory

--2.Creating the Oracle Grid Infrastructure Home Directory:
[root@pdb3 ~]# mkdir -p /opt/app/11.2.0.3.0/grid
[root@pdb3 ~]# chown -R grid:oinstall /opt/app/11.2.0.3.0/grid
[root@pdb3 ~]# chmod -R 775 /opt/app/11.2.0.3.0/grid

--3.Creating the Oracle Base Directory
[root@pdb3 ~]# mkdir -p /opt/app/oracle
[root@pdb3 ~]# mkdir /opt/app/oracle/cfgtoollogs
[root@pdb3 ~]# chown -R oracle:oinstall /opt/app/oracle
[root@pdb3 ~]# chmod -R 775 /opt/app/oracle
[root@pdb3 ~]# chown -R grid:oinstall /opt/app/oracle/cfgtoollogs
[root@pdb3 ~]# chmod -R 775 /opt/app/oracle/cfgtoollogs

--4.Creating the Oracle RDBMS Home Directory
[root@pdb3 ~]# mkdir -p /opt/app/oracle/product/11.2.0.3.0/db_1
[root@pdb3 ~]# chown -R oracle:oinstall /opt/app/oracle/product/11.2.0.3.0/db_1
[root@pdb3 ~]# chmod -R 775 /opt/app/oracle/product/11.2.0.3.0/db_1
[root@pdb3 ~]# cd /opt/app/oracle
[root@pdb3 ~]# chown -R oracle:oinstall product
[root@pdb3 ~]# chmod -R 775 product

-- Step 31 -->> On Node 3
[root@pdb3 ~]# mkdir -p /opt/app/11.2.0.3.0/grid/rpm/

-- Step 31.1 -->> On Node 1
[root@pdb1 ~]# cd /opt/app/11.2.0.3.0/grid/rpm/
[root@pdb1 rpm]# scp -r cvuqdisk-1.0.9-1.rpm root@pdb3:/opt/app/11.2.0.3.0/grid/rpm/
/*
The authenticity of host 'pdb3 (192.168.16.28)' can't be established.
RSA key fingerprint is e0:f7:36:78:2e:8b:73:17:05:bd:a5:28:6d:bf:3f:a9.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'pdb3,192.168.16.28' (RSA) to the list of known hosts.
root@pdb3's password: <= P@ssw0rd
cvuqdisk-1.0.9-1.rpm                                       100% 8551     8.4KB/s   00:00
*/

-- Step 31.2 -->> On Node 3
[root@pdb3 ~]# chown -R grid:oinstall /opt/app/11.2.0.3.0/grid
[root@pdb3 ~]# chmod -R 775 /opt/app/11.2.0.3.0/grid

-- Step 31.3 -->> On Node 3
[root@pdb3 ~]# ll /opt/app/11.2.0.3.0/grid/rpm/
/*
-rwxrwxr-x 1 grid oinstall 8551 Jun 30 16:45 cvuqdisk-1.0.9-1.rpm
*/

-- Step 32 -->> On Node 3
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
ORACLE_HOME=$ORACLE_BASE/product/11.2.0.3.0/db_1; export ORACLE_HOME
ORACLE_SID=pdbdb3; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 32.1 -->> On Node 3
[oracle@pdb3 ~]$ . .bash_profile

-- Step 33 -->> On Node 3
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
GRID_HOME=/opt/app/11.2.0.3.0/grid; export GRID_HOME
ORACLE_HOME=$GRID_HOME; export ORACLE_HOME

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 33.1 -->> On Node 3
[grid@pdb3 ~]$ . .bash_profile

-- Step 34 -->> On Node 3
-- To install the cvuqdisk-1.0.10-1.rpm
-- Login from root user
[root@pdb3 ~]# cd /opt/app/11.2.0.3.0/grid/rpm/

-- Step 34.1 -->> On Node 3
[root@pdb3 rpm]# ls -ltr
/*
-rwxrwxr-x 1 grid oinstall 8551 Jun 30 16:45 cvuqdisk-1.0.9-1.rpm
*/

-- Step 34.2 -->> On Node 3
[root@pdb3 rpm]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP

-- Step 35.3 -->> On Node 3
[root@pdb3 rpm]# rpm -iUvh cvuqdisk-1.0.9-1.rpm  
/*
Preparing...                ########################################### [100%]
   1:cvuqdisk               ########################################### [100%]
*/

-- Step 36 -->> On Node 3
[root@pdb3 ~]# which oracleasm
/*
/usr/sbin/oracleasm
*/

-- Step 36.1 -->> On Node 3
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

-- Step 36.2 -->> On Node 3
[root@pdb3 ~]# oracleasm status
/*
Checking if ASM is loaded: no
Checking if /dev/oracleasm is mounted: no
*/

-- Step 36.3 -->> On Node 3
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

-- Step 36.4 -->> On Node 3
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

-- Step 36.5 -->> On Node 3
[root@pdb3 ~]# oracleasm configure -p
/*
Writing Oracle ASM library driver configuration: done
*/

-- Step 36.6 -->> On Node 3
[root@pdb3 ~]# oracleasm init
/*
Creating /dev/oracleasm mount point: /dev/oracleasm
Loading module "oracleasm": oracleasm
Configuring "oracleasm" to use device physical block size
Mounting ASMlib driver filesystem: /dev/oracleasm
*/

-- Step 36.7 -->> On Node 3
[root@pdb3 ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 36.8 -->> On Node 3
[root@pdb3 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 36.9 -->> On Node 3
[root@pdb3 ~]# oracleasm listdisks

-- Step 56 -->> On Node 3
[root@pdb3 ~]# ll /etc/init.d/ | grep oracle
/*
-rwxr-xr-x  1 root root  7401 Feb  3  2018 oracleasm
-rwxr--r--  1 root root  1371 Nov  2  2018 oracle-rdbms-server-11gR2-preinstall-firstboot
*/

-- Step 37 -->> On Node 3
[root@pdb3 ~]# ll /dev/oracleasm/disks/
/*
total 0
*/

-- Step 38 -->> On Node 3
[root@pdb3 ~]# ll /dev/sd*
/*
brw-rw---- 1 root disk 8, 0 Jun 30 16:36 /dev/sda
brw-rw---- 1 root disk 8, 1 Jun 30 16:36 /dev/sda1
brw-rw---- 1 root disk 8, 2 Jun 30 16:36 /dev/sda2
brw-rw---- 1 root disk 8, 3 Jun 30 16:36 /dev/sda3
brw-rw---- 1 root disk 8, 4 Jun 30 16:36 /dev/sda4
brw-rw---- 1 root disk 8, 5 Jun 30 16:36 /dev/sda5
brw-rw---- 1 root disk 8, 6 Jun 30 16:36 /dev/sda6
brw-rw---- 1 root disk 8, 7 Jun 30 16:36 /dev/sda7
brw-rw---- 1 root disk 8, 8 Jun 30 16:36 /dev/sda8
brw-rw---- 1 root disk 8, 9 Jun 30 16:36 /dev/sda9
*/

--Step 38.1 -->> On Node 3
[root@pdb3 ~]# lsblk
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
sr0     11:0    1 1024M  0 rom
*/

-- Step 38.2 -->> On Node 3
[root@pdb3 ~]# init 0

-- Step 38.3 -->> On Node 3
-- Add the existing ASM disk to Node 3 with the same configuration as on Node 1 and Node 2, then power on the server on Node 3 and propagate the configuration.

-- Step 38.4 -->> On Node 3
[root@pdb1/pdb2/pdb3 ~]# fdisk -ll | grep -E "sdb|sdc|sdd"
/*
Disk /dev/sdb: 21.5 GB, 21474836480 bytes
/dev/sdb1               1        2610    20964793+  83  Linux
Disk /dev/sdc: 214.7 GB, 214748364800 bytes
/dev/sdc1               1       26108   209712478+  83  Linux
Disk /dev/sdd: 429.5 GB, 429496729600 bytes
/dev/sdd1               1       52216   419424988+  83  Linux
*/

-- Step 38.5 -->> On Node 3
[root@pdb3 ~]# lsblk
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
└─sdb1   8:17   0   20G  0 part
sdc      8:32   0  200G  0 disk
└─sdc1   8:33   0  200G  0 part
sdd      8:48   0  400G  0 disk
└─sdd1   8:49   0  400G  0 part
sr0     11:0    1 1024M  0 rom
*/

-- Step 39 -->> On Node 3
-- Enable Multipath to resolve oracleasmlibrary v3 issues - (Both Nodes disks not similar after reboot OS)
[root@pdb3 ~]# cd /etc/yum.repos.d/
[root@pdb3 yum.repos.d]# yum install -y device-mapper-multipath

-- Step 39.1 -->> On Node 3
[root@pdb3 ~]# which mpathconf
/*
/sbin/mpathconf
*/

-- Step 39.2 -->> On Node 3
[root@pdb3 ~]# mpathconf --enable --with_multipathd y
/*
Starting multipathd daemon:                                [  OK  ]
*/

-- Step 39.3 -->> On Node 3
[root@pdb3 ~]# multipath -ll
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

-- Step 39.4 -->> On Node 3
[root@pdb3 ~]# ls -l /dev/disk/by-id/ | grep -E "sdb|sdc|sdd"
/*
lrwxrwxrwx 1 root root  9 Jun 30 16:55 scsi-36000c291af7e96b9f320160f7132e880 -> ../../sdb
lrwxrwxrwx 1 root root 10 Jun 30 16:55 scsi-36000c291af7e96b9f320160f7132e880-part1 -> ../../sdb1
lrwxrwxrwx 1 root root  9 Jun 30 16:55 scsi-36000c2991137c9097275f10cb1b67a9e -> ../../sdd
lrwxrwxrwx 1 root root 10 Jun 30 16:55 scsi-36000c2991137c9097275f10cb1b67a9e-part1 -> ../../sdd1
lrwxrwxrwx 1 root root  9 Jun 30 16:55 scsi-36000c29df49724b2c639967308843c0c -> ../../sdc
lrwxrwxrwx 1 root root 10 Jun 30 16:55 scsi-36000c29df49724b2c639967308843c0c-part1 -> ../../sdc1
lrwxrwxrwx 1 root root  9 Jun 30 16:55 wwn-0x6000c291af7e96b9f320160f7132e880 -> ../../sdb
lrwxrwxrwx 1 root root 10 Jun 30 16:55 wwn-0x6000c291af7e96b9f320160f7132e880-part1 -> ../../sdb1
lrwxrwxrwx 1 root root  9 Jun 30 16:55 wwn-0x6000c2991137c9097275f10cb1b67a9e -> ../../sdd
lrwxrwxrwx 1 root root 10 Jun 30 16:55 wwn-0x6000c2991137c9097275f10cb1b67a9e-part1 -> ../../sdd1
lrwxrwxrwx 1 root root  9 Jun 30 16:55 wwn-0x6000c29df49724b2c639967308843c0c -> ../../sdc
lrwxrwxrwx 1 root root 10 Jun 30 16:55 wwn-0x6000c29df49724b2c639967308843c0c-part1 -> ../../sdc1
*/

-- Step 39.5 -->> On ALL Node
[root@pdb1/pdb2/pdb3 ~]# which scsi_id
/*
/sbin/scsi_id
*/

-- Step 39.6 -->> On ALL Node
[root@pdb1/pdb2/pdb3 ~]# /sbin/scsi_id -g -u -d /dev/sdb
/*
36000c291af7e96b9f320160f7132e880
*/

-- Step 39.7 -->> On ALL Node
[root@pdb1/pdb2/pdb3 ~]# /sbin/scsi_id -g -u -d /dev/sdc
/*
36000c29df49724b2c639967308843c0c
*/

-- Step 39.8 -->> On ALL Node
[root@pdb1/pdb2/pdb3 ~]# /sbin/scsi_id -g -u -d /dev/sdd
/*
36000c2991137c9097275f10cb1b67a9e
*/

-- Step 39.9 -->> On Node 1
[root@pdb1 ~]# scp -r /etc/multipath.conf root@pdb3:/etc/
/*
root@pdb2's password: <= P@ssw0rd
multipath.conf                                100% 3954     3.9KB/s   00:00
*/

-- Step 39.10 -->> On Node 3
[root@pdb3 ~]# ll /etc/multipath.conf
/*
-rw------- 1 root root 1687 Jun 30 17:02 /etc/multipath.conf
*/

-- Step 39.11 -->> On Node 3
[root@pdb3 ~]# chkconfig multipathd on

-- Step 39.12 -->> On Node 3
[root@pdb3 ~]# chkconfig --list multipathd
/*
multipathd      0:off   1:off   2:on    3:on    4:on    5:on    6:off
*/

-- Step 39.13 -->> On Node 3
[root@pdb3 ~]# service multipathd restart
/*
ok
Stopping multipathd daemon:                                [  OK  ]
Starting multipathd daemon:                                [  OK  ]
*/

-- Step 39.14 -->> On Node 3
[root@pdb3 ~]# service multipathd status
/*
multipathd (pid  4859) is running...
*/

-- Step 39.15 -->> On All Nodes
[root@pdb1/pdb2/pdb3 ~]# multipath -ll
/*
OCR (36000c2998eb0cc04818be9ea7176dbae) dm-0 VMware,Virtual disk
size=20G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  `- 3:0:0:0 sdb 8:16 active ready running
ARC (36000c29d3c8f573f0d91dbd2c74a788d) dm-2 VMware,Virtual disk
size=400G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  `- 3:0:2:0 sdd 8:48 active ready running
DATA (36000c295abe2ca5ffefe55a21bc4c8e9) dm-1 VMware,Virtual disk
size=200G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  `- 3:0:1:0 sdc 8:32 active ready running
*/

-- Step 40 -->> On Node 3
[root@pdb3 ~]# init 6

-- Step 41 -->> On All Nodes
[root@pdb1/pdb2/pdb3 ~]# lsblk
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

-- Step 42 -->> On All Nodes
[root@pdb1/pdb2/pdb3 ~]# fdisk -ll | grep -E "OCR|DATA|ARC"
/*
Disk /dev/mapper/OCR: 21.5 GB, 21474836480 bytes
/dev/mapper/OCRp1               1        2610    20964793+  83  Linux
Disk /dev/mapper/DATA: 214.7 GB, 214748364800 bytes
/dev/mapper/DATAp1               1       26108   209712478+  83  Linux
Disk /dev/mapper/ARC: 429.5 GB, 429496729600 bytes
/dev/mapper/ARCp1               1       52216   419424988+  83  Linux
*/

-- Step 43 -->> On All Nodes
[root@pdb1/pdb2/pdb3 ~]# ll /dev/mapper/
/*
lrwxrwxrwx 1 root root       7 Jun 30 17:04 ARC -> ../dm-2
lrwxrwxrwx 1 root root       7 Jun 30 17:04 ARCp1 -> ../dm-5
crw-rw---- 1 root root 10, 236 Jun 30 17:04 control
lrwxrwxrwx 1 root root       7 Jun 30 17:04 DATA -> ../dm-1
lrwxrwxrwx 1 root root       7 Jun 30 17:04 DATAp1 -> ../dm-4
lrwxrwxrwx 1 root root       7 Jun 30 17:04 OCR -> ../dm-0
lrwxrwxrwx 1 root root       7 Jun 30 17:04 OCRp1 -> ../dm-3
*/

-- Step 44 -->> On All Nodes
[root@pdb1/pdb2/pdb3 ~]# ll /dev/mapper/*
/*
lrwxrwxrwx 1 root root       7 Jun 30 17:04 /dev/mapper/ARC -> ../dm-2
lrwxrwxrwx 1 root root       7 Jun 30 17:04 /dev/mapper/ARCp1 -> ../dm-5
crw-rw---- 1 root root 10, 236 Jun 30 17:04 /dev/mapper/control
lrwxrwxrwx 1 root root       7 Jun 30 17:04 /dev/mapper/DATA -> ../dm-1
lrwxrwxrwx 1 root root       7 Jun 30 17:04 /dev/mapper/DATAp1 -> ../dm-4
lrwxrwxrwx 1 root root       7 Jun 30 17:04 /dev/mapper/OCR -> ../dm-0
lrwxrwxrwx 1 root root       7 Jun 30 17:04 /dev/mapper/OCRp1 -> ../dm-3
*/

-- Step 45 -->> On Node 3
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
Start Oracle ASM library driver on boot (y/n) [y]: y
Scan for Oracle ASM disks on boot (y/n) [y]: y
Writing Oracle ASM library driver configuration: done
*/

-- Step 45.1 -->> On Node 3
[root@pdb3 ~]# oracleasm init

-- Step 45.2 -->> On Node 3
[root@pdb3 ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 45.3 -->> On Node 3
[root@pdb3 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 45.4 -->> On Node 3
[root@pdb3 ~]# oracleasm listdisks
/*
ARC
DATA
OCR
*/

-- Step 46 -->> On All Nodes
[root@pdb1/pdb2/pdb3 ~]# ll /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Jun 30 17:04 /dev/sda
brw-rw---- 1 root disk 8,  1 Jun 30 17:04 /dev/sda1
brw-rw---- 1 root disk 8,  2 Jun 30 17:04 /dev/sda2
brw-rw---- 1 root disk 8,  3 Jun 30 17:04 /dev/sda3
brw-rw---- 1 root disk 8,  4 Jun 30 17:04 /dev/sda4
brw-rw---- 1 root disk 8,  5 Jun 30 17:04 /dev/sda5
brw-rw---- 1 root disk 8,  6 Jun 30 17:04 /dev/sda6
brw-rw---- 1 root disk 8,  7 Jun 30 17:04 /dev/sda7
brw-rw---- 1 root disk 8,  8 Jun 30 17:04 /dev/sda8
brw-rw---- 1 root disk 8,  9 Jun 30 17:04 /dev/sda9
brw-rw---- 1 root disk 8, 16 Jun 30 17:08 /dev/sdb
brw-rw---- 1 root disk 8, 17 Jun 30 17:08 /dev/sdb1
brw-rw---- 1 root disk 8, 32 Jun 30 17:08 /dev/sdc
brw-rw---- 1 root disk 8, 33 Jun 30 17:08 /dev/sdc1
brw-rw---- 1 root disk 8, 48 Jun 30 17:08 /dev/sdd
brw-rw---- 1 root disk 8, 49 Jun 30 17:08 /dev/sdd1
*/

-- Step 47 -->> On All Nodes
[root@pdb1/pdb2/pdb3 ~]# ll /dev/oracleasm/disks/
/*
brw-rw---- 1 grid asmadmin 8, 49 Jun 30 17:05 ARC
brw-rw---- 1 grid asmadmin 8, 33 Jun 30 17:05 DATA
brw-rw---- 1 grid asmadmin 8, 17 Jun 30 17:05 OCR
*/

-- Step 48 -->> On All Nodes of DC and including DR
[root@pdb1/pdb2/pdb3/pdbdr1/pdbdr2 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

##############################DC#####################
# Public
192.168.16.21   pdb1.unidev.org.np        pdb1
192.168.16.22   pdb2.unidev.org.np        pdb2
192.168.16.28   pdb3.unidev.org.np        pdb3

# Private
10.10.10.21     pdb1-priv.unidev.org.np   pdb1-priv
10.10.10.22     pdb2-priv.unidev.org.np   pdb2-priv
10.10.10.28     pdb3-priv.unidev.org.np   pdb3-priv

# Virtual
192.168.16.23   pdb1-vip.unidev.org.np    pdb1-vip
192.168.16.24   pdb2-vip.unidev.org.np    pdb2-vip
192.168.16.29   pdb3-vip.unidev.org.np    pdb3-vip

# SCAN
192.168.16.25   pdb-scan.unidev.org.np    pdb-scan
192.168.16.26   pdb-scan.unidev.org.np    pdb-scan
192.168.16.27   pdb-scan.unidev.org.np    pdb-scan

##############################DR######################
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


-- Step 49 -->> On All Nodes of DC and including DR
[oracle@pdb1/pdb2/pdb3/pdbdr1/pdbdr2 ~]$ ping -c 2 pdb1
[oracle@pdb1/pdb2/pdb3/pdbdr1/pdbdr2 ~]$ ping -c 2 pdb2
[oracle@pdb1/pdb2/pdb3/pdbdr1/pdbdr2 ~]$ ping -c 2 pdb3
[oracle@pdb1/pdb2/pdb3/pdbdr1/pdbdr2 ~]$ ping -c 2 pdb1-priv
[oracle@pdb1/pdb2/pdb3/pdbdr1/pdbdr2 ~]$ ping -c 2 pdb2-priv
[oracle@pdb1/pdb2/pdb3/pdbdr1/pdbdr2 ~]$ ping -c 2 pdb3-priv
[oracle@pdb1/pdb2/pdb3/pdbdr1/pdbdr2 ~]$ ping -c 2 pdb1-vip
[oracle@pdb1/pdb2/pdb3/pdbdr1/pdbdr2 ~]$ ping -c 2 pdb2-vip
[oracle@pdb1/pdb2/pdb3/pdbdr1/pdbdr2 ~]$ ping -c 2 pdb3-vip
[oracle@pdb1/pdb2/pdb3/pdbdr1/pdbdr2 ~]$ ping -c 2 pdb-scan
[oracle@pdb1/pdb2/pdb3/pdbdr1/pdbdr2 ~]$ ping -c 2 pdbdr1
[oracle@pdb1/pdb2/pdb3/pdbdr1/pdbdr2 ~]$ ping -c 2 pdbdr2
[oracle@pdb1/pdb2/pdb3/pdbdr1/pdbdr2 ~]$ ping -c 2 pdbdr1-priv
[oracle@pdb1/pdb2/pdb3/pdbdr1/pdbdr2 ~]$ ping -c 2 pdbdr2-priv
[oracle@pdb1/pdb2/pdb3/pdbdr1/pdbdr2 ~]$ ping -c 2 pdbdr1-vip
[oracle@pdb1/pdb2/pdb3/pdbdr1/pdbdr2 ~]$ ping -c 2 pdbdr2-vip
[oracle@pdb1/pdb2/pdb3/pdbdr1/pdbdr2 ~]$ ping -c 2 pdbdr-scan


-- Step 50 -->> On Node 1
-- To setup SSH Pass
[root@pdb1 ~]# su - grid
[grid@pdb1 ~]$ cd /opt/app/11.2.0.3.0/grid/deinstall
[grid@pdb1 deinstall]$ ./sshUserSetup.sh -user grid -hosts "pdb1 pdb2 pdb3" -noPromptPassphrase -confirm -advanced
/*
Password: grid
*/

-- Step 50.1 -->> On All Nodes
[grid@pdb1/pdb2/pdb3 ~]$ ssh grid@pdb1 date
[grid@pdb1/pdb2/pdb3 ~]$ ssh grid@pdb2 date
[grid@pdb1/pdb2/pdb3 ~]$ ssh grid@pdb3 date
[grid@pdb1/pdb2/pdb3 ~]$ ssh grid@pdb1 date && ssh grid@pdb2 date && ssh grid@pdb3 date 
[grid@pdb1/pdb2/pdb3 ~]$ ssh grid@pdb1.unidev.org.np date
[grid@pdb1/pdb2/pdb3 ~]$ ssh grid@pdb2.unidev.org.np date
[grid@pdb1/pdb2/pdb3 ~]$ ssh grid@pdb3.unidev.org.np date
[grid@pdb1/pdb2/pdb3 ~]$ ssh grid@pdb1.unidev.org.np date && ssh grid@pdb2.unidev.org.np date && ssh grid@pdb3.unidev.org.np date
[grid@pdb1/pdb2/pdb3 ~]$ ssh grid@192.168.16.21 date
[grid@pdb1/pdb2/pdb3 ~]$ ssh grid@192.168.16.22 date
[grid@pdb1/pdb2/pdb3 ~]$ ssh grid@192.168.16.28 date
[grid@pdb1/pdb2/pdb3 ~]$ ssh grid@192.168.16.21 date && ssh grid@192.168.16.22 date && ssh grid@192.168.16.28 date 

-- Step 51 -->> On Node 1
-- To setup SSH Pass
[root@pdb1 ~]# su - oracle
[oracle@pdb1 ~]$ cd /opt/app/oracle/product/11.2.0.3.0/db_1/deinstall
[oracle@pdb1 deinstall]$ ./sshUserSetup.sh -user oracle -hosts "pdb1 pdb2 pdb3" -noPromptPassphrase -confirm -advanced
/*
Password: oracle
*/

-- Step 51.1 -->> On All Nodes
[oracle@pdb1/pdb2/pdb3 ~]$ ssh oracle@pdb1 date
[oracle@pdb1/pdb2/pdb3 ~]$ ssh oracle@pdb2 date
[oracle@pdb1/pdb2/pdb3 ~]$ ssh oracle@pdb3 date
[oracle@pdb1/pdb2/pdb3 ~]$ ssh oracle@pdb1 date && ssh oracle@pdb2 date && ssh oracle@pdb3 date 
[oracle@pdb1/pdb2/pdb3 ~]$ ssh oracle@pdb1.unidev.org.np date
[oracle@pdb1/pdb2/pdb3 ~]$ ssh oracle@pdb2.unidev.org.np date
[oracle@pdb1/pdb2/pdb3 ~]$ ssh oracle@pdb3.unidev.org.np date
[oracle@pdb1/pdb2/pdb3 ~]$ ssh oracle@pdb1.unidev.org.np date && ssh oracle@pdb2.unidev.org.np date && ssh oracle@pdb3.unidev.org.np date
[oracle@pdb1/pdb2/pdb3 ~]$ ssh oracle@192.168.16.21 date
[oracle@pdb1/pdb2/pdb3 ~]$ ssh oracle@192.168.16.22 date
[oracle@pdb1/pdb2/pdb3 ~]$ ssh oracle@192.168.16.28 date
[oracle@pdb1/pdb2/pdb3 ~]$ ssh oracle@192.168.16.21 date && ssh oracle@192.168.16.22 date && ssh oracle@192.168.16.28 date 


-- Step 52 -->> On Node 1
[grid@pdb1 ~]$ which cluvfy
/*
/opt/app/11.2.0.3.0/grid/bin/cluvfy
*/

-- Step 53 -->> On Node 1
[grid@pdb1 ~]$ cd /opt/app/11.2.0.3.0/grid/bin
[grid@pdb1 bin]$ cluvfy stage -pre nodeadd -n pdb3 -fixup -verbose
/*
Performing pre-checks for node addition

Checking node reachability...

Check: Node reachability from node "pdb1"
  Destination Node                      Reachable?
  ------------------------------------  ------------------------
  pdb3                                  yes
Result: Node reachability check passed from node "pdb1"


Checking user equivalence...

Check: User equivalence for user "grid"
  Node Name                             Status
  ------------------------------------  ------------------------
  pdb3                                  passed
Result: User equivalence check passed for user "grid"

Checking node connectivity...

Checking hosts config file...
  Node Name                             Status
  ------------------------------------  ------------------------
  pdb1                                  passed
  pdb2                                  passed
  pdb3                                  passed

Verification of the hosts config file successful


Interface information for node "pdb1"
 Name   IP Address      Subnet          Gateway         Def. Gateway    HW Address        MTU
 ------ --------------- --------------- --------------- --------------- ----------------- ------
 eth0   192.168.16.21     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:F4:BC:32 1500
 eth0   192.168.16.27     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:F4:BC:32 1500
 eth0   192.168.16.26     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:F4:BC:32 1500
 eth0   192.168.16.23     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:F4:BC:32 1500
 eth1   10.10.10.21     10.10.10.0      0.0.0.0         192.168.16.1      00:0C:29:F4:BC:3C 1500
 eth1   169.254.78.91   169.254.0.0     0.0.0.0         192.168.16.1      00:0C:29:F4:BC:3C 1500


Interface information for node "pdb2"
 Name   IP Address      Subnet          Gateway         Def. Gateway    HW Address        MTU
 ------ --------------- --------------- --------------- --------------- ----------------- ------
 eth0   192.168.16.22     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:64:B4:57 1500
 eth0   192.168.16.24     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:64:B4:57 1500
 eth0   192.168.16.25     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:64:B4:57 1500
 eth1   10.10.10.22     10.10.10.0      0.0.0.0         192.168.16.1      00:0C:29:64:B4:61 1500
 eth1   169.254.244.202 169.254.0.0     0.0.0.0         192.168.16.1      00:0C:29:64:B4:61 1500


Interface information for node "pdb3"
 Name   IP Address      Subnet          Gateway         Def. Gateway    HW Address        MTU
 ------ --------------- --------------- --------------- --------------- ----------------- ------
 eth0   192.168.16.28     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:57:2D:AF 1500
 eth1   10.10.10.28     10.10.10.0      0.0.0.0         192.168.16.1      00:0C:29:57:2D:B9 1500


Check: Node connectivity for interface "eth0"
  Source                          Destination                     Connected?
  ------------------------------  ------------------------------  ----------------
  pdb1[192.168.16.21]               pdb1[192.168.16.27]               yes
  pdb1[192.168.16.21]               pdb1[192.168.16.26]               yes
  pdb1[192.168.16.21]               pdb1[192.168.16.23]               yes
  pdb1[192.168.16.21]               pdb2[192.168.16.22]               yes
  pdb1[192.168.16.21]               pdb2[192.168.16.24]               yes
  pdb1[192.168.16.21]               pdb2[192.168.16.25]               yes
  pdb1[192.168.16.21]               pdb3[192.168.16.28]               yes
  pdb1[192.168.16.27]               pdb1[192.168.16.26]               yes
  pdb1[192.168.16.27]               pdb1[192.168.16.23]               yes
  pdb1[192.168.16.27]               pdb2[192.168.16.22]               yes
  pdb1[192.168.16.27]               pdb2[192.168.16.24]               yes
  pdb1[192.168.16.27]               pdb2[192.168.16.25]               yes
  pdb1[192.168.16.27]               pdb3[192.168.16.28]               yes
  pdb1[192.168.16.26]               pdb1[192.168.16.23]               yes
  pdb1[192.168.16.26]               pdb2[192.168.16.22]               yes
  pdb1[192.168.16.26]               pdb2[192.168.16.24]               yes
  pdb1[192.168.16.26]               pdb2[192.168.16.25]               yes
  pdb1[192.168.16.26]               pdb3[192.168.16.28]               yes
  pdb1[192.168.16.23]               pdb2[192.168.16.22]               yes
  pdb1[192.168.16.23]               pdb2[192.168.16.24]               yes
  pdb1[192.168.16.23]               pdb2[192.168.16.25]               yes
  pdb1[192.168.16.23]               pdb3[192.168.16.28]               yes
  pdb2[192.168.16.22]               pdb2[192.168.16.24]               yes
  pdb2[192.168.16.22]               pdb2[192.168.16.25]               yes
  pdb2[192.168.16.22]               pdb3[192.168.16.28]               yes
  pdb2[192.168.16.24]               pdb2[192.168.16.25]               yes
  pdb2[192.168.16.24]               pdb3[192.168.16.28]               yes
  pdb2[192.168.16.25]               pdb3[192.168.16.28]               yes
Result: Node connectivity passed for interface "eth0"


Check: TCP connectivity of subnet "192.168.16.0"
  Source                          Destination                     Connected?
  ------------------------------  ------------------------------  ----------------
  pdb1:192.168.16.21                pdb1:192.168.16.27                passed
  pdb1:192.168.16.21                pdb1:192.168.16.26                passed
  pdb1:192.168.16.21                pdb1:192.168.16.23                passed
  pdb1:192.168.16.21                pdb2:192.168.16.22                passed
  pdb1:192.168.16.21                pdb2:192.168.16.24                passed
  pdb1:192.168.16.21                pdb2:192.168.16.25                passed
  pdb1:192.168.16.21                pdb3:192.168.16.28                passed
Result: TCP connectivity check passed for subnet "192.168.16.0"

Checking subnet mask consistency...
Subnet mask consistency check passed for subnet "192.168.16.0".
Subnet mask consistency check passed.

Result: Node connectivity check passed

Checking multicast communication...

Checking subnet "192.168.16.0" for multicast communication with multicast group "230.0.1.0"...
Check of subnet "192.168.16.0" for multicast communication with multicast group "230.0.1.0" passed.

Check of multicast communication passed.

Checking CRS integrity...

Clusterware version consistency passed
The Oracle Clusterware is healthy on node "pdb1"
The Oracle Clusterware is healthy on node "pdb2"

CRS integrity check passed

Checking shared resources...

Checking CRS home location...
PRVG-1013 : The path "/opt/app/11.2.0.3.0/grid" does not exist or cannot be created on the nodes to be added
Result: Shared resources check for node addition failed


Checking node connectivity...

Checking hosts config file...
  Node Name                             Status
  ------------------------------------  ------------------------
  pdb1                                  passed
  pdb2                                  passed
  pdb3                                  passed

Verification of the hosts config file successful


Interface information for node "pdb1"
 Name   IP Address      Subnet          Gateway         Def. Gateway    HW Address        MTU
 ------ --------------- --------------- --------------- --------------- ----------------- ------
 eth0   192.168.16.21     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:F4:BC:32 1500
 eth0   192.168.16.27     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:F4:BC:32 1500
 eth0   192.168.16.26     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:F4:BC:32 1500
 eth0   192.168.16.23     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:F4:BC:32 1500
 eth1   10.10.10.21     10.10.10.0      0.0.0.0         192.168.16.1      00:0C:29:F4:BC:3C 1500
 eth1   169.254.78.91   169.254.0.0     0.0.0.0         192.168.16.1      00:0C:29:F4:BC:3C 1500


Interface information for node "pdb2"
 Name   IP Address      Subnet          Gateway         Def. Gateway    HW Address        MTU
 ------ --------------- --------------- --------------- --------------- ----------------- ------
 eth0   192.168.16.22     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:64:B4:57 1500
 eth0   192.168.16.24     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:64:B4:57 1500
 eth0   192.168.16.25     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:64:B4:57 1500
 eth1   10.10.10.22     10.10.10.0      0.0.0.0         192.168.16.1      00:0C:29:64:B4:61 1500
 eth1   169.254.244.202 169.254.0.0     0.0.0.0         192.168.16.1      00:0C:29:64:B4:61 1500


Interface information for node "pdb3"
 Name   IP Address      Subnet          Gateway         Def. Gateway    HW Address        MTU
 ------ --------------- --------------- --------------- --------------- ----------------- ------
 eth0   192.168.16.28     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:57:2D:AF 1500
 eth1   10.10.10.28     10.10.10.0      0.0.0.0         192.168.16.1      00:0C:29:57:2D:B9 1500


Check: Node connectivity for interface "eth0"
  Source                          Destination                     Connected?
  ------------------------------  ------------------------------  ----------------
  pdb1[192.168.16.21]               pdb1[192.168.16.27]               yes
  pdb1[192.168.16.21]               pdb1[192.168.16.26]               yes
  pdb1[192.168.16.21]               pdb1[192.168.16.23]               yes
  pdb1[192.168.16.21]               pdb2[192.168.16.22]               yes
  pdb1[192.168.16.21]               pdb2[192.168.16.24]               yes
  pdb1[192.168.16.21]               pdb2[192.168.16.25]               yes
  pdb1[192.168.16.21]               pdb3[192.168.16.28]               yes
  pdb1[192.168.16.27]               pdb1[192.168.16.26]               yes
  pdb1[192.168.16.27]               pdb1[192.168.16.23]               yes
  pdb1[192.168.16.27]               pdb2[192.168.16.22]               yes
  pdb1[192.168.16.27]               pdb2[192.168.16.24]               yes
  pdb1[192.168.16.27]               pdb2[192.168.16.25]               yes
  pdb1[192.168.16.27]               pdb3[192.168.16.28]               yes
  pdb1[192.168.16.26]               pdb1[192.168.16.23]               yes
  pdb1[192.168.16.26]               pdb2[192.168.16.22]               yes
  pdb1[192.168.16.26]               pdb2[192.168.16.24]               yes
  pdb1[192.168.16.26]               pdb2[192.168.16.25]               yes
  pdb1[192.168.16.26]               pdb3[192.168.16.28]               yes
  pdb1[192.168.16.23]               pdb2[192.168.16.22]               yes
  pdb1[192.168.16.23]               pdb2[192.168.16.24]               yes
  pdb1[192.168.16.23]               pdb2[192.168.16.25]               yes
  pdb1[192.168.16.23]               pdb3[192.168.16.28]               yes
  pdb2[192.168.16.22]               pdb2[192.168.16.24]               yes
  pdb2[192.168.16.22]               pdb2[192.168.16.25]               yes
  pdb2[192.168.16.22]               pdb3[192.168.16.28]               yes
  pdb2[192.168.16.24]               pdb2[192.168.16.25]               yes
  pdb2[192.168.16.24]               pdb3[192.168.16.28]               yes
  pdb2[192.168.16.25]               pdb3[192.168.16.28]               yes
Result: Node connectivity passed for interface "eth0"


Check: TCP connectivity of subnet "192.168.16.0"
  Source                          Destination                     Connected?
  ------------------------------  ------------------------------  ----------------
  pdb1:192.168.16.21                pdb1:192.168.16.27                passed
  pdb1:192.168.16.21                pdb1:192.168.16.26                passed
  pdb1:192.168.16.21                pdb1:192.168.16.23                passed
  pdb1:192.168.16.21                pdb2:192.168.16.22                passed
  pdb1:192.168.16.21                pdb2:192.168.16.24                passed
  pdb1:192.168.16.21                pdb2:192.168.16.25                passed
  pdb1:192.168.16.21                pdb3:192.168.16.28                passed
Result: TCP connectivity check passed for subnet "192.168.16.0"


Check: Node connectivity for interface "eth1"
  Source                          Destination                     Connected?
  ------------------------------  ------------------------------  ----------------
  pdb1[10.10.10.21]               pdb2[10.10.10.22]               yes
  pdb1[10.10.10.21]               pdb3[10.10.10.28]               yes
  pdb2[10.10.10.22]               pdb3[10.10.10.28]               yes
Result: Node connectivity passed for interface "eth1"


Check: TCP connectivity of subnet "10.10.10.0"
  Source                          Destination                     Connected?
  ------------------------------  ------------------------------  ----------------
  pdb1:10.10.10.21                pdb2:10.10.10.22                passed
  pdb1:10.10.10.21                pdb3:10.10.10.28                passed
Result: TCP connectivity check passed for subnet "10.10.10.0"

Checking subnet mask consistency...
Subnet mask consistency check passed for subnet "192.168.16.0".
Subnet mask consistency check passed for subnet "10.10.10.0".
Subnet mask consistency check passed.

Result: Node connectivity check passed

Checking multicast communication...

Checking subnet "192.168.16.0" for multicast communication with multicast group "230.0.1.0"...
Check of subnet "192.168.16.0" for multicast communication with multicast group "230.0.1.0" passed.

Checking subnet "10.10.10.0" for multicast communication with multicast group "230.0.1.0"...
Check of subnet "10.10.10.0" for multicast communication with multicast group "230.0.1.0" passed.

Check of multicast communication passed.

Check: Total memory
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          19.3574GB (2.0297672E7KB)  1.5GB (1572864.0KB)       passed
  pdb1          19.3574GB (2.0297672E7KB)  1.5GB (1572864.0KB)       passed
Result: Total memory check passed

Check: Available memory
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          18.9599GB (1.9880856E7KB)  50MB (51200.0KB)          passed
  pdb1          16.6252GB (1.743274E7KB)  50MB (51200.0KB)          passed
Result: Available memory check passed

Check: Swap space
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          20GB (2.0971516E7KB)      16GB (1.6777216E7KB)      passed
  pdb1          20GB (2.0971516E7KB)      16GB (1.6777216E7KB)      passed
Result: Swap space check passed

Check: Free disk space for "pdb3:/opt/app/11.2.0.3.0/grid"
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /opt/app/11.2.0.3.0/grid  pdb3          /opt          56.6162GB     5.5GB         passed
Result: Free disk space check passed for "pdb3:/opt/app/11.2.0.3.0/grid"

Check: Free disk space for "pdb1:/opt/app/11.2.0.3.0/grid"
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /opt/app/11.2.0.3.0/grid  pdb1          /opt          44.3936GB     5.5GB         passed
Result: Free disk space check passed for "pdb1:/opt/app/11.2.0.3.0/grid"

Check: Free disk space for "pdb3:/tmp"
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /tmp              pdb3          /tmp          14.5078GB     1GB           passed
Result: Free disk space check passed for "pdb3:/tmp"

Check: Free disk space for "pdb1:/tmp"
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /tmp              pdb1          /tmp          14.5GB        1GB           passed
Result: Free disk space check passed for "pdb1:/tmp"

Check: User existence for "grid"
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdb3          passed                    exists(501)
  pdb1          passed                    exists(501)

Checking for multiple users with UID value 501
Result: Check for multiple users with UID value 501 passed
Result: User existence check passed for "grid"

Check: Run level
  Node Name     run level                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          5                         3,5                       passed
  pdb1          5                         3,5                       passed
Result: Run level check passed

Check: Hard limits for "maximum open file descriptors"
  Node Name         Type          Available     Required      Status
  ----------------  ------------  ------------  ------------  ----------------
  pdb1              hard          65536         65536         passed
  pdb3              hard          65536         65536         passed
Result: Hard limits check passed for "maximum open file descriptors"

Check: Soft limits for "maximum open file descriptors"
  Node Name         Type          Available     Required      Status
  ----------------  ------------  ------------  ------------  ----------------
  pdb1              soft          65536         1024          passed
  pdb3              soft          65536         1024          passed
Result: Soft limits check passed for "maximum open file descriptors"

Check: Hard limits for "maximum user processes"
  Node Name         Type          Available     Required      Status
  ----------------  ------------  ------------  ------------  ----------------
  pdb1              hard          16384         16384         passed
  pdb3              hard          16384         16384         passed
Result: Hard limits check passed for "maximum user processes"

Check: Soft limits for "maximum user processes"
  Node Name         Type          Available     Required      Status
  ----------------  ------------  ------------  ------------  ----------------
  pdb1              soft          16384         2047          passed
  pdb3              soft          16384         2047          passed
Result: Soft limits check passed for "maximum user processes"

Check: System architecture
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          x86_64                    x86_64                    passed
  pdb1          x86_64                    x86_64                    passed
Result: System architecture check passed

Check: Kernel version
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          4.1.12-124.48.6.el6uek.x86_64  2.6.32                    passed
  pdb1          4.1.12-124.48.6.el6uek.x86_64  2.6.32                    passed
Result: Kernel version check passed

Check: Kernel parameter for "semmsl"
  Node Name         Current       Configured    Required      Status        Comment
  ----------------  ------------  ------------  ------------  ------------  ------------
  pdb1              250           250           250           passed
  pdb3              250           250           250           passed
Result: Kernel parameter check passed for "semmsl"

Check: Kernel parameter for "semmns"
  Node Name         Current       Configured    Required      Status        Comment
  ----------------  ------------  ------------  ------------  ------------  ------------
  pdb1              32000         32000         32000         passed
  pdb3              32000         32000         32000         passed
Result: Kernel parameter check passed for "semmns"

Check: Kernel parameter for "semopm"
  Node Name         Current       Configured    Required      Status        Comment
  ----------------  ------------  ------------  ------------  ------------  ------------
  pdb1              100           100           100           passed
  pdb3              100           100           100           passed
Result: Kernel parameter check passed for "semopm"

Check: Kernel parameter for "semmni"
  Node Name         Current       Configured    Required      Status        Comment
  ----------------  ------------  ------------  ------------  ------------  ------------
  pdb1              128           128           128           passed
  pdb3              128           128           128           passed
Result: Kernel parameter check passed for "semmni"

Check: Kernel parameter for "shmmax"
  Node Name         Current       Configured    Required      Status        Comment
  ----------------  ------------  ------------  ------------  ------------  ------------
  pdb1              4398046511104  4398046511104  4294967295    passed
  pdb3              4398046511104  4398046511104  4294967295    passed
Result: Kernel parameter check passed for "shmmax"

Check: Kernel parameter for "shmmni"
  Node Name         Current       Configured    Required      Status        Comment
  ----------------  ------------  ------------  ------------  ------------  ------------
  pdb1              4096          65536         4096          passed
  pdb3              4096          65536         4096          passed
Result: Kernel parameter check passed for "shmmni"

Check: Kernel parameter for "shmall"
  Node Name         Current       Configured    Required      Status        Comment
  ----------------  ------------  ------------  ------------  ------------  ------------
  pdb1              4294967296    4294967296    2097152       passed
  pdb3              4294967296    4294967296    2097152       passed
Result: Kernel parameter check passed for "shmall"

Check: Kernel parameter for "file-max"
  Node Name         Current       Configured    Required      Status        Comment
  ----------------  ------------  ------------  ------------  ------------  ------------
  pdb1              6815744       6815744       6815744       passed
  pdb3              6815744       6815744       6815744       passed
Result: Kernel parameter check passed for "file-max"

Check: Kernel parameter for "ip_local_port_range"
  Node Name         Current       Configured    Required      Status        Comment
  ----------------  ------------  ------------  ------------  ------------  ------------
  pdb1              between 9000.0 & 65500.0  between 49152.0 & 65535.0  between 9000.0 & 65500.0  failed (ignorable)  Configured value too low.
  pdb3              between 9000.0 & 65500.0  between 49152.0 & 65535.0  between 9000.0 & 65500.0  failed (ignorable)  Configured value too low.
Result: Kernel parameter check passed for "ip_local_port_range"

Check: Kernel parameter for "rmem_default"
  Node Name         Current       Configured    Required      Status        Comment
  ----------------  ------------  ------------  ------------  ------------  ------------
  pdb1              262144        262144        262144        passed
  pdb3              262144        262144        262144        passed
Result: Kernel parameter check passed for "rmem_default"

Check: Kernel parameter for "rmem_max"
  Node Name         Current       Configured    Required      Status        Comment
  ----------------  ------------  ------------  ------------  ------------  ------------
  pdb1              4194304       4194304       4194304       passed
  pdb3              4194304       4194304       4194304       passed
Result: Kernel parameter check passed for "rmem_max"

Check: Kernel parameter for "wmem_default"
  Node Name         Current       Configured    Required      Status        Comment
  ----------------  ------------  ------------  ------------  ------------  ------------
  pdb1              262144        262144        262144        passed
  pdb3              262144        262144        262144        passed
Result: Kernel parameter check passed for "wmem_default"

Check: Kernel parameter for "wmem_max"
  Node Name         Current       Configured    Required      Status        Comment
  ----------------  ------------  ------------  ------------  ------------  ------------
  pdb1              1048576       1048576       1048576       passed
  pdb3              1048576       1048576       1048576       passed
Result: Kernel parameter check passed for "wmem_max"

Check: Kernel parameter for "aio-max-nr"
  Node Name         Current       Configured    Required      Status        Comment
  ----------------  ------------  ------------  ------------  ------------  ------------
  pdb1              1048576       1048576       1048576       passed
  pdb3              1048576       1048576       1048576       passed
Result: Kernel parameter check passed for "aio-max-nr"

Check: Package existence for "binutils"
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          binutils-2.20.51.0.2-5.48.0.3.el6_10.1  binutils-2.20.51.0.2      passed
  pdb1          binutils-2.20.51.0.2-5.48.0.3.el6_10.1  binutils-2.20.51.0.2      passed
Result: Package existence check passed for "binutils"

Check: Package existence for "compat-libcap1"
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          compat-libcap1-1.10-1     compat-libcap1-1.10       passed
  pdb1          compat-libcap1-1.10-1     compat-libcap1-1.10       passed
Result: Package existence check passed for "compat-libcap1"

Check: Package existence for "compat-libstdc++-33(x86_64)"
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          compat-libstdc++-33(x86_64)-3.2.3-69.el6  compat-libstdc++-33(x86_64)-3.2.3  passed
  pdb1          compat-libstdc++-33(x86_64)-3.2.3-69.el6  compat-libstdc++-33(x86_64)-3.2.3  passed
Result: Package existence check passed for "compat-libstdc++-33(x86_64)"

Check: Package existence for "libgcc(x86_64)"
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          libgcc(x86_64)-4.4.7-23.0.1.el6  libgcc(x86_64)-4.4.4      passed
  pdb1          libgcc(x86_64)-4.4.7-23.0.1.el6  libgcc(x86_64)-4.4.4      passed
Result: Package existence check passed for "libgcc(x86_64)"

Check: Package existence for "libstdc++(x86_64)"
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          libstdc++(x86_64)-4.4.7-23.0.1.el6  libstdc++(x86_64)-4.4.4   passed
  pdb1          libstdc++(x86_64)-4.4.7-23.0.1.el6  libstdc++(x86_64)-4.4.4   passed
Result: Package existence check passed for "libstdc++(x86_64)"

Check: Package existence for "libstdc++-devel(x86_64)"
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          libstdc++-devel(x86_64)-4.4.7-23.0.1.el6  libstdc++-devel(x86_64)-4.4.4  passed
  pdb1          libstdc++-devel(x86_64)-4.4.7-23.0.1.el6  libstdc++-devel(x86_64)-4.4.4  passed
Result: Package existence check passed for "libstdc++-devel(x86_64)"

Check: Package existence for "sysstat"
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          sysstat-9.0.4-33.0.1.el6_9.1  sysstat-9.0.4             passed
  pdb1          sysstat-9.0.4-33.0.1.el6_9.1  sysstat-9.0.4             passed
Result: Package existence check passed for "sysstat"

Check: Package existence for "gcc"
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          gcc-4.4.7-23.0.1.el6      gcc-4.4.4                 passed
  pdb1          gcc-4.4.7-23.0.1.el6      gcc-4.4.4                 passed
Result: Package existence check passed for "gcc"

Check: Package existence for "gcc-c++"
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          gcc-c++-4.4.7-23.0.1.el6  gcc-c++-4.4.4             passed
  pdb1          gcc-c++-4.4.7-23.0.1.el6  gcc-c++-4.4.4             passed
Result: Package existence check passed for "gcc-c++"

Check: Package existence for "ksh"
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          ksh-20120801-38.el6_10    ksh-20100621              passed
  pdb1          ksh-20120801-38.el6_10    ksh-20100621              passed
Result: Package existence check passed for "ksh"

Check: Package existence for "make"
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          make-3.81-23.el6          make-3.81                 passed
  pdb1          make-3.81-23.el6          make-3.81                 passed
Result: Package existence check passed for "make"

Check: Package existence for "glibc(x86_64)"
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          glibc(x86_64)-2.12-1.212.0.3.el6_10.3  glibc(x86_64)-2.12        passed
  pdb1          glibc(x86_64)-2.12-1.212.0.3.el6_10.3  glibc(x86_64)-2.12        passed
Result: Package existence check passed for "glibc(x86_64)"

Check: Package existence for "glibc-devel(x86_64)"
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          glibc-devel(x86_64)-2.12-1.212.0.3.el6_10.3  glibc-devel(x86_64)-2.12  passed
  pdb1          glibc-devel(x86_64)-2.12-1.212.0.3.el6_10.3  glibc-devel(x86_64)-2.12  passed
Result: Package existence check passed for "glibc-devel(x86_64)"

Check: Package existence for "libaio(x86_64)"
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          libaio(x86_64)-0.3.107-10.el6  libaio(x86_64)-0.3.107    passed
  pdb1          libaio(x86_64)-0.3.107-10.el6  libaio(x86_64)-0.3.107    passed
Result: Package existence check passed for "libaio(x86_64)"

Check: Package existence for "libaio-devel(x86_64)"
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb3          libaio-devel(x86_64)-0.3.107-10.el6  libaio-devel(x86_64)-0.3.107  passed
  pdb1          libaio-devel(x86_64)-0.3.107-10.el6  libaio-devel(x86_64)-0.3.107  passed
Result: Package existence check passed for "libaio-devel(x86_64)"

Checking for multiple users with UID value 0
Result: Check for multiple users with UID value 0 passed

Check: Current group ID
Result: Current group ID check passed

Starting check for consistency of primary group of root user
  Node Name                             Status
  ------------------------------------  ------------------------
  pdb3                                  passed
  pdb1                                  passed

Check for consistency of root user's primary group passed

Checking OCR integrity...

OCR integrity check passed

Checking Oracle Cluster Voting Disk configuration...

Oracle Cluster Voting Disk configuration check passed
Check: Time zone consistency
Result: Time zone consistency check passed

Starting Clock synchronization checks using Network Time Protocol(NTP)...

NTP Configuration file check started...
Network Time Protocol(NTP) configuration file not found on any of the nodes. Oracle Cluster Time Synchronization Service(CTSS) can be used instead of NTP for time synchronization on the cluster nodes
No NTP Daemons or Services were found to be running

Result: Clock synchronization check using Network Time Protocol(NTP) passed


Checking to make sure user "grid" is not in "root" group
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdb3          passed                    does not exist
  pdb1          passed                    does not exist
Result: User "grid" is not part of "root" group. Check passed
Checking consistency of file "/etc/resolv.conf" across nodes

Checking the file "/etc/resolv.conf" to make sure only one of domain and search entries is defined
File "/etc/resolv.conf" does not have both domain and search entries defined
Checking if domain entry in file "/etc/resolv.conf" is consistent across the nodes...
domain entry in file "/etc/resolv.conf" is consistent across nodes
Checking if search entry in file "/etc/resolv.conf" is consistent across the nodes...
search entry in file "/etc/resolv.conf" is consistent across nodes
Checking file "/etc/resolv.conf" to make sure that only one search entry is defined
All nodes have one search entry defined in file "/etc/resolv.conf"
Checking all nodes to make sure that search entry is "cibnepal.org.np" as found on node "pdb1"
All nodes of the cluster have same value for 'search'
Checking DNS response time for an unreachable node
  Node Name                             Status
  ------------------------------------  ------------------------
  pdb1                                  failed
  pdb3                                  failed
PRVF-5637 : DNS response time could not be checked on following nodes: pdb1,pdb3

File "/etc/resolv.conf" is not consistent across nodes

Fixup information has been generated for following node(s):
pdb3,pdb1
Please run the following script on each node as "root" user to execute the fixups:
'/tmp/CVU_11.2.0.3.0_grid/runfixup.sh'

Pre-check for node addition was unsuccessful on all the nodes.
*/

-- Step 53.1 -->> On Node 1 and 3
[root@pdb1/pdb3 ~]# /tmp/CVU_11.2.0.3.0_grid/runfixup.sh
/*
Response file being used is :/tmp/CVU_11.2.0.3.0_grid/fixup.response
Enable file being used is :/tmp/CVU_11.2.0.3.0_grid/fixup.enable
Log file location: /tmp/CVU_11.2.0.3.0_grid/orarun.log
Nothing to fix!!
*/

-- Step 54 -->> On Node 1
[grid@pdb1 ~]$ cd /opt/app/11.2.0.3.0/grid/oui/bin/
[grid@pdb1 bin]$ export IGNORE_PREADDNODE_CHECKS=Y
[grid@pdb1 bin]$ ./addNode.sh "CLUSTER_NEW_NODES={pdb3}" "CLUSTER_NEW_VIRTUAL_HOSTNAMES={pdb3-vip}"
/*
Starting Oracle Universal Installer...

Checking swap space: must be greater than 500 MB.   Actual 20479 MB    Passed
Oracle Universal Installer, Version 11.2.0.3.0 Production
Copyright (C) 1999, 2011, Oracle. All rights reserved.


Performing tests to see whether nodes pdb2,pdb3 are available
............................................................... 100% Done.

.
-----------------------------------------------------------------------------
Cluster Node Addition Summary
Global Settings
   Source: /opt/app/11.2.0.3.0/grid
   New Nodes
Space Requirements
   New Nodes
      pdb3
         /opt: Required 5.38GB : Available 52.72GB
Installed Products
   Product Names
      Oracle Grid Infrastructure 11.2.0.3.0
      Sun JDK 1.5.0.30.03
      Installer SDK Component 11.2.0.3.0
      Oracle One-Off Patch Installer 11.2.0.1.7
      Oracle Universal Installer 11.2.0.3.0
      Oracle USM Deconfiguration 11.2.0.3.0
      Oracle Configuration Manager Deconfiguration 10.3.1.0.0
      Enterprise Manager Common Core Files 10.2.0.4.4
      Oracle DBCA Deconfiguration 11.2.0.3.0
      Oracle RAC Deconfiguration 11.2.0.3.0
      Oracle Quality of Service Management (Server) 11.2.0.3.0
      Installation Plugin Files 11.2.0.3.0
      Universal Storage Manager Files 11.2.0.3.0
      Oracle Text Required Support Files 11.2.0.3.0
      Automatic Storage Management Assistant 11.2.0.3.0
      Oracle Database 11g Multimedia Files 11.2.0.3.0
      Oracle Multimedia Java Advanced Imaging 11.2.0.3.0
      Oracle Globalization Support 11.2.0.3.0
      Oracle Multimedia Locator RDBMS Files 11.2.0.3.0
      Oracle Core Required Support Files 11.2.0.3.0
      Bali Share 1.1.18.0.0
      Oracle Database Deconfiguration 11.2.0.3.0
      Oracle Quality of Service Management (Client) 11.2.0.3.0
      Expat libraries 2.0.1.0.1
      Oracle Containers for Java 11.2.0.3.0
      Perl Modules 5.10.0.0.1
      Secure Socket Layer 11.2.0.3.0
      Oracle JDBC/OCI Instant Client 11.2.0.3.0
      Oracle Multimedia Client Option 11.2.0.3.0
      LDAP Required Support Files 11.2.0.3.0
      Character Set Migration Utility 11.2.0.3.0
      Perl Interpreter 5.10.0.0.2
      PL/SQL Embedded Gateway 11.2.0.3.0
      OLAP SQL Scripts 11.2.0.3.0
      Database SQL Scripts 11.2.0.3.0
      Oracle Extended Windowing Toolkit 3.4.47.0.0
      SSL Required Support Files for InstantClient 11.2.0.3.0
      SQL*Plus Files for Instant Client 11.2.0.3.0
      Oracle Net Required Support Files 11.2.0.3.0
      Oracle Database User Interface 2.2.13.0.0
      RDBMS Required Support Files for Instant Client 11.2.0.3.0
      RDBMS Required Support Files Runtime 11.2.0.3.0
      XML Parser for Java 11.2.0.3.0
      Oracle Security Developer Tools 11.2.0.3.0
      Oracle Wallet Manager 11.2.0.3.0
      Enterprise Manager plugin Common Files 11.2.0.3.0
      Platform Required Support Files 11.2.0.3.0
      Oracle JFC Extended Windowing Toolkit 4.2.36.0.0
      RDBMS Required Support Files 11.2.0.3.0
      Oracle Ice Browser 5.2.3.6.0
      Oracle Help For Java 4.2.9.0.0
      Enterprise Manager Common Files 10.2.0.4.3
      Deinstallation Tool 11.2.0.3.0
      Oracle Java Client 11.2.0.3.0
      Cluster Verification Utility Files 11.2.0.3.0
      Oracle Notification Service (eONS) 11.2.0.3.0
      Oracle LDAP administration 11.2.0.3.0
      Cluster Verification Utility Common Files 11.2.0.3.0
      Oracle Clusterware RDBMS Files 11.2.0.3.0
      Oracle Locale Builder 11.2.0.3.0
      Oracle Globalization Support 11.2.0.3.0
      Buildtools Common Files 11.2.0.3.0
      Oracle RAC Required Support Files-HAS 11.2.0.3.0
      SQL*Plus Required Support Files 11.2.0.3.0
      XDK Required Support Files 11.2.0.3.0
      Agent Required Support Files 10.2.0.4.3
      Parser Generator Required Support Files 11.2.0.3.0
      Precompiler Required Support Files 11.2.0.3.0
      Installation Common Files 11.2.0.3.0
      Required Support Files 11.2.0.3.0
      Oracle JDBC/THIN Interfaces 11.2.0.3.0
      Oracle Multimedia Locator 11.2.0.3.0
      Oracle Multimedia 11.2.0.3.0
      HAS Common Files 11.2.0.3.0
      Assistant Common Files 11.2.0.3.0
      PL/SQL 11.2.0.3.0
      HAS Files for DB 11.2.0.3.0
      Oracle Recovery Manager 11.2.0.3.0
      Oracle Database Utilities 11.2.0.3.0
      Oracle Notification Service 11.2.0.3.0
      SQL*Plus 11.2.0.3.0
      Oracle Netca Client 11.2.0.3.0
      Oracle Net 11.2.0.3.0
      Oracle JVM 11.2.0.3.0
      Oracle Internet Directory Client 11.2.0.3.0
      Oracle Net Listener 11.2.0.3.0
      Cluster Ready Services Files 11.2.0.3.0
      Oracle Database 11g 11.2.0.3.0
-----------------------------------------------------------------------------


Instantiating scripts for add node (Thursday, July 3, 2025 12:39:37 PM NPT)
.                                                                 1% Done.
Instantiation of add node scripts complete

Copying to remote nodes (Thursday, July 3, 2025 12:39:39 PM NPT)
...............................................................................................                                 96% Done.
Home copied to new nodes

Saving inventory on nodes (Thursday, July 3, 2025 12:43:00 PM NPT)
.                                                               100% Done.
Save inventory complete
WARNING:A new inventory has been created on one or more nodes in this session. However, it has not yet been registered as the central inventory of this system.
To register the new inventory please run the script at '/opt/app/oraInventory/orainstRoot.sh' with root privileges on nodes 'pdb3'.
If you do not register the inventory, you may not be able to update or patch the products you installed.
The following configuration scripts need to be executed as the "root" user in each new cluster node. Each script in the list below is followed by a list of nodes.
/opt/app/oraInventory/orainstRoot.sh #On nodes pdb3
/opt/app/11.2.0.3.0/grid/root.sh #On nodes pdb3
To execute the configuration scripts:
    1. Open a terminal window
    2. Log in as "root"
    3. Run the scripts in each cluster node

The Cluster Node Addition of /opt/app/11.2.0.3.0/grid was successful.
Please check '/tmp/silentInstall.log' for more details.
*/

-- Step 54.1 -->> On Node 1
[root@pdb1 ~]# tail -f /tmp/silentInstall.log
/*
If you do not register the inventory, you may not be able to update or patch the products you installed.
The following configuration scripts need to be executed as the "root" user in each new cluster node. Each script in the list below is followed by a list of nodes.
/opt/app/oraInventory/orainstRoot.sh #On nodes pdb3
/opt/app/11.2.0.3.0/grid/root.sh #On nodes pdb3
To execute the configuration scripts:
    1. Open a terminal window
    2. Log in as "root"
    3. Run the scripts in each cluster node

The Cluster Node Addition of /opt/app/11.2.0.3.0/grid was successful.
*/

-- Step 54.2 -->> On Node 3
[root@pdb3 ~]# /opt/app/oraInventory/orainstRoot.sh
/*
Creating the Oracle inventory pointer file (/etc/oraInst.loc)
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 54.3 -->> On Node 3
[root@pdb3 ~]# /opt/app/11.2.0.3.0/grid/root.sh
/*
Check /opt/app/11.2.0.3.0/grid/install/root_pdb3.unidev.org.np_2025-07-03_12-48-18.log for the output of root script
*/

-- Step 54.4 -->> On Node 3
[root@pdb3 ~]# tail -f /opt/app/11.2.0.3.0/grid/install/root_pdb3.unidev.org.np_2025-07-03_12-48-18.log
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
clscfg: EXISTING configuration version 5 detected.
clscfg: version 5 is 11g Release 2.
Successfully accumulated necessary OCR keys.
Creating OCR keys for user 'root', privgrp 'root'..
Operation successful.
Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 55 -->> On All Nodes
[root@pdb1/pdb2/pdb3 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
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

-- Step 56 -->> On All Nodes
[root@pdb1/pdb2/pdb3 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.ARC.dg
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
               ONLINE  ONLINE       pdb3
ora.DATA.dg
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
               ONLINE  ONLINE       pdb3
ora.LISTENER.lsnr
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
               ONLINE  ONLINE       pdb3
ora.OCR.dg
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
               ONLINE  ONLINE       pdb3
ora.asm
               ONLINE  ONLINE       pdb1                     Started
               ONLINE  ONLINE       pdb2                     Started
               ONLINE  ONLINE       pdb3                     Started
ora.gsd
               OFFLINE OFFLINE      pdb1
               OFFLINE OFFLINE      pdb2
               OFFLINE OFFLINE      pdb3
ora.net1.network
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
               ONLINE  ONLINE       pdb3
ora.ons
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
               ONLINE  ONLINE       pdb3
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdb2
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdb3
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
ora.pdb3.vip
      1        ONLINE  ONLINE       pdb3
ora.pdbdb.db
      1        ONLINE  ONLINE       pdb1                     Open
      2        ONLINE  ONLINE       pdb2                     Open
ora.scan1.vip
      1        ONLINE  ONLINE       pdb2
ora.scan2.vip
      1        ONLINE  ONLINE       pdb3
ora.scan3.vip
      1        ONLINE  ONLINE       pdb1
*/

-- Step 57 -->> On All Nodes
[root@pdb1/pdb2/pdb3 ~]# su - grid
[grid@pdb1/pdb2/pdb3 ~]$ which olsnodes
/*
/opt/app/11.2.0.3.0/grid/bin/olsnodes
*/

-- Step 57.1 -->> On All Nodes
[grid@pdb1/pdb2/pdb3 ~]$ olsnodes -n -s -t
/*
pdb1    1       Active  Unpinned
pdb2    2       Active  Unpinned
pdb3    3       Active  Unpinned
*/

-- Step 58 -->> On Node 1
[root@pdb1 ~]# ps -ef | grep pmon
/*
grid     11041     1  0 Jun30 ?        00:00:50 asm_pmon_+ASM1
oracle   16325     1  0 Jun30 ?        00:00:58 ora_pmon_pdbdb1
root     22307 13576  0 12:56 pts/0    00:00:00 grep pmon
*/

-- Step 59 -->> On Node 2
[root@pdb2 ~]# ps -ef | grep pmon
/*
root     21728 18116  0 12:56 pts/0    00:00:00 grep pmon
grid     26540     1  0 Jun30 ?        00:01:04 asm_pmon_+ASM2
oracle   30253     1  0 Jun30 ?        00:01:14 ora_pmon_pdbdb2
*/

-- Step 60 -->> On Node 3
[root@pdb3 ~]# ps -ef | grep pmon
/*
root      1347 24787  0 12:56 pts/0    00:00:00 grep pmon
grid     32693     1  0 12:51 ?        00:00:00 asm_pmon_+ASM3
*/

-- Step 61 -->> On All Nodes
[grid@pdb1/pdb2/pdb3 ~]$ srvctl status scan
/*
SCAN VIP scan1 is enabled
SCAN VIP scan1 is running on node pdb2
SCAN VIP scan2 is enabled
SCAN VIP scan2 is running on node pdb3
SCAN VIP scan3 is enabled
SCAN VIP scan3 is running on node pdb1
*/

-- Step 62 -->> On All Nodes
[grid@pdb1/pdb2/pdb3 ~]$ srvctl config scan
/*
SCAN name: pdb-scan, Network: 1/192.168.16.0/255.255.255.0/eth0
SCAN VIP name: scan1, IP: /pdb-scan/192.168.16.25
SCAN VIP name: scan2, IP: /pdb-scan/192.168.16.26
SCAN VIP name: scan3, IP: /pdb-scan/192.168.16.27
*/

-- Step 63 -->> On All Nodes
[grid@pdb1/pdb2/pdb3 ~]$ srvctl status scan_listener
/*
SCAN Listener LISTENER_SCAN1 is enabled
SCAN listener LISTENER_SCAN1 is running on node pdb2
SCAN Listener LISTENER_SCAN2 is enabled
SCAN listener LISTENER_SCAN2 is running on node pdb3
SCAN Listener LISTENER_SCAN3 is enabled
SCAN listener LISTENER_SCAN3 is running on node pdb1
*/

-- Step 64 -->> On Node 1
[grid@pdb1 ~]$ ps -ef | grep SCAN
/*
grid     11352     1  0 Jun30 ?        00:00:05 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN3 -inherit
grid     22532 22335  0 12:58 pts/0    00:00:00 grep SCAN
*/

-- Step 65 -->> On Node 2
[grid@pdb2 ~]$ ps -ef | grep SCAN
/*
grid     21939 21753  0 12:58 pts/0    00:00:00 grep SCAN
grid     26884     1  0 Jun30 ?        00:00:06 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN1 -inherit
*/

-- Step 66 -->> On Node 3
[grid@pdb3 ~]$ ps -ef | grep SCAN
/*
grid       522     1  0 12:51 ?        00:00:00 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN2 -inherit
grid      1543  1364  0 12:58 pts/0    00:00:00 grep SCAN
*/

-- Step 67 -->> On Node 1 and 2
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 68 -->> On Node 1 and 2
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

-- Step 69 -->> On Node 1
[root@pdb1 ~]# su - oracle
[oracle@pdb1 ~]$ cd /opt/app/oracle/product/11.2.0.3.0/db_1/oui/bin/

-- Step 69.1 -->> On Node 1
[oracle@pdb1 ~]$ export IGNORE_PREADDNODE_CHECKS=Y
[oracle@pdb1 ~]$ ./addNode.sh "CLUSTER_NEW_NODES={pdb3}"
/*
Starting Oracle Universal Installer...

Checking swap space: must be greater than 500 MB.   Actual 20479 MB    Passed
Oracle Universal Installer, Version 11.2.0.3.0 Production
Copyright (C) 1999, 2011, Oracle. All rights reserved.


Performing tests to see whether nodes pdb2,pdb3 are available
............................................................... 100% Done.

.
-----------------------------------------------------------------------------
Cluster Node Addition Summary
Global Settings
   Source: /opt/app/oracle/product/11.2.0.3.0/db_1
   New Nodes
Space Requirements
   New Nodes
      pdb3
         /opt: Required 6.83GB : Available 48.61GB
Installed Products
   Product Names
      Oracle Database 11g 11.2.0.3.0
      Sun JDK 1.5.0.30.03
      Installer SDK Component 11.2.0.3.0
      Oracle One-Off Patch Installer 11.2.0.1.7
      Oracle Universal Installer 11.2.0.3.0
      Oracle USM Deconfiguration 11.2.0.3.0
      Oracle Configuration Manager Deconfiguration 10.3.1.0.0
      Oracle DBCA Deconfiguration 11.2.0.3.0
      Oracle RAC Deconfiguration 11.2.0.3.0
      Oracle Database Deconfiguration 11.2.0.3.0
      Oracle Configuration Manager Client 10.3.2.1.0
      Oracle Configuration Manager 10.3.5.0.1
      Oracle ODBC Driverfor Instant Client 11.2.0.3.0
      LDAP Required Support Files 11.2.0.3.0
      SSL Required Support Files for InstantClient 11.2.0.3.0
      Bali Share 1.1.18.0.0
      Oracle Extended Windowing Toolkit 3.4.47.0.0
      Oracle JFC Extended Windowing Toolkit 4.2.36.0.0
      Oracle Real Application Testing 11.2.0.3.0
      Oracle Database Vault J2EE Application 11.2.0.3.0
      Oracle Label Security 11.2.0.3.0
      Oracle Data Mining RDBMS Files 11.2.0.3.0
      Oracle OLAP RDBMS Files 11.2.0.3.0
      Oracle OLAP API 11.2.0.3.0
      Platform Required Support Files 11.2.0.3.0
      Oracle Database Vault option 11.2.0.3.0
      Oracle RAC Required Support Files-HAS 11.2.0.3.0
      SQL*Plus Required Support Files 11.2.0.3.0
      Oracle Display Fonts 9.0.2.0.0
      Oracle Ice Browser 5.2.3.6.0
      Oracle JDBC Server Support Package 11.2.0.3.0
      Oracle SQL Developer 11.2.0.3.0
      Oracle Application Express 11.2.0.3.0
      XDK Required Support Files 11.2.0.3.0
      RDBMS Required Support Files for Instant Client 11.2.0.3.0
      SQLJ Runtime 11.2.0.3.0
      Database Workspace Manager 11.2.0.3.0
      RDBMS Required Support Files Runtime 11.2.0.3.0
      Oracle Globalization Support 11.2.0.3.0
      Exadata Storage Server 11.2.0.1.0
      Provisioning Advisor Framework 10.2.0.4.3
      Enterprise Manager Database Plugin -- Repository Support 11.2.0.3.0
      Enterprise Manager Repository Core Files 10.2.0.4.4
      Enterprise Manager Database Plugin -- Agent Support 11.2.0.3.0
      Enterprise Manager Grid Control Core Files 10.2.0.4.4
      Enterprise Manager Common Core Files 10.2.0.4.4
      Enterprise Manager Agent Core Files 10.2.0.4.4
      RDBMS Required Support Files 11.2.0.3.0
      regexp 2.1.9.0.0
      Agent Required Support Files 10.2.0.4.3
      Oracle 11g Warehouse Builder Required Files 11.2.0.3.0
      Oracle Notification Service (eONS) 11.2.0.3.0
      Oracle Text Required Support Files 11.2.0.3.0
      Parser Generator Required Support Files 11.2.0.3.0
      Oracle Database 11g Multimedia Files 11.2.0.3.0
      Oracle Multimedia Java Advanced Imaging 11.2.0.3.0
      Oracle Multimedia Annotator 11.2.0.3.0
      Oracle JDBC/OCI Instant Client 11.2.0.3.0
      Oracle Multimedia Locator RDBMS Files 11.2.0.3.0
      Precompiler Required Support Files 11.2.0.3.0
      Oracle Core Required Support Files 11.2.0.3.0
      Sample Schema Data 11.2.0.3.0
      Oracle Starter Database 11.2.0.3.0
      Oracle Message Gateway Common Files 11.2.0.3.0
      Oracle XML Query 11.2.0.3.0
      XML Parser for Oracle JVM 11.2.0.3.0
      Oracle Help For Java 4.2.9.0.0
      Installation Plugin Files 11.2.0.3.0
      Enterprise Manager Common Files 10.2.0.4.3
      Expat libraries 2.0.1.0.1
      Deinstallation Tool 11.2.0.3.0
      Oracle Quality of Service Management (Client) 11.2.0.3.0
      Perl Modules 5.10.0.0.1
      JAccelerator (COMPANION) 11.2.0.3.0
      Oracle Containers for Java 11.2.0.3.0
      Perl Interpreter 5.10.0.0.2
      Oracle Net Required Support Files 11.2.0.3.0
      Secure Socket Layer 11.2.0.3.0
      Oracle Universal Connection Pool 11.2.0.3.0
      Oracle JDBC/THIN Interfaces 11.2.0.3.0
      Oracle Multimedia Client Option 11.2.0.3.0
      Oracle Java Client 11.2.0.3.0
      Character Set Migration Utility 11.2.0.3.0
      Oracle Code Editor 1.2.1.0.0I
      PL/SQL Embedded Gateway 11.2.0.3.0
      OLAP SQL Scripts 11.2.0.3.0
      Database SQL Scripts 11.2.0.3.0
      Oracle Locale Builder 11.2.0.3.0
      Oracle Globalization Support 11.2.0.3.0
      SQL*Plus Files for Instant Client 11.2.0.3.0
      Required Support Files 11.2.0.3.0
      Oracle Database User Interface 2.2.13.0.0
      Oracle ODBC Driver 11.2.0.3.0
      Oracle Notification Service 11.2.0.3.0
      XML Parser for Java 11.2.0.3.0
      Oracle Security Developer Tools 11.2.0.3.0
      Oracle Wallet Manager 11.2.0.3.0
      Cluster Verification Utility Common Files 11.2.0.3.0
      Oracle Clusterware RDBMS Files 11.2.0.3.0
      Oracle UIX 2.2.24.6.0
      Enterprise Manager plugin Common Files 11.2.0.3.0
      HAS Common Files 11.2.0.3.0
      Precompiler Common Files 11.2.0.3.0
      Installation Common Files 11.2.0.3.0
      Oracle Help for the  Web 2.0.14.0.0
      Oracle LDAP administration 11.2.0.3.0
      Buildtools Common Files 11.2.0.3.0
      Assistant Common Files 11.2.0.3.0
      Oracle Recovery Manager 11.2.0.3.0
      PL/SQL 11.2.0.3.0
      Generic Connectivity Common Files 11.2.0.3.0
      Oracle Database Gateway for ODBC 11.2.0.3.0
      Oracle Programmer 11.2.0.3.0
      Oracle Database Utilities 11.2.0.3.0
      Enterprise Manager Agent 10.2.0.4.3
      SQL*Plus 11.2.0.3.0
      Oracle Netca Client 11.2.0.3.0
      Oracle Multimedia Locator 11.2.0.3.0
      Oracle Call Interface (OCI) 11.2.0.3.0
      Oracle Multimedia 11.2.0.3.0
      Oracle Net 11.2.0.3.0
      Oracle XML Development Kit 11.2.0.3.0
      Database Configuration and Upgrade Assistants 11.2.0.3.0
      Oracle JVM 11.2.0.3.0
      Oracle Advanced Security 11.2.0.3.0
      Oracle Internet Directory Client 11.2.0.3.0
      Oracle Enterprise Manager Console DB 11.2.0.3.0
      HAS Files for DB 11.2.0.3.0
      Oracle Net Listener 11.2.0.3.0
      Oracle Text 11.2.0.3.0
      Oracle Net Services 11.2.0.3.0
      Oracle Database 11g 11.2.0.3.0
      Oracle OLAP 11.2.0.3.0
      Oracle Spatial 11.2.0.3.0
      Oracle Partitioning 11.2.0.3.0
      Enterprise Edition Options 11.2.0.3.0
-----------------------------------------------------------------------------


Instantiating scripts for add node (Thursday, July 3, 2025 1:01:15 PM NPT)
.                                                                 1% Done.
Instantiation of add node scripts complete

Copying to remote nodes (Thursday, July 3, 2025 1:01:17 PM NPT)
...............................................................................................                                 96% Done.
Home copied to new nodes

Saving inventory on nodes (Thursday, July 3, 2025 1:08:45 PM NPT)
.                                                               100% Done.
Save inventory complete
WARNING:
The following configuration scripts need to be executed as the "root" user in each new cluster node. Each script in the list below is followed by a list of nodes.
/opt/app/oracle/product/11.2.0.3.0/db_1/root.sh #On nodes pdb3
To execute the configuration scripts:
    1. Open a terminal window
    2. Log in as "root"
    3. Run the scripts in each cluster node

The Cluster Node Addition of /opt/app/oracle/product/11.2.0.3.0/db_1 was successful.
Please check '/tmp/silentInstall.log' for more details.
*/

-- Step 69.2 -->> On Node 3
[root@pdb3 ~]# /opt/app/oracle/product/11.2.0.3.0/db_1/root.sh
/*
Check /opt/app/oracle/product/11.2.0.3.0/db_1/install/root_pdb3.unidev.org.np_2025-07-03_13-15-06.log for the output of root script
*/

-- Step 69.3 -->> On Node 3
[root@pdb3 ~]# tail -f /opt/app/oracle/product/11.2.0.3.0/db_1/install/root_pdb3.unidev.org.np_2025-07-03_13-15-06.log
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

-- Step 69.4 -->> On Node 3
[root@pdb3 ~]# /opt/app/11.2.0.3.0/grid/crs/install/rootcrs.pl
/*
Using configuration parameter file: /opt/app/11.2.0.3.0/grid/crs/install/crsconfig_params
User ignored Prerequisites during installation
Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 70 -->> On Node 1
[grid@pdb1 ~]$ which cluvfy
/*
/opt/app/11.2.0.3.0/grid/bin/cluvfy
*/

-- Step 70.1 -->> On Node 1
[grid@pdb1 ~]$ cd /opt/app/11.2.0.3.0/grid/bin/
[grid@pdb1 bin]$ cluvfy stage -post nodeadd -n pdb3 -verbose
/*
Performing post-checks for node addition

Checking node reachability...

Check: Node reachability from node "pdb1"
  Destination Node                      Reachable?
  ------------------------------------  ------------------------
  pdb3                                  yes
Result: Node reachability check passed from node "pdb1"


Checking user equivalence...

Check: User equivalence for user "grid"
  Node Name                             Status
  ------------------------------------  ------------------------
  pdb3                                  passed
Result: User equivalence check passed for user "grid"

Checking node connectivity...

Checking hosts config file...
  Node Name                             Status
  ------------------------------------  ------------------------
  pdb3                                  passed
  pdb2                                  passed
  pdb1                                  passed

Verification of the hosts config file successful


Interface information for node "pdb3"
 Name   IP Address      Subnet          Gateway         Def. Gateway    HW Address        MTU
 ------ --------------- --------------- --------------- --------------- ----------------- ------
 eth0   192.168.16.28     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:57:2D:AF 1500
 eth0   192.168.16.26     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:57:2D:AF 1500
 eth0   192.168.16.29     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:57:2D:AF 1500
 eth1   10.10.10.28     10.10.10.0      0.0.0.0         192.168.16.1      00:0C:29:57:2D:B9 1500
 eth1   169.254.216.90  169.254.0.0     0.0.0.0         192.168.16.1      00:0C:29:57:2D:B9 1500


Interface information for node "pdb2"
 Name   IP Address      Subnet          Gateway         Def. Gateway    HW Address        MTU
 ------ --------------- --------------- --------------- --------------- ----------------- ------
 eth0   192.168.16.22     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:64:B4:57 1500
 eth0   192.168.16.24     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:64:B4:57 1500
 eth0   192.168.16.25     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:64:B4:57 1500
 eth1   10.10.10.22     10.10.10.0      0.0.0.0         192.168.16.1      00:0C:29:64:B4:61 1500
 eth1   169.254.244.202 169.254.0.0     0.0.0.0         192.168.16.1      00:0C:29:64:B4:61 1500


Interface information for node "pdb1"
 Name   IP Address      Subnet          Gateway         Def. Gateway    HW Address        MTU
 ------ --------------- --------------- --------------- --------------- ----------------- ------
 eth0   192.168.16.21     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:F4:BC:32 1500
 eth0   192.168.16.27     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:F4:BC:32 1500
 eth0   192.168.16.23     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:F4:BC:32 1500
 eth1   10.10.10.21     10.10.10.0      0.0.0.0         192.168.16.1      00:0C:29:F4:BC:3C 1500
 eth1   169.254.78.91   169.254.0.0     0.0.0.0         192.168.16.1      00:0C:29:F4:BC:3C 1500


Check: Node connectivity for interface "eth0"
  Source                          Destination                     Connected?
  ------------------------------  ------------------------------  ----------------
  pdb3[192.168.16.28]               pdb3[192.168.16.26]               yes
  pdb3[192.168.16.28]               pdb3[192.168.16.29]               yes
  pdb3[192.168.16.28]               pdb2[192.168.16.22]               yes
  pdb3[192.168.16.28]               pdb2[192.168.16.24]               yes
  pdb3[192.168.16.28]               pdb2[192.168.16.25]               yes
  pdb3[192.168.16.28]               pdb1[192.168.16.21]               yes
  pdb3[192.168.16.28]               pdb1[192.168.16.27]               yes
  pdb3[192.168.16.28]               pdb1[192.168.16.23]               yes
  pdb3[192.168.16.26]               pdb3[192.168.16.29]               yes
  pdb3[192.168.16.26]               pdb2[192.168.16.22]               yes
  pdb3[192.168.16.26]               pdb2[192.168.16.24]               yes
  pdb3[192.168.16.26]               pdb2[192.168.16.25]               yes
  pdb3[192.168.16.26]               pdb1[192.168.16.21]               yes
  pdb3[192.168.16.26]               pdb1[192.168.16.27]               yes
  pdb3[192.168.16.26]               pdb1[192.168.16.23]               yes
  pdb3[192.168.16.29]               pdb2[192.168.16.22]               yes
  pdb3[192.168.16.29]               pdb2[192.168.16.24]               yes
  pdb3[192.168.16.29]               pdb2[192.168.16.25]               yes
  pdb3[192.168.16.29]               pdb1[192.168.16.21]               yes
  pdb3[192.168.16.29]               pdb1[192.168.16.27]               yes
  pdb3[192.168.16.29]               pdb1[192.168.16.23]               yes
  pdb2[192.168.16.22]               pdb2[192.168.16.24]               yes
  pdb2[192.168.16.22]               pdb2[192.168.16.25]               yes
  pdb2[192.168.16.22]               pdb1[192.168.16.21]               yes
  pdb2[192.168.16.22]               pdb1[192.168.16.27]               yes
  pdb2[192.168.16.22]               pdb1[192.168.16.23]               yes
  pdb2[192.168.16.24]               pdb2[192.168.16.25]               yes
  pdb2[192.168.16.24]               pdb1[192.168.16.21]               yes
  pdb2[192.168.16.24]               pdb1[192.168.16.27]               yes
  pdb2[192.168.16.24]               pdb1[192.168.16.23]               yes
  pdb2[192.168.16.25]               pdb1[192.168.16.21]               yes
  pdb2[192.168.16.25]               pdb1[192.168.16.27]               yes
  pdb2[192.168.16.25]               pdb1[192.168.16.23]               yes
  pdb1[192.168.16.21]               pdb1[192.168.16.27]               yes
  pdb1[192.168.16.21]               pdb1[192.168.16.23]               yes
  pdb1[192.168.16.27]               pdb1[192.168.16.23]               yes
Result: Node connectivity passed for interface "eth0"


Check: TCP connectivity of subnet "192.168.16.0"
  Source                          Destination                     Connected?
  ------------------------------  ------------------------------  ----------------
  pdb1:192.168.16.21                pdb3:192.168.16.28                passed
  pdb1:192.168.16.21                pdb3:192.168.16.26                passed
  pdb1:192.168.16.21                pdb3:192.168.16.29                passed
  pdb1:192.168.16.21                pdb2:192.168.16.22                passed
  pdb1:192.168.16.21                pdb2:192.168.16.24                passed
  pdb1:192.168.16.21                pdb2:192.168.16.25                passed
  pdb1:192.168.16.21                pdb1:192.168.16.27                passed
  pdb1:192.168.16.21                pdb1:192.168.16.23                passed
Result: TCP connectivity check passed for subnet "192.168.16.0"

Checking subnet mask consistency...
Subnet mask consistency check passed for subnet "192.168.16.0".
Subnet mask consistency check passed.

Result: Node connectivity check passed

Checking multicast communication...

Checking subnet "192.168.16.0" for multicast communication with multicast group "230.0.1.0"...
Check of subnet "192.168.16.0" for multicast communication with multicast group "230.0.1.0" passed.

Check of multicast communication passed.

Checking cluster integrity...

  Node Name
  ------------------------------------
  pdb1
  pdb2
  pdb3

Cluster integrity check passed


Checking CRS integrity...

Clusterware version consistency passed
The Oracle Clusterware is healthy on node "pdb3"
The Oracle Clusterware is healthy on node "pdb2"
The Oracle Clusterware is healthy on node "pdb1"

CRS integrity check passed

Checking shared resources...

Checking CRS home location...
"/opt/app/11.2.0.3.0/grid" is not shared
Result: Shared resources check for node addition passed


Checking node connectivity...

Checking hosts config file...
  Node Name                             Status
  ------------------------------------  ------------------------
  pdb3                                  passed
  pdb2                                  passed
  pdb1                                  passed

Verification of the hosts config file successful


Interface information for node "pdb3"
 Name   IP Address      Subnet          Gateway         Def. Gateway    HW Address        MTU
 ------ --------------- --------------- --------------- --------------- ----------------- ------
 eth0   192.168.16.28     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:57:2D:AF 1500
 eth0   192.168.16.26     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:57:2D:AF 1500
 eth0   192.168.16.29     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:57:2D:AF 1500
 eth1   10.10.10.28     10.10.10.0      0.0.0.0         192.168.16.1      00:0C:29:57:2D:B9 1500
 eth1   169.254.216.90  169.254.0.0     0.0.0.0         192.168.16.1      00:0C:29:57:2D:B9 1500


Interface information for node "pdb2"
 Name   IP Address      Subnet          Gateway         Def. Gateway    HW Address        MTU
 ------ --------------- --------------- --------------- --------------- ----------------- ------
 eth0   192.168.16.22     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:64:B4:57 1500
 eth0   192.168.16.24     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:64:B4:57 1500
 eth0   192.168.16.25     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:64:B4:57 1500
 eth1   10.10.10.22     10.10.10.0      0.0.0.0         192.168.16.1      00:0C:29:64:B4:61 1500
 eth1   169.254.244.202 169.254.0.0     0.0.0.0         192.168.16.1      00:0C:29:64:B4:61 1500


Interface information for node "pdb1"
 Name   IP Address      Subnet          Gateway         Def. Gateway    HW Address        MTU
 ------ --------------- --------------- --------------- --------------- ----------------- ------
 eth0   192.168.16.21     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:F4:BC:32 1500
 eth0   192.168.16.27     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:F4:BC:32 1500
 eth0   192.168.16.23     192.168.16.0      0.0.0.0         192.168.16.1      00:0C:29:F4:BC:32 1500
 eth1   10.10.10.21     10.10.10.0      0.0.0.0         192.168.16.1      00:0C:29:F4:BC:3C 1500
 eth1   169.254.78.91   169.254.0.0     0.0.0.0         192.168.16.1      00:0C:29:F4:BC:3C 1500


Check: Node connectivity for interface "eth0"
  Source                          Destination                     Connected?
  ------------------------------  ------------------------------  ----------------
  pdb3[192.168.16.28]               pdb3[192.168.16.26]               yes
  pdb3[192.168.16.28]               pdb3[192.168.16.29]               yes
  pdb3[192.168.16.28]               pdb2[192.168.16.22]               yes
  pdb3[192.168.16.28]               pdb2[192.168.16.24]               yes
  pdb3[192.168.16.28]               pdb2[192.168.16.25]               yes
  pdb3[192.168.16.28]               pdb1[192.168.16.21]               yes
  pdb3[192.168.16.28]               pdb1[192.168.16.27]               yes
  pdb3[192.168.16.28]               pdb1[192.168.16.23]               yes
  pdb3[192.168.16.26]               pdb3[192.168.16.29]               yes
  pdb3[192.168.16.26]               pdb2[192.168.16.22]               yes
  pdb3[192.168.16.26]               pdb2[192.168.16.24]               yes
  pdb3[192.168.16.26]               pdb2[192.168.16.25]               yes
  pdb3[192.168.16.26]               pdb1[192.168.16.21]               yes
  pdb3[192.168.16.26]               pdb1[192.168.16.27]               yes
  pdb3[192.168.16.26]               pdb1[192.168.16.23]               yes
  pdb3[192.168.16.29]               pdb2[192.168.16.22]               yes
  pdb3[192.168.16.29]               pdb2[192.168.16.24]               yes
  pdb3[192.168.16.29]               pdb2[192.168.16.25]               yes
  pdb3[192.168.16.29]               pdb1[192.168.16.21]               yes
  pdb3[192.168.16.29]               pdb1[192.168.16.27]               yes
  pdb3[192.168.16.29]               pdb1[192.168.16.23]               yes
  pdb2[192.168.16.22]               pdb2[192.168.16.24]               yes
  pdb2[192.168.16.22]               pdb2[192.168.16.25]               yes
  pdb2[192.168.16.22]               pdb1[192.168.16.21]               yes
  pdb2[192.168.16.22]               pdb1[192.168.16.27]               yes
  pdb2[192.168.16.22]               pdb1[192.168.16.23]               yes
  pdb2[192.168.16.24]               pdb2[192.168.16.25]               yes
  pdb2[192.168.16.24]               pdb1[192.168.16.21]               yes
  pdb2[192.168.16.24]               pdb1[192.168.16.27]               yes
  pdb2[192.168.16.24]               pdb1[192.168.16.23]               yes
  pdb2[192.168.16.25]               pdb1[192.168.16.21]               yes
  pdb2[192.168.16.25]               pdb1[192.168.16.27]               yes
  pdb2[192.168.16.25]               pdb1[192.168.16.23]               yes
  pdb1[192.168.16.21]               pdb1[192.168.16.27]               yes
  pdb1[192.168.16.21]               pdb1[192.168.16.23]               yes
  pdb1[192.168.16.27]               pdb1[192.168.16.23]               yes
Result: Node connectivity passed for interface "eth0"


Check: TCP connectivity of subnet "192.168.16.0"
  Source                          Destination                     Connected?
  ------------------------------  ------------------------------  ----------------
  pdb1:192.168.16.21                pdb3:192.168.16.28                passed
  pdb1:192.168.16.21                pdb3:192.168.16.26                passed
  pdb1:192.168.16.21                pdb3:192.168.16.29                passed
  pdb1:192.168.16.21                pdb2:192.168.16.22                passed
  pdb1:192.168.16.21                pdb2:192.168.16.24                passed
  pdb1:192.168.16.21                pdb2:192.168.16.25                passed
  pdb1:192.168.16.21                pdb1:192.168.16.27                passed
  pdb1:192.168.16.21                pdb1:192.168.16.23                passed
Result: TCP connectivity check passed for subnet "192.168.16.0"


Check: Node connectivity for interface "eth1"
  Source                          Destination                     Connected?
  ------------------------------  ------------------------------  ----------------
  pdb3[10.10.10.28]               pdb2[10.10.10.22]               yes
  pdb3[10.10.10.28]               pdb1[10.10.10.21]               yes
  pdb2[10.10.10.22]               pdb1[10.10.10.21]               yes
Result: Node connectivity passed for interface "eth1"


Check: TCP connectivity of subnet "10.10.10.0"
  Source                          Destination                     Connected?
  ------------------------------  ------------------------------  ----------------
  pdb1:10.10.10.21                pdb3:10.10.10.28                passed
  pdb1:10.10.10.21                pdb2:10.10.10.22                passed
Result: TCP connectivity check passed for subnet "10.10.10.0"

Checking subnet mask consistency...
Subnet mask consistency check passed for subnet "192.168.16.0".
Subnet mask consistency check passed for subnet "10.10.10.0".
Subnet mask consistency check passed.

Result: Node connectivity check passed

Checking multicast communication...

Checking subnet "192.168.16.0" for multicast communication with multicast group "230.0.1.0"...
Check of subnet "192.168.16.0" for multicast communication with multicast group "230.0.1.0" passed.

Checking subnet "10.10.10.0" for multicast communication with multicast group "230.0.1.0"...
Check of subnet "10.10.10.0" for multicast communication with multicast group "230.0.1.0" passed.

Check of multicast communication passed.

Checking node application existence...

Checking existence of VIP node application (required)
  Node Name     Required                  Running?                  Comment
  ------------  ------------------------  ------------------------  ----------
  pdb3          yes                       yes                       passed
  pdb2          yes                       yes                       passed
  pdb1          yes                       yes                       passed
VIP node application check passed

Checking existence of NETWORK node application (required)
  Node Name     Required                  Running?                  Comment
  ------------  ------------------------  ------------------------  ----------
  pdb3          yes                       yes                       passed
  pdb2          yes                       yes                       passed
  pdb1          yes                       yes                       passed
NETWORK node application check passed

Checking existence of GSD node application (optional)
  Node Name     Required                  Running?                  Comment
  ------------  ------------------------  ------------------------  ----------
  pdb3          no                        no                        exists
  pdb2          no                        no                        exists
  pdb1          no                        no                        exists
GSD node application is offline on nodes "pdb3,pdb2,pdb1"

Checking existence of ONS node application (optional)
  Node Name     Required                  Running?                  Comment
  ------------  ------------------------  ------------------------  ----------
  pdb3          no                        yes                       passed
  pdb2          no                        yes                       passed
  pdb1          no                        yes                       passed
ONS node application check passed


Checking Single Client Access Name (SCAN)...
  SCAN Name         Node          Running?      ListenerName  Port          Running?
  ----------------  ------------  ------------  ------------  ------------  ------------
  pdb-scan          pdb2          true          LISTENER_SCAN1  1521          true
  pdb-scan          pdb3          true          LISTENER_SCAN2  1521          true
  pdb-scan          pdb1          true          LISTENER_SCAN3  1521          true

Checking TCP connectivity to SCAN Listeners...
  Node          ListenerName              TCP connectivity?
  ------------  ------------------------  ------------------------
  pdb1          LISTENER_SCAN1            yes
  pdb1          LISTENER_SCAN2            yes
  pdb1          LISTENER_SCAN3            yes
TCP connectivity to SCAN Listeners exists on all cluster nodes

Checking name resolution setup for "pdb-scan"...
  SCAN Name     IP Address                Status                    Comment
  ------------  ------------------------  ------------------------  ----------
  pdb-scan      192.168.16.27               passed
  pdb-scan      192.168.16.26               passed
  pdb-scan      192.168.16.25               passed

Verification of SCAN VIP and Listener setup passed

Checking to make sure user "grid" is not in "root" group
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdb3          passed                    does not exist
Result: User "grid" is not part of "root" group. Check passed

Checking if Clusterware is installed on all nodes...
Check of Clusterware install passed

Checking if CTSS Resource is running on all nodes...
Check: CTSS Resource running on all nodes
  Node Name                             Status
  ------------------------------------  ------------------------
  pdb3                                  passed
Result: CTSS resource check passed


Querying CTSS for time offset on all nodes...
Result: Query of CTSS for time offset passed

Check CTSS state started...
Check: CTSS state
  Node Name                             State
  ------------------------------------  ------------------------
  pdb3                                  Active
CTSS is in Active state. Proceeding with check of clock time offsets on all nodes...
Reference Time Offset Limit: 1000.0 msecs
Check: Reference Time Offset
  Node Name     Time Offset               Status
  ------------  ------------------------  ------------------------
  pdb3          0.0                       passed

Time offset is within the specified limits on the following set of nodes:
"[pdb3]"
Result: Check of clock time offsets passed


Oracle Cluster Time Synchronization Services check passed

Post-check for node addition was successful.
*/


-- Step 70.2 -->> On Node 3
[root@pdb3 ~]# su - oracle
[oracle@pdb3 ~]$ sqlplus -v
/*
SQL*Plus: Release 11.2.0.3.0 Production
*/

-- Step 71 -->> On Node 1
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Fri Jul 4 11:27:13 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options


-- Step 71.1.1 -->> On Node 1
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE

-- Step 71.1.2 -->> On Node 1
SQL> show parameter undo_tablespace

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
undo_tablespace                      string      UNDOTBS1

-- Step 71.1.3 -->> On Node 1
SQL> show parameter instance_number

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
instance_number                      integer     1

-- Step 71.1.4 -->> On Node 1
SQL> show parameter instance_name

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
instance_name                        string      pdbdb1

-- Step 71.1.5 -->> On Node 1
SQL>  show parameter thread

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
parallel_threads_per_cpu             integer     2
thread                               integer     1


-- Step 71.1.6 -->> On Node 1
SQL> alter system set undo_tablespace=UNDOTBS3 sid='pdbdb3' scope=spfile;
SQL> alter system set instance_number=3 sid='pdbdb3' scope=spfile;
SQL> alter system set instance_name='pdbdb3' sid='pdbdb3' scope=spfile;
SQL> alter system set thread=3 sid='pdbdb3' scope=spfile;

-- Step 71.1.7 -->> On Node 1
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

-- Step 71.1.8 -->> On Node 1
SQL> col member for a50
SQL> SELECT * FROM v$logfile a ORDER BY a.type,a.group#;

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

-- Step 71.1.9 -->> On Node 1
SQL> ALTER DATABASE ADD LOGFILE THREAD 3 GROUP 15 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD LOGFILE THREAD 3 GROUP 16 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD LOGFILE THREAD 3 GROUP 17 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ENABLE PUBLIC THREAD 3;
--SQL> ALTER DATABASE ENABLE THREAD 3;
SQL> ALTER DATABASE ADD STANDBY LOGFILE THREAD 3 GROUP 18 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD STANDBY LOGFILE THREAD 3 GROUP 19 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD STANDBY LOGFILE THREAD 3 GROUP 20 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD STANDBY LOGFILE THREAD 3 GROUP 21 ('+DATA' ,'+DATA') SIZE 50M;


-- Step 71.1.10 -->> On Node 1
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

-- Step 71.1.11 -->> On Node 1
SQL> SELECT * FROM v$logfile a ORDER BY a.type,a.group#;

    GROUP# STATUS  TYPE    MEMBER                                             IS_
---------- ------- ------- -------------------------------------------------- ---
         1         ONLINE  +DATA/pdbdb/onlinelog/group_1.269.1205148391       NO
         1         ONLINE  +DATA/pdbdb/onlinelog/group_1.268.1205148389       NO
         2         ONLINE  +DATA/pdbdb/onlinelog/group_2.271.1205148391       NO
         2         ONLINE  +DATA/pdbdb/onlinelog/group_2.270.1205148391       NO
         3         ONLINE  +DATA/pdbdb/onlinelog/group_3.272.1205148391       NO
         3         ONLINE  +DATA/pdbdb/onlinelog/group_3.273.1205148391       NO
         4         ONLINE  +DATA/pdbdb/onlinelog/group_4.275.1205148393       NO
         4         ONLINE  +DATA/pdbdb/onlinelog/group_4.274.1205148393       NO
         5         ONLINE  +DATA/pdbdb/onlinelog/group_5.277.1205148393       NO
         5         ONLINE  +DATA/pdbdb/onlinelog/group_5.276.1205148393       NO
         6         ONLINE  +DATA/pdbdb/onlinelog/group_6.278.1205148393       NO
         6         ONLINE  +DATA/pdbdb/onlinelog/group_6.279.1205148393       NO
        15         ONLINE  +DATA/pdbdb/onlinelog/group_15.321.1205580633      NO
        15         ONLINE  +DATA/pdbdb/onlinelog/group_15.296.1205580633      NO
        16         ONLINE  +DATA/pdbdb/onlinelog/group_16.326.1205580641      NO
        16         ONLINE  +DATA/pdbdb/onlinelog/group_16.292.1205580643      NO
        17         ONLINE  +DATA/pdbdb/onlinelog/group_17.338.1205580649      NO
        17         ONLINE  +DATA/pdbdb/onlinelog/group_17.330.1205580649      NO
         7         STANDBY +DATA/pdbdb/onlinelog/group_7.266.1205149301       NO
         7         STANDBY +DATA/pdbdb/onlinelog/group_7.265.1205149301       NO
         8         STANDBY +DATA/pdbdb/onlinelog/group_8.261.1205149303       NO
         8         STANDBY +DATA/pdbdb/onlinelog/group_8.262.1205149301       NO
         9         STANDBY +DATA/pdbdb/onlinelog/group_9.280.1205149303       NO
         9         STANDBY +DATA/pdbdb/onlinelog/group_9.281.1205149303       NO
        10         STANDBY +DATA/pdbdb/onlinelog/group_10.283.1205149303      NO
        10         STANDBY +DATA/pdbdb/onlinelog/group_10.282.1205149303      NO
        11         STANDBY +DATA/pdbdb/onlinelog/group_11.285.1205149303      NO
        11         STANDBY +DATA/pdbdb/onlinelog/group_11.284.1205149303      NO
        12         STANDBY +DATA/pdbdb/onlinelog/group_12.287.1205149303      NO
        12         STANDBY +DATA/pdbdb/onlinelog/group_12.286.1205149303      NO
        13         STANDBY +DATA/pdbdb/onlinelog/group_13.289.1205149305      NO
        13         STANDBY +DATA/pdbdb/onlinelog/group_13.288.1205149305      NO
        14         STANDBY +DATA/pdbdb/onlinelog/group_14.290.1205149305      NO
        14         STANDBY +DATA/pdbdb/onlinelog/group_14.291.1205149305      NO
        18         STANDBY +DATA/pdbdb/onlinelog/group_18.325.1205580667      NO
        18         STANDBY +DATA/pdbdb/onlinelog/group_18.339.1205580667      NO
        19         STANDBY +DATA/pdbdb/onlinelog/group_19.298.1205580673      NO
        19         STANDBY +DATA/pdbdb/onlinelog/group_19.344.1205580673      NO
        20         STANDBY +DATA/pdbdb/onlinelog/group_20.304.1205580677      NO
        20         STANDBY +DATA/pdbdb/onlinelog/group_20.299.1205580677      NO
        21         STANDBY +DATA/pdbdb/onlinelog/group_21.336.1205580681      NO
        21         STANDBY +DATA/pdbdb/onlinelog/group_21.333.1205580681      NO

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 72 -->> On Node 1
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 73 -->> On All Nodes
[oracle@pdb1/pdb2/pdb3 ~]$ srvctl config database -d pdbdb
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

-- Step 74 -->> On Node 1
[oracle@pdb1 ~]$ srvctl add instance -d pdbdb -i pdbdb3 -n pdb3

-- Step 75 -->> On All Nodes
[oracle@pdb1/pdb2/pdb3 ~]$ srvctl config database -d pdbdb
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
Database instances: pdbdb1,pdbdb2,pdbdb3
Disk Groups: DATA,ARC
Mount point paths:
Services:
Type: RAC
Database is administrator managed
*/

-- Step 76 -->> On All Nodes
[oracle@pdb1/pdb2/pdb3 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
Instance pdbdb3 is not running on node pdb3
*/

-- Step 77 -->> On Node 3
[root@pdb3 ~]# mkdir -p /opt/app/oracle/admin/pdbdb/adump
[root@pdb3 ~]# cd /opt/app/oracle/admin/
[root@pdb3 admin]# chown -R oracle:oinstall pdbdb/
[root@pdb3 admin]# chmod -R 775 pdbdb/

-- Step 78 -->> On Node 3
[root@pdb3 ~]# vi /etc/oratab
/*
+ASM3:/opt/app/11.2.0.3.0/grid:N                # line added by Agent
pdbdb3:/opt/app/oracle/product/11.2.0.3.0/db_1:N
pdbdb:/opt/app/oracle/product/11.2.0.3.0/db_1:N
*/

-- Step 79 -->> On Node 1
[oracle@pdb1 ~]$ srvctl start instance -i pdbdb3 -d pdbdb

-- Step 80 -->> On All Nodes
[oracle@pdb1/pdb2/pdb3  ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
Instance pdbdb3 is running on node pdb3. Instance status: Open.
*/

-- Step 81 -->> On Node 3
[oracle@pdb3 ~]$ vi /opt/app/oracle/product/11.2.0.3.0/db_1/network/admin/tnsnames.ora
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

PDBDB3 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.16.28)(PORT = 1521))
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

-- Step 81.1 -->> On Node 3
[oracle@pdb3 ~]$ tnsping PDBDB
/*
TNS Ping Utility for Linux: Version 11.2.0.3.0 - Production on 04-JUL-2025 11:41:06

Copyright (c) 1997, 2011, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdb-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = pdbdb)))
OK (0 msec)
*/

-- Step 81.2 -->> On Node 3
[oracle@pdb3 ~]$ tnsping PDBDB3
/*
TNS Ping Utility for Linux: Version 11.2.0.3.0 - Production on 04-JUL-2025 11:41:18

Copyright (c) 1997, 2011, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.16.28)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = pdbdb)))
OK (0 msec)
*/

-- Step 81.4 -->> On Node 3
[oracle@pdb3 ~]$ tnsping DR
/*
TNS Ping Utility for Linux: Version 11.2.0.3.0 - Production on 04-JUL-2025 11:41:33

Copyright (c) 1997, 2011, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = dr)))
OK (0 msec)
*/

-- Step 82 -->> On Node 1
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
Instance pdbdb3 is running on node pdb3. Instance status: Open.
*/

-- Step 83 -->> On Node 1
[oracle@pdb1 ~]$ cd /opt/app/oracle/product/11.2.0.3.0/db_1/dbs/
[oracle@pdb1 dbs]$ scp -r orapwpdbdb1 oracle@pdb3:/opt/app/oracle/product/11.2.0.3.0/db_1/dbs/orapwpdbdb3
/*
orapwpdbdb1                                                100% 1536     1.5KB/s   00:00
*/

-- Step 83.1 -->> On Node 3
[oracle@pdb3 ~]$ cd /opt/app/oracle/product/11.2.0.3.0/db_1/dbs/
[oracle@pdb3 dbs]$ ll
/*
-rw-rw---- 1 oracle oinstall     1544 Jul  3 13:06 hc_pdbdb1.dat
-rw-rw---- 1 oracle asmadmin     1544 Jul  4 11:38 hc_pdbdb3.dat
-rw-r--r-- 1 oracle oinstall     2851 Jul  3 13:06 init.ora
-rw-r----- 1 oracle oinstall       37 Jul  3 13:06 initpdbdb1.ora
-rw-r--r-- 1 oracle oinstall       60 Jul  4 11:38 initpdbdb3.ora
-rw-r----- 1 oracle oinstall     1536 Jul  3 13:06 orapwpdbdb
-rw-r----- 1 oracle oinstall     1536 Jul  3 13:06 orapwpdbdb1
-rw-r----- 1 oracle oinstall     1536 Jul  3 13:18 orapwpdbdb3
-rw-r----- 1 oracle oinstall 18792448 Jul  3 13:06 snapcf_pdbdb1.f
*/

-- Step 83.2 -->> On Node 3
[oracle@pdb3 dbs]$ rm -rf hc_pdbdb1.dat initpdbdb1.ora orapwpdbdb1
[oracle@pdb3 dbs]$ mv snapcf_pdbdb1.f snapcf_pdbdb3.f
[oracle@pdb3 dbs]$ ll
/*
-rw-rw---- 1 oracle asmadmin     1544 Jul  4 11:38 hc_pdbdb3.dat
-rw-r--r-- 1 oracle oinstall     2851 Jul  3 13:06 init.ora
-rw-r--r-- 1 oracle oinstall       60 Jul  4 11:38 initpdbdb3.ora
-rw-r----- 1 oracle oinstall     1536 Jul  3 13:06 orapwpdbdb
-rw-r----- 1 oracle oinstall     1536 Jul  4 11:43 orapwpdbdb3
-rw-r----- 1 oracle oinstall 18792448 Jul  3 13:06 snapcf_pdbdb3.f
*/

-- Step 84 -->> On Node 1 (DR)
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Fri Jul 4 11:49:26 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

-- Step 84.1.1 -->> On Node 1 (DR)
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED

-- Step 84.1.2 -->> On Node 1 (DR)
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

-- Step 84.1.3 -->> On Node 1 (DR)
SQL> col member for a50
SQL> SELECT * FROM v$logfile a ORDER BY a.type,a.group#;

    GROUP# STATUS  TYPE    MEMBER                                             IS_
---------- ------- ------- -------------------------------------------------- ---
         1         ONLINE  +DATA/dr/onlinelog/group_1.263.1205153763          YES
         1         ONLINE  +DATA/dr/onlinelog/group_1.262.1205153763          NO
         2         ONLINE  +DATA/dr/onlinelog/group_2.265.1205153763          YES
         2         ONLINE  +DATA/dr/onlinelog/group_2.264.1205153763          NO
         3         ONLINE  +DATA/dr/onlinelog/group_3.266.1205153763          NO
         3         ONLINE  +DATA/dr/onlinelog/group_3.267.1205153765          YES
         4         ONLINE  +DATA/dr/onlinelog/group_4.269.1205153765          YES
         4         ONLINE  +DATA/dr/onlinelog/group_4.268.1205153765          NO
         5         ONLINE  +DATA/dr/onlinelog/group_5.271.1205153765          YES
         5         ONLINE  +DATA/dr/onlinelog/group_5.270.1205153765          NO
         6         ONLINE  +DATA/dr/onlinelog/group_6.272.1205153765          NO
         6         ONLINE  +DATA/dr/onlinelog/group_6.273.1205153765          YES
        15         ONLINE  +DATA/dr/onlinelog/group_15.332.1205580657         NO
        15         ONLINE  +DATA/dr/onlinelog/group_15.329.1205580657         YES
        16         ONLINE  +DATA/dr/onlinelog/group_16.318.1205580659         NO
        16         ONLINE  +DATA/dr/onlinelog/group_16.308.1205580659         YES
         7         STANDBY +DATA/dr/onlinelog/group_7.274.1205153767          NO
         7         STANDBY +DATA/dr/onlinelog/group_7.275.1205153767          YES
         8         STANDBY +DATA/dr/onlinelog/group_8.277.1205153767          YES
         8         STANDBY +DATA/dr/onlinelog/group_8.276.1205153767          NO
         9         STANDBY +DATA/dr/onlinelog/group_9.279.1205153767          YES
         9         STANDBY +DATA/dr/onlinelog/group_9.278.1205153767          NO
        10         STANDBY +DATA/dr/onlinelog/group_10.280.1205153767         NO
        10         STANDBY +DATA/dr/onlinelog/group_10.281.1205153769         YES
        11         STANDBY +DATA/dr/onlinelog/group_11.283.1205153769         YES
        11         STANDBY +DATA/dr/onlinelog/group_11.282.1205153769         NO
        12         STANDBY +DATA/dr/onlinelog/group_12.285.1205153769         YES
        12         STANDBY +DATA/dr/onlinelog/group_12.284.1205153769         NO
        13         STANDBY +DATA/dr/onlinelog/group_13.286.1205153769         NO
        13         STANDBY +DATA/dr/onlinelog/group_13.287.1205153769         YES
        14         STANDBY +DATA/dr/onlinelog/group_14.288.1205153769         NO
        14         STANDBY +DATA/dr/onlinelog/group_14.289.1205153771         YES

-- Step 84.1.4 -->> On Node 1 (DR)
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
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;

-- Step 84.1.5 -->> On Node 1 (DR)
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

-- Step 84.1.6 -->> On Node 1 (DR)
SQL> SELECT * FROM v$logfile a ORDER BY a.type,a.group#;

    GROUP# STATUS  TYPE    MEMBER                                             IS_
---------- ------- ------- -------------------------------------------------- ---
         1         ONLINE  +DATA/dr/onlinelog/group_1.263.1205153763          YES
         1         ONLINE  +DATA/dr/onlinelog/group_1.262.1205153763          NO
         2         ONLINE  +DATA/dr/onlinelog/group_2.265.1205153763          YES
         2         ONLINE  +DATA/dr/onlinelog/group_2.264.1205153763          NO
         3         ONLINE  +DATA/dr/onlinelog/group_3.266.1205153763          NO
         3         ONLINE  +DATA/dr/onlinelog/group_3.267.1205153765          YES
         4         ONLINE  +DATA/dr/onlinelog/group_4.269.1205153765          YES
         4         ONLINE  +DATA/dr/onlinelog/group_4.268.1205153765          NO
         5         ONLINE  +DATA/dr/onlinelog/group_5.271.1205153765          YES
         5         ONLINE  +DATA/dr/onlinelog/group_5.270.1205153765          NO
         6         ONLINE  +DATA/dr/onlinelog/group_6.272.1205153765          NO
         6         ONLINE  +DATA/dr/onlinelog/group_6.273.1205153765          YES
        15         ONLINE  +DATA/dr/onlinelog/group_15.329.1205580657         YES
        15         ONLINE  +DATA/dr/onlinelog/group_15.332.1205580657         NO
        16         ONLINE  +DATA/dr/onlinelog/group_16.318.1205580659         NO
        16         ONLINE  +DATA/dr/onlinelog/group_16.308.1205580659         YES
        17         ONLINE  +DATA/dr/onlinelog/group_17.314.1205581921         NO
        17         ONLINE  +DATA/dr/onlinelog/group_17.320.1205581919         NO
         7         STANDBY +DATA/dr/onlinelog/group_7.274.1205153767          NO
         7         STANDBY +DATA/dr/onlinelog/group_7.275.1205153767          YES
         8         STANDBY +DATA/dr/onlinelog/group_8.277.1205153767          YES
         8         STANDBY +DATA/dr/onlinelog/group_8.276.1205153767          NO
         9         STANDBY +DATA/dr/onlinelog/group_9.278.1205153767          NO
         9         STANDBY +DATA/dr/onlinelog/group_9.279.1205153767          YES
        10         STANDBY +DATA/dr/onlinelog/group_10.281.1205153769         YES
        10         STANDBY +DATA/dr/onlinelog/group_10.280.1205153767         NO
        11         STANDBY +DATA/dr/onlinelog/group_11.283.1205153769         YES
        11         STANDBY +DATA/dr/onlinelog/group_11.282.1205153769         NO
        12         STANDBY +DATA/dr/onlinelog/group_12.285.1205153769         YES
        12         STANDBY +DATA/dr/onlinelog/group_12.284.1205153769         NO
        13         STANDBY +DATA/dr/onlinelog/group_13.287.1205153769         YES
        13         STANDBY +DATA/dr/onlinelog/group_13.286.1205153769         NO
        14         STANDBY +DATA/dr/onlinelog/group_14.288.1205153769         NO
        14         STANDBY +DATA/dr/onlinelog/group_14.289.1205153771         YES
        18         STANDBY +DATA/dr/onlinelog/group_18.312.1205581929         NO
        18         STANDBY +DATA/dr/onlinelog/group_18.346.1205581929         NO
        19         STANDBY +DATA/dr/onlinelog/group_19.324.1205581935         NO
        19         STANDBY +DATA/dr/onlinelog/group_19.322.1205581935         NO
        20         STANDBY +DATA/dr/onlinelog/group_20.313.1205581941         NO
        20         STANDBY +DATA/dr/onlinelog/group_20.326.1205581941         NO
        21         STANDBY +DATA/dr/onlinelog/group_21.334.1205581945         NO
        21         STANDBY +DATA/dr/onlinelog/group_21.335.1205581945         NO

-- Step 84.1.7 -->> On Node 3 (DC)
SQL> ALTER SYSTEM SET log_archive_dest_state_2 = DEFER SID='*';
SQL> ALTER SYSTEM SET log_archive_dest_state_2 = ENABLE SID='*';
SQL> ALTER SYSTEM SWITCH LOGFILE;
SQL> ALTER SYSTEM ARCHIVE LOG CURRENT;

-- Step 84.1.8 -->> On Node 3 (DC)
[oracle@pdb3 ~]$ srvctl stop instance -d pdbdb -i pdbdb3
[oracle@pdb3 ~]$ srvctl start instance -d pdbdb -i pdbdb3
[oracle@pdb3 ~]$ srvctl status database -d pdbdb -v
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
Instance pdbdb3 is running on node pdb3. Instance status: Open.

-- Step 84.1.9 -->> On Node 1 (DR)
SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           118          1
            97          2
            18          3

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           118          1
            96          2
            18          3

-- Step 84.1.10 -->> On Node 1 (DR)
SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby;

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         1         90 CLOSING               1 ARCH
         2         72 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         1         91 CLOSING               1 ARCH
         2         97 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         2         90 CLOSING               1 ARCH
         2         91 CLOSING               1 ARCH
         3          8 CLOSING               1 ARCH
         2         92 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         3         10 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         3         11 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         2         93 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         2         94 CLOSING               1 ARCH
         2         95 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         2         96 CLOSING               1 ARCH
         2         98 APPLYING_LOG         49 MRP0
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         2         98 IDLE                 51 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         1        106 CLOSING           61440 ARCH
         2         86 CLOSING           61440 ARCH
         0          0 CONNECTED             0 ARCH
         1        107 CLOSING           59392 ARCH
         2         87 CLOSING           59392 ARCH
         1        108 CLOSING           59392 ARCH
         2         88 CLOSING           26624 ARCH
         1        109 CLOSING           16384 ARCH
         1        110 CLOSING            4096 ARCH
         1         94 CLOSING               1 ARCH
         2         89 CLOSING            4096 ARCH
         1        111 CLOSING               1 ARCH
         1        112 CLOSING               1 ARCH
         1        113 CLOSING               1 ARCH
         1        114 CLOSING               1 ARCH
         3         12 CLOSING               1 ARCH
         1        115 CLOSING               1 ARCH
         1        116 CLOSING               1 ARCH
         3         13 CLOSING               1 ARCH
         3         14 CLOSING               1 ARCH
         1        117 CLOSING               1 ARCH
         3         15 CLOSING               1 ARCH
         3         16 CLOSING               1 ARCH
         3         17 CLOSING               1 ARCH
         3         18 CLOSING               1 ARCH
         1        118 CLOSING               1 ARCH
         2         84 CLOSING           59392 ARCH
         1        104 CLOSING           59392 ARCH
         2         85 CLOSING           59392 ARCH
         1        105 CLOSING           59392 ARCH
         0          0 IDLE                  0 RFS
         3         19 IDLE                 53 RFS
         1        119 IDLE                 57 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS

-- Step 84.1.11 -->> On Node 1 (DR)
SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

-- Step 84.1.12 -->> On Node 1 (DR)
SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 85 -->> On Node 1 (DC)
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
Log file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/opatch2025-07-20_11-45-43AM.log

Lsinventory Output file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/lsinv/lsinventory2025-07-20_11-45-43AM.txt

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
  Remote node = pdb3

--------------------------------------------------------------------------------

OPatch succeeded.
*/

-- Step 85.1 -->> On Node 2 (DC)
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
Log file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/opatch2025-07-20_11-46-56AM.log

Lsinventory Output file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/lsinv/lsinventory2025-07-20_11-46-56AM.txt

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
  Remote node = pdb3

--------------------------------------------------------------------------------

OPatch succeeded.
*/

-- Step 85.2 -->> On Node 3 (DC)
[oracle@pdb3 ~]$ /opt/app/oracle/product/11.2.0.3.0/db_1/OPatch/opatch lsinventory
/*
Invoking OPatch 11.2.0.1.7

Oracle Interim Patch Installer version 11.2.0.1.7
Copyright (c) 2011, Oracle Corporation.  All rights reserved.


Oracle Home       : /opt/app/oracle/product/11.2.0.3.0/db_1
Central Inventory : /opt/app/oraInventory
   from           : /etc/oraInst.loc
OPatch version    : 11.2.0.1.7
OUI version       : 11.2.0.3.0
Log file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/opatch2025-07-20_11-43-04AM.log

Lsinventory Output file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/lsinv/lsinventory2025-07-20_11-43-04AM.txt

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
  Local node = pdb3
  Remote node = pdb1
  Remote node = pdb2

--------------------------------------------------------------------------------

OPatch succeeded.
*/

-- Step 85.3 -->> On Node 1 (DR)
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
Log file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/opatch2025-07-23_14-42-48PM.log

Lsinventory Output file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/lsinv/lsinventory2025-07-23_14-42-48PM.txt

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

-- Step 85.4 -->> On Node 2 (DR)
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
Log file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/opatch2025-07-23_14-43-19PM.log

Lsinventory Output file location : /opt/app/oracle/product/11.2.0.3.0/db_1/cfgtoollogs/opatch/lsinv/lsinventory2025-07-23_14-43-19PM.txt

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

-----------------------------------------------------------------------------------------------------------
----------------------Test Cases Start for Node 3 from 3-Node-DC and 2-Node-DR-----------------------------
-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
---------------->> A. Stop Nodes 1 ,2 and Serve from Node 3 on DC side with 2 Node DR----------------------
-----------------------------------------------------------------------------------------------------------
---------------------------------1 Instance DC and 2 Instance DR-------------------------------------------
-----------------------------------------------------------------------------------------------------------

-- Step 1 -- Deploy -->> On Node 3 - (DC)
[oracle@pdb3 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
Instance pdbdb3 is running on node pdb3. Instance status: Open.
*/

-- Step 2 -- Deploy -->> On Node 3 - (DC)
[oracle@pdb3 ~]$ srvctl stop instance -d pdbdb -i pdbdb2
[oracle@pdb3 ~]$ srvctl stop instance -d pdbdb -i pdbdb1
[oracle@pdb3 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is not running on node pdb1
Instance pdbdb2 is not running on node pdb2
Instance pdbdb3 is running on node pdb3. Instance status: Open.
*/

-- Step 3 -- Deploy -->> On Node 3 - (DC)
[oracle@pdb3 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Fri Jul 4 12:12:32 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options


SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         3 OPEN         pdbdb3           PRIMARY          READ WRITE

SQL> alter system switch logfile;

System altered.

SQL> alter system switch logfile;

System altered.

SQL> alter system switch logfile;

System altered.

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           120          1
            99          2
            24          3

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 4 -- Deploy -->> On Node 1 - (DR)
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Fri Jul 4 12:13:14 2025

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


SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           120          1
            99          2
            24          3

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           120          1
            99          2
            23          3

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

Database altered.

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;

Database altered.

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         3         28 APPLYING_LOG         18 MRP0

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           120          1
            99          2
            26          3

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           120          1
            99          2
            27          3

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 5 -- Revert -->> On Node 3 - (DC)
[oracle@pdb3 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is not running on node pdb1
Instance pdbdb2 is not running on node pdb2
Instance pdbdb3 is running on node pdb3. Instance status: Open.
*/

-- Step 6 -- Revert -->> On Node 3 - (DC)
[oracle@pdb3 ~]$ srvctl start instance -d pdbdb -i pdbdb1
[oracle@pdb3 ~]$ srvctl start instance -d pdbdb -i pdbdb2

-- Step 7 -- Revert -->> On All Nodes - (DC)
[oracle@pdb1/pdb2/pdb3 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
Instance pdbdb3 is running on node pdb3. Instance status: Open.
*/

-- Step 8 -- Revert -->> On All Nodes - (DC)
[oracle@pdb1/pdb2/pdb3 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Fri Jul 4 12:12:32 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         3 OPEN         pdbdb3           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE

SQL> alter system switch logfile;

System altered.

SQL> alter system switch logfile;

System altered.

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           125          1
           103          2
            31          3

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 9 -- Revert -->> On Node 1 - (DR)
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Sun Jun 22 13:18:37 2025

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


SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           260          1
           194          2
            65          3

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           124          1
           103          2
            31          3

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

Database altered.

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;

Database altered.

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         3         32 APPLYING_LOG        702 MRP0

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           125          1
           103          2
            31          3

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-----------------------------------------------------------------------------------------------------------
--------------->> B. When Old Cluster DB Server has been Unabilable from OS on DC Side.--------------------
-----------------------------------------------------------------------------------------------------------
------------------------------------1 Node DC and 2 Node DR------------------------------------------------
-----------------------------------------------------------------------------------------------------------

-- Step 1 -- Deploy -->> On Node 1 and Node 2 - (DC)
[root@pdb1/pdb2 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
[root@pdb1/pdb2 bin]# ./crsctl stop crs

-- Step 2 -- Deploy -->> On Node 1 and Node 2 - (DC)
[root@pdb1/pdb2 bin]# init 0

-- Step 3 -- Deploy -->> On Node 3 - (DC)
[root@pdb3 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
[root@pdb3 bin]# ./crsctl stat res -t | grep -A3 -E pdbdb
/*
ora.pdbdb.db
      1        OFFLINE OFFLINE
      2        OFFLINE OFFLINE
      3        ONLINE  ONLINE       pdb3                     Open
*/

-- Step 4 -- Deploy -->> On Node 3 - (DC)
[oracle@pdb3 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is not running on node pdb1
Instance pdbdb2 is not running on node pdb2
Instance pdbdb3 is running on node pdb3. Instance status: Open.
*/

-- Step 5 -- Deploy -->> On Node 3 - (DC)
[oracle@pdb3 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Fri Jul 4 12:23:10 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         3 OPEN         pdbdb3           PRIMARY          READ WRITE

SQL> alter system switch logfile;

System altered.

SQL> alter system switch logfile;

System altered.

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           127          1
           105          2
            36          3

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 6 -- Deploy -->> On Node 1 - (DR)
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Sun Jun 22 14:08:11 2025

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

SQL>  SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           127          1
           105          2
            36          3

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           127          1
           105          2
            35          3

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

Database altered.

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;

Database altered.

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         3         37 APPLYING_LOG        163 MRP0

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           127          1
           105          2
            38          3

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 7 -- Revert -->> On Node 1 and Node 2 - (DC)
-- Push ON for Node 1 and Node 2 - (DC)

-- Step 8 -- Revert -->> On All Nodes - (DC)
[root@pdb1/pdb2/pdb3 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
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

-- Step 9 -- Revert -->> On All Nodes - (DC)
[root@pdb1/pdb2/pdb3 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.ARC.dg
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
               ONLINE  ONLINE       pdb3
ora.DATA.dg
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
               ONLINE  ONLINE       pdb3
ora.LISTENER.lsnr
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
               ONLINE  ONLINE       pdb3
ora.OCR.dg
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
               ONLINE  ONLINE       pdb3
ora.asm
               ONLINE  ONLINE       pdb1                     Started
               ONLINE  ONLINE       pdb2                     Started
               ONLINE  ONLINE       pdb3                     Started
ora.gsd
               OFFLINE OFFLINE      pdb1
               OFFLINE OFFLINE      pdb2
               OFFLINE OFFLINE      pdb3
ora.net1.network
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
               ONLINE  ONLINE       pdb3
ora.ons
               ONLINE  ONLINE       pdb1
               ONLINE  ONLINE       pdb2
               ONLINE  ONLINE       pdb3
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdb1
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdb2
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       pdb3
ora.cvu
      1        ONLINE  ONLINE       pdb3
ora.oc4j
      1        ONLINE  ONLINE       pdb3
ora.pdb1.vip
      1        ONLINE  ONLINE       pdb1
ora.pdb2.vip
      1        ONLINE  ONLINE       pdb2
ora.pdb3.vip
      1        ONLINE  ONLINE       pdb3
ora.pdbdb.db
      1        ONLINE  ONLINE       pdb1                     Open
      2        ONLINE  ONLINE       pdb2                     Open
      3        ONLINE  ONLINE       pdb3                     Open
ora.scan1.vip
      1        ONLINE  ONLINE       pdb1
ora.scan2.vip
      1        ONLINE  ONLINE       pdb2
ora.scan3.vip
      1        ONLINE  ONLINE       pdb3
*/

-- Step 10 -- Revert -->> On All Nodes - (DC)
[root@pdb1/pdb2/pdb3 bin]# ./crsctl stat res -t | grep -A3 -E pdbdb
/*
ora.pdbdb.db
      1        ONLINE  ONLINE       pdb1                     Open
      2        ONLINE  ONLINE       pdb2                     Open
      3        ONLINE  ONLINE       pdb3                     Open
*/

-- Step 11 -- Revert -->> On All Nodes - (DC)
[oracle@pdb1/pdb2/pdb3 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
Instance pdbdb3 is running on node pdb3. Instance status: Open.
*/

-- Step 12 -- Revert -->> On All Nodes - (DC)
[oracle@pdb1/pdb2/pdb3 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Fri Jul 4 12:59:19 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         3 OPEN         pdbdb3           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> alter system switch logfile;

System altered.

SQL> alter system switch logfile;

System altered.

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           131          1
           110          2
            43          3

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 13 -- Revert -->> On Node 1 - (DR)
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Fri Jul 4 13:00:55 2025

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

SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           131          1
           110          2
            43          3

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           131          1
           110          2
            42          3

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

Database altered.

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;

Database altered.

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           133          1
           112          2
            45          3

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           133          1
           111          2
            45          3

SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         2        113 APPLYING_LOG         48 MRP0


SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby ;

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         2        103 CLOSING               1 ARCH
         2         72 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         1         91 CLOSING               1 ARCH
         2         97 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         1        132 CLOSING               1 ARCH
         1        133 CLOSING               1 ARCH
         2         90 CLOSING               1 ARCH
         2         91 CLOSING               1 ARCH
         3          8 CLOSING               1 ARCH
         2         92 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         3         10 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         3         11 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         1        121 CLOSING               1 ARCH
         1        122 CLOSING               1 ARCH
         2        107 CLOSING               1 ARCH
         2        106 CLOSING               1 ARCH
         1        129 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         2        102 CLOSING               1 ARCH
         1        130 CLOSING            4096 ARCH
         0          0 CONNECTED             0 ARCH
         1        131 CLOSING               1 ARCH
         2        113 APPLYING_LOG         69 MRP0
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         1        134 IDLE                 75 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         2        109 CLOSING               1 ARCH
         2        110 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         3         43 CLOSING               1 ARCH
         3         44 CLOSING               1 ARCH
         3         45 CLOSING               1 ARCH
         2        111 CLOSING               1 ARCH
         2        112 CLOSING               1 ARCH
         3         28 CLOSING               1 ARCH
         2        100 CLOSING               1 ARCH
         3         29 CLOSING               1 ARCH
         1        123 CLOSING               1 ARCH
         1        124 CLOSING               1 ARCH
         3         30 CLOSING               1 ARCH
         3         31 CLOSING               1 ARCH
         1        125 CLOSING               1 ARCH
         2        104 CLOSING               1 ARCH
         3         32 CLOSING               1 ARCH
         3         33 CLOSING               1 ARCH
         3         34 CLOSING               1 ARCH
         3         35 CLOSING               1 ARCH
         3         36 CLOSING               1 ARCH
         3         37 CLOSING               1 ARCH
         3         38 CLOSING               1 ARCH
         3         39 CLOSING               1 ARCH
         3         40 CLOSING               1 ARCH
         1        128 CLOSING               1 ARCH
         3         41 CLOSING            4096 ARCH
         3         42 CLOSING               1 ARCH
         2        108 CLOSING            4096 ARCH
         0          0 IDLE                  0 RFS
         3         46 IDLE                 77 RFS
         0          0 IDLE                  0 RFS
         2        113 IDLE                 70 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 14 -- Revert -->> On Node 2 - (DR)
[oracle@pdbdr2 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Fri Jul 4 13:04:30 2025

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

SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL>  SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           133          1
           112          2
            45          3

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           133          1
           111          2
            45          3

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

Database altered.

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;

Database altered.

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           134          1
           113          2
            46          3

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           134          1
           112          2
            46          3

SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         3         48 APPLYING_LOG          6 MRP0

SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby ;

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         2        109 CLOSING               1 ARCH
         2        110 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         3         43 CLOSING               1 ARCH
         3         44 CLOSING               1 ARCH
         3         45 CLOSING               1 ARCH
         2        111 CLOSING               1 ARCH
         2        112 CLOSING               1 ARCH
         3         28 CLOSING               1 ARCH
         2        100 CLOSING               1 ARCH
         3         46 CLOSING               1 ARCH
         2        113 CLOSING               1 ARCH
         1        124 CLOSING               1 ARCH
         3         30 CLOSING               1 ARCH
         3         47 CLOSING               1 ARCH
         1        125 CLOSING               1 ARCH
         2        104 CLOSING               1 ARCH
         3         32 CLOSING               1 ARCH
         3         33 CLOSING               1 ARCH
         3         34 CLOSING               1 ARCH
         3         35 CLOSING               1 ARCH
         3         36 CLOSING               1 ARCH
         3         37 CLOSING               1 ARCH
         3         38 CLOSING               1 ARCH
         3         39 CLOSING               1 ARCH
         3         40 CLOSING               1 ARCH
         1        128 CLOSING               1 ARCH
         3         41 CLOSING            4096 ARCH
         3         42 CLOSING               1 ARCH
         2        108 CLOSING            4096 ARCH
         0          0 IDLE                  0 RFS
         3         48 IDLE                 26 RFS
         0          0 IDLE                  0 RFS
         2        114 IDLE                 79 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         3         48 APPLYING_LOG         25 MRP0
         2        103 CLOSING               1 ARCH
         2         72 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         1         91 CLOSING               1 ARCH
         2         97 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         1        132 CLOSING               1 ARCH
         1        133 CLOSING               1 ARCH
         2         90 CLOSING               1 ARCH
         2         91 CLOSING               1 ARCH
         3          8 CLOSING               1 ARCH
         2         92 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         3         10 CLOSING               1 ARCH
         1        134 CLOSING               1 ARCH
         3         11 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         1        121 CLOSING               1 ARCH
         1        122 CLOSING               1 ARCH
         2        107 CLOSING               1 ARCH
         2        106 CLOSING               1 ARCH
         1        129 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         2        102 CLOSING               1 ARCH
         1        130 CLOSING            4096 ARCH
         0          0 CONNECTED             0 ARCH
         1        131 CLOSING               1 ARCH
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         1        135 IDLE                 87 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 15 -- Revert -->> On All Nodes - (DC)
[oracle@pdb1/pdb2/pdb3 ~]$ rman target /
/*
Recovery Manager: Release 11.2.0.3.0 - Production on Fri Jul 4 13:08:08 2025

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
--Node 3
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/product/11.2.0.3.0/db_1/dbs/snapcf_pdbdb3.f'; # default

RMAN> exit


Recovery Manager complete.
*/

-----------------------------------------------------------------------------------------------------------
-------------------->> C. Three Nodes DC and Two Node DR - DR Drill Senty Testing--------------------------
-----------------------------------------------------------------------------------------------------------
------------------------------------------Snapshot Standby-------------------------------------------------
-----------------------------------------------------------------------------------------------------------
/*
Snapshot standby allows the standby database to be opened in read-write mode. 
When switched back into standby mode, all changes made whilst in read-write mode are lost. 
This is achieved using flashback database, but the standby database does not need to have flashback database
explicitly enabled to take advantage of this feature, thought it works just the same if it is.

Note: If you are using RAC-DC/DR, then turn off all RAC-DR db instance but one of the RAC-DR db instances should be UP and running in MOUNT mode.
*/

-- Step 1.1
-- Verify the DB instance status of Primary Database -> DC
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
Instance pdbdb3 is running on node pdb3. Instance status: Open.
*/

-- Step 1.2
-- Verify the DB instance status of Primary Database -> DC
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         3 OPEN         pdbdb3           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE
*/

-- Step 1.3
-- Connect the DB instance to Create Objects on Primary Database -> DC
-- Step 1.3.1
SQL> CREATE TABLESPACE tbs_snapshots
     DATAFILE '+DATA'
     SIZE 1g
     AUTOEXTEND ON NEXT 512m MAXSIZE UNLIMITED
     SEGMENT SPACE MANAGEMENT AUTO;

Tablespace created.

-- Step 1.3.2
SQL> CREATE USER snapshots IDENTIFIED BY "Sn#P#5h0#T"
     DEFAULT TABLESPACE tbs_snapshots
     TEMPORARY TABLESPACE TEMP
     QUOTA UNLIMITED ON tbs_snapshots;

User created.

-- Step 1.3.3
SQL> GRANT CONNECT,RESOURCE TO snapshots;

Grant succeeded.

-- Step 1.3.4
-- Connect with any user of Primary Database -> DC
SQL> conn snapshots/"Sn#P#5h0#T"
/*
Connected.
*/

-- Step 1.3.5
SQL> show user
USER is "SNAPSHOTS"

-- Step 1.3.6
-- Create a object with relevant user of Primary Database Node1 -> DC
SQL> CREATE TABLE snapshots.snapshot_standby AS
     SELECT
          LEVEL sn,
		  'Node1' status
     FROM dual
     CONNECT BY LEVEL <=10;
/*
Table created.
*/

-- Step 1.3.6.1
-- Populate a object with relevant user of Primary Database Node2 -> DC
SQL> INSERT INTO snapshots.snapshot_standby
     SELECT
          LEVEL sn,
		  'Node2' status
     FROM dual
     CONNECT BY LEVEL <=10;
/*
10 rows created.
*/

SQL> commit;
/*
Commit complete.
*/

-- Step 1.3.6.2
-- Populate a object with relevant user of Primary Database Node3 -> DC
SQL> INSERT INTO snapshots.snapshot_standby
     SELECT
          LEVEL sn,
		  'Node3' status
     FROM dual
     CONNECT BY LEVEL <=10;
/*
10 rows created.
*/

SQL> commit;
/*
Commit complete.
*/

-- Step 1.3.7
-- Verify the Create a object of Primary Database -> DC
SQL> SELECT count(sn),status FROM  snapshots.snapshot_standby group by status;
/*
 COUNT(SN) STATU
---------- -----
        10 Node3
        10 Node2
        10 Node1
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
           138          1
           116          2
            50          3
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
           137          1
           116          2
            50          3
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
db_recovery_file_dest                string      +DATA
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
SQL> conn snapshots/"Sn#P#5h0#T"
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
SQL> SELECT count(sn),status FROM  snapshots.snapshot_standby group by status;
/*
 COUNT(SN) STATU
---------- -----
        10 Node3
        10 Node2
        10 Node1
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
   INST_ID PROCESS      THREAD#  SEQUENCE# STATUS
---------- --------- ---------- ---------- ------------
         1 ARCH               2        125 CLOSING
         1 ARCH               0          0 CONNECTED
         1 ARCH               1        148 CLOSING
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               3         59 CLOSING
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               2        117 CLOSING
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               1        144 CLOSING
         1 ARCH               1        145 CLOSING
         1 ARCH               3         56 CLOSING
         1 ARCH               0          0 CONNECTED
         1 ARCH               2        122 CLOSING
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               3         57 CLOSING
         1 ARCH               2        123 CLOSING
         1 ARCH               0          0 CONNECTED
         1 ARCH               2        124 CLOSING
         1 ARCH               0          0 CONNECTED
         1 ARCH               3         58 CLOSING
         1 ARCH               1        146 CLOSING
         1 ARCH               0          0 CONNECTED
         1 ARCH               0          0 CONNECTED
         1 ARCH               1        147 CLOSING
         1 MRP0               3         60 APPLYING_LOG
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                3         60 IDLE
         1 RFS                2        126 IDLE
         1 RFS                1        149 IDLE
         2 ARCH               1        139 CLOSING
         2 RFS                0          0 IDLE
         2 ARCH               0          0 CONNECTED
         2 ARCH               3         51 CLOSING
         2 ARCH               3         55 CLOSING
         2 ARCH               2        121 CLOSING
         2 ARCH               1        143 CLOSING
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
         2 RFS                0          0 IDLE
         2 RFS                0          0 IDLE
         2 RFS                0          0 IDLE
         2 RFS                0          0 IDLE
         2 RFS                0          0 IDLE
         2 RFS                0          0 IDLE
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
         3 OPEN         pdbdb3           PRIMARY          READ WRITE
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

-- Step 4.20
-- Verify the currect archive of Primary Database -> DC
SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;
/*
MAX(SEQUENCE#)    THREAD#
-------------- ----------
           148          1
           125          2
            59          3
*/

-- Step 4.21
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;
/*
MAX(SEQUENCE#)    THREAD#
-------------- ----------
           148          1
           125          2
            58          3
*/

-----------------------------------------------------------------------------------------------------------
------------------------Test Cases End for Node 3 from 3-Node-DC and 2-Node-DR-----------------------------
-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
------------------------>> Deleting 3 Node of DC from 3-Node-DC and 2-Node-DR <<---------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

-- Step 1 -->> On Node 1 - (DC) -- Backup OCR
[root@pdb1 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
[root@pdb1 bin]# ./ocrconfig -manualbackup
/*
pdb1     2025/07/28 11:16:21     /opt/app/11.2.0.3.0/grid/cdata/pdb-cluster/backup_20250728_111621.ocr
*/

-- Step 2 -->> On All Nodes - (DC) -- Verify Backup
[root@pdb1/pdb2/pdb3 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
[root@pdb1/pdb2/pdb3 bin]# ./ocrconfig -showbackup
/*
pdb1     2025/07/28 10:06:28     /opt/app/11.2.0.3.0/grid/cdata/pdb-cluster/backup00.ocr
pdb1     2025/07/28 06:06:27     /opt/app/11.2.0.3.0/grid/cdata/pdb-cluster/backup01.ocr
pdb1     2025/07/28 02:06:27     /opt/app/11.2.0.3.0/grid/cdata/pdb-cluster/backup02.ocr
pdb1     2025/07/27 02:06:24     /opt/app/11.2.0.3.0/grid/cdata/pdb-cluster/day.ocr
pdb1     2025/07/20 14:06:03     /opt/app/11.2.0.3.0/grid/cdata/pdb-cluster/week.ocr
pdb1     2025/07/28 11:16:21     /opt/app/11.2.0.3.0/grid/cdata/pdb-cluster/backup_20250728_111621.ocr
*/

-- Step 3 -->> On All Nodes - (DC)
-- Verify and Remove 3 Instance from the Cluster Database
[oracle@pdb1/pdb2/pdb3 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jul 28 13:00:37 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         3 OPEN         pdbdb3           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           235          1
           201          2
           136          3

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 4 -->> On Node 1 - (DR) - Disable MRP
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jul 28 13:01:05 2025

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
           235          1
           201          2
           136          3

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           234          1 <==
           201          2
           136          3

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

Database altered.

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 5 -->> On Node 1 - (DC) - Verify the Cluster Database
[oracle@pdb1 ~]$ srvctl config database -d pdbdb -v
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
Database instances: pdbdb1,pdbdb2,pdbdb3
Disk Groups: DATA,ARC
Mount point paths:
Services:
Type: RAC
Database is administrator managed
*/


-- Step 5.1 -->> On Node 1 - (DC) (Pre-verifications)
[oracle@pdb1 ~]$ env | grep ORA
/*
ORACLE_UNQNAME=pdbdb
ORACLE_SID=pdbdb1
ORACLE_BASE=/opt/app/oracle
ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1
ORACLE_HOSTNAME=pdb1.unidev.org.np
*/

-- Step 5.2 -->> On Node 2 - (DC) (Pre-verifications)
[oracle@pdb2 ~]$ env | grep ORA
/*
ORACLE_UNQNAME=pdbdb
ORACLE_SID=pdbdb2
ORACLE_BASE=/opt/app/oracle
ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1
ORACLE_HOSTNAME=pdb2.unidev.org.np
*/

-- Step 5.3 -->> On Node 3 - (DC) (Pre-verifications)
[oracle@pdb3 ~]$ env | grep ORA
/*
ORACLE_UNQNAME=pdbdb
ORACLE_SID=pdbdb3
ORACLE_BASE=/opt/app/oracle
ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1
ORACLE_HOSTNAME=pdb3.unidev.org.np
*/

-- Step 6 -->> On Node 1 - (DC) - Remove the 3 Instance from Cluster Database
-- Delete the Oracle Instance -(Use the Database Configuration Assistant (DBCA) in silent mode)
[oracle@pdb1 ~]$ which dbca
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/bin/dbca
*/

-- Step 6.1 -->> On Node 1 - (DC)
[oracle@pdb1 ~]$ dbca -silent -deleteInstance -nodeList pdb3 -gdbName pdbdb -instanceName pdbdb3 -sysDBAUserName sys -sysDBAPassword Sys605014
/*
Deleting instance
1% complete
2% complete
6% complete
13% complete
20% complete
26% complete
33% complete
40% complete
46% complete
53% complete
60% complete
66% complete
Completing instance management.
100% complete
Look at the log file "/opt/app/oracle/cfgtoollogs/dbca/pdbdb.log" for further details.
*/

-- Step 6.2 -->> On Node 1 - (DC)
[oracle@pdb1 ~]$ cat /opt/app/oracle/cfgtoollogs/dbca/pdbdb.log
/*
The Database Configuration Assistant will delete the Oracle instance and its associated OFA directory structure. All information about this instance will be deleted.

Do you want to proceed?
Deleting instance
DBCA_PROGRESS : 1%
DBCA_PROGRESS : 2%
DBCA_PROGRESS : 6%
DBCA_PROGRESS : 13%
DBCA_PROGRESS : 20%
DBCA_PROGRESS : 26%
DBCA_PROGRESS : 33%
DBCA_PROGRESS : 40%
DBCA_PROGRESS : 46%
DBCA_PROGRESS : 53%
DBCA_PROGRESS : 60%
DBCA_PROGRESS : 66%
Completing instance management.
DBCA_PROGRESS : 100%
*/

-- Step 7 -->> On Node 1 - (DC) (Verification)
[oracle@pdb1 ~]$ srvctl config database -d pdbdb -v
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

-- Step 7.1 -->> On Node 1 - (DC) (Verification)
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jul 28 13:09:27 2025

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

-- Step 7.2 -->> On Node 1 - (DC) (Verification)
[oracle@pdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 28-JUL-2025 13:11:35

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                20-JUL-2025 09:51:06
Uptime                    8 days 3 hr. 20 min. 28 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener/alert/log.x                                                                                                             ml
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

-- Step 7.3 -->> On Node 2 - (DC) (Verification)
[oracle@pdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 28-JUL-2025 13:13:01

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                20-JUL-2025 09:51:23
Uptime                    8 days 3 hr. 21 min. 38 sec
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

-- Step 8 -->> On Node 3 - (DC) -> Remove Oracle Database Software
[oracle@pdb3 ~]$ ps -ef | grep tns
/*
root        64     2  0 Jul20 ?        00:00:00 [netns]
grid      5334     1  0 Jul20 ?        00:00:14 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER -inherit
grid      5399     1  0 Jul20 ?        00:00:18 /opt/app/11.2.0.3.0/grid/bin/tnslsnr LISTENER_SCAN1 -inherit
oracle   15742 12129  0 13:10 pts/0    00:00:00 grep tns
*/

-- Step 8.1 -->> On Node 3 - (DC)
--If listener is running from GI Home then ignore this step
[oracle@pdb3 ~]$ srvctl config listener -a
/*
Name: LISTENER
Network: 1, Owner: grid
Home: <CRS home>
  /opt/app/11.2.0.3.0/grid on node(s) pdb3,pdb2,pdb1
End points: TCP:1521
*/

-- Step 8.1.1 -->> On Node 3 - (DC)
--Note: If any listeners were explicitly created to run from the Oracle home being removed, they would need to be disabled and stopped.
/*
[oracle@pdb3 ~]$ srvctl disable listener -l -n 
[oracle@pdb3 ~]$ srvctl stop listener -l -n 
*/

-- Step 8.2 -->> On Node 3 - (DC)
[oracle@pdb3 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 28-JUL-2025 13:11:13

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                20-JUL-2025 09:51:29
Uptime                    8 days 3 hr. 19 min. 43 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb3/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.28)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.16.29)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM3", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 8.3 -->> On Node 3 - (DC) - Update Oracle Inventory – (Node Being Removed)
[oracle@pdb3 ~]$ cd $ORACLE_HOME/oui/bin
[oracle@pdb3 bin]$ pwd
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/oui/bin
*/

-- Step 8.4 -->> On Node 3 - (DC)
[oracle@pdb3 bin]$ ll runInstaller.sh
/*
-rwxr-x--- 1 oracle oinstall 79 Jul  3 13:06 runInstaller.sh
*/

-- Step 8.5 -->> On Node 3 - (DC) - Swap space: Must be greater than 500 MB
[oracle@pdb3 bin]$ $ORACLE_HOME/oui/bin/runInstaller -updateNodeList ORACLE_HOME=$ORACLE_HOME "CLUSTER_NODES={pdb3}" -local
/*
Starting Oracle Universal Installer...

Checking swap space: must be greater than 500 MB.   Actual 20479 MB    Passed
The inventory pointer is located at /etc/oraInst.loc
The inventory is located at /opt/app/oraInventory
'UpdateNodeList' was successful.
*/

-- Step 8.6 -->> On Node 3 - (DC) - Remove database instance entries - pdbdb3 entry from /etc/oratab
[root@pdb3 ~]# vi /etc/oratab
/*
#Backup file is  /opt/app/oracle/product/11.2.0.3.0/db_1/srvm/admin/oratab.bak.pdb3 line added by Agent
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
# directory of the database respectively.  The third filed indicates
# to the dbstart utility that the database should , "Y", or should not,
# "N", be brought up at system boot time.
#
# Multiple entries with the same $ORACLE_SID are not allowed.
#
#
+ASM3:/opt/app/11.2.0.3.0/grid:N                # line added by Agent
*/

-- Step 8.7 -->> On Node 3 - (DC) - Localy Deinstall Oracle Database Home for Node 3
[oracle@pdb3 ~]$ cd $ORACLE_HOME/deinstall
[oracle@pdb3 deinstall]$ pwd
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/deinstall
*/

-- Step 8.8 -->> On Node 3 - (DC)
[oracle@pdb3 deinstall]$ ./deinstall  -local
/*
Checking for required files and bootstrapping ...
Please wait ...
Location of logs /opt/app/oraInventory/logs/

############ ORACLE DEINSTALL & DECONFIG TOOL START ############


######################### CHECK OPERATION START #########################
## [START] Install check configuration ##


Checking for existence of the Oracle home location /opt/app/oracle/product/11.2.0.3.0/db_1
Oracle Home type selected for deinstall is: Oracle Real Application Cluster Database
Oracle Base selected for deinstall is: /opt/app/oracle
Checking for existence of central inventory location /opt/app/oraInventory
Checking for existence of the Oracle Grid Infrastructure home /opt/app/11.2.0.3.0/grid
The following nodes are part of this cluster: pdb3
Checking for sufficient temp space availability on node(s) : 'pdb3'

## [END] Install check configuration ##


Network Configuration check config START

Network de-configuration trace file location: /opt/app/oraInventory/logs/netdc_check2025-07-28_01-16-44-PM.log

Network Configuration check config END

Database Check Configuration START

Database de-configuration trace file location: /opt/app/oraInventory/logs/databasedc_check2025-07-28_01-16-47-PM.log

Database Check Configuration END

Enterprise Manager Configuration Assistant START

EMCA de-configuration trace file location: /opt/app/oraInventory/logs/emcadc_check2025-07-28_01-16-50-PM.log

Enterprise Manager Configuration Assistant END
Oracle Configuration Manager check START
OCM check log file location : /opt/app/oraInventory/logs//ocm_check5532.log
Oracle Configuration Manager check END

######################### CHECK OPERATION END #########################


####################### CHECK OPERATION SUMMARY #######################
Oracle Grid Infrastructure Home is: /opt/app/11.2.0.3.0/grid
The cluster node(s) on which the Oracle home deinstallation will be performed are:pdb3
Since -local option has been specified, the Oracle home will be deinstalled only on the local node, 'pdb3', and the global configuration will be removed.
Oracle Home selected for deinstall is: /opt/app/oracle/product/11.2.0.3.0/db_1
Inventory Location where the Oracle home registered is: /opt/app/oraInventory
The option -local will not modify any database configuration for this Oracle home.

No Enterprise Manager configuration to be updated for any database(s)
No Enterprise Manager ASM targets to update
No Enterprise Manager listener targets to migrate
Checking the config status for CCR
Oracle Home exists with CCR directory, but CCR is not configured
CCR check is finished
Do you want to continue (y - yes, n - no)? [n]: y
A log of this session will be written to: '/opt/app/oraInventory/logs/deinstall_deconfig2025-07-28_01-16-42-PM.out'
Any error messages from this session will be written to: '/opt/app/oraInventory/logs/deinstall_deconfig2025-07-28_01-16-42-PM.err'

######################## CLEAN OPERATION START ########################

Enterprise Manager Configuration Assistant START

EMCA de-configuration trace file location: /opt/app/oraInventory/logs/emcadc_clean2025-07-28_01-16-50-PM.log

Updating Enterprise Manager ASM targets (if any)
Updating Enterprise Manager listener targets (if any)
Enterprise Manager Configuration Assistant END
Database de-configuration trace file location: /opt/app/oraInventory/logs/databasedc_clean2025-07-28_01-16-53-PM.log

Network Configuration clean config START

Network de-configuration trace file location: /opt/app/oraInventory/logs/netdc_clean2025-07-28_01-16-53-PM.log

De-configuring Local Net Service Names configuration file...
Local Net Service Names configuration file de-configured successfully.

De-configuring backup files...
Backup files de-configured successfully.

The network configuration has been cleaned up successfully.

Network Configuration clean config END

Oracle Configuration Manager clean START
OCM clean log file location : /opt/app/oraInventory/logs//ocm_clean5532.log
Oracle Configuration Manager clean END
Setting the force flag to false
Setting the force flag to cleanup the Oracle Base
Oracle Universal Installer clean START

Detach Oracle home '/opt/app/oracle/product/11.2.0.3.0/db_1' from the central inventory on the local node : Done

Delete directory '/opt/app/oracle/product/11.2.0.3.0/db_1' on the local node : Done

The Oracle Base directory '/opt/app/oracle' will not be removed on local node. The directory is in use by Oracle Home '/opt/app/11.2.0.3.0/grid'.

Oracle Universal Installer cleanup was successful.

Oracle Universal Installer clean END


## [START] Oracle install clean ##

Clean install operation removing temporary directory '/tmp/deinstall2025-07-28_01-16-30PM' on node 'pdb3'

## [END] Oracle install clean ##


######################### CLEAN OPERATION END #########################


####################### CLEAN OPERATION SUMMARY #######################
Cleaning the config for CCR
As CCR is not configured, so skipping the cleaning of CCR configuration
CCR clean is finished
Successfully detached Oracle home '/opt/app/oracle/product/11.2.0.3.0/db_1' from the central inventory on the local node.
Successfully deleted directory '/opt/app/oracle/product/11.2.0.3.0/db_1' on the local node.
Oracle Universal Installer cleanup was successful.

Oracle deinstall tool successfully cleaned up temporary directories.
#######################################################################


############# ORACLE DEINSTALL & DECONFIG TOOL END #############
*/

-- Step 8.9 -->> On Node 3 - (DC) - Localy Deinstall Oracle Database Home for Node 3 - Verification
[oracle@pdb3 ~]$ ps -ef | grep pmon
/*
grid      5075     1  0 Jul20 ?        00:02:43 asm_pmon_+ASM3
oracle   19133 15979  0 13:18 pts/0    00:00:00 grep pmon
*/


-- Step 9 -->> On Node 1 - (DC) - Update Oracle Inventory – All Remaining Nodes 1 and 2
[oracle@pdb1 ~]$ cd $ORACLE_HOME/oui/bin
[oracle@pdb1 bin]$ pwd
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/oui/bin
*/

-- Step 9.1 -->> On Node 1 - (DC)
[oracle@pdb1 bin]$ ll runInstaller.sh
/*
-rwxr-x--- 1 oracle oinstall 79 Jun 26 14:55 runInstaller.sh
*/

-- Step 9.2 -->> On Node 1 - (DC) - Swap space: Must be greater than 500 MB.
[oracle@pdb1 bin]$ $ORACLE_HOME/oui/bin/runInstaller -updateNodeList ORACLE_HOME=$ORACLE_HOME "CLUSTER_NODES={pdb1,pdb2}"
/*
Starting Oracle Universal Installer...

Checking swap space: must be greater than 500 MB.   Actual 20479 MB    Passed
The inventory pointer is located at /etc/oraInst.loc
The inventory is located at /opt/app/oraInventory
'UpdateNodeList' was successful.
*/

-- Step 10 -->> On Node 1 - (DC) - Remove 3 Node from Clusterware
-- If Cluster Synchronization Services (CSS) is not running on the node you are deleting, then the crsctl unpin css command in this step fails.
[root@pdb1 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
[root@pdb1 bin]# ll olsnodes
/*
-rwxr-xr-x 1 grid oinstall 8205 Jun 26 12:55 olsnodes
*/

-- Step 10.1 -->> On Node 1 - (DC)
[root@pdb1 bin]# ./olsnodes  -s -t
/*
pdb1    Active  Unpinned
pdb2    Active  Unpinned
pdb3    Active  Unpinned
*/

-- Step 10.2 -->> On Node 3 - (DC)
--Disable the Oracle Clusterware applications and daemons running on the node. Run the rootcrs.pl script as root from the Grid_home/crs/install directory on the node to be deleted.
[root@pdb3 ~]# cd /opt/app/11.2.0.3.0/grid/crs/install/
[root@pdb3 install]# ll rootcrs.pl
/*
-rwxr-xr-x 1 root oinstall 34750 Jul  3 12:42 rootcrs.pl
*/

-- Step 10.3 -->> On Node 3 - (DC) - Disable Oracle Clusterware
[root@pdb3 install]# ./rootcrs.pl -deconfig -force
/*
Using configuration parameter file: ./crsconfig_params
Network exists: 1/192.168.16.0/255.255.255.0/eth0, type static
VIP exists: /pdb1-vip/192.168.16.23/192.168.16.0/255.255.255.0/eth0, hosting node pdb1
VIP exists: /pdb2-vip/192.168.16.24/192.168.16.0/255.255.255.0/eth0, hosting node pdb2
VIP exists: /pdb3-vip/192.168.16.29/192.168.16.0/255.255.255.0/eth0, hosting node pdb3
GSD exists
ONS exists: Local port 6100, remote port 6200, EM port 2016
CRS-2791: Starting shutdown of Oracle High Availability Services-managed resources on 'pdb3'
CRS-2673: Attempting to stop 'ora.crsd' on 'pdb3'
CRS-2790: Starting shutdown of Cluster Ready Services-managed resources on 'pdb3'
CRS-2673: Attempting to stop 'ora.ARC.dg' on 'pdb3'
CRS-2673: Attempting to stop 'ora.DATA.dg' on 'pdb3'
CRS-2673: Attempting to stop 'ora.OCR.dg' on 'pdb3'
CRS-2677: Stop of 'ora.ARC.dg' on 'pdb3' succeeded
CRS-2677: Stop of 'ora.DATA.dg' on 'pdb3' succeeded
CRS-2677: Stop of 'ora.OCR.dg' on 'pdb3' succeeded
CRS-2673: Attempting to stop 'ora.asm' on 'pdb3'
CRS-2677: Stop of 'ora.asm' on 'pdb3' succeeded
CRS-2792: Shutdown of Cluster Ready Services-managed resources on 'pdb3' has completed
CRS-2677: Stop of 'ora.crsd' on 'pdb3' succeeded
CRS-2673: Attempting to stop 'ora.crf' on 'pdb3'
CRS-2673: Attempting to stop 'ora.ctssd' on 'pdb3'
CRS-2673: Attempting to stop 'ora.evmd' on 'pdb3'
CRS-2673: Attempting to stop 'ora.asm' on 'pdb3'
CRS-2673: Attempting to stop 'ora.mdnsd' on 'pdb3'
CRS-2677: Stop of 'ora.crf' on 'pdb3' succeeded
CRS-2677: Stop of 'ora.mdnsd' on 'pdb3' succeeded
CRS-2677: Stop of 'ora.evmd' on 'pdb3' succeeded
CRS-2677: Stop of 'ora.ctssd' on 'pdb3' succeeded
CRS-2677: Stop of 'ora.asm' on 'pdb3' succeeded
CRS-2673: Attempting to stop 'ora.cluster_interconnect.haip' on 'pdb3'
CRS-2677: Stop of 'ora.cluster_interconnect.haip' on 'pdb3' succeeded
CRS-2673: Attempting to stop 'ora.cssd' on 'pdb3'
CRS-2677: Stop of 'ora.cssd' on 'pdb3' succeeded
CRS-2673: Attempting to stop 'ora.gipcd' on 'pdb3'
CRS-2677: Stop of 'ora.gipcd' on 'pdb3' succeeded
CRS-2673: Attempting to stop 'ora.gpnpd' on 'pdb3'
CRS-2677: Stop of 'ora.gpnpd' on 'pdb3' succeeded
CRS-2793: Shutdown of Oracle High Availability Services-managed resources on 'pdb3' has completed
CRS-4133: Oracle High Availability Services has been stopped.
Successfully deconfigured Oracle clusterware stack on this node
*/

-- Step 10.4 -->> On Node 1 - (DC) - Delete 3 Node from Clusterware Configuration
[root@pdb1 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
[root@pdb1 bin]# ll crsctl olsnodes
/*
-rwxr-xr-x 1 root oinstall 8205 Jun 26 12:55 crsctl
-rwxr-xr-x 1 grid oinstall 8205 Jun 26 12:55 olsnodes
*/

-- Step 10.5 -->> On Node 1 - (DC)
[root@pdb1 bin]# ./crsctl delete node -n pdb3
/*
CRS-4661: Node pdb3 successfully deleted.
*/

-- Step 10.6 -->> On Node 1 - (DC)
[root@pdb1 bin]# ./olsnodes -t -s
/*
pdb1    Active  Unpinned
pdb2    Active  Unpinned
*/

-- Step 10.7 -->> On Node 1 - (DC)
[root@pdb1 bin]# ./crsctl stat res -t
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
      1        ONLINE  ONLINE       pdb1
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdb2
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
      1        ONLINE  ONLINE       pdb1
ora.scan2.vip
      1        ONLINE  ONLINE       pdb2
ora.scan3.vip
      1        ONLINE  ONLINE       pdb1
*/

-- Step 10.8 -->> On Node 3 - (DC) - Update Oracle Inventory – (Node 3 Being Removed) for GI Home
[grid@pdb3 ~]$ cd $GRID_HOME/oui/bin/
[grid@pdb3 bin]$ pwd
/*
/opt/app/11.2.0.3.0/grid/oui/bin
*/

-- Step 10.9 -->> On Node 3 - (DC)
[grid@pdb3 bin]$ ll runInstaller
/*
-rwxr-x--- 1 grid oinstall 161979 Jul  3 12:42 runInstaller
*/

-- Step 10.10 -->> On Node 3 - (DC) - Swap space: Must be greater than 500 MB.
[grid@pdb3 bin]$ $GRID_HOME/oui/bin/runInstaller -updateNodeList ORACLE_HOME=$GRID_HOME "CLUSTER_NODES={pdb3}" CRS=TRUE -local
/*
Starting Oracle Universal Installer...

Checking swap space: must be greater than 500 MB.   Actual 20479 MB    Passed
The inventory pointer is located at /etc/oraInst.loc
The inventory is located at /opt/app/oraInventory
'UpdateNodeList' was successful.
*/

-- Step 10.11 -->> On Node 3 - (DC) - Locally De-install 3 Node Grid Infrastructure Software
[grid@pdb3 ~]$ cd $GRID_HOME/deinstall/
[grid@pdb3 deinstall]$ pwd
/*
/opt/app/11.2.0.3.0/grid/deinstall
*/

-- Step 10.12 -->> On Node 3 - (DC)
[grid@pdb3 deinstall]$ ll deinstall
/*
-rwxr-xr-x 1 grid oinstall 9647 Jul  3 12:42 deinstall
*/

-- Step 10.13 -->> On Node 3 - (DC)
[grid@pdb3 deinstall]$ ./deinstall -local
/*
Checking for required files and bootstrapping ...
Please wait ...
Location of logs /tmp/deinstall2025-07-28_01-38-47PM/logs/

############ ORACLE DEINSTALL & DECONFIG TOOL START ############


######################### CHECK OPERATION START #########################
## [START] Install check configuration ##


Checking for existence of the Oracle home location /opt/app/11.2.0.3.0/grid
Oracle Home type selected for deinstall is: Oracle Grid Infrastructure for a Cluster
Oracle Base selected for deinstall is: /opt/app/oracle
Checking for existence of central inventory location /opt/app/oraInventory
Checking for existence of the Oracle Grid Infrastructure home
The following nodes are part of this cluster: pdb3
Checking for sufficient temp space availability on node(s) : 'pdb3'

## [END] Install check configuration ##

Traces log file: /tmp/deinstall2025-07-28_01-38-47PM/logs//crsdc.log
Enter an address or the name of the virtual IP used on node "pdb3"[pdb3-vip]
 >

The following information can be collected by running "/sbin/ifconfig -a" on node "pdb3"
Enter the IP netmask of Virtual IP "192.168.16.29" on node "pdb3"[255.255.255.0]
 >

Enter the network interface name on which the virtual IP address "192.168.16.29" is active
 >

Enter an address or the name of the virtual IP[]
 >


Network Configuration check config START

Network de-configuration trace file location: /tmp/deinstall2025-07-28_01-38-47PM/logs/netdc_check2025-07-28_01-39-08-PM.log

Specify all RAC listeners (do not include SCAN listener) that are to be de-configured [LISTENER,LISTENER_SCAN3,LISTENER_SCAN2,LISTENER_SCAN1]:LISTENER

At least one listener from the discovered listener list [LISTENER,LISTENER_SCAN3,LISTENER_SCAN2,LISTENER_SCAN1] is missing in the specified listener list [LISTENER]. The Oracle home will be cleaned up, so all the listeners will not be available after deinstall. If you want to remove a specific listener, please use Oracle Net Configuration Assistant instead. Do you want to continue? (y|n) [n]: y

Network Configuration check config END

Asm Check Configuration START

ASM de-configuration trace file location: /tmp/deinstall2025-07-28_01-38-47PM/logs/asmcadc_check2025-07-28_01-39-24-PM.log


######################### CHECK OPERATION END #########################


####################### CHECK OPERATION SUMMARY #######################
Oracle Grid Infrastructure Home is:
The cluster node(s) on which the Oracle home deinstallation will be performed are:pdb3
Since -local option has been specified, the Oracle home will be deinstalled only on the local node, 'pdb3', and the global configuration will be removed.
Oracle Home selected for deinstall is: /opt/app/11.2.0.3.0/grid
Inventory Location where the Oracle home registered is: /opt/app/oraInventory
Following RAC listener(s) will be de-configured: LISTENER
Option -local will not modify any ASM configuration.
Do you want to continue (y - yes, n - no)? [n]: y
A log of this session will be written to: '/tmp/deinstall2025-07-28_01-38-47PM/logs/deinstall_deconfig2025-07-28_01-39-00-PM.out'
Any error messages from this session will be written to: '/tmp/deinstall2025-07-28_01-38-47PM/logs/deinstall_deconfig2025-07-28_01-39-00-PM.err'

######################## CLEAN OPERATION START ########################
ASM de-configuration trace file location: /tmp/deinstall2025-07-28_01-38-47PM/logs/asmcadc_clean2025-07-28_01-39-27-PM.log
ASM Clean Configuration END

Network Configuration clean config START

Network de-configuration trace file location: /tmp/deinstall2025-07-28_01-38-47PM/logs/netdc_clean2025-07-28_01-39-27-PM.log

De-configuring RAC listener(s): LISTENER

De-configuring listener: LISTENER
    Stopping listener on node "pdb3": LISTENER
    Warning: Failed to stop listener. Listener may not be running.
Listener de-configured successfully.

De-configuring Naming Methods configuration file...
Naming Methods configuration file de-configured successfully.

De-configuring backup files...
Backup files de-configured successfully.

The network configuration has been cleaned up successfully.

Network Configuration clean config END


---------------------------------------->

The deconfig command below can be executed in parallel on all the remote nodes. Execute the command on  the local node after the execution completes on all the remote nodes.

Run the following command as the root user or the administrator on node "pdb3".

/tmp/deinstall2025-07-28_01-38-47PM/perl/bin/perl -I/tmp/deinstall2025-07-28_01-38-47PM/perl/lib -I/tmp/deinstall2025-07-28_01-38-47PM/crs/install /tmp/deinstall2025-07-28_01-38-47PM/crs/install/rootcrs.pl -force  -deconfig -paramfile "/tmp/deinstall2025-07-28_01-38-47PM/response/deinstall_Ora11g_gridinfrahome1.rsp"

Press Enter after you finish running the above commands

<----------------------------------------
*/

-- Step 10.13.1 -->> On Node 3 - (DC) - Run From Other Terminal and after success, Press Enter after you finish running the above commands
[root@pdb3 ~]# /tmp/deinstall2025-07-28_01-38-47PM/perl/bin/perl -I/tmp/deinstall2025-07-28_01-38-47PM/perl/lib -I/tmp/deinstall2025-07-28_01-38-47PM/crs/install /tmp/deinstall2025-07-28_01-38-47PM/crs/install/rootcrs.pl -force  -deconfig -paramfile "/tmp/deinstall2025-07-28_01-38-47PM/response/deinstall_Ora11g_gridinfrahome1.rsp"
/*
****Unable to retrieve Oracle Clusterware home.
Start Oracle Clusterware stack and try again.
CRS-4047: No Oracle Clusterware components configured.
CRS-4000: Command Stop failed, or completed with errors.
################################################################
# You must kill processes or reboot the system to properly #
# cleanup the processes started by Oracle clusterware          #
################################################################
Either /etc/oracle/olr.loc does not exist or is not readable
Make sure the file exists and it has read and execute access
Either /etc/oracle/olr.loc does not exist or is not readable
Make sure the file exists and it has read and execute access
Failure in execution (rc=-1, 256, No such file or directory) for command /etc/init.d/ohasd deinstall
error: package cvuqdisk is not installed
Successfully deconfigured Oracle clusterware stack on this node
*/

-- Step 10.13.2 -->> On Node 3 - (DC) - After success Resume the task from same terminal, Press Enter after you finish running the above commands
[grid@pdb3 deinstall]$ Press Enter to Resume the task
/*
/tmp/deinstall2025-07-28_01-38-47PM/perl/bin/perl -I/tmp/deinstall2025-07-28_01-38-47PM/perl/lib -I/tmp/deinstall2025-07-28_01-38-47PM/crs/install /tmp/deinstall2025-07-28_01-38-47PM/crs/install/rootcrs.pl -force  -deconfig -paramfile "/tmp/deinstall2025-07-28_01-38-47PM/response/deinstall_Ora11g_gridinfrahome1.rsp"

Press Enter after you finish running the above commands

<----------------------------------------
<<-- Enter

Remove the directory: /tmp/deinstall2025-07-28_01-38-47PM on node:
Setting the force flag to false
Setting the force flag to cleanup the Oracle Base
Oracle Universal Installer clean START

Detach Oracle home '/opt/app/11.2.0.3.0/grid' from the central inventory on the local node : Done

Failed to delete the directory '/opt/app/11.2.0.3.0/grid'. The directory is in use.
Delete directory '/opt/app/11.2.0.3.0/grid' on the local node : Failed <<<<

Delete directory '/opt/app/oraInventory' on the local node : Done

Failed to delete the file '/opt/app/oracle/cfgtoollogs/emca/emca_2025_07_28_13_16_50.log'. The file is in use.
Failed to delete the directory '/opt/app/oracle/cfgtoollogs/emca'. The directory is not empty.
Failed to delete the directory '/opt/app/oracle/cfgtoollogs'. The directory is not empty.
Failed to delete the directory '/opt/app/oracle/diag/rdbms/pdbdb/pdbdb3/metadata_dgif'. The directory is in use.
Failed to delete the directory '/opt/app/oracle/diag/rdbms/pdbdb/pdbdb3/incpkg'. The directory is in use.
Failed to delete the directory '/opt/app/oracle/diag/rdbms/pdbdb/pdbdb3/cdump'. The directory is in use.
Failed to delete the file '/opt/app/oracle/diag/rdbms/pdbdb/pdbdb3/trace/pdbdb3_rcbg_23657.trc'. The file is in use.
Failed to delete the file '/opt/app/oracle/diag/rdbms/pdbdb/pdbdb3/trace/pdbdb3_arc4_22488.trc'. The file is in use.
Failed to delete the file '/opt/app/oracle/diag/rdbms/pdbdb/pdbdb3/trace/pdbdb3_gcr0_30795.trc'. The file is in use.
Failed to delete the file '/opt/app/oracle/diag/rdbms/pdbdb/pdbdb3/trace/pdbdb3_gcr0_14146.trc'. The file is in use.
Failed to delete the file '/opt/app/oracle/diag/rdbms/pdbdb/pdbdb3/trace/pdbdb3_arcc_23582.trc'. The file is in use.
Failed to delete the file '/opt/app/oracle/diag/rdbms/pdbdb/pdbdb3/trace/pdbdb3_gcr0_24613.trm'. The file is in use.
Failed to delete the file '/opt/app/oracle/diag/rdbms/pdbdb/pdbdb3/trace/pdbdb3_arcj_23596.trm'. The file is in use.
Failed to delete the file '/opt/app/oracle/diag/rdbms/pdbdb/pdbdb3/lck/AM_2087871759_1054152112.lck'. The file is in use.
Failed to delete the file '/opt/app/oracle/diag/rdbms/pdbdb/pdbdb3/lck/AM_2569157681_2857696958.lck'. The file is in use.
Failed to delete the directory '/opt/app/oracle/diag/rdbms/pdbdb/pdbdb3/lck'. The directory is not empty.
Failed to delete the directory '/opt/app/oracle/diag/rdbms/pdbdb/pdbdb3'. The directory is not empty.
Failed to delete the file '/opt/app/oracle/diag/rdbms/pdbdb/i_1.mif'. The file is in use.
Failed to delete the directory '/opt/app/oracle/diag/rdbms/pdbdb'. The directory is not empty.
Failed to delete the directory '/opt/app/oracle/diag/rdbms'. The directory is not empty.
Failed to delete the directory '/opt/app/oracle/diag'. The directory is not empty.
The Oracle Base directory '/opt/app/oracle' will not be removed on local node. The directory is not empty.

Oracle Universal Installer cleanup was successful.

Oracle Universal Installer clean END


## [START] Oracle install clean ##

Clean install operation removing temporary directory '/tmp/deinstall2025-07-28_01-38-47PM' on node 'pdb3'

## [END] Oracle install clean ##


######################### CLEAN OPERATION END #########################


####################### CLEAN OPERATION SUMMARY #######################
Following RAC listener(s) were de-configured successfully: LISTENER
Oracle Clusterware is stopped and successfully de-configured on node "pdb3"
Oracle Clusterware is stopped and de-configured successfully.
Successfully detached Oracle home '/opt/app/11.2.0.3.0/grid' from the central inventory on the local node.
Failed to delete directory '/opt/app/11.2.0.3.0/grid' on the local node.
Successfully deleted directory '/opt/app/oraInventory' on the local node.
Oracle Universal Installer cleanup was successful.


Run 'rm -rf /etc/oraInst.loc' as root on node(s) 'pdb3' at the end of the session.

Run 'rm -rf /opt/ORCLfmap' as root on node(s) 'pdb3' at the end of the session.
Oracle deinstall tool successfully cleaned up temporary directories.
#######################################################################


############# ORACLE DEINSTALL & DECONFIG TOOL END #############
*/

-- Step 10.14 -->> On Node 3 - (DC)
[root@pdb3 ~]# rm -rf /etc/oraInst.loc
[root@pdb3 ~]# rm -rf /opt/ORCLfmap
[root@pdb3 ~]# rm -rf /opt/app/
[root@pdb3 ~]# rm -rf /opt/app/11.2.0.3.0
[root@pdb3 ~]# rm -rf /opt/app/oracle

-- Step 11 -->> On Node 1 - (DC) - Update Oracle Inventory – All Remaining Nodes 1 and 2
[grid@pdb1 ~]$ cd $GRID_HOME/oui/bin
[grid@pdb1 bin]$ pwd
/*
/opt/app/11.2.0.3.0/grid/oui/bin
*/

-- Step 11.1 -->> On Node 1 - (DC)
[grid@pdb1 bin]$ ll runInstaller
/*
-rwxr-x--- 1 grid oinstall 161979 Aug 25  2011 runInstaller
*/

-- Step 11.2 -->> On Node 1 - (DC) - Swap space: Must be greater than 500 MB
[grid@pdb1 bin]$ $GRID_HOME/oui/bin/runInstaller -updateNodeList ORACLE_HOME=$GRID_HOME "CLUSTER_NODES={pdb1,pdb2}" CRS=TRUE
/*
Starting Oracle Universal Installer...

Checking swap space: must be greater than 500 MB.   Actual 20479 MB    Passed
The inventory pointer is located at /etc/oraInst.loc
The inventory is located at /opt/app/oraInventory
'UpdateNodeList' was successful.
*/

--Verify New Cluster Configuration
-- Step 12 -->> On Node 1 - (DC) - (Verify the 3 node has been successfully removed for grid user)
[grid@pdb1 ~]$ which cluvfy
/*
/opt/app/11.2.0.3.0/grid/bin/cluvfy
*/

-- Step 12.1 -->> On Node 1 - (DC) -  (Verify the node has been successfully removed for grid user)
[grid@pdb1 ~]$ cluvfy stage -post nodedel -n pdb3 -verbose
/*
Performing post-checks for node removal

Checking CRS integrity...

Clusterware version consistency passed
The Oracle Clusterware is healthy on node "pdb2"
The Oracle Clusterware is healthy on node "pdb1"

CRS integrity check passed
Result:
Node removal check passed

Post-check for node removal was successful.
*/

-- Step 12.2 -->> On Node 1 - (DC) - (Verify the node has been successfully removed for grid user)
[grid@pdb1 ~]$ which olsnodes
/*
/opt/app/11.2.0.3.0/grid/bin/olsnodes
*/

-- Step 12.3 -->> On Node 1 - (DC)
[grid@pdb1 ~]$ olsnodes -n -s -t
/*
pdb1    1       Active  Unpinned
pdb2    2       Active  Unpinned
*/

-- Step 13 -->> On All Nodes (De-Configure) (DC and DR)
[root@pdb1/pdb2/pdbdr1/pdbdr2 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

##############################DC#####################
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

##############################DR######################
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

-- Step 14 -->> On Node 1 (DC - Remove added log files)
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jul 28 14:28:32 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

-- Step 14.01 -->> On Node 1 (DC - Remove added log files)
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE

-- Step 14.02 -->> On Node 1 (DC - Remove added log files)
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

-- Step 14.03 -->> On Node 1 (DC - Remove added log files)
SQL> col member for a50
SQL> SELECT b.thread#,a.group#, a.type, a.member, b.bytes FROM gv$logfile a, gv$standby_log b WHERE a.group# = b.group# ORDER BY 2,4;

   THREAD#     GROUP# TYPE    MEMBER                                                  BYTES
---------- ---------- ------- -------------------------------------------------- ----------
         1          7 STANDBY +DATA/pdbdb/onlinelog/group_7.265.1205149301         52428800
         1          7 STANDBY +DATA/pdbdb/onlinelog/group_7.265.1205149301         52428800
         1          7 STANDBY +DATA/pdbdb/onlinelog/group_7.265.1205149301         52428800
         1          7 STANDBY +DATA/pdbdb/onlinelog/group_7.265.1205149301         52428800
         1          7 STANDBY +DATA/pdbdb/onlinelog/group_7.266.1205149301         52428800
         1          7 STANDBY +DATA/pdbdb/onlinelog/group_7.266.1205149301         52428800
         1          7 STANDBY +DATA/pdbdb/onlinelog/group_7.266.1205149301         52428800
         1          7 STANDBY +DATA/pdbdb/onlinelog/group_7.266.1205149301         52428800
         1          8 STANDBY +DATA/pdbdb/onlinelog/group_8.261.1205149303         52428800
         1          8 STANDBY +DATA/pdbdb/onlinelog/group_8.261.1205149303         52428800
         1          8 STANDBY +DATA/pdbdb/onlinelog/group_8.261.1205149303         52428800
         1          8 STANDBY +DATA/pdbdb/onlinelog/group_8.261.1205149303         52428800
         1          8 STANDBY +DATA/pdbdb/onlinelog/group_8.262.1205149301         52428800
         1          8 STANDBY +DATA/pdbdb/onlinelog/group_8.262.1205149301         52428800
         1          8 STANDBY +DATA/pdbdb/onlinelog/group_8.262.1205149301         52428800
         1          8 STANDBY +DATA/pdbdb/onlinelog/group_8.262.1205149301         52428800
         1          9 STANDBY +DATA/pdbdb/onlinelog/group_9.280.1205149303         52428800
         1          9 STANDBY +DATA/pdbdb/onlinelog/group_9.280.1205149303         52428800
         1          9 STANDBY +DATA/pdbdb/onlinelog/group_9.280.1205149303         52428800
         1          9 STANDBY +DATA/pdbdb/onlinelog/group_9.280.1205149303         52428800
         1          9 STANDBY +DATA/pdbdb/onlinelog/group_9.281.1205149303         52428800
         1          9 STANDBY +DATA/pdbdb/onlinelog/group_9.281.1205149303         52428800
         1          9 STANDBY +DATA/pdbdb/onlinelog/group_9.281.1205149303         52428800
         1          9 STANDBY +DATA/pdbdb/onlinelog/group_9.281.1205149303         52428800
         1         10 STANDBY +DATA/pdbdb/onlinelog/group_10.282.1205149303        52428800
         1         10 STANDBY +DATA/pdbdb/onlinelog/group_10.282.1205149303        52428800
         1         10 STANDBY +DATA/pdbdb/onlinelog/group_10.282.1205149303        52428800
         1         10 STANDBY +DATA/pdbdb/onlinelog/group_10.282.1205149303        52428800
         1         10 STANDBY +DATA/pdbdb/onlinelog/group_10.283.1205149303        52428800
         1         10 STANDBY +DATA/pdbdb/onlinelog/group_10.283.1205149303        52428800
         1         10 STANDBY +DATA/pdbdb/onlinelog/group_10.283.1205149303        52428800
         1         10 STANDBY +DATA/pdbdb/onlinelog/group_10.283.1205149303        52428800
         2         11 STANDBY +DATA/pdbdb/onlinelog/group_11.284.1205149303        52428800
         2         11 STANDBY +DATA/pdbdb/onlinelog/group_11.284.1205149303        52428800
         2         11 STANDBY +DATA/pdbdb/onlinelog/group_11.284.1205149303        52428800
         2         11 STANDBY +DATA/pdbdb/onlinelog/group_11.284.1205149303        52428800
         2         11 STANDBY +DATA/pdbdb/onlinelog/group_11.285.1205149303        52428800
         2         11 STANDBY +DATA/pdbdb/onlinelog/group_11.285.1205149303        52428800
         2         11 STANDBY +DATA/pdbdb/onlinelog/group_11.285.1205149303        52428800
         2         11 STANDBY +DATA/pdbdb/onlinelog/group_11.285.1205149303        52428800
         2         12 STANDBY +DATA/pdbdb/onlinelog/group_12.286.1205149303        52428800
         2         12 STANDBY +DATA/pdbdb/onlinelog/group_12.286.1205149303        52428800
         2         12 STANDBY +DATA/pdbdb/onlinelog/group_12.286.1205149303        52428800
         2         12 STANDBY +DATA/pdbdb/onlinelog/group_12.286.1205149303        52428800
         2         12 STANDBY +DATA/pdbdb/onlinelog/group_12.287.1205149303        52428800
         2         12 STANDBY +DATA/pdbdb/onlinelog/group_12.287.1205149303        52428800
         2         12 STANDBY +DATA/pdbdb/onlinelog/group_12.287.1205149303        52428800
         2         12 STANDBY +DATA/pdbdb/onlinelog/group_12.287.1205149303        52428800
         2         13 STANDBY +DATA/pdbdb/onlinelog/group_13.288.1205149305        52428800
         2         13 STANDBY +DATA/pdbdb/onlinelog/group_13.288.1205149305        52428800
         2         13 STANDBY +DATA/pdbdb/onlinelog/group_13.288.1205149305        52428800
         2         13 STANDBY +DATA/pdbdb/onlinelog/group_13.288.1205149305        52428800
         2         13 STANDBY +DATA/pdbdb/onlinelog/group_13.289.1205149305        52428800
         2         13 STANDBY +DATA/pdbdb/onlinelog/group_13.289.1205149305        52428800
         2         13 STANDBY +DATA/pdbdb/onlinelog/group_13.289.1205149305        52428800
         2         13 STANDBY +DATA/pdbdb/onlinelog/group_13.289.1205149305        52428800
         2         14 STANDBY +DATA/pdbdb/onlinelog/group_14.290.1205149305        52428800
         2         14 STANDBY +DATA/pdbdb/onlinelog/group_14.290.1205149305        52428800
         2         14 STANDBY +DATA/pdbdb/onlinelog/group_14.290.1205149305        52428800
         2         14 STANDBY +DATA/pdbdb/onlinelog/group_14.290.1205149305        52428800
         2         14 STANDBY +DATA/pdbdb/onlinelog/group_14.291.1205149305        52428800
         2         14 STANDBY +DATA/pdbdb/onlinelog/group_14.291.1205149305        52428800
         2         14 STANDBY +DATA/pdbdb/onlinelog/group_14.291.1205149305        52428800
         2         14 STANDBY +DATA/pdbdb/onlinelog/group_14.291.1205149305        52428800
         3         18 STANDBY +DATA/pdbdb/onlinelog/group_18.325.1205580667        52428800
         3         18 STANDBY +DATA/pdbdb/onlinelog/group_18.325.1205580667        52428800
         3         18 STANDBY +DATA/pdbdb/onlinelog/group_18.325.1205580667        52428800
         3         18 STANDBY +DATA/pdbdb/onlinelog/group_18.325.1205580667        52428800
         3         18 STANDBY +DATA/pdbdb/onlinelog/group_18.339.1205580667        52428800
         3         18 STANDBY +DATA/pdbdb/onlinelog/group_18.339.1205580667        52428800
         3         18 STANDBY +DATA/pdbdb/onlinelog/group_18.339.1205580667        52428800
         3         18 STANDBY +DATA/pdbdb/onlinelog/group_18.339.1205580667        52428800
         3         19 STANDBY +DATA/pdbdb/onlinelog/group_19.298.1205580673        52428800
         3         19 STANDBY +DATA/pdbdb/onlinelog/group_19.298.1205580673        52428800
         3         19 STANDBY +DATA/pdbdb/onlinelog/group_19.298.1205580673        52428800
         3         19 STANDBY +DATA/pdbdb/onlinelog/group_19.298.1205580673        52428800
         3         19 STANDBY +DATA/pdbdb/onlinelog/group_19.344.1205580673        52428800
         3         19 STANDBY +DATA/pdbdb/onlinelog/group_19.344.1205580673        52428800
         3         19 STANDBY +DATA/pdbdb/onlinelog/group_19.344.1205580673        52428800
         3         19 STANDBY +DATA/pdbdb/onlinelog/group_19.344.1205580673        52428800
         3         20 STANDBY +DATA/pdbdb/onlinelog/group_20.299.1205580677        52428800
         3         20 STANDBY +DATA/pdbdb/onlinelog/group_20.299.1205580677        52428800
         3         20 STANDBY +DATA/pdbdb/onlinelog/group_20.299.1205580677        52428800
         3         20 STANDBY +DATA/pdbdb/onlinelog/group_20.299.1205580677        52428800
         3         20 STANDBY +DATA/pdbdb/onlinelog/group_20.304.1205580677        52428800
         3         20 STANDBY +DATA/pdbdb/onlinelog/group_20.304.1205580677        52428800
         3         20 STANDBY +DATA/pdbdb/onlinelog/group_20.304.1205580677        52428800
         3         20 STANDBY +DATA/pdbdb/onlinelog/group_20.304.1205580677        52428800
         3         21 STANDBY +DATA/pdbdb/onlinelog/group_21.333.1205580681        52428800
         3         21 STANDBY +DATA/pdbdb/onlinelog/group_21.333.1205580681        52428800
         3         21 STANDBY +DATA/pdbdb/onlinelog/group_21.333.1205580681        52428800
         3         21 STANDBY +DATA/pdbdb/onlinelog/group_21.333.1205580681        52428800
         3         21 STANDBY +DATA/pdbdb/onlinelog/group_21.336.1205580681        52428800
         3         21 STANDBY +DATA/pdbdb/onlinelog/group_21.336.1205580681        52428800
         3         21 STANDBY +DATA/pdbdb/onlinelog/group_21.336.1205580681        52428800
         3         21 STANDBY +DATA/pdbdb/onlinelog/group_21.336.1205580681        52428800

-- Step 14.04 -->> On Node 1 (DC - Remove added log files)
SQL> alter database drop standby logfile group 18;
SQL> alter database drop standby logfile group 19;
SQL> alter database drop standby logfile group 20;
SQL> alter database drop standby logfile group 21;

-- Step 14.05 -->> On Node 1 (DC - Remove added log files)
SQL> col member for a50
SQL> SELECT b.thread#,a.group#, a.type, a.member, b.bytes FROM gv$logfile a, gv$standby_log b WHERE a.group# = b.group# ORDER BY 2,4;

   THREAD#     GROUP# TYPE    MEMBER                                                  BYTES
---------- ---------- ------- -------------------------------------------------- ----------
         1          7 STANDBY +DATA/pdbdb/onlinelog/group_7.265.1205149301         52428800
         1          7 STANDBY +DATA/pdbdb/onlinelog/group_7.265.1205149301         52428800
         1          7 STANDBY +DATA/pdbdb/onlinelog/group_7.265.1205149301         52428800
         1          7 STANDBY +DATA/pdbdb/onlinelog/group_7.265.1205149301         52428800
         1          7 STANDBY +DATA/pdbdb/onlinelog/group_7.266.1205149301         52428800
         1          7 STANDBY +DATA/pdbdb/onlinelog/group_7.266.1205149301         52428800
         1          7 STANDBY +DATA/pdbdb/onlinelog/group_7.266.1205149301         52428800
         1          7 STANDBY +DATA/pdbdb/onlinelog/group_7.266.1205149301         52428800
         1          8 STANDBY +DATA/pdbdb/onlinelog/group_8.261.1205149303         52428800
         1          8 STANDBY +DATA/pdbdb/onlinelog/group_8.261.1205149303         52428800
         1          8 STANDBY +DATA/pdbdb/onlinelog/group_8.261.1205149303         52428800
         1          8 STANDBY +DATA/pdbdb/onlinelog/group_8.261.1205149303         52428800
         1          8 STANDBY +DATA/pdbdb/onlinelog/group_8.262.1205149301         52428800
         1          8 STANDBY +DATA/pdbdb/onlinelog/group_8.262.1205149301         52428800
         1          8 STANDBY +DATA/pdbdb/onlinelog/group_8.262.1205149301         52428800
         1          8 STANDBY +DATA/pdbdb/onlinelog/group_8.262.1205149301         52428800
         1          9 STANDBY +DATA/pdbdb/onlinelog/group_9.280.1205149303         52428800
         1          9 STANDBY +DATA/pdbdb/onlinelog/group_9.280.1205149303         52428800
         1          9 STANDBY +DATA/pdbdb/onlinelog/group_9.280.1205149303         52428800
         1          9 STANDBY +DATA/pdbdb/onlinelog/group_9.280.1205149303         52428800
         1          9 STANDBY +DATA/pdbdb/onlinelog/group_9.281.1205149303         52428800
         1          9 STANDBY +DATA/pdbdb/onlinelog/group_9.281.1205149303         52428800
         1          9 STANDBY +DATA/pdbdb/onlinelog/group_9.281.1205149303         52428800
         1          9 STANDBY +DATA/pdbdb/onlinelog/group_9.281.1205149303         52428800
         1         10 STANDBY +DATA/pdbdb/onlinelog/group_10.282.1205149303        52428800
         1         10 STANDBY +DATA/pdbdb/onlinelog/group_10.282.1205149303        52428800
         1         10 STANDBY +DATA/pdbdb/onlinelog/group_10.282.1205149303        52428800
         1         10 STANDBY +DATA/pdbdb/onlinelog/group_10.282.1205149303        52428800
         1         10 STANDBY +DATA/pdbdb/onlinelog/group_10.283.1205149303        52428800
         1         10 STANDBY +DATA/pdbdb/onlinelog/group_10.283.1205149303        52428800
         1         10 STANDBY +DATA/pdbdb/onlinelog/group_10.283.1205149303        52428800
         1         10 STANDBY +DATA/pdbdb/onlinelog/group_10.283.1205149303        52428800
         2         11 STANDBY +DATA/pdbdb/onlinelog/group_11.284.1205149303        52428800
         2         11 STANDBY +DATA/pdbdb/onlinelog/group_11.284.1205149303        52428800
         2         11 STANDBY +DATA/pdbdb/onlinelog/group_11.284.1205149303        52428800
         2         11 STANDBY +DATA/pdbdb/onlinelog/group_11.284.1205149303        52428800
         2         11 STANDBY +DATA/pdbdb/onlinelog/group_11.285.1205149303        52428800
         2         11 STANDBY +DATA/pdbdb/onlinelog/group_11.285.1205149303        52428800
         2         11 STANDBY +DATA/pdbdb/onlinelog/group_11.285.1205149303        52428800
         2         11 STANDBY +DATA/pdbdb/onlinelog/group_11.285.1205149303        52428800
         2         12 STANDBY +DATA/pdbdb/onlinelog/group_12.286.1205149303        52428800
         2         12 STANDBY +DATA/pdbdb/onlinelog/group_12.286.1205149303        52428800
         2         12 STANDBY +DATA/pdbdb/onlinelog/group_12.286.1205149303        52428800
         2         12 STANDBY +DATA/pdbdb/onlinelog/group_12.286.1205149303        52428800
         2         12 STANDBY +DATA/pdbdb/onlinelog/group_12.287.1205149303        52428800
         2         12 STANDBY +DATA/pdbdb/onlinelog/group_12.287.1205149303        52428800
         2         12 STANDBY +DATA/pdbdb/onlinelog/group_12.287.1205149303        52428800
         2         12 STANDBY +DATA/pdbdb/onlinelog/group_12.287.1205149303        52428800
         2         13 STANDBY +DATA/pdbdb/onlinelog/group_13.288.1205149305        52428800
         2         13 STANDBY +DATA/pdbdb/onlinelog/group_13.288.1205149305        52428800
         2         13 STANDBY +DATA/pdbdb/onlinelog/group_13.288.1205149305        52428800
         2         13 STANDBY +DATA/pdbdb/onlinelog/group_13.288.1205149305        52428800
         2         13 STANDBY +DATA/pdbdb/onlinelog/group_13.289.1205149305        52428800
         2         13 STANDBY +DATA/pdbdb/onlinelog/group_13.289.1205149305        52428800
         2         13 STANDBY +DATA/pdbdb/onlinelog/group_13.289.1205149305        52428800
         2         13 STANDBY +DATA/pdbdb/onlinelog/group_13.289.1205149305        52428800
         2         14 STANDBY +DATA/pdbdb/onlinelog/group_14.290.1205149305        52428800
         2         14 STANDBY +DATA/pdbdb/onlinelog/group_14.290.1205149305        52428800
         2         14 STANDBY +DATA/pdbdb/onlinelog/group_14.290.1205149305        52428800
         2         14 STANDBY +DATA/pdbdb/onlinelog/group_14.290.1205149305        52428800
         2         14 STANDBY +DATA/pdbdb/onlinelog/group_14.291.1205149305        52428800
         2         14 STANDBY +DATA/pdbdb/onlinelog/group_14.291.1205149305        52428800
         2         14 STANDBY +DATA/pdbdb/onlinelog/group_14.291.1205149305        52428800
         2         14 STANDBY +DATA/pdbdb/onlinelog/group_14.291.1205149305        52428800

64 rows selected.

-- Step 14.05 -->> On Node 1 (Disable 3 Node)
SQL> ALTER DATABASE DISABLE THREAD 3;

SQL> create pfile='/home/oracle/spfilepdbdb.ora' from spfile;

File created.

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 15 -->> On Node 1 (DR - Remove added log files)
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jul 28 14:37:36 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

-- Step 15.01 -->> On Node 1 (DR - Remove added log files)
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED

-- Step 15.02 -->> On Node 1 (DR - Remove added log files)
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
        15          3   52428800
        15          3   52428800
        16          3   52428800
        16          3   52428800
        17          3   52428800
        17          3   52428800

18 rows selected.

-- Step 15.03 -->> On Node 1 (DR - Remove added log files)
--SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
SQL> ALTER SYSTEM SET STANDBY_FILE_MANAGEMENT=MANUAL;

-- To Clearing group
--SQL> ALTER DATABASE CLEAR LOGFILE GROUP 16;
-- If the corrupTredo log file has not been archived, use the UNARCHIVED keyword in the statement.
--SQL> ALTER DATABASE CLEAR UNARCHIVED LOGFILE GROUP 16;

-- Step 15.04 -->> On Node 1 (DR - Remove added log files)
SQL> alter database drop logfile group 15;
SQL> alter database drop logfile group 16;
SQL> alter database drop logfile group 17;
 
-- Step 15.05 -->> On Node 1 (DR - Remove added log files)
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

-- Step 15.06 -->> On Node 1 (DR - Remove added log files)
SQL> col member for a50
SQL> SELECT b.thread#,a.group#, a.type, a.member, b.bytes FROM gv$logfile a, gv$standby_log b WHERE a.group# = b.group# ORDER BY 2,4;

   THREAD#     GROUP# TYPE    MEMBER                                                  BYTES
---------- ---------- ------- -------------------------------------------------- ----------
         1          7 STANDBY +DATA/dr/onlinelog/group_7.274.1205153767            52428800
         1          7 STANDBY +DATA/dr/onlinelog/group_7.274.1205153767            52428800
         1          7 STANDBY +DATA/dr/onlinelog/group_7.274.1205153767            52428800
         1          7 STANDBY +DATA/dr/onlinelog/group_7.274.1205153767            52428800
         1          7 STANDBY +DATA/dr/onlinelog/group_7.275.1205153767            52428800
         1          7 STANDBY +DATA/dr/onlinelog/group_7.275.1205153767            52428800
         1          7 STANDBY +DATA/dr/onlinelog/group_7.275.1205153767            52428800
         1          7 STANDBY +DATA/dr/onlinelog/group_7.275.1205153767            52428800
         1          8 STANDBY +DATA/dr/onlinelog/group_8.276.1205153767            52428800
         1          8 STANDBY +DATA/dr/onlinelog/group_8.276.1205153767            52428800
         1          8 STANDBY +DATA/dr/onlinelog/group_8.276.1205153767            52428800
         1          8 STANDBY +DATA/dr/onlinelog/group_8.276.1205153767            52428800
         1          8 STANDBY +DATA/dr/onlinelog/group_8.277.1205153767            52428800
         1          8 STANDBY +DATA/dr/onlinelog/group_8.277.1205153767            52428800
         1          8 STANDBY +DATA/dr/onlinelog/group_8.277.1205153767            52428800
         1          8 STANDBY +DATA/dr/onlinelog/group_8.277.1205153767            52428800
         1          9 STANDBY +DATA/dr/onlinelog/group_9.278.1205153767            52428800
         1          9 STANDBY +DATA/dr/onlinelog/group_9.278.1205153767            52428800
         1          9 STANDBY +DATA/dr/onlinelog/group_9.278.1205153767            52428800
         1          9 STANDBY +DATA/dr/onlinelog/group_9.278.1205153767            52428800
         1          9 STANDBY +DATA/dr/onlinelog/group_9.279.1205153767            52428800
         1          9 STANDBY +DATA/dr/onlinelog/group_9.279.1205153767            52428800
         1          9 STANDBY +DATA/dr/onlinelog/group_9.279.1205153767            52428800
         1          9 STANDBY +DATA/dr/onlinelog/group_9.279.1205153767            52428800
         1         10 STANDBY +DATA/dr/onlinelog/group_10.280.1205153767           52428800
         1         10 STANDBY +DATA/dr/onlinelog/group_10.280.1205153767           52428800
         1         10 STANDBY +DATA/dr/onlinelog/group_10.280.1205153767           52428800
         1         10 STANDBY +DATA/dr/onlinelog/group_10.280.1205153767           52428800
         1         10 STANDBY +DATA/dr/onlinelog/group_10.281.1205153769           52428800
         1         10 STANDBY +DATA/dr/onlinelog/group_10.281.1205153769           52428800
         1         10 STANDBY +DATA/dr/onlinelog/group_10.281.1205153769           52428800
         1         10 STANDBY +DATA/dr/onlinelog/group_10.281.1205153769           52428800
         2         11 STANDBY +DATA/dr/onlinelog/group_11.282.1205153769           52428800
         2         11 STANDBY +DATA/dr/onlinelog/group_11.282.1205153769           52428800
         2         11 STANDBY +DATA/dr/onlinelog/group_11.282.1205153769           52428800
         2         11 STANDBY +DATA/dr/onlinelog/group_11.282.1205153769           52428800
         2         11 STANDBY +DATA/dr/onlinelog/group_11.283.1205153769           52428800
         2         11 STANDBY +DATA/dr/onlinelog/group_11.283.1205153769           52428800
         2         11 STANDBY +DATA/dr/onlinelog/group_11.283.1205153769           52428800
         2         11 STANDBY +DATA/dr/onlinelog/group_11.283.1205153769           52428800
         2         12 STANDBY +DATA/dr/onlinelog/group_12.284.1205153769           52428800
         2         12 STANDBY +DATA/dr/onlinelog/group_12.284.1205153769           52428800
         2         12 STANDBY +DATA/dr/onlinelog/group_12.284.1205153769           52428800
         2         12 STANDBY +DATA/dr/onlinelog/group_12.284.1205153769           52428800
         2         12 STANDBY +DATA/dr/onlinelog/group_12.285.1205153769           52428800
         2         12 STANDBY +DATA/dr/onlinelog/group_12.285.1205153769           52428800
         2         12 STANDBY +DATA/dr/onlinelog/group_12.285.1205153769           52428800
         2         12 STANDBY +DATA/dr/onlinelog/group_12.285.1205153769           52428800
         2         13 STANDBY +DATA/dr/onlinelog/group_13.286.1205153769           52428800
         2         13 STANDBY +DATA/dr/onlinelog/group_13.286.1205153769           52428800
         2         13 STANDBY +DATA/dr/onlinelog/group_13.286.1205153769           52428800
         2         13 STANDBY +DATA/dr/onlinelog/group_13.286.1205153769           52428800
         2         13 STANDBY +DATA/dr/onlinelog/group_13.287.1205153769           52428800
         2         13 STANDBY +DATA/dr/onlinelog/group_13.287.1205153769           52428800
         2         13 STANDBY +DATA/dr/onlinelog/group_13.287.1205153769           52428800
         2         13 STANDBY +DATA/dr/onlinelog/group_13.287.1205153769           52428800
         2         14 STANDBY +DATA/dr/onlinelog/group_14.288.1205153769           52428800
         2         14 STANDBY +DATA/dr/onlinelog/group_14.288.1205153769           52428800
         2         14 STANDBY +DATA/dr/onlinelog/group_14.288.1205153769           52428800
         2         14 STANDBY +DATA/dr/onlinelog/group_14.288.1205153769           52428800
         2         14 STANDBY +DATA/dr/onlinelog/group_14.289.1205153771           52428800
         2         14 STANDBY +DATA/dr/onlinelog/group_14.289.1205153771           52428800
         2         14 STANDBY +DATA/dr/onlinelog/group_14.289.1205153771           52428800
         2         14 STANDBY +DATA/dr/onlinelog/group_14.289.1205153771           52428800
         3         18 STANDBY +DATA/dr/onlinelog/group_18.312.1205581929           52428800
         3         18 STANDBY +DATA/dr/onlinelog/group_18.312.1205581929           52428800
         3         18 STANDBY +DATA/dr/onlinelog/group_18.312.1205581929           52428800
         3         18 STANDBY +DATA/dr/onlinelog/group_18.312.1205581929           52428800
         3         18 STANDBY +DATA/dr/onlinelog/group_18.346.1205581929           52428800
         3         18 STANDBY +DATA/dr/onlinelog/group_18.346.1205581929           52428800
         3         18 STANDBY +DATA/dr/onlinelog/group_18.346.1205581929           52428800
         3         18 STANDBY +DATA/dr/onlinelog/group_18.346.1205581929           52428800
         3         19 STANDBY +DATA/dr/onlinelog/group_19.322.1205581935           52428800
         3         19 STANDBY +DATA/dr/onlinelog/group_19.322.1205581935           52428800
         3         19 STANDBY +DATA/dr/onlinelog/group_19.322.1205581935           52428800
         3         19 STANDBY +DATA/dr/onlinelog/group_19.322.1205581935           52428800
         3         19 STANDBY +DATA/dr/onlinelog/group_19.324.1205581935           52428800
         3         19 STANDBY +DATA/dr/onlinelog/group_19.324.1205581935           52428800
         3         19 STANDBY +DATA/dr/onlinelog/group_19.324.1205581935           52428800
         3         19 STANDBY +DATA/dr/onlinelog/group_19.324.1205581935           52428800
         3         20 STANDBY +DATA/dr/onlinelog/group_20.313.1205581941           52428800
         3         20 STANDBY +DATA/dr/onlinelog/group_20.313.1205581941           52428800
         3         20 STANDBY +DATA/dr/onlinelog/group_20.313.1205581941           52428800
         3         20 STANDBY +DATA/dr/onlinelog/group_20.313.1205581941           52428800
         3         20 STANDBY +DATA/dr/onlinelog/group_20.326.1205581941           52428800
         3         20 STANDBY +DATA/dr/onlinelog/group_20.326.1205581941           52428800
         3         20 STANDBY +DATA/dr/onlinelog/group_20.326.1205581941           52428800
         3         20 STANDBY +DATA/dr/onlinelog/group_20.326.1205581941           52428800
         3         21 STANDBY +DATA/dr/onlinelog/group_21.334.1205581945           52428800
         3         21 STANDBY +DATA/dr/onlinelog/group_21.334.1205581945           52428800
         3         21 STANDBY +DATA/dr/onlinelog/group_21.334.1205581945           52428800
         3         21 STANDBY +DATA/dr/onlinelog/group_21.334.1205581945           52428800
         3         21 STANDBY +DATA/dr/onlinelog/group_21.335.1205581945           52428800
         3         21 STANDBY +DATA/dr/onlinelog/group_21.335.1205581945           52428800
         3         21 STANDBY +DATA/dr/onlinelog/group_21.335.1205581945           52428800
         3         21 STANDBY +DATA/dr/onlinelog/group_21.335.1205581945           52428800

96 rows selected.

-- Step 15.07 -->> On Node 1 (DR - Remove added log files)
SQL> alter database drop standby logfile group 18;
SQL> alter database drop standby logfile group 19;
SQL> alter database drop standby logfile group 20;
SQL> alter database drop standby logfile group 21;

-- Step 15.08 -->> On Node 1 (DR - Remove added log files)
SQL> col member for a50
SQL> SELECT b.thread#,a.group#, a.type, a.member, b.bytes FROM gv$logfile a, gv$standby_log b WHERE a.group# = b.group# ORDER BY 2,4;

   THREAD#     GROUP# TYPE    MEMBER                                                  BYTES
---------- ---------- ------- -------------------------------------------------- ----------
         1          7 STANDBY +DATA/dr/onlinelog/group_7.274.1205153767            52428800
         1          7 STANDBY +DATA/dr/onlinelog/group_7.274.1205153767            52428800
         1          7 STANDBY +DATA/dr/onlinelog/group_7.274.1205153767            52428800
         1          7 STANDBY +DATA/dr/onlinelog/group_7.274.1205153767            52428800
         1          7 STANDBY +DATA/dr/onlinelog/group_7.275.1205153767            52428800
         1          7 STANDBY +DATA/dr/onlinelog/group_7.275.1205153767            52428800
         1          7 STANDBY +DATA/dr/onlinelog/group_7.275.1205153767            52428800
         1          7 STANDBY +DATA/dr/onlinelog/group_7.275.1205153767            52428800
         1          8 STANDBY +DATA/dr/onlinelog/group_8.276.1205153767            52428800
         1          8 STANDBY +DATA/dr/onlinelog/group_8.276.1205153767            52428800
         1          8 STANDBY +DATA/dr/onlinelog/group_8.276.1205153767            52428800
         1          8 STANDBY +DATA/dr/onlinelog/group_8.276.1205153767            52428800
         1          8 STANDBY +DATA/dr/onlinelog/group_8.277.1205153767            52428800
         1          8 STANDBY +DATA/dr/onlinelog/group_8.277.1205153767            52428800
         1          8 STANDBY +DATA/dr/onlinelog/group_8.277.1205153767            52428800
         1          8 STANDBY +DATA/dr/onlinelog/group_8.277.1205153767            52428800
         1          9 STANDBY +DATA/dr/onlinelog/group_9.278.1205153767            52428800
         1          9 STANDBY +DATA/dr/onlinelog/group_9.278.1205153767            52428800
         1          9 STANDBY +DATA/dr/onlinelog/group_9.278.1205153767            52428800
         1          9 STANDBY +DATA/dr/onlinelog/group_9.278.1205153767            52428800
         1          9 STANDBY +DATA/dr/onlinelog/group_9.279.1205153767            52428800
         1          9 STANDBY +DATA/dr/onlinelog/group_9.279.1205153767            52428800
         1          9 STANDBY +DATA/dr/onlinelog/group_9.279.1205153767            52428800
         1          9 STANDBY +DATA/dr/onlinelog/group_9.279.1205153767            52428800
         1         10 STANDBY +DATA/dr/onlinelog/group_10.280.1205153767           52428800
         1         10 STANDBY +DATA/dr/onlinelog/group_10.280.1205153767           52428800
         1         10 STANDBY +DATA/dr/onlinelog/group_10.280.1205153767           52428800
         1         10 STANDBY +DATA/dr/onlinelog/group_10.280.1205153767           52428800
         1         10 STANDBY +DATA/dr/onlinelog/group_10.281.1205153769           52428800
         1         10 STANDBY +DATA/dr/onlinelog/group_10.281.1205153769           52428800
         1         10 STANDBY +DATA/dr/onlinelog/group_10.281.1205153769           52428800
         1         10 STANDBY +DATA/dr/onlinelog/group_10.281.1205153769           52428800
         2         11 STANDBY +DATA/dr/onlinelog/group_11.282.1205153769           52428800
         2         11 STANDBY +DATA/dr/onlinelog/group_11.282.1205153769           52428800
         2         11 STANDBY +DATA/dr/onlinelog/group_11.282.1205153769           52428800
         2         11 STANDBY +DATA/dr/onlinelog/group_11.282.1205153769           52428800
         2         11 STANDBY +DATA/dr/onlinelog/group_11.283.1205153769           52428800
         2         11 STANDBY +DATA/dr/onlinelog/group_11.283.1205153769           52428800
         2         11 STANDBY +DATA/dr/onlinelog/group_11.283.1205153769           52428800
         2         11 STANDBY +DATA/dr/onlinelog/group_11.283.1205153769           52428800
         2         12 STANDBY +DATA/dr/onlinelog/group_12.284.1205153769           52428800
         2         12 STANDBY +DATA/dr/onlinelog/group_12.284.1205153769           52428800
         2         12 STANDBY +DATA/dr/onlinelog/group_12.284.1205153769           52428800
         2         12 STANDBY +DATA/dr/onlinelog/group_12.284.1205153769           52428800
         2         12 STANDBY +DATA/dr/onlinelog/group_12.285.1205153769           52428800
         2         12 STANDBY +DATA/dr/onlinelog/group_12.285.1205153769           52428800
         2         12 STANDBY +DATA/dr/onlinelog/group_12.285.1205153769           52428800
         2         12 STANDBY +DATA/dr/onlinelog/group_12.285.1205153769           52428800
         2         13 STANDBY +DATA/dr/onlinelog/group_13.286.1205153769           52428800
         2         13 STANDBY +DATA/dr/onlinelog/group_13.286.1205153769           52428800
         2         13 STANDBY +DATA/dr/onlinelog/group_13.286.1205153769           52428800
         2         13 STANDBY +DATA/dr/onlinelog/group_13.286.1205153769           52428800
         2         13 STANDBY +DATA/dr/onlinelog/group_13.287.1205153769           52428800
         2         13 STANDBY +DATA/dr/onlinelog/group_13.287.1205153769           52428800
         2         13 STANDBY +DATA/dr/onlinelog/group_13.287.1205153769           52428800
         2         13 STANDBY +DATA/dr/onlinelog/group_13.287.1205153769           52428800
         2         14 STANDBY +DATA/dr/onlinelog/group_14.288.1205153769           52428800
         2         14 STANDBY +DATA/dr/onlinelog/group_14.288.1205153769           52428800
         2         14 STANDBY +DATA/dr/onlinelog/group_14.288.1205153769           52428800
         2         14 STANDBY +DATA/dr/onlinelog/group_14.288.1205153769           52428800
         2         14 STANDBY +DATA/dr/onlinelog/group_14.289.1205153771           52428800
         2         14 STANDBY +DATA/dr/onlinelog/group_14.289.1205153771           52428800
         2         14 STANDBY +DATA/dr/onlinelog/group_14.289.1205153771           52428800
         2         14 STANDBY +DATA/dr/onlinelog/group_14.289.1205153771           52428800

-- Step 15.09 -->> On Node 1 (DR - Remove added log files)
SQL> ALTER SYSTEM SET STANDBY_FILE_MANAGEMENT=AUTO;

-- Step 15.10 -->> On Node 1 (DR - Remove added log files)
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;

-- Step 15.11 -->> On Node 1 (DR - Remove added log files)
SQL> SELECT inst_id,process,thread#,sequence#,block#,status FROM gv$managed_standby;

   INST_ID PROCESS      THREAD#  SEQUENCE#     BLOCK# STATUS
---------- --------- ---------- ---------- ---------- ------------
         1 ARCH               3        118          1 CLOSING
         1 ARCH               3        133       6144 CLOSING
         1 ARCH               0          0          0 CONNECTED
         1 ARCH               3        120          1 CLOSING
         1 ARCH               3        134          1 CLOSING
         1 ARCH               3        122          1 CLOSING
         1 ARCH               3        123          1 CLOSING
         1 ARCH               3        124          1 CLOSING
         1 ARCH               3        125          1 CLOSING
         1 ARCH               3        135          1 CLOSING
         1 ARCH               1        181      59392 CLOSING
         1 ARCH               3        126       2048 CLOSING
         1 ARCH               1        207          1 CLOSING
         1 ARCH               3        136          1 CLOSING
         1 ARCH               3        128          1 CLOSING
         1 ARCH               1        210          1 CLOSING
         1 ARCH               3        129          1 CLOSING
         1 ARCH               3        130          1 CLOSING
         1 ARCH               1        229          1 CLOSING
         1 ARCH               1        214          1 CLOSING
         1 ARCH               1        215          1 CLOSING
         1 ARCH               1        216          1 CLOSING
         1 ARCH               3        131          1 CLOSING
         1 ARCH               3        112          1 CLOSING
         1 ARCH               3        113          1 CLOSING
         1 ARCH               3        132          1 CLOSING
         1 ARCH               3        114          1 CLOSING
         1 ARCH               3        115          1 CLOSING
         1 ARCH               3        116          1 CLOSING
         1 ARCH               3        117          1 CLOSING
         1 RFS                0          0          0 IDLE
         1 RFS                0          0          0 IDLE
         1 MRP0               2        213         16 APPLYING_LOG
         1 RFS                0          0          0 IDLE
         2 ARCH               2        210          1 CLOSING
         2 ARCH               1        243          1 CLOSING
         2 ARCH               1        244          1 CLOSING
         2 ARCH               2        211          1 CLOSING
         2 ARCH               0          0          0 CONNECTED
         2 ARCH               2        212          1 CLOSING
         2 ARCH               1        231       8192 CLOSING
         2 ARCH               1        232          1 CLOSING
         2 ARCH               2        199          1 CLOSING
         2 ARCH               1        233          1 CLOSING
         2 ARCH               2        200          1 CLOSING
         2 ARCH               2        201          1 CLOSING
         2 ARCH               1        234          1 CLOSING
         2 ARCH               1        235          1 CLOSING
         2 ARCH               3        137          1 CLOSING
         2 ARCH               1        236      10240 CLOSING
         2 ARCH               2        202       8192 CLOSING
         2 ARCH               2        203          1 CLOSING
         2 ARCH               2        204          1 CLOSING
         2 ARCH               2        205          1 CLOSING
         2 ARCH               1        237          1 CLOSING
         2 ARCH               1        238          1 CLOSING
         2 ARCH               1        239          1 CLOSING
         2 ARCH               1        240          1 CLOSING
         2 ARCH               2        206          1 CLOSING
         2 ARCH               1        241       2048 CLOSING
         2 ARCH               1        242          1 CLOSING
         2 ARCH               2        207       2048 CLOSING
         2 ARCH               2        208          1 CLOSING
         2 ARCH               2        209          1 CLOSING
         2 RFS                0          0          0 IDLE
         2 RFS                0          0          0 IDLE
         2 RFS                0          0          0 IDLE
         2 RFS                0          0          0 IDLE
         2 RFS                0          0          0 IDLE
         2 RFS                0          0          0 IDLE
         2 RFS                0          0          0 IDLE
         2 RFS                2        213         17 IDLE
         2 RFS                0          0          0 IDLE
         2 RFS                1        245         18 IDLE
         2 RFS                0          0          0 IDLE
         2 RFS                0          0          0 IDLE
         2 RFS                0          0          0 IDLE

74 rows selected.

-- Step 15.12 -->> On Node 1 (DR - Remove added log files)
-- The third last applied logs seen from Oracle DataDictionary Vew only
SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           244          1
           212          2
           138          3

-- Step 15.13 -->> On Node 1 (DR - Remove added log files)
-- The third last applied logs seen from Oracle DataDictionary Vew only
SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           244          1
           211          2
           138          3

-->> Note: In Case of 15,16,17 log not delete and throw error like
-->>Syntax
-->> alter database drop logfile group 15;
-->> alter database drop logfile group 16;
-->> alter database drop logfile group 17;
-->>Issue
-->> ERROR at line 1:
-->> ORA-01567: dropping log 16 would leave less than 2 log files for instance UNNAMED_INSTANCE_3 (thread 3)
-->> ORA-00312: online log 16 thread 3: '+DATA/dr/onlinelog/group_16.318.1207666015'
-->> ORA-00312: online log 16 thread 3: '+DATA/dr/onlinelog/group_16.402.1207666015'
-->>Rosolution
-->> Then we need Manully Switch over DC to DR and drop after disabling node 3 "ALTER DATABASE DISABLE THREAD 3" and then revert DC as DC and DR as DR

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 16 -->> On Node 3
[root@pdb3 ~]$ init 0

-- Step 17 -->> On Node 3
-- Remove the added shared drive after server down.