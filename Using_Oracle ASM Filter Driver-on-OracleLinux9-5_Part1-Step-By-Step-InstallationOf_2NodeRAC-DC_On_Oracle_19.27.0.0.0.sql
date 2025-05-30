----------------------------------------------------------------
-------------Two Node rac Setup on VM Workstation---------------
----------------------------------------------------------------
-- Step 0 -->> 2 Node rac on VM -->> On both Node
--For OS Oracle Linux 9.5 => boot OracleLinux-R9-U5-x86_64-dvd.iso
--Using Oracle ASM Filter Driver and Fixing The kernel Version 5.14.0-503.11.1,
--As per as Oracle Doucument 1369107.1 we have to Fix as:

-- Step 0.0 -->>  2 Node rac on VM -->> On both Node
[root@pdb1/pdb2 ~]# df -Th
/*
Filesystem               Type      Size  Used Avail Use% Mounted on
devtmpfs                 devtmpfs  4.0M     0  4.0M   0% /dev
tmpfs                    tmpfs     9.6G     0  9.6G   0% /dev/shm
tmpfs                    tmpfs     3.9G  9.5M  3.9G   1% /run
/dev/mapper/ol_pdb1-root xfs        70G  576M   70G   1% /
/dev/mapper/ol_pdb1-usr  xfs        15G  7.0G  8.0G  47% /usr
/dev/mapper/ol_pdb1-var  xfs        15G  1.5G   14G  10% /var
/dev/mapper/ol_pdb1-tmp  xfs        15G  140M   15G   1% /tmp
/dev/sda1                xfs       2.0G  588M  1.4G  30% /boot
/dev/mapper/ol_pdb1-opt  xfs        70G  939M   70G   2% /opt
/dev/mapper/ol_pdb1-home xfs        15G  140M   15G   1% /home
tmpfs                    tmpfs     2.0G   92K  2.0G   1% /run/user/0
/dev/sr0                 iso9660    12G   12G     0 100% /run/media/root/OL-9-5-0-BaseOS-x86_64
*/

