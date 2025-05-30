----------------------------------------------------------------
-------------Two Node rac Setup on VM Workstation---------------
----------------------------------------------------------------
-- Step 0 -->> 2 Node rac on VM -->> On both Node
--For OS Oracle Linux 9.5 => boot OracleLinux-R9-U5-x86_64-dvd.iso
--Using Oracle ASM Filter Driver and Fixing The kernel Version 5.14.0-503.11.1, 
--As per as Oracle Doucument 1369107.1 we have to Fix as:

-- Step 0.0 -->>  2 Node rac on VM -->> On both Node
[root@pdbdr1/pdbdr2 ~]# df -Th
/*
Filesystem                 Type      Size  Used Avail Use% Mounted on
devtmpfs                   devtmpfs  4.0M     0  4.0M   0% /dev
tmpfs                      tmpfs     9.6G     0  9.6G   0% /dev/shm
tmpfs                      tmpfs     3.9G  9.5M  3.9G   1% /run
/dev/mapper/ol_pdbdr1-root xfs        70G  576M   70G   1% /
/dev/mapper/ol_pdbdr1-usr  xfs        15G  7.0G  8.0G  47% /usr
/dev/sda1                  xfs       2.0G  588M  1.4G  30% /boot
/dev/mapper/ol_pdbdr1-tmp  xfs        15G  140M   15G   1% /tmp
/dev/mapper/ol_pdbdr1-var  xfs        15G  1.5G   14G  10% /var
/dev/mapper/ol_pdbdr1-opt  xfs        70G  939M   70G   2% /opt
/dev/mapper/ol_pdbdr1-home xfs        15G  140M   15G   1% /home
tmpfs                      tmpfs     2.0G   92K  2.0G   1% /run/user/0
/dev/sr0                   iso9660    12G   12G     0 100% /run/media/root/OL-9-5-0-BaseOS-x86_64
*/

-- Step 1 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.168.6.48   pdbdr1.unidev.org.np        pdbdr1
192.168.6.49   pdbdr2.unidev.org.np        pdbdr2

# Private
10.10.10.48   pdbdr1-priv.unidev.org.np   pdbdr1-priv
10.10.10.49   pdbdr2-priv.unidev.org.np   pdbdr2-priv

# Virtual
192.168.6.50   pdbdr1-vip.unidev.org.np    pdbdr1-vip
192.168.6.51   pdbdr2-vip.unidev.org.np    pdbdr2-vip

# SCAN
192.168.6.52   pdbdr-scan.unidev.org.np    pdbdr-scan
192.168.6.53   pdbdr-scan.unidev.org.np    pdbdr-scan
192.168.6.54   pdbdr-scan.unidev.org.np    pdbdr-scan
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
# See also:
# https://docs.oracle.com/en/operating-systems/oracle-linux/selinux/selinux-SettingSELinuxModes.html
#
# NOTE: In earlier Oracle Linux kernel builds, SELINUX=disabled would also
# fully disable SELinux during boot. If you need a system with SELinux
# fully disabled instead of SELinux running with no policy loaded, you
# need to pass selinux=0 to the kernel command line. You can use grubby
# to persistently set the bootloader to boot with selinux=0:
#
#    grubby --update-kernel ALL --args selinux=0
#
# To revert back to SELinux enabled:
#
#    grubby --update-kernel ALL --remove-args selinux
#
#SELINUX=enforcing
SELINUX=disabled
# SELINUXTYPE= can take one of these three values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
*/

-- Step 2.1 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# grubby --update-kernel ALL --args selinux=0

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

-- Step 5 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# nmtui
--OR--
-- Step 5 -->> On Node 1
[root@pdbdr1 ~]# vi /etc/NetworkManager/system-connections/ens192.nmconnection
/*
[connection]
id=ens192
uuid=b4f07a71-3043-3af9-89d1-f94dc7708a9a
type=ethernet
autoconnect-priority=-999
interface-name=ens192

[ethernet]

[ipv4]
address1=192.168.6.48/24,192.168.6.1
dns=127.0.0.1;192.168.4.11;192.168.4.12;
method=manual

[ipv6]
addr-gen-mode=eui64
method=ignore

[proxy]
*/

-- Step 6 -->> On Node 1
[root@pdbdr1 ~]# vi /etc/NetworkManager/system-connections/ens224.nmconnection
/*
[connection]
id=ens224
uuid=ae50bb0f-4151-39e7-b020-cb64a21c97a8
type=ethernet
autoconnect-priority=-999
interface-name=ens224

[ethernet]

[ipv4]
address1=10.10.10.48/24
method=manual

[ipv6]
addr-gen-mode=eui64
method=ignore

[proxy]
*/

-- Step 7 -->> On Node 2
[root@pdbdr2 ~]# vi /etc/NetworkManager/system-connections/ens192.nmconnection
/*
[connection]
id=ens192
uuid=09d38db1-4dfc-3938-bcc3-131d008b3f47
type=ethernet
autoconnect-priority=-999
interface-name=ens192

[ethernet]

[ipv4]
address1=192.168.6.49/24,192.168.6.1
dns=127.0.0.1;192.168.4.11;192.168.4.12;
method=manual

[ipv6]
addr-gen-mode=eui64
method=ignore

[proxy]
*/

-- Step 8 -->> On Node 2
[root@pdbdr2 ~]# vi /etc/NetworkManager/system-connections/ens224.nmconnection
/*
[connection]
id=ens224
uuid=4a9ff9c7-6616-3a5f-b057-d738803c2d24
type=ethernet
autoconnect-priority=-999
interface-name=ens224

[ethernet]

[ipv4]
address1=10.10.10.49/24
method=manual

[ipv6]
addr-gen-mode=eui64
method=ignore

[proxy]
*/

-- Step 9 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# systemctl restart network-online.target
[root@pdbdr1/pdbdr2 ~]# systemctl restart NetworkManager

-- Step 9.1 -->> On Node 1
[root@pdbdr1 ~]# systemctl status NetworkManager
/*
● NetworkManager.service - Network Manager
     Loaded: loaded (/usr/lib/systemd/system/NetworkManager.service; enabled; preset: enabled)
     Active: active (running) since Thu 2025-05-22 12:40:22 +0545; 21min ago
       Docs: man:NetworkManager(8)
   Main PID: 1155 (NetworkManager)
      Tasks: 3 (limit: 124664)
     Memory: 13.3M
        CPU: 274ms
     CGroup: /system.slice/NetworkManager.service
             └─1155 /usr/sbin/NetworkManager --no-daemon

May 22 12:40:22 pdbdr1.unidev.org.np NetworkManager[1155]: <info>  [1747896922.6219] device (ens192): state change: secondaries -> activated (reason 'none', managed-type: 'full')
May 22 12:40:22 pdbdr1.unidev.org.np NetworkManager[1155]: <info>  [1747896922.6235] device (ens192): Activation: successful, device activated.
May 22 12:40:22 pdbdr1.unidev.org.np NetworkManager[1155]: <info>  [1747896922.6243] manager: NetworkManager state is now CONNECTED_GLOBAL
May 22 12:40:22 pdbdr1.unidev.org.np NetworkManager[1155]: <info>  [1747896922.6251] device (ens224): state change: secondaries -> activated (reason 'none', managed-type: 'full')
May 22 12:40:22 pdbdr1.unidev.org.np NetworkManager[1155]: <info>  [1747896922.6261] device (ens224): Activation: successful, device activated.
May 22 12:40:22 pdbdr1.unidev.org.np NetworkManager[1155]: <info>  [1747896922.7302] manager: startup complete
May 22 12:40:25 pdbdr1.unidev.org.np NetworkManager[1155]: <info>  [1747896925.4271] modem-manager: ModemManager not available
May 22 12:40:25 pdbdr1.unidev.org.np NetworkManager[1155]: <info>  [1747896925.4721] modem-manager: ModemManager now available
May 22 12:40:57 pdbdr1.unidev.org.np NetworkManager[1155]: <info>  [1747896957.0589] agent-manager: agent[6be95e02389b394a,:1.32/org.gnome.Shell.NetworkAgent/42]: agent registered
May 22 12:41:17 pdbdr1.unidev.org.np NetworkManager[1155]: <info>  [1747896977.7890] agent-manager: agent[97a7380c03e1ac45,:1.88/org.gnome.Shell.NetworkAgent/0]: agent registered
*/

-- Step 9.2 -->> On Node 2
[root@pdbdr2 ~]#  systemctl status NetworkManager
/*
● NetworkManager.service - Network Manager
     Loaded: loaded (/usr/lib/systemd/system/NetworkManager.service; enabled; preset: enabled)
     Active: active (running) since Thu 2025-05-22 12:40:28 +0545; 21min ago
       Docs: man:NetworkManager(8)
   Main PID: 1156 (NetworkManager)
      Tasks: 3 (limit: 124664)
     Memory: 11.5M
        CPU: 214ms
     CGroup: /system.slice/NetworkManager.service
             └─1156 /usr/sbin/NetworkManager --no-daemon

May 22 12:40:28 pdbdr2.unidev.org.np NetworkManager[1156]: <info>  [1747896928.7135] device (ens192): state change: secondaries -> activated (reason 'none', managed-type: 'full')
May 22 12:40:28 pdbdr2.unidev.org.np NetworkManager[1156]: <info>  [1747896928.7142] device (ens192): Activation: successful, device activated.
May 22 12:40:28 pdbdr2.unidev.org.np NetworkManager[1156]: <info>  [1747896928.7149] manager: NetworkManager state is now CONNECTED_GLOBAL
May 22 12:40:28 pdbdr2.unidev.org.np NetworkManager[1156]: <info>  [1747896928.7152] device (ens224): state change: secondaries -> activated (reason 'none', managed-type: 'full')
May 22 12:40:28 pdbdr2.unidev.org.np NetworkManager[1156]: <info>  [1747896928.7158] device (ens224): Activation: successful, device activated.
May 22 12:40:28 pdbdr2.unidev.org.np NetworkManager[1156]: <info>  [1747896928.8420] manager: startup complete
May 22 12:40:31 pdbdr2.unidev.org.np NetworkManager[1156]: <info>  [1747896931.7813] modem-manager: ModemManager not available
May 22 12:40:31 pdbdr2.unidev.org.np NetworkManager[1156]: <info>  [1747896931.8235] modem-manager: ModemManager now available
May 22 12:41:17 pdbdr2.unidev.org.np NetworkManager[1156]: <info>  [1747896977.0929] agent-manager: agent[1ec84582edfd2e60,:1.32/org.gnome.Shell.NetworkAgent/42]: agent registered
May 22 12:41:40 pdbdr2.unidev.org.np NetworkManager[1156]: <info>  [1747897000.9255] agent-manager: agent[d314ba55aea3f44a,:1.88/org.gnome.Shell.NetworkAgent/0]: agent registered
*/

-- Step 9.3 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# nmcli device status
/*
DEVICE  TYPE      STATE                   CONNECTION
ens192  ethernet  connected               ens192
ens224  ethernet  connected               ens224
lo      loopback  connected (externally)  lo
*/

-- Step 9.4 -->> On Node 1
[root@pdbdr1 ~]#  nmcli connection show
/*
NAME    UUID                                  TYPE      DEVICE
ens192  b4f07a71-3043-3af9-89d1-f94dc7708a9a  ethernet  ens192
ens224  ae50bb0f-4151-39e7-b020-cb64a21c97a8  ethernet  ens224
lo      b3fdabbe-cab3-4521-8c87-4a99da992405  loopback  lo
*/

-- Step 9.5 -->> On Node 2
[root@pdbdr2 ~]#  nmcli connection show
/*
NAME    UUID                                  TYPE      DEVICE
ens192  09d38db1-4dfc-3938-bcc3-131d008b3f47  ethernet  ens192
ens224  4a9ff9c7-6616-3a5f-b057-d738803c2d24  ethernet  ens224
lo      df89a060-09cc-4762-9a97-98d980b39742  loopback  lo
*/

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
Linux pdbdr1.unidev.org.np 5.15.0-308.179.6.3.el9uek.x86_64 #2 SMP Tue May 13 20:29:18 PDT 2025 x86_64 x86_64 x86_64 GNU/Linux
*/

-- Step 10.2 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# uname -r
/*
5.15.0-308.179.6.3.el9uek.x86_64
*/

-- Step 10.3 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# grubby --info=ALL | grep ^kernel
/*
kernel="/boot/vmlinuz-5.15.0-308.179.6.3.el9uek.x86_64"
kernel="/boot/vmlinuz-5.15.0-302.167.6.el9uek.x86_64"
kernel="/boot/vmlinuz-5.14.0-570.12.1.0.1.el9_6.x86_64"
kernel="/boot/vmlinuz-5.14.0-503.11.1.el9_5.x86_64"
kernel="/boot/vmlinuz-0-rescue-e35e0ec1529e4f01872534270673e7ee"
*/

-- Step 10.4 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# grubby --default-kernel
/*
/boot/vmlinuz-5.15.0-308.179.6.3.el9uek.x86_64
*/

-- As per as Oracle Doucument 1369107.1 we have to Fix as:
/*
Oracle Linux 9 - Red Hat Compatible Kernel
Update => Update 5 (9.5)
Kernel Series => U5 Update 5.14.0-503.11.1 andlater RHEL9.5 CompatibleRedHat Kernels 
Architecture => X86_64
ACFS Minimum GI Releaseand Associated Bugs => 19.27.0.0.250415 (Base Bug 37246971)
AFD Minimum GI Releaseand Associated Bugs => 19.27.0.0.250415 (Base Bug 37246971)
*/

-- Step 10.5 -->> On Both Node, Set RHCK as Default Boot Kernel
[root@pdbdr1/pdbdr2 ~]# grubby --set-default /boot/vmlinuz-5.14.0-503.11.1.el9_5.x86_64
/*
The default is /boot/loader/entries/e35e0ec1529e4f01872534270673e7ee-5.14.0-503.11.1.el9_5.x86_64.conf with index 3 and kernel /boot/vmlinuz-5.14.0-503.11.1.el9_5.x86_64
*/

-- Step 10.6 -->> On Both Node, Confirm Default Kernel
[root@pdbdr1/pdbdr2 ~]# grubby --default-kernel
/*
/boot/vmlinuz-5.14.0-503.11.1.el9_5.x86_64
*/

-- Step 10.7 -->> On Both Node, Reboot and Verify
[root@pdbdr1/pdbdr2 ~]# init 6

--To Fix the Disk's issues
--[root@pdbdr1/pdbdr2 ~]# dracut -f --regenerate-all

--After reboot, verify the running kernel:
-- Step 10.8 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# dnf repolist
/*
repo id                       repo name
ol9_UEKR7                     Oracle Linux 9 UEK Release 7 (x86_64)
ol9_appstream                 Oracle Linux 9 Application Stream Packages (x86_64)
ol9_baseos_latest             Oracle Linux 9 BaseOS Latest (x86_64)
*/

-- Step 10.9 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# uname -a
/*
Linux pdbdr1.unidev.org.np 5.14.0-503.11.1.el9_5.x86_64 #1 SMP PREEMPT_DYNAMIC Wed Nov 13 08:33:30 PST 2024 x86_64 x86_64 x86_64 GNU/Linux
*/

-- Step 10.10 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# uname -r
/*
5.14.0-503.11.1.el9_5.x86_64
*/

-- Step 10.11 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# grubby --info=ALL | grep ^kernel
/*
kernel="/boot/vmlinuz-5.15.0-308.179.6.3.el9uek.x86_64"
kernel="/boot/vmlinuz-5.15.0-302.167.6.el9uek.x86_64"
kernel="/boot/vmlinuz-5.14.0-570.12.1.0.1.el9_6.x86_64"
kernel="/boot/vmlinuz-5.14.0-503.11.1.el9_5.x86_64"
kernel="/boot/vmlinuz-0-rescue-e35e0ec1529e4f01872534270673e7ee"
*/

-- Step 10.12 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# grubby --default-kernel
/*
/boot/vmlinuz-5.14.0-503.11.1.el9_5.x86_64
*/

-- Step 10.13 -->> On Both Node, Confirm Both Kernels Are Installed (Permanent Use)
[root@pdbdr1/pdbdr2 ~]# rpm -qa | grep kernel-core
/*
kernel-core-5.14.0-503.11.1.el9_5.x86_64
kernel-core-5.14.0-570.12.1.0.1.el9_6.x86_64
*/

-- Step 11 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/hostname
/*
pdbdr1/pdbdr2.unidev.org.np
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
         Chassis: vm 🖴
      Machine ID: e35e0ec1529e4f01872534270673e7ee
         Boot ID: a0f047ef95834e32965a8da9a12a4042
  Virtualization: vmware
Operating System: Oracle Linux Server 9.6
     CPE OS Name: cpe:/o:oracle:linux:9:6:server
          Kernel: Linux 5.14.0-503.11.1.el9_5.x86_64
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform
Firmware Version: 6.00
*/

-- Step 13 -->> On Node 2
[root@pdbdr2 ~]# hostnamectl set-hostname pdbdr2.unidev.org.np

-- Step 13.1 -->> On Node 2
[root@pdbdr2 ~]# hostnamectl
/*
 Static hostname: pdbdr2.unidev.org.np
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: 0787ec3474b74b7789be912e43d9b56a
         Boot ID: e3a0c555fb194f1793b1cca1f9103acb
  Virtualization: vmware
Operating System: Oracle Linux Server 9.6
     CPE OS Name: cpe:/o:oracle:linux:9:6:server
          Kernel: Linux 5.14.0-503.11.1.el9_5.x86_64
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform
Firmware Version: 6.00
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
     Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; preset: enabled)
     Active: active (running) since Thu 2025-05-22 15:29:33 +0545; 19s ago
       Docs: man:chronyd(8)
             man:chrony.conf(5)
    Process: 6440 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
   Main PID: 6442 (chronyd)
      Tasks: 1 (limit: 124714)
     Memory: 1.0M
        CPU: 64ms
     CGroup: /system.slice/chronyd.service
             └─6442 /usr/sbin/chronyd -F 2

May 22 15:29:33 pdbdr1.unidev.org.np systemd[1]: Starting NTP client/server...
May 22 15:29:33 pdbdr1.unidev.org.np chronyd[6442]: chronyd version 4.6.1 starting (+CMDMON +NTP +REFCLOCK +RTC +PRIVDROP +SCFILTER +SIGND +ASYNCDNS +NTS +SECHASH +IPV6 +DEBUG)
May 22 15:29:33 pdbdr1.unidev.org.np chronyd[6442]: Loaded 0 symmetric keys
May 22 15:29:33 pdbdr1.unidev.org.np chronyd[6442]: Using right/UTC timezone to obtain leap second data
May 22 15:29:33 pdbdr1.unidev.org.np chronyd[6442]: Frequency -9.972 +/- 0.906 ppm read from /var/lib/chrony/drift
May 22 15:29:33 pdbdr1.unidev.org.np chronyd[6442]: Loaded seccomp filter (level 2)
May 22 15:29:33 pdbdr1.unidev.org.np systemd[1]: Started NTP client/server.
May 22 15:29:38 pdbdr1.unidev.org.np chronyd[6442]: Selected source 162.159.200.123 (2.pool.ntp.org)
May 22 15:29:38 pdbdr1.unidev.org.np chronyd[6442]: System clock TAI offset set to 37 seconds
May 22 15:29:42 pdbdr1.unidev.org.np chronyd[6442]: System clock was stepped by -0.000236 seconds
*/

-- Step 18 -->> On Both Node
[root@pdbdr1 ~]# cd /etc/yum.repos.d/
[root@pdbdr1 yum.repos.d]# ll
/*
-rw-r--r--  1 root root 3235 May 13 21:53 oracle-linux-ol9.repo
-rw-r--r--  1 root root  615 May 13 21:53 uek-ol9.repo
-rw-r--r--. 1 root root  229 May 13 21:53 virt-ol9.repo
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
     Loaded: loaded (/usr/lib/systemd/system/NetworkManager.service; enabled; preset: enabled)
     Active: active (running) since Thu 2025-05-22 15:32:43 +0545; 7s ago
       Docs: man:NetworkManager(8)
   Main PID: 6592 (NetworkManager)
      Tasks: 4 (limit: 124714)
     Memory: 5.5M
        CPU: 112ms
     CGroup: /system.slice/NetworkManager.service
             └─6592 /usr/sbin/NetworkManager --no-daemon

May 22 15:32:43 pdbdr1.unidev.org.np NetworkManager[6592]: <info>  [1747907263.6002] device (lo): Activation: successful, device activated.
May 22 15:32:43 pdbdr1.unidev.org.np NetworkManager[6592]: <info>  [1747907263.6008] device (ens192): state change: ip-check -> secondaries (reason 'none', managed-type: 'assume')
May 22 15:32:43 pdbdr1.unidev.org.np NetworkManager[6592]: <info>  [1747907263.6010] device (ens224): state change: ip-check -> secondaries (reason 'none', managed-type: 'assume')
May 22 15:32:43 pdbdr1.unidev.org.np NetworkManager[6592]: <info>  [1747907263.6012] device (ens192): state change: secondaries -> activated (reason 'none', managed-type: 'assume')
May 22 15:32:43 pdbdr1.unidev.org.np NetworkManager[6592]: <info>  [1747907263.6015] manager: NetworkManager state is now CONNECTED_SITE
May 22 15:32:43 pdbdr1.unidev.org.np NetworkManager[6592]: <info>  [1747907263.6018] device (ens192): Activation: successful, device activated.
May 22 15:32:43 pdbdr1.unidev.org.np NetworkManager[6592]: <info>  [1747907263.6024] manager: NetworkManager state is now CONNECTED_GLOBAL
May 22 15:32:43 pdbdr1.unidev.org.np NetworkManager[6592]: <info>  [1747907263.6027] device (ens224): state change: secondaries -> activated (reason 'none', managed-type: 'assume')
May 22 15:32:43 pdbdr1.unidev.org.np NetworkManager[6592]: <info>  [1747907263.6032] device (ens224): Activation: successful, device activated.
May 22 15:32:43 pdbdr1.unidev.org.np NetworkManager[6592]: <info>  [1747907263.6040] manager: startup complete
*/

-- Step 18.5 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# systemctl status dnsmasq
/*
● dnsmasq.service - DNS caching server.
     Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; preset: disabled)
     Active: active (running) since Thu 2025-05-22 15:32:34 +0545; 30s ago
    Process: 6566 ExecStart=/usr/sbin/dnsmasq (code=exited, status=0/SUCCESS)
   Main PID: 6569 (dnsmasq)
      Tasks: 1 (limit: 124714)
     Memory: 1.1M
        CPU: 10ms
     CGroup: /system.slice/dnsmasq.service
             └─6569 /usr/sbin/dnsmasq

May 22 15:32:34 pdbdr1.unidev.org.np dnsmasq[6569]: reading /etc/resolv.conf
May 22 15:32:34 pdbdr1.unidev.org.np dnsmasq[6569]: ignoring nameserver 127.0.0.1 - local interface
May 22 15:32:34 pdbdr1.unidev.org.np dnsmasq[6569]: using nameserver 192.168.4.11#53
May 22 15:32:34 pdbdr1.unidev.org.np dnsmasq[6569]: using nameserver 192.168.4.12#53
May 22 15:32:34 pdbdr1.unidev.org.np dnsmasq[6569]: read /etc/hosts - 11 addresses
May 22 15:32:34 pdbdr1.unidev.org.np systemd[1]: Started DNS caching server..
May 22 15:32:43 pdbdr1.unidev.org.np dnsmasq[6569]: reading /etc/resolv.conf
May 22 15:32:43 pdbdr1.unidev.org.np dnsmasq[6569]: ignoring nameserver 127.0.0.1 - local interface
May 22 15:32:43 pdbdr1.unidev.org.np dnsmasq[6569]: using nameserver 192.168.4.11#53
May 22 15:32:43 pdbdr1.unidev.org.np dnsmasq[6569]: using nameserver 192.168.4.12#53
*/

-- Step 19 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/resolv.conf
/*
# Generated by NetworkManager
search cibnepal.org.np
nameserver 127.0.0.1
nameserver 192.168.4.11
nameserver 192.168.4.12
*/

-- Step 20 -->> On Node 1
[root@pdbdr1/pdbdr2 ~]# nslookup 192.168.6.48
/*
48.6.168.192.in-addr.arpa        name = pdbdr1.unidev.org.np.
*/

-- Step 20.1 -->> On Node 1
[root@pdbdr1/pdbdr2 ~]# nslookup 192.168.6.49
/*
49.6.168.192.in-addr.arpa        name = pdbdr2.unidev.org.np.
*/

-- Step 20.2 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup pdbdr1
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdbdr1.unidev.org.np
Address: 192.168.6.48
*/

-- Step 20.3 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup pdbdr2
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdbdr2.unidev.org.np
Address: 192.168.6.49
*/

