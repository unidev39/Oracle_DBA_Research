-- Steup the shared storage using Openfiler (openfileresa-2.99.1-x86_64-disc1) - (SAN/NAS)
/*
-- Primary Database Server (DC)
data_pdb 40960
fra_pdb  25600
ocr_pdb  20480

-- Standby Database Server (DR)
data_sdb 40960
fra_sdb  25600
ocr_sdb  20480
*/

-- Openfiler Configuration Steps for One Node Rac Setup (DC & DR)
[root@openfiler ~]# df -h
/*
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda2             7.5G  1.4G  5.8G   20% /
tmpfs                 491M  208K  490M   1% /dev/shm
/dev/sda1             289M   23M  252M   9% /boot
*/

-- Step 1 -->> On Openfiler (SAN/NAS Storage)
[root@openfiler ~]# vi /etc/hosts
/*
# Public
192.168.1.105   rac_pdb.mydoamin          rac_pdb
192.168.1.106   rac_sdb.mydoamin          rac_sdb

# Private
192.168.1.102     rac_pdb-priv.mydoamin   rac_pdb-priv
192.168.1.103     rac_sdb-priv.mydoamin   rac_sdb-priv

# Virtual
192.168.1.107   rac_pdb-vip.mydoamin     rac_pdb-vip
192.168.1.108   rac_sdb-vip.mydoamin     rac_sdb-vip

# Openfiler (SAN/NAS Storage)
192.168.1.104   openfiler.mydoamin   openfiler

# SCAN (DC)
192.168.1.109   rac-scan.mydoamin    rac-scan
192.168.1.110   rac-scan.mydoamin    rac-scan

# SCAN (DR)
192.168.1.120   rac-scandr.mydoamin       rac-scandr
192.168.1.121   rac-scandr.mydoamin       rac-scandr
*/

