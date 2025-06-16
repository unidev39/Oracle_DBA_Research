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
[root@pdbdr1/pdbdr2 ~]# df -Th
/*
Filesystem                   Type      Size  Used Avail Use% Mounted on
devtmpfs                     devtmpfs  9.6G     0  9.6G   0% /dev
tmpfs                        tmpfs     9.7G     0  9.7G   0% /dev/shm
tmpfs                        tmpfs     9.7G  9.3M  9.7G   1% /run
tmpfs                        tmpfs     9.7G     0  9.7G   0% /sys/fs/cgroup
/dev/mapper/ol_pdbdr1-root   xfs        70G  586M   70G   1% /
/dev/mapper/ol_pdbdr1-usr    xfs        10G  7.2G  2.9G  72% /usr
/dev/mapper/ol_pdbdr1-tmp    xfs        10G  104M  9.9G   2% /tmp
/dev/mapper/ol_pdbdr1-home   xfs        10G  104M  9.9G   2% /home
/dev/mapper/ol_pdbdr1-backup xfs        53G  411M   53G   1% /backup
/dev/mapper/ol_pdbdr1-opt    xfs        70G  740M   70G   2% /opt
/dev/sda1                    xfs      1014M  343M  672M  34% /boot
/dev/mapper/ol_pdbdr1-var    xfs        10G  819M  9.2G   9% /var
tmpfs                        tmpfs     2.0G   12K  2.0G   1% /run/user/42
tmpfs                        tmpfs     2.0G     0  2.0G   0% /run/user/0
*/

-- Step 1 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.160.6.48   pdbdr1.unidev.org.np        pdbdr1
192.160.6.49   pdbdr2.unidev.org.np        pdbdr2

# Private
10.10.10.48   pdbdr1-priv.unidev.org.np   pdbdr1-priv
10.10.10.49   pdbdr2-priv.unidev.org.np   pdbdr2-priv

# Virtual
192.160.6.50   pdbdr1-vip.unidev.org.np    pdbdr1-vip
192.160.6.51   pdbdr2-vip.unidev.org.np    pdbdr2-vip