-- Step 20.4 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup pdbdr-scan
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdbdr-scan.unidev.org.np
Address: 192.168.6.54
Name:   pdbdr-scan.unidev.org.np
Address: 192.168.6.52
Name:   pdbdr-scan.unidev.org.np
Address: 192.168.6.53
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
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.6.48  netmask 255.255.255.0  broadcast 192.168.6.255
        inet6 fe80::20c:29ff:fef5:c822  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:f5:c8:22  txqueuelen 1000  (Ethernet)
        RX packets 629  bytes 70268 (68.6 KiB)
        RX errors 0  dropped 23  overruns 0  frame 0
        TX packets 580  bytes 91081 (88.9 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens224: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.48  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::20c:29ff:fef5:c82c  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:f5:c8:2c  txqueuelen 1000  (Ethernet)
        RX packets 154  bytes 18137 (17.7 KiB)
        RX errors 0  dropped 21  overruns 0  frame 0
        TX packets 91  bytes 10726 (10.4 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 645  bytes 42616 (41.6 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 645  bytes 42616 (41.6 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 22.4 -->> On Node Two
[root@pdbdr2 ~]# ifconfig
/*
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.6.49  netmask 255.255.255.0  broadcast 192.168.6.255
        inet6 fe80::20c:29ff:fe59:8f68  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:59:8f:68  txqueuelen 1000  (Ethernet)
        RX packets 883  bytes 98209 (95.9 KiB)
        RX errors 0  dropped 65  overruns 0  frame 0
        TX packets 627  bytes 94659 (92.4 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens224: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.49  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::20c:29ff:fe59:8f72  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:59:8f:72  txqueuelen 1000  (Ethernet)
        RX packets 371  bytes 43378 (42.3 KiB)
        RX errors 0  dropped 63  overruns 0  frame 0
        TX packets 92  bytes 10796 (10.5 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 839  bytes 54604 (53.3 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 839  bytes 54604 (53.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/
-- Step 23 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# init 6


-- Step 24 -->> On Node One
[root@pdbdr1 ~]# ifconfig
/*
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.6.48  netmask 255.255.255.0  broadcast 192.168.6.255
        inet6 fe80::20c:29ff:fef5:c822  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:f5:c8:22  txqueuelen 1000  (Ethernet)
        RX packets 106  bytes 11099 (10.8 KiB)
        RX errors 0  dropped 13  overruns 0  frame 0
        TX packets 98  bytes 13833 (13.5 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens224: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.48  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::20c:29ff:fef5:c82c  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:f5:c8:2c  txqueuelen 1000  (Ethernet)
        RX packets 23  bytes 1563 (1.5 KiB)
        RX errors 0  dropped 11  overruns 0  frame 0
        TX packets 14  bytes 992 (992.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 178  bytes 12196 (11.9 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 178  bytes 12196 (11.9 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 24.1 -->> On Node Two
[root@pdbdr2 ~]# ifconfig
/*
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.6.49  netmask 255.255.255.0  broadcast 192.168.6.255
        inet6 fe80::20c:29ff:fe59:8f68  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:59:8f:68  txqueuelen 1000  (Ethernet)
        RX packets 135  bytes 12903 (12.6 KiB)
        RX errors 0  dropped 32  overruns 0  frame 0
        TX packets 94  bytes 12181 (11.8 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens224: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.49  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::20c:29ff:fe59:8f72  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:59:8f:72  txqueuelen 1000  (Ethernet)
        RX packets 54  bytes 3423 (3.3 KiB)
        RX errors 0  dropped 30  overruns 0  frame 0
        TX packets 14  bytes 992 (992.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 256  bytes 16988 (16.5 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 256  bytes 16988 (16.5 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 24.2 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# ifconfig | grep -E 'UP'
/*
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
ens224: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
*/

-- Step 24.3 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# ifconfig | grep -E 'RUNNING'
/*
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
ens224: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
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
     Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; preset: enabled)
     Active: active (running) since Thu 2025-05-22 15:42:51 +0545; 4min 16s ago
       Docs: man:chronyd(8)
             man:chrony.conf(5)
    Process: 1325 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
   Main PID: 1396 (chronyd)
      Tasks: 1 (limit: 124714)
     Memory: 1.5M
        CPU: 170ms
     CGroup: /system.slice/chronyd.service
             └─1396 /usr/sbin/chronyd -F 2

May 22 15:42:51 pdbdr1.unidev.org.np systemd[1]: Starting NTP client/server...
May 22 15:42:51 pdbdr1.unidev.org.np chronyd[1396]: chronyd version 4.6.1 starting (+CMDMON +NTP +REFCLOCK +RTC +PRIVDROP +SCFILTER +SIGND +ASYNCDNS +NTS +SECHASH +IPV6 +DEBUG)
May 22 15:42:51 pdbdr1.unidev.org.np chronyd[1396]: Loaded 0 symmetric keys
May 22 15:42:51 pdbdr1.unidev.org.np chronyd[1396]: Using right/UTC timezone to obtain leap second data
May 22 15:42:51 pdbdr1.unidev.org.np chronyd[1396]: Frequency -10.104 +/- 0.414 ppm read from /var/lib/chrony/drift
May 22 15:42:51 pdbdr1.unidev.org.np chronyd[1396]: Loaded seccomp filter (level 2)
May 22 15:42:51 pdbdr1.unidev.org.np systemd[1]: Started NTP client/server.
May 22 15:42:56 pdbdr1.unidev.org.np chronyd[1396]: Selected source 162.159.200.1 (2.pool.ntp.org)
May 22 15:42:56 pdbdr1.unidev.org.np chronyd[1396]: System clock TAI offset set to 37 seconds
*/

-- Step 31 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# systemctl status dnsmasq
/*
● dnsmasq.service - DNS caching server.
     Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; preset: disabled)
     Active: active (running) since Thu 2025-05-22 15:42:51 +0545; 4min 41s ago
    Process: 1296 ExecStart=/usr/sbin/dnsmasq (code=exited, status=0/SUCCESS)
   Main PID: 1315 (dnsmasq)
      Tasks: 1 (limit: 124714)
     Memory: 1.9M
        CPU: 14ms
     CGroup: /system.slice/dnsmasq.service
             └─1315 /usr/sbin/dnsmasq

May 22 15:42:50 pdbdr1.unidev.org.np systemd[1]: Starting DNS caching server....
May 22 15:42:51 pdbdr1.unidev.org.np dnsmasq[1315]: started, version 2.85 cachesize 150
May 22 15:42:51 pdbdr1.unidev.org.np dnsmasq[1315]: compile time options: IPv6 GNU-getopt DBus no-UBus no-i18n IDN2 DHCP DHCPv6 no-Lua TFTP no-conntrack ipset auth cryptohash DNSSEC loop>
May 22 15:42:51 pdbdr1.unidev.org.np dnsmasq[1315]: reading /etc/resolv.conf
May 22 15:42:51 pdbdr1.unidev.org.np dnsmasq[1315]: ignoring nameserver 127.0.0.1 - local interface
May 22 15:42:51 pdbdr1.unidev.org.np dnsmasq[1315]: using nameserver 192.168.4.11#53
May 22 15:42:51 pdbdr1.unidev.org.np dnsmasq[1315]: using nameserver 192.168.4.12#53
May 22 15:42:51 pdbdr1.unidev.org.np systemd[1]: Started DNS caching server..
May 22 15:42:51 pdbdr1.unidev.org.np dnsmasq[1315]: read /etc/hosts - 11 addresses
*/

-- Step 31.1 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup 192.168.6.48
/*
48.6.168.192.in-addr.arpa        name = pdbdr1.unidev.org.np.
*/

-- Step 31.2 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup 192.168.6.49
/*
49.6.168.192.in-addr.arpa        name = pdbdr2.unidev.org.np.
*/

-- Step 31.3 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup pdbdr1
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdbdr1.unidev.org.np
Address: 192.168.6.48
*/

-- Step 31.4 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup pdbdr2
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdbdr2.unidev.org.np
Address: 192.168.6.49
*/

-- Step 31.5 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup pdbdr-scan
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdbdr-scan.unidev.org.np
Address: 192.168.6.54
Name:   pdbdr-scan.unidev.org.np
Address: 192.168.6.52
Name:   pdbdr-scan.unidev.org.np
Address: 192.168.6.53
*/

-- Step 31.6 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup pdbdr2-vip
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdbdr2-vip.unidev.org.np
Address: 192.168.6.51
*/

-- Step 31.7 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# nslookup pdbdr1-vip
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdbdr1-vip.unidev.org.np
Address: 192.168.6.50
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
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y oracle-epel-release-el9
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y sshpass zip unzip
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y oracle-database-preinstall-19c

-- Step 32.2 -->> On Both Node
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y bc
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y binutils
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y compat-libcap1
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y compat-libstdc++-33
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y compat-openssl11
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y dtrace-utils
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y dtrace-modules
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y dtrace-modules-headers
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y dtrace-modules-provider-headers
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y elfutils-libelf
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y elfutils-libelf-devel
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y fontconfig-devel
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y fontconfig
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y glibc
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y glibc-devel
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y glibc-headers
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y ksh
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libaio
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libaio-devel
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libdtrace-ctf-devel
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libasan
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y liblsan
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libxcrypt-compat
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libibverbs
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libXrender
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libXrender-devel
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libX11
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libXau
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libXi
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libXtst
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libgcc
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y librdmacm-devel
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y librdmacm
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libstdc++
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libstdc++-devel
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libxcb
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libvirt-libs
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y make
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y net-tools
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y nfs-utils
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y python
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y python-configshell
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y python-rtslib
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y python-six
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y policycoreutils
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y policycoreutils-python-utils
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y targetcli
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y smartmontools
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y sysstat
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y gcc
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y unixODBC
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libnsl
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libnsl.i686
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libnsl2
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libnsl2.i686
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y ipmiutil
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y libnsl2-devel
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf install -y chrony
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf -y update

-- Step 32.3 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# cd /tmp
--Bug 29772579 / Bug 35547711 / 35448216
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libcap1-1.10-7.el7.i686.rpm
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libcap1-1.10-7.el7.x86_64.rpm
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libstdc++-33-3.2.3-72.el7.i686.rpm
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm

-- Step 32.4 -->> On Both Node
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL9/appstream/x86_64/getPackage/elfutils-libelf-devel-0.191-4.el9.i686.rpm
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL9/appstream/x86_64/getPackage/elfutils-libelf-devel-0.191-4.el9.x86_64.rpm
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL9/baseos/latest/x86_64/getPackage/numactl-2.0.18-2.el9.x86_64.rpm
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL9/appstream/x86_64/getPackage/numactl-devel-2.0.18-2.el9.i686.rpm
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL9/appstream/x86_64/getPackage/numactl-devel-2.0.18-2.el9.x86_64.rpm
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL9/baseos/latest/x86_64/getPackage/python3-libs-3.9.19-8.el9_5.1.i686.rpm
[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL9/baseos/latest/x86_64/getPackage/python3-libs-3.9.19-8.el9_5.1.x86_64.rpm
[root@pdbdr1/pdbdr2 tmp]# wget https://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/c/compat-libpthread-nonshared-2.41.9000-13.fc43.x86_64.rpm
                           
-- Step 00.00 -->> On Node 1
--Go to https://www.oracle.com/linux/downloads/linux-asmlib-v9-downloads.html
--[root@pdb1 tmp]# cp /root/Oracle_19C/19c_RPM/oracleasmlib-3.0.0-13.el9.x86_64.rpm /tmp/
--[root@pdb1 tmp]# scp -r /root/Oracle_19C/19c_RPM/oracleasmlib-3.0.0-13.el9.x86_64.rpm root@192.168.6.22:/tmp/

-- Step 00.00 -->> On Node 1
--[root@pdb1 tmp]# cp /root/Oracle_19C/19c_RPM/oracleasmlib-3.1.0-6.el9.x86_64.rpm /tmp/
--[root@pdb1 tmp]# scp -r /root/Oracle_19C/19c_RPM/oracleasmlib-3.1.0-6.el9.x86_64.rpm root@192.168.6.22:/tmp/

-- Step 00.00 -->> On Both Nodes
--[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL9/addons/x86_64/getPackage/oracleasm-support-3.0.0-6.el9.x86_64.rpm
--[root@pdbdr1/pdbdr2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL9/addons/x86_64/getPackage/oracleasm-support-3.1.0-10.el9.x86_64.rpm

-- Step 32.5 -->> On Both Node
--Bug 29772579
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./compat-libcap1-1.10-7.el7.i686.rpm
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./compat-libcap1-1.10-7.el7.x86_64.rpm
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./compat-libstdc++-33-3.2.3-72.el7.i686.rpm
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./compat-libpthread-nonshared-2.41.9000-13.fc43.x86_64.rpm
                                            

-- Step 32.6 -->> On Both Node
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./elfutils-libelf-devel-0.191-4.el9.i686.rpm
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./elfutils-libelf-devel-0.191-4.el9.x86_64.rpm
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./numactl-2.0.18-2.el9.x86_64.rpm
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./numactl-devel-2.0.18-2.el9.i686.rpm
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./numactl-devel-2.0.18-2.el9.x86_64.rpm
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./python3-libs-3.9.19-8.el9_5.1.i686.rpm
[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./python3-libs-3.9.19-8.el9_5.1.x86_64.rpm

--[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./oracleasm-support-3.0.0-6.el9.x86_64.rpm ./oracleasmlib-3.0.0-13.el9.x86_64.rpm
--[root@pdbdr1/pdbdr2 tmp]# yum -y localinstall ./oracleasm-support-3.1.0-10.el9.x86_64.rpm ./oracleasmlib-3.1.0-6.el9.x86_64.rpm

-- Step 33 -->> On Both Node
[root@pdbdr1/pdbdr2 tmp]# rm -rf *.rpm


-- Step 34 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# cd /etc/yum.repos.d/
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf -y install compat-libcap1 compat-libstdc++-33 bc binutils elfutils-libelf elfutils-libelf-devel fontconfig-devel glibc glibc-devel ksh libaio libaio-devel libgcc libnsl librdmacm-devel libstdc++ libstdc++-devel libX11 libXau libxcb libXi libXrender libXrender-devel libXtst make net-tools nfs-utils python3 python3-configshell python3-rtslib python3-six smartmontools sysstat targetcli unzip
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf -y install bash bc bind-utils binutils ethtool glibc glibc-devel initscripts ksh libaio libaio-devel libgcc libnsl libstdc++ libstdc++-devel make module-init-tools net-tools nfs-utils openssh-clients openssl-libs pam procps psmisc smartmontools sysstat tar unzip util-linux-ng xorg-x11-utils xorg-x11-xauth 
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf -y install bc binutils compat-libcap1 compat-libstdc++-33 compat-openssl11 dtrace-utils dtrace-modules dtrace-modules-headers dtrace-modules-provider-headers elfutils-libelf elfutils-libelf-devel fontconfig-devel fontconfig glibc glibc-devel glibc-headers ksh libaio libaio-devel libdtrace-ctf-devel libasan liblsan libxcrypt-compat libibverbs libXrender libXrender-devel libX11 libXau libXi libXtst libgcc librdmacm-devel librdmacm libstdc++ libstdc++-devel libxcb libvirt-libs make net-tools nfs-utils python python-configshell python-rtslib python-six policycoreutils policycoreutils-python-utils targetcli smartmontools sysstat gcc unixODBC libnsl libnsl.i686 libnsl2 libnsl2.i686 ipmiutil libnsl2-devel chrony
--[root@pdbdr1/pdbdr2 yum.repos.d]# dnf -y install oracleasm-support oracleasmlib
[root@pdbdr1/pdbdr2 yum.repos.d]# dnf -y update

-- Step 35 -->> On Both Node
[root@pdbdr1/pdbdr2 yum.repos.d]# rpm -q binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel \
[root@pdbdr1/pdbdr2 yum.repos.d]# rpm -q gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers kernel-headers ksh libaio libaio-devel \
[root@pdbdr1/pdbdr2 yum.repos.d]# rpm -q libgcc libgomp libstdc++ libstdc++-devel make numactl-devel sysstat unixODBC \

-- Step 00 -->> On Both Node
--[root@pdbdr1/pdbdr2 ~]# rpm -qa | grep oracleasm
/*
oracleasm-support-3.1.0-10.el9.x86_64
oracleasmlib-3.1.0-6.el9.x86_64
*/

--Enabling or Restricting io_uring
-- The io_uring interface is used instead of the oracleasm kernel driver, when the system is running UEK R7 
-- or Oracle Linux 9 with RHCK. If the system is running Oracle Linux 9 with RHCK, you must either 
-- enable io_uring globally, or you can enable io_uring so that its restricted to processes that are run by 
-- a particular group. io_uring is globally enabled in UEK R7 by default, but you can edit the system configuration 
-- to restrict it to processes that are run by a particular group, if you prefer.

-- Step 00 -->> On Both Node
--[root@pdbdr1/pdbdr2 ~]# vi /etc/sysctl.conf
/*
# You can fully enable io_uring in the kernel by adding the following line
kernel.io_uring_disabled = 0
*/

--[root@pdbdr1/pdbdr2 ~]# cat /etc/sysctl.conf | grep -E "io_uring" 
/*
# You can fully enable io_uring in the kernel by adding the following line
kernel.io_uring_disabled = 0
*/

-- Step 00 -->> On Both Node
--Reload the system configuration.
--[root@pdbdr1/pdbdr2 ~]# sysctl -p /etc/sysctl.conf
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
net.ipv4.ip_local_port_range = 9000 65500
kernel.io_uring_disabled = 0
*/

-- Step 00 -->> On Both Node
-- Upgrading ASMLIB
--[root@pdbdr1/pdbdr2 ~]# cd /etc/yum.repos.d/
--[root@pdbdr1/pdbdr2 yum.repos.d]# dnf -y update

-- Step 36 -->> On Both Node 
[root@pdbdr1/pdbdr2 ~]# init 0

-- Step 37 -->> On Both Node 
--Check and Set the Correct SCSI Controller Type
-->-In VMware, go to Edit Settings of each VM:
-->-Find the SCSI Controller for shared disks.
-->-Set it to VMware Paravirtual (PVSCSI) instead of LSI Logic.
-->-Reboot both VMs after making this change.
-->-Manually Add the required Disk's for ASM configuration 
-->-Open the The OS after creation/configuration of Disk's 

-- Step 38 -->> On Node 1 
[root@pdbdr1 ~]# lsblk
/*
NAME               MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                  8:0    0  222G  0 disk
├─sda1               8:1    0    2G  0 part /boot
└─sda2               8:2    0  220G  0 part
  ├─ol_pdbdr1-root 253:0    0   70G  0 lvm  /
  ├─ol_pdbdr1-swap 253:1    0   20G  0 lvm  [SWAP]
  ├─ol_pdbdr1-usr  253:2    0   15G  0 lvm  /usr
  ├─ol_pdbdr1-tmp  253:3    0   15G  0 lvm  /tmp
  ├─ol_pdbdr1-var  253:4    0   15G  0 lvm  /var
  ├─ol_pdbdr1-home 253:5    0   15G  0 lvm  /home
  └─ol_pdbdr1-opt  253:6    0   70G  0 lvm  /opt
sdb                  8:16   0   20G  0 disk
sdc                  8:32   0  200G  0 disk
sdd                  8:48   0  400G  0 disk
sr0                 11:0    1 11.7G  0 rom
*/

-- Step 38.1 -->> On Node 2
[root@pdbdr2 ~]# lsblk
/*
NAME               MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                  8:0    0  222G  0 disk
├─sda1               8:1    0    2G  0 part /boot
└─sda2               8:2    0  220G  0 part
  ├─ol_pdbdr2-root 253:0    0   70G  0 lvm  /
  ├─ol_pdbdr2-swap 253:1    0   20G  0 lvm  [SWAP]
  ├─ol_pdbdr2-usr  253:2    0   15G  0 lvm  /usr
  ├─ol_pdbdr2-tmp  253:3    0   15G  0 lvm  /tmp
  ├─ol_pdbdr2-var  253:4    0   15G  0 lvm  /var
  ├─ol_pdbdr2-home 253:5    0   15G  0 lvm  /home
  └─ol_pdbdr2-opt  253:6    0   70G  0 lvm  /opt
sdb                  8:16   0   20G  0 disk
sdc                  8:32   0  200G  0 disk
sdd                  8:48   0  400G  0 disk
sr0                 11:0    1 11.7G  0 rom
*/

-- Step 39 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# ll /etc/init.d/
/*
-rw-r--r-- 1 root root 18220 Aug 27  2024 functions
-rwx------ 1 root root  1307 Oct 16  2023 oracle-database-preinstall-19c-firstboot
-rw-r--r-- 1 root root  1161 Feb 25 16:43 README
*/

-- Step 40 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# ll /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 May 22 15:42 /dev/sda
brw-rw---- 1 root disk 8,  1 May 22 15:42 /dev/sda1
brw-rw---- 1 root disk 8,  2 May 22 15:42 /dev/sda2
brw-rw---- 1 root disk 8, 16 May 22 15:42 /dev/sdb
brw-rw---- 1 root disk 8, 32 May 22 15:42 /dev/sdc
brw-rw---- 1 root disk 8, 48 May 22 15:42 /dev/sdd
*/

-- Step 40.1 -->> On Both Node
[root@pdbdr1/pdbdr2 ~]# fdisk -ll | grep -E "sdb|sdc|sdd"
/*
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
Disk /dev/sdc: 200 GiB, 214748364800 bytes, 419430400 sectors
Disk /dev/sdd: 400 GiB, 429496729600 bytes, 838860800 sectors
*/

-- Step 40.2 -->> On Node 1
[root@pdbdr1 ~]# fdisk /dev/sdb
/*
Welcome to fdisk (util-linux 2.37.4).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0xc924da8f.

Command (m for help): p
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xc924da8f

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-41943039, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-41943039, default 41943039):

Created a new partition 1 of type 'Linux' and of size 20 GiB.

Command (m for help): p
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xc924da8f

Device     Boot Start      End  Sectors Size Id Type
/dev/sdb1        2048 41943039 41940992  20G 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 40.3 -->> On Node 1
[root@pdbdr1 ~]# fdisk /dev/sdc
/*
Welcome to fdisk (util-linux 2.37.4).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x9196cfad.

Command (m for help): p
Disk /dev/sdc: 200 GiB, 214748364800 bytes, 419430400 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x9196cfad

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-419430399, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-419430399, default 419430399):

Created a new partition 1 of type 'Linux' and of size 200 GiB.

Command (m for help): p
Disk /dev/sdc: 200 GiB, 214748364800 bytes, 419430400 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x9196cfad

Device     Boot Start       End   Sectors  Size Id Type
/dev/sdc1        2048 419430399 419428352  200G 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 40.4 -->> On Node 1
[root@pdbdr1 ~]# fdisk /dev/sdd
/*
Welcome to fdisk (util-linux 2.37.4).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0xc433c1a8.

Command (m for help): p
Disk /dev/sdd: 400 GiB, 429496729600 bytes, 838860800 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xc433c1a8

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-838860799, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-838860799, default 838860799):

Created a new partition 1 of type 'Linux' and of size 400 GiB.

Command (m for help): p
Disk /dev/sdd: 400 GiB, 429496729600 bytes, 838860800 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xc433c1a8

Device     Boot Start       End   Sectors  Size Id Type
/dev/sdd1        2048 838860799 838858752  400G 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 40.5 -->> On Both Node (If Required)
[root@pdbdr1/pdbdr2 ~]# partprobe /dev/sdb
[root@pdbdr1/pdbdr2 ~]# partprobe /dev/sdc
[root@pdbdr1/pdbdr2 ~]# partprobe /dev/sdd
[root@pdbdr1/pdbdr2 ~]# partprobe /dev/sdb1
[root@pdbdr1/pdbdr2 ~]# partprobe /dev/sdc1
[root@pdbdr1/pdbdr2 ~]# partprobe /dev/sdd1

-- Step 40.6 -->> On Node 1
[root@pdbdr1 ~]# mkfs.xfs -f /dev/sdb1
[root@pdbdr1 ~]# mkfs.xfs -f /dev/sdc1
[root@pdbdr1 ~]# mkfs.xfs -f /dev/sdd1

-- Step 40.7 -->> On Both Node 
[root@pdbdr1/pdbdr2 ~]# fdisk -ll | grep -E "sdb|sdc|sdd"
/*
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
/dev/sdb1        2048 41943039 41940992  20G 83 Linux
Disk /dev/sdc: 200 GiB, 214748364800 bytes, 419430400 sectors
/dev/sdc1        2048 419430399 419428352  200G 83 Linux
Disk /dev/sdd: 400 GiB, 429496729600 bytes, 838860800 sectors
/dev/sdd1        2048 838860799 838858752  400G 83 Linux
*/

-- Step 40.8 -->> On Both Node 
[root@pdbdr1/pdbdr2 ~]# lsblk
/*
NAME               MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                  8:0    0  222G  0 disk
├─sda1               8:1    0    2G  0 part /boot
└─sda2               8:2    0  220G  0 part
  ├─ol_pdbdr1-root 253:0    0   70G  0 lvm  /
  ├─ol_pdbdr1-swap 253:1    0   20G  0 lvm  [SWAP]
  ├─ol_pdbdr1-usr  253:2    0   15G  0 lvm  /usr
  ├─ol_pdbdr1-tmp  253:3    0   15G  0 lvm  /tmp
  ├─ol_pdbdr1-var  253:4    0   15G  0 lvm  /var
  ├─ol_pdbdr1-home 253:5    0   15G  0 lvm  /home
  └─ol_pdbdr1-opt  253:6    0   70G  0 lvm  /opt
sdb                  8:16   0   20G  0 disk
└─sdb1               8:17   0   20G  0 part
sdc                  8:32   0  200G  0 disk
└─sdc1               8:33   0  200G  0 part
sdd                  8:48   0  400G  0 disk
└─sdd1               8:49   0  400G  0 part
sr0                 11:0    1 11.7G  0 rom
*/

-- Step 41 -->> On Both Node
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

-- Step 41.1 -->> On Both Node
-- Run the following command to change the current kernel parameters.
[root@pdbdr1/pdbdr2 ~]# sysctl -p /etc/sysctl.conf

-- Step 42 -->> On Both Node
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

-- Step 43 -->> On Both Node
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

-- Step 44 -->> On both Node
-- Create the new groups and users.
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:
*/

-- Step 44.1 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:
backupdba:x:54324:
dgdba:x:54325:
kmdba:x:54326:
pdbdba:x:54330:
*/

-- Step 44.2 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i oracle
/*
oracle:x:1000:
*/

-- Step 44.3 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i oper
/*
oper:x:54323:
*/

-- Step 44.4 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i asm

-- Step 44.5 -->> On both Node
-- 1.Create OS groups using the command below. Enter these commands as the 'root' user:
--[root@pdbdr1/pdbdr2 ~]# /usr/sbin/groupadd -g 503 oper
[root@pdbdr1/pdbdr2 ~]# /usr/sbin/groupadd -g 504 asmadmin
[root@pdbdr1/pdbdr2 ~]# /usr/sbin/groupadd -g 506 asmdba
[root@pdbdr1/pdbdr2 ~]# /usr/sbin/groupadd -g 507 asmoper
[root@pdbdr1/pdbdr2 ~]# /usr/sbin/groupadd -g 508 beoper

-- Step 44.6 -->> On both Node
-- 2.Create the users that will own the Oracle software using the commands:
[root@pdbdr1/pdbdr2 ~]# /usr/sbin/useradd  -g oinstall -G oinstall,dba,asmadmin,asmdba,asmoper,beoper grid
[root@pdbdr1/pdbdr2 ~]# /usr/sbin/usermod -g oinstall -G oinstall,dba,oper,asmdba,asmadmin,backupdba,dgdba,kmdba,racdba oracle

-- Step 44.7 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/

-- Step 44.8 -->> On both Node
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

-- Step 44.9 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i grid
/*
oinstall:x:54321:grid,oracle
dba:x:54322:grid,oracle
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 44.10 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i oper
/*
oper:x:54323:oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 44.11 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:grid,oracle
*/

-- Step 44.12 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:grid,oracle
backupdba:x:54324:oracle
dgdba:x:54325:oracle
kmdba:x:54326:oracle
pdbdba:x:54330:oracle
asmdba:x:506:grid,oracle
*/

-- Step 44.13 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/

-- Step 45 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# passwd oracle
/*
Changing password for user oracle.
New password: oracle
Retype new password: oracle
passwd: all authentication tokens updated successfully.
*/

-- Step 46 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# passwd grid
/*
Changing password for user grid.
New password: grid
Retype new password: grid
passwd: all authentication tokens updated successfully.
*/

-- Step 47 -->> On both Node
[root@pdbdr1/pdbdr2 ~]# su - oracle

-- Step 47.1 -->> On both Node
[oracle@pdbdr1/pdbdr2 ~]$ su - grid
/*
Password: grid
*/

-- Step 47.2 -->> On both Node
[grid@pdbdr1/pdbdr2 ~]$ su - oracle
/*
Password: oracle
*/

-- Step 47.3 -->> On both Node
[oracle@pdbdr1/pdbdr2 ~]$ exit
/*
logout
*/

-- Step 47.4 -->> On both Node
[grid@pdbdr1/pdbdr2 ~]$ exit
/*
logout
*/

-- Step 47.5 -->> On both Node
[oracle@pdbdr1/pdbdr2 ~]$ exit
/*
logout
*/

-- Step 48 -->> On both Node
--Create the Oracle Inventory Director:
[root@pdbdr1/pdbdr2 ~]# mkdir -p /opt/app/oraInventory
[root@pdbdr1/pdbdr2 ~]# chown -R grid:oinstall /opt/app/oraInventory
[root@pdbdr1/pdbdr2 ~]# chmod -R 775 /opt/app/oraInventory

-- Step 49 -->> On both Node
--Creating the Oracle Grid Infrastructure Home Directory:
[root@pdbdr1/pdbdr2 ~]# mkdir -p /opt/app/19c/grid
[root@pdbdr1/pdbdr2 ~]# chown -R grid:oinstall /opt/app/19c/grid
[root@pdbdr1/pdbdr2 ~]# chmod -R 775 /opt/app/19c/grid

-- Step 50 -->> On both Node
--Creating the Oracle Base Directory
[root@pdbdr1/pdbdr2 ~]#   mkdir -p /opt/app/oracle
[root@pdbdr1/pdbdr2 ~]#   chmod -R 775 /opt/app/oracle
[root@pdbdr1/pdbdr2 ~]#   cd /opt/app/
[root@pdbdr1/pdbdr2 app]# chown -R oracle:oinstall /opt/app/oracle

-- Step 51 -->> On Node 1
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

-- Step 51.1 -->> On Node 1
[oracle@pdbdr1 ~]$ . .bash_profile

-- Step 52 -->> On Node 1
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

-- Step 52.1 -->> On Node 1
[grid@pdbdr1 ~]$ . .bash_profile

-- Step 53 -->> On Node 2
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

-- Step 53.1 -->> On Node 2
[oracle@pdbdr2 ~]$ . .bash_profile

-- Step 54 -->> On Node 2
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

-- Step 54.1 -->> On Node 2
[grid@pdbdr2 ~]$ . .bash_profile

-- Step 55 -->> On Node 1
-- To Unzio The Oracle Grid Software and lateset Opatch
[root@pdbdr1 ~]# cd /opt/app/19c/grid/
[root@pdbdr1 grid]# unzip -oq /root/Oracle_19C/19.3.0.0.0_Grid_Binary/LINUX.X64_193000_grid_home.zip
[root@pdbdr1 grid]# unzip -oq /root/Oracle_19C/OPATCH_19c/p6880880_190000_Linux-x86-64.zip

-- Step 56 -->> On Node 1
-- To Unzio The Oracle PSU
[root@pdbdr1 ~]# cd /tmp/
[root@pdbdr1 tmp]# unzip -oq /root/Oracle_19C/PSU_19.27.0.0.0/p37591516_190000_Linux-x86-64.zip
[root@pdbdr1 tmp]# chown -R oracle:oinstall 37591516
[root@pdbdr1 tmp]# chmod -R 775 37591516
[root@pdbdr1 tmp]# ls -ltr | grep 37591516
/*
drwxrwxr-x  4 oracle oinstall      80 Apr 16 11:18 37591516
*/

-- Step 57 -->> On Node 1
-- Login as root user and issue the following command at pdbdr1
[root@pdbdr1 ~]# chown -R grid:oinstall /opt/app/19c/grid/
[root@pdbdr1 ~]# chmod -R 775 /opt/app/19c/grid/

-- Step 58 -->> On Node 1
[root@pdbdr1 tmp]# su - grid
[grid@pdbdr1 ~]$ cd /opt/app/19c/grid/OPatch/
[grid@pdbdr1 OPatch]$ ./opatch version
/*
OPatch Version: 12.2.0.1.46

OPatch succeeded.
*/

-- Step 59 -->> On Node 1
[root@pdbdr1 ~]# scp -r /opt/app/19c/grid/cv/rpm/cvuqdisk-1.0.10-1.rpm root@pdbdr2:/tmp/
/*
root@pdbdr2's password: P@ssw0rd
cvuqdisk-1.0.10-1.rpm                                      100%   11KB   6.3MB/s   00:00
*/

-- Step 60 -->> On Node 1
-- To install the cvuqdisk-1.0.10-1.rpm
-- Login from root user
[root@pdbdr1 ~]# cd /opt/app/19c/grid/cv/rpm/

-- Step 60.1 -->> On Node 1
[root@pdbdr1 rpm]# ls -ltr
/*
-rwxrwxr-x 1 grid oinstall 11412 Mar 13  2019 cvuqdisk-1.0.10-1.rpm
*/

-- Step 60.2 -->> On Node 1
[root@pdbdr1 rpm]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP

-- Step 60.3 -->> On Node 1
[root@pdbdr1 rpm]# rpm -iUvh cvuqdisk-1.0.10-1.rpm 
/*
Preparing...                          ################################# [100%]
Updating / installing...
   1:cvuqdisk-1.0.10-1                ################################# [100%]
*/

-- Step 61 -->> On Node 2
[root@pdbdr2 ~]# cd /tmp/
[root@pdbdr2 tmp]# chown -R grid:oinstall cvuqdisk-1.0.10-1.rpm
[root@pdbdr2 tmp]# chmod -R 775 cvuqdisk-1.0.10-1.rpm
[root@pdbdr2 tmp]# ls -ltr | grep cvuqdisk-1.0.10-1.rpm
/*
-rwxrwxr-x  1 grid oinstall 11412 May 23 11:12 cvuqdisk-1.0.10-1.rpm
*/

-- Step 61.1 -->> On Node 2
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

-- Step 62 -->> On Node 1
-- Bug 30286976: To Solve the Pre-check or any Oracle relavant Installation for rac Setup make compatible version CV_ASSUME_DISTID=OEL7.8
[grid@pdbdr1 ~]$ vi /opt/app/19c/grid/cv/admin/cvu_config
/*
# Fallback to this distribution id
CV_ASSUME_DISTID=OEL7.8
*/

-- Step 62.1 -->> On Node 1
[grid@pdbdr1 ~]$ cat /opt/app/19c/grid/cv/admin/cvu_config | grep -E CV_ASSUME_DISTID
/*
CV_ASSUME_DISTID=OEL7.8
*/

-- Step 63 -->> On Node 1
-- To setup SSH Pass
--Fix: Manually Create a Valid 2048-bit RSA Key for grid User
--Step 1: Remove the 1024-bit Key
[grid@pdbdr1/pdbdr2 ~]$ rm -f ~/.ssh/id_rsa ~/.ssh/id_rsa.pub
[grid@pdbdr1/pdbdr2 ~]$ ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
[grid@pdbdr1/pdbdr2 ~]$ cat ~/.ssh/id_rsa.pub  --# Should start with "ssh-rsa AAAA..."
[grid@pdbdr1/pdbdr2 ~]$ chmod 700 ~/.ssh
[grid@pdbdr1/pdbdr2 ~]$ chmod 600 ~/.ssh/id_rsa
[grid@pdbdr1/pdbdr2 ~]$ chmod 644 ~/.ssh/id_rsa.pub

-- Step 63.1 -->> On Both Node, Manually Copy the Key to Remote Hosts
[grid@pdbdr1/pdbdr2 ~]$ ssh-copy-id grid@pdbdr1
[grid@pdbdr1/pdbdr2 ~]$ ssh-copy-id grid@pdbdr2
--OR--
[grid@pdbdr1/pdbdr2 ~]$ cat ~/.ssh/id_rsa.pub | ssh grid@pdbdr1 'cat >> ~/.ssh/authorized_keys'
[grid@pdbdr1/pdbdr2 ~]$ cat ~/.ssh/id_rsa.pub | ssh grid@pdbdr2 'cat >> ~/.ssh/authorized_keys'

-- Step 63.2 -->> On Both Node
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@pdbdr1 date
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@pdbdr2 date
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@pdbdr1 date && ssh grid@pdbdr2 date
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@pdbdr1.unidev.org.np date
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@pdbdr2.unidev.org.np date
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@pdbdr1.unidev.org.np date && ssh grid@pdbdr2.unidev.org.np date
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@192.168.6.48 date
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@192.168.6.49 date
[grid@pdbdr1/pdbdr2 ~]$ ssh grid@192.168.6.48 date && ssh grid@192.168.6.49 date

-- Step 64 -->> On Node 1 (Enable Oracle ASM Filter Driver)
[grid@pdbdr1 ~]$ cd /opt/app/19c/grid/
[grid@pdbdr1 grid]$ export CV_ASSUME_DISTID=OEL7.8
[grid@pdbdr1 grid]$ ./OPatch/opatch version
/*
OPatch Version: 12.2.0.1.46

OPatch succeeded.
*/

-- Step 64.1 -->> On Node 1 (Enable Oracle ASM Filter Driver)
[grid@pdbdr1 grid]$ ./bin/afddriverstate supported
/*
AFD-620: AFD is not supported on this operating system version: 'unknown'
AFD-9201: Not Supported
*/

-- Step 64.2 -->> On Node 1 (Enable Oracle ASM Filter Driver)
[grid@pdbdr1 ~]$ cd /opt/app/19c/grid
[grid@pdbdr1 grid]$ export CV_ASSUME_DISTID=OEL7.8
[grid@pdbdr1 grid]$ ./gridSetup.sh -silent -applyRU /tmp/37591516/37641958
/*
Preparing the home to patch...
Applying the patch /tmp/37591516/37641958...
Successfully applied the patch.
The log can be found at: /tmp/GridSetupActions2025-05-23_11-37-03AM/installerPatchActions_2025-05-23_11-37-03AM.log
Launching Oracle Grid Infrastructure Setup Wizard...

[FATAL] [INS-40426] Grid installation option has not been specified.
   ACTION: Specify the valid installation option.
*/

-- Step 64.3 -->> On Node 1 (Enabled Oracle ASM Filter Driver)
[grid@pdbdr1 ~]$ cd /opt/app/19c/grid/
[grid@pdbdr1 grid]$ ./bin/afddriverstate supported
/*
AFD-9200: Supported
*/

-- Step 64.4 -->> On Node 1 (Enabled Oracle ASM Filter Driver)
[grid@pdbdr1 grid]$ ./bin/afdroot version_check
/*
AFD-616: Valid AFD distribution media detected at: '/opt/app/19c/grid/usm/install/Oracle/EL9/x86_64/5.14.0-503.11.1/5.14.0-503.11.1-x86_64/bin'
*/

-- Step 65 -->> On Node 1 (Lable Disks as Oracle ASM Filter Driver)
[root@pdbdr1 ~]# vi /opt/app/19c/grid/bin/kfod
/*
#OHOME=/u01/app/19.0.0/grid
OHOME=/opt/app/19c/grid
ORACLE_HOME=${OHOME}
export ORACLE_HOME

exec $OHOME/bin/kfod.bin "$@"
*/

-- Step 00 -->> On Node 1 (Lable Disks as Oracle ASM Filter Driver)
-- To drop AFD Labels when somithing going wrong
/*
[root@pdbdr1 ~]# mount | grep ARC1
[root@pdbdr1 ~]# fuser -v /dev/mapper/ARC1
[root@pdbdr1 ~]# lsof | grep ARC1
[root@pdbdr1 ~]# wipefs -a /dev/mapper/OCR1
[root@pdbdr1 ~]# wipefs -a /dev/mapper/DATA1
[root@pdbdr1 ~]# wipefs -a /dev/mapper/ARC1
[root@pdbdr1 ~]# dd if=/dev/zero of=/dev/mapper/OCR1 bs=1M count=10
[root@pdbdr1 ~]# dd if=/dev/zero of=/dev/mapper/DATA1 bs=1M count=10
[root@pdbdr1 ~]# dd if=/dev/zero of=/dev/mapper/ARC1 bs=1M count=10
[root@pdbdr1 ~]# init 6
*/

-- Step 65.1 -->> On Node 1 (Lable Disks as Oracle ASM Filter Driver)
[root@pdbdr1 ~]# lsblk
/*
NAME               MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                  8:0    0  222G  0 disk
├─sda1               8:1    0    2G  0 part /boot
└─sda2               8:2    0  220G  0 part
  ├─ol_pdbdr1-root 253:0    0   70G  0 lvm  /
  ├─ol_pdbdr1-swap 253:1    0   20G  0 lvm  [SWAP]
  ├─ol_pdbdr1-usr  253:2    0   15G  0 lvm  /usr
  ├─ol_pdbdr1-tmp  253:3    0   15G  0 lvm  /tmp
  ├─ol_pdbdr1-var  253:4    0   15G  0 lvm  /var
  ├─ol_pdbdr1-home 253:5    0   15G  0 lvm  /home
  └─ol_pdbdr1-opt  253:6    0   70G  0 lvm  /opt
sdb                  8:16   0   20G  0 disk
└─sdb1               8:17   0   20G  0 part
sdc                  8:32   0  200G  0 disk
└─sdc1               8:33   0  200G  0 part
sdd                  8:48   0  400G  0 disk
└─sdd1               8:49   0  400G  0 part
sr0                 11:0    1 1024M  0 rom
*/

-- Step 65.2 -->> On Node 1 (Lable Disks as Oracle ASM Filter Driver)
[root@pdbdr1 ~]# export ORACLE_HOME=/opt/app/19c/grid
[root@pdbdr1 ~]# export CV_ASSUME_DISTID=OEL7.8
[root@pdbdr1 ~]# export ORACLE_BASE=/opt/app/oracle

-- Step 65.3 -->> On Node 1 (Lable Disks as Oracle ASM Filter Driver)
[root@pdbdr1 ~]# /opt/app/19c/grid/bin/asmcmd afd_label OCR /dev/sdb1 --init
/*
ASMCMD-9463: [/var/tmp/.oracle]
*/

-- Step 65.4 -->> On Node 1 (Lable Disks as Oracle ASM Filter Driver)
[root@pdbdr1 ~]# /opt/app/19c/grid/bin/asmcmd afd_label DATA /dev/sdc1 --init
/*
ASMCMD-9463: [/var/tmp/.oracle]
*/

-- Step 65.5 -->> On Node 1 (Lable Disks as Oracle ASM Filter Driver)
[root@pdbdr1 ~]# /opt/app/19c/grid/bin/asmcmd afd_label ARC /dev/sdd1 --init
/*
ASMCMD-9463: [/var/tmp/.oracle]
*/

-- Step 65.6 -->> On Node 1 (Verify Diskes as Oracle ASM Filter Driver)
[root@pdbdr1 ~]# ll /dev/oracleafd/disks/*
/*
-rw-rw-r-- 1 grid oinstall 34 May 23 12:01 /dev/oracleafd/disks/ARC
-rw-rw-r-- 1 grid oinstall 34 May 23 12:01 /dev/oracleafd/disks/DATA
-rw-rw-r-- 1 grid oinstall 33 May 23 12:01 /dev/oracleafd/disks/OCR
*/

-- Step 65.7 -->> On Node 1 (Verify Diskes as Oracle ASM Filter Driver)
[root@pdbdr1 ~]# ll /dev/oracleafd/disks/
/*
-rw-rw-r-- 1 grid oinstall 34 May 23 12:01 ARC
-rw-rw-r-- 1 grid oinstall 34 May 23 12:01 DATA
-rw-rw-r-- 1 grid oinstall 33 May 23 12:01 OCR
*/

-- Step 65.8 -->> On Node 1 (Verify Diskes as Oracle ASM Filter Driver)
[root@pdbdr1 ~]# export ORACLE_HOME=/opt/app/19c/grid
[root@pdbdr1 ~]# export CV_ASSUME_DISTID=OEL7.8
[root@pdbdr1 ~]# export ORACLE_BASE=/opt/app/oracle
[root@pdbdr1 ~]# /opt/app/19c/grid/bin/asmcmd afd_lslbl
/*
ASMCMD-9463: [/var/tmp/.oracle]
Could not open pfile '/etc/oracleafd.conf'--------------------------------------------------------------------------------
Label                     Duplicate  Path
================================================================================
ARC                                   /dev/sdd1
DATA                                  /dev/sdc1
OCR                                   /dev/sdb1
*/

-- Step 66 -->> On Node 1
[grid@pdbdr1 ~]$ cd /opt/app/19c/grid/
[grid@pdbdr1 grid]$ export CV_ASSUME_DISTID=OEL7.8
[grid@pdbdr1 grid]$ ./runcluvfy.sh stage -pre crsinst -n pdbdr1,pdbdr2 -verbose
/*
Performing following verification checks ...

  Physical Memory ...
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdbdr2        19.0928GB (2.002028E7KB)  8GB (8388608.0KB)         passed
  pdbdr1        19.0928GB (2.0020284E7KB)  8GB (8388608.0KB)         passed
  Physical Memory ...PASSED
  Available Physical Memory ...
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdbdr2        18.1934GB (1.9077196E7KB)  50MB (51200.0KB)          passed
  pdbdr1        17.7103GB (1.857062E7KB)  50MB (51200.0KB)          passed
  Available Physical Memory ...PASSED
  Swap Size ...
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdbdr2        19.9961GB (2.096742E7KB)  16GB (1.6777216E7KB)      passed
  pdbdr1        19.9961GB (2.096742E7KB)  16GB (1.6777216E7KB)      passed
  Swap Size ...PASSED
  Free Space: pdbdr2:/usr,pdbdr2:/sbin ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /usr              pdbdr2        /usr          8.2109GB      25MB          passed
  /sbin             pdbdr2        /usr          8.2109GB      10MB          passed
  Free Space: pdbdr2:/usr,pdbdr2:/sbin ...PASSED
  Free Space: pdbdr2:/var ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /var              pdbdr2        /var          13.9609GB     5MB           passed
  Free Space: pdbdr2:/var ...PASSED
  Free Space: pdbdr2:/etc ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /etc              pdbdr2        /             72.7461GB     25MB          passed
  Free Space: pdbdr2:/etc ...PASSED
  Free Space: pdbdr2:/tmp ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /tmp              pdbdr2        /tmp          15.5059GB     1GB           passed
  Free Space: pdbdr2:/tmp ...PASSED
  Free Space: pdbdr1:/usr,pdbdr1:/sbin ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /usr              pdbdr1        /usr          8.2109GB      25MB          passed
  /sbin             pdbdr1        /usr          8.2109GB      10MB          passed
  Free Space: pdbdr1:/usr,pdbdr1:/sbin ...PASSED
  Free Space: pdbdr1:/var ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /var              pdbdr1        /var          13.9482GB     5MB           passed
  Free Space: pdbdr1:/var ...PASSED
  Free Space: pdbdr1:/etc ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /etc              pdbdr1        /             60.2197GB     25MB          passed
  Free Space: pdbdr1:/etc ...PASSED
  Free Space: pdbdr1:/tmp ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /tmp              pdbdr1        /tmp          7.9414GB      1GB           passed
  Free Space: pdbdr1:/tmp ...PASSED
  User Existence: grid ...
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdbdr2        passed                    exists(1001)
  pdbdr1        passed                    exists(1001)

    Users With Same UID: 1001 ...PASSED
  User Existence: grid ...PASSED
  Group Existence: asmadmin ...
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdbdr2        passed                    exists
  pdbdr1        passed                    exists
  Group Existence: asmadmin ...PASSED
  Group Existence: asmdba ...
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdbdr2        passed                    exists
  pdbdr1        passed                    exists
  Group Existence: asmdba ...PASSED
  Group Existence: oinstall ...
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdbdr2        passed                    exists
  pdbdr1        passed                    exists
  Group Existence: oinstall ...PASSED
  Group Membership: asmdba ...
  Node Name         User Exists   Group Exists  User in Group  Status
  ----------------  ------------  ------------  ------------  ----------------
  pdbdr2            yes           yes           yes           passed
  pdbdr1            yes           yes           yes           passed
  Group Membership: asmdba ...PASSED
  Group Membership: asmadmin ...
  Node Name         User Exists   Group Exists  User in Group  Status
  ----------------  ------------  ------------  ------------  ----------------
  pdbdr2            yes           yes           yes           passed
  pdbdr1            yes           yes           yes           passed
  Group Membership: asmadmin ...PASSED
  Group Membership: oinstall(Primary) ...
  Node Name         User Exists   Group Exists  User in Group  Primary       Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  pdbdr2            yes           yes           yes           yes           passed
  pdbdr1            yes           yes           yes           yes           passed
  Group Membership: oinstall(Primary) ...PASSED
  Run Level ...
  Node Name     run level                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdbdr2        5                         3,5,3,5                   passed
  pdbdr1        5                         3,5,3,5                   passed
  Run Level ...PASSED
  Hard Limit: maximum open file descriptors ...
  Node Name         Type          Available     Required      Status
  ----------------  ------------  ------------  ------------  ----------------
  pdbdr2            hard          65536         65536         passed
  pdbdr1            hard          65536         65536         passed
  Hard Limit: maximum open file descriptors ...PASSED
  Soft Limit: maximum open file descriptors ...
  Node Name         Type          Available     Required      Status
  ----------------  ------------  ------------  ------------  ----------------
  pdbdr2            soft          65536         1024          passed
  pdbdr1            soft          65536         1024          passed
  Soft Limit: maximum open file descriptors ...PASSED
  Hard Limit: maximum user processes ...
  Node Name         Type          Available     Required      Status
  ----------------  ------------  ------------  ------------  ----------------
  pdbdr2            hard          16384         16384         passed
  pdbdr1            hard          16384         16384         passed
  Hard Limit: maximum user processes ...PASSED
  Soft Limit: maximum user processes ...
  Node Name         Type          Available     Required      Status
  ----------------  ------------  ------------  ------------  ----------------
  pdbdr2            soft          16384         2047          passed
  pdbdr1            soft          16384         2047          passed
  Soft Limit: maximum user processes ...PASSED
  Soft Limit: maximum stack size ...
  Node Name         Type          Available     Required      Status
  ----------------  ------------  ------------  ------------  ----------------
  pdbdr2            soft          10240         10240         passed
  pdbdr1            soft          10240         10240         passed
  Soft Limit: maximum stack size ...PASSED
  Users With Same UID: 0 ...PASSED
  Current Group ID ...PASSED
  Root user consistency ...
  Node Name                             Status
  ------------------------------------  ------------------------
  pdbdr2                                passed
  pdbdr1                                passed
  Root user consistency ...PASSED
  Package: cvuqdisk-1.0.10-1 ...
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdbdr2        cvuqdisk-1.0.10-1         cvuqdisk-1.0.10-1         passed
  pdbdr1        cvuqdisk-1.0.10-1         cvuqdisk-1.0.10-1         passed
  Package: cvuqdisk-1.0.10-1 ...PASSED
  Package: psmisc-22.6-19 ...
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdbdr2        psmisc-23.4-3.el9         psmisc-22.6-19            passed
  pdbdr1        psmisc-23.4-3.el9         psmisc-22.6-19            passed
  Package: psmisc-22.6-19 ...PASSED
  Host name ...PASSED
  Node Connectivity ...
    Hosts File ...
  Node Name                             Status
  ------------------------------------  ------------------------
  pdbdr1                                passed
  pdbdr2                                passed
    Hosts File ...PASSED

Interface information for node "pdbdr2"

 Name   IP Address      Subnet          Gateway         Def. Gateway    HW Address        MTU
 ------ --------------- --------------- --------------- --------------- ----------------- ------
 ens192 192.168.6.49     192.168.6.0      0.0.0.0         192.168.6.1      00:0C:29:59:8F:68 1500
 ens224 10.10.10.49     10.10.10.0      0.0.0.0         192.168.6.1      00:0C:29:59:8F:72 1500

Interface information for node "pdbdr1"

 Name   IP Address      Subnet          Gateway         Def. Gateway    HW Address        MTU
 ------ --------------- --------------- --------------- --------------- ----------------- ------
 ens192 192.168.6.48     192.168.6.0      0.0.0.0         192.168.6.1      00:0C:29:F5:C8:22 1500
 ens224 10.10.10.48     10.10.10.0      0.0.0.0         192.168.6.1      00:0C:29:F5:C8:2C 1500

Check: MTU consistency of the subnet "10.10.10.0".

  Node              Name          IP Address    Subnet        MTU
  ----------------  ------------  ------------  ------------  ----------------
  pdbdr2            ens224        10.10.10.49   10.10.10.0    1500
  pdbdr1            ens224        10.10.10.48   10.10.10.0    1500

Check: MTU consistency of the subnet "192.168.6.0".

  Node              Name          IP Address    Subnet        MTU
  ----------------  ------------  ------------  ------------  ----------------
  pdbdr2            ens192        192.168.6.49   192.168.6.0    1500
  pdbdr1            ens192        192.168.6.48   192.168.6.0    1500
    Check that maximum (MTU) size packet goes through subnet ...PASSED

  Source                          Destination                     Connected?
  ------------------------------  ------------------------------  ----------------
  pdbdr1[ens224:10.10.10.48]      pdbdr2[ens224:10.10.10.49]      yes

  Source                          Destination                     Connected?
  ------------------------------  ------------------------------  ----------------
  pdbdr1[ens192:192.168.6.48]      pdbdr2[ens192:192.168.6.49]      yes
    subnet mask consistency for subnet "10.10.10.0" ...PASSED
    subnet mask consistency for subnet "192.168.6.0" ...PASSED
  Node Connectivity ...PASSED
  Multicast or broadcast check ...
Checking subnet "10.10.10.0" for multicast communication with multicast group "224.0.0.251"
  Multicast or broadcast check ...PASSED
  Network Time Protocol (NTP) ...
    '/etc/chrony.conf' ...
  Node Name                             File exists?
  ------------------------------------  ------------------------
  pdbdr2                                yes
  pdbdr1                                yes

    '/etc/chrony.conf' ...PASSED
    Daemon 'chronyd' ...
  Node Name                             Running?
  ------------------------------------  ------------------------
  pdbdr2                                yes
  pdbdr1                                yes

    Daemon 'chronyd' ...PASSED
    NTP daemon or service using UDP port 123 ...
  Node Name                             Port Open?
  ------------------------------------  ------------------------
  pdbdr2                                yes
  pdbdr1                                yes

    NTP daemon or service using UDP port 123 ...PASSED
    chrony daemon is synchronized with at least one external time source ...PASSED
  Network Time Protocol (NTP) ...PASSED
  Same core file name pattern ...PASSED
  User Mask ...
  Node Name     Available                 Required                  Comment
  ------------  ------------------------  ------------------------  ----------
  pdbdr2        0022                      0022                      passed
  pdbdr1        0022                      0022                      passed
  User Mask ...PASSED
  User Not In Group "root": grid ...
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdbdr2        passed                    does not exist
  pdbdr1        passed                    does not exist
  User Not In Group "root": grid ...PASSED
  Time zone consistency ...PASSED
  Path existence, ownership, permissions and attributes ...
    Path "/var" ...PASSED
    Path "/dev/shm" ...PASSED
  Path existence, ownership, permissions and attributes ...PASSED
  Time offset between nodes ...PASSED
  resolv.conf Integrity ...
  Node Name                             Status
  ------------------------------------  ------------------------
  pdbdr1                                passed
  pdbdr2                                passed

checking response for name "pdbdr2" from each of the name servers specified in
"/etc/resolv.conf"

  Node Name     Source                    Comment                   Status
  ------------  ------------------------  ------------------------  ----------
  pdbdr2        127.0.0.1                 IPv4                      passed
  pdbdr2        192.168.4.11               IPv4                      passed
  pdbdr2        192.168.4.12               IPv4                      passed

checking response for name "pdbdr1" from each of the name servers specified in
"/etc/resolv.conf"

  Node Name     Source                    Comment                   Status
  ------------  ------------------------  ------------------------  ----------
  pdbdr1        127.0.0.1                 IPv4                      passed
  pdbdr1        192.168.4.11               IPv4                      passed
  pdbdr1        192.168.4.12               IPv4                      passed
  resolv.conf Integrity ...PASSED
  DNS/NIS name service ...PASSED
  Domain Sockets ...PASSED
  Daemon "avahi-daemon" not configured and running ...
  Node Name     Configured                Status
  ------------  ------------------------  ------------------------
  pdbdr2        no                        passed
  pdbdr1        no                        passed

  Node Name     Running?                  Status
  ------------  ------------------------  ------------------------
  pdbdr2        no                        passed
  pdbdr1        no                        passed
  Daemon "avahi-daemon" not configured and running ...PASSED
  Daemon "proxyt" not configured and running ...
  Node Name     Configured                Status
  ------------  ------------------------  ------------------------
  pdbdr2        no                        passed
  pdbdr1        no                        passed

  Node Name     Running?                  Status
  ------------  ------------------------  ------------------------
  pdbdr2        no                        passed
  pdbdr1        no                        passed
  Daemon "proxyt" not configured and running ...PASSED
  User Equivalence ...PASSED
  RPM Package Manager database ...INFORMATION (PRVG-11250)
  Maximum locked memory check ...PASSED
  /dev/shm mounted as temporary file system ...PASSED
  File system mount options for path /var ...PASSED
  DefaultTasksMax parameter ...PASSED
  zeroconf check ...PASSED
  ASM Filter Driver configuration ...PASSED
  Systemd login manager IPC parameter ...PASSED
  ORAchk checks ...INFORMATION (PRVH-1507)

Pre-check for cluster services setup was successful.
RPM Package Manager database ...INFORMATION
PRVG-11250 : The check "RPM Package Manager database" was not performed because
it needs 'root' user privileges.

Refer to My Oracle Support notes "2548970.1" for more details regarding errors
PRVG-11250".

ORAchk checks ...INFORMATION
PRVH-1507 : ORAchk/EXAchk checks are skipped.


CVU operation performed:      stage -pre crsinst
Date:                         May 23, 2025 12:05:02 PM
CVU version:                  19.27.0.0.0 (041025x8664)
CVU home:                     /opt/app/19c/grid
User:                         grid
Operating system:             Linux5.14.0-503.11.1.el9_5.x86_64
*/

-- Step 67 -->> On Node 1
-- To Create a Response File to Install GID
[grid@pdbdr1 ~]$ cp /opt/app/19c/grid/install/response/gridsetup.rsp /home/grid/
[grid@pdbdr1 ~]$ cd /home/grid/
[grid@pdbdr1 ~]$ ls -ltr | grep gridsetup.rsp
/*
-rwxr-xr-x 1 grid oinstall 36221 Sep 29 14:33 gridsetup.rsp
*/

-- Step 67.1 -->> On Node 1
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
oracle.install.crs.config.networkInterfaceList=ens192:192.168.6.0:1,ens224:10.10.10.0:5
oracle.install.crs.configureGIMR=false
oracle.install.asm.configureGIMRDataDG=false
oracle.install.crs.config.storageOption=FLEX_ASM_STORAGE
oracle.install.crs.config.useIPMI=false
oracle.install.asm.SYSASMPassword=Sys605014
oracle.install.asm.diskGroup.name=OCR
oracle.install.asm.diskGroup.redundancy=EXTERNAL
oracle.install.asm.diskGroup.AUSize=4
oracle.install.asm.diskGroup.disks=/dev/sdb1
oracle.install.asm.diskGroup.diskDiscoveryString=/dev/sd*
oracle.install.asm.monitorPassword=Sys605014
oracle.install.asm.configureAFD=true
oracle.install.crs.configureRHPS=false
oracle.install.crs.config.ignoreDownNodes=false
oracle.install.config.managementOption=NONE
oracle.install.config.omsPort=0
oracle.install.crs.rootconfig.executeRootScript=false
*/

-- Step 68 -->> On Node 1
[grid@pdbdr1 ~]$ cd /opt/app/19c/grid/
[grid@pdbdr1 grid]$ OPatch/opatch version
/*
OPatch Version: 12.2.0.1.46

OPatch succeeded.
*/

-- Step 68.1 -->> On Node 1
-- To Install Grid Software with Leteset Opatch
[grid@pdbdr1 ~]$ cd /opt/app/19c/grid/
[grid@pdbdr1 grid]$ export CV_ASSUME_DISTID=OEL7.8
[grid@pdbdr1 grid]$ ./gridSetup.sh -ignorePrereq -waitForCompletion -silent -applyRU /tmp/37591516/37641958 -responseFile /home/grid/gridsetup.rsp
/*
Preparing the home to patch...
Applying the patch /tmp/37591516/37641958...
Successfully applied the patch.
The log can be found at: /tmp/GridSetupActions2025-05-23_12-43-40PM/installerPatchActions_2025-05-23_12-43-40PM.log
Launching Oracle Grid Infrastructure Setup Wizard...

[WARNING] [INS-40109] The specified Oracle Base location is not empty on this server.
   ACTION: Specify an empty location for Oracle Base.
[WARNING] [INS-13014] Target environment does not meet some optional requirements.
   CAUSE: Some of the optional prerequisites are not met. See logs for details. gridSetupActions2025-05-23_12-43-40PM.log
   ACTION: Identify the list of failed prerequisite checks from the log: gridSetupActions2025-05-23_12-43-40PM.log. Then either from the log file or from installation manual find the appropriate configuration to meet the prerequisites and fix it manually.
The response file for this session can be found at:
 /opt/app/19c/grid/install/response/grid_2025-05-23_12-43-40PM.rsp

You can find the log of this install session at:
 /tmp/GridSetupActions2025-05-23_12-43-40PM/gridSetupActions2025-05-23_12-43-40PM.log

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
 /opt/app/oraInventory/logs/GridSetupActions2025-05-23_12-43-40PM
*/

-- Step 68.2 -->> On Node 1
[root@pdbdr1 ~]# /opt/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 68.3 -->> On Node 2
[root@pdbdr2 ~]# /opt/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 68.4 -->> On Node 1
[root@pdbdr1 ~]# /opt/app/19c/grid/root.sh
/*
Check /opt/app/19c/grid/install/root_pdbdr1.unidev.org.np_2025-05-23_12-56-26-269393957.log for the output of root script
*/

-- Step 68.5 -->> On Node 1
[root@pdbdr1 ~]#  tail -f  /opt/app/19c/grid/install/root_pdbdr1.unidev.org.np_2025-05-23_12-56-26-269393957.log
/*
Creating /etc/oratab file...
Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Relinking oracle with rac_on option
Using configuration parameter file: /opt/app/19c/grid/crs/install/crsconfig_params
The log of current session can be found at:
  /opt/app/oracle/crsdata/pdbdr1/crsconfig/rootcrs_pdbdr1_2025-05-23_12-56-54AM.log
2025/05/23 12:57:09 CLSRSC-594: Executing installation step 1 of 19: 'ValidateEnv'.
2025/05/23 12:57:09 CLSRSC-363: User ignored prerequisites during installation
2025/05/23 12:57:10 CLSRSC-594: Executing installation step 2 of 19: 'CheckFirstNode'.
2025/05/23 12:57:12 CLSRSC-594: Executing installation step 3 of 19: 'GenSiteGUIDs'.
2025/05/23 12:57:14 CLSRSC-594: Executing installation step 4 of 19: 'SetupOSD'.
Redirecting to /bin/systemctl restart rsyslog.service
2025/05/23 12:57:14 CLSRSC-594: Executing installation step 5 of 19: 'CheckCRSConfig'.
2025/05/23 12:57:14 CLSRSC-594: Executing installation step 6 of 19: 'SetupLocalGPNP'.
2025/05/23 12:57:33 CLSRSC-594: Executing installation step 7 of 19: 'CreateRootCert'.
2025/05/23 12:57:40 CLSRSC-594: Executing installation step 8 of 19: 'ConfigOLR'.
2025/05/23 12:58:03 CLSRSC-594: Executing installation step 9 of 19: 'ConfigCHMOS'.
2025/05/23 12:58:03 CLSRSC-594: Executing installation step 10 of 19: 'CreateOHASD'.
2025/05/23 12:58:12 CLSRSC-594: Executing installation step 11 of 19: 'ConfigOHASD'.
2025/05/23 12:58:12 CLSRSC-330: Adding Clusterware entries to file 'oracle-ohasd.service'
2025/05/23 12:58:45 CLSRSC-594: Executing installation step 12 of 19: 'SetupTFA'.
2025/05/23 12:58:45 CLSRSC-594: Executing installation step 13 of 19: 'InstallAFD'.
2025/05/23 12:59:21 CLSRSC-594: Executing installation step 14 of 19: 'InstallACFS'.
2025/05/23 12:59:54 CLSRSC-594: Executing installation step 15 of 19: 'InstallKA'.
2025/05/23 13:00:02 CLSRSC-594: Executing installation step 16 of 19: 'InitConfig'.
2025/05/23 13:00:18 CLSRSC-4002: Successfully installed Oracle Trace File Analyzer (TFA) Collector.

[INFO] [DBT-30161] Disk label(s) created successfully. Check /opt/app/oracle/cfgtoollogs/asmca/asmca-250523PM010031.log for details.


2025/05/23 13:01:25 CLSRSC-482: Running command: '/opt/app/19c/grid/bin/ocrconfig -upgrade grid oinstall'
CRS-4256: Updating the profile
Successful addition of voting disk e6caf31d22844fb4bffe6abe73efebb0.
Successfully replaced voting disk group with +OCR.
CRS-4256: Updating the profile
CRS-4266: Voting file(s) successfully replaced
##  STATE    File Universal Id                File Name Disk group
--  -----    -----------------                --------- ---------
 1. ONLINE   e6caf31d22844fb4bffe6abe73efebb0 (AFD:OCR) [OCR]
Located 1 voting disk(s).
2025/05/23 13:02:43 CLSRSC-594: Executing installation step 17 of 19: 'StartCluster'.
2025/05/23 13:03:45 CLSRSC-343: Successfully started Oracle Clusterware stack
2025/05/23 13:03:45 CLSRSC-594: Executing installation step 18 of 19: 'ConfigNode'.
2025/05/23 13:05:32 CLSRSC-594: Executing installation step 19 of 19: 'PostConfig'.
2025/05/23 13:06:06 CLSRSC-325: Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 68.6 -->> On Node 2
[root@pdbdr2 ~]# /opt/app/19c/grid/root.sh
/*
Check /opt/app/19c/grid/install/root_pdbdr2.unidev.org.np_2025-05-23_13-07-34-910993097.log for the output of root script
*/

-- Step 68.7 -->> On Node 2 
[root@pdbdr2 ~]# tail -f /opt/app/19c/grid/install/root_pdbdr2.unidev.org.np_2025-05-23_13-07-34-910993097.log
/*
Creating /etc/oratab file...
Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Relinking oracle with rac_on option
Using configuration parameter file: /opt/app/19c/grid/crs/install/crsconfig_params
The log of current session can be found at:
  /opt/app/oracle/crsdata/pdbdr2/crsconfig/rootcrs_pdbdr2_2025-05-23_01-08-06PM.log
2025/05/23 13:08:13 CLSRSC-594: Executing installation step 1 of 19: 'ValidateEnv'.
2025/05/23 13:08:13 CLSRSC-363: User ignored prerequisites during installation
2025/05/23 13:08:13 CLSRSC-594: Executing installation step 2 of 19: 'CheckFirstNode'.
2025/05/23 13:08:15 CLSRSC-594: Executing installation step 3 of 19: 'GenSiteGUIDs'.
2025/05/23 13:08:15 CLSRSC-594: Executing installation step 4 of 19: 'SetupOSD'.
Redirecting to /bin/systemctl restart rsyslog.service
2025/05/23 13:08:16 CLSRSC-594: Executing installation step 5 of 19: 'CheckCRSConfig'.
2025/05/23 13:08:17 CLSRSC-594: Executing installation step 6 of 19: 'SetupLocalGPNP'.
2025/05/23 13:08:19 CLSRSC-594: Executing installation step 7 of 19: 'CreateRootCert'.
2025/05/23 13:08:19 CLSRSC-594: Executing installation step 8 of 19: 'ConfigOLR'.
2025/05/23 13:08:35 CLSRSC-594: Executing installation step 9 of 19: 'ConfigCHMOS'.
2025/05/23 13:08:35 CLSRSC-594: Executing installation step 10 of 19: 'CreateOHASD'.
2025/05/23 13:08:37 CLSRSC-594: Executing installation step 11 of 19: 'ConfigOHASD'.
2025/05/23 13:08:38 CLSRSC-330: Adding Clusterware entries to file 'oracle-ohasd.service'
2025/05/23 13:09:06 CLSRSC-594: Executing installation step 12 of 19: 'SetupTFA'.
2025/05/23 13:09:06 CLSRSC-594: Executing installation step 13 of 19: 'InstallAFD'.
2025/05/23 13:09:43 CLSRSC-594: Executing installation step 14 of 19: 'InstallACFS'.
2025/05/23 13:10:40 CLSRSC-594: Executing installation step 15 of 19: 'InstallKA'.
2025/05/23 13:10:47 CLSRSC-594: Executing installation step 16 of 19: 'InitConfig'.
2025/05/23 13:11:29 CLSRSC-4002: Successfully installed Oracle Trace File Analyzer (TFA) Collector.
2025/05/23 13:11:42 CLSRSC-594: Executing installation step 17 of 19: 'StartCluster'.
2025/05/23 13:12:39 CLSRSC-343: Successfully started Oracle Clusterware stack
2025/05/23 13:12:39 CLSRSC-594: Executing installation step 18 of 19: 'ConfigNode'.
2025/05/23 13:13:01 CLSRSC-594: Executing installation step 19 of 19: 'PostConfig'.
2025/05/23 13:13:13 CLSRSC-325: Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 68.8 -->> On Node 1
[grid@pdbdr1 ~]$ cd /opt/app/19c/grid/
[grid@pdbdr1 grid]$ export CV_ASSUME_DISTID=OEL7.8
[grid@pdbdr1 grid]$ /opt/app/19c/grid/gridSetup.sh -silent -executeConfigTools -responseFile /home/grid/gridsetup.rsp
/*
Launching Oracle Grid Infrastructure Setup Wizard...

You can find the logs of this session at:
/opt/app/oraInventory/logs/GridSetupActions2025-05-23_01-14-27PM

You can find the log of this install session at:
 /opt/app/oraInventory/logs/UpdateNodeList2025-05-23_01-14-27PM.log
Successfully Configured Software.
*/

-- Step 68.9 -->> On Node 1
[root@pdbdr1 ~]# tail -f /opt/app/oraInventory/logs/UpdateNodeList2025-05-23_01-14-27PM.log
/*
INFO: Command execution completes for node : pdbdr2
INFO: Command execution sucess for node : pdbdr2
INFO: All threads completed its operations
INFO: Checkpoint:Index file written and updated
INFO: Done calling doOperation.
INFO: 'UpdateNodeList' was successful.
*/

-- Step 68.10 -->> On Both Node
--Auto Configured based on Grid Responce File
[root@pdbdr1/pdbdr2 ~]# cat /etc/oracleafd.conf
/*
afd_diskstring='/dev/sd*'
afd_dev_count=3
*/

-- Step 69 -->> On Both Nodes
[root@pdbdr1/pdbdr2 ~]# cd /opt/app/19c/grid/bin/
[root@pdbdr1/pdbdr2 bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/


-- Step 70 -->> On Both Nodes
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

-- Step 71 -->> On Node 1
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
ora.driver.afd
      1        ONLINE  ONLINE       pdbdr1                   STABLE
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


-- Step 72 -->> On Node 2
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
ora.driver.afd
      1        ONLINE  ONLINE       pdbdr2                   STABLE
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

-- Step 73 -->> On Both Nodes
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


-- Step 74 -->> On Both Nodes
[grid@pdbdr1/pdbdr2 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20136                0           20136              0             Y  OCR/
ASMCMD [+] > exit
*/

-- Step 75 -->> On Both Nodes
[grid@pdbdr1/pdbdr2 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri May 23 14:16:09 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

SQL> col name for a20
SQL> col path for a10
SQL> col library for a50
SQL> set lines 120
SQL> SELECT group_number, name, path, library from v$asm_disk;

GROUP_NUMBER NAME                 PATH       LIBRARY
------------ -------------------- ---------- -------------------------------------------
           0                      AFD:DATA   AFD Library - Generic , version 3 (KABI_V3)
           0                      AFD:ARC    AFD Library - Generic , version 3 (KABI_V3)
           1 OCR                  AFD:OCR    AFD Library - Generic , version 3 (KABI_V3)

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0
*/

-- Step 76 -->> On Node 1
[grid@pdbdr1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 23-MAY-2025 14:18:08

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-MAY-2025 13:05:54
Uptime                    0 days 1 hr. 12 min. 14 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.48)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.50)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 76.1 -->> On Node 1
[grid@pdbdr1 ~]$ ps -ef | grep SCAN
/*
grid       49871       1  0 13:05 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid       49931       1  0 13:05 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid      157296  150929  0 14:19 pts/1    00:00:00 grep --color=auto SCAN
*/

-- Step 76.2 -->> On Node 1
[grid@pdbdr1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 23-MAY-2025 14:20:32

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-MAY-2025 13:05:14
Uptime                    0 days 1 hr. 15 min. 19 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.53)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 76.3 -->> On Node 1
[grid@pdbdr1 ~]$ lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 23-MAY-2025 14:21:02

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-MAY-2025 13:05:15
Uptime                    0 days 1 hr. 15 min. 46 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener_scan3/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN3)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.54)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 76.4 -->> On Node 2
[grid@pdbdr2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 23-MAY-2025 14:21:59

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-MAY-2025 13:13:06
Uptime                    0 days 1 hr. 8 min. 53 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.49)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.51)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 76.5 -->> On Node 2
[grid@pdbdr2 ~]$ ps -ef | grep SCAN
/*
grid       46626       1  0 13:12 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid      134819  131670  0 14:22 pts/2    00:00:00 grep --color=auto SCAN
*/

-- Step 76.6 -->> On Node 2
[grid@pdbdr2 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 23-MAY-2025 14:23:09

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-MAY-2025 13:12:43
Uptime                    0 days 1 hr. 10 min. 27 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr2/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.52)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 77 -->> On Node 2
-- Bug 30286976: To Solve the Pre-check or any Oracle relavant Installation for rac Setup make compatible version CV_ASSUME_DISTID=OEL7.8
[grid@pdbdr2 ~]$ vi /opt/app/19c/grid/cv/admin/cvu_config
/*
# Fallback to this distribution id.
CV_ASSUME_DISTID=OEL7.8
*/

-- Step 77.1 -->> On Node 2
[grid@pdbdr2 ~]$ cat /opt/app/19c/grid/cv/admin/cvu_config | grep -E CV_ASSUME_DISTID
/*
CV_ASSUME_DISTID=OEL7.8
*/

-- Step 78 -->> On Node 1
-- To Create ASM storage for Data and Archive 
[grid@pdbdr1 ~]$ cd /opt/app/19c/grid/bin
[grid@pdbdr1 bin]$ export CV_ASSUME_DISTID=OEL7.8

-- Step 78.1 -->> On Node 1
[grid@pdbdr1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName DATA -diskList AFD:DATA -redundancy EXTERNAL
/*
[INFO] [DBT-30001] Disk groups created successfully. Check /opt/app/oracle/cfgtoollogs/asmca/asmca-250523PM022632.log for details.
*/

-- Step 78.2 -->> On Node 1
[grid@pdbdr1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName ARC -diskList ORCL:ARC -redundancy EXTERNAL
/*
[INFO] [DBT-30001] Disk groups created successfully. Check /opt/app/oracle/cfgtoollogs/asmca/asmca-250523PM022741.log for details.
*/

-- Step 79 -->> On Both Nodes
[grid@pdbdr1/pdbdr2 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri May 23 14:29:02 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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

NAME PATH     GROUP_# DISK_# MOUNT_S HEADER_STATU STATE  TOTAL_MB FREE_MB
---- -------- ------- ------ ------- ------------ ------ -------- -------
OCR  AFD:OCR        1      0 CACHED  MEMBER       NORMAL    20476   20136
DATA AFD:DATA       2      0 CACHED  MEMBER       NORMAL   204799  204689
ARC  AFD:ARC        3      0 CACHED  MEMBER       NORMAL   409599  409485

SQL> set lines 200;
SQL> col BANNER_FULL format a80;
SQL> col BANNER_LEGACY format a80;
SQL> SELECT inst_id,banner_full,banner_legacy,con_id FROM gv$version;

   INST_ID BANNER_FULL                                                            BANNER_LEGACY                                                          CON_ID
---------- ---------------------------------------------------------------------- ---------------------------------------------------------------------- ------
         1 Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production      0
           Version 19.27.0.0.0                                                                                                                           
         2 Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production      0
           Version 19.27.0.0.0

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0
*/

-- Step 80 -->> On Both Nodes
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

-- Step 81 -->> On Both Nodes
[grid@pdbdr1/pdbdr2 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  1048576    409599   409485                0          409485              0             N  ARC/
MOUNTED  EXTERN  N         512             512   4096  1048576    204799   204689                0          204689              0             N  DATA/
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20136                0           20136              0             Y  OCR/
ASMCMD [+] > exit
*/

-- Step 82 -->> On Node 1
[root@pdbdr1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/19c/grid:N
*/

-- Step 83 -->> On Node 2
[root@pdbdr2 ~]# vi /etc/oratab
/*
+ASM2:/opt/app/19c/grid:N
*/

-- Step 84 -->> On Both Nodes
-- Creating the Oracle RDBMS Home Directory
[root@pdbdr1/pdbdr2 ~]# mkdir -p /opt/app/oracle/product/19c/db_1
[root@pdbdr1/pdbdr2 ~]# chown -R oracle:oinstall /opt/app/oracle/product/19c/db_1
[root@pdbdr1/pdbdr2 ~]# chmod -R 775 /opt/app/oracle/product/19c/db_1

-- Step 84.1 -->> On Node 1
-- To unzip the Oracle Binary and Letest Opatch
[root@pdbdr1 ~]# cd /opt/app/oracle/product/19c/db_1
[root@pdbdr1 db_1]# unzip -oq /root/Oracle_19C/19.3.0.0.0_DB_Binary/LINUX.X64_193000_db_home.zip
[root@pdbdr1 db_1]# unzip -oq /root/Oracle_19C/OPATCH_19c/p6880880_190000_Linux-x86-64.zip

-- Step 84.2 -->> On Node 1
[root@pdbdr1 ~]# chown -R oracle:oinstall /opt/app/oracle/product/19c/db_1/
[root@pdbdr1 ~]# chmod -R 775 /opt/app/oracle/product/19c/db_1/

-- Step 84.3 -->> On Node 1
[root@pdbdr1 ~]# su - oracle
[oracle@pdbdr1 ~]$ /opt/app/oracle/product/19c/db_1/OPatch/opatch version
/*
OPatch Version: 12.2.0.1.46

OPatch succeeded.
*/

-- Step 85 -->> On Both Node
--Fix: Manually Create a Valid 2048-bit RSA Key for oracle User
[oracle@pdbdr1/pdbdr2 ~]$ rm -f ~/.ssh/id_rsa ~/.ssh/id_rsa.pub
[oracle@pdbdr1/pdbdr2 ~]$ ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
[oracle@pdbdr1/pdbdr2 ~]$ cat ~/.ssh/id_rsa.pub  # Should start with "ssh-rsa AAAA..."
[oracle@pdbdr1/pdbdr2 ~]$ chmod 700 ~/.ssh
[oracle@pdbdr1/pdbdr2 ~]$ chmod 600 ~/.ssh/id_rsa
[oracle@pdbdr1/pdbdr2 ~]$ chmod 644 ~/.ssh/id_rsa.pub

-- Step 85.1 -->> On Both Node, Manually Copy the Key to Remote Hosts
[oracle@pdbdr1/pdbdr2 ~]$ ssh-copy-id oracle@pdbdr1
[oracle@pdbdr1/pdbdr2 ~]$ ssh-copy-id oracle@pdbdr2
--OR--
[oracle@pdbdr1/pdbdr2 ~]$ cat ~/.ssh/id_rsa.pub | ssh grid@pdb1 'cat >> ~/.ssh/authorized_keys'
[oracle@pdbdr1/pdbdr2 ~]$ cat ~/.ssh/id_rsa.pub | ssh grid@pdb2 'cat >> ~/.ssh/authorized_keys'

-- Step 86 -->> On Both Nodes
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@pdbdr1 date
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@pdbdr2 date
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@pdbdr1 date && ssh oracle@pdbdr2 date
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@pdbdr1.unidev.org.np date
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@pdbdr2.unidev.org.np date
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@pdbdr1.unidev.org.np date && ssh oracle@pdbdr2.unidev.org.np date
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@192.168.6.48 date
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@192.168.6.49 date
[oracle@pdbdr1/pdbdr2 ~]$ ssh oracle@192.168.6.48 date && ssh oracle@192.168.6.49 date

-- Step 87 -->> On Node 1
-- To Create a responce file for Oracle Software Installation
[oracle@pdbdr1 ~]$ cp /opt/app/oracle/product/19c/db_1/install/response/db_install.rsp /home/oracle/
[oracle@pdbdr1 ~]$ cd /home/oracle/

-- Step 87.1 -->> On Node 1
[oracle@pdbdr1 ~]$ ll
/*
-rwxr-xr-x 1 oracle oinstall 19932 Oct  4 11:15 db_install.rsp
*/

-- Step 87.2 -->> On Node 1
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

-- Step 88 -->> On Node 1
[oracle@pdbdr1 ~]$ vi /opt/app/oracle/product/19c/db_1/cv/admin/cvu_config
/*
# Fallback to this distribution id
CV_ASSUME_DISTID=OEL7.8
*/

-- Step 88.1 -->> On Node 1
[oracle@pdbdr1 ~]$ cat /opt/app/oracle/product/19c/db_1/cv/admin/cvu_config | grep -E 'CV_ASSUME_DISTID'
/*
CV_ASSUME_DISTID=OEL7.8
*/

-- Step 89 -->> On Node 1
-- To install Oracle Software with Letest Opatch
[oracle@pdbdr1 ~]$ cd /opt/app/oracle/product/19c/db_1/
[oracle@pdbdr1 db_1]$ export CV_ASSUME_DISTID=OEL7.8
[oracle@pdbdr1 db_1]$ ./runInstaller -ignorePrereq -waitforcompletion -silent \
-applyRU /tmp/37591516/37641958                                             \
-responseFile /home/oracle/db_install.rsp                                   \
oracle.install.db.isRACOneInstall=false                                     \
oracle.install.db.rac.serverpoolCardinality=0                               \
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false                                  \
DECLINE_SECURITY_UPDATES=true

/*
Preparing the home to patch...
Applying the patch /tmp/37591516/37641958...
Successfully applied the patch.
The log can be found at: /opt/app/oraInventory/logs/InstallActions2025-05-25_12-23-42PM/installerPatchActions_2025-05-25_12-23-42PM.log
Launching Oracle Database Setup Wizard...

The response file for this session can be found at:
 /opt/app/oracle/product/19c/db_1/install/response/db_2025-05-25_12-23-42PM.rsp

You can find the log of this install session at:
 /opt/app/oraInventory/logs/InstallActions2025-05-25_12-23-42PM/installActions2025-05-25_12-23-42PM.log

As a root user, execute the following script(s):
        1. /opt/app/oracle/product/19c/db_1/root.sh

Execute /opt/app/oracle/product/19c/db_1/root.sh on the following nodes:
[pdbdr1, pdbdr2]


Successfully Setup Software.
*/

-- Step 89.1 -->> On Node 1
[root@pdbdr1 ~]# /opt/app/oracle/product/19c/db_1/root.sh
/*
Check /opt/app/oracle/product/19c/db_1/install/root_pdbdr1.unidev.org.np_2025-05-25_12-58-47-776406387.log for the output of root script
*/

-- Step 89.2 -->> On Node 1
[root@pdbdr1 ~]# tail -f  /opt/app/oracle/product/19c/db_1/install/root_pdbdr1.unidev.org.np_2025-05-25_12-58-47-776406387.log
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

-- Step 89.3 -->> On Node 2
[root@pdbdr2 ~]# /opt/app/oracle/product/19c/db_1/root.sh
/*
Check /opt/app/oracle/product/19c/db_1/install/root_pdbdr2.unidev.org.np_2025-05-25_12-59-33-288320318.log for the output of root script
*/

-- Step 89.4 -->> On Node 2
[root@pdbdr2 ~]# tail -f /opt/app/oracle/product/19c/db_1/install/root_pdbdr2.unidev.org.np_2025-05-25_12-59-33-288320318.log
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
[root@pdbdr1 ~]# cd /tmp/
[root@pdbdr1 tmp]$ export CV_ASSUME_DISTID=OEL7.8
[root@pdbdr1 tmp]# export ORACLE_HOME=/opt/app/oracle/product/19c/db_1
[root@pdbdr1 tmp]# export PATH=${ORACLE_HOME}/bin:$PATH
[root@pdbdr1 tmp]# export PATH=${PATH}:${ORACLE_HOME}/OPatch

-- Step 90.1 -->> On Node 1
[root@pdbdr1 tmp]# which opatchauto
/*
/opt/app/oracle/product/19c/db_1/OPatch/opatchauto
*/

-- Step 90.2 -->> On Node 1           
[root@pdbdr1 tmp]# opatchauto apply /tmp/37591516/37499406 -oh /opt/app/oracle/product/19c/db_1 --nonrolling
/*
OPatchauto session is initiated at Sun May 25 13:02:13 2025

System initialization log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchautodb/systemconfig2025-05-25_01-02-21PM.log.

Session log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/opatchauto2025-05-25_01-02-55PM.log
The id for this session is E3JC

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

Patch: /tmp/37591516/37499406
Log: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2025-05-25_13-04-39PM_1.log



OPatchauto session completed at Sun May 25 13:08:21 2025
Time taken to complete the session 6 minutes, 8 seconds
*/

-- Step 90.3 -->> On Node 1
[root@pdbdr1 ~]# tail -f /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2025-05-25_13-04-39PM_1.log
/*
[May 25, 2025 1:08:05 PM] [INFO]    [OPSR-TIME] Backup area for restore has been cleaned up. For a complete list of files/directories, deleted, Please refer log file.
[May 25, 2025 1:08:05 PM] [INFO]    Patch 37499406 successfully applied.
[May 25, 2025 1:08:05 PM] [INFO]    [OPSR-TIME] deleteInactivePatchesByDefault begins
[May 25, 2025 1:08:05 PM] [INFO]    Inactive patches will be deleted by default after apply.
[May 25, 2025 1:08:05 PM] [INFO]    [OPSR-TIME] deleteInactivePatchesByDefault ends
[May 25, 2025 1:08:05 PM] [INFO]    UtilSession: N-Apply done.
[May 25, 2025 1:08:05 PM] [INFO]    Finishing UtilSession at Sun May 25 13:08:05 NPT 2025
[May 25, 2025 1:08:05 PM] [INFO]    Log file location: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2025-05-25_13-04-39PM_1.log
[May 25, 2025 1:08:05 PM] [INFO]    EXITING METHOD: NApply(patches,options)
*/

-- Step 91 -->> On Node 1
[root@pdbdr1 ~]# scp -r /tmp/37591516/ root@pdbdr2:/tmp/

-- Step 91.1 -->> On Node 2
[root@pdbdr2 ~]# cd /tmp/
[root@pdbdr2 tmp]# chown -R oracle:oinstall 37591516
[root@pdbdr2 tmp]# chmod -R 775 37591516

-- Step 91.2 -->> On Node 2
[root@pdbdr2 tmp]# ls -ltr | grep 37591516
/*
drwxrwxr-x  4 oracle oinstall     80 May 25 13:12 37591516
*/

-- Step 93 -->> On Node 2
-- To applying the Oracle PSU on Remote Node 2
[root@pdbdr2 ~]# cd /tmp/
[root@pdbdr1 tmp]$ export CV_ASSUME_DISTID=OEL7.8
[root@pdbdr2 tmp]# export ORACLE_HOME=/opt/app/oracle/product/19c/db_1
[root@pdbdr2 tmp]# export PATH=${ORACLE_HOME}/bin:$PATH
[root@pdbdr2 tmp]# export PATH=${PATH}:${ORACLE_HOME}/OPatch

-- Step 93.1 -->> On Node 2
[root@pdbdr2 tmp]# which opatchauto
/*
/opt/app/oracle/product/19c/db_1/OPatch/opatchauto
*/

-- Step 93.2 -->> On Node 2
[root@pdbdr2 tmp]# opatchauto apply /tmp/37591516/37499406 -oh /opt/app/oracle/product/19c/db_1 --nonrolling
/*
OPatchauto session is initiated at Sun May 25 13:20:14 2025

System initialization log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchautodb/systemconfig2025-05-25_01-20-23PM.log.

Session log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/opatchauto2025-05-25_01-20-56PM.log
The id for this session is XBY8

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

Patch: /tmp/37591516/37499406
Log: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2025-05-25_13-22-26PM_1.log



OPatchauto session completed at Sun May 25 13:26:06 2025
Time taken to complete the session 5 minutes, 53 seconds
*/

-- Step 93.3 -->> On Node 2
[root@pdbdr2 ~]# tail -f /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2025-05-25_13-22-26PM_1.log
/*
[May 25, 2025 1:25:51 PM] [INFO]    [OPSR-TIME] Backup area for restore has been cleaned up. For a complete list of files/directories, deleted, Please refer log file.
[May 25, 2025 1:25:51 PM] [INFO]    Patch 37499406 successfully applied.
[May 25, 2025 1:25:51 PM] [INFO]    [OPSR-TIME] deleteInactivePatchesByDefault begins
[May 25, 2025 1:25:51 PM] [INFO]    Inactive patches will be deleted by default after apply.
[May 25, 2025 1:25:51 PM] [INFO]    [OPSR-TIME] deleteInactivePatchesByDefault ends
[May 25, 2025 1:25:51 PM] [INFO]    UtilSession: N-Apply done.
[May 25, 2025 1:25:51 PM] [INFO]    Finishing UtilSession at Sun May 25 13:25:51 NPT 2025
[May 25, 2025 1:25:51 PM] [INFO]    Log file location: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2025-05-25_13-22-26PM_1.log
[May 25, 2025 1:25:51 PM] [INFO]    EXITING METHOD: NApply(patches,options)
*/

-- Step 94 -->> On Both Nodes (DC and DR)
--########################################################################--
[root@pdbdr1/pdbdr2/pdbdr1/pdbdr2 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

##############################DC##################################
# Public
192.168.6.21   pdb1.unidev.org.np        pdb1
192.168.6.22   pdb2.unidev.org.np        pdb2

# Private
10.10.10.21   pdb1-priv.unidev.org.np   pdb1-priv
10.10.10.22   pdb2-priv.unidev.org.np   pdb2-priv

# Virtual
192.168.6.23   pdb1-vip.unidev.org.np    pdb1-vip
192.168.6.24   pdb2-vip.unidev.org.np    pdb2-vip

# SCAN
192.168.6.25   pdb-scan.unidev.org.np    pdb-scan
192.168.6.26   pdb-scan.unidev.org.np    pdb-scan
192.168.6.27   pdb-scan.unidev.org.np    pdb-scan

##############################DR##################################
# Public
192.168.6.48   pdbdr1.unidev.org.np        pdbdr1
192.168.6.49   pdbdr2.unidev.org.np        pdbdr2

# Private
10.10.10.48   pdbdr1-priv.unidev.org.np   pdbdr1-priv
10.10.10.49   pdbdr2-priv.unidev.org.np   pdbdr2-priv

# Virtual
192.168.6.50   pdbdr1-vip.unidev.org.np    pdbdr1-vip
192.168.6.51   pdbdr2-vip.unidev.org.np    pdbdr2-vip

# SCAN
192.168.6.52   pdbdr-scan.unidev.org.np    pdbdr-scan
192.168.6.53   pdbdr-scan.unidev.org.np    pdbdr-scan
192.168.6.54   pdbdr-scan.unidev.org.np    pdbdr-scan
*/

-- Step 95 -->> On Both Nodes - DC & DR
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

-- Step 96 -->> On Both Node's - DC
-- Enable Archive
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is running on node pdb1
Instance pdbdb2 is running on node pdb2
*/

-- Step 97 -->> On Both Node's - DC
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 98 -->> On Node 1 - DC
[oracle@pdb1 ~]$ srvctl stop database -d pdbdb
[oracle@pdb1 ~]$ srvctl start database -d pdbdb -o mount
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Mounted (Closed).
Instance pdbdb2 is running on node pdb2. Instance status: Mounted (Closed).
*/

-- Step 99 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue May 27 11:53:31 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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

SQL> ALTER SYSTEM SET log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST' sid='*';
SQL> ALTER SYSTEM SET log_archive_format='pdbdb_%t_%s_%r.arc' SCOPE=spfile sid='*';

SQL> archive log list;

Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     105
Next log sequence to archive   106
Current log sequence           106

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
         1 PDBDB     pdbdb1           MOUNTED      27-MAY-25 pdb1.unidev.org.np      MOUNTED    ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED
         2 PDBDB     pdbdb2           MOUNTED      27-MAY-25 pdb2.unidev.org.np      MOUNTED    ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED

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
Version 19.27.0.0.0
*/

-- Step 100 -->> On Node 1 - DC
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Mounted (Closed).
Instance pdbdb2 is running on node pdb2. Instance status: Mounted (Closed).
*/
[oracle@pdb1 ~]$ srvctl stop database -d pdbdb
[oracle@pdb1 ~]$ srvctl start database -d pdbdb

-- Step 101 -->> On Both Nodes - DC
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is running on node pdb1
Instance pdbdb2 is running on node pdb2
*/

-- Step 101.1 -->> On Both Nodes - DC
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 102 -->> On Node 1 - DC
[grid@pdb1 ~]$ srvctl config database -d pdbdb | grep pwd
/*
Password file: +DATA/PDBDB/PASSWORD/pwdpdbdb.256.1202051163
*/

-- Step 103 -->> On Node 1 - DC
[grid@pdb1 ~]$ asmcmd -p
/*
ASMCMD [+] > cd +DATA/PDBDB/PASSWORD

ASMCMD [+DATA/PDBDB/PASSWORD] > ls
pwdpdbdb.256.1202051163

ASMCMD [+DATA/PDBDB/PASSWORD] > ls -lt
Type      Redund  Striped  Time             Sys  Name
PASSWORD  UNPROT  COARSE   MAY 25 15:00:00  Y    pwdpdbdb.256.1202051163

ASMCMD [+DATA/PDBDB/PASSWORD] > pwcopy pwdpdbdb.256.1202051163 /tmp
copying +DATA/PDBDB/PASSWORD/pwdpdbdb.256.1202051163 -> /tmp/pwdpdbdb.256.1202051163

ASMCMD [+DATA/PDBDB/PASSWORD] > ls -lt
Type      Redund  Striped  Time             Sys  Name
PASSWORD  UNPROT  COARSE   MAY 25 15:00:00  Y    pwdpdbdb.256.1202051163

ASMCMD [+DATA/PDBDB/PASSWORD] > exit
*/

-- Step 104 -->> On Node 1 - DC
[grid@pdb1 ~]$ cd /tmp/
[grid@pdb1 tmp]$ ls -lrth pwdpdbdb.256.1202051163
/*
-rw-r----- 1 grid oinstall 2.0K May 27 12:01 pwdpdbdb.256.1202051163
*/

-- Step 105 -->> On Node 1 - DC
[grid@pdb1 ~]$ cd /tmp/
[grid@pdb1 tmp]$ scp -p pwdpdbdb.256.1202051163 oracle@pdbdr1:/opt/app/oracle/product/19c/db_1/dbs/orapwpdbdb1
/*
The authenticity of host 'pdbdr1 (192.168.6.48)' can't be established.
ED25519 key fingerprint is SHA256:QsObkxBryZTLQxvw+RyOhrz+5LTM9MErqF7fin9qrHo.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'pdbdr1' (ED25519) to the list of known hosts.
oracle@pdbdr1's password: <= oracle
pwdpdbdb.256.1202051163               100% 2048     2.1MB/s   00:00
*/

-- Step 106 -->> On Node 1 - DC
[grid@pdb1 tmp]$ scp -p pwdpdbdb.256.1202051163 oracle@pdbdr2:/opt/app/oracle/product/19c/db_1/dbs/orapwpdbdb2
/*
The authenticity of host 'pdbdr2 (192.168.6.49)' can't be established.
ED25519 key fingerprint is SHA256:JMVPd40btp2bGpOmxJZCJRlXtCf0ZLDmbBmiVT12QBk.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'pdbdr2' (ED25519) to the list of known hosts.
oracle@pdbdr2's password: <= oracle
pwdpdbdb.256.1202051163           100% 2048     2.3MB/s   00:00
*/

-- Step 107 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue May 27 12:05:36 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

SQL> show parameter pfile

NAME                                 TYPE        VALUE
------------------------------------ ----------- -----------------------------------------------
spfile                               string      +DATA/PDBDB/PARAMETERFILE/spfile.285.1202055169

SQL> create pfile='/home/oracle/spfilepdbdb.ora' from spfile;

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           OPEN         27-MAY-25 pdb1.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED
         2 PDBDB     pdbdb2           OPEN         27-MAY-25 pdb2.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED

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
Version 19.27.0.0.0
*/

-- Step 108 -->> On Node 1 - DC
[oracle@pdb1 ~]$  sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue May 27 12:08:10 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

SQL> set lines 999 pages 999
SQL> col name for a20
SQL> col open_mode for a10
SQL> col db_unique_name for a15
SQL> col host_name for a25

SQL> SELECT a.inst_id,a.name db_name,b.instance_name,b.status,b.startup_time,b.host_name,a.open_mode,a.log_mode,a.database_role,b.version,a.protection_mode,a.switchover_status FROM gv$database a,gv$instance b WHERE a.inst_id =b.inst_id ORDER BY 1;

   INST_ID DB_NAME   INSTANCE_NAME    STATUS       STARTUP_T HOST_NAME                 OPEN_MODE  LOG_MODE     DATABASE_ROLE    VERSION           PROTECTION_MODE      SWITCHOVER_STATUS
---------- --------- ---------------- ------------ --------- ------------------------- ---------- ------------ ---------------- ----------------- -------------------- --------------------
         1 PDBDB     pdbdb1           OPEN         27-MAY-25 pdb1.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED
         2 PDBDB     pdbdb2           OPEN         27-MAY-25 pdb2.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED

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
         1         ONLINE  +ARC/PDBDB/ONLINELOG/group_1.260.1202051359        YES          0
         1         ONLINE  +DATA/PDBDB/ONLINELOG/group_1.275.1202051359       NO           0
         2         ONLINE  +ARC/PDBDB/ONLINELOG/group_2.261.1202051361        YES          0
         2         ONLINE  +DATA/PDBDB/ONLINELOG/group_2.276.1202051359       NO           0
         3         ONLINE  +DATA/PDBDB/ONLINELOG/group_3.283.1202055167       NO           0
         3         ONLINE  +ARC/PDBDB/ONLINELOG/group_3.262.1202055167        YES          0
         4         ONLINE  +DATA/PDBDB/ONLINELOG/group_4.284.1202055167       NO           0
         4         ONLINE  +ARC/PDBDB/ONLINELOG/group_4.263.1202055169        YES          0

SQL> ALTER DATABASE ADD LOGFILE MEMBER '+DATA' ,'+DATA' to group 1;
SQL> ALTER DATABASE ADD LOGFILE MEMBER '+DATA' ,'+DATA' to group 2;
SQL> ALTER DATABASE ADD LOGFILE MEMBER '+DATA' ,'+DATA' to group 3;
SQL> ALTER DATABASE ADD LOGFILE MEMBER '+DATA' ,'+DATA' to group 4;
SQL> ALTER DATABASE ADD LOGFILE THREAD 1 GROUP 5 ('+DATA' ,'+DATA') SIZE 50M;
SQL> ALTER DATABASE ADD LOGFILE THREAD 2 GROUP 6 ('+DATA' ,'+DATA') SIZE 50M;

SQL> SELECT group#, archived, status FROM v$log;

    GROUP# ARC STATUS
---------- --- ----------------
         1 NO  CURRENT
         2 YES INACTIVE
         3 YES INACTIVE
         4 YES ACTIVE
         5 YES INACTIVE
         6 NO  CURRENT

--Delete the original log member (Note: Switch to a non-current log for deletion)
--alter system switch logfile;
--alter system checkpoint;

SQL> ALTER DATABASE DROP LOGFILE MEMBER '+ARC/PDBDB/ONLINELOG/group_1.260.1202051359'; 
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+DATA/PDBDB/ONLINELOG/group_1.275.1202051359';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+ARC/PDBDB/ONLINELOG/group_2.261.1202051361';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+DATA/PDBDB/ONLINELOG/group_2.276.1202051359';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+DATA/PDBDB/ONLINELOG/group_3.283.1202055167';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+ARC/PDBDB/ONLINELOG/group_3.262.1202055167';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+DATA/PDBDB/ONLINELOG/group_4.284.1202055167';
SQL> ALTER DATABASE DROP LOGFILE MEMBER '+ARC/PDBDB/ONLINELOG/group_4.263.1202055169';

SQL> SELECT * FROM v$logfile a ORDER BY a.type,a.group#;

    GROUP# STATUS  TYPE    MEMBER                                             IS_     CON_ID
---------- ------- ------- -------------------------------------------------- --- ----------
         1         ONLINE  +DATA/PDBDB/ONLINELOG/group_1.263.1202213831       NO           0
         1         ONLINE  +DATA/PDBDB/ONLINELOG/group_1.262.1202213831       NO           0
         2         ONLINE  +DATA/PDBDB/ONLINELOG/group_2.267.1202213841       NO           0
         2         ONLINE  +DATA/PDBDB/ONLINELOG/group_2.266.1202213841       NO           0
         3         ONLINE  +DATA/PDBDB/ONLINELOG/group_3.265.1202213847       NO           0
         3         ONLINE  +DATA/PDBDB/ONLINELOG/group_3.268.1202213847       NO           0
         4         ONLINE  +DATA/PDBDB/ONLINELOG/group_4.264.1202213853       NO           0
         4         ONLINE  +DATA/PDBDB/ONLINELOG/group_4.260.1202213853       NO           0
         5         ONLINE  +DATA/PDBDB/ONLINELOG/group_5.269.1202213865       NO           0
         5         ONLINE  +DATA/PDBDB/ONLINELOG/group_5.259.1202213865       NO           0
         6         ONLINE  +DATA/PDBDB/ONLINELOG/group_6.257.1202213871       NO           0
         6         ONLINE  +DATA/PDBDB/ONLINELOG/group_6.258.1202213871       NO           0

SQL> SELECT b.thread#,a.group#,a.member,b.bytes FROM v$logfile a, v$log b  WHERE a.group#=b.group# ORDER BY b.group#;

   THREAD#     GROUP# MEMBER                                                  BYTES
---------- ---------- -------------------------------------------------- ----------
         1          1 +DATA/PDBDB/ONLINELOG/group_1.263.1202213831         52428800
         1          1 +DATA/PDBDB/ONLINELOG/group_1.262.1202213831         52428800
         1          2 +DATA/PDBDB/ONLINELOG/group_2.267.1202213841         52428800
         1          2 +DATA/PDBDB/ONLINELOG/group_2.266.1202213841         52428800
         2          3 +DATA/PDBDB/ONLINELOG/group_3.265.1202213847         52428800
         2          3 +DATA/PDBDB/ONLINELOG/group_3.268.1202213847         52428800
         2          4 +DATA/PDBDB/ONLINELOG/group_4.264.1202213853         52428800
         2          4 +DATA/PDBDB/ONLINELOG/group_4.260.1202213853         52428800
         1          5 +DATA/PDBDB/ONLINELOG/group_5.269.1202213865         52428800
         1          5 +DATA/PDBDB/ONLINELOG/group_5.259.1202213865         52428800
         2          6 +DATA/PDBDB/ONLINELOG/group_6.257.1202213871         52428800
         2          6 +DATA/PDBDB/ONLINELOG/group_6.258.1202213871         52428800

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
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.275.1202214407         52428800
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.284.1202214407         52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.276.1202214409         52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.283.1202214407         52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.292.1202214409         52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.293.1202214409         52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.294.1202214409        52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.295.1202214409        52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.296.1202214409        52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.297.1202214409        52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.298.1202214411        52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.299.1202214411        52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.300.1202214411        52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.301.1202214411        52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.302.1202214411        52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.303.1202214411        52428800

--Node 2
SQL> SELECT b.thread#,a.group#, a.type, a.member, b.bytes FROM v$logfile a, v$standby_log b WHERE a.group# = b.group# ORDER BY 2,4;

   THREAD#     GROUP# TYPE    MEMBER                                                  BYTES
---------- ---------- ------- -------------------------------------------------- ----------
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.275.1202214407         52428800
         1          7 STANDBY +DATA/PDBDB/ONLINELOG/group_7.284.1202214407         52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.276.1202214409         52428800
         1          8 STANDBY +DATA/PDBDB/ONLINELOG/group_8.283.1202214407         52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.292.1202214409         52428800
         1          9 STANDBY +DATA/PDBDB/ONLINELOG/group_9.293.1202214409         52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.294.1202214409        52428800
         1         10 STANDBY +DATA/PDBDB/ONLINELOG/group_10.295.1202214409        52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.296.1202214409        52428800
         2         11 STANDBY +DATA/PDBDB/ONLINELOG/group_11.297.1202214409        52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.298.1202214411        52428800
         2         12 STANDBY +DATA/PDBDB/ONLINELOG/group_12.299.1202214411        52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.300.1202214411        52428800
         2         13 STANDBY +DATA/PDBDB/ONLINELOG/group_13.301.1202214411        52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.302.1202214411        52428800
         2         14 STANDBY +DATA/PDBDB/ONLINELOG/group_14.303.1202214411        52428800

SQL> SELECT * FROM v$logfile order by 1;

    GROUP# STATUS  TYPE    MEMBER                                             IS_     CON_ID
---------- ------- ------- -------------------------------------------------- --- ----------
         1         ONLINE  +DATA/PDBDB/ONLINELOG/group_1.262.1202213831       NO           0
         1         ONLINE  +DATA/PDBDB/ONLINELOG/group_1.263.1202213831       NO           0
         2         ONLINE  +DATA/PDBDB/ONLINELOG/group_2.267.1202213841       NO           0
         2         ONLINE  +DATA/PDBDB/ONLINELOG/group_2.266.1202213841       NO           0
         3         ONLINE  +DATA/PDBDB/ONLINELOG/group_3.265.1202213847       NO           0
         3         ONLINE  +DATA/PDBDB/ONLINELOG/group_3.268.1202213847       NO           0
         4         ONLINE  +DATA/PDBDB/ONLINELOG/group_4.264.1202213853       NO           0
         4         ONLINE  +DATA/PDBDB/ONLINELOG/group_4.260.1202213853       NO           0
         5         ONLINE  +DATA/PDBDB/ONLINELOG/group_5.259.1202213865       NO           0
         5         ONLINE  +DATA/PDBDB/ONLINELOG/group_5.269.1202213865       NO           0
         6         ONLINE  +DATA/PDBDB/ONLINELOG/group_6.257.1202213871       NO           0
         6         ONLINE  +DATA/PDBDB/ONLINELOG/group_6.258.1202213871       NO           0
         7         STANDBY +DATA/PDBDB/ONLINELOG/group_7.275.1202214407       NO           0
         7         STANDBY +DATA/PDBDB/ONLINELOG/group_7.284.1202214407       NO           0
         8         STANDBY +DATA/PDBDB/ONLINELOG/group_8.276.1202214409       NO           0
         8         STANDBY +DATA/PDBDB/ONLINELOG/group_8.283.1202214407       NO           0
         9         STANDBY +DATA/PDBDB/ONLINELOG/group_9.293.1202214409       NO           0
         9         STANDBY +DATA/PDBDB/ONLINELOG/group_9.292.1202214409       NO           0
        10         STANDBY +DATA/PDBDB/ONLINELOG/group_10.294.1202214409      NO           0
        10         STANDBY +DATA/PDBDB/ONLINELOG/group_10.295.1202214409      NO           0
        11         STANDBY +DATA/PDBDB/ONLINELOG/group_11.296.1202214409      NO           0
        11         STANDBY +DATA/PDBDB/ONLINELOG/group_11.297.1202214409      NO           0
        12         STANDBY +DATA/PDBDB/ONLINELOG/group_12.298.1202214411      NO           0
        12         STANDBY +DATA/PDBDB/ONLINELOG/group_12.299.1202214411      NO           0
        13         STANDBY +DATA/PDBDB/ONLINELOG/group_13.300.1202214411      NO           0
        13         STANDBY +DATA/PDBDB/ONLINELOG/group_13.301.1202214411      NO           0
        14         STANDBY +DATA/PDBDB/ONLINELOG/group_14.302.1202214411      NO           0
        14         STANDBY +DATA/PDBDB/ONLINELOG/group_14.303.1202214411      NO           0


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
[ ONLINE REDO LOG ]        1      1          1        122 +DATA/PDBDB/ONLINELOG/group_1.262.1202213831                 INACTIVE         YES             50
[ ONLINE REDO LOG ]        1      1          1        122 +DATA/PDBDB/ONLINELOG/group_1.263.1202213831                 INACTIVE         YES             50
[ ONLINE REDO LOG ]        1      2          1        121 +DATA/PDBDB/ONLINELOG/group_2.266.1202213841                 INACTIVE         YES             50
[ ONLINE REDO LOG ]        1      2          1        121 +DATA/PDBDB/ONLINELOG/group_2.267.1202213841                 INACTIVE         YES             50
[ ONLINE REDO LOG ]        1      5          1        123 +DATA/PDBDB/ONLINELOG/group_5.259.1202213865                 CURRENT          NO              50
[ ONLINE REDO LOG ]        1      5          1        123 +DATA/PDBDB/ONLINELOG/group_5.269.1202213865                 CURRENT          NO              50
[ STANDBY REDO LOG ]       1      7          1          0 +DATA/PDBDB/ONLINELOG/group_7.275.1202214407                 UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      7          1          0 +DATA/PDBDB/ONLINELOG/group_7.284.1202214407                 UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      8          1          0 +DATA/PDBDB/ONLINELOG/group_8.276.1202214409                 UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      8          1          0 +DATA/PDBDB/ONLINELOG/group_8.283.1202214407                 UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      9          1          0 +DATA/PDBDB/ONLINELOG/group_9.292.1202214409                 UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      9          1          0 +DATA/PDBDB/ONLINELOG/group_9.293.1202214409                 UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1     10          1          0 +DATA/PDBDB/ONLINELOG/group_10.294.1202214409                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1     10          1          0 +DATA/PDBDB/ONLINELOG/group_10.295.1202214409                UNASSIGNED       YES             50

--At Node 2 (pdb2)
REDOLOG_FILE_TYPE    INST_ID GROUP#    THREAD#  SEQUENCE# MEMBER                                                       STATUS           ARCHIVE    SIZE_MB
-------------------- ------- ------ ---------- ---------- ------------------------------------------------------------ ---------------- ------- ----------
[ ONLINE REDO LOG ]        2      3          2         15 +DATA/PDBDB/ONLINELOG/group_3.265.1202213847                 CURRENT          NO              50
[ ONLINE REDO LOG ]        2      3          2         15 +DATA/PDBDB/ONLINELOG/group_3.268.1202213847                 CURRENT          NO              50
[ ONLINE REDO LOG ]        2      4          2         13 +DATA/PDBDB/ONLINELOG/group_4.260.1202213853                 INACTIVE         YES             50
[ ONLINE REDO LOG ]        2      4          2         13 +DATA/PDBDB/ONLINELOG/group_4.264.1202213853                 INACTIVE         YES             50
[ ONLINE REDO LOG ]        2      6          2         14 +DATA/PDBDB/ONLINELOG/group_6.257.1202213871                 INACTIVE         YES             50
[ ONLINE REDO LOG ]        2      6          2         14 +DATA/PDBDB/ONLINELOG/group_6.258.1202213871                 INACTIVE         YES             50
[ STANDBY REDO LOG ]       2     11          2          0 +DATA/PDBDB/ONLINELOG/group_11.296.1202214409                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     11          2          0 +DATA/PDBDB/ONLINELOG/group_11.297.1202214409                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     12          2          0 +DATA/PDBDB/ONLINELOG/group_12.298.1202214411                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     12          2          0 +DATA/PDBDB/ONLINELOG/group_12.299.1202214411                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     13          2          0 +DATA/PDBDB/ONLINELOG/group_13.300.1202214411                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     13          2          0 +DATA/PDBDB/ONLINELOG/group_13.301.1202214411                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     14          2          0 +DATA/PDBDB/ONLINELOG/group_14.302.1202214411                UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       2     14          2          0 +DATA/PDBDB/ONLINELOG/group_14.303.1202214411                UNASSIGNED       YES             50

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0
*/

-- Step 109 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue May 27 12:30:24 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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

-- Step 110 -->> On Both Nodes - DC
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 111.1 -->> On Node 1 - DC
[oracle@pdb1 ~]$ srvctl stop database -d pdbdb

-- Step 111.2 -->> On Node 1 - DC
[oracle@pdb1 ~]$ srvctl start database -d pdbdb

-- Step 112 -->> On Both Nodes - DC
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is running on node pdb1
Instance pdbdb2 is running on node pdb2
*/

-- Step 112.1 -->> On Both Nodes - DC
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 113 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue May 27 12:36:33 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
pdbdb2.__db_cache_size=7918845952
pdbdb1.__db_cache_size=7918845952
pdbdb2.__inmemory_ext_roarea=0
pdbdb1.__inmemory_ext_roarea=0
pdbdb2.__inmemory_ext_rwarea=0
pdbdb1.__inmemory_ext_rwarea=0
pdbdb2.__java_pool_size=0
pdbdb1.__java_pool_size=0
pdbdb2.__large_pool_size=67108864
pdbdb1.__large_pool_size=67108864
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
*.control_files='+DATA/PDBDB/CONTROLFILE/current.274.1202051357','+ARC/PDBDB/CONTROLFILE/current.259.1202051357'
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
*.processes=640
*.remote_login_passwordfile='EXCLUSIVE'
*.sga_target=9216m
*.standby_file_management='AUTO'
pdbdb2.thread=2
pdbdb1.thread=1
pdbdb1.undo_tablespace='UNDOTBS1'
pdbdb2.undo_tablespace='UNDOTBS2'

SQL> !ps -ef | grep tns
root           7       2  0 May23 ?        00:00:00 [kworker/R-netns]
root          12       2  0 May23 ?        00:00:01 [kworker/u32:1-netns]
grid     2002680       1  0 May25 ?        00:00:07 /opt/app/19c/grid/bin/tnslsnr LISTENER -no_crs_notify -inherit
grid     2003538       1  0 May25 ?        00:00:07 /opt/app/19c/grid/bin/tnslsnr ASMNET1LSNR_ASM -no_crs_notify -inherit
grid     2023771       1  0 May25 ?        00:00:06 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid     2023773       1  0 May25 ?        00:00:06 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
oracle   3626185 3625041  0 12:38 pts/1    00:00:00 /bin/bash -c ps -ef | grep tns
oracle   3626187 3626185  0 12:38 pts/1    00:00:00 grep tns

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0
*/

-- Step 114 -->> On Node 1 - DC
[grid@pdb1 ~]$ cat /opt/app/19c/grid/network/admin/listener.ora
/*
LISTENER=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER))))                            # line added by Agent
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

-- Step 115 -->> On Node 1 - DC
[grid@pdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 12:39:47

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                25-MAY-2025 16:53:06
Uptime                    1 days 19 hr. 46 min. 41 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.21)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.23)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "35f450d5c13c3158e063150610acc99a" has 1 instance(s).
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

-- Step 116 -->> On Node 2 - DC
[grid@pdb2 ~]$ cat /opt/app/19c/grid/network/admin/listener.ora
/*
LISTENER_SCAN2=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2))))                # line added by Agent
LISTENER_SCAN3=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3))))                # line added by Agent
LISTENER=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER))))                            # line added by Agent
LISTENER_SCAN1=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1))))                # line added by Agent
ASMNET1LSNR_ASM=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=IPC)(KEY=ASMNET1LSNR_ASM))))              # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_ASMNET1LSNR_ASM=ON               # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_ASMNET1LSNR_ASM=SUBNET         # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN1=ON                # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_LISTENER_SCAN1=OFF             # line added by Agent - Disabled by Agent because REMOTE_REGISTRATION_ADDRESS is set
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER=ON                      # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_LISTENER=SUBNET                # line added by Agent
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN3=ON                # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_LISTENER_SCAN3=OFF             # line added by Agent - Disabled by Agent because REMOTE_REGISTRATION_ADDRESS is set
ENABLE_GLOBAL_DYNAMIC_ENDPOINT_LISTENER_SCAN2=ON                # line added by Agent
VALID_NODE_CHECKING_REGISTRATION_LISTENER_SCAN2=OFF             # line added by Agent - Disabled by Agent because REMOTE_REGISTRATION_ADDRESS is set
*/

-- Step 117 -->> On Node 2 - DC
[grid@pdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 12:41:09

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                25-MAY-2025 17:00:51
Uptime                    1 days 19 hr. 40 min. 18 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.22)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.24)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "35f450d5c13c3158e063150610acc99a" has 1 instance(s).
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

-- Step 118 -->> On Node 1 - DC
[oracle@pdb1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 118.1 -->> On Node 1 - DC
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
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.6.21)(PORT = 1521))
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

-- Step 119 -->> On Node 1 - DC
[oracle@pdb1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 119.1 -->> On Node 1 - DC
[oracle@pdb1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 119.2 -->> On Node 1 - DC
[oracle@pdb1 admin]$ scp -r tnsnames.ora oracle@pdb2:/opt/app/oracle/product/19c/db_1/network/admin
/*
tnsnames.ora                                                              100%  895     1.2MB/s   00:00
*/

-- Step 120 -->> On Node 2 - DC
[oracle@pdb2 ~]$ cd $ORACLE_HOME/network/admin

-- Step 120.1 -->> On Node 2 - DC
[oracle@pdb2 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 120.2 -->> On Node 2 - DC
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
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.6.22)(PORT = 1521))
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

-- Step 121 -->> On Node 1 - DC
[oracle@pdb1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 121.1 -->> On Node 1 - DC
[oracle@pdb1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 121.2 -->> On Node 1 - DC
[oracle@pdb1 admin]$ scp -r tnsnames.ora oracle@pdbdr1:/opt/app/oracle/product/19c/db_1/network/admin
/*
oracle@pdbdr1's password: oracle
tnsnames.ora                                               100%  866   127.5KB/s   00:00
*/

-- Step 121.3 -->> On Node 1 - DC
[oracle@pdb1 admin]$ scp -r tnsnames.ora oracle@pdbdr2:/opt/app/oracle/product/19c/db_1/network/admin
/*
oracle@pdbdr2's password: oracle
tnsnames.ora                                               100%  866   369.7KB/s   00:00
*/

-- Step 122 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 122.1 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 122.2 -->> On Node 1 - DR
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

-- Step 123 -->> On Node 2 - DR
[oracle@pdbdr2 ~]$ cd $ORACLE_HOME/network/admin

-- Step 123.1 -->> On Node 2 - DR
[oracle@pdbdr2 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 123.2 -->> On Node 2 - DR
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
    (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr1.unidev.org.np)(PORT = 1541))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = dr)(UR=A)
    )
  )
*/

-- Step 124 -->> On Node 1 - DC
[oracle@pdb1 ~]$ cd /home/oracle/

-- Step 124.1 -->> On Node 1 - DC
[oracle@pdb1 ~]$ ll initpdbdb.ora
/*
-rw-r--r-- 1 oracle asmadmin 2463 May 27 12:38 initpdbdb.ora
*/

-- Step 124.2 -->> On Node 1 - DC
[oracle@pdb1 ~]$ scp -r initpdbdb.ora oracle@pdbdr1:/opt/app/oracle/product/19c/db_1/dbs/initpdbdb1.ora
/*
oracle@pdbdr1's password:
initpdbdb.ora                                              100% 2518     1.7MB/s   00:00
*/

-- Step 125 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/dbs

-- Step 125.1 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ ll initpdbdb1.ora
/*
-rw-r--r-- 1 oracle oinstall 2463 May 27 13:14 initpdbdb1.ora
*/

-- Step 125.2 -->> On Node 1 - DR
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

-- Step 126 -->> On Both Node's - DR
--[root@pdbdr1/pdbdr2 ~]# mkdir -p /opt/app/oracle/admin/pdbdb/hdump
--[root@pdbdr1/pdbdr2 ~]# mkdir -p /opt/app/oracle/admin/pdbdb/dpdump
--[root@pdbdr1/pdbdr2 ~]# mkdir -p /opt/app/oracle/admin/pdbdb/pfile
[root@pdbdr1/pdbdr2 ~]# mkdir -p /opt/app/oracle/admin/pdbdb/adump
[root@pdbdr1/pdbdr2 ~]# cd /opt/app/oracle/admin/
[root@pdbdr1/pdbdr2 admin]# chown -R oracle:oinstall pdbdb/
[root@pdbdr1/pdbdr2 admin]# chmod -R 775 pdbdb/

-- Step 127 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ asmcmd -p
/*
ASMCMD [+] > ls
ARC/
DATA/
OCR/
ASMCMD [+] > cd +ARC
ASMCMD [+ARC] > ls
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

-- Step 128 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ env | grep ORA
/*
ORACLE_UNQNAME=pdbdb
ORACLE_SID=pdbdb1
ORACLE_BASE=/opt/app/oracle
ORACLE_HOME=/opt/app/oracle/product/19c/db_1
ORACLE_HOSTNAME=pdbdr1.unidev.org.np
*/

-- Step 129 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue May 27 13:23:54 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> startup nomount pfile='/opt/app/oracle/product/19c/db_1/dbs/initpdbdb1.ora';
ORACLE instance started.

Total System Global Area 9663675432 bytes
Fixed Size                 13921320 bytes
Variable Size            1509949440 bytes
Database Buffers         8120172544 bytes
Redo Buffers               19632128 bytes

SQL> show parameter db_unique_name

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_unique_name                       string      dr

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0
*/

-- Step 130 -->> On Node 1 - DR
--Creating temporary listener 
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 130.1 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 130.2 -->> On Node 1 - DR
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

-- Step 130.3 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ ll listener.ora
/*
-rw-r--r-- 1 oracle oinstall 312 May 27 13:25 listener.ora
*/

-- Step 130.4 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ lsnrctl start listener1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 13:26:03

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

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
Start Date                27-MAY-2025 13:26:04
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

-- Step 130.5 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ lsnrctl status listener1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 13:26:22

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))
STATUS of the LISTENER
------------------------
Alias                     listener1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                27-MAY-2025 13:26:04
Uptime                    0 days 0 hr. 0 min. 18 sec
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

-- Step 130.6 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ sqlplus sys/Sys605014@pdbdb as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue May 27 13:26:44 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
Version 19.27.0.0.0
*/

-- Step 130.7 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ sqlplus sys/Sys605014@dr as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue May 27 13:34:13 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
Version 19.27.0.0.0
*/

-- Step 130.8 -->> On Node 1 - DC
[oracle@pdb1 ~]$ tnsping dr
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 13:35:09

Copyright (c) 1997, 2025, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr1.unidev.org.np)(PORT = 1541)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = dr)(UR=A)))
OK (10 msec)
*/

-- Step 130.9 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ tnsping pdbdb
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 13:35:32

Copyright (c) 1997, 2025, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdb-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = pdbdb)))
OK (0 msec)
*/

-- Step 131 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus sys/Sys605014@pdbdb as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue May 27 13:35:52 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
Version 19.27.0.0.0
*/

-- Step 131.1 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus sys/Sys605014@dr as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue May 27 13:36:31 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
Version 19.27.0.0.0
*/

-- Step 132 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 132.1 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/


-- Step 132.2 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ rman target sys/Sys605014@pdbdb auxiliary sys/Sys605014@dr
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Tue May 27 13:52:33 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB (DBID=3260158620)
connected to auxiliary database: PDBDB (not mounted)

RMAN> duplicate target database for standby from active database DB_FILE_NAME_CONVERT '+DATA/PDBDB/','+DATA/DR/','+ARC/PDBDB/','+ARC/DR/';

duplicate target database for standby from active database DB_FILE_NAME_CONVERT '+DATA/PDBDB/','+DATA/DR/','+ARC/PDBDB/','+ARC/DR/';
Starting Duplicate Db at 27-MAY-25
using target database control file instead of recovery catalog
allocated channel: ORA_AUX_DISK_1
channel ORA_AUX_DISK_1: SID=130 device type=DISK

contents of Memory Script:
{
   backup as copy reuse
   passwordfile auxiliary format  '/opt/app/oracle/product/19c/db_1/dbs/orapwpdbdb1'   ;
}
executing Memory Script

Starting backup at 27-MAY-25
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=391 instance=pdbdb1 device type=DISK
Finished backup at 27-MAY-25

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

Total System Global Area    9663675432 bytes

Fixed Size                    13921320 bytes
Variable Size               1509949440 bytes
Database Buffers            8120172544 bytes
Redo Buffers                  19632128 bytes

Starting restore at 27-MAY-25
allocated channel: ORA_AUX_DISK_1
channel ORA_AUX_DISK_1: SID=254 device type=DISK

channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: restoring control file
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:03
output file name=+DATA/DR/CONTROLFILE/current.257.1202219635
output file name=+ARC/DR/CONTROLFILE/current.257.1202219637
Finished restore at 27-MAY-25

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

Starting restore at 27-MAY-25
using channel ORA_AUX_DISK_1

channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00001 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:16
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00003 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:15
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
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:04
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00009 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:01
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00010 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:08
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00011 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:07
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00012 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:03
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00013 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:04
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service pdbdb
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00014 to +DATA
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:01
Finished restore at 27-MAY-25

sql statement: alter system archive log current

contents of Memory Script:
{
   switch clone datafile all;
}
executing Memory Script

datafile 1 switched to datafile copy
input datafile copy RECID=17 STAMP=1202219731 file name=+DATA/DR/DATAFILE/system.258.1202219647
datafile 3 switched to datafile copy
input datafile copy RECID=18 STAMP=1202219731 file name=+DATA/DR/DATAFILE/sysaux.259.1202219661
datafile 4 switched to datafile copy
input datafile copy RECID=19 STAMP=1202219731 file name=+DATA/DR/DATAFILE/undotbs1.260.1202219677
datafile 5 switched to datafile copy
input datafile copy RECID=20 STAMP=1202219731 file name=+DATA/DR/35F3E097C7B9E171E063150610AC23C7/DATAFILE/system.261.1202219685
datafile 6 switched to datafile copy
input datafile copy RECID=21 STAMP=1202219731 file name=+DATA/DR/35F3E097C7B9E171E063150610AC23C7/DATAFILE/sysaux.262.1202219693
datafile 7 switched to datafile copy
input datafile copy RECID=22 STAMP=1202219731 file name=+DATA/DR/DATAFILE/users.263.1202219699
datafile 8 switched to datafile copy
input datafile copy RECID=23 STAMP=1202219731 file name=+DATA/DR/35F3E097C7B9E171E063150610AC23C7/DATAFILE/undotbs1.264.1202219701
datafile 9 switched to datafile copy
input datafile copy RECID=24 STAMP=1202219731 file name=+DATA/DR/DATAFILE/undotbs2.265.1202219705
datafile 10 switched to datafile copy
input datafile copy RECID=25 STAMP=1202219731 file name=+DATA/DR/35F450D5C13C3158E063150610ACC99A/DATAFILE/system.266.1202219707
datafile 11 switched to datafile copy
input datafile copy RECID=26 STAMP=1202219731 file name=+DATA/DR/35F450D5C13C3158E063150610ACC99A/DATAFILE/sysaux.267.1202219713
datafile 12 switched to datafile copy
input datafile copy RECID=27 STAMP=1202219731 file name=+DATA/DR/35F450D5C13C3158E063150610ACC99A/DATAFILE/undotbs1.268.1202219721
datafile 13 switched to datafile copy
input datafile copy RECID=28 STAMP=1202219731 file name=+DATA/DR/35F450D5C13C3158E063150610ACC99A/DATAFILE/undo_2.269.1202219725
datafile 14 switched to datafile copy
input datafile copy RECID=29 STAMP=1202219731 file name=+DATA/DR/35F450D5C13C3158E063150610ACC99A/DATAFILE/users.270.1202219727
Finished Duplicate Db at 27-MAY-25

RMAN> exit

Recovery Manager complete.
*/

-- Step 133 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue May 27 13:56:45 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
         1 PDBDB     pdbdb1           MOUNTED      27-MAY-25 pdbdr1.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  TO PRIMARY


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
         1         ONLINE  +ARC/DR/ONLINELOG/group_1.258.1202219735           YES          0
         1         ONLINE  +DATA/DR/ONLINELOG/group_1.271.1202219733          NO           0
         2         ONLINE  +DATA/DR/ONLINELOG/group_2.272.1202219735          NO           0
         2         ONLINE  +ARC/DR/ONLINELOG/group_2.259.1202219735           YES          0
         3         ONLINE  +DATA/DR/ONLINELOG/group_3.273.1202219735          NO           0
         3         ONLINE  +ARC/DR/ONLINELOG/group_3.260.1202219735           YES          0
         4         ONLINE  +DATA/DR/ONLINELOG/group_4.274.1202219735          NO           0
         4         ONLINE  +ARC/DR/ONLINELOG/group_4.261.1202219737           YES          0
         5         ONLINE  +ARC/DR/ONLINELOG/group_5.262.1202219737           YES          0
         5         ONLINE  +DATA/DR/ONLINELOG/group_5.275.1202219737          NO           0
         6         ONLINE  +DATA/DR/ONLINELOG/group_6.276.1202219737          NO           0
         6         ONLINE  +ARC/DR/ONLINELOG/group_6.263.1202219737           YES          0
         7         STANDBY +DATA/DR/ONLINELOG/group_7.277.1202219737          NO           0
         7         STANDBY +ARC/DR/ONLINELOG/group_7.264.1202219739           YES          0
         8         STANDBY +ARC/DR/ONLINELOG/group_8.265.1202219739           YES          0
         8         STANDBY +DATA/DR/ONLINELOG/group_8.278.1202219739          NO           0
         9         STANDBY +ARC/DR/ONLINELOG/group_9.266.1202219741           YES          0
         9         STANDBY +DATA/DR/ONLINELOG/group_9.279.1202219739          NO           0
        10         STANDBY +DATA/DR/ONLINELOG/group_10.280.1202219741         NO           0
        10         STANDBY +ARC/DR/ONLINELOG/group_10.267.1202219741          YES          0
        11         STANDBY +DATA/DR/ONLINELOG/group_11.281.1202219741         NO           0
        11         STANDBY +ARC/DR/ONLINELOG/group_11.268.1202219743          YES          0
        12         STANDBY +DATA/DR/ONLINELOG/group_12.282.1202219743         NO           0
        12         STANDBY +ARC/DR/ONLINELOG/group_12.269.1202219743          YES          0
        13         STANDBY +DATA/DR/ONLINELOG/group_13.283.1202219743         NO           0
        13         STANDBY +ARC/DR/ONLINELOG/group_13.270.1202219743          YES          0
        14         STANDBY +DATA/DR/ONLINELOG/group_14.284.1202219743         NO           0
        14         STANDBY +ARC/DR/ONLINELOG/group_14.271.1202219745          YES          0

SQL> SELECT b.thread#,a.group#,a.member,b.bytes FROM v$logfile a, v$log b  WHERE a.group#=b.group# ORDER BY b.group#;

   THREAD#     GROUP# MEMBER                                                  BYTES
---------- ---------- -------------------------------------------------- ----------
         1          1 +ARC/DR/ONLINELOG/group_1.258.1202219735             52428800
         1          1 +DATA/DR/ONLINELOG/group_1.271.1202219733            52428800
         1          2 +DATA/DR/ONLINELOG/group_2.272.1202219735            52428800
         1          2 +ARC/DR/ONLINELOG/group_2.259.1202219735             52428800
         2          3 +DATA/DR/ONLINELOG/group_3.273.1202219735            52428800
         2          3 +ARC/DR/ONLINELOG/group_3.260.1202219735             52428800
         2          4 +DATA/DR/ONLINELOG/group_4.274.1202219735            52428800
         2          4 +ARC/DR/ONLINELOG/group_4.261.1202219737             52428800
         1          5 +ARC/DR/ONLINELOG/group_5.262.1202219737             52428800
         1          5 +DATA/DR/ONLINELOG/group_5.275.1202219737            52428800
         2          6 +DATA/DR/ONLINELOG/group_6.276.1202219737            52428800
         2          6 +ARC/DR/ONLINELOG/group_6.263.1202219737             52428800

--Node 1
SQL> SELECT b.thread#,a.group#, a.type, a.member, b.bytes FROM v$logfile a, v$standby_log b WHERE a.group# = b.group# ORDER BY 2,4;

   THREAD#     GROUP# TYPE    MEMBER                                                  BYTES
---------- ---------- ------- -------------------------------------------------- ----------
         1          7 STANDBY +ARC/DR/ONLINELOG/group_7.264.1202219739             52428800
         1          7 STANDBY +DATA/DR/ONLINELOG/group_7.277.1202219737            52428800
         1          8 STANDBY +ARC/DR/ONLINELOG/group_8.265.1202219739             52428800
         1          8 STANDBY +DATA/DR/ONLINELOG/group_8.278.1202219739            52428800
         1          9 STANDBY +ARC/DR/ONLINELOG/group_9.266.1202219741             52428800
         1          9 STANDBY +DATA/DR/ONLINELOG/group_9.279.1202219739            52428800
         1         10 STANDBY +ARC/DR/ONLINELOG/group_10.267.1202219741            52428800
         1         10 STANDBY +DATA/DR/ONLINELOG/group_10.280.1202219741           52428800
         2         11 STANDBY +ARC/DR/ONLINELOG/group_11.268.1202219743            52428800
         2         11 STANDBY +DATA/DR/ONLINELOG/group_11.281.1202219741           52428800
         2         12 STANDBY +ARC/DR/ONLINELOG/group_12.269.1202219743            52428800
         2         12 STANDBY +DATA/DR/ONLINELOG/group_12.282.1202219743           52428800
         2         13 STANDBY +ARC/DR/ONLINELOG/group_13.270.1202219743            52428800
         2         13 STANDBY +DATA/DR/ONLINELOG/group_13.283.1202219743           52428800
         2         14 STANDBY +ARC/DR/ONLINELOG/group_14.271.1202219745            52428800
         2         14 STANDBY +DATA/DR/ONLINELOG/group_14.284.1202219743           52428800

SQL> SELECT * FROM v$logfile order by 1;

    GROUP# STATUS  TYPE    MEMBER                                             IS_     CON_ID
---------- ------- ------- -------------------------------------------------- --- ----------
         1         ONLINE  +ARC/DR/ONLINELOG/group_1.258.1202219735           YES          0
         1         ONLINE  +DATA/DR/ONLINELOG/group_1.271.1202219733          NO           0
         2         ONLINE  +DATA/DR/ONLINELOG/group_2.272.1202219735          NO           0
         2         ONLINE  +ARC/DR/ONLINELOG/group_2.259.1202219735           YES          0
         3         ONLINE  +DATA/DR/ONLINELOG/group_3.273.1202219735          NO           0
         3         ONLINE  +ARC/DR/ONLINELOG/group_3.260.1202219735           YES          0
         4         ONLINE  +DATA/DR/ONLINELOG/group_4.274.1202219735          NO           0
         4         ONLINE  +ARC/DR/ONLINELOG/group_4.261.1202219737           YES          0
         5         ONLINE  +ARC/DR/ONLINELOG/group_5.262.1202219737           YES          0
         5         ONLINE  +DATA/DR/ONLINELOG/group_5.275.1202219737          NO           0
         6         ONLINE  +DATA/DR/ONLINELOG/group_6.276.1202219737          NO           0
         6         ONLINE  +ARC/DR/ONLINELOG/group_6.263.1202219737           YES          0
         7         STANDBY +DATA/DR/ONLINELOG/group_7.277.1202219737          NO           0
         7         STANDBY +ARC/DR/ONLINELOG/group_7.264.1202219739           YES          0
         8         STANDBY +ARC/DR/ONLINELOG/group_8.265.1202219739           YES          0
         8         STANDBY +DATA/DR/ONLINELOG/group_8.278.1202219739          NO           0
         9         STANDBY +ARC/DR/ONLINELOG/group_9.266.1202219741           YES          0
         9         STANDBY +DATA/DR/ONLINELOG/group_9.279.1202219739          NO           0
        10         STANDBY +DATA/DR/ONLINELOG/group_10.280.1202219741         NO           0
        10         STANDBY +ARC/DR/ONLINELOG/group_10.267.1202219741          YES          0
        11         STANDBY +DATA/DR/ONLINELOG/group_11.281.1202219741         NO           0
        11         STANDBY +ARC/DR/ONLINELOG/group_11.268.1202219743          YES          0
        12         STANDBY +DATA/DR/ONLINELOG/group_12.282.1202219743         NO           0
        12         STANDBY +ARC/DR/ONLINELOG/group_12.269.1202219743          YES          0
        13         STANDBY +DATA/DR/ONLINELOG/group_13.283.1202219743         NO           0
        13         STANDBY +ARC/DR/ONLINELOG/group_13.270.1202219743          YES          0
        14         STANDBY +DATA/DR/ONLINELOG/group_14.284.1202219743         NO           0
        14         STANDBY +ARC/DR/ONLINELOG/group_14.271.1202219745          YES          0

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
[ ONLINE REDO LOG ]        1      1          1          0 +ARC/DR/ONLINELOG/group_1.258.1202219735                     UNUSED           YES             50
[ ONLINE REDO LOG ]        1      1          1          0 +DATA/DR/ONLINELOG/group_1.271.1202219733                    UNUSED           YES             50
[ ONLINE REDO LOG ]        1      2          1          0 +ARC/DR/ONLINELOG/group_2.259.1202219735                     UNUSED           YES             50
[ ONLINE REDO LOG ]        1      2          1          0 +DATA/DR/ONLINELOG/group_2.272.1202219735                    UNUSED           YES             50
[ ONLINE REDO LOG ]        1      5          1          0 +ARC/DR/ONLINELOG/group_5.262.1202219737                     CURRENT          NO              50
[ ONLINE REDO LOG ]        1      5          1          0 +DATA/DR/ONLINELOG/group_5.275.1202219737                    CURRENT          NO              50
[ STANDBY REDO LOG ]       1      7          1        130 +ARC/DR/ONLINELOG/group_7.264.1202219739                     ACTIVE           YES             50
[ STANDBY REDO LOG ]       1      7          1        130 +DATA/DR/ONLINELOG/group_7.277.1202219737                    ACTIVE           YES             50
[ STANDBY REDO LOG ]       1      8          1          0 +ARC/DR/ONLINELOG/group_8.265.1202219739                     UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      8          1          0 +DATA/DR/ONLINELOG/group_8.278.1202219739                    UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      9          1          0 +ARC/DR/ONLINELOG/group_9.266.1202219741                     UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1      9          1          0 +DATA/DR/ONLINELOG/group_9.279.1202219739                    UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1     10          1          0 +ARC/DR/ONLINELOG/group_10.267.1202219741                    UNASSIGNED       YES             50
[ STANDBY REDO LOG ]       1     10          1          0 +DATA/DR/ONLINELOG/group_10.280.1202219741                   UNASSIGNED       YES             50

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
Version 19.27.0.0.0
*/

-- Step 134 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/dbs

-- Step 134.1 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ pwd
/*
/opt/app/oracle/product/19c/db_1/dbs
*/

-- Step 134.2 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ ll -ltrh initpdbdb1.ora
/*
-rw-r--r-- 1 oracle oinstall 1.4K May 27 13:20 initpdbdb1.ora
*/

-- Step 134.3 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ mv initpdbdb1.ora initpdbdb1.ora.backup
[oracle@pdbdr1 dbs]$ mv spfilepdbdb1.ora spfilepdbdb1.ora.backup

-- Step 135 -->> On Node 2 - DR
[grid@pdbdr1 ~]$ asmcmd
/*
ASMCMD> cd +DATA/DR/PARAMETERFILE/
ASMCMD> ls
spfile.285.1202220023
ASMCMD> exit
*/

-- Step 136 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/dbs

-- Step 136.1 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ pwd
/*
/opt/app/oracle/product/19c/db_1/dbs
*/

-- Step 136.2 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ echo "SPFILE='+DATA/DR/PARAMETERFILE/spfile.285.1202220023'" > initpdbdb1.ora

-- Step 136.3 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ ll -ltrh initpdbdb1.ora
/*
-rw-r--r-- 1 oracle oinstall 54 May 27 14:03 initpdbdb1.ora
*/

-- Step 136.4 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ cat initpdbdb1.ora
/*
SPFILE='+DATA/DR/PARAMETERFILE/spfile.285.1202220023'
*/

-- Step 136.5 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ scp -r initpdbdb1.ora oracle@pdbdr2:/opt/app/oracle/product/19c/db_1/dbs/initpdbdb2.ora
/*
initpdbdb1.ora                                                             100%   57    45.3KB/s   00:00
*/

-- Step 136.6 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ ssh oracle@pdbdr2

[oracle@pdbdr2 ~]$ ll /opt/app/oracle/product/19c/db_1/dbs/ | grep initpdbdb2.ora
/*
-rw-r--r-- 1 oracle oinstall   54 May 27 14:03 initpdbdb2.ora
*/

-- Step 136.7 -->> On Node 2 - DR
[oracle@pdbdr2 ~]$ cat /opt/app/oracle/product/19c/db_1/dbs/initpdbdb2.ora
/*
SPFILE='+DATA/DR/PARAMETERFILE/spfile.285.1202220023'
*/

-- Step 136.8 -->> On Node 1 - DR
[oracle@pdbdr1 dbs]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue May 27 14:06:07 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> !ls
+DATA_BK  hc_pdbdb1.dat  init.ora  initpdbdb1.ora  initpdbdb1.ora.backup  orapwpdbdb1  spfilepdbdb1.ora.backup

SQL> startup mount
ORACLE instance started.

Total System Global Area 9663675432 bytes
Fixed Size                 13921320 bytes
Variable Size            1509949440 bytes
Database Buffers         8120172544 bytes
Redo Buffers               19632128 bytes
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
         1 PDBDB     pdbdb1           MOUNTED      27-MAY-25 pdbdr1.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED

SQL> show parameter spfile

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
spfile                               string      +DATA/DR/PARAMETERFILE/spfile.285.1202220023

SQL> show parameter control_files

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
control_files                        string       +DATA/DR/CONTROLFILE/current.257.1202219635,
                                                  +ARC/DR/CONTROLFILE/current.257.1202219637

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

Total System Global Area 9663675432 bytes
Fixed Size                 13921320 bytes
Variable Size            1509949440 bytes
Database Buffers         8120172544 bytes
Redo Buffers               19632128 bytes
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
         1 PDBDB     pdbdb1           MOUNTED      27-MAY-25 pdbdr1.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED

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
Version 19.27.0.0.0
*/

-- Step 137 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ which srvctl
/*
/opt/app/oracle/product/19c/db_1/bin/srvctl
*/

-- Step 137.1 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ srvctl add database -d pdbdb -o /opt/app/oracle/product/19c/db_1 -r physical_standby -s mount
[oracle@pdbdr1 ~]$ srvctl modify database -d pdbdb -spfile +DATA/DR/PARAMETERFILE/spfile.285.1202220023
[oracle@pdbdr1 ~]$ srvctl modify database -d pdbdb -diskgroup "DATA,ARC"
[oracle@pdbdr1 ~]$ srvctl add instance -d pdbdb -i pdbdb1 -n pdbdr1
[oracle@pdbdr1 ~]$ srvctl add instance -d pdbdb -i pdbdb2 -n pdbdr2

-- Step 137.2 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ srvctl config database -d pdbdb 
/*
Database unique name: pdbdb
Database name:
Oracle home: /opt/app/oracle/product/19c/db_1
Oracle user: oracle
Spfile: +DATA/DR/PARAMETERFILE/spfile.285.1202220023
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

-- Step 138 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue May 27 14:13:43 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

SQL> shut immediate
ORA-01109: database not open


Database dismounted.
ORACLE instance shut down.
SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0
*/

-- Step 138 -->> On Node 1 - DR
[oracle@pdbdr1/pdbdr2 ~]$ srvctl start database -d pdbdb -o mount
[oracle@pdbdr1/pdbdr2 ~]$ srvctl status database -d pdbdb
/*
Instance pdbdb1 is running on node pdbdr1
Instance pdbdb2 is running on node pdbdr2
*/

-- Step 138.1 -->> On Node 1 - DR
[oracle@pdbdr1/pdbdr2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdbdr1. Instance status: Mounted (Closed).
Instance pdbdb2 is running on node pdbdr2. Instance status: Mounted (Closed).
*/

-- Step 139 -->> On Node 1 - DR
[oracle@pdbdr1/pdbdr2 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue May 27 14:15:55 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
         1 PDBDB     pdbdb1           MOUNTED      27-MAY-25 pdbdr1.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED
         2 PDBDB     pdbdb2           MOUNTED      27-MAY-25 pdbdr2.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0
*/

-- Step 140 -->> On Node 1 - DR
[root@pdbdr1/pdbdr2 ~]# cd /opt/app/19c/grid/bin/

-- Step 140.1 -->> On Node 1 - DR
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

-- Step 141 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue May 27 14:18:34 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
         1 PDBDB     pdbdb1           OPEN         27-MAY-25 pdb1.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  TO STANDBY
         2 PDBDB     pdbdb2           OPEN         27-MAY-25 pdb2.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  TO STANDBY

SQL> alter system archive log current;

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           140          1
            33          2

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0
*/

-- Step 142 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue May 27 14:20:49 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
         1 PDBDB     pdbdb1           MOUNTED      27-MAY-25 pdbdr1.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED
         2 PDBDB     pdbdb2           MOUNTED      27-MAY-25 pdbdr2.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  RECOVERY NEEDED

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;
--SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION INSTANCES ALL;

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           130          1
            22          2

SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         2         23 APPLYING_LOG        266 MRP0

SQL> SELECT sequence#,status,block#,process FROM v$managed_standby ;

 SEQUENCE# STATUS           BLOCK# PROCESS
---------- ------------ ---------- ---------
         0 CONNECTED             0 ARCH
         0 ALLOCATED             0 DGRD
         0 ALLOCATED             0 DGRD
        22 CLOSING            2048 ARCH
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
         0 CONNECTED             0 ARCH
       130 CLOSING               1 ARCH
         0 CONNECTED             0 ARCH
         0 IDLE                  0 RFS
        23 IDLE                290 RFS
         0 IDLE                  0 RFS
       131 IDLE                281 RFS
        23 APPLYING_LOG        290 MRP0

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/

-- Step 143 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ asmcmd -p
/*
ASMCMD [+] > cd +DATA/DR
ASMCMD [+DATA/DR] > ls
35F3E097C7B9E171E063150610AC23C7/
35F450D5C13C3158E063150610ACC99A/
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
PASSWORD  UNPROT  COARSE   MAY 27 14:00:00  N    orapwpdbdb => +DATA/DB_UNKNOWN/PASSWORD/pwddb_unknown.286.1202221547

ASMCMD [+DATA/DR/PASSWORDFILE] > ls
orapwpdbdb
ASMCMD [+DATA/DR/PASSWORDFILE] > exit
*/

-- Step 144 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ srvctl modify database -d pdbdb -pwfile +DATA/DR/PASSWORDFILE/orapwpdbdb

-- Step 144.1 -->> On Node 1 - DR
[oracle@pdbdr1/pdbdr2 ~]$ srvctl config database -d pdbdb
/*
Database unique name: pdbdb
Database name:
Oracle home: /opt/app/oracle/product/19c/db_1
Oracle user: oracle
Spfile: +DATA/DR/PARAMETERFILE/spfile.285.1202220023
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

-- Step 145 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 145.1 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 145.2 -->> On Node 1 - DR
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

-- Step 145.3 -->> On Node 1 - DR
[oracle@pdbdr1 admin]$ tnsping dr
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 14:28:05

Copyright (c) 1997, 2025, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr1.unidev.org.np)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = dr)(UR=A)))
OK (0 msec)
*/

-- Step 146 -->> On Node 2 - DR
[oracle@pdbdr2 ~]$ cd $ORACLE_HOME/network/admin

-- Step 146.1 -->> On Node 1 - DR
[oracle@pdbdr2 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 146.2 -->> On Node 1 - DR
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

-- Step 146.3 -->> On Node 1 - DR
[oracle@pdbdr2 admin]$ tnsping dr
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 14:31:40

Copyright (c) 1997, 2025, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr1.unidev.org.np)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = dr)(UR=A)))
OK (0 msec)
*/

-- Step 147 -->> On Node 1 - DC
[oracle@pdb1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 147.1 -->> On Node 1 - DC
[oracle@pdb1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 147.2 -->> On Node 1 - DC
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
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.6.21)(PORT = 1521))
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

-- Step 147.3 -->> On Node 1 - DC
[oracle@pdb1 admin]$ tnsping dr
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 14:33:24

Copyright (c) 1997, 2025, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr1.unidev.org.np)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = dr)))
OK (0 msec)
*/

