#!/bin/bash
scripts/launch.sh -r server -p 15744 -r 20 &
sleep 2
scripts/launch.sh -r client -n 100 -d 10000 -r 10 &