# SCAN
192.160.6.52   pdbdr-scan.unidev.org.np    pdbdr-scan
192.160.6.53   pdbdr-scan.unidev.org.np    pdbdr-scan
192.160.6.54   pdbdr-scan.unidev.org.np    pdbdr-scan
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
[root@pdbdr1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens160 
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=ens160
DEVICE=ens160
ONBOOT=yes
IPADDR=192.160.6.48
NETMASK=255.255.255.0
GATEWAY=192.160.6.1
DNS1=127.0.0.1
DNS2=192.160.4.11
DNS3=192.160.4.12
*/

-- Step 6 -->> On Node 1
[root@pdbdr1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens192
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=ens192
DEVICE=ens192
ONBOOT=yes
IPADDR=10.10.10.48
NETMASK=255.255.255.0
*/

-- Step 7 -->> On Node 2
[root@pdbdr2 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens160
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=ens160
DEVICE=ens160
ONBOOT=yes
IPADDR=192.160.6.49
NETMASK=255.255.255.0
GATEWAY=192.160.6.1
DNS1=127.0.0.1
DNS2=192.160.4.11
DNS3=192.160.4.12
*/

-- Step 8 -->> On Node 2
[root@pdbdr2 ~]# vi /etc/sysconfig/network-scripts/ifcfg-ens192
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=ens192
DEVICE=ens192
ONBOOT=yes
IPADDR=10.10.10.49
NETMASK=255.255.255.0
*/

-- Step 9 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# systemctl restart network-online.target
[root@pdbdr1/pdbdr2 ~]# systemctl restart NetworkManager

-- Step 10 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# dnf repolist
/*
repo id           repo name
ol8_UEKR6         Latest Unbreakable Enterprise Kernel Release 6 for Oracle Linux 8 (x86_64)
ol8_appstream     Oracle Linux 8 Application Stream (x86_64)
ol8_baseos_latest Oracle Linux 8 BaseOS Latest (x86_64)
*/

-- Step 10.1 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# uname -a
/*
Linux pdbdr1/pdbdr2.unidev.org.np 5.4.17-2136.335.4.el8uek.x86_64 #3 SMP Thu Aug 22 12:18:30 PDT 202 4 x86_64 x86_64 x86_64 GNU/Linux
*/

-- Step 10.2 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# uname -r
/*
5.4.17-2136.334.6.1.el8uek.x86_64
*/

-- Step 10.3 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# grubby --info=ALL | grep ^kernel
/*
kernel="/boot/vmlinuz-5.4.17-2136.335.4.el8uek.x86_64"
kernel="/boot/vmlinuz-4.18.0-553.16.1.el8_10.x86_64"
kernel="/boot/vmlinuz-0-rescue-32c3f0ef5777489899dfb348b044ff1f"
*/

-- Step 10.4 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# grubby --default-kernel
/*
/boot/vmlinuz-5.4.17-2136.335.4.el8uek.x86_64
*/

-- Step 11 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/hostname
/*
localhost.localdomain
*/

-- Step 11.1 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# hostnamectl | grep hostname
/*
   Static hostname: localhost.localdomain
Transient hostname: pdbdr1/pdbdr2.unidev.org.np
*/

-- Step 11.2 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# hostnamectl --static
/*
localhost.localdomain
*/

-- Step 12 -->> On Node 1
[root@pdbdr1 ~]# hostnamectl set-hostname pdbdr1.unidev.org.np

-- Step 12.1 -->> On Node 1
[root@pdbdr1 ~]# hostnamectl
/*
   Static hostname: pdbdr1.unidev.org.np
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 32c3f0ef5777489899dfb348b044ff1f
           Boot ID: 50651ba2523d419f8e8f3e188d34aff3
    Virtualization: vmware
  Operating System: Oracle Linux Server 8.10
       CPE OS Name: cpe:/o:oracle:linux:8:10:server
            Kernel: Linux 5.4.17-2136.335.4.el8uek.x86_64
      Architecture: x86-64
*/

-- Step 13 -->> On Node 2
[root@pdbdr2 ~]# hostnamectl set-hostname pdbdr2.unidev.org.np

-- Step 13.1 -->> On Node 2
[root@pdbdr2 ~]# hostnamectl
/*
   Static hostname: pdbdr2.unidev.org.np
         Icon name: computer-vm
           Chassis: vm
        Machine ID: bbe6f4ad3d954dc08d72f55f7ea02e5f
           Boot ID: 6deddec9a5b54cd2b3d3f412aab65256
    Virtualization: vmware
  Operating System: Oracle Linux Server 8.10
       CPE OS Name: cpe:/o:oracle:linux:8:10:server
            Kernel: Linux 5.4.17-2136.335.4.el8uek.x86_64
      Architecture: x86-64
*/

--Note: If you are not configure proper hostname then While installation of Grid Software, 
--you have to face error CLSRSC-180: An error occurred while executing /opt/app/19c/grid/root.sh script.

-- Step 14 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# systemctl stop firewalld
[root@pdbdr1/pdbdr2 ~]# systemctl disable firewalld
/*
Removed /etc/systemd/system/multi-user.target.wants/firewalld.service.
Removed /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.
*/

-- Step 14.1 -->> On Both Nodedf 
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
Chain INPUT (policy ACCEPT 1 packets, 40 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 9 packets, 968 bytes)
 pkts bytes target     prot opt in     out     source               destination
*/

-- Step 16 -->> On Both Node
[root@pdbdr1/pdbdr2 ~ ]# systemctl stop named
[root@pdbdr1/pdbdr2 ~ ]# systemctl disable named

-- Step 17 -->> On Both Node
-- Enable chronyd service." `date`
[root@pdbdr1/pdbdr2 ~ ]# systemctl enable chronyd
[root@pdbdr1/pdbdr2 ~ ]# systemctl restart chronyd
[root@pdbdr1/pdbdr2 ~ ]# chronyc -a 'burst 4/4'
/*
200 OK
*/

-- Step 17.1 -->> On Both Node
[root@pdbdr1/pdbdr2 ~ ]# chronyc -a makestep
/*
200 OK
*/

-- Step 17.2 -->> On Both Node
[root@pdbdr1/pdbdr2 ~ ]# systemctl status chronyd
/*
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2024-09-25 13:03:09 +0545; 13s ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 8009 ExecStopPost=/usr/libexec/chrony-helper remove-daemon-state (code=exited, st>
  Process: 8018 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, status=>
  Process: 8014 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 8016 (chronyd)
    Tasks: 1 (limit: 125778)
   Memory: 908.0K
   CGroup: /system.slice/chronyd.service
           └─8016 /usr/sbin/chronyd

Sep 25 13:03:08 pdbdr1.unidev.org.np systemd[1]: Stopped NTP client/server.
Sep 25 13:03:08 pdbdr1.unidev.org.np systemd[1]: Starting NTP client/server...
Sep 25 13:03:09 pdbdr1.unidev.org.np chronyd[8016]: chronyd version 4.5 starting (+CMDMON >
Sep 25 13:03:09 pdbdr1.unidev.org.np chronyd[8016]: Loaded 0 symmetric keys
Sep 25 13:03:09 pdbdr1.unidev.org.np chronyd[8016]: Frequency -9.451 +/- 1.004 ppm read fr>
Sep 25 13:03:09 pdbdr1.unidev.org.np chronyd[8016]: Using right/UTC timezone to obtain lea>
Sep 25 13:03:09 pdbdr1.unidev.org.np systemd[1]: Started NTP client/server.
Sep 25 13:03:13 pdbdr1.unidev.org.np chronyd[8016]: Selected source 162.159.200.123 (2.poo>
Sep 25 13:03:13 pdbdr1.unidev.org.np chronyd[8016]: System clock TAI offset set to 37 seco>
Sep 25 13:03:15 pdbdr1.unidev.org.np chronyd[8016]: System clock was stepped by 0.000000 s>
*/

-- Step 18 -->> On Both Node
[root@pdbdr1 ~]# cd /etc/yum.repos.d/
[root@pdbdr1 yum.repos.d]# ll
/*
-rw-r--r--. 1 root root 4107 May 22 16:13 oracle-linux-ol8.repo
-rw-r--r--. 1 root root  941 May 23 14:02 uek-ol8.repo
-rw-r--r--. 1 root root  243 May 23 14:02 virt-ol8.repo
*/

-- Step 18.1 -->> On Both Node
[root@pdbdr1 ~]# cd /etc/yum.repos.d/
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf -y update
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y bind
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y dnsmasq

-- Step 18.2 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# systemctl enable dnsmasq
[root@pdbdr1/pdbdr2 ~]# systemctl restart dnsmasq
[root@pdbdr1/pdbdr2 ~]# vi /etc/dnsmasq.conf
/*
listen-address=::1,127.0.0.1

#Add the following Lines
except-interface=virbr0
bind-interfaces
*/

-- Step 18.3 -->> On Both Node
[root@pdbdr1 ~]# cat /etc/dnsmasq.conf | grep -E 'listen-address|except-interface|bind-interfaces'
/*
except-interface=virbr0
listen-address=::1,127.0.0.1
bind-interfaces
*/

-- Step 18.4 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# systemctl restart dnsmasq
[root@pdbdr1/pdbdr2 ~]# systemctl restart network-online.target
[root@pdbdr1/pdbdr2 ~]# systemctl restart NetworkManager
[root@pdbdr1/pdbdr2 ~]# systemctl status NetworkManager
/*
● NetworkManager.service - Network Manager
   Loaded: loaded (/usr/lib/systemd/system/NetworkManager.service; enabled; vendor preset: e>
   Active: active (running) since Wed 2024-09-25 13:19:24 +0545; 8s ago
     Docs: man:NetworkManager(8)
 Main PID: 57269 (NetworkManager)
    Tasks: 4 (limit: 125778)
   Memory: 5.5M
   CGroup: /system.slice/NetworkManager.service
           └─57269 /usr/sbin/NetworkManager --no-daemon

Sep 25 13:19:25 pdbdr1.unidev.org.np NetworkManager[57269]: <info>  [1727249665.0891] devi>
Sep 25 13:19:25 pdbdr1.unidev.org.np NetworkManager[57269]: <info>  [1727249665.0993] devi>
Sep 25 13:19:25 pdbdr1.unidev.org.np NetworkManager[57269]: <info>  [1727249665.0996] devi>
Sep 25 13:19:25 pdbdr1.unidev.org.np NetworkManager[57269]: <info>  [1727249665.0998] devi>
Sep 25 13:19:25 pdbdr1.unidev.org.np NetworkManager[57269]: <info>  [1727249665.1001] mana>
Sep 25 13:19:25 pdbdr1.unidev.org.np NetworkManager[57269]: <info>  [1727249665.1004] devi>
Sep 25 13:19:25 pdbdr1.unidev.org.np NetworkManager[57269]: <info>  [1727249665.1009] mana>
Sep 25 13:19:25 pdbdr1.unidev.org.np NetworkManager[57269]: <info>  [1727249665.1012] devi>
Sep 25 13:19:25 pdbdr1.unidev.org.np NetworkManager[57269]: <info>  [1727249665.1016] devi>
Sep 25 13:19:25 pdbdr1.unidev.org.np NetworkManager[57269]: <info>  [1727249665.1038] mana>
*/

-- Step 18.5 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# systemctl status dnsmasq
/*
● dnsmasq.service - DNS caching server.
   Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2024-09-25 13:19:24 +0545; 48s ago
 Main PID: 57257 (dnsmasq)
    Tasks: 1 (limit: 125778)
   Memory: 708.0K
   CGroup: /system.slice/dnsmasq.service
           └─57257 /usr/sbin/dnsmasq -k

Sep 25 13:19:24 pdbdr1.unidev.org.np dnsmasq[57257]: compile time options: IPv6 GNU-getopt>
Sep 25 13:19:24 pdbdr1.unidev.org.np dnsmasq[57257]: reading /etc/resolv.conf
Sep 25 13:19:24 pdbdr1.unidev.org.np dnsmasq[57257]: ignoring nameserver 127.0.0.1 - local>
Sep 25 13:19:24 pdbdr1.unidev.org.np dnsmasq[57257]: using nameserver 192.160.4.11#53
Sep 25 13:19:24 pdbdr1.unidev.org.np dnsmasq[57257]: using nameserver 192.160.4.12#53
Sep 25 13:19:24 pdbdr1.unidev.org.np dnsmasq[57257]: read /etc/hosts - 11 addresses
Sep 25 13:19:25 pdbdr1.unidev.org.np dnsmasq[57257]: reading /etc/resolv.conf
Sep 25 13:19:25 pdbdr1.unidev.org.np dnsmasq[57257]: ignoring nameserver 127.0.0.1 - local>
Sep 25 13:19:25 pdbdr1.unidev.org.np dnsmasq[57257]: using nameserver 192.160.4.11#53
Sep 25 13:19:25 pdbdr1.unidev.org.np dnsmasq[57257]: using nameserver 192.160.4.12#53
*/

-- Step 18.6 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/resolv.conf
/*
# Generated by NetworkManager
search cibnepal.org.np
nameserver 127.0.0.1
nameserver 192.160.4.11
nameserver 192.160.4.12
*/

-- Step 19 -->> On Node 1
[root@pdbdr1 ~]# nslookup 192.160.6.48
/*
48.6.160.192.in-addr.arpa        name = pdbdr1.unidev.org.np.
*/

-- Step 19.1 -->> On Node 1
[root@pdbdr1 ~]# nslookup 192.160.6.49
/*
49.6.160.192.in-addr.arpa        name = pdbdr2.unidev.org.np.
*/

-- Step 20 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup pdbdr1
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdbdr1.unidev.org.np
Address: 192.160.6.48
*/

-- Step 20.1 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup pdbdr2
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdbdr2.unidev.org.np
Address: 192.160.6.49
*/

-- Step 20.2 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup pdbdr-scan
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdbdr-scan.unidev.org.np
Address: 192.160.6.54
Name:   pdbdr-scan.unidev.org.np
Address: 192.160.6.52
Name:   pdbdr-scan.unidev.org.np
Address: 192.160.6.53
*/

-- Step 21 -->> On Both Node
--Stop avahi-daemon damon if it not configured
[root@pdbdr1/pdbdr2 ~]# systemctl stop avahi-daemon
[root@pdbdr1/pdbdr2 ~]# systemctl disable avahi-daemon

-- Step 22 -->> On Both Node
--To Remove virbr0 and lxcbr0 Network Interfac
[root@pdbdr1/pdbdr2 ~]# systemctl stop libvirtd.service
[root@pdbdr1/pdbdr2 ~]# systemctl disable libvirtd.service
[root@pdbdr1/pdbdr2 ~]# virsh net-list
/*
 Name      State    Autostart   Persistent
--------------------------------------------
 default   active   yes         yes
*/

-- Step 22.1 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# virsh net-destroy default
/*
Network default destroyed
*/

-- Step 22.2 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# ifconfig virbr0
/*
virbr0: error fetching interface information: Device not found
*/

-- Step 22.3 -->> On Node One
[root@pdbdr1 ~]# ifconfig
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.160.6.48  netmask 255.255.255.0  broadcast 192.160.6.255
        inet6 fe80::250:56ff:feac:6df  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:06:df  txqueuelen 1000  (Ethernet)
        RX packets 10223015  bytes 15157596989 (14.1 GiB)
        RX errors 0  dropped 34  overruns 0  frame 0
        TX packets 2215501  bytes 178114621 (169.8 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.48  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::250:56ff:feac:89b  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:08:9b  txqueuelen 1000  (Ethernet)
        RX packets 666  bytes 64589 (63.0 KiB)
        RX errors 0  dropped 32  overruns 0  frame 0
        TX packets 91  bytes 10638 (10.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 806  bytes 51733 (50.5 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 806  bytes 51733 (50.5 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 22.4 -->> On Node Two
[root@pdbdr2 ~]# ifconfig
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.160.6.49  netmask 255.255.255.0  broadcast 192.160.6.255
        inet6 fe80::250:56ff:feac:2254  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:22:54  txqueuelen 1000  (Ethernet)
        RX packets 164038  bytes 244646483 (233.3 MiB)
        RX errors 0  dropped 23  overruns 0  frame 0
        TX packets 95942  bytes 7635315 (7.2 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.49  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::250:56ff:feac:51d7  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:51:d7  txqueuelen 1000  (Ethernet)
        RX packets 601  bytes 56127 (54.8 KiB)
        RX errors 0  dropped 22  overruns 0  frame 0
        TX packets 92  bytes 10664 (10.4 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 820  bytes 53013 (51.7 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 820  bytes 53013 (51.7 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/
-- Step 23 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# init 6


-- Step 24 -->> On Node One
[root@pdbdr1 ~]# ifconfig
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.160.6.48  netmask 255.255.255.0  broadcast 192.160.6.255
        inet6 fe80::250:56ff:feac:6df  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:06:df  txqueuelen 1000  (Ethernet)
        RX packets 239  bytes 25409 (24.8 KiB)
        RX errors 0  dropped 31  overruns 0  frame 0
        TX packets 168  bytes 16876 (16.4 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.48  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::250:56ff:feac:89b  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:08:9b  txqueuelen 1000  (Ethernet)
        RX packets 94  bytes 6006 (5.8 KiB)
        RX errors 0  dropped 29  overruns 0  frame 0
        TX packets 17  bytes 1202 (1.1 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 340  bytes 21902 (21.3 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 340  bytes 21902 (21.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 24.1 -->> On Node Two
[root@pdbdr2 ~]# ifconfig
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.160.6.49  netmask 255.255.255.0  broadcast 192.160.6.255
        inet6 fe80::250:56ff:feac:2254  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:22:54  txqueuelen 1000  (Ethernet)
        RX packets 233  bytes 25135 (24.5 KiB)
        RX errors 0  dropped 23  overruns 0  frame 0
        TX packets 178  bytes 17500 (17.0 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.49  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::250:56ff:feac:51d7  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:ac:51:d7  txqueuelen 1000  (Ethernet)
        RX packets 80  bytes 5166 (5.0 KiB)
        RX errors 0  dropped 22  overruns 0  frame 0
        TX packets 17  bytes 1202 (1.1 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 366  bytes 23350 (22.8 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 366  bytes 23350 (22.8 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 24.2 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# ifconfig | grep -E 'UP'
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
*/

-- Step 24.3 -->> On Both Nodes
[root@pdbdr1 ~]# ifconfig | grep -E 'RUNNING'
/*
ens160: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
*/

-- Step 25 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# systemctl status libvirtd.service
/*
● libvirtd.service - Virtualization daemon
   Loaded: loaded (/usr/lib/systemd/system/libvirtd.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:libvirtd(8)
           https://libvirt.org
*/

-- Step 26 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# firewall-cmd --list-all
/*
FirewallD is not running
*/

-- Step 27 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# systemctl status firewalld
/*
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:firewalld(1)
*/

-- Step 28 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# systemctl status named
/*
● named.service - Berkeley Internet Name Domain (DNS)
   Loaded: loaded (/usr/lib/systemd/system/named.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
*/

-- Step 29 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# systemctl status avahi-daemon
/*
● avahi-daemon.service - Avahi mDNS/DNS-SD Stack
   Loaded: loaded (/usr/lib/systemd/system/avahi-daemon.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
*/

-- Step 30 -->> On Both Node
[root@pdbdr1/pdbdr2 ~ ]# systemctl status chronyd
/*
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2024-09-25 13:23:43 +0545; 23min ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 1361 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, status=>
  Process: 1326 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 1349 (chronyd)
    Tasks: 1 (limit: 125778)
   Memory: 1.3M
   CGroup: /system.slice/chronyd.service
           └─1349 /usr/sbin/chronyd

Sep 25 13:23:43 pdbdr1.unidev.org.np systemd[1]: Starting NTP client/server...
Sep 25 13:23:43 pdbdr1.unidev.org.np chronyd[1349]: chronyd version 4.5 starting (+CMDMON >
Sep 25 13:23:43 pdbdr1.unidev.org.np chronyd[1349]: Loaded 0 symmetric keys
Sep 25 13:23:43 pdbdr1.unidev.org.np chronyd[1349]: Frequency -9.403 +/- 0.241 ppm read fr>
Sep 25 13:23:43 pdbdr1.unidev.org.np chronyd[1349]: Using right/UTC timezone to obtain lea>
Sep 25 13:23:43 pdbdr1.unidev.org.np systemd[1]: Started NTP client/server.
Sep 25 13:23:48 pdbdr1.unidev.org.np chronyd[1349]: Selected source 162.159.200.123 (2.poo>
Sep 25 13:23:48 pdbdr1.unidev.org.np chronyd[1349]: System clock TAI offset set to 37 seco>
Sep 25 13:24:54 pdbdr1.unidev.org.np chronyd[1349]: Selected source 162.159.200.1 (2.pool.>
*/

-- Step 31 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# systemctl status dnsmasq
/*
● dnsmasq.service - DNS caching server.
   Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2024-09-25 13:23:42 +0545; 23min ago
 Main PID: 1249 (dnsmasq)
    Tasks: 1 (limit: 125778)
   Memory: 1.3M
   CGroup: /system.slice/dnsmasq.service
           └─1249 /usr/sbin/dnsmasq -k

Sep 25 13:23:42 pdbdr1.unidev.org.np dnsmasq[1249]: compile time options: IPv6 GNU-getopt >
Sep 25 13:23:42 pdbdr1.unidev.org.np dnsmasq[1249]: reading /etc/resolv.conf
Sep 25 13:23:42 pdbdr1.unidev.org.np dnsmasq[1249]: ignoring nameserver 127.0.0.1 - local >
Sep 25 13:23:42 pdbdr1.unidev.org.np dnsmasq[1249]: using nameserver 192.160.4.11#53
Sep 25 13:23:42 pdbdr1.unidev.org.np dnsmasq[1249]: using nameserver 192.160.4.12#53
Sep 25 13:23:42 pdbdr1.unidev.org.np dnsmasq[1249]: read /etc/hosts - 11 addresses
Sep 25 13:23:43 pdbdr1.unidev.org.np dnsmasq[1249]: reading /etc/resolv.conf
Sep 25 13:23:43 pdbdr1.unidev.org.np dnsmasq[1249]: ignoring nameserver 127.0.0.1 - local >
Sep 25 13:23:43 pdbdr1.unidev.org.np dnsmasq[1249]: using nameserver 192.160.4.11#53
Sep 25 13:23:43 pdbdr1.unidev.org.np dnsmasq[1249]: using nameserver 192.160.4.12#53
*/

-- Step 31.1 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup 192.160.6.48
/*
48.6.160.192.in-addr.arpa        name = pdbdr1.unidev.org.np.
*/

-- Step 31.2 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup 192.160.6.49
/*
49.6.160.192.in-addr.arpa        name = pdbdr2.unidev.org.np.
*/

-- Step 31.3 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup pdbdr1
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdbdr1.unidev.org.np
Address: 192.160.6.48
*/

-- Step 31.4 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup pdbdr2
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdbdr2.unidev.org.np
Address: 192.160.6.49
*/

-- Step 31.5 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup pdbdr-scan
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdbdr-scan.unidev.org.np
Address: 192.160.6.54
Name:   pdbdr-scan.unidev.org.np
Address: 192.160.6.52
Name:   pdbdr-scan.unidev.org.np
Address: 192.160.6.53
*/

-- Step 31.6 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup pdbdr2-vip
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdbdr2-vip.unidev.org.np
Address: 192.160.6.51
*/

-- Step 31.7 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup pdbdr1-vip
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdbdr1-vip.unidev.org.np
Address: 192.160.6.50
*/

-- Step 31.8 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# iptables -L -nv
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
[root@pdbdr1/pdbdr2 ~]# cd /etc/yum.repos.d/
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf -y update

-- Step 32.1 -->> On Both Node
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y yum-utils
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y dnf-utils
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y oracle-epel-release-el8
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y sshpass zip unzip
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y oracle-database-preinstall-19c

-- Step 32.2 -->> On Both Node
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y bc
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y binutils
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y compat-libcap1
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y compat-libstdc++-33
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y dtrace-utils
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y elfutils-libelf
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y elfutils-libelf-devel
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y fontconfig-devel
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y glibc
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y glibc-devel
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y ksh
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libaio
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libaio-devel
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libdtrace-ctf-devel
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libXrender
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libXrender-devel
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libX11
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libXau
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libXi
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libXtst
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libgcc
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y librdmacm-devel
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libstdc++
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libstdc++-devel
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libxcb
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y make
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y net-tools
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y nfs-utils
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y python
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y python-configshell
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y python-rtslib
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y python-six
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y targetcli
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y smartmontools
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y sysstat
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y unixODBC
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libnsl
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libnsl.i686
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libnsl2
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libnsl2.i686
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y chrony
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y unixODBC
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf -y update

-- Step 32.3 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# cd /tmp
--Bug 29772579
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libcap1-1.10-7.el7.i686.rpm
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libcap1-1.10-7.el7.x86_64.rpm
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libstdc++-33-3.2.3-72.el7.i686.rpm
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm

-- Step 32.4 -->> On Both Node
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/elfutils-libelf-devel-0.189-3.el8.i686.rpm
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/elfutils-libelf-devel-0.189-3.el8.x86_64.rpm
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/numactl-2.0.12-13.el8.x86_64.rpm
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/numactl-devel-2.0.12-13.el8.x86_64.rpm
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/numactl-devel-2.0.12-13.el8.i686.rpm
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/python3-libs-3.6.8-56.0.1.el8_9.i686.rpm
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/python3-libs-3.6.8-56.0.1.el8_9.x86_64.rpm

/* -- On Physical Server (If the ASMLib-8 we installed)
https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=364500837732007&id=2789052.1&_adf.ctrl-state=11vbxw8jk2_58

--OL8/RHEL8: ASMLib: root.sh is failing with CRS-1705: Found 0 Configured Voting Files But 1 Voting Files Are Required (Doc ID 2789052.1)
Bug 32410237 - oracleasm configure -p not discovering disks on RHEL8
Bug 32812376 - ROOT.SH IS FAILING WTH THE ERRORS CLSRSC-119: START OF THE EXCLUSIVE MODE CLUSTER FAILED
*/

--[root@pdbdr1/pdbdr2 tmp]# wget https://download.oracle.com/otn_software/asmlib/oracleasmlib-2.0.17-1.el8.x86_64.rpm
--[root@pdbdr1/pdbdr2 tmp]# wget https://public-yum.oracle.com/repo/OracleLinux/OL8/addons/x86_64/getPackage/oracleasm-support-2.1.12-1.el8.x86_64.rpm

-- Step 32.5 -->> On Both Node
[root@pdbdr1/pdbdr2 tmp]# wget https://download.oracle.com/otn_software/asmlib/oracleasmlib-2.0.12-1.el7.x86_64.rpm
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/oracleasm-support-2.1.11-2.el7.x86_64.rpm

-- Step 32.6 -->> On Both Node
--Bug 29772579
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./compat-libcap1-1.10-7.el7.i686.rpm
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./compat-libcap1-1.10-7.el7.x86_64.rpm
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./compat-libstdc++-33-3.2.3-72.el7.i686.rpm
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm

-- Step 33 -->> On Both Node
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./elfutils-libelf-devel-0.189-3.el8.i686.rpm
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./elfutils-libelf-devel-0.189-3.el8.x86_64.rpm
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./numactl-2.0.12-13.el8.x86_64.rpm
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./numactl-devel-2.0.12-13.el8.i686.rpm
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./numactl-devel-2.0.12-13.el8.x86_64.rpm
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./python3-libs-3.6.8-56.0.1.el8_9.i686.rpm
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./python3-libs-3.6.8-56.0.1.el8_9.x86_64.rpm

--[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./oracleasm-support-2.1.12-1.el8.x86_64.rpm ./oracleasmlib-2.0.17-1.el8.x86_64.rpm
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./oracleasm-support-2.1.11-2.el7.x86_64.rpm ./oracleasmlib-2.0.12-1.el7.x86_64.rpm
[root@pdbdr1/pdbdr2 tmp]# rm -rf *.rpm

-- Step 34 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# cd /etc/yum.repos.d/
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf -y install compat-libcap1 compat-libstdc++-33 bc binutils elfutils-libelf elfutils-libelf-devel fontconfig-devel glibc glibc-devel ksh libaio libaio-devel libgcc libnsl librdmacm-devel libstdc++ libstdc++-devel libX11 libXau libxcb libXi libXrender libXrender-devel libXtst make net-tools nfs-utils python3 python3-configshell python3-rtslib python3-six smartmontools sysstat targetcli unzip
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf -y install bash bc bind-utils binutils ethtool glibc glibc-devel initscripts ksh libaio libaio-devel libgcc libnsl libstdc++ libstdc++-devel make module-init-tools net-tools nfs-utils openssh-clients openssl-libs pam procps psmisc smartmontools sysstat tar unzip util-linux-ng xorg-x11-utils xorg-x11-xauth 
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf -y update

-- Step 35 -->> On Both Node
[root@pdbdr1/pdbdr2 yum.repos.d]# rpm -q binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel elfutils-libelf-devel-static \
[root@pdbdr1/pdbdr2 yum.repos.d]# rpm -q gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers kernel-headers ksh libaio libaio-devel \
[root@pdbdr1/pdbdr2 yum.repos.d]# rpm -q libgcc libgomp libstdc++ libstdc++-devel make numactl-devel sysstat unixODBC unixODBC-devel \

-- Step 36.3 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# rpm -qa | grep oracleasm
/*
oracleasmlib-2.0.12-1.el7.x86_64
oracleasm-support-2.1.11-2.el7.x86_64
*/

-- Step 37 -->> On Both Node
-- Add the kernel parameters file "/etc/sysctl.conf" and add oracle recommended kernel parameters
[root@pdbdr1/pdbdr2 ~]# vi /etc/sysctl.conf
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
[root@pdbdr1/pdbdr2 ~]# sysctl -p /etc/sysctl.conf

-- Step 38 -->> On Both Node
-- Edit “/etc/security/limits.d/oracle-database-preinstall-19c.conf” file to limit user processes
[root@pdbdr1/pdbdr2 ~]# vi /etc/security/limits.d/oracle-database-preinstall-19c.conf
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
-session    optional    pam_ck_connector.so
*/

-- Step 40 -->> On both Node
-- Create the new groups and users.
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:
*/

-- Step 40.1 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:
backupdba:x:54324:
dgdba:x:54325:
kmdba:x:54326:
pdbdba:x:54330:
*/

-- Step 40.2 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i oracle
/*
oracle:x:1000:
*/

-- Step 40.3 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i oper
/*
oper:x:54323:
*/

-- Step 40.4 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i asm

-- Step 40.5 -->> On both Node
-- 1.Create OS groups using the command below. Enter these commands as the 'root' user:
--[root@pdbdr1/pdbdr2 ~]# /usr/sbin/groupadd -g 503 oper
[root@pdbdr1/pdbdr2 ~]# /usr/sbin/groupadd -g 504 asmadmin
[root@pdbdr1/pdbdr2 ~]# /usr/sbin/groupadd -g 506 asmdba
[root@pdbdr1/pdbdr2 ~]# /usr/sbin/groupadd -g 507 asmoper
[root@pdbdr1/pdbdr2 ~]# /usr/sbin/groupadd -g 508 beoper

-- Step 40.6 -->> On both Node
-- 2.Create the users that will own the Oracle software using the commands:
[root@pdbdr1/pdbdr2 ~]# /usr/sbin/useradd  -g oinstall -G oinstall,dba,asmadmin,asmdba,asmoper,beoper grid
[root@pdbdr1/pdbdr2 ~]# /usr/sbin/usermod -g oinstall -G oinstall,dba,oper,asmdba,asmadmin,backupdba,dgdba,kmdba,racdba oracle

-- Step 40.7 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/

-- Step 40.8 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i oracle
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
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i grid
/*
oinstall:x:54321:grid,oracle
dba:x:54322:grid,oracle
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 40.10 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i oper
/*
oper:x:54323:oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 40.11 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:grid,oracle
*/

-- Step 40.12 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:grid,oracle
backupdba:x:54324:oracle
dgdba:x:54325:oracle
kmdba:x:54326:oracle
pdbdba:x:54330:oracle
asmdba:x:506:grid,oracle
*/

-- Step 40.13 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/

-- Step 41 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# passwd oracle
/*
Changing password for user oracle.
New password: oracle
Retype new password: oracle
passwd: all authentication tokens updated successfully.
*/

-- Step 42 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# passwd grid
/*
Changing password for user grid.
New password: grid
Retype new password: grid
passwd: all authentication tokens updated successfully.
*/

-- Step 42.1 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# su - oracle

-- Step 42.2 -->> On both Node
[oracle@pdbdr1/pdbdr2 ~]$ su - grid
/*
Password: grid
*/

-- Step 42.3 -->> On both Node
[grid@pdbdr1/pdbdr2 ~]$ su - oracle
/*
Password: oracle
*/

-- Step 42.4 -->> On both Node
[oracle@pdbdr1/pdbdr2 ~]$ exit
/*
logout
*/

-- Step 42.5 -->> On both Node
[grid@pdbdr1/pdbdr2 ~]$ exit
/*
logout
*/

-- Step 42.6 -->> On both Node
[oracle@pdbdr1/pdbdr2 ~]$ exit
/*
logout
*/

-- Step 43 -->> On both Node
--Create the Oracle Inventory Director:
[root@pdbdr1/pdbdr2 ~]# mkdir -p /opt/app/oraInventory
[root@pdbdr1/pdbdr2 ~]# chown -R grid:oinstall /opt/app/oraInventory
[root@pdbdr1/pdbdr2 ~]# chmod -R 775 /opt/app/oraInventory

-- Step 44 -->> On both Node
--Creating the Oracle Grid Infrastructure Home Directory:
[root@pdbdr1/pdbdr2 ~]# mkdir -p /opt/app/19c/grid
[root@pdbdr1/pdbdr2 ~]# chown -R grid:oinstall /opt/app/19c/grid
[root@pdbdr1/pdbdr2 ~]# chmod -R 775 /opt/app/19c/grid

-- Step 45 -->> On both Node
--Creating the Oracle Base Directory
[root@pdbdr1/pdbdr2 ~]#   mkdir -p /opt/app/oracle
[root@pdbdr1/pdbdr2 ~]#   chmod -R 775 /opt/app/oracle
[root@pdbdr1/pdbdr2 ~]#   cd /opt/app/
[root@pdbdr1/pdbdr2 app]# chown -R oracle:oinstall /opt/app/oracle

-- Step 46 -->> On Node 1
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
ORACLE_HOME=$ORACLE_BASE/product/19c/db_1; export ORACLE_HOME
ORACLE_SID=pdbdb1; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 47 -->> On Node 1
[oracle@pdbdr1 ~]$ . .bash_profile

-- Step 48 -->> On Node 1
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
GRID_HOME=/opt/app/19c/grid; export GRID_HOME
ORACLE_HOME=$GRID_HOME; export ORACLE_HOME

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 49 -->> On Node 1
[grid@pdbdr1 ~]$ . .bash_profile

-- Step 50 -->> On Node 2
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
ORACLE_HOME=$ORACLE_BASE/product/19c/db_1; export ORACLE_HOME
ORACLE_SID=pdbdb2; export ORACLE_SID

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 51 -->> On Node 2
[oracle@pdbdr2 ~]$ . .bash_profile

-- Step 52 -->> On Node 2
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
GRID_HOME=/opt/app/19c/grid; export GRID_HOME
ORACLE_HOME=$GRID_HOME; export ORACLE_HOME

PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
*/

-- Step 53 -->> On Node 2
[grid@pdbdr2 ~]$ . .bash_profile

-- Step 54 -->> On Node 1
-- To Unzio The Oracle Grid Software and lateset Opatch
[root@pdbdr1 ~]# cd /opt/app/19c/grid/
[root@pdbdr1 grid]# unzip -oq /root/Oracle_19C/19.3.0.0.0_Grid_Binary/LINUX.X64_193000_grid_home.zip
[root@pdbdr1 grid]# unzip -oq /root/Oracle_19C/OPATCH_19c/p6880880_190000_Linux-x86-64.zip

-- Step 55 -->> On Node 1
-- To Unzio The Oracle PSU
[root@pdbdr1 ~]# cd /tmp/
[root@pdbdr1 tmp]# unzip -oq /root/Oracle_19C/PSU_19.23.0.0.0/p36209493_190000_Linux-x86-64.zip
[root@pdbdr1 tmp]# chown -R oracle:oinstall 36209493
[root@pdbdr1 tmp]# chmod -R 775 36209493
[root@pdbdr1 tmp]# ls -ltr | grep 36209493
/*
drwxrwxr-x  4 oracle oinstall      80 Apr 16 16:14 36209493
*/

-- Step 56 -->> On Node 1
-- Login as root user and issue the following command at pdbdr1
[root@pdbdr1 ~]# chown -R grid:oinstall /opt/app/19c/grid/
[root@pdbdr1 ~]# chmod -R 775 /opt/app/19c/grid/

[root@pdbdr1 tmp]# su - grid
[grid@pdbdr1 ~]$ cd /opt/app/19c/grid/OPatch/
[grid@pdbdr1 OPatch]$ ./opatch version
/*
OPatch Version: 12.2.0.1.43

OPatch succeeded.
*/

-- Step 57 -->> On Node 1
[root@pdbdr1 ~]# scp -r /opt/app/19c/grid/cv/rpm/cvuqdisk-1.0.10-1.rpm root@pdbdr2:/tmp/
/*
The authenticity of host 'pdbdr2 (192.160.6.49)' can't be established.
ECDSA key fingerprint is SHA256:6NantI4crKoxtXNREfhRZ4fxdEyl+3gYXHw3Es23exU.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'pdbdr2,192.160.6.49' (ECDSA) to the list of known hosts.
root@pdbdr2's password: P@ssw0rd
cvuqdisk-1.0.10-1.rpm                                      100%   11KB   6.3MB/s   00:00
*/

-- Step 58 -->> On Node 1
-- To install the cvuqdisk-1.0.10-1.rpm
-- Login from root user
[root@pdbdr1 ~]# cd /opt/app/19c/grid/cv/rpm/

-- Step 58.1 -->> On Node 1
[root@pdbdr1 rpm]# ls -ltr
/*
-rwxrwxr-x 1 grid oinstall 11412 Mar 13  2019 cvuqdisk-1.0.10-1.rpm
*/

-- Step 58.2 -->> On Node 1
[root@pdbdr1 rpm]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP

-- Step 58.3 -->> On Node 1
[root@pdbdr1 rpm]# rpm -iUvh cvuqdisk-1.0.10-1.rpm 
/*
Preparing...                          ################################# [100%]
Updating / installing...
   1:cvuqdisk-1.0.10-1                ################################# [100%]
*/

-- Step 59 -->> On Node 2
[root@pdbdr2 ~]# cd /tmp/
[root@pdbdr2 tmp]# chown -R grid:oinstall cvuqdisk-1.0.10-1.rpm
[root@pdbdr2 tmp]# chmod -R 775 cvuqdisk-1.0.10-1.rpm
[root@pdbdr2 tmp]# ls -ltr | grep cvuqdisk-1.0.10-1.rpm
/*
-rwxrwxr-x  1 grid oinstall 11412 Sep 25 14:29 cvuqdisk-1.0.10-1.rpm
*/

-- Step 60 -->> On Node 2
-- To install the cvuqdisk-1.0.10-1.rpm
-- Login from root user
[root@pdbdr2 ~]# cd /tmp/
[root@pdbdr2 tmp]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP
[root@pdbdr2 tmp]# rpm -iUvh cvuqdisk-1.0.10-1.rpm 
/*
Preparing...                          ################################# [100%]
Updating / installing...
   1:cvuqdisk-1.0.10-1                ################################# [100%]
*/

-- Step 61 -->> On all Node
[root@pdbdr1/pdbdr2 ~]# which oracleasm
/*
/usr/sbin/oracleasm
*/

-- Step 62 -->> On all Node
[root@pdbdr1/pdbdr2 ~]# oracleasm configure
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
[root@pdbdr1/pdbdr2 ~]# oracleasm status
/*
Checking if ASM is loaded: no
Checking if /dev/oracleasm is mounted: no
*/

-- Step 64 -->> On all Node
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

-- Step 65 -->> On all Node
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

-- Step 66 -->> On all Node
[root@pdbdr1/pdbdr2 ~]# oracleasm init
/*
Creating /dev/oracleasm mount point: /dev/oracleasm
Loading module "oracleasm": oracleasm
Configuring "oracleasm" to use device physical block size
Mounting ASMlib driver filesystem: /dev/oracleasm
*/

-- Step 67 -->> On all Node
[root@pdbdr1/pdbdr2 ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 68 -->> On all Node
[root@pdbdr1/pdbdr2 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 69 -->> On all Node
[root@pdbdr1/pdbdr2 ~]# oracleasm listdisks

[root@pdbdr1/pdbdr2 ~]# ls -ltr /etc/init.d/
/*
-rwxr-xr-x  1 root root  4954 Feb  3  2018 oracleasm
-rwx------  1 root root  1281 Feb 17  2021 oracle-database-preinstall-19c-firstboot
-rw-r--r--. 1 root root 18434 Aug 10  2022 functions
-rw-r--r--. 1 root root  1161 Jun  5 18:53 README
*/

-- Step 70 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# ll /dev/oracleasm/disks/
/*
total 0
*/

-- Step 71 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# ll /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Oct  1 12:08 /dev/sda
brw-rw---- 1 root disk 8,  1 Oct  1 12:08 /dev/sda1
brw-rw---- 1 root disk 8,  2 Oct  1 12:08 /dev/sda2
brw-rw---- 1 root disk 8, 16 Oct  1 12:08 /dev/sdb
brw-rw---- 1 root disk 8, 32 Oct  1 12:08 /dev/sdc
brw-rw---- 1 root disk 8, 48 Oct  1 12:08 /dev/sdd
*/

--Step 71.1 -->> Both Node
[root@pdbdr1 ~]# lsblk
/*
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0  250G  0 disk
├─sda1                 8:1    0    1G  0 part /boot
└─sda2                 8:2    0  249G  0 part
  ├─ol_pdbdr1-root   252:0    0   70G  0 lvm  /
  ├─ol_pdbdr1-swap   252:1    0   16G  0 lvm  [SWAP]
  ├─ol_pdbdr1-usr    252:2    0   10G  0 lvm  /usr
  ├─ol_pdbdr1-opt    252:3    0   70G  0 lvm  /opt
  ├─ol_pdbdr1-home   252:4    0   10G  0 lvm  /home
  ├─ol_pdbdr1-var    252:5    0   10G  0 lvm  /var
  ├─ol_pdbdr1-tmp    252:6    0   10G  0 lvm  /tmp
  └─ol_pdbdr1-backup 252:7    0   53G  0 lvm  /backup
sdb                    8:16   0   20G  0 disk
sdc                    8:32   0  400G  0 disk
sdd                    8:48   0  200G  0 disk
sr0                   11:0    1  891M  0 rom
*/

-- Step 72 -->> On Node 1
[root@pdbdr1 ~]# fdisk -ll | grep GiB | grep sd
/*
Disk /dev/sda: 250 GiB, 268435456000 bytes, 524288000 sectors
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
Disk /dev/sdc: 400 GiB, 429496729600 bytes, 838860800 sectors
Disk /dev/sdd: 200 GiB, 214748364800 bytes, 419430400 sectors
*/

-- Step 73 -->> On Node 1
[root@pdbdr1 ~]# fdisk /dev/sdb
/*
Welcome to fdisk (util-linux 2.32.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x38c5bd98.

Command (m for help): p
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x38c5bd98

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
Disk identifier: 0x38c5bd98

Device     Boot Start      End  Sectors Size Id Type
/dev/sdb1        2048 41943039 41940992  20G 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 74 -->> On Node 1
[root@pdbdr1 ~]# fdisk  /dev/sdc
/*
Welcome to fdisk (util-linux 2.32.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x7d9d3a84.

Command (m for help): p
Disk /dev/sdc: 400 GiB, 429496729600 bytes, 838860800 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x7d9d3a84

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
Disk identifier: 0x7d9d3a84

Device     Boot Start       End   Sectors  Size Id Type
/dev/sdc1        2048 838860799 838858752  400G 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 75 -->> On Node 1
[root@pdbdr1 ~]# fdisk /dev/sdd
/*
Welcome to fdisk (util-linux 2.32.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x0351dd62.

Command (m for help): p
Disk /dev/sdd: 200 GiB, 214748364800 bytes, 419430400 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x0351dd62

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
Disk identifier: 0x0351dd62

Device     Boot Start       End   Sectors  Size Id Type
/dev/sdd1        2048 419430399 419428352  200G 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 76 -->> On Node 1
[root@pdbdr1 ~]# ll /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 Oct  1 12:08 /dev/sda
brw-rw---- 1 root disk 8,  1 Oct  1 12:08 /dev/sda1
brw-rw---- 1 root disk 8,  2 Oct  1 12:08 /dev/sda2
brw-rw---- 1 root disk 8, 16 Oct  1 15:49 /dev/sdb
brw-rw---- 1 root disk 8, 17 Oct  1 15:49 /dev/sdb1
brw-rw---- 1 root disk 8, 32 Oct  1 15:49 /dev/sdc
brw-rw---- 1 root disk 8, 33 Oct  1 15:49 /dev/sdc1
brw-rw---- 1 root disk 8, 48 Oct  1 15:50 /dev/sdd
brw-rw---- 1 root disk 8, 49 Oct  1 15:50 /dev/sdd1
*/

-- Step 77 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# fdisk -ll | grep sd
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

-- Step 77.1 -->> On Both Node
[root@pdbdr1 ~]# lsblk
/*
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0  250G  0 disk
├─sda1                 8:1    0    1G  0 part /boot
└─sda2                 8:2    0  249G  0 part
  ├─ol_pdbdr1-root   252:0    0   70G  0 lvm  /
  ├─ol_pdbdr1-swap   252:1    0   16G  0 lvm  [SWAP]
  ├─ol_pdbdr1-usr    252:2    0   10G  0 lvm  /usr
  ├─ol_pdbdr1-opt    252:3    0   70G  0 lvm  /opt
  ├─ol_pdbdr1-home   252:4    0   10G  0 lvm  /home
  ├─ol_pdbdr1-var    252:5    0   10G  0 lvm  /var
  ├─ol_pdbdr1-tmp    252:6    0   10G  0 lvm  /tmp
  └─ol_pdbdr1-backup 252:7    0   53G  0 lvm  /backup
sdb                    8:16   0   20G  0 disk
└─sdb1                 8:17   0   20G  0 part
sdc                    8:32   0  400G  0 disk
└─sdc1                 8:33   0  400G  0 part
sdd                    8:48   0  200G  0 disk
└─sdd1                 8:49   0  200G  0 part
sr0                   11:0    1  891M  0 rom
*/

-- Step 78 -->> On Node 1
[root@pdbdr1 ~]# mkfs.xfs -f /dev/sdb1
[root@pdbdr1 ~]# mkfs.xfs -f /dev/sdc1
[root@pdbdr1 ~]# mkfs.xfs -f /dev/sdd1

-- Step 79 -->> On Node 1
[root@pdbdr1 ~]# oracleasm createdisk OCR /dev/sdb1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 80 -->> On Node 1
[root@pdbdr1 ~]# oracleasm createdisk DATA /dev/sdd1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 81 -->> On Node 1
[root@pdbdr1 ~]# oracleasm createdisk ARC /dev/sdc1
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 82 -->> On Node 1
[root@pdbdr1 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 83 -->> On Node 1
[root@pdbdr1 ~]# oracleasm listdisks
/*
ARC
DATA
OCR
*/

-- Step 84 -->> On Node 2
[root@pdbdr2 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
Instantiating disk "OCR"
Instantiating disk "ARC"
Instantiating disk "DATA"
*/

-- Step 85 -->> On Node 2
[root@pdbdr2 ~]# oracleasm listdisks
/*
ARC
DATA
OCR
*/

-- Step 86 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# ll /dev/oracleasm/disks/
/*
brw-rw---- 1 grid asmadmin 8, 33 Oct  1 15:52 ARC
brw-rw---- 1 grid asmadmin 8, 49 Oct  1 15:51 DATA
brw-rw---- 1 grid asmadmin 8, 17 Oct  1 15:51 OCR
*/

-- Step 87 -->> On Node 1
-- To setup SSH Pass
[root@pdbdr1 ~]# su - grid
[grid@pdbdr1 ~]$ cd /opt/app/19c/grid/deinstall
[grid@pdbdr1 deinstall]$ ./sshUserSetup.sh -user grid -hosts "pdbdr1 pdbdr2" -noPromptPassphrase -confirm -advanced
/*
Password: grid
*/

-- Step 88 -->> On Node 1
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@pdbdr1 date
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@pdbdr2 date
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@pdbdr1 date && ssh grid@pdbdr2 date
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@pdbdr1.unidev.org.np date
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@pdbdr2.unidev.org.np date
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@pdbdr1.unidev.org.np date && ssh grid@pdbdr2.unidev.org.np date

-- Step 89 -->> On Node 1
-- Bug 30286976: To Solve the Pre-check or any Oracle relavant Installation for rac Setup make compatible version CV_ASSUME_DISTID=OEL7.6
[grid@pdbdr1 ~]$ vi /opt/app/19c/grid/cv/admin/cvu_config
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
[grid@pdbdr1 ~]$ cat /opt/app/19c/grid/cv/admin/cvu_config | grep -E CV_ASSUME_DISTID
/*
CV_ASSUME_DISTID=OEL7.6
*/

-- Step 89.2 -->> On Node 1
-- To solve the Pre-check for rac Setup, from remote nodes PRVG-2002
/*
Verifying resolv.conf Integrity ...FAILED
pdbdr2: PRVG-2002 : Encountered error in copying file "/etc/resolv.conf" from
      node "pdbdr2" to node "pdbdr1"
      protocol error: filename does not match request

Verifying DNS/NIS name service ...FAILED
pdbdr2: PRVG-2002 : Encountered error in copying file "/etc/nsswitch.conf" from
      node "pdbdr2" to node "pdbdr1"
      protocol error: filename does not match request
*/
[root@pdbdr1 ~]# cp -p /usr/bin/scp /usr/bin/scp-original

-- Step 89.3 -->> On Node 1
[root@pdbdr1 ~]# echo "/usr/bin/scp-original -T \$*" > /usr/bin/scp

-- Step 89.4 -->> On Node 1
[root@pdbdr1 ~]# cat /usr/bin/scp
/*
/usr/bin/scp-original -T $*
*/

-- Step 89.5 -->> On Node 1
-- Pre-check for rac Setup
[grid@pdbdr1 ~]$ cd /opt/app/19c/grid/
[grid@pdbdr1 grid]$ export CV_ASSUME_DISTID=OEL7.6
[grid@pdbdr1 grid]$ ./runcluvfy.sh stage -pre crsinst -n pdbdr1,pdbdr2 -verbose
[grid@pdbdr1 grid]$ export CV_ASSUME_DISTID=OEL7.6
[grid@pdbdr1 grid]$ ./runcluvfy.sh stage -pre crsinst -n pdbdr1,pdbdr2 -method root
--[grid@pdbdr1 grid]$ ./runcluvfy.sh stage -pre crsinst -n pdbdr1,pdbdr2 -fixup -verbose (If Required)

-- Step 90 -->> On Node 1
-- To Create a Response File to Install GID
[grid@pdbdr1 ~]$ cp /opt/app/19c/grid/install/response/gridsetup.rsp /home/grid/
[grid@pdbdr1 ~]$ cd /home/grid/
[grid@pdbdr1 ~]$ ls -ltr | grep gridsetup.rsp
/*
-rwxr-xr-x 1 grid oinstall 36221 Oct  1 15:59 gridsetup.rsp
*/

-- Step 90.1 -->> On Node 1
[grid@pdbdr1 ~]$ vi gridsetup.rsp
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
oracle.install.crs.config.gpnp.scanName=pdbdr-scan
oracle.install.crs.config.gpnp.scanPort=1521
oracle.install.crs.config.ClusterConfiguration=STANDALONE
oracle.install.crs.config.configureAsExtendedCluster=false
oracle.install.crs.config.clusterName=pdbdr-cluster
oracle.install.crs.config.gpnp.configureGNS=false
oracle.install.crs.config.autoConfigureClusterNodeVIP=false
oracle.install.crs.config.clusterNodes=pdbdr1:pdbdr1-vip,pdbdr2:pdbdr2-vip
oracle.install.crs.config.networkInterfaceList=ens160:192.160.6.0:1,ens192:10.10.10.0:5
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
[grid@pdbdr1 ~]$ cd /opt/app/19c/grid/
[grid@pdbdr1 grid]$ OPatch/opatch version
/*
OPatch Version: 12.2.0.1.43

OPatch succeeded.
*/

-- Step 91 -->> On Node 1
-- To Install Grid Software with Leteset Opatch
[grid@pdbdr1 ~]$ cd /opt/app/19c/grid/
[grid@pdbdr1 grid]$ export CV_ASSUME_DISTID=OEL7.6
[grid@pdbdr1 grid]$ ./gridSetup.sh -ignorePrereq -waitForCompletion -silent -applyRU /tmp/36209493/36233126 -responseFile /home/grid/gridsetup.rsp
/*
Preparing the home to patch...
Applying the patch /tmp/36209493/36233126...
Successfully applied the patch.
The log can be found at: /tmp/GridSetupActions2024-10-01_04-08-53PM/installerPatchActions_2024-10-01_04-08-53PM.log
Launching Oracle Grid Infrastructure Setup Wizard...

[WARNING] [INS-13014] Target environment does not meet some optional requirements.
   CAUSE: Some of the optional prerequisites are not met. See logs for details. gridSetupActions2024-10-01_04-08-53PM.log
   ACTION: Identify the list of failed prerequisite checks from the log: gridSetupActions2024-10-01_04-08-53PM.log. Then either from the log file or from installation manual find the appropriate configuration to meet the prerequisites and fix it manually.
The response file for this session can be found at:
 /opt/app/19c/grid/install/response/grid_2024-10-01_04-08-53PM.rsp

You can find the log of this install session at:
 /tmp/GridSetupActions2024-10-01_04-08-53PM/gridSetupActions2024-10-01_04-08-53PM.log

As a root user, execute the following script(s):
        1. /opt/app/oraInventory/orainstRoot.sh
        2. /opt/app/19c/grid/root.sh

Execute /opt/app/oraInventory/orainstRoot.sh on the following nodes:
[pdbdr1, pdbdr2]
Execute /opt/app/19c/grid/root.sh on the following nodes:
[pdbdr1, pdbdr2]

Run the script on the local node first. After successful completion, you can start the script in parallel on all other nodes.

Successfully Setup Software with warning(s).
As install user, execute the following command to complete the configuration.
        /opt/app/19c/grid/gridSetup.sh -executeConfigTools -responseFile /home/grid/gridsetup.rsp [-silent]


Moved the install session logs to:
 /opt/app/oraInventory/logs/GridSetupActions2024-10-01_04-08-53PM
*/

-- Step 92 -->> On Node 1
[root@pdbdr1 ~]# /opt/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 93 -->> On Node 2
[root@pdbdr2 ~]# /opt/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 94 -->> On Node 1
[root@pdbdr1 ~]# /opt/app/19c/grid/root.sh
/*
Check /opt/app/19c/grid/install/root_pdbdr1.unidev.org.np_2024-10-01_16-30-40-465246838.log for the output of root script
*/

-- Step 94.1 -->> On Node 1
[root@pdbdr1 ~]#  tail -f /opt/app/19c/grid/install/root_pdbdr1.unidev.org.np_2024-10-01_16-30-40-465246838.log
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
  /opt/app/oracle/crsdata/pdbdr1/crsconfig/rootcrs_pdbdr1_2024-10-01_04-31-00PM.log
2024/10/01 16:31:12 CLSRSC-594: Executing installation step 1 of 19: 'ValidateEnv'.
2024/10/01 16:31:12 CLSRSC-363: User ignored prerequisites during installation
2024/10/01 16:31:12 CLSRSC-594: Executing installation step 2 of 19: 'CheckFirstNode'.
2024/10/01 16:31:15 CLSRSC-594: Executing installation step 3 of 19: 'GenSiteGUIDs'.
2024/10/01 16:31:16 CLSRSC-594: Executing installation step 4 of 19: 'SetupOSD'.
Redirecting to /bin/systemctl restart rsyslog.service
2024/10/01 16:31:16 CLSRSC-594: Executing installation step 5 of 19: 'CheckCRSConfig'.
2024/10/01 16:31:17 CLSRSC-594: Executing installation step 6 of 19: 'SetupLocalGPNP'.
2024/10/01 16:31:34 CLSRSC-594: Executing installation step 7 of 19: 'CreateRootCert'.
2024/10/01 16:31:40 CLSRSC-594: Executing installation step 8 of 19: 'ConfigOLR'.
2024/10/01 16:31:59 CLSRSC-594: Executing installation step 9 of 19: 'ConfigCHMOS'.
2024/10/01 16:31:59 CLSRSC-594: Executing installation step 10 of 19: 'CreateOHASD'.
2024/10/01 16:32:07 CLSRSC-594: Executing installation step 11 of 19: 'ConfigOHASD'.
2024/10/01 16:32:07 CLSRSC-330: Adding Clusterware entries to file 'oracle-ohasd.service'
2024/10/01 16:32:36 CLSRSC-594: Executing installation step 12 of 19: 'SetupTFA'.
2024/10/01 16:32:36 CLSRSC-594: Executing installation step 13 of 19: 'InstallAFD'.
2024/10/01 16:32:36 CLSRSC-594: Executing installation step 14 of 19: 'InstallACFS'.
2024/10/01 16:33:26 CLSRSC-594: Executing installation step 15 of 19: 'InstallKA'.
2024/10/01 16:33:33 CLSRSC-594: Executing installation step 16 of 19: 'InitConfig'.

ASM has been created and started successfully.

[DBT-30001] Disk groups created successfully. Check /opt/app/oracle/cfgtoollogs/asmca/asmca-241001PM043406.log for details.

2024/10/01 16:34:56 CLSRSC-482: Running command: '/opt/app/19c/grid/bin/ocrconfig -upgrade grid oinstall'
CRS-4256: Updating the profile
Successful addition of voting disk 45b08e7fd4874f69bf644fbe37244d61.
Successfully replaced voting disk group with +OCR.
CRS-4256: Updating the profile
CRS-4266: Voting file(s) successfully replaced
##  STATE    File Universal Id                File Name Disk group
--  -----    -----------------                --------- ---------
 1. ONLINE   45b08e7fd4874f69bf644fbe37244d61 (/dev/oracleasm/disks/OCR) [OCR]
Located 1 voting disk(s).
2024/10/01 16:36:14 CLSRSC-594: Executing installation step 17 of 19: 'StartCluster'.
2024/10/01 16:36:18 CLSRSC-4002: Successfully installed Oracle Trace File Analyzer (TFA) Collector.
2024/10/01 16:37:22 CLSRSC-343: Successfully started Oracle Clusterware stack
2024/10/01 16:37:22 CLSRSC-594: Executing installation step 18 of 19: 'ConfigNode'.
2024/10/01 16:38:56 CLSRSC-594: Executing installation step 19 of 19: 'PostConfig'.
2024/10/01 16:39:26 CLSRSC-325: Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 95 -->> On Node 2
[root@pdbdr2 ~]# /opt/app/19c/grid/root.sh
/*
Check /opt/app/19c/grid/install/root_pdbdr2.unidev.org.np_2024-10-01_16-40-47-678789188.log for the output of root script
*/

-- Step 95.1 -->> On Node 2 
[root@pdbdr2 ~]# tail -f /opt/app/19c/grid/install/root_pdbdr2.unidev.org.np_2024-10-01_16-40-47-678789188.log
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
  /opt/app/oracle/crsdata/pdbdr2/crsconfig/rootcrs_pdbdr2_2024-10-01_04-41-13PM.log
2024/10/01 16:41:18 CLSRSC-594: Executing installation step 1 of 19: 'ValidateEnv'.
2024/10/01 16:41:18 CLSRSC-363: User ignored prerequisites during installation
2024/10/01 16:41:18 CLSRSC-594: Executing installation step 2 of 19: 'CheckFirstNode'.
2024/10/01 16:41:20 CLSRSC-594: Executing installation step 3 of 19: 'GenSiteGUIDs'.
2024/10/01 16:41:20 CLSRSC-594: Executing installation step 4 of 19: 'SetupOSD'.
Redirecting to /bin/systemctl restart rsyslog.service
2024/10/01 16:41:21 CLSRSC-594: Executing installation step 5 of 19: 'CheckCRSConfig'.
2024/10/01 16:41:21 CLSRSC-594: Executing installation step 6 of 19: 'SetupLocalGPNP'.
2024/10/01 16:41:23 CLSRSC-594: Executing installation step 7 of 19: 'CreateRootCert'.
2024/10/01 16:41:23 CLSRSC-594: Executing installation step 8 of 19: 'ConfigOLR'.
2024/10/01 16:41:36 CLSRSC-594: Executing installation step 9 of 19: 'ConfigCHMOS'.
2024/10/01 16:41:36 CLSRSC-594: Executing installation step 10 of 19: 'CreateOHASD'.
2024/10/01 16:41:38 CLSRSC-594: Executing installation step 11 of 19: 'ConfigOHASD'.
2024/10/01 16:41:38 CLSRSC-330: Adding Clusterware entries to file 'oracle-ohasd.service'
2024/10/01 16:42:02 CLSRSC-594: Executing installation step 12 of 19: 'SetupTFA'.
2024/10/01 16:42:02 CLSRSC-594: Executing installation step 13 of 19: 'InstallAFD'.
2024/10/01 16:42:02 CLSRSC-594: Executing installation step 14 of 19: 'InstallACFS'.
2024/10/01 16:42:45 CLSRSC-594: Executing installation step 15 of 19: 'InstallKA'.
2024/10/01 16:42:47 CLSRSC-594: Executing installation step 16 of 19: 'InitConfig'.
2024/10/01 16:42:56 CLSRSC-594: Executing installation step 17 of 19: 'StartCluster'.
2024/10/01 16:43:37 CLSRSC-343: Successfully started Oracle Clusterware stack
2024/10/01 16:43:37 CLSRSC-594: Executing installation step 18 of 19: 'ConfigNode'.
2024/10/01 16:43:57 CLSRSC-594: Executing installation step 19 of 19: 'PostConfig'.
2024/10/01 16:44:07 CLSRSC-325: Configure Oracle Grid Infrastructure for a Cluster ... succeeded
2024/10/01 16:45:15 CLSRSC-4002: Successfully installed Oracle Trace File Analyzer (TFA) Collector.
*/

-- Step 96 -->> On Node 1
[grid@pdbdr1 ~]$ cd /opt/app/19c/grid/
[grid@pdbdr1 grid]$ export CV_ASSUME_DISTID=OEL7.6
[grid@pdbdr1 grid]$ /opt/app/19c/grid/gridSetup.sh -silent -executeConfigTools -responseFile /home/grid/gridsetup.rsp
/*
Launching Oracle Grid Infrastructure Setup Wizard...

You can find the logs of this session at:
/opt/app/oraInventory/logs/GridSetupActions2024-10-01_04-46-10PM

You can find the log of this install session at:
 /opt/app/oraInventory/logs/UpdateNodeList2024-10-01_04-46-10PM.log
Successfully Configured Software.
*/

-- Step 96.1 -->> On Node 1
[root@pdbdr1 ~]# tail -f /opt/app/oraInventory/logs/UpdateNodeList2024-10-01_04-46-10PM.log
/*
INFO: Command execution completes for node : pdbdr2
INFO: Command execution sucess for node : pdbdr2
INFO: All threads completed its operations
INFO: Checkpoint:Index file written and updated
INFO: Done calling doOperation.
INFO: 'UpdateNodeList' was successful.
*/

-- Step 97 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# cd /opt/app/19c/grid/bin/
[root@pdbdr1/pdbdr2 bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/


-- Step 98 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# cd /opt/app/19c/grid/bin/
[root@pdbdr1/pdbdr2 bin]# ./crsctl check cluster -all
/*
**************************************************************
pdbdr1:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
pdbdr2:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/

-- Step 99 -->> On Node 1
[root@pdbdr1 ~]# cd /opt/app/19c/grid/bin/
[root@pdbdr1 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdbdr1                   Started,STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.crf
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.crsd
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.cssd
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.ctssd
      1        ONLINE  ONLINE       pdbdr1                   OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.drivers.acfs
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.evmd
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.gipcd
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.gpnpd
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.mdnsd
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.storage
      1        ONLINE  ONLINE       pdbdr1                   STABLE
--------------------------------------------------------------------------------
*/


-- Step 100 -->> On Node 2
[root@pdbdr2 ~]# cd /opt/app/19c/grid/bin/
[root@pdbdr2 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.crf
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.crsd
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.cssd
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.ctssd
      1        ONLINE  ONLINE       pdbdr2                   OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.drivers.acfs
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.evmd
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.gipcd
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.gpnpd
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.mdnsd
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.storage
      1        ONLINE  ONLINE       pdbdr2                   STABLE
--------------------------------------------------------------------------------
*/

-- Step 101 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# cd /opt/app/19c/grid/bin/
[root@pdbdr1/pdbdr2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       pdbdr1                   STABLE
               ONLINE  ONLINE       pdbdr2                   STABLE
ora.chad
               ONLINE  ONLINE       pdbdr1                   STABLE
               ONLINE  ONLINE       pdbdr2                   STABLE
ora.net1.network
               ONLINE  ONLINE       pdbdr1                   STABLE
               ONLINE  ONLINE       pdbdr2                   STABLE
ora.ons
               ONLINE  ONLINE       pdbdr1                   STABLE
               ONLINE  ONLINE       pdbdr2                   STABLE
ora.proxy_advm
               OFFLINE OFFLINE      pdbdr1                   STABLE
               OFFLINE OFFLINE      pdbdr2                   STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   STABLE
      2        ONLINE  ONLINE       pdbdr2                   STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   STABLE
      2        ONLINE  ONLINE       pdbdr2                   STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   Started,STABLE
      2        ONLINE  ONLINE       pdbdr2                   Started,STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   STABLE
      2        ONLINE  ONLINE       pdbdr2                   STABLE
ora.cvu
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.pdbdr1.vip
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.pdbdr2.vip
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.qosmserver
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.scan3.vip
      1        ONLINE  ONLINE       pdbdr1                   STABLE
--------------------------------------------------------------------------------
*/


-- Step 102 -->> On Both Nodes
[grid@pdbdr1/pdbdr2 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20112                0           20112              0             Y  OCR/
ASMCMD [+] > exit
*/

-- Step 103 -->> On Node 1
[grid@pdbdr1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 04-OCT-2024 11:03:31

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                01-OCT-2024 16:39:16
Uptime                    2 days 18 hr. 24 min. 15 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.48)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.50)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 103.1 -->> On Node 1
[grid@pdbdr1 ~]$ ps -ef | grep SCAN
/*
grid       57347       1  0 Oct01 ?        00:00:06 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid       57383       1  0 Oct01 ?        00:00:06 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid     2363070 2362345  0 11:03 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 103.2 -->> On Node 1
[grid@pdbdr1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 04-OCT-2024 11:04:02

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                01-OCT-2024 16:38:40
Uptime                    2 days 18 hr. 25 min. 23 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.53)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 103.3 -->> On Node 1
[grid@pdbdr1 ~]$ lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 04-OCT-2024 11:04:15

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                01-OCT-2024 16:38:41
Uptime                    2 days 18 hr. 25 min. 33 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener_scan3/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN3)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.54)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 103.4 -->> On Node 2
[grid@pdbdr2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 04-OCT-2024 11:03:33

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                01-OCT-2024 16:44:02
Uptime                    2 days 18 hr. 19 min. 30 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.49)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.51)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 103.5 -->> On Node 2
[grid@pdbdr2 ~]$ ps -ef | grep SCAN
/*
grid       62436       1  0 Oct01 ?        00:00:06 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid     2292887 2291950  0 11:04 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 103.6 -->> On Node 2
[grid@pdbdr2 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 04-OCT-2024 11:04:51

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                01-OCT-2024 16:43:41
Uptime                    2 days 18 hr. 21 min. 10 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr2/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.52)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 104 -->> On Node 2
-- Bug 30286976: To Solve the Pre-check or any Oracle relavant Installation for rac Setup make compatible version CV_ASSUME_DISTID=OEL7.6
[grid@pdbdr2 ~]$ vi /opt/app/19c/grid/cv/admin/cvu_config
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
[grid@pdbdr2 ~]$ cat /opt/app/19c/grid/cv/admin/cvu_config | grep -E CV_ASSUME_DISTID
/*
CV_ASSUME_DISTID=OEL7.6
*/

-- Step 105 -->> On Node 1
-- To Create ASM storage for Data and Archive 
[grid@pdbdr1 ~]$ cd /opt/app/19c/grid/bin
[grid@pdbdr1 bin]$ export CV_ASSUME_DISTID=OEL7.6

-- Step 105.1 -->> On Node 1
[grid@pdbdr1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName DATA -diskList /dev/oracleasm/disks/DATA -redundancy EXTERNAL

-- Step 105.2 -->> On Node 1
[grid@pdbdr1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName ARC -diskList /dev/oracleasm/disks/ARC -redundancy EXTERNAL

-- Step 106 -->> On Both Nodes
[grid@pdbdr1/pdbdr2 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri Oct 4 11:07:21 2024
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
[root@pdbdr1/pdbdr2 ~]# cd /opt/app/19c/grid/bin
[root@pdbdr1/pdbdr2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       pdbdr1                   STABLE
               ONLINE  ONLINE       pdbdr2                   STABLE
ora.chad
               ONLINE  ONLINE       pdbdr1                   STABLE
               ONLINE  ONLINE       pdbdr2                   STABLE
ora.net1.network
               ONLINE  ONLINE       pdbdr1                   STABLE
               ONLINE  ONLINE       pdbdr2                   STABLE
ora.ons
               ONLINE  ONLINE       pdbdr1                   STABLE
               ONLINE  ONLINE       pdbdr2                   STABLE
ora.proxy_advm
               OFFLINE OFFLINE      pdbdr1                   STABLE
               OFFLINE OFFLINE      pdbdr2                   STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ARC.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   STABLE
      2        ONLINE  ONLINE       pdbdr2                   STABLE
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   STABLE
      2        ONLINE  ONLINE       pdbdr2                   STABLE
ora.DATA.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   STABLE
      2        ONLINE  ONLINE       pdbdr2                   STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   STABLE
      2        ONLINE  ONLINE       pdbdr2                   STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   Started,STABLE
      2        ONLINE  ONLINE       pdbdr2                   Started,STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   STABLE
      2        ONLINE  ONLINE       pdbdr2                   STABLE
ora.cvu
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.pdbdr1.vip
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.pdbdr2.vip
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.qosmserver
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.scan3.vip
      1        ONLINE  ONLINE       pdbdr1                   STABLE
--------------------------------------------------------------------------------
*/

-- Step 108 -->> On Both Nodes
[grid@pdbdr1/pdbdr2 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  1048576    409599   409485                0          409485              0             N  ARC/
MOUNTED  EXTERN  N         512             512   4096  1048576    204799   204689                0          204689              0             N  DATA/
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20136                0           20136              0             Y  OCR/
ASMCMD [+] > exit
*/

-- Step 109 -->> On Node 1
[root@pdbdr1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/19c/grid:N
*/

-- Step 110 -->> On Node 2
[root@pdbdr2 ~]# vi /etc/oratab
/*
+ASM2:/opt/app/19c/grid:N
*/

-- Step 111 -->> On Both Nodes
-- Creating the Oracle RDBMS Home Directory
[root@pdbdr1/pdbdr2 ~]# mkdir -p /opt/app/oracle/product/19c/db_1
[root@pdbdr1/pdbdr2 ~]# chown -R oracle:oinstall /opt/app/oracle/product/19c/db_1
[root@pdbdr1/pdbdr2 ~]# chmod -R 775 /opt/app/oracle/product/19c/db_1

-- Step 111.1 -->> On Node 1
-- To unzip the Oracle Binary and Letest Opatch
[root@pdbdr1 ~]# cd /opt/app/oracle/product/19c/db_1
[root@pdbdr1 db_1]# unzip -oq /root/Oracle_19C/19.3.0.0.0_DB_Binary/LINUX.X64_193000_db_home.zip
[root@pdbdr1 db_1]# unzip -oq /root/Oracle_19C/OPATCH_19c/p6880880_190000_Linux-x86-64.zip

-- Step 111.2 -->> On Node 1
[root@pdbdr1 ~]# chown -R oracle:oinstall /opt/app/oracle/product/19c/db_1/
[root@pdbdr1 ~]# chmod -R 775 /opt/app/oracle/product/19c/db_1/

-- Step 111.3 -->> On Node 1
[root@pdbdr1 ~]# su - oracle
[oracle@pdbdr1 ~]$ /opt/app/oracle/product/19c/db_1/OPatch/opatch version
/*
OPatch Version: 12.2.0.1.43

OPatch succeeded.
*/

-- Step 112 -->> On Node 1
-- To Setup the SSH Connectivity 
[root@pdbdr1 ~]# su - oracle
[oracle@pdbdr1 ~]$ cd /opt/app/oracle/product/19c/db_1/deinstall/
[oracle@pdbdr1 deinstall]$ ./sshUserSetup.sh -user oracle -hosts "pdbdr1 pdbdr2" -noPromptPassphrase -confirm -advanced
/*
Password: oracle
*/
-- Step 113 -->> On Both Nodes
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@pdbdr1 date
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@pdbdr2 date
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@pdbdr1 date && ssh oracle@pdbdr2 date
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@pdbdr1.unidev.org.np date
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@pdbdr2.unidev.org.np date
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@pdbdr1.unidev.org.np date && ssh oracle@pdbdr2.unidev.org.np date

-- Step 114 -->> On Node 1
-- To Create a responce file for Oracle Software Installation
[oracle@pdbdr1 ~]$ cp /opt/app/oracle/product/19c/db_1/install/response/db_install.rsp /home/oracle/
[oracle@pdbdr1 ~]$ cd /home/oracle/

-- Step 114.1 -->> On Node 1
[oracle@pdbdr1 ~]$ ll
/*
-rwxr-xr-x 1 oracle oinstall 19932 Oct  4 11:15 db_install.rsp
*/

-- Step 114.2 -->> On Node 1
[oracle@pdbdr1 ~]$ vi db_install.rsp
/*
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v19.0.0
oracle.install.option=INSTALL_DB_SWONLY
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/opt/app/oraInventory
ORACLE_HOME=/opt/app/oracle/product/19c/db_1
ORACLE_BASE=/opt/app/oracle
oracle.install.db.InstallEdition=EE
ORACLE_HOSTNAME=pdbdr1.unidev.org.np
SELECTED_LANGUAGES=en
oracle.install.db.OSDBA_GROUP=dba
oracle.install.db.OSOPER_GROUP=oper
oracle.install.db.OSBACKUPDBA_GROUP=backupdba
oracle.install.db.OSDGDBA_GROUP=dgdba
oracle.install.db.OSKMDBA_GROUP=kmdba
oracle.install.db.OSRACDBA_GROUP=racdba
oracle.install.db.rootconfig.executeRootScript=false
oracle.install.db.CLUSTER_NODES=pdbdr1,pdbdr2
oracle.install.db.config.starterdb.type=GENERAL_PURPOSE
oracle.install.db.ConfigureAsContainerDB=false
*/

-- Step 114.3 -->> On Node 1
[oracle@pdbdr1 ~]$ vi /opt/app/oracle/product/19c/db_1/cv/admin/cvu_config
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
[oracle@pdbdr1 ~]$ cat /opt/app/oracle/product/19c/db_1/cv/admin/cvu_config | grep -E 'CV_ASSUME_DISTID'
/*
CV_ASSUME_DISTID=OEL7.6
*/

-- Step 115 -->> On Node 1
-- To install Oracle Software with Letest Opatch
[oracle@pdbdr1 ~]$ cd /opt/app/oracle/product/19c/db_1/
[oracle@pdbdr1 db_1]$ export CV_ASSUME_DISTID=OEL7.6
[oracle@pdbdr1 db_1]$ ./runInstaller -ignorePrereq -waitforcompletion -silent \
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
The log can be found at: /opt/app/oraInventory/logs/InstallActions2024-10-04_11-19-23AM/installerPatchActions_2024-10-04_11-19-23AM.log
Launching Oracle Database Setup Wizard...

The response file for this session can be found at:
 /opt/app/oracle/product/19c/db_1/install/response/db_2024-10-04_11-19-23AM.rsp

You can find the log of this install session at:
 /opt/app/oraInventory/logs/InstallActions2024-10-04_11-19-23AM/installActions2024-10-04_11-19-23AM.log

As a root user, execute the following script(s):
        1. /opt/app/oracle/product/19c/db_1/root.sh

Execute /opt/app/oracle/product/19c/db_1/root.sh on the following nodes:
[pdbdr1, pdbdr2]


Successfully Setup Software.
*/

-- Step 116 -->> On Node 1
[root@pdbdr1 ~]# /opt/app/oracle/product/19c/db_1/root.sh
/*
Check /opt/app/oracle/product/19c/db_1/install/root_pdbdr1.unidev.org.np_2024-10-04_11-43-22-149224463.log for the output of root script
*/

-- Step 116.1 -->> On Node 1
[root@pdbdr1 ~]# tail -f  /opt/app/oracle/product/19c/db_1/install/root_pdbdr1.unidev.org.np_2024-10-04_11-43-22-149224463.log
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
[root@pdbdr2 ~]# /opt/app/oracle/product/19c/db_1/root.sh
/*
Check /opt/app/oracle/product/19c/db_1/install/root_pdbdr2.unidev.org.np_2024-10-04_11-44-35-589470588.log for the output of root script
*/

-- Step 117.1 -->> On Node 2
[root@pdbdr2 ~]# tail -f /opt/app/oracle/product/19c/db_1/install/root_pdbdr2.unidev.org.np_2024-10-04_11-44-35-589470588.log
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
[root@pdbdr1 ~]# cd /tmp/
[root@pdbdr1 tmp]$ export CV_ASSUME_DISTID=OEL7.6
[root@pdbdr1 tmp]# export ORACLE_HOME=/opt/app/oracle/product/19c/db_1
[root@pdbdr1 tmp]# export PATH=${ORACLE_HOME}/bin:$PATH
[root@pdbdr1 tmp]# export PATH=${PATH}:${ORACLE_HOME}/OPatch

-- Step 118.1 -->> On Node 1
[root@pdbdr1 tmp]# which opatchauto
/*
/opt/app/oracle/product/19c/db_1/OPatch/opatchauto
*/

-- Step 119 -->> On Node 1
[root@pdbdr1 tmp]# opatchauto apply /tmp/36209493/36199232 -oh /opt/app/oracle/product/19c/db_1 --nonrolling
/*
OPatchauto session is initiated at Fri Oct  4 11:46:00 2024

System initialization log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchautodb/s                                                                                                ystemconfig2024-10-04_11-46-05AM.log.

Session log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/opatchauto2024-10-04_11-46-27AM.log
The id for this session is RG3V

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

Host:pdbdr1
RAC Home:/opt/app/oracle/product/19c/db_1
Version:19.0.0.0.0
Summary:

==Following patches were SUCCESSFULLY applied:

Patch: /tmp/36209493/36199232
Log: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2024-10-04_11-47-30AM_1.log

OPatchauto session completed at Fri Oct  4 11:49:47 2024
Time taken to complete the session 3 minutes, 47 seconds
*/

-- Step 119.1 -->> On Node 1
[root@pdbdr1 ~]# tail -f /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2024-10-04_11-47-30AM_1.log
/*
[Oct 4, 2024 11:49:44 AM] [INFO]    Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/NApply/2024-10-04_11-47-30AM/restore.sh"
[Oct 4, 2024 11:49:44 AM] [INFO]    Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/NApply/2024-10-04_11-47-30AM/make.txt"
[Oct 4, 2024 11:49:44 AM] [INFO]    Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/36199232_Mar_12_2024_17_07_05/scratch/joxwtp.o"
[Oct 4, 2024 11:49:44 AM] [INFO]    [OPSR-TIME] Backup area for restore has been cleaned up. For a complete list of files/directories deleted, Please refer log file.
[Oct 4, 2024 11:49:44 AM] [INFO]    Patch 36199232 successfully applied.
[Oct 4, 2024 11:49:44 AM] [INFO]    UtilSession: N-Apply done.
[Oct 4, 2024 11:49:44 AM] [INFO]    Finishing UtilSession at Fri Oct 04 11:49:44 NPT 2024
[Oct 4, 2024 11:49:44 AM] [INFO]    Log file location: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2024-10-04_11-47-30AM_1.log
[Oct 4, 2024 11:49:44 AM] [INFO]    EXITING METHOD: NApply(patches,options)
*/

-- Step 120 -->> On Node 1
[root@pdbdr1 ~]# scp -r /tmp/36209493/ root@pdbdr2:/tmp/

-- Step 121 -->> On Node 2
[root@pdbdr2 ~]# cd /tmp/
[root@pdbdr2 tmp]# chown -R oracle:oinstall 36209493
[root@pdbdr2 tmp]# chmod -R 775 36209493

-- Step 121.1 -->> On Node 2
[root@pdbdr2 tmp]# ls -ltr | grep 36209493
/*
drwxrwxr-x  4 oracle oinstall     80 Oct  4 11:54 36209493
*/

-- Step 122 -->> On Node 2
-- To applying the Oracle PSU on Remote Node 2
[root@pdbdr2 ~]# cd /tmp/
[root@pdbdr1 tmp]$ export CV_ASSUME_DISTID=OEL7.6
[root@pdbdr2 tmp]# export ORACLE_HOME=/opt/app/oracle/product/19c/db_1
[root@pdbdr2 tmp]# export PATH=${ORACLE_HOME}/bin:$PATH
[root@pdbdr2 tmp]# export PATH=${PATH}:${ORACLE_HOME}/OPatch

-- Step 122.1 -->> On Node 2
[root@pdbdr2 tmp]# which opatchauto
/*
/opt/app/oracle/product/19c/db_1/OPatch/opatchauto
*/

-- Step 123 -->> On Node 2
[root@pdbdr2 tmp]# opatchauto apply /tmp/36209493/36199232 -oh /opt/app/oracle/product/19c/db_1 --nonrolling
/*
OPatchauto session is initiated at Fri Oct  4 11:56:10 2024

System initialization log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchautodb/systemconfig2024-10-04_11-56-15AM.log.

Session log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/opatchauto2024-10-04_11-56-38AM.log
The id for this session is 9MUI

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

Host:pdbdr2
RAC Home:/opt/app/oracle/product/19c/db_1
Version:19.0.0.0.0
Summary:

==Following patches were SUCCESSFULLY applied:

Patch: /tmp/36209493/36199232
Log: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2024-10-04_11-57-40AM_1.log



OPatchauto session completed at Fri Oct  4 12:00:09 2024
Time taken to complete the session 3 minutes, 59 seconds
*/

-- Step 123.1 -->> On Node 2
[root@pdbdr2 ~]# tail -f /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2024-10-04_11-57-40AM_1.log
/*
[Oct 4, 2024 12:00:07 PM] [INFO]    Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/NApply/2024-10-04_11-57-40AM/restore.sh"
[Oct 4, 2024 12:00:07 PM] [INFO]    Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/NApply/2024-10-04_11-57-40AM/make.txt"
[Oct 4, 2024 12:00:07 PM] [INFO]    Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/36199232_Mar_12_2024_17_07_05/scratch/joxwtp.o"
[Oct 4, 2024 12:00:07 PM] [INFO]    [OPSR-TIME] Backup area for restore has been cleaned up. For a complete list of files/directories deleted, Please refer log file.
[Oct 4, 2024 12:00:07 PM] [INFO]    Patch 36199232 successfully applied.
[Oct 4, 2024 12:00:07 PM] [INFO]    UtilSession: N-Apply done.
[Oct 4, 2024 12:00:07 PM] [INFO]    Finishing UtilSession at Fri Oct 04 12:00:07 NPT 2024
[Oct 4, 2024 12:00:07 PM] [INFO]    Log file location: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2024-10-04_11-57-40AM_1.log
[Oct 4, 2024 12:00:07 PM] [INFO]    EXITING METHOD: NApply(patches,options)
*/

-- Step 124 -->> On Both Nodes (DC and DR)
--########################################################################--
[root@pdb1/pdb2/pdbdr1/pdbdr2 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

##############################DC##################################
# Public
192.160.6.21   pdb1.unidev.org.np        pdb1
192.160.6.22   pdb2.unidev.org.np        pdb2

# Private
10.10.10.21   pdb1-priv.unidev.org.np   pdb1-priv
10.10.10.22   pdb2-priv.unidev.org.np   pdb2-priv

# Virtual
192.160.6.23   pdb1-vip.unidev.org.np    pdb1-vip
192.160.6.24   pdb2-vip.unidev.org.np    pdb2-vip

# SCAN
192.160.6.25   pdb-scan.unidev.org.np    pdb-scan
192.160.6.26   pdb-scan.unidev.org.np    pdb-scan
192.160.6.27   pdb-scan.unidev.org.np    pdb-scan

##############################DR##################################
# Public
192.160.6.48   pdbdr1.unidev.org.np        pdbdr1
192.160.6.49   pdbdr2.unidev.org.np        pdbdr2

# Private
10.10.10.48   pdbdr1-priv.unidev.org.np   pdbdr1-priv
10.10.10.49   pdbdr2-priv.unidev.org.np   pdbdr2-priv

# Virtual
192.160.6.50   pdbdr1-vip.unidev.org.np    pdbdr1-vip
192.160.6.51   pdbdr2-vip.unidev.org.np    pdbdr2-vip

# SCAN
192.160.6.52   pdbdr-scan.unidev.org.np    pdbdr-scan
192.160.6.53   pdbdr-scan.unidev.org.np    pdbdr-scan
192.160.6.54   pdbdr-scan.unidev.org.np    pdbdr-scan
*/

-- Step 125 -->> On Both Nodes - DC & DR
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

-- Step 126 -->> On Both Node's - DC
-- Enable Archive
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is running on node pdb1
Instance pdbdb2 is running on node pdb2
*/

-- Step 127 -->> On Both Node's - DC
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 128 -->> On Node 1 - DC
[oracle@pdb1 ~]$ srvctl stop database -d pdbdb
[oracle@pdb1 ~]$ srvctl start database -d pdbdb -o mount
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Mounted (Closed).
Instance pdbdb2 is running on node pdb2. Instance status: Mounted (Closed).
*/

[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri Oct 4 12:50:42 2024
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
         2 PDB$SEED                       MOUNTED
         3 SBXPDB                         MOUNTED

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
SQL> ALTER SYSTEM SET DB_RECOVERY_FILE_DEST='+DATA' SCOPE=BOTH SID='*';
SQL> ALTER SYSTEM SET DB_RECOVERY_FILE_DEST_SIZE=10G SCOPE=BOTH SID='*';

SQL> archive log list;

Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     102
Next log sequence to archive   103
Current log sequence           103

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
         1 PDBDB     pdbdb1           MOUNTED      04-OCT-24 pdb1.unidev.org.np      MOUNTED    ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED
         2 PDBDB     pdbdb2           MOUNTED      04-OCT-24 pdb2.unidev.org.np      MOUNTED    ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED

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
         1 PDBDB     pdbdb1           MOUNTED      04-OCT-24 pdb1.unidev.org.np      MOUNTED    ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED
         2 PDBDB     pdbdb2           MOUNTED      04-OCT-24 pdb2.unidev.org.np      MOUNTED    ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED

--SQL> ALTER USER sys IDENTIFIED BY "Sys605014";
--SQL> ALTER USER sys IDENTIFIED BY "Sys605014" container=all;

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 129 -->> On Node 1 - DC
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Mounted (Closed).
Instance pdbdb2 is running on node pdb2. Instance status: Mounted (Closed).
*/
[oracle@pdb1 ~]$ srvctl stop database -d pdbdb
[oracle@pdb1 ~]$ srvctl start database -d pdbdb

-- Step 130 -->> On Both Nodes - DC
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is running on node pdb1
Instance pdbdb2 is running on node pdb2
*/

-- Step 130.1 -->> On Both Nodes - DC
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 131 -->> On Node 1 - DC
[grid@pdb1 ~]$ srvctl config database -d pdbdb | grep pwd
/*
Password file: +DATA/PDBDB/PASSWORD/pwdpdbdb.256.1181045219
*/

-- Step 132 -->> On Node 1 - DC
[grid@pdb1 ~]$ asmcmd -p
/*
ASMCMD [+] > cd +DATA/PDBDB/PASSWORD

ASMCMD [+DATA/PDBDB/PASSWORD] > ls
pwdpdbdb.256.1181045219

ASMCMD [+DATA/PDBDB/PASSWORD] > ls -lt
Type      Redund  Striped  Time             Sys  Name
PASSWORD  UNPROT  COARSE   SEP 30 12:00:00  Y    pwdpdbdb.256.1181045219

ASMCMD [+DATA/PDBDB/PASSWORD] > pwcopy pwdpdbdb.256.1181045219 /tmp
copying +DATA/PDBDB/PASSWORD/pwdpdbdb.256.1181045219 -> /tmp/pwdpdbdb.256.1181045219

ASMCMD [+DATA/PDBDB/PASSWORD] > ls -lt
Type      Redund  Striped  Time             Sys  Name
PASSWORD  UNPROT  COARSE   SEP 30 12:00:00  Y    pwdpdbdb.256.1181045219

ASMCMD [+DATA/PDBDB/PASSWORD] > exit
*/

-- Step 133 -->> On Node 1 - DC
[grid@pdb1 ~]$ cd /tmp/
[grid@pdb1 tmp]$ ls -lrth pwdpdbdb.256.1181045219
/*
-rw-r----- 1 grid oinstall 2.0K May 29 11:19 pwdpdbdb.256.1181045219
*/

-- Step 134 -->> On Node 1 - DC
[grid@pdb1 ~]$ cd /tmp/
[grid@pdb1 tmp]$ scp -p pwdpdbdb.256.1181045219 oracle@pdbdr1:/opt/app/oracle/product/19c/db_1/dbs/orapwpdbdb1
/*
The authenticity of host 'pdbdr1 (192.160.6.48)' can't be established.
ECDSA key fingerprint is SHA256:B1/tTpbAVGmVTp+5F0MRHCwB1ayv1KW34IFg6GQZ7kM.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'pdbdr1,192.160.6.48' (ECDSA) to the list of known hosts.
oracle@pdbdr1's password: oracle
pwdpdbdb.256.1181045219           100% 2048     1.1MB/s   00:00
*/

-- Step 135 -->> On Node 1 - DC
[grid@pdb1 tmp]$ scp -p pwdpdbdb.256.1181045219 oracle@pdbdr2:/opt/app/oracle/product/19c/db_1/dbs/orapwpdbdb2
/*
The authenticity of host 'pdbdr2 (192.160.6.49)' can't be established.
ECDSA key fingerprint is SHA256:pLO3V4qhnDL39RTklg9ioMGs2yDSOt5ktrIdRzHo+pA.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'pdbdr2,192.160.6.49' (ECDSA) to the list of known hosts.
oracle@pdbdr2's password: oracle
pwdpdbdb.256.1181045219            100% 2048     1.6MB/s   00:00
*/

-- Step 135.1 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri Oct 4 13:01:20 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> show parameter pfile

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
spfile                               string      +DATA/PDBDB/PARAMETERFILE/spfile.272.1181047863

SQL> create pfile='/home/oracle/spfilepdbdb.ora' from spfile;

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           OPEN         04-OCT-24 pdb1.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED
         2 PDBDB     pdbdb2           OPEN         04-OCT-24 pdb2.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 SBXPDB                         READ WRITE NO

SQL> connect sys/Sys605014@SBXPDB as sysdba
Connected.

SQL> SELECT name, open_mode,force_logging FROM gv$database;

NAME                 OPEN_MODE  FORCE_LOGGING
-------------------- ---------- ---------------------------------------
PDBDB                READ WRITE YES
PDBDB                READ WRITE YES

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 136 -->> On Node 1 - DC
[oracle@pdb1 ~]$  sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri Oct 4 13:03:48 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           OPEN         04-OCT-24 pdb1.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED
         2 PDBDB     pdbdb2           OPEN         04-OCT-24 pdb2.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED

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

    GROUP# STATUS  TYPE    MEMBER                                             IS_     CON_ID
---------- ------- ------- -------------------------------------------------- --- ----------
         1         ONLINE  +ARC/PDBDB/ONLINELOG/group_1.257.1181045387        YES          0
         1         ONLINE  +DATA/PDBDB/ONLINELOG/group_1.262.1181045385       NO           0
         2         ONLINE  +ARC/PDBDB/ONLINELOG/group_2.258.1181045387        YES          0
         2         ONLINE  +DATA/PDBDB/ONLINELOG/group_2.263.1181045385       NO           0
         3         ONLINE  +DATA/PDBDB/ONLINELOG/group_3.270.1181047861       NO           0
         3         ONLINE  +ARC/PDBDB/ONLINELOG/group_3.259.1181047863        YES          0
         4         ONLINE  +DATA/PDBDB/ONLINELOG/group_4.271.1181047863       NO           0
         4         ONLINE  +ARC/PDBDB/ONLINELOG/group_4.260.1181047863        YES          0

SQL> ALTER DATABASE ADD LOGFILE MEMBER '+DATA' ,'+DATA' to group 1;
SQL> ALTER DATABASE ADD LOGFILE MEMBER '+DATA' ,'+DATA' to group 2;
SQL> ALTER DATABASE ADD LOGFILE MEMBER '+DATA' ,'+DATA' to group 3;
SQL> ALTER DATABASE ADD LOGFILE MEMBER '+DATA' ,'+DATA' to group 4;
SQL> ALTER DATABASE ADD LOGFILE THREAD 1 GROUP 5 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD LOGFILE THREAD 2 GROUP 6 ('+DATA' ,'+DATA') SIZE 50M;

SQL> SELECT group#, archived, status FROM v$log;

    GROUP# ARC STATUS
---------- --- ----------------
         1 YES INACTIVE
         2 NO  CURRENT
         3 YES INACTIVE
         4 NO  CURRENT
         5 YES UNUSED
         6 YES UNUSED

--Delete the original log member (Note: Switch to a non-current log for deletion)
--alter system switch logfile;
--alter system checkpoint;

SQL> ALTER DATABASE DROP LOGFILE MEMBER '+ARC/PDBDB/ONLINELOG/group_1.257.1181045387';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+DATA/PDBDB/ONLINELOG/group_1.262.1181045385';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+ARC/PDBDB/ONLINELOG/group_2.258.1181045387';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+DATA/PDBDB/ONLINELOG/group_2.263.1181045385';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+DATA/PDBDB/ONLINELOG/group_3.270.1181047861';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+ARC/PDBDB/ONLINELOG/group_3.259.1181047863';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+DATA/PDBDB/ONLINELOG/group_4.271.1181047863';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+ARC/PDBDB/ONLINELOG/group_4.260.1181047863';

SQL> SELECT * FROM v$logfile a ORDER BY a.type,a.group#;

    GROUP# STATUS  TYPE    MEMBER                                             IS_     CON_ID
---------- ------- ------- -------------------------------------------------- --- ----------
         1         ONLINE  +DATA/PDBDB/ONLINELOG/group_1.280.1181480709       NO           0
         1         ONLINE  +DATA/PDBDB/ONLINELOG/group_1.281.1181480709       NO           0
         2         ONLINE  +DATA/PDBDB/ONLINELOG/group_2.282.1181480715       NO           0
         2         ONLINE  +DATA/PDBDB/ONLINELOG/group_2.283.1181480715       NO           0
         3         ONLINE  +DATA/PDBDB/ONLINELOG/group_3.284.1181480719       NO           0
         3         ONLINE  +DATA/PDBDB/ONLINELOG/group_3.285.1181480719       NO           0
         4         ONLINE  +DATA/PDBDB/ONLINELOG/group_4.286.1181480725       NO           0
         4         ONLINE  +DATA/PDBDB/ONLINELOG/group_4.287.1181480725       NO           0
         5         ONLINE  +DATA/PDBDB/ONLINELOG/group_5.288.1181480731       NO           0
         5         ONLINE  +DATA/PDBDB/ONLINELOG/group_5.289.1181480731       NO           0
         6         ONLINE  +DATA/PDBDB/ONLINELOG/group_6.290.1181480737       NO           0
         6         ONLINE  +DATA/PDBDB/ONLINELOG/group_6.291.1181480737       NO           0

SQL> SELECT b.thread#,a.group#,a.member,b.bytes FROM v$logfile a, v$log b  WHERE a.group#=b.group# ORDER BY b.group#;

   THREAD#     GROUP# MEMBER                                                  BYTES
---------- ---------- -------------------------------------------------- ----------
         1          1 +DATA/PDBDB/ONLINELOG/group_1.280.1181480709         52428800
         1          1 +DATA/PDBDB/ONLINELOG/group_1.281.1181480709         52428800
         1          2 +DATA/PDBDB/ONLINELOG/group_2.282.1181480715         52428800
         1          2 +DATA/PDBDB/ONLINELOG/group_2.283.1181480715         52428800
         2          3 +DATA/PDBDB/ONLINELOG/group_3.284.1181480719         52428800
         2          3 +DATA/PDBDB/ONLINELOG/group_3.285.1181480719         52428800
         2          4 +DATA/PDBDB/ONLINELOG/group_4.286.1181480725         52428800
         2          4 +DATA/PDBDB/ONLINELOG/group_4.287.1181480725         52428800
         1          5 +DATA/PDBDB/ONLINELOG/group_5.288.1181480731         52428800
         1          5 +DATA/PDBDB/ONLINELOG/group_5.289.1181480731         52428800
         2          6 +DATA/PDBDB/ONLINELOG/group_6.290.1181480737         52428800
         2          6 +DATA/PDBDB/ONLINELOG/group_6.291.1181480737         52428800

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
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.262.1181481203         52428800
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.263.1181481203         52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.270.1181481205         52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.271.1181481203         52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.292.1181481205         52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.293.1181481205         52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.294.1181481205        52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.295.1181481205        52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.296.1181481205        52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.297.1181481205        52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.298.1181481205        52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.299.1181481207        52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.300.1181481207        52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.301.1181481207        52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.302.1181481207        52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.303.1181481207        52428800

--Node 2
SQL> SELECT b.thread#,a.group#, a.type, a.member, b.bytes FROM v$logfile a, v$standby_log b WHERE a.group# = b.group# ORDER BY 2,4;

   THREAD#     GROUP# TYPE    MEMBER                                                  BYTES
---------- ---------- ------- -------------------------------------------------- ----------
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.262.1181481203         52428800
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.263.1181481203         52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.270.1181481205         52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.271.1181481203         52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.292.1181481205         52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.293.1181481205         52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.294.1181481205        52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.295.1181481205        52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.296.1181481205        52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.297.1181481205        52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.298.1181481205        52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.299.1181481207        52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.300.1181481207        52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.301.1181481207        52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.302.1181481207        52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.303.1181481207        52428800

SQL> SELECT * FROM v$logfile order by 1;

    GROUP# STATUS  TYPE    MEMBER                                             IS_     CON_ID
---------- ------- ------- -------------------------------------------------- --- ----------
         1         ONLINE  +DATA/PDBDB/ONLINELOG/group_1.281.1181480709       NO           0
         1         ONLINE  +DATA/PDBDB/ONLINELOG/group_1.280.1181480709       NO           0
         2         ONLINE  +DATA/PDBDB/ONLINELOG/group_2.282.1181480715       NO           0
         2         ONLINE  +DATA/PDBDB/ONLINELOG/group_2.283.1181480715       NO           0
         3         ONLINE  +DATA/PDBDB/ONLINELOG/group_3.284.1181480719       NO           0
         3         ONLINE  +DATA/PDBDB/ONLINELOG/group_3.285.1181480719       NO           0
         4         ONLINE  +DATA/PDBDB/ONLINELOG/group_4.286.1181480725       NO           0
         4         ONLINE  +DATA/PDBDB/ONLINELOG/group_4.287.1181480725       NO           0
         5         ONLINE  +DATA/PDBDB/ONLINELOG/group_5.289.1181480731       NO           0
         5         ONLINE  +DATA/PDBDB/ONLINELOG/group_5.288.1181480731       NO           0
         6         ONLINE  +DATA/PDBDB/ONLINELOG/group_6.290.1181480737       NO           0
         6         ONLINE  +DATA/PDBDB/ONLINELOG/group_6.291.1181480737       NO           0
         7         STANDBY +DATA/PDBDB/ONLINELOG/group_7.263.1181481203       NO           0
         7         STANDBY +DATA/PDBDB/ONLINELOG/group_7.262.1181481203       NO           0
         8         STANDBY +DATA/PDBDB/ONLINELOG/group_8.270.1181481205       NO           0
         8         STANDBY +DATA/PDBDB/ONLINELOG/group_8.271.1181481203       NO           0
         9         STANDBY +DATA/PDBDB/ONLINELOG/group_9.293.1181481205       NO           0
         9         STANDBY +DATA/PDBDB/ONLINELOG/group_9.292.1181481205       NO           0
        10         STANDBY +DATA/PDBDB/ONLINELOG/group_10.294.1181481205      NO           0
        10         STANDBY +DATA/PDBDB/ONLINELOG/group_10.295.1181481205      NO           0
        11         STANDBY +DATA/PDBDB/ONLINELOG/group_11.296.1181481205      NO           0
        11         STANDBY +DATA/PDBDB/ONLINELOG/group_11.297.1181481205      NO           0
        12         STANDBY +DATA/PDBDB/ONLINELOG/group_12.298.1181481205      NO           0
        12         STANDBY +DATA/PDBDB/ONLINELOG/group_12.299.1181481207      NO           0
        13         STANDBY +DATA/PDBDB/ONLINELOG/group_13.300.1181481207      NO           0
        13         STANDBY +DATA/PDBDB/ONLINELOG/group_13.301.1181481207      NO           0
        14         STANDBY +DATA/PDBDB/ONLINELOG/group_14.302.1181481207      NO           0
        14         STANDBY +DATA/PDBDB/ONLINELOG/group_14.303.1181481207      NO           0


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
[ ONLINE REDO LOG ]        1      1          1        118 +DATA/PDBDB/ONLINELOG/group_1.280.1181480709                 CURRENT          NO              50
[ ONLINE REDO LOG ]        1      1          1        118 +DATA/PDBDB/ONLINELOG/group_1.281.1181480709                 CURRENT          NO              50
[ ONLINE REDO LOG ]        1      2          1        116 +DATA/PDBDB/ONLINELOG/group_2.282.1181480715                 INACTIVE         YES             50
[ ONLINE REDO LOG ]        1      2          1        116 +DATA/PDBDB/ONLINELOG/group_2.283.1181480715                 INACTIVE         YES             50
[ ONLINE REDO LOG ]        1      5          1        117 +DATA/PDBDB/ONLINELOG/group_5.288.1181480731                 ACTIVE           YES             50
[ ONLINE REDO LOG ]        1      5          1        117 +DATA/PDBDB/ONLINELOG/group_5.289.1181480731                 ACTIVE           YES             50
[ STANDBY REDO LOG ]       1      7          1          0 +DATA/PDBDB/ONLINELOG/group_7.262.1181481203                 UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      7          1          0 +DATA/PDBDB/ONLINELOG/group_7.263.1181481203                 UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      8          1          0 +DATA/PDBDB/ONLINELOG/group_8.270.1181481205                 UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      8          1          0 +DATA/PDBDB/ONLINELOG/group_8.271.1181481203                 UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      9          1          0 +DATA/PDBDB/ONLINELOG/group_9.292.1181481205                 UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      9          1          0 +DATA/PDBDB/ONLINELOG/group_9.293.1181481205                 UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1     10          1          0 +DATA/PDBDB/ONLINELOG/group_10.294.1181481205                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1     10          1          0 +DATA/PDBDB/ONLINELOG/group_10.295.1181481205                UNASSIGNED       YES             50

--At Node 2 (pdb2)
REDOLOG_FILE_TYPE    INST_ID GROUP#    THREAD#  SEQUENCE# MEMBER                                                       STATUS           ARCHIVE    SIZE_MB
-------------------- ------- ------ ---------- ---------- ------------------------------------------------------------ ---------------- ------- ----------
[ ONLINE REDO LOG ]        2      3          2         15 +DATA/PDBDB/ONLINELOG/group_3.284.1181480719                 CURRENT          NO              50
[ ONLINE REDO LOG ]        2      3          2         15 +DATA/PDBDB/ONLINELOG/group_3.285.1181480719                 CURRENT          NO              50
[ ONLINE REDO LOG ]        2      4          2         13 +DATA/PDBDB/ONLINELOG/group_4.286.1181480725                 INACTIVE         YES             50
[ ONLINE REDO LOG ]        2      4          2         13 +DATA/PDBDB/ONLINELOG/group_4.287.1181480725                 INACTIVE         YES             50
[ ONLINE REDO LOG ]        2      6          2         14 +DATA/PDBDB/ONLINELOG/group_6.290.1181480737                 INACTIVE         YES             50
[ ONLINE REDO LOG ]        2      6          2         14 +DATA/PDBDB/ONLINELOG/group_6.291.1181480737                 INACTIVE         YES             50
[ STANDBY REDO LOG ]       2     11          2          0 +DATA/PDBDB/ONLINELOG/group_11.296.1181481205                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     11          2          0 +DATA/PDBDB/ONLINELOG/group_11.297.1181481205                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     12          2          0 +DATA/PDBDB/ONLINELOG/group_12.298.1181481205                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     12          2          0 +DATA/PDBDB/ONLINELOG/group_12.299.1181481207                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     13          2          0 +DATA/PDBDB/ONLINELOG/group_13.300.1181481207                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     13          2          0 +DATA/PDBDB/ONLINELOG/group_13.301.1181481207                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     14          2          0 +DATA/PDBDB/ONLINELOG/group_14.302.1181481207                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     14          2          0 +DATA/PDBDB/ONLINELOG/group_14.303.1181481207                UNASSIGNED       YES             50

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 137 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri Oct 4 13:16:56 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

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
SQL> ALTER system SET fal_server ='dr' sid='*';
SQL> ALTER system SET STANDBY_FILE_MANAGEMENT=AUTO scope=spfile sid='*';
SQL> ALTER system SET db_file_name_convert='+DATA/PDBDB/','+DATA/DR/', '+ARC/PDBDB/','+ARC/DR/' scope=spfile sid='*';
SQL> ALTER system SET log_file_name_convert='+DATA/PDBDB/','+DATA/DR/', '+ARC/PDBDB/','+ARC/DR/' scope=spfile sid='*';
SQL> ALTER system SET db_recovery_file_dest_size=50G scope=both sid='*';
SQL> exit

*/



-- Step 138 -->> On Both Nodes - DC
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 138.1 -->> On Node 1 - DC
[oracle@pdb1 ~]$ srvctl stop database -d pdbdb

-- Step 138.2 -->> On Node 1 - DC
[oracle@pdb1 ~]$ srvctl start database -d pdbdb

-- Step 139 -->> On Both Nodes - DC
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is running on node pdb1
Instance pdbdb2 is running on node pdb2
*/

-- Step 139.1 -->> On Both Nodes - DC
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 140 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Oct 6 15:36:27 2024
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

pdbdb2.__data_transfer_cache_size=0
pdbdb1.__data_transfer_cache_size=0
pdbdb2.__db_cache_size=7952400384
pdbdb1.__db_cache_size=7952400384
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
pdbdb2.__shared_pool_size=1509949440
pdbdb1.__shared_pool_size=1509949440
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
*.db_file_name_convert='+DATA/PDBDB/','+DATA/DR/','+ARC/PDBDB/','+ARC/DR/'
*.db_name='pdbdb'
*.db_recovery_file_dest='+ARC'
*.db_recovery_file_dest_size=53687091200
*.diagnostic_dest='/opt/app/oracle'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=pdbdbXDB)'
*.enable_pluggable_database=true
*.fal_client='pdbdb'
*.fal_server='dr'
family:dw_helper.instance_mode='read-only'
pdbdb2.instance_number=2
pdbdb1.instance_number=1
*.local_listener='-oraagent-dummy-'
*.log_archive_config='DG_CONFIG=(pdbdb,dr)'
*.log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=pdbdb'
*.log_archive_dest_2='SERVICE=dr VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=dr'
*.log_archive_dest_state_1='ENABLE'
*.log_archive_dest_state_2='ENABLE'
*.log_archive_format='pdbdb_%t_%s_%r.arc'
*.log_archive_max_processes=30
*.log_file_name_convert='+DATA/PDBDB/','+DATA/DR/','+ARC/PDBDB/','+ARC/DR/'
*.nls_language='AMERICAN'
*.nls_territory='AMERICA'
*.open_cursors=300
*.pga_aggregate_target=3072m
*.processes=320
*.remote_login_passwordfile='EXCLUSIVE'
*.sga_target=9216m
*.standby_file_management='AUTO'
pdbdb2.thread=2
pdbdb1.thread=1
pdbdb2.undo_tablespace='UNDOTBS2'
pdbdb1.undo_tablespace='UNDOTBS1'

SQL> !ps -ef | grep tns
root          35       2  0 Oct04 ?        00:00:00 [netns]
grid        9965       1  0 Oct04 ?        00:01:20 /opt/app/19c/grid/bin/tnslsnr ASMNET1LSNR_ASM -no_crs_notify -inherit
grid       10219       1  0 Oct04 ?        00:00:05 /opt/app/19c/grid/bin/tnslsnr LISTENER -no_crs_notify -inherit
grid       10254       1  0 Oct04 ?        00:00:05 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid       10265       1  0 Oct04 ?        00:00:05 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
oracle   1838378 1837578  0 15:38 pts/0    00:00:00 /bin/bash -c ps -ef | grep tns
oracle   1838380 1838378  0 15:38 pts/0    00:00:00 grep tns

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 141 -->> On Node 1 - DC
[grid@pdb1 ~]$ cat /opt/app/19c/grid/network/admin/listener.ora
/*
LISTENER=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER))))            # line added by Agent
LISTENER_SCAN3=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3))))                # line added by Agent
LISTENER_SCAN2=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2))))                # line added by Agent
LISTENER_SCAN1=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1))))                # line added by Agent
ASMNET1LSNR_ASM=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=ASMNET1LSNR_ASM))))              # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_ASMNET1LSNR_ASM=ON               # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_ASMNET1LSNR_ASM=SUBNET         # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN1=ON                # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_LISTENER_SCAN1=OFF             # line added by Agent - Disabled by Agent because REMOTE_REGISTRATION_ADDRESS is set
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN2=ON                # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_LISTENER_SCAN2=OFF             # line added by Agent - Disabled by Agent because REMOTE_REGISTRATION_ADDRESS is set
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN3=ON                # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_LISTENER_SCAN3=OFF             # line added by Agent - Disabled by Agent because REMOTE_REGISTRATION_ADDRESS is set
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER=ON                      # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_LISTENER=SUBNET                # line added by Agent
*/

-- Step 142 -->> On Node 1 - DC
[grid@pdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 06-OCT-2024 15:39:25

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                04-OCT-2024 12:04:17
Uptime                    2 days 3 hr. 35 min. 7 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.21)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.23)(PORT=1521)))
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

-- Step 143 -->> On Node 2 - DC
[grid@pdb2 ~]$ cat /opt/app/19c/grid/network/admin/listener.ora
/*
LISTENER_SCAN2=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2))))                # line added by Agent
LISTENER_SCAN3=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3))))                # line added by Agent
LISTENER=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER))))            # line added by Agent
LISTENER_SCAN1=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1))))                # line added by Agent
ASMNET1LSNR_ASM=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=ASMNET1LSNR_ASM))))              # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_ASMNET1LSNR_ASM=ON               # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_ASMNET1LSNR_ASM=SUBNET         # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN1=ON                # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_LISTENER_SCAN1=OFF             # line added by Agent - Disabled by Agent because REMOTE_REGISTRATION_ADDRESS is set
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER=ON              # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_LISTENER=SUBNET                # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN3=ON                # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_LISTENER_SCAN3=OFF             # line added by Agent - Disabled by Agent because REMOTE_REGISTRATION_ADDRESS is set
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN2=ON                # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_LISTENER_SCAN2=OFF             # line added by Agent - Disabled by Agent because REMOTE_REGISTRATION_ADDRESS is set
*/

-- Step 144 -->> On Node 2 - DC
[grid@pdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 06-OCT-2024 15:40:35

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                04-OCT-2024 12:04:34
Uptime                    2 days 3 hr. 36 min. 1 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.22)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.24)(PORT=1521)))
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

-- Step 145 -->> On Node 1 - DC
[oracle@pdb1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 145.1 -->> On Node 1 - DC
[oracle@pdb1 admin]$ vi tnsnames.ora
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
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.160.6.21)(PORT = 1521))
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
      (SERVICE_NAME = SBXPDB)
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

-- Step 146 -->> On Node 1 - DC
[oracle@pdb1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 146.1 -->> On Node 1 - DC
[oracle@pdb1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 146.2 -->> On Node 1 - DC
[oracle@pdb1 admin]$ scp -r tnsnames.ora pdb2:/opt/app/oracle/product/19c/db_1/network/admin
/*
tnsnames.ora                                                              100%  895     1.2MB/s   00:00
*/

-- Step 147 -->> On Node 2 - DC
[oracle@pdb2 ~]$ cd $ORACLE_HOME/network/admin

-- Step 147.1 -->> On Node 2 - DC
[oracle@pdb2 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 147.2 -->> On Node 2 - DC
[oracle@pdb2 admin]$ vi tnsnames.ora
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
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.160.6.22)(PORT = 1521))
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
      (SERVICE_NAME = SBXPDB)
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

-- Step 148 -->> On Node 1 - DC
[oracle@pdb1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 148.1 -->> On Node 1 - DC
[oracle@pdb1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 148.2 -->> On Node 1 - DC
[oracle@pdb1 admin]$ scp -r tnsnames.ora pdbdr1:/opt/app/oracle/product/19c/db_1/network/admin
/*
oracle@pdbdr1's password: oracle
tnsnames.ora                                               100%  866   127.5KB/s   00:00
*/

-- Step 148.3 -->> On Node 1 - DC
[oracle@pdb1 admin]$ scp -r tnsnames.ora pdbdr2:/opt/app/oracle/product/19c/db_1/network/admin
/*
oracle@pdbdr2's password: oracle
tnsnames.ora                                               100%  866   369.7KB/s   00:00
*/

-- Step 149 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 149.1 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 149.2 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ vi tnsnames.ora
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

DR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr1.unidev.org.np)(PORT = 1541))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = dr)(UR=A)
    )
  )
*/

-- Step 150 -->> On Node 2 - DR
[oracle@pdbdr2 ~]$ cd $ORACLE_HOME/network/admin

-- Step 150.1 -->> On Node 2 - DR
[oracle@pdbdr2 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 150.2 -->> On Node 2 - DR
[oracle@pdbdr2 admin]$ cat tnsnames.ora
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

DR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr1.unidev.org.np)(PORT = 1541))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = dr)(UR=A)
    )
  )
*/

-- Step 151 -->> On Node 1 - DC
[oracle@pdb1 ~]$ cd /home/oracle/

-- Step 151.1 -->> On Node 1 - DC
[oracle@pdb1 ~]$ ll initpdbdb.ora
/*
-rw-r--r-- 1 oracle asmadmin 2463 Oct  6 15:37 initpdbdb.ora
*/

-- Step 151.2 -->> On Node 1 - DC
[oracle@pdb1 ~]$ scp -r initpdbdb.ora pdbdr1:/opt/app/oracle/product/19c/db_1/dbs/initpdbdb1.ora
/*
oracle@pdbdr1's password:
initpdbdb.ora                                              100% 2518     1.7MB/s   00:00
*/

-- Step 152 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/dbs

-- Step 152.1 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ ll initpdbdb1.ora
/*
-rw-r--r-- 1 oracle oinstall 2463 Oct  6 15:49 initpdbdb1.ora
*/

-- Step 152.2 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ vi initpdbdb1.ora
/*
*.audit_file_dest='/opt/app/oracle/admin/pdbdb/adump'
*.audit_trail='db'
*.cluster_database=false
*.compatible='19.0.0'
*.control_files='+DATA/DR/CONTROLFILE/current.261.1181045383','+ARC/DR/CONTROLFILE/current.256.1181045383'
*.db_block_size=8192
*.db_create_file_dest='+DATA'
*.db_file_name_convert='+DATA/PDBDB/','+DATA/DR/','+ARC/PDBDB/','+ARC/DR/'
*.db_name='pdbdb'
*.db_unique_name='dr'
*.db_recovery_file_dest='+ARC'
*.db_recovery_file_dest_size=53687091200
*.diagnostic_dest='/opt/app/oracle'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=pdbdbXDB)'
*.enable_pluggable_database=true
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
*.pga_aggregate_target=3072m
*.processes=640
*.remote_login_passwordfile='EXCLUSIVE'
*.sga_target=9216m
*.sga_max_size=9216m
*.standby_file_management='AUTO'
pdbdb1.thread=1
pdbdb1.undo_tablespace='UNDOTBS1'
*/

-- Step 153 -->> On Both Node's - DR /opt/app/oracle/admin/pdbdb/adump
--[root@pdbdr1/pdbdr2 ~]# mkdir -p /opt/app/oracle/admin/pdbdb/hdump
--[root@pdbdr1/pdbdr2 ~]# mkdir -p /opt/app/oracle/admin/pdbdb/dpdump
--[root@pdbdr1/pdbdr2 ~]# mkdir -p /opt/app/oracle/admin/pdbdb/pfile
[root@pdbdr1/pdbdr2 ~]# mkdir -p /opt/app/oracle/admin/pdbdb/adump
[root@pdbdr1/pdbdr2 ~]# cd /opt/app/oracle/admin/
[root@pdbdr1/pdbdr2 admin]# chown -R oracle:oinstall pdbdb/
[root@pdbdr1/pdbdr2 admin]# chmod -R 775 pdbdb/

-- Step 154 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ asmcmd -p
/*
ASMCMD [+] > ls
ARC/
DATA/
OCR/
ASMCMD [+] > cd +ARC
ASMCMD [+ARC] > cd +ARC
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

-- Step 155 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ env | grep ORA
/*
ORACLE_UNQNAME=pdbdb
ORACLE_SID=pdbdb1
ORACLE_BASE=/opt/app/oracle
ORACLE_HOME=/opt/app/oracle/product/19c/db_1
ORACLE_HOSTNAME=pdbdr1.unidev.org.np
*/

-- Step 156 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Thu May 30 13:26:54 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> startup nomount pfile='/opt/app/oracle/product/19c/db_1/dbs/initpdbdb1.ora';
ORACLE instance started.

Total System Global Area 9663673304 bytes
Fixed Size                  9188312 bytes
Variable Size            1476395008 bytes
Database Buffers         8153726976 bytes
Redo Buffers               24363008 bytes

SQL> show parameter db_unique_name

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_unique_name                       string      dr

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 156 -->> On Node 1 - DR
--Creating temporary listener 
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 156.1 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 156.2 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ vi listener.ora
/*
SID_LIST_LISTENER1 =
  (SID_LIST =
    (SID_DESC =
      (GLOBAL_DBNAME = dr)
      (ORACLE_HOME = /opt/app/oracle/product/19c/db_1)
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

-- Step 156.3 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ ll listener.ora
/*
-rw-r--r-- 1 oracle oinstall 312 Oct  6 16:59 listener.ora
*/

-- Step 156.4 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ lsnrctl start listener1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 06-OCT-2024 17:00:05

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Starting /opt/app/oracle/product/19c/db_1/bin/tnslsnr: please wait...

TNSLSNR for Linux: Version 19.0.0.0.0 - Production
System parameter file is /opt/app/oracle/product/19c/db_1/network/admin/listener.ora
Log messages written to /opt/app/oracle/product/19c/db_1/network/log/listener1.log
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))
STATUS of the LISTENER
------------------------
Alias                     listener1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                06-OCT-2024 17:00:05
Uptime                    0 days 0 hr. 0 min. 0 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/oracle/product/19c/db_1/network/admin/listener.ora
Listener Log File         /opt/app/oracle/product/19c/db_1/network/log/listener1.log
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))
Services Summary...
Service "dr" has 1 instance(s).
  Instance "pdbdb1", status UNKNOWN, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 156.5 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ lsnrctl status listener1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 06-OCT-2024 17:00:48

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))
STATUS of the LISTENER
------------------------
Alias                     listener1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                06-OCT-2024 17:00:05
Uptime                    0 days 0 hr. 0 min. 43 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/oracle/product/19c/db_1/network/admin/listener.ora
Listener Log File         /opt/app/oracle/product/19c/db_1/network/log/listener1.log
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))
Services Summary...
Service "dr" has 1 instance(s).
  Instance "pdbdb1", status UNKNOWN, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 156.6 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ sqlplus sys/Sys605014@pdbdb as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Oct 6 17:01:23 2024
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
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 156.7 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ sqlplus sys/Sys605014@dr as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Oct 6 17:02:03 2024
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
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 156.8 -->> On Node 1 - DC
[oracle@pdb1 ~]$ tnsping dr
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 06-OCT-2024 17:03:56

Copyright (c) 1997, 2024, Oracle.  All rights reserved.

Used parameter files:

Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr1.unidev.org.np)(PORT = 1541)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = dr)(UR=A)))
OK (0 msec)
*/

-- Step 156.9 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ tnsping pdbdb
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 06-OCT-2024 17:03:58

Copyright (c) 1997, 2024, Oracle.  All rights reserved.

Used parameter files:

Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr1.unidev.org.np)(PORT = 1541)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = dr)(UR=A)))
OK (0 msec)
*/

-- Step 157 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus sys/Sys605014@pdbdb as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Oct 6 17:04:50 2024
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
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 157.1 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus sys/Sys605014@dr as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Oct 6 17:05:47 2024
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
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 158 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 158.1 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/


-- Step 158.2 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ rman target sys/Sys605014@pdbdb auxiliary sys/Sys605014@dr
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Sun Oct 6 17:07:09 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB (DBID=3239152647)
connected to auxiliary database: PDBDB (not mounted)

RMAN> duplicate target database for standby from active database DB_FILE_NAME_CONVERT '+DATA/PDBDB/','+DATA/DR/','+ARC/PDBDB/','+ARC/DR/';

Starting Duplicate Db at 06-OCT-24
using target database control file instead of recovery catalog
allocated channel: ORA_AUX_DISK_1
channel ORA_AUX_DISK_1: SID=12 device type=DISK

contents of Memory Script:
{
   backup as copy reuse
   passwordfile auxiliary format  '/opt/app/oracle/product/19c/db_1/dbs/orapwpdbdb1'   ;
}
executing Memory Script

Starting backup at 06-OCT-24
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=33 instance=pdbdb2 device type=DISK
Finished backup at 06-OCT-24

contents of Memory Script:
{
   sql clone "create spfile from memory";
   shutdown clone immediate;
   startup clone nomount;
   restore clone from service  'pdbdb' standby controlfile;
}
executing Memory Script

sql statement: create spfile from memory

Oracle instance shut down

connected to auxiliary database (not started)
Oracle instance started

Total System Global Area    9663673304 bytes

Fixed Size                     9188312 bytes
Variable Size               1476395008 bytes
Database Buffers            8153726976 bytes
Redo Buffers                  24363008 bytes

Starting restore at 06-OCT-24
allocated channel: ORA_AUX_DISK_1
channel ORA_AUX_DISK_1: SID=506 device type=DISK

channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: restoring control file
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:02
output file name=+DATA/DR/CONTROLFILE/current.257.1181668105
output file name=+ARC/DR/CONTROLFILE/current.257.1181668105
Finished restore at 06-OCT-24

contents of Memory Script:
{
   sql clone 'alter database mount standby database';
}
executing Memory Script

sql statement: alter database mount standby database
RMAN-05529: warning: DB_FILE_NAME_CONVERT resulted in invalid ASM names; names changed to disk group only.

contents of Memory Script:
{
   set newname for tempfile  1 to
 "+DATA";
   set newname for tempfile  2 to
 "+DATA";
   set newname for tempfile  3 to
 "+DATA";
   switch clone tempfile all;
   set newname for datafile  1 to
 "+DATA";
   set newname for datafile  3 to
 "+DATA";
   set newname for datafile  4 to
 "+DATA";
   set newname for datafile  5 to
 "+DATA";
   set newname for datafile  6 to
 "+DATA";
   set newname for datafile  7 to
 "+DATA";
   set newname for datafile  8 to
 "+DATA";
   set newname for datafile  9 to
 "+DATA";
   set newname for datafile  10 to
 "+DATA";
   set newname for datafile  11 to
 "+DATA";
   set newname for datafile  12 to
 "+DATA";
   set newname for datafile  13 to
 "+DATA";
   set newname for datafile  14 to
 "+DATA";
   set newname for datafile  15 to
 "+DATA";
   restore
   from  nonsparse   from service
 'pdbdb'   clone database
   ;
   sql 'alter system archive log current';
}
executing Memory Script

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

renamed tempfile 1 to +DATA in control file
renamed tempfile 2 to +DATA in control file
renamed tempfile 3 to +DATA in control file

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

Starting restore at 06-OCT-24
using channel ORA_AUX_DISK_1

channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00001 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:15
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00003 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00004 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:08
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00005 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00006 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:08
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00007 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:01
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00008 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:03
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00009 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:02
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00010 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00011 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00012 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:04
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00013 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:03
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00014 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:01
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00015 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:08
Finished restore at 06-OCT-24

sql statement: alter system archive log current

contents of Memory Script:
{
   switch clone datafile all;
}
executing Memory Script

datafile 1 switched to datafile copy
input datafile copy RECID=18 STAMP=1181668195 file name=+DATA/DR/DATAFILE/system.258.1181668113
datafile 3 switched to datafile copy
input datafile copy RECID=19 STAMP=1181668195 file name=+DATA/DR/DATAFILE/sysaux.259.1181668129
datafile 4 switched to datafile copy
input datafile copy RECID=20 STAMP=1181668195 file name=+DATA/DR/DATAFILE/undotbs1.260.1181668137
datafile 5 switched to datafile copy
input datafile copy RECID=21 STAMP=1181668195 file name=+DATA/DR/23519278369E2978E063150610ACF012/DATAFILE/system.261.1181668143
datafile 6 switched to datafile copy
input datafile copy RECID=22 STAMP=1181668195 file name=+DATA/DR/23519278369E2978E063150610ACF012/DATAFILE/sysaux.262.1181668151
datafile 7 switched to datafile copy
input datafile copy RECID=23 STAMP=1181668195 file name=+DATA/DR/DATAFILE/users.263.1181668159
datafile 8 switched to datafile copy
input datafile copy RECID=24 STAMP=1181668195 file name=+DATA/DR/23519278369E2978E063150610ACF012/DATAFILE/undotbs1.264.1181668159
datafile 9 switched to datafile copy
input datafile copy RECID=25 STAMP=1181668195 file name=+DATA/DR/DATAFILE/undotbs2.265.1181668163
datafile 10 switched to datafile copy
input datafile copy RECID=26 STAMP=1181668195 file name=+DATA/DR/2351E15D26626035E063150610AC7E23/DATAFILE/system.266.1181668165
datafile 11 switched to datafile copy
input datafile copy RECID=27 STAMP=1181668195 file name=+DATA/DR/2351E15D26626035E063150610AC7E23/DATAFILE/sysaux.267.1181668171
datafile 12 switched to datafile copy
input datafile copy RECID=28 STAMP=1181668195 file name=+DATA/DR/2351E15D26626035E063150610AC7E23/DATAFILE/undotbs1.268.1181668179
datafile 13 switched to datafile copy
input datafile copy RECID=29 STAMP=1181668195 file name=+DATA/DR/2351E15D26626035E063150610AC7E23/DATAFILE/undo_2.269.1181668183
datafile 14 switched to datafile copy
input datafile copy RECID=30 STAMP=1181668195 file name=+DATA/DR/2351E15D26626035E063150610AC7E23/DATAFILE/users.270.1181668185
datafile 15 switched to datafile copy
input datafile copy RECID=31 STAMP=1181668195 file name=+DATA/DR/2351E15D26626035E063150610AC7E23/DATAFILE/tbs_backup.271.1181668187
Finished Duplicate Db at 06-OCT-24

RMAN> exit

Recovery Manager complete.
*/

-- Step 159 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Oct 6 17:10:57 2024
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

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           MOUNTED      06-OCT-24 pdbdr1.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  TO PRIMARY


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

    GROUP# STATUS  TYPE    MEMBER                                             IS_     CON_ID
---------- ------- ------- -------------------------------------------------- --- ----------
         1         ONLINE  +ARC/DR/ONLINELOG/group_1.258.1181668197           YES          0
         1         ONLINE  +DATA/DR/ONLINELOG/group_1.272.1181668197          NO           0
         2         ONLINE  +DATA/DR/ONLINELOG/group_2.273.1181668197          NO           0
         2         ONLINE  +ARC/DR/ONLINELOG/group_2.259.1181668197           YES          0
         3         ONLINE  +DATA/DR/ONLINELOG/group_3.274.1181668197          NO           0
         3         ONLINE  +ARC/DR/ONLINELOG/group_3.260.1181668199           YES          0
         4         ONLINE  +DATA/DR/ONLINELOG/group_4.275.1181668199          NO           0
         4         ONLINE  +ARC/DR/ONLINELOG/group_4.261.1181668199           YES          0
         5         ONLINE  +ARC/DR/ONLINELOG/group_5.262.1181668199           YES          0
         5         ONLINE  +DATA/DR/ONLINELOG/group_5.276.1181668199          NO           0
         6         ONLINE  +DATA/DR/ONLINELOG/group_6.277.1181668199          NO           0
         6         ONLINE  +ARC/DR/ONLINELOG/group_6.263.1181668199           YES          0
         7         STANDBY +DATA/DR/ONLINELOG/group_7.278.1181668201          NO           0
         7         STANDBY +ARC/DR/ONLINELOG/group_7.264.1181668201           YES          0
         8         STANDBY +ARC/DR/ONLINELOG/group_8.265.1181668201           YES          0
         8         STANDBY +DATA/DR/ONLINELOG/group_8.279.1181668201          NO           0
         9         STANDBY +ARC/DR/ONLINELOG/group_9.266.1181668201           YES          0
         9         STANDBY +DATA/DR/ONLINELOG/group_9.280.1181668201          NO           0
        10         STANDBY +DATA/DR/ONLINELOG/group_10.281.1181668201         NO           0
        10         STANDBY +ARC/DR/ONLINELOG/group_10.267.1181668203          YES          0
        11         STANDBY +DATA/DR/ONLINELOG/group_11.282.1181668203         NO           0
        11         STANDBY +ARC/DR/ONLINELOG/group_11.268.1181668203          YES          0
        12         STANDBY +DATA/DR/ONLINELOG/group_12.283.1181668203         NO           0
        12         STANDBY +ARC/DR/ONLINELOG/group_12.269.1181668203          YES          0
        13         STANDBY +DATA/DR/ONLINELOG/group_13.284.1181668203         NO           0
        13         STANDBY +ARC/DR/ONLINELOG/group_13.270.1181668203          YES          0
        14         STANDBY +DATA/DR/ONLINELOG/group_14.285.1181668205         NO           0
        14         STANDBY +ARC/DR/ONLINELOG/group_14.271.1181668205          YES          0

SQL> SELECT b.thread#,a.group#,a.member,b.bytes FROM v$logfile a, v$log b  WHERE a.group#=b.group# ORDER BY b.group#;

   THREAD#     GROUP# MEMBER                                                  BYTES
---------- ---------- -------------------------------------------------- ----------
         1          1 +ARC/DR/ONLINELOG/group_1.258.1181668197             52428800
         1          1 +DATA/DR/ONLINELOG/group_1.272.1181668197            52428800
         1          2 +DATA/DR/ONLINELOG/group_2.273.1181668197            52428800
         1          2 +ARC/DR/ONLINELOG/group_2.259.1181668197             52428800
         2          3 +DATA/DR/ONLINELOG/group_3.274.1181668197            52428800
         2          3 +ARC/DR/ONLINELOG/group_3.260.1181668199             52428800
         2          4 +DATA/DR/ONLINELOG/group_4.275.1181668199            52428800
         2          4 +ARC/DR/ONLINELOG/group_4.261.1181668199             52428800
         1          5 +ARC/DR/ONLINELOG/group_5.262.1181668199             52428800
         1          5 +DATA/DR/ONLINELOG/group_5.276.1181668199            52428800
         2          6 +DATA/DR/ONLINELOG/group_6.277.1181668199            52428800
         2          6 +ARC/DR/ONLINELOG/group_6.263.1181668199             52428800

--Node 1
SQL> SELECT b.thread#,a.group#, a.type, a.member, b.bytes FROM v$logfile a, v$standby_log b WHERE a.group# = b.group# ORDER BY 2,4;

   THREAD#     GROUP# TYPE    MEMBER                                                  BYTES
---------- ---------- ------- -------------------------------------------------- ----------
         1          7 STANDBY +ARC/DR/ONLINELOG/group_7.264.1181668201             52428800
         1          7 STANDBY +DATA/DR/ONLINELOG/group_7.278.1181668201            52428800
         1          8 STANDBY +ARC/DR/ONLINELOG/group_8.265.1181668201             52428800
         1          8 STANDBY +DATA/DR/ONLINELOG/group_8.279.1181668201            52428800
         1          9 STANDBY +ARC/DR/ONLINELOG/group_9.266.1181668201             52428800
         1          9 STANDBY +DATA/DR/ONLINELOG/group_9.280.1181668201            52428800
         1         10 STANDBY +ARC/DR/ONLINELOG/group_10.267.1181668203            52428800
         1         10 STANDBY +DATA/DR/ONLINELOG/group_10.281.1181668201           52428800
         2         11 STANDBY +ARC/DR/ONLINELOG/group_11.268.1181668203            52428800
         2         11 STANDBY +DATA/DR/ONLINELOG/group_11.282.1181668203           52428800
         2         12 STANDBY +ARC/DR/ONLINELOG/group_12.269.1181668203            52428800
         2         12 STANDBY +DATA/DR/ONLINELOG/group_12.283.1181668203           52428800
         2         13 STANDBY +ARC/DR/ONLINELOG/group_13.270.1181668203            52428800
         2         13 STANDBY +DATA/DR/ONLINELOG/group_13.284.1181668203           52428800
         2         14 STANDBY +ARC/DR/ONLINELOG/group_14.271.1181668205            52428800
         2         14 STANDBY +DATA/DR/ONLINELOG/group_14.285.1181668205           52428800

SQL> SELECT * FROM v$logfile order by 1;

    GROUP# STATUS  TYPE    MEMBER                                             IS_     CON_ID
---------- ------- ------- -------------------------------------------------- --- ----------
         1         ONLINE  +ARC/DR/ONLINELOG/group_1.258.1181668197           YES          0
         1         ONLINE  +DATA/DR/ONLINELOG/group_1.272.1181668197          NO           0
         2         ONLINE  +DATA/DR/ONLINELOG/group_2.273.1181668197          NO           0
         2         ONLINE  +ARC/DR/ONLINELOG/group_2.259.1181668197           YES          0
         3         ONLINE  +DATA/DR/ONLINELOG/group_3.274.1181668197          NO           0
         3         ONLINE  +ARC/DR/ONLINELOG/group_3.260.1181668199           YES          0
         4         ONLINE  +DATA/DR/ONLINELOG/group_4.275.1181668199          NO           0
         4         ONLINE  +ARC/DR/ONLINELOG/group_4.261.1181668199           YES          0
         5         ONLINE  +ARC/DR/ONLINELOG/group_5.262.1181668199           YES          0
         5         ONLINE  +DATA/DR/ONLINELOG/group_5.276.1181668199          NO           0
         6         ONLINE  +DATA/DR/ONLINELOG/group_6.277.1181668199          NO           0
         6         ONLINE  +ARC/DR/ONLINELOG/group_6.263.1181668199           YES          0
         7         STANDBY +DATA/DR/ONLINELOG/group_7.278.1181668201          NO           0
         7         STANDBY +ARC/DR/ONLINELOG/group_7.264.1181668201           YES          0
         8         STANDBY +ARC/DR/ONLINELOG/group_8.265.1181668201           YES          0
         8         STANDBY +DATA/DR/ONLINELOG/group_8.279.1181668201          NO           0
         9         STANDBY +ARC/DR/ONLINELOG/group_9.266.1181668201           YES          0
         9         STANDBY +DATA/DR/ONLINELOG/group_9.280.1181668201          NO           0
        10         STANDBY +DATA/DR/ONLINELOG/group_10.281.1181668201         NO           0
        10         STANDBY +ARC/DR/ONLINELOG/group_10.267.1181668203          YES          0
        11         STANDBY +DATA/DR/ONLINELOG/group_11.282.1181668203         NO           0
        11         STANDBY +ARC/DR/ONLINELOG/group_11.268.1181668203          YES          0
        12         STANDBY +DATA/DR/ONLINELOG/group_12.283.1181668203         NO           0
        12         STANDBY +ARC/DR/ONLINELOG/group_12.269.1181668203          YES          0
        13         STANDBY +DATA/DR/ONLINELOG/group_13.284.1181668203         NO           0
        13         STANDBY +ARC/DR/ONLINELOG/group_13.270.1181668203          YES          0
        14         STANDBY +DATA/DR/ONLINELOG/group_14.285.1181668205         NO           0
        14         STANDBY +ARC/DR/ONLINELOG/group_14.271.1181668205          YES          0

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
[ ONLINE REDO LOG ]        1      1          1          0 +ARC/DR/ONLINELOG/group_1.258.1181668197                     CURRENT          NO              50
[ ONLINE REDO LOG ]        1      1          1          0 +DATA/DR/ONLINELOG/group_1.272.1181668197                    CURRENT          NO              50
[ ONLINE REDO LOG ]        1      2          1          0 +ARC/DR/ONLINELOG/group_2.259.1181668197                     UNUSED           YES             50
[ ONLINE REDO LOG ]        1      2          1          0 +DATA/DR/ONLINELOG/group_2.273.1181668197                    UNUSED           YES             50
[ ONLINE REDO LOG ]        1      5          1          0 +ARC/DR/ONLINELOG/group_5.262.1181668199                     UNUSED           YES             50
[ ONLINE REDO LOG ]        1      5          1          0 +DATA/DR/ONLINELOG/group_5.276.1181668199                    UNUSED           YES             50
[ STANDBY REDO LOG ]       1      7          1        125 +ARC/DR/ONLINELOG/group_7.264.1181668201                     ACTIVE           YES             50
[ STANDBY REDO LOG ]       1      7          1        125 +DATA/DR/ONLINELOG/group_7.278.1181668201                    ACTIVE           YES             50
[ STANDBY REDO LOG ]       1      8          1          0 +ARC/DR/ONLINELOG/group_8.265.1181668201                     UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      8          1          0 +DATA/DR/ONLINELOG/group_8.279.1181668201                    UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      9          1          0 +ARC/DR/ONLINELOG/group_9.266.1181668201                     UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      9          1          0 +DATA/DR/ONLINELOG/group_9.280.1181668201                    UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1     10          1          0 +ARC/DR/ONLINELOG/group_10.267.1181668203                    UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1     10          1          0 +DATA/DR/ONLINELOG/group_10.281.1181668201                   UNASSIGNED       YES             50

SQL> show parameter spfile

NAME                                 TYPE        VALUE
------------------------------------ ----------- -----------------------------------------------------
spfile                               string      /opt/app/oracle/product/19c/db_1/dbs/spfilepdbdb1.ora

SQL> !ls /opt/app/oracle/product/19c/db_1/dbs/
hc_pdbdb1.dat  init.ora  initpdbdb1.ora  orapwpdbdb1  spfilepdbdb1.ora

SQL> CREATE PFILE='+DATA' FROM SPFILE='/opt/app/oracle/product/19c/db_1/dbs/spfilepdbdb1.ora';
SQL> CREATE SPFILE='+DATA' FROM PFILE ='+DATA';


SQL> shut immediate
ORA-01109: database not open


Database dismounted.
ORACLE instance shut down.

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 160 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/dbs

-- Step 160.1 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ pwd
/*
/opt/app/oracle/product/19c/db_1/dbs
*/

-- Step 160.2 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ ll -ltrh initpdbdb1.ora
/*
-rw-r--r-- 1 oracle oinstall 1.4K Oct  6 16:51 initpdbdb1.ora
*/

-- Step 160.2 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ mv initpdbdb1.ora initpdbdb1.ora.backup
[oracle@pdbdr1 dbs]$ mv spfilepdbdb1.ora spfilepdbdb1.ora.backup

-- Step 161 -->> On Node 2 - DR
[grid@pdbdr1 ~]$ asmcmd
/*
ASMCMD> cd +DATA/DR/PARAMETERFILE/
ASMCMD> ls
spfile.286.1181668497
ASMCMD> exit
*/

-- Step 162 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/dbs

-- Step 162.1 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ pwd
/*
/opt/app/oracle/product/19c/db_1/dbs
*/

-- Step 162.2 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ echo "SPFILE='+DATA/DR/PARAMETERFILE/spfile.286.1181668497'" > initpdbdb1.ora

-- Step 162.3 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ ll -ltrh initpdbdb1.ora
/*
-rw-r--r-- 1 oracle oinstall 54 Oct  6 17:19 initpdbdb1.ora
*/

-- Step 162.4 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ cat initpdbdb1.ora
/*
SPFILE='+DATA/DR/PARAMETERFILE/spfile.286.1181668497'
*/

-- Step 162.5 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ scp -r initpdbdb1.ora oracle@pdbdr2:/opt/app/oracle/product/19c/db_1/dbs/initpdbdb2.ora
/*
initpdbdb1.ora                                                             100%   57    45.3KB/s   00:00
*/

-- Step 162.6 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ ssh pdbdr2

[oracle@pdbdr2 ~]$ ll /opt/app/oracle/product/19c/db_1/dbs/ | grep initpdbdb2.ora
/*
-rw-r--r-- 1 oracle oinstall   54 Oct  6 17:19 initpdbdb2.ora
*/

-- Step 162.7 -->> On Node 2 - DR
[oracle@pdbdr2 ~]$ cat /opt/app/oracle/product/19c/db_1/dbs/initpdbdb2.ora
/*
SPFILE='+DATA/DR/PARAMETERFILE/spfile.286.1181668497'
*/

-- Step 162.8 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Oct 6 17:21:15 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> !ls
+DATA_BK  hc_pdbdb1.dat  init.ora  initpdbdb1.ora  initpdbdb1.ora.backup  orapwpdbdb1  spfilepdbdb1.ora.backup

SQL> startup mount
ORACLE instance started.

Total System Global Area 9663673304 bytes
Fixed Size                  9188312 bytes
Variable Size            1476395008 bytes
Database Buffers         8153726976 bytes
Redo Buffers               24363008 bytes
Database mounted.

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       MOUNTED
         3 SBXPDB                         MOUNTED

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           MOUNTED      06-OCT-24 pdbdr1.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED

SQL> show parameter spfile

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
spfile                               string      +DATA/DR/PARAMETERFILE/spfile.286.1181668497

SQL> show parameter control_files

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
control_files                        string      +DATA/DR/CONTROLFILE/current.257.1181668105, 
                                                 +ARC/DR/CONTROLFILE/current.257.1181668105

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

Total System Global Area 9663673304 bytes
Fixed Size                  9188312 bytes
Variable Size            1476395008 bytes
Database Buffers         8153726976 bytes
Redo Buffers               24363008 bytes
Database mounted.

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode,a.cdb FROM gv$database a,v$instance b;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE  CDB
---------- ------------ ---------------- ---------------- ---------- ---
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED    YES

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       MOUNTED
         3 SBXPDB                         MOUNTED

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           MOUNTED      06-OCT-24 pdbdr1.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED

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
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 163 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ which srvctl
/*
/opt/app/oracle/product/19c/db_1/bin/srvctl
*/

-- Step 163.1 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ srvctl add database -d pdbdb -o /opt/app/oracle/product/19c/db_1 -r physical_standby -s mount
[oracle@pdbdr1 ~]$ srvctl modify database -d pdbdb -spfile +DATA/DR/PARAMETERFILE/spfile.286.1181668497
[oracle@pdbdr1 ~]$ srvctl modify database -d pdbdb -diskgroup "DATA,ARC"
[oracle@pdbdr1 ~]$ srvctl add instance -d pdbdb -i pdbdb1 -n pdbdr1
[oracle@pdbdr1 ~]$ srvctl add instance -d pdbdb -i pdbdb2 -n pdbdr2

-- Step 163.2 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ srvctl config database -d pdbdb 
/*
Database unique name: pdbdb
Database name:
Oracle home: /opt/app/oracle/product/19c/db_1
Oracle user: oracle
Spfile: +DATA/DR/PARAMETERFILE/spfile.286.1181668497
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
Database instances: pdbdb1,pdbdb2
Configured nodes: pdbdr1,pdbdr2
CSS critical: no
CPU count: 0
Memory target: 0
Maximum memory: 0
Default network number for database services:
Database is administrator managed
*/

-- Step 164 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Oct 6 17:27:25 2024
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

-- Step 165 -->> On Node 1 - DR
[oracle@pdbdr1/pdbdr2 ~]$ srvctl start database -d pdbdb -o mount
[oracle@pdbdr1/pdbdr2 ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is running on node pdbdr1
Instance pdbdb2 is running on node pdbdr2
*/

-- Step 165.1 -->> On Node 1 - DR
[oracle@pdbdr1/pdbdr2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdbdr1. Instance status: Mounted (Closed).
Instance pdbdb2 is running on node pdbdr2. Instance status: Mounted (Closed).
*/

-- Step 166 -->> On Node 1 - DR
[oracle@pdbdr1/pdbdr2 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue Oct 8 11:01:09 2024
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
MOUNTED      pdbdb2


SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           MOUNTED      08-OCT-24 pdbdr1.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED
         2 PDBDB     pdbdb2           MOUNTED      08-OCT-24 pdbdr2.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 167 -->> On Node 1 - DR
[root@pdbdr1/pdbdr2 ~]# cd /opt/app/19c/grid/bin/

-- Step 167.1 -->> On Node 1 - DR
[root@pdbdr1/pdbdr2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       pdbdr1                   STABLE
               ONLINE  ONLINE       pdbdr2                   STABLE
ora.chad
               ONLINE  ONLINE       pdbdr1                   STABLE
               ONLINE  ONLINE       pdbdr2                   STABLE
ora.net1.network
               ONLINE  ONLINE       pdbdr1                   STABLE
               ONLINE  ONLINE       pdbdr2                   STABLE
ora.ons
               ONLINE  ONLINE       pdbdr1                   STABLE
               ONLINE  ONLINE       pdbdr2                   STABLE
ora.proxy_advm
               OFFLINE OFFLINE      pdbdr1                   STABLE
               OFFLINE OFFLINE      pdbdr2                   STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ARC.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   STABLE
      2        ONLINE  ONLINE       pdbdr2                   STABLE
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   STABLE
      2        ONLINE  ONLINE       pdbdr2                   STABLE
ora.DATA.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   STABLE
      2        ONLINE  ONLINE       pdbdr2                   STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   STABLE
      2        ONLINE  ONLINE       pdbdr2                   STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   Started,STABLE
      2        ONLINE  ONLINE       pdbdr2                   Started,STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   STABLE
      2        ONLINE  ONLINE       pdbdr2                   STABLE
ora.cvu
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.pdbdb.db
      1        ONLINE  INTERMEDIATE pdbdr1                   Mounted (Closed),HOME=/opt/app/oracle/product/19c/db_1,STABLE
      2        ONLINE  INTERMEDIATE pdbdr2                   Mounted (Closed),HOME=/opt/app/oracle/product/19c/db_1,STABLE
ora.pdbdr1.vip
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.pdbdr2.vip
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.qosmserver
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.scan3.vip
      1        ONLINE  ONLINE       pdbdr1                   STABLE
--------------------------------------------------------------------------------
*/

-- Step 168 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue Oct 8 11:06:11 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 SBXPDB                         READ WRITE NO

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
         1 PDBDB     pdbdb1           OPEN         06-OCT-24 pdb1.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  TO STANDBY
         2 PDBDB     pdbdb2           OPEN         06-OCT-24 pdb2.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  TO STANDBY

SQL> alter system archive log current;

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           140          1
            33          2

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 169 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue Oct 8 11:07:47 2024
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
MOUNTED      pdbdb2

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           MOUNTED      08-OCT-24 pdbdr1.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED
         2 PDBDB     pdbdb2           MOUNTED      08-OCT-24 pdbdr2.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;
--SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION INSTANCES ALL;

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           140          1
            33          2

SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         2         34 APPLYING_LOG        303 MRP0

SQL> SELECT sequence#,status,block#,process FROM v$managed_standby ;

 SEQUENCE# STATUS           BLOCK# PROCESS
---------- ------------ ---------- ---------
         0 CONNECTED             0 ARCH
         0 ALLOCATED             0 DGRD
         0 ALLOCATED             0 DGRD
         0 CONNECTED             0 ARCH
       140 CLOSING            6144 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
         0 CONNECTED             0 ARCH
        33 CLOSING           43008 ARCH
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
        34 IDLE                333 RFS
       141 RECEIVING           424 RFS
        34 APPLYING_LOG        332 MRP0

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 170 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ asmcmd -p
/*
ASMCMD [+] > cd +DATA/DR
ASMCMD [+DATA/DR] > ls
23519278369E2978E063150610ACF012/
2351E15D26626035E063150610AC7E23/
CONTROLFILE/
DATAFILE/
ONLINELOG/
PARAMETERFILE/

ASMCMD [+DATA/DR] > mkdir PASSWORDFILE
ASMCMD [+DATA/DR] > cd PASSWORDFILE
ASMCMD [+DATA/DR/PASSWORDFILE] > pwcopy /opt/app/oracle/product/19c/db_1/dbs/orapwpdbdb1 +DATA/DR/PASSWORDFILE/orapwpdbdb
copying /opt/app/oracle/product/19c/db_1/dbs/orapwpdbdb1 -> +DATA/DR/PASSWORDFILE/orapwpdbdb

ASMCMD [+DATA/DR/PASSWORDFILE] > ls -l
Type      Redund  Striped  Time             Sys  Name
PASSWORD  UNPROT  COARSE   OCT 08 11:00:00  N    orapwpdbdb => +DATA/DB_UNKNOWN/PASSWORD/pwddb_unknown.287.1181819541

ASMCMD [+DATA/DR/PASSWORDFILE] > ls
orapwpdbdb
ASMCMD [+DATA/DR/PASSWORDFILE] > exit
*/

-- Step 171 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ srvctl modify database -d pdbdb -pwfile +DATA/DR/PASSWORDFILE/orapwpdbdb

-- Step 171.1 -->> On Node 1 - DR
[oracle@pdbdr1/pdbdr2 ~]$ srvctl config database -d pdbdb
/*
Database unique name: pdbdb
Database name:
Oracle home: /opt/app/oracle/product/19c/db_1
Oracle user: oracle
Spfile: +DATA/DR/PARAMETERFILE/spfile.286.1181668497
Password file: +DATA/DR/PASSWORDFILE/orapwpdbdb
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
Database instances: pdbdb1,pdbdb2
Configured nodes: pdbdr1,pdbdr2
CSS critical: no
CPU count: 0
Memory target: 0
Maximum memory: 0
Default network number for database services:
Database is administrator managed
*/

-- Step 172 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 172.1 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 172.2 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ vi tnsnames.ora
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

DR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = dr)
    )
  )
*/

-- Step 172.3 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ tnsping dr
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 08-OCT-2024 11:17:25

Copyright (c) 1997, 2024, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = dr)))
OK (0 msec)
*/

-- Step 173 -->> On Node 2 - DR
[oracle@pdbdr2 ~]$ cd $ORACLE_HOME/network/admin

-- Step 173.1 -->> On Node 1 - DR
[oracle@pdbdr2 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 173.2 -->> On Node 1 - DR
[oracle@pdbdr2 admin]$ vi tnsnames.ora
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

DR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = dr)
    )
  )
*/

-- Step 173.3 -->> On Node 1 - DR
[oracle@pdbdr2 admin]$ tnsping dr
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 08-OCT-2024 11:19:57

Copyright (c) 1997, 2024, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr1.unidev.org.np)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = dr)))
OK (0 msec)
*/

