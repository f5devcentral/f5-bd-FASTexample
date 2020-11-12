#!/bin/sh
## This EAV Looks for windows service status of 5 critical Exchange CAS services.
## This is completed using SNMP, please make sure SNMP is enabled on each server
## in the pool.
## The EAV requires that 'PASSWORD' be defined as a user variable that needs to
## be supplied within the LTM Monitor.  The password is the community string.

# Remove IPv6/IPv4 compatibility prefix (LTM passes addresses in IPv6 format)
NODE=`echo ${1} | sed 's/::ffff://'`
if [[ $NODE =~ ^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}$ ]]; then
NODE=${NODE}
else
NODE=[${NODE}]
fi

query1=$(/usr/bin/snmpget -m '' -v 2c -c "${PASSWORD}" $NODE 1.3.6.1.4.1.77.1.2.3.1.1.33.87.111.114.108.100.32.87.105.100.101.32.87.101.98.32.80.117.98.108.105.115.104.105.110.103.32.83.101.114.118.105.99.101)
query2=$(/usr/bin/snmpget -m '' -v 2c -c "${PASSWORD}" $NODE 1.3.6.1.4.1.77.1.2.3.1.1.31.77.105.99.114.111.115.111.102.116.32.69.120.99.104.97.110.103.101.32.83.101.114.118.105.99.101.32.72.111.115.116)
query3=$(/usr/bin/snmpget -m '' -v 2c -c "${PASSWORD}" $NODE 1.3.6.1.4.1.77.1.2.3.1.1.38.77.105.99.114.111.115.111.102.116.32.69.120.99.104.97.110.103.101.32.77.97.105.108.98.111.120.32.82.101.112.108.105.99.97.116.105.111.110)
query4=$(/usr/bin/snmpget -m '' -v 2c -c "${PASSWORD}" $NODE 1.3.6.1.4.1.77.1.2.3.1.1.17.73.73.83.32.65.100.109.105.110.32.83.101.114.118.105.99.101)
query5=$(/usr/bin/snmpget -m '' -v 2c -c "${PASSWORD}" $NODE 1.3.6.1.4.1.77.1.2.3.1.1.44.77.105.99.114.111.115.111.102.116.32.69.120.99.104.97.110.103.101.32.65.99.116.105.118.101.32.68.105.114.101.99.116.111.114.121.32.84.111.112.111.108.111.103.121)

if  [[ "$query1" == *"World Wide Web Publishing Service"*
    && "$query2" == *"Microsoft Exchange Service Host"*
    && "$query3" == *"Microsoft Exchange Mailbox Replication"*
    && "$query4" == *"IIS Admin Service"*
    && "$query5" == *"Microsoft Exchange Active Directory Topology"* ]]
then
    echo "All CAS Services Are Up!"
fi
