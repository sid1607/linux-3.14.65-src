#!/bin/bash
srcdir="$(dirname "$0")"
logdir=$srcdir/logs
mkdir -p $logdir
BATCH_SIZE=650000

echo "Starting server"
{ $srcdir/scripts/launch.sh -r server -p 15744 -a 0.0.0.0 -t 150; } &
#sleep 2
#echo "Starting client"
#{ $srcdir/scripts/launch.sh -r client -t 20 -n $BATCH_SIZE -a 172.16.141.1  > $logdir/client1.log 2>&1; } &
wait
echo "All jobs done!"
# sleep 2
# $srcdir/scripts/launch.sh -r client -n 100 -d 10000 -t 10 &