-- Step 174 -->> On Node 1 - DC
[oracle@pdb1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 174.1 -->> On Node 1 - DC
[oracle@pdb1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 174.2 -->> On Node 1 - DC
[oracle@pdb1 admin]$ vi tnsnames.ora
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
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.160.6.21)(PORT = 1521))
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
      (SERVICE_NAME = SBXPDB)
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

-- Step 174.3 -->> On Node 1 - DC
[oracle@pdb1 admin]$ tnsping dr
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 08-OCT-2024 11:24:26

Copyright (c) 1997, 2024, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = dr)))
OK (0 msec)
*/

-- Step 175 -->> On Node 2 - DC
[oracle@pdb2 ~]$ cd $ORACLE_HOME/network/admin

-- Step 175.1 -->> On Node 2 - DC
[oracle@pdb2 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 175.2 -->> On Node 2 - DC
[oracle@pdb2 admin]$ vi tnsnames.ora
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
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.160.6.22)(PORT = 1521))
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
      (SERVICE_NAME = SBXPDB)
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

-- Step 175.3 -->> On Node 2 - DC
[oracle@pdb2 admin]$ tnsping dr
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 08-OCT-2024 11:28:38

Copyright (c) 1997, 2024, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = dr)))
OK (0 msec)
*/

-- Step 176 -->> On Node 1 - DC
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 176.1 -->> On Node 1 - DC
[oracle@pdb1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 176.2 -->> On Node 1 - DC
[oracle@pdbdr1 admin]$ ll | grep listener.ora
/*
-rw-r--r-- 1 oracle oinstall  312 Oct  6 16:59 listener.ora
*/

-- Step 176.3 -->> On Node 1 - DC
[oracle@pdbdr1 admin]$ ps -ef | grep tns
/*
root          35       2  0 Oct01 ?        00:00:00 [netns]
oracle     45547       1  0 Oct06 ?        00:00:07 /opt/app/oracle/product/19c/db_1/bin/tnslsnr listener1 -inherit
grid       56643       1  0 Oct01 ?        00:04:08 /opt/app/19c/grid/bin/tnslsnr ASMNET1LSNR_ASM -no_crs_notify -inherit
grid       57347       1  0 Oct01 ?        00:00:16 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid       57383       1  0 Oct01 ?        00:00:16 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid       58814       1  0 Oct01 ?        00:00:18 /opt/app/19c/grid/bin/tnslsnr LISTENER -no_crs_notify -inherit
oracle   1529761 1521261  0 11:30 pts/0    00:00:00 grep --color=auto tns
*/

-- Step 176.4 -->> On Node 1 - DC
[oracle@pdbdr1 admin]$ lsnrctl status listener1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 08-OCT-2024 11:31:14

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))
STATUS of the LISTENER
------------------------
Alias                     listener1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                06-OCT-2024 17:00:05
Uptime                    1 days 18 hr. 31 min. 9 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/oracle/product/19c/db_1/network/admin/listener.ora
Listener Log File         /opt/app/oracle/product/19c/db_1/network/log/listener1.log
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))
Services Summary...
Service "dr" has 1 instance(s).
  Instance "pdbdb1", status UNKNOWN, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 176.5 -->> On Node 1 - DC
