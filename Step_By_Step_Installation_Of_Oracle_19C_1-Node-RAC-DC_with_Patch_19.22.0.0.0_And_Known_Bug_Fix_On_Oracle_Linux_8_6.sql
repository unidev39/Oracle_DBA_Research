----------------------------------------------------------------
-------------One Node rac Setup on Physical Server--------------
----------------------------------------------------------------
-- Step 0 -->> 1 Node rac on Physical Server -->> On Node 1
--For OS Oracle Linux 8.6 => boot V1020894-01.iso
--And follow 
--https <= public-yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/
--UEKR6 <= https <= public-yum.oracle.com/repo/OracleLinux/OL8/UEKR6/x86_64/
--appstream <= https <= public-yum.oracle.com/repo/OracleLinux/OL8/appstream/x86_64/
--Then for other RPM V1020898-01.iso

-- Step 0.0 -->>  1 Node rac on Physical Server -->> On Node 1
[root@tpdb1 ~]# df -Th
/*
Filesystem                  Type      Size  Used Avail Use% Mounted on
devtmpfs                    devtmpfs   16G     0   16G   0% /dev
tmpfs                       tmpfs      16G     0   16G   0% /dev/shm
tmpfs                       tmpfs      16G   11M   16G   1% /run
tmpfs                       tmpfs      16G     0   16G   0% /sys/fs/cgroup
/dev/mapper/ol_tpdb100-root xfs        75G  621M   75G   1% /
/dev/mapper/ol_tpdb100-usr  xfs        10G  7.2G  2.9G  72% /usr
/dev/sda1                   xfs      1014M  346M  669M  35% /boot
/dev/mapper/ol_tpdb100-var  xfs        10G  1.3G  8.8G  13% /var
/dev/mapper/ol_tpdb100-tmp  xfs        10G  104M  9.9G   2% /tmp
/dev/mapper/ol_tpdb100-home xfs        10G  104M  9.9G   2% /home
/dev/mapper/ol_tpdb100-opt  xfs        80G  811M   80G   1% /opt
tmpfs                       tmpfs     3.2G   16K  3.2G   1% /run/user/42
tmpfs                       tmpfs     3.2G     0  3.2G   0% /run/user/0
*/