-- Step 2 -->> On Openfiler (SAN/NAS Storage)
[root@openfiler ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth0 
/*
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.1.104
NETMASK=255.255.255.0
GATEWAY=192.168.1.6
DNS1=192.168.1.16
DNS2=192.168.1.2
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
*/

-- Step 3 -->> On Openfiler (SAN/NAS Storage)
[root@openfiler ~]# service network restart

-- Step 4 -->> On Openfiler (SAN/NAS Storage)
-- Disabling the firewall.
[root@openfiler ~]# chkconfig --list iptables
/*
iptables  0:off    1:off    2:on    3:on    4:on    5:on    6:off
*/
[root@openfiler ~]# service iptables stop
/*
iptables: Setting chains to policy ACCEPT: nat mangle filte[  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
*/
[root@openfiler ~]# chkconfig iptables off
[root@openfiler ~]# iptables -F
[root@openfiler ~]# service iptables save
/*
iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]
*/
[root@openfiler ~]# /etc/init.d/iptables stop
/*
iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
*/
[root@openfiler ~]# iptables -L
/*
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
*/

[root@openfiler ~]# chkconfig --list iptables
/*
iptables   0:off    1:off    2:off    3:off    4:off    5:off    6:off
*/ 

-- Step 5 -->> On Openfiler (SAN/NAS Storage)
-- ntpd disable
[root@openfiler ~]# service ntpd stop
/*
Shutting down ntpd:                                        [FAILED]
*/

[root@openfiler ~]# service ntpd status
/*
ntpd is stopped
*/

[root@openfiler ~]# chkconfig ntpd off
[root@openfiler ~]# mv /etc/ntp.conf /etc/ntp.conf.backup
[root@openfiler ~]# rm /etc/ntp.conf
[root@openfiler ~]# rm /var/run/ntpd.pid

-- Step 6 -->> On Openfiler (SAN/NAS Storage)
[root@openfiler ~]# init 6


--------------------------------------------------------------------------------------------------------------------
-------------One Node Rac Setup on VM Workstation from Primary (DC) and Standby (DR) Database Servers---------------
--------------------------------------------------------------------------------------------------------------------

-- 1 Node Rac on VM -->> On both Primary (DC) and Standby (DR) Database Servers
[root@rac_pdb/rac_sdb ~]# df -h
/*
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda2              15G  718M   13G   6% /
tmpfs                1004M  272K 1004M   1% /dev/shm
/dev/sda1             9.7G  197M  9.0G   3% /boot
/dev/sda8             9.7G  151M  9.0G   2% /home
/dev/sda9             9.7G  160M  9.0G   2% /tmp
/dev/sda3              23G  172M   22G   1% /u01
/dev/sda5              13G  7.8G  4.2G  66% /usr
/dev/sda6              11G  1.8G  8.3G  18% /var
.host:/                82G   57G   26G  69% /mnt/hgfs
/dev/sr0              3.5G  3.5G     0 100% /media/OL6.4 x86_64 Disc 1 20130225
*/

-- Step 7 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.168.1.105   rac_pdb.mydoamin          rac_pdb
                                           
# Private                                  
192.168.1.102     rac_pdb-priv.mydoamin     rac_pdb-priv
                                           
# Virtual                                  
192.168.1.107   rac_pdb-vip.mydoamin      rac_pdb-vip

# Openfiler (SAN/NAS Storage)
192.168.1.104   openfiler.mydoamin      openfiler
                                           
# SCAN                                     
192.168.1.109   rac-scan.mydoamin       rac-scan
192.168.1.110   rac-scan.mydoamin       rac-scan
*/

-- Step 8 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.168.1.106   rac_sdb.mydoamin         rac_sdb

# Private
192.168.1.103   rac_sdb-priv.mydoamin      rac_sdb-priv

# Virtual
192.168.1.108   rac_sdb-vip.mydoamin     rac_sdb-vip

# Openfiler (SAN/NAS Storage)
192.168.1.104   openfiler.mydoamin       openfiler

# SCAN
192.168.1.120   rac-scandr.mydoamin      rac-scandr
192.168.1.121   rac-scandr.mydoamin      rac-scandr
*/

-- Step 9 -->> On both Primary (DC) and Standby (DR) Database Servers
-- Disable secure linux by editing the "/etc/selinux/config" file, making sure the SELINUX flag is set as follows.
[root@rac_pdb/rac_sdb ~]# vim /etc/selinux/config
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

-- Step 10 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth0 
/*
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.1.105
NETMASK=255.255.255.0
GATEWAY=192.168.1.6
DNS1=192.168.1.16
DNS2=192.168.1.2
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
*/

-- Step 11 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth1
/*
DEVICE=eth1
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.1.102
NETMASK=255.255.255.0
GATEWAY=192.168.1.6
DNS1=192.168.1.16
DNS2=192.168.1.2
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
*/

-- Step 12 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth0 
/*
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.1.106
NETMASK=255.255.255.0
GATEWAY=192.168.1.6
DNS1=192.168.1.16
DNS2=192.168.1.2
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
*/

-- Step 13 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth1
/*
DEVICE=eth1
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.1.103
NETMASK=255.255.255.0
GATEWAY=192.168.1.6
DNS1=192.168.1.16
DNS2=192.168.1.2
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
*/
-- Step 14 -->> On both Primary (DC) and Standby (DR) Database Servers
[root@rac_pdb/rac_sdb ~]# service network restart

-- Step 15 -->> On both Primary (DC) and Standby (DR) Database Servers
-- disabling the firewall.
[root@rac_pdb/rac_sdb ~]# chkconfig --list iptables
/*
iptables  0:off    1:off    2:on    3:on    4:on    5:on    6:off
*/
[root@rac_pdb/rac_sdb ~]# service iptables stop
/*
iptables: Setting chains to policy ACCEPT: nat mangle filte[  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
*/
[root@rac_pdb/rac_sdb ~]# chkconfig iptables off
[root@rac_pdb/rac_sdb ~]# iptables -F
[root@rac_pdb/rac_sdb ~]# service iptables save
/*
iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]
*/
[root@rac_pdb/rac_sdb ~]# /etc/init.d/iptables stop
/*
iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
*/
[root@rac_pdb/rac_sdb ~]# iptables -L
/*
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
*/

[root@rac_pdb/rac_sdb ~]# chkconfig --list iptables
/*
iptables   0:off    1:off    2:off    3:off    4:off    5:off    6:off
*/ 

-- Step 16 -->> On both Primary (DC) and Standby (DR) Database Servers
-- ntpd disable
[root@rac_pdb/rac_sdb ~]# service ntpd stop
/*
Shutting down ntpd:                                        [FAILED]
*/

[root@rac_pdb/rac_sdb ~]# service ntpd status
/*
ntpd is stopped
*/

[root@rac_pdb/rac_sdb ~]# chkconfig ntpd off
[root@rac_pdb/rac_sdb ~]# mv /etc/ntp.conf /etc/ntp.conf.backup
[root@rac_pdb/rac_sdb ~]# rm /etc/ntp.conf
[root@rac_pdb/rac_sdb ~]# rm /var/run/ntpd.pid

-- Step 17 -->> On both Primary (DC) and Standby (DR) Database Servers
[root@rac_pdb/rac_sdb ~]# init 6

-- Step 18 -->> On both Primary (DC) and Standby (DR) Database Servers
-- Perform either the Automatic Setup or the Manual Setup to complete the basic prerequisites. 
-- The Additional Setup is required for all installations.
[root@rac_pdb/rac_sdb ~]# cd /media/OL6.4\ x86_64\ Disc\ 1\ 20130225/Server/Packages/
[root@rac_pdb/rac_sdb Packages]# yum install oracle-rdbms-server-11gR2-preinstall
[root@rac_pdb/rac_sdb Packages]# yum update

-- Step 19 -->> On both Primary (DC) and Standby (DR) Database Servers
-- Manual tup the relevant RPMS
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh binutils-2*x86_64*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh glibc-2*x86_64* nss-softokn-freebl-3*x86_64*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh glibc-2*i686* nss-softokn-freebl-3*i686*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh compat-libstdc++-33*x86_64*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh glibc-common-2*x86_64*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh glibc-devel-2*x86_64*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh glibc-devel-2*i686*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh glibc-headers-2*x86_64*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh elfutils-libelf-0*x86_64*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh elfutils-libelf-devel-0*x86_64*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh gcc-4*x86_64*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh gcc-c++-4*x86_64*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh ksh-*x86_64*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh libaio-0*x86_64*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh libaio-devel-0*x86_64*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh libaio-0*i686*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh libaio-devel-0*i686*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh libgcc-4*x86_64*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh libgcc-4*i686*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh libstdc++-4*x86_64*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh libstdc++-4*i686*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh libstdc++-devel-4*x86_64*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh make-3.81*x86_64*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh numactl-devel-2*x86_64*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh sysstat-9*x86_64*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh compat-libstdc++-33*i686*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh compat-libcap*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh libaio-devel-0.*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh ksh-2*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh libstdc++-4.*.i686*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh elfutils-libelf-0*i686* elfutils-libelf-devel-0*i686*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh libtool-ltdl*i686*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh ncurses*i686*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh readline*i686*
[root@rac_pdb/rac_sdb Packages]# rpm -iUvh unixODBC*
[root@rac_pdb/rac_sdb Packages]# rpm -Uvh oracleasm*.rpm
[root@rac_pdb/rac_sdb Packages]# rpm -q binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel elfutils-libelf-devel-static \
[root@rac_pdb/rac_sdb Packages]# rpm -q gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers kernel-headers ksh libaio libaio-devel \
[root@rac_pdb/rac_sdb Packages]# rpm -q libgcc libgomp libstdc++ libstdc++-devel make numactl-devel sysstat unixODBC unixODBC-devel

-- Step 20 -->> On both Primary (DC) and Standby (DR) Database Servers
-- Pre-Installation Steps for ASM
[root@rac_pdb/rac_sdb ~ ]# cd /etc/yum.repos.d
[root@rac_pdb/rac_sdb yum.repos.d]# uname -a
/*
Linux rac_pdb/rac_sdb.mydoamin 2.6.39-400.313.1.el6uek.x86_64 #1 SMP Thu Aug 8 15:49:52 PDT 2019 x86_64 x86_64 x86_64 GNU/Linux
*/

[root@rac_pdb/rac_sdb yum.repos.d]# cat /etc/os-release 
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

[root@rac_pdb/rac_sdb yum.repos.d]# wget https://public-yum.oracle.com/public-yum-ol6.repo
/*
--2019-09-02 13:50:54--  https://public-yum.oracle.com/public-yum-ol6.repo
Resolving public-yum.oracle.com... 104.84.157.171
Connecting to public-yum.oracle.com|104.84.157.171|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 12045 (12K) [text/plain]
Saving to: “public-yum-ol6.repo.2”

100%[======================================>] 12,045      --.-K/s   in 0s      

2019-09-02 13:50:55 (95.3 MB/s) - “public-yum-ol6.repo” saved [12045/12045]
*/
[root@rac_pdb/rac_sdb yum.repos.d]# ls
/*
oracle-linux-ol6.repo.disabled  public-yum-ol6.repo    public-yum-ol6.repo.2
packagekit-media.repo           public-yum-ol6.repo.1  uek-ol6.repo.disabled
*/

[root@rac_pdb/rac_sdb yum.repos.d]# yum install kmod-oracleasm
[root@rac_pdb/rac_sdb yum.repos.d]# yum install oracleasm-support
/*
Loaded plugins: aliases, changelog, kabi, presto, refresh-packagekit, security,
              : tmprepo, ulninfo, verify, versionlock
Loading support for kernel ABI
Setting up Install Process
Package oracleasm-support-2.1.11-2.el6.x86_64 already installed and latest version
Nothing to do
*/

-- Step 21 -->> On both Primary (DC) and Standby (DR) Database Servers
-- Need to dounload (oracleasmlib-2.0.4-1.el5.i386.rpm : https://oracle-base.com/articles/11g/oracle-db-11gr2-rac-installation-on-oel5-using-virtualbox | http://www.hblsoft.org/hwl/1326.html)
[root@rac_pdb/rac_sdb yum.repos.d]# cd /mnt/hgfs/Oracle_Software/OracleASM_Package/
[root@rac_pdb/rac_sdb OracleASM_Package]# ls
/*
elfutils-libelf-devel-static-0.164-2.el6.x86_64.rpm
oracleasmlib-2.0.4-1.el6.x86_64.rpm
*/
[root@rac_pdb/rac_sdb OracleASM_Package]# rpm -iUvh oracleasmlib-2.0.4-1.el6.x86_64.rpm
/*
Preparing...                ########################################### [100%]
    package oracleasmlib-2.0.4-1.el6.x86_64 is already installed
*/
[root@rac_pdb/rac_sdb OracleASM_Package]# rpm -iUvh elfutils-libelf-devel-static-0.164-2.el6.x86_64.rpm
/*
Preparing...                ########################################### [100%]
   1:elfutils-libelf-devel-s########################################### [100%]
*/

-- Step 22 -->> On both Primary (DC) and Standby (DR) Database Servers
-- Orcle ASM Configuration
[root@rac_pdb/rac_sdb ~]# rpm -qa | grep -i oracleasm
/*
kmod-oracleasm-2.0.8-16.1.el6_10.x86_64
oracleasmlib-2.0.4-1.el6.x86_64
oracleasm-support-2.1.11-2.el6.x86_64
*/

-- Step 23 -->> On both Primary (DC) and Standby (DR) Database Servers
-- Add the kernel parameters file "/etc/sysctl.conf" and add oracle recommended kernel parameters
[root@rac_pdb/rac_sdb ~]# vim /etc/sysctl.conf
/*
net.ipv4.ip_forward = 0
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
net.ipv4.tcp_syncookies = 1
net.bridge.bridge-nf-call-ip6tables = 0
net.bridge.bridge-nf-call-iptables = 0
net.bridge.bridge-nf-call-arptables = 0
kernel.msgmnb = 65536
kernel.msgmax = 65536
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

-- Run the following command to change the current kernel parameters.
[root@rac_pdb/rac_sdb ~]# /sbin/sysctl -p

-- Step 24 -->> On both Primary (DC) and Standby (DR) Database Servers
-- Edit “/etc/security/limits.conf” file to limit user processes
[root@rac_pdb/rac_sdb ~]# vim /etc/security/limits.conf
/*
oracle   soft   nofile  65536
oracle   hard   nofile  65536
oracle   soft   nproc   16384
oracle   hard   nproc   16384
oracle   soft   stack   10240
oracle   hard   stack   32768
oracle   hard   memlock 134217728
oracle   soft   memlock 134217728

grid    soft    nproc    16384
grid    hard    nproc    16384
grid    soft    nofile   65536
grid    hard    nofile   65536
grid    soft    stack    10240
grid    soft    memlock  134217728
grid    hard    memlock  134217728
*/


-- Step 25 -->> On both Primary (DC) and Standby (DR) Database Servers
-- Add the following line to the "/etc/pam.d/login" file, if it does not already exist.
[root@rac_pdb/rac_sdb ~]# vim /etc/pam.d/login
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
session    required     pam_limits.so
*/


-- Step 26 -->> On both Primary (DC) and Standby (DR) Database Servers
-- Create the new groups and users.
[root@rac_pdb/rac_sdb ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:
*/
[root@rac_pdb/rac_sdb ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:oracle
*/
[root@rac_pdb/rac_sdb !]# cat /etc/group | grep -i asm

-- 1.Create OS groups using the command below. Enter these commands as the 'root' user:
[root@rac_pdb/rac_sdb ~]# /usr/sbin/groupadd -g 503 oper
[root@rac_pdb/rac_sdb ~]# /usr/sbin/groupadd -g 504 asmadmin
[root@rac_pdb/rac_sdb ~]# /usr/sbin/groupadd -g 506 asmdba
[root@rac_pdb/rac_sdb ~]# /usr/sbin/groupadd -g 507 asmoper
[root@rac_pdb/rac_sdb ~]# /usr/sbin/groupadd -g 508 beoper

-- 2.Create the users that will own the Oracle software using the commands:
[root@rac_pdb/rac_sdb ~]# /usr/sbin/useradd -g oinstall -G oinstall,dba,asmadmin,asmdba,asmoper,beoper grid
[root@rac_pdb/rac_sdb ~]# /usr/sbin/usermod -g oinstall -G oinstall,dba,asmadmin,asmdba,asmoper,beoper grid
[root@rac_pdb/rac_sdb ~]# /usr/sbin/useradd -g oinstall -G oinstall,dba,oper,asmdba,asmadmin oracle
[root@rac_pdb/rac_sdb ~]# /usr/sbin/usermod -g oinstall -G oinstall,dba,oper,asmdba,asmadmin oracle

[root@rac_pdb/rac_sdb ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/
[root@rac_pdb/rac_sdb ~]# cat /etc/group | grep -i oracle
/*
oinstall:x:54321:grid,oracle
dba:x:54322:oracle,grid
oper:x:503:oracle
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
*/
[root@rac_pdb/rac_sdb ~]# cat /etc/group | grep -i grid
/*
oinstall:x:54321:grid,oracle
dba:x:54322:oracle,grid
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

[root@rac_pdb/rac_sdb ~]# passwd oracle
/*
Changing password for user oracle.
New password: 
BAD PASSWORD: it is based on a dictionary word
BAD PASSWORD: is too simple
Retype new password: 
passwd: all authentication tokens updated successfully.
*/
[root@rac_pdb/rac_sdb ~]# passwd grid
/*
Changing password for user grid.
New password: 
BAD PASSWORD: it is too short
BAD PASSWORD: is too simple
Retype new password: 
passwd: all authentication tokens updated successfully.
*/
[root@rac_pdb/rac_sdb ~]# su - oracle
[oracle@rac_pdb/rac_sdb ~]$ su - grid
/*
Password: 
*/
[grid@rac_pdb/rac_sdb ~]$ su - root
/*
Password: 
*/

-- Step 27 -->> On both Primary (DC) and Standby (DR) Database Servers
--1.Create the Oracle Inventory Director:
[root@rac_pdb/rac_sdb ~]# mkdir -p /u01/app/oraInventory
[root@rac_pdb/rac_sdb ~]# chown -R grid:oinstall /u01/app/oraInventory
[root@rac_pdb/rac_sdb ~]# chmod -R 775 /u01/app/oraInventory

--2.Creating the Oracle Grid Infrastructure Home Directory:
[root@rac_pdb/rac_sdb ~]# mkdir -p /u01/11.2.0.3.0/grid
[root@rac_pdb/rac_sdb ~]# chown -R grid:oinstall /u01/11.2.0.3.0/grid
[root@rac_pdb/rac_sdb ~]# chmod -R 775 /u01/11.2.0.3.0/grid

--3.Creating the Oracle Base Directory
[root@rac_pdb/rac_sdb ~]# mkdir -p /u01/app/oracle
[root@rac_pdb/rac_sdb ~]# mkdir /u01/app/oracle/cfgtoollogs
[root@rac_pdb/rac_sdb ~]# chown -R oracle:oinstall /u01/app/oracle
[root@rac_pdb/rac_sdb ~]# chmod -R 775 /u01/app/oracle
[root@rac_pdb/rac_sdb ~]# chown -R grid:oinstall /u01/app/oracle/cfgtoollogs
[root@rac_pdb/rac_sdb ~]# chmod -R 775 /u01/app/oracle/cfgtoollogs

--4.Creating the Oracle RDBMS Home Directory
[root@rac_pdb/rac_sdb ~]# mkdir -p /u01/app/oracle/product/11.2.0.3.0/db_1
[root@rac_pdb/rac_sdb ~]# chown -R oracle:oinstall /u01/app/oracle/product/11.2.0.3.0/db_1
[root@rac_pdb/rac_sdb ~]# chmod -R 775 /u01/app/oracle/product/11.2.0.3.0/db_1

[root@rac_pdb/rac_sdb ~]# cd /u01/app/oracle
[root@rac_pdb/rac_sdb oracle]# chown -R oracle:oinstall product/
[root@rac_pdb/rac_sdb oracle]# chmod -R 775 product/
[root@rac_pdb/rac_sdb oracle]# 

-- Step 28 -->> On both Primary (DC) and Standby (DR) Database Servers
--Make the following changes to the default shell startup file, add the following lines to the /etc/profile file:
[root@rac_pdb/rac_sdb ~]# vim /etc/profile
/*
if [ $USER = "oracle" ]; then
           if [ $SHELL = "/bin/ksh" ]; then
              ulimit -p 16384
              ulimit -n 65536
           else
              ulimit -u 16384 -n 65536
           fi
fi

if [ $USER = "grid" ]; then
           if [ $SHELL = "/bin/ksh" ]; then
              ulimit -p 16384
              ulimit -n 65536
           else
              ulimit -u 16384 -n 65536
           fi
fi
*/

-- Step 29 -->> On both Primary (DC) and Standby (DR) Database Servers
-- For the C shell (csh or tcsh), add the following lines to the /etc/csh.login file:
[root@rac_pdb/rac_sdb ~]# vim /etc/csh.login
/*
if ( $USER == "oracle" ) then
          limit maxproc 16384
          limit descriptors 65536
endif

if ( $USER == "grid" ) then
          limit maxproc 16384
          limit descriptors 65536
endif
*/

-- Step 30 -->> On both Primary (DC) and Standby (DR) Database Servers
[root@rac_pdb/rac_sdb ~]# mkdir -p /home/grid/grid_software
[root@rac_pdb/rac_sdb ~]# mkdir -p /home/oracle/oracle_software

-- Step 31 -->> On both Primary (DC) and Standby (DR) Database Servers
-- Unzip the files.
[root@rac_pdb/rac_sdb oracle]# cd
[root@rac_pdb/rac_sdb ~]# cd /mnt/hgfs/Oracle_Software/Oracle\ Db\ 11.2.0.3.0\ \(64-bit\ -\ Linux\)/
[root@rac_pdb/rac_sdb Oracle Db 11.2.0.3.0 (64-bit - Linux)]# ls
/*
p10404530_112030_Linux-x86-64_1of7.zip  p10404530_112030_Linux-x86-64_3of7-Clusterware.zip
p10404530_112030_Linux-x86-64_2of7.zip  software_patch
*/
[root@rac_pdb/rac_sdb Oracle Db 11.2.0.3.0 (64-bit - Linux)]# unzip p10404530_112030_Linux-x86-64_1of7.zip -d /home/oracle/oracle_software/
[root@rac_pdb/rac_sdb Oracle Db 11.2.0.3.0 (64-bit - Linux)]# unzip p10404530_112030_Linux-x86-64_2of7.zip -d /home/oracle/oracle_software/
[root@rac_pdb/rac_sdb Oracle Db 11.2.0.3.0 (64-bit - Linux)]# unzip p10404530_112030_Linux-x86-64_3of7-Clusterware.zip -d /home/grid/grid_software/

-- Step 32 -->> On both Primary (DC) and Standby (DR) Database Servers
-- Login as root user and issue the following command at rac_pdb
[root@rac_pdb/rac_sdb Oracle Db 11.2.0.3.0 (64-bit - Linux)]# cd /home/grid/
[root@rac_pdb/rac_sdb grid]# chown -R grid:oinstall grid_software
[root@rac_pdb/rac_sdb grid]# chmod -R 775 /home/grid/
[root@rac_pdb/rac_sdb grid]# cd /home/oracle/
[root@rac_pdb/rac_sdb oracle]# chown -R oracle:oinstall /home/oracle/
[root@rac_pdb/rac_sdb oracle]# chmod -R 775 /home/oracle/

-- Step 33 -->> On both Primary (DC) and Standby (DR) Database Servers
-- To Disable the virbr0/lxcbr0 Linux services 
[root@rac_pdb/rac_sdb ~]# cd /etc/sysconfig/
[root@rac_pdb/rac_sdb sysconfig]#  brctl show
/*
bridge name    bridge id        STP enabled    interfaces
lxcbr0        8000.000000000000    no        
pan0          8000.000000000000    no        
virbr0        8000.525400467a72    yes        virbr0-nic
*/

[root@rac_pdb/rac_sdb sysconfig]# virsh net-list
/*
Name                 State      Autostart     Persistent
--------------------------------------------------
default              active     yes           yes
*/

[root@rac_pdb/rac_sdb sysconfig]# service libvirtd stop
/*
Stopping libvirtd daemon:                                  [  OK  ]
*/
[root@rac_pdb/rac_sdb sysconfig]# chkconfig --list | grep libvirtd
/*
libvirtd           0:off    1:off    2:off    3:on    4:on    5:on    6:off
*/

[root@rac_pdb/rac_sdb sysconfig]# chkconfig libvirtd off
[root@rac_pdb/rac_sdb sysconfig]# ip link set lxcbr0 down
[root@rac_pdb/rac_sdb sysconfig]# brctl delbr lxcbr0
[root@rac_pdb/rac_sdb sysconfig]# brctl show
[root@rac_pdb/rac_sdb sysconfig]# init 6

[root@rac_pdb/rac_sdb ~]# brctl show
/*
bridge name    bridge id        STP enabled    interfaces
lxcbr0        8000.000000000000    no        
pan0        8000.000000000000    no        
*/
[root@rac_pdb/rac_sdb ~]# chkconfig --list | grep libvirtd
/*
libvirtd           0:off    1:off    2:off    3:off    4:off    5:off    6:off
*/

-- Step 34 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# su - oracle

-- Login as the oracle user and add the following lines at the end of the ".bash_profile" file.
[oracle@rac_pdb ~]$ vim .bash_profile
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

ORACLE_HOSTNAME=rac_pdb.mydoamin; export ORACLE_HOSTNAME
ORACLE_UNQNAME=racdb; export ORACLE_UNQNAME
ORACLE_BASE=/u01/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/11.2.0.3.0/db_1; export ORACLE_HOME
ORACLE_SID=racdb1; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

[oracle@rac_pdb ~]$ . .bash_profile

-- Step 35 -->> On Primary Database Server (DC)
-- Login as the grid user and add the following lines at the end of the ".bash_profile" file.
[root@rac_pdb ~]# su - grid
[grid@rac_pdb ~]$ vim .bash_profile
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
ORACLE_BASE=/u01/app/oracle; export ORACLE_BASE
GRID_HOME=/u01/11.2.0.3.0/grid; export GRID_HOME
ORACLE_HOME=$GRID_HOME; export ORACLE_HOME

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

[grid@rac_pdb ~]$ . .bash_profile

-- Step 36 -->> On Primary Database Server (DC)
[grid@rac_pdb]# su - root
[root@rac_pdb ~]# vim /etc/sysconfig/network
/*
NETWORKING=yes
HOSTNAME=rac_pdb.mydoamin
# oracle-rdbms-server-11gR2-preinstall : Add NOZEROCONF=yes
NOZEROCONF=yes
*/

-- Step 37 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# su - oracle

-- Login as the oracle user and add the following lines at the end of the ".bash_profile" file.
[oracle@rac_sdb ~]$ vim .bash_profile
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

ORACLE_HOSTNAME=rac_sdb.mydoamin; export ORACLE_HOSTNAME
ORACLE_UNQNAME=racdb_dr; export ORACLE_UNQNAME
ORACLE_BASE=/u01/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/11.2.0.3.0/db_1; export ORACLE_HOME
ORACLE_SID=racdb1; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

[oracle@rac_sdb ~]$ . .bash_profile

-- Step 38 -->> On Standby Database Server (DR)
-- Login as the grid user and add the following lines at the end of the ".bash_profile" file.
[root@rac_sdb iscsi]# su - grid
[grid@rac_sdb ~]$ vim .bash_profile
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
ORACLE_BASE=/u01/app/oracle; export ORACLE_BASE
GRID_HOME=/u01/11.2.0.3.0/grid; export GRID_HOME
ORACLE_HOME=$GRID_HOME; export ORACLE_HOME

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

[grid@rac_sdb ~]$ . .bash_profile

-- Step 39 -->> On Standby Database Server (DR)
[grid@rac_sdb]# su - root
[root@rac_sdb ~]# vim /etc/sysconfig/network
/*
NETWORKING=yes
HOSTNAME=rac_sdb.mydoamin
# oracle-rdbms-server-11gR2-preinstall : Add NOZEROCONF=yes
NOZEROCONF=yes
*/

-- Step 40 -->> On Primary Database Server (DC)
--SSH user Equivalency configuration (grid and oracle):
--On All the Cluster Nodes:
[root@rac_pdb ~]# su - oracle
[oracle@rac_pdb ~]# mkdir ~/.ssh
[oracle@rac_pdb ~]# chmod 700 ~/.ssh

--Generate the RSA and DSA keys:
[oracle@rac_pdb ~]# /usr/bin/ssh-keygen -t rsa
/*
Generating public/private rsa key pair.
Enter file in which to save the key (/home/oracle/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/oracle/.ssh/id_rsa.
Your public key has been saved in /home/oracle/.ssh/id_rsa.pub.
The key fingerprint is:
18:30:38:58:53:f2:00:8f:e3:d5:b9:4f:46:b7:8a:0a oracle@rac_pdb.mydoamin
The key's randomart image is:
+--[ RSA 2048]----+
|.+=o+            |
|.oo=.o.          |
|o .o.o.. .       |
|...   oo. .      |
| .   ..oS.       |
|      = .        |
| E   . o         |
|  . .            |
|   .             |
+-----------------+
*/

[oracle@rac_pdb ~]# /usr/bin/ssh-keygen -t dsa
/*
Generating public/private dsa key pair.
Enter file in which to save the key (/home/oracle/.ssh/id_dsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/oracle/.ssh/id_dsa.
Your public key has been saved in /home/oracle/.ssh/id_dsa.pub.
The key fingerprint is:
0b:53:94:a7:3f:9a:38:4b:5f:dd:05:22:f0:a9:7b:41 oracle@rac_pdb.mydoamin
The key's randomart image is:
+--[ DSA 1024]----+
|        o.       |
|       ..o..     |
|        .oE . .  |
|       ..o . . . |
|      o S..     .|
|       o ooo . . |
|      ..ooo.. .  |
|     .o.oo       |
|      .o.        |
+-----------------+
*/
[oracle@rac_pdb ~]# touch ~/.ssh/authorized_keys
[oracle@rac_pdb ~]# cd ~/.ssh

--(a) Add these Keys to the Authorized_keys file.
[oracle@rac_pdb ~]# cat id_rsa.pub >> authorized_keys
[oracle@rac_pdb ~]# cat id_dsa.pub >> authorized_keys

-- Step 41 -->> On Standby Database Server (DR)
--SSH user Equivalency configuration (grid and oracle):
--On All the Cluster Nodes:
[root@rac_sdb ~]#su - oracle
[oracle@rac_sdb ~]# mkdir ~/.ssh
[oracle@rac_sdb ~]# chmod 700 ~/.ssh

--Generate the RSA and DSA keys:
[oracle@rac_sdb ~]# /usr/bin/ssh-keygen -t rsa
/*
Generating public/private rsa key pair.
Enter file in which to save the key (/home/oracle/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/oracle/.ssh/id_rsa.
Your public key has been saved in /home/oracle/.ssh/id_rsa.pub.
The key fingerprint is:
da:61:39:20:b0:ae:0b:a9:d9:b2:11:84:a8:ee:d9:d3 oracle@rac_sdb.mydoamin
The key's randomart image is:
+--[ RSA 2048]----+
|  .              |
|o  o             |
|o.. . .          |
|o.   . . .       |
|o .     S        |
|.+     + o       |
|=.  . . .        |
|==o. E           |
|==...            |
+-----------------+
*/
[oracle@rac_sdb ~]# /usr/bin/ssh-keygen -t dsa
/*
Generating public/private dsa key pair.
Enter file in which to save the key (/home/oracle/.ssh/id_dsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/oracle/.ssh/id_dsa.
Your public key has been saved in /home/oracle/.ssh/id_dsa.pub.
The key fingerprint is:
95:c6:44:bb:92:1e:a2:4a:ee:2d:5e:43:cf:64:84:63 oracle@rac_sdb.mydoamin
The key's randomart image is:
+--[ DSA 1024]----+
|         .o      |
|     .   o o     |
|    E .   *      |
|   . o   + .     |
|    . + S .      |
|   . * o o       |
|  . + o .        |
| o.+ .           |
| o=..            |
+-----------------+
*/
[oracle@rac_sdb ~]# cd ~/.ssh

-- Step 42 -->> On Primary Database Server (DC)
-- Send this file to node Standby Database Server.
[oracle@rac_pdb .ssh]# scp authorized_keys oracle@192.168.1.106:~/.ssh/
/*
The authenticity of host '192.168.1.106 (192.168.1.106)' can't be established.
RSA key fingerprint is 57:4f:d9:c7:c1:da:ed:f5:c2:a0:fa:b5:4e:24:fc:e4.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.1.106' (RSA) to the list of known hosts.
oracle@192.168.1.106's password: 
authorized_keys                               100% 1026     1.0KB/s   00:00
*/

-- Step 43 -->> On both Primary (DC) and Standby (DR) Database Servers
[oracle@rac_pdb/rac_sdb ~]# chmod 600 ~/.ssh/authorized_keys

-- Step 44 -->> On Primary Database Server (DC)
[oracle@rac_pdb .ssh]$ ssh oracle@192.168.1.106
/*
oracle@192.168.1.106's password:
*/ 
[oracle@rac_sdb ~]$ exit
/*
logout
Connection to 192.168.1.106 closed.
*/ 

-- Step 45 -->> On Standby Database Server (DR)
[oracle@rac_sdb .ssh]$ ssh oracle@192.168.1.105
/*
The authenticity of host '192.168.1.105 (192.168.1.105)' can't be established.
RSA key fingerprint is a2:e1:2a:b8:4c:ac:94:1a:9c:53:9c:82:e5:4b:69:f3.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.1.105' (RSA) to the list of known hosts.
oracle@192.168.1.105's password: 
*/
[oracle@rac_pdb ~]$ exit
/*
logout
Connection to 192.168.1.105 closed.
*/

-- Step 46 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# su - grid
[grid@rac_pdb ~]$ mkdir ~/.ssh
[grid@rac_pdb ~]$ chmod 700 ~/.ssh
[grid@rac_pdb ~]$ /usr/bin/ssh-keygen -t rsa
/*
Generating public/private rsa key pair.
Enter file in which to save the key (/home/grid/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/grid/.ssh/id_rsa.
Your public key has been saved in /home/grid/.ssh/id_rsa.pub.
The key fingerprint is:
c5:f3:5a:47:d2:c5:60:5d:2a:d8:98:8b:6a:ce:e4:60 grid@rac_pdb.mydoamin
The key's randomart image is:
+--[ RSA 2048]----+
|              o++|
|         . = o oo|
|          B + +  |
|         o + +   |
|        S . o .  |
|       .   o .   |
|    E +   .      |
|   . B           |
|      +          |
+-----------------+
*/
[grid@rac_pdb ~]$ /usr/bin/ssh-keygen -t dsa
/*
Generating public/private dsa key pair.
Enter file in which to save the key (/home/grid/.ssh/id_dsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/grid/.ssh/id_dsa.
Your public key has been saved in /home/grid/.ssh/id_dsa.pub.
The key fingerprint is:
38:de:db:40:e1:36:60:49:c3:45:02:59:12:4a:b9:70 grid@rac_pdb.mydoamin
The key's randomart image is:
+--[ DSA 1024]----+
|  ..+*=oo        |
|..E..o.+         |
| o..  + .        |
|  .  . + .       |
|      o S        |
|     . = .       |
|      . o        |
|         +       |
|        . .      |
+-----------------+
*/
[grid@rac_pdb ~]$ touch ~/.ssh/authorized_keys
[grid@rac_pdb ~]$ cd ~/.ssh
[grid@rac_pdb .ssh]$ cat id_rsa.pub >> authorized_keys
[grid@rac_pdb .ssh]$ cat id_dsa.pub >> authorized_keys

-- Step 47 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# su - grid
[grid@rac_sdb ~]$ mkdir ~/.ssh
[grid@rac_sdb ~]$ chmod 700 ~/.ssh
[grid@rac_sdb ~]$ /usr/bin/ssh-keygen -t rsa
/*
Generating public/private rsa key pair.
Enter file in which to save the key (/home/grid/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/grid/.ssh/id_rsa.
Your public key has been saved in /home/grid/.ssh/id_rsa.pub.
The key fingerprint is:
1f:28:5d:fa:6e:a7:de:55:9a:cc:cc:e0:0a:79:66:a1 grid@rac_sdb.mydoamin
The key's randomart image is:
+--[ RSA 2048]----+
|                 |
|                 |
|          .      |
|       . +       |
|      . S o .   .|
|       . = + * + |
|        E * . O  |
|         *.o..   |
|         o=o.    |
+-----------------+
*/
[grid@rac_sdb ~]$ /usr/bin/ssh-keygen -t dsa
/*
Generating public/private dsa key pair.
Enter file in which to save the key (/home/grid/.ssh/id_dsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/grid/.ssh/id_dsa.
Your public key has been saved in /home/grid/.ssh/id_dsa.pub.
The key fingerprint is:
e8:20:12:ed:6b:f4:aa:7e:05:5c:7d:15:d9:5c:4c:ff grid@rac_sdb.mydoamin
The key's randomart image is:
+--[ DSA 1024]----+
|      .   .o= +o |
| .   . . . . o ..|
|. o .   .       .|
| o o   .        .|
|. + o . S       E|
| o + +           |
|  o o .          |
| . o             |
|ooo              |
+-----------------+
*/
[grid@rac_sdb ~]$ cd ~/.ssh

-- Step 48 -->> On Primary Database Server (DC)
[grid@rac_pdb .ssh]$ scp authorized_keys grid@192.168.1.106:~/.ssh/
/*
The authenticity of host '192.168.1.106 (192.168.1.106)' can't be established.
RSA key fingerprint is 57:4f:d9:c7:c1:da:ed:f5:c2:a0:fa:b5:4e:24:fc:e4.
Are you sure you want to continue connecting (yes/no)? yes 
Warning: Permanently added '192.168.1.106' (RSA) to the list of known hosts.
grid@192.168.1.106's password: 
authorized_keys                               100% 1022     1.0KB/s   00:00
*/

-- Step 49 -->> On both Primary (DC) and Standby (DR) Database Servers
[grid@rac_pdb/rac_sdb .ssh]$ chmod 600 ~/.ssh/authorized_keys

-- Step 50 -->> On Primary Database Server (DC)
[grid@rac_pdb .ssh]$ ssh grid@192.168.1.106
/*
grid@rac_sdb's password:
*/ 
[grid@rac_sdb ~]$ exit
/*
logout
Connection to 192.168.1.106 closed.
*/

-- Step 51 -->> On Standby Database Server (DR)
[grid@rac_sdb .ssh]$ ssh grid@192.168.1.105
/*
The authenticity of host '192.168.1.105 (192.168.1.105)' can't be established.
RSA key fingerprint is a2:e1:2a:b8:4c:ac:94:1a:9c:53:9c:82:e5:4b:69:f3.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.1.105' (RSA) to the list of known hosts.
grid@192.168.1.105's password: 
*/
[grid@rac_pdb ~]$ exit
/*
logout
Connection to 192.168.1.105 closed.
*/

-- Step 52 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# ssh 192.168.1.106
/*
The authenticity of host '192.168.1.106 (192.168.1.106)' can't be established.
RSA key fingerprint is 57:4f:d9:c7:c1:da:ed:f5:c2:a0:fa:b5:4e:24:fc:e4.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.1.106' (RSA) to the list of known hosts.
root@192.168.1.106's password: 
*/

[root@rac_sdb ~]# exit
/*
logout
Connection to 192.168.1.106 closed.
*/

[root@rac_sdb ~]# ssh 192.168.1.105
/*
The authenticity of host '192.168.1.105 (192.168.1.105)' can't be established.
RSA key fingerprint is a2:e1:2a:b8:4c:ac:94:1a:9c:53:9c:82:e5:4b:69:f3.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.1.105' (RSA) to the list of known hosts.
root@192.168.1.105's password: 
*/
[root@rac_pdb ~]# exit
/*
logout
Connection to 192.168.1.105 closed.
*/

-- Step 53 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# ssh 192.168.1.105
/*
root@192.168.1.105's password: 
Last login: Tue Dec 10 11:45:30 2019 from 192.168.1.106
*/

[root@rac_pdb ~]# exit
/*
logout
Connection to 192.168.1.105 closed.
*/

[root@rac_pdb ~]# ssh 192.168.1.106
/*
root@192.168.1.106's password: 
Last login: Tue Dec 10 11:44:07 2019 from 192.168.1.105
*/

[root@rac_sdb ~]# exit
/*
logout
Connection to 192.168.1.106 closed.
*/

-- Step 54 -->> On openfiler (SAN/NAS Storage)
[oracle@openfiler ~]#service iscsi-target restart

-- Step 55 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# which oracleasm
/*
/usr/sbin/oracleasm
*/

-- Step 56 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# oracleasm configure
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

-- Step 57 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# oracleasm status
/*
Checking if ASM is loaded: no
Checking if /dev/oracleasm is mounted: no
*/

-- Step 58 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# oracleasm configure -i
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

-- Step 59 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# oracleasm configure
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

-- Step 60 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# oracleasm init
/*
Creating /dev/oracleasm mount point: /dev/oracleasm
Loading module "oracleasm": oracleasm
Configuring "oracleasm" to use device physical block size
Mounting ASMlib driver filesystem: /dev/oracleasm
*/

-- Step 61 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 62 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 63 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# oracleasm listdisks
[root@rac_pdb ~]# rpm -qa | grep -i iscsi
/*
iscsi-initiator-utils-6.2.0.873-27.0.10.el6_10.x86_64
*/

-- Step 64 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# service iscsi stop
/*
Stopping iscsi:                                            [  OK  ]
*/

-- Step 65 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# service iscsi status
/*
iscsi is stopped
*/

-- Step 66 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# cd /etc/iscsi/
[root@rac_pdb iscsi]# ls
/*
initiatorname.iscsi  iscsid.conf
*/

-- Step 67 -->> On Primary Database Server (DC)
[root@rac_pdb iscsi]# vim initiatorname.iscsi 
/*
InitiatorName=iqn.rac_pdb:oracle
*/

-- Step 68 -->> On Primary Database Server (DC)
[root@rac_pdb iscsi]# service iscsi start
[root@rac_pdb iscsi]# chkconfig iscsi on
[root@rac_pdb iscsi]# chkconfig iscsid on

-- Step 69 -->> On Primary Database Server (DC)
[root@rac_pdb iscsi]# lsscsi
/*
[1:0:0:0]    cd/dvd  NECVMWar VMware IDE CDR10 1.00  /dev/sr0 
[2:0:0:0]    disk    VMware,  VMware Virtual S 1.0   /dev/sda 
*/

-- Step 70 -->> On Primary Database Server (DC)
[root@rac_pdb iscsi]# iscsiadm -m discovery -t sendtargets -p openfiler
/*
192.168.1.104:3260,1 iqn.openfiler:fra_pdb
192.168.1.104:3260,1 iqn.openfiler:data_pdb
192.168.1.104:3260,1 iqn.openfiler:ocr_pdb
*/

-- Step 71 -->> On Primary Database Server (DC)
[root@rac_pdb iscsi]# lsscsi
/*
[1:0:0:0]    cd/dvd  NECVMWar VMware IDE CDR10 1.00  /dev/sr0 
[2:0:0:0]    disk    VMware,  VMware Virtual S 1.0   /dev/sda 
*/

-- Step 72 -->> On Primary Database Server (DC)
[root@rac_pdb iscsi]# ls /var/lib/iscsi/send_targets/
/*
openfiler,3260
*/

-- Step 73 -->> On Primary Database Server (DC)
[root@rac_pdb iscsi]# ls /var/lib/iscsi/nodes/
/*
iqn.openfiler:data_pdb  iqn.openfiler:fra_pdb  iqn.openfiler:ocr_pdb
*/

-- Step 74 -->> On Primary Database Server (DC)
[root@rac_pdb iscsi]# service iscsi restart
/*
Stopping iscsi:                                            [  OK  ]
Starting iscsi:                                            [  OK  ]
*/

-- Step 75 -->> On Primary Database Server (DC)
[root@rac_pdb iscsi]# lsscsi
/*
[1:0:0:0]    cd/dvd  NECVMWar VMware IDE CDR10 1.00  /dev/sr0 
[2:0:0:0]    disk    VMware,  VMware Virtual S 1.0   /dev/sda 
[4:0:0:0]    disk    OPNFILER VIRTUAL-DISK     0     /dev/sdb 
[6:0:0:0]    disk    OPNFILER VIRTUAL-DISK     0     /dev/sdc 
[8:0:0:0]    disk    OPNFILER VIRTUAL-DISK     0     /dev/sdd 
*/

-- Step 76 -->> On Primary Database Server (DC)
[root@rac_pdb iscsi]# iscsiadm -m session
/*
tcp: [1] 192.168.1.104:3260,1 iqn.openfiler:fra_pdb (non-flash)
tcp: [2] 192.168.1.104:3260,1 iqn.openfiler:data_pdb (non-flash)
tcp: [3] 192.168.1.104:3260,1 iqn.openfiler:ocr_pdb (non-flash)
*/

-- Step 77 -->> On Primary Database Server (DC)
[root@rac_pdb iscsi]# iscsiadm -m node -T iqn.openfiler:ocr_pdb -p 192.168.1.104 --op update -n node.startup -v automatic
[root@rac_pdb iscsi]# iscsiadm -m node -T iqn.openfiler:data_pdb -p 192.168.1.104 --op update -n node.startup -v automatic
[root@rac_pdb iscsi]# iscsiadm -m node -T iqn.openfiler:fra_pdb -p 192.168.1.104 --op update -n node.startup -v automatic

-- Step 78 -->> On Primary Database Server (DC)
[root@rac_pdb iscsi]# lsscsi
/*
[0:0:0:0]    disk    VMware,  VMware Virtual S 1.0   /dev/sda 
[2:0:0:0]    cd/dvd  NECVMWar VMware IDE CDR10 1.00  /dev/sr0 
[3:0:0:0]    disk    OPNFILER VIRTUAL-DISK     0     /dev/sdb 
[4:0:0:0]    disk    OPNFILER VIRTUAL-DISK     0     /dev/sdc 
[5:0:0:0]    disk    OPNFILER VIRTUAL-DISK     0     /dev/sdd 
*/

-- Step 79 -->> On Primary Database Server (DC)
[root@rac_pdb iscsi]# ls /dev/sd*
/*
/dev/sda   /dev/sda2  /dev/sda4  /dev/sda6  /dev/sda8  /dev/sdb  /dev/sdd
/dev/sda1  /dev/sda3  /dev/sda5  /dev/sda7  /dev/sda9  /dev/sdc
*/

-- Step 80 -->> On Primary Database Server (DC)
[root@rac_pdb iscsi]# iscsiadm -m session -P 3 > scsi_sdbives.txt
[root@rac_pdb iscsi]# vim scsi_sdbives.txt 
[root@rac_pdb iscsi]# cat scsi_sdbives.txt 
/*
# iscsiadm -m session -P 3 > scsi_sdbives.txt

Target: iqn.openfiler:fra_pdb (non-flash)
            Attached scsi disk sdb        State: running
Target: iqn.openfiler:ocr_pdb (non-flash)
            Attached scsi disk sdd        State: running
Target: iqn.openfiler:data_pdb (non-flash)
            Attached scsi disk sdc        State: running
*/

----------------------------------------------------------
-- Step 81 -->> On Primary Database Server (DC)
-- Login from root user of rac_pdb
[root@rac_pdb ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 82 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 83 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# oracleasm listdisks
[root@rac_pdb ~]# ls /dev/sd*
/*
/dev/sda   /dev/sda2  /dev/sda4  /dev/sda6  /dev/sda8  /dev/sdb  /dev/sdd
/dev/sda1  /dev/sda3  /dev/sda5  /dev/sda7  /dev/sda9  /dev/sdc
*/

-- Step 84 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# ls -ltr /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Dec 10 12:11 /dev/sda
brw-rw---- 1 root disk 8,  4 Dec 10 12:11 /dev/sda4
brw-rw---- 1 root disk 8,  7 Dec 10 12:11 /dev/sda7
brw-rw---- 1 root disk 8,  2 Dec 10 12:11 /dev/sda2
brw-rw---- 1 root disk 8,  1 Dec 10 12:11 /dev/sda1
brw-rw---- 1 root disk 8,  8 Dec 10 12:11 /dev/sda8
brw-rw---- 1 root disk 8,  9 Dec 10 12:11 /dev/sda9
brw-rw---- 1 root disk 8,  3 Dec 10 12:11 /dev/sda3
brw-rw---- 1 root disk 8,  5 Dec 10 12:11 /dev/sda5
brw-rw---- 1 root disk 8,  6 Dec 10 12:11 /dev/sda6
brw-rw---- 1 root disk 8, 48 Dec 10 12:26 /dev/sdd
brw-rw---- 1 root disk 8, 16 Dec 10 12:26 /dev/sdb
brw-rw---- 1 root disk 8, 32 Dec 10 12:26 /dev/sdc
*/

-- Step 85 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# fdisk /dev/sdb
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0x485f3eff.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/sdb: 26.8 GB, 26843545600 bytes
64 heads, 32 sectors/track, 25600 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x485f3eff

   Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-25600, default 1): 
Using default value 1
Last cylinder, +cylinders or +size{K,M,G} (1-25600, default 25600): 
Using default value 25600

Command (m for help): p

Disk /dev/sdb: 26.8 GB, 26843545600 bytes
64 heads, 32 sectors/track, 25600 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x485f3eff

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1       25600    26214384   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 86 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# fdisk /dev/sdc
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0xc8336e74.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/sdc: 42.9 GB, 42949672960 bytes
64 heads, 32 sectors/track, 40960 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xc8336e74

   Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-40960, default 1): 
Using default value 1
Last cylinder, +cylinders or +size{K,M,G} (1-40960, default 40960): 
Using default value 40960

Command (m for help): p

Disk /dev/sdc: 42.9 GB, 42949672960 bytes
64 heads, 32 sectors/track, 40960 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xc8336e74

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       40960    41943024   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 87 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# fdisk /dev/sdd
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0xe6a8cf06.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/sdd: 21.5 GB, 21474836480 bytes
64 heads, 32 sectors/track, 20480 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xe6a8cf06

   Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-20480, default 1): 
Using default value 1
Last cylinder, +cylinders or +size{K,M,G} (1-20480, default 20480): 
Using default value 20480

Command (m for help): p

Disk /dev/sdd: 21.5 GB, 21474836480 bytes
64 heads, 32 sectors/track, 20480 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xe6a8cf06

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1       20480    20971504   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 88 -->> On Primary Database Server (DC)
[root@rac_pdb  ~]# ls -ltr /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Dec 10 12:11 /dev/sda
brw-rw---- 1 root disk 8,  4 Dec 10 12:11 /dev/sda4
brw-rw---- 1 root disk 8,  7 Dec 10 12:11 /dev/sda7
brw-rw---- 1 root disk 8,  2 Dec 10 12:11 /dev/sda2
brw-rw---- 1 root disk 8,  1 Dec 10 12:11 /dev/sda1
brw-rw---- 1 root disk 8,  8 Dec 10 12:11 /dev/sda8
brw-rw---- 1 root disk 8,  9 Dec 10 12:11 /dev/sda9
brw-rw---- 1 root disk 8,  3 Dec 10 12:11 /dev/sda3
brw-rw---- 1 root disk 8,  5 Dec 10 12:11 /dev/sda5
brw-rw---- 1 root disk 8,  6 Dec 10 12:11 /dev/sda6
brw-rw---- 1 root disk 8, 17 Dec 10 12:35 /dev/sdb1
brw-rw---- 1 root disk 8, 16 Dec 10 12:35 /dev/sdb
brw-rw---- 1 root disk 8, 33 Dec 10 12:36 /dev/sdc1
brw-rw---- 1 root disk 8, 32 Dec 10 12:36 /dev/sdc
brw-rw---- 1 root disk 8, 48 Dec 10 12:37 /dev/sdd
brw-rw---- 1 root disk 8, 49 Dec 10 12:37 /dev/sdd1
*/

-- Step 89 -->> On Primary Database Server (DC)
[root@rac_pdb iscsi]# fdisk -l
/*
Disk /dev/sda: 107.4 GB, 107374182400 bytes
255 heads, 63 sectors/track, 13054 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00092330

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1        1275    10240000   83  Linux
/dev/sda2            1275        3188    15360000   83  Linux
/dev/sda3            3188        6170    23955456   83  Linux
/dev/sda4            6170       13055    55301120    5  Extended
/dev/sda5            6170        7827    13310976   83  Linux
/dev/sda6            7828        9230    11264000   83  Linux
/dev/sda7            9230       10505    10240000   82  Linux swap / Solaris
/dev/sda8           10505       11780    10240000   83  Linux
/dev/sda9           11780       13055    10240000   83  Linux

Disk /dev/sdb: 26.8 GB, 26843545600 bytes
64 heads, 32 sectors/track, 25600 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x485f3eff

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1       25600    26214384   83  Linux

Disk /dev/sdc: 42.9 GB, 42949672960 bytes
64 heads, 32 sectors/track, 40960 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xc8336e74

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       40960    41943024   83  Linux

Disk /dev/sdd: 21.5 GB, 21474836480 bytes
64 heads, 32 sectors/track, 20480 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xe6a8cf06

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1       20480    20971504   83  Linux
*/

-- Step 90 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# oracleasm createdisk OCR /dev/sdd1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 91 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# oracleasm createdisk DATA /dev/sdc1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 92 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# oracleasm createdisk FRA /dev/sdb1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 93 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# hostname
/*
rac_pdb.mydoamin
*/

-- Step 94 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 95 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# oracleasm listdisks
/*
DATA
FRA
OCR
*/

-- Step 96 -->> On Primary Database Server (DC)
[root@rac_pdb ~]# cd /etc/iscsi/
[root@rac_pdb iscsi]# service iscsi restart
/*
Stopping iscsi:                                            [  OK  ]
Starting iscsi:                                            [  OK  ]
*/

-- Step 97 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# which oracleasm
/*
/usr/sbin/oracleasm
*/

-- Step 98 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# oracleasm configure
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

-- Step 99 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# oracleasm status
/*
Checking if ASM is loaded: no
Checking if /dev/oracleasm is mounted: no
*/

-- Step 100 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# oracleasm configure -i
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

-- Step 101 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# oracleasm configure
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

-- Step 102 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# oracleasm init
/*
Creating /dev/oracleasm mount point: /dev/oracleasm
Loading module "oracleasm": oracleasm
Configuring "oracleasm" to use device physical block size
Mounting ASMlib driver filesystem: /dev/oracleasm
*/

-- Step 103 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 104 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 105 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# oracleasm listdisks
[root@rac_sdb ~]# rpm -qa | grep -i iscsi
/*
iscsi-initiator-utils-6.2.0.873-27.0.10.el6_10.x86_64
*/

-- Step 106 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# service iscsi stop
/*
Stopping iscsi:                                            [  OK  ]
*/

-- Step 107 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# service iscsi status
/*
iscsi is stopped
*/

-- Step 108 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# cd /etc/iscsi/
[root@rac_sdb iscsi]# ls
/*
initiatorname.iscsi  iscsid.conf
*/

-- Step 109 -->> On Standby Database Server (DR)
[root@rac_sdb iscsi]# vim initiatorname.iscsi 
/*
InitiatorName=iqn.rac_sdb:oracle
*/

-- Step 110 -->> On Standby Database Server (DR)
[root@rac_sdb iscsi]# service iscsi start
[root@rac_sdb iscsi]# chkconfig iscsi on
[root@rac_sdb iscsi]# chkconfig iscsid on

-- Step 111 -->> On Standby Database Server (DR)
[root@rac_sdb iscsi]# lsscsi
/*
[1:0:0:0]    cd/dvd  NECVMWar VMware IDE CDR10 1.00  /dev/sr0 
[2:0:0:0]    disk    VMware,  VMware Virtual S 1.0   /dev/sda 
*/

-- Step 112 -->> On Standby Database Server (DR)
[root@rac_sdb iscsi]# iscsiadm -m discovery -t sendtargets -p openfiler
/*
192.168.1.104:3260,1 iqn.openfiler:fra_sdb
192.168.1.104:3260,1 iqn.openfiler:data_sdb
192.168.1.104:3260,1 iqn.openfiler:ocr_sdb
*/

-- Step 113 -->> On Standby Database Server (DR)
[root@rac_sdb iscsi]# lsscsi
/*
[1:0:0:0]    cd/dvd  NECVMWar VMware IDE CDR10 1.00  /dev/sr0 
[2:0:0:0]    disk    VMware,  VMware Virtual S 1.0   /dev/sda 
*/

-- Step 114 -->> On Standby Database Server (DR)
[root@rac_sdb iscsi]# ls /var/lib/iscsi/send_targets/
/*
openfiler,3260
*/

-- Step 115 -->> On Standby Database Server (DR)
[root@rac_sdb iscsi]# ls /var/lib/iscsi/nodes/
/*
iqn.openfiler:data_sdb  iqn.openfiler:fra_sdb  iqn.openfiler:ocr_sdb
*/

-- Step 116 -->> On Standby Database Server (DR)
[root@rac_sdb iscsi]# service iscsi restart
/*
Stopping iscsi:                                            [  OK  ]
Starting iscsi:                                            [  OK  ]
*/

-- Step 117 -->> On Standby Database Server (DR)
[root@rac_sdb iscsi]# lsscsi
/*
[1:0:0:0]    cd/dvd  NECVMWar VMware IDE CDR10 1.00  /dev/sr0 
[2:0:0:0]    disk    VMware,  VMware Virtual S 1.0   /dev/sda 
[3:0:0:0]    disk    OPNFILER VIRTUAL-DISK     0     /dev/sdb 
[4:0:0:0]    disk    OPNFILER VIRTUAL-DISK     0     /dev/sdd 
[5:0:0:0]    disk    OPNFILER VIRTUAL-DISK     0     /dev/sdc 
*/

-- Step 118 -->> On Standby Database Server (DR)
[root@rac_sdb iscsi]# iscsiadm -m session
/*
tcp: [1] 192.168.1.104:3260,1 iqn.openfiler:fra_sdb (non-flash)
tcp: [2] 192.168.1.104:3260,1 iqn.openfiler:ocr_sdb (non-flash)
tcp: [3] 192.168.1.104:3260,1 iqn.openfiler:data_sdb (non-flash)
*/

-- Step 119 -->> On Standby Database Server (DR)
[root@rac_sdb iscsi]# iscsiadm -m node -T iqn.openfiler:ocr_sdb -p 192.168.1.104 --op update -n node.startup -v automatic
[root@rac_sdb iscsi]# iscsiadm -m node -T iqn.openfiler:data_sdb -p 192.168.1.104 --op update -n node.startup -v automatic
[root@rac_sdb iscsi]# iscsiadm -m node -T iqn.openfiler:fra_sdb -p 192.168.1.104 --op update -n node.startup -v automatic

-- Step 120 -->> On Standby Database Server (DR)
[root@rac_sdb iscsi]# lsscsi
/*
[1:0:0:0]    cd/dvd  NECVMWar VMware IDE CDR10 1.00  /dev/sr0 
[2:0:0:0]    disk    VMware,  VMware Virtual S 1.0   /dev/sda 
[3:0:0:0]    disk    OPNFILER VIRTUAL-DISK     0     /dev/sdb 
[4:0:0:0]    disk    OPNFILER VIRTUAL-DISK     0     /dev/sdd 
[5:0:0:0]    disk    OPNFILER VIRTUAL-DISK     0     /dev/sdc 
*/

-- Step 121 -->> On Standby Database Server (DR)
[root@rac_sdb iscsi]# ls /dev/sd*
/*
/dev/sda   /dev/sda2  /dev/sda4  /dev/sda6  /dev/sda8  /dev/sdb  /dev/sdd
/dev/sda1  /dev/sda3  /dev/sda5  /dev/sda7  /dev/sda9  /dev/sdc
*/

-- Step 122 -->> On Standby Database Server (DR)
[root@rac_sdb iscsi]# iscsiadm -m session -P 3 > scsi_sdbives.txt
[root@rac_sdb iscsi]# vim scsi_sdbives.txt 
[root@rac_sdb iscsi]# cat scsi_sdbives.txt 
/*
# iscsiadm -m session -P 3 > scsi_sdbives.txt

Target: iqn.openfiler:fra_sdb (non-flash)
            Attached scsi disk sdb        State: running
Target: iqn.openfiler:ocr_sdb (non-flash)
            Attached scsi disk sdd        State: running
Target: iqn.openfiler:data_sdb (non-flash)
            Attached scsi disk sdc        State: running
*/

-- Step 123 -->> On Standby Database Server (DR)
-- Login from root user of rac_pdb
[root@rac_sdb ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 124 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 125 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# oracleasm listdisks
[root@rac_sdb ~]# ls /dev/sd*
/*
/dev/sda   /dev/sda2  /dev/sda4  /dev/sda6  /dev/sda8  /dev/sdb  /dev/sdd
/dev/sda1  /dev/sda3  /dev/sda5  /dev/sda7  /dev/sda9  /dev/sdc
*/

-- Step 126 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# ls -ltr /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Dec 10 12:12 /dev/sda
brw-rw---- 1 root disk 8,  4 Dec 10 12:12 /dev/sda4
brw-rw---- 1 root disk 8,  7 Dec 10 12:12 /dev/sda7
brw-rw---- 1 root disk 8,  2 Dec 10 12:12 /dev/sda2
brw-rw---- 1 root disk 8,  1 Dec 10 12:12 /dev/sda1
brw-rw---- 1 root disk 8,  8 Dec 10 12:12 /dev/sda8
brw-rw---- 1 root disk 8,  9 Dec 10 12:12 /dev/sda9
brw-rw---- 1 root disk 8,  3 Dec 10 12:12 /dev/sda3
brw-rw---- 1 root disk 8,  5 Dec 10 12:12 /dev/sda5
brw-rw---- 1 root disk 8,  6 Dec 10 12:12 /dev/sda6
brw-rw---- 1 root disk 8, 32 Dec 10 12:55 /dev/sdc
brw-rw---- 1 root disk 8, 16 Dec 10 12:55 /dev/sdb
brw-rw---- 1 root disk 8, 48 Dec 10 12:55 /dev/sdd
*/

-- Step 127 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# fdisk /dev/sdb
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0xc26a1275.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/sdb: 26.8 GB, 26843545600 bytes
64 heads, 32 sectors/track, 25600 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xc26a1275

   Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-25600, default 1): 
Using default value 1
Last cylinder, +cylinders or +size{K,M,G} (1-25600, default 25600): 
Using default value 25600

Command (m for help): p

Disk /dev/sdb: 26.8 GB, 26843545600 bytes
64 heads, 32 sectors/track, 25600 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xc26a1275

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1       25600    26214384   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 128 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# fdisk /dev/sdc
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0xb3307317.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/sdc: 42.9 GB, 42949672960 bytes
64 heads, 32 sectors/track, 40960 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xb3307317

   Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-40960, default 1): 
Using default value 1
Last cylinder, +cylinders or +size{K,M,G} (1-40960, default 40960): 
Using default value 40960

Command (m for help): p

Disk /dev/sdc: 42.9 GB, 42949672960 bytes
64 heads, 32 sectors/track, 40960 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xb3307317

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       40960    41943024   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 129 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# fdisk /dev/sdd
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0xf8cd3dc3.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/sdd: 21.5 GB, 21474836480 bytes
64 heads, 32 sectors/track, 20480 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xf8cd3dc3

   Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-20480, default 1): 
Using default value 1
Last cylinder, +cylinders or +size{K,M,G} (1-20480, default 20480): 
Using default value 20480

Command (m for help): p

Disk /dev/sdd: 21.5 GB, 21474836480 bytes
64 heads, 32 sectors/track, 20480 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xf8cd3dc3

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1       20480    20971504   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 130 -->> On Standby Database Server (DR)
[root@rac_sdb  ~]# ls -ltr /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Dec 10 12:12 /dev/sda
brw-rw---- 1 root disk 8,  4 Dec 10 12:12 /dev/sda4
brw-rw---- 1 root disk 8,  7 Dec 10 12:12 /dev/sda7
brw-rw---- 1 root disk 8,  2 Dec 10 12:12 /dev/sda2
brw-rw---- 1 root disk 8,  1 Dec 10 12:12 /dev/sda1
brw-rw---- 1 root disk 8,  8 Dec 10 12:12 /dev/sda8
brw-rw---- 1 root disk 8,  9 Dec 10 12:12 /dev/sda9
brw-rw---- 1 root disk 8,  3 Dec 10 12:12 /dev/sda3
brw-rw---- 1 root disk 8,  5 Dec 10 12:12 /dev/sda5
brw-rw---- 1 root disk 8,  6 Dec 10 12:12 /dev/sda6
brw-rw---- 1 root disk 8, 16 Dec 10 13:03 /dev/sdb
brw-rw---- 1 root disk 8, 17 Dec 10 13:03 /dev/sdb1
brw-rw---- 1 root disk 8, 33 Dec 10 13:04 /dev/sdc1
brw-rw---- 1 root disk 8, 32 Dec 10 13:04 /dev/sdc
brw-rw---- 1 root disk 8, 48 Dec 10 13:05 /dev/sdd
brw-rw---- 1 root disk 8, 49 Dec 10 13:05 /dev/sdd1
*/

-- Step 131 -->> On Standby Database Server (DR)
[root@rac_sdb iscsi]# fdisk -l
/*
Disk /dev/sda: 107.4 GB, 107374182400 bytes
255 heads, 63 sectors/track, 13054 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00015c85

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1        1275    10240000   83  Linux
/dev/sda2            1275        3188    15360000   83  Linux
/dev/sda3            3188        6170    23955456   83  Linux
/dev/sda4            6170       13055    55301120    5  Extended
/dev/sda5            6170        7827    13310976   83  Linux
/dev/sda6            7828        9230    11264000   83  Linux
/dev/sda7            9230       10505    10240000   82  Linux swap / Solaris
/dev/sda8           10505       11780    10240000   83  Linux
/dev/sda9           11780       13055    10240000   83  Linux

Disk /dev/sdb: 26.8 GB, 26843545600 bytes
64 heads, 32 sectors/track, 25600 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xc26a1275

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1       25600    26214384   83  Linux

Disk /dev/sdc: 42.9 GB, 42949672960 bytes
64 heads, 32 sectors/track, 40960 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xb3307317

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       40960    41943024   83  Linux

Disk /dev/sdd: 21.5 GB, 21474836480 bytes
64 heads, 32 sectors/track, 20480 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xf8cd3dc3

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1       20480    20971504   83  Linux
*/

-- Step 132 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# oracleasm createdisk OCR /dev/sdd1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 133 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# oracleasm createdisk DATA /dev/sdc1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 134 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# oracleasm createdisk FRA /dev/sdb1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 135 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# hostname
/*
rac_sdb.mydoamin
*/

-- Step 136 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 137 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# oracleasm listdisks
/*
DATA
FRA
OCR
*/

-- Step 138 -->> On Standby Database Server (DR)
[root@rac_sdb ~]# cd /etc/iscsi/
[root@rac_sdb iscsi]# service iscsi restart
/*
Stopping iscsi:                                            [  OK  ]
Starting iscsi:                                            [  OK  ]
*/

-- Step 139 -->> On both Primary (DC) and Standby (DR) Database Servers
-- To install the cvuqdisk-1.0.9-1.rpm on both racs
-- Login from root user
[root@rac_pdb/rac_sdb ~]# cd /home/grid/grid_software/grid/rpm/
[root@rac_pdb/rac_sdb rpm]# ls -ltr
/*
-rwxrwxr-x 1 grid oinstall 8551 Sep 22  2011 cvuqdisk-1.0.9-1.rpm
*/

[root@rac_pdb/rac_sdb rpm]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP
[root@rac_pdb/rac_sdb rpm]# rpm -iv cvuqdisk-1.0.9-1.rpm 
/*
Preparing packages for installation...
cvuqdisk-1.0.9-1
*/

[root@rac_pdb/rac_sdb rpm]# rpm -iUvh cvuqdisk-1.0.9-1.rpm 
/*
Preparing...                ########################################### [100%]
   package cvuqdisk-1.0.9-1.x86_64 is already installed
*/

[root@rac_pdb/rac_sdb rpm]# rpm -qa | grep cvuq
/*
cvuqdisk-1.0.9-1.x86_64
*/

-- Step 140 -->> On both Primary (DC) and Standby (DR) Database Servers
[root@rac_pdb/rac_sdb rpm]# init 0

-- Step 141 -->> On both Primary (DC) and Standby (DR) Database Servers
-- Login as grid user and issu the following command
[grid@rac_pdb/rac_sdb Desktop]$ cd 
[grid@rac_pdb/rac_sdb ~]$ hostname
/*
rac_pdb/rac_sdb.mydoamin
*/
[grid@rac_pdb/rac_sdb ~]$ xhost + rac_pdb/rac_sdb.mydoamin
/*
rac_pdb/rac_sdb.mydoamin being added to access control list
*/

-- Note: 
-- Login as grid user and issue the following command at rac_pdb 
-- Make sure choose proper groups while installing grid
-- OSDBA  Group => asmdba
-- OSOPER Group => asmoper
-- OSASM  Group => asmadmin
-- oraInventory Group Name => oinstall

[grid@rac_pdb/rac_sdb ~]$ cd /home/grid/grid_software/grid/
[grid@rac_pdb/rac_sdb grid]$ ls
/*
doc      readme.html  rpm           runInstaller  stage
install  response     runcluvfy.sh  sshsetup      welcome.html
*/
[grid@rac_pdb/rac_sdb grid]$ sh ./runInstaller 

-- Run from root user to finalized the setup for both Servers
-- Step 142 -->> On both Primary (DC) and Standby (DR) Database Servers
[root@rac_pdb/rac_sdb ~]# /u01/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /u01/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /u01/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 143 -->> On both Primary (DC) and Standby (DR) Database Servers
[root@rac_pdb/rac_sdb ~]# /u01/11.2.0.3.0/grid/root.sh 
/*
Performing root user operation for Oracle 11g 

The following environment variables are set as:
    ORACLE_OWNER= grid
    ORACLE_HOME=  /u01/11.2.0.3.0/grid

Enter the full pathname of the local bin directory: [/usr/local/bin]: 
   Copying dbhome to /usr/local/bin ...
   Copying oraenv to /usr/local/bin ...
   Copying coraenv to /usr/local/bin ...

Creating /etc/oratab file...
Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Using configuration parameter file: /u01/11.2.0.3.0/grid/crs/install/crsconfig_params
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
Adding Clusterware entries to upstart
CRS-2672: Attempting to start 'ora.mdnsd' on 'rac_pdb/rac_sdb'
CRS-2676: Start of 'ora.mdnsd' on 'rac_pdb/rac_sdb' succeeded
CRS-2672: Attempting to start 'ora.gpnpd' on 'rac_pdb/rac_sdb'
CRS-2676: Start of 'ora.gpnpd' on 'rac_pdb/rac_sdb' succeeded
CRS-2672: Attempting to start 'ora.cssdmonitor' on 'rac_pdb/rac_sdb'
CRS-2672: Attempting to start 'ora.gipcd' on 'rac_pdb/rac_sdb'
CRS-2676: Start of 'ora.cssdmonitor' on 'rac_pdb/rac_sdb' succeeded
CRS-2676: Start of 'ora.gipcd' on 'rac_pdb/rac_sdb' succeeded
CRS-2672: Attempting to start 'ora.cssd' on 'rac_pdb/rac_sdb'
CRS-2672: Attempting to start 'ora.diskmon' on 'rac_pdb/rac_sdb'
CRS-2676: Start of 'ora.diskmon' on 'rac_pdb/rac_sdb' succeeded
CRS-2676: Start of 'ora.cssd' on 'rac_pdb/rac_sdb' succeeded

ASM created and started successfully.

Disk Group OCR created successfully.

clscfg: -install mode specified
Successfully accumulated necessary OCR keys.
Creating OCR keys for user 'root', privgrp 'root'..
Operation successful.
CRS-4256: Updating the profile
Successful addition of voting disk 2f065f46f6074f47bf8af001441f1d6b.
Successfully replaced voting disk group with +OCR.
CRS-4256: Updating the profile
CRS-4266: Voting file(s) successfully replaced
##  STATE    File Universal Id                File Name Disk group
--  -----    -----------------                --------- ---------
 1. ONLINE   2f065f46f6074f47bf8af001441f1d6b (ORCL:OCR) [OCR]
Located 1 voting disk(s).
CRS-2672: Attempting to start 'ora.asm' on 'rac_pdb/rac_sdb'
CRS-2676: Start of 'ora.asm' on 'rac_pdb/rac_sdb' succeeded
CRS-2672: Attempting to start 'ora.OCR.dg' on 'rac_pdb/rac_sdb'
CRS-2676: Start of 'ora.OCR.dg' on 'rac_pdb/rac_sdb' succeeded
Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 144 -->> On both Primary (DC) and Standby (DR) Database Servers
[root@rac_pdb/rac_sdb ~]# cd /u01/app/11.2.0.3/grid/bin/
[root@rac_pdb/rac_sdb bin]# ./crsctl check crs
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/

[root@rac_pdb/rac_sdb bin]# ./crsctl check cluster -all
/*
**************************************************************
rac_pdb/rac_sdb:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/

[root@rac_pdb/rac_sdb bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS       
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       rac_pdb/rac_sdb                  Started             
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       rac_pdb/rac_sdb                                      
ora.crf
      1        ONLINE  ONLINE       rac_pdb/rac_sdb                                      
ora.crsd
      1        ONLINE  ONLINE       rac_pdb/rac_sdb                                      
ora.cssd
      1        ONLINE  ONLINE       rac_pdb/rac_sdb                                      
ora.cssdmonitor
      1        ONLINE  ONLINE       rac_pdb/rac_sdb                                      
ora.ctssd
      1        ONLINE  ONLINE       rac_pdb/rac_sdb                  ACTIVE:0            
ora.diskmon
      1        OFFLINE OFFLINE                                                   
ora.evmd
      1        ONLINE  ONLINE       rac_pdb/rac_sdb                                      
ora.gipcd
      1        ONLINE  ONLINE       rac_pdb/rac_sdb                                      
ora.gpnpd
      1        ONLINE  ONLINE       rac_pdb/rac_sdb                                      
ora.mdnsd
      1        ONLINE  ONLINE       rac_pdb/rac_sdb                                      
*/

[root@rac_pdb/rac_sdb bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS       
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.OCR.dg
               ONLINE  ONLINE       rac_pdb/rac_sdb                                      
ora.asm
               ONLINE  ONLINE       rac_pdb/rac_sdb                  Started             
ora.gsd
               OFFLINE OFFLINE      rac_pdb/rac_sdb                                      
ora.net1.network
               ONLINE  ONLINE       rac_pdb/rac_sdb                                      
ora.ons
               ONLINE  ONLINE       rac_pdb/rac_sdb                                      
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       rac_pdb/rac_sdb                                      
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       rac_pdb/rac_sdb                                      
ora.cvu
      1        ONLINE  ONLINE       rac_pdb/rac_sdb                                      
ora.oc4j
      1        ONLINE  ONLINE       rac_pdb/rac_sdb                                      
ora.rac_pdb/rac_sdb.vip
      1        ONLINE  ONLINE       rac_pdb/rac_sdb                                      
ora.scan1.vip
      1        ONLINE  ONLINE       rac_pdb/rac_sdb                                      
ora.scan2.vip
      1        ONLINE  ONLINE       rac_pdb/rac_sdb                                      
*/

[root@rac_pdb/rac_sdb bin]# ./ocrcheck
/*
Status of Oracle Cluster Registry is as follows :
    Version                  :          3
    Total space (kbytes)     :     262120
    Used space (kbytes)      :       2120
    Available space (kbytes) :     260000
    ID                       : 1339548959
    Device/File Name         :       +OCR
                                      Device/File integrity check succeeded
   
                                      Device/File not configured
   
                                      Device/File not configured
   
                                      Device/File not configured
   
                                      Device/File not configured
   
    Cluster registry integrity check succeeded
   
    Logical corruption check succeeded
*/

[root@rac_pdb/rac_sdb bin]# ./crsctl query css votedisk
/*
##  STATE    File Universal Id                File Name Disk group
--  -----    -----------------                --------- ---------
 1. ONLINE   97f9e1f5eb374fc3bfe672f4f1ca3c72 (ORCL:OCR) [OCR]
*/

[grid@rac_pdb/rac_sdb ~]$ asmcmd
/*
ASMCMD> lsdg
State    Type    Rebal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512   4096  1048576     20479    20126                0           20126              0             Y  OCR/
ASMCMD> exit
*/

-- Step 145 -->> On both Primary (DC) and Standby (DR) Database Servers
-- Click on Next Button to finish installation

-- Step 146 -->> On both Primary (DC) and Standby (DR) Database Servers
-- Login as oracle user and issu the following command at rac_pdb 
[oracle@rac_pdb/rac_sdb Desktop]$ cd 
[oracle@rac_pdb/rac_sdb ~]$ hostname
/*
rac_pdb/rac_sdb.mydoamin
*/

[oracle@rac_pdb/rac_sdb ~]$ xhost + rac_pdb/rac_sdb.mydoamin
/*
rac_pdb/rac_sdb.mydoamin being added to access control list
*/

-- Step 147 -->> On both Primary (DC) and Standby (DR) Database Servers
[oracle@rac_pdb/rac_sdb ~]$ cd /home/oracle/oracle_software/database/
-- Install database software only => Real Application Cluster database installation
-- Make sure choose proper groups while installing oracle
-- OSDBA  Group => dba
-- OSOPER Group => oper

[oracle@rac_pdb/rac_sdb oracle]$ ls
/*
doc      readme.html  rpm           runInstaller  stage
install  response     runcluvfy.sh  sshsetup      welcome.html
*/
[oracle@rac_pdb/rac_sdb oracle]$ sh ./runInstaller 

-- Step 148 -->> On both Primary (DC) and Standby (DR) Database Servers
-- Run from root user to finalized the setup for both racs
[root@rac_pdb/rac_sdb ~]# /u01/app/oracle/product/11.2.0.3.0/db_1/root.sh
/*
Performing root user operation for Oracle 11g 

The following environment variables are set as:
    ORACLE_OWNER= oracle
    ORACLE_HOME=  /u01/app/oracle/product/11.2.0.3.0/db_1

Enter the full pathname of the local bin directory: [/usr/local/bin]: 
The contents of "dbhome" have not changed. No need to overwrite.
The contents of "oraenv" have not changed. No need to overwrite.
The contents of "coraenv" have not changed. No need to overwrite.

Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Finished product-specific root actions.
*/

-- Step 149 -->> On both Primary (DC) and Standby (DR) Database Servers
-- Login as grid user and issu the following command
-- To add DATA and FRA storage
[grig@rac_pdb/rac_sdb ~]# su - grid
[grid@rac_pdb/rac_sdb ~]$ hostname
/*
rac_pdb/rac_sdb.mydoamin
*/
[grid@rac_pdb/rac_sdb ~]$ xhost + rac_pdb/rac_sdb.mydoamin
/*
rac_pdb/rac_sdb.mydoamin being added to access control list
*/

[grig@rac_pdb/rac_sdb ~]# cd /u01/11.2.0.3.0/grid/bin
[grig@rac_pdb/rac_sdb bin]# ./asmca

-- Step 150 -->> On both Primary (DC) and Standby (DR) Database Servers
-- Verify from grid storage level
[grid@rac_pdb/rac_sdb ~]$ asmcmd
/*
ASMCMD> lsdg
State    Type    Rebal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512   4096  1048576     40959    40907                0           40907              0             N  DATA/
MOUNTED  EXTERN  N         512   4096  1048576     25599    25547                0           25547              0             N  FRA/
MOUNTED  EXTERN  N         512   4096  1048576     20479    20126                0           20126              0             Y  OCR/
ASMCMD> exit
*/

-- Verify from /etc/oratab configuration level
[root@rac_pdb/rac_sdb ~]# vi /etc/oratab
/*
+ASM1:/u01/11.2.0.3.0/grid:N        # line added by Agent
*/

-- Step 151 -->> On Standby (DR) Database Servers
[oracle@rac_sdb ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 15-DEC-2019 12:34:49

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                15-DEC-2019 12:20:44
Uptime                    0 days 0 hr. 14 min. 4 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /u01/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /u01/app/oracle/diag/tnslsnr/rac_sdb/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.106)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.108)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1| status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 152 -->> On Primary (DC) Database Servers
-- To create database
[oracle@rac_pdb ~]# su - oracle
[oracle@rac_pdb ~]# cd /u01/app/oracle/product/11.2.0.3.0/db_1/bin
[oracle@rac_pdb bin]# ./dbca

-- Step 153 -->> On Primary (DC) Database Servers
[root@rac_pdb ~]# vi /etc/oratab
/*
+ASM1:/u01/11.2.0.3.0/grid:N        # line added by Agent
racdb1:/u01/app/oracle/product/11.2.0.3.0/db_1:N        # line added by Agent
*/

-- Step 154 -->> On Primary (DC) Database Servers
[oracle@rac_pdb ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 15-DEC-2019 12:37:59

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                15-DEC-2019 12:20:47
Uptime                    0 days 0 hr. 17 min. 11 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /u01/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /u01/app/oracle/diag/tnslsnr/rac_pdb/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.105)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.107)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1| status READY, has 1 handler(s) for this service...
Service "rac_pdb" has 1 instance(s).
  Instance "racdb1| status READY, has 1 handler(s) for this service...