[oracle@pdbdr1 admin]$ lsnrctl stop listener1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 08-OCT-2024 11:31:31

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))
The command completed successfully
*/

-- Step 176.6 -->> On Node 1 - DC
[oracle@pdbdr1 admin]$ lsnrctl status listener1
/*

LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 08-OCT-2024 11:31:49

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))
TNS-12541: TNS:no listener
 TNS-12560: TNS:protocol adapter error
  TNS-00511: No listener
   Linux Error: 111: Connection refused
*/

-- Step 176.7 -->> On Node 1 - DC
[oracle@pdbdr1 admin]$ ps -ef | grep tns
/*
root          35       2  0 Oct01 ?        00:00:00 [netns]
grid       56643       1  0 Oct01 ?        00:04:08 /opt/app/19c/grid/bin/tnslsnr ASMNET1LSNR_ASM -no_crs_notify -inherit
grid       57347       1  0 Oct01 ?        00:00:16 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid       57383       1  0 Oct01 ?        00:00:16 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid       58814       1  0 Oct01 ?        00:00:18 /opt/app/19c/grid/bin/tnslsnr LISTENER -no_crs_notify -inherit
oracle   1530344 1521261  0 11:32 pts/0    00:00:00 grep --color=auto tns
*/


-- Step 177 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue Oct 8 11:32:40 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> show con_name