-- Step 148 -->> On Node 2 - DC
[oracle@pdb2 ~]$ cd $ORACLE_HOME/network/admin

-- Step 148.1 -->> On Node 2 - DC
[oracle@pdb2 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 148.2 -->> On Node 2 - DC
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
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.6.49)(PORT = 1521))
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

-- Step 148.3 -->> On Node 2 - DC
[oracle@pdb2 admin]$ tnsping dr
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 14:33:38

Copyright (c) 1997, 2025, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr1.unidev.org.np)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = dr)))
OK (10 msec)
*/

-- Step 149 -->> On Node 1 - DC
[oracle@pdbdr1 ~]$ cd $ORACLE_HOME/network/admin

-- Step 149.1 -->> On Node 1 - DC
[oracle@pdb1 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 149.2 -->> On Node 1 - DC
[oracle@pdbdr1 admin]$ ll | grep listener.ora
/*
-rw-r--r-- 1 oracle oinstall  312 May 27 13:25 listener.ora
*/

-- Step 149.3 -->> On Node 1 - DC
[oracle@pdbdr1 admin]$ ps -ef | grep tns
/*
root           7       2  0 May23 ?        00:00:00 [kworker/R-netns]
root          12       2  0 May23 ?        00:00:00 [kworker/u32:1-netns]
grid       48815       1  0 May23 ?        00:00:10 /opt/app/19c/grid/bin/tnslsnr ASMNET1LSNR_ASM -no_crs_notify -inherit
grid       49871       1  0 May23 ?        00:00:11 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid       49931       1  0 May23 ?        00:00:11 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid       51868       1  0 May23 ?        00:00:12 /opt/app/19c/grid/bin/tnslsnr LISTENER -no_crs_notify -inherit
oracle   3591938       1  0 13:26 ?        00:00:00 /opt/app/oracle/product/19c/db_1/bin/tnslsnr listener1 -inherit
oracle   3632978 3628272  0 14:34 pts/1    00:00:00 grep --color=auto tns
*/

-- Step 149.4 -->> On Node 1 - DC
[oracle@pdbdr1 admin]$ lsnrctl status listener1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 14:35:00

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))
STATUS of the LISTENER
------------------------
Alias                     listener1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                27-MAY-2025 13:26:04
Uptime                    0 days 1 hr. 8 min. 56 sec
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