Service "racpdbXDB" has 1 instance(s).
  Instance "racdb1| status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 155 -->> On Primary (DC) Database Servers
[oracle@rac_pdb ~]$ sqlplus sys/sys as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Tue Sep 17 12:27:22 2019

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT status, instance_name FROM gv$instance;

STATUS  INSTANCE_NAME
------  -------------
OPEN    racdb1


SQL> select file_name from dba_data_files;

FILE_NAME
--------------------------------------------------------------------------------
+DATA/rac_pdb/datafile/users.259.1026904915
+DATA/rac_pdb/datafile/undotbs1.258.1026904915
+DATA/rac_pdb/datafile/sysaux.257.1026904915
+DATA/rac_pdb/datafile/system.256.1026904915

SQL> exit
*/

-- Step 156 -->> On Primary (DC) Database Servers
[oracle@rac_pdb ~]$ which srvctl
/*
/u01/app/oracle/product/11.2.0.3.0/db_1/bin/srvctl
*/
[oracle@rac_pdb ~]$ srvctl stop database -d racdb
[oracle@rac_pdb ~]$ srvctl status database -d racdb
/*
Instance racdb1 is not running on node rac_pdb
*/
[oracle@rac_pdb ~]$ srvctl start database -d racdb -o mount
[oracle@rac_pdb ~]$ sqlplus sys/sys as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Fri Nov 29 20:50:08 2019

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> select status, instance_name from gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
MOUNTED      racdb1