CON_NAME
------------------------------
CDB$ROOT
SQL>
SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 SBXPDB                         READ WRITE NO

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
         1 PDBDB     pdbdb1           OPEN         06-OCT-24 pdb1.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  TO STANDBY
         2 PDBDB     pdbdb2           OPEN         06-OCT-24 pdb2.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  TO STANDBY

SQL> alter system archive log current;
SQL> alter system switch logfile;

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           147          1
            38          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 178 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue Oct 8 11:33:37 2024
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
         2 PDB$SEED                       MOUNTED
         3 SBXPDB                         MOUNTED

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
         1 PDBDB     pdbdb1           MOUNTED      08-OCT-24 pdbdr1.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED
         2 PDBDB     pdbdb2           MOUNTED      08-OCT-24 pdbdr2.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           147          1
            38          2

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           145          1
            37          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         2         39 APPLYING_LOG        125 MRP0

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

Database altered.

--SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION INSTANCES ALL;

Database altered.

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           147          1
            38          2

SQL>  SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL>  SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         1        150 APPLYING_LOG          8 MRP0

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 179 -->> On Node 1 - DC
[grid@pdb1 ~]$ ps -ef | grep SCAN
/*
grid       10254       1  0 Oct04 ?        00:00:10 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid       10265       1  0 Oct04 ?        00:00:10 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid     3386416 3386323  0 11:47 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 179.1 -->> On Node 1 - DC
[grid@pdb1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 08-OCT-2024 11:47:21

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                04-OCT-2024 12:04:18
Uptime                    3 days 23 hr. 43 min. 3 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.26)(PORT=1521)))
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

-- Step 179.2 -->> On Node 1 - DC
[grid@pdb1 ~]$ lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 08-OCT-2024 11:47:53

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                04-OCT-2024 12:04:17
Uptime                    3 days 23 hr. 43 min. 36 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener_scan3/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN3)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.27)(PORT=1521)))
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

-- Step 179.3 -->> On Node 1 - DC
[grid@pdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 08-OCT-2024 11:48:05

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                04-OCT-2024 12:04:17
Uptime                    3 days 23 hr. 43 min. 47 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.21)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.23)(PORT=1521)))
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

-- Step 179.4 -->> On Node 2 - DC
[grid@pdb2 ~]$ ps -ef | grep SCAN
/*
grid       13510       1  0 Oct04 ?        00:00:10 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid     3290852 3290687  0 11:48 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 179.5 -->> On Node 2 - DC
[grid@pdb2 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 08-OCT-2024 11:49:09

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                04-OCT-2024 12:05:12
Uptime                    3 days 23 hr. 43 min. 56 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.25)(PORT=1521)))
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

-- Step 179.6 -->> On Node 2 - DC
[grid@pdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 08-OCT-2024 11:49:24

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                04-OCT-2024 12:04:34
Uptime                    3 days 23 hr. 44 min. 50 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.22)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.24)(PORT=1521)))
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

-- Step 180 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ ps -ef | grep SCAN
/*
grid       57347       1  0 Oct01 ?        00:00:16 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid       57383       1  0 Oct01 ?        00:00:16 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid     1540257 1540187  0 11:50 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 180.1 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 08-OCT-2024 11:50:45

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                01-OCT-2024 16:38:40
Uptime                    6 days 19 hr. 12 min. 5 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.53)(PORT=1521)))
Services Summary...
Service "dr" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 180.2 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 08-OCT-2024 11:51:42

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                01-OCT-2024 16:38:41
Uptime                    6 days 19 hr. 13 min. 0 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener_scan3/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN3)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.54)(PORT=1521)))
Services Summary...
Service "dr" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/
-- Step 180.3 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 08-OCT-2024 11:52:24

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                01-OCT-2024 16:39:16
Uptime                    6 days 19 hr. 13 min. 8 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.48)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.50)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "dr" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 180.4 -->> On Node 2 - DR
[grid@pdbdr2 ~]$ ps -ef | grep SCAN
/*
grid       62436       1  0 Oct01 ?        00:00:16 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid     1379463 1377296  0 11:52 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 180.5 -->> On Node 2 - DR
[grid@pdbdr2 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 08-OCT-2024 11:53:00

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                01-OCT-2024 16:43:41
Uptime                    6 days 19 hr. 9 min. 19 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr2/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.52)(PORT=1521)))
Services Summary...
Service "dr" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 180.6 -->> On Node 2 - DR
[grid@pdbdr2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 08-OCT-2024 11:53:12

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                01-OCT-2024 16:44:02
Uptime                    6 days 19 hr. 9 min. 9 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.49)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.51)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "dr" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 181 -->> On Both Node's - DC
[oracle@pdb1/pdb2 ~]$ rman target /
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Tue Oct 8 11:54:54 2024
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

-- Step 182 -->> On Both Node's - DR
[oracle@pdbdr1/pdbdr2 ~]$ rman target /
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Tue Oct 8 11:56:49 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB (DBID=3239152647, not open)

RMAN> show all;

using target database control file instead of recovery catalog
RMAN configuration parameters for database with db_unique_name DR are:
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

-- Step 183 -->> On Both Node's - DR
[oracle@pdbdr1/pdbdr2 ~]$ cd $ORACLE_HOME/network/admin

-- Step 183.1 -->> On Both Node's - DR
[oracle@pdbdr1/pdbdr2 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 183.2 -->> On Both Node's - DR
[oracle@pdbdr1/pdbdr2 admin]$ vi tnsnames.ora
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

DR =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = dr)
    )
  )

SBXPDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = SBXPDB)
    )
  )
*/

