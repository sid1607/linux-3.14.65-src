#!/bin/bash
scripts/launch.sh -r server -p 15744 &
sleep 2
scripts/launch.sh -r client -n 100 -d 10000 &