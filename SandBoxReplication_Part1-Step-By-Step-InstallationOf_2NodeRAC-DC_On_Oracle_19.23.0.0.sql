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
Filesystem                 Type      Size  Used Avail Use% Mounted on
devtmpfs                   devtmpfs  9.6G     0  9.6G   0% /dev
tmpfs                      tmpfs     9.7G     0  9.7G   0% /dev/shm
tmpfs                      tmpfs     9.7G  9.3M  9.7G   1% /run
tmpfs                      tmpfs     9.7G     0  9.7G   0% /sys/fs/cgroup
/dev/mapper/ol_pdb1-root   xfs        70G  585M   70G   1% /
/dev/mapper/ol_pdb1-usr    xfs        10G  7.2G  2.9G  72% /usr
/dev/mapper/ol_pdb1-tmp    xfs        10G  104M  9.9G   2% /tmp
/dev/mapper/ol_pdb1-backup xfs        53G  411M   53G   1% /backup
/dev/mapper/ol_pdb1-home   xfs        10G  104M  9.9G   2% /home
/dev/mapper/ol_pdb1-opt    xfs        70G  740M   70G   2% /opt
/dev/sda1                  xfs      1014M  343M  672M  34% /boot
/dev/mapper/ol_pdb1-var    xfs        10G  1.1G  9.0G  11% /var
tmpfs                      tmpfs     2.0G   12K  2.0G   1% /run/user/42
tmpfs                      tmpfs     2.0G     0  2.0G   0% /run/user/0
*/