-- Step 149.5 -->> On Node 1 - DC
[oracle@pdbdr1 admin]$ lsnrctl stop listener1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 14:35:14

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))
The command completed successfully
*/

-- Step 149.6 -->> On Node 1 - DC
[oracle@pdbdr1 admin]$ lsnrctl status listener1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 14:35:29

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=pdbdr1.unidev.org.np)(PORT=1541)))
TNS-12541: TNS:no listener
 TNS-12560: TNS:protocol adapter error
  TNS-00511: No listener
   Linux Error: 111: Connection refused
*/

-- Step 149.7 -->> On Node 1 - DC
[oracle@pdbdr1 admin]$ ps -ef | grep tns
/*
root           7       2  0 May23 ?        00:00:00 [kworker/R-netns]
root          12       2  0 May23 ?        00:00:00 [kworker/u32:1-netns]
grid       48815       1  0 May23 ?        00:00:10 /opt/app/19c/grid/bin/tnslsnr ASMNET1LSNR_ASM -no_crs_notify -inherit
grid       49871       1  0 May23 ?        00:00:11 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid       49931       1  0 May23 ?        00:00:11 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid       51868       1  0 May23 ?        00:00:12 /opt/app/19c/grid/bin/tnslsnr LISTENER -no_crs_notify -inherit
oracle   3634322 3628272  0 14:35 pts/1    00:00:00 grep --color=auto tns
*/