-- Step 183.2 -->> On Both Node's - DR
[oracle@pdbdr1/pdbdr2 ~]$ tnsping SBXPDB
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 08-OCT-2024 11:59:30

Copyright (c) 1997, 2024, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = SBXPDB)))
OK (0 msec)
*/

-- Step 184 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ mkdir -p /backup/script
[oracle@pdbdr1 ~]$ chmod -R 775 /backup/script

-- Step 184.1 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ vi /backup/script/dr_archivedelete.sh
/*

##SOS to script deletes the applied archivelog file in standby database##

export ORACLE_HOME="/opt/app/oracle/product/19c/db_1"
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

-- Step 184.2 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ /backup/script/dr_archivedelete.sh

-- Step 185 -->> On Node 1 - DR
[root@pdbdr1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/19c/grid:N
pdbdb:/opt/app/oracle/product/19c/db_1:N
pdbdb1:/opt/app/oracle/product/19c/db_1:N
*/

-- Step 186 -->> On Node 2 - DR
[root@pdbdr2 ~]# vi /etc/oratab
/*
+ASM2:/opt/app/19c/grid:N
pdbdb:/opt/app/oracle/product/19c/db_1:N
pdbdb2:/opt/app/oracle/product/19c/db_1:N
*/

-- Step 187 -->> On Node 2 - DR
-- To Fix the ADRCI log if occured in remote nodes
-- Step Fix.1 -->> On Node 2
[oracle@pdbdr2 ~]$ adrci
/*
ADRCI: Release 19.0.0.0.0 - Production on Tue Oct 8 14:48:35 2024

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

No ADR base is set

adrci> exit
*/