-- Step 1 -->> On both Node
[root@pdb1/pdb2 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.16.6.21   pdb1.unidev.org.np        pdb1
192.16.6.22   pdb2.unidev.org.np        pdb2

# Private
10.10.10.21   pdb1-priv.unidev.org.np   pdb1-priv
10.10.10.22   pdb2-priv.unidev.org.np   pdb2-priv

# Virtual
192.16.6.23   pdb1-vip.unidev.org.np    pdb1-vip
192.16.6.24   pdb2-vip.unidev.org.np    pdb2-vip

# SCAN
192.16.6.25   pdb-scan.unidev.org.np    pdb-scan
192.16.6.26   pdb-scan.unidev.org.np    pdb-scan
192.16.6.27   pdb-scan.unidev.org.np    pdb-scan
*/

/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.16.6.21   pdb1.unidev.org.np        pdb1
192.16.6.22   pdb2.unidev.org.np        pdb2
192.16.6.28   pdb3.unidev.org.np        pdb3

# Private
10.10.10.21   pdb1-priv.unidev.org.np   pdb1-priv
10.10.10.22   pdb2-priv.unidev.org.np   pdb2-priv
10.10.10.28   pdb3-priv.unidev.org.np   pdb3-priv

# Virtual
192.16.6.23   pdb1-vip.unidev.org.np    pdb1-vip
192.16.6.24   pdb2-vip.unidev.org.np    pdb2-vip
192.16.6.29   pdb3-vip.unidev.org.np    pdb3-vip

# SCAN
192.16.6.25   pdb-scan.unidev.org.np    pdb-scan
192.16.6.26   pdb-scan.unidev.org.np    pdb-scan
192.16.6.27   pdb-scan.unidev.org.np    pdb-scan
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
IPADDR=192.16.6.21
NETMASK=255.255.255.0
GATEWAY=192.16.6.1
DNS1=127.0.0.1
DNS2=192.16.4.11
DNS3=192.16.4.12
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
IPADDR=192.16.6.22
NETMASK=255.255.255.0
GATEWAY=192.16.6.1
DNS1=127.0.0.1
DNS2=192.16.4.11
DNS3=192.16.4.12
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
[root@pdb1/pdb2 ~]# systemctl restart NetworkManager

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
Linux pdb1/pdb2.unidev.org.np 5.4.17-2136.335.4.el8uek.x86_64 #3 SMP Thu Aug 22 12:18:30 PDT 202 4 x86_64 x86_64 x86_64 GNU/Linux
*/

-- Step 10.2 -->> On Both Node
[root@pdb1/pdb2 ~]# uname -r
/*
5.4.17-2136.334.6.1.el8uek.x86_64
*/

-- Step 10.3 -->> On Both Node
[root@pdb1/pdb2 ~]# grubby --info=ALL | grep ^kernel
/*
kernel="/boot/vmlinuz-5.4.17-2136.335.4.el8uek.x86_64"
kernel="/boot/vmlinuz-4.18.0-553.16.1.el8_10.x86_64"
kernel="/boot/vmlinuz-0-rescue-92a8e203aa7445279cb705e093783f54"
*/

-- Step 10.4 -->> On Both Node
[root@pdb1/pdb2 ~]# grubby --default-kernel
/*
/boot/vmlinuz-5.4.17-2136.335.4.el8uek.x86_64
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
        Machine ID: 92a8e203aa7445279cb705e093783f54
           Boot ID: 8a625d2c79cc4b9185cdea68758376c7
    Virtualization: vmware
  Operating System: Oracle Linux Server 8.10
       CPE OS Name: cpe:/o:oracle:linux:8:10:server
            Kernel: Linux 5.4.17-2136.335.4.el8uek.x86_64
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
        Machine ID: ba34c6ab2f0a43c0a1d8929fd921a6f0
           Boot ID: 4fbb02c05e8842e4ab3f03b78e6c2176
    Virtualization: vmware
  Operating System: Oracle Linux Server 8.10
       CPE OS Name: cpe:/o:oracle:linux:8:10:server
            Kernel: Linux 5.4.17-2136.335.4.el8uek.x86_64
      Architecture: x86-64
*/

--Note: If you are not configure proper hostname then While installation of Grid Software, 
--you have to face error CLSRSC-180: An error occurred while executing /opt/app/19c/grid/root.sh script.

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
   Active: active (running) since Wed 2024-09-25 10:44:55 +0545; 15s ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 7059 ExecStopPost=/usr/libexec/chrony-helper remove-daemon-state (code=exited, sta>
  Process: 7069 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, status=0>
  Process: 7064 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 7066 (chronyd)
    Tasks: 1 (limit: 125778)
   Memory: 904.0K
   CGroup: /system.slice/chronyd.service
           └─7066 /usr/sbin/chronyd

Sep 25 10:44:55 pdb1.unidev.org.np systemd[1]: Starting NTP client/server...
Sep 25 10:44:55 pdb1.unidev.org.np chronyd[7066]: chronyd version 4.5 starting (+CMDMON +NT>
Sep 25 10:44:55 pdb1.unidev.org.np chronyd[7066]: Loaded 0 symmetric keys
Sep 25 10:44:55 pdb1.unidev.org.np chronyd[7066]: Frequency -9.971 +/- 0.252 ppm read from >
Sep 25 10:44:55 pdb1.unidev.org.np chronyd[7066]: Using right/UTC timezone to obtain leap s>
Sep 25 10:44:55 pdb1.unidev.org.np systemd[1]: Started NTP client/server.
Sep 25 10:45:01 pdb1.unidev.org.np chronyd[7066]: Selected source 162.159.200.1 (2.pool.ntp>
Sep 25 10:45:01 pdb1.unidev.org.np chronyd[7066]: System clock TAI offset set to 37 seconds
Sep 25 10:45:05 pdb1.unidev.org.np chronyd[7066]: System clock was stepped by 0.000000 seco>
*/

-- Step 18 -->> On Both Node
[root@pdb1 ~]# cd /etc/yum.repos.d/
[root@pdb1 yum.repos.d]# ll
/*
-rw-r--r--. 1 root root 4107 May 22 16:13 oracle-linux-ol8.repo
-rw-r--r--. 1 root root  941 May 23 14:02 uek-ol8.repo
-rw-r--r--. 1 root root  243 May 23 14:02 virt-ol8.repo
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
[root@pdb1/pdb2 ~]# systemctl restart NetworkManager
[root@pdb1/pdb2 ~]# systemctl status NetworkManager
/*
● NetworkManager.service - Network Manager
   Loaded: loaded (/usr/lib/systemd/system/NetworkManager.service; enabled; vendor preset: en>
   Active: active (running) since Wed 2024-09-25 10:51:09 +0545; 17s ago
     Docs: man:NetworkManager(8)
 Main PID: 56204 (NetworkManager)
    Tasks: 3 (limit: 125778)
   Memory: 5.8M
   CGroup: /system.slice/NetworkManager.service
           └─56204 /usr/sbin/NetworkManager --no-daemon

Sep 25 10:51:09 pdb1.unidev.org.np NetworkManager[56204]: <info>  [1727240769.3671] device >
Sep 25 10:51:09 pdb1.unidev.org.np NetworkManager[56204]: <info>  [1727240769.3724] device >
Sep 25 10:51:09 pdb1.unidev.org.np NetworkManager[56204]: <info>  [1727240769.3726] device >
Sep 25 10:51:09 pdb1.unidev.org.np NetworkManager[56204]: <info>  [1727240769.3729] device >
Sep 25 10:51:09 pdb1.unidev.org.np NetworkManager[56204]: <info>  [1727240769.3733] manager>
Sep 25 10:51:09 pdb1.unidev.org.np NetworkManager[56204]: <info>  [1727240769.3737] device >
Sep 25 10:51:09 pdb1.unidev.org.np NetworkManager[56204]: <info>  [1727240769.3742] manager>
Sep 25 10:51:09 pdb1.unidev.org.np NetworkManager[56204]: <info>  [1727240769.3745] device >
Sep 25 10:51:09 pdb1.unidev.org.np NetworkManager[56204]: <info>  [1727240769.3751] device >
Sep 25 10:51:09 pdb1.unidev.org.np NetworkManager[56204]: <info>  [1727240769.3756] manager>
*/

-- Step 18.5 -->> On Both Node
[root@pdb1/pdb2 ~]# systemctl status dnsmasq
/*
● dnsmasq.service - DNS caching server.
   Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2024-09-25 10:51:09 +0545; 37s ago
 Main PID: 56191 (dnsmasq)
    Tasks: 1 (limit: 125778)
   Memory: 696.0K
   CGroup: /system.slice/dnsmasq.service
           └─56191 /usr/sbin/dnsmasq -k

Sep 25 10:51:09 pdb1.unidev.org.np dnsmasq[56191]: compile time options: IPv6 GNU-getopt DB>
Sep 25 10:51:09 pdb1.unidev.org.np dnsmasq[56191]: reading /etc/resolv.conf
Sep 25 10:51:09 pdb1.unidev.org.np dnsmasq[56191]: ignoring nameserver 127.0.0.1 - local in>
Sep 25 10:51:09 pdb1.unidev.org.np dnsmasq[56191]: using nameserver 192.16.4.11#53
Sep 25 10:51:09 pdb1.unidev.org.np dnsmasq[56191]: using nameserver 192.16.4.12#53
Sep 25 10:51:09 pdb1.unidev.org.np dnsmasq[56191]: read /etc/hosts - 11 addresses
Sep 25 10:51:09 pdb1.unidev.org.np dnsmasq[56191]: reading /etc/resolv.conf
Sep 25 10:51:09 pdb1.unidev.org.np dnsmasq[56191]: ignoring nameserver 127.0.0.1 - local in>
Sep 25 10:51:09 pdb1.unidev.org.np dnsmasq[56191]: using nameserver 192.16.4.11#53
Sep 25 10:51:09 pdb1.unidev.org.np dnsmasq[56191]: using nameserver 192.16.4.12#53
*/

-- Step 18.6 -->> On Both Node
[root@pdb1/pdb2 ~]# cat /etc/resolv.conf
/*
# Generated by NetworkManager
search cibnepal.org.np
nameserver 127.0.0.1
nameserver 192.16.4.11
nameserver 192.16.4.12
*/

-- Step 19 -->> On Node 1
[root@pdb1 ~]# nslookup 192.16.6.21
/*
21.6.16.192.in-addr.arpa        name = pdb1.unidev.org.np.
*/

-- Step 19.1 -->> On Node 1
[root@pdb1 ~]# nslookup 192.16.6.22
/*
22.6.16.192.in-addr.arpa        name = pdb2.unidev.org.np.
*/

-- Step 20 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb1
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb1.unidev.org.np
Address: 192.16.6.21
*/

-- Step 20.1 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb2
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb2.unidev.org.np
Address: 192.16.6.22
*/

-- Step 20.2 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb-scan
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb-scan.unidev.org.np
Address: 192.16.6.27
Name:   pdb-scan.unidev.org.np
Address: 192.16.6.25
Name:   pdb-scan.unidev.org.np
Address: 192.16.6.26
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
        inet 192.16.6.21  netmask 255.255.255.0  broadcast 192.16.6.255
        inet6 fe80::20c:29ff:fe59:74f2  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:59:74:f2  txqueuelen 1000  (Ethernet)
        RX packets 10069915  bytes 15149251075 (14.1 GiB)
        RX errors 0  dropped 34  overruns 0  frame 0
        TX packets 1979001  bytes 153552871 (146.4 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.21  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::250:56ff:feac:606b  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:60:6b  txqueuelen 1000  (Ethernet)
        RX packets 333  bytes 35806 (34.9 KiB)
        RX errors 0  dropped 32  overruns 0  frame 0
        TX packets 92  bytes 10570 (10.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 888  bytes 56842 (55.5 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 888  bytes 56842 (55.5 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 22.4 -->> On Node Two
[root@pdb2 ~]# ifconfig
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.16.6.22  netmask 255.255.255.0  broadcast 192.16.6.255
        inet6 fe80::20c:29ff:fece:d977  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:ce:d9:77  txqueuelen 1000  (Ethernet)
        RX packets 260120  bytes 385359181 (367.5 MiB)
        RX errors 0  dropped 15  overruns 0  frame 0
        TX packets 156232  bytes 17404930 (16.5 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.22  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::250:56ff:feac:1d97  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:1d:97  txqueuelen 1000  (Ethernet)
        RX packets 242  bytes 25456 (24.8 KiB)
        RX errors 0  dropped 14  overruns 0  frame 0
        TX packets 92  bytes 10630 (10.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 882  bytes 56477 (55.1 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 882  bytes 56477 (55.1 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/
-- Step 23 -->> On Both Node
[root@pdb1/pdb2 ~]# init 6


-- Step 24 -->> On Node One
[root@pdb1 ~]# ifconfig
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.16.6.21  netmask 255.255.255.0  broadcast 192.16.6.255
        inet6 fe80::20c:29ff:fe59:74f2  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:59:74:f2  txqueuelen 1000  (Ethernet)
        RX packets 742349  bytes 2664970074 (2.4 GiB)
        RX errors 0  dropped 31  overruns 0  frame 0
        TX packets 357551  bytes 28003909 (26.7 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.21  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::250:56ff:feac:606b  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:60:6b  txqueuelen 1000  (Ethernet)
        RX packets 51  bytes 3156 (3.0 KiB)
        RX errors 0  dropped 29  overruns 0  frame 0
        TX packets 14  bytes 992 (992.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 84  bytes 6213 (6.0 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 84  bytes 6213 (6.0 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 24.1 -->> On Node Two
[root@pdb2 ~]# ifconfig
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.16.6.22  netmask 255.255.255.0  broadcast 192.16.6.255
        inet6 fe80::20c:29ff:fece:d977  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:ce:d9:77  txqueuelen 1000  (Ethernet)
        RX packets 145  bytes 18624 (18.1 KiB)
        RX errors 0  dropped 22  overruns 0  frame 0
        TX packets 116  bytes 14094 (13.7 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.22  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::250:56ff:feac:1d97  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:1d:97  txqueuelen 1000  (Ethernet)
        RX packets 36  bytes 2256 (2.2 KiB)
        RX errors 0  dropped 21  overruns 0  frame 0
        TX packets 14  bytes 992 (992.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 94  bytes 7317 (7.1 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 94  bytes 7317 (7.1 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 24.2 -->> On Both Nodes
[root@pdb1/pdb2 ~]# ifconfig | grep -E 'UP'
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
*/

-- Step 24.3 -->> On Both Nodes
[root@pdb1 ~]# ifconfig | grep -E 'RUNNING'
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
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
   Active: active (running) since Wed 2024-09-25 10:56:09 +0545; 4min 8s ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 1387 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, status=0>
  Process: 1342 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 1373 (chronyd)
    Tasks: 1 (limit: 125778)
   Memory: 1.3M
   CGroup: /system.slice/chronyd.service
           └─1373 /usr/sbin/chronyd

Sep 25 10:56:09 pdb1.unidev.org.np systemd[1]: Starting NTP client/server...
Sep 25 10:56:09 pdb1.unidev.org.np chronyd[1373]: chronyd version 4.5 starting (+CMDMON +NT>
Sep 25 10:56:09 pdb1.unidev.org.np chronyd[1373]: Loaded 0 symmetric keys
Sep 25 10:56:09 pdb1.unidev.org.np chronyd[1373]: Frequency -10.109 +/- 0.929 ppm read from>
Sep 25 10:56:09 pdb1.unidev.org.np chronyd[1373]: Using right/UTC timezone to obtain leap s>
Sep 25 10:56:09 pdb1.unidev.org.np systemd[1]: Started NTP client/server.
Sep 25 10:56:14 pdb1.unidev.org.np chronyd[1373]: Selected source 162.159.200.123 (2.pool.n>
Sep 25 10:56:14 pdb1.unidev.org.np chronyd[1373]: System clock TAI offset set to 37 seconds
*/

-- Step 31 -->> On Both Node
[root@pdb1/pdb2 ~]# systemctl status dnsmasq
/*
● dnsmasq.service - DNS caching server.
   Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2024-09-25 10:56:09 +0545; 4min 25s ago
 Main PID: 1270 (dnsmasq)
    Tasks: 1 (limit: 125778)
   Memory: 1.3M
   CGroup: /system.slice/dnsmasq.service
           └─1270 /usr/sbin/dnsmasq -k

Sep 25 10:56:09 pdb1.unidev.org.np dnsmasq[1270]: compile time options: IPv6 GNU-getopt DBu>
Sep 25 10:56:09 pdb1.unidev.org.np dnsmasq[1270]: reading /etc/resolv.conf
Sep 25 10:56:09 pdb1.unidev.org.np dnsmasq[1270]: ignoring nameserver 127.0.0.1 - local int>
Sep 25 10:56:09 pdb1.unidev.org.np dnsmasq[1270]: using nameserver 192.16.4.11#53
Sep 25 10:56:09 pdb1.unidev.org.np dnsmasq[1270]: using nameserver 192.16.4.12#53
Sep 25 10:56:09 pdb1.unidev.org.np dnsmasq[1270]: read /etc/hosts - 11 addresses
Sep 25 10:56:09 pdb1.unidev.org.np dnsmasq[1270]: reading /etc/resolv.conf
Sep 25 10:56:09 pdb1.unidev.org.np dnsmasq[1270]: ignoring nameserver 127.0.0.1 - local int>
Sep 25 10:56:09 pdb1.unidev.org.np dnsmasq[1270]: using nameserver 192.16.4.11#53
Sep 25 10:56:09 pdb1.unidev.org.np dnsmasq[1270]: using nameserver 192.16.4.12#53
*/

-- Step 31.1 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup 192.16.6.21
/*
21.6.16.192.in-addr.arpa        name = pdb1.unidev.org.np.
*/

-- Step 31.2 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup 192.16.6.22
/*
22.6.16.192.in-addr.arpa        name = pdb2.unidev.org.np.
*/

-- Step 31.3 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb1
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb1.unidev.org.np
Address: 192.16.6.21
*/

-- Step 31.4 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb2
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb2.unidev.org.np
Address: 192.16.6.22
*/

-- Step 31.5 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb-scan
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb-scan.unidev.org.np
Address: 192.16.6.27
Name:   pdb-scan.unidev.org.np
Address: 192.16.6.25
Name:   pdb-scan.unidev.org.np
Address: 192.16.6.26
*/

-- Step 31.6 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb2-vip
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb2-vip.unidev.org.np
Address: 192.16.6.24
*/

-- Step 31.7 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb1-vip
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb1-vip.unidev.org.np
Address: 192.16.6.23
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
[root@pdb1/pdb2 yum.repos.d]# dnf install -y oracle-database-preinstall-19c

-- Step 32.2 -->> On Both Node
[root@pdb1/pdb2 yum.repos.d]# dnf install -y bc
[root@pdb1/pdb2 yum.repos.d]# dnf install -y binutils
[root@pdb1/pdb2 yum.repos.d]# dnf install -y compat-libcap1
[root@pdb1/pdb2 yum.repos.d]# dnf install -y compat-libstdc++-33
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
[root@pdb1/pdb2 yum.repos.d]# dnf install -y make
[root@pdb1/pdb2 yum.repos.d]# dnf install -y net-tools
[root@pdb1/pdb2 yum.repos.d]# dnf install -y nfs-utils
[root@pdb1/pdb2 yum.repos.d]# dnf install -y python
[root@pdb1/pdb2 yum.repos.d]# dnf install -y python-configshell
[root@pdb1/pdb2 yum.repos.d]# dnf install -y python-rtslib
[root@pdb1/pdb2 yum.repos.d]# dnf install -y python-six
[root@pdb1/pdb2 yum.repos.d]# dnf install -y targetcli
[root@pdb1/pdb2 yum.repos.d]# dnf install -y smartmontools
[root@pdb1/pdb2 yum.repos.d]# dnf install -y sysstat
[root@pdb1/pdb2 yum.repos.d]# dnf install -y unixODBC
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libnsl
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libnsl.i686
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libnsl2
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libnsl2.i686
[root@pdb1/pdb2 yum.repos.d]# dnf install -y chrony
[root@pdb1/pdb2 yum.repos.d]# dnf install -y unixODBC
[root@pdb1/pdb2 yum.repos.d]# dnf -y update

-- Step 32.3 -->> On Both Node
[root@pdb1/pdb2 ~]# cd /tmp
--Bug 29772579
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libcap1-1.10-7.el7.i686.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libcap1-1.10-7.el7.x86_64.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libstdc++-33-3.2.3-72.el7.i686.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm

-- Step 32.4 -->> On Both Node
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/elfutils-libelf-devel-0.189-3.el8.i686.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/elfutils-libelf-devel-0.189-3.el8.x86_64.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/numactl-2.0.12-13.el8.x86_64.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/numactl-devel-2.0.12-13.el8.x86_64.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/numactl-devel-2.0.12-13.el8.i686.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/python3-libs-3.6.8-56.0.1.el8_9.i686.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/python3-libs-3.6.8-56.0.1.el8_9.x86_64.rpm

/* -- On Physical Server (If the ASMLib-8 we installed)
https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=364500837732007&id=2789052.1&_adf.ctrl-state=11vbxw8jk2_58

--OL8/RHEL8: ASMLib: root.sh is failing with CRS-1705: Found 0 Configured Voting Files But 1 Voting Files Are Required (Doc ID 2789052.1)
Bug 32410237 - oracleasm configure -p not discovering disks on RHEL8
Bug 32812376 - ROOT.SH IS FAILING WTH THE ERRORS CLSRSC-119: START OF THE EXCLUSIVE MODE CLUSTER FAILED
*/

--[root@pdb1/pdb2 tmp]# wget https://download.oracle.com/otn_software/asmlib/oracleasmlib-2.0.17-1.el8.x86_64.rpm
--[root@pdb1/pdb2 tmp]# wget https://public-yum.oracle.com/repo/OracleLinux/OL8/addons/x86_64/getPackage/oracleasm-support-2.1.12-1.el8.x86_64.rpm

-- Step 32.5 -->> On Both Node
[root@pdb1/pdb2 tmp]# wget https://download.oracle.com/otn_software/asmlib/oracleasmlib-2.0.12-1.el7.x86_64.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/oracleasm-support-2.1.11-2.el7.x86_64.rpm

-- Step 32.6 -->> On Both Node
--Bug 29772579
[root@pdb1/pdb2 tmp]# yum -y localinstall ./compat-libcap1-1.10-7.el7.i686.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./compat-libcap1-1.10-7.el7.x86_64.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./compat-libstdc++-33-3.2.3-72.el7.i686.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm

-- Step 33 -->> On Both Node
[root@pdb1/pdb2 tmp]# yum -y localinstall ./elfutils-libelf-devel-0.189-3.el8.i686.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./elfutils-libelf-devel-0.189-3.el8.x86_64.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./numactl-2.0.12-13.el8.x86_64.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./numactl-devel-2.0.12-13.el8.i686.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./numactl-devel-2.0.12-13.el8.x86_64.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./python3-libs-3.6.8-56.0.1.el8_9.i686.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./python3-libs-3.6.8-56.0.1.el8_9.x86_64.rpm

--[root@pdb1/pdb2 tmp]# yum -y localinstall ./oracleasm-support-2.1.12-1.el8.x86_64.rpm ./oracleasmlib-2.0.17-1.el8.x86_64.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./oracleasm-support-2.1.11-2.el7.x86_64.rpm ./oracleasmlib-2.0.12-1.el7.x86_64.rpm
[root@pdb1/pdb2 tmp]# rm -rf *.rpm

-- Step 34 -->> On Both Node
[root@pdb1/pdb2 ~]# cd /etc/yum.repos.d/
[root@pdb1/pdb2 yum.repos.d]# dnf -y install compat-libcap1 compat-libstdc++-33 bc binutils elfutils-libelf elfutils-libelf-devel fontconfig-devel glibc glibc-devel ksh libaio libaio-devel libgcc libnsl librdmacm-devel libstdc++ libstdc++-devel libX11 libXau libxcb libXi libXrender libXrender-devel libXtst make net-tools nfs-utils python3 python3-configshell python3-rtslib python3-six smartmontools sysstat targetcli unzip
[root@pdb1/pdb2 yum.repos.d]# dnf -y install bash bc bind-utils binutils ethtool glibc glibc-devel initscripts ksh libaio libaio-devel libgcc libnsl libstdc++ libstdc++-devel make module-init-tools net-tools nfs-utils openssh-clients openssl-libs pam procps psmisc smartmontools sysstat tar unzip util-linux-ng xorg-x11-utils xorg-x11-xauth 
[root@pdb1/pdb2 yum.repos.d]# dnf -y update

-- Step 35 -->> On Both Node
[root@pdb1/pdb2 yum.repos.d]# rpm -q binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel elfutils-libelf-devel-static \
[root@pdb1/pdb2 yum.repos.d]# rpm -q gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers kernel-headers ksh libaio libaio-devel \
[root@pdb1/pdb2 yum.repos.d]# rpm -q libgcc libgomp libstdc++ libstdc++-devel make numactl-devel sysstat unixODBC unixODBC-devel \

-- Step 36.3 -->> On Both Node
[root@pdb1/pdb2 ~]# rpm -qa | grep oracleasm
/*
oracleasmlib-2.0.12-1.el7.x86_64
oracleasm-support-2.1.11-2.el7.x86_64
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
[root@pdb1/pdb2 ~]# vi /etc/security/limits.d/oracle-database-preinstall-19c.conf
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
oracle:x:1000:
*/

-- Step 40.3 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i oper
/*
oper:x:54323:
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
[root@pdb1/pdb2 ~]# mkdir -p /opt/app/19c/grid
[root@pdb1/pdb2 ~]# chown -R grid:oinstall /opt/app/19c/grid
[root@pdb1/pdb2 ~]# chmod -R 775 /opt/app/19c/grid

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
ORACLE_HOME=$ORACLE_BASE/product/19c/db_1; export ORACLE_HOME
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
GRID_HOME=/opt/app/19c/grid; export GRID_HOME
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
ORACLE_HOME=$ORACLE_BASE/product/19c/db_1; export ORACLE_HOME
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
GRID_HOME=/opt/app/19c/grid; export GRID_HOME
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
[root@pdb1 ~]# cd /opt/app/19c/grid/
[root@pdb1 grid]# unzip -oq /root/Oracle_19C/19.3.0.0.0_Grid_Binary/LINUX.X64_193000_grid_home.zip
[root@pdb1 grid]# unzip -oq /root/Oracle_19C/OPATCH_19c/p6880880_190000_Linux-x86-64.zip

-- Step 55 -->> On Node 1
-- To Unzio The Oracle PSU
[root@pdb1 ~]# cd /tmp/
[root@pdb1 tmp]# unzip -oq /root/Oracle_19C/PSU_19.23.0.0.0/p36209493_190000_Linux-x86-64.zip
[root@pdb1 tmp]# chown -R oracle:oinstall 36209493
[root@pdb1 tmp]# chmod -R 775 36209493
[root@pdb1 tmp]# ls -ltr | grep 36209493
/*
drwxrwxr-x  4 oracle oinstall      80 Apr 16 16:14 36209493
*/

-- Step 56 -->> On Node 1
-- Login as root user and issue the following command at pdb1
[root@pdb1 ~]# chown -R grid:oinstall /opt/app/19c/grid/
[root@pdb1 ~]# chmod -R 775 /opt/app/19c/grid/

[root@pdb1 tmp]# su - grid
[grid@pdb1 ~]$ cd /opt/app/19c/grid/OPatch/
[grid@pdb1 OPatch]$ ./opatch version
/*
OPatch Version: 12.2.0.1.43

OPatch succeeded.
*/

-- Step 57 -->> On Node 1
[root@pdb1 ~]# scp -r /opt/app/19c/grid/cv/rpm/cvuqdisk-1.0.10-1.rpm root@pdb2:/tmp/
/*
The authenticity of host 'pdb2 (192.16.6.22)' can't be established.
ECDSA key fingerprint is SHA256:6NantI4crKoxtXNREfhRZ4fxdEyl+3gYXHw3Es23exU.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'pdb2,192.16.6.22' (ECDSA) to the list of known hosts.
root@pdb2's password: P@ssw0rd
cvuqdisk-1.0.10-1.rpm                                      100%   11KB   6.3MB/s   00:00
*/

-- Step 58 -->> On Node 1
-- To install the cvuqdisk-1.0.10-1.rpm
-- Login from root user
[root@pdb1 ~]# cd /opt/app/19c/grid/cv/rpm/

-- Step 58.1 -->> On Node 1
[root@pdb1 rpm]# ls -ltr
/*
-rwxrwxr-x 1 grid oinstall 11412 Mar 13  2019 cvuqdisk-1.0.10-1.rpm
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
-rwxrwxr-x  1 grid oinstall 11412 Sep 25 12:34 cvuqdisk-1.0.10-1.rpm
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
-rwxr-xr-x  1 root root  4954 Feb  3  2018 oracleasm
-rwx------  1 root root  1281 Feb 17  2021 oracle-database-preinstall-19c-firstboot
-rw-r--r--. 1 root root 18434 Aug 10  2022 functions
-rw-r--r--. 1 root root  1161 Jun  5 18:53 README
*/

-- Step 70 -->> On Both Node
[root@pdb1/pdb2 ~]# ll /dev/oracleasm/disks/
/*
total 0
*/

-- Step 71 -->> On Both Node
[root@pdb1/pdb2 ~]# ll /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Sep 29 12:21 /dev/sda
brw-rw---- 1 root disk 8,  1 Sep 29 12:21 /dev/sda1
brw-rw---- 1 root disk 8,  2 Sep 29 12:21 /dev/sda2
brw-rw---- 1 root disk 8, 16 Sep 29 12:21 /dev/sdb
brw-rw---- 1 root disk 8, 32 Sep 29 12:21 /dev/sdc
brw-rw---- 1 root disk 8, 48 Sep 29 12:21 /dev/sdd
*/

--Step 71.1 -->> Both Node
[root@pdb1 ~]# lsblk
/*
NAME               MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                  8:0    0  250G  0 disk
├─sda1               8:1    0    1G  0 part /boot
└─sda2               8:2    0  249G  0 part
  ├─ol_pdb1-root   252:0    0   70G  0 lvm  /
  ├─ol_pdb1-swap   252:1    0   16G  0 lvm  [SWAP]
  ├─ol_pdb1-usr    252:2    0   10G  0 lvm  /usr
  ├─ol_pdb1-opt    252:3    0   70G  0 lvm  /opt
  ├─ol_pdb1-home   252:4    0   10G  0 lvm  /home
  ├─ol_pdb1-var    252:5    0   10G  0 lvm  /var
  ├─ol_pdb1-tmp    252:6    0   10G  0 lvm  /tmp
  └─ol_pdb1-backup 252:7    0   53G  0 lvm  /backup
sdb                  8:16   0   20G  0 disk
sdc                  8:32   0  400G  0 disk
sdd                  8:48   0  200G  0 disk
sr0                 11:0    1  891M  0 rom
*/

-- Step 72 -->> On Node 1
[root@pdb1 ~]# fdisk -ll | grep GiB | grep sd
/*
Disk /dev/sda: 250 GiB, 268435456000 bytes, 524288000 sectors
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
Disk /dev/sdc: 400 GiB, 429496729600 bytes, 838860800 sectors
Disk /dev/sdd: 200 GiB, 214748364800 bytes, 419430400 sectors
*/

-- Step 73 -->> On Node 1
[root@pdb1 ~]# fdisk /dev/sdb
/*
Welcome to fdisk (util-linux 2.32.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x4893ff68.

Command (m for help): p
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x4893ff68

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
Disk identifier: 0x4893ff68

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
Created a new DOS disklabel with disk identifier 0xb86fb82c.

Command (m for help): p
Disk /dev/sdc: 400 GiB, 429496729600 bytes, 838860800 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xb86fb82c

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
Disk identifier: 0xb86fb82c

Device     Boot Start       End   Sectors  Size Id Type
/dev/sdc1        2048 838860799 838858752  400G 83 Linux

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
Created a new DOS disklabel with disk identifier 0xfa4d0ae9.

Command (m for help): p
Disk /dev/sdd: 200 GiB, 214748364800 bytes, 419430400 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xfa4d0ae9

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
Disk identifier: 0xfa4d0ae9

Device     Boot Start       End   Sectors  Size Id Type
/dev/sdd1        2048 419430399 419428352  200G 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 76 -->> On Node 1
[root@pdb1 ~]# ll /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Sep 29 12:21 /dev/sda
brw-rw---- 1 root disk 8,  1 Sep 29 12:21 /dev/sda1
brw-rw---- 1 root disk 8,  2 Sep 29 12:21 /dev/sda2
brw-rw---- 1 root disk 8, 16 Sep 29 14:20 /dev/sdb
brw-rw---- 1 root disk 8, 17 Sep 29 14:20 /dev/sdb1
brw-rw---- 1 root disk 8, 32 Sep 29 14:21 /dev/sdc
brw-rw---- 1 root disk 8, 33 Sep 29 14:21 /dev/sdc1
brw-rw---- 1 root disk 8, 48 Sep 29 14:21 /dev/sdd
brw-rw---- 1 root disk 8, 49 Sep 29 14:21 /dev/sdd1
*/

-- Step 77 -->> On Both Node
[root@pdb1/pdb2 ~]# fdisk -ll | grep sd
/*
Disk /dev/sda: 250 GiB, 268435456000 bytes, 524288000 sectors
/dev/sda1  *       2048   2099199   2097152    1G 83 Linux
/dev/sda2       2099200 524287999 522188800  249G 8e Linux LVM
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
/dev/sdb1        2048 41943039 41940992  20G 83 Linux
Disk /dev/sdc: 400 GiB, 429496729600 bytes, 838860800 sectors
/dev/sdc1        2048 838860799 838858752  400G 83 Linux
Disk /dev/sdd: 200 GiB, 214748364800 bytes, 419430400 sectors
/dev/sdd1        2048 419430399 419428352  200G 83 Linux
*/

-- Step 77.1 -->> On Both Node
[root@pdb1 ~]# lsblk
/*
NAME               MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                  8:0    0  250G  0 disk
├─sda1               8:1    0    1G  0 part /boot
└─sda2               8:2    0  249G  0 part
  ├─ol_pdb1-root   252:0    0   70G  0 lvm  /
  ├─ol_pdb1-swap   252:1    0   16G  0 lvm  [SWAP]
  ├─ol_pdb1-usr    252:2    0   10G  0 lvm  /usr
  ├─ol_pdb1-opt    252:3    0   70G  0 lvm  /opt
  ├─ol_pdb1-home   252:4    0   10G  0 lvm  /home
  ├─ol_pdb1-var    252:5    0   10G  0 lvm  /var
  ├─ol_pdb1-tmp    252:6    0   10G  0 lvm  /tmp
  └─ol_pdb1-backup 252:7    0   53G  0 lvm  /backup
sdb                  8:16   0   20G  0 disk
└─sdb1               8:17   0   20G  0 part
sdc                  8:32   0  400G  0 disk
└─sdc1               8:33   0  400G  0 part
sdd                  8:48   0  200G  0 disk
└─sdd1               8:49   0  200G  0 part
sr0                 11:0    1  891M  0 rom
*/

-- Step 78 -->> On Node 1
[root@pdb1 ~]# mkfs.xfs -f /dev/sdb1
[root@pdb1 ~]# mkfs.xfs -f /dev/sdc1
[root@pdb1 ~]# mkfs.xfs -f /dev/sdd1

-- Step 79 -->> On Node 1
[root@pdb1 ~]# oracleasm createdisk OCR /dev/sdb1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 80 -->> On Node 1
[root@pdb1 ~]# oracleasm createdisk DATA /dev/sdd1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 81 -->> On Node 1
[root@pdb1 ~]# oracleasm createdisk ARC /dev/sdc1
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
[root@pdb1/pdb2 ~]# ll /dev/oracleasm/disks/
/*
brw-rw---- 1 grid asmadmin 8, 33 Sep 29 14:24 ARC
brw-rw---- 1 grid asmadmin 8, 49 Sep 29 14:24 DATA
brw-rw---- 1 grid asmadmin 8, 17 Sep 29 14:24 OCR
*/

-- Step 87 -->> On Node 1
-- To setup SSH Pass
[root@pdb1 ~]# su - grid
[grid@pdb1 ~]$ cd /opt/app/19c/grid/deinstall
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
-- Bug 30286976: To Solve the Pre-check or any Oracle relavant Installation for rac Setup make compatible version CV_ASSUME_DISTID=OEL7.6
[grid@pdb1 ~]$ vi /opt/app/19c/grid/cv/admin/cvu_config
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

-- Step 89.1 -->> On Node 1
[grid@pdb1 ~]$ cat /opt/app/19c/grid/cv/admin/cvu_config | grep -E CV_ASSUME_DISTID
/*
CV_ASSUME_DISTID=OEL7.6
*/

-- Step 89.2 -->> On Node 1
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
[root@pdb1 ~]# cp -p /usr/bin/scp /usr/bin/scp-original

-- Step 89.3 -->> On Node 1
[root@pdb1 ~]# echo "/usr/bin/scp-original -T \$*" > /usr/bin/scp

-- Step 89.4 -->> On Node 1
[root@pdb1 ~]# cat /usr/bin/scp
/*
/usr/bin/scp-original -T $*
*/

-- Step 89.5 -->> On Node 1
-- Pre-check for rac Setup
[grid@pdb1 ~]$ cd /opt/app/19c/grid/
[grid@pdb1 grid]$ export CV_ASSUME_DISTID=OEL7.6
[grid@pdb1 grid]$ ./runcluvfy.sh stage -pre crsinst -n pdb1,pdb2 -verbose
[grid@pdb1 grid]$ export CV_ASSUME_DISTID=OEL7.6
[grid@pdb1 grid]$ ./runcluvfy.sh stage -pre crsinst -n pdb1,pdb2 -method root
--[grid@pdb1 grid]$ ./runcluvfy.sh stage -pre crsinst -n pdb1,pdb2 -fixup -verbose (If Required)

-- Step 90 -->> On Node 1
-- To Create a Response File to Install GID
[grid@pdb1 ~]$ cp /opt/app/19c/grid/install/response/gridsetup.rsp /home/grid/
[grid@pdb1 ~]$ cd /home/grid/
[grid@pdb1 ~]$ ls -ltr | grep gridsetup.rsp
/*
-rwxr-xr-x 1 grid oinstall 36221 Sep 29 14:33 gridsetup.rsp
*/

-- Step 90.1 -->> On Node 1
[grid@pdb1 ~]$ vi gridsetup.rsp
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
oracle.install.crs.config.gpnp.scanName=pdb-scan
oracle.install.crs.config.gpnp.scanPort=1521
oracle.install.crs.config.ClusterConfiguration=STANDALONE
oracle.install.crs.config.configureAsExtendedCluster=false
oracle.install.crs.config.clusterName=pdb-cluster
oracle.install.crs.config.gpnp.configureGNS=false
oracle.install.crs.config.autoConfigureClusterNodeVIP=false
oracle.install.crs.config.clusterNodes=pdb1:pdb1-vip,pdb2:pdb2-vip
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

-- Step 90.2 -->> On Node 1
[grid@pdb1 ~]$ cd /opt/app/19c/grid/
[grid@pdb1 grid]$ OPatch/opatch version
/*
OPatch Version: 12.2.0.1.43

OPatch succeeded.
*/

-- Step 91 -->> On Node 1
-- To Install Grid Software with Leteset Opatch
[grid@pdb1 ~]$ cd /opt/app/19c/grid/
[grid@pdb1 grid]$ export CV_ASSUME_DISTID=OEL7.6
[grid@pdb1 grid]$ ./gridSetup.sh -ignorePrereq -waitForCompletion -silent -applyRU /tmp/36209493/36233126 -responseFile /home/grid/gridsetup.rsp
/*
Preparing the home to patch...
Applying the patch /tmp/36209493/36233126...
Successfully applied the patch.
The log can be found at: /tmp/GridSetupActions2024-09-29_02-41-09PM/installerPatchActions_2024-09-29_02-41-09PM.log
Launching Oracle Grid Infrastructure Setup Wizard...

[WARNING] [INS-13014] Target environment does not meet some optional requirements.
   CAUSE: Some of the optional prerequisites are not met. See logs for details. gridSetupActions2024-09-29_02-41-09PM.log
   ACTION: Identify the list of failed prerequisite checks from the log: gridSetupActions2024-09-29_02-41-09PM.log. Then either from the log file or from installation manual find the appropriate configuration to meet the prerequisites and fix it manually.
The response file for this session can be found at:
 /opt/app/19c/grid/install/response/grid_2024-09-29_02-41-09PM.rsp

You can find the log of this install session at:
 /tmp/GridSetupActions2024-09-29_02-41-09PM/gridSetupActions2024-09-29_02-41-09PM.log

As a root user, execute the following script(s):
        1. /opt/app/oraInventory/orainstRoot.sh
        2. /opt/app/19c/grid/root.sh

Execute /opt/app/oraInventory/orainstRoot.sh on the following nodes:
[pdb1, pdb2]
Execute /opt/app/19c/grid/root.sh on the following nodes:
[pdb1, pdb2]

Run the script on the local node first. After successful completion, you can start the script in parallel on all other nodes.

Successfully Setup Software with warning(s).
As install user, execute the following command to complete the configuration.
        /opt/app/19c/grid/gridSetup.sh -executeConfigTools -responseFile /home/grid/gridsetup.rsp [-silent]


Moved the install session logs to:
 /opt/app/oraInventory/logs/GridSetupActions2024-09-29_02-41-09PM
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
[root@pdb1 ~]# /opt/app/19c/grid/root.sh
/*
Check /opt/app/19c/grid/install/root_pdb1.unidev.org.np_2024-09-29_15-04-06-103478347.log for the output of root script
*/

-- Step 94.1 -->> On Node 1
[root@pdb1 ~]#  tail -f /opt/app/19c/grid/install/root_pdb1.unidev.org.np_2024-09-29_15-04-06-103478347.log
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
  /opt/app/oracle/crsdata/pdb1/crsconfig/rootcrs_pdb1_2024-09-29_03-04-27PM.log
2024/09/29 15:04:40 CLSRSC-594: Executing installation step 1 of 19: 'ValidateEnv'.
2024/09/29 15:04:40 CLSRSC-363: User ignored prerequisites during installation
2024/09/29 15:04:40 CLSRSC-594: Executing installation step 2 of 19: 'CheckFirstNode'.
2024/09/29 15:04:43 CLSRSC-594: Executing installation step 3 of 19: 'GenSiteGUIDs'.
2024/09/29 15:04:44 CLSRSC-594: Executing installation step 4 of 19: 'SetupOSD'.
Redirecting to /bin/systemctl restart rsyslog.service
2024/09/29 15:04:45 CLSRSC-594: Executing installation step 5 of 19: 'CheckCRSConfig'.
2024/09/29 15:04:45 CLSRSC-594: Executing installation step 6 of 19: 'SetupLocalGPNP'.
2024/09/29 15:05:02 CLSRSC-594: Executing installation step 7 of 19: 'CreateRootCert'.
2024/09/29 15:05:09 CLSRSC-594: Executing installation step 8 of 19: 'ConfigOLR'.
2024/09/29 15:05:29 CLSRSC-594: Executing installation step 9 of 19: 'ConfigCHMOS'.
2024/09/29 15:05:29 CLSRSC-594: Executing installation step 10 of 19: 'CreateOHASD'.
2024/09/29 15:05:37 CLSRSC-594: Executing installation step 11 of 19: 'ConfigOHASD'.
2024/09/29 15:05:37 CLSRSC-330: Adding Clusterware entries to file 'oracle-ohasd.service'
2024/09/29 15:06:06 CLSRSC-594: Executing installation step 12 of 19: 'SetupTFA'.
2024/09/29 15:06:06 CLSRSC-594: Executing installation step 13 of 19: 'InstallAFD'.
2024/09/29 15:06:06 CLSRSC-594: Executing installation step 14 of 19: 'InstallACFS'.
2024/09/29 15:06:58 CLSRSC-594: Executing installation step 15 of 19: 'InstallKA'.
2024/09/29 15:07:06 CLSRSC-594: Executing installation step 16 of 19: 'InitConfig'.

ASM has been created and started successfully.

[DBT-30001] Disk groups created successfully. Check /opt/app/oracle/cfgtoollogs/asmca/asmca-240929PM030738.log for details.

2024/09/29 15:08:30 CLSRSC-482: Running command: '/opt/app/19c/grid/bin/ocrconfig -upgrade grid oinstall'
CRS-4256: Updating the profile
Successful addition of voting disk 6aae9ad6f91c4fc3bf3a2ef650d0a7dd.
Successfully replaced voting disk group with +OCR.
CRS-4256: Updating the profile
CRS-4266: Voting file(s) successfully replaced
##  STATE    File Universal Id                File Name Disk group
--  -----    -----------------                --------- ---------
 1. ONLINE   6aae9ad6f91c4fc3bf3a2ef650d0a7dd (/dev/oracleasm/disks/OCR) [OCR]
Located 1 voting disk(s).
2024/09/29 15:09:53 CLSRSC-594: Executing installation step 17 of 19: 'StartCluster'.
2024/09/29 15:09:53 CLSRSC-4002: Successfully installed Oracle Trace File Analyzer (TFA) Collector.
2024/09/29 15:10:59 CLSRSC-343: Successfully started Oracle Clusterware stack
2024/09/29 15:11:00 CLSRSC-594: Executing installation step 18 of 19: 'ConfigNode'.
2024/09/29 15:12:34 CLSRSC-594: Executing installation step 19 of 19: 'PostConfig'.
2024/09/29 15:13:05 CLSRSC-325: Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 95 -->> On Node 2
[root@pdb2 ~]# /opt/app/19c/grid/root.sh
/*
Check /opt/app/19c/grid/install/root_pdb2.unidev.org.np_2024-09-29_15-15-12-769765229.log for the output of root script
*/

-- Step 95.1 -->> On Node 2 
[root@pdb2 ~]# tail -f /opt/app/19c/grid/install/root_pdb2.unidev.org.np_2024-09-29_15-15-12-769765229.log
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
  /opt/app/oracle/crsdata/pdb2/crsconfig/rootcrs_pdb2_2024-09-29_03-15-38PM.log
2024/09/29 15:15:44 CLSRSC-594: Executing installation step 1 of 19: 'ValidateEnv'.
2024/09/29 15:15:44 CLSRSC-363: User ignored prerequisites during installation
2024/09/29 15:15:44 CLSRSC-594: Executing installation step 2 of 19: 'CheckFirstNode'.
2024/09/29 15:15:46 CLSRSC-594: Executing installation step 3 of 19: 'GenSiteGUIDs'.
2024/09/29 15:15:46 CLSRSC-594: Executing installation step 4 of 19: 'SetupOSD'.
Redirecting to /bin/systemctl restart rsyslog.service
2024/09/29 15:15:46 CLSRSC-594: Executing installation step 5 of 19: 'CheckCRSConfig'.
2024/09/29 15:15:47 CLSRSC-594: Executing installation step 6 of 19: 'SetupLocalGPNP'.
2024/09/29 15:15:48 CLSRSC-594: Executing installation step 7 of 19: 'CreateRootCert'.
2024/09/29 15:15:48 CLSRSC-594: Executing installation step 8 of 19: 'ConfigOLR'.
2024/09/29 15:16:02 CLSRSC-594: Executing installation step 9 of 19: 'ConfigCHMOS'.
2024/09/29 15:16:02 CLSRSC-594: Executing installation step 10 of 19: 'CreateOHASD'.
2024/09/29 15:16:04 CLSRSC-594: Executing installation step 11 of 19: 'ConfigOHASD'.
2024/09/29 15:16:04 CLSRSC-330: Adding Clusterware entries to file 'oracle-ohasd.service'
2024/09/29 15:16:28 CLSRSC-594: Executing installation step 12 of 19: 'SetupTFA'.
2024/09/29 15:16:28 CLSRSC-594: Executing installation step 13 of 19: 'InstallAFD'.
2024/09/29 15:16:28 CLSRSC-594: Executing installation step 14 of 19: 'InstallACFS'.
2024/09/29 15:17:12 CLSRSC-594: Executing installation step 15 of 19: 'InstallKA'.
2024/09/29 15:17:13 CLSRSC-594: Executing installation step 16 of 19: 'InitConfig'.
2024/09/29 15:17:22 CLSRSC-594: Executing installation step 17 of 19: 'StartCluster'.
2024/09/29 15:18:02 CLSRSC-343: Successfully started Oracle Clusterware stack
2024/09/29 15:18:02 CLSRSC-594: Executing installation step 18 of 19: 'ConfigNode'.
2024/09/29 15:18:21 CLSRSC-594: Executing installation step 19 of 19: 'PostConfig'.
2024/09/29 15:18:31 CLSRSC-325: Configure Oracle Grid Infrastructure for a Cluster ... succeeded
2024/09/29 15:19:53 CLSRSC-4002: Successfully installed Oracle Trace File Analyzer (TFA) Collector.
*/

-- Step 96 -->> On Node 1
[grid@pdb1 ~]$ cd /opt/app/19c/grid/
[grid@pdb1 grid]$ export CV_ASSUME_DISTID=OEL7.6
[grid@pdb1 grid]$ /opt/app/19c/grid/gridSetup.sh -silent -executeConfigTools -responseFile /home/grid/gridsetup.rsp
/*
Launching Oracle Grid Infrastructure Setup Wizard...

You can find the logs of this session at:
/opt/app/oraInventory/logs/GridSetupActions2024-09-29_03-21-30PM

You can find the log of this install session at:
 /opt/app/oraInventory/logs/UpdateNodeList2024-09-29_03-21-30PM.log
Successfully Configured Software.
*/

-- Step 96.1 -->> On Node 1
[root@pdb1 ~]# tail -f /opt/app/oraInventory/logs/UpdateNodeList2024-09-18_12-17-38PM.log
/*
INFO: Command execution completes for node : pdb2
INFO: Command execution sucess for node : pdb2
INFO: All threads completed its operations
INFO: Checkpoint:Index file written and updated
INFO: Done calling doOperation.
INFO: 'UpdateNodeList' was successful.
*/

-- Step 97 -->> On Both Nodes
[root@pdb1/pdb2 ~]# cd /opt/app/19c/grid/bin/
[root@pdb1/pdb2 bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/


-- Step 98 -->> On Both Nodes
[root@pdb1/pdb2 ~]# cd /opt/app/19c/grid/bin/
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
[root@pdb1 ~]# cd /opt/app/19c/grid/bin/
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
ora.drivers.acfs
      1        ONLINE  ONLINE       pdb1                     STABLE
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
[root@pdb2 ~]# cd /opt/app/19c/grid/bin/
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
ora.drivers.acfs
      1        ONLINE  ONLINE       pdb2                     STABLE
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
[root@pdb1/pdb2 ~]# cd /opt/app/19c/grid/bin/
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
ora.proxy_advm
               OFFLINE OFFLINE      pdb1                     STABLE
               OFFLINE OFFLINE      pdb2                     STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     Started,STABLE
      2        ONLINE  ONLINE       pdb2                     Started,STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.cvu
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.pdb1.vip
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.pdb2.vip
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.qosmserver
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.scan3.vip
      1        ONLINE  ONLINE       pdb1                     STABLE
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
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 29-SEP-2024 15:29:40

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                29-SEP-2024 15:12:55
Uptime                    0 days 0 hr. 16 min. 45 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.21)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.23)(PORT=1521)))
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
grid       53939       1  0 15:12 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid       53956       1  0 15:12 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid      100839   99485  0 15:30 pts/1    00:00:00 grep --color=auto SCAN
*/

-- Step 103.2 -->> On Node 1
[grid@pdb1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 29-SEP-2024 15:30:24

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                29-SEP-2024 15:12:16
Uptime                    0 days 0 hr. 18 min. 7 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.26)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 103.3 -->> On Node 1
[grid@pdb1 ~]$ lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 29-SEP-2024 15:31:13

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                29-SEP-2024 15:12:18
Uptime                    0 days 0 hr. 18 min. 55 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener_scan3/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN3)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.27)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 103.4 -->> On Node 2
[grid@pdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 29-SEP-2024 15:29:48

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                29-SEP-2024 15:18:27
Uptime                    0 days 0 hr. 11 min. 21 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.22)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.24)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 103.5 -->> On Node 2
[grid@pdb2 ~]$ ps -ef | grep SCAN
/*
grid       59902       1  0 15:18 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid       94839   92569  0 15:31 pts/1    00:00:00 grep --color=auto SCAN
*/

-- Step 103.6 -->> On Node 2
[grid@pdb2 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 29-SEP-2024 15:32:02

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                29-SEP-2024 15:18:06
Uptime                    0 days 0 hr. 13 min. 57 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.25)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 104 -->> On Node 2
-- Bug 30286976: To Solve the Pre-check or any Oracle relavant Installation for rac Setup make compatible version CV_ASSUME_DISTID=OEL7.6
[grid@pdb2 ~]$ vi /opt/app/19c/grid/cv/admin/cvu_config
/*
# Configuration file for Cluster Verification Utility(CVU)
#
# Copyright (c) 2004, 2022, Oracle and/or its affiliates.
#
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

#Maximum number of reports (Text, Json) to retain in the CVU report directory.
CV_MAX_REPORT_COUNT=5

#Maximum number of baselines to retain in the CVU baseline directory.
CV_MAX_BASELINE_COUNT=10

#Minimum number of free inodes at /var/lib/oracle path
CV_MIN_FREE_INODES_REQ_VAR_PATH=100

#Minimum space required at the /var/lib/oracle path in Kilo Bytes
CV_MIN_FREE_SPACE_REQ_VAR_LIB_ORACLE_PATH=500

#Valid age in number of days for fresh software. If bits are found older than
#following number then CVU reports informational message suggesting update/upgrade
CV_MAX_DAYS_SOFTWARE_BITS_FRESH=180

#Minimum space required MB's in the CV_DESTLOC for CVU operations on the node
CV_DESTLOC_MIN_SPACE_MB=100

#Minimum space required MB's in the CVU TRACE LOC for CVU operations on the node
CV_TRACELOC_MIN_SPACE_MB=50

#Minimum space required MB's in the root filesystem
CV_ROOTFS_MIN_SPACE_MB=100

# Fallback to this distribution id.
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

# ODA CVU profile json file location
#CV_ODA_PROFILE_JSON_FILE_PATH=/opt/oracle/cvu/oda_cvu_profile.json

# OEDA(Exadata) CVU profile json file location
#CV_OEDA_PROFILE_JSON_FILE_PATH=/opt/oracle/cvu/oeda_cvu_profile.json

# OCI(Cloud) CVU profile json file location
#CV_OCI_PROFILE_JSON_FILE_PATH=/opt/oracle/cvu/oci_cvu_profile.json

# Variable to represent which profile to use and load all the properties
# and data from the profile. The profiles will be used internally and
# updated for OCI,ODA and EXADATA environments and will not be exposed to
# the customers directly.
# Applicable values are OCI or ODA or EXADATA or OCI,EXADATA or OCI,ODA
#CV_PROFILE_TO_USE=OCI

# Variable to define the packet size to be used during multicast connectivity
#CV_MULTICAST_PACKET_SIZE=2016

# Variable to set the behavior of patch checks during rootscripts execution
CV_ROOTSCRIPTS_PATCHING_CHECKS=TRUE

# Number of Seconds to time out when checking node reachability from local node
# The maximum allowed time out is 6 seconds.
#CV_NETREACH_TIMEOUT=3

# Maximum time out in seconds required for the CVU stand alone execution.
# Used when alternative pluggable CVU home is in use to perform the checks
#CV_STAND_ALONE_MAX_TIMEOUT_SECONDS=600
*/

-- Step 104.1 -->> On Node 2
[grid@pdb2 ~]$ cat /opt/app/19c/grid/cv/admin/cvu_config | grep -E CV_ASSUME_DISTID
/*
CV_ASSUME_DISTID=OEL7.6
*/

-- Step 105 -->> On Node 1
-- To Create ASM storage for Data and Archive 
[grid@pdb1 ~]$ cd /opt/app/19c/grid/bin
[grid@pdb1 bin]$ export CV_ASSUME_DISTID=OEL7.6

-- Step 105.1 -->> On Node 1
[grid@pdb1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName DATA -diskList /dev/oracleasm/disks/DATA -redundancy EXTERNAL

-- Step 105.2 -->> On Node 1
[grid@pdb1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName ARC -diskList /dev/oracleasm/disks/ARC -redundancy EXTERNAL

-- Step 106 -->> On Both Nodes
[grid@pdb1/pdb2 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Sep 29 15:35:17 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> set lines 200;
SQL> COLUMN name FORMAT A30
SQL> SELECT inst_id,name,state,type,compatibility,database_compatibility,voting_files FROM gv$asm_diskgroup order by name;

   INST_ID NAME STATE   TYPE   COMPATIBILITY DATABASE_COMPATIBILITY V
---------- ---- ------- ------ ------------- ---------------------- -
         1 ARC  MOUNTED EXTERN 19.0.0.0.0    10.1.0.0.0             N
         2 ARC  MOUNTED EXTERN 19.0.0.0.0    10.1.0.0.0             N
         2 DATA MOUNTED EXTERN 19.0.0.0.0    10.1.0.0.0             N
         1 DATA MOUNTED EXTERN 19.0.0.0.0    10.1.0.0.0             N
         2 OCR  MOUNTED EXTERN 19.0.0.0.0    10.1.0.0.0             Y
         1 OCR  MOUNTED EXTERN 19.0.0.0.0    10.1.0.0.0             Y

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

   INST_ID BANNER_FULL                                                            BANNER_LEGACY                                                          CON_ID
---------- ---------------------------------------------------------------------- ---------------------------------------------------------------------- ------
         1 Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production      0
           Version 19.23.0.0.0                                                                                                                           
         2 Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production      0
           Version 19.23.0.0.0

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 107 -->> On Both Nodes
[root@pdb1/pdb2 ~]# cd /opt/app/19c/grid/bin
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
ora.proxy_advm
               OFFLINE OFFLINE      pdb1                     STABLE
               OFFLINE OFFLINE      pdb2                     STABLE
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
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     Started,STABLE
      2        ONLINE  ONLINE       pdb2                     Started,STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.cvu
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.pdb1.vip
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.pdb2.vip
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.qosmserver
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.scan3.vip
      1        ONLINE  ONLINE       pdb1                     STABLE
--------------------------------------------------------------------------------
*/

-- Step 108 -->> On Both Nodes
[grid@pdb1/pdb2 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  1048576    409599   409485                0          409485              0             N  ARC/
MOUNTED  EXTERN  N         512             512   4096  1048576    204799   204689                0          204689              0             N  DATA/
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20136                0           20136              0             Y  OCR/
ASMCMD [+] > exit
*/

-- Step 109 -->> On Node 1
[root@pdb1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/19c/grid:N
*/

-- Step 110 -->> On Node 2
[root@pdb2 ~]# vi /etc/oratab
/*
+ASM2:/opt/app/19c/grid:N
*/

-- Step 111 -->> On Both Nodes
-- Creating the Oracle RDBMS Home Directory
[root@pdb1/pdb2 ~]# mkdir -p /opt/app/oracle/product/19c/db_1
[root@pdb1/pdb2 ~]# chown -R oracle:oinstall /opt/app/oracle/product/19c/db_1
[root@pdb1/pdb2 ~]# chmod -R 775 /opt/app/oracle/product/19c/db_1

-- Step 111.1 -->> On Node 1
-- To unzip the Oracle Binary and Letest Opatch
[root@pdb1 ~]# cd /opt/app/oracle/product/19c/db_1
[root@pdb1 db_1]# unzip -oq /root/Oracle_19C/19.3.0.0.0_DB_Binary/LINUX.X64_193000_db_home.zip
[root@pdb1 db_1]# unzip -oq /root/Oracle_19C/OPATCH_19c/p6880880_190000_Linux-x86-64.zip

-- Step 111.2 -->> On Node 1
[root@pdb1 ~]# chown -R oracle:oinstall /opt/app/oracle/product/19c/db_1/
[root@pdb1 ~]# chmod -R 775 /opt/app/oracle/product/19c/db_1/

-- Step 111.3 -->> On Node 1
[root@pdb1 ~]# su - oracle
[oracle@pdb1 ~]$ /opt/app/oracle/product/19c/db_1/OPatch/opatch version
/*
OPatch Version: 12.2.0.1.43

OPatch succeeded.
*/

-- Step 112 -->> On Node 1
-- To Setup the SSH Connectivity 
[root@pdb1 ~]# su - oracle
[oracle@pdb1 ~]$ cd /opt/app/oracle/product/19c/db_1/deinstall/
[oracle@pdb1 deinstall]$ ./sshUserSetup.sh -user oracle -hosts "pdb1 pdb2" -noPromptPassphrase -confirm -advanced
/*
Password: oracle
*/
-- Step 113 -->> On Both Nodes
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb1 date
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb2 date
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb1 date && ssh oracle@pdb2 date
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb1.unidev.org.np date
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb2.unidev.org.np date
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb1.unidev.org.np date && ssh oracle@pdb2.unidev.org.np date

-- Step 114 -->> On Node 1
-- To Create a responce file for Oracle Software Installation
[oracle@pdb1 ~]$ cp /opt/app/oracle/product/19c/db_1/install/response/db_install.rsp /home/oracle/
[oracle@pdb1 ~]$ cd /home/oracle/

-- Step 114.1 -->> On Node 1
[oracle@pdb1 ~]$ ll
/*
-rwxr-xr-x 1 oracle oinstall 19932 Sep 29 15:44 db_install.rsp
*/

-- Step 114.2 -->> On Node 1
[oracle@pdb1 ~]$ vi db_install.rsp
/*
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v19.0.0
oracle.install.option=INSTALL_DB_SWONLY
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/opt/app/oraInventory
ORACLE_HOME=/opt/app/oracle/product/19c/db_1
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
oracle.install.db.ConfigureAsContainerDB=false
*/

-- Step 114.3 -->> On Node 1
[oracle@pdb1 ~]$ vi /opt/app/oracle/product/19c/db_1/cv/admin/cvu_config
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

-- Step 114.4 -->> On Node 1
[oracle@pdb1 ~]$ cat /opt/app/oracle/product/19c/db_1/cv/admin/cvu_config | grep -E 'CV_ASSUME_DISTID'
/*
CV_ASSUME_DISTID=OEL7.6
*/

-- Step 115 -->> On Node 1
-- To install Oracle Software with Letest Opatch
[oracle@pdb1 ~]$ cd /opt/app/oracle/product/19c/db_1/
[oracle@pdb1 db_1]$ export CV_ASSUME_DISTID=OEL7.6
[oracle@pdb1 db_1]$ ./runInstaller -ignorePrereq -waitforcompletion -silent \
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
The log can be found at: /opt/app/oraInventory/logs/InstallActions2024-09-30_11-11-46AM/installerPatchActions_2024-09-30_11-11-46AM.log
Launching Oracle Database Setup Wizard...

The response file for this session can be found at:
 /opt/app/oracle/product/19c/db_1/install/response/db_2024-09-30_11-11-46AM.rsp

You can find the log of this install session at:
 /opt/app/oraInventory/logs/InstallActions2024-09-30_11-11-46AM/installActions2024-09-30_11-11-46AM.log

As a root user, execute the following script(s):
        1. /opt/app/oracle/product/19c/db_1/root.sh

Execute /opt/app/oracle/product/19c/db_1/root.sh on the following nodes:
[pdb1, pdb2]

Successfully Setup Software.
*/

-- Step 116 -->> On Node 1
[root@pdb1 ~]# /opt/app/oracle/product/19c/db_1/root.sh
/*
Check /opt/app/oracle/product/19c/db_1/install/root_pdb1.unidev.org.np_2024-09-30_11-29-54-296855464.log for the output of root script
*/

-- Step 116.1 -->> On Node 1
[root@pdb1 ~]# tail -f  /opt/app/oracle/product/19c/db_1/install/root_pdb1.unidev.org.np_2024-09-30_11-29-54-296855464.log
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

-- Step 117 -->> On Node 2
[root@pdb2 ~]# /opt/app/oracle/product/19c/db_1/root.sh
/*
Check /opt/app/oracle/product/19c/db_1/install/root_pdb2.unidev.org.np_2024-09-30_11-30-40-948547049.log for the output of root script
*/

-- Step 117.1 -->> On Node 2
[root@pdb2 ~]# tail -f /opt/app/oracle/product/19c/db_1/install/root_pdb2.unidev.org.np_2024-09-30_11-30-40-948547049.log
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

-- Step 118 -->> On Node 1
-- To applying the Oracle PSU on Node 1
[root@pdb1 ~]# cd /tmp/
[root@pdb1 tmp]$ export CV_ASSUME_DISTID=OEL7.6
[root@pdb1 tmp]# export ORACLE_HOME=/opt/app/oracle/product/19c/db_1
[root@pdb1 tmp]# export PATH=${ORACLE_HOME}/bin:$PATH
[root@pdb1 tmp]# export PATH=${PATH}:${ORACLE_HOME}/OPatch

-- Step 118.1 -->> On Node 1
[root@pdb1 tmp]# which opatchauto
/*
/opt/app/oracle/product/19c/db_1/OPatch/opatchauto
*/

-- Step 119 -->> On Node 1
[root@pdb1 tmp]# opatchauto apply /tmp/36209493/36199232 -oh /opt/app/oracle/product/19c/db_1 --nonrolling
/*
OPatchauto session is initiated at Mon Sep 30 11:32:28 2024

System initialization log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchautodb/systemconfig2024-09-30_11-32-33AM.log.

Session log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/opatchauto2024-09-30_11-32-56AM.log
The id for this session is BS9A

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

Host:pdb1
RAC Home:/opt/app/oracle/product/19c/db_1
Version:19.0.0.0.0
Summary:

==Following patches were SUCCESSFULLY applied:

Patch: /tmp/36209493/36199232
Log: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2024-09-30_11-34-02AM_1.log



OPatchauto session completed at Mon Sep 30 11:36:24 2024
Time taken to complete the session 3 minutes, 57 seconds
*/

-- Step 119.1 -->> On Node 1
[root@pdb1 ~]# tail -f /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2024-09-30_11-34-02AM_1.log
/*
[Sep 30, 2024 11:36:21 AM] [INFO]   Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/unzip_action/1727674031940/inventory/Templates/perl/bin/prove"
[Sep 30, 2024 11:36:21 AM] [INFO]   Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/unzip_action/1727674031940/inventory/Templates/perl/bin/ptar"
[Sep 30, 2024 11:36:21 AM] [INFO]   Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/unzip_action/1727674031940/inventory/Templates/perl/bin/ptardiff"
[Sep 30, 2024 11:36:21 AM] [INFO]   Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/unzip_action/1727674031940/inventory/Templates/perl/bin/ptargrep"
[Sep 30, 2024 11:36:21 AM] [INFO]   Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/unzip_action/1727674031940/inventory/Templates/perl/bin/shasum"
[Sep 30, 2024 11:36:21 AM] [INFO]   Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/unzip_action/1727674031940/inventory/Templates/perl/bin/splain"
[Sep 30, 2024 11:36:21 AM] [INFO]   Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/unzip_action/1727674031940/inventory/Templates/perl/bin/streamzip"
[Sep 30, 2024 11:36:21 AM] [INFO]   Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/unzip_action/1727674031940/inventory/Templates/perl/bin/xsubpp"
[Sep 30, 2024 11:36:21 AM] [INFO]   Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/unzip_action/1727674031940/inventory/Templates/perl/bin/zipdetails"
[Sep 30, 2024 11:36:21 AM] [INFO]   EXITING METHOD: NApply(patches,options)
*/

-- Step 120 -->> On Node 1
[root@pdb1 ~]# scp -r /tmp/36209493/ root@pdb2:/tmp/

-- Step 121 -->> On Node 2
[root@pdb2 ~]# cd /tmp/
[root@pdb2 tmp]# chown -R oracle:oinstall 36209493
[root@pdb2 tmp]# chmod -R 775 36209493

-- Step 121.1 -->> On Node 2
[root@pdb2 tmp]# ls -ltr | grep 36209493
/*
drwxrwxr-x  4 oracle oinstall     80 Sep 30 11:45 36209493
*/

-- Step 122 -->> On Node 2
-- To applying the Oracle PSU on Remote Node 2
[root@pdb2 ~]# cd /tmp/
[root@pdb1 tmp]$ export CV_ASSUME_DISTID=OEL7.6
[root@pdb2 tmp]# export ORACLE_HOME=/opt/app/oracle/product/19c/db_1
[root@pdb2 tmp]# export PATH=${ORACLE_HOME}/bin:$PATH
[root@pdb2 tmp]# export PATH=${PATH}:${ORACLE_HOME}/OPatch

-- Step 122.1 -->> On Node 2
[root@pdb2 tmp]# which opatchauto
/*
/opt/app/oracle/product/19c/db_1/OPatch/opatchauto
*/

-- Step 123 -->> On Node 2
[root@pdb2 tmp]# opatchauto apply /tmp/36209493/36199232 -oh /opt/app/oracle/product/19c/db_1 --nonrolling
/*
OPatchauto session is initiated at Mon Sep 30 11:46:47 2024

System initialization log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchautodb/s                                                                                                ystemconfig2024-09-30_11-46-52AM.log.

Session log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/opatchauto2024-09-30_11-47-13AM.log
The id for this session is D4AQ

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

Host:pdb2
RAC Home:/opt/app/oracle/product/19c/db_1
Version:19.0.0.0.0
Summary:

==Following patches were SUCCESSFULLY applied:

Patch: /tmp/36209493/36199232
Log: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2024-09-30_11-48-17AM_1.log



OPatchauto session completed at Mon Sep 30 11:50:44 2024
Time taken to complete the session 3 minutes, 58 seconds
*/

-- Step 123.1 -->> On Node 2
[root@pdb2 ~]# tail -f /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2024-09-30_11-48-17AM_1.log
/*
[Sep 30, 2024 11:50:41 AM] [INFO]   Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/unzip_action/1727674031940/inventory/Templates/perl/bin/perlivp"
[Sep 30, 2024 11:50:41 AM] [INFO]   Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/unzip_action/1727674031940/inventory/Templates/perl/bin/pod2text"
[Sep 30, 2024 11:50:41 AM] [INFO]   Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/unzip_action/1727674031940/inventory/Templates/perl/bin/prove"
[Sep 30, 2024 11:50:41 AM] [INFO]   Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/unzip_action/1727674031940/inventory/Templates/perl/bin/corelist"
[Sep 30, 2024 11:50:41 AM] [INFO]   Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/unzip_action/1727674031940/inventory/Templates/perl/bin/libnetcfg"
[Sep 30, 2024 11:50:41 AM] [INFO]   Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/unzip_action/1727674031940/inventory/Templates/perl/bin/pod2man"
[Sep 30, 2024 11:50:41 AM] [INFO]   Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/unzip_action/1727674031940/inventory/Templates/perl/bin/perldoc"
[Sep 30, 2024 11:50:41 AM] [INFO]   Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/unzip_action/1727674031940/inventory/Templates/perl/bin/dbilogstrip"
[Sep 30, 2024 11:50:41 AM] [INFO]   Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/unzip_action/zipfiles.txt"
[Sep 30, 2024 11:50:41 AM] [INFO]   EXITING METHOD: NApply(patches,options)
*/

-- Step 124 -->> On Both Nodes
-- To Create a Oracle Database
[root@pdb1/pdb2 ~]# mkdir -p /opt/app/oracle/admin/pdbdb/adump
[root@pdb1/pdb2 ~]# cd /opt/app/oracle/admin/
[root@pdb1/pdb2 ~]# chown -R oracle:oinstall pdbdb/
[root@pdb1/pdb2 ~]# chmod -R 775 pdbdb/

-- Step 125 -->> On Node 1
-- To prepare the responce file
[root@pdb1 ~]# su - oracle

-- Step 126 -->> On Node 1
[oracle@pdb1 db_1]$ cd /opt/app/oracle/product/19c/db_1/assistants/dbca
[oracle@pdb1 dbca]$ export CV_ASSUME_DISTID=OEL7.6
[oracle@pdb1 dbca]$ dbca -silent -createDatabase \
-templateName General_Purpose.dbc             \
-gdbname pdbdb -responseFile NO_VALUE         \
-characterSet AL32UTF8                        \
-sysPassword Sys605014                        \
-systemPassword Sys605014                     \
-createAsContainerDatabase true               \
-numberOfPDBs 1                               \
-pdbName sbxpdb                               \
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

-- Step 126.1 -->> On Node 1
[oracle@pdb1 ~]$  tail -f /opt/app/oracle/cfgtoollogs/dbca/pdbdb/pdbdb.log
/*
[ 2024-09-30 12:06:30.156 NPT ] Prepare for db operation
DBCA_PROGRESS : 7%
[ 2024-09-30 12:06:56.508 NPT ] Copying database files
DBCA_PROGRESS : 27%
[ 2024-09-30 12:08:39.124 NPT ] Creating and starting Oracle instance
DBCA_PROGRESS : 28%
DBCA_PROGRESS : 31%
DBCA_PROGRESS : 35%
DBCA_PROGRESS : 37%
DBCA_PROGRESS : 40%
[ 2024-09-30 12:36:39.339 NPT ] Creating cluster database views
DBCA_PROGRESS : 41%
DBCA_PROGRESS : 53%
[ 2024-09-30 12:38:00.903 NPT ] Completing Database Creation
DBCA_PROGRESS : 57%
DBCA_PROGRESS : 59%
DBCA_PROGRESS : 60%
[ 2024-09-30 12:54:05.414 NPT ] Creating Pluggable Databases
DBCA_PROGRESS : 64%
DBCA_PROGRESS : 80%
[ 2024-09-30 12:54:45.208 NPT ] Executing Post Configuration Actions
DBCA_PROGRESS : 100%
[ 2024-09-30 12:54:45.211 NPT ] Database creation complete. For details check the logfiles at:
 /opt/app/oracle/cfgtoollogs/dbca/pdbdb.
Database Information:
Global Database Name:pdbdb
System Identifier(SID) Prefix:pdbdb
*/

-- Step 127 -->> On Node 1  
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue Oct 1 11:17:33 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> show con_name

CON_NAME
------------------------------
CDB$ROOT

SQL> alter pluggable database sbxpdb open;
SQL> alter pluggable database all open;
SQL> alter pluggable database sbxpdb save state;

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 SBXPDB                         READ WRITE NO

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
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 128 -->> On Both Nodes 
[oracle@pdb1/pdb2 ~]$ srvctl config database -d pdbdb
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

-- Step 129 -->> On Both Nodes 
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 130 -->> On Both Nodes 
[oracle@pdb1/pdb2 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): pdb2,pdb1
*/

-- Step 131 -->> On Node 1 
[oracle@pdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 01-OCT-2024 11:20:05

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                29-SEP-2024 15:12:55
Uptime                    1 days 20 hr. 7 min. 10 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.21)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.23)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "2351e15d26626035e063150610ac7e23" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "86b637b62fdf7a65e053f706e80a27ca" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "sbxpdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 132 -->> On Node 2 
[oracle@pdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 01-OCT-2024 11:20:07

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                29-SEP-2024 15:18:27
Uptime                    1 days 20 hr. 1 min. 41 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.22)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.24)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "2351e15d26626035e063150610ac7e23" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "86b637b62fdf7a65e053f706e80a27ca" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "sbxpdb" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- To Fix the ADRCI log if occured in remote nodes
-- Step Fix.1 -->> On Node 2
[oracle@pdb2 ~]$ adrci
/*
ADRCI: Release 19.0.0.0.0 - Production on Tue Oct 1 11:20:50 2024

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

No ADR base is set
adrci> exit
*/

-- Step Fix.2 -->> On Node 2
[oracle@pdb1 ~]$ ls -ltr /opt/app/oracle/product/19c/db_1/log/diag/
/*
-rw-r----- 1 oracle asmadmin 16 Sep 30 12:53 adrci_dir.mif
*/

-- Step Fix.3 -->> On Node 2
[oracle@pdb2 ~]$ cd /opt/app/oracle/product/19c/db_1/
[oracle@pdb2 db_1]$ mkdir -p log/diag
[oracle@pdb2 db_1]$ mkdir -p log/pdb2/client
[oracle@pdb2 db_1]$ cd log
[oracle@pdb2 db_1]$ chown -R oracle:asmadmin diag
-- Step Fix.4 -->> On Node 2
[oracle@pdb1 ~]$ scp -r /opt/app/oracle/product/19c/db_1/log/diag/adrci_dir.mif oracle@pdb2:/opt/app/oracle/product/19c/db_1/log/diag/

-- Step Fix.5 -->> On Node 2
[oracle@pdb2 ~]$ adrci
/*
ADRCI: Release 19.0.0.0.0 - Production on Mon Sep 23 14:44:14 2024

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

ADR base = "/opt/app/oracle"
adrci> exit
*/

-- Step 133 -->> On Node 1
[root@pdb1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/19c/grid:N
pdbdb:/opt/app/oracle/product/19c/db_1:N
pdbdb1:/opt/app/oracle/product/19c/db_1:N
*/

-- Step 134 -->> On Node 2
[root@pdb2 ~]# vi /etc/oratab 
/*
+ASM2:/opt/app/19c/grid:N
pdbdb:/opt/app/oracle/product/19c/db_1:N
pdbdb2:/opt/app/oracle/product/19c/db_1:N
*/

-- Step 135 -->> On Node 1
[oracle@pdb1 ~]$ vi /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
/*
# tnsnames.ora Network Configuration File: /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
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
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.16.6.21)(PORT = 1521))
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
*/

-- Step 136 -->> On Node 2
[oracle@pdb2 ~]$ vi /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
/*
# tnsnames.ora Network Configuration File: /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
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
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.16.6.22)(PORT = 1521))
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
*/

-- Step 137 -->> On Both Node
[oracle@pdb1/pdb2 ~]$ tnsping pdbdb
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 01-OCT-2024 11:25:25

Copyright (c) 1997, 2024, Oracle.  All rights reserved.

Used parameter files:

Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdb-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = pdbdb)))
OK (0 msec)
*/

-- Step 137.1 -->> On Both Node
[oracle@pdb1/pdb2 ~]$ tnsping sbxpdb
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 01-OCT-2024 11:25:40

Copyright (c) 1997, 2024, Oracle.  All rights reserved.

Used parameter files:

Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdb-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = sbxpdb)))
OK (0 msec)
*/

-- Step 138.1 -->> On Node 1
[oracle@pdb1 ~]$ sqlplus sys/Sys605014@pdbdb as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue Oct 1 11:26:15 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> show con_name

CON_NAME
------------------------------
CDB$ROOT
SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 SBXPDB                         READ WRITE NO
SQL> connect sys/Sys605014@sbxpdb as sysdba
Connected.
SQL> show con_name

CON_NAME
------------------------------
SBXPDB
SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         3 SBXPDB                         READ WRITE NO
SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 139 -->> On Node 1
[root@pdb1 ~]# cd /opt/app/19c/grid/bin
[root@pdb1 ~]# ./crsctl stop cluster -all
[root@pdb1 ~]# ./crsctl start cluster -all

-- Step 140 -->> On Node 1
[root@pdb1 ~]# cd /opt/app/19c/grid/bin
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
ora.drivers.acfs
      1        ONLINE  ONLINE       pdb1                     STABLE
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
[root@pdb2 ~]# cd /opt/app/19c/grid/bin
[root@pdb2 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdb2                     Started,STABLE
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
ora.drivers.acfs
      1        ONLINE  ONLINE       pdb2                     STABLE
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
[root@pdb1/pdb2 ~]# cd /opt/app/19c/grid/bin
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
ora.proxy_advm
               OFFLINE OFFLINE      pdb1                     STABLE
               OFFLINE OFFLINE      pdb2                     STABLE
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
ora.LISTENER_SCAN3.lsnr
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
ora.cvu
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.pdb1.vip
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.pdb2.vip
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.pdbdb.db
      1        ONLINE  ONLINE       pdb1                     Open,HOME=/opt/app/oracle/product/19c/db_1,STABLE
      2        ONLINE  ONLINE       pdb2                     Open,HOME=/opt/app/oracle/product/19c/db_1,STABLE
ora.qosmserver
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.scan3.vip
      1        ONLINE  ONLINE       pdb2                     STABLE
--------------------------------------------------------------------------------
*/

-- Step 143 -->> On Both Nodes
[root@pdb1/pdb2 ~]# cd /opt/app/19c/grid/bin
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
MOUNTED  EXTERN  N         512             512   4096  1048576    204799   198278                0          198278              0             N  DATA/
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20112                0           20112              0             Y  OCR/
ASMCMD [+] > exit

*/

-- Step 145 -->> On Node 1
[grid@pdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 01-OCT-2024 11:33:00

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                01-OCT-2024 11:29:51
Uptime                    0 days 0 hr. 3 min. 8 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.21)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.23)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "2351e15d26626035e063150610ac7e23" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "86b637b62fdf7a65e053f706e80a27ca" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "sbxpdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 146 -->> On Node 2
[grid@pdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 01-OCT-2024 11:33:01

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                01-OCT-2024 11:29:40
Uptime                    0 days 0 hr. 3 min. 20 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.22)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.24)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "2351e15d26626035e063150610ac7e23" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "86b637b62fdf7a65e053f706e80a27ca" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "sbxpdb" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 147 -->> On Node 1
[grid@pdb1 ~]$ ps -ef | grep SCAN
/*
grid     1667622       1  0 11:30 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid     1683136 1677567  0 11:33 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 147.1 -->> On Node 1
[grid@pdb1 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 01-OCT-2024 11:33:43

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                01-OCT-2024 11:30:22
Uptime                    0 days 0 hr. 3 min. 21 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.25)(PORT=1521)))
Services Summary...
Service "2351e15d26626035e063150610ac7e23" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "86b637b62fdf7a65e053f706e80a27ca" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "sbxpdb" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 148 -->> On Node 2
[grid@pdb2 ~]$ ps -ef | grep SCAN
/*
grid     1604085       1  0 11:29 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid     1604094       1  0 11:29 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid     1616787 1615148  0 11:33 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 148.1 -->> On Node 2
[grid@pdb2 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 01-OCT-2024 11:34:12

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                01-OCT-2024 11:29:40
Uptime                    0 days 0 hr. 4 min. 31 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.26)(PORT=1521)))
Services Summary...
Service "2351e15d26626035e063150610ac7e23" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "86b637b62fdf7a65e053f706e80a27ca" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "sbxpdb" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 148.2 -->> On Node 2
[grid@pdb2 ~]$ lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 01-OCT-2024 11:34:43

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                01-OCT-2024 11:29:40
Uptime                    0 days 0 hr. 5 min. 2 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener_scan3/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN3)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.6.27)(PORT=1521)))
Services Summary...
Service "2351e15d26626035e063150610ac7e23" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "86b637b62fdf7a65e053f706e80a27ca" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "sbxpdb" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 148.3 -->> On Both Nodes
[grid@pdb1/pdb2 ~]$ ps -ef | grep ASMNET1LSNR
/*
grid     1685664 1677567  0 11:35 pts/0    00:00:00 grep --color=auto ASMLI
[grid@pdb1 ~]$ ps -ef | grep ASMNET1LSNR
grid     1665044       1  0 11:29 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr ASMNET1LSNR_ASM -no_crs_notify -inherit
grid     1685859 1677567  0 11:35 pts/0    00:00:00 grep --color=auto ASMNET1LSNR
*/

-- Step 148.4 -->> On Node 1
[grid@pdb1 ~]$ lsnrctl status ASMNET1LSNR_ASM
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 01-OCT-2024 11:37:36

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=ASMNET1LSNR_ASM)))
STATUS of the LISTENER
------------------------
Alias                     ASMNET1LSNR_ASM
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                01-OCT-2024 11:29:53
Uptime                    0 days 0 hr. 7 min. 42 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/asmnet1lsnr_asm/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=ASMNET1LSNR_ASM)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=10.10.10.21)(PORT=1525)))
Services Summary...
Service "+ASM" has 2 instance(s).
  Instance "+ASM1", status READY, has 2 handler(s) for this service...
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 2 instance(s).
  Instance "+ASM1", status READY, has 2 handler(s) for this service...
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 2 instance(s).
  Instance "+ASM1", status READY, has 2 handler(s) for this service...
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 2 instance(s).
  Instance "+ASM1", status READY, has 2 handler(s) for this service...
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 148.5 -->> On Node 2
[grid@pdb2 ~]$ lsnrctl status ASMNET1LSNR_ASM
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 01-OCT-2024 11:38:04

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=ASMNET1LSNR_ASM)))
STATUS of the LISTENER
------------------------
Alias                     ASMNET1LSNR_ASM
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                01-OCT-2024 11:29:37
Uptime                    0 days 0 hr. 8 min. 26 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/asmnet1lsnr_asm/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=ASMNET1LSNR_ASM)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=10.10.10.22)(PORT=1525)))
Services Summary...
Service "+ASM" has 2 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
  Instance "+ASM2", status READY, has 2 handler(s) for this service...