-- Step 150 -->> On Node 1 - DC
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue May 27 14:36:05 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
         1 PDBDB     pdbdb1           OPEN         27-MAY-25 pdb1.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  TO STANDBY
         2 PDBDB     pdbdb2           OPEN         27-MAY-25 pdb2.unidev.org.np      READ WRITE ARCHIVELOG   PRIMARY          19.0.0.0.0        MAXIMUM PERFORMANCE  TO STANDBY

SQL> alter system archive log current;
SQL> alter system switch logfile;

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           134          1
            26          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0
*/

-- Step 151 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue May 27 14:38:08 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
         1 PDBDB     pdbdb1           MOUNTED      27-MAY-25 pdbdr1.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED
         2 PDBDB     pdbdb2           MOUNTED      27-MAY-25 pdbdr2.unidev.org.np    MOUNTED    ARCHIVELOG   PHYSICAL STANDBY 19.0.0.0.0        MAXIMUM PERFORMANCE  NOT ALLOWED

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           134          1
            26          2

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           130          1
            22          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         1        135 APPLYING_LOG        172 MRP0

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

Database altered.

--SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION INSTANCES ALL;

Database altered.

SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           134          1
            26          2

SQL>  SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL>  SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         2         27 APPLYING_LOG        324 MRP0

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0
*/

