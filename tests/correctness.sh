#!/bin/bash
srcdir="$(dirname "$0")"
logdir=$srcdir/logs
mkdir -p $logdir
BATCH_SIZE=200

echo "Starting server"
{ $srcdir/scripts/launch.sh -r server -p 15744 -t 13 > $logdir/server.log 2>&1; } &
sleep 2
echo "Starting client1"
{ $srcdir/scripts/launch.sh -r client -t 10 -n $BATCH_SIZE > $logdir/client1.log 2>&1; } &
wait
echo "All jobs done!"
# sleep 2
# $srcdir/scripts/launch.sh -r client -n 100 -d 10000 -t 10 &