-- Step 1 -->> On both Node
[root@pdb1/pdb2 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

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
[root@pdb1/pdb2 ~]# grubby --update-kernel ALL --args selinux=0

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

-- Step 5 -->> On Both Nodes
[root@pdb1/pdb2 ~]# nmtui
--OR--
-- Step 5 -->> On Node 1
[root@pdb1 ~]# vi /etc/NetworkManager/system-connections/ens192.nmconnection
/*
[connection]
id=ens192
uuid=9ff98fa6-f24d-3709-8add-ca9678e5c2ce
type=ethernet
autoconnect-priority=-999
interface-name=ens192

[ethernet]

[ipv4]
address1=192.168.6.21/24,192.168.6.1
dns=127.0.0.1;192.168.4.11;192.168.4.12;
method=manual

[ipv6]
addr-gen-mode=eui64
method=ignore

[proxy]
*/

-- Step 6 -->> On Node 1
[root@pdb1 ~]# vi /etc/NetworkManager/system-connections/ens224.nmconnection
/*
[connection]
id=ens224
uuid=7f5d1b60-1025-3dc3-b51e-c9dd9337be3b
type=ethernet
autoconnect-priority=-999
interface-name=ens224

[ethernet]

[ipv4]
address1=10.10.10.21/24
method=manual

[ipv6]
addr-gen-mode=eui64
method=ignore

[proxy]
*/

-- Step 7 -->> On Node 2
[root@pdb2 ~]# vi /etc/NetworkManager/system-connections/ens192.nmconnection
/*
[connection]
id=ens192
uuid=028cf8fd-4324-3faa-9839-98a8cb91e7ce
type=ethernet
autoconnect-priority=-999
interface-name=ens192

[ethernet]

[ipv4]
address1=192.168.6.22/24,192.168.6.1
dns=127.0.0.1;192.168.4.11;192.168.4.12;
method=manual

[ipv6]
addr-gen-mode=eui64
method=ignore

[proxy]
*/

-- Step 8 -->> On Node 2
[root@pdb2 ~]# vi /etc/NetworkManager/system-connections/ens224.nmconnection
/*
[connection]
id=ens224
uuid=4e3e353b-0bda-392c-a016-832a82d5bdb0
type=ethernet
autoconnect-priority=-999
interface-name=ens224

[ethernet]

[ipv4]
address1=10.10.10.22/24
method=manual

[ipv6]
addr-gen-mode=eui64
method=ignore

[proxy]
*/

-- Step 9 -->> On Both Node
[root@pdb1/pdb2 ~]# systemctl restart network-online.target
[root@pdb1/pdb2 ~]# systemctl restart NetworkManager

-- Step 9.1 -->> On Node 1
[root@pdb1 ~]# systemctl status NetworkManager
/*
● NetworkManager.service - Network Manager
     Loaded: loaded (/usr/lib/systemd/system/NetworkManager.service; enabled; preset: enabled)
     Active: active (running) since Thu 2025-05-22 11:45:53 +0545; 16min ago
       Docs: man:NetworkManager(8)
   Main PID: 1150 (NetworkManager)
      Tasks: 3 (limit: 124664)
     Memory: 11.0M
        CPU: 251ms
     CGroup: /system.slice/NetworkManager.service
             └─1150 /usr/sbin/NetworkManager --no-daemon

May 22 11:45:53 pdb1.unidev.org.np NetworkManager[1150]: <info>  [1747893653.3947] device (ens192): Activation: successful, device activated.
May 22 11:45:53 pdb1.unidev.org.np NetworkManager[1150]: <info>  [1747893653.3956] manager: NetworkManager state is now CONNECTED_GLOBAL
May 22 11:45:53 pdb1.unidev.org.np NetworkManager[1150]: <info>  [1747893653.3959] device (ens224): state change: secondaries -> activated (reason 'none', managed-type: 'full')
May 22 11:45:53 pdb1.unidev.org.np NetworkManager[1150]: <info>  [1747893653.3968] device (ens224): Activation: successful, device activated.
May 22 11:45:53 pdb1.unidev.org.np NetworkManager[1150]: <info>  [1747893653.4038] manager: startup complete
May 22 11:45:53 pdb1.unidev.org.np NetworkManager[1150]: <info>  [1747893653.6856] modem-manager: ModemManager not available
May 22 11:45:53 pdb1.unidev.org.np NetworkManager[1150]: <info>  [1747893653.7443] modem-manager: ModemManager now available
May 22 11:46:04 pdb1.unidev.org.np NetworkManager[1150]: <info>  [1747893664.2186] agent-manager: agent[b997e169699a87c7,:1.32/org.gnome.Shell.NetworkAgent/42]: agent registered
May 22 11:46:16 pdb1.unidev.org.np NetworkManager[1150]: <info>  [1747893676.7522] agent-manager: agent[2f08aebff7922d60,:1.86/org.gnome.Shell.NetworkAgent/0]: agent registered
May 22 11:57:32 pdb1.unidev.org.np NetworkManager[1150]: <info>  [1747894352.2103] agent-manager: agent[2f08aebff7922d60,:1.86/org.gnome.Shell.NetworkAgent/0]: agent registered
*/

-- Step 9.2 -->> On Node 2
[root@pdb2 ~]#  systemctl status NetworkManager
/*
● NetworkManager.service - Network Manager
     Loaded: loaded (/usr/lib/systemd/system/NetworkManager.service; enabled; preset: enabled)
     Active: active (running) since Thu 2025-05-22 11:49:25 +0545; 13min ago
       Docs: man:NetworkManager(8)
   Main PID: 1151 (NetworkManager)
      Tasks: 3 (limit: 124664)
     Memory: 13.5M
        CPU: 242ms
     CGroup: /system.slice/NetworkManager.service
             └─1151 /usr/sbin/NetworkManager --no-daemon

May 22 11:49:25 pdb2.unidev.org.np NetworkManager[1151]: <info>  [1747893865.6150] device (ens192): Activation: successful, device activated.
May 22 11:49:25 pdb2.unidev.org.np NetworkManager[1151]: <info>  [1747893865.6158] manager: NetworkManager state is now CONNECTED_GLOBAL
May 22 11:49:25 pdb2.unidev.org.np NetworkManager[1151]: <info>  [1747893865.6162] device (ens224): state change: secondaries -> activated (reason 'none', managed-type: 'full')
May 22 11:49:25 pdb2.unidev.org.np NetworkManager[1151]: <info>  [1747893865.6175] device (ens224): Activation: successful, device activated.
May 22 11:49:25 pdb2.unidev.org.np NetworkManager[1151]: <info>  [1747893865.6217] manager: startup complete
May 22 11:49:25 pdb2.unidev.org.np NetworkManager[1151]: <info>  [1747893865.9406] modem-manager: ModemManager not available
May 22 11:49:25 pdb2.unidev.org.np NetworkManager[1151]: <info>  [1747893865.9922] modem-manager: ModemManager now available
May 22 11:49:34 pdb2.unidev.org.np NetworkManager[1151]: <info>  [1747893874.6143] agent-manager: agent[f55b1b6287e44048,:1.32/org.gnome.Shell.NetworkAgent/42]: agent registered
May 22 11:49:48 pdb2.unidev.org.np NetworkManager[1151]: <info>  [1747893888.7353] agent-manager: agent[342bace55c9cd012,:1.87/org.gnome.Shell.NetworkAgent/0]: agent registered
May 22 11:57:25 pdb2.unidev.org.np NetworkManager[1151]: <info>  [1747894345.6207] agent-manager: agent[342bace55c9cd012,:1.87/org.gnome.Shell.NetworkAgent/0]: agent registered
*/

-- Step 9.3 -->> On Both Nodes
[root@pdb1/pdb2 ~]# nmcli device status
/*
DEVICE  TYPE      STATE                   CONNECTION
ens192  ethernet  connected               ens192
ens224  ethernet  connected               ens224
lo      loopback  connected (externally)  lo
*/

-- Step 9.4 -->> On Node 1
[root@pdb1 ~]#  nmcli connection show
/*
NAME    UUID                                  TYPE      DEVICE
ens192  9ff98fa6-f24d-3709-8add-ca9678e5c2ce  ethernet  ens192
ens224  7f5d1b60-1025-3dc3-b51e-c9dd9337be3b  ethernet  ens224
lo      13e98e25-0da0-42d0-90f9-9d37a50a3794  loopback  lo
*/

-- Step 9.5 -->> On Node 2
[root@pdb2 ~]#  nmcli connection show
/*
NAME    UUID                                  TYPE      DEVICE
ens192  028cf8fd-4324-3faa-9839-98a8cb91e7ce  ethernet  ens192
ens224  4e3e353b-0bda-392c-a016-832a82d5bdb0  ethernet  ens224
lo      84a1ab22-fb8f-4db8-b6fd-534547f97009  loopback  lo
*/

-- Step 10 -->> On Both Node
[root@pdb1/pdb2 ~]# dnf repolist
/*
repo id                       repo name
ol9_UEKR7                     Oracle Linux 9 UEK Release 7 (x86_64)
ol9_appstream                 Oracle Linux 9 Application Stream Packages (x86_64)
ol9_baseos_latest             Oracle Linux 9 BaseOS Latest (x86_64)
*/

-- Step 10.1 -->> On Both Node
[root@pdb1/pdb2 ~]# uname -a
/*
Linux pdb1.unidev.org.np 5.15.0-308.179.6.3.el9uek.x86_64 #2 SMP Tue May 13 20:29:18 PDT 2025 x86_64 x86_64 x86_64 GNU/Linux
*/

-- Step 10.2 -->> On Both Node
[root@pdb1/pdb2 ~]# uname -r
/*
5.15.0-308.179.6.3.el9uek.x86_64
*/

-- Step 10.3 -->> On Both Node
[root@pdb1/pdb2 ~]# grubby --info=ALL | grep ^kernel
/*
kernel="/boot/vmlinuz-5.15.0-308.179.6.3.el9uek.x86_64"
kernel="/boot/vmlinuz-5.15.0-302.167.6.el9uek.x86_64"
kernel="/boot/vmlinuz-5.14.0-570.12.1.0.1.el9_6.x86_64"
kernel="/boot/vmlinuz-5.14.0-503.11.1.el9_5.x86_64"
kernel="/boot/vmlinuz-0-rescue-2595e6ca9f4e4efe850491d87047f8cc"
*/

-- Step 10.4 -->> On Both Node
[root@pdb1/pdb2 ~]# grubby --default-kernel
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
[root@pdb1/pdb2 ~]# grubby --set-default /boot/vmlinuz-5.14.0-503.11.1.el9_5.x86_64
/*
The default is /boot/loader/entries/2595e6ca9f4e4efe850491d87047f8cc-5.14.0-503.11.1.el9_5.x86_64.conf with index 3 and kernel /boot/vmlinuz-5.14.0-503.11.1.el9_5.x86_64
*/

-- Step 10.6 -->> On Both Node, Confirm Default Kernel
[root@pdb1/pdb2 ~]# grubby --default-kernel
/*
/boot/vmlinuz-5.14.0-503.11.1.el9_5.x86_64
*/

-- Step 10.7 -->> On Both Node, Reboot and Verify
[root@pdb1/pdb2 ~]# init 6

--To Fix the Disk's issues
--[root@pdbdr1/pdbdr2 ~]# dracut -f --regenerate-all

--After reboot, verify the running kernel:
-- Step 10.8 -->> On Both Node, -->> On Both Node
[root@pdb1/pdb2 ~]# dnf repolist
/*
repo id                       repo name
ol9_UEKR7                     Oracle Linux 9 UEK Release 7 (x86_64)
ol9_appstream                 Oracle Linux 9 Application Stream Packages (x86_64)
ol9_baseos_latest             Oracle Linux 9 BaseOS Latest (x86_64)
*/

-- Step 10.9 -->> On Both Node
[root@pdb1/pdb2 ~]# uname -a
/*
Linux pdb1.unidev.org.np 5.14.0-503.11.1.el9_5.x86_64 #1 SMP PREEMPT_DYNAMIC Wed Nov 13 08:33:30 PST 2024 x86_64 x86_64 x86_64 GNU/Linux
*/

-- Step 10.10 -->> On Both Node
[root@pdb1/pdb2 ~]# uname -r
/*
5.14.0-503.11.1.el9_5.x86_64
*/

-- Step 10.11 -->> On Both Node
[root@pdb1/pdb2 ~]# grubby --info=ALL | grep ^kernel
/*
kernel="/boot/vmlinuz-5.15.0-308.179.6.3.el9uek.x86_64"
kernel="/boot/vmlinuz-5.15.0-302.167.6.el9uek.x86_64"
kernel="/boot/vmlinuz-5.14.0-570.12.1.0.1.el9_6.x86_64"
kernel="/boot/vmlinuz-5.14.0-503.11.1.el9_5.x86_64"
kernel="/boot/vmlinuz-0-rescue-2595e6ca9f4e4efe850491d87047f8cc"
*/

-- Step 10.12 -->> On Both Node
[root@pdb1/pdb2 ~]# grubby --default-kernel
/*
/boot/vmlinuz-5.14.0-503.11.1.el9_5.x86_64
*/

-- Step 10.13 -->> On Both Node, Confirm Both Kernels Are Installed (Permanent Use)
[root@pdb1/pdb2 ~]# rpm -qa | grep kernel-core
/*
kernel-core-5.14.0-503.11.1.el9_5.x86_64
kernel-core-5.14.0-570.12.1.0.1.el9_6.x86_64
*/

-- Step 11 -->> On Both Node
[root@pdb1/pdb2 ~]# cat /etc/hostname
/*
pdb1/pdb2.unidev.org.np
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
         Chassis: vm 🖴
      Machine ID: 2595e6ca9f4e4efe850491d87047f8cc
         Boot ID: 3be4937685c94d618e621ba05bfa082b
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
[root@pdb2 ~]# hostnamectl set-hostname pdb2.unidev.org.np

-- Step 13.1 -->> On Node 2
[root@pdb2 ~]# hostnamectl
/*
 Static hostname: pdb2.unidev.org.np
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: 271e3cbe567149eda4c03818593b8a57
         Boot ID: fd0951cc23c14373b8f0c824f1790815
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
Chain INPUT (policy ACCEPT 257 packets, 386K bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 29 packets, 1464 bytes)
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
     Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; preset: enabled)
     Active: active (running) since Thu 2025-05-22 14:43:04 +0545; 19s ago
       Docs: man:chronyd(8)
             man:chrony.conf(5)
    Process: 6392 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
   Main PID: 6394 (chronyd)
      Tasks: 1 (limit: 124714)
     Memory: 1.0M
        CPU: 66ms
     CGroup: /system.slice/chronyd.service
             └─6394 /usr/sbin/chronyd -F 2

May 22 14:43:04 pdb1.unidev.org.np systemd[1]: Starting NTP client/server...
May 22 14:43:04 pdb1.unidev.org.np chronyd[6394]: chronyd version 4.6.1 starting (+CMDMON +NTP +REFCLOCK +RTC +PRIVDROP +SCFILTER +SIGND +ASYNCDNS +NTS +SECHASH +IPV6 +DEBUG)
May 22 14:43:04 pdb1.unidev.org.np chronyd[6394]: Loaded 0 symmetric keys
May 22 14:43:04 pdb1.unidev.org.np chronyd[6394]: Using right/UTC timezone to obtain leap second data
May 22 14:43:04 pdb1.unidev.org.np chronyd[6394]: Frequency -10.563 +/- 0.538 ppm read from /var/lib/chrony/drift
May 22 14:43:04 pdb1.unidev.org.np chronyd[6394]: Loaded seccomp filter (level 2)
May 22 14:43:04 pdb1.unidev.org.np systemd[1]: Started NTP client/server.
May 22 14:43:09 pdb1.unidev.org.np chronyd[6394]: Selected source 162.159.200.123 (2.pool.ntp.org)
May 22 14:43:09 pdb1.unidev.org.np chronyd[6394]: System clock TAI offset set to 37 seconds
May 22 14:43:14 pdb1.unidev.org.np chronyd[6394]: System clock was stepped by 0.000065 seconds
*/

-- Step 18 -->> On Both Node
[root@pdb1 ~]# cd /etc/yum.repos.d/
[root@pdb1 yum.repos.d]# ll
/*
-rw-r--r--  1 root root 3235 May 13 21:53 oracle-linux-ol9.repo
-rw-r--r--  1 root root  615 May 13 21:53 uek-ol9.repo
-rw-r--r--. 1 root root  229 May 13 21:53 virt-ol9.repo
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
     Loaded: loaded (/usr/lib/systemd/system/NetworkManager.service; enabled; preset: enabled)
     Active: active (running) since Thu 2025-05-22 14:46:25 +0545; 7s ago
       Docs: man:NetworkManager(8)
   Main PID: 6541 (NetworkManager)
      Tasks: 4 (limit: 124714)
     Memory: 7.6M
        CPU: 158ms
     CGroup: /system.slice/NetworkManager.service
             └─6541 /usr/sbin/NetworkManager --no-daemon

May 22 14:46:25 pdb1.unidev.org.np NetworkManager[6541]: <info>  [1747904485.1936] device (lo): Activation: successful, device activated.
May 22 14:46:25 pdb1.unidev.org.np NetworkManager[6541]: <info>  [1747904485.2062] device (ens192): state change: ip-check -> secondaries (reason 'none', managed-type: 'assume')
May 22 14:46:25 pdb1.unidev.org.np NetworkManager[6541]: <info>  [1747904485.2064] device (ens224): state change: ip-check -> secondaries (reason 'none', managed-type: 'assume')
May 22 14:46:25 pdb1.unidev.org.np NetworkManager[6541]: <info>  [1747904485.2066] device (ens192): state change: secondaries -> activated (reason 'none', managed-type: 'assume')
May 22 14:46:25 pdb1.unidev.org.np NetworkManager[6541]: <info>  [1747904485.2069] manager: NetworkManager state is now CONNECTED_SITE
May 22 14:46:25 pdb1.unidev.org.np NetworkManager[6541]: <info>  [1747904485.2072] device (ens192): Activation: successful, device activated.
May 22 14:46:25 pdb1.unidev.org.np NetworkManager[6541]: <info>  [1747904485.2078] manager: NetworkManager state is now CONNECTED_GLOBAL
May 22 14:46:25 pdb1.unidev.org.np NetworkManager[6541]: <info>  [1747904485.2081] device (ens224): state change: secondaries -> activated (reason 'none', managed-type: 'assume')
May 22 14:46:25 pdb1.unidev.org.np NetworkManager[6541]: <info>  [1747904485.2085] device (ens224): Activation: successful, device activated.
May 22 14:46:25 pdb1.unidev.org.np NetworkManager[6541]: <info>  [1747904485.2214] manager: startup complete
*/

-- Step 18.5 -->> On Both Node
[root@pdb1/pdb2 ~]# systemctl status dnsmasq
/*
● dnsmasq.service - DNS caching server.
     Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; preset: disabled)
     Active: active (running) since Thu 2025-05-22 14:46:15 +0545; 40s ago
    Process: 6515 ExecStart=/usr/sbin/dnsmasq (code=exited, status=0/SUCCESS)
   Main PID: 6517 (dnsmasq)
      Tasks: 1 (limit: 124714)
     Memory: 1.1M
        CPU: 11ms
     CGroup: /system.slice/dnsmasq.service
             └─6517 /usr/sbin/dnsmasq

May 22 14:46:15 pdb1.unidev.org.np dnsmasq[6517]: reading /etc/resolv.conf
May 22 14:46:15 pdb1.unidev.org.np dnsmasq[6517]: ignoring nameserver 127.0.0.1 - local interface
May 22 14:46:15 pdb1.unidev.org.np dnsmasq[6517]: using nameserver 192.168.4.11#53
May 22 14:46:15 pdb1.unidev.org.np dnsmasq[6517]: using nameserver 192.168.4.12#53
May 22 14:46:15 pdb1.unidev.org.np dnsmasq[6517]: read /etc/hosts - 11 addresses
May 22 14:46:15 pdb1.unidev.org.np systemd[1]: Started DNS caching server..
May 22 14:46:25 pdb1.unidev.org.np dnsmasq[6517]: reading /etc/resolv.conf
May 22 14:46:25 pdb1.unidev.org.np dnsmasq[6517]: ignoring nameserver 127.0.0.1 - local interface
May 22 14:46:25 pdb1.unidev.org.np dnsmasq[6517]: using nameserver 192.168.4.11#53
May 22 14:46:25 pdb1.unidev.org.np dnsmasq[6517]: using nameserver 192.168.4.12#53
*/

-- Step 19 -->> On Both Node
[root@pdb1/pdb2 ~]# cat /etc/resolv.conf
/*
# Generated by NetworkManager
search cibnepal.org.np
nameserver 127.0.0.1
nameserver 192.168.4.11
nameserver 192.168.4.12
*/

-- Step 20 -->> On Node 1
[root@pdb1/pdb2 ~]# nslookup 192.168.6.21
/*
21.6.168.192.in-addr.arpa        name = pdb1.unidev.org.np.
*/

-- Step 20.1 -->> On Node 1
[root@pdb1/pdb2 ~]# nslookup 192.168.6.22
/*
22.6.168.192.in-addr.arpa        name = pdb2.unidev.org.np.
*/

-- Step 20.2 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb1
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb1.unidev.org.np
Address: 192.168.6.21
*/

-- Step 20.3 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb2
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb2.unidev.org.np
Address: 192.168.6.22
*/

-- Step 20.4 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb-scan
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb-scan.unidev.org.np
Address: 192.168.6.27
Name:   pdb-scan.unidev.org.np
Address: 192.168.6.25
Name:   pdb-scan.unidev.org.np
Address: 192.168.6.26
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
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.6.21  netmask 255.255.255.0  broadcast 192.168.6.255
        inet6 fe80::20c:29ff:fe74:5ff9  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:74:5f:f9  txqueuelen 1000  (Ethernet)
        RX packets 702  bytes 99244 (96.9 KiB)
        RX errors 0  dropped 23  overruns 0  frame 0
        TX packets 653  bytes 99303 (96.9 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens224: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.21  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::20c:29ff:fe74:5f03  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:74:5f:03  txqueuelen 1000  (Ethernet)
        RX packets 157  bytes 17585 (17.1 KiB)
        RX errors 0  dropped 21  overruns 0  frame 0
        TX packets 92  bytes 10724 (10.4 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 839  bytes 55923 (54.6 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 839  bytes 55923 (54.6 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 22.4 -->> On Node Two
[root@pdb2 ~]# ifconfig
/*
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.6.22  netmask 255.255.255.0  broadcast 192.168.6.255
        inet6 fe80::20c:29ff:fea1:afb5  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:a1:af:b5  txqueuelen 1000  (Ethernet)
        RX packets 839  bytes 114105 (111.4 KiB)
        RX errors 0  dropped 44  overruns 0  frame 0
        TX packets 697  bytes 103215 (100.7 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens224: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.22  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::20c:29ff:fea1:afbf  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:a1:af:bf  txqueuelen 1000  (Ethernet)
        RX packets 264  bytes 28578 (27.9 KiB)
        RX errors 0  dropped 43  overruns 0  frame 0
        TX packets 93  bytes 10778 (10.5 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 1069  bytes 70244 (68.5 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1069  bytes 70244 (68.5 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 23 -->> On Both Node
[root@pdb1/pdb2 ~]# init 6


-- Step 24 -->> On Node One
[root@pdb1 ~]# ifconfig
/*
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.6.21  netmask 255.255.255.0  broadcast 192.168.6.255
        inet6 fe80::20c:29ff:fe74:5ff9  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:74:5f:f9  txqueuelen 1000  (Ethernet)
        RX packets 93  bytes 9890 (9.6 KiB)
        RX errors 0  dropped 11  overruns 0  frame 0
        TX packets 76  bytes 10313 (10.0 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens224: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.21  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::20c:29ff:fe74:5f03  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:74:5f:03  txqueuelen 1000  (Ethernet)
        RX packets 25  bytes 1692 (1.6 KiB)
        RX errors 0  dropped 9  overruns 0  frame 0
        TX packets 13  bytes 922 (922.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 126  bytes 8580 (8.3 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 126  bytes 8580 (8.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 24.1 -->> On Node Two
[root@pdb2 ~]# ifconfig
/*
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.6.22  netmask 255.255.255.0  broadcast 192.168.6.255
        inet6 fe80::20c:29ff:fea1:afb5  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:a1:af:b5  txqueuelen 1000  (Ethernet)
        RX packets 125  bytes 11884 (11.6 KiB)
        RX errors 0  dropped 29  overruns 0  frame 0
        TX packets 83  bytes 11003 (10.7 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens224: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.22  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::20c:29ff:fea1:afbf  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:a1:af:bf  txqueuelen 1000  (Ethernet)
        RX packets 52  bytes 3312 (3.2 KiB)
        RX errors 0  dropped 27  overruns 0  frame 0
        TX packets 14  bytes 992 (992.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 210  bytes 14508 (14.1 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 210  bytes 14508 (14.1 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 24.2 -->> On Both Nodes
[root@pdb1/pdb2 ~]# ifconfig | grep -E 'UP'
/*
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
ens224: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
*/

-- Step 24.3 -->> On Both Nodes
[root@pdb1/pdb2 ~]# ifconfig | grep -E 'RUNNING'
/*
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
ens224: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
*/

-- Step 25 -->> On Both Node
[root@pdb1/pdb2 ~]# systemctl status libvirtd.service
/*
○ libvirtd.service - libvirt legacy monolithic daemon
     Loaded: loaded (/usr/lib/systemd/system/libvirtd.service; disabled; preset: disabled)
     Active: inactive (dead)
TriggeredBy: ○ libvirtd-ro.socket
             ○ libvirtd.socket
             ○ libvirtd-admin.socket
       Docs: man:libvirtd(8)
             https://libvirt.org/
*/

-- Step 26 -->> On Both Node
[root@pdb1/pdb2 ~]# firewall-cmd --list-all
/*
FirewallD is not running
*/

-- Step 27 -->> On Both Node
[root@pdb1/pdb2 ~]# systemctl status firewalld
/*
○ firewalld.service - firewalld - dynamic firewall daemon
     Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; preset: enabled)
     Active: inactive (dead)
       Docs: man:firewalld(1)
*/

-- Step 28 -->> On Both Node
[root@pdb1/pdb2 ~]# systemctl status named
/*
○ named.service - Berkeley Internet Name Domain (DNS)
     Loaded: loaded (/usr/lib/systemd/system/named.service; disabled; preset: disabled)
     Active: inactive (dead)
*/

-- Step 29 -->> On Both Node
[root@pdb1/pdb2 ~]# systemctl status avahi-daemon
/*
○ avahi-daemon.service - Avahi mDNS/DNS-SD Stack
     Loaded: loaded (/usr/lib/systemd/system/avahi-daemon.service; disabled; preset: enabled)
     Active: inactive (dead)
TriggeredBy: ○ avahi-daemon.socket
*/

-- Step 30 -->> On Both Node
[root@pdb1/pdb2 ~ ]# systemctl status chronyd
/*
● chronyd.service - NTP client/server
     Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; preset: enabled)
     Active: active (running) since Thu 2025-05-22 14:51:12 +0545; 3min 17s ago
       Docs: man:chronyd(8)
             man:chrony.conf(5)
    Process: 1298 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
   Main PID: 1346 (chronyd)
      Tasks: 1 (limit: 124715)
     Memory: 1.5M
        CPU: 71ms
     CGroup: /system.slice/chronyd.service
             └─1346 /usr/sbin/chronyd -F 2

May 22 14:51:12 pdb1.unidev.org.np systemd[1]: Starting NTP client/server...
May 22 14:51:12 pdb1.unidev.org.np chronyd[1346]: chronyd version 4.6.1 starting (+CMDMON +NTP +REFCLOCK +RTC +PRIVDROP +SCFILTER +SIGND +ASYNCDNS +NTS +SECHASH +IPV6 +DEBUG)
May 22 14:51:12 pdb1.unidev.org.np chronyd[1346]: Loaded 0 symmetric keys
May 22 14:51:12 pdb1.unidev.org.np chronyd[1346]: Using right/UTC timezone to obtain leap second data
May 22 14:51:12 pdb1.unidev.org.np chronyd[1346]: Frequency -10.531 +/- 0.907 ppm read from /var/lib/chrony/drift
May 22 14:51:12 pdb1.unidev.org.np chronyd[1346]: Loaded seccomp filter (level 2)
May 22 14:51:12 pdb1.unidev.org.np systemd[1]: Started NTP client/server.
May 22 14:51:17 pdb1.unidev.org.np chronyd[1346]: Selected source 162.159.200.1 (2.pool.ntp.org)
May 22 14:51:17 pdb1.unidev.org.np chronyd[1346]: System clock TAI offset set to 37 seconds
*/

-- Step 31 -->> On Both Node
[root@pdb1/pdb2 ~]# systemctl status dnsmasq
/*
● dnsmasq.service - DNS caching server.
     Loaded: loaded (/usr/lib/systemd/system/dnsmasq.service; enabled; preset: disabled)
     Active: active (running) since Thu 2025-05-22 14:51:12 +0545; 3min 35s ago
    Process: 1281 ExecStart=/usr/sbin/dnsmasq (code=exited, status=0/SUCCESS)
   Main PID: 1294 (dnsmasq)
      Tasks: 1 (limit: 124715)
     Memory: 1.9M
        CPU: 21ms
     CGroup: /system.slice/dnsmasq.service
             └─1294 /usr/sbin/dnsmasq

May 22 14:51:12 pdb1.unidev.org.np systemd[1]: Starting DNS caching server....
May 22 14:51:12 pdb1.unidev.org.np dnsmasq[1294]: started, version 2.85 cachesize 150
May 22 14:51:12 pdb1.unidev.org.np dnsmasq[1294]: compile time options: IPv6 GNU-getopt DBus no-UBus no-i18n IDN2 DHCP DHCPv6 no-Lua TFTP no-conntrack ipset auth cryptohash DNSSEC loop-d>
May 22 14:51:12 pdb1.unidev.org.np dnsmasq[1294]: reading /etc/resolv.conf
May 22 14:51:12 pdb1.unidev.org.np dnsmasq[1294]: ignoring nameserver 127.0.0.1 - local interface
May 22 14:51:12 pdb1.unidev.org.np dnsmasq[1294]: using nameserver 192.168.4.11#53
May 22 14:51:12 pdb1.unidev.org.np dnsmasq[1294]: using nameserver 192.168.4.12#53
May 22 14:51:12 pdb1.unidev.org.np systemd[1]: Started DNS caching server..
May 22 14:51:12 pdb1.unidev.org.np dnsmasq[1294]: read /etc/hosts - 11 addresses
*/

-- Step 31.1 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup 192.168.6.21
/*
21.6.168.192.in-addr.arpa        name = pdb1.unidev.org.np.
*/

-- Step 31.2 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup 192.168.6.22
/*
22.6.168.192.in-addr.arpa        name = pdb2.unidev.org.np.
*/

-- Step 31.3 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb1
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb1.unidev.org.np
Address: 192.168.6.21
*/

-- Step 31.4 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb2
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb2.unidev.org.np
Address: 192.168.6.22
*/

-- Step 31.5 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb-scan
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb-scan.unidev.org.np
Address: 192.168.6.27
Name:   pdb-scan.unidev.org.np
Address: 192.168.6.25
Name:   pdb-scan.unidev.org.np
Address: 192.168.6.26
*/

-- Step 31.6 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb2-vip
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb2-vip.unidev.org.np
Address: 192.168.6.24
*/

-- Step 31.7 -->> On Both Node
[root@pdb1/pdb2 ~]# nslookup pdb1-vip
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   pdb1-vip.unidev.org.np
Address: 192.168.6.23
*/

-- Step 31.8 -->> On Both Node
[root@pdb1/pdb2 ~]# iptables -L -nv
/*
Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination
*/


-- Step 32 -->> On Both Node
-- Perform either the Automatic Setup or the Manual Setup to complete the basic prerequisites. 
[root@pdb1/pdb2 ~]# cd /etc/yum.repos.d/
[root@pdb1/pdb2 yum.repos.d]# dnf -y update

-- Step 32.1 -->> On Both Node
[root@pdb1/pdb2 yum.repos.d]# dnf install -y yum-utils
[root@pdb1/pdb2 yum.repos.d]# dnf install -y dnf-utils
[root@pdb1/pdb2 yum.repos.d]# dnf install -y oracle-epel-release-el9
[root@pdb1/pdb2 yum.repos.d]# dnf install -y sshpass zip unzip
[root@pdb1/pdb2 yum.repos.d]# dnf install -y oracle-database-preinstall-19c


-- Step 32.2 -->> On Both Node
[root@pdb1/pdb2 yum.repos.d]# dnf install -y bc
[root@pdb1/pdb2 yum.repos.d]# dnf install -y binutils
[root@pdb1/pdb2 yum.repos.d]# dnf install -y compat-libcap1
[root@pdb1/pdb2 yum.repos.d]# dnf install -y compat-libstdc++-33
[root@pdb1/pdb2 yum.repos.d]# dnf install -y compat-openssl11
[root@pdb1/pdb2 yum.repos.d]# dnf install -y dtrace-utils
[root@pdb1/pdb2 yum.repos.d]# dnf install -y dtrace-modules
[root@pdb1/pdb2 yum.repos.d]# dnf install -y dtrace-modules-headers
[root@pdb1/pdb2 yum.repos.d]# dnf install -y dtrace-modules-provider-headers
[root@pdb1/pdb2 yum.repos.d]# dnf install -y elfutils-libelf
[root@pdb1/pdb2 yum.repos.d]# dnf install -y elfutils-libelf-devel
[root@pdb1/pdb2 yum.repos.d]# dnf install -y fontconfig-devel
[root@pdb1/pdb2 yum.repos.d]# dnf install -y fontconfig
[root@pdb1/pdb2 yum.repos.d]# dnf install -y glibc
[root@pdb1/pdb2 yum.repos.d]# dnf install -y glibc-devel
[root@pdb1/pdb2 yum.repos.d]# dnf install -y glibc-headers
[root@pdb1/pdb2 yum.repos.d]# dnf install -y ksh
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libaio
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libaio-devel
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libdtrace-ctf-devel
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libasan
[root@pdb1/pdb2 yum.repos.d]# dnf install -y liblsan
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libxcrypt-compat
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libibverbs
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libXrender
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libXrender-devel
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libX11
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libXau
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libXi
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libXtst
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libgcc
[root@pdb1/pdb2 yum.repos.d]# dnf install -y librdmacm-devel
[root@pdb1/pdb2 yum.repos.d]# dnf install -y librdmacm
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libstdc++
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libstdc++-devel
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libxcb
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libvirt-libs
[root@pdb1/pdb2 yum.repos.d]# dnf install -y make
[root@pdb1/pdb2 yum.repos.d]# dnf install -y net-tools
[root@pdb1/pdb2 yum.repos.d]# dnf install -y nfs-utils
[root@pdb1/pdb2 yum.repos.d]# dnf install -y python
[root@pdb1/pdb2 yum.repos.d]# dnf install -y python-configshell
[root@pdb1/pdb2 yum.repos.d]# dnf install -y python-rtslib
[root@pdb1/pdb2 yum.repos.d]# dnf install -y python-six
[root@pdb1/pdb2 yum.repos.d]# dnf install -y policycoreutils
[root@pdb1/pdb2 yum.repos.d]# dnf install -y policycoreutils-python-utils
[root@pdb1/pdb2 yum.repos.d]# dnf install -y targetcli
[root@pdb1/pdb2 yum.repos.d]# dnf install -y smartmontools
[root@pdb1/pdb2 yum.repos.d]# dnf install -y sysstat
[root@pdb1/pdb2 yum.repos.d]# dnf install -y gcc
[root@pdb1/pdb2 yum.repos.d]# dnf install -y unixODBC
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libnsl
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libnsl.i686
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libnsl2
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libnsl2.i686
[root@pdb1/pdb2 yum.repos.d]# dnf install -y ipmiutil
[root@pdb1/pdb2 yum.repos.d]# dnf install -y libnsl2-devel
[root@pdb1/pdb2 yum.repos.d]# dnf install -y chrony
[root@pdb1/pdb2 yum.repos.d]# dnf -y update

-- Step 32.3 -->> On Both Node
[root@pdb1/pdb2 ~]# cd /tmp
--Bug 29772579 / Bug 35547711 / 35448216
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libcap1-1.10-7.el7.i686.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libcap1-1.10-7.el7.x86_64.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libstdc++-33-3.2.3-72.el7.i686.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm

-- Step 32.4 -->> On Both Node
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL9/appstream/x86_64/getPackage/elfutils-libelf-devel-0.191-4.el9.i686.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL9/appstream/x86_64/getPackage/elfutils-libelf-devel-0.191-4.el9.x86_64.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL9/baseos/latest/x86_64/getPackage/numactl-2.0.18-2.el9.x86_64.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL9/appstream/x86_64/getPackage/numactl-devel-2.0.18-2.el9.i686.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL9/appstream/x86_64/getPackage/numactl-devel-2.0.18-2.el9.x86_64.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL9/baseos/latest/x86_64/getPackage/python3-libs-3.9.19-8.el9_5.1.i686.rpm
[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL9/baseos/latest/x86_64/getPackage/python3-libs-3.9.19-8.el9_5.1.x86_64.rpm
[root@pdb1/pdb2 tmp]# wget https://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/c/compat-libpthread-nonshared-2.41.9000-13.fc43.x86_64.rpm
                           
-- Step 00.00 -->> On Node 1
--Go to https://www.oracle.com/linux/downloads/linux-asmlib-v9-downloads.html
--[root@pdb1 tmp]# cp /root/Oracle_19C/19c_RPM/oracleasmlib-3.0.0-13.el9.x86_64.rpm /tmp/
--[root@pdb1 tmp]# scp -r /root/Oracle_19C/19c_RPM/oracleasmlib-3.0.0-13.el9.x86_64.rpm root@192.168.6.22:/tmp/

-- Step 00.00 -->> On Node 1
--[root@pdb1 tmp]# cp /root/Oracle_19C/19c_RPM/oracleasmlib-3.1.0-6.el9.x86_64.rpm /tmp/
--[root@pdb1 tmp]# scp -r /root/Oracle_19C/19c_RPM/oracleasmlib-3.1.0-6.el9.x86_64.rpm root@192.168.6.22:/tmp/

-- Step 00.00 -->> On Both Nodes
--[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL9/addons/x86_64/getPackage/oracleasm-support-3.0.0-6.el9.x86_64.rpm
--[root@pdb1/pdb2 tmp]# wget https://yum.oracle.com/repo/OracleLinux/OL9/addons/x86_64/getPackage/oracleasm-support-3.1.0-10.el9.x86_64.rpm

-- Step 32.5 -->> On Both Node
--Bug 29772579
[root@pdb1/pdb2 tmp]# yum -y localinstall ./compat-libcap1-1.10-7.el7.i686.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./compat-libcap1-1.10-7.el7.x86_64.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./compat-libstdc++-33-3.2.3-72.el7.i686.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./compat-libpthread-nonshared-2.41.9000-13.fc43.x86_64.rpm
                                            

-- Step 32.6 -->> On Both Node
[root@pdb1/pdb2 tmp]# yum -y localinstall ./elfutils-libelf-devel-0.191-4.el9.i686.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./elfutils-libelf-devel-0.191-4.el9.x86_64.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./numactl-2.0.18-2.el9.x86_64.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./numactl-devel-2.0.18-2.el9.i686.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./numactl-devel-2.0.18-2.el9.x86_64.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./python3-libs-3.9.19-8.el9_5.1.i686.rpm
[root@pdb1/pdb2 tmp]# yum -y localinstall ./python3-libs-3.9.19-8.el9_5.1.x86_64.rpm

--[root@pdb1/pdb2 tmp]# yum -y localinstall ./oracleasm-support-3.0.0-6.el9.x86_64.rpm ./oracleasmlib-3.0.0-13.el9.x86_64.rpm
--[root@pdb1/pdb2 tmp]# yum -y localinstall ./oracleasm-support-3.1.0-10.el9.x86_64.rpm ./oracleasmlib-3.1.0-6.el9.x86_64.rpm

-- Step 33 -->> On Both Node
[root@pdb1/pdb2 tmp]# rm -rf *.rpm


-- Step 34 -->> On Both Node
[root@pdb1/pdb2 ~]# cd /etc/yum.repos.d/
[root@pdb1/pdb2 yum.repos.d]# dnf -y install compat-libcap1 compat-libstdc++-33 bc binutils elfutils-libelf elfutils-libelf-devel fontconfig-devel glibc glibc-devel ksh libaio libaio-devel libgcc libnsl librdmacm-devel libstdc++ libstdc++-devel libX11 libXau libxcb libXi libXrender libXrender-devel libXtst make net-tools nfs-utils python3 python3-configshell python3-rtslib python3-six smartmontools sysstat targetcli unzip
[root@pdb1/pdb2 yum.repos.d]# dnf -y install bash bc bind-utils binutils ethtool glibc glibc-devel initscripts ksh libaio libaio-devel libgcc libnsl libstdc++ libstdc++-devel make module-init-tools net-tools nfs-utils openssh-clients openssl-libs pam procps psmisc smartmontools sysstat tar unzip util-linux-ng xorg-x11-utils xorg-x11-xauth 
[root@pdb1/pdb2 yum.repos.d]# dnf -y install bc binutils compat-libcap1 compat-libstdc++-33 compat-openssl11 dtrace-utils dtrace-modules dtrace-modules-headers dtrace-modules-provider-headers elfutils-libelf elfutils-libelf-devel fontconfig-devel fontconfig glibc glibc-devel glibc-headers ksh libaio libaio-devel libdtrace-ctf-devel libasan liblsan libxcrypt-compat libibverbs libXrender libXrender-devel libX11 libXau libXi libXtst libgcc librdmacm-devel librdmacm libstdc++ libstdc++-devel libxcb libvirt-libs make net-tools nfs-utils python python-configshell python-rtslib python-six policycoreutils policycoreutils-python-utils targetcli smartmontools sysstat gcc unixODBC libnsl libnsl.i686 libnsl2 libnsl2.i686 ipmiutil libnsl2-devel chrony
--[root@pdb1/pdb2 yum.repos.d]# dnf -y install oracleasm-support oracleasmlib
[root@pdb1/pdb2 yum.repos.d]# dnf -y update

-- Step 35 -->> On Both Node
[root@pdb1/pdb2 yum.repos.d]# rpm -q binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel \
[root@pdb1/pdb2 yum.repos.d]# rpm -q gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers kernel-headers ksh libaio libaio-devel \
[root@pdb1/pdb2 yum.repos.d]# rpm -q libgcc libgomp libstdc++ libstdc++-devel make numactl-devel sysstat unixODBC \

-- Step 00 -->> On Both Node
--[root@pdb1/pdb2 ~]# rpm -qa | grep oracleasm
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
--[root@pdb1/pdb2 ~]# vi /etc/sysctl.conf
/*
# You can fully enable io_uring in the kernel by adding the following line
kernel.io_uring_disabled = 0
*/

-- Step 00 -->> On Both Node
--[root@pdb1/pdb2 ~]# cat /etc/sysctl.conf | grep -E "io_uring" 
/*
# You can fully enable io_uring in the kernel by adding the following line
kernel.io_uring_disabled = 0
*/

-- Step 00 -->> On Both Node
--Reload the system configuration.
--[root@pdb1/pdb2 ~]# sysctl -p /etc/sysctl.conf
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
--[root@pdb1/pdb2 ~]# cd /etc/yum.repos.d/
--[root@pdb1/pdb2 yum.repos.d]# dnf -y update

-- Step 36 -->> On Both Node 
[root@pdb1/pdb2 ~]# init 0

-- Step 37 -->> On Both Node 
--Check and Set the Correct SCSI Controller Type
-->-In VMware, go to Edit Settings of each VM:
-->-Find the SCSI Controller for shared disks.
-->-Set it to VMware Paravirtual (PVSCSI) instead of LSI Logic.
-->-Reboot both VMs after making this change.
-->-Manually Add the required Disk's for ASM configuration 
-->-Open the The OS after creation/configuration of Disk's 

-- Step 38 -->> On Node 1 
[root@pdb1 ~]# lsblk
/*
NAME             MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                8:0    0  222G  0 disk
├─sda1             8:1    0    2G  0 part /boot
└─sda2             8:2    0  220G  0 part
  ├─ol_pdb1-root 253:0    0   70G  0 lvm  /
  ├─ol_pdb1-swap 253:1    0   20G  0 lvm  [SWAP]
  ├─ol_pdb1-usr  253:2    0   15G  0 lvm  /usr
  ├─ol_pdb1-tmp  253:3    0   15G  0 lvm  /tmp
  ├─ol_pdb1-var  253:4    0   15G  0 lvm  /var
  ├─ol_pdb1-home 253:5    0   15G  0 lvm  /home
  └─ol_pdb1-opt  253:6    0   70G  0 lvm  /opt
sdb                8:16   0   20G  0 disk
sdc                8:32   0  200G  0 disk
sdd                8:48   0  400G  0 disk
sr0               11:0    1 11.7G  0 rom
*/

-- Step 38.1 -->> On Node 2
[root@pdb2 ~]# lsblk
/*
NAME             MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                8:0    0  222G  0 disk
├─sda1             8:1    0    2G  0 part /boot
└─sda2             8:2    0  220G  0 part
  ├─ol_pdb2-root 253:0    0   70G  0 lvm  /
  ├─ol_pdb2-swap 253:1    0   20G  0 lvm  [SWAP]
  ├─ol_pdb2-usr  253:2    0   15G  0 lvm  /usr
  ├─ol_pdb2-tmp  253:3    0   15G  0 lvm  /tmp
  ├─ol_pdb2-var  253:4    0   15G  0 lvm  /var
  ├─ol_pdb2-home 253:5    0   15G  0 lvm  /home
  └─ol_pdb2-opt  253:6    0   70G  0 lvm  /opt
sdb                8:16   0   20G  0 disk
sdc                8:32   0  200G  0 disk
sdd                8:48   0  400G  0 disk
sr0               11:0    1 11.7G  0 rom
*/

-- Step 39 -->> On Both Node
[root@pdb1/pdb2 ~]# ll /etc/init.d/
/*
-rw-r--r-- 1 root root 18220 Aug 27  2024 functions
-rwx------ 1 root root  1307 Oct 16  2023 oracle-database-preinstall-19c-firstboot
-rw-r--r-- 1 root root  1161 Feb 25 16:43 README
*/

-- Step 40 -->> On Both Node
[root@pdb1/pdb2 ~]# ll /dev/sd*
/*
brw-rw---- 1 root disk 8,  0 May 22 14:51 /dev/sda
brw-rw---- 1 root disk 8,  1 May 22 14:51 /dev/sda1
brw-rw---- 1 root disk 8,  2 May 22 14:51 /dev/sda2
brw-rw---- 1 root disk 8, 16 May 22 14:51 /dev/sdb
brw-rw---- 1 root disk 8, 32 May 22 14:51 /dev/sdc
brw-rw---- 1 root disk 8, 48 May 22 14:51 /dev/sdd
*/

-- Step 40.1 -->> On Both Node
[root@pdb1/pdb2 ~]# fdisk -ll | grep -E "sdb|sdc|sdd"
/*
Disk /dev/sdc: 200 GiB, 214748364800 bytes, 419430400 sectors
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
Disk /dev/sdd: 400 GiB, 429496729600 bytes, 838860800 sectors
*/

-- Step 40.2 -->> On Node 1
[root@pdb1 ~]# fdisk /dev/sdb
/*
Welcome to fdisk (util-linux 2.37.4).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x109dc833.

Command (m for help): p
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x109dc833

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
Disk identifier: 0x109dc833

Device     Boot Start      End  Sectors Size Id Type
/dev/sdb1        2048 41943039 41940992  20G 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 40.3 -->> On Node 1
[root@pdb1 ~]# fdisk /dev/sdc
/*
Welcome to fdisk (util-linux 2.37.4).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x3381ea7b.

Command (m for help): p
Disk /dev/sdc: 200 GiB, 214748364800 bytes, 419430400 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x3381ea7b

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
Disk identifier: 0x3381ea7b

Device     Boot Start       End   Sectors  Size Id Type
/dev/sdc1        2048 419430399 419428352  200G 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 40.4 -->> On Node 1
[root@pdb1 ~]# fdisk /dev/sdd
/*
Welcome to fdisk (util-linux 2.37.4).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x42bb7d74.

Command (m for help): p
Disk /dev/sdd: 400 GiB, 429496729600 bytes, 838860800 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x42bb7d74

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
Disk identifier: 0x42bb7d74

Device     Boot Start       End   Sectors  Size Id Type
/dev/sdd1        2048 838860799 838858752  400G 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 40.5 -->> On Both Node (If Required)
[root@pdb1/pdb2 ~]# partprobe /dev/sdb
[root@pdb1/pdb2 ~]# partprobe /dev/sdc
[root@pdb1/pdb2 ~]# partprobe /dev/sdd
[root@pdb1/pdb2 ~]# partprobe /dev/sdb1
[root@pdb1/pdb2 ~]# partprobe /dev/sdc1
[root@pdb1/pdb2 ~]# partprobe /dev/sdd1

-- Step 40.6 -->> On Node 1
[root@pdb1 ~]# mkfs.xfs -f /dev/sdb1
[root@pdb1 ~]# mkfs.xfs -f /dev/sdc1
[root@pdb1 ~]# mkfs.xfs -f /dev/sdd1

-- Step 40.7 -->> On Both Node 
[root@pdb1/pdb2 ~]# fdisk -ll | grep -E "sdb|sdc|sdd"
/*
Disk /dev/sdc: 200 GiB, 214748364800 bytes, 419430400 sectors
/dev/sdc1        2048 419430399 419428352  200G 83 Linux
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
/dev/sdb1        2048 41943039 41940992  20G 83 Linux
Disk /dev/sdd: 400 GiB, 429496729600 bytes, 838860800 sectors
/dev/sdd1        2048 838860799 838858752  400G 83 Linux
*/

-- Step 40.8 -->> On Both Node 
[root@pdb1/pdb2 ~]# lsblk
/*
NAME             MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                8:0    0  222G  0 disk
├─sda1             8:1    0    2G  0 part /boot
└─sda2             8:2    0  220G  0 part
  ├─ol_pdb1-root 253:0    0   70G  0 lvm  /
  ├─ol_pdb1-swap 253:1    0   20G  0 lvm  [SWAP]
  ├─ol_pdb1-usr  253:2    0   15G  0 lvm  /usr
  ├─ol_pdb1-tmp  253:3    0   15G  0 lvm  /tmp
  ├─ol_pdb1-var  253:4    0   15G  0 lvm  /var
  ├─ol_pdb1-home 253:5    0   15G  0 lvm  /home
  └─ol_pdb1-opt  253:6    0   70G  0 lvm  /opt
sdb                8:16   0   20G  0 disk
└─sdb1             8:17   0   20G  0 part
sdc                8:32   0  200G  0 disk
└─sdc1             8:33   0  200G  0 part
sdd                8:48   0  400G  0 disk
└─sdd1             8:49   0  400G  0 part
sr0               11:0    1 11.7G  0 rom
*/

-- Step 41 -->> On Both Node
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

-- Step 41.1 -->> On Both Node
-- Run the following command to change the current kernel parameters.
[root@pdb1/pdb2 ~]# sysctl -p /etc/sysctl.conf

-- Step 42 -->> On Both Node
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

# Grid Configuration
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

-- Step 44 -->> On both Node
-- Create the new groups and users.
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:
*/

-- Step 44.1 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:
backupdba:x:54324:
dgdba:x:54325:
kmdba:x:54326:
racdba:x:54330:
*/

-- Step 44.2 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i oracle
/*
oracle:x:1000:
*/

-- Step 44.3 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i oper
/*
oper:x:54323:
*/

-- Step 44.4 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i asm

-- Step 44.5 -->> On both Node
-- 1.Create OS groups using the command below. Enter these commands as the 'root' user:
--[root@pdb1/pdb2 ~]# /usr/sbin/groupadd -g 503 oper
[root@pdb1/pdb2 ~]# /usr/sbin/groupadd -g 504 asmadmin
[root@pdb1/pdb2 ~]# /usr/sbin/groupadd -g 506 asmdba
[root@pdb1/pdb2 ~]# /usr/sbin/groupadd -g 507 asmoper
[root@pdb1/pdb2 ~]# /usr/sbin/groupadd -g 508 beoper

-- Step 44.6 -->> On both Node
-- 2.Create the users that will own the Oracle software using the commands:
[root@pdb1/pdb2 ~]# /usr/sbin/useradd  -g oinstall -G oinstall,dba,asmadmin,asmdba,asmoper,beoper grid
[root@pdb1/pdb2 ~]# /usr/sbin/usermod -g oinstall -G oinstall,dba,oper,asmdba,asmadmin,backupdba,dgdba,kmdba,racdba oracle

-- Step 44.7 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/

-- Step 44.8 -->> On both Node
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

-- Step 44.9 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i grid
/*
oinstall:x:54321:grid,oracle
dba:x:54322:grid,oracle
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 44.10 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i oper
/*
oper:x:54323:oracle
asmoper:x:507:grid
beoper:x:508:grid
*/

-- Step 44.11 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i oinstall
/*
oinstall:x:54321:grid,oracle
*/

-- Step 44.12 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i dba
/*
dba:x:54322:grid,oracle
backupdba:x:54324:oracle
dgdba:x:54325:oracle
kmdba:x:54326:oracle
racdba:x:54330:oracle
asmdba:x:506:grid,oracle
*/

-- Step 44.13 -->> On both Node
[root@pdb1/pdb2 ~]# cat /etc/group | grep -i asm
/*
asmadmin:x:504:grid,oracle
asmdba:x:506:grid,oracle
asmoper:x:507:grid
*/

-- Step 45 -->> On both Node
[root@pdb1/pdb2 ~]# passwd oracle
/*
Changing password for user oracle.
New password: oracle
Retype new password: oracle
passwd: all authentication tokens updated successfully.
*/

-- Step 46 -->> On both Node
[root@pdb1/pdb2 ~]# passwd grid
/*
Changing password for user grid.
New password: grid
Retype new password: grid
passwd: all authentication tokens updated successfully.
*/

-- Step 47 -->> On both Node
[root@pdb1/pdb2 ~]# su - oracle

-- Step 47.1 -->> On both Node
[oracle@pdb1/pdb2 ~]$ su - grid
/*
Password: DbA#Gpass#605014#
*/

-- Step 47.2 -->> On both Node
[grid@pdb1/pdb2 ~]$ su - oracle
/*
Password: DbA#Opass#605014#
*/

-- Step 47.3 -->> On both Node
[oracle@pdb1/pdb2 ~]$ exit
/*
logout
*/

-- Step 47.4 -->> On both Node
[grid@pdb1/pdb2 ~]$ exit
/*
logout
*/

-- Step 47.5 -->> On both Node
[oracle@pdb1/pdb2 ~]$ exit
/*
logout
*/

-- Step 48 -->> On both Node
--Create the Oracle Inventory Director:
[root@pdb1/pdb2 ~]# mkdir -p /opt/app/oraInventory
[root@pdb1/pdb2 ~]# chown -R grid:oinstall /opt/app/oraInventory
[root@pdb1/pdb2 ~]# chmod -R 775 /opt/app/oraInventory

-- Step 49 -->> On both Node
--Creating the Oracle Grid Infrastructure Home Directory:
[root@pdb1/pdb2 ~]# mkdir -p /opt/app/19c/grid
[root@pdb1/pdb2 ~]# chown -R grid:oinstall /opt/app/19c/grid
[root@pdb1/pdb2 ~]# chmod -R 775 /opt/app/19c/grid

-- Step 50 -->> On both Node
--Creating the Oracle Base Directory
[root@pdb1/pdb2 ~]#   mkdir -p /opt/app/oracle
[root@pdb1/pdb2 ~]#   chmod -R 775 /opt/app/oracle
[root@pdb1/pdb2 ~]#   cd /opt/app/
[root@pdb1/pdb2 app]# chown -R oracle:oinstall /opt/app/oracle

-- Step 51 -->> On Node 1
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

-- Step 51.1 -->> On Node 1
[oracle@pdb1 ~]$ . .bash_profile

-- Step 52 -->> On Node 1
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

-- Step 52.1 -->> On Node 1
[grid@pdb1 ~]$ . .bash_profile

-- Step 53 -->> On Node 2
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

-- Step 53.1 -->> On Node 2
[oracle@pdb2 ~]$ . .bash_profile

-- Step 54 -->> On Node 2
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

-- Step 54.1 -->> On Node 2
[grid@pdb2 ~]$ . .bash_profile

-- Step 55 -->> On Node 1
-- To Unzio The Oracle Grid Software and lateset Opatch
[root@pdb1 ~]# cd /opt/app/19c/grid/
[root@pdb1 grid]# unzip -oq /root/Oracle_19C/19.3.0.0.0_Grid_Binary/LINUX.X64_193000_grid_home.zip
[root@pdb1 grid]# unzip -oq /root/Oracle_19C/OPATCH_19c/p6880880_190000_Linux-x86-64.zip

-- Step 56 -->> On Node 1
-- To Unzio The Oracle PSU
[root@pdb1 ~]# cd /tmp/
[root@pdb1 tmp]# unzip -oq /root/Oracle_19C/PSU_19.27.0.0.0/p37591516_190000_Linux-x86-64.zip
[root@pdb1 tmp]# chown -R oracle:oinstall 37591516
[root@pdb1 tmp]# chmod -R 775 37591516
[root@pdb1 tmp]# ls -ltr | grep 37591516
/*
drwxrwxr-x  4 oracle oinstall      80 Apr 16 11:18 37591516
*/

-- Step 57 -->> On Node 1
-- Login as root user and issue the following command at pdb1
[root@pdb1 ~]# chown -R grid:oinstall /opt/app/19c/grid/
[root@pdb1 ~]# chmod -R 775 /opt/app/19c/grid/

-- Step 58 -->> On Node 1
[root@pdb1 ~]# su - grid
[grid@pdb1 ~]$ cd /opt/app/19c/grid/OPatch/
[grid@pdb1 OPatch]$ ./opatch version
/*
OPatch Version: 12.2.0.1.46

OPatch succeeded.
*/

-- Step 59 -->> On Node 1
[root@pdb1 ~]# scp -r /opt/app/19c/grid/cv/rpm/cvuqdisk-1.0.10-1.rpm root@pdb2:/tmp/
/*
root@pdb2's password: <= P@ssw0rd
cvuqdisk-1.0.10-1.rpm   100%   11KB   1.2MB/s   00:00
*/

-- Step 60 -->> On Node 1
-- To install the cvuqdisk-1.0.10-1.rpm
-- Login from root user
[root@pdb1 ~]# cd /opt/app/19c/grid/cv/rpm/

-- Step 60.1 -->> On Node 1
[root@pdb1 rpm]# ls -ltr
/*
-rwxrwxr-x 1 grid oinstall 11412 Mar 13  2019 cvuqdisk-1.0.10-1.rpm
*/

-- Step 60.2 -->> On Node 1
[root@pdb1 rpm]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP

-- Step 60.3 -->> On Node 1
[root@pdb1 rpm]# rpm -iUvh cvuqdisk-1.0.10-1.rpm 
/*
Verifying...                          ################################# [100%]
Preparing...                          ################################# [100%]
Updating / installing...
   1:cvuqdisk-1.0.10-1                ################################# [100%]
*/

-- Step 61 -->> On Node 2
[root@pdb2 ~]# cd /tmp/
[root@pdb2 tmp]# chown -R grid:oinstall cvuqdisk-1.0.10-1.rpm
[root@pdb2 tmp]# chmod -R 775 cvuqdisk-1.0.10-1.rpm
[root@pdb2 tmp]# ls -ltr | grep cvuqdisk-1.0.10-1.rpm
/*
-rwxrwxr-x  1 grid oinstall 11412 May 23 11:11 cvuqdisk-1.0.10-1.rpm
*/

-- Step 61.1 -->> On Node 2
-- To install the cvuqdisk-1.0.10-1.rpm
-- Login from root user
[root@pdb2 ~]# cd /tmp/
[root@pdb2 tmp]# CVUQDISK_GRP=oinstall; export CVUQDISK_GRP
[root@pdb2 tmp]# rpm -iUvh cvuqdisk-1.0.10-1.rpm 
/*
Verifying...                          ################################# [100%]
Preparing...                          ################################# [100%]
Updating / installing...
   1:cvuqdisk-1.0.10-1                ################################# [100%]
*/

-- Step 62 -->> On Node 1
-- Bug 30286976: To Solve the Pre-check or any Oracle relavant Installation for rac Setup make compatible version CV_ASSUME_DISTID=OEL7.8
[grid@pdb1 ~]$ vi /opt/app/19c/grid/cv/admin/cvu_config
/*
# Fallback to this distribution id
CV_ASSUME_DISTID=OEL7.8
*/

-- Step 62.1 -->> On Node 1
[grid@pdb1 ~]$ cat /opt/app/19c/grid/cv/admin/cvu_config | grep -E CV_ASSUME_DISTID
/*
CV_ASSUME_DISTID=OEL7.8
*/

-- Step 63 -->> On Both Node
--To setup SSH Pass
--Fix: Manually Create a Valid 2048-bit RSA Key for grid User
--Remove the 1024-bit Key
[grid@pdb1/pdb2 ~]$ rm -f ~/.ssh/id_rsa ~/.ssh/id_rsa.pub
[grid@pdb1/pdb2 ~]$ ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
[grid@pdb1/pdb2 ~]$ cat ~/.ssh/id_rsa.pub  --# Should start with "ssh-rsa AAAA..."
[grid@pdb1/pdb2 ~]$ chmod 700 ~/.ssh
[grid@pdb1/pdb2 ~]$ chmod 600 ~/.ssh/id_rsa
[grid@pdb1/pdb2 ~]$ chmod 644 ~/.ssh/id_rsa.pub

-- Step 63.1 -->> On Both Node, Manually Copy the Key to Remote Hosts
[grid@pdb1/pdb2 ~]$ ssh-copy-id grid@pdb1
[grid@pdb1/pdb2 ~]$ ssh-copy-id grid@pdb2
--OR--
[grid@pdb1/pdb2 ~]$ cat ~/.ssh/id_rsa.pub | ssh grid@pdb1 'cat >> ~/.ssh/authorized_keys'
[grid@pdb1/pdb2 ~]$ cat ~/.ssh/id_rsa.pub | ssh grid@pdb2 'cat >> ~/.ssh/authorized_keys'

-- Step 63.2 -->> On Both Node
[grid@pdb1/pdb2 ~]$ ssh grid@pdb1 date
[grid@pdb1/pdb2 ~]$ ssh grid@pdb2 date
[grid@pdb1/pdb2 ~]$ ssh grid@pdb1 date && ssh grid@pdb2 date
[grid@pdb1/pdb2 ~]$ ssh grid@pdb1.unidev.org.np date
[grid@pdb1/pdb2 ~]$ ssh grid@pdb2.unidev.org.np date
[grid@pdb1/pdb2 ~]$ ssh grid@pdb1.unidev.org.np date && ssh grid@pdb2.unidev.org.np date
[grid@pdb1/pdb2 ~]$ ssh grid@192.168.6.21 date
[grid@pdb1/pdb2 ~]$ ssh grid@192.168.6.22 date
[grid@pdb1/pdb2 ~]$ ssh grid@192.168.6.21 date && ssh grid@192.168.6.22 date

-- Step 64 -->> On Node 1 (Enable Oracle ASM Filter Driver)
[grid@pdb1 ~]$ cd /opt/app/19c/grid/
[grid@pdb1 grid]$ export CV_ASSUME_DISTID=OEL7.8
[grid@pdb1 grid]$ ./OPatch/opatch version
/*
OPatch Version: 12.2.0.1.46

OPatch succeeded.
*/

-- Step 64.1 -->> On Node 1 (Enable Oracle ASM Filter Driver)
[grid@pdb1 grid]$ ./bin/afddriverstate supported
/*
AFD-620: AFD is not supported on this operating system version: 'unknown'
AFD-9201: Not Supported
*/

-- Step 64.2 -->> On Node 1 (Enable Oracle ASM Filter Driver)
[grid@pdb1 ~]$ cd /opt/app/19c/grid
[grid@pdb1 grid]$ export CV_ASSUME_DISTID=OEL7.8
[grid@pdb1 grid]$ ./gridSetup.sh -silent -applyRU /tmp/37591516/37641958
/*
Preparing the home to patch...
Applying the patch /tmp/37591516/37641958...
Successfully applied the patch.
The log can be found at: /tmp/GridSetupActions2025-05-23_11-36-30AM/installerPatchActions_2025-05-23_11-36-30AM.log
Launching Oracle Grid Infrastructure Setup Wizard...

[FATAL] [INS-40426] Grid installation option has not been specified.
   ACTION: Specify the valid installation option.
*/

-- Step 64.3 -->> On Node 1 (Enabled Oracle ASM Filter Driver)
[grid@pdb1 ~]$ cd /opt/app/19c/grid/
[grid@pdb1 grid]$ ./bin/afddriverstate supported
/*
AFD-9200: Supported
*/

-- Step 64.4 -->> On Node 1 (Enabled Oracle ASM Filter Driver)
[grid@pdb1 grid]$ ./bin/afdroot version_check
/*
AFD-616: Valid AFD distribution media detected at: '/opt/app/19c/grid/usm/install/Oracle/EL9/x86_64/5.14.0-503.11.1/5.14.0-503.11.1-x86_64/bin'
*/

-- Step 65 -->> On Node 1 (Lable Disks as Oracle ASM Filter Driver)
[root@pdb1 ~]# vi /opt/app/19c/grid/bin/kfod
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
[root@pdb1 ~]# mount | grep ARC1
[root@pdb1 ~]# fuser -v /dev/mapper/ARC1
[root@pdb1 ~]# lsof | grep ARC1
[root@pdb1 ~]# wipefs -a /dev/mapper/OCR1
[root@pdb1 ~]# wipefs -a /dev/mapper/DATA1
[root@pdb1 ~]# wipefs -a /dev/mapper/ARC1
[root@pdb1 ~]# dd if=/dev/zero of=/dev/mapper/OCR1 bs=1M count=10
[root@pdb1 ~]# dd if=/dev/zero of=/dev/mapper/DATA1 bs=1M count=10
[root@pdb1 ~]# dd if=/dev/zero of=/dev/mapper/ARC1 bs=1M count=10
[root@pdb1 ~]# init 6
*/

-- Step 65.1 -->> On Node 1 (Lable Disks as Oracle ASM Filter Driver)
[root@pdb1 ~]# lsblk
/*
NAME             MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                8:0    0  222G  0 disk
├─sda1             8:1    0    2G  0 part /boot
└─sda2             8:2    0  220G  0 part
  ├─ol_pdb1-root 253:0    0   70G  0 lvm  /
  ├─ol_pdb1-swap 253:1    0   20G  0 lvm  [SWAP]
  ├─ol_pdb1-usr  253:2    0   15G  0 lvm  /usr
  ├─ol_pdb1-tmp  253:3    0   15G  0 lvm  /tmp
  ├─ol_pdb1-var  253:4    0   15G  0 lvm  /var
  ├─ol_pdb1-home 253:5    0   15G  0 lvm  /home
  └─ol_pdb1-opt  253:6    0   70G  0 lvm  /opt
sdb                8:16   0   20G  0 disk
└─sdb1             8:17   0   20G  0 part
sdc                8:32   0  200G  0 disk
└─sdc1             8:33   0  200G  0 part
sdd                8:48   0  400G  0 disk
└─sdd1             8:49   0  400G  0 part
sr0               11:0    1 1024M  0 rom
*/

-- Step 65.2 -->> On Node 1 (Lable Disks as Oracle ASM Filter Driver)
[root@pdb1 ~]# export ORACLE_HOME=/opt/app/19c/grid
[root@pdb1 ~]# export CV_ASSUME_DISTID=OEL7.8
[root@pdb1 ~]# export ORACLE_BASE=/opt/app/oracle

-- Step 65.3 -->> On Node 1 (Lable Disks as Oracle ASM Filter Driver)
[root@pdb1 ~]# /opt/app/19c/grid/bin/asmcmd afd_label OCR /dev/sdb1 --init
/*
ASMCMD-9463: [/var/tmp/.oracle]
*/

-- Step 65.4 -->> On Node 1 (Lable Disks as Oracle ASM Filter Driver)
[root@pdb1 ~]# /opt/app/19c/grid/bin/asmcmd afd_label DATA /dev/sdc1 --init
/*
ASMCMD-9463: [/var/tmp/.oracle]
*/

-- Step 65.5 -->> On Node 1 (Lable Disks as Oracle ASM Filter Driver)
[root@pdb1 ~]# /opt/app/19c/grid/bin/asmcmd afd_label ARC /dev/sdd1 --init
/*
ASMCMD-9463: [/var/tmp/.oracle]
*/

-- Step 65.6 -->> On Node 1 (Verify Diskes as Oracle ASM Filter Driver)
[root@pdb1 ~]# ll /dev/oracleafd/disks/*
/*
-rw-rw-r-- 1 grid oinstall 34 May 23 12:01 /dev/oracleafd/disks/ARC
-rw-rw-r-- 1 grid oinstall 34 May 23 12:01 /dev/oracleafd/disks/DATA
-rw-rw-r-- 1 grid oinstall 33 May 23 12:01 /dev/oracleafd/disks/OCR
*/

-- Step 65.7 -->> On Node 1 (Verify Diskes as Oracle ASM Filter Driver)
[root@pdb1 ~]# ll /dev/oracleafd/disks/
/*
-rw-rw-r-- 1 grid oinstall 34 May 23 12:01 ARC
-rw-rw-r-- 1 grid oinstall 34 May 23 12:01 DATA
-rw-rw-r-- 1 grid oinstall 33 May 23 12:01 OCR
*/

-- Step 65.8 -->> On Node 1 (Verify Diskes as Oracle ASM Filter Driver)
[root@pdb1 ~]# export ORACLE_HOME=/opt/app/19c/grid
[root@pdb1 ~]# export CV_ASSUME_DISTID=OEL7.8
[root@pdb1 ~]# export ORACLE_BASE=/opt/app/oracle
[root@pdb1 ~]# /opt/app/19c/grid/bin/asmcmd afd_lslbl
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
[grid@pdb1 ~]$ cd /opt/app/19c/grid/
[grid@pdb1 grid]$ export CV_ASSUME_DISTID=OEL7.8
[grid@pdb1 grid]$ ./runcluvfy.sh stage -pre crsinst -n pdb1,pdb2 -verbose
/*
Performing following verification checks ...

  Physical Memory ...
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb2          19.0928GB (2.0020284E7KB)  8GB (8388608.0KB)         passed
  pdb1          19.0929GB (2.0020308E7KB)  8GB (8388608.0KB)         passed
  Physical Memory ...PASSED
  Available Physical Memory ...
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb2          18.1811GB (1.9064216E7KB)  50MB (51200.0KB)          passed
  pdb1          17.6667GB (1.8524872E7KB)  50MB (51200.0KB)          passed
  Available Physical Memory ...PASSED
  Swap Size ...
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb2          19.9961GB (2.096742E7KB)  16GB (1.6777216E7KB)      passed
  pdb1          19.9961GB (2.096742E7KB)  16GB (1.6777216E7KB)      passed
  Swap Size ...PASSED
  Free Space: pdb2:/usr,pdb2:/sbin ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /usr              pdb2          /usr          8.2109GB      25MB          passed
  /sbin             pdb2          /usr          8.2109GB      10MB          passed
  Free Space: pdb2:/usr,pdb2:/sbin ...PASSED
  Free Space: pdb2:/var ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /var              pdb2          /var          13.9551GB     5MB           passed
  Free Space: pdb2:/var ...PASSED
  Free Space: pdb2:/etc ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /etc              pdb2          /             72.7461GB     25MB          passed
  Free Space: pdb2:/etc ...PASSED
  Free Space: pdb2:/tmp ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /tmp              pdb2          /tmp          15.5059GB     1GB           passed
  Free Space: pdb2:/tmp ...PASSED
  Free Space: pdb1:/usr,pdb1:/sbin ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /usr              pdb1          /usr          8.21GB        25MB          passed
  /sbin             pdb1          /usr          8.21GB        10MB          passed
  Free Space: pdb1:/usr,pdb1:/sbin ...PASSED
  Free Space: pdb1:/var ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /var              pdb1          /var          13.96GB       5MB           passed
  Free Space: pdb1:/var ...PASSED
  Free Space: pdb1:/etc ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /etc              pdb1          /             60.2197GB     25MB          passed
  Free Space: pdb1:/etc ...PASSED
  Free Space: pdb1:/tmp ...
  Path              Node Name     Mount point   Available     Required      Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  /tmp              pdb1          /tmp          7.9424GB      1GB           passed
  Free Space: pdb1:/tmp ...PASSED
  User Existence: grid ...
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdb2          passed                    exists(1001)
  pdb1          passed                    exists(1001)

    Users With Same UID: 1001 ...PASSED
  User Existence: grid ...PASSED
  Group Existence: asmadmin ...
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdb2          passed                    exists
  pdb1          passed                    exists
  Group Existence: asmadmin ...PASSED
  Group Existence: asmdba ...
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdb2          passed                    exists
  pdb1          passed                    exists
  Group Existence: asmdba ...PASSED
  Group Existence: oinstall ...
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdb2          passed                    exists
  pdb1          passed                    exists
  Group Existence: oinstall ...PASSED
  Group Membership: asmdba ...
  Node Name         User Exists   Group Exists  User in Group  Status
  ----------------  ------------  ------------  ------------  ----------------
  pdb2              yes           yes           yes           passed
  pdb1              yes           yes           yes           passed
  Group Membership: asmdba ...PASSED
  Group Membership: asmadmin ...
  Node Name         User Exists   Group Exists  User in Group  Status
  ----------------  ------------  ------------  ------------  ----------------
  pdb2              yes           yes           yes           passed
  pdb1              yes           yes           yes           passed
  Group Membership: asmadmin ...PASSED
  Group Membership: oinstall(Primary) ...
  Node Name         User Exists   Group Exists  User in Group  Primary       Status
  ----------------  ------------  ------------  ------------  ------------  ------------
  pdb2              yes           yes           yes           yes           passed
  pdb1              yes           yes           yes           yes           passed
  Group Membership: oinstall(Primary) ...PASSED
  Run Level ...
  Node Name     run level                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb2          5                         3,5,3,5                   passed
  pdb1          5                         3,5,3,5                   passed
  Run Level ...PASSED
  Hard Limit: maximum open file descriptors ...
  Node Name         Type          Available     Required      Status
  ----------------  ------------  ------------  ------------  ----------------
  pdb2              hard          65536         65536         passed
  pdb1              hard          65536         65536         passed
  Hard Limit: maximum open file descriptors ...PASSED
  Soft Limit: maximum open file descriptors ...
  Node Name         Type          Available     Required      Status
  ----------------  ------------  ------------  ------------  ----------------
  pdb2              soft          65536         1024          passed
  pdb1              soft          65536         1024          passed
  Soft Limit: maximum open file descriptors ...PASSED
  Hard Limit: maximum user processes ...
  Node Name         Type          Available     Required      Status
  ----------------  ------------  ------------  ------------  ----------------
  pdb2              hard          16384         16384         passed
  pdb1              hard          16384         16384         passed
  Hard Limit: maximum user processes ...PASSED
  Soft Limit: maximum user processes ...
  Node Name         Type          Available     Required      Status
  ----------------  ------------  ------------  ------------  ----------------
  pdb2              soft          16384         2047          passed
  pdb1              soft          16384         2047          passed
  Soft Limit: maximum user processes ...PASSED
  Soft Limit: maximum stack size ...
  Node Name         Type          Available     Required      Status
  ----------------  ------------  ------------  ------------  ----------------
  pdb2              soft          10240         10240         passed
  pdb1              soft          10240         10240         passed
  Soft Limit: maximum stack size ...PASSED
  Users With Same UID: 0 ...PASSED
  Current Group ID ...PASSED
  Root user consistency ...
  Node Name                             Status
  ------------------------------------  ------------------------
  pdb2                                  passed
  pdb1                                  passed
  Root user consistency ...PASSED
  Package: cvuqdisk-1.0.10-1 ...
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb2          cvuqdisk-1.0.10-1         cvuqdisk-1.0.10-1         passed
  pdb1          cvuqdisk-1.0.10-1         cvuqdisk-1.0.10-1         passed
  Package: cvuqdisk-1.0.10-1 ...PASSED
  Package: psmisc-22.6-19 ...
  Node Name     Available                 Required                  Status
  ------------  ------------------------  ------------------------  ----------
  pdb2          psmisc-23.4-3.el9         psmisc-22.6-19            passed
  pdb1          psmisc-23.4-3.el9         psmisc-22.6-19            passed
  Package: psmisc-22.6-19 ...PASSED
  Host name ...PASSED
  Node Connectivity ...
    Hosts File ...
  Node Name                             Status
  ------------------------------------  ------------------------
  pdb1                                  passed
  pdb2                                  passed
    Hosts File ...PASSED

Interface information for node "pdb2"

 Name   IP Address      Subnet          Gateway         Def. Gateway    HW Address        MTU
 ------ --------------- --------------- --------------- --------------- ----------------- ------
 ens192 192.168.6.22     192.168.6.0      0.0.0.0         192.168.6.1      00:0C:29:A1:AF:B5 1500
 ens224 10.10.10.22     10.10.10.0      0.0.0.0         192.168.6.1      00:0C:29:A1:AF:BF 1500

Interface information for node "pdb1"

 Name   IP Address      Subnet          Gateway         Def. Gateway    HW Address        MTU
 ------ --------------- --------------- --------------- --------------- ----------------- ------
 ens192 192.168.6.21     192.168.6.0      0.0.0.0         192.168.6.1      00:0C:29:74:5F:F9 1500
 ens224 10.10.10.21     10.10.10.0      0.0.0.0         192.168.6.1      00:0C:29:74:5F:03 1500

Check: MTU consistency of the subnet "10.10.10.0".

  Node              Name          IP Address    Subnet        MTU
  ----------------  ------------  ------------  ------------  ----------------
  pdb2              ens224        10.10.10.22   10.10.10.0    1500
  pdb1              ens224        10.10.10.21   10.10.10.0    1500

Check: MTU consistency of the subnet "192.168.6.0".

  Node              Name          IP Address    Subnet        MTU
  ----------------  ------------  ------------  ------------  ----------------
  pdb2              ens192        192.168.6.22   192.168.6.0    1500
  pdb1              ens192        192.168.6.21   192.168.6.0    1500
    Check that maximum (MTU) size packet goes through subnet ...PASSED

  Source                          Destination                     Connected?
  ------------------------------  ------------------------------  ----------------
  pdb1[ens224:10.10.10.21]        pdb2[ens224:10.10.10.22]        yes

  Source                          Destination                     Connected?
  ------------------------------  ------------------------------  ----------------
  pdb1[ens192:192.168.6.21]        pdb2[ens192:192.168.6.22]        yes
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
  pdb2                                  yes
  pdb1                                  yes

    '/etc/chrony.conf' ...PASSED
    Daemon 'chronyd' ...
  Node Name                             Running?
  ------------------------------------  ------------------------
  pdb2                                  yes
  pdb1                                  yes

    Daemon 'chronyd' ...PASSED
    NTP daemon or service using UDP port 123 ...
  Node Name                             Port Open?
  ------------------------------------  ------------------------
  pdb2                                  yes
  pdb1                                  yes

    NTP daemon or service using UDP port 123 ...PASSED
    chrony daemon is synchronized with at least one external time source ...PASSED
  Network Time Protocol (NTP) ...PASSED
  Same core file name pattern ...PASSED
  User Mask ...
  Node Name     Available                 Required                  Comment
  ------------  ------------------------  ------------------------  ----------
  pdb2          0022                      0022                      passed
  pdb1          0022                      0022                      passed
  User Mask ...PASSED
  User Not In Group "root": grid ...
  Node Name     Status                    Comment
  ------------  ------------------------  ------------------------
  pdb2          passed                    does not exist
  pdb1          passed                    does not exist
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
  pdb1                                  passed
  pdb2                                  passed

checking response for name "pdb1" from each of the name servers specified in
"/etc/resolv.conf"

  Node Name     Source                    Comment                   Status
  ------------  ------------------------  ------------------------  ----------
  pdb1          127.0.0.1                 IPv4                      passed
  pdb1          192.168.4.11               IPv4                      passed
  pdb1          192.168.4.12               IPv4                      passed

checking response for name "pdb2" from each of the name servers specified in
"/etc/resolv.conf"

  Node Name     Source                    Comment                   Status
  ------------  ------------------------  ------------------------  ----------
  pdb2          127.0.0.1                 IPv4                      passed
  pdb2          192.168.4.11               IPv4                      passed
  pdb2          192.168.4.12               IPv4                      passed
  resolv.conf Integrity ...PASSED
  DNS/NIS name service ...PASSED
  Domain Sockets ...PASSED
  Daemon "avahi-daemon" not configured and running ...
  Node Name     Configured                Status
  ------------  ------------------------  ------------------------
  pdb2          no                        passed
  pdb1          no                        passed

  Node Name     Running?                  Status
  ------------  ------------------------  ------------------------
  pdb2          no                        passed
  pdb1          no                        passed
  Daemon "avahi-daemon" not configured and running ...PASSED
  Daemon "proxyt" not configured and running ...
  Node Name     Configured                Status
  ------------  ------------------------  ------------------------
  pdb2          no                        passed
  pdb1          no                        passed

  Node Name     Running?                  Status
  ------------  ------------------------  ------------------------
  pdb2          no                        passed
  pdb1          no                        passed
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
Date:                         May 23, 2025 12:04:08 PM
CVU version:                  19.27.0.0.0 (041025x8664)
CVU home:                     /opt/app/19c/grid
User:                         grid
Operating system:             Linux5.14.0-503.11.1.el9_5.x86_64
*/

-- Step 67 -->> On Node 1
-- To Create a Response File to Install GID
[grid@pdb1 ~]$ cp /opt/app/19c/grid/install/response/gridsetup.rsp /home/grid/
[grid@pdb1 ~]$ cd /home/grid/
[grid@pdb1 ~]$ ls -ltr | grep gridsetup.rsp
/*
-rwxr-xr-x 1 grid oinstall 36221 Sep 29 14:33 gridsetup.rsp
*/

-- Step 67.1 -->> On Node 1
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
[grid@pdb1 ~]$ cd /opt/app/19c/grid/
[grid@pdb1 grid]$ OPatch/opatch version
/*
OPatch Version: 12.2.0.1.46

OPatch succeeded.
*/

-- Step 68.1 -->> On Node 1
-- To Install Grid Software with Leteset Opatch
[grid@pdb1 ~]$ cd /opt/app/19c/grid/
[grid@pdb1 grid]$ export CV_ASSUME_DISTID=OEL7.8
[grid@pdb1 grid]$ ./gridSetup.sh -ignorePrereq -waitForCompletion -silent -applyRU /tmp/37591516/37641958 -responseFile /home/grid/gridsetup.rsp
/*
Preparing the home to patch...
Applying the patch /tmp/37591516/37641958...
Successfully applied the patch.
The log can be found at: /tmp/GridSetupActions2025-05-23_12-43-26PM/installerPatchActions_2025-05-23_12-43-26PM.log
Launching Oracle Grid Infrastructure Setup Wizard...

[WARNING] [INS-40109] The specified Oracle Base location is not empty on this server.
   ACTION: Specify an empty location for Oracle Base.
[WARNING] [INS-13014] Target environment does not meet some optional requirements.
   CAUSE: Some of the optional prerequisites are not met. See logs for details. gridSetupActions2025-05-23_12-43-26PM.log
   ACTION: Identify the list of failed prerequisite checks from the log: gridSetupActions2025-05-23_12-43-26PM.log. Then either from the log file or from installation manual find the appropriate configuration to meet the prerequisites and fix it manually.
The response file for this session can be found at:
 /opt/app/19c/grid/install/response/grid_2025-05-23_12-43-26PM.rsp

You can find the log of this install session at:
 /tmp/GridSetupActions2025-05-23_12-43-26PM/gridSetupActions2025-05-23_12-43-26PM.log

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
 /opt/app/oraInventory/logs/GridSetupActions2025-05-23_12-43-26PM
*/

-- Step 68.2 -->> On Node 1
[root@pdb1 ~]# /opt/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 68.3 -->> On Node 2
[root@pdb2 ~]# /opt/app/oraInventory/orainstRoot.sh
/*
Changing permissions of /opt/app/oraInventory.
Adding read,write permissions for group.
Removing read,write,execute permissions for world.

Changing groupname of /opt/app/oraInventory to oinstall.
The execution of the script is complete.
*/

-- Step 68.4 -->> On Node 1
[root@pdb1 ~]# /opt/app/19c/grid/root.sh
/*
Check /opt/app/19c/grid/install/root_pdb1.unidev.org.np_2025-05-23_12-57-45-157196935.log for the output of root script
*/

-- Step 68.5 -->> On Node 1
[root@pdb1 ~]#  tail -f /opt/app/19c/grid/install/root_pdb1.unidev.org.np_2025-05-23_12-57-45-157196935.log
/*
Creating /etc/oratab file...
Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Relinking oracle with rac_on option
Using configuration parameter file: /opt/app/19c/grid/crs/install/crsconfig_params
The log of current session can be found at:
  /opt/app/oracle/crsdata/pdb1/crsconfig/rootcrs_pdb1_2025-05-23_12-58-18AM.log
2025/05/23 12:58:34 CLSRSC-594: Executing installation step 1 of 19: 'ValidateEnv'.
2025/05/23 12:58:34 CLSRSC-363: User ignored prerequisites during installation
2025/05/23 12:58:35 CLSRSC-594: Executing installation step 2 of 19: 'CheckFirstNode'.
2025/05/23 12:58:38 CLSRSC-594: Executing installation step 3 of 19: 'GenSiteGUIDs'.
2025/05/23 12:58:40 CLSRSC-594: Executing installation step 4 of 19: 'SetupOSD'.
Redirecting to /bin/systemctl restart rsyslog.service
2025/05/23 12:58:41 CLSRSC-594: Executing installation step 5 of 19: 'CheckCRSConfig'.
2025/05/23 12:58:42 CLSRSC-594: Executing installation step 6 of 19: 'SetupLocalGPNP'.
2025/05/23 12:59:03 CLSRSC-594: Executing installation step 7 of 19: 'CreateRootCert'.
2025/05/23 12:59:11 CLSRSC-594: Executing installation step 8 of 19: 'ConfigOLR'.
2025/05/23 12:59:37 CLSRSC-594: Executing installation step 9 of 19: 'ConfigCHMOS'.
2025/05/23 12:59:37 CLSRSC-594: Executing installation step 10 of 19: 'CreateOHASD'.
2025/05/23 12:59:47 CLSRSC-594: Executing installation step 11 of 19: 'ConfigOHASD'.
2025/05/23 12:59:48 CLSRSC-330: Adding Clusterware entries to file 'oracle-ohasd.service'
2025/05/23 13:00:29 CLSRSC-594: Executing installation step 12 of 19: 'SetupTFA'.
2025/05/23 13:00:29 CLSRSC-594: Executing installation step 13 of 19: 'InstallAFD'.
2025/05/23 13:01:13 CLSRSC-594: Executing installation step 14 of 19: 'InstallACFS'.
2025/05/23 13:01:57 CLSRSC-594: Executing installation step 15 of 19: 'InstallKA'.
2025/05/23 13:02:08 CLSRSC-594: Executing installation step 16 of 19: 'InitConfig'.
2025/05/23 13:02:19 CLSRSC-4002: Successfully installed Oracle Trace File Analyzer (TFA) Collector.

[INFO] [DBT-30161] Disk label(s) created successfully. Check /opt/app/oracle/cfgtoollogs/asmca/asmca-250523PM010241.log for details.


2025/05/23 13:03:39 CLSRSC-482: Running command: '/opt/app/19c/grid/bin/ocrconfig -upgrade grid oinstall'
CRS-4256: Updating the profile
Successful addition of voting disk f7038d5ba2764f32bf0bb5743ec95497.
Successfully replaced voting disk group with +OCR.
CRS-4256: Updating the profile
CRS-4266: Voting file(s) successfully replaced
##  STATE    File Universal Id                File Name Disk group
--  -----    -----------------                --------- ---------
 1. ONLINE   f7038d5ba2764f32bf0bb5743ec95497 (AFD:OCR) [OCR]
Located 1 voting disk(s).
2025/05/23 13:05:11 CLSRSC-594: Executing installation step 17 of 19: 'StartCluster'.
2025/05/23 13:06:15 CLSRSC-343: Successfully started Oracle Clusterware stack
2025/05/23 13:06:15 CLSRSC-594: Executing installation step 18 of 19: 'ConfigNode'.
2025/05/23 13:08:25 CLSRSC-594: Executing installation step 19 of 19: 'PostConfig'.
2025/05/23 13:09:19 CLSRSC-325: Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 68.6 -->> On Node 2
[root@pdb2 ~]# /opt/app/19c/grid/root.sh
/*
Check /opt/app/19c/grid/install/root_pdb2.unidev.org.np_2025-05-23_13-10-21-765308104.log for the output of root script
*/

-- Step 68.7 -->> On Node 2 
[root@pdb2 ~]# tail -f /opt/app/19c/grid/install/root_pdb2.unidev.org.np_2025-05-23_13-10-21-765308104.log
/*
Creating /etc/oratab file...
Entries will be added to the /etc/oratab file as needed by
Database Configuration Assistant when a database is created
Finished running generic part of root script.
Now product-specific root actions will be performed.
Relinking oracle with rac_on option
Using configuration parameter file: /opt/app/19c/grid/crs/install/crsconfig_params
The log of current session can be found at:
  /opt/app/oracle/crsdata/pdb2/crsconfig/rootcrs_pdb2_2025-05-23_01-10-55PM.log
2025/05/23 13:11:03 CLSRSC-594: Executing installation step 1 of 19: 'ValidateEnv'.
2025/05/23 13:11:03 CLSRSC-363: User ignored prerequisites during installation
2025/05/23 13:11:04 CLSRSC-594: Executing installation step 2 of 19: 'CheckFirstNode'.
2025/05/23 13:11:06 CLSRSC-594: Executing installation step 3 of 19: 'GenSiteGUIDs'.
2025/05/23 13:11:06 CLSRSC-594: Executing installation step 4 of 19: 'SetupOSD'.
Redirecting to /bin/systemctl restart rsyslog.service
2025/05/23 13:11:07 CLSRSC-594: Executing installation step 5 of 19: 'CheckCRSConfig'.
2025/05/23 13:11:07 CLSRSC-594: Executing installation step 6 of 19: 'SetupLocalGPNP'.
2025/05/23 13:11:10 CLSRSC-594: Executing installation step 7 of 19: 'CreateRootCert'.
2025/05/23 13:11:10 CLSRSC-594: Executing installation step 8 of 19: 'ConfigOLR'.
2025/05/23 13:11:26 CLSRSC-594: Executing installation step 9 of 19: 'ConfigCHMOS'.
2025/05/23 13:11:27 CLSRSC-594: Executing installation step 10 of 19: 'CreateOHASD'.
2025/05/23 13:11:29 CLSRSC-594: Executing installation step 11 of 19: 'ConfigOHASD'.
2025/05/23 13:11:29 CLSRSC-330: Adding Clusterware entries to file 'oracle-ohasd.service'
2025/05/23 13:11:59 CLSRSC-594: Executing installation step 12 of 19: 'SetupTFA'.
2025/05/23 13:11:59 CLSRSC-594: Executing installation step 13 of 19: 'InstallAFD'.
2025/05/23 13:12:30 CLSRSC-594: Executing installation step 14 of 19: 'InstallACFS'.
2025/05/23 13:13:17 CLSRSC-594: Executing installation step 15 of 19: 'InstallKA'.
2025/05/23 13:13:19 CLSRSC-594: Executing installation step 16 of 19: 'InitConfig'.
2025/05/23 13:13:29 CLSRSC-594: Executing installation step 17 of 19: 'StartCluster'.
2025/05/23 13:13:50 CLSRSC-4002: Successfully installed Oracle Trace File Analyzer (TFA) Collector.
2025/05/23 13:14:14 CLSRSC-343: Successfully started Oracle Clusterware stack
2025/05/23 13:14:14 CLSRSC-594: Executing installation step 18 of 19: 'ConfigNode'.
2025/05/23 13:14:47 CLSRSC-594: Executing installation step 19 of 19: 'PostConfig'.
2025/05/23 13:15:05 CLSRSC-325: Configure Oracle Grid Infrastructure for a Cluster ... succeeded
*/

-- Step 68.8 -->> On Node 1
[grid@pdb1 ~]$ cd /opt/app/19c/grid/
[grid@pdb1 grid]$ export CV_ASSUME_DISTID=OEL7.8
[grid@pdb1 grid]$ /opt/app/19c/grid/gridSetup.sh -silent -executeConfigTools -responseFile /home/grid/gridsetup.rsp
/*
Launching Oracle Grid Infrastructure Setup Wizard...

You can find the logs of this session at:
/opt/app/oraInventory/logs/GridSetupActions2025-05-23_01-16-39PM

You can find the log of this install session at:
 /opt/app/oraInventory/logs/UpdateNodeList2025-05-23_01-16-39PM.log
Successfully Configured Software.
*/

-- Step 68.9 -->> On Node 1
[root@pdb1 ~]# tail -f /opt/app/oraInventory/logs/UpdateNodeList2025-05-23_01-16-39PM.log
/*
INFO: Command execution completes for node : pdb2
INFO: Command execution sucess for node : pdb2
INFO: All threads completed its operations
INFO: Checkpoint:Index file written and updated
INFO: Done calling doOperation.
INFO: 'UpdateNodeList' was successful.
*/

-- Step 68.10 -->> On Both Node
--Auto Configured based on Grid Responce File
[root@pdb1/pdb2 ~]# cat /etc/oracleafd.conf
/*
afd_diskstring='/dev/sd*'
afd_dev_count=3
*/

-- Step 69 -->> On Both Nodes
[root@pdb1/pdb2 ~]# cd /opt/app/19c/grid/bin/
[root@pdb1/pdb2 bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/


-- Step 70 -->> On Both Nodes
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

-- Step 71 -->> On Node 1
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
ora.driver.afd
      1        ONLINE  ONLINE       pdb1                     STABLE
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


-- Step 72 -->> On Node 2
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
ora.driver.afd
      1        ONLINE  ONLINE       pdb2                     STABLE
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

-- Step 73 -->> On Both Nodes
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


-- Step 74 -->> On Both Nodes
[grid@pdb1/pdb2 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20136                0           20136              0             Y  OCR/
ASMCMD [+] > exit
*/

-- Step 75 -->> On Both Nodes
[grid@pdb1/pdb2 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri May 23 14:14:55 2025
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
[grid@pdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 23-MAY-2025 14:18:06

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-MAY-2025 13:08:56
Uptime                    0 days 1 hr. 9 min. 10 sec
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
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 76.1 -->> On Node 1
[grid@pdb1 ~]$ ps -ef | grep SCAN
/*
grid       51458       1  0 13:07 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid       51509       1  0 13:07 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid      157158  148520  0 14:19 pts/1    00:00:00 grep --color=auto SCAN
*/

-- Step 76.2 -->> On Node 1
[grid@pdb1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 23-MAY-2025 14:20:31

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-MAY-2025 13:07:46
Uptime                    0 days 1 hr. 12 min. 45 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.26)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 76.3 -->> On Node 1
[grid@pdb1 ~]$ lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 23-MAY-2025 14:21:01

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-MAY-2025 13:07:51
Uptime                    0 days 1 hr. 13 min. 11 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener_scan3/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN3)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.27)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 76.4 -->> On Node 2
[grid@pdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 23-MAY-2025 14:22:03

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-MAY-2025 13:14:55
Uptime                    0 days 1 hr. 7 min. 7 sec
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
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 76.5 -->> On Node 2
[grid@pdb2 ~]$ ps -ef | grep SCAN
/*
grid       46298       1  0 13:14 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid      134374  129137  0 14:22 pts/1    00:00:00 grep --color=auto SCAN
*/

-- Step 76.6 -->> On Node 2
[grid@pdb2 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 23-MAY-2025 14:23:08

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                23-MAY-2025 13:14:18
Uptime                    0 days 1 hr. 8 min. 50 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.6.25)(PORT=1521)))
The listener supports no services
The command completed successfully
*/

-- Step 77 -->> On Node 2
-- Bug 30286976: To Solve the Pre-check or any Oracle relavant Installation for rac Setup make compatible version CV_ASSUME_DISTID=OEL7.8
[grid@pdb2 ~]$ vi /opt/app/19c/grid/cv/admin/cvu_config
/*
# Fallback to this distribution id.
CV_ASSUME_DISTID=OEL7.8
*/

-- Step 77.1 -->> On Node 2
[grid@pdb2 ~]$ cat /opt/app/19c/grid/cv/admin/cvu_config | grep -E CV_ASSUME_DISTID
/*
CV_ASSUME_DISTID=OEL7.8
*/

-- Step 78 -->> On Node 1
-- To Create ASM storage for Data and Archive 
[grid@pdb1 ~]$ cd /opt/app/19c/grid/bin
[grid@pdb1 bin]$ export CV_ASSUME_DISTID=OEL7.8

-- Step 78.1 -->> On Node 1
[grid@pdb1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName DATA -diskList AFD:DATA -redundancy EXTERNAL
/*
[INFO] [DBT-30001] Disk groups created successfully. Check /opt/app/oracle/cfgtoollogs/asmca/asmca-250523PM022628.log for details.
*/
                 
-- Step 78.2 -->> On Node 1
[grid@pdb1 bin]$ ./asmca -silent -createDiskGroup -diskGroupName ARC -diskList AFD:ARC -redundancy EXTERNAL
/*
[INFO] [DBT-30001] Disk groups created successfully. Check /opt/app/oracle/cfgtoollogs/asmca/asmca-250523PM022740.log for details.
*/

-- Step 79 -->> On Both Nodes
[grid@pdb1/pdb2 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Fri May 23 14:29:00 2025
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

-- Step 81 -->> On Both Nodes
[grid@pdb1/pdb2 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  1048576    409599   409485                0          409485              0             N  ARC/
MOUNTED  EXTERN  N         512             512   4096  1048576    204799   204689                0          204689              0             N  DATA/
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20136                0           20136              0             Y  OCR/
ASMCMD [+] > exit
*/

-- Step 82 -->> On Node 1
[root@pdb1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/19c/grid:N
*/

-- Step 83 -->> On Node 2
[root@pdb2 ~]# vi /etc/oratab
/*
+ASM2:/opt/app/19c/grid:N
*/

-- Step 84 -->> On Both Nodes
-- Creating the Oracle RDBMS Home Directory
[root@pdb1/pdb2 ~]# mkdir -p /opt/app/oracle/product/19c/db_1
[root@pdb1/pdb2 ~]# chown -R oracle:oinstall /opt/app/oracle/product/19c/db_1
[root@pdb1/pdb2 ~]# chmod -R 775 /opt/app/oracle/product/19c/db_1

-- Step 84.1 -->> On Node 1
-- To unzip the Oracle Binary and Letest Opatch
[root@pdb1 ~]# cd /opt/app/oracle/product/19c/db_1
[root@pdb1 db_1]# unzip -oq /root/Oracle_19C/19.3.0.0.0_DB_Binary/LINUX.X64_193000_db_home.zip
[root@pdb1 db_1]# unzip -oq /root/Oracle_19C/OPATCH_19c/p6880880_190000_Linux-x86-64.zip

-- Step 84.2 -->> On Node 1
[root@pdb1 ~]# chown -R oracle:oinstall /opt/app/oracle/product/19c/db_1/
[root@pdb1 ~]# chmod -R 775 /opt/app/oracle/product/19c/db_1/

-- Step 84.3 -->> On Node 1
[root@pdb1 ~]# su - oracle
[oracle@pdb1 ~]$ /opt/app/oracle/product/19c/db_1/OPatch/opatch version
/*
OPatch Version: 12.2.0.1.46

OPatch succeeded.
*/

-- Step 85 -->> On Both Node
--Fix: Manually Create a Valid 2048-bit RSA Key for oracle User
[oracle@pdb1/pdb2 ~]$ rm -f ~/.ssh/id_rsa ~/.ssh/id_rsa.pub
[oracle@pdb1/pdb2 ~]$ ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
[oracle@pdb1/pdb2 ~]$ cat ~/.ssh/id_rsa.pub  # Should start with "ssh-rsa AAAA..."
[oracle@pdb1/pdb2 ~]$ chmod 700 ~/.ssh
[oracle@pdb1/pdb2 ~]$ chmod 600 ~/.ssh/id_rsa
[oracle@pdb1/pdb2 ~]$ chmod 644 ~/.ssh/id_rsa.pub

-- Step 85.1 -->> On Both Node, Manually Copy the Key to Remote Hosts
[oracle@pdb1/pdb2 ~]$ ssh-copy-id oracle@pdb1
[oracle@pdb1/pdb2 ~]$ ssh-copy-id oracle@pdb2
--OR--
[oracle@pdb1/pdb2 ~]$ cat ~/.ssh/id_rsa.pub | ssh grid@pdb1 'cat >> ~/.ssh/authorized_keys'
[oracle@pdb1/pdb2 ~]$ cat ~/.ssh/id_rsa.pub | ssh grid@pdb2 'cat >> ~/.ssh/authorized_keys'

-- Step 86 -->> On Both Nodes
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb1 date
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb2 date
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb1 date && ssh oracle@pdb2 date
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb1.unidev.org.np date
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb2.unidev.org.np date
[oracle@pdb1/pdb2 ~]$ ssh oracle@pdb1.unidev.org.np date && ssh oracle@pdb2.unidev.org.np date
[oracle@pdb1/pdb2 ~]$ ssh oracle@192.168.6.21 date
[oracle@pdb1/pdb2 ~]$ ssh oracle@192.168.6.22 date
[oracle@pdb1/pdb2 ~]$ ssh oracle@192.168.6.21 date && ssh oracle@192.168.6.22 date

-- Step 87 -->> On Node 1
-- To Create a responce file for Oracle Software Installation
[oracle@pdb1 ~]$ cp /opt/app/oracle/product/19c/db_1/install/response/db_install.rsp /home/oracle/
[oracle@pdb1 ~]$ cd /home/oracle/

-- Step 87.1 -->> On Node 1
[oracle@pdb1 ~]$ ll
/*
-rwxr-xr-x 1 oracle oinstall 20152 May 18 11:47 db_install.rsp
*/

-- Step 87.2 -->> On Node 1
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

-- Step 88 -->> On Node 1
[oracle@pdb1 ~]$ vi /opt/app/oracle/product/19c/db_1/cv/admin/cvu_config
/*
# Fallback to this distribution id
CV_ASSUME_DISTID=OEL7.8
*/

-- Step 88.1 -->> On Node 1
[oracle@pdb1 ~]$ cat /opt/app/oracle/product/19c/db_1/cv/admin/cvu_config | grep -E 'CV_ASSUME_DISTID'
/*
CV_ASSUME_DISTID=OEL7.8
*/

-- Step 89 -->> On Node 1
-- To install Oracle Software with Letest Opatch
[oracle@pdb1 ~]$ cd /opt/app/oracle/product/19c/db_1/
[oracle@pdb1 db_1]$ export CV_ASSUME_DISTID=OEL7.8
[oracle@pdb1 db_1]$ ./runInstaller -ignorePrereq -waitforcompletion -silent \
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
The log can be found at: /opt/app/oraInventory/logs/InstallActions2025-05-25_12-23-13PM/installerPatchActions_2025-05-25_12-23-13PM.log
Launching Oracle Database Setup Wizard...

The response file for this session can be found at:
 /opt/app/oracle/product/19c/db_1/install/response/db_2025-05-25_12-23-13PM.rsp

You can find the log of this install session at:
 /opt/app/oraInventory/logs/InstallActions2025-05-25_12-23-13PM/installActions2025-05-25_12-23-13PM.log

As a root user, execute the following script(s):
        1. /opt/app/oracle/product/19c/db_1/root.sh

Execute /opt/app/oracle/product/19c/db_1/root.sh on the following nodes:
[pdb1, pdb2]


Successfully Setup Software.
*/

-- Step 89.1 -->> On Node 1
[root@pdb1 ~]# /opt/app/oracle/product/19c/db_1/root.sh
/*
Check  /opt/app/oracle/product/19c/db_1/install/root_pdb1.unidev.org.np_2025-05-25_13-05-36-404064342.log for the output of root script
*/

-- Step 89.2 -->> On Node 1
[root@pdb1 ~]# tail -f   /opt/app/oracle/product/19c/db_1/install/root_pdb1.unidev.org.np_2025-05-25_13-05-36-404064342.log
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
[root@pdb2 ~]# /opt/app/oracle/product/19c/db_1/root.sh
/*
Check /opt/app/oracle/product/19c/db_1/install/root_pdb2.unidev.org.np_2025-05-25_13-06-34-334016596.log for the output of root script
*/

-- Step 89.4 -->> On Node 2
[root@pdb2 ~]# tail -f /opt/app/oracle/product/19c/db_1/install/root_pdb2.unidev.org.np_2025-05-25_13-06-34-334016596.log
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
[root@pdb1 ~]# cd /tmp/
[root@pdb1 tmp]$ export CV_ASSUME_DISTID=OEL7.8
[root@pdb1 tmp]# export ORACLE_HOME=/opt/app/oracle/product/19c/db_1
[root@pdb1 tmp]# export PATH=${ORACLE_HOME}/bin:$PATH
[root@pdb1 tmp]# export PATH=${PATH}:${ORACLE_HOME}/OPatch

-- Step 90.1 -->> On Node 1
[root@pdb1 tmp]# which opatchauto
/*
/opt/app/oracle/product/19c/db_1/OPatch/opatchauto
*/

-- Step 90.2 -->> On Node 1
[root@pdb1 tmp]# opatchauto apply /tmp/37591516/37499406 -oh /opt/app/oracle/product/19c/db_1 --nonrolling
/*
OPatchauto session is initiated at Sun May 25 13:07:47 2025

System initialization log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchautodb/systemconfig2025-05-25_01-08-01PM.log.

Session log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/opatchauto2025-05-25_01-08-41PM.log
The id for this session is BNQL

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

Patch: /tmp/37591516/37499406
Log: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2025-05-25_13-11-41PM_1.log



OPatchauto session completed at Sun May 25 13:16:46 2025
Time taken to complete the session 9 minutes, 0 second
*/

-- Step 90.3 -->> On Node 1
[root@pdb1 ~]# tail -f /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2025-05-25_13-11-41PM_1.log
/*
[May 25, 2025 1:16:30 PM] [INFO]    [OPSR-TIME] Backup area for restore has been cleaned up. For a complete list of files/directories, deleted, Please refer log file.
[May 25, 2025 1:16:30 PM] [INFO]    Patch 37499406 successfully applied.
[May 25, 2025 1:16:30 PM] [INFO]    [OPSR-TIME] deleteInactivePatchesByDefault begins
[May 25, 2025 1:16:30 PM] [INFO]    Inactive patches will be deleted by default after apply.
[May 25, 2025 1:16:30 PM] [INFO]    [OPSR-TIME] deleteInactivePatchesByDefault ends
[May 25, 2025 1:16:30 PM] [INFO]    UtilSession: N-Apply done.
[May 25, 2025 1:16:30 PM] [INFO]    Finishing UtilSession at Sun May 25 13:16:30 NPT 2025
[May 25, 2025 1:16:30 PM] [INFO]    Log file location: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2025-05-25_13-11-41PM_1.log
[May 25, 2025 1:16:30 PM] [INFO]    EXITING METHOD: NApply(patches,options)
*/

-- Step 91 -->> On Node 1
[root@pdb1 ~]# scp -r /tmp/37591516/ root@pdb2:/tmp/

-- Step 92 -->> On Node 2
[root@pdb2 ~]# cd /tmp/
[root@pdb2 tmp]# chown -R oracle:oinstall 37591516
[root@pdb2 tmp]# chmod -R 775 37591516

-- Step 92.1 -->> On Node 2
[root@pdb2 tmp]# ls -ltr | grep 37591516
/*
drwxrwxr-x  4 oracle oinstall     80 May 25 13:18 37591516
*/

-- Step 93 -->> On Node 2
-- To applying the Oracle PSU on Remote Node 2
[root@pdb2 ~]# cd /tmp/
[root@pdb1 tmp]$ export CV_ASSUME_DISTID=OEL7.8
[root@pdb2 tmp]# export ORACLE_HOME=/opt/app/oracle/product/19c/db_1
[root@pdb2 tmp]# export PATH=${ORACLE_HOME}/bin:$PATH
[root@pdb2 tmp]# export PATH=${PATH}:${ORACLE_HOME}/OPatch

-- Step 93.1 -->> On Node 2
[root@pdb2 tmp]# which opatchauto
/*
/opt/app/oracle/product/19c/db_1/OPatch/opatchauto
*/

-- Step 93.2 -->> On Node 2
[root@pdb2 tmp]# opatchauto apply /tmp/37591516/37499406 -oh /opt/app/oracle/product/19c/db_1 --nonrolling
/*
OPatchauto session is initiated at Sun May 25 13:24:16 2025

System initialization log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchautodb/systemconfig2025-05-25_01-24-26PM.log.

Session log file is /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/opatchauto2025-05-25_01-24-57PM.log
The id for this session is EB8G

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

Patch: /tmp/37591516/37499406
Log: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2025-05-25_13-26-39PM_1.log


OPatchauto session completed at Sun May 25 13:30:11 2025
Time taken to complete the session 5 minutes, 56 seconds
*/

-- Step 93.3 -->> On Node 2
[root@pdb2 ~]# tail -f /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2025-05-18_12-39-16PM_1.log
/*
[May 25, 2025 1:29:56 PM] [INFO]    [OPSR-TIME] Backup area for restore has been cleaned up. For a complete list of files/directories, deleted, Please refer log file.
[May 25, 2025 1:29:56 PM] [INFO]    Patch 37499406 successfully applied.
[May 25, 2025 1:29:56 PM] [INFO]    [OPSR-TIME] deleteInactivePatchesByDefault begins
[May 25, 2025 1:29:56 PM] [INFO]    Inactive patches will be deleted by default after apply.
[May 25, 2025 1:29:56 PM] [INFO]    [OPSR-TIME] deleteInactivePatchesByDefault ends
[May 25, 2025 1:29:56 PM] [INFO]    UtilSession: N-Apply done.
[May 25, 2025 1:29:56 PM] [INFO]    Finishing UtilSession at Sun May 25 13:29:56 NPT 2025
[May 25, 2025 1:29:56 PM] [INFO]    Log file location: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatchauto/core/opatch/opatch2025-05-25_13-26-39PM_1.log
[May 25, 2025 1:29:56 PM] [INFO]    EXITING METHOD: NApply(patches,options)
*/

-- Step 94 -->> On Both Nodes
-- To Create a Oracle Database
[root@pdb1/pdb2 ~]# mkdir -p /opt/app/oracle/admin/pdbdb/adump
[root@pdb1/pdb2 ~]# cd /opt/app/oracle/admin/
[root@pdb1/pdb2 admin]# chown -R oracle:oinstall pdbdb/
[root@pdb1/pdb2 admin]# chmod -R 775 pdbdb/
[root@pdb1/pdb2 admin]# ll
/*
drwxr-x--- 3 grid   oinstall 24 May 23 13:03 +ASM
drwxrwxr-x 3 oracle oinstall 19 May 25 13:35 pdbdb
*/

-- Step 95 -->> On Node 1
-- To prepare the responce file
[root@pdb1 ~]# su - oracle

-- Step 95.1 -->> On Node 1
[oracle@pdb1 db_1]$ cd /opt/app/oracle/product/19c/db_1/assistants/dbca
[oracle@pdb1 dbca]$ export CV_ASSUME_DISTID=OEL7.8
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
-nodelist pdb1,pdb2                           \
-storageType ASM                              \
-diskGroupName DATA                           \
-recoveryGroupName ARC                        \
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

-- Step 95.2 -->> On Node 1
[oracle@pdb1 ~]$  tail -f /opt/app/oracle/cfgtoollogs/dbca/pdbdb/pdbdb.log
/*
[ 2025-05-25 15:05:27.289 NPT ] Prepare for db operation
DBCA_PROGRESS : 7%
[ 2025-05-25 15:06:00.414 NPT ] Copying database files
DBCA_PROGRESS : 27%
[ 2025-05-25 15:08:12.420 NPT ] Creating and starting Oracle instance
DBCA_PROGRESS : 28%
DBCA_PROGRESS : 31%
DBCA_PROGRESS : 35%
DBCA_PROGRESS : 37%
DBCA_PROGRESS : 40%
[ 2025-05-25 15:49:50.117 NPT ] Creating cluster database views
DBCA_PROGRESS : 41%
DBCA_PROGRESS : 53%
[ 2025-05-25 15:52:00.789 NPT ] Completing Database Creation


DBCA_PROGRESS : 57%
DBCA_PROGRESS : 59%
DBCA_PROGRESS : 60%
[ 2025-05-25 16:15:09.557 NPT ] Creating Pluggable Databases
DBCA_PROGRESS : 64%
DBCA_PROGRESS : 80%
[ 2025-05-25 16:16:06.749 NPT ] Executing Post Configuration Actions
DBCA_PROGRESS : 100%
[ 2025-05-25 16:16:06.753 NPT ] Database creation complete. For details check the logfiles at:
 /opt/app/oracle/cfgtoollogs/dbca/pdbdb.
Database Information:
Global Database Name:pdbdb
System Identifier(SID) Prefix:pdbdb
*/

-- Step 96 -->> On Node 1  
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Mon May 26 11:15:25 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

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
Version 19.27.0.0.0
*/

-- Step 97 -->> On Both Nodes 
[oracle@pdb1/pdb2 ~]$ srvctl config database -d pdbdb
/*
Database unique name: pdbdb
Database name: pdbdb
Oracle home: /opt/app/oracle/product/19c/db_1
Oracle user: oracle
Spfile: +DATA/PDBDB/PARAMETERFILE/spfile.285.1202055169
Password file: +DATA/PDBDB/PASSWORD/pwdpdbdb.256.1202051163
Domain:
Start options: open
Stop options: immediate
Database role: PRIMARY
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
Configured nodes: pdb1,pdb2
CSS critical: no
CPU count: 0
Memory target: 0
Maximum memory: 0
Default network number for database services:
Database is administrator managed
*/

-- Step 98 -->> On Both Nodes 
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 99 -->> On Both Nodes 
[oracle@pdb1/pdb2 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): pdb2,pdb1
*/

-- Step 100 -->> On Node 1 
[oracle@pdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 26-MAY-2025 11:17:20

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                25-MAY-2025 16:53:06
Uptime                    0 days 18 hr. 24 min. 14 sec
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

-- Step 101 -->> On Node 2 
[oracle@pdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 26-MAY-2025 11:17:20

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                25-MAY-2025 17:00:51
Uptime                    0 days 18 hr. 16 min. 29 sec
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

-- To Fix the ADRCI log if occured in remote nodes
-- Step Fix.1 -->> On Node 2
[oracle@pdb2 ~]$ adrci
/*
ADRCI: Release 19.0.0.0.0 - Production on Mon May 26 11:17:50 2025

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

No ADR base is set
adrci> exit
*/

-- Step Fix.2 -->> On Node 2
[oracle@pdb1 ~]$ ls -ltr /opt/app/oracle/product/19c/db_1/log/diag/
/*
-rw-r----- 1 oracle asmadmin 16 May 25 16:54 adrci_dir.mif
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
ADRCI: Release 19.0.0.0.0 - Production on Mon May 26 11:51:31 2025

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

ADR base = "/opt/app/oracle"
adrci> show home
ADR Homes:
diag/rdbms/pdbdb/pdbdb2
diag/asm/+asm/+ASM2
diag/crs/pdb2/crs
diag/clients/user_root/host_1869589228_110
diag/tnslsnr/pdb2/asmnet1lsnr_asm
diag/tnslsnr/pdb2/listener_scan1
diag/tnslsnr/pdb2/listener
diag/tnslsnr/pdb2/listener_scan3
diag/tnslsnr/pdb2/listener_scan2
diag/asmtool/user_grid/host_1869589228_110
diag/asmcmd/user_root/pdb2.unidev.org.np
diag/asmcmd/user_grid/pdb2.unidev.org.np
diag/kfod/pdb2/kfod
adrci> exit
*/

-- Step 102 -->> On Node 1
[root@pdb1 ~]# vi /etc/oratab
/*
+ASM1:/opt/app/19c/grid:N
pdbdb:/opt/app/oracle/product/19c/db_1:N
pdbdb1:/opt/app/oracle/product/19c/db_1:N
*/

-- Step 103 -->> On Node 2
[root@pdb2 ~]# vi /etc/oratab 
/*
+ASM2:/opt/app/19c/grid:N
pdbdb:/opt/app/oracle/product/19c/db_1:N
pdbdb2:/opt/app/oracle/product/19c/db_1:N
*/

-- Step 104 -->> On Node 1
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
      (SERVICE_NAME = sbxpdb)
    )
  )
*/

-- Step 105 -->> On Node 2
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
      (SERVICE_NAME = sbxpdb)
    )
  )
*/

-- Step 106 -->> On Both Node
[oracle@pdb1/pdb2 ~]$ tnsping pdbdb
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 26-MAY-2025 11:53:21

Copyright (c) 1997, 2025, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdb-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = pdbdb)))
OK (0 msec)
*/

-- Step 106.1 -->> On Both Node
[oracle@pdb1/pdb2 ~]$ tnsping sbxpdb
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 26-MAY-2025 11:53:41

Copyright (c) 1997, 2025, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = pdb-scan)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = sbxpdb)))
OK (0 msec)
*/

-- Step 106.2 -->> On Node 1
[oracle@pdb1 ~]$ tnsping pdbdb1
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 26-MAY-2025 11:53:52

Copyright (c) 1997, 2025, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.6.21)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = pdbdb)))
OK (0 msec)
*/