-- Step Fix.2 -->> On Node 2
[oracle@pdbdr1 ~]$ ls -ltr /opt/app/oracle/product/19c/db_1/log/diag/
/*
-rw-r----- 1 oracle asmadmin 16 Oct  8 10:59 adrci_dir.mif
*/

-- Step Fix.3 -->> On Node 2
[oracle@pdbdr2 ~]$ cd /opt/app/oracle/product/19c/db_1/
[oracle@pdbdr2 db_1]$ mkdir -p log/diag
[oracle@pdbdr2 db_1]$ mkdir -p log/pdbdr2/client
[oracle@pdbdr2 db_1]$ cd log
[oracle@pdbdr2 db_1]$ chown -R oracle:asmadmin diag
-- Step Fix.4 -->> On Node 1
[oracle@pdbdr1 ~]$ scp -r /opt/app/oracle/product/19c/db_1/log/diag/adrci_dir.mif oracle@pdbdr2:/opt/app/oracle/product/19c/db_1/log/diag/

-- Step Fix.5 -->> On Node 2
[oracle@pdbdr2 ~]$ adrci
/*
ADRCI: Release 19.0.0.0.0 - Production on Tue Oct 8 14:50:12 2024

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

ADR base = "/opt/app/oracle"

adrci> exit
*/

