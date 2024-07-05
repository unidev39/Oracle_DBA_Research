--https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=84985638019625&id=276434.1&_afrWindowMode=0&_adf.ctrl-state=gaged7b7s_53

--How to Change Various IP's In Oracle RAC Cluster
--Step 1 (Check current network information)
[grid@tpdb1 ~]$ which oifcfg
/*
/opt/app/19c/grid/bin/oifcfg
*/

--Step 1.1 (Check current network information)
[grid@tpdb1 ~]$ oifcfg getif
/*
eno1  192.168.200.0  global  public
eno2  20.20.20.0  global  cluster_interconnect,asm
*/

--Step 2 (Current IP Configurations)
[grid@tpdb1 ~]$ cat /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.168.200.2   tpdb1.unidev.org.np        tpdb1

# Private
20.20.20.2      tpdb1-priv.unidev.org.np   tpdb1-priv

# Virtual
192.168.200.3   tpdb1-vip.unidev.org.np    tpdb1-vip

# SCAN
192.168.200.4   tpdb-scan.unidev.org.np    tpdb-scan
192.168.200.5   tpdb-scan.unidev.org.np    tpdb-scan
*/

--Step 2.1 (Required to change as IP Configurations)
[grid@tpdb1 ~]$ cat /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.168.129.208   tpdb1.unidev.org.np        tpdb1

# Private
10.10.10.28    tpdb1-priv.unidev.org.np   tpdb1-priv

# Virtual
192.168.129.209   tpdb1-vip.unidev.org.np    tpdb1-vip

# SCAN
192.168.129.210   tpdb-scan.unidev.org.np    tpdb-scan
192.168.129.211   tpdb-scan.unidev.org.np    tpdb-scan
*/

--Step 3 (Check current status of Cluster)
[grid@tpdb1 ~]$ which crsctl
/*
/opt/app/19c/grid/bin/crsctl
*/

--Step 3.1 (Check current status of Cluster)
[grid@tpdb1 ~]$ crsctl stat res -t
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