SQL> alter database archivelog;

Database altered.

SQL> exit 
*/

[oracle@rac_pdb ~]$ srvctl stop database -d racdb
[oracle@rac_pdb ~]$ srvctl start database -d racdb
[oracle@rac_pdb ~]$ sqlplus sys/sys as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Fri Nov 29 20:53:25 2019

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> select status, instance_name from gv$instance;

STATUS INSTANCE_NAME
------ ------------
OPEN   racdb1

SQL> archive log list;
Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     4
Next log sequence to archive   5
Current log sequence           5
SQL> alter system switch logfile;

System altered.

SQL> /

System altered.

SQL> exit
*/ 

-- For disabling archive mode also steps are same (If you want)
/*
srvctl stop database -d racdb
srvctl start database -d racdb -o mount
alter database noarchivelog;
srvctl stop database -d racdb
srvctl start database -d racdb
*/

-- Step 157 -->> On Primary (DC) Database Servers
[grid@rac_pdb ~]$ cd /u01/11.2.0.3.0/grid/bin/
[grid@rac_pdb bin]$ ./crsctl check cluster -all
/*
**************************************************************
rac_pdb:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/

[grid@rac_pdb bin]$ ./crsctl check crs
/*
CRS-4638: Oracle High Availability Services is online
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/

[grid@rac_pdb bin]$ ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS       
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       rac_pdb                  Started             
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       rac_pdb                                      
ora.crf
      1        ONLINE  ONLINE       rac_pdb                                      
ora.crsd
      1        ONLINE  ONLINE       rac_pdb                                      
ora.cssd
      1        ONLINE  ONLINE       rac_pdb                                      
ora.cssdmonitor
      1        ONLINE  ONLINE       rac_pdb                                      
ora.ctssd
      1        ONLINE  ONLINE       rac_pdb                  ACTIVE:0            
ora.diskmon
      1        OFFLINE OFFLINE                                                   
ora.evmd
      1        ONLINE  ONLINE       rac_pdb                                      
ora.gipcd
      1        ONLINE  ONLINE       rac_pdb                                      
ora.gpnpd
      1        ONLINE  ONLINE       rac_pdb                                      
ora.mdnsd
      1        ONLINE  ONLINE       rac_pdb                                      
*/

