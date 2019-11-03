-- Steup the shared storage using Openfiler (openfileresa-2.99.1-x86_64-disc1)
/*
data1 40960
fra1  25600
ocr   20480
*/
-- Openfiler Configuration Steps for Two Node Rac Setup
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
192.168.129.105   rac1.mydomain        rac1
192.168.129.106   rac2.mydomain        rac2

# Private
192.168.1.102   rac1-priv.mydomain   rac1-priv
192.168.1.103   rac2-priv.mydomain   rac2-priv

# Virtual
192.168.129.107   rac1-vip.mydomain    rac1-vip
192.168.129.108   rac2-vip.mydomain    rac2-vip

# Openfiler (SAN/NAS Storage)
192.168.129.104   openfiler.mydomain   openfiler

# SCAN
192.168.129.109   rac-scan.mydomain    rac-scan
192.168.129.110   rac-scan.mydomain    rac-scan
*/

-- Step 2 -->> On Openfiler (SAN/NAS Storage)
[root@openfiler ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth0 
/*
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.129.104
NETMASK=255.255.255.0
GATEWAY=192.168.129.6
DNS1=192.168.129.16
DNS2=192.168.129.2
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
*/

-- Step 3 -->> On Openfiler (SAN/NAS Storage)
[root@openfiler ~]# service network restart

-- Step 4 -->> On Openfiler (SAN/NAS Storage)
-- disabling the firewall.
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


----------------------------------------------------------------
-------------Two Node Rac Setup on VM Workstation---------------
----------------------------------------------------------------

-- 2 Node Rac on VM -->> On both Nodes
[root@rac1/rac2 ~]# df -h
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

-- Step 1 -->> On both Nodes
[root@rac1/rac2 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.168.129.105   rac1.mydomain        rac1
192.168.129.106   rac2.mydomain        rac2

# Private
192.168.1.102   rac1-priv.mydomain   rac1-priv
192.168.1.103   rac2-priv.mydomain   rac2-priv

# Virtual
192.168.129.107   rac1-vip.mydomain    rac1-vip
192.168.129.108   rac2-vip.mydomain    rac2-vip

# Openfiler (SAN/NAS Storage)
192.168.129.104   openfiler.mydomain   openfiler

# SCAN
192.168.129.109   rac-scan.mydomain    rac-scan
192.168.129.110   rac-scan.mydomain    rac-scan
*/


-- Step 2 -->> On both Nodes
-- Disable secure linux by editing the "/etc/selinux/config" file, making sure the SELINUX flag is set as follows.
[root@rac1/rac2 ~]# vim /etc/selinux/config
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

-- Step 3 -->> On Nodes 1
[root@rac1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth0 
/*
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.129.105
NETMASK=255.255.255.0
GATEWAY=192.168.129.6
DNS1=192.168.129.16
DNS2=192.168.129.2
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
*/

-- Step 4 -->> On Nodes 1
[root@rac1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth1
/*
DEVICE=eth1
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.1.102
NETMASK=255.255.255.0
GATEWAY=192.168.129.6
DNS1=192.168.129.16
DNS2=192.168.129.2
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
*/

-- Step 5 -->> On Nodes 2
[root@rac2 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth0 
/*
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.129.106
NETMASK=255.255.255.0
GATEWAY=192.168.129.6
DNS1=192.168.129.16
DNS2=192.168.129.2
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
*/

-- Step 6 -->> On Nodes 2
[root@rac2 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth1
/*
DEVICE=eth1
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.1.103
NETMASK=255.255.255.0
GATEWAY=192.168.129.6
DNS1=192.168.129.16
DNS2=192.168.129.2
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
*/
-- Step 7 -->> On both Nodes
[root@rac1/rac2 ~]# service network restart

-- Step 8 -->> On both Nodes
-- disabling the firewall.
[root@rac1/rac2 ~]# chkconfig --list iptables
/*
iptables  0:off    1:off    2:on    3:on    4:on    5:on    6:off
*/
[root@rac1/rac2 ~]# service iptables stop
/*
iptables: Setting chains to policy ACCEPT: nat mangle filte[  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
*/
[root@rac1/rac2 ~]# chkconfig iptables off
[root@rac1/rac2 ~]# iptables -F
[root@rac1/rac2 ~]# service iptables save
/*
iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]
*/
[root@rac1/rac2 ~]# /etc/init.d/iptables stop
/*
iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
*/
[root@rac1/rac2 ~]# iptables -L
/*
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
*/

[root@rac1/rac2 ~]# chkconfig --list iptables
/*
iptables   0:off    1:off    2:off    3:off    4:off    5:off    6:off
*/ 

-- Step 9 -->> On both Nodes
-- ntpd disable
[root@rac1/rac2 ~]# service ntpd stop
/*
Shutting down ntpd:                                        [FAILED]
*/

[root@rac1/rac2 ~]# service ntpd status
/*
ntpd is stopped
*/

[root@rac1/rac2 ~]# chkconfig ntpd off
[root@rac1/rac2 ~]# mv /etc/ntp.conf /etc/ntp.conf.backup
[root@rac1/rac2 ~]# rm /etc/ntp.conf
[root@rac1/rac2 ~]# rm /var/run/ntpd.pid

-- Step 10 -->> On both Nodes
[root@rac1/rac2 ~]# init 6

-- Step 11 -->> On both Nodes
-- Perform either the Automatic Setup or the Manual Setup to complete the basic prerequisites. 
-- The Additional Setup is required for all installations.
[root@rac1/rac2 ~]# cd /media/OL6.4\ x86_64\ Disc\ 1\ 20130225/Server/Packages/
[root@rac1/rac2 Packages]# yum install oracle-rdbms-server-11gR2-preinstall
[root@rac1/rac2 Packages]# yum update

-- Step 12 -->> On both Nodes
-- Manual tup the relevant RPMS
[root@rac1/rac2 Packages]# rpm -iUvh binutils-2*x86_64*
[root@rac1/rac2 Packages]# rpm -iUvh glibc-2*x86_64* nss-softokn-freebl-3*x86_64*
[root@rac1/rac2 Packages]# rpm -iUvh glibc-2*i686* nss-softokn-freebl-3*i686*
[root@rac1/rac2 Packages]# rpm -iUvh compat-libstdc++-33*x86_64*
[root@rac1/rac2 Packages]# rpm -iUvh glibc-common-2*x86_64*
[root@rac1/rac2 Packages]# rpm -iUvh glibc-devel-2*x86_64*
[root@rac1/rac2 Packages]# rpm -iUvh glibc-devel-2*i686*
[root@rac1/rac2 Packages]# rpm -iUvh glibc-headers-2*x86_64*
[root@rac1/rac2 Packages]# rpm -iUvh elfutils-libelf-0*x86_64*
[root@rac1/rac2 Packages]# rpm -iUvh elfutils-libelf-devel-0*x86_64*
[root@rac1/rac2 Packages]# rpm -iUvh gcc-4*x86_64*
[root@rac1/rac2 Packages]# rpm -iUvh gcc-c++-4*x86_64*
[root@rac1/rac2 Packages]# rpm -iUvh ksh-*x86_64*
[root@rac1/rac2 Packages]# rpm -iUvh libaio-0*x86_64*
[root@rac1/rac2 Packages]# rpm -iUvh libaio-devel-0*x86_64*
[root@rac1/rac2 Packages]# rpm -iUvh libaio-0*i686*
[root@rac1/rac2 Packages]# rpm -iUvh libaio-devel-0*i686*
[root@rac1/rac2 Packages]# rpm -iUvh libgcc-4*x86_64*
[root@rac1/rac2 Packages]# rpm -iUvh libgcc-4*i686*
[root@rac1/rac2 Packages]# rpm -iUvh libstdc++-4*x86_64*
[root@rac1/rac2 Packages]# rpm -iUvh libstdc++-4*i686*
[root@rac1/rac2 Packages]# rpm -iUvh libstdc++-devel-4*x86_64*
[root@rac1/rac2 Packages]# rpm -iUvh make-3.81*x86_64*
[root@rac1/rac2 Packages]# rpm -iUvh numactl-devel-2*x86_64*
[root@rac1/rac2 Packages]# rpm -iUvh sysstat-9*x86_64*
[root@rac1/rac2 Packages]# rpm -iUvh compat-libstdc++-33*i686*
[root@rac1/rac2 Packages]# rpm -iUvh compat-libcap*
[root@rac1/rac2 Packages]# rpm -iUvh libaio-devel-0.*
[root@rac1/rac2 Packages]# rpm -iUvh ksh-2*
[root@rac1/rac2 Packages]# rpm -iUvh libstdc++-4.*.i686*
[root@rac1/rac2 Packages]# rpm -iUvh elfutils-libelf-0*i686* elfutils-libelf-devel-0*i686*
[root@rac1/rac2 Packages]# rpm -iUvh libtool-ltdl*i686*
[root@rac1/rac2 Packages]# rpm -iUvh ncurses*i686*
[root@rac1/rac2 Packages]# rpm -iUvh readline*i686*
[root@rac1/rac2 Packages]# rpm -iUvh unixODBC*
[root@rac1/rac2 Packages]# rpm -Uvh oracleasm*.rpm
[root@rac1/rac2 Packages]# rpm -q binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel elfutils-libelf-devel-static \
[root@rac1/rac2 Packages]# rpm -q gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers kernel-headers ksh libaio libaio-devel \
[root@rac1/rac2 Packages]# rpm -q libgcc libgomp libstdc++ libstdc++-devel make numactl-devel sysstat unixODBC unixODBC-devel

-- Step 13 -->> On both Nodes
-- Pre-Installation Steps for ASM
[root@rac1/rac2 ~ ]# cd /etc/yum.repos.d
[root@rac1/rac2 yum.repos.d]# uname -a
/*
Linux rac1/rac2.mydomain 2.6.39-400.313.1.el6uek.x86_64 #1 SMP Thu Aug 8 15:49:52 PDT 2019 x86_64 x86_64 x86_64 GNU/Linux
*/

[root@rac1/rac2 yum.repos.d]# cat /etc/os-release 
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

[root@rac1/rac2 yum.repos.d]# wget https://public-yum.oracle.com/public-yum-ol6.repo
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
[root@rac1/rac2 yum.repos.d]# ls
/*
oracle-linux-ol6.repo.disabled  public-yum-ol6.repo    public-yum-ol6.repo.2
packagekit-media.repo           public-yum-ol6.repo.1  uek-ol6.repo.disabled
*/

[root@rac1/rac2 yum.repos.d]# yum install kmod-oracleasm
[root@rac1/rac2 yum.repos.d]# yum install oracleasm-support
/*
Loaded plugins: aliases, changelog, kabi, presto, refresh-packagekit, security,
              : tmprepo, ulninfo, verify, versionlock
Loading support for kernel ABI
Setting up Install Process
Package oracleasm-support-2.1.11-2.el6.x86_64 already installed and latest version
Nothing to do
*/

-- Step 14 -->> On both Nodes
-- Need to dounload (oracleasmlib-2.0.4-1.el5.i386.rpm : https://oracle-base.com/articles/11g/oracle-db-11gr2-rac-installation-on-oel5-using-virtualbox | http://www.hblsoft.org/hwl/1326.html)
[root@rac1/rac2 yum.repos.d]# cd /mnt/hgfs/Oracle_Software/OracleASM_Package/
[root@rac1/rac2 OracleASM_Package]# ls
/*
elfutils-libelf-devel-static-0.164-2.el6.x86_64.rpm
oracleasmlib-2.0.4-1.el6.x86_64.rpm
*/
[root@rac1/rac2 OracleASM_Package]# rpm -iUvh oracleasmlib-2.0.4-1.el6.x86_64.rpm
/*
Preparing...                ########################################### [100%]
    package oracleasmlib-2.0.4-1.el6.x86_64 is already installed
*/
[root@rac1/rac2 OracleASM_Package]# rpm -iUvh elfutils-libelf-devel-static-0.164-2.el6.x86_64.rpm
/*
Preparing...                ########################################### [100%]
   1:elfutils-libelf-devel-s########################################### [100%]
*/

-- Step 15 -->> On both Nodes
-- Orcle ASM Configuration
[root@rac1/rac2 ~]# rpm -qa | grep -i oracleasm
/*
kmod-oracleasm-2.0.8-16.1.el6_10.x86_64
oracleasmlib-2.0.4-1.el6.x86_64
oracleasm-support-2.1.11-2.el6.x86_64
*/

-- Step 16 -->> On both Nodes
-- Add the kernel parameters file "/etc/sysctl.conf" and add oracle recommended kernel parameters
[root@rac1/rac2 ~]# vim /etc/sysctl.conf
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
[root@rac1/rac2 ~]# /sbin/sysctl -p

-- Step 17 -->> On both Nodes
-- Edit “/etc/security/limits.conf” file to limit user processes
[root@rac1/rac2 ~]# vim /etc/security/limits.conf
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


-- Step 18 -->> On both Nodes
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
session    required     pam_limits.so
*/


-- Step 19 -->> On both Nodes
-- Create the new groups and users.
[root@rac1/rac2 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:
*/
[root@rac1/rac2 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:oracle
*/
[root@rac1/rac2 !]# cat /etc/group | grep -i asm

-- 1.Create OS groups using the command below. Enter these commands as the 'root' user:
[root@rac1/rac2 ~]# /usr/sbin/groupadd -g 503 oper
[root@rac1/rac2 ~]# /usr/sbin/groupadd -g 504 asmadmin
[root@rac1/rac2 ~]# /usr/sbin/groupadd -g 506 asmdba
[root@rac1/rac2 ~]# /usr/sbin/groupadd -g 507 asmoper

-- 2.Create the users that will own the Oracle software using the commands:
[root@rac1/rac2 ~]# /usr/sbin/useradd  -g oinstall -G asmadmin,asmdba,asmoper grid
[root@rac1/rac2 ~]# /usr/sbin/usermod -g oinstall -G dba,oper,asmdba oracle

[root@rac1/rac2 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/
[root@rac1/rac2 ~]# cat /etc/group | grep -i oracle
/*
dba:x:54322:oracle
oper:x:503:oracle
asmdba:x:506:grid,oracle
*/
[root@rac1/rac2 ~]# cat /etc/group | grep -i grid
/*
asmadmin:x:504:grid
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/

[root@rac1/rac2 ~]# passwd oracle
/*
Changing password for user oracle.
New password: 
BAD PASSWORD: it is based on a dictionary word
BAD PASSWORD: is too simple
Retype new password: 
passwd: all authentication tokens updated successfully.
*/
[root@rac1/rac2 ~]# passwd grid
/*
Changing password for user grid.
New password: 
BAD PASSWORD: it is too short
BAD PASSWORD: is too simple
Retype new password: 
passwd: all authentication tokens updated successfully.
*/
[root@rac1/rac2 ~]# su - oracle
[oracle@rac1/rac2 ~]$ su - grid
/*
Password: 
*/
[grid@rac1/rac2 ~]$ su - root
/*
Password: 
*/

-- Step 20 -->> On both Nodes
--1.Create the Oracle Inventory Director:
[root@rac1/rac2 ~]# mkdir -p /u01/app/oraInventory
[root@rac1/rac2 ~]# chown -R grid:oinstall /u01/app/oraInventory
[root@rac1/rac2 ~]# chmod -R 775 /u01/app/oraInventory

--2.Creating the Oracle Grid Infrastructure Home Directory:
[root@rac1/rac2 ~]# mkdir -p /u01/11.2.0.3.0/grid
[root@rac1/rac2 ~]# chown -R grid:oinstall /u01/11.2.0.3.0/grid
[root@rac1/rac2 ~]# chmod -R 775 /u01/11.2.0.3.0/grid

--3.Creating the Oracle Base Directory
[root@rac1/rac2 ~]# mkdir -p /u01/app/oracle
[root@rac1/rac2 ~]# mkdir /u01/app/oracle/cfgtoollogs
[root@rac1/rac2 ~]# chown -R oracle:oinstall /u01/app/oracle
[root@rac1/rac2 ~]# chmod -R 775 /u01/app/oracle
[root@rac1/rac2 ~]# chown -R grid:oinstall /u01/app/oracle/cfgtoollogs
[root@rac1/rac2 ~]# chmod -R 775 /u01/app/oracle/cfgtoollogs

--4.Creating the Oracle RDBMS Home Directory
[root@rac1/rac2 ~]# mkdir -p /u01/app/oracle/product/11.2.0.3.0/db_1
[root@rac1/rac2 ~]# chown -R oracle:oinstall /u01/app/oracle/product/11.2.0.3.0/db_1
[root@rac1/rac2 ~]# chmod -R 775 /u01/app/oracle/product/11.2.0.3.0/db_1

[root@rac1/rac2 ~]# cd /u01/app/oracle
[root@rac1/rac2 oracle]# chown -R oracle:oinstall product/
[root@rac1/rac2 oracle]# chmod -R 775 product/
[root@rac1/rac2 oracle]# 

-- Step 21 -->> On both Nodes
--Make the following changes to the default shell startup file, add the following lines to the /etc/profile file:
[root@rac1/rac2 ~]# vim /etc/profile
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

-- Step 22 -->> On both Nodes
-- For the C shell (csh or tcsh), add the following lines to the /etc/csh.login file:
[root@rac1/rac2 ~]# vim /etc/csh.login
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

-- Step 23 -->> On both Nodes
[root@rac1/rac2 ~]# mkdir -p /home/grid/grid_software
[root@rac1/rac2 ~]# mkdir -p /home/oracle/oracle_software

-- Step 24 -->> On both Nodes
-- Unzip the files.
[root@rac1/rac2 oracle]# cd
[root@rac1/rac2 ~]# cd /mnt/hgfs/Oracle_Software/Oracle\ Db\ 11.2.0.3.0\ \(64-bit\ -\ Linux\)/
[root@rac1/rac2 Oracle Db 11.2.0.3.0 (64-bit - Linux)]# ls
/*
p10404530_112030_Linux-x86-64_1of7.zip  p10404530_112030_Linux-x86-64_3of7-Clusterware.zip
p10404530_112030_Linux-x86-64_2of7.zip  software_patch
*/
[root@rac1/rac2 Oracle Db 11.2.0.3.0 (64-bit - Linux)]# unzip p10404530_112030_Linux-x86-64_1of7.zip -d /home/oracle/oracle_software/
[root@rac1/rac2 Oracle Db 11.2.0.3.0 (64-bit - Linux)]# unzip p10404530_112030_Linux-x86-64_2of7.zip -d /home/oracle/oracle_software/
[root@rac1/rac2 Oracle Db 11.2.0.3.0 (64-bit - Linux)]# unzip p10404530_112030_Linux-x86-64_3of7-Clusterware.zip -d /home/grid/grid_software/

-- Step 25 -->> On both Nodes
-- Login as root user and issue the following command at rac1
[root@rac1/rac2 Oracle Db 11.2.0.3.0 (64-bit - Linux)]# cd /home/grid/
[root@rac1/rac2 grid]# chown -R grid:oinstall grid_software
[root@rac1/rac2 grid]# chmod -R 775 /home/grid/
[root@rac1/rac2 grid]# cd /home/oracle/
[root@rac1/rac2 oracle]# chown -R oracle:oinstall /home/oracle/
[root@rac1/rac2 oracle]# chmod -R 775 /home/oracle/

-- Step 26 -->> On both Nodes
-- To Disable the virbr0/lxcbr0 Linux services 
[root@rac1/rac2 ~]# cd /etc/sysconfig/
[root@rac1/rac2 sysconfig]#  brctl show
/*
bridge name    bridge id        STP enabled    interfaces
lxcbr0        8000.000000000000    no        
pan0          8000.000000000000    no        
virbr0        8000.525400467a72    yes        virbr0-nic
*/

[root@rac1/rac2 sysconfig]# virsh net-list
/*
Name                 State      Autostart     Persistent
--------------------------------------------------
default              active     yes           yes
*/

[root@rac1/rac2 sysconfig]# service libvirtd stop
/*
Stopping libvirtd daemon:                                  [  OK  ]
*/
[root@rac1/rac2 sysconfig]# chkconfig --list | grep libvirtd
/*
libvirtd           0:off    1:off    2:off    3:on    4:on    5:on    6:off
*/

[root@rac1/rac2 sysconfig]# chkconfig libvirtd off
[root@rac1/rac2 sysconfig]# ip link set lxcbr0 down
[root@rac1/rac2 sysconfig]# brctl delbr lxcbr0
[root@rac1/rac2 sysconfig]# brctl show
[root@rac1/rac2 sysconfig]# init 6

[root@rac1/rac2 ~]# brctl show
/*
bridge name    bridge id        STP enabled    interfaces
lxcbr0        8000.000000000000    no        
pan0        8000.000000000000    no        
*/
[root@rac1/rac2 ~]# chkconfig --list | grep libvirtd
/*
libvirtd           0:off    1:off    2:off    3:off    4:off    5:off    6:off
*/

-- Step 27 -->> On Node 1
[root@rac1 ~]# su - oracle

-- Login as the oracle user and add the following lines at the end of the ".bash_profile" file.
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
ORACLE_BASE=/u01/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/11.2.0.3.0/db_1; export ORACLE_HOME
ORACLE_SID=racdb1; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

[oracle@rac1 ~]$ . .bash_profile

-- Step 28 -->> On Node 1
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
ORACLE_BASE=/u01/app/oracle; export ORACLE_BASE
GRID_HOME=/u01/11.2.0.3.0/grid; export GRID_HOME
ORACLE_HOME=$GRID_HOME; export ORACLE_HOME

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

[grid@rac1 ~]$ . .bash_profile

-- Step 29 -->> On Node 1
[grid@rac1]# su - root
[root@rac1 ~]# vim /etc/sysconfig/network
/*
NETWORKING=yes
HOSTNAME=rac1.mydomain
# oracle-rdbms-server-11gR2-preinstall : Add NOZEROCONF=yes
NOZEROCONF=yes
*/

-- Step 30 -->> On Node 2
[root@rac2 ~]# su - oracle

-- Login as the oracle user and add the following lines at the end of the ".bash_profile" file.
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
ORACLE_BASE=/u01/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/11.2.0.3.0/db_1; export ORACLE_HOME
ORACLE_SID=racdb2; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

[oracle@rac2 ~]$ . .bash_profile

-- Step 31 -->> On Node 2
-- Login as the grid user and add the following lines at the end of the ".bash_profile" file.
[root@rac2 iscsi]# su - grid
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
ORACLE_BASE=/u01/app/oracle; export ORACLE_BASE
GRID_HOME=/u01/11.2.0.3.0/grid; export GRID_HOME
ORACLE_HOME=$GRID_HOME; export ORACLE_HOME

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

[grid@rac2 ~]$ . .bash_profile

-- Step 32 -->> On Node 2
[grid@rac2]# su - root
[root@rac2 ~]# vim /etc/sysconfig/network
/*
NETWORKING=yes
HOSTNAME=rac2.mydomain
# oracle-rdbms-server-11gR2-preinstall : Add NOZEROCONF=yes
NOZEROCONF=yes
*/

-- Step 32 -->> On Node 1
--SSH user Equivalency configuration (grid and oracle):
--On All the Cluster Nodes:
[root@rac1 ~]# su - oracle
[oracle@rac1 ~]# mkdir ~/.ssh
[oracle@rac1 ~]# chmod 700 ~/.ssh

--Generate the RSA and DSA keys:
[oracle@rac1 ~]# /usr/bin/ssh-keygen -t rsa
[oracle@rac1 ~]# /usr/bin/ssh-keygen -t dsa

[oracle@rac1 ~]# touch ~/.ssh/authorized_keys
[oracle@rac1 ~]# cd ~/.ssh

--(a) Add these Keys to the Authorized_keys file.
[oracle@rac1 ~]# cat id_rsa.pub >> authorized_keys
[oracle@rac1 ~]# cat id_dsa.pub >> authorized_keys

-- Step 33 -->> On Node 2
--SSH user Equivalency configuration (grid and oracle):
--On All the Cluster Nodes:
[root@rac2 ~]#su - oracle
[oracle@rac2 ~]# mkdir ~/.ssh
[oracle@rac2 ~]# chmod 700 ~/.ssh

--Generate the RSA and DSA keys:
[oracle@rac2 ~]# /usr/bin/ssh-keygen -t rsa
[oracle@rac2 ~]# /usr/bin/ssh-keygen -t dsa
[oracle@rac2 ~]# cd ~/.ssh

-- Step 34 -->> On Node 1
-- Send this file to node2.
[oracle@rac1 .ssh]# scp authorized_keys oracle@rac2:~/.ssh/
/*
The authenticity of host 'rac2 (192.168.129.106)' can't be established.
RSA key fingerprint is 87:1a:ad:6d:f8:cc:fb:37:b7:60:66:c1:20:55:97:53.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'rac2,192.168.129.106' (RSA) to the list of known hosts.
oracle@rac2's password: 
authorized_keys                               100% 1020     1.0KB/s   00:0
*/

-- Step 35 -->> On all Nodes
[oracle@rac1/rac2 ~]# chmod 600 ~/.ssh/authorized_keys

-- Step 36 -->> On Node 1
[oracle@rac1 .ssh]$ ssh oracle@rac2
/*
oracle@rac2's password:
*/ 
[oracle@rac2 ~]$ exit
/*
logout
Connection to rac2 closed.
*/ 

-- Step 37 -->> On Node 2
[oracle@rac2 .ssh]$ ssh oracle@rac1
/*
The authenticity of host 'rac1 (192.168.129.105)' can't be established.
RSA key fingerprint is 4a:f2:44:d8:f2:82:93:17:27:d5:86:36:9a:ef:6f:25.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'rac1,192.168.129.105' (RSA) to the list of known hosts.
oracle@rac1's password:
*/ 
[oracle@rac1 ~]$ exit
/*
logout
Connection to rac1 closed.
*/

-- Step 38 -->> On Node 1
[root@rac1 ~]# su - grid
[grid@rac1 ~]$ mkdir ~/.ssh
[grid@rac1 ~]$ chmod 700 ~/.ssh
[grid@rac1 ~]$ /usr/bin/ssh-keygen -t rsa
[grid@rac1 ~]$ /usr/bin/ssh-keygen -t dsa
[grid@rac1 ~]$ touch ~/.ssh/authorized_keys
[grid@rac1 ~]$ cd ~/.ssh
[grid@rac1 .ssh]$ cat id_rsa.pub >> authorized_keys
[grid@rac1 .ssh]$ cat id_dsa.pub >> authorized_keys

-- Step 39 -->> On Node 2
[root@rac2 ~]# su - grid
[grid@rac2 ~]$ mkdir ~/.ssh
[grid@rac2 ~]$ chmod 700 ~/.ssh
[grid@rac2 ~]$ /usr/bin/ssh-keygen -t rsa
[grid@rac2 ~]$ /usr/bin/ssh-keygen -t dsa
[grid@rac2 ~]$ cd ~/.ssh

-- Step 40 -->> On Node 1
[grid@rac1 .ssh]$ scp authorized_keys grid@rac2:~/.ssh/
/*
The authenticity of host 'rac2 (192.168.129.106)' can't be established.
RSA key fingerprint is 87:1a:ad:6d:f8:cc:fb:37:b7:60:66:c1:20:55:97:53.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'rac2,192.168.129.106' (RSA) to the list of known hosts.
grid@rac2's password: 
authorized_keys                               100% 1016     1.0KB/s   00:00    
*/

-- Step 40 -->> On all Nodes
[grid@rac1/rac2 .ssh]$ chmod 600 ~/.ssh/authorized_keys

-- Step 41 -->> On Node 1
[grid@rac1 .ssh]$ ssh grid@rac2
/*
grid@rac2's password:
*/ 
[grid@rac2 ~]$ exit
/*
logout
Connection to rac2 closed.
*/

-- Step 42 -->> On Node 2
[grid@rac2 .ssh]$ ssh grid@rac1
/*
The authenticity of host 'rac1 (192.168.129.105)' can't be established.
RSA key fingerprint is 4a:f2:44:d8:f2:82:93:17:27:d5:86:36:9a:ef:6f:25.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'rac1,192.168.129.105' (RSA) to the list of known hosts.
grid@rac1's password:
*/
[grid@rac1 ~]$ exit
/*
logout
Connection to rac1 closed.
*/

-- Step 43 -->> On Node 1
[root@rac1 ~]# ssh rac2
/*
The authenticity of host 'rac2 (192.168.129.106)' can't be established.
RSA key fingerprint is 87:1a:ad:6d:f8:cc:fb:37:b7:60:66:c1:20:55:97:53.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'rac2,192.168.129.106' (RSA) to the list of known hosts.
root@rac2's password:
*/

[root@rac2 ~]# ssh rac1
/*
The authenticity of host 'rac1 (192.168.129.105)' can't be established.
RSA key fingerprint is 4a:f2:44:d8:f2:82:93:17:27:d5:86:36:9a:ef:6f:25.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'rac1,192.168.129.105' (RSA) to the list of known hosts.
root@rac1's password: 
*/
[root@rac1 ~]# exit
/*
logout
Connection to rac1 closed.
*/
[root@rac2 ~]# exit
/*
logout
Connection to rac2 closed.
*/

-- Step 44 -->> On Node 2
[root@rac2 ~]# ssh rac1
/*
root@rac1's password: 
Last login: Mon Sep 16 10:07:30 2019 from rac2.mydomain
*/

[root@rac1 ~]# ssh rac2
/*
root@rac2's password: 
Last login: Mon Sep 16 10:07:15 2019 from rac1.mydomain
*/

[root@rac2 ~]# exit
/*
logout
Connection to rac2 closed.
*/

[root@rac1 ~]# exit
/*
logout
Connection to rac1 closed.
*/

-- Step 44 -->> On openfiler (SAN/NAS Storage)
[oracle@openfiler ~]#service iscsi-target restart

-- Step 37 -->> On all Nodes
[root@rac1/rac2 ~]# which oracleasm
/*
/usr/sbin/oracleasm
*/

-- Step 38 -->> On all Nodes
[root@rac1/rac2 ~]# oracleasm configure
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

-- Step 39 -->> On all Nodes
[root@rac1/rac2 ~]# oracleasm status
/*
Checking if ASM is loaded: no
Checking if /dev/oracleasm is mounted: no
*/

-- Step 40 -->> On all Nodes
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

-- Step 41 -->> On all Nodes
[root@rac1/rac2 ~]# oracleasm configure
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

-- Step 42 -->> On all Nodes
[root@rac1/rac2 ~]# oracleasm init
/*
Creating /dev/oracleasm mount point: /dev/oracleasm
Loading module "oracleasm": oracleasm
Configuring "oracleasm" to use device physical block size
Mounting ASMlib driver filesystem: /dev/oracleasm
*/

-- Step 43 -->> On all Nodes
[root@rac1/rac2 ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 44 -->> On all Nodes
[root@rac1/rac2 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 45 -->> On all Nodes
[root@rac1/rac2 ~]# oracleasm listdisks
[root@rac1/rac2 ~]# rpm -qa | grep -i iscsi
/*
iscsi-initiator-utils-6.2.0.873-27.0.10.el6_10.x86_64
*/

-- Step 46 -->> On all Nodes
[root@rac1/rac2 ~]# service iscsi stop
/*
Stopping iscsi:                                            [  OK  ]
*/

-- Step 47 -->> On all Nodes
[root@rac1/rac2 ~]# service iscsi status
/*
iscsi is stopped
*/

-- Step 48 -->> On all Nodes
[root@rac1/rac2 ~]# cd /etc/iscsi/
[root@rac1/rac2 iscsi]# ls
/*
initiatorname.iscsi  iscsid.conf
*/

-- Step 49 -->> On all Nodes
[root@rac1 iscsi]# vim initiatorname.iscsi 
/*
InitiatorName=iqn.rac1:oracle
*/

[root@rac2 iscsi]# vim initiatorname.iscsi 
/*
InitiatorName=iqn.rac2:oracle
*/

-- Step 50 -->> On all Nodes 
[root@rac1/rac2 iscsi]# service iscsi start
[root@rac1/rac2 iscsi]# chkconfig iscsi on
[root@rac1/rac2 iscsi]# chkconfig iscsid on

-- Step 51 -->> On all Nodes 
[root@rac1/rac2 iscsi]# lsscsi
/*
[1:0:0:0]    cd/dvd  NECVMWar VMware IDE CDR10 1.00  /dev/sr0 
[2:0:0:0]    disk    VMware,  VMware Virtual S 1.0   /dev/sda 
*/

-- Step 52 -->> On all Nodes 
[root@rac1/rac2 iscsi]# iscsiadm -m discovery -t sendtargets -p openfiler
/*
192.168.129.104:3260,1 iqn.openfiler:fra1
192.168.129.104:3260,1 iqn.openfiler:data1
192.168.129.104:3260,1 iqn.openfiler:ocr
*/

-- Step 53 -->> On all Nodes 
[root@rac1/rac2 iscsi]# lsscsi
/*
[1:0:0:0]    cd/dvd  NECVMWar VMware IDE CDR10 1.00  /dev/sr0 
[2:0:0:0]    disk    VMware,  VMware Virtual S 1.0   /dev/sda 
*/

-- Step 54 -->> On all Nodes 
[root@rac1/rac2 iscsi]# ls /var/lib/iscsi/send_targets/
/*
openfiler,3260
*/

-- Step 55 -->> On all Nodes 
[root@rac1/rac2 iscsi]# ls /var/lib/iscsi/nodes/
/*
iqn.openfiler:data1  iqn.openfiler:fra1  iqn.openfiler:ocr
*/

-- Step 56 -->> On all Nodes 
[root@rac1/rac2 iscsi]# service iscsi restart
/*
Stopping iscsi:                                            [  OK  ]
Starting iscsi:                                            [  OK  ]
*/

-- Step 57 -->> On all Nodes 
[root@rac1/rac2 iscsi]# lsscsi
/*
[1:0:0:0]    cd/dvd  NECVMWar VMware IDE CDR10 1.00  /dev/sr0 
[2:0:0:0]    disk    VMware,  VMware Virtual S 1.0   /dev/sda 
[4:0:0:0]    disk    OPNFILER VIRTUAL-DISK     0     /dev/sdb 
[6:0:0:0]    disk    OPNFILER VIRTUAL-DISK     0     /dev/sdc 
[8:0:0:0]    disk    OPNFILER VIRTUAL-DISK     0     /dev/sdd 
*/

-- Step 58 -->> On all Nodes 
[root@rac1/rac2 iscsi]# iscsiadm -m session
/*
tcp: [2] 192.168.129.104:3260,1 iqn.openfiler:data1 (non-flash)
tcp: [4] 192.168.129.104:3260,1 iqn.openfiler:fra1 (non-flash)
tcp: [6] 192.168.129.104:3260,1 iqn.openfiler:ocr (non-flash)
*/

-- Step 59 -->> On Node 1
[root@rac1 iscsi]# iscsiadm -m node -T iqn.openfiler:ocr -p 192.168.129.104 --op update -n node.startup -v automatic
[root@rac1 iscsi]# iscsiadm -m node -T iqn.openfiler:data1 -p 192.168.129.104 --op update -n node.startup -v automatic
[root@rac1 iscsi]# iscsiadm -m node -T iqn.openfiler:fra1 -p 192.168.129.104 --op update -n node.startup -v automatic

-- Step 60 -->> On Node 1
[root@rac1 iscsi]# lsscsi
/*
[1:0:0:0]    cd/dvd  NECVMWar VMware IDE CDR10 1.00  /dev/sr0 
[2:0:0:0]    disk    VMware,  VMware Virtual S 1.0   /dev/sda 
[4:0:0:0]    disk    OPNFILER VIRTUAL-DISK     0     /dev/sdb 
[6:0:0:0]    disk    OPNFILER VIRTUAL-DISK     0     /dev/sdc 
[8:0:0:0]    disk    OPNFILER VIRTUAL-DISK     0     /dev/sdd 
*/

-- Step 61 -->> On Node 1
[root@rac1 iscsi]# ls /dev/sd*
/*
/dev/sda   /dev/sda2  /dev/sda4  /dev/sda6  /dev/sda8  /dev/sdb  /dev/sdd
/dev/sda1  /dev/sda3  /dev/sda5  /dev/sda7  /dev/sda9  /dev/sdc
*/

-- Step 62 -->> On Node 1
[root@rac1 iscsi]# iscsiadm -m session -P 3 > scsi_drives.txt
[root@rac1 iscsi]# vim scsi_drives.txt 
[root@rac1 iscsi]# cat scsi_drives.txt 
/*
# iscsiadm -m session -P 3

Target: iqn.openfiler:data1 (non-flash)
            Attached scsi disk sdb        State: running
Target: iqn.openfiler:fra1 (non-flash)
            Attached scsi disk sdc        State: running
Target: iqn.openfiler:ocr (non-flash)
            Attached scsi disk sdd        State: running
*/

----------------------------------------------------------
-- Step 63 -->> On Node 1
-- Login from root user of rac1
[root@rac1 ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 64 -->> On Node 1
[root@rac1 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 65 -->> On Node 1
[root@rac1 ~]# oracleasm listdisks
[root@rac1 ~]# ls /dev/sd*
/*
/dev/sda   /dev/sda2  /dev/sda4  /dev/sda6  /dev/sda8  /dev/sdb  /dev/sdd
/dev/sda1  /dev/sda3  /dev/sda5  /dev/sda7  /dev/sda9  /dev/sdc
*/

-- Step 66 -->> On Node 1
[root@rac1 ~]# ls -ltr /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Sep  3 12:46 /dev/sda
brw-rw---- 1 root disk 8,  4 Sep  3 12:46 /dev/sda4
brw-rw---- 1 root disk 8,  7 Sep  3 12:46 /dev/sda7
brw-rw---- 1 root disk 8,  2 Sep  3 12:46 /dev/sda2
brw-rw---- 1 root disk 8,  1 Sep  3 12:46 /dev/sda1
brw-rw---- 1 root disk 8,  8 Sep  3 12:46 /dev/sda8
brw-rw---- 1 root disk 8,  9 Sep  3 12:46 /dev/sda9
brw-rw---- 1 root disk 8,  3 Sep  3 12:46 /dev/sda3
brw-rw---- 1 root disk 8,  5 Sep  3 12:46 /dev/sda5
brw-rw---- 1 root disk 8,  6 Sep  3 12:46 /dev/sda6
brw-rw---- 1 root disk 8, 16 Sep  3 12:47 /dev/sdb
brw-rw---- 1 root disk 8, 32 Sep  3 12:47 /dev/sdc
brw-rw---- 1 root disk 8, 48 Sep  3 12:47 /dev/sdd
*/

-- Step 67 -->> On Node 1
[root@rac1 ~]# fdisk /dev/sdb
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0x033c67f4.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/sdb: 21.5 GB, 21474836480 bytes
64 heads, 32 sectors/track, 20480 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x033c67f4

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

Disk /dev/sdb: 21.5 GB, 21474836480 bytes
64 heads, 32 sectors/track, 20480 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x033c67f4

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1       20480    20971504   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 68 -->> On Node 1
[root@rac1 ~]# fdisk /dev/sdc
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0x76d4b187.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/sdc: 16.1 GB, 16106127360 bytes
64 heads, 32 sectors/track, 15360 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x76d4b187

   Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-15360, default 1): 
Using default value 1
Last cylinder, +cylinders or +size{K,M,G} (1-15360, default 15360): 
Using default value 15360

Command (m for help): p

Disk /dev/sdc: 16.1 GB, 16106127360 bytes
64 heads, 32 sectors/track, 15360 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x76d4b187

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       15360    15728624   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 69 -->> On Node 1
[root@rac1 ~]# fdisk /dev/sdd
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0x42a82d1b.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/sdd: 5368 MB, 5368709120 bytes
166 heads, 62 sectors/track, 1018 cylinders
Units = cylinders of 10292 * 512 = 5269504 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x42a82d1b

   Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-1018, default 1): 
Using default value 1
Last cylinder, +cylinders or +size{K,M,G} (1-1018, default 1018): 
Using default value 1018

Command (m for help): p

Disk /dev/sdd: 5368 MB, 5368709120 bytes
166 heads, 62 sectors/track, 1018 cylinders
Units = cylinders of 10292 * 512 = 5269504 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x42a82d1b

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1        1018     5238597   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 70 -->> On Node 1
[root@rac1 ~]# ls -ltr /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Sep  3 12:46 /dev/sda
brw-rw---- 1 root disk 8,  4 Sep  3 12:46 /dev/sda4
brw-rw---- 1 root disk 8,  7 Sep  3 12:46 /dev/sda7
brw-rw---- 1 root disk 8,  2 Sep  3 12:46 /dev/sda2
brw-rw---- 1 root disk 8,  1 Sep  3 12:46 /dev/sda1
brw-rw---- 1 root disk 8,  8 Sep  3 12:46 /dev/sda8
brw-rw---- 1 root disk 8,  9 Sep  3 12:46 /dev/sda9
brw-rw---- 1 root disk 8,  3 Sep  3 12:46 /dev/sda3
brw-rw---- 1 root disk 8,  5 Sep  3 12:46 /dev/sda5
brw-rw---- 1 root disk 8,  6 Sep  3 12:46 /dev/sda6
brw-rw---- 1 root disk 8, 16 Sep  3 13:31 /dev/sdb
brw-rw---- 1 root disk 8, 17 Sep  3 13:31 /dev/sdb1
brw-rw---- 1 root disk 8, 32 Sep  3 13:33 /dev/sdc
brw-rw---- 1 root disk 8, 33 Sep  3 13:33 /dev/sdc1
brw-rw---- 1 root disk 8, 48 Sep  3 13:35 /dev/sdd
brw-rw---- 1 root disk 8, 49 Sep  3 13:35 /dev/sdd1
*/

-- Step 71 -->> On Node 1
[root@rac1 iscsi]# fdisk -l
/*
Disk /dev/sda: 107.4 GB, 107374182400 bytes
255 heads, 63 sectors/track, 13054 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000bfa46

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

Disk /dev/sdb: 26.2 GB, 26239565824 bytes
64 heads, 32 sectors/track, 25024 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x31093014

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1       25024    25624560   83  Linux

Disk /dev/sdc: 42.9 GB, 42949672960 bytes
64 heads, 32 sectors/track, 40960 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xcb59a453

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       40960    41943024   83  Linux

Disk /dev/sdd: 21.5 GB, 21474836480 bytes
64 heads, 32 sectors/track, 20480 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x2bdc6dd6

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1       20480    20971504   83  Linux
[root@rac1 iscsi]# 

*/

-- Step 72 -->> On Node 1
[root@rac1 ~]# oracleasm createdisk OCR /dev/sdd1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 73 -->> On Node 1
[root@rac1 ~]# oracleasm createdisk DATA /dev/sdc1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 74 -->> On Node 1
[root@rac1 ~]# oracleasm createdisk FRA /dev/sdb1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 75 -->> On Node 1
[root@rac1 ~]# hostname
/*
rac1.mydomain
*/

-- Step 76 -->> On Node 1
[root@rac1 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 78 -->> On Node 1
[root@rac1 ~]# oracleasm listdisks
/*
DATA
FRA
OCR
*/

-- Step 79 -->> On Node 2
[root@rac2 ~]# cd /etc/iscsi/
[root@rac2 iscsi]# service iscsi restart
/*
Stopping iscsi:                                            [  OK  ]
Starting iscsi:                                            [  OK  ]
*/

-- Step 80 -->> On Node 2
[root@rac2 iscsi]# ls -ltr /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Sep 16 09:28 /dev/sda
brw-rw---- 1 root disk 8,  4 Sep 16 09:28 /dev/sda4
brw-rw---- 1 root disk 8,  7 Sep 16 09:28 /dev/sda7
brw-rw---- 1 root disk 8,  2 Sep 16 09:28 /dev/sda2
brw-rw---- 1 root disk 8,  1 Sep 16 09:28 /dev/sda1
brw-rw---- 1 root disk 8,  8 Sep 16 09:28 /dev/sda8
brw-rw---- 1 root disk 8,  9 Sep 16 09:28 /dev/sda9
brw-rw---- 1 root disk 8,  3 Sep 16 09:28 /dev/sda3
brw-rw---- 1 root disk 8,  5 Sep 16 09:28 /dev/sda5
brw-rw---- 1 root disk 8,  6 Sep 16 09:28 /dev/sda6
brw-rw---- 1 root disk 8, 16 Sep 16 10:45 /dev/sdb
brw-rw---- 1 root disk 8, 32 Sep 16 10:45 /dev/sdc
brw-rw---- 1 root disk 8, 48 Sep 16 10:45 /dev/sdd
brw-rw---- 1 root disk 8, 49 Sep 16 10:45 /dev/sdd1
brw-rw---- 1 root disk 8, 17 Sep 16 10:45 /dev/sdb1
brw-rw---- 1 root disk 8, 33 Sep 16 10:45 /dev/sdc1
*/

-- Step 81 -->> On Node 2
[root@rac2 iscsi]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
Instantiating disk "DATA"
Instantiating disk "OCR"
Instantiating disk "FRA"
*/

-- Step 82 -->> On Node 2
[root@rac2 iscsi]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 83 -->> On Node 2
[root@rac2 iscsi]# oracleasm listdisks
/*
DATA
FRA
OCR
*/

-- Step 84 -->> On Node 2
[root@rac2 iscsi]# iscsiadm -m session -P 3 > scsi_drives.txt
[root@rac2 iscsi]# vim scsi_drives.txt 
[root@rac2 iscsi]# cat scsi_drives.txt 
/*
Target: iqn.openfiler:data1 (non-flash)
            Attached scsi disk sdb        State: running
Target: iqn.openfiler:fra1 (non-flash)
            Attached scsi disk sdd        State: running
Target: iqn.openfiler:ocr (non-flash)
            Attached scsi disk sdc        State: running
*/

-- Step 85 -->> On Node 2
[root@rac2 iscsi]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 86 -->> On all Nodes
-- To install the cvuqdisk-1.0.9-1.rpm on both racs
-- Login from root user
[root@rac1/rac2 ~]# cd /home/grid/grid_software/grid/rpm/
[root@rac1/rac2 rpm]# ls -ltr
/*
-rwxrwxr-x 1 grid oinstall 8551 Sep 22  2011 cvuqdisk-1.0.9-1.rpm
*/

[root@rac1/rac2 rpm]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP
[root@rac1/rac2 rpm]# rpm -iv cvuqdisk-1.0.9-1.rpm 
/*
Preparing packages for installation...
cvuqdisk-1.0.9-1
*/

[root@rac1/rac2 rpm]# rpm -iUvh cvuqdisk-1.0.9-1.rpm 
/*
Preparing...                ########################################### [100%]
   package cvuqdisk-1.0.9-1.x86_64 is already installed
*/


-- Step 87 -->> On all Nodes
[root@rac1/rac2 rpm]# init 0

-- Step 88 -->> On Node 1
-- Login as grid user and issu the following command at rac1
[grid@rac1 Desktop]$ cd 
[grid@rac1 ~]$ hostname
/*
rac1.mydomain
*/
[grid@rac1 ~]$ xhost + rac1.mydomain
/*
rac1.mydomain being added to access control list
*/
[grid@rac1 ~]$ 

-- Login as grid user and issue the following command at rac1 
-- Make sure choose proper groups while installing grid
-- OSDBA  Group => asmdba
-- OSOPER Group => asmoper
-- OSASM  Group => asmadmin
-- oraInventory Group Name => oinstall

[grid@rac1 ~]$ cd /home/grid/grid_software/grid/
[grid@rac1 grid]$ ls
/*
doc      readme.html  rpm           runInstaller  stage
install  response     runcluvfy.sh  sshsetup      welcome.html
*/
[grid@rac1 grid]$ sh ./runInstaller 

-- Run from root user to finalized the setup for both racs
-- Step 89 -->> On Node 1
[root@rac1 ~]#/u01/app/oraInventory/orainstRoot.sh
-- Step 90 -->> On Node 2
[root@rac2 ~]#/u01/app/oraInventory/orainstRoot.sh
-- Step 91 -->> On Node 1
[root@rac1 ~]# /u01/11.2.0.3.0/grid/root.sh 
-- Step 92 -->> On Node 2
[root@rac2 ~]# /u01/11.2.0.3.0/grid/root.sh 

-- Step 93 -->> On Node 1
[root@rac1 ~]# cd /u01/app/11.2.0.3/grid/bin/
[root@rac1 bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/

-- Step 94 -->> On Node 2
[root@rac2 ~]# cd /u01/app/11.2.0.3/grid/bin/
[root@rac2 bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/

-- Step 95 -->> On Node 1
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

-- Step 96 -->> On Node 2
[root@rac2 bin]# ./crsctl check cluster -all
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

-- Step 97 -->> On Node 1
[root@rac1 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS       
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       rac1                     Started             
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       rac1                                         
ora.crf
      1        ONLINE  ONLINE       rac1                                         
ora.crsd
      1        ONLINE  ONLINE       rac1                                         
ora.cssd
      1        ONLINE  ONLINE       rac1                                         
ora.cssdmonitor
      1        ONLINE  ONLINE       rac1                                         
ora.ctssd
      1        ONLINE  ONLINE       rac1                     ACTIVE:0            
ora.diskmon
      1        OFFLINE OFFLINE                                                   
ora.evmd
      1        ONLINE  ONLINE       rac1                                         
ora.gipcd
      1        ONLINE  ONLINE       rac1                                         
ora.gpnpd
      1        ONLINE  ONLINE       rac1                                         
ora.mdnsd
      1        ONLINE  ONLINE       rac1                                         
*/

-- Step 98 -->> On Node 1
root@rac1 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS       
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.DATA.dg
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.FRA.dg
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.LISTENER.lsnr
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.OCR.dg
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.asm
               ONLINE  ONLINE       rac1                     Started             
               ONLINE  ONLINE       rac2                     Started             
ora.gsd
               OFFLINE OFFLINE      rac1                                         
               OFFLINE OFFLINE      rac2                                         
ora.net1.network
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.ons
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       rac1                                         
ora.cvu
      1        ONLINE  ONLINE       rac1                                         
ora.oc4j
      1        ONLINE  ONLINE       rac1                                         
ora.rac1.vip
      1        ONLINE  ONLINE       rac1                                         
ora.rac2.vip
      1        ONLINE  ONLINE       rac2                                         
ora.scan1.vip
      1        ONLINE  ONLINE       rac1                                         
*/

-- Step 99 -->> On Node 2
[root@rac2 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS       
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       rac2                     Started             
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       rac2                                         
ora.crf
      1        ONLINE  ONLINE       rac2                                         
ora.crsd
      1        ONLINE  ONLINE       rac2                                         
ora.cssd
      1        ONLINE  ONLINE       rac2                                         
ora.cssdmonitor
      1        ONLINE  ONLINE       rac2                                         
ora.ctssd
      1        ONLINE  ONLINE       rac2                     ACTIVE:0            
ora.diskmon
      1        OFFLINE OFFLINE                                                   
ora.evmd
      1        ONLINE  ONLINE       rac2                                         
ora.gipcd
      1        ONLINE  ONLINE       rac2                                         
ora.gpnpd
      1        ONLINE  ONLINE       rac2                                         
ora.mdnsd
      1        ONLINE  ONLINE       rac2                                         
*/

-- Step 100 -->> On Node 2
[root@rac2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS       
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.DATA.dg
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.FRA.dg
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.LISTENER.lsnr
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.OCR.dg
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.asm
               ONLINE  ONLINE       rac1                     Started             
               ONLINE  ONLINE       rac2                     Started             
ora.gsd
               OFFLINE OFFLINE      rac1                                         
               OFFLINE OFFLINE      rac2                                         
ora.net1.network
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.ons
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       rac1                                         
ora.cvu
      1        ONLINE  ONLINE       rac1                                         
ora.oc4j
      1        ONLINE  ONLINE       rac1                                         
ora.rac1.vip
      1        ONLINE  ONLINE       rac1                                         
ora.rac2.vip
      1        ONLINE  ONLINE       rac2                                         
ora.scan1.vip
      1        ONLINE  ONLINE       rac1                                         
*/

-- Click on OK to complete the installations
-- Step 101 -->> On Node 1
[grid@rac1 ~]$ asmcmd
ASMCMD> lsdg
/*
State    Type    Rebal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512   4096  1048576     20479    20083                0           20083              0             Y  OCR/
*/
ASMCMD> exit

-- Step 102 -->> On Node 2
[grid@rac2 ~]$ asmcmd
ASMCMD> lsdg
/*
State    Type    Rebal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512   4096  1048576     20479    20083                0           20083              0             Y  OCR/
*/
ASMCMD> exit

-- Step 103 -->> On Node 1
-- Login as oracle user and issu the following command at rac1 
[oracle@rac1 Desktop]$ cd 
[oracle@rac1 ~]$ hostname
/*
rac1.mydomain
*/
[oracle@rac1 ~]$ xhost + rac1.mydomain
/*
rac1.mydomain being added to access control list
*/
[oracle@rac1 ~]$ 
-- Install database software only => Real Application Cluster database installation
-- Make sure choose proper groups while installing oracle
-- OSDBA  Group => dba
-- OSOPER Group => oper

[oracle@rac1 ~]$ cd /home/oracle/oracle_software/database/
[oracle@rac1 oracle]$ ls
/*
doc      readme.html  rpm           runInstaller  stage
install  response     runcluvfy.sh  sshsetup      welcome.html
*/
[oracle@rac1 oracle]$ sh ./runInstaller 

-- Run from root user to finalized the setup for both racs
-- Step 104 -->> On Node 1
[root@rac1 ~]# /u01/app/oracle/product/11.2.0.3.0/db_1/root.sh
-- Step 105 -->> On Node 2
[root@rac2 ~]# /u01/app/oracle/product/11.2.0.3.0/db_1/root.sh


-- Step 106 -->> On Node 1
--To add DATA and FRA storage
[grig@rac1 ~]# su - grid
[grig@rac1 ~]# cd /u01/11.2.0.3.0/grid/bin
[grig@rac1 bin]# ./asmca


-- Step 107 -->> On Node 1
-- To create database
[oracle@rac1 ~]# su - oracle
[oracle@rac1 ~]# cd /u01/app/oracle/product/11.2.0.3.0/db_1/bin
[oracle@rac1 bin]# ./dbca

-- Step 108 -->> On Node 1
[root@rac1 ~]# vi /etc/oratab
/*
+ASM1:/u01/11.2.0.3.0/grid:N        # line added by Agent
racdb1:/u01/app/oracle/product/11.2.0.3.0/db_1:N        # line added by Agent
*/

-- Step 109 -->> On Node 2
[root@rac2 ~]# vi /etc/oratab 
/*
+ASM2:/u01/11.2.0.3.0/grid:N        # line added by Agent
racdb2:/u01/app/oracle/product/11.2.0.3.0/db_1:N        # line added by Agent
*/

-- Step 110 -->> On Node 1
[oracle@rac1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 17-SEP-2019 11:54:08

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                17-SEP-2019 10:48:21
Uptime                    0 days 1 hr. 5 min. 46 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /u01/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /u01/app/oracle/diag/tnslsnr/rac1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.129.105)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.129.107)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "racdb" has 1 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
Service "racdbXDB" has 1 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 111 -->> On Node 1
[oracle@rac1 ~]$ sqlplus sys/sys as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Tue Sep 17 12:27:22 2019

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> select instance_name,status from gv$instance;

INSTANCE_NAME     STATUS
---------------- ------------
racdb1           OPEN
racdb2           OPEN

SQL> exit
*/

-- Step 112 -->> On Node 2
[oracle@rac2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 17-SEP-2019 11:53:36

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                17-SEP-2019 10:48:44
Uptime                    0 days 1 hr. 4 min. 51 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /u01/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /u01/app/oracle/diag/tnslsnr/rac2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.129.106)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.129.108)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "racdb" has 1 instance(s).
  Instance "racdb2", status READY, has 1 handler(s) for this service...
Service "racdbXDB" has 1 instance(s).
  Instance "racdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 113 -->> On Node 2
[oracle@rac2 ~]$ sqlplus sys/sys as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Tue Sep 17 11:59:50 2019

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> select instance_name,status from gv$instance;

INSTANCE_NAME     STATUS
---------------- ------------
racdb2           OPEN
racdb1           OPEN

SQL> exit
*/

-- Step 114 -->> On Node 2
[oracle@rac2 Desktop]$ su - root
/*
Password: 
*/

[root@rac2 ~]# cd /u01/11.2.0.3.0/grid/bin/
[root@rac2 bin]# ./crsctl check cluster -all
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

-- Step 115 -->> On Node 2
[root@rac2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS       
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.DATA.dg
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.FRA.dg
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.LISTENER.lsnr
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.OCR.dg
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.asm
               ONLINE  ONLINE       rac1                     Started             
               ONLINE  ONLINE       rac2                     Started             
ora.gsd
               OFFLINE OFFLINE      rac1                                         
               OFFLINE OFFLINE      rac2                                         
ora.net1.network
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.ons
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       rac1                                         
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       rac2                                         
ora.cvu
      1        ONLINE  ONLINE       rac2                                         
ora.oc4j
      1        ONLINE  ONLINE       rac2                                         
ora.rac1.vip
      1        ONLINE  ONLINE       rac1                                         
ora.rac2.vip
      1        ONLINE  ONLINE       rac2                                         
ora.racdb.db
      1        ONLINE  ONLINE       rac1                     Open                
      2        ONLINE  ONLINE       rac2                     Open                
ora.scan1.vip
      1        ONLINE  ONLINE       rac1                                         
ora.scan2.vip
      1        ONLINE  ONLINE       rac2                                         
*/

-- Step 116 -->> On Node 1
[oracle@rac1 Desktop]$ su - grid
/*
Password: 
*/

[grid@rac1 ~]$ asmcmd
ASMCMD> lsdg
/*
State    Type    Rebal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512   4096  1048576     40959    39305                0           39305              0             N  DATA/
MOUNTED  EXTERN  N         512   4096  1048576     25023    24693                0           24693              0             N  FRA/
MOUNTED  EXTERN  N         512   4096  1048576     20479    20083                0           20083              0             Y  OCR/
*/
ASMCMD> exit

-- Step 117 -->> On Node 2
[oracle@rac2 Desktop]$ su - grid
/*
Password: 
*/

[grid@rac2 ~]$ asmcmd
ASMCMD> lsdg
/*
State    Type    Rebal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512   4096  1048576     40959    39305                0           39305              0             N  DATA/
MOUNTED  EXTERN  N         512   4096  1048576     25023    24693                0           24693              0             N  FRA/
MOUNTED  EXTERN  N         512   4096  1048576     20479    20083                0           20083              0             Y  OCR/
*/
ASMCMD> exit

------------------------------------------------------------------------------------------------------
-- Reboot the cluster of rac1 and rac2 to verify the proper installation of Real Application Cluster--
------------------------------------------------------------------------------------------------------
-- Step 118 -->> On Node 1
[oracle@rac1 ~]$ su - root
/*
Password:
*/
[root@rac1 ~]# cd /u01/11.2.0.3.0/grid/bin/
[root@rac1 bin]# ./crsctl stop crs
/*
CRS-2791: Starting shutdown of Oracle High Availability Services-managed resources on 'rac1'
CRS-2673: Attempting to stop 'ora.crsd' on 'rac1'
CRS-2790: Starting shutdown of Cluster Ready Services-managed resources on 'rac1'
CRS-2673: Attempting to stop 'ora.LISTENER.lsnr' on 'rac1'
CRS-2673: Attempting to stop 'ora.LISTENER_SCAN1.lsnr' on 'rac1'
CRS-2673: Attempting to stop 'ora.OCR.dg' on 'rac1'
CRS-2673: Attempting to stop 'ora.racdb.db' on 'rac1'
CRS-2677: Stop of 'ora.LISTENER.lsnr' on 'rac1' succeeded
CRS-2673: Attempting to stop 'ora.rac1.vip' on 'rac1'
CRS-2677: Stop of 'ora.LISTENER_SCAN1.lsnr' on 'rac1' succeeded
CRS-2673: Attempting to stop 'ora.scan1.vip' on 'rac1'
CRS-2677: Stop of 'ora.rac1.vip' on 'rac1' succeeded
CRS-2672: Attempting to start 'ora.rac1.vip' on 'rac2'
CRS-2677: Stop of 'ora.scan1.vip' on 'rac1' succeeded
CRS-2672: Attempting to start 'ora.scan1.vip' on 'rac2'
CRS-2676: Start of 'ora.rac1.vip' on 'rac2' succeeded
CRS-2677: Stop of 'ora.racdb.db' on 'rac1' succeeded
CRS-2673: Attempting to stop 'ora.DATA.dg' on 'rac1'
CRS-2673: Attempting to stop 'ora.FRA.dg' on 'rac1'
CRS-2676: Start of 'ora.scan1.vip' on 'rac2' succeeded
CRS-2672: Attempting to start 'ora.LISTENER_SCAN1.lsnr' on 'rac2'
CRS-2677: Stop of 'ora.DATA.dg' on 'rac1' succeeded
CRS-2677: Stop of 'ora.FRA.dg' on 'rac1' succeeded
CRS-2676: Start of 'ora.LISTENER_SCAN1.lsnr' on 'rac2' succeeded
CRS-2677: Stop of 'ora.OCR.dg' on 'rac1' succeeded
CRS-2673: Attempting to stop 'ora.asm' on 'rac1'
CRS-2677: Stop of 'ora.asm' on 'rac1' succeeded
CRS-2673: Attempting to stop 'ora.ons' on 'rac1'
CRS-2677: Stop of 'ora.ons' on 'rac1' succeeded
CRS-2673: Attempting to stop 'ora.net1.network' on 'rac1'
CRS-2677: Stop of 'ora.net1.network' on 'rac1' succeeded
CRS-2792: Shutdown of Cluster Ready Services-managed resources on 'rac1' has completed
CRS-2677: Stop of 'ora.crsd' on 'rac1' succeeded
CRS-2673: Attempting to stop 'ora.crf' on 'rac1'
CRS-2673: Attempting to stop 'ora.ctssd' on 'rac1'
CRS-2673: Attempting to stop 'ora.evmd' on 'rac1'
CRS-2673: Attempting to stop 'ora.asm' on 'rac1'
CRS-2673: Attempting to stop 'ora.mdnsd' on 'rac1'
CRS-2677: Stop of 'ora.crf' on 'rac1' succeeded
CRS-2677: Stop of 'ora.mdnsd' on 'rac1' succeeded
CRS-2677: Stop of 'ora.evmd' on 'rac1' succeeded
CRS-2677: Stop of 'ora.asm' on 'rac1' succeeded
CRS-2673: Attempting to stop 'ora.cluster_interconnect.haip' on 'rac1'
CRS-2677: Stop of 'ora.ctssd' on 'rac1' succeeded
CRS-2677: Stop of 'ora.cluster_interconnect.haip' on 'rac1' succeeded
CRS-2673: Attempting to stop 'ora.cssd' on 'rac1'
CRS-2677: Stop of 'ora.cssd' on 'rac1' succeeded
CRS-2673: Attempting to stop 'ora.gipcd' on 'rac1'
CRS-2677: Stop of 'ora.gipcd' on 'rac1' succeeded
CRS-2673: Attempting to stop 'ora.gpnpd' on 'rac1'
CRS-2677: Stop of 'ora.gpnpd' on 'rac1' succeeded
CRS-2793: Shutdown of Oracle High Availability Services-managed resources on 'rac1' has completed
CRS-4133: Oracle High Availability Services has been stopped.
*/

-- Step 119 -->> On Node 2
[oracle@rac2 ~]$ su - root
/*
Password: 
*/

[root@rac2 ~]# cd /u01/11.2.0.3.0/grid/bin/
[root@rac2 bin]# ./crsctl stop crs
/*
CRS-2791: Starting shutdown of Oracle High Availability Services-managed resources on 'rac2'
CRS-2673: Attempting to stop 'ora.crsd' on 'rac2'
CRS-2790: Starting shutdown of Cluster Ready Services-managed resources on 'rac2'
CRS-2673: Attempting to stop 'ora.cvu' on 'rac2'
CRS-2673: Attempting to stop 'ora.rac1.vip' on 'rac2'
CRS-2673: Attempting to stop 'ora.LISTENER.lsnr' on 'rac2'
CRS-2673: Attempting to stop 'ora.OCR.dg' on 'rac2'
CRS-2673: Attempting to stop 'ora.racdb.db' on 'rac2'
CRS-2673: Attempting to stop 'ora.LISTENER_SCAN2.lsnr' on 'rac2'
CRS-2673: Attempting to stop 'ora.LISTENER_SCAN1.lsnr' on 'rac2'
CRS-2673: Attempting to stop 'ora.oc4j' on 'rac2'
CRS-2677: Stop of 'ora.rac1.vip' on 'rac2' succeeded
CRS-2677: Stop of 'ora.LISTENER_SCAN2.lsnr' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.scan2.vip' on 'rac2'
CRS-2677: Stop of 'ora.LISTENER.lsnr' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.rac2.vip' on 'rac2'
CRS-2677: Stop of 'ora.LISTENER_SCAN1.lsnr' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.scan1.vip' on 'rac2'
CRS-2677: Stop of 'ora.cvu' on 'rac2' succeeded
CRS-2677: Stop of 'ora.scan2.vip' on 'rac2' succeeded
CRS-2677: Stop of 'ora.rac2.vip' on 'rac2' succeeded
CRS-2677: Stop of 'ora.scan1.vip' on 'rac2' succeeded
CRS-2677: Stop of 'ora.racdb.db' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.DATA.dg' on 'rac2'
CRS-2673: Attempting to stop 'ora.FRA.dg' on 'rac2'
CRS-2677: Stop of 'ora.DATA.dg' on 'rac2' succeeded
CRS-2677: Stop of 'ora.FRA.dg' on 'rac2' succeeded
CRS-2677: Stop of 'ora.oc4j' on 'rac2' succeeded
CRS-2677: Stop of 'ora.OCR.dg' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.asm' on 'rac2'
CRS-2677: Stop of 'ora.asm' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.ons' on 'rac2'
CRS-2677: Stop of 'ora.ons' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.net1.network' on 'rac2'
CRS-2677: Stop of 'ora.net1.network' on 'rac2' succeeded
CRS-2792: Shutdown of Cluster Ready Services-managed resources on 'rac2' has completed
CRS-2677: Stop of 'ora.crsd' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.crf' on 'rac2'
CRS-2673: Attempting to stop 'ora.ctssd' on 'rac2'
CRS-2673: Attempting to stop 'ora.evmd' on 'rac2'
CRS-2673: Attempting to stop 'ora.asm' on 'rac2'
CRS-2673: Attempting to stop 'ora.mdnsd' on 'rac2'
CRS-2677: Stop of 'ora.crf' on 'rac2' succeeded
CRS-2677: Stop of 'ora.evmd' on 'rac2' succeeded
CRS-2677: Stop of 'ora.mdnsd' on 'rac2' succeeded
CRS-2677: Stop of 'ora.asm' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.cluster_interconnect.haip' on 'rac2'
CRS-2677: Stop of 'ora.ctssd' on 'rac2' succeeded
CRS-2677: Stop of 'ora.cluster_interconnect.haip' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.cssd' on 'rac2'
CRS-2677: Stop of 'ora.cssd' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.gipcd' on 'rac2'
CRS-2677: Stop of 'ora.gipcd' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.gpnpd' on 'rac2'
CRS-2677: Stop of 'ora.gpnpd' on 'rac2' succeeded
CRS-2793: Shutdown of Oracle High Availability Services-managed resources on 'rac2' has completed
CRS-4133: Oracle High Availability Services has been stopped.
*/

-- Step 120 -->> On Node 1
[root@rac1 bin]# ./crsctl start crs
/*
CRS-4123: Oracle High Availability Services has been started.
*/

-- Step 121 -->> On Node 2
[root@rac2 bin]# ./crsctl start crs
/*
CRS-4123: Oracle High Availability Services has been started.
*/

-- Step 122 -->> On Node 1
[root@rac1 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS       
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       rac1                     Started             
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       rac1                                         
ora.crf
      1        ONLINE  ONLINE       rac1                                         
ora.crsd
      1        ONLINE  ONLINE       rac1                                         
ora.cssd
      1        ONLINE  ONLINE       rac1                                         
ora.cssdmonitor
      1        ONLINE  ONLINE       rac1                                         
ora.ctssd
      1        ONLINE  ONLINE       rac1                     ACTIVE:0            
ora.diskmon
      1        OFFLINE OFFLINE                                                   
ora.evmd
      1        ONLINE  ONLINE       rac1                                         
ora.gipcd
      1        ONLINE  ONLINE       rac1                                         
ora.gpnpd
      1        ONLINE  ONLINE       rac1                                         
ora.mdnsd
      1        ONLINE  ONLINE       rac1                                         
*/

-- Step 123 -->> On Node 2
[root@rac2 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS       
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       rac2                     Started             
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       rac2                                         
ora.crf
      1        ONLINE  ONLINE       rac2                                         
ora.crsd
      1        ONLINE  ONLINE       rac2                                         
ora.cssd
      1        ONLINE  ONLINE       rac2                                         
ora.cssdmonitor
      1        ONLINE  ONLINE       rac2                                         
ora.ctssd
      1        ONLINE  ONLINE       rac2                     ACTIVE:0            
ora.diskmon
      1        OFFLINE OFFLINE                                                   
ora.evmd
      1        ONLINE  ONLINE       rac2                                         
ora.gipcd
      1        ONLINE  ONLINE       rac2                                         
ora.gpnpd
      1        ONLINE  ONLINE       rac2                                         
ora.mdnsd
      1        ONLINE  ONLINE       rac2                                         
*/

-- Step 124 -->> On Node 1
[root@rac1 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS       
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.DATA.dg
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.FRA.dg
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.LISTENER.lsnr
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.OCR.dg
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.asm
               ONLINE  ONLINE       rac1                     Started             
               ONLINE  ONLINE       rac2                     Started             
ora.gsd
               OFFLINE OFFLINE      rac1                                         
               OFFLINE OFFLINE      rac2                                         
ora.net1.network
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.ons
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       rac2                                         
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       rac1                                         
ora.cvu
      1        ONLINE  ONLINE       rac1                                         
ora.oc4j
      1        ONLINE  ONLINE       rac1                                         
ora.rac1.vip
      1        ONLINE  ONLINE       rac1                                         
ora.rac2.vip
      1        ONLINE  ONLINE       rac2                                         
ora.racdb.db
      1        ONLINE  ONLINE       rac1                     Open                
      2        ONLINE  ONLINE       rac2                     Open                
ora.scan1.vip
      1        ONLINE  ONLINE       rac2                                         
ora.scan2.vip
      1        ONLINE  ONLINE       rac1                                         
*/

-- Step 125 -->> On Node 2
[root@rac2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS       
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.DATA.dg
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.FRA.dg
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.LISTENER.lsnr
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.OCR.dg
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.asm
               ONLINE  ONLINE       rac1                     Started             
               ONLINE  ONLINE       rac2                     Started             
ora.gsd
               OFFLINE OFFLINE      rac1                                         
               OFFLINE OFFLINE      rac2                                         
ora.net1.network
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
ora.ons
               ONLINE  ONLINE       rac1                                         
               ONLINE  ONLINE       rac2                                         
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       rac2                                         
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       rac1                                         
ora.cvu
      1        ONLINE  ONLINE       rac1                                         
ora.oc4j
      1        ONLINE  ONLINE       rac1                                         
ora.rac1.vip
      1        ONLINE  ONLINE       rac1                                         
ora.rac2.vip
      1        ONLINE  ONLINE       rac2                                         
ora.racdb.db
      1        ONLINE  ONLINE       rac1                     Open                
      2        ONLINE  ONLINE       rac2                     Open                
ora.scan1.vip
      1        ONLINE  ONLINE       rac2                                         
ora.scan2.vip
      1        ONLINE  ONLINE       rac1                                         
*/

-- Step 126 -->> On Node 1
[oracle@rac1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 17-SEP-2019 12:43:25

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                17-SEP-2019 12:38:26
Uptime                    0 days 0 hr. 4 min. 59 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /u01/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /u01/app/oracle/diag/tnslsnr/rac1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.129.105)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.129.107)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "racdb" has 1 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
Service "racdbXDB" has 1 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 127 -->> On Node 1
[oracle@rac1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Tue Sep 17 12:44:44 2019

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> select instance_name,status from gv$instance;

INSTANCE_NAME     STATUS
---------------- ------------
racdb1         OPEN
racdb2         OPEN

SQL> select file_name from dba_data_files;

FILE_NAME
--------------------------------------------------------------------------------
+DATA/racdb/datafile/users.259.1019215997
+DATA/racdb/datafile/undotbs1.258.1019215997
+DATA/racdb/datafile/sysaux.257.1019215997
+DATA/racdb/datafile/system.256.1019215995
+DATA/racdb/datafile/undotbs2.264.1019216161

SQL> exit
*/

-- Step 128 -->> On Node 2
[oracle@rac2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 17-SEP-2019 12:43:11

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                17-SEP-2019 12:38:40
Uptime                    0 days 0 hr. 4 min. 31 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /u01/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /u01/app/oracle/diag/tnslsnr/rac2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.129.106)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.129.108)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "racdb" has 1 instance(s).
  Instance "racdb2", status READY, has 1 handler(s) for this service...
Service "racdbXDB" has 1 instance(s).
  Instance "racdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 129 -->> On Node 2
[oracle@rac2 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Tue Sep 17 12:47:27 2019

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> select instance_name,status from gv$instance;

INSTANCE_NAME     STATUS
---------------- ------------
racdb2         OPEN
racdb1         OPEN

SQL> select file_name from dba_data_files;

FILE_NAME
--------------------------------------------------------------------------------
+DATA/racdb/datafile/users.259.1019215997
+DATA/racdb/datafile/undotbs1.258.1019215997
+DATA/racdb/datafile/sysaux.257.1019215997
+DATA/racdb/datafile/system.256.1019215995
+DATA/racdb/datafile/undotbs2.264.1019216161

SQL> exit
*/