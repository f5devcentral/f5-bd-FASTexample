#!/bin/bash
## This EAV Looks for windows service status of the the CAS POP service.
## This is completed using SNMP.  Please make sure SNMP is enabled on
## each server in the pool.
## The EAV requires that 'PASSWORD' be defined as a user variable that needs
## to be supplied within the LTM Monitor. The password is the community string.

# Remove IPv6/IPv4 compatibility prefix (LTM passes addresses in IPv6 format)
NODE=`echo ${1} | sed 's/::ffff://'`
if [[ $NODE =~ ^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}$ ]]; then
NODE=${NODE}
else
NODE=[${NODE}]
fi

query1=$(/usr/bin/snmpget -m '' -v 2c -c "${PASSWORD}" $NODE 1.3.6.1.4.1.77.1.2.3.1.1.23.77.105.99.114.111.115.111.102.116.32.69.120.99.104.97.110.103.101.32.80.79.80.51)

if [[ "$query1" == *"Microsoft Exchange POP3"* ]]
then
    echo "POP Service is Up!"
fi