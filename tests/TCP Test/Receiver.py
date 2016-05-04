#!/usr/bin/python

import socket

addr = "0.0.0.0"
port = 4321


def main():
    fd = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    fd.bind((addr, port))
    fd.listen(1)
    print("Started listening on port " + str(port) + ".")
    while True:
        conn, clientAddr = fd.accept()

        while True:
            data = conn.recv(32)
            if not data:
                    break
            # conn.send(data)
            print("Received 32 bytes.")

        conn.close()

if __name__ == "__main__":
    main()