-- Step 152 -->> On Node 1 - DC
[grid@pdb1 ~]$ ps -ef | grep SCAN
/*
grid     2023771       1  0 May25 ?        00:00:06 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid     2023773       1  0 May25 ?        00:00:07 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid     3698737 3698543  0 14:42 pts/1    00:00:00 grep --color=auto SCAN
*/

-- Step 152.1 -->> On Node 1 - DC
[grid@pdb1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 14:42:52

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                25-MAY-2025 16:59:16
Uptime                    1 days 21 hr. 43 min. 35 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.26)(PORT=1521)))
Services Summary...
Service "35f450d5c13c3158e063150610acc99a" has 2 instance(s).
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

-- Step 152.2 -->> On Node 1 - DC
[grid@pdb1 ~]$ lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 14:43:04

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                25-MAY-2025 16:59:16
Uptime                    1 days 21 hr. 43 min. 47 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener_scan3/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN3)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.27)(PORT=1521)))
Services Summary...
Service "35f450d5c13c3158e063150610acc99a" has 2 instance(s).
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

-- Step 152.3 -->> On Node 1 - DC
[grid@pdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 14:43:16

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                25-MAY-2025 16:53:06
Uptime                    1 days 21 hr. 50 min. 10 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.21)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.23)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "35f450d5c13c3158e063150610acc99a" has 1 instance(s).
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