[grid@rac_pdb bin]$ ./crsctl stat res -t 
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS       
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.DATA.dg
               ONLINE  ONLINE       rac_pdb                                      
ora.FRA.dg
               ONLINE  ONLINE       rac_pdb                                      
ora.LISTENER.lsnr
               ONLINE  ONLINE       rac_pdb                                      
ora.OCR.dg
               ONLINE  ONLINE       rac_pdb                                      
ora.asm
               ONLINE  ONLINE       rac_pdb                  Started             
ora.gsd
               OFFLINE OFFLINE      rac_pdb                                      
ora.net1.network
               ONLINE  ONLINE       rac_pdb                                      
ora.ons
               ONLINE  ONLINE       rac_pdb                                      
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       rac_pdb                                      
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       rac_pdb                                      
ora.cvu
      1        ONLINE  ONLINE       rac_pdb                                      
ora.oc4j
      1        ONLINE  ONLINE       rac_pdb                                      
ora.rac_pdb.db
      1        ONLINE  ONLINE       rac_pdb                  Open                
ora.rac_pdb.vip
      1        ONLINE  ONLINE       rac_pdb                                      
ora.scan1.vip
      1        ONLINE  ONLINE       rac_pdb                                      
ora.scan2.vip
      1        ONLINE  ONLINE       rac_pdb                                      