Service "+ASM_ARC" has 2 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
  Instance "+ASM2", status READY, has 2 handler(s) for this service...
Service "+ASM_DATA" has 2 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
  Instance "+ASM2", status READY, has 2 handler(s) for this service...
Service "+ASM_OCR" has 2 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
  Instance "+ASM2", status READY, has 2 handler(s) for this service...
The command completed successfully
*/

-- Step 149 -->> On Both Nodes
[grid@pdb1/pdb2 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue Oct 1 11:39:10 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> set lines 200;
SQL> col BANNER_FULL format a80;
SQL> col BANNER_LEGACY format a80;
SQL> SELECT inst_id,banner_full,banner_legacy,con_id FROM gv$version;

   INST_ID BANNER_FULL                                                                      BANNER_LEGACY                                                                        CON_ID
---------- -------------------------------------------------------------------------------- -------------------------------------------------------------------------------- ----------
         2 Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production           Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production                    0
           Version 19.23.0.0.0

         1 Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production           Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production                    0
           Version 19.23.0.0.0

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 150 -->> On Both Nodes
-- DB Service Verification
[root@pdb1/pdb2 ~]# su - oracle
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 151 -->> On Both Nodes
-- Listener Service Verification
[oracle@pdb1/pdb2 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): pdb2,pdb1
*/

-- Step 152 -->> On Both Nodes
[oracle@pdb1/pdb2 ~]$ rman target sys/Sys605014@pdbdb
--OR--
[oracle@pdb1/pdb2 ~]$ rman target /
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Tue Oct 1 11:40:38 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB (DBID=3239152647)

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
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/product/19c/db_1/dbs/snapcf_pdbdb1.f'; # default
--Node 2
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/product/19c/db_1/dbs/snapcf_pdbdb2.f'; # default

RMAN> exit

Recovery Manager complete.
*/

-- Step 153 -->> On Both Nodes
[oracle@pdb1/pdb2 ~]$ rman target sys/Sys605014@sbxpdb
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Tue Oct 1 11:45:57 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB:SBXPDB (DBID=582878271)

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
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/product/19c/db_1/dbs/snapcf_pdbdb1.f'; # default
--Node 2
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/product/19c/db_1/dbs/snapcf_pdbdb2.f'; # default

RMAN> exit

Recovery Manager complete.
*/
-- Step 154 -->> On Both Nodes
-- To connnect CDB$ROOT using TNS
[oracle@pdb1/pdb2 ~]$ sqlplus sys/Sys605014@pdbdb as sysdba

-- Step 155 -->> On Node 1
[oracle@pdb1 ~]$ sqlplus sys/Sys605014@pdbdb1 as sysdba

-- Step 156 -->> On Node 2
[oracle@pdb2 ~]$ sqlplus sys/Sys605014@pdbdb2 as sysdba

-- Step 157 -->> On Both Nodes
-- To connnect PDB using TNS
[oracle@pdb1/pdb2 ~]$ sqlplus sys/Sys605014@sbxpdb as sysdba

-- Step 158 -->> On TARGETDB Server (Heap/Partitions tables import using Network Link)
[oracle@pdb1 ~]$ sqlplus sys/"Sys605014"@sbxpdb as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue Oct 1 11:58:42 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         3 SBXPDB                         READ WRITE NO


SQL> CREATE TABLESPACE tbs_backup
     DATAFILE '+DATA'
     SIZE 1g
     AUTOEXTEND ON NEXT 512m MAXSIZE UNLIMITED
     SEGMENT SPACE MANAGEMENT AUTO;

Tablespace created.

SQL> CREATE USER backup IDENTIFIED BY "B8#cKu#P" CONTAINER=CURRENT
     DEFAULT TABLESPACE tbs_backup
     TEMPORARY TABLESPACE TEMP
     QUOTA UNLIMITED ON tbs_backup;

User created.

SQL> GRANT CONNECT,RESOURCE TO backup;

Grant succeeded.

SQL> CREATE TABLE BACKUP.tbl_import_heap TABLESPACE tbs_backup
AS
SELECT LEVEL c1, SYSDATE c2 FROM dual CONNECT BY LEVEL <=900000;

SQL> CREATE TABLE BACKUP.tbl_tbl_big_album_sales_pt
(
 id           NUMBER,
 album_id     NUMBER,
 country_id   NUMBER,
 release_date DATE,
 total_sales  NUMBER
)
PARTITION BY RANGE (release_date)
(
 PARTITION album_2001 VALUES LESS THAN (TO_DATE('01-JAN-2002', 'DD-MON-YYYY')),
 PARTITION album_2002 VALUES LESS THAN (TO_DATE('01-JAN-2003', 'DD-MON-YYYY')),
 PARTITION album_2003 VALUES LESS THAN (TO_DATE('01-JAN-2004', 'DD-MON-YYYY')),
 PARTITION album_2004 VALUES LESS THAN (TO_DATE('01-JAN-2005', 'DD-MON-YYYY')),
 PARTITION album_2005 VALUES LESS THAN (TO_DATE('01-JAN-2006', 'DD-MON-YYYY')),
 PARTITION album_2006 VALUES LESS THAN (TO_DATE('01-JAN-2007', 'DD-MON-YYYY')),
 PARTITION album_2007 VALUES LESS THAN (TO_DATE('01-JAN-2008', 'DD-MON-YYYY')),
 PARTITION album_2008 VALUES LESS THAN (MAXVALUE)
) TABLESPACE tbs_backup;

SQL> INSERT INTO BACKUP.tbl_tbl_big_album_sales_pt
SELECT
     ROWNUM                             id,
     MOD(ROWNUM,5000)+1                 album_id,
     MOD(ROWNUM,100)+1                  country_id,
     SYSDATE-MOD(ROWNUM,2785)           release_date,
     CEIL(dbms_random.value(1,500000))  total_sales
FROM dual
CONNECT BY LEVEL <= 900000;

COMMIT;
SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/
