----------------------------------------------------------------
-------------Two Node Rac Setup on VM Workstation---------------
----------------------------------------------------------------

-- 2 Node Rac on VM -->> On both Node
[root@RAC1/RAC2 ~]# df -Th
/*
Filesystem    Type    Size  Used Avail Use% Mounted on
/dev/sda2     ext4     50G  534M   47G   2% /
tmpfs        tmpfs    4.0G  112K  4.0G   1% /dev/shm
/dev/sda1     ext4    9.9G  196M  9.2G   3% /boot
/dev/sda7     ext4    9.9G  151M  9.2G   2% /home
/dev/sda3     ext4     79G  184M   75G   1% /opt
/dev/sda8     ext4    9.9G  151M  9.2G   2% /tmp
/dev/sda5     ext4     15G  5.5G  8.7G  39% /usr
/dev/sda6     ext4     15G  345M   14G   3% /var
/dev/sr0   iso9660    3.5G  3.5G     0 100% /media/OL6.4 x86_64 Disc 1 20130225
*/

-- Step 1 -->> On both Node
[root@RAC1/RAC2 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.168.1.75   RAC1.mydomain        RAC1
192.168.1.76   RAC2.mydomain        RAC2

# Private
192.0.1.75     RAC1-priv.mydomain   RAC1-priv
192.0.1.76     RAC2-priv.mydomain   RAC2-priv

# Virtual
192.168.1.77   RAC1-vip.mydomain    RAC1-vip
192.168.1.78   RAC2-vip.mydomain    RAC2-vip

# SCAN
192.168.1.79   RAC-scan.mydomain    RAC-scan
192.168.1.80   RAC-scan.mydomain    RAC-scan
*/


-- Step 2 -->> On both Node
-- Disable secure linux by editing the "/etc/selinux/config" file, making sure the SELINUX flag is set as follows.
[root@RAC1/RAC2 ~]# vi /etc/selinux/config
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
[root@RAC1 network-scripts ~]# vi /etc/sysconfig/network
/*
NETWORKING=yes
HOSTNAME=RAC1.mydomain
*/

-- Step 4 -->> On Node 2
[root@RAC2 network-scripts ~]# vi /etc/sysconfig/network
/*
NETWORKING=yes
HOSTNAME=RAC2.mydomain
*/
-- Step 5 -->> On Node 1
[root@RAC1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth0 
/*
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.1.75
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=192.168.4.11
DNS2=192.168.4.12
*/

-- Step 6 -->> On Node 1
[root@RAC1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth1
/*
DEVICE=eth1
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.0.1.75
NETMASK=255.255.255.0
*/

-- Step 7 -->> On Node 2
[root@RAC2 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth0 
/*
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.1.76
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=192.168.4.11
DNS2=192.168.4.12
*/

-- Step 8 -->> On Node 2
[root@RAC2 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth1
/*
DEVICE=eth1
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.0.1.76
NETMASK=255.255.255.0
*/

-- Step 9 -->> On Both Node
[root@RAC1/RAC2 network-scripts]# service network restart
[root@RAC1/RAC2 network-scripts]# service NetworkManager stop
[root@RAC1/RAC2 network-scripts]# service network restart

-- Step 10 -->> On Both Node
[root@RAC1/RAC2 ~]# chkconfig --list iptables
/*
iptables  0:off    1:off    2:on    3:on    4:on    5:on    6:off
*/
[root@RAC1/RAC2 ~]# service iptables stop
/*
iptables: Setting chains to policy ACCEPT: nat mangle filte[  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
*/
[root@RAC1/RAC2 ~]# chkconfig iptables off
[root@RAC1/RAC2 ~]# iptables -F
[root@RAC1/RAC2 ~]# service iptables save
/*
iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]
*/
[root@RAC1/RAC2 ~]# /etc/init.d/iptables stop
/*
iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
*/
[root@RAC1/RAC2 ~]# iptables -L
/*
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
*/

[root@RAC1/RAC2 ~]# chkconfig --list iptables
/*
iptables   0:off    1:off    2:off    3:off    4:off    5:off    6:off
*/ 

-- Step 11 -->> On both Nodes
-- ntpd disable
[root@RAC1/RAC2 ~]# service ntpd stop
/*
Shutting down ntpd:                                        [FAILED]
*/

[root@RAC1/RAC2 ~]# service ntpd status
/*
ntpd is stopped
*/

[root@RAC1/RAC2 ~]# chkconfig ntpd off
[root@RAC1/RAC2 ~]# mv /etc/ntp.conf /etc/ntp.conf.backup
[root@RAC1/RAC2 ~]# rm -rf /etc/ntp.conf
[root@RAC1/RAC2 ~]# rm -rf /var/run/ntpd.pid

-- Step 12 -->> On Both Node
[root@RAC1/RAC2 ~]# init 6

-- Step 13 -->> On Both Node
[root@RAC1/RAC2 ~]# chkconfig --list iptables
/*
iptables   0:off    1:off    2:off    3:off    4:off    5:off    6:off
*/ 

[root@RAC1/RAC2 ~]# chkconfig --list ntpd
/*
ntpd            0:off   1:off   2:off   3:off   4:off   5:off   6:off
*/ 

-- Step 14 -->> On Both Node
-- Perform either the Automatic Setup or the Manual Setup to complete the basic prerequisites. 
-- The Additional Setup is required for all installations.
[root@RAC1/RAC2 ~]# cd /media/OL6.4\ x86_64\ Disc\ 1\ 20130225/Server/Packages/
[root@RAC1/RAC2 Packages]# yum install oracle-rdbms-server-11gR2-preinstall
[root@RAC1/RAC2 Packages]# yum update
[root@RAC1/RAC2 Packages]# rpm -iUvh binutils-2*x86_64*
[root@RAC1/RAC2 Packages]# rpm -iUvh glibc-2*x86_64* nss-softokn-freebl-3*x86_64*
[root@RAC1/RAC2 Packages]# rpm -iUvh glibc-2*i686* nss-softokn-freebl-3*i686*
[root@RAC1/RAC2 Packages]# rpm -iUvh compat-libstdc++-33*x86_64*
[root@RAC1/RAC2 Packages]# rpm -iUvh glibc-common-2*x86_64*
[root@RAC1/RAC2 Packages]# rpm -iUvh glibc-devel-2*x86_64*
[root@RAC1/RAC2 Packages]# rpm -iUvh glibc-devel-2*i686*
[root@RAC1/RAC2 Packages]# rpm -iUvh glibc-headers-2*x86_64*
[root@RAC1/RAC2 Packages]# rpm -iUvh elfutils-libelf-0*x86_64*
[root@RAC1/RAC2 Packages]# rpm -iUvh elfutils-libelf-devel-0*x86_64*
[root@RAC1/RAC2 Packages]# rpm -iUvh gcc-4*x86_64*
[root@RAC1/RAC2 Packages]# rpm -iUvh gcc-c++-4*x86_64*
[root@RAC1/RAC2 Packages]# rpm -iUvh ksh-*x86_64*
[root@RAC1/RAC2 Packages]# rpm -iUvh libaio-0*x86_64*
[root@RAC1/RAC2 Packages]# rpm -iUvh libaio-devel-0*x86_64*
[root@RAC1/RAC2 Packages]# rpm -iUvh libaio-0*i686*
[root@RAC1/RAC2 Packages]# rpm -iUvh libaio-devel-0*i686*
[root@RAC1/RAC2 Packages]# rpm -iUvh libgcc-4*x86_64*
[root@RAC1/RAC2 Packages]# rpm -iUvh libgcc-4*i686*
[root@RAC1/RAC2 Packages]# rpm -iUvh libstdc++-4*x86_64*
[root@RAC1/RAC2 Packages]# rpm -iUvh libstdc++-4*i686*
[root@RAC1/RAC2 Packages]# rpm -iUvh libstdc++-devel-4*x86_64*
[root@RAC1/RAC2 Packages]# rpm -iUvh make-3.81*x86_64*
[root@RAC1/RAC2 Packages]# rpm -iUvh numactl-devel-2*x86_64*
[root@RAC1/RAC2 Packages]# rpm -iUvh sysstat-9*x86_64*
[root@RAC1/RAC2 Packages]# rpm -iUvh compat-libstdc++-33*i686*
[root@RAC1/RAC2 Packages]# rpm -iUvh compat-libcap*
[root@RAC1/RAC2 Packages]# rpm -iUvh libaio-devel-0.*
[root@RAC1/RAC2 Packages]# rpm -iUvh ksh-2*
[root@RAC1/RAC2 Packages]# rpm -iUvh libstdc++-4.*.i686*
[root@RAC1/RAC2 Packages]# rpm -iUvh elfutils-libelf-0*i686* elfutils-libelf-devel-0*i686*
[root@RAC1/RAC2 Packages]# rpm -iUvh libtool-ltdl*i686*
[root@RAC1/RAC2 Packages]# rpm -iUvh ncurses*i686*
[root@RAC1/RAC2 Packages]# rpm -iUvh readline*i686*
[root@RAC1/RAC2 Packages]# rpm -iUvh unixODBC*
[root@RAC1/RAC2 Packages]# rpm -iUvh oracleasm*.rpm
[root@RAC1/RAC2 Packages]# yum update

-- Step 15 -->> On Both Node
[root@RAC1/RAC2 ~]# cd /root/Oracle_Linux_6_Rpm/
[root@RAC1/RAC2 Oracle_Linux_6_Rpm]# rpm -iUvh elfutils-libelf-devel-static-0.164-2.el6.x86_64.rpm
[root@RAC1/RAC2 Oracle_Linux_6_Rpm]# rpm -iUvh --nodeps --force unixODBC-devel-2.2.14-12.el6_3.x86_64.rpm

-- Step 16 -->> On Both Node
[root@RAC1/RAC2 ~]# cd /media/OL6.4\ x86_64\ Disc\ 1\ 20130225/Server/Packages/
[root@RAC1/RAC2 Packages]# yum update

-- Step 17 -->> On Both Node
[root@RAC1/RAC2 Packages]# rpm -q binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel elfutils-libelf-devel-static \
[root@RAC1/RAC2 Packages]# rpm -q gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers kernel-headers ksh libaio libaio-devel \
[root@RAC1/RAC2 Packages]# rpm -q libgcc libgomp libstdc++ libstdc++-devel make numactl-devel sysstat unixODBC unixODBC-devel \

-- Step 18 -->> On Both Node
-- Pre-Installation Steps for ASM
[root@RAC1/RAC2 ~ ]# cd /etc/yum.repos.d
[root@RAC1/RAC2 yum.repos.d]# uname -ras
/*
Linux RAC1/RAC2.mydomain 2.6.39-400.17.1.el6uek.x86_64 #1 SMP Fri Feb 22 18:16:18 PST 2013 x86_64 x86_64 x86_64 GNU/Linux
*/

-- Step 19 -->> On Both Node
[root@RAC1/RAC2 yum.repos.d]# cat /etc/os-release 
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

-- Step 20 -->> On Both Node
[root@RAC1/RAC2 yum.repos.d]# wget https://public-yum.oracle.com/public-yum-ol6.repo
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

-- Step 21 -->> On Both Node
[root@RAC1/RAC2 yum.repos.d]# yum install kmod-oracleasm
[root@RAC1/RAC2 yum.repos.d]# yum install oracleasm-support

-- Step 22 -->> On Both Node
[root@RAC1/RAC2 ~]# cd /root/Oracle_Linux_6_Rpm/
[root@RAC1/RAC2 Oracle_Linux_6_Rpm]# rpm -iUvh oracleasmlib-2.0.4-1.el6.x86_64.rpm
[root@RAC1/RAC2 yum.repos.d]# rpm -qa | grep oracleasm
/*
kmod-oracleasm-2.0.8-16.1.el6_10.x86_64
oracleasmlib-2.0.4-1.el6.x86_64
oracleasm-support-2.1.11-2.el6.x86_64
*/

[root@RAC1/RAC2 ~]# cd /media/OL6.4\ x86_64\ Disc\ 1\ 20130225/Server/Packages/
[root@RAC1/RAC2 Packages]# yum update

-- Step 23 -->> On Both Node
-- Add the kernel parameters file "/etc/sysctl.conf" and add oracle recommended kernel parameters
[root@RAC1/RAC2 ~]# vim /etc/sysctl.conf
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
net.ipv4.ip_local_port_range = 9000 65500
*/

-- Run the following command to change the current kernel parameters.
[root@RAC1/RAC2 ~]# sysctl -p /etc/sysctl.conf
--or--
[root@RAC1/RAC2 ~]# /sbin/sysctl -p

-- Step 24 -->> On Both Node
-- Edit “/etc/security/limits.conf” file to limit user processes
[root@RAC1/RAC2 ~]# vim /etc/security/limits.conf
/*
oracle   soft   nofile  65536
oracle   hard   nofile  65536
oracle   soft   nproc   16384
oracle   hard   nproc   16384
oracle   soft   stack   10240
oracle   hard   stack   32768
oracle   hard   memlock 134217728
oracle   soft   memlock 134217728

grid    soft    nofile   65536
grid    hard    nofile   65536
grid    soft    nproc    16384
grid    hard    nproc    16384
grid    soft    stack    10240
grid    hard    stack    32768
grid    soft    memlock  134217728
grid    hard    memlock  134217728
*/

-- Step 25 -->> On Both Node
-- Add the following line to the "/etc/pam.d/login" file, if it does not already exist.
[root@RAC1/RAC2 ~]# vim /etc/pam.d/login
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

-- Step 26 -->> On both Node
-- Create the new groups and users.
[root@RAC1/RAC2 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:
*/
[root@RAC1/RAC2 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:
*/

[root@RAC1/RAC2 !]# cat /etc/group | grep -i asm

-- 1.Create OS groups using the command below. Enter these commands as the 'root' user:
[root@RAC1/RAC2 ~]# /usr/sbin/groupadd -g 503 oper
[root@RAC1/RAC2 ~]# /usr/sbin/groupadd -g 504 asmadmin
[root@RAC1/RAC2 ~]# /usr/sbin/groupadd -g 506 asmdba
[root@RAC1/RAC2 ~]# /usr/sbin/groupadd -g 507 asmoper
[root@RAC1/RAC2 ~]# /usr/sbin/groupadd -g 508 beoper

-- 2.Create the users that will own the Oracle software using the commands:
[root@RAC1/RAC2 ~]# /usr/sbin/useradd -g oinstall -G oinstall,dba,asmadmin,asmdba,asmoper,beoper grid	
[root@RAC1/RAC2 ~]# /usr/sbin/usermod -g oinstall -G oinstall,dba,oper,asmadmin,asmdba oracle

[root@RAC1/RAC2 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:grid,oracle
*/
[root@RAC1/RAC2 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/
[root@RAC1/RAC2 ~]# cat /etc/group | grep -i oracle
/*
oracle:x:500:
oinstall:x:54321:grid,oracle
dba:x:54322:grid,oracle
oper:x:503:oracle
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
*/
[root@RAC1/RAC2 ~]# cat /etc/group | grep -i grid
/*
oinstall:x:54321:grid,oracle
dba:x:54322:grid,oracle
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

[root@RAC1/RAC2 ~]# cat /etc/group | grep -i oper
/*
oper:x:503:oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 27 -->> On both Node
[root@RAC1/RAC2 ~]# passwd oracle
/*
Changing password for user oracle.
New password: 
BAD PASSWORD: it is based on a dictionary word
BAD PASSWORD: is too simple
Retype new password: 
passwd: all authentication tokens updated successfully.
*/

-- Step 28 -->> On both Node
[root@RAC1/RAC2 ~]# passwd grid
/*
Changing password for user grid.
New password: 
BAD PASSWORD: it is too short
BAD PASSWORD: is too simple
Retype new password: 
passwd: all authentication tokens updated successfully.
*/

-- Step 29 -->> On both Node
[root@RAC1/RAC2 ~]# su - oracle
[oracle@RAC1/RAC2 ~]$ su - grid
[grid@RAC1/RAC2 ~]$ su - root

-- Step 30 -->> On both Node
--1.Create the Oracle Inventory Director:
[root@RAC1/RAC2 ~]# mkdir -p /opt/app/oraInventory
[root@RAC1/RAC2 ~]# chown -R grid:oinstall /opt/app/oraInventory
[root@RAC1/RAC2 ~]# chmod -R 775 /opt/app/oraInventory

--2.Creating the Oracle Grid Infrastructure Home Directory:
[root@RAC1/RAC2 ~]# mkdir -p /opt/app/11.2.0.3.0/grid
[root@RAC1/RAC2 ~]# chown -R grid:oinstall /opt/app/11.2.0.3.0/grid
[root@RAC1/RAC2 ~]# chmod -R 775 /opt/app/11.2.0.3.0/grid

--3.Creating the Oracle Base Directory
[root@RAC1/RAC2 ~]# mkdir -p /opt/app/oracle
[root@RAC1/RAC2 ~]# mkdir /opt/app/oracle/cfgtoollogs
[root@RAC1/RAC2 ~]# chown -R oracle:oinstall /opt/app/oracle
[root@RAC1/RAC2 ~]# chmod -R 775 /opt/app/oracle
[root@RAC1/RAC2 ~]# chown -R grid:oinstall /opt/app/oracle/cfgtoollogs
[root@RAC1/RAC2 ~]# chmod -R 775 /opt/app/oracle/cfgtoollogs

--4.Creating the Oracle RDBMS Home Directory
[root@RAC1/RAC2 ~]# mkdir -p /opt/app/oracle/product/11.2.0.3.0/db_1
[root@RAC1/RAC2 ~]# chown -R oracle:oinstall /opt/app/oracle/product/11.2.0.3.0/db_1
[root@RAC1/RAC2 ~]# chmod -R 775 /opt/app/oracle/product/11.2.0.3.0/db_1
[root@RAC1/RAC2 ~]# cd /opt/app/oracle
[root@RAC1/RAC2 ~]# chown -R oracle:oinstall product
[root@RAC1/RAC2 ~]# chmod -R 775 product

-- Step 31 -->> On both Nodes
-- Unzip the files and Copy the ASM rpm to another Nodes.
[root@RAC1/RAC2 ~]# cd /root/11.2.0.3.0/
[root@RAC1 11.2.0.3.0]# unzip p10404530_112030_Linux-x86-64_1of7.zip -d /opt/app/oracle/product/11.2.0.3.0/db_1/
[root@RAC1 11.2.0.3.0]# unzip p10404530_112030_Linux-x86-64_2of7.zip -d /opt/app/oracle/product/11.2.0.3.0/db_1/
[root@RAC1 11.2.0.3.0]# unzip p10404530_112030_Linux-x86-64_3of7-Clusterware.zip -d /opt/app/11.2.0.3.0/
[root@RAC2 ~]# mkdir -p /opt/app/11.2.0.3.0/grid/rpm/
[root@RAC1 ~]# cd /opt/app/11.2.0.3.0/grid/rpm/
[root@RAC1 rpm]# scp -r cvuqdisk-1.0.9-1.rpm root@RAC2:/opt/app/11.2.0.3.0/grid/rpm/
/*
The authenticity of host 'RAC2 (192.168.1.76)' can't be established.
RSA key fingerprint is 41:08:36:19:bd:fa:4f:7f:e8:ff:cf:27:e3:8d:61:e5.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'RAC2,192.168.1.76' (RSA) to the list of known hosts.
root@RAC2's password: 
cvuqdisk-1.0.9-1.rpm                                                     100% 8551     8.4KB/s   00:00    
*/

-- Step 32 -->> On both Nodes
[root@RAC1/RAC2 ~]# chown -R grid:oinstall /opt/app/11.2.0.3.0/grid
[root@RAC1/RAC2 ~]# chmod -R 775 /opt/app/11.2.0.3.0/grid
[root@RAC1/RAC2 ~]# chown -R oracle:oinstall /opt/app/oracle/product/11.2.0.3.0/db_1
[root@RAC1/RAC2 ~]# chmod -R 775 /opt/app/oracle/product/11.2.0.3.0/db_1

-- Step 33 -->> On both Nodes
[root@RAC1/RAC2 ~]# cd /opt/app/11.2.0.3.0/grid/rpm/
[root@RAC1/RAC2 rpm]# ls -ltr
/*
-rwxrwxr-x 1 grid oinstall 8551 Sep 22  2011 cvuqdisk-1.0.9-1.rpm
*/

[root@RAC1/RAC2 rpm]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP
[root@RAC1/RAC2 rpm]# rpm -iUvh cvuqdisk-1.0.9-1.rpm 
/*
Preparing...                          ################################# [100%]
   1:cvuqdisk-1.0.9-1                 ################################# [100%]
*/

-- Step 34 -->> On both Nodes
-- To Disable the virbr0/lxcbr0 Linux services 
[root@RAC1/RAC2 ~]# cd /etc/sysconfig/
[root@RAC1/RAC2 sysconfig]# brctl show
/*
bridge name    bridge id        STP enabled    interfaces
virbr0        8000.525400467a72    yes        virbr0-nic
*/

[root@RAC1/RAC2 sysconfig]# virsh net-list
/*
Name                 State      Autostart     Persistent
--------------------------------------------------
default              active     yes           yes
*/

[root@RAC1/RAC2 sysconfig]# service libvirtd stop
/*
Stopping libvirtd daemon:                                  [  OK  ]
*/
[root@RAC1/RAC2 sysconfig]# chkconfig --list | grep libvirtd
/*
libvirtd           0:off    1:off    2:off    3:on    4:on    5:on    6:off
*/

[root@RAC1/RAC2 sysconfig]# chkconfig libvirtd off
[root@RAC1/RAC2 sysconfig]# ip link set lxcbr0 down
[root@RAC1/RAC2 sysconfig]# brctl delbr lxcbr0
[root@RAC1/RAC2 sysconfig]# brctl show
[root@RAC1/RAC2 sysconfig]# init 6

-- Step 35 -->> On both Nodes
[root@RAC1/RAC2 ~]# brctl show
/*
bridge name    bridge id        STP enabled    interfaces
*/
[root@RAC1/RAC2 ~]# chkconfig --list | grep libvirtd
/*
libvirtd           0:off    1:off    2:off    3:off    4:off    5:off    6:off
*/

-- Step 36 -->> On Node 1
-- Login as the oracle user and add the following lines at the end of the ".bash_profile" file.
[root@RAC1 ~]# su - oracle
[oracle@RAC1 ~]$ vim .bash_profile
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

ORACLE_HOSTNAME=RAC1.mydomain; export ORACLE_HOSTNAME
ORACLE_UNQNAME=racdb; export ORACLE_UNQNAME
ORACLE_BASE=/opt/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/11.2.0.3.0/db_1; export ORACLE_HOME
ORACLE_SID=racdb1; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 37 -->> On Node 1
[oracle@RAC1 ~]$ . .bash_profile

-- Step 38 -->> On Node 1
-- Login as the grid user and add the following lines at the end of the ".bash_profile" file.
[root@RAC1 ~]# su - grid
[grid@RAC1 ~]$ vim .bash_profile
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

-- Step 39 -->> On Node 1
[grid@RAC1 ~]$ . .bash_profile

-- Step 40 -->> On Node 2
-- Login as the oracle user and add the following lines at the end of the ".bash_profile" file.
[root@RAC2 ~]# su - oracle
[oracle@RAC2 ~]$ vim .bash_profile
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

ORACLE_HOSTNAME=RAC2.mydomain; export ORACLE_HOSTNAME
ORACLE_UNQNAME=racdb; export ORACLE_UNQNAME
ORACLE_BASE=/opt/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/11.2.0.3.0/db_1; export ORACLE_HOME
ORACLE_SID=racdb2; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 41 -->> On Node 2
[oracle@RAC2 ~]$ . .bash_profile

-- Step 42 -->> On Node 2
-- Login as the grid user and add the following lines at the end of the ".bash_profile" file.
[root@RAC2 iscsi]# su - grid
[grid@RAC2 ~]$ vim .bash_profile
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

-- Step 43 -->> On Node 2
[grid@RAC2 ~]$ . .bash_profile

-- Step 44 -->> On Node 1
--SSH user Equivalency configuration (grid and oracle):
[root@RAC1 ~]# su - oracle
[oracle@RAC1 ~]$ cd /opt/app/oracle/product/11.2.0.3.0/db_1/database/sshsetup/
[oracle@RAC1 sshsetup]$ ./sshUserSetup.sh -user oracle -hosts "RAC1.mydomain RAC2.mydomain" -noPromptPassphrase -confirm -advanced

[root@RAC1 ~]# su - grid
[grid@RAC1 ~]$ cd /opt/app/11.2.0.3.0/grid/sshsetup
[grid@RAC1 deinstall]$ ./sshUserSetup.sh -user grid -hosts "RAC1.mydomain RAC2.mydomain" -noPromptPassphrase -confirm -advanced

-- Step 45 -->> On all Node
[root@RAC1/RAC2 ~]# which oracleasm
/*
/usr/sbin/oracleasm
*/

-- Step 46 -->> On all Node
[root@RAC1/RAC2 ~]# oracleasm configure
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

-- Step 47 -->> On all Node
[root@RAC1/RAC2 ~]# oracleasm status
/*
Checking if ASM is loaded: no
Checking if /dev/oracleasm is mounted: no
*/

-- Step 48 -->> On all Node
[root@RAC1/RAC2 ~]# oracleasm configure -i
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

-- Step 49 -->> On all Node
[root@RAC1/RAC2 ~]# oracleasm configure
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

-- Step 50 -->> On all Node
[root@RAC1/RAC2 ~]# oracleasm init
/*
Creating /dev/oracleasm mount point: /dev/oracleasm
Loading module "oracleasm": oracleasm
Configuring "oracleasm" to use device physical block size
Mounting ASMlib driver filesystem: /dev/oracleasm
*/

-- Step 51 -->> On all Node
[root@RAC1/RAC2 ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 52 -->> On all Node
[root@RAC1/RAC2 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 53 -->> On all Node
[root@RAC1/RAC2 ~]# oracleasm listdisks

-- Step 54 -->> On Node 1
[root@RAC1 ~]# ls -ltr /dev/sd*
/*
brw-rw---- 1 root disk 8, 48 Aug  2 11:37 /dev/sdd
brw-rw---- 1 root disk 8, 16 Aug  2 11:37 /dev/sdb
brw-rw---- 1 root disk 8,  0 Aug  2 11:37 /dev/sda
brw-rw---- 1 root disk 8,  4 Aug  2 11:37 /dev/sda4
brw-rw---- 1 root disk 8, 32 Aug  2 11:37 /dev/sdc
brw-rw---- 1 root disk 8,  7 Aug  2 11:37 /dev/sda7
brw-rw---- 1 root disk 8,  2 Aug  2 11:37 /dev/sda2
brw-rw---- 1 root disk 8,  1 Aug  2 11:37 /dev/sda1
brw-rw---- 1 root disk 8,  8 Aug  2 11:37 /dev/sda8
brw-rw---- 1 root disk 8,  3 Aug  2 11:37 /dev/sda3
brw-rw---- 1 root disk 8,  9 Aug  2 11:37 /dev/sda9
brw-rw---- 1 root disk 8,  5 Aug  2 11:37 /dev/sda5
brw-rw---- 1 root disk 8,  6 Aug  2 11:37 /dev/sda6
*/

-- Step 55 -->> On Node 1
[root@RAC1 ~]# fdisk -ll
/*
Disk /dev/sdc: 53.7 GB, 53687091200 bytes
64 heads, 32 sectors/track, 51200 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000


Disk /dev/sda: 214.7 GB, 214748364800 bytes
255 heads, 63 sectors/track, 26108 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000393cb

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1        1306    10485760   83  Linux
/dev/sda2            1306        7833    52428800   83  Linux
/dev/sda3            7833       18276    83878912   83  Linux
/dev/sda4           18276       26109    62920704    5  Extended
/dev/sda5           18276       20234    15728640   83  Linux
/dev/sda6           20234       22192    15728640   83  Linux
/dev/sda7           22192       23498    10485760   82  Linux swap / Solaris
/dev/sda8           23498       24803    10485760   83  Linux
/dev/sda9           24803       26109    10485760   83  Linux

Disk /dev/sdd: 53.7 GB, 53687091200 bytes
64 heads, 32 sectors/track, 51200 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000


Disk /dev/sdb: 10.7 GB, 10737418240 bytes
64 heads, 32 sectors/track, 10240 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

*/

-- Step 56 -->> On Node 1
[root@RAC1 ~]# fdisk /dev/sdb
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0x29112920.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/sdb: 10.7 GB, 10737418240 bytes
64 heads, 32 sectors/track, 10240 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x29112920

   Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-10240, default 1): 
Using default value 1
Last cylinder, +cylinders or +size{K,M,G} (1-10240, default 10240): 
Using default value 10240

Command (m for help): p

Disk /dev/sdb: 10.7 GB, 10737418240 bytes
64 heads, 32 sectors/track, 10240 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x29112920

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1       10240    10485744   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 57 -->> On Node 1
[root@RAC1 ~]# fdisk /dev/sdc
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0xbff51c9c.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/sdc: 53.7 GB, 53687091200 bytes
64 heads, 32 sectors/track, 51200 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xbff51c9c

   Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-51200, default 1): 
Using default value 1
Last cylinder, +cylinders or +size{K,M,G} (1-51200, default 51200): 
Using default value 51200

Command (m for help): p

Disk /dev/sdc: 53.7 GB, 53687091200 bytes
64 heads, 32 sectors/track, 51200 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xbff51c9c

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       51200    52428784   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.

*/

-- Step 58 -->> On Node 1
[root@RAC1 ~]# fdisk /dev/sdd
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0xebb9bef6.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/sdd: 53.7 GB, 53687091200 bytes
64 heads, 32 sectors/track, 51200 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xebb9bef6

   Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-51200, default 1): 
Using default value 1
Last cylinder, +cylinders or +size{K,M,G} (1-51200, default 51200): 
Using default value 51200

Command (m for help): p

Disk /dev/sdd: 53.7 GB, 53687091200 bytes
64 heads, 32 sectors/track, 51200 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xebb9bef6

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1       51200    52428784   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 59 -->> On Node 1
[root@RAC1 ~]# mkfs.ext4 /dev/sdb1
[root@RAC1 ~]# mkfs.ext4 /dev/sdc1
[root@RAC1 ~]# mkfs.ext4 /dev/sdd1

-- Step 60 -->> On Node 1
[root@RAC1 ~]# ls -ltr /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Aug  2 11:37 /dev/sda
brw-rw---- 1 root disk 8,  4 Aug  2 11:37 /dev/sda4
brw-rw---- 1 root disk 8,  7 Aug  2 11:37 /dev/sda7
brw-rw---- 1 root disk 8,  2 Aug  2 11:37 /dev/sda2
brw-rw---- 1 root disk 8,  1 Aug  2 11:37 /dev/sda1
brw-rw---- 1 root disk 8,  8 Aug  2 11:37 /dev/sda8
brw-rw---- 1 root disk 8,  3 Aug  2 11:37 /dev/sda3
brw-rw---- 1 root disk 8,  9 Aug  2 11:37 /dev/sda9
brw-rw---- 1 root disk 8,  5 Aug  2 11:37 /dev/sda5
brw-rw---- 1 root disk 8,  6 Aug  2 11:37 /dev/sda6
brw-rw---- 1 root disk 8, 17 Aug  2 11:47 /dev/sdb1
brw-rw---- 1 root disk 8, 16 Aug  2 11:47 /dev/sdb
brw-rw---- 1 root disk 8, 33 Aug  2 11:48 /dev/sdc1
brw-rw---- 1 root disk 8, 32 Aug  2 11:48 /dev/sdc
brw-rw---- 1 root disk 8, 48 Aug  2 11:49 /dev/sdd
brw-rw---- 1 root disk 8, 49 Aug  2 11:49 /dev/sdd1
*/

-- Step 61 -->> On Both Nodes
[root@RAC1/RAC2 ~]# fdisk -ll
/*
Disk /dev/sdc: 53.7 GB, 53687091200 bytes
64 heads, 32 sectors/track, 51200 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xbff51c9c

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       51200    52428784   83  Linux

Disk /dev/sda: 214.7 GB, 214748364800 bytes
255 heads, 63 sectors/track, 26108 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000393cb

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1        1306    10485760   83  Linux
/dev/sda2            1306        7833    52428800   83  Linux
/dev/sda3            7833       18276    83878912   83  Linux
/dev/sda4           18276       26109    62920704    5  Extended
/dev/sda5           18276       20234    15728640   83  Linux
/dev/sda6           20234       22192    15728640   83  Linux
/dev/sda7           22192       23498    10485760   82  Linux swap / Solaris
/dev/sda8           23498       24803    10485760   83  Linux
/dev/sda9           24803       26109    10485760   83  Linux

Disk /dev/sdd: 53.7 GB, 53687091200 bytes
64 heads, 32 sectors/track, 51200 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xebb9bef6

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1       51200    52428784   83  Linux

Disk /dev/sdb: 10.7 GB, 10737418240 bytes
64 heads, 32 sectors/track, 10240 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x29112920

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1       10240    10485744   83  Linux
*/

-- Step 62 -->> On Node 1
[root@RAC1 ~]# /etc/init.d/oracleasm createdisk OCR /dev/sdb1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 63 -->> On Node 1
[root@RAC1 ~]# /etc/init.d/oracleasm createdisk DATA /dev/sdc1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 64 -->> On Node 1
[root@RAC1 ~]# /etc/init.d/oracleasm createdisk ARC /dev/sdd1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 65 -->> On Node 1
[root@RAC1 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 66 -->> On Node 1
[root@RAC1 ~]# oracleasm listdisks
/*
ARC
DATA
OCR
*/

-- Step 67 -->> On Node 2
[root@RAC2 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
Instantiating disk "OCR"
Instantiating disk "ARC"
Instantiating disk "DATA"
*/

-- Step 68 -->> On Node 2
[root@RAC2 ~]# oracleasm listdisks
/*
ARC
DATA
OCR
*/

-- Step 69 -->> On Node 1
-- Pre-check for RAC Setup
[grid@RAC1 ~]$ cd /opt/app/11.2.0.3.0/grid
[grid@RAC1 grid]$ ./runcluvfy.sh stage -pre crsinst -n RAC1,RAC2 -verbose
-- OR --
[grid@RAC1 grid]$ ./runcluvfy.sh stage -pre crsinst -n RAC1.mydomain,RAC2.mydomain -verbose
[grid@rac1 grid]$ ./runcluvfy.sh stage -pre crsinst -n rac1,rac2 -method root
--[grid@rac1 grid]$ ./runcluvfy.sh stage -pre crsinst -n rac1,rac2 -fixup -verbose (If Required)

-- Step 70 -->> On Node 1
-- Login as grid user and issu the following command at RAC1
[grid@RAC1 Desktop]$ cd 
[grid@RAC1/RAC2 ~]$ hostname
/*
RAC1.mydomain
*/
[grid@RAC1 ~]$ xhost + RAC1.mydomain
/*
RAC1.mydomain being added to access control list
*/

-- Step 71 -->> On Both Nodes
-- Login as grid user and issue the following command at RAC1 
-- Make sure choose proper groups while installing grid
-- OSDBA  Group => asmdba
-- OSOPER Group => asmoper
-- OSASM  Group => asmadmin
-- oraInventory Group Name => oinstall
[grid@RAC1 ~]$ cd /opt/app/11.2.0.3.0/grid
[grid@RAC1 grid]$ sh ./runInstaller.sh 

-- Step 72 -->> On Both Nodes
-- Run from root user to finalized the setup for both racs
[root@RAC1/RAC2 ~]# /opt/app/oraInventory/orainstRoot.sh
[root@RAC1/RAC2 ~]# /opt/app/11.2.0.3.0/grid/root.sh 

-- Step 73 -->> On Both Nodes
[root@RAC1/RAC2 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
[root@RAC1/RAC2 bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/

-- Step 74 -->> On Both Nodes
[root@RAC1/RAC2 bin]# ./crsctl check cluster -all
/*
**************************************************************
RAC1:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
RAC2:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/

-- Step 75 -->> On Node 1
[root@RAC1 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS       
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       RAC1                     Started             
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       RAC1                                         
ora.crf
      1        ONLINE  ONLINE       RAC1                                         
ora.crsd
      1        ONLINE  ONLINE       RAC1                                         
ora.cssd
      1        ONLINE  ONLINE       RAC1                                         
ora.cssdmonitor
      1        ONLINE  ONLINE       RAC1                                         
ora.ctssd
      1        ONLINE  ONLINE       RAC1                     ACTIVE:0            
ora.diskmon
      1        OFFLINE OFFLINE                                                   
ora.evmd
      1        ONLINE  ONLINE       RAC1                                         
ora.gipcd
      1        ONLINE  ONLINE       RAC1                                         
ora.gpnpd
      1        ONLINE  ONLINE       RAC1                                         
ora.mdnsd
      1        ONLINE  ONLINE       RAC1                                       
*/


-- Step 76 -->> On Node 2
[root@RAC2 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS       
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       RAC2                     Started             
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       RAC2                                         
ora.crf
      1        ONLINE  ONLINE       RAC2                                         
ora.crsd
      1        ONLINE  ONLINE       RAC2                                         
ora.cssd
      1        ONLINE  ONLINE       RAC2                                         
ora.cssdmonitor
      1        ONLINE  ONLINE       RAC2                                         
ora.ctssd
      1        ONLINE  ONLINE       RAC2                     ACTIVE:0            
ora.diskmon
      1        OFFLINE OFFLINE                                                   
ora.evmd
      1        ONLINE  ONLINE       RAC2                                         
ora.gipcd
      1        ONLINE  ONLINE       RAC2                                         
ora.gpnpd
      1        ONLINE  ONLINE       RAC2                                         
ora.mdnsd
      1        ONLINE  ONLINE       RAC2                                         
*/

-- Step 77 -->> On Both Nodes
[root@RAC1/RAC2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS       
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       RAC1                                         
               ONLINE  ONLINE       RAC2                                         
ora.OCR.dg
               ONLINE  ONLINE       RAC1                                         
               ONLINE  ONLINE       RAC2                                         
ora.asm
               ONLINE  ONLINE       RAC1                     Started             
               ONLINE  ONLINE       RAC2                     Started             
ora.gsd
               OFFLINE OFFLINE      RAC1                                         
               OFFLINE OFFLINE      RAC2                                         
ora.net1.network
               ONLINE  ONLINE       RAC1                                         
               ONLINE  ONLINE       RAC2                                         
ora.ons
               ONLINE  ONLINE       RAC1                                         
               ONLINE  ONLINE       RAC2                                         
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       RAC2                                         
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       RAC1                                         
ora.cvu
      1        ONLINE  ONLINE       RAC1                                         
ora.oc4j
      1        ONLINE  ONLINE       RAC1                                         
ora.RAC1.vip
      1        ONLINE  ONLINE       RAC1                                         
ora.RAC2.vip
      1        ONLINE  ONLINE       RAC2                                         
ora.scan1.vip
      1        ONLINE  ONLINE       RAC2                                         
ora.scan2.vip
      1        ONLINE  ONLINE       RAC1                      
*/

-- Step 78 -->> On Node 1
/*
Click on OK to complete the installations
*/

-- Step 79 -->> On Node 1
[grid@RAC1 ~]$ asmcmd
ASMCMD> lsdg
/*
State    Type    Rebal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512   4096  1048576     30719    30323                0           30323              0             Y  OCR/
*/
ASMCMD> exit

-- Step 80 -->> On Node 2
[grid@RAC2 ~]$ asmcmd
ASMCMD> lsdg
/*
State    Type    Rebal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512   4096  1048576     30719    30323                0           30323              0             Y  OCR/
*/
ASMCMD> exit

-- Step 81 -->> On Node 1
-- Login as oracle user and issu the following command at RAC1 
[oracle@RAC1 ~]$ hostname
/*
RAC1.mydomain
*/
[oracle@RAC1 ~]$ xhost + RAC1.mydomain
/*
RAC1.mydomain being added to access control list
*/

-- Step 82 -->> On Node 1
-- Install database software only => Real Application Cluster database installation
-- Make sure choose proper groups while installing oracle
-- OSDBA  Group => dba
-- OSOPER Group => oper
[oracle@SDB-RAC1 ~]$ cd /opt/app/oracle/product/11.2.0.3.0/db_1/database/
[oracle@RAC1 oracle]$ sh ./runInstaller 

-- Step 83 -->> On Both Nodes
-- Run from root user to finalized the setup for both racs
[root@RAC1/RAC2 ~]# /opt/app/oracle/product/11.2.0.3.0/db_1/root.sh


-- Step 84 -->> On Node 1
--To add DATA and FRA storage
[grid@RAC1 ~]# cd /opt/app/11.2.0.3.0/grid/bin
[grid@RAC1 bin]# ./asmca

-- Step 85 -->> On Node 1
-- To create database 
[oracle@RAC1 ~]# cd /opt/app/oracle/product/11.2.0.3.0/db_1/bin
[oracle@RAC1 bin]# ./dbca

-- Step 86 -->> On Node 1
[root@RAC1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/11.2.0.3.0/grid:N        # line added by Agent
racdb1:/opt/app/oracle/product/11.2.0.3.0/db_1:N        # line added by Agent
*/

-- Step 87 -->> On Node 2
[root@RAC2 ~]# vi /etc/oratab 
/*
+ASM2:/opt/app/11.2.0.3.0/grid:N        # line added by Agent
racdb2:/opt/app/oracle/product/11.2.0.3.0/db_1:N        # line added by Agent
*/

-- Step 88 -->> On Both Nodes
-- Reboot the Oracle Cluster
[root@RAC1/RAC2 ~]# cd /opt/app/11.2.0.3.0/grid/bin
[root@RAC1/RAC2 ~]# ./crsctl stop crs
[root@RAC1/RAC2 ~]# ./crsctl start crs
[root@RAC1/RAC2 ~]# ./crsctl stat res -t -init
[root@RAC1/RAC2 ~]# ./crsctl stat res -t
[root@RAC1/RAC2 ~]# ./crsctl check cluster -all
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

-- Step 89 -->> On Both Nodes
[root@RAC1/RAC2 ~]# su - grid
[grid@RAC1/RAC2 ~]$ asmcmd
ASMCMD> lsdg
/*
State    Type    Rebal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512   4096  1048576     51199    51104                0           51104              0             N  ARC/
MOUNTED  EXTERN  N         512   4096  1048576     51199    49317                0           49317              0             N  DATA/
MOUNTED  EXTERN  N         512   4096  1048576     10239     9843                0            9843              0             Y  OCR/
ASMCMD> exit
*/

-- Step 90 -->> On Both Nodes
[root@RAC1/RAC2 ~]# su - oracle
[oracle@RAC1/RAC2 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node rac1
Instance racdb2 is running on node rac2
*/

-- Step 91 -->> On Both Nodes
[oracle@RAC1/RAC2 ~]$ srvctl status listener -l listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): rac1,rac2
*/

-- Step 92 -->> On Both Nodes
[oracle@RAC1/RAC2 ~]$ srvctl config database -d racdb
/*
Database unique name: racdb
Database name: racdb
Oracle home: /opt/app/oracle/product/11.2.0.3.0/db_1
Oracle user: oracle
Spfile: +DATA/racdb/spfileracdb.ora
Domain: 
Start options: open
Stop options: immediate
Database role: PRIMARY
Management policy: AUTOMATIC
Server pools: racdb
Database instances: racdb1,racdb2
Disk Groups: DATA
Mount point paths: 
Services: 
Type: RAC
Database is administrator managed
*/

-- Step 93 -->> On Node 1
[oracle@RAC1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 28-JUL-2020 00:30:19

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                27-JUL-2020 22:51:33
Uptime                    0 days 1 hr. 38 min. 46 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/RAC1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.75)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.77)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "racdb" has 1 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
Service "racdbXDB" has 1 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 94 -->> On Node 2
[oracle@RAC2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 28-JUL-2020 00:31:07

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                27-JUL-2020 23:02:21
Uptime                    0 days 1 hr. 28 min. 45 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/RAC2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.76)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.78)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "racdb" has 1 instance(s).
  Instance "racdb2", status READY, has 1 handler(s) for this service...
Service "racdbXDB" has 1 instance(s).
  Instance "racdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 95 -->> On Node 1
-- To Enable and Configure the Archive Log
[oracle@RAC1 ~]$ srvctl stop database -d racdb
[oracle@RAC1 ~]$ srvctl start database -d racdb -o mount
[oracle@RAC1 ~]$ sqlplus sys/sys as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Wed Aug 17 14:46:11 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

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
SQL> ALTER SYSTEM SET log_archive_format='racdb_%t_%s_%r.arc' scope=spfile sid='*';


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
      1 RACDB ARCHIVELOG MOUNTED   MAXIMUM PERFORMANCE
      2 RACDB ARCHIVELOG MOUNTED   MAXIMUM PERFORMANCE

SQL> set linesize 200
SQL> SELECT * FROM gv$version;
INST_ID BANNER                                                                      
------- ----------------------------------------------------------------------------
      1 Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
      1 PL/SQL Release 11.2.0.3.0 - Production                                      
      1 CORE    11.2.0.3.0    Production                                            
      1 TNS for Linux: Version 11.2.0.3.0 - Production                              
      1 NLSRTL Version 11.2.0.3.0 - Production                                      
      2 Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
      2 PL/SQL Release 11.2.0.3.0 - Production                                      
      2 CORE    11.2.0.3.0    Production                                            
      2 TNS for Linux: Version 11.2.0.3.0 - Production                              
      2 NLSRTL Version 11.2.0.3.0 - Production                                      

SQL> exit
*/

-- Step 96 -->> On Node 1
[oracle@RAC1 ~]$ srvctl stop database -d racdb
[oracle@RAC1 ~]$ srvctl start database -d racdb

-- Step 97 -->> On Both Nodes
[oracle@RAC1/RAC2 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node RAC1
Instance racdb2 is running on node RAC2
*/

-- Step 98 -->> On Node 1
--To Create Oracle Tablespace,User with Grants and a Oracle Object on Newly Created Oracle User
[oracle@RAC1/RAC2 ~]$ sqlplus sys/sys as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Tue Jul 28 01:00:05 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SET SERVEROUTPUT ON;
SQL> DECLARE
          l_input     VARCHAR2(30) := 'UPGRADE';
          l_location  VARCHAR2(100);
     BEGIN
         SELECT SUBSTR(file_name,1,INSTR(file_name,'/',-1)) file_name INTO l_location FROM dba_data_files WHERE ROWNUM =1;
         BEGIN 
             EXECUTE IMMEDIATE 'CREATE TABLESPACE '||l_input||'
                                DATAFILE '''||l_location||''||l_input||'.dbf''
                                SIZE 1g
                                AUTOEXTEND ON NEXT 500m MAXSIZE UNLIMITED
                                SEGMENT SPACE MANAGEMENT auto
                                NOLOGGING ';
         
             EXECUTE IMMEDIATE 'CREATE USER '||l_input||' IDENTIFIED BY oracle
                                DEFAULT TABLESPACE '||l_input||'
                                QUOTA UNLIMITED ON '||l_input||'';
         
             EXECUTE IMMEDIATE 'GRANT CONNECT,RESOURCE TO '||l_input||'';
         END;
     
         BEGIN
             FOR i IN (SELECT * FROM dba_sys_privs)
             LOOP
                BEGIN
                    EXECUTE IMMEDIATE 'GRANT '||i.privilege||' TO '||l_input||' ';
                    Dbms_Output.Put_Line('GRANT '||i.privilege||' TO '||l_input||' ');
                EXCEPTION WHEN OTHERS THEN 
                    NULL;
                END;
             END LOOP;
         END;
     
         BEGIN
             FOR i IN (SELECT * FROM dba_sys_privs)
             LOOP
                BEGIN
                    EXECUTE IMMEDIATE 'GRANT '||i.privilege||' TO '||l_input||' ';
                EXCEPTION WHEN OTHERS THEN 
                    NULL;
                END;
             END LOOP;
         END;
     
         BEGIN
             EXECUTE IMMEDIATE 'CREATE TABLE '||l_input||'.tbl_upgrade
                                AS
                                SELECT 
                                     LEVEL           c1,
                                     SYSDATE         c2,
                                     LEVEL||''data'' c3
                                FROM dual
                                CONNECT BY LEVEL <=10000';
         EXCEPTION WHEN OTHERS THEN 
             Dbms_Output.Put_Line(SQLERRM);
         END;
     END;
     /

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 99 -->> On Both Nodes
-- Prerequisite checks and backups
/*
Check storage space for the new binary to be installed.
We must have around 20 GB of space available for each homes(Grid and RDBMS) on each node.
Also issue df -kh and make sure we space available in /tmp and /(root).
*/

-- Step 100 -->> On Both Nodes
-- Remove the audit files and any large log files on each node.
[root@RAC1/RAC2 ~]# cd /opt/app/11.2.0.3.0/grid/rdbms/audit
[root@RAC1/RAC2 audit]# rm *.aud
[root@RAC1/RAC2 ~]# cd /opt/app/oracle/product/11.2.0.3.0/db_1/rdbms/audit
[root@RAC1/RAC2 audit]# rm *.aud

-- Step 101 -->> On Node 1
-- Take full database backup using RMAN. (choose primary node)
[root@RAC1 ~]# mkdir -p /opt/upgrade/db_backup
[root@RAC1 ~]# cd /opt/
[root@RAC1 opt]# chown -R oracle:oinstall upgrade/
[root@RAC1 opt]# chmod -R 775 upgrade/
[root@RAC1 opt]# su - oracle
[oracle@RAC1 ~]$ rman target /
/*
RUN {
ALLOCATE CHANNEL c1 DEVICE TYPE disk;
ALLOCATE CHANNEL c2 DEVICE TYPE disk;
ALLOCATE CHANNEL c3 DEVICE TYPE disk;
ALLOCATE CHANNEL c4 DEVICE TYPE disk;
CONFIGURE DEVICE TYPE DISK PARALLELISM 4 BACKUP TYPE TO BACKUPSET;
BACKUP FULL FORMAT '/opt/upgrade/db_backup/%d_%U' 
DATABASE INCLUDE CURRENT CONTROLFILE PLUS ARCHIVELOG;
RELEASE CHANNEL c1;
RELEASE CHANNEL c2;
RELEASE CHANNEL c3;
RELEASE CHANNEL c4;
}
RMAN> exit;
*/

-- Step 102 -->> On Both Nodes
-- Backup of Grid and RDBMS binaries using tar.gz (As root do it when DB instance/CRS is down)
/*
--To restore the file 
1. Go to loaction that you have to backup with relavant User
2. unzip the file
Example:
su - grid
cd /opt/app/
tar zvxf /opt/upgrade/backup_oraInventory_112030.tar.gz
*/

[root@RAC1/RAC2 ~]# mkdir -p /opt/upgrade/grid_home_backup
[root@RAC1/RAC2 ~]# mkdir -p /opt/upgrade/ora_inventory_backup
[root@RAC1/RAC2 ~]# mkdir -p /opt/upgrade/oracle_home_backup
[root@RAC1/RAC2 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
[root@RAC1/RAC2 bin]# ./crsctl stop crs
[root@RAC1/RAC2 bin]# cd /opt/app
[root@RAC1/RAC2 app]# ls -ltr
/*
drwxr-xr-x  3 root   oinstall 4096 Jul 29 23:19 11.2.0.3.0
drwxrwx---  6 grid   oinstall 4096 Jul 30 01:28 oraInventory
drwxrwxr-x 10 oracle oinstall 4096 Jul 30 02:32 oracle
*/
-- Grid Home
[root@RAC1/RAC2 app]# tar -czvf /opt/upgrade/grid_home_backup/backup_grid_home_112030.tar.gz ./11.2.0.3.0

-- oraInventory
[root@RAC1/RAC2 app]$ tar -czvf /opt/upgrade/ora_inventory_backup/backup_oraInventory_112030.tar.gz ./oraInventory

-- Oracle Home
[root@RAC1/RAC2 ~]# cd /opt/app/oracle/product
[root@RAC1 product]$ tar -czvf /opt/upgrade/oracle_home_backup/backup_oracle_home_112030.tar.gz ./11.2.0.3.0

-- Step 103 -->> On Both Nodes
-- Backup of OCR on each nodes
[root@RAC1/RAC2 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
[root@RAC1/RAC2 bin]# ./crsctl start crs
[root@RAC1/RAC2 bin]# ./crsctl stat res -t -init
[root@RAC1/RAC2 bin]# ./crsctl stat res -t
[root@RAC1/RAC2 bin]# ./crsctl check cluster -all
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

-- Change the Backup Location of OCR on each nodes of OCR (you can change the backup location using ./ocrconfig -backuploc /opt/upgrade/)
[root@RAC1/RAC2 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
[root@RAC1/RAC2 bin]# ./ocrconfig -backuploc /opt/upgrade/
[root@RAC1/RAC2 bin]# ./ocrconfig -manualbackup 
[root@RAC1/RAC2 bin]# ./ocrconfig -backuploc /opt/app/11.2.0.3.0/grid/bin/
[root@RAC1/RAC2 bin]# ./ocrconfig -showbackup

-- Step 104 -->> On Node 1
-- Backup of ASM metadata.
[root@RAC1 ~]# mkdir -p /opt/upgrade/asm_backup
[root@RAC1 ~]# cd /opt/upgrade
[root@RAC1 ~]# chown grid:oinstall asm_backup/
[root@RAC1 ~]# chmod -R 775 asm_backup/
[root@RAC1 ~]# su - grid
[grid@RAC1 ~]$ asmcmd
ASMCMD> ls
/*
ASMCMD> ls
ARC/
DATA/
DATA2/
OCR/
*/
ASMCMD> md_backup /opt/upgrade/asm_backup/backup_asm.bcp -G data,data2,arc,ocr
/*
Disk group metadata to be backed up: DATA
Disk group metadata to be backed up: DATA2
Disk group metadata to be backed up: ARC
Disk group metadata to be backed up: OCR
Current alias directory path: RACDB/CONTROLFILE
Current alias directory path: RACDB/DATAFILE
Current alias directory path: RACDB/TEMPFILE
Current alias directory path: RACDB
Current alias directory path: RACDB/PARAMETERFILE
Current alias directory path: RACDB/ONLINELOG
Current alias directory path: RACDB/DATAFILE
Current alias directory path: RACDB
Current alias directory path: RACDB/ARCHIVELOG
Current alias directory path: RACDB
Current alias directory path: RACDB/ARCHIVELOG/2020_07_30
Current alias directory path: RAC-cluster
Current alias directory path: RAC-cluster/ASMPARAMETERFILE
Current alias directory path: RAC-cluster/OCRFILE
ASMCMD> exit
*/ 

-- Step 105 -->> On Both Nodes
-- Creating the Oracle & Grid Infrastructure Home Directory to installation of Software
[root@RAC1/RAC2 ~]# cd /opt/app/
[root@RAC1/RAC2 app]# mkdir -p 11.2.0.4.0/grid
[root@RAC1/RAC2 app]# chown -R grid:oinstall 11.2.0.4.0/
[root@RAC1/RAC2 app]# chmod -R 775 11.2.0.4.0/

[root@RAC1/RAC2 ~]# cd /opt/app/oracle/product/
[root@RAC1/RAC2 product]# mkdir -p 11.2.0.4.0/db_1
[root@RAC1/RAC2 product]# chown -R oracle:oinstall 11.2.0.4.0/
[root@RAC1/RAC2 product]# chmod -R 775 11.2.0.4.0/

-- Step 106 -->> On Node 1
-- The Oracle & Grid Directory to hold the Software & Unzip
[root@RAC1 ~]# cd /root/11.2.0.4.0/
[root@RAC1 11.2.0.4.0]# ls
/*
p13390677_112040_Linux-x86-64_1of7.zip  p13390677_112040_Linux-x86-64_3of7.zip
p13390677_112040_Linux-x86-64_2of7.zip  p6880880_112000_Linux-x86-64.zip
*/
[root@RAC1 11.2.0.4.0]# unzip p13390677_112040_Linux-x86-64_1of7.zip -d /opt/app/oracle/product/11.2.0.4.0/db_1/
[root@RAC1 11.2.0.4.0]# unzip p13390677_112040_Linux-x86-64_2of7.zip -d /opt/app/oracle/product/11.2.0.4.0/db_1/
[root@RAC1 11.2.0.4.0]# unzip p13390677_112040_Linux-x86-64_3of7.zip -d /opt/app/11.2.0.4.0/
[root@RAC1 11.2.0.4.0]# cd /opt/app/oracle/product/
[root@RAC1 product]# chown -R oracle:oinstall 11.2.0.4.0/
[root@RAC1 product]# chmod -R 775 11.2.0.4.0/
[root@RAC1 11.2.0.4.0]# cd /opt/app/
[root@RAC1 app]# chown -R grid:oinstall 11.2.0.4.0/
[root@RAC1 app]# chmod -R 775 11.2.0.4.0/

-- Step 107 -->> On Node 1
-- If necessary, adjust existing ASM instance memory parameter:
--Log in as sysasm:
[grid@RAC1 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 11.2.0.3.0 Production on Wed Aug 19 15:02:44 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Real Application Clusters and Automatic Storage Management options

SQL> show parameter memory_target

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
memory_target                        big integer 272M

--If the value is smaller than 1536 m, then issue the following command
SQL> alter system set memory_target=1536m scope=spfile sid='*';

SQL> show parameter memory_max_target

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
memory_max_target                    big integer 272M

-- If the value is smaller than 4096, then issue the following command:
SQL> alter system set memory_max_target=4096 scope=spfile sid='*';

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Real Application Clusters and Automatic Storage Management options
*/

-- Step 108 -->> On Both Nodes
-- The number for memory_target & memory_max_target has proven to be sufficient in most environment, 
-- the change will not be effective until next restart.
[root@RAC1/RAC2 ~]# cd /opt/app/11.2.0.3.0/grid/bin/
[root@RAC1/RAC2 bin]# ./crsctl stop crs
[root@RAC1/RAC2 bin]# ./crsctl start crs
[root@RAC1/RAC2 bin]# ./crsctl stat res -t -init
[root@RAC1/RAC2 bin]# ./crsctl stat res -t
[root@RAC1/RAC2 bin]# ./crsctl check cluster -all

-- Step 109 -->> On Both Nodes
[root@RAC1/RAC2 bin]# su - grid
[grid@RAC1/RAC2 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 11.2.0.3.0 Production on Tue Jul 28 05:16:15 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Real Application Clusters and Automatic Storage Management options

SQL> show parameter memory_max_target

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
memory_max_target                    big integer 1536M
SQL> show parameter memory_target

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
memory_target                        big integer 1536M

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Real Application Clusters and Automatic Storage Management option
*/

-- Step 110 -->> On Both Nodes
[root@RAC1/RAC2 ~]# su - grid
[grid@RAC1/RAC2 ~]$ cd /opt/app/11.2.0.3.0/grid/bin/
[grid@RAC1/RAC2 bin]# ./crsctl query crs activeversion
/*
Oracle Clusterware active version on the cluster is [11.2.0.3.0]
*/

-- Step 111 -->> On Both Nodes
[grid@RAC1/RAC2 bin]# ./crsctl query crs softwareversion
/*
Oracle Clusterware version on node [RAC1/RAC2] is [11.2.0.3.0]
*/

-- Step 112 -->> On Both Nodes
[grid@RAC1/RAC2 bin]# ./crsctl query css votedisk
/*
##  STATE    File Universal Id                File Name Disk group
--  -----    -----------------                --------- ---------
 1. ONLINE   af4025ada7ed4fd1bfd3cc67330a1468 (ORCL:OCR) [OCR]
Located 1 voting disk(s).
*/

-- Step 113 -->> On Both Nodes
[grid@RAC1/RAC2 bin]# ./ocrcheck
/*
Status of Oracle Cluster Registry is as follows :
         Version                  :          3
         Total space (kbytes)     :     262120
         Used space (kbytes)      :       2908
         Available space (kbytes) :     259212
         ID                       : 1440999537
         Device/File Name         :       +OCR
                                    Device/File integrity check succeeded

                                    Device/File not configured

                                    Device/File not configured

                                    Device/File not configured

                                    Device/File not configured

         Cluster registry integrity check succeeded

         Logical corruption check bypassed due to non-privileged user
*/

-- Step 114 -->> On Node 1
[grid@RAC1 bin]# ./crsctl stat res -p |tee /opt/upgrade/crs_stats.out

-- Step 115 -->> On Both Nodes
[root@RAC1/RAC2 ~]# su - oracle
[oracle@RAC1/RAC2 ~]# which srvctl
/*
u01/app/oracle/product/11.2.0.3.0/db_1/bin/srvctl
*/

-- Step 116 -->> On Both Nodes
[oracle@RAC1/RAC2 ~]# srvctl status database -d racdb
/*
Instance racdb1 is running on node rac1
Instance racdb2 is running on node rac2
*/

-- Step 117 -->> On Both Nodes
[oracle@RAC1/RAC2 ~]# srvctl config database -d racdb
/*
Database unique name: racdb
Database name: racdb
Oracle home: /opt/app/oracle/product/11.2.0.3.0/db_1
Oracle user: oracle
Spfile: +DATA/racdb/spfileracdb.ora
Domain: 
Start options: open
Stop options: immediate
Database role: PRIMARY
Management policy: AUTOMATIC
Server pools: racdb
Database instances: racdb1,racdb2
Disk Groups: DATA
Mount point paths: 
Services: 
Type: RAC
Database is administrator managed
*/

-- Step 118 -->> On Node 1
[oracle@RAC1 ~]$ srvctl stop database -d racdb
[oracle@RAC1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is not running on node rac1
Instance racdb2 is not running on node rac2
*/

-- Step 119 -->> On Node 1
-- To Check the clusters status
[grid@RAC1 ~]$ cd /opt/app/11.2.0.4.0/grid/
[grid@RAC1 grid]$ ./runcluvfy.sh stage -pre crsinst -upgrade -n rac1,rac2 -rolling -src_crshome /opt/app/11.2.0.3.0/grid -dest_crshome /opt/app/11.2.0.4.0/grid -dest_version 11.2.0.4.0 -fixup -fixupdir /tmp -verbose |tee /opt/upgrade/grid_runcluvfyOutput.out

-- Step 120 -->> On Node 1
-- Verifiye/Fix the clusters status failed
[grid@RAC1 ~]$ cd /opt/upgrade/
[grid@RAC1 upgrade]$ less runcluvfyOutput.out
--Or-- 
[grid@RAC1 upgrade]$ find -type f | grep runcluvfyOutput.out | xargs grep fail {}
/*
grep: {}: No such file or directory
./runcluvfyOutput.out:Result: Clock synchronization check using Network Time Protocol(NTP) failed
*/

-- Step 121 -->> On Node 1
-- Verifiye/Apply Patches - if any
[grid@RAC1 upgrade]$ find -type f | grep runcluvfyOutput.out | xargs grep patches {}
/*
grep: {}: No such file or directory
./runcluvfyOutput.out:There are no oracle patches required for home "/opt/app/11.2.0.3.0/grid/".
./runcluvfyOutput.out:There are no oracle patches required for home "/opt/app/11.2.0.4.0/grid/".
*/

-- Step 122 -->> On Node 1
-- To Make the Node Lists
[grid@RAC1 ~]$ cd /opt/app/11.2.0.3.0/grid/oui/bin
[grid@RAC1 bin]$ ./runInstaller -updateNodeList ORACLE_HOME="/opt/app/11.2.0.3.0/grid" CRS=true
/*
Starting Oracle Universal Installer...

Checking swap space: must be greater than 500 MB.   Actual 10231 MB    Passed
The inventory pointer is located at /etc/oraInst.loc
The inventory is located at /opt/app/oraInventory
'UpdateNodeList' was successful.
*/

-- Step 123 -->> On Node 1
-- Prepare the responce file
[grid@RAC1 ~]$ cp -r /opt/app/11.2.0.4.0/grid/response/grid_install.rsp /home/grid/ 
[grid@RAC1 ~]$ vi /home/grid/grid_install.rsp
/*
oracle.install.responseFileVersion=/oracle/install/rspfmt_crsinstall_response_schema_v11_2_0
ORACLE_HOSTNAME=RAC1.mydomain
INVENTORY_LOCATION=/opt/app/oraInventory
SELECTED_LANGUAGES=en
oracle.install.option=UPGRADE
ORACLE_BASE=/opt/app/oracle
ORACLE_HOME=/opt/app/11.2.0.4.0/grid
oracle.install.asm.OSDBA=asmdba
oracle.install.asm.OSOPER=asmoper
oracle.install.asm.OSASM=asmadmin
oracle.install.crs.config.gpnp.configureGNS=false
oracle.install.crs.config.clusterNodes=rac1:rac1-vip,rac2:rac2-vip
oracle.install.crs.config.sharedFileSystemStorage.votingDiskRedundancy=NORMAL
oracle.install.crs.config.sharedFileSystemStorage.ocrRedundancy=NORMAL
oracle.install.crs.config.useIPMI=false
oracle.install.asm.SYSASMPassword=sys
oracle.install.asm.diskGroup.redundancy=NORMAL
oracle.install.asm.diskGroup.AUSize=1
oracle.install.crs.upgrade.clusterNodes=rac1,rac2
oracle.install.asm.upgradeASM=false
oracle.installer.autoupdates.option=SKIP_UPDATES
*/
[grid@RAC1 ~]$ cd /home/grid/
[grid@RAC1 ~]$ chmod -R 755 grid_install.rsp

-- Step 124 -->> On Node 1
-- To Upgrade the grid software in silent mode
[grid@RAC1 grid]$cd /opt/app/11.2.0.4.0/grid
[grid@RAC1 grid]$ ./runInstaller -silent -ignoreSysPrereqs -ignorePrereq  -responseFile  /home/grid/grid_install.rsp  ORACLE_HOME="/opt/app/11.2.0.4.0/grid" oracle.install.option="UPGRADE"
/*
Starting Oracle Universal Installer...

Checking Temp space: must be greater than 120 MB.   Actual 9064 MB    Passed
Checking swap space: must be greater than 150 MB.   Actual 10231 MB    Passed
Preparing to launch Oracle Universal Installer from /tmp/OraInstall2020-08-02_06-50-09PM. Please wait ...[grid@RAC1 grid]$ 

The installation of Oracle Grid Infrastructure 11g was successful.
Please check '/opt/app/oraInventory/logs/silentInstall2020-08-10_03-32-19AM.log' for more details.

As a root user, execute the following script(s):
        1. /opt/app/11.2.0.4.0/grid/rootupgrade.sh

Execute /opt/app/11.2.0.4.0/grid/rootupgrade.sh on the following nodes: 
[RAC1, rac2]

As install user, execute the following script to complete the configuration.
        1. /opt/app/11.2.0.4.0/grid/cfgtoollogs/configToolAllCommands RESPONSE_FILE=<response_file>

        Note:
        1. This script must be run on the same host from where installer was run. 
        2. This script needs a small password properties file for configuration assistants that require passwords (refer to install guide documentation).


Successfully Setup Software.
*/

-- Step 125 -->> On Node 1
[root@RAC1 ~]# /opt/app/11.2.0.4.0/grid/rootupgrade.sh
/*
[root@RAC1 ~]# tail -f /opt/app/11.2.0.4.0/grid/install/root_RAC1.mydomain_2020-08-02_18-54-41.log 
Finished running generic part of root script.
Now product-specific root actions will be performed.
Using configuration parameter file: /opt/app/11.2.0.4.0/grid/crs/install/crsconfig_params
Creating trace directory
User ignored Prerequisites during installation
Installing Trace File Analyzer

ASM upgrade has started on first node.

CRS-2791: Starting shutdown of Oracle High Availability Services-managed resources on 'rac1'
CRS-2673: Attempting to stop 'ora.crsd' on 'rac1'
CRS-2790: Starting shutdown of Cluster Ready Services-managed resources on 'rac1'
CRS-2673: Attempting to stop 'ora.ARC.dg' on 'rac1'
CRS-2673: Attempting to stop 'ora.OCR.dg' on 'rac1'
CRS-2673: Attempting to stop 'ora.DATA.dg' on 'rac1'
CRS-2673: Attempting to stop 'ora.oc4j' on 'rac1'
CRS-2673: Attempting to stop 'ora.LISTENER.lsnr' on 'rac1'
CRS-2673: Attempting to stop 'ora.LISTENER_SCAN2.lsnr' on 'rac1'
CRS-2673: Attempting to stop 'ora.cvu' on 'rac1'
CRS-2677: Stop of 'ora.LISTENER.lsnr' on 'rac1' succeeded
CRS-2673: Attempting to stop 'ora.rac1.vip' on 'rac1'
CRS-2677: Stop of 'ora.LISTENER_SCAN2.lsnr' on 'rac1' succeeded
CRS-2673: Attempting to stop 'ora.scan2.vip' on 'rac1'
CRS-2677: Stop of 'ora.rac1.vip' on 'rac1' succeeded
CRS-2672: Attempting to start 'ora.rac1.vip' on 'rac2'
CRS-2677: Stop of 'ora.scan2.vip' on 'rac1' succeeded
CRS-2672: Attempting to start 'ora.scan2.vip' on 'rac2'
CRS-2677: Stop of 'ora.ARC.dg' on 'rac1' succeeded
CRS-2676: Start of 'ora.rac1.vip' on 'rac2' succeeded
CRS-2676: Start of 'ora.scan2.vip' on 'rac2' succeeded
CRS-2672: Attempting to start 'ora.LISTENER_SCAN2.lsnr' on 'rac2'
CRS-2677: Stop of 'ora.DATA.dg' on 'rac1' succeeded
CRS-2676: Start of 'ora.LISTENER_SCAN2.lsnr' on 'rac2' succeeded
CRS-2677: Stop of 'ora.oc4j' on 'rac1' succeeded
CRS-2672: Attempting to start 'ora.oc4j' on 'rac2'
CRS-2677: Stop of 'ora.cvu' on 'rac1' succeeded
CRS-2672: Attempting to start 'ora.cvu' on 'rac2'
CRS-2676: Start of 'ora.cvu' on 'rac2' succeeded
CRS-2676: Start of 'ora.oc4j' on 'rac2' succeeded
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
CRS-2677: Stop of 'ora.evmd' on 'rac1' succeeded
CRS-2677: Stop of 'ora.crf' on 'rac1' succeeded
CRS-2677: Stop of 'ora.mdnsd' on 'rac1' succeeded
CRS-2677: Stop of 'ora.ctssd' on 'rac1' succeeded
CRS-2677: Stop of 'ora.asm' on 'rac1' succeeded
CRS-2673: Attempting to stop 'ora.cluster_interconnect.haip' on 'rac1'
CRS-2677: Stop of 'ora.cluster_interconnect.haip' on 'rac1' succeeded
CRS-2673: Attempting to stop 'ora.cssd' on 'rac1'
CRS-2677: Stop of 'ora.cssd' on 'rac1' succeeded
CRS-2673: Attempting to stop 'ora.gipcd' on 'rac1'
CRS-2677: Stop of 'ora.gipcd' on 'rac1' succeeded
CRS-2673: Attempting to stop 'ora.gpnpd' on 'rac1'
CRS-2677: Stop of 'ora.gpnpd' on 'rac1' succeeded
CRS-2793: Shutdown of Oracle High Availability Services-managed resources on 'rac1' has completed
CRS-4133: Oracle High Availability Services has been stopped.
OLR initialization - successful
Replacing Clusterware entries in upstart
clscfg: EXISTING configuration version 5 detected.
clscfg: version 5 is 11g Release 2.
Successfully accumulated necessary OCR keys.
Creating OCR keys for user 'root', privgrp 'root'..
Operation successful.
Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 126 -->> On Node 2
[root@RAC2 ~]# /opt/app/11.2.0.4.0/grid/rootupgrade.sh
/*
[root@RAC2 ~]# tail -f  /opt/app/11.2.0.4.0/grid/install/root_RAC2.mydomain_2020-08-02_19-04-41.log
   Copying coraenv to /usr/local/bin ...

Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Using configuration parameter file: /opt/app/11.2.0.4.0/grid/crs/install/crsconfig_params
Creating trace directory
User ignored Prerequisites during installation
Installing Trace File Analyzer
CRS-2791: Starting shutdown of Oracle High Availability Services-managed resources on 'rac2'
CRS-2673: Attempting to stop 'ora.crsd' on 'rac2'
CRS-2790: Starting shutdown of Cluster Ready Services-managed resources on 'rac2'
CRS-2673: Attempting to stop 'ora.ARC.dg' on 'rac2'
CRS-2673: Attempting to stop 'ora.OCR.dg' on 'rac2'
CRS-2673: Attempting to stop 'ora.DATA.dg' on 'rac2'
CRS-2673: Attempting to stop 'ora.LISTENER.lsnr' on 'rac2'
CRS-2673: Attempting to stop 'ora.LISTENER_SCAN2.lsnr' on 'rac2'
CRS-2673: Attempting to stop 'ora.cvu' on 'rac2'
CRS-2677: Stop of 'ora.cvu' on 'rac2' succeeded
CRS-2672: Attempting to start 'ora.cvu' on 'rac1'
CRS-2677: Stop of 'ora.LISTENER.lsnr' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.rac2.vip' on 'rac2'
CRS-2677: Stop of 'ora.LISTENER_SCAN2.lsnr' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.scan2.vip' on 'rac2'
CRS-2677: Stop of 'ora.rac2.vip' on 'rac2' succeeded
CRS-2672: Attempting to start 'ora.rac2.vip' on 'rac1'
CRS-2677: Stop of 'ora.scan2.vip' on 'rac2' succeeded
CRS-2672: Attempting to start 'ora.scan2.vip' on 'rac1'
CRS-2676: Start of 'ora.cvu' on 'rac1' succeeded
CRS-2677: Stop of 'ora.ARC.dg' on 'rac2' succeeded
CRS-2677: Stop of 'ora.DATA.dg' on 'rac2' succeeded
CRS-2676: Start of 'ora.rac2.vip' on 'rac1' succeeded
CRS-2676: Start of 'ora.scan2.vip' on 'rac1' succeeded
CRS-2672: Attempting to start 'ora.LISTENER_SCAN2.lsnr' on 'rac1'
CRS-2676: Start of 'ora.LISTENER_SCAN2.lsnr' on 'rac1' succeeded
CRS-2677: Stop of 'ora.OCR.dg' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.asm' on 'rac2'
CRS-2677: Stop of 'ora.asm' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.ons' on 'rac2'
CRS-2677: Stop of 'ora.ons' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.net1.network' on 'rac2'
CRS-2677: Stop of 'ora.net1.network' on 'rac2' succeeded
CRS-2792: Shutdown of Cluster Ready Services-managed resources on 'rac2' has completed
CRS-2677: Stop of 'ora.crsd' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.ctssd' on 'rac2'
CRS-2673: Attempting to stop 'ora.evmd' on 'rac2'
CRS-2673: Attempting to stop 'ora.asm' on 'rac2'
CRS-2673: Attempting to stop 'ora.mdnsd' on 'rac2'
CRS-2677: Stop of 'ora.evmd' on 'rac2' succeeded
CRS-2677: Stop of 'ora.ctssd' on 'rac2' succeeded
CRS-2677: Stop of 'ora.mdnsd' on 'rac2' succeeded
CRS-2677: Stop of 'ora.asm' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.cluster_interconnect.haip' on 'rac2'
CRS-2677: Stop of 'ora.cluster_interconnect.haip' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.cssd' on 'rac2'
CRS-2677: Stop of 'ora.cssd' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.crf' on 'rac2'
CRS-2677: Stop of 'ora.crf' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.gipcd' on 'rac2'
CRS-2677: Stop of 'ora.gipcd' on 'rac2' succeeded
CRS-2673: Attempting to stop 'ora.gpnpd' on 'rac2'
CRS-2677: Stop of 'ora.gpnpd' on 'rac2' succeeded
CRS-2793: Shutdown of Oracle High Availability Services-managed resources on 'rac2' has completed
CRS-4133: Oracle High Availability Services has been stopped.
OLR initialization - successful
Replacing Clusterware entries in upstart
clscfg: EXISTING configuration version 5 detected.
clscfg: version 5 is 11g Release 2.
Successfully accumulated necessary OCR keys.
Creating OCR keys for user 'root', privgrp 'root'..
Operation successful.
Started to upgrade the Oracle Clusterware. This operation may take a few minutes.
Started to upgrade the CSS.
Started to upgrade the CRS.
The CRS was successfully upgraded.
Successfully upgraded the Oracle Clusterware.
Oracle Clusterware operating version was successfully set to 11.2.0.4.0

ASM upgrade has finished on last node.

Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 127 -->> On Node 1
-- Prepare one responce file more to set asm password 
[grid@RAC1 ~]$ vi /tmp/conf.rsp
/*
oracle.assistants.asm=sys
*/

-- Step 128 -->> On Node 1
[grid@RAC1 grid]$ cd /opt/app/11.2.0.4.0/grid
[grid@RAC1 grid]$ /opt/app/11.2.0.4.0/grid/cfgtoollogs/configToolAllCommands RESPONSE_FILE=/tmp/conf.rsp
/*
Setting the invPtrLoc to /opt/app/11.2.0.4.0/grid/oraInst.loc

perform - mode is starting for action: configure

perform - mode finished for action: configure

You can see the log file: /opt/app/11.2.0.4.0/grid/cfgtoollogs/oui/configActions2020-08-02_07-17-27-PM.log
*/

-- Step 129 -->> On Node 1
-- Hit the Enter key to exist from terminal to Successfully Setup Software
/*
[grid@RAC1 grid]$ ./runInstaller -silent -ignoreSysPrereqs -ignorePrereq  -responseFile  /home/grid/grid_install.rsp  ORACLE_HOME="/opt/app/11.2.0.4.0/grid" oracle.install.option="UPGRADE"
Starting Oracle Universal Installer...

Checking Temp space: must be greater than 120 MB.   Actual 9064 MB    Passed
Checking swap space: must be greater than 150 MB.   Actual 10231 MB    Passed
Preparing to launch Oracle Universal Installer from /tmp/OraInstall2020-08-02_06-50-09PM. Please wait ...[grid@RAC1 grid]$ 

The installation of Oracle Grid Infrastructure 11g was successful.
Please check '/opt/app/oraInventory/logs/silentInstall2020-08-10_03-32-19AM.log' for more details.

As a root user, execute the following script(s):
        1. /opt/app/11.2.0.4.0/grid/rootupgrade.sh

Execute /opt/app/11.2.0.4.0/grid/rootupgrade.sh on the following nodes: 
[RAC1, rac2]

As install user, execute the following script to complete the configuration.
        1. /opt/app/11.2.0.4.0/grid/cfgtoollogs/configToolAllCommands RESPONSE_FILE=<response_file>

        Note:
        1. This script must be run on the same host from where installer was run. 
        2. This script needs a small password properties file for configuration assistants that require passwords (refer to install guide documentation).


Successfully Setup Software.
*/

-- Step 130 -->> On Both Nodes
[root@RAC1/RAC2 bin]# cd /opt/app/11.2.0.4.0/grid/bin/
[root@RAC1/RAC2 bin]# ./crsctl query crs activeversion
/*
Oracle Clusterware active version on the cluster is [11.2.0.4.0]
*/

-- Step 131 -->> On Both Nodes
[root@RAC1/RAC2 bin]# ./crsctl query crs softwareversion
/*
Oracle Clusterware version on node [RAC1/RAC2] is [11.2.0.4.0]
*/

-- Step 132 -->> On Both Nodes
[root@RAC1/RAC2 bin]# ./crsctl query css votedisk
/*
##  STATE    File Universal Id                File Name Disk group
--  -----    -----------------                --------- ---------
 1. ONLINE   af4025ada7ed4fd1bfd3cc67330a1468 (ORCL:OCR) [OCR]
Located 1 voting disk(s).

*/

-- Step 133 -->> On Both Nodes
[root@RAC1/RAC2 bin]# ./ocrcheck
/*
[root@RAC1 bin]# cd /opt/app/11.2.0.4.0/grid/bin/
[root@RAC1 bin]# ./ocrcheck
Status of Oracle Cluster Registry is as follows :
         Version                  :          3
         Total space (kbytes)     :     262120
         Used space (kbytes)      :       3140
         Available space (kbytes) :     258980
         ID                       : 1440999537
         Device/File Name         :       +OCR
                                    Device/File integrity check succeeded

                                    Device/File not configured

                                    Device/File not configured

                                    Device/File not configured

                                    Device/File not configured

         Cluster registry integrity check succeeded

         Logical corruption check succeeded
*/

-- Step 134 -->> On Node 1
[root@RAC1 ~]# vi /etc/oratab 
/*
+ASM1:/opt/app/11.2.0.4.0/grid:N                    # line added by Agent
racdb1:/opt/app/oracle/product/11.2.0.3.0/db_1:N    # line added by Agent
racdb:/opt/app/oracle/product/11.2.0.3.0/db_1:N     # line added by Agent
*/

-- Step 135 -->> On Node 2
[root@RAC2 ~]# vi /etc/oratab 
/*
+ASM2:/opt/app/11.2.0.4.0/grid:N                    # line added by Agent
racdb1:/opt/app/oracle/product/11.2.0.3.0/db_1:N    # line added by Agent
racdb:/opt/app/oracle/product/11.2.0.3.0/db_1:N     # line added by Agent
*/

-- Step 136 -->> On Node 1
[grid@RAC1 ~]$ vi .bash_profile
/* 
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

#PATH=$PATH:$HOME/bin
#export PATH

# Grid Settings
TMP=/tmp; export TMP
TMPDIR=$TMP; export TMPDIR

ORACLE_SID=+ASM1; export ORACLE_SID
ORACLE_BASE=/opt/app/oracle; export ORACLE_BASE
GRID_HOME=/opt/app/11.2.0.4.0/grid; export GRID_HOME
ORACLE_HOME=$GRID_HOME; export ORACLE_HOME

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 137 -->> On Node 1
[grid@RAC1 ~]$ . .bash_profile

-- Step 138 -->> On Node 2
[grid@RAC2 ~]$ vi .bash_profile 
/*
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

#PATH=$PATH:$HOME/bin
#export PATH

# Grid Settings
TMP=/tmp; export TMP
TMPDIR=$TMP; export TMPDIR

ORACLE_SID=+ASM2; export ORACLE_SID
ORACLE_BASE=/opt/app/oracle; export ORACLE_BASE
GRID_HOME=/opt/app/11.2.0.4.0/grid; export GRID_HOME
ORACLE_HOME=$GRID_HOME; export ORACLE_HOME

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 139 -->> On Node 2
[grid@RAC2 ~]$ . .bash_profile 

-- Step 140 -->> On Both Nodes
[grid@RAC1/RAC2 ~]$ sqlplus sys/sys as sysasm
/*
SQL*Plus: Release 11.2.0.4.0 Production on Mon Aug 3 11:05:50 2020

Copyright (c) 1982, 2013, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
With the Real Application Clusters and Automatic Storage Management options

SQL> set linesize 200
SQL> select * from gv$version;

   INST_ID BANNER
---------- --------------------------------------------------------------------------------
         1 Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
         1 PL/SQL Release 11.2.0.4.0 - Production
         1 CORE 11.2.0.4.0      Production
         1 TNS for Linux: Version 11.2.0.4.0 - Production
         1 NLSRTL Version 11.2.0.4.0 - Production
         2 Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
         2 PL/SQL Release 11.2.0.4.0 - Production
         2 CORE 11.2.0.4.0      Production
         2 TNS for Linux: Version 11.2.0.4.0 - Production
         2 NLSRTL Version 11.2.0.4.0 - Production

10 rows selected.

SQL> exit
*/

-- Step 141 -->> On Node 1
-- To Update OPatch - Grid
[root@RAC1 ~]# cd /opt/app/11.2.0.4.0/grid/
[root@RAC1 grid]# ls -ltr | grep OPatch
/*
drwxr-xr-x  8 grid oinstall  4096 Aug  2 18:49 OPatch
*/
[root@RAC1 grid]# mv OPatch OPatch_bk

-- Step 142 -->> On Node 1
[root@RAC1 grid]# cd /root/11.2.0.4.0/
[root@RAC1 11.2.0.4.0]# unzip p6880880_112000_Linux-x86-64.zip -d /opt/app/11.2.0.4.0/grid/
[root@RAC1 11.2.0.4.0]# cd /opt/app/11.2.0.4.0/grid/
[root@RAC1 grid]# ls -ltr | grep OPatch
/*
drwxr-x--- 15 root root      4096 Apr 22 16:34 OPatch
drwxr-xr-x  8 grid oinstall  4096 Aug  2 18:49 OPatch_bk
*/
[root@RAC1 grid]# chown -R grid:oinstall OPatch
[root@RAC1 grid]# chmod -R 755 OPatch
[root@RAC1 grid]# ls -ltr | grep OPatch
/*
drwxr-xr-x 15 grid oinstall  4096 Apr 22 16:34 OPatch
drwxr-xr-x  8 grid oinstall  4096 Aug  2 18:49 OPatch_bk
*/

-- Step 143 -->> On Node 1
[root@RAC1 grid]# cd OPatch
[root@RAC1 OPatch]# ./opatch version
/*
OPatch Version: 11.2.0.3.25

OPatch succeeded.
*/

-- Step 144 -->> On Node 2
[root@RAC2 ~]# cd /opt/app/11.2.0.4.0/grid/
[root@RAC2 grid]# ls -ltr | grep OPatch
/*
drwxr-xr-x  8 grid oinstall  4096 Aug  2 18:52 OPatch
*/
[root@RAC2 grid]# mv OPatch OPatch_bk
[root@RAC2 grid]# ls -ltr | grep OPatch
/*
drwxr-xr-x  8 grid oinstall  4096 Aug  2 18:52 OPatch_bk
*/

-- Step 145 -->> On Node 1
[root@RAC1 ~]# cd /opt/app/11.2.0.4.0/grid
[root@RAC1 grid]# scp -r OPatch root@RAC2:/opt/app/11.2.0.4.0/grid/

-- Step 146 -->> On Node 2
[root@RAC2 ~]# cd /opt/app/11.2.0.4.0/grid
[root@RAC2 grid]# ls -ltr | grep OPatch
/*
drwxr-xr-x  8 grid oinstall  4096 Aug  2 18:52 OPatch_bk
drwxr-xr-x 15 root root      4096 Aug  3 11:35 OPatch
*/
[root@RAC2 grid]# chown -R grid:oinstall OPatch
[root@RAC2 grid]# chmod -R 755 OPatch
[root@RAC2 grid]# ls -ltr | grep OPatch
/*
drwxr-xr-x  8 grid oinstall  4096 Aug  2 18:52 OPatch_bk
drwxr-xr-x 15 grid oinstall  4096 Aug  3 11:35 OPatch
*/

-- Step 147 -->> On Node 2
[root@RAC2 grid]# cd OPatch
[root@RAC2 OPatch]# ./opatch version
/*
OPatch Version: 11.2.0.3.25

OPatch succeeded.
*/

-- Step 148 -->> On Both Nodes
[root@RAC1/RAC2 app]# cd /opt/app/11.2.0.4.0/grid/bin/
[root@RAC1/RAC2 bin]# ./crsctl check cluster -all
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

-- Step 149 -->> On Both Nodes
[oracle@RAC1/RAC2 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is not running on node rac1
Instance racdb2 is not running on node rac2
*/

-- Step 150 -->> On Node 1
[oracle@RAC1 ~]$ srvctl start database -d racdb

-- Step 151 -->> On Both Nodes
[oracle@RAC1/RAC2 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node rac1
Instance racdb2 is running on node rac2
*/

-- Step 152 -->> On Both Nodes
[oracle@RAC1/RAC2 ~]$ sqlplus sys/sys as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Aug 3 11:50:06 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> set linesize 200
SQL> select * from gv$version;

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

10 rows selected.

SQL> exit
*/

-- Step 153 -->> On Node 1
[grid@RAC1 ~]$ cd /opt/app/11.2.0.3.0/grid/deinstall
[grid@RAC1 ~]$ ./deinstall

-- Step 154 -->> On Both Nodes
[root@RAC1/RAC2 ~]# cd /opt/app/11.2.0.4.0/grid/bin/
[root@RAC1/RAC2 bin]# ./crsctl stop crs

-- Step 155 -->> On Both Nodes
[root@RAC1/RAC2 ~]# cd /opt/app/
[root@RAC1/RAC2 app]# rm -rf 11.2.0.3.0/

-- Step 156 -->> On Both Nodes
[root@RAC1/RAC2 ~]# cd /opt/app/11.2.0.4.0/grid/bin/
[root@RAC1/RAC2 bin]# ./crsctl start crs
[root@RAC1/RAC2 bin]# ./crsctl stat res -t -init
[root@RAC1/RAC2 bin]# ./crsctl stat res -t
[root@RAC1/RAC2 bin]# ./crsctl check cluster -all
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

-- Step 157 -->> On Both Nodes
[grid@RAC1/RAC2 ~]$ cd /opt/app/11.2.0.4.0/grid/bin/
[grid@RAC1/RAC2 bin]$ srvctl status diskgroup -g OCR -a
/*
Disk Group OCR is running on rac2,rac1
Disk Group OCR is enabled
*/

-- Step 158 -->> On Both Nodes
[grid@RAC1/RAC2 bin]$ srvctl status diskgroup -g DATA -a
/*
Disk Group DATA is running on rac2,rac1
Disk Group DATA is enabled
*/

-- Step 159 -->> On Both Nodes
[grid@RAC1/RAC2 bin]$ srvctl status diskgroup -g ARC -a
/*
Disk Group ARC is running on rac2,rac1
Disk Group ARC is enabled
*/

-- Step 160 -->> On Node 1
-- Prepare response file Install Oracle Software
[oracle@RAC1 ~]$ cd /opt/app/oracle/product/11.2.0.4.0/db_1/database/response/
[oracle@RAC1 response]$ cp -r db_install.rsp /home/oracle/
[oracle@RAC1 response]$ cd /home/oracle/
[oracle@RAC1 oracle]$  vi db_install.rsp
/*
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v11_2_0
oracle.install.option=INSTALL_DB_SWONLY
ORACLE_HOSTNAME=RAC1.mydomain
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/opt/app/oraInventory
SELECTED_LANGUAGES=en
ORACLE_HOME=/opt/app/oracle/product/11.2.0.4.0/db_1
ORACLE_BASE=/opt/app/oracle
oracle.install.db.InstallEdition=EE
oracle.install.db.EEOptionsSelection=false
oracle.install.db.optionalComponents=oracle.rdbms.partitioning:11.2.0.4.0,oracle.oraolap:11.2.0.4.0,oracle.rdbms.dm:11.2.0.4.0,oracle.rdbms.dv:11.2.0.4.0,oracle.rdbms.lbac:11.2.0.4.0,oracle.rdbms.rat:11.2.0.4.0
oracle.install.db.DBA_GROUP=dba
oracle.install.db.OPER_GROUP=oper
oracle.install.db.CLUSTER_NODES=rac1,rac2
oracle.install.db.config.starterdb.characterSet=AL32UTF8
oracle.install.db.config.starterdb.memoryOption=true
oracle.install.db.config.starterdb.installExampleSchemas=false
oracle.install.db.config.starterdb.enableSecuritySettings=true
oracle.install.db.config.starterdb.control=DB_CONTROL
oracle.install.db.config.starterdb.automatedBackup.enable=false
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false
DECLINE_SECURITY_UPDATES=true
oracle.installer.autoupdates.option=SKIP_UPDATES
*/

-- Step 161 -->> On Node 1
[oracle@RAC1 oracle]$ chown -R oracle:oinstall db_install.rsp
[oracle@RAC1 oracle]$ chmod -R 755 db_install.rsp

-- Step 162 -->> On Node 1
-- To Install the Oracle Software in Siletn Mode
[oracle@RAC1 ~]$ cd /opt/app/oracle/product/11.2.0.4.0/db_1/database/
[oracle@RAC1 database]$ ./runInstaller -silent -responseFile /home/oracle/db_install.rsp -ignoreSysPrereqs
/*
Starting Oracle Universal Installer...

Checking Temp space: must be greater than 120 MB.   Actual 9209 MB    Passed
Checking swap space: must be greater than 150 MB.   Actual 10222 MB    Passed
Preparing to launch Oracle Universal Installer from /tmp/OraInstall2020-08-16_11-20-13PM. Please wait ...[oracle@RAC1 database]$ [WARNING] [INS-32016] The selected Oracle home contains directories or files.
You can find the log of this install session at:
 /opt/app/oraInventory/logs/installActions2020-08-16_11-25-47PM.log

The installation of Oracle Database 11g was successful.
Please check '/opt/app/oraInventory/logs/silentInstall2020-08-16_11-25-47PM.log' for more details.

As a root user, execute the following script(s):
        1. /opt/app/oracle/product/11.2.0.4.0/db_1/root.sh

Execute /opt/app/oracle/product/11.2.0.4.0/db_1/root.sh on the following nodes: 
[rac1, rac2]

Successfully Setup Software.
*/

-- Step 163 -->> On Both Nodes
[root@RAC1 ~]# /opt/app/oracle/product/11.2.0.4.0/db_1/root.sh

-- Step 164 -->> On Node 1
-- Hit the Enter key to exist from terminal to Successfully Setup Software
/*
[oracle@RAC1 database]$ ./runInstaller -silent -responseFile /home/oracle/db_install.rsp -ignoreSysPrereqs
Starting Oracle Universal Installer...

Checking Temp space: must be greater than 120 MB.   Actual 9209 MB    Passed
Checking swap space: must be greater than 150 MB.   Actual 10222 MB    Passed
Preparing to launch Oracle Universal Installer from /tmp/OraInstall2020-08-16_11-20-13PM. Please wait ...[oracle@RAC1 database]$ [WARNING] [INS-32016] The selected Oracle home contains directories or files.
You can find the log of this install session at:
 /opt/app/oraInventory/logs/installActions2020-08-16_11-25-47PM.log

The installation of Oracle Database 11g was successful.
Please check '/opt/app/oraInventory/logs/silentInstall2020-08-16_11-25-47PM.log' for more details.

As a root user, execute the following script(s):
        1. /opt/app/oracle/product/11.2.0.4.0/db_1/root.sh

Execute /opt/app/oracle/product/11.2.0.4.0/db_1/root.sh on the following nodes: 
[rac1, rac2]

Successfully Setup Software.
*/

-- Step 165 -->> On Node 1
-- pre-requisets Before upgarde of oracle database
[oracle@RAC1 ~]$ sqlplus sys/sys as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Aug 3 11:50:06 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SELECT * FROM gv$backup WHERE status != 'NOT ACTIVE';

no rows selected

SQL> SELECT * FROM v$rman_backup_job_details WHERE status <> 'COMPLETED';

no rows selected

SQL> SELECT * FROM dba_2pc_pending;

no rows selected

SQL> SELECT SUBSTR(value,INSTR(value,'=',INSTR(UPPER(value),'SERVICE'))+1) FROM v$parameter WHERE name LIKE 'log_archive_dest%' AND UPPER(value) LIKE 'SERVICE%';

no rows selected

SQL> select name,open_mode,version from v$database,v$instance;

NAME      OPEN_MODE            VERSION
--------- -------------------- -----------------
RACDB      READ WRITE          11.2.0.3.0
*/

-- Step 166 -->> On Node 1
[oracle@RAC1 ~]$ emctl stop dbconsole
[oracle@RAC1 ~]$ emctl stop agent
[oracle@RAC1 ~]$ sqlplus sys/sys as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Aug 3 11:50:06 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

-- Remove the EM repository
SQL> @/opt/app/oracle/product/11.2.0.3.0/rdbms/admin/emremove.sql

-- Remove OLAP Catalog
SQL> @/opt/app/oracle/product/11.2.0.3.0/db_1/olap/admin/catnoamd.sql

-- Update INITIALIZATION PARAMETERS
SQL> show parameter PROCESSES

NAME                          TYPE     VALUE
----------------------------- ------- ----------- ------------------------------
aq_tm_processes               integer     1
db_writer_processes           integer     1
gcs_server_processes          integer     2
global_txn_processes          integer     1
job_queue_processes           integer     1000
log_archive_max_processes     integer     4
processes                     integer     150

SQL> ALTER SYSTEM SET PROCESSES=300 SCOPE=SPFILE SID ='*';

System altered.

-- Before upgrade run the preupgrade tool to check the pre-requisites before proceeding upgrade which is available in new home.
-- Fix as per output result
SQL> @/opt/app/oracle/product/11.2.0.4.0/db_1/rdbms/admin/utlu112i.sql

-- Purge Recyclebin
SQL> PURGE DBA_RECYCLEBIN;

DBA Recyclebin purged.
SQL> TRUNCATE TABLE SYS.AUD$;
SQL> exit

-- Gather DICTIONARY STATS
SQL> EXECUTE DBMS_STATS.GATHER_DICTIONARY_STATS;

PL/SQL procedure successfully completed.

-- Refresh MVs
SQL> DECLARE
         list_failures integer(3) :=0;
     BEGIN
         DBMS_MVIEW.REFRESH_ALL_MVIEWS(list_failures,'C','', TRUE, FALSE);
     END;
     /

PL/SQL procedure successfully completed.

-- Run fixups 
SQL> EXECUTE DBMS_STATS.GATHER_FIXED_OBJECTS_STATS

-- For object invalidation in sys schema before upgrade the run below one.
SQL> @/opt/app/oracle/product/11.2.0.4.0/db_1/rdbms/admin/utluiobj.sql

SQL> select substr(comp_name,1,40) comp_name, status, substr(version,1,10) version from dba_registry order by comp_name;

COMP_NAME                                STATUS      VERSION
---------------------------------------- ----------- ----------
JServer JAVA Virtual Machine             VALID       11.2.0.3.0
OLAP Analytic Workspace                  VALID       11.2.0.3.0
OWB                                      VALID       11.2.0.3.0
Oracle Application Express               VALID       3.2.1.00.1
Oracle Database Catalog Views            VALID       11.2.0.3.0
Oracle Database Java Packages            VALID       11.2.0.3.0
Oracle Database Packages and Types       VALID       11.2.0.3.0
Oracle Enterprise Manager                VALID       11.2.0.3.0
Oracle Expression Filter                 VALID       11.2.0.3.0
Oracle Multimedia                        VALID       11.2.0.3.0
Oracle OLAP API                          VALID       11.2.0.3.0
Oracle Real Application Clusters         VALID       11.2.0.3.0
Oracle Rules Manager                     VALID       11.2.0.3.0
Oracle Text                              VALID       11.2.0.3.0
Oracle Workspace Manager                 VALID       11.2.0.3.0
Oracle XDK                               VALID       11.2.0.3.0
Oracle XML Database                      VALID       11.2.0.3.0
Spatial                                  VALID       11.2.0.3.0


SQL> SELECT (translate(value,chr(13)||chr(10),' ')) FROM sys.v$parameter2 WHERE  UPPER(name) ='EVENT' AND  isdefault='FALSE';

no rows selected

SQL> SELECT (translate(value,chr(13)||chr(10),' ')) from sys.v$parameter2 WHERE UPPER(name) = '_TRACE_EVENTS' AND isdefault='FALSE';

no rows selected

SQL> select substr(object_name,1,40) object_name,substr(owner,1,15) owner,object_type from dba_objects where status='INVALID' order by owner,object_type;

no rows selected

SQL> select owner,object_type,count(*) from dba_objects where status='INVALID' group by owner,object_type order by owner,object_type ;

no rows selected

-- Create Flashback Guaranteed Restore Point
SQL> select flashback_on from v$database;

FLASHBACK_ON
------------
NO

SQL> select * from V$restore_point;

no rows selected 

SQL> show parameter compatible

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
compatible                           string      11.2.0.0.0

SQL> alter system set db_recovery_file_dest_size=10G sid ='*';

SQL> show parameter recovery

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_recovery_file_dest                string      +DATA
db_recovery_file_dest_size           big integer 10G
recovery_parallelism                 integer     0

SQL> create restore point pre_upgrade guarantee flashback database;

Restore point created.

SQL> col name for a20
SQL> col GUARANTEE_FLASHBACK_DATABASE for a10
SQL>  SELECT name,guarantee_flashback_database,time FROM V$restore_point;

NAME                 GUARANTEE_ TIME
-------------------- ---------- ---------------------------------------------------------------------------
PRE_UPGRADE          YES        17-AUG-20 01.20.07.000000000 AM

*/

-- Step 167 -->> On Both Nodes
[oracle@RAC1/RAC2 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): rac2,rac1
*/

-- Step 168 -->> On Both Nodes
[oracle@RAC1/RAC2 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node rac1
Instance racdb2 is running on node rac2
*/

-- Step 169 -->> On Node 1
[oracle@RAC1 ~]$ srvctl stop database -d racdb

-- Step 170 -->> On Both Nodes
[oracle@RAC1/RAC2 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is not running on node rac1
Instance racdb2 is not running on node rac2
*/

-- Step 171 -->> On Node 1
-- Copy init and password files from source to destination dbs home
[oracle@RAC1 ~]$ cd /opt/app/oracle/product/11.2.0.3.0/db_1/dbs/
[oracle@RAC1 dbs]$ ls -ltr
/*
-rw-r--r-- 1 oracle oinstall     2851 May 15  2009 init.ora
-rw-r----- 1 oracle oinstall     1536 Aug  2 16:26 orapwracdb1
-rw-r----- 1 oracle oinstall       37 Aug  2 16:27 initracdb1.ora
-rw-r----- 1 oracle oinstall 18497536 Aug  6 10:27 snapcf_racdb1.f
-rw-rw---- 1 oracle asmadmin     1544 Aug  6 15:57 hc_racdb1.dat
*/
[oracle@RAC1 dbs]$ cp -r orapwracdb1 initracdb1.ora /opt/app/oracle/product/11.2.0.4.0/db_1/dbs/
[oracle@RAC1 dbs]$ ls -ltr /opt/app/oracle/product/11.2.0.4.0/db_1/dbs/
/*
-rw-r--r-- 1 oracle oinstall 2851 May 15  2009 init.ora
-rw-r----- 1 oracle oinstall 1536 Aug 17 02:50 orapwracdb1
-rw-r----- 1 oracle oinstall   37 Aug 17 02:50 initracdb1.ora
*/

-- Step 172 -->> On Node 2
[oracle@RAC2 ~]$ cd /opt/app/oracle/product/11.2.0.3.0/db_1/dbs/
[oracle@RAC2 dbs]$ ls -ltr
/*
-rw-r--r-- 1 oracle oinstall 2851 Aug  2 16:15 init.ora
-rw-r----- 1 oracle oinstall 1536 Aug  2 16:26 orapwracdb2
-rw-r----- 1 oracle oinstall   37 Aug  2 16:27 initracdb2.ora
-rw-rw---- 1 oracle asmadmin 1544 Aug  6 15:56 hc_racdb2.dat
*/
[oracle@RAC2 dbs]$ cp -r orapwracdb2 initracdb2.ora /opt/app/oracle/product/11.2.0.4.0/db_1/dbs/
[oracle@RAC2 dbs]$ ls -ltr /opt/app/oracle/product/11.2.0.4.0/db_1/dbs/
/*
-rw-r--r-- 1 oracle oinstall 2851 Aug 16 23:33 init.ora
-rw-r----- 1 oracle oinstall 1536 Aug 17 02:53 orapwracdb2
-rw-r----- 1 oracle oinstall   37 Aug 17 02:53 initracdb2.ora
*/

-- Step 173 -->> On Both Nodes
[oracle@RAC1/RAC2 ~]$ cp -r /opt/app/oracle/product/11.2.0.3.0/db_1/network/admin/tnsnames.ora /opt/app/oracle/product/11.2.0.4.0/db_1/network/admin/

-- Step 174 -->> On Node 1
[oracle@RAC1 ~]$ vi /etc/oratab 
/*
+ASM1:/opt/app/11.2.0.4.0/grid:N                # line added by Agent
racdb1:/opt/app/oracle/product/11.2.0.4.0/db_1:N         # line added by Agent
racdb:/opt/app/oracle/product/11.2.0.4.0/db_1:N         # line added by Agent
*/

-- Step 175 -->> On Node 2
[oracle@RAC2 ~]$ vi /etc/oratab 
/*
+ASM2:/opt/app/11.2.0.4.0/grid:N                # line added by Agent
racdb2:/opt/app/oracle/product/11.2.0.4.0/db_1:N         # line added by Agent
racdb:/opt/app/oracle/product/11.2.0.4.0/db_1:N         # line added by Agent
*/

-- Step 176 -->> On Node 1
-- Set the environment variables pointing to the newly oracle Home
[oracle@RAC1 ~]$ export ORACLE_SID=racdb1
[oracle@RAC1 ~]$ export ORACLE_HOME=/opt/app/oracle/product/11.2.0.4.0/db_1
[oracle@RAC1 ~]$ export PATH=$ORACLE_HOME/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/oracle/bin
[oracle@RAC1 ~]$ which sqlplus
/*
/opt/app/oracle/product/11.2.0.4.0/db_1/bin/sqlplus
*/

-- Step 177 -->> On Node 1
[oracle@RAC1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.4.0 Production on Thu Aug 6 16:16:10 2020

Copyright (c) 1982, 2013, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> startup mount
ORACLE instance started.

Total System Global Area 3140026368 bytes
Fixed Size                  2257352 bytes
Variable Size             822087224 bytes
Database Buffers         2298478592 bytes
Redo Buffers               17203200 bytes
Database mounted.
SQL> show parameter cluster_database

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
cluster_database                     boolean     TRUE
cluster_database_instances           integer     2

SQL> alter system set cluster_database=false scope=spfile sid='*';

System altered.

SQL> shut immediate
ORA-01109: database not open


Database dismounted.
ORACLE instance shut down.

SQL> startup upgrade
ORACLE instance started.

Total System Global Area 3140026368 bytes
Fixed Size                  2257352 bytes
Variable Size             822087224 bytes
Database Buffers         2298478592 bytes
Redo Buffers               17203200 bytes
Database mounted.
Database opened.

SQL> select instance_name,version,status from v$instance;

INSTANCE_NAME    VERSION           STATUS
---------------- ----------------- ------------
racdb1           11.2.0.4.0        OPEN MIGRATE

SQL> @?/rdbms/admin/catupgrd
-- OR --
SQL> @/opt/app/oracle/product/11.2.0.4.0/db_1/rdbms/admin/catupgrd.sql

.
Oracle Database 11.2 Post-Upgrade Status Tool           08-17-2020 04:34:31
.
Component                               Current      Version     Elapsed Time
Name                                    Status       Number      HH:MM:SS
.
Oracle Server
.                                         VALID      11.2.0.4.0  00:08:16
JServer JAVA Virtual Machine
.                                         VALID      11.2.0.4.0  00:02:56
Oracle Real Application Clusters
.                                         VALID      11.2.0.4.0  00:00:00
Oracle Workspace Manager
.                                         VALID      11.2.0.4.0  00:00:28
OLAP Analytic Workspace
.                                         VALID      11.2.0.4.0  00:01:00
Oracle OLAP API
.                                         VALID      11.2.0.4.0  00:00:16
Oracle Enterprise Manager
.                                         VALID      11.2.0.4.0  00:05:40
Oracle XDK
.                                         VALID      11.2.0.4.0  00:00:22
Oracle Text
.                                         VALID      11.2.0.4.0  00:00:25
Oracle XML Database
.                                         VALID      11.2.0.4.0  00:01:40
Oracle Database Java Packages
.                                         VALID      11.2.0.4.0  00:00:08
Oracle Multimedia
.                                         VALID      11.2.0.4.0  00:01:21
Spatial
.                                         VALID      11.2.0.4.0  00:03:20
Oracle Expression Filter
.                                         VALID      11.2.0.4.0  00:00:06
Oracle Rules Manager
.                                         VALID      11.2.0.4.0  00:00:06
Oracle Application Express
.                                         VALID     3.2.1.00.12
Final Actions
.                                                                00:00:00
Total Upgrade Time: 00:26:11

PL/SQL procedure successfully completed.

SQL> 
SQL> SET SERVEROUTPUT OFF
SQL> SET VERIFY ON
SQL> commit;

Commit complete.

SQL> 
SQL> shutdown immediate;
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL> 
SQL> 
SQL> DOC
DOC>#######################################################################
DOC>#######################################################################
DOC>
DOC>   The above sql script is the final step of the upgrade. Please
DOC>   review any errors in the spool log file. If there are any errors in
DOC>   the spool file, consult the Oracle Database Upgrade Guide for
DOC>   troubleshooting recommendations.
DOC>
DOC>   Next restart for normal operation, and then run utlrp.sql to
DOC>   recompile any invalid application objects.
DOC>
DOC>   If the source database had an older time zone version prior to
DOC>   upgrade, then please run the DBMS_DST package.  DBMS_DST will upgrade
DOC>   TIMESTAMP WITH TIME ZONE data to use the latest time zone file shipped
DOC>   with Oracle.
DOC>
DOC>#######################################################################
DOC>#######################################################################
DOC>#
SQL> 
SQL> Rem Set errorlogging off
SQL> SET ERRORLOGGING OFF;
SQL> 
SQL> REM END OF CATUPGRD.SQL
SQL> 
SQL> REM bug 12337546 - Exit current sqlplus session at end of catupgrd.sql.
SQL> REM                This forces user to start a new sqlplus session in order
SQL> REM                to connect to the upgraded db.
SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 178 -->> On Node 1
-- Again Set the environment variables pointing to the newly oracle Home - If exist from terminal
[oracle@RAC1 ~]$ export ORACLE_SID=racdb1
[oracle@RAC1 ~]$ export ORACLE_HOME=/opt/app/oracle/product/11.2.0.4.0/db_1
[oracle@RAC1 ~]$ export PATH=$ORACLE_HOME/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/oracle/bin
[oracle@RAC1 ~]$ which sqlplus
/*
/opt/app/oracle/product/11.2.0.4.0/db_1/bin/sqlplus
*/

-- Step 179 -->> On Node 1
[oracle@RAC1 ~]$ cd /opt/app/oracle/product/11.2.0.4.0/db_1/rdbms/admin/
[oracle@RAC1 admin]$ ls -ltr | grep utlu112s
/*
-rw-r--r-- 1 oracle oinstall     486 Mar 18  2008 utlu112s.sql
*/

-- Step 180 -->> On Node 1
[oracle@RAC1 admin]$ sqlplus sys/sys as sysdba
/*
SQL*Plus: Release 11.2.0.4.0 Production on Mon Aug 17 04:59:56 2020

Copyright (c) 1982, 2013, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> startup
ORACLE instance started.

Total System Global Area 3140026368 bytes
Fixed Size                  2257352 bytes
Variable Size             889196088 bytes
Database Buffers         2231369728 bytes
Redo Buffers               17203200 bytes
Database mounted.
Database opened.

SQL> @?/rdbms/admin/utlu112s
-- OR --
SQL> @/opt/app/oracle/product/11.2.0.4.0/db_1/rdbms/admin/utlu112s.sql

.
Oracle Database 11.2 Post-Upgrade Status Tool           08-17-2020 05:01:11
.
Component                               Current      Version     Elapsed Time
Name                                    Status       Number      HH:MM:SS
.
Oracle Server
.                                         VALID      11.2.0.4.0  00:08:16
JServer JAVA Virtual Machine
.                                         VALID      11.2.0.4.0  00:02:56
Oracle Real Application Clusters
.                                         VALID      11.2.0.4.0  00:00:00
Oracle Workspace Manager
.                                         VALID      11.2.0.4.0  00:00:28
OLAP Analytic Workspace
.                                         VALID      11.2.0.4.0  00:01:00
Oracle OLAP API
.                                         VALID      11.2.0.4.0  00:00:16
Oracle Enterprise Manager
.                                         VALID      11.2.0.4.0  00:05:40
Oracle XDK
.                                         VALID      11.2.0.4.0  00:00:22
Oracle Text
.                                         VALID      11.2.0.4.0  00:00:25
Oracle XML Database
.                                         VALID      11.2.0.4.0  00:01:40
Oracle Database Java Packages
.                                         VALID      11.2.0.4.0  00:00:08
Oracle Multimedia
.                                         VALID      11.2.0.4.0  00:01:21
Spatial
.                                         VALID      11.2.0.4.0  00:03:20
Oracle Expression Filter
.                                         VALID      11.2.0.4.0  00:00:06
Oracle Rules Manager
.                                         VALID      11.2.0.4.0  00:00:06
Oracle Application Express
.                                         VALID     3.2.1.00.12
Final Actions
.                                                                00:00:00
Total Upgrade Time: 00:26:11

PL/SQL procedure successfully completed.

SQL> select instance_name,version,status from v$instance;

INSTANCE_NAME    VERSION           STATUS
---------------- ----------------- ------------
racdb1           11.2.0.4.0        OPEN

-- For migrating the baseline from pre 11g database
SQL> @/opt/app/oracle/product/11.2.0.4.0/db_1/rdbms/admin/catuppst.sql

-- Recompile objects
SQL> @/opt/app/oracle/product/11.2.0.4.0/db_1/rdbms/admin/utlrp.sql

SQL> EXECUTE DBMS_STATS.GATHER_FIXED_OBJECTS_STATS;
SQL> select count(*) from dba_objects where status = 'INVALID';
 
  COUNT(*)
----------
         0
 
SQL> select count(*) from dba_objects where status='INVALID';
 
  COUNT(*)
----------
         0     

SQL> col ACTION_TIME for a50
SQL> col ACTION for a20
SQL> col NAMESPACE for a20
SQL> col VERSION for a20
SQL> col COMMENTS for a50
SQL> set linesize 400
SQL> select * from registry$history;

ACTION_TIME                                        ACTION               NAMESPACE            VERSION                      ID COMMENTS                                           BUNDLE_SERIES
-------------------------------------------------- -------------------- -------------------- -------------------- ---------- -------------------------------------------------- ------------------------------
17-SEP-11 10.21.11.595816 AM                       APPLY                SERVER               11.2.0.3                      0 Patchset 11.2.0.2.0                                PSU
10-AUG-20 01.06.19.092274 AM                       APPLY                SERVER               11.2.0.3                      0 Patchset 11.2.0.2.0                                PSU
17-AUG-20 04.34.30.856778 AM                       VIEW INVALIDATE                                                   8289601 view invalidation
17-AUG-20 04.34.30.986853 AM                       UPGRADE              SERVER               11.2.0.4.0                      Upgraded from 11.2.0.3.0
17-AUG-20 05.05.48.249187 AM                       APPLY                SERVER               11.2.0.4                      0 Patchset 11.2.0.2.0                                PSU

SQL> select * from gv$version;

   INST_ID BANNER
---------- --------------------------------------------------------------------------------
         1 Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
         1 PL/SQL Release 11.2.0.4.0 - Production
         1 CORE 11.2.0.4.0      Production
         1 TNS for Linux: Version 11.2.0.4.0 - Production
         1 NLSRTL Version 11.2.0.4.0 - Production
*/

-- Step 181 -->> On Node 1
-- Go to Old DB Home
[oracle@RAC1 ~]$ exit
/*
logout
*/
[root@PDB-RAC1 ~]# su - oracle
-- OR -- 
-- Set the environment variables pointing to the old oracle Home
[oracle@RAC1 ~]$ export ORACLE_SID=racdb1
[oracle@RAC1 ~]$ export ORACLE_HOME=/opt/app/oracle/product/11.2.0.4.0/db_1
[oracle@RAC1 ~]$ export PATH=$ORACLE_HOME/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/oracle/bin
[oracle@RAC1 ~]$ which sqlplus
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/bin/sqlplus
*/
[oracle@RAC1 ~]$ which srvctl
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/bin/srvctl
*/

-- Step 182 -->> On Node 1
[oracle@RAC1 bin]$ srvctl status database -d racdb
/*
Instance racdb1 is not running on node rac1
Instance racdb2 is not running on node rac2
*/

-- Step 183 -->> On Node 1
[oracle@RAC1 ~]$ srvctl status listener -l listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): rac2,rac1
*/

-- Step 184 -->> On Node 1
[oracle@RAC1 bin]$ srvctl stop listener
[oracle@RAC1 bin]$ srvctl status listener -l listener
/*
Listener LISTENER is enabled
Listener LISTENER is not running
*/

-- Step 185 -->> On Node 1
[oracle@RAC1 ~]$ srvctl config database -d racdb
/*
Database unique name: racdb
Database name: racdb
Oracle home: /opt/app/oracle/product/11.2.0.3.0/db_1
Oracle user: oracle
Spfile: +DATA/racdb/spfileracdb.ora
Domain: 
Start options: open
Stop options: immediate
Database role: PRIMARY
Management policy: AUTOMATIC
Server pools: racdb
Database instances: racdb1,racdb2
Disk Groups: DATA
Mount point paths: 
Services: 
Type: RAC
Database is administrator managed
*/

-- Step 186 -->> On Node 1
[oracle@RAC1 ~]$ which sqlplus
/*
/opt/app/oracle/product/11.2.0.3.0/db_1/bin/sqlplus
*/

-- Step 187 -->> On Node 1
-- To Cluster make TRUE and Drop the Restore Point
[oracle@RAC1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon Aug 17 06:16:30 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> startup mount;
ORACLE instance started.

Total System Global Area 3140026368 bytes
Fixed Size                  2232472 bytes
Variable Size             771755880 bytes
Database Buffers         2348810240 bytes
Redo Buffers               17227776 bytes
Database mounted.

SQL> select instance_name,version,status from v$instance;

INSTANCE_NAME    VERSION           STATUS
---------------- ----------------- ------------
racdb1           11.2.0.3.0        MOUNTED

SQL> show parameter cluster_database

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
cluster_database                     boolean     FALSE
cluster_database_instances           integer     1

SQL> alter system set cluster_database=true scope=spfile sid='*';

System altered.

SQL> select flashback_on from v$database;

FLASHBACK_ON
------------------
RESTORE POINT ONLY

SQL> drop restore point pre_upgrade;

Restore point dropped.

SQL> shut immediate
ORA-01109: database not open


Database dismounted.
ORACLE instance shut down.
SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
*/

-- Step 188 -->> On Node 1
[oracle@RAC1 ~]$ vi .bash_profile 
/*
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

#PATH=$PATH:$HOME/bin
#export PATH

# Oracle Settings
TMP=/tmp; export TMP
TMPDIR=$TMP; export TMPDIR

ORACLE_HOSTNAME=RAC1.mydomain; export ORACLE_HOSTNAME
ORACLE_UNQNAME=racdb; export ORACLE_UNQNAME
ORACLE_BASE=/opt/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/11.2.0.4.0/db_1; export ORACLE_HOME
ORACLE_SID=racdb1; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 189 -->> On Node 1
[oracle@RAC1 ~]$ . .bash_profile 

-- Step 190 -->> On Node 2
[oracle@RAC2 ~]$ vi .bash_profile 
/*
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

#PATH=$PATH:$HOME/bin
#export PATH

# Oracle Settings
TMP=/tmp; export TMP
TMPDIR=$TMP; export TMPDIR

ORACLE_HOSTNAME=RAC2.mydomain; export ORACLE_HOSTNAME
ORACLE_UNQNAME=racdb; export ORACLE_UNQNAME
ORACLE_BASE=/opt/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/11.2.0.4.0/db_1; export ORACLE_HOME
ORACLE_SID=racdb2; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 191 -->> On Node 2
[oracle@RAC2 ~]$ . .bash_profile 

-- Step 192 -->> On Node 1
[oracle@RAC1 ~]$ srvctl remove database -d racdb
/*
Remove the database racdb? (y/[n]) y
*/

-- Step 193 -->> On Node 1
[oracle@RAC1 ~]$ cd /opt/app/oracle/product/11.2.0.4.0/db_1/bin/
[oracle@RAC1 bin]$ srvctl add database -d racdb -o /opt/app/oracle/product/11.2.0.4.0/db_1
[oracle@RAC1 bin]$ srvctl add instance -i racdb1 -d racdb -n rac1
[oracle@RAC1 bin]$ srvctl add instance -i racdb2 -d racdb -n rac2

-- Step 194 -->> On Node 1
[oracle@RAC1 ~]$ which srvctl
/*
/opt/app/oracle/product/11.2.0.4.0/db_1/bin/srvctl
*/

-- Step 195 -->> On Node 1
[oracle@RAC1 ~]$ srvctl start listener
[oracle@RAC1 ~]$ srvctl status listener -l listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): rac2,rac1
*/

-- Step 196 -->> On Node 1
[oracle@RAC1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.4.0 - Production on 17-AUG-2020 06:09:43

Copyright (c) 1991, 2013, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.4.0 - Production
Start Date                17-AUG-2020 06:09:28
Uptime                    0 days 0 hr. 0 min. 19 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.4.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/RAC1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.75)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.77)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 197 -->> On Node 2
[oracle@RAC1 ~]$ srvctl status listener -l listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): rac2,rac1
*/

-- Step 198 -->> On Node 2
[oracle@RAC2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.4.0 - Production on 17-AUG-2020 23:21:56

Copyright (c) 1991, 2013, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.4.0 - Production
Start Date                17-AUG-2020 06:09:28
Uptime                    0 days 17 hr. 12 min. 28 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.4.0/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/RAC2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.76)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.78)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "racdb" has 1 instance(s).
  Instance "racdb2", status READY, has 1 handler(s) for this service...
Service "racdbXDB" has 1 instance(s).
  Instance "racdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 199 -->> On Node 2
[oracle@RAC1 ~]$ srvctl config database -d racdb
/*
Database unique name: racdb
Database name: 
Oracle home: /opt/app/oracle/product/11.2.0.4.0/db_1
Oracle user: oracle
Spfile: 
Domain: 
Start options: open
Stop options: immediate
Database role: PRIMARY
Management policy: AUTOMATIC
Server pools: racdb
Database instances: racdb1,racdb2
Disk Groups: 
Mount point paths: 
Services: 
Type: RAC
Database is administrator managed
*/

-- Step 200 -->> On Node 1
[oracle@RAC1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is not running on node rac1
Instance racdb2 is not running on node rac2
*/

-- Step 201 -->> On Node 1
[oracle@RAC1 ~]$ srvctl stop database -d racdb
[oracle@RAC1 ~]$ srvctl start database -d racdb

-- Step 202 -->> On Both Nodes
[oracle@RAC1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node rac1
Instance racdb2 is running on node rac2
*/

-- Step 203 -->> On Node 1
[oracle@RAC1 ~]$ cd /opt/app/oracle/product/11.2.0.4.0/db_1/
[oracle@RAC1 db_1]$ mv OPatch OPatch_bk
[oracle@RAC1 db_1]$ ls -ltr | grep OPatch
/*
drwxr-xr-x  8 oracle oinstall  4096 Aug 16 23:28 OPatch_bk
*/

-- Step 204 -->> On Node 1
[root@RAC1 ~]# cd /root/11.2.0.4.0/
[root@RAC1 11.2.0.4.0]# unzip p6880880_112000_Linux-x86-64.zip -d /opt/app/oracle/product/11.2.0.4.0/db_1/
[root@RAC1 11.2.0.4.0]# cd /opt/app/oracle/product/11.2.0.4.0/db_1/
[root@RAC1 db_1]# chown -R oracle:oinstall OPatch
[root@RAC1 db_1]# chmod -R 755 OPatch
[root@RAC1 db_1]# ls -ltr | grep OPatch
/*
drwxr-xr-x 15 oracle oinstall  4096 Apr 22 16:34 OPatch
drwxr-xr-x  8 oracle oinstall  4096 Aug 16 23:28 OPatch_bk
*/

-- Step 205 -->> On Node 1
[oracle@RAC1 ~]$ cd /opt/app/oracle/product/11.2.0.4.0/db_1/OPatch/
[oracle@RAC1 OPatch]$ ./opatch version
/*
OPatch Version: 11.2.0.3.25

OPatch succeeded.
*/

-- Step 206 -->> On Node 2
[root@RAC2 ~]# cd /opt/app/oracle/product/11.2.0.4.0/db_1/
[root@RAC2 db_1]# mv OPatch OPatch_bk
[root@RAC2 db_1]# ls -ltr | grep OPatch
/*
drwxr-xr-x  8 oracle oinstall  4096 Aug 16 23:33 OPatch_bk
*/

-- Step 207 -->> On Node 1
[oracle@RAC1 ~]$ cd /opt/app/oracle/product/11.2.0.4.0/db_1/
[oracle@RAC1 db_1]$ scp -r OPatch oracle@RAC2:/opt/app/oracle/product/11.2.0.4.0/db_1/

-- Step 208 -->> On Node 2
[root@RAC2 ~]# cd /opt/app/oracle/product/11.2.0.4.0/db_1/
[root@RAC2 db_1]# chmod -R 755 OPatch
[root@RAC2 db_1]# ls -ltr | grep OPatch
/*
drwxr-xr-x  8 oracle oinstall  4096 Aug 16 23:33 OPatch_bk
drwxr-xr-x 15 oracle oinstall  4096 Aug 17 23:36 OPatch
*/

-- Step 209 -->> On Node 2
[oracle@RAC2 ~]$ cd /opt/app/oracle/product/11.2.0.4.0/db_1/OPatch/
[oracle@RAC2 OPatch]$ ./opatch version
/*
OPatch Version: 11.2.0.3.25

OPatch succeeded.
*/

-- Step 210 -->> On Node 1
[oracle@RAC1 db_1]$ cd /opt/app/oracle/product/11.2.0.3.0/db_1/deinstall/
[oracle@RAC1 deinstall]$ ./deinstall
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
Checking for existence of the Oracle Grid Infrastructure home /opt/app/11.2.0.4.0/grid
The following nodes are part of this cluster: rac1,rac2
Checking for sufficient temp space availability on node(s) : 'rac1,rac2'

## [END] Install check configuration ##


Network Configuration check config START

Network de-configuration trace file location: /opt/app/oraInventory/logs/netdc_check2020-08-17_11-56-40-PM.log

Network Configuration check config END

Database Check Configuration START

Database de-configuration trace file location: /opt/app/oraInventory/logs/databasedc_check2020-08-17_11-56-42-PM.log

Use comma as separator when specifying list of values as input

Specify the list of database names that are configured in this Oracle home []: racdb

###### For Database 'racdb' ######

Specify the type of this database (1.Single Instance Database|2.Oracle Restart Enabled Database|3.RAC Database|4.RAC One Node Database) [2]: 3
Specify the list of nodes on which this database has instances []: racdb1,racdb2
Specify the list of instance names [racdb]: racdb1,racdb2
Specify the local instance name on node   []: rac1,rac2
Specify the diagnostic destination location of the database [/opt/app/oracle/diag/rdbms/racdb]: 
Specify the storage type used by the Database ASM|FS []: ASM


Database Check Configuration END

Enterprise Manager Configuration Assistant START

EMCA de-configuration trace file location: /opt/app/oraInventory/logs/emcadc_check2020-08-17_11-58-20-PM.log 

Checking configuration for database racdb
Enterprise Manager Configuration Assistant END
Oracle Configuration Manager check START
OCM check log file location : /opt/app/oraInventory/logs//ocm_check64.log
Oracle Configuration Manager check END

######################### CHECK OPERATION END #########################


####################### CHECK OPERATION SUMMARY #######################
Oracle Grid Infrastructure Home is: /opt/app/11.2.0.4.0/grid
The cluster node(s) on which the Oracle home deinstallation will be performed are:rac1,rac2
Oracle Home selected for deinstall is: /opt/app/oracle/product/11.2.0.3.0/db_1
Inventory Location where the Oracle home registered is: /opt/app/oraInventory
The following databases were selected for de-configuration : racdb
Database unique name : racdb
Storage used : ASM
No Enterprise Manager configuration to be updated for any database(s)
No Enterprise Manager ASM targets to update
No Enterprise Manager listener targets to migrate
Checking the config status for CCR
rac1 : Oracle Home exists with CCR directory, but CCR is not configured
rac2 : Oracle Home exists with CCR directory, but CCR is not configured
CCR check is finished
Do you want to continue (y - yes, n - no)? [n]: y
A log of this session will be written to: '/opt/app/oraInventory/logs/deinstall_deconfig2020-08-17_11-56-34-PM.out'
Any error messages from this session will be written to: '/opt/app/oraInventory/logs/deinstall_deconfig2020-08-17_11-56-34-PM.err'

######################## CLEAN OPERATION START ########################

Enterprise Manager Configuration Assistant START

EMCA de-configuration trace file location: /opt/app/oraInventory/logs/emcadc_clean2020-08-17_11-58-20-PM.log 

Updating Enterprise Manager ASM targets (if any)
Updating Enterprise Manager listener targets (if any)
Enterprise Manager Configuration Assistant END
Database de-configuration trace file location: /opt/app/oraInventory/logs/databasedc_clean2020-08-17_11-58-25-PM.log
Database Clean Configuration START racdb
This operation may take few minutes.
Database Clean Configuration END racdb

Network Configuration clean config START

Network de-configuration trace file location: /opt/app/oraInventory/logs/netdc_clean2020-08-17_11-58-44-PM.log

De-configuring Listener configuration file on all nodes...
Listener configuration file de-configured successfully.

De-configuring Naming Methods configuration file on all nodes...
Naming Methods configuration file de-configured successfully.

De-configuring Local Net Service Names configuration file on all nodes...
Local Net Service Names configuration file de-configured successfully.

De-configuring Directory Usage configuration file on all nodes...
Directory Usage configuration file de-configured successfully.

De-configuring backup files on all nodes...
Backup files de-configured successfully.

The network configuration has been cleaned up successfully.

Network Configuration clean config END

Oracle Configuration Manager clean START
OCM clean log file location : /opt/app/oraInventory/logs//ocm_clean64.log
Oracle Configuration Manager clean END
Setting the force flag to false
Setting the force flag to cleanup the Oracle Base
Oracle Universal Installer clean START

Detach Oracle home '/opt/app/oracle/product/11.2.0.3.0/db_1' from the central inventory on the local node : Done

Delete directory '/opt/app/oracle/product/11.2.0.3.0/db_1' on the local node : Done

The Oracle Base directory '/opt/app/oracle' will not be removed on local node. The directory is in use by Oracle Home '/opt/app/11.2.0.4.0/grid'.

Detach Oracle home '/opt/app/oracle/product/11.2.0.3.0/db_1' from the central inventory on the remote nodes 'rac2' : Done

Delete directory '/opt/app/oracle/product/11.2.0.3.0/db_1' on the remote nodes 'rac2' : Done

The Oracle Base directory '/opt/app/oracle' will not be removed on node 'rac2'. The directory is in use by Oracle Home '/opt/app/11.2.0.4.0/grid'.

Oracle Universal Installer cleanup was successful.

Oracle Universal Installer clean END


## [START] Oracle install clean ##

Clean install operation removing temporary directory '/tmp/deinstall2020-08-17_11-56-15PM' on node 'RAC1'
Clean install operation removing temporary directory '/tmp/deinstall2020-08-17_11-56-15PM' on node 'rac2'

## [END] Oracle install clean ##


######################### CLEAN OPERATION END #########################


####################### CLEAN OPERATION SUMMARY #######################
Successfully de-configured the following database instances : racdb
Cleaning the config for CCR
As CCR is not configured, so skipping the cleaning of CCR configuration
CCR clean is finished
Successfully detached Oracle home '/opt/app/oracle/product/11.2.0.3.0/db_1' from the central inventory on the local node.
Successfully deleted directory '/opt/app/oracle/product/11.2.0.3.0/db_1' on the local node.
Successfully detached Oracle home '/opt/app/oracle/product/11.2.0.3.0/db_1' from the central inventory on the remote nodes 'rac2'.
Successfully deleted directory '/opt/app/oracle/product/11.2.0.3.0/db_1' on the remote nodes 'rac2'.
Oracle Universal Installer cleanup was successful.

Oracle deinstall tool successfully cleaned up temporary directories.
#######################################################################


############# ORACLE DEINSTALL & DECONFIG TOOL END #############
*/

-- Step 211 -->> On Node 1
[oracle@RAC1 deinstall]$ cd /opt/app/oracle/product/
[oracle@RAC1 product]$ du -sh *
/*
4.0K    11.2.0.3.0
7.0G    11.2.0.4.0
*/
[oracle@RAC1 product]$ rm -rf 11.2.0.3.0/

-- Step 212 -->> On Node 2
[oracle@RAC2 ~]$ cd /opt/app/oracle/product/
[oracle@RAC2 product]$ du -sh *
/*
4.0K    11.2.0.3.0
7.0G    11.2.0.4.0
*/
[oracle@RAC2 product]$ rm -rf 11.2.0.3.0/

-- Step 213 -->> On Both Nodes
[oracle@RAC1/RAC2 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node rac1
Instance racdb2 is running on node rac2
*/

-- Step 214 -->> On Node 1
[oracle@RAC1 ~]$ srvctl stop database -d racdb
[oracle@RAC1 ~]$ srvctl start database -d racdb

-- Step 215 -->> On Both Nodes
[oracle@RAC1/RAC2 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node rac1
Instance racdb2 is running on node rac2
*/

-- Step 216 -->> On Both Nodes
[oracle@RAC1/RAC2 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.4.0 Production on Tue Aug 18 00:25:25 2020

Copyright (c) 1982, 2013, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> archive log list 
Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            +ARC/racdb
Oldest online log sequence     104
Next log sequence to archive   105
Current log sequence           105

SQL> set linesize 200
SQL> select * from gv$version;

   INST_ID BANNER
---------- --------------------------------------------------------------------------------
         1 Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
         1 PL/SQL Release 11.2.0.4.0 - Production
         1 CORE 11.2.0.4.0      Production
         1 TNS for Linux: Version 11.2.0.4.0 - Production
         1 NLSRTL Version 11.2.0.4.0 - Production
         2 Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
         2 PL/SQL Release 11.2.0.4.0 - Production
         2 CORE 11.2.0.4.0      Production
         2 TNS for Linux: Version 11.2.0.4.0 - Production
         2 NLSRTL Version 11.2.0.4.0 - Production

10 rows selected.

SQL> SELECT inst_id,name,log_mode,open_mode,protection_mode FROM gv$database;

   INST_ID NAME      LOG_MODE     OPEN_MODE            PROTECTION_MODE
---------- --------- ------------ -------------------- --------------------
         1 RACDB     ARCHIVELOG   READ WRITE           MAXIMUM PERFORMANCE
         2 RACDB     ARCHIVELOG   READ WRITE           MAXIMUM PERFORMANCE
*/

-- Step 217 -->> On Both Nodes
[oracle@RAC1/RAC2 ~]$ rman target /
/*
Recovery Manager: Release 11.2.0.4.0 - Production on Tue Aug 18 00:29:45 2020

Copyright (c) 1982, 2011, Oracle and/or its affiliates.  All rights reserved.

connected to target database: RACDB (DBID=1045652710)

RMAN> show all;

using target database control file instead of recovery catalog
RMAN configuration parameters for database with db_unique_name RACDB are:
CONFIGURE RETENTION POLICY TO REDUNDANCY 1; # default
CONFIGURE BACKUP OPTIMIZATION OFF; # default
CONFIGURE DEFAULT DEVICE TYPE TO DISK; # default
CONFIGURE CONTROLFILE AUTOBACKUP OFF; # default
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '%F'; # default
CONFIGURE DEVICE TYPE DISK PARALLELISM 4 BACKUP TYPE TO BACKUPSET;
CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE MAXSETSIZE TO UNLIMITED; # default
CONFIGURE ENCRYPTION FOR DATABASE OFF; # default
CONFIGURE ENCRYPTION ALGORITHM 'AES128'; # default
CONFIGURE COMPRESSION ALGORITHM 'BASIC' AS OF RELEASE 'DEFAULT' OPTIMIZE FOR LOAD TRUE ; # default
CONFIGURE ARCHIVELOG DELETION POLICY TO NONE; # default
-- Node 1
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/product/11.2.0.4.0/db_1/dbs/snapcf_racdb1.f'; # default
-- Node 2
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/product/11.2.0.4.0/db_1/dbs/snapcf_racdb2.f'; # default

RMAN> exit


Recovery Manager complete.
*/

-- Step 218 -->> On Both Nodes
[oracle@RAC1/RAC2 ~]$ tnsping racdb
/*
TNS Ping Utility for Linux: Version 11.2.0.4.0 - Production on 18-AUG-2020 03:04:21

Copyright (c) 1997, 2013, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = RAC-scan.mydomain)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = racdb)))
OK (10 msec)
*/

-- Step 219 -->> On Both Nodes
[grid@RAC1/RAC2 ~]$ sqlplus sys/sys as sysasm
/*
SQL*Plus: Release 11.2.0.4.0 Production on Tue Aug 18 03:07:25 2020

Copyright (c) 1982, 2013, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
With the Real Application Clusters and Automatic Storage Management options

SQL> set linesize 200
SQL> select * from gv$version;

   INST_ID BANNER
---------- --------------------------------------------------------------------------------
         2 Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
         2 PL/SQL Release 11.2.0.4.0 - Production
         2 CORE 11.2.0.4.0      Production
         2 TNS for Linux: Version 11.2.0.4.0 - Production
         2 NLSRTL Version 11.2.0.4.0 - Production
         1 Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
         1 PL/SQL Release 11.2.0.4.0 - Production
         1 CORE 11.2.0.4.0      Production
         1 TNS for Linux: Version 11.2.0.4.0 - Production
         1 NLSRTL Version 11.2.0.4.0 - Production

10 rows selected.

SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
With the Real Application Clusters and Automatic Storage Management options
*/


