#!/usr/bin/python

import socket
import sys
import getopt
import random
from time import sleep

# Transfer parameters
sourceAddr = "0.0.0.0"
sourcePort = random.randint(60000, 65400)  # Select random source port
packetLength = 32  # Number of bytes
packetBody = "\x00" * packetLength
socketFlagNum = 100  # SO_CROSS_LAYER_DELAY

# Sleep duration before transfer starts
sleepDuration = 2  # Seconds


def main(argv):
    destAddr = -1
    destPort = -1
    numPacketsToSend = 0
    delayToleranceInMs = 0

    # Parse argument list
    try:
        opts, args = getopt.getopt(argv[1:], "ha:p:n:d:", ["addr=", "port=", "npack=", "delay="])
    except getopt.GetoptError:
        print(argv[0] + ' -a <dest_addr> -p <dest_port> -n <num_packets> -d <delay_tolerance_ms>')
        sys.exit(2)

    # Read arguments
    for opt, arg in opts:
        if opt == '-h':
            print(argv[0] + '-a <dest_addr> -p <dest_port>')
            sys.exit()
        elif opt in ("-a", "--addr"):
            destAddr = str(arg)
        elif opt in ("-p", "--port"):
            destPort = int(arg)
        elif opt in ("-n", "--npack"):
            numPacketsToSend = int(arg)
        elif opt in ("-d", "--delay"):
            delayToleranceInMs = int(arg)

    if destAddr == -1 or destPort == -1:
        print("Usage: " + argv[0] + '-a <dest_addr> -p <dest_port>')
        sys.exit(1)
    # Start transfer
    transfer(destAddr, destPort, numPacketsToSend, delayToleranceInMs)


def transfer(destAddr, destPort, numPacketsToSend, delayToleranceInMs):
    # Create socket and connect
    fd = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    fd.bind((sourceAddr, sourcePort))  # select source port to reduce nondeterminism
    if delayToleranceInMs != 0:
        print("Delay set to " + str(delayToleranceInMs) + " ms.")
        fd.setsockopt(socket.SOL_SOCKET, socketFlagNum, delayToleranceInMs)
    fd.connect((destAddr, destPort))

    print("Transfer about to begin.")

    # Sleep for 'sleepDuration' seconds before starting
    sleep(sleepDuration)

    # Start the transfer
    for x in range(1, int(numPacketsToSend)):
        fd.send(packetBody.encode())

    fd.close()
    print("Transfer complete, sent " + str(numPacketsToSend) + " packets.")


if __name__ == "__main__":
    main(sys.argv)
