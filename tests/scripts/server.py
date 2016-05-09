#!/usr/bin/python

import socket
import getopt
import sys
import time
import marshal
from threading import Thread, Lock

addr = ""
port = -1

lock = Lock()

def server_thread(new_conn):
    conn = new_conn
    total_batch_size = total_time = 0
    lock.release()
    while True:
        start = time.time()
        # receive first batch of data
        data = conn.recv(4096)
        # print(data)
        # unmarshal first 4 bytes for size
        total_size = batch_size = marshal.loads(data) + 4
        # print(str(total_size) + ' bytes to be received')
        
        while True:
            if total_size <= len(data):
                # received everything, break
                break
            total_size -= len(data)

            # load next batch
            data = conn.recv(4096)
            
        end = time.time()
        print('Batch received in ' + str(end-start) + ' seconds.')
        print('Throughput: ' + str(batch_size/((end-start)*1000000)) + ' Mbps')
        total_batch_size += batch_size
        total_time += end-start
        print('Average Throughput: ' + str(total_batch_size/(total_time*1000000)) + ' Mbps')
        conn.send('ack'.encode())
    conn.close()

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

    if port == -1 or addr == "":
        print('Usage: ' + argv[0] + ' -a <listen_addr> -p <listen_port>')
        sys.exit(1)
       
    fd = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    fd.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    fd.bind((addr, port))
    fd.listen(1)
    print("Started listening on port " + str(port) + ".")
    while True:
        conn, clientAddr = fd.accept()
        lock.acquire()
        t = Thread(target=server_thread, args=(conn,))
        t.start()        

if __name__ == "__main__":
    main(sys.argv)