*/

[oracle@rac_pdb ~]$ which srvctl
/*
/u01/app/oracle/product/11.2.0.3.0/db_1/bin/srvctl
*/

[oracle@rac_pdb ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node rac_pdb
*/

-- Step 158 -->> On Standby (DR) Database Servers
[grid@rac_sdb bin]$ ./crsctl check cluster -all
/*
**************************************************************
rac_sdb:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/

[grid@rac_sdb bin]$ ./crsctl check crs
/*
CRS-4638: Oracle High Availability Services is online
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/

[grid@rac_sdb bin]$ ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS       
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       rac_sdb                  Started             
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       rac_sdb                                      
ora.crf
      1        ONLINE  ONLINE       rac_sdb                                      
ora.crsd
      1        ONLINE  ONLINE       rac_sdb                                      
ora.cssd
      1        ONLINE  ONLINE       rac_sdb                                      
ora.cssdmonitor
      1        ONLINE  ONLINE       rac_sdb                                      
ora.ctssd
      1        ONLINE  ONLINE       rac_sdb                  ACTIVE:0            
ora.diskmon
      1        OFFLINE OFFLINE                                                   
ora.evmd
      1        ONLINE  ONLINE       rac_sdb                                      
ora.gipcd
      1        ONLINE  ONLINE       rac_sdb                                      
ora.gpnpd
      1        ONLINE  ONLINE       rac_sdb                                      
ora.mdnsd
      1        ONLINE  ONLINE       rac_sdb     
*/

[grid@rac_sdb bin]$ ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS       
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.DATA.dg
               ONLINE  ONLINE       rac_sdb                                      
ora.FRA.dg
               ONLINE  ONLINE       rac_sdb                                      
ora.LISTENER.lsnr
               ONLINE  ONLINE       rac_sdb                                      
ora.OCR.dg
               ONLINE  ONLINE       rac_sdb                                      
ora.asm
               ONLINE  ONLINE       rac_sdb                  Started             
ora.gsd
               OFFLINE OFFLINE      rac_sdb                                      
ora.net1.network
               ONLINE  ONLINE       rac_sdb                                      
ora.ons
               ONLINE  ONLINE       rac_sdb                                      
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       rac_sdb                                      
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       rac_sdb                                      
ora.cvu
      1        ONLINE  ONLINE       rac_sdb                                      
ora.oc4j
      1        ONLINE  ONLINE       rac_sdb                                      
ora.rac_sdb.vip
      1        ONLINE  ONLINE       rac_sdb                                      
ora.scan1.vip
      1        ONLINE  ONLINE       rac_sdb                                      
ora.scan2.vip
      1        ONLINE  ONLINE       rac_sdb   
*/

[oracle@rac_sdb ~]$ which srvctl
/*
/u01/app/oracle/product/11.2.0.3.0/db_1/bin/srvctl
*/
[oracle@rac_sdb ~]$ srvctl status database -d racdb_dr
/*
PRCD-1120 : The resource for database racdb_dr could not be found.
PRCR-1001 : Resource ora.rac_sdb.db does not exist
*/

--Step 159 -->> On Primary (DC) Database Servers & Standby (DR) Database Servers
-- Create backup Location on (DC) & (DR)
[oracle@rac_pdb/rac_sdb ~]$ mkdir -p /home/oracle/backup
[oracle@rac_pdb/rac_sdb ~]$ chmod -R 775 /home/oracle/backup/
[oracle@rac_pdb/rac_sdb ~]$ cd /home/oracle/
[oracle@rac_pdb/rac_sdb oracle]$ ls -ltr | grep backup
/*
drwxrwxr-x 2 oracle oinstall 4096 Dec 25 10:55 backup
*/

--Step 160 -->> On Primary (DC) Database Servers
-- Enable Force Logging.
[oracle@rac_pdb ~]$ which srvctl
/*
/u01/app/oracle/product/11.2.0.3.0/db_1/bin/srvctl
*/
[oracle@rac_pdb ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node rac_pdb
*/
[oracle@rac_pdb ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Thu Dec 19 10:51:03 2019

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT status, instance_name FROM gv$instance;

STATUS  INSTANCE_NAME
------- ----------------
OPEN    racdb1

SQL> SELECT name, open_mode,force_logging FROM gv$database;

NAME  OPEN_MODE   FORCE_LOGGING
----- ----------- ---------------
RACDB READ WRITE  NO

SQL> ALTER DATABASE FORCE LOGGING;

Database altered.

SQL> SELECT name, open_mode,force_logging FROM gv$database;

NAME  OPEN_MODE   FORCE_LOGGING
----- ----------- ---------------
RACDB READ WRITE  YES

SQL> 
*/

--Step 161 -->> On Primary (DC) Database Servers
-- Configure a Standby Redo Log on Primary
[oracle@rac_pdb ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Wed Dec 25 11:01:16 2019

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT group#,thread#,bytes FROM gv$log;

GROUP# THREAD# BYTES
------ ------- ----------
1      1       52428800
2      1       52428800
3      1       52428800

SQL> col member for a60
SQL> set lines 180
SQL> SELECT b.thread#, a.group#,a.type, a.member, b.bytes FROM gv$logfile a, gv$log b WHERE a.group# = b.group# order by 2;

THREAD# GROUP# TYPE    MEMBER                                         BYTES
------- ------ ------  ------- -------------------------------------- --------
1       1      ONLINE  +FRA/racdb/onlinelog/group_1.257.1026905023  52428800
1       1      ONLINE  +DATA/racdb/onlinelog/group_1.261.1026905021 52428800
1       2      ONLINE  +FRA/racdb/onlinelog/group_2.258.1026905025  52428800
1       2      ONLINE  +DATA/racdb/onlinelog/group_2.262.1026905023 52428800
1       3      ONLINE  +FRA/racdb/onlinelog/group_3.259.1026905027  52428800
1       3      ONLINE  +DATA/racdb/onlinelog/group_3.263.1026905025 52428800

-- To Fix the location / name issue
https://docs.oracle.com/cd/B10501_01/server.920/a96521/onlineredo.htm
-- To drop group
SELECT group#, archived, status FROM v$log;

GROUP# ARC STATUS
------ --- ----------------
     1 YES ACTIVE
     2 NO  CURRENT
     3 YES INACTIVE
     4 YES INACTIVE

ALTER DATABASE DROP LOGFILE GROUP 1;

-- To Clearing group
ALTER DATABASE CLEAR LOGFILE GROUP 2;

-- If the corrupTredo log file has not been archived, use the UNARCHIVED keyword in the statement.
ALTER DATABASE CLEAR UNARCHIVED LOGFILE GROUP 3;

-- To Add group
ALTER DATABASE ADD LOGFILE GROUP 1 '+DATA/racdb/onlinelog/redo01.log' SIZE 50M;

-- To Add Logfile Memebers to relevant group
ALTER DATABASE ADD LOGFILE MEMBER '+DATA/racdb/onlinelog/redo03.log' TO GROUP 1;

--To drop redo log member
ALTER DATABASE DROP LOGFILE MEMBER '+DATA/racdb/onlinelog/group_3.263.1026905025';

col MEMBER for a60
SET lines 180
SELECT b.thread#, a.group#,a.type, a.member, b.bytes FROM gv$logfile a, gv$log b WHERE a.group# = b.group# order by 2;

THREAD# GROUP# TYPE    MEMBER                             BYTES
------- ------ ------  ------- -------------------------- --------
1       1      ONLINE  +DATA/racdb/onlinelog/redo01.log  52428800
1       2      ONLINE  +DATA/racdb/onlinelog/redo02.log  52428800
1       3      ONLINE  +DATA/racdb/onlinelog/redo03.log  52428800

ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 4 ('+DATA/racdb/onlinelog/redo04.log') SIZE 50M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 5 ('+DATA/racdb/onlinelog/redo05.log') SIZE 50M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 6 ('+DATA/racdb/onlinelog/redo06.log') SIZE 50M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 7 ('+DATA/racdb/onlinelog/redo07.log') SIZE 50M;

SQL> SELECT b.thread#,a.group#, a.type, a.member, b.bytes FROM gv$logfile a, gv$standby_log b WHERE a.group# = b.group#;

THREAD# GROUP#  TYPE    MEMBER                             BYTES
------- ------- ------- ---------------------------------- --------
1       4       STANDBY +DATA/racdb/onlinelog/redo04.log 52428800
1       5       STANDBY +DATA/racdb/onlinelog/redo05.log 52428800
1       6       STANDBY +DATA/racdb/onlinelog/redo06.log 52428800
1       7       STANDBY +DATA/racdb/onlinelog/redo07.log 52428800

SQL> SELECT * FROM v$logfile order by 1;

GROUP# STATUS  TYPE    MEMBER                             IS_RECOVERY_DEST_FILE
------ ------- ------- ---------------------------------- ---------------------
1              ONLINE  +DATA/racdb/onlinelog/redo01.log NO
2              ONLINE  +DATA/racdb/onlinelog/redo02.log NO
3              ONLINE  +DATA/racdb/onlinelog/redo03.log NO
4              STANDBY +DATA/racdb/onlinelog/redo04.log NO
5              STANDBY +DATA/racdb/onlinelog/redo05.log NO
6              STANDBY +DATA/racdb/onlinelog/redo06.log NO
7              STANDBY +DATA/racdb/onlinelog/redo07.log NO

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


REDOLOG_FILE_TYPE    INST_ID GROUP# THREAD# SEQUENCE# MEMBER                           STATUS     ARCHIVE SIZE_MB
-------------------- ------- ------ ------- --------- -------------------------------- ---------- ------- -------
[ ONLINE REDO LOG ]  1       1      1       15        +DATA/racdb/onlinelog/redo01.log CURRENT    NO      50
[ ONLINE REDO LOG ]  1       2      1       14        +DATA/racdb/onlinelog/redo02.log INACTIVE   YES     50
[ ONLINE REDO LOG ]  1       3      1       13        +DATA/racdb/onlinelog/redo03.log INACTIVE   YES     50
[ STANDBY REDO LOG ] 1       4      1       0         +DATA/racdb/onlinelog/redo04.log UNASSIGNED YES     50
[ STANDBY REDO LOG ] 1       5      1       0         +DATA/racdb/onlinelog/redo05.log UNASSIGNED YES     50
[ STANDBY REDO LOG ] 1       6      1       0         +DATA/racdb/onlinelog/redo06.log UNASSIGNED YES     50
[ STANDBY REDO LOG ] 1       7      1       0         +DATA/racdb/onlinelog/redo07.log UNASSIGNED YES     50
*/

--Step 162 -->> On Primary (DC) Database Servers
--  Verify Archive Mode Enabled on Primary
[oracle@rac_pdb ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Wed Dec 25 11:01:16 2019

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> archive log list
Database log mode             Archive Mode
Automatic archival            Enabled
Archive destination           USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence    13
Next log sequence to archive  15
Current log sequence          15
*/

--Step 163 -->> On Primary (DC) Database Servers
-- SET Primary Database Initialization Parameters
-- Now, verify all the required values have the appropriate values.
[oracle@rac_pdb ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Wed Dec 25 11:01:16 2019

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


NAME                         VALUE
---------------------------- --------------------------------------------------
db_file_name_convert
log_file_name_convert
log_archive_dest_1
log_archive_dest_2
log_archive_dest_state_1     enable
log_archive_dest_state_2     enable
fal_client
fal_server
log_archive_config
log_archive_format           %t_%s_%r.dbf
log_archive_max_processes    4
standby_file_management      MANUAL
remote_login_passwordfile    EXCLUSIVE
audit_file_dest              /u01/app/oracle/admin/racdb/adump
db_name                      racdb
db_unique_name               racdb

SQL> show parameter db_unique_name

NAME           TYPE   VALUE
-------------- ------ -----
db_unique_name string racdb

SQL> ALTER system SET db_unique_name='racdb' scope=spfile sid='*';
SQL> ALTER system SET log_archive_config='DG_CONFIG=(racdb,racdb_dr)' scope=both sid='*';
SQL> ALTER system SET log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=racdb' scope=both sid='*';
SQL> ALTER system SET LOG_ARCHIVE_DEST_2='SERVICE=racdb_dr VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=racdb_dr' scope=both sid='*';
SQL> ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_1=ENABLE scope=both sid='*';
SQL> ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2=ENABLE scope=both sid='*';
SQL> ALTER system SET log_archive_format='racdb_%t_%s_%r.arc' scope=spfile sid='*';
SQL> ALTER system SET LOG_ARCHIVE_MAX_PROCESSES=8 scope=both sid='*';
SQL> ALTER system SETrEMOTE_LOGIN_PASSWORDFILE=EXCLUSIVE scope=spfile sid='*';
SQL> ALTER SYSTEM SET fal_client='racdb' scope=both;
SQL> ALTER system SET fal_server = 'racdb_dr' sid='*';
SQL> ALTER system SET STANDBY_FILE_MANAGEMENT=AUTO scope=spfile sid='*';
SQL> ALTER system SET db_file_name_convert='+DATA/racdb/','+DATA/racdb_dr/', '+FRA/racdb/','+FRA/racdb_dr/' scope=spfile sid='*';
SQL> ALTER system SET log_file_name_convert='+DATA/racdb/','+DATA/racdb_dr/', '+FRA/racdb/','+FRA/racdb_dr/' scope=spfile sid='*';
SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

--Step 164 -->> On Primary (DC) Database Servers
-- Reboot the Server to set Intial parameter 
[oracle@rac_pdb ~]$ which srvctl
/u01/app/oracle/product/11.2.0.3.0/db_1/bin/srvctl
[oracle@rac_pdb ~]$ srvctl stop database -d racdb
[oracle@rac_pdb ~]$ srvctl start database -d racdb
[oracle@rac_pdb ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node rac_pdb
*/

--Step 165 -->> On Primary (DC) Database Servers
-- Verify the Intial parameter 
[oracle@rac_pdb ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Wed Dec 25 11:30:33 2019

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> set lines 999 pages 999
SQL> col name for a40 
SQL> col value for a100
SQL> SELECT
          name,
          value
     FROM v$parameter
     WHERE name IN ('db_name','db_unique_name','log_archive_config', 'log_archive_dest_1','log_archive_dest_2','log_archive_dest_state_1','log_archive_dest_state_2',
     'remote_login_passwordfile','log_archive_format','log_archive_max_processes','fal_server','fal_client','standby_file_management',
     'db_file_name_convert','log_file_name_convert','audit_file_dest');

NAME                         VALUE
---------------------------- ---------------
db_file_name_convert         +DATA/racdb/, +DATA/racdb_dr/, +FRA/racdb/, +FRA/racdb_dr/
log_file_name_convert        +DATA/racdb/, +DATA/racdb_dr/, +FRA/racdb/, +FRA/racdb_dr/
log_archive_dest_1           LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=racdb
log_archive_dest_2           SERVICE=racdb_dr VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=racdb_dr
log_archive_dest_state_1     ENABLE
log_archive_dest_state_2     ENABLE
fal_client                   racdb
fal_server                   racdb_dr
log_archive_config           DG_CONFIG=(racdb,racdb_dr)
log_archive_format           racdb_%t_%s_%r.arc
log_archive_max_processes    8
standby_file_management      AUTO
remote_login_passwordfile    EXCLUSIVE
audit_file_dest              /u01/app/oracle/admin/racdb/adump
db_name                      racdb
db_unique_name               racdb

SQL> CREATE PFILE='/home/oracle/backup/spfileracdb.ora' FROM SPFILE;

SQL> exit
*/

--Step 166 -->> On Primary (DC) Database Servers
-- Verfy the parameter file
[oracle@rac_pdb backup]$ cat /home/oracle/backup/spfileracdb.ora
/*
racdb1.__db_cache_size=369098752
racdb1.__java_pool_size=4194304
racdb1.__large_pool_size=4194304
racdb1.__pga_aggregate_target=209715200
racdb1.__sga_target=629145600
racdb1.__shared_io_pool_size=0
racdb1.__shared_pool_size=239075328
racdb1.__streams_pool_size=0
*.audit_file_dest='/u01/app/oracle/admin/racdb/adump'
*.audit_trail='db'
*.cluster_database=true
*.compatible='11.2.0.0.0'
*.control_files='+DATA/racdb/controlfile/current.260.1027866129','+FRA/racdb/controlfile/current.256.1027866131'
*.db_block_size=8192
*.db_create_file_dest='+DATA'
*.db_domain=''
*.db_file_name_convert='+DATA/racdb/','+DATA/racdb_dr/','+FRA/racdb/','+FRA/racdb_dr/'
*.db_name='racdb'
*.db_recovery_file_dest='+FRA'
*.db_recovery_file_dest_size=4322230272
*.db_unique_name='racdb'
*.diagnostic_dest='/u01/app/oracle'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=racdbXDB)'
*.fal_client='racdb'
*.fal_server='racdb_dr'
racdb1.instance_number=1
*.log_archive_config='DG_CONFIG=(racdb,racdb_dr)'
*.log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=racdb'
*.log_archive_dest_2='SERVICE=racdb_dr VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=racdb_dr'
*.log_archive_dest_state_1='ENABLE'
*.log_archive_dest_state_2='ENABLE'
*.log_archive_format='racdb_%t_%s_%r.arc'
*.log_archive_max_processes=8
*.log_file_name_convert='+DATA/racdb/','+DATA/racdb_dr/','+FRA/racdb/','+FRA/racdb_dr/'
*.open_cursors=300
*.pga_aggregate_target=209715200
*.processes=150
*.remote_listener='rac-scan.mydoamin:1521'
*.remote_login_passwordfile='EXCLUSIVE'
*.sga_target=629145600
*.standby_file_management='AUTO'
racdb1.thread=1
racdb1.undo_tablespace='UNDOTBS1'
*/

--Step 167 -->> On Primary (DC) Database Servers
-- Backup the primary database that includes backup of datafiles, archivelogs and controlfile for standby
[oracle@rac_pdb ~]$ rman target / nocatalog
/*
Recovery Manager: Release 11.2.0.3.0 - Production on Wed Dec 25 11:39:20 2019

Copyright (c) 1982, 2011, Oracle and/or its affiliates.  All rights reserved.

connected to target database: RACDB (DBID=1025482897)
using target database control file instead of recovery catalog

RMAN> run
{
  ALLOCATE CHANNEL c1 DEVICE TYPE DISK MAXPIECESIZE 10G;
  ALLOCATE CHANNEL c2 DEVICE TYPE DISK MAXPIECESIZE 10G;
  ALLOCATE CHANNEL c3 DEVICE TYPE DISK MAXPIECESIZE 10G;

  SQL "ALTER SYSTEM SWITCH LOGFILE";
  BACKUP DATABASE FORMAT '/home/oracle/backup/database_%d_%u_%s';

  SQL "ALTER SYSTEM ARCHIVE LOG CURRENT";
  BACKUP ARCHIVELOG ALL FORMAT '/home/oracle/backup/arch_%d_%u_%s';

  BACKUP CURRENT CONTROLFILE FOR STANDBY FORMAT '/home/oracle/backup/Control_%d_%u_%s';
  release channel c1;
  release channel c2;
  release channel c3;
}
*/

--Step 168 -->> On Primary (DC) Database Servers
-- Transfer PASSWORD FILE TO STANDBY SIDE
[oracle@rac_pdb ~]$ cd /u01/app/oracle/product/11.2.0.3.0/db_1/dbs/
[oracle@rac_pdb dbs]$ ls -ltr | grep orapwracdb 
/*
-rw-r----- 1 oracle oinstall     1536 Dec 24 14:22 orapwracdb
-rw-r----- 1 oracle oinstall     1536 Dec 24 14:22 orapwracdb1
*/

[oracle@rac_pdb dbs]$ scp orapwracdb oracle@192.168.1.106:/u01/app/oracle/product/11.2.0.3.0/db_1/dbs/orapwracdb
/*
orapwracdb                                  100% 1536     1.5KB/s   00:00    
*/

[oracle@rac_pdb dbs]$ scp orapwracdb1 oracle@192.168.1.106:/u01/app/oracle/product/11.2.0.3.0/db_1/dbs/orapwracdb1
/*
orapwracdb1                                  100% 1536     1.5KB/s   00:00    
*/

--Step 169 -->> On Primary (DC) Database Servers
-- Transfer Backup FROM Primary to Standby
[oracle@rac_sdb ~]$ mkdir -p /home/oracle/backup
[oracle@rac_pdb ~]$ scp -p /home/oracle/backup/* oracle@192.168.1.106:/home/oracle/backup/
/*
arch_RACDB_13uknmru_35               100%   16MB  16.2MB/s   00:00    
arch_RACDB_14uknmrv_36               100%   39MB  39.5MB/s   00:01    
arch_RACDB_15uknmrv_37               100%   15MB  14.8MB/s   00:00    
arch_RACDB_16uknms1_38               100% 2486KB   2.4MB/s   00:01    
Control_RACDB_17uknmst_39            100%   18MB  17.7MB/s   00:00    
database_RACDB_0vuknmqb_31           100%  600MB  46.1MB/s   00:13    
database_RACDB_10uknmqb_32           100%  383MB  42.6MB/s   00:09    
database_RACDB_11uknmqc_33           100%   18MB  17.7MB/s   00:00    
database_RACDB_12uknmqs_34           100%   96KB  96.0KB/s   00:00    
spfileracdb.ora                      100% 1685     1.7KB/s   00:00    
*/

--Step 170 -->> On Primary (DC) Database Servers
-- Configure TNS for Primary
-- Now we need to modify/update $ORACLE_HOME/network/admin/tnsnames.ora file on primary node 1 as shown an example below

[oracle@rac_pdb ~]$ vi $ORACLE_HOME/network/admin/tnsnames.ora
/*
RACDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.1.105)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = racdb)
    )
  )

RACDB_DR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.1.106)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = racdb_dr)
    )
  )
*/

--Step 171 -->> On Primary (DC) Database Servers
-- Verify the TNS Connection
[oracle@rac_pdb ~]$ tnsping racdb
/*
TNS Ping Utility for Linux: Version 11.2.0.3.0 - Production on 25-DEC-2019 12:11:38

Copyright (c) 1997, 2011, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = rac-scan.mydoamin)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = racdb)))
OK (10 msec)
*/

[oracle@rac_pdb ~]$ tnsping racdb_dr
/*
TNS Ping Utility for Linux: Version 11.2.0.3.0 - Production on 25-DEC-2019 12:11:48

Copyright (c) 1997, 2011, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.1.106)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = racdb_dr)))
OK (10 msec)
*/

--Step 172 -->> On Primary (DC) Database Servers
-- Copy the tnsnames.ora FROM racdb to all the three nodes under $ORACLE_HOME/network/admin in order to keep the same tnsnames.ora on all the nodes.
[oracle@rac_pdb ~]$ cd /u01/app/oracle/product/11.2.0.3.0/db_1/network/admin
[oracle@rac_pdb admin]$ scp tnsnames.ora oracle@192.168.1.106:/u01/app/oracle/product/11.2.0.3.0/db_1/network/admin/
/*
tnsnames.ora                          100%  526     0.5KB/s   00:00    
*/

--Step 173 -->> On Secondary (DR) Database Servers
-- Change the TNS at DR
[oracle@rac_sdb ~]$ cd /u01/app/oracle/product/11.2.0.3.0/db_1/network/admin
[oracle@rac_sdb admin]$ vi tnsnames.ora 
/*
# tnsnames.ora Network Configuration File: /u01/app/oracle/product/11.2.0.3.0/db_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.
/*
RACDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.1.105)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = racdb)
    )
  )

RACDB_DR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.1.106)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = racdb_dr)
    )
  )
*/

--Step 174 -->> On Secondary (DR) Database Servers
-- Verify the TNS
[oracle@rac_sdb admin]$ tnsping racdb
/*
TNS Ping Utility for Linux: Version 11.2.0.3.0 - Production on 25-DEC-2019 12:17:50

Copyright (c) 1997, 2011, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.1.105)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = racdb)))
OK (0 msec)
*/

[oracle@rac_sdb admin]$ tnsping racdb_dr
/*
TNS Ping Utility for Linux: Version 11.2.0.3.0 - Production on 25-DEC-2019 12:17:55

Copyright (c) 1997, 2011, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.1.106)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = racdb_dr)))
OK (0 msec)
*/

--Step 175 -->> On Secondary (DR) Database Servers
-- Data Guard Configuration - Standby Site
-- Login to racdb_dr using oracle user and perform the following tasks to prepare Standby site data guard configuration.

--[oracle@rac_sdb ~]$ mkdir -p /u01/app/oracle/admin/racdb/hdump
--[oracle@rac_sdb ~]$ mkdir -p /u01/app/oracle/admin/racdb/dpdump
--[oracle@rac_sdb ~]$ mkdir -p /u01/app/oracle/admin/racdb/pfile
[oracle@rac_sdb ~]$ mkdir -p /u01/app/oracle/admin/racdb/adump

--Step 176 -->> On Secondary (DR) Database Servers
-- Modified in our paramter file initracdb_dr.ora for standby database creation in a dataguard environment.
[oracle@rac_sdb ~]$ vi /home/oracle/backup/spfileracdb.ora
/*
racdb1.__db_cache_size=369098752
racdb1.__java_pool_size=4194304
racdb1.__large_pool_size=4194304
racdb1.__oracle_base='/u01/app/oracle'#ORACLE_BASE set FROM environment
racdb1.__pga_aggregate_target=209715200
racdb1.__sga_target=629145600
racdb1.__shared_io_pool_size=0
racdb1.__shared_pool_size=239075328
racdb1.__streams_pool_size=0
*.audit_file_dest='/u01/app/oracle/admin/racdb/adump'
*.audit_trail='db'
*.cluster_database=true
*.compatible='11.2.0.0.0'
*.control_files='+DATA/racdb/controlfile/current.260.1027866129','+FRA/racdb/controlfile/current.256.1027866131'
*.db_block_size=8192
*.db_file_name_convert='+DATA/racdb/','+DATA/racdb_dr/','+FRA/racdb/','+FRA/racdb_dr/'
*.db_name='racdb'
*.db_recovery_file_dest='+FRA'
*.db_recovery_file_dest_size=4322230272
*.db_unique_name='racdb_dr'
*.diagnostic_dest='/u01/app/oracle'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=racdbXDB)'
*.fal_client='racdb_dr'
*.fal_server='racdb'
*.instance_name='racdb1'
racdb1.instance_number=1
*.log_archive_config='DG_CONFIG=(racdb,racdb_dr)'
*.log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=racdb_dr'
*.log_archive_dest_2='SERVICE=racdb VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=racdb'
*.log_archive_dest_state_1='ENABLE'
*.log_archive_dest_state_2='ENABLE'
*.log_archive_format='racdb_%t_%s_%r.arc'
*.log_file_name_convert='+DATA/racdb/','+DATA/racdb_dr/','+FRA/racdb/','+FRA/racdb_dr/'
*.nls_language='AMERICAN'
*.nls_territory='AMERICA'
*.open_cursors=300
*.pga_aggregate_target=288m
*.processes=300
*.remote_listener='192.168.1.106:1521'
*.remote_login_passwordfile='EXCLUSIVE'
*.sga_target=629145600
*.standby_file_management='AUTO'
racdb1.thread=1
racdb1.undo_tablespace='UNDOTBS1'
*/

--Step 177 -->> On Secondary (DR) Database Servers
-- Add oratab entry
[oracle@rac_sdb ~]$ vi /etc/oratab
/*
+ASM1:/u01/11.2.0.3.0/grid:N        # line added by Agent
racdb1:/u01/app/oracle/product/11.2.0.3.0/db_1:N        # line added by Agent
*/

--Step 178 -->> On Secondary (DR) Database Servers
-- Modify the initracdb1 file
[oracle@rac_sdb ~]$ vi /u01/app/oracle/product/11.2.0.3.0/db_1/dbs/initracdb1.ora
/*
SPFILE='+DATA/racdb_dr/spfileracdb.ora'
*/

[oracle@rac_sdb ~]$ cd /u01/app/oracle/product/11.2.0.3.0/db_1/dbs/
[oracle@rac_sdb dbs]$ ls -ltr | grep initracdb1.ora
/*
-rw-r--r-- 1 oracle oinstall   40 Dec 25 12:50 initracdb1.ora
*/

--Step 179 -->> On Secondary (DR) Database Servers
-- Creating physical standby database
[oracle@rac_sdb ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Sun Dec 22 11:47:21 2019

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> startup nomount pfile='/home/oracle/backup/spfileracdb.ora'
ORACLE instance started.

Total System Global Area  626327552 bytes
Fixed Size                2230952 bytes
Variable Size             247465304 bytes
Database Buffers          369098752 bytes
Redo Buffers              7532544 bytes

SQL> SELECT status,instance_name FROM gv$instance;

STATUS  INSTANCE_NAME
------- -------------
STARTED racdb1

SQL> show parameter db_unique_name

NAME           TYPE   VALUE
-------------- ------ --------
db_unique_name string racdb_dr

SQL> CREATE SPFILE = '+DATA/racdb_dr/spfileracdb.ora' FROM PFILE = '/home/oracle/backup/spfileracdb.ora';

File created.

SQL> shutdown immediate 
ORA-01507: database not mounted


ORACLE instance shut down.
SQL> startup nomount
ORACLE instance started.

Total System Global Area  626327552 bytes
Fixed Size            2230952 bytes
Variable Size          247465304 bytes
Database Buffers      369098752 bytes
Redo Buffers            7532544 bytes
SQL> 
*/

--Step 180 -->> On Secondary (DR) Database Servers
-- To Restore the backup
[oracle@rac_sdb ~]$ ls -ltr /home/oracle/backup/
/*
-rw-r----- 1 oracle oinstall  18546688 Dec 30 13:31 database_RACDB_11uknmqc_33
-rw-r----- 1 oracle oinstall 401793024 Dec 30 13:32 database_RACDB_10uknmqb_32
-rw-r----- 1 oracle oinstall     98304 Dec 30 13:32 database_RACDB_12uknmqs_34
-rw-r----- 1 oracle oinstall 628850688 Dec 30 13:32 database_RACDB_0vuknmqb_31
-rw-r----- 1 oracle oinstall  17024512 Dec 30 13:32 arch_RACDB_13uknmru_35
-rw-r----- 1 oracle oinstall  15491072 Dec 30 13:32 arch_RACDB_15uknmrv_37
-rw-r----- 1 oracle oinstall  41373696 Dec 30 13:32 arch_RACDB_14uknmrv_36
-rw-r----- 1 oracle oinstall   2545152 Dec 30 13:32 arch_RACDB_16uknms1_38
-rw-r----- 1 oracle oinstall  18579456 Dec 30 13:33 Control_RACDB_17uknmst_39
-rw-r--r-- 1 oracle oinstall      1673 Dec 30 13:44 spfileracdb.ora
*/

[oracle@rac_sdb ~]$ rman target /
/*
Recovery Manager: Release 11.2.0.3.0 - Production on Wed Dec 25 13:02:42 2019

Copyright (c) 1982, 2011, Oracle and/or its affiliates.  All rights reserved.

connected to target database: RACDB (not mounted)

RMAN> RESTORE STANDBY CONTROLFILE FROM '/home/oracle/backup/Control_RACDB_17uknmst_39';
RMAN> SQL 'ALTER DATABASE MOUNT STANDBY DATABASE';
RMAN> exit

Recovery Manager complete.
*/

--Step 181 -->> On Secondary (DR) Database Servers
-- Chage the permission and ownership
[oracle@rac_sdb ~]$ cd /home/oracle/backup/
[oracle@rac_sdb backup]$ ls -ltr
/*
-rw-r----- 1 oracle oinstall  18546688 Dec 30 13:31 database_RACDB_11uknmqc_33
-rw-r----- 1 oracle oinstall 401793024 Dec 30 13:32 database_RACDB_10uknmqb_32
-rw-r----- 1 oracle oinstall     98304 Dec 30 13:32 database_RACDB_12uknmqs_34
-rw-r----- 1 oracle oinstall 628850688 Dec 30 13:32 database_RACDB_0vuknmqb_31
-rw-r----- 1 oracle oinstall  17024512 Dec 30 13:32 arch_RACDB_13uknmru_35
-rw-r----- 1 oracle oinstall  15491072 Dec 30 13:32 arch_RACDB_15uknmrv_37
-rw-r----- 1 oracle oinstall  41373696 Dec 30 13:32 arch_RACDB_14uknmrv_36
-rw-r----- 1 oracle oinstall   2545152 Dec 30 13:32 arch_RACDB_16uknms1_38
-rw-r----- 1 oracle oinstall  18579456 Dec 30 13:33 Control_RACDB_17uknmst_39
-rw-r--r-- 1 oracle oinstall      1673 Dec 30 13:44 spfileracdb.ora
*/
[oracle@rac_sdb backup]$ rm -rf spfileracdb.ora 
[oracle@rac_sdb backup]$ chmod -R 775 *
[oracle@rac_sdb backup]$ ls -ltr
/*
-rwxrwxr-x 1 oracle oinstall  18546688 Dec 30 13:31 database_RACDB_11uknmqc_33
-rwxrwxr-x 1 oracle oinstall 401793024 Dec 30 13:32 database_RACDB_10uknmqb_32
-rwxrwxr-x 1 oracle oinstall     98304 Dec 30 13:32 database_RACDB_12uknmqs_34
-rwxrwxr-x 1 oracle oinstall 628850688 Dec 30 13:32 database_RACDB_0vuknmqb_31
-rwxrwxr-x 1 oracle oinstall  17024512 Dec 30 13:32 arch_RACDB_13uknmru_35
-rwxrwxr-x 1 oracle oinstall  15491072 Dec 30 13:32 arch_RACDB_15uknmrv_37
-rwxrwxr-x 1 oracle oinstall  41373696 Dec 30 13:32 arch_RACDB_14uknmrv_36
-rwxrwxr-x 1 oracle oinstall   2545152 Dec 30 13:32 arch_RACDB_16uknms1_38
-rw-r----- 1 oracle oinstall  18579456 Dec 30 13:33 Control_RACDB_17uknmst_39
*/

--Step 182 -->> On Secondary (DR) Database Servers
-- Restor the Database on Phiysiscal Statandby Database
[oracle@rac_sdb ~]$ rman target /
/*
Recovery Manager: Release 11.2.0.3.0 - Production on Mon Dec 30 13:54:46 2019

Copyright (c) 1982, 2011, Oracle and/or its affiliates.  All rights reserved.

connected to target database: RACDB (DBID=1025482897, not open)

RMAN> CATALOG START WITH '/home/oracle/backup/';
RMAN> LIST BACKUP OF ARCHIVELOG ALL;
-----------------------------------
List of Backup Sets
===================

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
1       3.71M      DISK        00:00:00     29-DEC-19      
        BP Key: 1   Status: EXPIRED  Compressed: NO  Tag: TAG20191229T130708
        Piece Name: /home/oracle/backup/database_RACDB_01ukl0vt_1

  List of Archived Logs in backup set 1
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    12      1032210    24-DEC-19 1032886    24-DEC-19
  1    13      1032886    24-DEC-19 1052917    24-DEC-19
  1    14      1052917    24-DEC-19 1074494    29-DEC-19
......

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
38      2.43M      DISK        00:00:00     30-DEC-19      
        BP Key: 38   Status: AVAILABLE  Compressed: NO  Tag: TAG20191230T133245
        Piece Name: /home/oracle/backup/arch_RACDB_16uknms1_38

  List of Archived Logs in backup set 38
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    31      1126087    30-DEC-19 1126446    30-DEC-19
  1    32      1126446    30-DEC-19 1147453    30-DEC-19
  1    33      1147453    30-DEC-19 1147472    30-DEC-19
  1    34      1147472    30-DEC-19 1149496    30-DEC-19
  1    35      1149496    30-DEC-19 1149505    30-DEC-19

RMAN> run
{
 ALLOCATE CHANNEL t1 TYPE DISK;
 ALLOCATE CHANNEL t2 TYPE DISK;
 ALLOCATE CHANNEL t3 TYPE DISK;
 RESTORE DATABASE;
 RECOVER DATABASE UNTIL SEQUENCE 36;
 RELEASE CHANNEL t1;
 RELEASE CHANNEL t2;
 RELEASE CHANNEL t3;
}

*/


--Step 183 -->> On Secondary (DR) Database Servers
-- Add init parameters for Instance
[oracle@rac_sdb ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Tue May 12 15:47:22 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, Oracle Label Security,
OLAP, Data Mining, Oracle Database Vault and Real Application Testing options

SQL> alter system seTremote_listener='192.168.1.106:1521' scope=spfile;
*/

--Step 184 -->> On Secondary (DR) Database Servers
-- On either node of the standby cluster, register the standby database and the database instances with the Oracle Cluster Registry (OCR) using the Server Control (SRVCTL) utility.
[oracle@rac_sdb ~]$ which srvctl
/*
/u01/app/oracle/product/11.2.0.3.0/db_1/bin/srvctl
*/
[oracle@rac_sdb ~]$ srvctl add database -d racdb_dr -o /u01/app/oracle/product/11.2.0.3.0/db_1 -r physical_standby -s mount
[oracle@rac_sdb ~]$ srvctl config database -d racdb_dr
/*
Database unique name: racdb_dr
Database name: 
Oracle home: /u01/app/oracle/product/11.2.0.3.0/db_1
Oracle user: oracle
Spfile: 
Domain: 
Start options: mount
Stop options: immediate
Database role: PHYSICAL_STANDBY
Management policy: AUTOMATIC
Server pools: racdb_dr
Database instances: 
Disk Groups: 
Mount point paths: 
Services: 
Type: RAC
Database is administrator managed
*/

[oracle@rac_sdb ~]$ srvctl add instance -d racdb_dr -i racdb1 -n rac_sdb
/*
The -d option specifies the database unique name (DB_UNIQUE_NAME) of the database.
The -i option specifies the database insance name.
The -n option specifies the node on which the instance is running.
The -o option specifies the Oracle home of the database.
*/

[oracle@rac_sdb Desktop]$ srvctl config database -d racdb_dr
/*
Database unique name: racdb_dr
Database name: 
Oracle home: /u01/app/oracle/product/11.2.0.3.0/db_1
Oracle user: oracle
Spfile: 
Domain: 
Start options: mount
col dest_id for a10
Stop options: immediate
Database role: PHYSICAL_STANDBY
Management policy: AUTOMATIC
Server pools: racdb_dr
Database instances: racdb1
Disk Groups: DATA,FRA
Mount point paths: 
Services: 
Type: RAC
Database is administrator managed
*/

[oracle@rac_sdb ~]$ srvctl status database -d racdb_dr
/*
Instance racdb1 is running on node rac_sdb
*/

--Step 185 -->> On Secondary (DR) Database Servers
-- Verify Standby redo logs and Apply MRP
[oracle@rac_sdb ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Wed Dec 25 13:20:16 2019

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> select status, instance_name from gv$instance;

STATUS  INSTANCE_NAME
------- -------------
MOUNTED racdb1

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15

SQL> SELECT name,open_mode,db_unique_name,database_role,protection_mode FROM gv$database;

NAME  OPEN_MODE DB_UNIQUE_NAME  DATABASE_ROLE    PROTECTION_MODE
----- --------- --------------- ---------------- --------------------
RACDB MOUNTED   racdb_dr        PHYSICAL STANDBY MAXIMUM PERFORMANCE

SQL> SELECT b.thread#,a.group#, a.type, a.member, b.bytes FROM gv$logfile a, gv$standby_log b WHERE a.group# = b.group#;

THREAD# GROUP#  TYPE    MEMBER                             BYTES
------- ------- ------- ---------------------------------- --------
1       4       STANDBY +DATA/racdb/onlinelog/redo04.log 52428800
1       5       STANDBY +DATA/racdb/onlinelog/redo05.log 52428800
1       6       STANDBY +DATA/racdb/onlinelog/redo06.log 52428800
1       7       STANDBY +DATA/racdb/onlinelog/redo07.log 52428800

SQL> SELECT * FROM v$logfile order by 1;

GROUP# STATUS  TYPE    MEMBER                             IS_RECOVERY_DEST_FILE
------ ------- ------- ---------------------------------- ---------------------
1              ONLINE  +DATA/racdb/onlinelog/redo01.log NO
2              ONLINE  +DATA/racdb/onlinelog/redo02.log NO
3              ONLINE  +DATA/racdb/onlinelog/redo03.log NO
4              STANDBY +DATA/racdb/onlinelog/redo04.log NO
5              STANDBY +DATA/racdb/onlinelog/redo05.log NO
6              STANDBY +DATA/racdb/onlinelog/redo06.log NO
7              STANDBY +DATA/racdb/onlinelog/redo07.log NO

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


REDOLOG_FILE_TYPE    INST_ID GROUP# THREAD# SEQUENCE# MEMBER                           STATUS     ARCHIVE SIZE_MB
-------------------- ------- ------ ------- --------- -------------------------------- ---------- ------- -------
[ ONLINE REDO LOG ]  1       1      1       36        +DATA/racdb/onlinelog/redo01.log CLEARING   YES     50
[ ONLINE REDO LOG ]  1       2      1       38        +DATA/racdb/onlinelog/redo02.log CURRENT    YES     50
[ ONLINE REDO LOG ]  1       3      1       37        +DATA/racdb/onlinelog/redo03.log CURRENT    YES     50
[ STANDBY REDO LOG ] 1       4      1       38        +DATA/racdb/onlinelog/redo04.log ACTIVE     YES     50
[ STANDBY REDO LOG ] 1       5      1       0         +DATA/racdb/onlinelog/redo05.log UNASSIGNED NO      50
[ STANDBY REDO LOG ] 1       6      1       0         +DATA/racdb/onlinelog/redo06.log UNASSIGNED YES     50
[ STANDBY REDO LOG ] 1       7      1       0         +DATA/racdb/onlinelog/redo07.log UNASSIGNED YES     50

-- To Enable MRP on STANDBY
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;

-- To Disable MRP on STANDBY
-- ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

SQL> SELECT process,thread#,sequence#,status FROM gv$managed_standby;

PROCESS THREAD# SEQUENCE# STATUS
------- ------- --------- ------------
ARCH    1       89        CLOSING
ARCH    0       0         CONNECTED
ARCH    0       0         CONNECTED
ARCH    1       90        CLOSING
RFS     0       0         IDLE
RFS     0       0         IDLE
RFS     1       91        IDLE
MRP0    1       91        APPLYING_LOG

SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> SELECT DISTINCT error FROM v$archive_dest_status;

no rows selected

SQL> exit;
*/

--Step 186 -->> On Primary (DC) Database Servers
[oracle@rac_pdb ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 29 14:58:08 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> alter system switch logfile;

System altered.

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

--Step 187 -->> On Secondary (DR) Database Servers
[oracle@rac_sdb ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Jun 29 14:59:24 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT process,thread#,sequence#,status FROM gv$managed_standby;

PROCESS THREAD# SEQUENCE# STATUS
------- ------- --------- ------------
ARCH    1       89        CLOSING
ARCH    0       0         CONNECTED
ARCH    0       0         CONNECTED
ARCH    1       91        CLOSING
RFS     0       0         IDLE
RFS     0       0         IDLE
RFS     1       92        IDLE
MRP0    1       92        APPLYING_LOG

SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> SELECT DISTINCT error FROM v$archive_dest_status;

no rows selected

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Other Relevant Notes On DC and DR
1.Protection Mode
There are three protection modes for the primary database:

Maximum Availability: Transactions on the primary do not commit until redo information has been written to the online redo log and the standby
redo logs of at least one standby location. If no standby location is available, it acts in the same manner as maximum performance mode until a
standby becomes available again.

Maximum Performance: Transactions on the primary commit as soon as redo information has been written to the online redo log. Transfer of redo
information to the standby server is asynchronous, so it does not impact on performance of the primary.
Maximum Protection: Transactions on the primary do not commit until redo information has been written to the online redo log and the standby
redo logs of at least one standby location. If not suitable standby location is available, the primary database shuts down.

By default, for a newly created standby database, the primary database is in maximum performance mode.

SELECT protection_mode FROM v$database;
PROTECTION_MODE
-------------------
MAXIMUM PERFORMANCE

The mode can be switched using the following commands. Note the alterations in the redo transport attributes.
-- Maximum Availability.
ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='SERVICE=racdb_dr AFFIRM SYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=racdb_dr';
ALTER DATABASE SET STANDBY DATABASE TO MAXIMIZE AVAILABILITY;

-- Maximum Performance.
ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='SERVICE=racdb_dr NOAFFIRM ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=racdb_dr';
ALTER DATABASE SET STANDBY DATABASE TO MAXIMIZE PERFORMANCE;

-- Maximum Protection.
ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='SERVICE=racdb_dr AFFIRM SYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=racdb_dr';
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE SET STANDBY DATABASE TO MAXIMIZE PROTECTION;
ALTER DATABASE OPEN;


2. Database Switchover
A database can be in one of two mutually exclusive modes (primary or standby). These roles can be altered aTruntime without loss of data or resetting of
redo logs. This process is known as a Switchover and can be performed using the following statements.
-- Convert primary database to standby
CONNECT / AS SYSDBA
ALTER DATABASE COMMIT TO SWITCHOVER TO STANDBY;
-- Shutdown primary database
SHUTDOWN IMMEDIATE;
-- Mount old primary database as standby database
STARTUP NOMOUNT;
ALTER DATABASE MOUNT STANDBY DATABASE;
--ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;

On the original standby database issue the following commands.
-- Convert standby database to primary
CONNECT / AS SYSDBA
ALTER DATABASE COMMIT TO SWITCHOVER TO PRIMARY;
-- Shutdown standby database
SHUTDOWN IMMEDIATE;
-- Open old standby database as primary
STARTUP;

Once this is complete, test the log transport as before. If everything is working fine, switch the primary database back to the original server by doing
another switchover. This is known as a switchback.

3. Failover
If the primary database is not available the standby database can be activated as a primary database using the following statements.
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE FINISH;
ALTER DATABASE ACTIVATE STANDBY DATABASE;

Since the standby database is now the primary database it should be backed up immediately.
The original primary database can now be configured as a standby. If Flashback Database was enabled on the primary database, then this can be done
relatively easily (shown here). If not, the whole setup process must be followed, but this time using the original primary server as the standby.

4. Read-Only Standby and Active Data Guard
Once a standby database is configured, it can be opened in read-only mode to allow query access. This is often used to offload reporting to the standby
server, thereby freeing up resources on the primary server. When open in read-only mode, archive log shipping continues, but managed recovery is
stopped, so the standby database becomes increasingly out of date until managed recovery is resumed.
T o switch the standby database into read-only mode, do the following.

SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE OPEN READ ONLY;

To resume managed recovery, do the following.
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
--ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;

In 11g, Oracle introduced the Active Data Guard feature. This allows the standby database to be open in read-only mode, but still apply redo information.
This means a standby can be available for querying, yet still be up to date. There are licensing implications for this feature, but the following commands
show how active data guard can be enabled.

SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE OPEN READ ONLY;
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;

Since managed recovery continues with active data guard, there is no need to switch back to managed recovery from read-only mode in this case.


5. Snapshot Standby
Introduced in 11g, snapshot standby allows the standby database to be opened in read-write mode. When switched back into standby mode, all changes
made whilst in read-write mode are lost. This is achieved using flashback database, but the standby database does not need to have flashback database
explicitly enabled to take advantage of this feature, thought it works just the same if it is.

If you are using RAC, turn off all but one of the RAC instances. Make sure the instance is in MOUNT mode.

SHUTDOWN IMMEDIATE;
STARTUP MOUNT;

Make sure managed recovery is disabled.
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

Convert the standby to a snapshot standby. The following example queries the  V$DATABASE view to show that flashback database is not enabled prior to the
conversion operation.

SELECT flashback_on FROM v$database;
FLASHBACK_ON
------------
NO

ALTER DATABASE CONVERT TO SNAPSHOT STANDBY;
ALTER DATABASE OPEN;

SELECT flashback_on FROM v$database;
FLASHBACK_ON
------------------
RESTORE POINT ONLY

You can now do treat the standby like any read-write database.
To convert it back to the physical standby, losing all the changes made since the conversion to snapshot standby, issue the following commands.

SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE CONVERT TO PHYSICAL STANDBY;
SHUTDOWN IMMEDIATE;
STARTUP NOMOUNT;
ALTER DATABASE MOUNT STANDBY DATABASE;
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;


SELECT flashback_on FROM v$database;
FLASHBACK_ON
------------
NO

The standby is once again in managed recovery and archivelog shipping is resumed. Notice that flashback database is still not enabled.