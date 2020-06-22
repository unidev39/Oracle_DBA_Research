[root@DB-RAC1/DB-RAC2 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.168.1.71   DB-RAC1.mydomain.com        DB-RAC1
192.168.1.72   DB-RAC2.mydomain.com        DB-RAC2

# Private
192.168.0.71   DB-RAC1-priv.mydomain.com   DB-RAC1-priv
192.168.0.72   DB-RAC2-priv.mydomain.com   DB-RAC2-priv

# Virtual
192.168.1.69   DB-RAC1-vip.mydomain.com     DB-RAC1-vip
192.168.1.70   DB-RAC2-vip.mydomain.com     DB-RAC2-vip

# SCAN
192.168.1.73   DB-RAC-scan.mydomain.com    DB-RAC-scan
192.168.1.74   DB-RAC-scan.mydomain.com    DB-RAC-scan
*/

[root@DB-RAC1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth0
/*
DEVICE=eth0
BOOTPROTO=static
ONBOOT=yes
TYPE=Ethernet
IPADDR=192.168.1.71
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=192.168.1.11
DNS2=192.168.1.12
*/
[root@DB-RAC1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth1
/*
DEVICE=eth1
BOOTPROTO=static
ONBOOT=yes
TYPE=Ethernet
IPADDR=192.168.0.71
NETMASK=255.255.255.0
*/

[root@DB-RAC2 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth0
/*
DEVICE=eth0
BOOTPROTO=static
ONBOOT=yes
TYPE=Ethernet
IPADDR=192.168.1.72
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=192.168.1.11
DNS2=192.168.1.12
*/

[root@DB-RAC2 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth1
/*
DEVICE=eth1
BOOTPROTO=static
ONBOOT=yes
TYPE=Ethernet
IPADDR=192.168.0.72
NETMASK=255.255.255.0
*/

[root@DB-RAC1/DB-RAC2 ~]# vi /etc/selinux/config 
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


-- disabling the firewall.
[root@DB-RAC1/DB-RAC2 ~]# chkconfig --list iptables
/*
iptables  0:off    1:off    2:on    3:on    4:on    5:on    6:off
*/
[root@DB-RAC1/DB-RAC2 ~]# service iptables stop
/*
iptables: Setting chains to policy ACCEPT: nat mangle filte[  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
*/
[root@DB-RAC1/DB-RAC2 ~]# chkconfig iptables off
[root@DB-RAC1/DB-RAC2 ~]# iptables -F
[root@DB-RAC1/DB-RAC2 ~]# service iptables save
/*
iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]
*/
[root@DB-RAC1/DB-RAC2 ~]# /etc/init.d/iptables stop
/*
iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
*/
[root@DB-RAC1/DB-RAC2 ~]# iptables -L
/*
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
*/

[root@DB-RAC1/DB-RAC2 ~]# chkconfig --list iptables
/*
iptables   0:off    1:off    2:off    3:off    4:off    5:off    6:off
*/ 

-- Step 9 -->> On both Nodes
-- ntpd disable
[root@DB-RAC1/DB-RAC2 ~]# service ntpd stop
/*
Shutting down ntpd:                                        [FAILED]
*/

[root@DB-RAC1/DB-RAC2 ~]# service ntpd status
/*
ntpd is stopped
*/

[root@DB-RAC1/DB-RAC2 ~]# chkconfig ntpd off
[root@DB-RAC1/DB-RAC2 ~]# mv /etc/ntp.conf /etc/ntp.conf.backup
[root@DB-RAC1/DB-RAC2 ~]# rm /etc/ntp.conf
[root@DB-RAC1/DB-RAC2 ~]# rm /var/run/ntpd.pid
[root@DB-RAC1/DB-RAC2 ~]# /etc/init.d/NetworkManager stop
[root@DB-RAC1/DB-RAC2 ~]# service network restart
[root@DB-RAC1/DB-RAC2 ~]# /etc/init.d/network restart
[root@DB-RAC1/DB-RAC2 ~]# init 6

[root@DB-RAC1 ~]# cd /media/OL6.4\ x86_64\ Disc\ 1\ 20130225/Server/Packages/
[root@DB-RAC1 Packages]# yum install oracle-rdbms-server-11gR2-preinstall
[root@DB-RAC1 Packages]# yum update

[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh binutils-2*x86_64*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh glibc-2*x86_64* nss-softokn-freebl-3*x86_64*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh glibc-2*i686* nss-softokn-freebl-3*i686*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh compat-libstdc++-33*x86_64*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh glibc-common-2*x86_64*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh glibc-devel-2*x86_64*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh glibc-devel-2*i686*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh glibc-headers-2*x86_64*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh elfutils-libelf-0*x86_64*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh elfutils-libelf-devel-0*x86_64*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh gcc-3*x86_64*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh gcc-c++-4*x86_64*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh ksh-*x86_64*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh libaio-0*x86_64*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh libaio-devel-0*x86_64*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh libaio-0*i686*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh libaio-devel-0*i686*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh libgcc-4*x86_64*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh libgcc-4*i686*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh libstdc++-4*x86_64*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh libstdc++-4*i686*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh libstdc++-devel-4*x86_64*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh make-3.81*x86_64*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh numactl-devel-2*x86_64*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh sysstat-9*x86_64*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh compat-libstdc++-33*i686*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh compat-libcap*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh libaio-devel-0.*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh ksh-2*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh libstdc++-4.*.i686*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh elfutils-libelf-0*i686* elfutils-libelf-devel-0*i686*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh libtool-ltdl*i686*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh ncurses*i686*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh readline*i686*
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh unixODBC*
[root@DB-RAC1/DB-RAC2 ~]# rpm -q binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel elfutils-libelf-devel-static \
[root@DB-RAC1/DB-RAC2 ~]# rpm -q gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers kernel-headers ksh libaio libaio-devel \
[root@DB-RAC1/DB-RAC2 ~]# rpm -q libgcc libgomp libstdc++ libstdc++-devel make numactl-devel sysstat unixODBC unixODBC-devel
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh oracleasm*.rpm
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh --nodeps --force numactl-devel-2.0.7-6.el6.x86_64.rpm
[root@DB-RAC1/DB-RAC2 ~]# rpm -iUvh --nodeps --force unixODBC-devel-2.2.14-12.el6_3.x86_64.rpm 
[root@DB-RAC1/DB-RAC2 ~]# 

[root@DB-RAC1/DB-RAC2 ~ ]# cd /etc/yum.repos.d
[root@DB-RAC1/DB-RAC2 yum.repos.d]# uname -a
/*
Linux DB-RAC1/DB-RAC2.mydomain.com 2.6.39-400.313.1.el6uek.x86_64 #1 SMP Thu Aug 8 15:49:52 PDT 2019 x86_64 x86_64 x86_64 GNU/Linux
*/

[root@DB-RAC1/DB-RAC2 yum.repos.d]# cat /etc/os-release
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

[root@DB-RAC1/DB-RAC2 yum.repos.d]# wget https://public-yum.oracle.com/public-yum-ol6.repo
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
[root@DB-RAC1/DB-RAC2 yum.repos.d]# ls
/*
oracle-linux-ol6.repo.disabled  public-yum-ol6.repo    public-yum-ol6.repo.2
packagekit-media.repo           public-yum-ol6.repo.1  uek-ol6.repo.disabled
*/

[root@DB-RAC1/DB-RAC2 yum.repos.d]# yum install kmod-oracleasm
[root@DB-RAC1/DB-RAC2 yum.repos.d]# yum install oracleasm-support
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
[root@DB-RAC1/DB-RAC2 yum.repos.d]# cd /mnt/hgfs/Oracle_Software/OracleASM_Package/
[root@DB-RAC1/DB-RAC2 OracleASM_Package]# ls
/*
elfutils-libelf-devel-static-0.164-2.el6.x86_64.rpm
oracleasmlib-2.0.4-1.el6.x86_64.rpm
*/
[root@DB-RAC1/DB-RAC2 OracleASM_Package]# rpm -iUvh oracleasmlib-2.0.4-1.el6.x86_64.rpm
/*
Preparing...                ########################################### [100%]
    package oracleasmlib-2.0.4-1.el6.x86_64 is already installed
*/
[root@DB-RAC1/DB-RAC2 OracleASM_Package]# rpm -iUvh elfutils-libelf-devel-static-0.164-2.el6.x86_64.rpm
rpm -iUvh --nodeps --force elfutils-libelf-devel-static-0.164-2.el6.x86_64.rpm

/*
Preparing...                ########################################### [100%]
   1:elfutils-libelf-devel-s########################################### [100%]
*/

-- Step 15 -->> On both Nodes
-- Orcle ASM Configuration
[root@DB-RAC1/DB-RAC2 ~]# rpm -qa | grep -i oracleasm
/*
kmod-oracleasm-2.0.8-16.1.el6_10.x86_64
oracleasmlib-2.0.4-1.el6.x86_64
oracleasm-support-2.1.11-2.el6.x86_64
*/
 
[root@DB-RAC1/DB-RAC2 ~]# vi /etc/sysctl.conf
/*
# Kernel sysctl configuration file for Red Hat Linux
#
# For binary values, 0 is disabled, 1 is enabled.  See sysctl(8) and
# sysctl.conf(5) for more details.

# Controls IP packet forwarding
net.ipv4.ip_forward = 0

# Controls source route verification
net.ipv4.conf.default.rp_filter = 1

# Do not accept source routing
net.ipv4.conf.default.accept_source_route = 0

# Controls the System Request debugging functionality of the kernel
kernel.sysrq = 0

# Controls whether core dumps will append the PID to the core filename.
# Useful for debugging multi-threaded applications.
kernel.core_uses_pid = 1

# Controls the use of TCP syncookies
net.ipv4.tcp_syncookies = 1

# Disable netfilter on bridges.
net.bridge.bridge-nf-call-ip6tables = 0
net.bridge.bridge-nf-call-iptables = 0
net.bridge.bridge-nf-call-arptables = 0

# Controls the default maxmimum size of a mesage queue
kernel.msgmnb = 65536

# Controls the maximum size of a message, in bytes
kernel.msgmax = 65536

# Controls the maximum shared segment size, in bytes
kernel.shmmax = 68719476736

# Controls the maximum number of shared memory segments, in pages
kernel.shmall = 4294967296
kernel.shmmni = 4096
kernel.sem = 250 32000 100 128
fs.file-max = 6815744
net.ipv4.ip_local_port_range = 9000 65500
net.core.rmem_default = 262144
net.core.wmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_max = 1048576
fs.aio-max-nr = 1048576



# For oracle as suggested by D&B

fs.aio-max-nr=1048576
fs.file-max=6815744


# Recommened by D&B 2097152 was increased due to database startup problems
kernel.shmall=4294967296  
# Recommended by D&B 17179869184  was increased due to database sartup problems
kernel.shmmax=68719476736  
kernel.shmmni=4096
kernel.sem=250 32000 100 128

net.ipv4.ip_local_port_range = 9000 65500
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048586

net.ipv4.tcp_wmem=262144 262144 262144
net.ipv4.tcp_rmem=4194304 4194304 4194304


net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_intvl = 60
net.ipv4.tcp_keepalive_probes = 20
*/

[root@DB-RAC1/DB-RAC2 ~]# /sbin/sysctl -p

[root@DB-RAC1/DB-RAC2 ~]# vi /etc/security/limits.conf
/*
# /etc/security/limits.conf
#
#Each line describes a limit for a user in the form:
#
#<domain>        <type>  <item>  <value>
#
#Where:
#<domain> can be:
#        - an user name
#        - a group name, with @group syntax
#        - the wildcard *, for default entry
#        - the wildcard %, can be also used with %group syntax,
#                 for maxlogin limit
#
#<type> can have the two values:
#        - "soft" for enforcing the soft limits
#        - "hard" for enforcing hard limits
#
#<item> can be one of the following:
#        - core - limits the core file size (KB)
#        - data - max data size (KB)
#        - fsize - maximum filesize (KB)
#        - memlock - max locked-in-memory address space (KB)
#        - nofile - max number of open files
#        - rss - max resident set size (KB)
#        - stack - max stack size (KB)
#        - cpu - max CPU time (MIN)
#        - nproc - max number of processes
#        - as - address space limit (KB)
#        - maxlogins - max number of logins for this user
#        - maxsyslogins - max number of logins on the system
#        - priority - the priority to run user process with
#        - locks - max number of file locks the user can hold
#        - sigpending - max number of pending signals
#        - msgqueue - max memory used by POSIX message queues (bytes)
#        - nice - max nice priority allowed to raise to values: [-20, 19]
#        - rtprio - max realtime priority
#
#<domain>      <type>  <item>         <value>
#

#*               soft    core            0
#*               hard    rss             10000
#@student        hard    nproc           20
#@faculty        soft    nproc           20
#@faculty        hard    nproc           50
#ftp             hard    nproc           0
#@student        -       maxlogins       4

# End of file
grid soft nproc 2047
grid hard nofile 65536
oracle soft nproc 2047
oracle hard nofile 65536


# For oracle as suggested by D&B
oracle  soft    nproc   2047
oracle  hard    nproc   16384
oracle  soft    nofile  65536
oracle  hard    nofile  65536
oracle  soft    stack   10240

grid    soft    nproc   2047
grid    hard    nproc   16384
grid    soft    nofile  65536
grid    hard    nofile  65536
grid    soft    stack   10240
*/


[root@DB-RAC1/DB-RAC2 ~]# vi /etc/pam.d/login
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
*/

-- 1.Create OS groups using the command below. Enter these commands as the 'root' user:
[root@DB-RAC1/DB-RAC2 ~]# /usr/sbin/groupadd -g 503 oper
[root@DB-RAC1/DB-RAC2 ~]# /usr/sbin/groupadd -g 504 asmadmin
[root@DB-RAC1/DB-RAC2 ~]# /usr/sbin/groupadd -g 506 asmdba
[root@DB-RAC1/DB-RAC2 ~]# /usr/sbin/groupadd -g 507 asmoper
[root@DB-RAC1/DB-RAC2 ~]# /usr/sbin/groupadd -g 508 beoper
[root@DB-RAC1/DB-RAC2 ~]# /usr/sbin/groupadd -g 509 oinstall
[root@DB-RAC1/DB-RAC2 ~]# /usr/sbin/groupadd -g 510 dba

-- 2.Create the users that will own the Oracle software using the commands:
[root@DB-RAC1/DB-RAC2 ~]# /usr/sbin/useradd -g oinstall -G oinstall,dba,asmadmin,asmdba,asmoper,beoper grid
[root@DB-RAC1/DB-RAC2 ~]# /usr/sbin/usermod -g oinstall -G oinstall,dba,asmadmin,asmdba,asmoper,beoper grid
[root@DB-RAC1/DB-RAC2 ~]# /usr/sbin/useradd -g oinstall -G oinstall,dba,oper,asmdba,asmadmin oracle
[root@DB-RAC1/DB-RAC2 ~]# /usr/sbin/usermod -g oinstall -G oinstall,dba,oper,asmdba,asmadmin oracle

[root@DB-RAC1 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/
[root@DB-RAC1 ~]# cat /etc/group | grep -i oracle
/*
oper:x:503:oracle
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
oinstall:x:509:grid,oracle
dba:x:510:grid,oracle
*/
[root@DB-RAC1 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:509:grid,oracle
*/
[root@DB-RAC1 ~]# cat /etc/group | grep -i dba
/*
asmdba:x:506:grid,oracle
dba:x:510:grid,oracle
*/
[root@DB-RAC1 ~]# cat /etc/group | grep -i grid
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
beoper:x:508:grid
oinstall:x:509:grid,oracle
dba:x:510:grid,oracle
*/


[root@DB-RAC1/DB-RAC2 ~]# passwd oracle
/*
Changing password for user oracle.
New password: 
BAD PASSWORD: it is based on a dictionary word
BAD PASSWORD: is too simple
Retype new password: 
passwd: all authentication tokens updated successfully.
*/
[root@DB-RAC1/DB-RAC2 ~]# passwd grid
/*
Changing password for user grid.
New password: 
BAD PASSWORD: it is too short
BAD PASSWORD: is too simple
Retype new password: 
passwd: all authentication tokens updated successfully.
*/
[root@DB-RAC1/DB-RAC2 ~]# su - oracle
[oracle@DB-RAC1/rac2 ~]$ su - grid
/*
Password: 
*/
[grid@DB-RAC1/rac2 ~]$ su - root
/*
Password: 
*/

-- Step 20 -->> On both Nodes
--1.Create the Oracle Inventory Director:
[root@DB-RAC1/DB-RAC2 ~]# mkdir -p /opt/app/oraInventory
[root@DB-RAC1/DB-RAC2 ~]# chown -R grid:oinstall /opt/app/oraInventory
[root@DB-RAC1/DB-RAC2 ~]# chmod -R 775 /opt/app/oraInventory

--2.Creating the Oracle Grid Infrastructure Home Directory:
[root@DB-RAC1/DB-RAC2 ~]# mkdir -p /opt/app/11.2.0.3/grid
[root@DB-RAC1/DB-RAC2 ~]# chown -R grid:oinstall /opt/app/11.2.0.3/grid
[root@DB-RAC1/DB-RAC2 ~]# chmod -R 775 /opt/app/11.2.0.3/grid

--3.Creating the Oracle Base Directory
[root@DB-RAC1/DB-RAC2 ~]# mkdir -p /opt/app/oracle
[root@DB-RAC1/DB-RAC2 ~]# mkdir /opt/app/oracle/cfgtoollogs
[root@DB-RAC1/DB-RAC2 ~]# chown -R oracle:oinstall /opt/app/oracle
[root@DB-RAC1/DB-RAC2 ~]# chmod -R 775 /opt/app/oracle
[root@DB-RAC1/DB-RAC2 ~]# chown -R grid:oinstall /opt/app/oracle/cfgtoollogs
[root@DB-RAC1/DB-RAC2 ~]# chmod -R 775 /opt/app/oracle/cfgtoollogs

--4.Creating the Oracle RDBMS Home Directory
[root@DB-RAC1/DB-RAC2 ~]# mkdir -p /opt/app/oracle/product/11.2.0.3/db_1
[root@DB-RAC1/DB-RAC2 ~]# chown -R oracle:oinstall /opt/app/oracle/product/11.2.0.3/db_1
[root@DB-RAC1/DB-RAC2 ~]# chmod -R 775 /opt/app/oracle/product/11.2.0.3/db_1

[root@DB-RAC1/DB-RAC2 ~]# cd /opt/app/oracle
[root@DB-RAC1/DB-RAC2 ~]# chown -R oracle:oinstall product/
[root@DB-RAC1/DB-RAC2 ~]# chmod -R 775 product/
[root@DB-RAC1/DB-RAC2 ~]# 

[root@DB-RAC1/DB-RAC2 ~]# mkdir -p /opt/oracle_software/oracle_sft
[root@DB-RAC1/DB-RAC2 ~]# mkdir -p /opt/oracle_software/grid_sft
[root@DB-RAC1/DB-RAC2 oracle_software]# unzip p10404530_112030_Linux-x86-64_1of7.zip -d /opt/oracle_software/oracle_sft/
[root@DB-RAC1/DB-RAC2 oracle_software]# unzip p10404530_112030_Linux-x86-64_2of7.zip -d /opt/oracle_software/oracle_sft/
[root@DB-RAC1/DB-RAC2 oracle_software]# unzip p10404530_112030_Linux-x86-64_3of7-Clusterware.zip -d /opt/oracle_software/grid_sft/

[root@DB-RAC1/DB-RAC2 oracle_software]# chown -R grid:oinstall grid_sft/
[root@DB-RAC1/DB-RAC2 oracle_software]# chmod -R 775 grid_sft/
[root@DB-RAC1/DB-RAC2 oracle_software]# chown -R oracle:oinstall oracle_sft/
[root@DB-RAC1/DB-RAC2 oracle_software]# chmod -R 775 oracle_sft/

-----------
[oracle@DB-RAC1 ~]# vi .bash_profile
/*
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH

export TZ=Asia/Kathmandu
MAIL=/usr/mail/${LOGNAME:?}
TMP=/tmp; export TMP
TMPDIR=$TMP; export TMPDIR
ORACLE_BASE=/opt/app/oracle; 
export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/11.2.0.3/db_1; 
export ORACLE_HOME
ORACLE_HOSTNAME=DB-RAC1.mydomain.com; 
export ORACLE_HOSTNAME
ORACLE_UNQNAME=racdb; 
export ORACLE_UNQNAME
ORACLE_SID=racdb1; 
export ORACLE_SID
ORACLE_TERM=xterm; 
export ORACLE_TERM
PATH=/usr/sbin:$PATH;
export PATH
PATH=$ORACLE_HOME/bin:$ORACLE_HOME/OPatch:$PATH; 
export PATH
LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; 
export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; 
export CLASSPATH
export PATH
*/

[grid@DB-RAC1 ~]$ vi .bash_profile 
/*
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH

MAIL=/usr/mail/${LOGNAME:?}

TMP=/tmp export TMP
TMPDIR=$TMP export TMPDIR

ORACLE_SID=+ASM1 
export ORACLE_SID
ORACLE_BASE=/opt/app/oracle
export ORACLE_BASE
GRID_HOME=/opt/app/11.2.0.3/grid 
export GRID_HOME
ORACLE_HOME=$GRID_HOME 
export ORACLE_HOME
PATH=$PATH:/usr/sbin:/usr/X11/bin:/usr/dt/bin:/usr/openwin/bin:/usr/sfw/bin:/usr/sfw/sbin:/usr/ccs/bin:/usr/local/bin:/usr/local/sbin:$ORACLE_HOME/bin:$ORACLE_HOME/OPatch 
export PATH
LD_LIBRARY_PATH=$ORACLE_HOME/lib:/usr/dt/lib:/usr/lib:$ORACLE_HOME/oracm/lib 
export LD_LIBRARY_PATH
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib:$ORACLE_HOME/network/jlib:$ORACLE_HOME/JRE 
export CLASSPATH
export PATH
*/

[oracle@DB-RAC2 ~]$ vi .bash_profile
/*
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH

MAIL=/usr/mail/${LOGNAME:?}
TMP=/tmp; export TMP
TMPDIR=$TMP; export TMPDIR
ORACLE_BASE=/opt/app/oracle; 
export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/11.2.0.3/db_1; 
export ORACLE_HOME
ORACLE_HOSTNAME=DB-RAC2.mydomain.com; 
export ORACLE_HOSTNAME
ORACLE_UNQNAME=racdb; 
export ORACLE_UNQNAME
ORACLE_SID=racdb2; 
export ORACLE_SID
TZ=Asia/Kathmandu
export TZ
ORACLE_TERM=xterm; 
export ORACLE_TERM
PATH=/usr/sbin:$PATH;
export PATH
PATH=$ORACLE_HOME/bin:$PATH:$ORACLE_HOME/OPatch; 
export PATH
LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; 
export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; 
export CLASSPATH
export PATH
*/

[grid@DB-RAC2 ~]$ vi .bash_profile 
/*
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH

MAIL=/usr/mail/${LOGNAME:?}

TMP=/tmp export TMP
TMPDIR=$TMP export TMPDIR
ORACLE_SID=+ASM2 
export ORACLE_SID
ORACLE_BASE=/opt/app/oracle
export ORACLE_BASE
GRID_HOME=/opt/app/11.2.0.3/grid 
export GRID_HOME
ORACLE_HOME=$GRID_HOME 
export ORACLE_HOME
PATH=$PATH:/usr/sbin:/usr/X11/bin:/usr/dt/bin:/usr/openwin/bin:/usr/sfw/bin:/usr/sfw/sbin:/usr/ccs/bin:/usr/local/bin:/usr/local/sbin:$ORACLE_HOME/bin:$ORACLE_HOME/OPatch 
export PATH
LD_LIBRARY_PATH=$ORACLE_HOME/lib:/usr/dt/lib:/usr/lib:$ORACLE_HOME/oracm/lib 
export LD_LIBRARY_PATH
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib:$ORACLE_HOME/network/jlib:$ORACLE_HOME/JRE 
export CLASSPATH
export PATH
*/

[root@DB-RAC1 ~]# vi /etc/sysconfig/network
/*
NETWORKING=yes
HOSTNAME=DB-RAC1.mydomain.com
*/

[root@DB-RAC2 ~]# vim /etc/sysconfig/network
/*
NETWORKING=yes
HOSTNAME=DB-RAC2.mydomain.com
*/

[root@DB-RAC1 ~]# su - oracle
[oracle@DB-RAC1 ~]# mkdir -p ~/.ssh
[oracle@DB-RAC1 ~]# chmod 700 ~/.ssh

--Generate the RSA and DSA keys:
[oracle@DB-RAC1 ~]# /usr/bin/ssh-keygen -t rsa
[oracle@DB-RAC1 ~]# /usr/bin/ssh-keygen -t dsa

[oracle@DB-RAC1 ~]# touch ~/.ssh/authorized_keys
[oracle@DB-RAC1 ~]# cd ~/.ssh

--(a) Add these Keys to the Authorized_keys file.
[oracle@DB-RAC1 ~]# cat id_rsa.pub >> authorized_keys
[oracle@DB-RAC1 ~]# cat id_dsa.pub >> authorized_keys

--SSH user Equivalency configuration (grid and oracle):
[root@DB-RAC2 ~]# su - oracle
[oracle@DB-RAC2 ~]# mkdir -p ~/.ssh
[oracle@DB-RAC2 ~]# chmod 700 ~/.ssh

--Generate the RSA and DSA keys:
[oracle@DB-RAC2 ~]# /usr/bin/ssh-keygen -t rsa
[oracle@DB-RAC2 ~]# /usr/bin/ssh-keygen -t dsa
[oracle@DB-RAC2 ~]# cd ~/.ssh

-- Step 34 -->> On Node 1
-- Send this file to node2.
[oracle@DB-RAC1 .ssh]# scp authorized_keys oracle@DB-RAC2:~/.ssh/
/*
[oracle@DB-RAC1 .ssh]$ scp authorized_keys oracle@DB-RAC2:~/.ssh/
The authenticity of host 'DB-RAC2 (192.168.1.72)' can't be established.
RSA key fingerprint is 5c:db:7a:5a:0e:8c:1e:c4:ef:74:5e:e4:4a:e2:1e:dd.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'DB-RAC2,192.168.1.72' (RSA) to the list of known hosts.
oracle@DB-RAC2's password: 
authorized_keys                                                     100% 1028     1.0KB/s   00:00  
*/

[oracle@DB-RAC1/DB-RAC2  ~]# chmod 600 ~/.ssh/authorized_keys
[oracle@DB-RAC1 .ssh]$ ssh oracle@DB-RAC2
[oracle@DB-RAC2 ~]$ exit
[oracle@DB-RAC2 .ssh]$ ssh oracle@DB-RAC1
/*
The authenticity of host 'DB-RAC1 (192.168.1.71)' can't be established.
RSA key fingerprint is 8d:16:04:3a:c6:db:57:e4:59:ad:67:34:7d:6c:9a:0b.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'DB-RAC1,192.168.1.71' (RSA) to the list of known hosts.
oracle@DB-RAC1's password:
*/ 
[oracle@DB-RAC1 ~]$ exit
[root@DB-RAC1 ~]#  su - grid
[grid@DB-RAC1 ~]$ mkdir -p ~/.ssh
[grid@DB-RAC1 ~]$ chmod 700 ~/.ssh
[grid@DB-RAC1 ~]$ /usr/bin/ssh-keygen -t rsa
[grid@DB-RAC1 ~]$ /usr/bin/ssh-keygen -t dsa
[grid@DB-RAC1 ~]$ touch ~/.ssh/authorized_keys
[grid@DB-RAC1 ~]$ cd ~/.ssh
[grid@DB-RAC1 .ssh]$ cat id_rsa.pub >> authorized_keys
[grid@DB-RAC1 .ssh]$ cat id_dsa.pub >> authorized_keys

[root@DB-RAC2 ~]#  su - grid
[grid@DB-RAC2 ~]$ mkdir -p ~/.ssh
[grid@DB-RAC2 ~]$ chmod 700 ~/.ssh
[grid@DB-RAC2 ~]$ /usr/bin/ssh-keygen -t rsa
[grid@DB-RAC2 ~]$ /usr/bin/ssh-keygen -t dsa
[grid@DB-RAC2 ~]$ cd ~/.ssh

[grid@DB-RAC1 .ssh]$ scp authorized_keys grid@DB-RAC2:~/.ssh/
/*
The authenticity of host 'DB-RAC2 (192.168.1.72)' can't be established.
RSA key fingerprint is 5c:db:7a:5a:0e:8c:1e:c4:ef:74:5e:e4:4a:e2:1e:dd.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'DB-RAC2,192.168.1.72' (RSA) to the list of known hosts.
grid@DB-RAC2's password: 
authorized_keys                                                     100%    0     0.0KB/s   00:00      
*/

[grid@DB-RAC1/DB-RAC2 .ssh]$ chmod 600 ~/.ssh/authorized_keys
[grid@DB-RAC1 .ssh]$ ssh grid@DB-RAC2
[grid@DB-RAC2 ~]$ exit
[grid@DB-RAC2 .ssh]$ ssh grid@DB-RAC1
/*
The authenticity of host 'rac1 (192.168.0.104)' can't be established.
RSA key fingerprint is 4a:f2:44:d8:f2:82:93:17:27:d5:86:36:9a:ef:6f:25.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'rac1,192.168.0.104' (RSA) to the list of known hosts.
grid@DB-RAC1's password:
*/
[grid@DB-RAC1 ~]$ exit

[root@DB-RAC1 ~]#  ssh DB-RAC2
[root@DB-RAC2 ~]#  exit
[root@DB-RAC2 ~]#  ssh DB-RAC1
[root@DB-RAC1 ~]#  exit

[root@DB-RAC1 ~]#  ssh root@DB-RAC2
[root@DB-RAC2 ~]#  exit
[root@DB-RAC2 ~]#  ssh root@DB-RAC1
[root@DB-RAC1 ~]#  exit

[root@DB-RAC1/DB-RAC2 ~]# which oracleasm
/*
/usr/sbin/oracleasm
*/

[root@DB-RAC1/DB-RAC2 ~]# oracleasm configure
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

[root@DB-RAC1/DB-RAC2 ~]# oracleasm status
/*
Checking if ASM is loaded: no
Checking if /dev/oracleasm is mounted: no
*/
[root@DB-RAC1/DB-RAC2 ~]# oracleasm configure -i
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

[root@DB-RAC1/DB-RAC2 ~]# oracleasm configure
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
[root@DB-RAC1/DB-RAC2 ~]# oracleasm init
/*
Creating /dev/oracleasm mount point: /dev/oracleasm
Loading module "oracleasm": oracleasm
Configuring "oracleasm" to use device physical block size
Mounting ASMlib driver filesystem: /dev/oracleasm
*/
[root@DB-RAC1/DB-RAC2 ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/
[root@DB-RAC1/DB-RAC2 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/
[root@DB-RAC1/DB-RAC2 ~]# oracleasm listdisks

[root@DB-RAC1 ~]# ls -ltr /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 May 22 14:46 /dev/sda
brw-rw---- 1 root disk 8,  4 May 22 14:46 /dev/sda4
brw-rw---- 1 root disk 8, 16 May 22 14:46 /dev/sdb
brw-rw---- 1 root disk 8,  5 May 22 14:46 /dev/sda5
brw-rw---- 1 root disk 8, 32 May 22 14:46 /dev/sdc
brw-rw---- 1 root disk 8, 64 May 22 14:46 /dev/sde
brw-rw---- 1 root disk 8, 80 May 22 14:46 /dev/sdf
brw-rw---- 1 root disk 8, 48 May 22 14:46 /dev/sdd
brw-rw---- 1 root disk 8,  2 May 22 14:46 /dev/sda2
brw-rw---- 1 root disk 8,  1 May 22 14:46 /dev/sda1
brw-rw---- 1 root disk 8,  6 May 22 14:46 /dev/sda6
brw-rw---- 1 root disk 8,  3 May 22 14:46 /dev/sda3
brw-rw---- 1 root disk 8,  7 May 22 14:46 /dev/sda7
brw-rw---- 1 root disk 8,  8 May 22 14:46 /dev/sda8
brw-rw---- 1 root disk 8,  9 May 22 14:46 /dev/sda9
*/

[root@DB-RAC1 ~]# fdisk -ll
/*
[root@DB-RAC1 ~]# fdisk -ll

Disk /dev/sdc: 918.0 GB, 918049259520 bytes
255 heads, 63 sectors/track, 111613 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000


Disk /dev/sdb: 161.1 GB, 161061273600 bytes
255 heads, 63 sectors/track, 19581 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000


Disk /dev/sdd: 1934.9 GB, 1934882766848 bytes
255 heads, 63 sectors/track, 235236 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000


Disk /dev/sda: 311.4 GB, 311385128960 bytes
255 heads, 63 sectors/track, 37857 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000470d2

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1        1959    15728640   83  Linux
/dev/sda2            1959       15013   104857600   83  Linux
/dev/sda3           15013       28066   104850432   83  Linux
/dev/sda4           28066       37858    78649344    5  Extended
/dev/sda5           28066       30025    15728640   82  Linux swap / Solaris
/dev/sda6           30025       31983    15728640   83  Linux
/dev/sda7           31983       33941    15728640   83  Linux
/dev/sda8           33941       35899    15728640   83  Linux
/dev/sda9           35899       37858    15728640   83  Linux

Disk /dev/sdf: 11.8 GB, 11811160064 bytes
64 heads, 32 sectors/track, 11264 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000


Disk /dev/sde: 483.2 GB, 483183820800 bytes
255 heads, 63 sectors/track, 58743 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000
*/
----------------
[root@DB-RAC1 ~]#  fdisk /dev/sdb
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0x41e3f835.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/sdb: 161.1 GB, 161061273600 bytes
255 heads, 63 sectors/track, 19581 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x41e3f835

   Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-19581, default 1): 
Using default value 1
Last cylinder, +cylinders or +size{K,M,G} (1-19581, default 19581): 
Using default value 19581

Command (m for help): p

Disk /dev/sdb: 161.1 GB, 161061273600 bytes
255 heads, 63 sectors/track, 19581 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x41e3f835

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1       19581   157284351   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

[root@DB-RAC1 ~]# fdisk /dev/sdc
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0x190c687e.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/sdc: 918.0 GB, 918049259520 bytes
255 heads, 63 sectors/track, 111613 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x190c687e

   Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-111613, default 1): 
Using default value 1
Last cylinder, +cylinders or +size{K,M,G} (1-111613, default 111613): 
Using default value 111613

Command (m for help): p

Disk /dev/sdc: 918.0 GB, 918049259520 bytes
255 heads, 63 sectors/track, 111613 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x190c687e

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1      111613   896531391   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

[root@DB-RAC1 ~]# fdisk /dev/sdd
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0x45316603.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/sdd: 1934.9 GB, 1934882766848 bytes
255 heads, 63 sectors/track, 235236 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x45316603

   Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-235236, default 1): 
Using default value 1
Last cylinder, +cylinders or +size{K,M,G} (1-235236, default 235236): 
Using default value 235236

Command (m for help): p

Disk /dev/sdd: 1934.9 GB, 1934882766848 bytes
255 heads, 63 sectors/track, 235236 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x45316603

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1      235236  1889533138+  83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

[root@DB-RAC1 ~]# fdisk /dev/sde
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0x2e4c5c2d.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/sde: 483.2 GB, 483183820800 bytes
255 heads, 63 sectors/track, 58743 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x2e4c5c2d

   Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-58743, default 1): 
Using default value 1
Last cylinder, +cylinders or +size{K,M,G} (1-58743, default 58743): 
Using default value 58743

Command (m for help): p

Disk /dev/sde: 483.2 GB, 483183820800 bytes
255 heads, 63 sectors/track, 58743 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x2e4c5c2d

   Device Boot      Start         End      Blocks   Id  System
/dev/sde1               1       58743   471853116   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

[root@DB-RAC1 ~]# fdisk /dev/sdf
/*
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0xaaf409bc.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/sdf: 11.8 GB, 11811160064 bytes
64 heads, 32 sectors/track, 11264 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xaaf409bc

   Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-11264, default 1): 
Using default value 1
Last cylinder, +cylinders or +size{K,M,G} (1-11264, default 11264): 
Using default value 11264

Command (m for help): p

Disk /dev/sdf: 11.8 GB, 11811160064 bytes
64 heads, 32 sectors/track, 11264 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xaaf409bc

   Device Boot      Start         End      Blocks   Id  System
/dev/sdf1               1       11264    11534320   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
*/

[root@DB-RAC1 ~]# ls -ltr /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 May 22 14:46 /dev/sda
brw-rw---- 1 root disk 8,  4 May 22 14:46 /dev/sda4
brw-rw---- 1 root disk 8,  5 May 22 14:46 /dev/sda5
brw-rw---- 1 root disk 8,  2 May 22 14:46 /dev/sda2
brw-rw---- 1 root disk 8,  1 May 22 14:46 /dev/sda1
brw-rw---- 1 root disk 8,  6 May 22 14:46 /dev/sda6
brw-rw---- 1 root disk 8,  3 May 22 14:46 /dev/sda3
brw-rw---- 1 root disk 8,  7 May 22 14:46 /dev/sda7
brw-rw---- 1 root disk 8,  8 May 22 14:46 /dev/sda8
brw-rw---- 1 root disk 8,  9 May 22 14:46 /dev/sda9
brw-rw---- 1 root disk 8, 16 May 22 15:06 /dev/sdb
brw-rw---- 1 root disk 8, 17 May 22 15:06 /dev/sdb1
brw-rw---- 1 root disk 8, 32 May 22 15:08 /dev/sdc
brw-rw---- 1 root disk 8, 33 May 22 15:08 /dev/sdc1
brw-rw---- 1 root disk 8, 48 May 22 15:10 /dev/sdd
brw-rw---- 1 root disk 8, 49 May 22 15:10 /dev/sdd1
brw-rw---- 1 root disk 8, 64 May 22 15:11 /dev/sde
brw-rw---- 1 root disk 8, 65 May 22 15:11 /dev/sde1
brw-rw---- 1 root disk 8, 80 May 22 15:13 /dev/sdf
brw-rw---- 1 root disk 8, 81 May 22 15:13 /dev/sdf1
*/

[root@DB-RAC1 ~]# fdisk -ll
/*
Disk /dev/sdc: 918.0 GB, 918049259520 bytes
255 heads, 63 sectors/track, 111613 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x190c687e

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1      111613   896531391   83  Linux

Disk /dev/sdb: 161.1 GB, 161061273600 bytes
255 heads, 63 sectors/track, 19581 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x41e3f835

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1       19581   157284351   83  Linux

Disk /dev/sdd: 1934.9 GB, 1934882766848 bytes
255 heads, 63 sectors/track, 235236 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x45316603

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1      235236  1889533138+  83  Linux

Disk /dev/sda: 311.4 GB, 311385128960 bytes
255 heads, 63 sectors/track, 37857 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000470d2

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1        1959    15728640   83  Linux
/dev/sda2            1959       15013   104857600   83  Linux
/dev/sda3           15013       28066   104850432   83  Linux
/dev/sda4           28066       37858    78649344    5  Extended
/dev/sda5           28066       30025    15728640   82  Linux swap / Solaris
/dev/sda6           30025       31983    15728640   83  Linux
/dev/sda7           31983       33941    15728640   83  Linux
/dev/sda8           33941       35899    15728640   83  Linux
/dev/sda9           35899       37858    15728640   83  Linux

Disk /dev/sdf: 11.8 GB, 11811160064 bytes
64 heads, 32 sectors/track, 11264 cylinders
Units = cylinders of 2048 * 512 = 1048576 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xaaf409bc

   Device Boot      Start         End      Blocks   Id  System
/dev/sdf1               1       11264    11534320   83  Linux

Disk /dev/sde: 483.2 GB, 483183820800 bytes
255 heads, 63 sectors/track, 58743 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x2e4c5c2d

   Device Boot      Start         End      Blocks   Id  System
/dev/sde1               1       58743   471853116   83  Linux
*/

[root@DB-RAC1 ~]# /etc/init.d/oracleasm createdisk ARC /dev/sdb1
[root@DB-RAC1 ~]# /etc/init.d/oracleasm createdisk DATA /dev/sdc1
[root@DB-RAC1 ~]# /etc/init.d/oracleasm createdisk DATA2 /dev/sdd1
[root@DB-RAC1 ~]# /etc/init.d/oracleasm createdisk FRA /dev/sde1
[root@DB-RAC1 ~]# /etc/init.d/oracleasm createdisk OCR /dev/sdf1

[root@DB-RAC1/DB-RAC2 ~]# oracleasm configure
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
[root@DB-RAC1/DB-RAC2 ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/
[root@DB-RAC1 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/
[root@DB-RAC2 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
Instantiating disk "FRA"
Instantiating disk "OCR"
Instantiating disk "DATA"
Instantiating disk "DATA2"
Instantiating disk "ARC"
*/

[root@DB-RAC1/DB-RAC2 ~]# oracleasm listdisks
/*
ARC
DATA
DATA2
FRA
OCR
*/

-- Login from root user
[root@DB-RAC1/DB-RAC2~]# cd /opt/oracle_software/grid_sft/grid/rpm/
[root@DB-RAC1/DB-RAC2 rpm]# ls -ltr
/*
-rwxrwxr-x 1 grid oinstall 8551 Sep 22  2011 cvuqdisk-1.0.9-1.rpm
*/

[root@DB-RAC1/DB-RAC2 rpm]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP
[root@DB-RAC1/DB-RAC2 rpm]# rpm -iv cvuqdisk-1.0.9-1.rpm 
/*
Preparing packages for installation...
cvuqdisk-1.0.9-1
*/

[root@DB-RAC1/DB-RAC2 rpm]# rpm -iUvh cvuqdisk-1.0.9-1.rpm 
/*
Preparing...                ########################################### [100%]
   package cvuqdisk-1.0.9-1.x86_64 is already installed
*/

[root@DB-RAC1/DB-RAC2 rpm]# init 0


-- Login as grid user and issu the following command at rac1
[grid@DB-RAC1 Desktop]$ cd 
[grid@DB-RAC1 ~]$ hostname
/*
DB-RAC1.mydomain.com
*/
[grid@DB-RAC1 ~]$ xhost + DB-RAC1.mydomain.com
/*
DB-RAC1.mydomain.com being added to access control list
*/
[grid@DB-RAC1 ~]$ 

-- Login as grid user and issue the following command at rac1 
-- Make sure choose proper groups while installing grid
-- OSDBA  Group => asmdba
-- OSOPER Group => asmoper
-- OSASM  Group => asmadmin
-- oraInventory Group Name => oinstall

[grid@DB-RAC1 ~]$ cd /opt/oracle_software/grid_sft/grid/
[grid@DB-RAC1 grid]$ ls
/*
doc      readme.html  rpm           runInstaller  stage
install  response     runcluvfy.sh  sshsetup      welcome.html
*/
[grid@DB-RAC1 grid]$ sh ./runInstaller 

-- Run from root user to finalized the setup for both racs
[root@DB-RAC1 ~]#/opt/app/oraInventory/orainstRoot.sh 
[root@DB-RAC2 ~]#/opt/app/oraInventory/orainstRoot.sh
[root@DB-RAC1 ~]# /opt/app/11.2.0.3.0/grid/root.sh 
[root@DB-RAC2 ~]# /opt/app/11.2.0.3.0/grid/root.sh 
[root@DB-RAC1 ~]# cd /opt/app/11.2.0.3/grid/bin/
[root@DB-RAC1 bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/

[root@DB-RAC2 ~]# cd /opt/app/11.2.0.3/grid/bin/
[root@DB-RAC2 bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/

[root@DB-RAC1 bin]# ./crsctl check cluster -all
/*
**************************************************************
DB-RAC1:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
DB-RAC2:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/

[root@DB-RAC2 bin]# ./crsctl check cluster -all
/*
**************************************************************
DB-RAC1:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
DB-RAC2:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/

[root@DB-RAC1 bin]# ./crsctl stat res -t -init
[root@DB-RAC1 bin]# ./crsctl stat res -t
[root@DB-RAC2 bin]# ./crsctl stat res -t -init
[root@DB-RAC2 bin]# ./crsctl stat res -t

-- Click on OK to complete the installations
[grid@DB-RAC1 ~]$ asmcmd
ASMCMD> lsdg
/*
State    Type    Rebal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512   4096  1048576     11263    10867                0           10867              0             Y  OCR/
*/
ASMCMD> exit

[grid@DB-RAC2 ~]$ asmcmd
ASMCMD> lsdg
/*
State    Type    Rebal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512   4096  1048576     11263    10867                0           10867              0             Y  OCR/
*/
ASMCMD> exit

-- Login as oracle user and issu the following command at rac1 
[oracle@DB-RAC1 Desktop]$ cd 
[oracle@DB-RAC1 ~]$ hostname
/*
DB-RAC1.mydomain.com
*/
[oracle@DB-RAC1 ~]$ xhost + DB-RAC1.mydomain.com
/*
DB-RAC1.mydomain.com being added to access control list
*/
[oracle@DB-RAC1 ~]$ 
-- Install database software only => Real Application Cluster database installation
-- Make sure choose proper groups while installing oracle
-- OSDBA  Group => dba
-- OSOPER Group => oper

[oracle@DB-RAC1 ~]$ cd /opt/oracle_software/oracle_sft/database/
[oracle@DB-RAC1 oracle]$ ls
/*
doc      readme.html  rpm           runInstaller  stage
install  response     runcluvfy.sh  sshsetup      welcome.html
*/
[oracle@DB-RAC1 oracle]$ sh ./runInstaller 

-- Run from root user to finalized the setup for both racs
[root@DB-RAC1 ~]# /opt/app/oracle/product/11.2.0.3.0/db_1/root.sh
[root@DB-RAC2 ~]# /opt/app/oracle/product/11.2.0.3.0/db_1/root.sh


--To add DATA and FRA storage
[grig@DB-RAC1 ~]# su - grid
[grig@DB-RAC1 ~]# cd /opt/app/11.2.0.3.0/grid/bin
[grig@DB-RAC1 bin]# ./asmca

[oracle@DB-RAC1 Desktop]$ su - grid
/*
Password: 
*/

[grid@DB-RAC1 ~]$ asmcmd
ASMCMD> lsdg
/*
State    Type    Rebal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512   4096  1048576    153597   153501                0          153501              0             N  ARC/
MOUNTED  EXTERN  N         512   4096  1048576    875518   875416                0          875416              0             N  DATA/
MOUNTED  EXTERN  N         512   4096  1048576   1845247  1845136                0         1845136              0             N  DATA2/
MOUNTED  EXTERN  N         512   4096  1048576    460794   460695                0          460695              0             N  FRA/
MOUNTED  EXTERN  N         512   4096  1048576     11263    10867                0           10867              0             Y  OCR/
*/
ASMCMD> exit

-- Step 108 -->> On Node 2
[oracle@DB-RAC2 Desktop]$ su - grid
/*
Password: 
*/

[grid@DB-RAC2 ~]$ asmcmd
ASMCMD> lsdg
/*
State    Type    Rebal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512   4096  1048576    153597   153501                0          153501              0             N  ARC/
MOUNTED  EXTERN  N         512   4096  1048576    875518   875416                0          875416              0             N  DATA/
MOUNTED  EXTERN  N         512   4096  1048576   1845247  1845136                0         1845136              0             N  DATA2/
MOUNTED  EXTERN  N         512   4096  1048576    460794   460695                0          460695              0             N  FRA/
MOUNTED  EXTERN  N         512   4096  1048576     11263    10867                0           10867              0             Y  OCR/
*/
ASMCMD> exit

1.ARC
ASMCMD> cd +ARC
ASMCMD> pwd
+ARC
ASMCMD> mkdir racdb

2.DATA
ASMCMD> cd +DATA
ASMCMD> pwd
+DATA
ASMCMD> mkdir racdb
ASMCMD> mkdir primary
ASMCMD> cd racdb
ASMCMD> pwd
+DATA/racdb
ASMCMD> mkdir controlfile
ASMCMD> mkdir datafile
ASMCMD> mkdir onlinelog
ASMCMD> mkdir parameterfile
ASMCMD> mkdir tempfile
ASMCMD> cd ..
ASMCMD> cd primary
ASMCMD> pwd
+DATA/primary
ASMCMD> mkdir datafile
ASMCMD> mkdir onlinelog

3.DATA2
ASMCMD> cd +DATA2
ASMCMD> pwd
+DATA2
ASMCMD> mkdir racdb
ASMCMD> mkdir primary
ASMCMD> cd racdb
ASMCMD> pwd
+DATA2/racdb
ASMCMD> mkdir datafile
ASMCMD> mkdir tempfile
ASMCMD> cd ..
ASMCMD> cd primary
ASMCMD> pwd
+DATA2/primary
ASMCMD> mkdir datafile
ASMCMD> mkdir tempfile

4.FRA
ASMCMD> cd +FRA
ASMCMD> pwd
+FRA
ASMCMD> mkdir racdb


-- Required file from SOURCE_DB Server
[oracle@SOURCE_DB backup]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Sun Apr 5 09:55:11 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> create pfile='/home/oracle/backup/spfileracdb.ora' from spfile;

File created.

SQL> exit;
*/

[oracle@SOURCE_DB1 backup]$ ls
/*
spfileracdb.ora
*/
[oracle@SOURCE_DB1 backup]$ cd /opt/app/oracle/product/11.2.0.3/db_1/dbs/
[oracle@SOURCE_DB1 dbs]$ cp -r initracdb1.ora orapwracdb1 /home/oracle/backup/

[oracle@SOURCE_DB2 ~]$ cd /opt/app/oracle/product/11.2.0.3/db_1/dbs/
[oracle@SOURCE_DB2 dbs]$ scp -r initracdb2.ora orapwracdb2 oracle@192.168.1.85:/home/oracle/backup/
/*
initracdb2.ora                                                                                                                                   100%   41     0.0KB/s   00:00    
orapwracdb2                                                                                                                                      100% 1536     1.5KB/s   00:00    
*/

[oracle@SOURCE_DB1 dbs]$ cd /home/oracle/backup/
[oracle@SOURCE_DB1 backup]$ ls
/*
initracdb1.ora  initracdb2.ora  orapwracdb1  orapwracdb2  spfileracdb.ora
*/

[oracle@DB-RAC1 Old_DB_Config_File]$ ls -ltr
/*
-rwxrwxr-x 1 oracle oinstall 26435 May 24 00:40 sorcedb_ramn_fullbackup_log.log
-rwxrwxr-x 1 oracle oinstall  2229 May 24 11:27 spfileracdb.ora
-rwxrwxr-x 1 oracle oinstall  1536 May 24 11:29 orapwracdb1
-rwxrwxr-x 1 oracle oinstall    64 May 24 11:29 initracdb1.ora
-rwxrwxr-x 1 oracle oinstall  1536 May 24 11:31 orapwracdb2
-rwxrwxr-x 1 oracle oinstall    41 May 24 11:31 initracdb2.ora
*/ 

--To Verify the File name
[oracle@DB-RAC1 Old_DB_Config_File]$ export LOG_FILE_NAME='sorcedb_ramn_fullbackup_log.log'
[oracle@DB-RAC1 Old_DB_Config_File]$ export input_filename=`echo ${LOG_FILE_NAME} |  sed 's/.*\///'`
[oracle@DB-RAC1 Old_DB_Config_File]$ export temp_filename='temp_filename.txt'
[oracle@DB-RAC1 Old_DB_Config_File]$ output_filename='fullbkp_filename.txt'
[oracle@DB-RAC1 Old_DB_Config_File]$ cat ${input_filename} | grep -i ^piece  > ${temp_filename}
[oracle@DB-RAC1 Old_DB_Config_File]$ sed -e s/"piece handle"//g -i ${temp_filename}
[oracle@DB-RAC1 Old_DB_Config_File]$ sed -e s/"="//g -i ${temp_filename}
[oracle@DB-RAC1 Old_DB_Config_File]$ sed 's/ .*//' ${temp_filename} > ${output_filename}
[oracle@DB-RAC1 Old_DB_Config_File]$ rm -rf ${temp_filename}
[root@DB-RAC1 Old_DB_Config_File]# ls
/*
sorcedb_ramn_fullbackup_log.log  initracdb1.ora  orapwracdb1  spfileracdb.ora
fullbkp_filename.txt            initracdb2.ora   orapwracdb2
*/

[oracle@DB-RAC1 Old_DB_Config_File]$ cp -r initracdb1.ora orapwracdb1 /opt/app/oracle/product/11.2.0.3/db_1/dbs/
[oracle@DB-RAC1 Old_DB_Config_File]$ cd /opt/app/oracle/product/11.2.0.3/db_1/dbs/
[oracle@DB-RAC1 dbs]$ ls
/*
initracdb1.ora  init.ora  orapwracdb1
*/

[oracle@DB-RAC1 Old_DB_Config_File]$ scp -r initracdb2.ora orapwracdb2 oracle@DB-RAC2:/opt/app/oracle/product/11.2.0.3/db_1/dbs/
/*
initracdb2.ora                                                    100%   41     0.0KB/s   00:00    
orapwracdb2                                                       100% 1536     1.5KB/s   00:00 
*/   
[oracle@DB-RAC1 Old_DB_Config_File]$ ssh oracle@DB-RAC2
[oracle@DB-RAC2 ~]$ cd /opt/app/oracle/product/11.2.0.3/db_1/dbs/
[oracle@DB-RAC2 dbs]$ ls
/*
initracdb2.ora  init.ora  orapwracdb2
*/

[oracle@DB-RAC2 dbs]$ exit
/*
logout
Connection to DB-RAC2 closed.
*/

[oracle@DB-RAC1 Old_DB_Config_File]$ vi spfileracdb.ora
/* 
racdb2.__db_cache_size=8657043456
racdb1.__db_cache_size=7717519360
racdb2.__java_pool_size=201326592
racdb1.__java_pool_size=201326592
racdb1.__large_pool_size=201326592
racdb2.__large_pool_size=167772160
racdb2.__oracle_base='/opt/app/oracle'#ORACLE_BASE set from environment
racdb1.__oracle_base='/opt/app/oracle'#ORACLE_BASE set from environment
racdb1.__pga_aggregate_target=3388997632
racdb2.__pga_aggregate_target=3388997632
racdb1.__sga_target=12884901888
racdb2.__sga_target=12884901888
racdb1.__shared_io_pool_size=536870912
racdb2.__shared_io_pool_size=536870912
racdb2.__shared_pool_size=3221225472
racdb1.__shared_pool_size=4127195136
racdb2.__streams_pool_size=33554432
racdb1.__streams_pool_size=33554432
*.audit_file_dest='/opt/app/oracle/admin/racdb/adump'
*.audit_trail='NONE'
*.cluster_database=true
*.compatible='11.2.0.0.0'
*.control_files='+DATA/racdb/control01.ctl','+DATA/racdb/control02.ctl'
*.cursor_sharing='FORCE'
*.db_block_size=16384
*.db_domain=''
*.db_name='racdb'
*.db_recovery_file_dest_size=42949672960
*.db_unique_name='PRIMARY'
*.db_writer_processes=8
*.diagnostic_dest='/opt/app/oracle'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=racdbXDB)'
racdb2.instance_number=2
racdb1.instance_number=1
*.job_queue_processes=1000
*.log_archive_dest_1='LOCATION=+ARC/racdb/'
*.log_archive_dest_state_1='ENABLE'
*.log_archive_format='racdb_%t_%s_%r.arc'
*.log_archive_max_processes=8
*.open_cursors=300
*.optimizer_index_caching=50
*.optimizer_index_cost_adj=15
*.pga_aggregate_target=3363831808
*.processes=1500
*.remote_listener='DB-RAC-scan:1521'
*.remote_login_passwordfile='exclusive'
*.sec_case_sensitive_logon=FALSE
*.sga_max_size=12884901888
*.sga_target=12884901888
racdb2.thread=2
racdb1.thread=1
racdb2.undo_tablespace='UNDOTBS2'
racdb1.undo_tablespace='UNDOTBS1'
*/

[oracle@DB-RAC1 ~]$ mkdir -p /opt/app/oracle/admin/racdb/adump
[oracle@DB-RAC1 ~]$ ssh oracle@DB-RAC2
[oracle@DB-RAC2 ~]$ mkdir -p /opt/app/oracle/admin/racdb/adump

[oracle@DB-RAC1 ~]$ vi /etc/oratab
/*
racdb1:/opt/app/oracle/product/11.2.0.3/db_1:N
*/
[oracle@DB-RAC1 ~]$ ssh oracle@DB-RAC2
[oracle@DB-RAC2 ~]$ vi /etc/oratab
/*
racdb2:/opt/app/oracle/product/11.2.0.3/db_1:N
*/


[oracle@DB-RAC1 ~]$ cd /home/oracle/Old_DB_Config_File/
[oracle@DB-RAC1 Old_DB_Config_File]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Sun May 24 15:32:00 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> !ls
sorcedb_ramn_fullbackup_log.log  initracdb1.ora  orapwracdb1  spfileracdb.ora
fullbkp_filename.txt            initracdb2.ora  orapwracdb2  spfileracdb.ora.backup

SQL> startup nomount pfile='/home/oracle/Old_DB_Config_File/spfileracdb.ora';
ORACLE instance started.

Total System Global Area 1.2827E+10 bytes
Fixed Size                  2240344 bytes
Variable Size            4563402920 bytes
Database Buffers         8254390272 bytes
Redo Buffers                7335936 bytes

SQL> create SPFILE='+DATA/racdb/spfileracdb.ora' from pfile='/home/oracle/Old_DB_Config_File/spfileracdb.ora';

File created.

SQL> shut immediate;
ORA-01507: database not mounted


ORACLE instance shut down.
SQL> startup nomount;
ORACLE instance started.

Total System Global Area 1.2827E+10 bytes
Fixed Size                  2240344 bytes
Variable Size            4563402920 bytes
Database Buffers         8254390272 bytes
Redo Buffers                7335936 bytes
SQL> sho parameter pfile

NAME   TYPE   VALUE
------ ------ -------------------------------
spfile string +DATA/racdb/spfileracdb.ora

SQL> exit
*/

[oracle@DB-RAC1 ~]$ ps -ef | grep pmon
/*
grid       4159      1  0 May23 ?        00:00:28 asm_pmon_+ASM1
oracle    44019      1  0 15:36 ?        00:00:00 ora_pmon_racdb1
oracle    44241  43007  0 15:42 pts/0    00:00:00 grep pmon
*/

[oracle@DB-RAC1 ~]$ rman target /
/*
Recovery Manager: Release 11.2.0.3.0 - Production on Thu Apr 2 17:10:20 2020

Copyright (c) 1982, 2011, Oracle and/or its affiliates.  All rights reserved.

connected to target database: RACDB (not mounted)

RMAN> restore controlfile from '+FRA/racdb/racdb_cf_racdb_fcv0v5g3_14828_20200524';
Starting restore at 24-MAY-20
using target database control file instead of recovery catalog
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=1517 instance=racdb1 device type=DISK

channel ORA_DISK_1: restoring control file
channel ORA_DISK_1: restore complete, elapsed time: 00:00:01
output file name=+DATA/racdb/control01.ctl
output file name=+DATA/racdb/control02.ctl
Finished restore at 24-MAY-20

RMAN> sql 'alter database mount';

sql statement: alter database mount
released channel: ORA_DISK_1

RMAN> show all;

RMAN configuration parameters for database with db_unique_name PRIMARY are:
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 30 DAYS;
CONFIGURE BACKUP OPTIMIZATION OFF; # default
CONFIGURE DEFAULT DEVICE TYPE TO DISK; # default
CONFIGURE CONTROLFILE AUTOBACKUP ON;
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '+FRA/racdb/control_arc_%F_%T';
CONFIGURE DEVICE TYPE DISK PARALLELISM 1 BACKUP TYPE TO BACKUPSET; # default
CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE MAXSETSIZE TO UNLIMITED; # default
CONFIGURE ENCRYPTION FOR DATABASE OFF; # default
CONFIGURE ENCRYPTION ALGORITHM 'AES128'; # default
CONFIGURE COMPRESSION ALGORITHM 'BASIC' AS OF RELEASE 'DEFAULT' OPTIMIZE FOR LOAD TRUE;
CONFIGURE ARCHIVELOG DELETION POLICY TO APPLIED ON ALL STANDBY;
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '+FRA/racdb/snapcontrolfile/snapcf_racdb1.f';
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '+FRA/racdb/snapcontrolfile/snapcf_racdb1.f';

RMAN> CONFIGURE DEVICE TYPE DISK PARALLELISM 4  BACKUP TYPE TO BACKUPSET;  

new RMAN configuration parameters:
CONFIGURE DEVICE TYPE DISK PARALLELISM 4 BACKUP TYPE TO BACKUPSET;
new RMAN configuration parameters are successfully stored

RMAN> show all;

RMAN configuration parameters for database with db_unique_name PRIMARY are:
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 30 DAYS;
CONFIGURE BACKUP OPTIMIZATION OFF; # default
CONFIGURE DEFAULT DEVICE TYPE TO DISK; # default
CONFIGURE CONTROLFILE AUTOBACKUP ON;
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '+FRA/racdb/control_arc_%F_%T';
CONFIGURE DEVICE TYPE DISK PARALLELISM 4 BACKUP TYPE TO BACKUPSET;
CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE MAXSETSIZE TO UNLIMITED; # default
CONFIGURE ENCRYPTION FOR DATABASE OFF; # default
CONFIGURE ENCRYPTION ALGORITHM 'AES128'; # default
CONFIGURE COMPRESSION ALGORITHM 'BASIC' AS OF RELEASE 'DEFAULT' OPTIMIZE FOR LOAD TRUE;
CONFIGURE ARCHIVELOG DELETION POLICY TO APPLIED ON ALL STANDBY;
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '+FRA/racdb/snapcontrolfile/snapcf_racdb1.f';
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '+FRA/racdb/snapcontrolfile/snapcf_racdb1.f';


RMAN> catalog start with '+FRA/racdb/';
RMAN> restore database;

channel ORA_DISK_3: restored backup piece 14
channel ORA_DISK_3: restore complete, elapsed time: 08:15:06
Finished restore at 25-MAY-20

RMAN> list backup of archivelog all;

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
13482   43.71M     DISK        00:00:00     24-MAY-20      
        BP Key: 46085   Status: AVAILABLE  Compressed: YES  Tag: TAG20200524T100017
        Piece Name: +FRA/racdb/arc_racdb_frv1069h_1_1_20200524

  List of Archived Logs in backup set 13482
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    53489   32521098570 24-MAY-20 32521626221 24-MAY-20
  2    50737   32520174398 24-MAY-20 32521098574 24-MAY-20
  2    50738   32521098574 24-MAY-20 32521626264 24-MAY-20

RMAN> recover database;

archived log file name=+ARC/racdb/racdb_1_53488_846526302.arc thread=1 sequence=53488
archived log file name=+ARC/racdb/racdb_1_53489_846526302.arc thread=1 sequence=53489
archived log file name=+ARC/racdb/racdb_2_50738_846526302.arc thread=2 sequence=50738
unable to find archived log
archived log thread=1 sequence=53490
RMAN-00571: ===========================================================
RMAN-00569: =============== ERROR MESSAGE STACK FOLLOWS ===============
RMAN-00571: ===========================================================
RMAN-03002: failure of recover command at 05/25/2020 11:51:44
RMAN-06054: media recovery requesting unknown archived log for thread 1 with sequence 53490 and starting SCN of 32521626221

RMAN> exit

Recovery Manager complete.
*/

SELECT sid, serial#, context, sofar, totalwork,
 round(sofar/totalwork*100,2) "% Complete"
 FROM v$session_longops
 WHERE opname LIKE 'RMAN%'
 AND opname NOT LIKE '%aggregate%'
 AND totalwork != 0
 AND sofar != totalwork;

[oracle@DB-RAC1 Old_DB_Config_File]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon May 25 11:52:55 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> alter database open;
alter database open
*
ERROR at line 1:
ORA-01589: must use RESETLOGS or NORESETLOGS option for database open


SQL> ALTER DATABASE OPEN RESETLOGS;

Database altered.

SQL> select status, instance_name from gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
OPEN         racdb1


SQL> select name, open_mode, dbid from v$database;

NAME      OPEN_MODE                  DBID
--------- -------------------- ----------
racdb   READ WRITE            448326366

*/

[oracle@DB-RAC1 ~]$ which srvctl
/opt/app/oracle/product/11.2.0.3.0/db_1/bin/srvctl
[oracle@DB-RAC1 ~]$ srvctl add database -d racdb -o /opt/app/oracle/product/11.2.0.3/db_1
[oracle@DB-RAC1 ~]$ srvctl config database -d racdb -a
/*
Database unique name: racdb
Database name: 
Oracle home: /opt/app/oracle/product/11.2.0.3/db_1
Oracle user: oracle
Spfile: 
Domain: 
Start options: open
Stop options: immediate
Database role: PRIMARY
Management policy: AUTOMATIC
Server pools: racdb
Database instances: 
Disk Groups: 
Mount point paths: 
Services: 
Type: RAC
Database is enabled
Database is administrator managed
*/

[oracle@DB-RAC1 ~]$ srvctl add instance -d racdb -i racdb1 -n DB-RAC1
[oracle@DB-RAC1 ~]$ srvctl add instance -d racdb -i racdb2 -n DB-RAC2
[oracle@DB-RAC1 ~]$ srvctl config database -d racdb -a
/*
Database unique name: racdb
Database name: 
Oracle home: /opt/app/oracle/product/11.2.0.3/db_1
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
Database is enabled
Database is administrator managed
*/

[oracle@DB-RAC1 ~]$ srvctl status database -d racdb

/*
Instance racdb1 is not running on node rac1
Instance racdb2 is not running on node rac2
*/

[oracle@DB-RAC1 ~]$ srvctl start database -d  racdb
[oracle@DB-RAC1 ~]$ srvctl status database -d  racdb
/*
Instance racdb1 is running on node DB-RAC1
Instance racdb2 is running on node DB-RAC2
*/

[oracle@DB-RAC1 ~]$ srvctl config database -d racdb -a
/*
Database unique name: racdb
Database name: 
Oracle home: /opt/app/oracle/product/11.2.0.3/db_1
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
Database is enabled
Database is administrator managed
*/

[oracle@DB-RAC1 ~]$ srvctl stop database -d racdb
[oracle@DB-RAC1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is not running on node DB-RAC1
Instance racdb2 is not running on node DB-RAC2
*/

[oracle@DB-RAC1 ~]$ srvctl start database -d racdb
[oracle@DB-RAC1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node DB-RAC1
Instance racdb2 is running on node DB-RAC2
*/

[oracle@DB-RAC1 ~]$ srvctl config database -d racdb -a
/*
Database unique name: racdb
Database name: 
Oracle home: /opt/app/oracle/product/11.2.0.3/db_1
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
Database is enabled
Database is administrator managed
*/

[oracle@DB-RAC1 ~]$ srvctl modify database -d racdb -a "DATA,DATA2,ARC"
[oracle@DB-RAC1 ~]$ srvctl config database -d racdb -a
/*
Database unique name: racdb
Database name: 
Oracle home: /opt/app/oracle/product/11.2.0.3/db_1
Oracle user: oracle
Spfile: 
Domain: 
Start options: open
Stop options: immediate
Database role: PRIMARY
Management policy: AUTOMATIC
Server pools: racdb
Database instances: racdb1,racdb2
Disk Groups: DATA,DATA2,ARC
Mount point paths: 
Services: 
Type: RAC
Database is enabled
Database is administrator managed
*/

[oracle@DB-RAC1 ~]$ srvctl status listener -l listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): DB-RAC1,DB-RAC2
*/

[oracle@DB-RAC1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 25-MAY-2020 13:36:26

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                25-MAY-2020 13:29:15
Uptime                    0 days 0 hr. 7 min. 11 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/DB-RAC1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.71)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.69)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "PRIMARY" has 1 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
Service "racdbXDB" has 1 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

[oracle@DB-RAC2 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node DB-RAC1
Instance racdb2 is running on node DB-RAC2
*/
[oracle@DB-RAC2 ~]$ srvctl status listener -l listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): DB-RAC1,DB-RAC2
*/
[oracle@DB-RAC2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 25-MAY-2020 13:32:51

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                25-MAY-2020 13:29:19
Uptime                    0 days 0 hr. 3 min. 31 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/DB-RAC2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.72)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.70)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "PRIMARY" has 1 instance(s).
  Instance "racdb2", status READY, has 1 handler(s) for this service...
Service "racdbXDB" has 1 instance(s).
  Instance "racdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

[oracle@DB-RAC1/DB-RAC2 ~]$ vi /opt/app/oracle/product/11.2.0.3/db_1/network/admin/tnsnames.ora
/*
PRIMARY =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = DB-RAC-scan.mydomain.com)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = primary)
    )
  )

racdb =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = DB-RAC-scan.mydomain.com)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = racdb)
    )
  )
*/

[oracle@DB-RAC1/DB-RAC2 ~]$ tnsping primary
/*
TNS Ping Utility for Linux: Version 11.2.0.3.0 - Production on 22-JUN-2020 10:41:04

Copyright (c) 1997, 2011, Oracle.  All rights reserved.

Used parameter files:

Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = DB-RAC-scan.mydomain.com)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = primary)))
OK (0 msec)
*/

[oracle@DB-RAC1/DB-RAC2 ~]$ tnsping racdb
/*
TNS Ping Utility for Linux: Version 11.2.0.3.0 - Production on 22-JUN-2020 10:41:56

Copyright (c) 1997, 2011, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = DB-RAC-scan.mydomain.com)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = racdb)))
OK (0 msec)
*/

