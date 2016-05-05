#!/usr/bin/python

import socket
import getopt
import sys

addr = "localhost"
port = -1


def main(argv):
    global addr, port
    try:
        opts, args = getopt.getopt(argv[1:], "ha:p:", ["addr=", "port="])
    except getopt.GetoptError:
        print(argv[0] + ' -a <listen_addr> -p <listen_port>')
        sys.exit(2)

    # Read arguments
    for opt, arg in opts:
        if opt == '-h':
            print(argv[0] + ' -a <listen_addr> -p <listen_port>')
            sys.exit()
        elif opt in ("-a", "--addr"):
            addr = str(arg)
        elif opt in ("-p", "--port"):
            port = int(arg)

    if port == -1:
        print('Usage: ' + argv[0] + ' -a <listen_addr> -p <listen_port>')
        sys.exit(1)
       
    fd = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    fd.bind((addr, port))
    fd.listen(1)
    print("Started listening on port " + str(port) + ".")
    while True:
        conn, clientAddr = fd.accept()
        start = time.time()
        recv_size = 0
        while True:
            data = conn.recv(4096)
            if not data:
                    break
            recv_size += len(data)

        print("Received "+ str(redv_size)+ " bytes.")
        end = time.time()
        print('Batch received in ' + str(end-start) + ' seconds.')
        conn.send('ack'.encode())
        conn.close()

if __name__ == "__main__":
    main(sys.argv)