-- Step 106.3 -->> On Node 2
[oracle@pdb2 ~]$ tnsping pdbdb2
/*
TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 26-MAY-2025 11:54:24

Copyright (c) 1997, 2025, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.6.22)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = pdbdb)))
OK (0 msec)
*/

-- Step 107 -->> On Node 1
[oracle@pdb1 ~]$ sqlplus sys/Sys605014@pdbdb as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Mon May 26 11:54:51 2025
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
Version 19.27.0.0.0
*/

-- Step 108 -->> On Node 1
[root@pdb1 ~]# cd /opt/app/19c/grid/bin
[root@pdb1 ~]# ./crsctl stop cluster -all
[root@pdb1 ~]# ./crsctl start cluster -all

-- Step 109 -->> On Node 1
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
ora.driver.afd
      1        ONLINE  ONLINE       pdb1                     STABLE
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

-- Step 110 -->> On Node 2
[root@pdb2 ~]# cd /opt/app/19c/grid/bin
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
ora.driver.afd
      1        ONLINE  ONLINE       pdb2                     STABLE
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

-- Step 111 -->> On Both Nodes
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
ora.pdbdb.db
      1        ONLINE  ONLINE       pdb1                     Open,HOME=/opt/app/oracle/product/19c/db_1,STABLE
      2        ONLINE  ONLINE       pdb2                     Open,HOME=/opt/app/oracle/product/19c/db_1,STABLE
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