-- Step 188 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue Oct 15 15:02:32 2024
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

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

Database altered.

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 189 -->> On Node 1 - DR
[root@pdbdr1 ~]# cd /opt/app/19c/grid/bin/

-- Step 189.1 -->> On Node 1 - DR
[root@pdbdr1 bin]# ./crsctl stop cluster -all

-- Step 189.2 -->> On Node 1 - DR
[root@pdbdr1 bin]# ./crsctl start cluster -all

-- Step 189.3 -->> On Node 1 - DR
[root@pdbdr1 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.crf
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.crsd
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.cssd
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.ctssd
      1        ONLINE  ONLINE       pdbdr1                   OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.drivers.acfs
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.evmd
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.gipcd
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.gpnpd
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.mdnsd
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.storage
      1        ONLINE  ONLINE       pdbdr1                   STABLE
--------------------------------------------------------------------------------
*/

-- Step 189.4 -->> On Node 2 - DR
[root@pdbdr2 ~]# cd /opt/app/19c/grid/bin/

-- Step 189.5 -->> On Node 2 - DR
[root@pdbdr2 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.crf
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.crsd
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.cssd
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.ctssd
      1        ONLINE  ONLINE       pdbdr2                   OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.drivers.acfs
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.evmd
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.gipcd
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.gpnpd
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.mdnsd
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.storage
      1        ONLINE  ONLINE       pdbdr2                   STABLE
--------------------------------------------------------------------------------
*/

-- Step 190 -->> On Both Nodes - DR
[root@pdbdr1/pdbdr2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       pdbdr1                   STABLE
               ONLINE  ONLINE       pdbdr2                   STABLE
ora.chad
               ONLINE  ONLINE       pdbdr1                   STABLE
               ONLINE  ONLINE       pdbdr2                   STABLE
ora.net1.network
               ONLINE  ONLINE       pdbdr1                   STABLE
               ONLINE  ONLINE       pdbdr2                   STABLE
ora.ons
               ONLINE  ONLINE       pdbdr1                   STABLE
               ONLINE  ONLINE       pdbdr2                   STABLE
ora.proxy_advm
               OFFLINE OFFLINE      pdbdr1                   STABLE
               OFFLINE OFFLINE      pdbdr2                   STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ARC.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   STABLE
      2        ONLINE  ONLINE       pdbdr2                   STABLE
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   STABLE
      2        ONLINE  ONLINE       pdbdr2                   STABLE
ora.DATA.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   STABLE
      2        ONLINE  ONLINE       pdbdr2                   STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   STABLE
      2        ONLINE  ONLINE       pdbdr2                   STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   Started,STABLE
      2        ONLINE  ONLINE       pdbdr2                   Started,STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       pdbdr1                   STABLE
      2        ONLINE  ONLINE       pdbdr2                   STABLE
ora.cvu
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.pdbdb.db
      1        ONLINE  INTERMEDIATE pdbdr1                   Mounted (Closed),HOME=/opt/app/oracle/product/19c/db_1,STABLE
      2        ONLINE  INTERMEDIATE pdbdr2                   Mounted (Closed),HOME=/opt/app/oracle/product/19c/db_1,STABLE
ora.pdbdr1.vip
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.pdbdr2.vip
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.qosmserver
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.scan3.vip
      1        ONLINE  ONLINE       pdbdr1                   STABLE
--------------------------------------------------------------------------------
*/

-- Step 191 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 15-OCT-2024 15:09:22

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                15-OCT-2024 15:05:49
Uptime                    0 days 0 hr. 3 min. 33 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.48)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.50)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "dr" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 191.1 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ ps -ef | grep SCAN
/*
grid     3266547       1  0 15:05 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid     3266552       1  0 15:05 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid     3280073 3279108  0 15:09 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 191.2 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 15-OCT-2024 15:10:20

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                15-OCT-2024 15:05:50
Uptime                    0 days 0 hr. 4 min. 30 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.53)(PORT=1521)))
Services Summary...
Service "dr" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 191.3 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 15-OCT-2024 15:10:32

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                15-OCT-2024 15:05:50
Uptime                    0 days 0 hr. 4 min. 42 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener_scan3/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN3)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.54)(PORT=1521)))
Services Summary...
Service "dr" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 192 -->> On Node 2 - DR
[grid@pdbdr2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 15-OCT-2024 15:09:23

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                15-OCT-2024 15:06:12
Uptime                    0 days 0 hr. 3 min. 11 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.49)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.51)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "dr" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 192.1 -->> On Node 2 - DR
[grid@pdbdr2 ~]$ ps -ef | grep SCAN
/*
grid     2959976       1  0 15:06 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid     2976289 2975920  0 15:09 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 192.2 -->> On Node 2 - DR
[grid@pdbdr2 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 15-OCT-2024 15:11:10

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                15-OCT-2024 15:06:24
Uptime                    0 days 0 hr. 4 min. 45 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr2/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.52)(PORT=1521)))
Services Summary...
Service "dr" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 193 -->> On Both Nodes - DR
[oracle@pdbdr1/pdbdr2 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): pdbdr2,pdbdr1
*/

-- Step 194 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 15-OCT-2024 15:11:59

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                15-OCT-2024 15:05:49
Uptime                    0 days 0 hr. 6 min. 9 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.48)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.50)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "dr" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 195 -->> On Node 2 - DR
[oracle@pdbdr2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 15-OCT-2024 15:12:00

Copyright (c) 1991, 2024, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                15-OCT-2024 15:06:12
Uptime                    0 days 0 hr. 5 min. 47 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.49)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.160.6.51)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "dr" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 196 -->> On Both Nodes - DR
[oracle@pdbdr1/pdbdr2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdbdr1. Instance status: Mounted (Closed).
Instance pdbdb2 is running on node pdbdr2. Instance status: Mounted (Closed).
*/

-- Step 197 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue Oct 15 15:12:54 2024
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
         2 PDB$SEED                       MOUNTED
         3 SBXPDB                         MOUNTED

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION INSTANCES ALL;

Database altered.

SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         1        218 APPLYING_LOG      32105 MRP0

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           240          1
           113          2

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

----------------------------------------------------------------
--------------Two Nodes DR Drill Senty Testing------------------
----------------------------------------------------------------
----------------------Snapshot Standby--------------------------
----------------------------------------------------------------
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
-- Verify the PDB's instance status of Primary Database -> DC
SQL> show pdbs
/*
    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 SBXPDB                         READ WRITE NO
*/

-- Step 1.4
-- Connect the PDB instance to Create Objects on Primary Database -> DC
SQL> connect sys/Sys605014@SBXPDB as sysdba
Connected.

-- Step 1.4.1
SQL> CREATE TABLESPACE tbs_snapshot
     DATAFILE '+DATA'
     SIZE 1g
     AUTOEXTEND ON NEXT 512m MAXSIZE UNLIMITED
     SEGMENT SPACE MANAGEMENT AUTO;

Tablespace created.

-- Step 1.4.2
SQL> CREATE USER snapshot IDENTIFIED BY "Sn#P#5h0#T" CONTAINER=CURRENT
     DEFAULT TABLESPACE tbs_snapshot
     TEMPORARY TABLESPACE TEMP
     QUOTA UNLIMITED ON tbs_snapshot;

User created.

-- Step 1.4.3
SQL> GRANT CONNECT,RESOURCE TO snapshot;

Grant succeeded.

-- Step 1.4.4
-- Connect with any user of Primary Database -> DC
SQL> conn snapshot/"Sn#P#5h0#T"@SBXPDB
/*
Connected.
*/

-- Step 1.4.5
SQL> show user
USER is "SNAPSHOT"

-- Step 1.4.6
-- Create a object with relevant user of Primary Database -> DC
SQL> CREATE TABLE snapshot.snapshot_standby_test AS
     SELECT
          LEVEL sn
     FROM dual
     CONNECT BY LEVEL <=10;
/*
Table created.
*/

-- Step 1.4.7
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

-- Step 1.5
-- Connect with sys user of Primary Database -> DC
SQL> conn sys/Sys605014@pdbdb as sysdba
/*
Connected.
*/

-- Step 1.6
-- Verify the connection of Primary Database -> DC
SQL> show con_name
/*
CON_NAME
------------------------------
CDB$ROOT
*/

-- Step 1.7
-- Verify the currect archive of Primary Database -> DC
SQL> alter system switch logfile;
/*
System altered.
*/

-- Step 1.8
-- Verify the currect archive of Primary Database -> DC
SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;
/*
MAX(SEQUENCE#)    THREAD#
-------------- ----------
           220          1
           103          2
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

-- Step 2.3
-- Verify the DB instance status of Secondary Database -> DR
SQL> show pdbs
/*
    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       MOUNTED
         3 SBXPDB                         MOUNTED
*/

-- Step 2.4
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;
/*
MAX(SEQUENCE#)    THREAD#
-------------- ----------
           220          1
           103          2
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
-- Bring the database in open mode -> DR
SQL> alter pluggable database all open;
/*
Pluggable database altered.
*/

-- Step 3.8
-- Bring the database in open mode -> DR
SQL> show pdbs
/*
    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 SBXPDB                         READ WRITE NO
*/

-- Step 3.9
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT inst_id,status,instance_name FROM gv$instance;
/*
   INST_ID STATUS       INSTANCE_NAME
---------- ------------ ----------------
         1 OPEN         pdbdb1
*/


-- Step 3.10
-- Verify the restore point of Secondary Database -> DR
SQL> SELECT inst_id,flashback_on FROM gv$database;
/*
   INST_ID FLASHBACK_ON
---------- ------------------
         1 RESTORE POINT ONLY
*/

-- Step 3.11
-- Verify the Added Data Files on Primary Database -> DC and properly reflected on Secondary Database -> DR 
SQL> conn snapshot/"Sn#P#5h0#T"@SBXPDB
/*
Connected.
*/

-- Step 3.12
-- Verify the Added Data Files on Primary Database -> DC and properly reflected on Secondary Database -> DR 
SQL> show user
/*
USER is "SNAPSHOT"
*/

-- Step 3.13
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
SQL> show pdbs
/*
    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 SBXPDB                         READ WRITE NO
*/

-- Step 4.2
-- Verify the Added Data Files on Primary Database -> DC and properly reflected on Secondary Database -> DR 
SQL> shutdown immediate;
/*
Database closed.
Database dismounted.
ORACLE instance shut down.
*/

-- Step 4.3
-- Bring the database in mount mode -> DR
SQL> startup mount;
/*
ORACLE instance started.

Total System Global Area 9663673304 bytes
Fixed Size                  9188312 bytes
Variable Size            1476395008 bytes
Database Buffers         8153726976 bytes
Redo Buffers               24363008 bytes
Database mounted.
*/

-- Step 4.4
-- Covert back physical standby database from snapshot standby database -> DR.
SQL> ALTER DATABASE CONVERT TO PHYSICAL STANDBY;
/*
Database altered.
*/

-- Step 4.5
-- Shutdown the database -> DR
SQL> shutdown immediate;
/*
ORA-01109: database not open


Database dismounted.
ORACLE instance shut down.
*/

-- Step 4.6
-- Bring the database in nomount mode -> DR
SQL> startup nomount;
/*
ORACLE instance started.

Total System Global Area 9663673304 bytes
Fixed Size                  9188312 bytes
Variable Size            1476395008 bytes
Database Buffers         8153726976 bytes
Redo Buffers               24363008 bytes
*/

-- Step 4.7
-- Bring the database in mount mode -> DR
SQL> ALTER DATABASE MOUNT STANDBY DATABASE;
/*
Database altered.
*/

-- Step 4.8
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
*/

-- Step 4.9
-- Verify the DB services status Secondary Database -> DR
[oracle@pdbdr1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdbdr1. Instance status: Mounted (Closed).
Instance pdbdb2 is not running on node pdbdr2
*/

-- Step 4.10
-- To stop the DB services and status Secondary Database -> DR
[oracle@pdbdr1 ~]$ srvctl stop database -d pdbdb
[oracle@pdbdr1 ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is not running on node pdbdr1
Instance pdbdb2 is not running on node pdbdr2
*/

-- Step 4.11
-- To start the DB services and status Secondary Database -> DR
[oracle@pdbdr1 ~]$ srvctl start database -d pdbdb -o mount
[oracle@pdbdr1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdbdr1. Instance status: Mounted (Closed).
Instance pdbdb2 is running on node pdbdr2. Instance status: Mounted (Closed).
*/

-- Step 4.12
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT inst_id,status,instance_name from gv$instance;
/*
   INST_ID STATUS       INSTANCE_NAME
---------- ------------ ----------------
         1 MOUNTED      pdbdb1
         2 MOUNTED      pdbdb2
*/

-- Step 4.13
-- Verify the restore point of Secondary Database -> DR
SQL> SELECT inst_id,flashback_on FROM gv$database;
/*
INST_ID FLASHBACK_ON
------- ------------------
      1 NO
      2 NO
*/

-- Step 4.14
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED
*/

-- Step 4.15
-- Verify the DB instance status of Secondary Database -> DR
SQL> show pdbs
/*
    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       MOUNTED
         3 SBXPDB                         MOUNTED
*/

-- Step 4.16
-- Start the Recovery Process in Secondary Database -> DR
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION INSTANCES ALL;
/*
Database altered.
*/

-- Step 4.17
-- Verify the issue in Secondary Database -> DR
SQL> SELECT DISTINCT error FROM gv$archive_dest_status;
/*
ERROR
-----
*/

-- Step 4.18
-- Verify the MRP of Secondary Database -> DR
SELECT inst_id,process,thread#,sequence#,status FROM gv$managed_standby ORDER BY 1;
/*
SQL> SELECT inst_id,process,thread#,sequence#,status FROM gv$managed_standby ORDER BY 1;

   INST_ID PROCESS      THREAD#  SEQUENCE# STATUS
---------- --------- ---------- ---------- ------------
         1 ARCH               0          0 CONNECTED
         1 MRP0               1        221 APPLYING_LOG
         1 DGRD               0          0 ALLOCATED
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
         1 DGRD               0          0 ALLOCATED
         2 ARCH               0          0 CONNECTED
         2 DGRD               0          0 ALLOCATED
         2 DGRD               0          0 ALLOCATED
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
         2 RFS                2          0 IDLE
         2 RFS                1        221 IDLE
         2 RFS                1          0 IDLE
         2 RFS                2        104 IDLE
*/

-- Step 4.19
SQL> SELECT * FROM gv$archive_gap;
/*
no rows selected
*/

-- Step 4.20
-- Verify the DB instance status of Primary Database -> DC
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE
*/

-- Step 4.21
-- Verify the DB instance status of Secondary Database -> DR
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b WHERE a.inst_id=b.inst_id;
/*
   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED
*/


----------------------------------------------------------------
--------------Two Nodes DR Drill Senty Testing------------------
----------------------------------------------------------------
---------Perform Manual Switchover on Physical Standby----------
----------------------------------------------------------------
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
SQL*Plus: Release 19.0.0.0.0 - Production on Wed Oct 16 10:21:31 2024
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

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           228          1
           113          2

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
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 4
--Verify the switchover status on the primary database:
[oracle@pdbdr1 ~]$  sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Wed Oct 16 11:36:13 2024
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
         2 PDB$SEED                       MOUNTED
         3 SBXPDB                         MOUNTED
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           228          1
           113          2

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           228          1
           113          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         1        229 APPLYING_LOG        149 MRP0

SQL> set linesize 9999
SQL> select NAME, VALUE, DATUM_TIME from V$DATAGUARD_STATS;

NAME                             VALUE        DATUM_TIME         
-------------------------------- ------------ -------------------
transport lag                    +00 00:00:00 10/16/2024 11:39:08
apply lag                        +00 00:00:00 10/16/2024 11:39:08
apply finish time
estimated startup time           28

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 5
--Commit to switchover to primary with session shutdown:
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Wed Oct 16 11:40:04 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> select name, open_mode, db_unique_name, database_role from v$database;

NAME      OPEN_MODE            DB_UNIQUE_NAME                 DATABASE_ROLE
--------- -------------------- ------------------------------ ----------------
PDBDB     READ WRITE           pdbdb                          PRIMARY

SQL> alter database commit to switchover to physical standby with session shutdown;

Database altered.

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 6
--Verify the switchover status on the primary database:
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is not running on node pdb1
Instance pdbdb2 is not running on node pdb2
*/

-- Step 7
--Start the switchover primary database:
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
SQL*Plus: Release 19.0.0.0.0 - Production on Wed Oct 16 11:42:16 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

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
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 10
--Commit to switchover to primary with session shutdown:
[oracle@pdbdr1 ~]$  sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Wed Oct 16 11:42:49 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

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
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
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

-- Step 12
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
SQL*Plus: Release 19.0.0.0.0 - Production on Wed Oct 16 11:46:31 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE

SQL> show con_name

CON_NAME
------------------------------
CDB$ROOT

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 SBXPDB                         READ WRITE NO

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> alter system switch logfile;

System altered.

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           232          1
           116          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 14
-- On the new standby (initially the primary), start the MRP:
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Wed Oct 16 11:47:51 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION INSTANCES ALL;

Database altered.

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           232          1
           116          2

SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby;

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         0          0 CONNECTED             0 ARCH
         0          0 ALLOCATED             0 DGRD
         0          0 ALLOCATED             0 DGRD
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
         2        116 CLOSING           65536 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         2        117 IDLE               2199 RFS
         2          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 CONNECTED             0 ARCH
         0          0 ALLOCATED             0 DGRD
         0          0 ALLOCATED             0 DGRD
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
         1        232 CLOSING            2048 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         1        231 CLOSING           65536 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 IDLE                  0 RFS
         1          0 IDLE                  0 RFS
         1        233 IDLE                119 RFS
         2        117 APPLYING_LOG       2199 MRP0

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           232          1
           116          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

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
SQL*Plus: Release 19.0.0.0.0 - Production on Wed Oct 16 11:52:38 2024
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

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           235          1
           117          2

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
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 18
-- Verify the SwitchBack status on the primary database:
[oracle@pdb1 ~]$  sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Wed Oct 16 11:55:30 2024
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
         2 PDB$SEED                       MOUNTED
         3 SBXPDB                         MOUNTED

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           235          1
           117          2

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           234          1
           117          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         2        118 APPLYING_LOG      10713 MRP0

SQL> set linesize 9999
SQL> select NAME, VALUE, DATUM_TIME from V$DATAGUARD_STATS;

NAME                             VALUE        DATUM_TIME         
-------------------------------- ------------ -------------------
transport lag                    +00 00:00:00 10/16/2024 11:57:27
apply lag                        +00 00:00:00 10/16/2024 11:57:27
apply finish time
estimated startup time           28

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 19
--Commit to switchover to physical standby with session shutdown
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Wed Oct 16 11:58:10 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> select name, open_mode, db_unique_name, database_role from v$database;

NAME      OPEN_MODE            DB_UNIQUE_NAME                 DATABASE_ROLE
--------- -------------------- ------------------------------ ----------------
PDBDB     READ WRITE           dr                             PRIMARY

SQL> alter database commit to switchover to physical standby with session shutdown;

Database altered.

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 20
-- Verify the DB services and status of Old Secondary Database
[oracle@pdbdr1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is not running on node pdbdr1
Instance pdbdb2 is not running on node pdbdr2
*/

-- Step 21
-- Start the DB services of Secondary Database
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
SQL*Plus: Release 19.0.0.0.0 - Production on Wed Oct 16 11:59:47 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

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
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 24
--Commit to switchover to primary with session shutdown:
[oracle@pdb1 ~]$  sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Wed Oct 16 12:00:19 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

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
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
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
SQL*Plus: Release 19.0.0.0.0 - Production on Wed Oct 16 12:02:56 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE
         2 OPEN         pdbdb2           PRIMARY          READ WRITE

SQL> show con_name

CON_NAME
------------------------------
CDB$ROOT

SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 SBXPDB                         READ WRITE NO

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> alter system switch logfile;

System altered.

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           240          1
           120          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/

-- Step 29
-- On the old standby, start the MRP:
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Wed Oct 16 12:04:00 2024
Version 19.23.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      pdbdb1           PHYSICAL STANDBY MOUNTED
         2 MOUNTED      pdbdb2           PHYSICAL STANDBY MOUNTED

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION INSTANCES ALL;

Database altered.

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           240          1
           120          2

SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby;

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         0          0 CONNECTED             0 ARCH
         0          0 ALLOCATED             0 DGRD
         0          0 ALLOCATED             0 DGRD
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
         2        120 CLOSING           65536 ARCH
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
         2        121 IDLE               1559 RFS
         2          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         0          0 CONNECTED             0 ARCH
         0          0 ALLOCATED             0 DGRD
         0          0 ALLOCATED             0 DGRD
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         1        238 CLOSING           65536 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         1        239 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         1        240 CLOSING               1 ARCH
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
         1        241 IDLE                115 RFS
         1          0 IDLE                  0 RFS
         2        121 APPLYING_LOG       1559 MRP0

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           240          1
           120          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.23.0.0.0
*/
