#!/bin/sh
# These arguments supplied automatically for all external monitors:
# $1 = IP (nnn.nnn.nnn.nnn notation)
# $2 = port (decimal, host byte order)
#
# This script expects the following Name/Value pairs:
# HOST = the host name of the SNI-enabled site
# URI  = the URI to request
# RECV = the expected response
#
# Remove IPv6/IPv4 compatibility prefix (LTM passes addresses in IPv6 format)
NODE=`echo ${1} | sed 's/::ffff://'`
if [[ $NODE =~ ^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}$ ]]; then
NODE=${NODE}
else
NODE=[${NODE}]
fi
PORT=${2}
PIDFILE="/var/run/`basename ${0}`.sni_monitor_${HOST}_${PORT}_${NODE}.pid"
if [ -f $PIDFILE ]
then
echo "EAV exceeded runtime needed to kill ${HOST}:${PORT}:${NODE}" | logger -p local0.error
kill -9 `cat $PIDFILE` > /dev/null 2>&1
fi
echo "$$" > $PIDFILE
curl-apd -k -i --resolve $HOST:$PORT:$NODE https://$HOST$URI | grep -i "${RECV}" > /dev/null 2>&1
STATUS=$?
rm -f $PIDFILE
if [ $STATUS -eq 0 ]
then
echo "UP"
fi
exit
     