-- Step 112 -->> On Both Nodes
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

-- Step 113 -->> On Both Nodes
-- ASM Verification
[root@pdb1/pdb2 ~]# su - grid
[grid@pdb1/pdb2 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  1048576    409599   409130                0          409130              0             N  ARC/
MOUNTED  EXTERN  N         512             512   4096  1048576    204799   197685                0          197685              0             N  DATA/
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20112                0           20112              0             Y  OCR/
ASMCMD [+] > exit
*/

-- Step 114 -->> On Node 1
[grid@pdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 26-MAY-2025 12:01:21

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                25-MAY-2025 16:53:06
Uptime                    0 days 19 hr. 8 min. 14 sec
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

-- Step 115 -->> On Node 2
[grid@pdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 26-MAY-2025 12:01:21

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                25-MAY-2025 17:00:51
Uptime                    0 days 19 hr. 0 min. 30 sec
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

-- Step 116 -->> On Node 1
[grid@pdb1 ~]$ ps -ef | grep SCAN
/*
grid     2023771       1  0 May25 ?        00:00:02 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN3 -no_crs_notify -inherit
grid     2023773       1  0 May25 ?        00:00:02 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid     2746096 2745393  0 12:01 pts/1    00:00:00 grep --color=auto SCAN
*/

-- Step 116.1 -->> On Node 1
[grid@pdb1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 26-MAY-2025 12:02:15

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                25-MAY-2025 16:59:16
Uptime                    0 days 19 hr. 2 min. 59 sec
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

-- Step 116.2 -->> On Node 1
[grid@pdb1 ~]$ lsnrctl status LISTENER_SCAN3
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 26-MAY-2025 12:02:29

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN3)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN3
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                25-MAY-2025 16:59:16
Uptime                    0 days 19 hr. 3 min. 12 sec
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

-- Step 117 -->> On Node 2
[grid@pdb2 ~]$ ps -ef | grep SCAN
/*
grid     1910030       1  0 May25 ?        00:00:02 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid     2594120 2593360  0 12:01 pts/1    00:00:00 grep --color=auto SCAN
*/

-- Step 117.1 -->> On Node 2
[grid@pdb2 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 26-MAY-2025 12:02:56

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                25-MAY-2025 17:00:52
Uptime                    0 days 19 hr. 2 min. 3 sec
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

-- Step 118 -->> On Both Nodes
[grid@pdb1/pdb2 ~]$ ps -ef | grep ASMNET1LSNR
/*
grid     2003538       1  0 May25 ?        00:00:03 /opt/app/19c/grid/bin/tnslsnr ASMNET1LSNR_ASM -no_crs_notify -inherit
grid     2746901 2745393  0 12:03 pts/1    00:00:00 grep --color=auto ASMNET1LSNR
*/

-- Step 118.1 -->> On Node 1
[grid@pdb1 ~]$ lsnrctl status ASMNET1LSNR_ASM
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 26-MAY-2025 12:03:35

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=ASMNET1LSNR_ASM)))
STATUS of the LISTENER
------------------------
Alias                     ASMNET1LSNR_ASM
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                25-MAY-2025 16:53:20
Uptime                    0 days 19 hr. 10 min. 14 sec
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

-- Step 118.2 -->> On Node 2
[grid@pdb2 ~]$ lsnrctl status ASMNET1LSNR_ASM
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 26-MAY-2025 12:03:37

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=ASMNET1LSNR_ASM)))
STATUS of the LISTENER
------------------------
Alias                     ASMNET1LSNR_ASM
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                25-MAY-2025 17:00:53
Uptime                    0 days 19 hr. 2 min. 44 sec
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

