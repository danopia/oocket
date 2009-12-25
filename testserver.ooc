import socket

sock := Socket new()
sock listen(8877)

client: Socket
client_addr: SockAddr

while (true) {
  client = sock accept(client_addr)
  client sendline(client recvline())
  client io close()
}
