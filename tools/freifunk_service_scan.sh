#!/bin/sh
# written by Robin Kuck
#
# requires cat, awk, sort, uniq, wc, nmap
NODES="`cat /var/run/latlon.js|awk -F"'" '{print $2}'|sort|uniq`"
NUM_NODES=`echo "$NODES"|wc -l`

I="1"
echo $NUM_NODES gefunden
for NODE in $NODES; do
echo "Scanne $NODE ($I/$NUM_NODES)"
I=`echo $I+1|bc`
nmap $NODE -PN > nmap/$NODE.nmap
done