-- Step 119 -->> On Both Nodes
[grid@pdb1/pdb2 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Mon May 26 12:04:29 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

SQL> set lines 200;
SQL> col BANNER_FULL format a80;
SQL> col BANNER_LEGACY format a80;
SQL> SELECT inst_id,banner_full,banner_legacy,con_id FROM gv$version;

   INST_ID BANNER_FULL                                                                      BANNER_LEGACY                                                                        CON_ID
---------- -------------------------------------------------------------------------------- -------------------------------------------------------------------------------- ----------
         2 Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production           Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production                    0
           Version 19.27.0.0.0

         1 Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production           Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production                    0
           Version 19.27.0.0.0

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0
*/

-- Step 120 -->> On Both Nodes
-- DB Service Verification
[root@pdb1/pdb2 ~]# su - oracle
[oracle@pdb1/pdb2 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

-- Step 121 -->> On Both Nodes
-- Listener Service Verification
[oracle@pdb1/pdb2 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): pdb2,pdb1
*/

-- Step 122 -->> On Both Nodes
[oracle@pdb1/pdb2 ~]$ rman target sys/Sys605014@pdbdb
--OR--
[oracle@pdb1/pdb2 ~]$ rman target /
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Mon May 26 12:03:11 2025
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

-- Step 123 -->> On Both Nodes
[oracle@pdb1/pdb2 ~]$ rman target sys/Sys605014@sbxpdb
/*
Recovery Manager: Release 19.0.0.0.0 - Production on Mon May 26 12:07:25 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: PDBDB:SBXPDB (DBID=1990735703, not open)

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
-- Step 124 -->> On Both Nodes
-- To connnect CDB$ROOT using TNS
[oracle@pdb1/pdb2 ~]$ sqlplus sys/Sys605014@pdbdb as sysdba

-- Step 125 -->> On Node 1
[oracle@pdb1 ~]$ sqlplus sys/Sys605014@pdbdb1 as sysdba

-- Step 126 -->> On Node 2
[oracle@pdb2 ~]$ sqlplus sys/Sys605014@pdbdb2 as sysdba

-- Step 127 -->> On Both Nodes
-- To connnect PDB using TNS
[oracle@pdb1/pdb2 ~]$ sqlplus sys/Sys605014@sbxpdb as sysdba



---------------------------------------------------------------------------------------------------------------
----------------------------------To Add Disks Using Oracle ASM Filter Driver----------------------------------
---------------------------------------------------------------------------------------------------------------
-- Step 1
  Create Disk in SAN Storage and mapping in appropriate location

-- Step 2
   Reboot the relevent server
   OR
   Use below commads to reflect partition without rebooting server:
   
   cat /proc/scsi/scsi | egrep –I ‘Host:’ | wc -l
   /*
   30
   */
   /usr/bin/rescan-scsi-bus.sh
   cat /proc/scsi/scsi | egrep –I ‘Host:’ | wc -l
   /*
   34
   */

-- Step 3 -->> On Both Node
[root@pdb1/pdb2 ~]# fdisk -ll | grep -E "sd"
/*
Disk /dev/sda: 222 GiB, 238370684928 bytes, 465567744 sectors
/dev/sda1  *       2048   4196351   4194304    2G 83 Linux
/dev/sda2       4196352 465567743 461371392  220G 8e Linux LVM
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
/dev/sdb1        2048 41943039 41940992  20G 83 Linux
Disk /dev/sdc: 200 GiB, 214748364800 bytes, 419430400 sectors
/dev/sdc1        2048 419430399 419428352  200G 83 Linux
Disk /dev/sdd: 400 GiB, 429496729600 bytes, 838860800 sectors
/dev/sdd1        2048 838860799 838858752  400G 83 Linux
Disk /dev/sde: 10 GiB, 10737418240 bytes, 20971520 sectors
*/

-- Step 4  -->> On Node 1
[root@pdb1 ~]# fdisk /dev/sde
/*
Welcome to fdisk (util-linux 2.37.4).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0xfa8997a7.

Command (m for help): p
Disk /dev/sde: 10 GiB, 10737418240 bytes, 20971520 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xfa8997a7

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-20971519, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-20971519, default 20971519):

Created a new partition 1 of type 'Linux' and of size 10 GiB.

Command (m for help): p
Disk /dev/sde: 10 GiB, 10737418240 bytes, 20971520 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xfa8997a7

Device     Boot Start      End  Sectors Size Id Type
/dev/sde1        2048 20971519 20969472  10G 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 5  -->> On Node 1
[root@pdb1 ~]# mkfs.xfs -f /dev/sde1

-- Step 6  -->> On Both Node (If Necessary)
[root@pdb1/pdb2 ~]# partprobe /dev/sde1

-- Step 7  -->> On Both Node
[root@pdb1/pdb2 ~]# lsblk /dev/sde
/*
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
sde      8:64   0  10G  0 disk
└─sde1   8:65   0  10G  0 part
*/

-- Step 8  -->> On Both Node
[root@pdb1/pdb2 ~]# fdisk -ll | grep -E "sde"
/*
Disk /dev/sde: 10 GiB, 10737418240 bytes, 20971520 sectors
/dev/sde1        2048 20971519 20969472  10G 83 Linux
*/

-- Step 9  -->> On Both Node
[root@pdb1/pdb2 ~]# lsmod | grep oracleafd
/*
oracleafd             290816  52
*/

-- Step 10  -->> On Both Node
[root@pdb1/pdb2 ~]# ll /dev/oracleafd/disks/
/*
-rw-r--r-- 1 grid asmadmin 10 May 18 15:08 ARC
-rw-r--r-- 1 grid asmadmin 10 May 18 15:08 DATA
-rw-r--r-- 1 grid asmadmin 10 May 18 15:08 OCR
*/

-- Step 11  -->> On Both Node
[root@pdb1/pdb2 ~]# ll /dev/oracleafd/disks/*
/*
-rw-r--r-- 1 grid asmadmin 10 May 18 15:08 /dev/oracleafd/disks/ARC
-rw-r--r-- 1 grid asmadmin 10 May 18 15:08 /dev/oracleafd/disks/DATA
-rw-r--r-- 1 grid asmadmin 10 May 18 15:08 /dev/oracleafd/disks/OCR
*/

-- Step 12  -->> On Both Node
[root@pdb1/pdb2 ~]# export ORACLE_HOME=/opt/app/19c/grid
[root@pdb1/pdb2 ~]# export CV_ASSUME_DISTID=OEL7.8
[root@pdb1/pdb2 ~]# export ORACLE_BASE=/opt/app/oracle
[root@pdb1/pdb2 ~]# /opt/app/19c/grid/bin/asmcmd showclustermode
/*
ASM cluster : Flex mode enabled - Direct Storage Access
*/

-- Step 13  -->> On Both Node
[root@pdb1/pdb2 ~]# /opt/app/19c/grid/bin/asmcmd afd_state
/*
ASMCMD-9526: The AFD state is 'LOADED' and filtering is 'DISABLED' on host 'pdb1/pdb2.unidev.org.np'
*/

-- Step 14  -->> On Both Node
[root@pdb1/pdb2 ~]# /opt/app/19c/grid/bin/asmcmd afd_scan
[root@pdb1/pdb2 ~]# /opt/app/19c/grid/bin/asmcmd afd_lslbl
/*
--------------------------------------------------------------------------------
Label                     Duplicate  Path
================================================================================
ARC                                   /dev/sdd1
DATA                                  /dev/sdc1
OCR                                   /dev/sdb1
*/

-- Step 15 -->> On Node 1
[root@pdb1 ~]# /opt/app/19c/grid/bin/asmcmd afd_label DATA01 /dev/sde1
[root@pdb1 ~]# /opt/app/19c/grid/bin/asmcmd afd_scan
[root@pdb1 ~]# /opt/app/19c/grid/bin/asmcmd afd_lslbl
/*
--------------------------------------------------------------------------------
Label                     Duplicate  Path
================================================================================
ARC                                   /dev/sdd1
DATA                                  /dev/sdc1
DATA01                                /dev/sde1
OCR                                   /dev/sdb1
*/

-- Step 16 -->> On Node 2
[root@pdb2 ~]# /opt/app/19c/grid/bin/asmcmd afd_scan
[root@pdb2 ~]# /opt/app/19c/grid/bin/asmcmd afd_lslbl
/*
--------------------------------------------------------------------------------
Label                     Duplicate  Path
================================================================================
ARC                                   /dev/sdd1
DATA                                  /dev/sdc1
DATA01                                /dev/sde1
OCR                                   /dev/sdb1
*/

-- Step 17 -->> On Both Node
[root@pdb1/pdb2 ~]# ll /dev/oracleafd/disks/*
/*
-rw-rw-r-- 1 grid oinstall 10 May 18 15:44 /dev/oracleafd/disks/ARC
-rw-rw-r-- 1 grid oinstall 10 May 18 15:44 /dev/oracleafd/disks/DATA
-rw-rw-r-- 1 grid oinstall 10 May 18 16:05 /dev/oracleafd/disks/DATA01
-rw-rw-r-- 1 grid oinstall 10 May 18 15:44 /dev/oracleafd/disks/OCR
*/

-- Step 18 -->> On Both Node
[root@pdb1/pdb2 ~]# ll /dev/oracleafd/disks/
/*
-rw-rw-r-- 1 grid oinstall 10 May 18 15:44 ARC
-rw-rw-r-- 1 grid oinstall 10 May 18 15:44 DATA
-rw-rw-r-- 1 grid oinstall 10 May 18 16:05 DATA01
-rw-rw-r-- 1 grid oinstall 10 May 18 15:44 OCR
*/

-- Step 19 -->> On Node 1
-- Login as grid user then issue the commnad from sqlplus / as sysasm
-- First we identify the ASM diskgroup where we want to add the disk
[grid@pdb1 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Mon May 26 12:13:35 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

SQL> set linesize 9999
SQL> col group_number for a60
SQL> select
        group_number,
        name
     from
        v$asm_diskgroup;

GROUP_NUMBER NAME
------------ -----
           0
           1 ARC
           2 DATA
           3 OCR

SQL> col path for a60
SQL> SELECT path,header_status,state FROM v$asm_disk;

PATH       HEADER_STATU STATE
---------- ------------ --------
AFD:DATA01 PROVISIONED  NORMAL
AFD:OCR    MEMBER       NORMAL
AFD:ARC    MEMBER       NORMAL
AFD:DATA   MEMBER       NORMAL

SQL> set lines 200;
SQL> col path format a40;
SQL> select name,path, group_number group_#, disk_number disk_#, mount_status,header_status, state, total_mb, free_mb from v$asm_disk order by group_number;

NAME PATH       GROUP_# DISK_# MOUNT_S HEADER_STATU STATE  TOTAL_MB FREE_MB
---- ---------- ------- ------ ------- ------------ ------ -------- -------
     AFD:DATA01       0      0 CLOSED  PROVISIONED  NORMAL        0       0
ARC  AFD:ARC          1      0 CACHED  MEMBER       NORMAL   409599  409256
DATA AFD:DATA         2      0 CACHED  MEMBER       NORMAL   204799  197926
OCR  AFD:OCR          3      0 CACHED  MEMBER       NORMAL    20476   20112

SQL> ALTER DISKGROUP DATA ADD DISK 'AFD:DATA01' NAME DATA01;

Diskgroup altered.

SQL> col name for a60
SQL> SELECT name, total_mb/1024 total_gb, free_mb/1024 free_gb, free_mb/total_mb*100 free_pct FROM v$asm_diskgroup;SQL>

NAME   TOTAL_GB    FREE_GB   FREE_PCT
---- ---------- ---------- ----------
ARC  399.999023 399.664063 99.9162596
DATA 209.998047 203.283203 96.8024256
OCR  19.9960938  19.640625  98.222309

SQL> col operation for a60
SQL> SELECT inst_id, operation, state, power, sofar, est_work, est_rate, est_minutes from GV$ASM_OPERATION;

-- Next, to view the rebalancing status
col operation for a60
SELECT inst_id, operation, state, power, sofar, est_work, est_rate, est_minutes from GV$ASM_OPERATION;

-- Next, to change the rebalancing status
ALTER DISKGROUP DATA rebalance power 11;

-- Next, to view the rebalancing status
col operation for a60
SELECT inst_id, operation, state, power, sofar, est_work, est_rate, est_minutes from GV$ASM_OPERATION;
-- Note: After no rows returned by the query (rebalancing status) then we have to process the data operation over DATA

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0
*/

-- Step 20 -->> On Both Node
[grid@pdb1/pdb2 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  1048576    409599   409256                0          409256              0             N  ARC/
MOUNTED  EXTERN  N         512             512   4096  1048576    215038   208162                0          208162              0             N  DATA/
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20112                0           20112              0             Y  OCR/
ASMCMD [+] > exit
*/