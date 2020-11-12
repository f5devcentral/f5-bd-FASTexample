#!/bin/sh
# These arguments supplied automatically for all external monitors:
# $1 = IP (nnn.nnn.nnn.nnn notation)
# $2 = port (decimal, host byte order)
#
# This script expects the following Name/Value pairs:
#  USER  = the username associated with a mailbox
#  PASSWORD = the password for the user account
#  DOMAIN = the Windows domain in which the account lives
#
# Remove IPv6/IPv4 compatibility prefix (LTM passes addresses in IPv6 format)

NODE=`echo ${1} | sed 's/::ffff://'`
if [[ $NODE =~ ^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}$ ]]; then
    # node is v4
    NODE=${NODE}
else
    # node is v6
    NODE=[${NODE}]
fi
PORT=995
PIDFILE="/var/run/`basename ${0}`.my_new_iapp_test_2010_${USER}_${NODE}_ad.pid"
RECV='successfully logged on'

# kill of the last instance of this monitor if hung and log current pid
if [ -f $PIDFILE ]
then
   echo "EAV exceeded runtime needed to kill ${NODE}:${PORT}" | logger -p local0.error
   kill -9 `cat $PIDFILE` > /dev/null 2>&1
fi
echo "$$" > $PIDFILE
/usr/bin/curl-apd -k -v -u ${DOMAIN}\\${USER}:${PASSWORD} pop3s://${NODE}:${PORT} 2>&1 | grep "${RECV}" > /dev/null
STATUS=$?
rm -f $PIDFILE
if [ $STATUS -eq 0 ]
then
    echo "UP"
fi
exit