-- Step 1 -->> On Node 1
[root@tpdb1 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
10.0.129.208   tpdb1.unidev.org.np        tpdb1

# Private
10.10.10.28    tpdb1-priv.unidev.org.np   tpdb1-priv

# Virtual
10.0.129.209   tpdb1-vip.unidev.org.np    tpdb1-vip

# SCAN
10.0.129.210   tpdb-scan.unidev.org.np    tpdb-scan
10.0.129.211   tpdb-scan.unidev.org.np    tpdb-scan
*/


-- Step 2 -->> On Node 1
-- Disable secure linux by editing the "/etc/selinux/config" file, making sure the SELINUX flag is set as follows.
[root@tpdb1 ~]# vi /etc/selinux/config
/*
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
#SELINUX=enforcing
SELINUX=disabled
# SELINUXTYPE= can take one of these three values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
*/

-- Step 3 -->> On Node 1
[root@tpdb1 ~]# vi /etc/sysconfig/network
/*
NETWORKING=yes
HOSTNAME=tpdb1.unidev.org.np
*/

-- Step 4 -->> On Node 1
[root@tpdb1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eno1
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=eno1
DEVICE=eno1
ONBOOT=yes
IPADDR=10.0.129.208
NETMASK=255.255.255.0
GATEWAY=10.0.129.6
DNS1=127.0.0.1
DNS2=172.16.20.180
DNS3=172.16.20.181
*/

-- Step 5 -->> On Node 1
[root@tpdb1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eno2
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=eno2
DEVICE=eno2
ONBOOT=yes
IPADDR=10.10.10.208
NETMASK=255.255.255.0
*/

-- Step 6 -->> On Node 1
[root@tpdb1 ~]# systemctl restart network-online.target
[root@tpdb1 ~]# systemctl restart NetworkManager

-- Step 7 -->> On Node 1
[root@tpdb1 ~]# dnf repolist
/*
repo id                  repo name
ol8_UEKR6                Latest Unbreakable Enterprise Kernel Release 6 for Oracle Linux 8 (x86_64)
ol8_appstream            Oracle Linux 8 Application Stream (x86_64)
ol8_baseos_latest        Oracle Linux 8 BaseOS Latest (x86_64)
*/

-- Step 7.1 -->> On Node 1
[root@tpdb1 ~]# uname -a
/*
Linux tpdb1.unidev.org.np 5.4.17-2136.332.5.2.el8uek.x86_64 #3 SMP Tue Jun 11 17:58:26 PDT 2024 x86_64 x86_64 x86_64 GNU/Linux
*/

-- Step 7.2 -->> On Node 1
[root@tpdb1 ~]# uname -r
/*
5.4.17-2136.332.5.2.el8uek.x86_64
*/

-- Step 7.3 -->> On Node 1
[root@tpdb1 ~]# grubby --info=ALL | grep ^kernel
/*
kernel="/boot/vmlinuz-5.4.17-2136.332.5.2.el8uek.x86_64"
kernel="/boot/vmlinuz-4.18.0-553.5.1.el8_10.x86_64"
kernel="/boot/vmlinuz-0-rescue-49f55b2392354305a514f71ba0bf4861"
*/

-- Step 7.4 -->> On Node 1
[root@tpdb1 ~]# grubby --default-kernel
/*
/boot/vmlinuz-5.4.17-2136.332.5.2.el8uek.x86_64
*/

-- Step 8 -->> On Node 1
[root@tpdb1 ~]# cat /etc/hostname
/*
localhost.localdomain
*/

-- Step 8.1 -->> On Node 1
[root@tpdb1 ~]# hostnamectl | grep hostname
/*
   Static hostname: localhost.localdomain
Transient hostname: tpdb1.unidev.org.np
*/

-- Step 8.2 -->> On Node 1
[root@tpdb1 ~]# hostnamectl --static
/*
localhost.localdomain
*/

-- Step 9 -->> On Node 1
[root@tpdb1 ~]# hostnamectl set-hostname tpdb1.unidev.org.np

-- Step 9.1 -->> On Node 1
[root@tpdb1 ~]# hostnamectl
/*
   Static hostname: tpdb1.unidev.org.np
         Icon name: computer-server
           Chassis: server
        Machine ID: 49f55b2392354305a514f71ba0bf4861
           Boot ID: 23843c4e811148ae927b823efa6e8337
  Operating System: Oracle Linux Server 8.10
       CPE OS Name: cpe:/o:oracle:linux:8:10:server
            Kernel: Linux 5.4.17-2136.332.5.2.el8uek.x86_64
      Architecture: x86-64
*/

--Note: If you are not configure proper hostname then While installation of Grid Software, 
--you have to face error CLSRSC-180: An error occurred while executing /opt/app/19c/grid/root.sh script.

-- Step 10 -->> On Node 1
[root@tpdb1 ~]# systemctl stop firewalld
[root@tpdb1 ~]# systemctl disable firewalld
/*
Removed /etc/systemd/system/multi-user.target.wants/firewalld.service.
Removed /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.
*/

-- Step 11 -->> On Node 1df 
[root@tpdb1 ~]# mv /etc/ntp.conf /etc/ntp.conf.backup
[root@tpdb1 ~]# rm -rf /etc/ntp.conf
[root@tpdb1 ~]# rm -rf /var/run/ntpd.pid

-- Step 12 -->> On Node 1
[root@tpdb1 ~]# iptables -F
[root@tpdb1 ~]# iptables -X
[root@tpdb1 ~]# iptables -t nat -F
[root@tpdb1 ~]# iptables -t nat -X
[root@tpdb1 ~]# iptables -t mangle -F
[root@tpdb1 ~]# iptables -t mangle -X
[root@tpdb1 ~]# iptables -P INPUT ACCEPT
[root@tpdb1 ~]# iptables -P FORWARD ACCEPT
[root@tpdb1 ~]# iptables -P OUTPUT ACCEPT
[root@tpdb1 ~]# iptables -L -nv
/*
Chain INPUT (policy ACCEPT 3 packets, 120 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 2 packets, 256 bytes)
 pkts bytes target     prot opt in     out     source               destination
*/

-- Step 13 -->> On Node 1
[root@tpdb1 ~ ]# systemctl stop named
[root@tpdb1 ~ ]# systemctl disable named

-- Step 14 -->> On Node 1
-- Enable chronyd service." `date`
[root@tpdb1 ~ ]# systemctl enable chronyd
[root@tpdb1 ~ ]# systemctl restart chronyd
[root@tpdb1 ~ ]# chronyc -a 'burst 4/4'
/*
200 OK
*/

-- Step 14.1 -->> On Node 1
[root@tpdb1 ~ ]# chronyc -a makestep
/*
200 OK
*/

-- Step 14.2 -->> On Node 1
[root@tpdb1 ~ ]# systemctl status chronyd
/*
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: active (running) since Sun 2024-06-23 12:29:57 +0545; 14s ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 14573 ExecStopPost=/usr/libexec/chrony-helper remove-daemon-state (code=exited, status=0/SUCCESS)
  Process: 14583 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, status=0/SUCCESS)
  Process: 14579 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 14581 (chronyd)
    Tasks: 1 (limit: 202886)
   Memory: 920.0K
   CGroup: /system.slice/chronyd.service
           └─14581 /usr/sbin/chronyd

Jun 23 12:29:57 tpdb1.unidev.org.np systemd[1]: Starting NTP client/server...
Jun 23 12:29:57 tpdb1.unidev.org.np chronyd[14581]: chronyd version 4.5 starting (+CMDMON +NTP +REFCLOCK +RTC +PRIVDROP +SCFILTER +SIGND +ASYNCDNS +NTS +SECHASH +IPV6 +DEBUG)
Jun 23 12:29:57 tpdb1.unidev.org.np chronyd[14581]: Loaded 0 symmetric keys
Jun 23 12:29:57 tpdb1.unidev.org.np chronyd[14581]: Frequency -14.534 +/- 0.105 ppm read from /var/lib/chrony/drift
Jun 23 12:29:57 tpdb1.unidev.org.np chronyd[14581]: Using right/UTC timezone to obtain leap second data
Jun 23 12:29:57 tpdb1.unidev.org.np systemd[1]: Started NTP client/server.
Jun 23 12:30:02 tpdb1.unidev.org.np chronyd[14581]: Selected source 103.104.28.105 (2.pool.ntp.org)
Jun 23 12:30:02 tpdb1.unidev.org.np chronyd[14581]: System clock TAI offset set to 37 seconds
Jun 23 12:30:06 tpdb1.unidev.org.np chronyd[14581]: System clock was stepped by -0.000000 seconds
*/

-- Step 15 -->> On Node 1
[root@tpdb1 ~]# cd /etc/yum.repos.d/
[root@tpdb1 yum.repos.d]# ll
/*
-rw-r--r--. 1 root root 4107 May 22 16:13 oracle-linux-ol8.repo
-rw-r--r--. 1 root root  941 May 23 14:02 uek-ol8.repo
-rw-r--r--. 1 root root  243 May 23 14:02 virt-ol8.repo
*/

-- Step 15.1 -->> On Node 1
[root@tpdb1 ~]# cd /etc/yum.repos.d/
[root@tpdb1 yum.repos.d]# dnf -y update
[root@tpdb1 yum.repos.d]# dnf install -y bind
[root@tpdb1 yum.repos.d]# dnf install -y dnsmasq

-- Step 15.2 -->> On Node 1
[root@tpdb1 ~]# systemctl enable dnsmasq
[root@tpdb1 ~]# systemctl restart dnsmasq
[root@tpdb1 ~]# vi /etc/dnsmasq.conf
/*
listen-address=::1,127.0.0.1

#Add the following Lines
except-interface=virbr0
bind-interfaces
*/

-- Step 15.3 -->> On Node 1
[root@tpdb1 ~]# cat /etc/dnsmasq.conf | grep -E 'listen-address|except-interface|bind-interfaces'
/*
except-interface=virbr0
listen-address=::1,127.0.0.1
bind-interfaces
*/

-- Step 15.4 -->> On Node 1
[root@tpdb1 ~]# systemctl restart dnsmasq
[root@tpdb1 ~]# systemctl restart network-online.target
[root@tpdb1 ~]# systemctl restart NetworkManager
[root@tpdb1 ~]# systemctl status dnsmasq
/*
● dnsmasq.service - DNS caching server.
   Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2024-06-23 12:33:18 +0545; 13s ago
 Main PID: 63399 (dnsmasq)
    Tasks: 1 (limit: 202886)
   Memory: 696.0K
   CGroup: /system.slice/dnsmasq.service
           └─63399 /usr/sbin/dnsmasq -k

Jun 23 12:33:18 tpdb1.unidev.org.np dnsmasq[63399]: compile time options: IPv6 GNU-getopt DBus no-i18n IDN2 DHCP DHCPv6 no-Lua TFTP no-conntrack ipset auth DNSSEC loop-detect inotify
Jun 23 12:33:18 tpdb1.unidev.org.np dnsmasq[63399]: reading /etc/resolv.conf
Jun 23 12:33:18 tpdb1.unidev.org.np dnsmasq[63399]: ignoring nameserver 127.0.0.1 - local interface
Jun 23 12:33:18 tpdb1.unidev.org.np dnsmasq[63399]: using nameserver 172.16.20.180#53
Jun 23 12:33:18 tpdb1.unidev.org.np dnsmasq[63399]: using nameserver 172.16.20.181#53
Jun 23 12:33:18 tpdb1.unidev.org.np dnsmasq[63399]: read /etc/hosts - 7 addresses
Jun 23 12:33:27 tpdb1.unidev.org.np dnsmasq[63399]: reading /etc/resolv.conf
Jun 23 12:33:27 tpdb1.unidev.org.np dnsmasq[63399]: ignoring nameserver 127.0.0.1 - local interface
Jun 23 12:33:27 tpdb1.unidev.org.np dnsmasq[63399]: using nameserver 172.16.20.180#53
Jun 23 12:33:27 tpdb1.unidev.org.np dnsmasq[63399]: using nameserver 172.16.20.181#53
*/

-- Step 15.5 -->> On Node 1
[root@tpdb1 ~]# cat /etc/resolv.conf
/*
# Generated by NetworkManager
search cibnepal.org.np
nameserver 127.0.0.1
nameserver 172.16.20.180
nameserver 172.16.20.181
*/

-- Step 16 -->> On Node 1
[root@tpdb1 ~]# nslookup 10.0.129.208
/*
208.129.0.10.in-addr.arpa       name = tpdb1.unidev.org.np.
*/

-- Step 16.1 -->> On Node 1
[root@tpdb1 ~]# nslookup tpdb1
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   tpdb1.unidev.org.np
Address: 10.0.129.208
*/

-- Step 16.2 -->> On Node 1
[root@tpdb1 ~]# nslookup tpdb-scan
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   tpdb-scan.unidev.org.np
Address: 10.0.129.211
Name:   tpdb-scan.unidev.org.np
Address: 10.0.129.210
*/

-- Step 17 -->> On Node 1
--Stop avahi-daemon damon if it not configured
[root@tpdb1 ~]# systemctl stop avahi-daemon
[root@tpdb1 ~]# systemctl disable avahi-daemon

-- Step 18 -->> On Node 1
--To Remove virbr0 and lxcbr0 Network Interfac
[root@tpdb1 ~]# systemctl stop libvirtd.service
[root@tpdb1 ~]# systemctl disable libvirtd.service
[root@tpdb1 ~]# virsh net-list
/*
 Name      State    Autostart   Persistent
--------------------------------------------
 default   active   yes         yes
*/

-- Step 18.1 -->> On Node 1
[root@tpdb1 ~]# virsh net-destroy default
/*
Network default destroyed
*/

-- Step 18.2 -->> On Node 1
[root@tpdb1 ~]# ifconfig virbr0
/*
virbr0: error fetching interface information: Device not found
*/

-- Step 18.3 -->> On Node One
[root@tpdb1 ~]# ifconfig
/*
eno1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.129.208  netmask 255.255.255.0  broadcast 10.0.129.255
        inet6 fe80::8218:44ff:fee3:caec  prefixlen 64  scopeid 0x20<link>
        ether 80:18:44:e3:ca:ec  txqueuelen 1000  (Ethernet)
        RX packets 273492  bytes 252425972 (240.7 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 111374  bytes 8786947 (8.3 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 52

eno2: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.208  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::8218:44ff:fee3:caed  prefixlen 64  scopeid 0x20<link>
        ether 80:18:44:e3:ca:ed  txqueuelen 1000  (Ethernet)
        RX packets 116451  bytes 16471648 (15.7 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1173  bytes 108104 (105.5 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 53

eno3: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        ether 80:18:44:e3:ca:ee  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 54

eno4: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        ether 80:18:44:e3:ca:ef  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 56

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 3084  bytes 188787 (184.3 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 3084  bytes 188787 (184.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/


-- Step 19 -->> On Node 1
[root@tpdb1 ~]# init 6


-- Step 20 -->> On Node One
[root@tpdb1 ~]# ifconfig
/*
eno1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.129.208  netmask 255.255.255.0  broadcast 10.0.129.255
        inet6 fe80::8218:44ff:fee3:caec  prefixlen 64  scopeid 0x20<link>
        ether 80:18:44:e3:ca:ec  txqueuelen 1000  (Ethernet)
        RX packets 495  bytes 69938 (68.2 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 79  bytes 10608 (10.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 38

eno2: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.208  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::8218:44ff:fee3:caed  prefixlen 64  scopeid 0x20<link>
        ether 80:18:44:e3:ca:ed  txqueuelen 1000  (Ethernet)
        RX packets 422  bytes 55500 (54.1 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 13  bytes 1070 (1.0 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 53

eno3: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        ether 80:18:44:e3:ca:ee  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 55

eno4: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        ether 80:18:44:e3:ca:ef  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 57

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 64  bytes 4898 (4.7 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 64  bytes 4898 (4.7 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 21 -->> On Node 1
[root@tpdb1 ~]# systemctl status libvirtd.service
/*
● libvirtd.service - Virtualization daemon
   Loaded: loaded (/usr/lib/systemd/system/libvirtd.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:libvirtd(8)
           https://libvirt.org
*/

-- Step 22 -->> On Node 1
[root@tpdb1 ~]# firewall-cmd --list-all
/*
FirewallD is not running
*/

-- Step 22.1 -->> On Node 1
[root@tpdb1 ~]# systemctl status firewalld
/*
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:firewalld(1)
*/

-- Step 23 -->> On Node 1
[root@tpdb1 ~]# systemctl status named
/*
● named.service - Berkeley Internet Name Domain (DNS)
   Loaded: loaded (/usr/lib/systemd/system/named.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
*/

-- Step 24 -->> On Node 1
[root@tpdb1 ~]# systemctl status avahi-daemon
/*
● avahi-daemon.service - Avahi mDNS/DNS-SD Stack
   Loaded: loaded (/usr/lib/systemd/system/avahi-daemon.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
*/

-- Step 25 -->> On Node 1
[root@tpdb1 ~ ]# systemctl status chronyd
/*
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: active (running) since Sun 2024-06-23 12:37:44 +0545; 7min ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 1352 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, status=0/SUCCESS)
  Process: 1325 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 1341 (chronyd)
    Tasks: 1 (limit: 202886)
   Memory: 2.2M
   CGroup: /system.slice/chronyd.service
           └─1341 /usr/sbin/chronyd

Jun 23 12:37:44 tpdb1.unidev.org.np systemd[1]: Starting NTP client/server...
Jun 23 12:37:44 tpdb1.unidev.org.np chronyd[1341]: chronyd version 4.5 starting (+CMDMON +NTP +REFCLOCK +RTC +PRIVDROP +SCFILTER +SIGND +ASYNCDNS +NTS +SECHASH +IPV6 +DEBUG)
Jun 23 12:37:44 tpdb1.unidev.org.np chronyd[1341]: Loaded 0 symmetric keys
Jun 23 12:37:44 tpdb1.unidev.org.np chronyd[1341]: Frequency -14.446 +/- 0.277 ppm read from /var/lib/chrony/drift
Jun 23 12:37:44 tpdb1.unidev.org.np chronyd[1341]: Using right/UTC timezone to obtain leap second data
Jun 23 12:37:44 tpdb1.unidev.org.np systemd[1]: Started NTP client/server.
Jun 23 12:37:51 tpdb1.unidev.org.np chronyd[1341]: Selected source 162.159.200.1 (2.pool.ntp.org)
Jun 23 12:37:51 tpdb1.unidev.org.np chronyd[1341]: System clock TAI offset set to 37 seconds
Jun 23 12:40:03 tpdb1.unidev.org.np chronyd[1341]: Received KoD RATE from 103.104.28.105
*/

-- Step 26 -->> On Node 1
[root@tpdb1 ~]# systemctl status dnsmasq
/*
● dnsmasq.service - DNS caching server.
   Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2024-06-23 12:37:44 +0545; 7min ago
 Main PID: 1408 (dnsmasq)
    Tasks: 1 (limit: 202886)
   Memory: 1.3M
   CGroup: /system.slice/dnsmasq.service
           └─1408 /usr/sbin/dnsmasq -k

Jun 23 12:37:44 tpdb1.unidev.org.np dnsmasq[1408]: compile time options: IPv6 GNU-getopt DBus no-i18n IDN2 DHCP DHCPv6 no-Lua TFTP no-conntrack ipset auth DNSSEC loop-detect inotify
Jun 23 12:37:44 tpdb1.unidev.org.np dnsmasq[1408]: reading /etc/resolv.conf
Jun 23 12:37:44 tpdb1.unidev.org.np dnsmasq[1408]: ignoring nameserver 127.0.0.1 - local interface
Jun 23 12:37:44 tpdb1.unidev.org.np dnsmasq[1408]: using nameserver 172.16.20.180#53
Jun 23 12:37:44 tpdb1.unidev.org.np dnsmasq[1408]: using nameserver 172.16.20.181#53
Jun 23 12:37:44 tpdb1.unidev.org.np dnsmasq[1408]: read /etc/hosts - 7 addresses
Jun 23 12:37:44 tpdb1.unidev.org.np dnsmasq[1408]: reading /etc/resolv.conf
Jun 23 12:37:44 tpdb1.unidev.org.np dnsmasq[1408]: ignoring nameserver 127.0.0.1 - local interface
Jun 23 12:37:44 tpdb1.unidev.org.np dnsmasq[1408]: using nameserver 172.16.20.180#53
Jun 23 12:37:44 tpdb1.unidev.org.np dnsmasq[1408]: using nameserver 172.16.20.181#53
*/

-- Step 27 -->> On Node 1
[root@tpdb1 ~]# nslookup 10.0.129.208
/*
208.129.0.10.in-addr.arpa       name = tpdb1.unidev.org.np.
*/

-- Step 27.1 -->> On Node 1
[root@tpdb1 ~]# nslookup tpdb1
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   tpdb1.unidev.org.np
Address: 10.0.129.208
*/

-- Step 27.2 -->> On Node 1
[root@tpdb1 ~]# nslookup tpdb-scan
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   tpdb-scan.unidev.org.np
Address: 10.0.129.211
Name:   tpdb-scan.unidev.org.np
Address: 10.0.129.210
*/

-- Step 27.8 -->> On Node 1
[root@tpdb1 ~]# nslookup tpdb1-vip
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   tpdb1-vip.unidev.org.np
Address: 10.0.129.209
*/

-- Step 27.9 -->> On Node 1
[root@tpdb1 ~]# nslookup tpdb1-priv
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   tpdb1-priv.unidev.org.np
Address: 10.10.10.28
*/

-- Step 28 -->> On Node 1
[root@tpdb1 ~]# iptables -L -nv
/*
Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination
*/


-- Step 29 -->> On Node 1
-- Perform either the Automatic Setup or the Manual Setup to complete the basic prerequisites. 
[root@tpdb1 ~]# cd /etc/yum.repos.d/
[root@tpdb1 yum.repos.d]# dnf -y update

-- Step 29.1 -->> On Node 1
[root@tpdb1 yum.repos.d]# dnf install -y yum-utils
[root@tpdb1 yum.repos.d]# dnf install -y dnf-utils
[root@tpdb1 yum.repos.d]# dnf install -y oracle-epel-release-el8
[root@tpdb1 yum.repos.d]# dnf install -y sshpass zip unzip
[root@tpdb1 yum.repos.d]# dnf install -y oracle-database-preinstall-19c

-- Step 29.2 -->> On Node 1
[root@tpdb1 yum.repos.d]# dnf install -y bc
[root@tpdb1 yum.repos.d]# dnf install -y binutils
[root@tpdb1 yum.repos.d]# dnf install -y compat-libcap1
[root@tpdb1 yum.repos.d]# dnf install -y compat-libstdc++-33
[root@tpdb1 yum.repos.d]# dnf install -y dtrace-utils
[root@tpdb1 yum.repos.d]# dnf install -y elfutils-libelf
[root@tpdb1 yum.repos.d]# dnf install -y elfutils-libelf-devel
[root@tpdb1 yum.repos.d]# dnf install -y fontconfig-devel
[root@tpdb1 yum.repos.d]# dnf install -y glibc
[root@tpdb1 yum.repos.d]# dnf install -y glibc-devel
[root@tpdb1 yum.repos.d]# dnf install -y ksh
[root@tpdb1 yum.repos.d]# dnf install -y libaio
[root@tpdb1 yum.repos.d]# dnf install -y libaio-devel
[root@tpdb1 yum.repos.d]# dnf install -y libdtrace-ctf-devel
[root@tpdb1 yum.repos.d]# dnf install -y libXrender
[root@tpdb1 yum.repos.d]# dnf install -y libXrender-devel
[root@tpdb1 yum.repos.d]# dnf install -y libX11
[root@tpdb1 yum.repos.d]# dnf install -y libXau
[root@tpdb1 yum.repos.d]# dnf install -y libXi
[root@tpdb1 yum.repos.d]# dnf install -y libXtst
[root@tpdb1 yum.repos.d]# dnf install -y libgcc
[root@tpdb1 yum.repos.d]# dnf install -y librdmacm-devel
[root@tpdb1 yum.repos.d]# dnf install -y libstdc++
[root@tpdb1 yum.repos.d]# dnf install -y libstdc++-devel
[root@tpdb1 yum.repos.d]# dnf install -y libxcb
[root@tpdb1 yum.repos.d]# dnf install -y make
[root@tpdb1 yum.repos.d]# dnf install -y net-tools
[root@tpdb1 yum.repos.d]# dnf install -y nfs-utils
[root@tpdb1 yum.repos.d]# dnf install -y python
[root@tpdb1 yum.repos.d]# dnf install -y python-configshell
[root@tpdb1 yum.repos.d]# dnf install -y python-rtslib
[root@tpdb1 yum.repos.d]# dnf install -y python-six
[root@tpdb1 yum.repos.d]# dnf install -y targetcli
[root@tpdb1 yum.repos.d]# dnf install -y smartmontools
[root@tpdb1 yum.repos.d]# dnf install -y sysstat
[root@tpdb1 yum.repos.d]# dnf install -y libnsl
[root@tpdb1 yum.repos.d]# dnf install -y libnsl.i686
[root@tpdb1 yum.repos.d]# dnf install -y libnsl2
[root@tpdb1 yum.repos.d]# dnf install -y libnsl2.i686
[root@tpdb1 yum.repos.d]# dnf install -y chrony
[root@tpdb1 yum.repos.d]# dnf install -y unixODBC
[root@tpdb1 yum.repos.d]# dnf -y update

-- Step 29.3 -->> On Node 1
[root@tpdb1 ~]# cd /tmp
--Bug 29772579
[root@tpdb1 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libcap1-1.10-7.el7.i686.rpm
[root@tpdb1 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libcap1-1.10-7.el7.x86_64.rpm
[root@tpdb1 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libstdc++-33-3.2.3-72.el7.i686.rpm
[root@tpdb1 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm

-- Step 29.4 -->> On Node 1
[root@tpdb1 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/elfutils-libelf-devel-0.189-3.el8.i686.rpm
[root@tpdb1 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/elfutils-libelf-devel-0.189-3.el8.x86_64.rpm
[root@tpdb1 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/numactl-2.0.12-13.el8.x86_64.rpm
[root@tpdb1 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/numactl-devel-2.0.12-13.el8.x86_64.rpm
[root@tpdb1 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/numactl-devel-2.0.12-13.el8.i686.rpm
[root@tpdb1 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/python3-libs-3.6.8-56.0.1.el8_9.i686.rpm
[root@tpdb1 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/python3-libs-3.6.8-56.0.1.el8_9.x86_64.rpm

/* -- On Physical Server (If the ASMLib-8 we installed)
https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=364500837732007&id=2789052.1&_adf.ctrl-state=11vbxw8jk2_58

--OL8/RHEL8: ASMLib: root.sh is failing with CRS-1705: Found 0 Configured Voting Files But 1 Voting Files Are Required (Doc ID 2789052.1)
Bug 32410237 - oracleasm configure -p not discovering disks on RHEL8
Bug 32812376 - ROOT.SH IS FAILING WTH THE ERRORS CLSRSC-119: START OF THE EXCLUSIVE MODE CLUSTER FAILED
*/

--[root@tpdb1 tmp]# wget https://download.oracle.com/otn_software/asmlib/oracleasmlib-2.0.17-1.el8.x86_64.rpm
--[root@tpdb1 tmp]# wget https://public-yum.oracle.com/repo/OracleLinux/OL8/addons/x86_64/getPackage/oracleasm-support-2.1.12-1.el8.x86_64.rpm

-- Step 29.5 -->> On Node 1
[root@tpdb1 tmp]# wget https://download.oracle.com/otn_software/asmlib/oracleasmlib-2.0.12-1.el7.x86_64.rpm
[root@tpdb1 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/oracleasm-support-2.1.11-2.el7.x86_64.rpm

-- Step 29.6 -->> On Node 1
--Bug 29772579
[root@tpdb1 tmp]# yum -y localinstall ./compat-libcap1-1.10-7.el7.i686.rpm
[root@tpdb1 tmp]# yum -y localinstall ./compat-libcap1-1.10-7.el7.x86_64.rpm
[root@tpdb1 tmp]# yum -y localinstall ./compat-libstdc++-33-3.2.3-72.el7.i686.rpm
[root@tpdb1 tmp]# yum -y localinstall ./compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm

-- Step 29.7 -->> On Node 1
[root@tpdb1 tmp]# yum -y localinstall ./elfutils-libelf-devel-0.189-3.el8.i686.rpm
[root@tpdb1 tmp]# yum -y localinstall ./elfutils-libelf-devel-0.189-3.el8.x86_64.rpm
[root@tpdb1 tmp]# yum -y localinstall ./numactl-2.0.12-13.el8.x86_64.rpm
[root@tpdb1 tmp]# yum -y localinstall ./numactl-devel-2.0.12-13.el8.i686.rpm
[root@tpdb1 tmp]# yum -y localinstall ./numactl-devel-2.0.12-13.el8.x86_64.rpm
[root@tpdb1 tmp]# yum -y localinstall ./python3-libs-3.6.8-56.0.1.el8_9.i686.rpm
[root@tpdb1 tmp]# yum -y localinstall ./python3-libs-3.6.8-56.0.1.el8_9.x86_64.rpm

/* -- On Physical Server (If the ASMLib-8 we installed)
https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=364500837732007&id=2789052.1&_adf.ctrl-state=11vbxw8jk2_58

--OL8/RHEL8: ASMLib: root.sh is failing with CRS-1705: Found 0 Configured Voting Files But 1 Voting Files Are Required (Doc ID 2789052.1)
Bug 32410237 - oracleasm configure -p not discovering disks on RHEL8
Bug 32812376 - ROOT.SH IS FAILING WTH THE ERRORS CLSRSC-119: START OF THE EXCLUSIVE MODE CLUSTER FAILED
*/

--[root@tpdb1 tmp]# yum -y localinstall ./oracleasm-support-2.1.12-1.el8.x86_64.rpm ./oracleasmlib-2.0.17-1.el8.x86_64.rpm

-- Step 29.8 -->> On Node 1
[root@tpdb1 tmp]# yum -y localinstall ./oracleasm-support-2.1.11-2.el7.x86_64.rpm ./oracleasmlib-2.0.12-1.el7.x86_64.rpm
[root@tpdb1 tmp]# rm -rf *.rpm

-- Step 30 -->> On Node 1
[root@tpdb1 ~]# cd /etc/yum.repos.d/
[root@tpdb1 yum.repos.d]# dnf -y install compat-libcap1 compat-libstdc++-33 bc binutils elfutils-libelf elfutils-libelf-devel fontconfig-devel glibc glibc-devel ksh libaio libaio-devel libgcc libnsl librdmacm-devel libstdc++ libstdc++-devel libX11 libXau libxcb libXi libXrender libXrender-devel libXtst make net-tools nfs-utils python3 python3-configshell python3-rtslib python3-six smartmontools sysstat targetcli unzip
[root@tpdb1 yum.repos.d]# dnf -y install bash bc bind-utils binutils ethtool glibc glibc-devel initscripts ksh libaio libaio-devel libgcc libnsl libstdc++ libstdc++-devel make module-init-tools net-tools nfs-utils openssh-clients openssl-libs pam procps psmisc smartmontools sysstat tar unzip util-linux-ng xorg-x11-utils xorg-x11-xauth 
[root@tpdb1 yum.repos.d]# dnf -y update

-- Step 31 -->> On Node 1
[root@tpdb1 yum.repos.d]# rpm -q binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel elfutils-libelf-devel-static \
[root@tpdb1 yum.repos.d]# rpm -q gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers kernel-headers ksh libaio libaio-devel \
[root@tpdb1 yum.repos.d]# rpm -q libgcc libgomp libstdc++ libstdc++-devel make numactl-devel sysstat unixODBC unixODBC-devel \

-- Step 32 -->> On Node 1
[root@tpdb1 ~]# rpm -qa | grep oracleasm
/*
oracleasm-support-2.1.11-2.el7.x86_64
oracleasmlib-2.0.12-1.el7.x86_64
*/

-- Step 33 -->> On Node 1
-- Add the kernel parameters file "/etc/sysctl.conf" and add oracle recommended kernel parameters
[root@tpdb1 ~]# vi /etc/sysctl.conf
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

-- Step 33.1 -->> On Node 1
-- Run the following command to change the current kernel parameters.
[root@tpdb1 ~]# sysctl -p /etc/sysctl.conf

-- Step 34 -->> On Node 1
-- Edit “/etc/security/limits.d/oracle-database-preinstall-19c.conf” file to limit user processes
[root@tpdb1 ~]# vi /etc/security/limits.d/oracle-database-preinstall-19c.conf
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

-- Step 35 -->> On Node 1
-- Add the following line to the "/etc/pam.d/login" file, if it does not already exist.
[root@tpdb1 ~]# vi /etc/pam.d/login
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

-- Step 36 -->> On Node 1
-- Create the new groups and users.
[root@tpdb1 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:
*/

-- Step 36.1 -->> On Node 1
[root@tpdb1 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:oracle
backupdba:x:54324:oracle
dgdba:x:54325:oracle
kmdba:x:54326:oracle
racdba:x:54330:oracle
*/

-- Step 36.2 -->> On Node 1
[root@tpdb1 ~]# cat /etc/group | grep -i oracle
/*
oinstall:x:54321:oracle
dba:x:54322:oracle
oper:x:54323:oracle
backupdba:x:54324:oracle
dgdba:x:54325:oracle
kmdba:x:54326:oracle
racdba:x:54330:oracle
*/

-- Step 36.3 -->> On Node 1
[root@tpdb1 ~]# cat /etc/group | grep -i oper
/*
oper:x:54323:oracle
*/

-- Step 36.4 -->> On Node 1
[root@tpdb1 ~]# cat /etc/group | grep -i asm

-- Step 37 -->> On Node 1
-- 1.Create OS groups using the command below. Enter these commands as the 'root' user:
--[root@tpdb1 ~]# /usr/sbin/groupadd -g 503 oper
[root@tpdb1 ~]# /usr/sbin/groupadd -g 504 asmadmin
[root@tpdb1 ~]# /usr/sbin/groupadd -g 506 asmdba
[root@tpdb1 ~]# /usr/sbin/groupadd -g 507 asmoper
[root@tpdb1 ~]# /usr/sbin/groupadd -g 508 beoper

-- Step 38 -->> On Node 1
-- 2.Create the users that will own the Oracle software using the commands:
[root@tpdb1 ~]# /usr/sbin/useradd  -g oinstall -G oinstall,dba,asmadmin,asmdba,asmoper,beoper grid
[root@tpdb1 ~]# /usr/sbin/usermod -g oinstall -G oinstall,dba,oper,asmdba,asmadmin,backupdba,dgdba,kmdba,racdba oracle

-- Step 39.1 -->> On Node 1
[root@tpdb1 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/

-- Step 39.2 -->> On Node 1
[root@tpdb1 ~]# cat /etc/group | grep -i oracle
/*
oinstall:x:54321:oracle,grid
dba:x:54322:oracle,grid
oper:x:54323:oracle
backupdba:x:54324:oracle
dgdba:x:54325:oracle
kmdba:x:54326:oracle
racdba:x:54330:oracle
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
*/

-- Step 39.3 -->> On Node 1
[root@tpdb1 ~]# cat /etc/group | grep -i grid
/*
oinstall:x:54321:oracle,grid
dba:x:54322:oracle,grid
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 39.4 -->> On Node 1
[root@tpdb1 ~]# cat /etc/group | grep -i oper
/*
oper:x:54323:oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 39.5 -->> On Node 1
[root@tpdb1 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:grid,oracle
*/

-- Step 39.6 -->> On Node 1
[root@tpdb1 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:oracle,grid
backupdba:x:54324:oracle
dgdba:x:54325:oracle
kmdba:x:54326:oracle
racdba:x:54330:oracle
asmdba:x:506:grid,oracle
*/

-- Step 40 -->> On Node 1
[root@tpdb1 ~]# passwd oracle
/*
Changing password for user oracle.
New password: oracle
Retype new password: oracle
passwd: all authentication tokens updated successfully.
*/

-- Step 41 -->> On Node 1
[root@tpdb1 ~]# passwd grid
/*
Changing password for user grid.
New password: grid
Retype new password: grid
passwd: all authentication tokens updated successfully.
*/

-- Step 42 -->> On Node 1
[root@tpdb1 ~]# su - oracle

-- Step 42.1 -->> On Node 1
[oracle@tpdb1 ~]$ su - grid
/*
Password: grid
*/

-- Step 42.2 -->> On Node 1
[grid@tpdb1 ~]$ su - oracle
/*
Password: oracle
*/

-- Step 42.3 -->> On Node 1
[oracle@tpdb1 ~]$ exit
/*
logout
*/

-- Step 42.4 -->> On Node 1
[grid@tpdb1 ~]$ exit
/*
logout
*/

-- Step 42.5 -->> On Node 1
[oracle@tpdb1 ~]$ exit
/*
logout
*/

-- Step 43 -->> On Node 1
--Create the Oracle Inventory Director:
[root@tpdb1 ~]# mkdir -p /opt/app/oraInventory
[root@tpdb1 ~]# chown -R grid:oinstall /opt/app/oraInventory
[root@tpdb1 ~]# chmod -R 775 /opt/app/oraInventory

-- Step 44 -->> On Node 1
--Creating the Oracle Grid Infrastructure Home Directory:
[root@tpdb1 ~]# mkdir -p /opt/app/19c/grid
[root@tpdb1 ~]# chown -R grid:oinstall /opt/app/19c/grid
[root@tpdb1 ~]# chmod -R 775 /opt/app/19c/grid

-- Step 45 -->> On Node 1
--Creating the Oracle Base Directory
[root@tpdb1 ~]#   mkdir -p /opt/app/oracle
[root@tpdb1 ~]#   chmod -R 775 /opt/app/oracle
[root@tpdb1 ~]#   cd /opt/app/
[root@tpdb1 app]# chown -R oracle:oinstall /opt/app/oracle

-- Step 46 -->> On Node 1
-- Login as the oracle user and add the following lines at the end of the ".bash_profile" file.
[root@tpdb1 ~]# su - oracle
[oracle@tpdb1 ~]$ vi .bash_profile
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

ORACLE_HOSTNAME=tpdb1.unidev.org.np; export ORACLE_HOSTNAME
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
[oracle@tpdb1 ~]$ . .bash_profile

-- Step 48 -->> On Node 1
-- Login as the grid user and add the following lines at the end of the ".bash_profile" file.
[root@tpdb1 ~]# su - grid
[grid@tpdb1 ~]$ vi .bash_profile
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
[grid@tpdb1 ~]$ . .bash_profile

-- Step 50 -->> On Node 1
-- To Unzio The Oracle Grid Software and lateset Opatch
[root@tpdb1 ~]# cd /opt/app/19c/grid/
[root@tpdb1 grid]# unzip -oq /root/Oracle_19C/19.3.0.0.0_Grid_Binary/LINUX.X64_193000_grid_home.zip
[root@tpdb1 grid]# unzip -oq /root/Oracle_19C/OPATCH_19c/p6880880_190000_Linux-x86-64.zip

-- Step 51 -->> On Node 1
-- To Unzio The Oracle PSU
[root@tpdb1 ~]# cd /tmp/
[root@tpdb1 tmp]# unzip -oq /root/Oracle_19C/PSU_19.22.0.0.0/p36031453_190000_Linux-x86-64.zip
[root@tpdb1 tmp]# chown -R oracle:oinstall 36031453
[root@tpdb1 tmp]# chmod -R 775 36031453
[root@tpdb1 tmp]# ls -ltr | grep 36031453
/*
drwxrwxr-x  4 oracle oinstall      57 Jan 16 13:07 36031453
*/

-- Step 52 -->> On Node 1
-- Login as root user and issue the following command at pdb1
[root@tpdb1 ~]# chown -R grid:oinstall /opt/app/19c/grid/
[root@tpdb1 ~]# chmod -R 775 /opt/app/19c/grid/

-- Step 53 -->> On Node 1
[root@tpdb1 ~]# su - grid
[grid@tpdb1 ~]$ cd /opt/app/19c/grid/OPatch/
[grid@tpdb1 OPatch]$ ./opatch version
/*
OPatch Version: 12.2.0.1.42

OPatch succeeded.
*/

-- Step 54 -->> On Node 1
-- To install the cvuqdisk-1.0.10-1.rpm
-- Login from root user
[root@tpdb1 ~]# cd /opt/app/19c/grid/cv/rpm/

-- Step 54.1 -->> On Node 1
[root@tpdb1 rpm]# ls -ltr
/*
-rwxrwxr-x 1 grid oinstall 11412 Mar 13  2019 cvuqdisk-1.0.10-1.rpm
*/

-- Step 54.2 -->> On Node 1
--[root@tpdb1 rpm]# export CV_ASSUME_DISTID=OEL7.8
[root@tpdb1 rpm]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP

-- Step 54.3 -->> On Node 1
[root@tpdb1 rpm]# rpm -iUvh cvuqdisk-1.0.10-1.rpm 
/*
Verifying...                          ################################# [100%]
Preparing...                          ################################# [100%]
Updating / installing...
   1:cvuqdisk-1.0.10-1                ################################# [100%]
*/

-- Step 55 -->> On Node 1
[root@tpdb1 ~]# which oracleasm
/*
/usr/sbin/oracleasm
*/

-- Step 55.1 -->> On Node 1
[root@tpdb1 ~]# oracleasm configure
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

-- Step 55.2 -->> On Node 1
[root@tpdb1 ~]# oracleasm status
/*
Checking if ASM is loaded: no
Checking if /dev/oracleasm is mounted: no
*/

-- Step 55.3 -->> On Node 1
[root@tpdb1 ~]# oracleasm configure -i
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

-- Step 55.4 -->> On Node 1
[root@tpdb1 ~]# oracleasm configure
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

-- Step 55.5 -->> On Node 1
[root@tpdb1 ~]# oracleasm init
/*
Creating /dev/oracleasm mount point: /dev/oracleasm
Loading module "oracleasm": oracleasm
Configuring "oracleasm" to use device physical block size
Mounting ASMlib driver filesystem: /dev/oracleasm
*/

-- Step 55.6 -->> On Node 1
[root@tpdb1 ~]# oracleasm status
/*
Checking if ASM is loaded: yes
Checking if /dev/oracleasm is mounted: yes
*/

-- Step 55.7 -->> On Node 1
[root@tpdb1 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 55.8 -->> On Node 1
[root@tpdb1 ~]# oracleasm listdisks

-- Step 56 -->> On Node 1
[root@tpdb1 ~]# ls -ltr /etc/init.d/
/*
-rwxr-xr-x  1 root root  4954 Feb  3  2018 oracleasm
-rwx------  1 root root  1281 Feb 17  2021 oracle-database-preinstall-19c-firstboot
-rw-r--r--. 1 root root 18434 Aug 10  2022 functions
-rw-r--r--. 1 root root  1161 Jun  5 18:53 README
*/

-- Step 57 -->> On Node 1
[root@tpdb1 ~]# ls -ll /dev/oracleasm/disks/
/*
total 0
*/

-- Step 58 -->> On Node 1
[root@tpdb1 ~]# ls -ll /dev/sd*
/*
brw-rw---- 1 root disk 8, 0 Jun 23 12:37 /dev/sda
brw-rw---- 1 root disk 8, 1 Jun 23 12:37 /dev/sda1
brw-rw---- 1 root disk 8, 2 Jun 23 12:37 /dev/sda2
*/

--Step 58.1 -->> On Node 1
[root@tpdb1 ~]# lsblk
/*
NAME                MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                   8:0    0  1.5T  0 disk
├─sda1                8:1    0    1G  0 part /boot
└─sda2                8:2    0  211G  0 part
  ├─ol_tpdb100-root 252:0    0   75G  0 lvm  /
  ├─ol_tpdb100-swap 252:1    0   16G  0 lvm  [SWAP]
  ├─ol_tpdb100-usr  252:2    0   10G  0 lvm  /usr
  ├─ol_tpdb100-tmp  252:3    0   10G  0 lvm  /tmp
  ├─ol_tpdb100-var  252:4    0   10G  0 lvm  /var
  ├─ol_tpdb100-home 252:5    0   10G  0 lvm  /home
  └─ol_tpdb100-opt  252:6    0   80G  0 lvm  /opt
sr0                  11:0    1 1024M  0 rom
*/

-- Step 58.2 -->> On Node 1
[root@tpdb1 ~]# fdisk -ll | grep TiB
/*
Disk /dev/sda: 1.5 TiB, 1599070011392 bytes, 3123183616 sectors
*/

-- Step 58.3 -->> On Node 1
[root@tpdb1 ~]# fdisk /dev/sda
/*
Welcome to fdisk (util-linux 2.32.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): p
Disk /dev/sda: 1.5 TiB, 1599070011392 bytes, 3123183616 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x56eb3c8a

Device     Boot   Start       End   Sectors  Size Id Type
/dev/sda1  *       2048   2099199   2097152    1G 83 Linux
/dev/sda2       2099200 444614655 442515456  211G 8e Linux LVM

Command (m for help): n
Partition type
   p   primary (2 primary, 0 extended, 2 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (3,4, default 3): 3
First sector (444614656-3123183615, default 444614656):
Last sector, +sectors or +size{K,M,G,T,P} (444614656-3123183615, default 3123183615): +20G

Created a new partition 3 of type 'Linux' and of size 20 GiB.

Command (m for help): p
Disk /dev/sda: 1.5 TiB, 1599070011392 bytes, 3123183616 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x56eb3c8a

Device     Boot     Start       End   Sectors  Size Id Type
/dev/sda1  *         2048   2099199   2097152    1G 83 Linux
/dev/sda2         2099200 444614655 442515456  211G 8e Linux LVM
/dev/sda3       444614656 486557695  41943040   20G 83 Linux

Command (m for help): w
The partition table has been altered.
Syncing disks.
*/

-- Step 58.4 -->> On Node 1
[root@tpdb1 ~]# fdisk /dev/sda
/*
Welcome to fdisk (util-linux 2.32.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): p
Disk /dev/sda: 1.5 TiB, 1599070011392 bytes, 3123183616 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x56eb3c8a

Device     Boot     Start       End   Sectors  Size Id Type
/dev/sda1  *         2048   2099199   2097152    1G 83 Linux
/dev/sda2         2099200 444614655 442515456  211G 8e Linux LVM
/dev/sda3       444614656 486557695  41943040   20G 83 Linux

Command (m for help): n
Partition type
   p   primary (3 primary, 0 extended, 1 free)
   e   extended (container for logical partitions)
Select (default e): e

Selected partition 4
First sector (486557696-3123183615, default 486557696):
Last sector, +sectors or +size{K,M,G,T,P} (486557696-3123183615, default 3123183615):

Created a new partition 4 of type 'Extended' and of size 1.2 TiB.

Command (m for help): p
Disk /dev/sda: 1.5 TiB, 1599070011392 bytes, 3123183616 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x56eb3c8a

Device     Boot     Start        End    Sectors  Size Id Type
/dev/sda1  *         2048    2099199    2097152    1G 83 Linux
/dev/sda2         2099200  444614655  442515456  211G 8e Linux LVM
/dev/sda3       444614656  486557695   41943040   20G 83 Linux
/dev/sda4       486557696 3123183615 2636625920  1.2T  5 Extended

Command (m for help): w
The partition table has been altered.
Syncing disks.
*/

-- Step 58.5 -->> On Node 1
[root@tpdb1 ~]# fdisk /dev/sda
/*
Welcome to fdisk (util-linux 2.32.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): p
Disk /dev/sda: 1.5 TiB, 1599070011392 bytes, 3123183616 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x56eb3c8a

Device     Boot     Start        End    Sectors  Size Id Type
/dev/sda1  *         2048    2099199    2097152    1G 83 Linux
/dev/sda2         2099200  444614655  442515456  211G 8e Linux LVM
/dev/sda3       444614656  486557695   41943040   20G 83 Linux
/dev/sda4       486557696 3123183615 2636625920  1.2T  5 Extended

Command (m for help): n
All primary partitions are in use.
Adding logical partition 5
First sector (486559744-3123183615, default 486559744):
Last sector, +sectors or +size{K,M,G,T,P} (486559744-3123183615, default 3123183615): +200G

Created a new partition 5 of type 'Linux' and of size 200 GiB.

Command (m for help): p
Disk /dev/sda: 1.5 TiB, 1599070011392 bytes, 3123183616 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x56eb3c8a

Device     Boot     Start        End    Sectors  Size Id Type
/dev/sda1  *         2048    2099199    2097152    1G 83 Linux
/dev/sda2         2099200  444614655  442515456  211G 8e Linux LVM
/dev/sda3       444614656  486557695   41943040   20G 83 Linux
/dev/sda4       486557696 3123183615 2636625920  1.2T  5 Extended
/dev/sda5       486559744  905990143  419430400  200G 83 Linux

Command (m for help): w
The partition table has been altered.
Syncing disks.
*/

-- Step 58.6 -->> On Node 1
[root@tpdb1 ~]# fdisk /dev/sda
/*
Welcome to fdisk (util-linux 2.32.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): p
Disk /dev/sda: 1.5 TiB, 1599070011392 bytes, 3123183616 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x56eb3c8a

Device     Boot     Start        End    Sectors  Size Id Type
/dev/sda1  *         2048    2099199    2097152    1G 83 Linux
/dev/sda2         2099200  444614655  442515456  211G 8e Linux LVM
/dev/sda3       444614656  486557695   41943040   20G 83 Linux
/dev/sda4       486557696 3123183615 2636625920  1.2T  5 Extended
/dev/sda5       486559744  905990143  419430400  200G 83 Linux

Command (m for help): n
All primary partitions are in use.
Adding logical partition 6
First sector (905992192-3123183615, default 905992192):
Last sector, +sectors or +size{K,M,G,T,P} (905992192-3123183615, default 3123183615): +400G

Created a new partition 6 of type 'Linux' and of size 400 GiB.

Command (m for help): p
Disk /dev/sda: 1.5 TiB, 1599070011392 bytes, 3123183616 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x56eb3c8a

Device     Boot     Start        End    Sectors  Size Id Type
/dev/sda1  *         2048    2099199    2097152    1G 83 Linux
/dev/sda2         2099200  444614655  442515456  211G 8e Linux LVM
/dev/sda3       444614656  486557695   41943040   20G 83 Linux
/dev/sda4       486557696 3123183615 2636625920  1.2T  5 Extended
/dev/sda5       486559744  905990143  419430400  200G 83 Linux
/dev/sda6       905992192 1744852991  838860800  400G 83 Linux

Command (m for help): w
The partition table has been altered.
Syncing disks.
*/

-- Step 58.7 -->> On Node 1
[root@tpdb1 ~]# ls -ll /dev/sd*
/*
brw-rw---- 1 root disk 8, 0 Jun 23 15:04 /dev/sda
brw-rw---- 1 root disk 8, 1 Jun 23 15:04 /dev/sda1
brw-rw---- 1 root disk 8, 2 Jun 23 15:04 /dev/sda2
brw-rw---- 1 root disk 8, 3 Jun 23 15:04 /dev/sda3
brw-rw---- 1 root disk 8, 4 Jun 23 15:04 /dev/sda4
brw-rw---- 1 root disk 8, 5 Jun 23 15:04 /dev/sda5
brw-rw---- 1 root disk 8, 6 Jun 23 15:04 /dev/sda6
*/

-- Step 58.8 -->> On Node 1
[root@tpdb1 ~]# fdisk -ll | grep sd
/*
Disk /dev/sda: 1.5 TiB, 1599070011392 bytes, 3123183616 sectors
/dev/sda1  *         2048    2099199    2097152    1G 83 Linux
/dev/sda2         2099200  444614655  442515456  211G 8e Linux LVM
/dev/sda3       444614656  486557695   41943040   20G 83 Linux
/dev/sda4       486557696 3123183615 2636625920  1.2T  5 Extended
/dev/sda5       486559744  905990143  419430400  200G 83 Linux
/dev/sda6       905992192 1744852991  838860800  400G 83 Linux
*/

-- Step 58.9 -->> On Node 1
[root@tpdb1 ~]# lsblk
/*
NAME                MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                   8:0    0  1.5T  0 disk
├─sda1                8:1    0    1G  0 part /boot
├─sda2                8:2    0  211G  0 part
│ ├─ol_tpdb100-root 252:0    0   75G  0 lvm  /
│ ├─ol_tpdb100-swap 252:1    0   16G  0 lvm  [SWAP]
│ ├─ol_tpdb100-usr  252:2    0   10G  0 lvm  /usr
│ ├─ol_tpdb100-tmp  252:3    0   10G  0 lvm  /tmp
│ ├─ol_tpdb100-var  252:4    0   10G  0 lvm  /var
│ ├─ol_tpdb100-home 252:5    0   10G  0 lvm  /home
│ └─ol_tpdb100-opt  252:6    0   80G  0 lvm  /opt
├─sda3                8:3    0   20G  0 part
├─sda4                8:4    0    1K  0 part
├─sda5                8:5    0  200G  0 part
└─sda6                8:6    0  400G  0 part
sr0                  11:0    1 1024M  0 rom
*/

-- Step 58.10 -->> On Node 1
[root@tpdb1 ~]# mkfs.xfs -f /dev/sda3
[root@tpdb1 ~]# mkfs.xfs -f /dev/sda5
[root@tpdb1 ~]# mkfs.xfs -f /dev/sda6

-- Step 59 -->> On Node 1
[root@tpdb1 ~]# /usr/sbin/oracleasm createdisk OCR /dev/sda3
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 59.1 -->> On Node 1
[root@tpdb1 ~]# /usr/sbin/oracleasm createdisk DATA /dev/sda5
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 59.2 -->> On Node 1
[root@tpdb1 ~]# /usr/sbin/oracleasm createdisk ARC /dev/sda6
/*
Writing disk header: done
Instantiating disk: done
*/

-- Step 59.3 -->> On Node 1
[root@tpdb1 ~]# oracleasm scandisks
/*
Reloading disk partitions: done
Cleaning any stale ASM disks...
Scanning system for ASM disks...
*/

-- Step 59.4 -->> On Node 1
[root@tpdb1 ~]# oracleasm listdisks
/*
ARC
DATA
OCR
*/

-- Step 60 -->> On Node 1
[root@tpdb1 ~]# ls -ll /dev/oracleasm/disks/
/*
brw-rw---- 1 grid asmadmin 8, 6 Jun 23 15:06 ARC
brw-rw---- 1 grid asmadmin 8, 5 Jun 23 15:06 DATA
brw-rw---- 1 grid asmadmin 8, 3 Jun 23 15:06 OCR
*/

-- Step 61 -->> On Node 1
-- To setup SSH Pass
[root@tpdb1 ~]# su - grid
[grid@tpdb1 ~]$ cd /opt/app/19c/grid/deinstall
[grid@tpdb1 deinstall]$ ./sshUserSetup.sh -user grid -hosts "tpdb1" -noPromptPassphrase -confirm -advanced
/*
Password: grid
*/

-- Step 62 -->> On Node 1
[grid@tpdb1 ~]$ ssh grid@tpdb1 date
[grid@tpdb1 ~]$ ssh grid@tpdb1.unidev.org.np date
[grid@tpdb1 ~]$ ssh grid@tpdb1 date && ssh grid@tpdb1.unidev.org.np date

-- Step 63 -->> On Node 1
-- Bug 30286976: To Solve the Pre-check or any Oracle relavant Installation for rac Setup make compatible version CV_ASSUME_DISTID=OEL7.8
[grid@tpdb1 ~]$ vi /opt/app/19c/grid/cv/admin/cvu_config
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

#if enabled, cvuqdisk rpm is required On Node 1s
CV_RAW_CHECK_ENABLED=TRUE

# Fallback to this distribution id
CV_ASSUME_DISTID=OEL7.8

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

-- Step 63.1 -->> On Node 1
[grid@tpdb1 ~]$ cat /opt/app/19c/grid/cv/admin/cvu_config | grep -E CV_ASSUME_DISTID
/*
CV_ASSUME_DISTID=OEL7.8
*/

-- Step 64 -->> On Node 1
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

-- Step 64.1 -->> On Node 1
[root@tpdb1 ~]# cp -p /usr/bin/scp /usr/bin/scp-original

-- Step 64.2 -->> On Node 1
[root@tpdb1 ~]# echo "/usr/bin/scp-original -T \$*" > /usr/bin/scp

-- Step 64.3 -->> On Node 1
[root@tpdb1 ~]# cat /usr/bin/scp
/*
/usr/bin/scp-original -T $*
*/

-- Step 65 -->> On Node 1
-- Pre-check for rac Setup
[grid@tpdb1 ~]$ cd /opt/app/19c/grid/
[grid@tpdb1 grid]$ export CV_ASSUME_DISTID=OEL7.8
[grid@tpdb1 grid]$ ./runcluvfy.sh stage -pre crsinst -n tpdb1 -verbose
[grid@tpdb1 grid]$ export CV_ASSUME_DISTID=OEL7.8
[grid@tpdb1 grid]$ ./runcluvfy.sh stage -pre crsinst -n tpdb1 -method root
--[grid@tpdb1 grid]$ ./runcluvfy.sh stage -pre crsinst -n pdb1,pdb2 -fixup -verbose (If Required)

-- Step 66 -->> On Node 1
-- To Create a Response File to Install GID
[grid@tpdb1 ~]$ cp /opt/app/19c/grid/install/response/gridsetup.rsp /home/grid/
[grid@tpdb1 ~]$ cd /home/grid/
[grid@tpdb1 ~]$ ls -ltr | grep gridsetup.rsp
/*
-rwxr-xr-x 1 grid oinstall 36221 Jun 23 15:11 gridsetup.rsp
*/

-- Step 66.1 -->> On Node 1
[root@tpdb1 grid]# vi gridsetup.rsp
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
oracle.install.crs.config.gpnp.scanName=tpdb-scan
oracle.install.crs.config.gpnp.scanPort=1521
oracle.install.crs.config.ClusterConfiguration=STANDALONE
oracle.install.crs.config.configureAsExtendedCluster=false
oracle.install.crs.config.clusterName=tpdb-cluster
oracle.install.crs.config.gpnp.configureGNS=false
oracle.install.crs.config.autoConfigureClusterNodeVIP=false
oracle.install.crs.config.clusterNodes=tpdb1:tpdb1-vip
oracle.install.crs.config.networkInterfaceList=eno1:10.0.129.0:1,eno2:10.10.10.0:5
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

-- Step 67 -->> On Node 1
[grid@tpdb1 ~]$ cd /opt/app/19c/grid/
[grid@tpdb1 grid]$ OPatch/opatch version
/*
OPatch Version: 12.2.0.1.42

OPatch succeeded.
*/

-- Step 68 -->> On Node 1
-- To Install Grid Software with Leteset Opatch
[grid@tpdb1 ~]$ cd /opt/app/19c/grid/
[grid@tpdb1 grid]$ export CV_ASSUME_DISTID=OEL7.8
[grid@tpdb1 grid]$ ./gridSetup.sh -ignorePrereq -waitForCompletion -silent -applyRU /tmp/36031453/35940989 -responseFile /home/grid/gridsetup.rsp
/*
Preparing the home to patch...
Applying the patch /tmp/36031453/35940989...
Successfully applied the patch.
The log can be found at: /tmp/GridSetupActions2024-06-23_03-37-43PM/installerPatchActions_2024-06-23_03-37-43PM.log
Launching Oracle Grid Infrastructure Setup Wizard...

[WARNING] [INS-13014] Target environment does not meet some optional requirements.
   CAUSE: Some of the optional prerequisites are not met. See logs for details. gridSetupActions2024-06-23_03-37-43PM.log
   ACTION: Identify the list of failed prerequisite checks from the log: gridSetupActions2024-06-23_03-37-43PM.log. Then either from the log file or from installation manual find the appropriate configuration to meet the prerequisites and fix it manually.
The response file for this session can be found at:
 /opt/app/19c/grid/install/response/grid_2024-06-23_03-37-43PM.rsp

You can find the log of this install session at:
 /tmp/GridSetupActions2024-06-23_03-37-43PM/gridSetupActions2024-06-23_03-37-43PM.log

As a root user, execute the following script(s):
        1. /opt/app/oraInventory/orainstRoot.sh
        2. /opt/app/19c/grid/root.sh

Execute /opt/app/oraInventory/orainstRoot.sh on the following nodes:
[tpdb1]
Execute /opt/app/19c/grid/root.sh on the following nodes:
[tpdb1]



Successfully Setup Software with warning(s).
As install user, execute the following command to complete the configuration.
        /opt/app/19c/grid/gridSetup.sh -executeConfigTools -responseFile /home/grid/gridsetup.rsp [-silent]


Moved the install session logs to:
 /opt/app/oraInventory/logs/GridSetupActions2024-06-23_03-37-43PM
*/

-- Step 69 -->> On Node 1
--[root@tpdb1 ~]# export CV_ASSUME_DISTID=OEL7.8
[root@tpdb1 ~]# /opt/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

/*  -- On Physical Server (If we use AMSLib-8)
https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=364500837732007&id=2789052.1&_adf.ctrl-state=11vbxw8jk2_58

--OL8/RHEL8: ASMLib: root.sh is failing with CRS-1705: Found 0 Configured Voting Files But 1 Voting Files Are Required (Doc ID 2789052.1)
Bug 32410237 - oracleasm configure -p not discovering disks on RHEL8
Bug 32812376 - ROOT.SH IS FAILING WTH THE ERRORS CLSRSC-119: START OF THE EXCLUSIVE MODE CLUSTER FAILED
*/

-- Step-Issue 1 -->> On Node 1
--[root@tpdb1 ~]# export CV_ASSUME_DISTID=OEL7.8
--[root@tpdb1 ~]# /opt/app/19c/grid/root.sh
--/*
--Check /opt/app/19c/grid/install/root_tpdb1.unidev.org.np_2024-06-13_11-27-51-316012179.log for the output of root script
--*/

-- Step-Issue 1.1 -->> On Node 1
--[root@tpdb1 ~]# tail -f /opt/app/19c/grid/install/root_tpdb1.unidev.org.np_2024-06-13_11-27-51-316012179.log
--/*
--Creating /etc/oratab file...
--Entries will be added to the /etc/oratab file as needed by
--Database Configuration Assistant when a database is created
--Finished running generic part of root script.
--Now product-specific root actions will be performed.
--Relinking oracle with rac_on option
--Using configuration parameter file: /opt/app/19c/grid/crs/install/crsconfig_params
--The log of current session can be found at:
--  /opt/app/oracle/crsdata/tpdb1/crsconfig/rootcrs_tpdb1_2024-06-20_03-02-43PM.log
--2024/06/20 15:02:48 CLSRSC-594: Executing installation step 1 of 19: 'ValidateEnv'.
--2024/06/20 15:02:48 CLSRSC-363: User ignored prerequisites during installation
--2024/06/20 15:02:49 CLSRSC-594: Executing installation step 2 of 19: 'CheckFirstNode'.
--2024/06/20 15:02:51 CLSRSC-594: Executing installation step 3 of 19: 'GenSiteGUIDs'.
--2024/06/20 15:02:52 CLSRSC-594: Executing installation step 4 of 19: 'SetupOSD'.
--Redirecting to /bin/systemctl restart rsyslog.service
--2024/06/20 15:02:52 CLSRSC-594: Executing installation step 5 of 19: 'CheckCRSConfig'.
--2024/06/20 15:02:52 CLSRSC-594: Executing installation step 6 of 19: 'SetupLocalGPNP'.
--2024/06/20 15:03:08 CLSRSC-594: Executing installation step 7 of 19: 'CreateRootCert'.
--2024/06/20 15:03:12 CLSRSC-594: Executing installation step 8 of 19: 'ConfigOLR'.
--2024/06/20 15:03:26 CLSRSC-594: Executing installation step 9 of 19: 'ConfigCHMOS'.
--2024/06/20 15:03:26 CLSRSC-594: Executing installation step 10 of 19: 'CreateOHASD'.
--2024/06/20 15:03:31 CLSRSC-594: Executing installation step 11 of 19: 'ConfigOHASD'.
--2024/06/20 15:03:31 CLSRSC-330: Adding Clusterware entries to file 'oracle-ohasd.service'
--2024/06/20 15:03:55 CLSRSC-594: Executing installation step 12 of 19: 'SetupTFA'.
--2024/06/20 15:03:55 CLSRSC-594: Executing installation step 13 of 19: 'InstallAFD'.
--2024/06/20 15:03:55 CLSRSC-594: Executing installation step 14 of 19: 'InstallACFS'.
--2024/06/20 15:04:01 CLSRSC-594: Executing installation step 15 of 19: 'InstallKA'.
--2024/06/20 15:04:05 CLSRSC-594: Executing installation step 16 of 19: 'InitConfig'.
--CRS-2672: Attempting to start 'ora.evmd' on 'tpdb1'
--CRS-2672: Attempting to start 'ora.mdnsd' on 'tpdb1'
--CRS-2676: Start of 'ora.mdnsd' on 'tpdb1' succeeded
--CRS-2676: Start of 'ora.evmd' on 'tpdb1' succeeded
--CRS-2672: Attempting to start 'ora.gpnpd' on 'tpdb1'
--CRS-2676: Start of 'ora.gpnpd' on 'tpdb1' succeeded
--CRS-2672: Attempting to start 'ora.cssdmonitor' on 'tpdb1'
--CRS-2672: Attempting to start 'ora.gipcd' on 'tpdb1'
--CRS-2676: Start of 'ora.cssdmonitor' on 'tpdb1' succeeded
--CRS-2676: Start of 'ora.gipcd' on 'tpdb1' succeeded
--CRS-2672: Attempting to start 'ora.cssd' on 'tpdb1'
--CRS-2672: Attempting to start 'ora.diskmon' on 'tpdb1'
--CRS-2676: Start of 'ora.diskmon' on 'tpdb1' succeeded
--CRS-1705: Found 0 configured voting files but 1 voting files are required, terminating to ensure data integrity; details at (:CSSNM00065:) in /opt/app/oracle/diag/crs/tpdb1/crs/trace/ocssd.trc
--CRS-2674: Start of 'ora.cssd' on 'tpdb1' failed
--CRS-2679: Attempting to clean 'ora.cssd' on 'tpdb1'
--CRS-2681: Clean of 'ora.cssd' on 'tpdb1' succeeded
--CRS-2673: Attempting to stop 'ora.gipcd' on 'tpdb1'
--CRS-2677: Stop of 'ora.gipcd' on 'tpdb1' succeeded
--CRS-2673: Attempting to stop 'ora.gpnpd' on 'tpdb1'
--CRS-2677: Stop of 'ora.gpnpd' on 'tpdb1' succeeded
--CRS-2673: Attempting to stop 'ora.mdnsd' on 'tpdb1'
--CRS-2677: Stop of 'ora.mdnsd' on 'tpdb1' succeeded
--CRS-2673: Attempting to stop 'ora.evmd' on 'tpdb1'
--CRS-2677: Stop of 'ora.evmd' on 'tpdb1' succeeded
--CRS-4000: Command Start failed, or completed with errors.
--2024/06/20 15:16:24 CLSRSC-119: Start of the exclusive mode cluster failed
--Died at /opt/app/19c/grid/crs/install/crsinstall.pm line 2579.
--2024/06/20 15:19:27 CLSRSC-4002: Successfully installed Oracle Trace File Analyzer (TFA) Collector.
--*/

-- Step-Fix 2 -->> On Node 1
--[root@tpdb1 ~]# oracleasm exit
--/*
--Unmounting ASMlib driver filesystem: failed
--Unable to unmount ASMlib driver filesystem
--*/

-- Step-Fix 2.1 -->> On Node 1
--[root@tpdb1 ~]# lsmod | grep -i oracle
--[root@tpdb1 ~]# rpm -qa | grep oracleasm
--/*
--oracleasm-support-2.1.12-1.el8.x86_64
--oracleasmlib-2.0.17-1.el8.x86_64
--*/

-- Step-Fix 2.2 -->> On Node 1
--[root@tpdb1 ~]# rpm -e oracleasm-support-2.1.12-1.el8.x86_64
--/*
--warning: /etc/sysconfig/oracleasm saved as /etc/sysconfig/oracleasm.rpmsave
--*/

-- Step-Fix 2.3 -->> On Node 1
--[root@tpdb1 ~]# rpm -e oracleasmlib-2.0.17-1.el8.x86_64

-- Step-Fix 2.4 -->> On Node 1
--[root@tpdb1 ~]# cd /tmp/
--[root@tpdb1 tmp]# wget https://download.oracle.com/otn_software/asmlib/oracleasmlib-2.0.12-1.el7.x86_64.rpm
--[root@tpdb1 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/oracleasm-support-2.1.11-2.el7.x86_64.rpm

-- Step-Fix 2.5 -->> On Node 1
--[root@tpdb1 tmp]# yum -y localinstall ./oracleasm-support-2.1.11-2.el7.x86_64.rpm ./oracleasmlib-2.0.12-1.el7.x86_64.rpm

-- Step-Fix 2.6 -->> On Node 1
--[root@tpdb1 ~]# lsmod | grep -i oracle
--[root@tpdb1 ~]# rpm -qa | grep -i oracleasm
--/*
--oracleasmlib-2.0.12-1.el7.x86_64
--oracleasm-support-2.1.11-2.el7.x86_64
--*/

-- Step-Fix 2.7 -->> On Node 1
--[root@tpdb1 ~]# oracleasm init
--[root@tpdb1 ~]# oracleasm status
--/*
--Checking if ASM is loaded: yes
--Checking if /dev/oracleasm is mounted: yes
--*/

-- Step-Fix 2.8 -->> On Node 1
--[root@tpdb1 ~]# lsmod | grep oracle
--/*
--oracleasm              65536  1
--*/

-- Step-Fix 2.9 -->> On Node 1
--[root@tpdb1 ~]# oracleasm configure -i
--/*
--Configuring the Oracle ASM library driver.
--This will configure the on-boot properties of the Oracle ASM library
--driver.  The following questions will determine whether the driver is
--loaded on boot and what permissions it will have.  The current values
--will be shown in brackets ('[]').  Hitting <ENTER> without typing an
--answer will keep that current value.  Ctrl-C will abort.
--Default user to own the driver interface []: grid
--Default group to own the driver interface []: asmadmin
--Start Oracle ASM library driver on boot (y/n) [n]: y
--Scan for Oracle ASM disks on boot (y/n) [y]: y
--Writing Oracle ASM library driver configuration: done
--*/

-- Step-Fix 2.10 -->> On Node 1
--[root@tpdb1 ~]# oracleasm configure -e
--/*
--Writing Oracle ASM library driver configuration: done
--*/

-- Step-Fix 2.11 -->> On Node 1
--[root@tpdb1 ~]# systemctl status oracleam
--/*
--Unit oracleam.service could not be found.
--*/

-- Step-Fix 2.12 -->> On Node 1
--[root@tpdb1 ~]#  systemctl start oracleasm
--[root@tpdb1 ~]#  systemctl status oracleasm
--/*
--● oracleasm.service - Load oracleasm Modules
--   Loaded: loaded (/usr/lib/systemd/system/oracleasm.service; enabled; vendor preset: disabled)
--   Active: active (exited) since Thu 2024-06-20 13:45:18 +0545; 2h 47min ago
-- Main PID: 1328 (code=exited, status=0/SUCCESS)
--    Tasks: 0 (limit: 202580)
--   Memory: 0B
--   CGroup: /system.slice/oracleasm.service
--
--Jun 20 13:45:17 tpdb1.unidev.org.np systemd[1]: Starting Load oracleasm Modules...
--Jun 20 13:45:17 tpdb1.unidev.org.np oracleasm.init[1328]: Initializing the Oracle ASMLib driver: OK
--Jun 20 13:45:18 tpdb1.unidev.org.np oracleasm.init[1328]: Scanning the system for Oracle ASMLib disks: OK
--Jun 20 13:45:18 tpdb1.unidev.org.np systemd[1]: Started Load oracleasm Modules.
--*/

-- Step-Fix 2.13 -->> On Node 1
--[root@tpdb1 ~]# oracleasm scandisks
--/*
--Reloading disk partitions: done
--Cleaning any stale ASM disks...
--Scanning system for ASM disks...
--Instantiating disk "DATA"
--Instantiating disk "ARC"
--Instantiating disk "OCR"
--*/

-- Step-Fix 2.14 -->> On Node 1
--[root@tpdb1 ~]# oracleasm listdisks
--/*
--ARC
--DATA
--OCR
--*/

-- Step 70 -->> On Node 1
--[root@tpdb1 ~]# export CV_ASSUME_DISTID=OEL7.8
[root@tpdb1 ~]# /opt/app/19c/grid/root.sh
/*
Check /opt/app/19c/grid/install/root_tpdb1.unidev.org.np_2024-06-23_15-50-12-521149739.log for the output of root script
*/

-- Step 70.1 -->> On Node 1 
[root@tpdb1 ~]# tail -f /opt/app/19c/grid/install/root_tpdb1.unidev.org.np_2024-06-23_15-50-12-521149739.log
/*
   Copying coraenv to /usr/local/bin ...

Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Relinking oracle with rac_on option
Using configuration parameter file: /opt/app/19c/grid/crs/install/crsconfig_params
The log of current session can be found at:
  /opt/app/oracle/crsdata/tpdb1/crsconfig/rootcrs_tpdb1_2024-06-23_03-50-30PM.log
2024/06/23 15:50:35 CLSRSC-594: Executing installation step 1 of 19: 'ValidateEnv'.
2024/06/23 15:50:35 CLSRSC-363: User ignored prerequisites during installation
2024/06/23 15:50:36 CLSRSC-594: Executing installation step 2 of 19: 'CheckFirstNode'.
2024/06/23 15:50:38 CLSRSC-594: Executing installation step 3 of 19: 'GenSiteGUIDs'.
2024/06/23 15:50:39 CLSRSC-594: Executing installation step 4 of 19: 'SetupOSD'.
Redirecting to /bin/systemctl restart rsyslog.service
2024/06/23 15:50:39 CLSRSC-594: Executing installation step 5 of 19: 'CheckCRSConfig'.
2024/06/23 15:50:39 CLSRSC-594: Executing installation step 6 of 19: 'SetupLocalGPNP'.
2024/06/23 15:50:54 CLSRSC-594: Executing installation step 7 of 19: 'CreateRootCert'.
2024/06/23 15:50:59 CLSRSC-594: Executing installation step 8 of 19: 'ConfigOLR'.
2024/06/23 15:51:13 CLSRSC-594: Executing installation step 9 of 19: 'ConfigCHMOS'.
2024/06/23 15:51:13 CLSRSC-594: Executing installation step 10 of 19: 'CreateOHASD'.
2024/06/23 15:51:18 CLSRSC-594: Executing installation step 11 of 19: 'ConfigOHASD'.
2024/06/23 15:51:18 CLSRSC-330: Adding Clusterware entries to file 'oracle-ohasd.service'
2024/06/23 15:51:42 CLSRSC-594: Executing installation step 12 of 19: 'SetupTFA'.
2024/06/23 15:51:42 CLSRSC-594: Executing installation step 13 of 19: 'InstallAFD'.
2024/06/23 15:51:42 CLSRSC-594: Executing installation step 14 of 19: 'InstallACFS'.
2024/06/23 15:51:47 CLSRSC-594: Executing installation step 15 of 19: 'InstallKA'.
2024/06/23 15:51:52 CLSRSC-594: Executing installation step 16 of 19: 'InitConfig'.

ASM has been created and started successfully.

[DBT-30001] Disk groups created successfully. Check /opt/app/oracle/cfgtoollogs/asmca/asmca-240623PM035222.log for details.

2024/06/23 15:53:01 CLSRSC-482: Running command: '/opt/app/19c/grid/bin/ocrconfig -upgrade grid oinstall'
CRS-4256: Updating the profile
Successful addition of voting disk ddfe297643574fcfbf9d2889a5a88a6f.
Successfully replaced voting disk group with +OCR.
CRS-4256: Updating the profile
CRS-4266: Voting file(s) successfully replaced
##  STATE    File Universal Id                File Name Disk group
--  -----    -----------------                --------- ---------
 1. ONLINE   ddfe297643574fcfbf9d2889a5a88a6f (/dev/oracleasm/disks/OCR) [OCR]
Located 1 voting disk(s).
2024/06/23 15:53:49 CLSRSC-594: Executing installation step 17 of 19: 'StartCluster'.
2024/06/23 15:54:55 CLSRSC-343: Successfully started Oracle Clusterware stack
2024/06/23 15:54:55 CLSRSC-594: Executing installation step 18 of 19: 'ConfigNode'.
2024/06/23 15:55:48 CLSRSC-4002: Successfully installed Oracle Trace File Analyzer (TFA) Collector.
2024/06/23 15:56:04 CLSRSC-594: Executing installation step 19 of 19: 'PostConfig'.
2024/06/23 15:56:26 CLSRSC-325: Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 71 -->> On Node 1
[grid@tpdb1 ~]$ cd /opt/app/19c/grid/
[grid@tpdb1 grid]$ export CV_ASSUME_DISTID=OEL7.8
[grid@tpdb1 grid]$ /opt/app/19c/grid/gridSetup.sh -silent -executeConfigTools -responseFile /home/grid/gridsetup.rsp
/*
Launching Oracle Grid Infrastructure Setup Wizard...

You can find the logs of this session at:
/opt/app/oraInventory/logs/GridSetupActions2024-06-23_03-57-58PM

You can find the log of this install session at:
 /opt/app/oraInventory/logs/UpdateNodeList2024-06-23_03-57-58PM.log
Successfully Configured Software.
*/

-- Step 71.1 -->> On Node 1
[root@tpdb1 ~]#  tail -f /opt/app/oraInventory/logs/UpdateNodeList2024-06-23_03-57-58PM.log
/*
INFO: Checkpoint:Index file written and updated
INFO: Done calling doOperation.
INFO: 'UpdateNodeList' was successful.
*/

-- Step 72 -->> On Node 1
[root@tpdb1 ~]# cd /opt/app/19c/grid/bin/
[root@tpdb1 bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/


-- Step 73 -->> On Node 1
[root@tpdb1 ~]# cd /opt/app/19c/grid/bin/
[root@tpdb1 bin]# ./crsctl check cluster -all
/*
**************************************************************
tpdb1:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/

-- Step 74 -->> On Node 1
[root@tpdb1 ~]# cd /opt/app/19c/grid/bin/
[root@tpdb1 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       tpdb1                    Started,STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.crf
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.crsd
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.cssd
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.ctssd
      1        ONLINE  ONLINE       tpdb1                    OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.evmd
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.gipcd
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.gpnpd
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.mdnsd
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.storage
      1        ONLINE  ONLINE       tpdb1                    STABLE
--------------------------------------------------------------------------------
*/


-- Step 75 -->> On Node 1
[root@tpdb1 ~]# cd /opt/app/19c/grid/bin/
[root@tpdb1 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       tpdb1                    STABLE
ora.chad
               ONLINE  ONLINE       tpdb1                    STABLE
ora.net1.network
               ONLINE  ONLINE       tpdb1                    STABLE
ora.ons
               ONLINE  ONLINE       tpdb1                    STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       tpdb1                    Started,STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.cvu
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.qosmserver
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.tpdb1.vip
      1        ONLINE  ONLINE       tpdb1                    STABLE
--------------------------------------------------------------------------------
*/


-- Step 76 -->> On Node 1
[grid@tpdb1 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  4194304     20480    20184                0           20184              0             Y  OCR/
ASMCMD [+] > exit
*/

-- Step 77 -->> On Node 1
[grid@tpdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 23-JUN-2024 16:01:06

Copyright (c) 1991, 2023, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-JUN-2024 15:56:20
Uptime                    0 days 0 hr. 4 min. 46 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/tpdb1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=10.0.129.208)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=10.0.129.209)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 77.1 -->> On Node 1
[grid@tpdb1 ~]$ ps -ef | grep SCAN
/*
grid       87596       1  0 15:55 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid       87609       1  0 15:55 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid      122665  119904  0 16:01 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 77.2 -->> On Node 1
[grid@tpdb1 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 23-JUN-2024 16:01:36

Copyright (c) 1991, 2023, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-JUN-2024 15:55:49
Uptime                    0 days 0 hr. 5 min. 47 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/tpdb1/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=10.0.129.210)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 77.3 -->> On Node 1
[grid@tpdb1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 23-JUN-2024 16:01:50

Copyright (c) 1991, 2023, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-JUN-2024 15:55:51
Uptime                    0 days 0 hr. 5 min. 58 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/tpdb1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=10.0.129.211)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 78 -->> On Node 1
-- To Create ASM storage for Data and Archive 
[grid@tpdb1 ~]$ cd /opt/app/19c/grid/bin
[grid@tpdb1 bin]$ export CV_ASSUME_DISTID=OEL7.8

-- Step 78.1 -->> On Node 1
[grid@tpdb1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName DATA -diskList /dev/oracleasm/disks/DATA -redundancy EXTERNAL

-- Step 78.2 -->> On Node 1
[grid@tpdb1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName ARC -diskList /dev/oracleasm/disks/ARC -redundancy EXTERNAL

-- Step 79 -->> On Node 1
[grid@tpdb1 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Jun 23 16:03:04 2024
Version 19.22.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.22.0.0.0

SQL> set lines 200;
SQL> COLUMN name FORMAT A30
SQL> SELECT inst_id,name,state,type,compatibility,database_compatibility,voting_files FROM gv$asm_diskgroup order by name;

   INST_ID NAME   STATE       TYPE   COMPATIBILITY DATABASE_COMPATIBILITY V
---------- ------ ----------- ------ ------------- ---------------------- -
         1 ARC    MOUNTED     EXTERN 19.0.0.0.0    10.1.0.0.0             N
         1 DATA   MOUNTED     EXTERN 19.0.0.0.0    10.1.0.0.0             N
         1 OCR    MOUNTED     EXTERN 19.0.0.0.0    10.1.0.0.0             Y

SQL> set lines 200;
SQL> col path format a40;
SQL> SELECT name,path, group_number group_#, disk_number disk_#, mount_status,header_status, state, total_mb, free_mb FROM v$asm_disk order by group_number;

NAME      PATH                       GROUP_#     DISK_# MOUNT_S HEADER_STATU STATE      TOTAL_MB    FREE_MB
--------- ------------------------- -------- ---------- ------- ------------ -------- ---------- ----------
OCR_0000  /dev/oracleasm/disks/OCR         1          0 CACHED  MEMBER       NORMAL        20480      20184
DATA_0000 /dev/oracleasm/disks/DATA        2          0 CACHED  MEMBER       NORMAL       204800     204734
ARC_0000  /dev/oracleasm/disks/ARC         3          0 CACHED  MEMBER       NORMAL       409600     409530

SQL> set lines 200;
SQL> col BANNER_FULL format a80;
SQL> col BANNER_LEGACY format a80;
SQL> SELECT inst_id,banner_full,banner_legacy,con_id FROM gv$version;

   INST_ID BANNER_FULL                                                                      BANNER_LEGACY                                                                        CON_ID
---------- -------------------------------------------------------------------------------- -------------------------------------------------------------------------------- ----------
         1 Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production           Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production                    0
           Version 19.22.0.0.0

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.22.0.0.0
*/

-- Step 80 -->> On Node 1
[root@tpdb1 ~]# cd /opt/app/19c/grid/bin
[root@tpdb1 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       tpdb1                    STABLE
ora.chad
               ONLINE  ONLINE       tpdb1                    STABLE
ora.net1.network
               ONLINE  ONLINE       tpdb1                    STABLE
ora.ons
               ONLINE  ONLINE       tpdb1                    STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ARC.dg(ora.asmgroup)
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.DATA.dg(ora.asmgroup)
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       tpdb1                    Started,STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.cvu
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.qosmserver
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.tpdb1.vip
      1        ONLINE  ONLINE       tpdb1                    STABLE
--------------------------------------------------------------------------------
*/

-- Step 81 -->> On Node 1
[grid@tpdb1 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  1048576    409600   409530                0          409530              0             N  ARC/
MOUNTED  EXTERN  N         512             512   4096  1048576    204800   204734                0          204734              0             N  DATA/
MOUNTED  EXTERN  N         512             512   4096  4194304     20480    20184                0           20184              0             Y  OCR/
ASMCMD [+] > exit
*/

-- Step 82 -->> On Node 1
[root@tpdb1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/19c/grid:N
*/

-- Step 83 -->> On Node 1
-- Creating the Oracle RDBMS Home Directory
[root@tpdb1 ~]# mkdir -p /opt/app/oracle/product/19c/db_1
[root@tpdb1 ~]# chown -R oracle:oinstall /opt/app/oracle/product/19c/db_1
[root@tpdb1 ~]# chmod -R 775 /opt/app/oracle/product/19c/db_1

-- Step 83.1 -->> On Node 1
-- To unzip the Oracle Binary and Letest Opatch
[root@tpdb1 ~]# cd /opt/app/oracle/product/19c/db_1
[root@tpdb1 db_1]# unzip -oq /root/Oracle_19C/19.3.0.0.0_DB_Binary/LINUX.X64_193000_db_home.zip
[root@tpdb1 db_1]# unzip -oq /root/Oracle_19C/OPATCH_19c/p6880880_190000_Linux-x86-64.zip

-- Step 83.2 -->> On Node 1
[root@tpdb1 ~]# chown -R oracle:oinstall /opt/app/oracle/product/19c/db_1/
[root@tpdb1 ~]# chmod -R 775 /opt/app/oracle/product/19c/db_1/

-- Step 84 -->> On Node 1
[root@tpdb1 ~]# su - oracle
[oracle@tpdb1 ~]$ /opt/app/oracle/product/19c/db_1/OPatch/opatch version
/*
OPatch Version: 12.2.0.1.42

OPatch succeeded.
*/

-- Step 85 -->> On Node 1
-- To Setup the SSH Connectivity 
[root@tpdb1 ~]# su - oracle
[oracle@tpdb1 ~]$ cd /opt/app/oracle/product/19c/db_1/deinstall/
[oracle@tpdb1 deinstall]$ ./sshUserSetup.sh -user oracle -hosts "tpdb1" -noPromptPassphrase -confirm -advanced
/*
Password: oracle
*/

-- Step 86 -->> On Node 1
[oracle@tpdb1 ~]$ ssh oracle@tpdb1 date
[oracle@tpdb1 ~]$ ssh oracle@tpdb1.unidev.org.np date
[oracle@tpdb1 ~]$ ssh oracle@tpdb1 date && ssh oracle@tpdb1.unidev.org.np date

-- Step 87 -->> On Node 1
-- To Create a responce file for Oracle Software Installation
[oracle@tpdb1 ~]$ cp /opt/app/oracle/product/19c/db_1/install/response/db_install.rsp /home/oracle/
[oracle@tpdb1 ~]$ cd /home/oracle/

-- Step 87.1 -->> On Node 1
[oracle@tpdb1 ~]$ ls -ltr
/*
-rwxr-xr-x 1 oracle oinstall 19932 Jun 23 16:09 db_install.rsp
*/

-- Step 87.2 -->> On Node 1
[oracle@tpdb1 ~]$ vi db_install.rsp
/*
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v19.0.0
oracle.install.option=INSTALL_DB_SWONLY
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/opt/app/oraInventory
ORACLE_HOME=/opt/app/oracle/product/19c/db_1
ORACLE_BASE=/opt/app/oracle
oracle.install.db.InstallEdition=EE
ORACLE_HOSTNAME=tpdb1.unidev.org.np
SELECTED_LANGUAGES=en
oracle.install.db.OSDBA_GROUP=dba
oracle.install.db.OSOPER_GROUP=oper
oracle.install.db.OSBACKUPDBA_GROUP=backupdba
oracle.install.db.OSDGDBA_GROUP=dgdba
oracle.install.db.OSKMDBA_GROUP=kmdba
oracle.install.db.OSRACDBA_GROUP=racdba
oracle.install.db.rootconfig.executeRootScript=false
oracle.install.db.CLUSTER_NODES=tpdb1
oracle.install.db.config.starterdb.type=GENERAL_PURPOSE
oracle.install.db.ConfigureAsContainerDB=false
*/

-- Step 88 -->> On Node 1
-- To install Oracle Software with Letest Opatch
[oracle@tpdb1 ~]$ cd /opt/app/oracle/product/19c/db_1/
[oracle@tpdb1 db_1]$ export CV_ASSUME_DISTID=OEL7.8
[oracle@tpdb1 db_1]$ ./runInstaller -ignorePrereq -waitforcompletion -silent \
-applyRU /tmp/36031453/35940989                                             \
-responseFile /home/oracle/db_install.rsp                                   \
oracle.install.db.isRACOneInstall=false                                     \
oracle.install.db.rac.serverpoolCardinality=0                               \
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false                                  \
DECLINE_SECURITY_UPDATES=true

/*
Preparing the home to patch...
Applying the patch /tmp/36031453/35940989...
Successfully applied the patch.
The log can be found at: /opt/app/oraInventory/logs/InstallActions2024-06-23_04-12-59PM/installerPatchActions_2024-06-23_04-12-59PM.log
Launching Oracle Database Setup Wizard...

[WARNING] [INS-13014] Target environment does not meet some optional requirements.
   CAUSE: Some of the optional prerequisites are not met. See logs for details. /opt/app/oraInventory/logs/InstallActions2024-06-23_04-12-59PM/installActions2024-06-23_04-12-59PM.log
   ACTION: Identify the list of failed prerequisite checks from the log: /opt/app/oraInventory/logs/InstallActions2024-06-23_04-12-59PM/installActions2024-06-23_04-12-59PM.log. Then either from the log file or from installation manual find the appropriate configuration to meet the prerequisites and fix it manually.
The response file for this session can be found at:
 /opt/app/oracle/product/19c/db_1/install/response/db_2024-06-23_04-12-59PM.rsp

You can find the log of this install session at:
 /opt/app/oraInventory/logs/InstallActions2024-06-23_04-12-59PM/installActions2024-06-23_04-12-59PM.log

As a root user, execute the following script(s):
        1. /opt/app/oracle/product/19c/db_1/root.sh

Execute /opt/app/oracle/product/19c/db_1/root.sh on the following nodes:
[tpdb1]


Successfully Setup Software with warning(s).
*/

-- Step 89 -->> On Node 1
[root@tpdb1 ~]# /opt/app/oracle/product/19c/db_1/root.sh
/*
Check /opt/app/oracle/product/19c/db_1/install/root_tpdb1.unidev.org.np_2024-06-23_16-26-49-222989788.log for the output of root script
*/

-- Step 89.1 -->> On Node 1
[root@tpdb1 ~]# tail -f /opt/app/oracle/product/19c/db_1/install/root_tpdb1.unidev.org.np_2024-06-23_16-26-49-222989788.log
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

-- Step 90 -->> On Node 1
-- To applying the Oracle PSU on Node 1
[root@tpdb1 ~]# cd /tmp/
[root@tpdb1 tmp]$ export CV_ASSUME_DISTID=OEL7.8
[root@tpdb1 tmp]# export ORACLE_HOME=/opt/app/oracle/product/19c/db_1
[root@tpdb1 tmp]# export PATH=${ORACLE_HOME}/bin:$PATH
[root@tpdb1 tmp]# export PATH=${PATH}:${ORACLE_HOME}/OPatch

-- Step 90.1 -->> On Node 1
[root@tpdb1 tmp]# which opatchauto
/*
/opt/app/oracle/product/19c/db_1/OPatch/opatchauto
*/

-- Step 90.2 -->> On Node 1
[root@tpdb1 tmp]# opatchauto apply /tmp/36031453/35926646 -oh /opt/app/oracle/product/19c/db_1 --nonrolling
/*
OPatchauto session is initiated at Sun Jun 23 16:28:20 2024

System initialization log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchautodb/systemconfig2024-06-23_04-28-23PM.log.

Session log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/opatchauto2024-06-23_04-28-29PM.log
The id for this session is INN7

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

Host:tpdb1
RAC Home:/opt/app/oracle/product/19c/db_1
Version:19.0.0.0.0
Summary:

==Following patches were SUCCESSFULLY applied:

Patch: /tmp/36031453/35926646
Log: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2024-06-23_16-29-23PM_1.log

OPatchauto session completed at Sun Jun 23 16:31:12 2024
Time taken to complete the session 2 minutes, 52 seconds
*/

-- Step 90.3 -->> On Node 1
[root@tpdb1 ~]# tail -f /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2024-06-23_16-29-23PM_1.log
/*
[Jun 23, 2024 4:31:10 PM] [INFO]    Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/NApply/2024-06-23_16-29-23PM/restore.sh"
[Jun 23, 2024 4:31:10 PM] [INFO]    Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/NApply/2024-06-23_16-29-23PM/make.txt"
[Jun 23, 2024 4:31:10 PM] [INFO]    Deleted the file "/opt/app/oracle/product/19c/db_1/.patch_storage/35926646_Jan_3_2024_10_52_25/scratch/joxwtp.o"
[Jun 23, 2024 4:31:10 PM] [INFO]    [OPSR-TIME] Backup area for restore has been cleaned up. For a complete list of files/directories deleted, Please refer log file.
[Jun 23, 2024 4:31:10 PM] [INFO]    Patch 35926646 successfully applied.
[Jun 23, 2024 4:31:10 PM] [INFO]    UtilSession: N-Apply done.
[Jun 23, 2024 4:31:10 PM] [INFO]    Finishing UtilSession at Sun Jun 23 16:31:10 NPT 2024
[Jun 23, 2024 4:31:10 PM] [INFO]    Log file location: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2024-06-23_16-29-23PM_1.log
[Jun 23, 2024 4:31:10 PM] [INFO]    EXITING METHOD: NApply(patches,options)
*/

-- Step 94 -->> On Node 1
-- To Create a Oracle Database
[root@tpdb1 ~]# mkdir -p /opt/app/oracle/admin/pdbdb/adump
[root@tpdb1 ~]# cd /opt/app/oracle/admin/
[root@tpdb1 ~]# chown -R oracle:oinstall pdbdb/
[root@tpdb1 ~]# chmod -R 775 pdbdb/

-- Step 95 -->> On Node 1
-- To prepare the responce file
[root@tpdb1 ~]# su - oracle

-- Step 96 -->> On Node 1
[oracle@tpdb1 db_1]$ cd /opt/app/oracle/product/19c/db_1/assistants/dbca
[oracle@tpdb1 dbca]$ export CV_ASSUME_DISTID=OEL7.8
[oracle@tpdb1 dbca]$ dbca -silent -createDatabase \
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
-nodelist tpdb1                               \
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

-- Step 96.1 -->> On Node 1
[oracle@tpdb1 ~]$  tail -f /opt/app/oracle/cfgtoollogs/dbca/pdbdb/pdbdb.log
/*
[ 2024-06-23 16:33:27.986 NPT ] Prepare for db operation
DBCA_PROGRESS : 7%
[ 2024-06-23 16:33:33.649 NPT ] Copying database files
DBCA_PROGRESS : 27%
[ 2024-06-23 16:35:29.461 NPT ] Creating and starting Oracle instance
DBCA_PROGRESS : 28%
DBCA_PROGRESS : 31%
DBCA_PROGRESS : 35%
DBCA_PROGRESS : 37%
DBCA_PROGRESS : 40%
[ 2024-06-23 16:56:22.882 NPT ] Creating cluster database views
DBCA_PROGRESS : 41%
DBCA_PROGRESS : 53%
[ 2024-06-23 16:58:02.289 NPT ] Completing Database Creation
DBCA_PROGRESS : 57%
DBCA_PROGRESS : 59%
DBCA_PROGRESS : 60%
[ 2024-06-23 17:09:58.848 NPT ] Creating Pluggable Databases
DBCA_PROGRESS : 64%
DBCA_PROGRESS : 80%
[ 2024-06-23 17:10:09.914 NPT ] Executing Post Configuration Actions
DBCA_PROGRESS : 100%
[ 2024-06-23 17:10:09.916 NPT ] Database creation complete. For details check the logfiles at:
 /opt/app/oracle/cfgtoollogs/dbca/pdbdb.
Database Information:
Global Database Name:pdbdb
System Identifier(SID) Prefix:pdbdb
*/

-- Step 97 -->> On Node 1  
[oracle@tpdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Jun 23 17:11:28 2024
Version 19.22.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.22.0.0.0

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

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,gv$instance b where a.inst_id=b.inst_id;

   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 OPEN         pdbdb1           PRIMARY          READ WRITE

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.22.0.0.0
*/

-- Step 98 -->> On Node 1 
[oracle@tpdb1 ~]$ srvctl config database -d pdbdb
/*
Database unique name: pdbdb
Database name: pdbdb
Oracle home: /opt/app/oracle/product/19c/db_1
Oracle user: oracle
Spfile: +DATA/PDBDB/PARAMETERFILE/spfile.270.1172423245
Password file: +DATA/PDBDB/PASSWORD/pwdpdbdb.256.1172421215
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
Database instances: pdbdb1
Configured nodes: tpdb1
CSS critical: no
CPU count: 0
Memory target: 0
Maximum memory: 0
Default network number for database services:
Database is administrator managed
*/

-- Step 99 -->> On Node 1 
[oracle@tpdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node tpdb1. Instance status: Open.
*/

-- Step 100 -->> On Node 1 
[oracle@tpdb1 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): tpdb1
*/

-- Step 100.1 -->> On Node 1 
[oracle@tpdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 23-JUN-2024 17:13:02

Copyright (c) 1991, 2023, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-JUN-2024 15:56:20
Uptime                    0 days 1 hr. 16 min. 42 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/tpdb1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=10.0.129.208)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=10.0.129.209)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "1b8dea34278f528ee063d081000af871" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "86b637b62fdf7a65e053f706e80a27ca" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "invpdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 101 -->> On Node 1
[root@tpdb1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/19c/grid:N
pdbdb:/opt/app/oracle/product/19c/db_1:N
pdbdb1:/opt/app/oracle/product/19c/db_1:N
*/

-- Step 102 -->> On Node 1
[root@tpdb1 ~]# vi /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
/*
# tnsnames.ora Network Configuration File: /opt/app/oracle/product/19c/db_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.

PDBDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = tpdb-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = pdbdb)
    )
  )

PDBDB1 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 10.0.129.208)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = pdbdb)
    )
  )

INVPDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = tpdb-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = invpdb)
    )
  )
*/

-- Step 102.1 -->> On Node 1
[oracle@tpdb1 ~]$ tnsping pdbdb
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 23-JUN-2024 17:13:57

Copyright (c) 1997, 2023, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = tpdb-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = pdbdb)))
OK (0 msec)
*/

-- Step 102.2 -->> On Node 1
[oracle@tpdb1 ~]$ tnsping pdbdb1
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 23-JUN-2024 17:14:08

Copyright (c) 1997, 2023, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = 10.0.129.208)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = pdbdb)))
OK (0 msec)
*/

-- Step 102.3 -->> On Node 1
[oracle@tpdb1 ~]$ tnsping invpdb
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 23-JUN-2024 17:14:19

Copyright (c) 1997, 2023, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = tpdb-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = invpdb)))
OK (0 msec)
*/

-- Step 103 -->> On Node 1 (If Required)
-- To run the oracle tools (Till 11gR2 - If Required)
-- To Connect lower version tools
-- 1. Copy the contains of /etc/hosts
-- 2. Past on host file of relevant PC C:\Windows\System32\drivers\etc\hosts
[grid@tpdb1 ~]$ vi /opt/app/19c/grid/network/admin/sqlnet.ora
/*
# sqlnet.ora.tpdb1 Network Configuration File: /opt/app/19c/grid/network/admin/sqlnet.ora
# Generated by Oracle configuration tools.

NAMES.DIRECTORY_PATH= (TNSNAMES, EZCONNECT)

SQLNET.ALLOWED_LOGON_VERSION_SERVER=8
SQLNET.ALLOWED_LOGON_VERSION_CLIENT=8
*/

-- Step 103.1 -->> On Node 1
[oracle@tpdb1 ~]$ vi /opt/app/oracle/product/19c/db_1/network/admin/sqlnet.ora
/*
# sqlnet.ora.tpdb1 Network Configuration File: /opt/app/oracle/product/19c/db_1/network/admin/sqlnet.ora
# Generated by Oracle configuration tools.

NAMES.DIRECTORY_PATH= (TNSNAMES, EZCONNECT)

SQLNET.ALLOWED_LOGON_VERSION_SERVER=8
SQLNET.ALLOWED_LOGON_VERSION_CLIENT=8
*/

-- Step 103.2 -->> On Node 1
[oracle@tpdb1 ~]$ srvctl stop listener
[oracle@tpdb1 ~]$ srvctl start listener
[oracle@tpdb1 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): tpdb1
*/
-- Step 103.3 -->> On Node 1
[oracle@tpdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Jun 23 17:15:40 2024
Version 19.22.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.22.0.0.0

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
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.22.0.0.0
*/

-- Step 104 -->> On Node 1
[oracle@tpdb1 ~]$ sqlplus sys/P#ssw0rd@pdbdb as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Jun 23 17:16:13 2024
Version 19.22.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.22.0.0.0

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
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.22.0.0.0
*/

-- Step 105 -->> On Node 1
[root@tpdb1 ~]# cd /opt/app/19c/grid/bin
[root@tpdb1 ~]# ./crsctl stop cluster -all
[root@tpdb1 ~]# ./crsctl start cluster -all

-- Step 106 -->> On Node 1
[root@tpdb1 ~]# cd /opt/app/19c/grid/bin
[root@tpdb1 ~]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.crf
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.crsd
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.cssd
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.ctssd
      1        ONLINE  ONLINE       tpdb1                    OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.evmd
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.gipcd
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.gpnpd
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.mdnsd
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.storage
      1        ONLINE  ONLINE       tpdb1                    STABLE
--------------------------------------------------------------------------------
*/


-- Step 106.1 -->> On Node 1
[root@tpdb1 ~]# cd /opt/app/19c/grid/bin
[root@tpdb1 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       tpdb1                    STABLE
ora.chad
               ONLINE  ONLINE       tpdb1                    STABLE
ora.net1.network
               ONLINE  ONLINE       tpdb1                    STABLE
ora.ons
               ONLINE  ONLINE       tpdb1                    STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ARC.dg(ora.asmgroup)
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.DATA.dg(ora.asmgroup)
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       tpdb1                    Started,STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.cvu
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.pdbdb.db
      1        ONLINE  ONLINE       tpdb1                    Open,HOME=/opt/app/oracle/product/19c/db_1,STABLE
ora.qosmserver
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.tpdb1.vip
      1        ONLINE  ONLINE       tpdb1                    STABLE
--------------------------------------------------------------------------------
*/

-- Step 106.2 -->> On Node 1
[root@tpdb1 ~]# cd /opt/app/19c/grid/bin
[root@tpdb1 bin]# ./crsctl check cluster -all
/*
**************************************************************
tpdb1:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/

-- Step 107 -->> On Node 1
-- ASM Verification
[root@tpdb1 ~]# su - grid
[grid@tpdb1 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  1048576    409600   409352                0          409352              0             N  ARC/
MOUNTED  EXTERN  N         512             512   4096  1048576    204800   199003                0          199003              0             N  DATA/
MOUNTED  EXTERN  N         512             512   4096  4194304     20480    20184                0           20184              0             Y  OCR/
ASMCMD [+] > exit

*/

-- Step 108 -->> On Node 1
[grid@tpdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 23-JUN-2024 17:21:30

Copyright (c) 1991, 2023, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-JUN-2024 17:18:44
Uptime                    0 days 0 hr. 2 min. 45 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/tpdb1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=10.0.129.208)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=10.0.129.209)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "1b8dea34278f528ee063d081000af871" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "86b637b62fdf7a65e053f706e80a27ca" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "invpdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/


-- Step 108.1 -->> On Node 1
[grid@tpdb1 ~]$ ps -ef | grep SCAN
/*
grid      224160       1  0 17:18 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid      224165       1  0 17:18 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid      239149  237219  0 17:22 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 108.2 -->> On Node 1
[grid@tpdb1 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 23-JUN-2024 17:22:19

Copyright (c) 1991, 2023, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-JUN-2024 17:18:45
Uptime                    0 days 0 hr. 3 min. 33 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/tpdb1/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=10.0.129.210)(PORT=1521)))
Services Summary...
Service "1b8dea34278f528ee063d081000af871" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "86b637b62fdf7a65e053f706e80a27ca" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "invpdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 108.3 -->> On Node 1
[grid@tpdb1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 23-JUN-2024 17:22:33

Copyright (c) 1991, 2023, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-JUN-2024 17:18:45
Uptime                    0 days 0 hr. 3 min. 47 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/tpdb1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=10.0.129.211)(PORT=1521)))
Services Summary...
Service "1b8dea34278f528ee063d081000af871" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "86b637b62fdf7a65e053f706e80a27ca" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "invpdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 109 -->> On Node 1
[grid@tpdb1 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun Jun 23 17:22:47 2024
Version 19.22.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.22.0.0.0

SQL> set lines 200;
SQL> col BANNER_FULL format a80;
SQL> col BANNER_LEGACY format a80;
SQL> SELECT inst_id,banner_full,banner_legacy,con_id FROM gv$version;

   INST_ID BANNER_FULL                                                                      BANNER_LEGACY                                                                        CON_ID
---------- -------------------------------------------------------------------------------- -------------------------------------------------------------------------------- ----------
         1 Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production           Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production                    0
           Version 19.22.0.0.0

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.22.0.0.0
*/

-- Step 110 -->> On Node 1
-- DB Service Verification
[root@tpdb1 ~]# su - oracle
[oracle@tpdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node tpdb1. Instance status: Open.
*/

-- Step 111 -->> On Node 1
-- Listener Service Verification
[oracle@tpdb1 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): tpdb1
*/

-- Step 112 -->> On Node 1
[oracle@tpdb1 ~]$ rman target sys/P#ssw0rd@pdbdb
--OR--
[oracle@tpdb1 ~]$ rman target /
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Sun Jun 23 17:23:40 2024
Version 19.22.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB (DBID=3230528650)

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
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/product/19c/db_1/dbs/snapcf_pdbdb1.f'; # default

RMAN> exit

Recovery Manager complete.
*/

-- Step 113 -->> On Node 1
[oracle@tpdb1 ~]$ rman target sys/P#ssw0rd@invpdb
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Sun Jun 23 17:24:10 2024
Version 19.22.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB:INVPDB (DBID=2707477285)

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
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/opt/app/oracle/product/19c/db_1/dbs/snapcf_pdbdb1.f'; # default

RMAN> exit

Recovery Manager complete.
*/
-- Step 114 -->> On Node 1
-- To connnect CDB$ROOT using TNS
[oracle@tpdb1 ~]$ sqlplus sys/P#ssw0rd@pdbdb as sysdba

-- Step 115 -->> On Node 1
[oracle@tpdb1 ~]$ sqlplus sys/P#ssw0rd@pdbdb1 as sysdba
