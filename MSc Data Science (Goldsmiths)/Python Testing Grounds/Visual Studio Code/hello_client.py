# Client

import socket

s = socket.socket()

localhost = "127.0.0.1"
hostname = localhost
port = 44130

MAX_BYTES = 1024

s.connect((localhost, port))

print(s.recv(MAX_BYTES))

s.close

while True:
    print("Type a message to send: ")
    msg = input()
    s.send(bytes(msg, 'utf-8'))
    