--Step 4 (Stopping Resources)
[grid@tpdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node tpdb1. Instance status: Open.
*/

--Step 4.1
[grid@tpdb1 ~]$ srvctl stop database -d pdbdb

--Step 4.2
[grid@tpdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is not running on node tpdb1
*/

--Step 5
[grid@tpdb1 ~]$ srvctl status asm
/*
ASM is running on tpdb1
*/

--Step 5.1
[grid@tpdb1 ~]$ srvctl stop asm
/*
PRCR-1214 : failed to stop resource group ora.asmgroup
CRS-2893: Cannot stop ASM instance on server 'tpdb1' because it is the only instance running.
CRS-0223: Resource 'RGI: ora.asmgroup 1 1' has placement error.
*/

--Step 5.2
[grid@tpdb1 ~]$ srvctl stop asm -f
/*
PRCR-1214 : failed to stop resource group ora.asmgroup
CRS-2893: Cannot stop ASM instance on server 'tpdb1' because it is the only instance running.
CRS-0223: Resource 'RGI: ora.asmgroup 1 1' has placement error.
*/

--Step 6
[grid@tpdb1 ~]$ srvctl status nodeapps
/*
VIP 192.168.200.3 is enabled
VIP 192.168.200.3 is running on node: tpdb1
Network is enabled
Network is running on node: tpdb1
ONS is enabled
ONS daemon is running on node: tpdb1
*/

--Step 7
[grid@tpdb1 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): tpdb1
*/

--Step 7.1
[grid@tpdb1 ~]$ srvctl stop listener

--Step 7.2
[grid@tpdb1 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is not running
*/

--Step 8
[grid@tpdb1 ~]$ srvctl status vip -n tpdb1
/*
VIP 192.168.200.3 is enabled
VIP 192.168.200.3 is running on node: tpdb1
*/

--Step 8.1
[grid@tpdb1 ~]$ srvctl stop vip -n tpdb1

--Step 8.2
[grid@tpdb1 ~]$ srvctl status vip -n tpdb1
/*
VIP 192.168.200.3 is enabled
VIP 192.168.200.3 is not running
*/

--Step 9
[grid@tpdb1 ~]$ srvctl stop nodeapps -f
/*
PRCC-1016 : tpdb1-vip was already stopped
PRCR-1005 : Resource ora.tpdb1.vip is already stopped
*/

--Step 9.1
[grid@tpdb1 ~]$ srvctl status nodeapps
/*
VIP 192.168.200.3 is enabled
VIP 192.168.200.3 is not running
Network is enabled
Network is not running on node: tpdb1
ONS is enabled
ONS daemon is not running on node: tpdb1
*/

--Step 10
[grid@tpdb1 ~]$ crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               OFFLINE OFFLINE      tpdb1                    STABLE
ora.chad
               ONLINE  ONLINE       tpdb1                    STABLE
ora.net1.network
               OFFLINE OFFLINE      tpdb1                    STABLE
ora.ons
               OFFLINE OFFLINE      tpdb1                    STABLE
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
      1        ONLINE  OFFLINE                               STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  OFFLINE                               STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       tpdb1                    Started,STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       tpdb1                    STABLE
ora.cvu
      1        ONLINE  OFFLINE                               STABLE
ora.pdbdb.db
      1        OFFLINE OFFLINE                               Instance Shutdown,ST
                                                             ABLE
ora.qosmserver
      1        ONLINE  OFFLINE                               STABLE
ora.scan1.vip
      1        ONLINE  OFFLINE                               STABLE
ora.scan2.vip
      1        ONLINE  OFFLINE                               STABLE
ora.tpdb1.vip
      1        OFFLINE OFFLINE                               STABLE
--------------------------------------------------------------------------------
*/

--Step 11 Changing public and private network interface, subnet or netmask
--Step 11.1 (Check current network information)
[grid@tpdb1 ~]$ oifcfg getif
/*
eno1  192.168.200.0  global  public
eno2  20.20.20.0  global  cluster_interconnect,asm
*/

--Step 11.2 Public IP - Delete the existing interface information from OCR
[grid@tpdb1 ~]$ oifcfg delif -global eno1/192.168.200.0

--Step 11.3 Public IP - Add it back with the correct information
[grid@tpdb1 ~]$ oifcfg setif -global eno1/192.168.129.0:public

--Step 11.4 (Check current network information)
[grid@tpdb1 ~]$ oifcfg getif
/*
eno2  20.20.20.0  global  cluster_interconnect,asm
eno1  192.168.129.0  global  public
*/

--Step 11.5 Private IP - Add it back with the correct information
[grid@tpdb1 ~]$ oifcfg setif -global eno2/10.10.10.0:cluster_interconnect,asm

--Step 11.6 (Check current network information)
[grid@tpdb1 ~]$ oifcfg getif
/*
eno2  20.20.20.0  global  cluster_interconnect,asm
eno1  192.168.129.0  global  public
eno2  10.10.10.0  global  cluster_interconnect,asm
*/

--Step 11.7 Private IP - Delete the existing interface information from OCR
[grid@tpdb1 ~]$ oifcfg  delif -global eno2/20.20.20.0
[grid@tpdb1 ~]$ oifcfg getif
/*
eno1  192.168.129.0  global  public
eno2  10.10.10.0  global  cluster_interconnect,asm
*/

--Step 11.8 Shutdown the cluster
[root@tpdb1 ~]# cd /opt/app/19c/grid/bin/
[root@tpdb1 bin]# ./crsctl stop cluster -all

--Step 11.9 Modify the Public and Private IPs address at network hosts layer
[grid@tpdb1 ~]$ vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.168.129.208 tpdb1.unidev.org.np        tpdb1

# Private
10.10.10.208 tpdb1-priv.unidev.org.np   tpdb1-priv

# Virtual
192.168.200.3   tpdb1-vip.unidev.org.np    tpdb1-vip

# SCAN
192.168.200.4   tpdb-scan.unidev.org.np    tpdb-scan
192.168.200.5   tpdb-scan.unidev.org.np    tpdb-scan
*/

--Step 11.10 Modify the Public and Private IPs address at network DNS layer

--Step 11.11 Change the interface-eno1 for IP
[root@tpdb1 ~]# vi /etc/sysconfig/network-scripts/ifcfg-eno1
/*
TYPE=Ethernet
BOOTPROTO=static
NAME=eno1
DEVICE=eno1
ONBOOT=yes
IPADDR=192.168.129.208
NETMASK=255.255.255.0
GATEWAY=192.168.129.1
DNS1=127.0.0.1
DNS2=192.168.10.180
DNS3=192.168.10.181
*/

--Step 11.12 Change the interface-eno2 for IP
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

--Step 11.13 Restart the Network services
[root@tpdb1 ~]# systemctl restart network-online.target
[root@tpdb1 ~]# systemctl restart NetworkManager

--Step 11.14 Shut the OS
[root@tpdb1 bin]# init 0

--Step 11.15 Changes The Ethernet Connectivity for (192.168.129.208/10.10.10.208)

--Step 11.16 Power ON the relevant Server to resume the rest Private IPs changes

--Step 11.17 Verify the current status of asmnetwork
[grid@tpdb1 ~]$ srvctl status asmnetwork
/*
ASM network 1 is not running.
*/

--Step 11.18 Verify the configuration of asmnetwork
[grid@tpdb1 ~]$ srvctl config asmnetwork
/*
ASM network 1 exists
Subnet IPv4: 20.20.20.0//
Subnet IPv6:
Network is enabled
Network is individually enabled on nodes:
Network is individually disabled on nodes:
*/

--Step 11.19 Verify the configuration of asmnet-listenr
[grid@tpdb1 ~]$ srvctl config listener -l asmnet1lsnr_asm
/*
Name: ASMNET1LSNR_ASM
Type: ASM Listener
Owner: grid
Subnet: 20.20.20.0
Home: <CRS home>
End points: TCP:1525
Listener is enabled.
Listener is individually enabled on nodes:
Listener is individually disabled on nodes:
*/

--Step 11.20 Verify the cluster status of subnets
[grid@tpdb1 ~]$ crsctl stat res -p|grep SUBNET
/*
SUBNET=20.20.20.0
REGISTRATION_INVITED_SUBNETS=
REGISTRATION_INVITED_SUBNETS=
USR_ORA_SUBNET=20.20.20.0
USR_ORA_SUBNET=192.168.200.0
*/

--Step 11.21 Remove the asm-network - from root user
[root@tpdb1 ~]# /opt/app/19c/grid/bin/srvctl remove asmnetwork -netnum 1 -force

--Step 11.22 Verify the asm-network - from root user
[root@tpdb1 ~]# /opt/app/19c/grid/bin/srvctl config asmnetwork
/*
PRCN-2045 : No network exists
*/

--Step 11.23 Add the with subnet of asm-network - from root user
[root@tpdb1 ~]# /opt/app/19c/grid/bin/srvctl add  asmnetwork -subnet 10.10.10.0

--Step 11.24 Verify the asm-network configuration - from root user
[root@tpdb1 ~]# /opt/app/19c/grid/bin/srvctl config asmnetwork
/*
ASM network 1 exists
Subnet IPv4: 10.10.10.0//
Subnet IPv6:
Network is enabled
Network is individually enabled on nodes:
Network is individually disabled on nodes:
*/

--Step 11.25 Verify the configuration of asmnet-listenr
[grid@tpdb1 ~]$ srvctl config listener -l asmnet1lsnr_asm
/*
Name: ASMNET1LSNR_ASM
Type: ASM Listener
Owner: grid
Subnet: 20.20.20.0
Home: <CRS home>
End points: TCP:1525
Listener is enabled.
Listener is individually enabled on nodes:
Listener is individually disabled on nodes:
*/

--Step 11.26 Verify the cluster status of subnets
[grid@tpdb1 ~]$ crsctl stat res -p|grep SUBNET
/*
SUBNET=20.20.20.0
REGISTRATION_INVITED_SUBNETS=
REGISTRATION_INVITED_SUBNETS=
USR_ORA_SUBNET=10.10.10.0
USR_ORA_SUBNET=192.168.200.0
*/

--Step 11.27 Verify the configuration of asm-listenr
[grid@tpdb1 ~]$ srvctl config listener -asmlistener
/*
Name: ASMNET1LSNR_ASM
Type: ASM Listener
Owner: grid
Subnet: 20.20.20.0
Home: <CRS home>
End points: TCP:1525
Listener is enabled.
Listener is individually enabled on nodes:
Listener is individually disabled on nodes:
*/

--Step 11.28 Remove the configuration of asmnet-listenr
[grid@tpdb1 ~]$ srvctl update listener -listener ASMNET1LSNR_ASM -asm -remove -force

--Step 11.29 Verify the configuration of asm-listenr
[grid@tpdb1 ~]$ srvctl config listener -asmlistener
/*
PRCN-2044 : No listener exists
*/

--Step 11.30 Add the configuration of asmnet-listenr
[grid@tpdb1 ~]$ srvctl add listener -listener ASMNET1LSNR_ASM -oraclehome $GRID_HOME -asmlistener -netnum 1

--Step 11.31 Verify the configuration of asm-listenr
[grid@tpdb1 ~]$ srvctl config listener -asmlistener
/*
Name: ASMNET1LSNR_ASM
Type: ASM Listener
Owner: grid
Subnet: 10.10.10.0
Home: <CRS home>
End points: TCP:1525
Listener is enabled.
Listener is individually enabled on nodes:
Listener is individually disabled on nodes:
*/

--Step 11.32 Verify the cluster status of subnets
[grid@tpdb1 ~]$ crsctl stat res -p|grep SUBNET
/*
SUBNET=10.10.10.0
REGISTRATION_INVITED_SUBNETS=
REGISTRATION_INVITED_SUBNETS=
USR_ORA_SUBNET=10.10.10.0
USR_ORA_SUBNET=192.168.200.0
*/

--Step 11.33 Verify the configuration of asmnet-listenr
[grid@tpdb1 ~]$ srvctl config listener -l asmnet1lsnr_asm
/*
Name: ASMNET1LSNR_ASM
Type: ASM Listener
Owner: grid
Subnet: 10.10.10.0
Home: <CRS home>
End points: TCP:1525
Listener is enabled.
Listener is individually enabled on nodes:
Listener is individually disabled on nodes:
*/

--Step 11.34 Stop the asmnet-listenr
[grid@tpdb1 ~]$ srvctl stop listener -l asmnet1lsnr_asm
/*
PRCC-1016 : ASMNET1LSNR_ASM was already stopped
PRCR-1005 : Resource ora.ASMNET1LSNR_ASM.lsnr is already stopped
*/

--Step 11.35 Start the asmnet-listenr
[grid@tpdb1 ~]$ srvctl start listener -l asmnet1lsnr_asm

--Step 11.36 Verify the asmnet-listenr
[grid@tpdb1 ~]$ srvctl status listener -l asmnet1lsnr_asm
/*
Listener ASMNET1LSNR_ASM is enabled
Listener ASMNET1LSNR_ASM is running on node(s): tpdb1
*/

--Step 11.37 Reboot the OS 
[root@tpdb1 ~]# init 6

--Step 12 To Change the Server used Vertual IP - VIP
--Step 12.1 Stopping Resources
--Step 12.2 Stop the database
[grid@tpdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is not running on node tpdb1
*/

--Step 12.3 Stop the listener
[grid@tpdb1 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is not running
*/

--Step 12.4 Stop the vip on relevant nodes
[grid@tpdb1 ~]$ srvctl status vip -n tpdb1
/*
VIP 192.168.200.3 is enabled
VIP 192.168.200.3 is not running
*/

--Step 12.5 Stop the nodeapps
[grid@tpdb1 ~]$ srvctl status nodeapps
/*
VIP 192.168.200.3 is enabled
VIP 192.168.200.3 is not running
Network is enabled
Network is not running on node: tpdb1
ONS is enabled
ONS daemon is not running on node: tpdb1
*/

--Step 12.6 Verify the status of vip's on cluster
[root@tpdb1 ~]# cd /opt/app/19c/grid/bin/
[root@tpdb1 bin]# ./crsctl stat res -t

--Step 12.7 Verify the interfaces
[root@tpdb1 ~]# ifconfig -a
/*
eno1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.129.208  netmask 255.255.255.0  broadcast 192.168.129.255
        inet6 fe80::8218:44ff:fee3:caec  prefixlen 64  scopeid 0x20<link>
        ether 80:18:44:e3:ca:ec  txqueuelen 1000  (Ethernet)
        RX packets 39864  bytes 4672118 (4.4 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1684  bytes 281089 (274.5 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 38

eno2: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.208  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::8218:44ff:fee3:caed  prefixlen 64  scopeid 0x20<link>
        ether 80:18:44:e3:ca:ed  txqueuelen 1000  (Ethernet)
        RX packets 38825  bytes 4572078 (4.3 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 493  bytes 51856 (50.6 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 53

eno2:1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 169.254.30.9  netmask 255.255.224.0  broadcast 169.254.31.255
        ether 80:18:44:e3:ca:ed  txqueuelen 1000  (Ethernet)
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
        RX packets 32650  bytes 197457266 (188.3 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 32650  bytes 197457266 (188.3 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

--Step 12.8 Verify the configuration of nodeapps
[grid@tpdb1 ~]$ srvctl config nodeapps -a
/*
Network 1 exists
Subnet IPv4: 192.168.200.0/255.255.255.0/eno1, static
Subnet IPv6:
Ping Targets:
Network is enabled
Network is individually enabled on nodes:
Network is individually disabled on nodes:
VIP exists: network number 1, hosting node tpdb1
VIP Name: tpdb1-vip
VIP IPv4 Address: 192.168.200.3
VIP IPv6 Address:
VIP is enabled.
VIP is individually enabled on nodes:
VIP is individually disabled on nodes:
*/

--Step 12.9 Modify the VIP-IPs address at network DNS layer

--Step 12.10 Modify the VIP-IPs address at network hosts layer
[root@tpdb1 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.168.129.208   tpdb1.unidev.org.np        tpdb1

# Private
10.10.10.208    tpdb1-priv.unidev.org.np   tpdb1-priv

# Virtual
192.168.129.209   tpdb1-vip.unidev.org.np    tpdb1-vip

# SCAN
192.168.200.4   tpdb-scan.unidev.org.np    tpdb-scan
192.168.200.5   tpdb-scan.unidev.org.np    tpdb-scan
*/

--Step 12.11 Modify the VIP-IPs address at nodeapps - from root user
[root@tpdb1 ~]# /opt/app/19c/grid/bin/srvctl modify nodeapps -n tpdb1 -A 192.168.129.209/255.255.255.0/eno1

--Step 12.12 Verify the configuration of nodeapps
[grid@tpdb1 ~]$ srvctl config nodeapps -a
/*
Network 1 exists
Subnet IPv4: 192.168.129.0/255.255.255.0/eno1, static
Subnet IPv6:
Ping Targets:
Network is enabled
Network is individually enabled on nodes:
Network is individually disabled on nodes:
VIP exists: network number 1, hosting node tpdb1
VIP Name: tpdb1-vip
VIP IPv4 Address: 192.168.129.209
VIP IPv6 Address:
VIP is enabled.
VIP is individually enabled on nodes:
VIP is individually disabled on nodes:
*/


--Step 12.13 Start the releavnt services
--Step 12.13.1 Start the vip services
[grid@tpdb1 ~]$ srvctl start vip -n tpdb1
--Step 12.13.2 Start the ams services
[grid@tpdb1 ~]$ srvctl start asm
--Step 12.13.3 Start the nodeapps services
[grid@tpdb1 ~]$ srvctl start nodeapps
--Step 12.13.4 Start the database services
[grid@tpdb1 ~]$ srvctl start database -d pdbdb

--Step 12.14 Verify the SUBNETS
[grid@tpdb1 ~]$ crsctl stat res -p|grep SUBNET
/*
SUBNET=10.10.10.0
REGISTRATION_INVITED_SUBNETS=
REGISTRATION_INVITED_SUBNETS=
USR_ORA_SUBNET=10.10.10.0
USR_ORA_SUBNET=192.168.129.0
*/

--Step 12.15 Ensure VIP is online on cluster level
$ crsctl stat res -t
--Step 12.16 Ensure VIP is bounded to network interface
$ ifconfig -a | grep -i RUNNING
/*
eno1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
eno1:1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
eno1:2: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
eno1:3: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
eno2: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
eno2:1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
*/

--Step 12.17 Verify the status of nodeapps on releavant nodes
[grid@tpdb1 ~]$ srvctl status nodeapps -n tpdb1
/*
VIP 192.168.129.209 is enabled
VIP 192.168.129.209 is running on node: tpdb1
Network is enabled
Network is running on node: tpdb1
ONS is enabled
ONS daemon is running on node: tpdb1
*/

--Step 12.18 Verify the configuration of nodeapps
[grid@tpdb1 ~]$ srvctl config nodeapps -a
/*
Network 1 exists
Subnet IPv4: 192.168.129.0/255.255.255.0/eno1, static
Subnet IPv6:
Ping Targets:
Network is enabled
Network is individually enabled on nodes:
Network is individually disabled on nodes:
VIP exists: network number 1, hosting node tpdb1
VIP Name: tpdb1-vip
VIP IPv4 Address: 192.168.129.209
VIP IPv6 Address:
VIP is enabled.
VIP is individually enabled on nodes:
VIP is individually disabled on nodes:
*/

--Step 12.19 Verify the status of listener
[grid@tpdb1 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): tpdb1
*/

--Step 12.20 Verify the status of Cluster
[grid@tpdb1 ~]$ crsctl stat res -t
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

--Step 13 Changing SCAN IPs
--Step 13.1 Verify the Current status of DNS
[grid@tpdb1 ~]$ nslookup tpdb-scan
/*
[grid@tpdb1 ~]$ nslookup tpdb-scan
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   tpdb-scan.unidev.org.np
Address: 192.168.200.4
Name:   tpdb-scan.unidev.org.np
Address: 192.168.200.5
*/

--Step 13.2 Stop the SCAN listener
[grid@tpdb1 ~]$ srvctl stop scan_listener

--Step 13.3 Verify the status of SCAN listener
[grid@tpdb1 ~]$ srvctl status scan_listener
/*
SCAN Listener LISTENER_SCAN1 is enabled
SCAN listener LISTENER_SCAN1 is not running
SCAN Listener LISTENER_SCAN2 is enabled
SCAN listener LISTENER_SCAN2 is not running
*/

--Step 13.4 Stop the SCAN
[grid@tpdb1 ~]$ srvctl stop scan

--Step 13.5 Verify the status of SCAN
[grid@tpdb1 ~]$ srvctl status scan
/*
SCAN VIP scan1 is enabled
SCAN VIP scan1 is not running
SCAN VIP scan2 is enabled
SCAN VIP scan2 is not running
*/

--Step 13.6 Check the current IP address of the SCAN
[grid@tpdb1 ~]$ srvctl config scan
/*
SCAN name: tpdb-scan, Network: 1
Subnet IPv4: 192.168.129.0/255.255.255.0/eno1, static
Subnet IPv6:
SCAN 1 IPv4 VIP: 192.168.200.4
SCAN VIP is enabled.
SCAN 2 IPv4 VIP: 192.168.200.5
SCAN VIP is enabled.
*/

--Step 13.7 Modify the SCAN IPs address at network DNS layer

--Step 13.8 Modify the SCAN IPs address at network hosts layer
[root@tpdb1 ~]# vi /etc/hosts
/*
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# Public
192.168.129.208   tpdb1.unidev.org.np        tpdb1

# Private
10.10.10.208   tpdb1-priv.unidev.org.np   tpdb1-priv

# Virtual
192.168.129.209   tpdb1-vip.unidev.org.np    tpdb1-vip

# SCAN
192.168.129.210   tpdb-scan.unidev.org.np    tpdb-scan
192.168.129.211   tpdb-scan.unidev.org.np    tpdb-scan
*/

--Step 13.9 Refresh the SCAN with the new IP addresses from the DNS entry - From root user
[root@tpdb1 ~]# /opt/app/19c/grid/bin/srvctl modify scan -n tpdb-scan

--Step 13.10 Refresh the SCAN Listener with the new IP addresses from the DNS entry - From root user
[root@tpdb1 ~]# /opt/app/19c/grid/bin/srvctl modify scan_listener -u


--Step 13.11 Check whether the SCAN has been changed
[root@tpdb1 ~]# /opt/app/19c/grid/bin/srvctl config scan
/*
SCAN name: tpdb-scan, Network: 1
Subnet IPv4: 192.168.129.0/255.255.255.0/eno1, static
Subnet IPv6:
SCAN 1 IPv4 VIP: 192.168.129.210
SCAN VIP is enabled.
SCAN 2 IPv4 VIP: 192.168.129.211
SCAN VIP is enabled.
*/

--Step 13.12 Verify the configuration of SCAN
[grid@tpdb1 ~]$ srvctl config scan
/*
SCAN name: tpdb-scan, Network: 1
Subnet IPv4: 192.168.129.0/255.255.255.0/eno1, static
Subnet IPv6:
SCAN 1 IPv4 VIP: 192.168.129.210
SCAN VIP is enabled.
SCAN 2 IPv4 VIP: 192.168.129.211
SCAN VIP is enabled.
*/

--Step 13.14 Sart the SCAN
[grid@tpdb1 ~]$ srvctl start scan

--Step 13.15 Verify the status of SCAN
[grid@tpdb1 ~]$ srvctl status scan
/*
SCAN VIP scan1 is enabled
SCAN VIP scan1 is running on node tpdb1
SCAN VIP scan2 is enabled
SCAN VIP scan2 is running on node tpdb1
*/

--Step 13.16 Sart the SCAN listener
[grid@tpdb1 ~]$ srvctl start scan_listener

--Step 13.17 Verify the status of SCAN listener
[grid@tpdb1 ~]$ srvctl status scan_listener
/*
SCAN Listener LISTENER_SCAN1 is enabled
SCAN listener LISTENER_SCAN1 is running on node tpdb1
SCAN Listener LISTENER_SCAN2 is enabled
SCAN listener LISTENER_SCAN2 is running on node tpdb1
*/

--Step 13.18 Verify the configuration of SCAN Listener
[grid@tpdb1 ~]$ srvctl config scan_listener
/*
SCAN Listeners for network 1:
Registration invited nodes:
Registration invited subnets:
Endpoints: TCP:1521
SCAN Listener LISTENER_SCAN1 exists
SCAN Listener is enabled.
SCAN Listener LISTENER_SCAN2 exists
SCAN Listener is enabled.
*/

--Step 13.19 Shutdown the cluster
[root@tpdb1 ~]# cd /opt/app/19c/grid/bin/
[root@tpdb1 bin]# ./crsctl stop cluster -all

--Step 13.20 Reboot the OS
[root@tpdb1 bin]# init 6

--Step 13.21 Verify the status of DNS
[grid@tpdb1 ~]$ nslookup tpdb-scan
/*
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   tpdb-scan.unidev.org.np
Address: 192.168.129.211
Name:   tpdb-scan.unidev.org.np
Address: 192.168.129.210
*/

--Step 14 Verify the Status of RAC Cluster
--Step 14.1
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
      1        ONLINE  INTERMEDIATE tpdb1                    STABLE
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

--Step 14.2
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

--Step 14.3
[grid@tpdb1 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): tpdb1
*/

--Step 14.4
[grid@tpdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 05-JUL-2024 12:34:42

Copyright (c) 1991, 2023, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                05-JUL-2024 12:33:26
Uptime                    0 days 0 hr. 1 min. 15 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/tpdb1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.129.208)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.129.209)(PORT=1521)))
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

--Step 14.5
[grid@tpdb1 ~]$ ps -ef | grep SCAN
/*
grid        7762       1  0 12:33 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid        7767       1  0 12:33 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid       20082   17571  0 12:35 pts/0    00:00:00 grep --color=auto SCAN
*/

--Step 14.6
[grid@tpdb1 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 05-JUL-2024 12:35:35

Copyright (c) 1991, 2023, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                05-JUL-2024 12:33:28
Uptime                    0 days 0 hr. 2 min. 7 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/tpdb1/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.129.210)(PORT=1521)))
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

--Step 14.7
[grid@tpdb1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 05-JUL-2024 12:35:50

Copyright (c) 1991, 2023, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                05-JUL-2024 12:33:28
Uptime                    0 days 0 hr. 2 min. 22 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/tpdb1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.129.211)(PORT=1521)))
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

--Step 14.8
[oracle@tpdb1 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): tpdb1
*/
--Step 14.9
[oracle@tpdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 05-JUL-2024 12:36:17

Copyright (c) 1991, 2023, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                05-JUL-2024 12:33:26
Uptime                    0 days 0 hr. 2 min. 50 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/tpdb1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.129.208)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.129.209)(PORT=1521)))
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

--Step 14.10
[oracle@tpdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node tpdb1. Instance status: Open.
*/