-- Step 153 -->> On Node 2 - DC
[grid@pdb2 ~]$ ps -ef | grep SCAN
/*
grid     1910030       1  0 May25 ?        00:00:05 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid     3626054 3625997  0 14:43 pts/1    00:00:00 grep --color=auto SCAN
*/

-- Step 153.1 -->> On Node 2 - DC
[grid@pdb2 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 14:44:04

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                25-MAY-2025 17:00:52
Uptime                    1 days 21 hr. 43 min. 11 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.25)(PORT=1521)))
Services Summary...
Service "35f450d5c13c3158e063150610acc99a" has 2 instance(s).
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

-- Step 153.2 -->> On Node 2 - DC
[grid@pdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 14:44:15

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                25-MAY-2025 17:00:51
Uptime                    1 days 21 hr. 43 min. 24 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.22)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.24)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "35f450d5c13c3158e063150610acc99a" has 1 instance(s).
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

-- Step 154 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ ps -ef | grep SCAN
/*
grid       49871       1  0 May23 ?        00:00:11 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid       49931       1  0 May23 ?        00:00:11 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid     3639815 3639634  0 14:46 pts/1    00:00:00 grep --color=auto SCAN
*/

-- Step 154.1 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 14:46:21

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-MAY-2025 13:05:14
Uptime                    4 days 1 hr. 41 min. 7 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.53)(PORT=1521)))
Services Summary...
Service "dr" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 154.2 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 14:46:32

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-MAY-2025 13:05:15
Uptime                    4 days 1 hr. 41 min. 16 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener_scan3/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN3)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.54)(PORT=1521)))
Services Summary...
Service "dr" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/
-- Step 154.3 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 14:46:44

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-MAY-2025 13:05:54
Uptime                    4 days 1 hr. 40 min. 50 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.48)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.50)(PORT=1521)))
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

