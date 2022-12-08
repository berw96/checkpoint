# Server

import socket


s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

if s:
    print("Server socket created")
    
localhost = "127.0.0.1"
hostname = ""
port = 44130

MAX_BYTES = 1024

s.bind((hostname, port))
print("Server socket binded to %s" %(port))

MAX_CONNECTIONS = 3
s.listen(MAX_CONNECTIONS)
print("Server socket is listening")

while True:
    c, addr = s.accept()
    print("Connection from ", addr)
    
    c.send(b"Thank you for connecting")
    
    print(c.recv(MAX_BYTES))