-- Step 155 -->> On Node 2 - DR
[grid@pdbdr2 ~]$ ps -ef | grep SCAN
/*
grid       46626       1  0 May23 ?        00:00:09 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid     3453096 3453030  0 14:44 pts/1    00:00:00 grep --color=auto SCAN
*/

-- Step 155.1 -->> On Node 2 - DR
[grid@pdbdr2 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 14:45:56

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-MAY-2025 13:12:43
Uptime                    4 days 1 hr. 33 min. 13 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr2/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.52)(PORT=1521)))
Services Summary...
Service "dr" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 155.2 -->> On Node 2 - DR
[grid@pdbdr2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 14:47:20

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-MAY-2025 13:13:06
Uptime                    4 days 1 hr. 34 min. 13 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.49)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.51)(PORT=1521)))
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

-- Step 156 -->> On Both Node's - DC
[oracle@pdb1/pdb2 ~]$ rman target /
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Tue May 27 14:50:47 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB (DBID=3260158620)

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

-- Step 157 -->> On Both Node's - DR
[oracle@pdbdr1/pdbdr2 ~]$ rman target /
/*

Recovery Manager: Release 19.0.0.0.0 - Production on Tue May 27 14:47:52 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB (DBID=3260158620, not open)

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

-- Step 158 -->> On Both Node's - DR
[oracle@pdbdr1/pdbdr2 ~]$ cd $ORACLE_HOME/network/admin

-- Step 158.1 -->> On Both Node's - DR
[oracle@pdbdr1/pdbdr2 admin]$ pwd
/*
/opt/app/oracle/product/19c/db_1/network/admin
*/

-- Step 158.2 -->> On Both Node's - DR
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

-- Step 158.2 -->> On Both Node's - DR
[oracle@pdbdr1/pdbdr2 ~]$ tnsping SBXPDB
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 14:53:39

Copyright (c) 1997, 2025, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdbdr-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = SBXPDB)))
OK (0 msec)
*/

-- Step 159 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ mkdir -p /backup/script
[oracle@pdbdr1 ~]$ chmod -R 775 /backup/script

-- Step 159.1 -->> On Node 1 - DR
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

-- Step 159.2 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ /backup/script/dr_archivedelete.sh

-- Step 160 -->> On Node 1 - DR
[root@pdbdr1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/19c/grid:N
pdbdb:/opt/app/oracle/product/19c/db_1:N
pdbdb1:/opt/app/oracle/product/19c/db_1:N
*/

-- Step 161 -->> On Node 2 - DR
[root@pdbdr2 ~]# vi /etc/oratab
/*
+ASM2:/opt/app/19c/grid:N
pdbdb:/opt/app/oracle/product/19c/db_1:N
pdbdb2:/opt/app/oracle/product/19c/db_1:N
*/

-- Step 162 -->> On Node 2 - DR
-- To Fix the ADRCI log if occured in remote nodes
-- Step Fix.1 -->> On Node 2
[oracle@pdbdr2 ~]$ adrci
/*
ADRCI: Release 19.0.0.0.0 - Production on Tue May 27 15:00:09 2025

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

No ADR base is set

adrci> exit
*/

-- Step Fix.2 -->> On Node 2
[oracle@pdbdr1 ~]$ ls -ltr /opt/app/oracle/product/19c/db_1/log/diag/
/*
-rw-r----- 1 oracle asmadmin 16 May 27 14:14 adrci_dir.mif
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
ADRCI: Release 19.0.0.0.0 - Production on Tue May 27 15:01:27 2025

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

ADR base = "/opt/app/oracle"
adrci> show home
ADR Homes:
diag/rdbms/dr/pdbdb2
diag/asm/+asm/+ASM2
diag/crs/pdbdr2/crs
diag/clients/user_root/host_3453532781_110
diag/clients/user_oracle/RMAN_3453532781_110
diag/tnslsnr/pdbdr2/asmnet1lsnr_asm
diag/tnslsnr/pdbdr2/listener_scan1
diag/tnslsnr/pdbdr2/listener
diag/asmtool/user_grid/host_3453532781_110
diag/asmcmd/user_root/pdbdr2.unidev.org.np
diag/asmcmd/user_grid/pdbdr2.unidev.org.np
diag/kfod/pdbdr2/kfod
adrci> exit
*/

-- Step 163 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue May 27 16:17:53 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
Version 19.27.0.0.0
*/

-- Step 164 -->> On Node 1 - DR
[root@pdbdr1 ~]# cd /opt/app/19c/grid/bin/

-- Step 164.1 -->> On Node 1 - DR
[root@pdbdr1 bin]# ./crsctl stop cluster -all

-- Step 164.2 -->> On Node 1 - DR
[root@pdbdr1 bin]# ./crsctl start cluster -all

-- Step 164.3 -->> On Node 1 - DR
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
ora.driver.afd
      1        ONLINE  ONLINE       pdbdr1                   STABLE
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

-- Step 164.4 -->> On Node 2 - DR
[root@pdbdr2 ~]# cd /opt/app/19c/grid/bin/

-- Step 164.5 -->> On Node 2 - DR
[root@pdbdr2 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdbdr2                   Started,STABLE
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
ora.driver.afd
      1        ONLINE  ONLINE       pdbdr2                   STABLE
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

-- Step 165 -->> On Both Nodes - DR
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
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.LISTENER_SCAN3.lsnr
      1        ONLINE  ONLINE       pdbdr2                   STABLE
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
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.pdbdb.db
      1        ONLINE  INTERMEDIATE pdbdr1                   Mounted (Closed),HOME=/opt/app/oracle/product/19c/db_1,STABLE
      2        ONLINE  INTERMEDIATE pdbdr2                   Mounted (Closed),HOME=/opt/app/oracle/product/19c/db_1,STABLE
ora.pdbdr1.vip
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.pdbdr2.vip
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.qosmserver
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       pdbdr1                   STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       pdbdr2                   STABLE
ora.scan3.vip
      1        ONLINE  ONLINE       pdbdr2                   STABLE
--------------------------------------------------------------------------------
*/

-- Step 166 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 16:23:10

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                27-MAY-2025 16:20:52
Uptime                    0 days 0 hr. 2 min. 17 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.48)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.50)(PORT=1521)))
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

-- Step 166.1 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ ps -ef | grep SCAN
/*
grid     3707487       1  0 16:24 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid     3707492       1  0 16:24 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid     3715793 3703943  0 16:27 pts/1    00:00:00 grep --color=auto SCAN
*/

-- Step 166.2 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 16:28:00

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                27-MAY-2025 16:24:07
Uptime                    0 days 0 hr. 3 min. 53 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.53)(PORT=1521)))
Services Summary...
Service "dr" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 166.3 -->> On Node 1 - DR
[grid@pdbdr1 ~]$ lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 16:28:16

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                27-MAY-2025 16:24:07
Uptime                    0 days 0 hr. 4 min. 8 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener_scan3/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN3)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.54)(PORT=1521)))
Services Summary...
Service "dr" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 167 -->> On Node 2 - DR
[grid@pdbdr2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 16:27:40

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                27-MAY-2025 16:26:04
Uptime                    0 days 0 hr. 1 min. 36 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.49)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.51)(PORT=1521)))
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

-- Step 167.1 -->> On Node 2 - DR
[grid@pdbdr2 ~]$ ps -ef | grep SCAN
/*
grid     3526016       1  0 16:26 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid     3531834 3528505  0 16:28 pts/1    00:00:00 grep --color=auto SCAN
*/

-- Step 167.2 -->> On Node 2 - DR
[grid@pdbdr2 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 16:29:12

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                27-MAY-2025 16:26:05
Uptime                    0 days 0 hr. 3 min. 7 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr2/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.52)(PORT=1521)))
Services Summary...
Service "dr" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 168 -->> On Both Nodes - DR
[oracle@pdbdr1/pdbdr2 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): pdbdr2,pdbdr1
*/

-- Step 169 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 16:29:48

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                27-MAY-2025 16:20:52
Uptime                    0 days 0 hr. 8 min. 56 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.48)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.50)(PORT=1521)))
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

-- Step 170 -->> On Node 2 - DR
[oracle@pdbdr2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2025 16:29:49

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                27-MAY-2025 16:26:04
Uptime                    0 days 0 hr. 3 min. 45 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdbdr2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.49)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.51)(PORT=1521)))
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

-- Step 171 -->> On Both Nodes - DR
[oracle@pdbdr1/pdbdr2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdbdr1. Instance status: Mounted (Closed).
Instance pdbdb2 is running on node pdbdr2. Instance status: Mounted (Closed).
*/

-- Step 172 -->> On Node 1 - DR
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Tue May 27 16:30:28 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
           134          1
            26          2

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           134          1
            26          2

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0
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

Total System Global Area 9663675432 bytes
Fixed Size                 13921320 bytes
Variable Size            1509949440 bytes
Database Buffers         8120172544 bytes
Redo Buffers               19632128 bytes
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

Total System Global Area 9663675432 bytes
Fixed Size                 13921320 bytes
Variable Size            1509949440 bytes
Database Buffers         8120172544 bytes
Redo Buffers               19632128 bytes
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
   INST_ID PROCESS      THREAD#  SEQUENCE# STATUS
---------- --------- ---------- ---------- ------------
         1 ARCH               0          0 CONNECTED
         1 DGRD               0          0 ALLOCATED
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
         1 RFS                2          0 IDLE
         1 RFS                2         37 IDLE
         1 RFS                1          0 IDLE
         1 RFS                1        143 IDLE
         1 MRP0               1        143 APPLYING_LOG
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
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
         2 DGRD               0          0 ALLOCATED
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
SQL*Plus: Release 19.0.0.0.0 - Production on Wed May 28 11:32:38 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
           146          1
            37          2

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
Version 19.27.0.0.0
*/

-- Step 4
--Verify the switchover status on the primary database:
[oracle@pdbdr1 ~]$  sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Wed May 28 11:34:11 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
           146          1
            37          2

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           146          1
            37          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         1        147 APPLYING_LOG        561 MRP0

SQL> set linesize 9999
SQL> select NAME, VALUE, DATUM_TIME from V$DATAGUARD_STATS;

NAME                   VALUE        DATUM_TIME
---------------------- ------------ -------------------
transport lag          +00 00:00:00 05/28/2025 11:35:54
apply lag              +00 00:00:00 05/28/2025 11:35:54
apply finish time                  
estimated startup time 34

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0
*/

-- Step 5
--Commit to switchover to primary with session shutdown:
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Wed May 28 11:37:23 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

SQL> select name, open_mode, db_unique_name, database_role from v$database;

NAME      OPEN_MODE            DB_UNIQUE_NAME                 DATABASE_ROLE
--------- -------------------- ------------------------------ ----------------
PDBDB     READ WRITE           pdbdb                          PRIMARY

SQL> alter database commit to switchover to physical standby with session shutdown;

Database altered.

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0
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
SQL*Plus: Release 19.0.0.0.0 - Production on Wed May 28 11:40:24 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
Version 19.27.0.0.0
*/

-- Step 10
--Commit to switchover to primary with session shutdown:
[oracle@pdbdr1 ~]$  sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Wed May 28 11:40:59 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
Version 19.27.0.0.0
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
SQL*Plus: Release 19.0.0.0.0 - Production on Wed May 28 11:44:24 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
           151          1
            41          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0
*/

-- Step 14
-- On the new standby (initially the primary), start the MRP:
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Wed May 28 11:45:43 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
         1        151 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         2         41 CLOSING               1 ARCH
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
         1        150 CLOSING           30720 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 IDLE                  0 RFS
         1          0 IDLE                  0 RFS
         1        152 IDLE                186 RFS
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
         2         40 CLOSING           73728 ARCH
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
         2         42 IDLE                785 RFS
         2          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         2         42 APPLYING_LOG        785 MRP0

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           153          1
            43          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0
*/

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------Perform Manual SwitchBack on Physical Standby from New Primary----------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

-- Step 15
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
SQL*Plus: Release 19.0.0.0.0 - Production on Wed May 28 11:50:35 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
Version 19.27.0.0.0
*/

-- Step 18
-- Verify the SwitchBack status on the primary database:
[oracle@pdb1 ~]$  sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Wed May 28 11:51:38 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
           153          1
            43          2

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           153          1
            43          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------


SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> SELECT thread#,sequence#,status,block#,process FROM gv$managed_standby WHERE status IN ('APPLYING_LOG','RECEIVING');

   THREAD#  SEQUENCE# STATUS           BLOCK# PROCESS
---------- ---------- ------------ ---------- ---------
         2         44 APPLYING_LOG        277 MRP0

SQL> set linesize 9999
SQL> select NAME, VALUE, DATUM_TIME from V$DATAGUARD_STATS;

NAME                   VALUE        DATUM_TIME
---------------------- ------------ -------------------
transport lag          +00 00:00:00 05/28/2025 11:53:17
apply lag              +00 00:00:00 05/28/2025 11:53:17
apply finish time
estimated startup time 34

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0
*/

-- Step 19
--Commit to switchover to physical standby with session shutdown
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Wed May 28 11:54:07 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

SQL> select name, open_mode, db_unique_name, database_role from v$database;

NAME      OPEN_MODE            DB_UNIQUE_NAME                 DATABASE_ROLE
--------- -------------------- ------------------------------ ----------------
PDBDB     READ WRITE           dr                             PRIMARY

SQL> alter database commit to switchover to physical standby with session shutdown;

Database altered.

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0
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
SQL*Plus: Release 19.0.0.0.0 - Production on Wed May 28 11:55:57 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
Version 19.27.0.0.0
*/

-- Step 24
--Commit to switchover to primary with session shutdown:
[oracle@pdb1 ~]$  sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Wed May 28 11:56:29 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
Version 19.27.0.0.0
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
SQL*Plus: Release 19.0.0.0.0 - Production on Wed May 28 12:02:00 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
Version 19.27.0.0.0
*/

-- Step 29
-- On the old standby, start the MRP:
[oracle@pdbdr1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Wed May 28 12:03:43 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
           159          1
            49          2

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
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 ALLOCATED             0 DGRD
         0          0 ALLOCATED             0 DGRD
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         1        159 CLOSING               1 ARCH
         1        158 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         2         48 CLOSING               1 ARCH
         2         46 CLOSING           71680 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         1        156 CLOSING           73728 ARCH
         2         47 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         2         49 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         1        157 CLOSING               1 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         0          0 CONNECTED             0 ARCH
         2         50 IDLE                335 RFS
         0          0 IDLE                  0 RFS
         2          0 IDLE                  0 RFS
         0          0 IDLE                  0 RFS
         1        160 IDLE                322 RFS
         1          0 IDLE                  0 RFS
         2         50 APPLYING_LOG        335 MRP0

SQL> SELECT MAX(sequence#), thread# FROM v$archived_log WHERE applied='YES' GROUP BY thread#;

MAX(SEQUENCE#)    THREAD#
-------------- ----------
           159          1
            49          2

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;

ERROR
-----------------------------------------------------------------

SQL> SELECT * FROM gv$archive_gap;

no rows selected

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0
*/