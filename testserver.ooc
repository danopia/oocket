import socket

sock := Socket new()
sock listen(8877)

client: Socket
client_addr: SockAddr

while (true) {
"1" println()
  client = sock accept(client_addr)
"2" println()
  client sendline(client recvline())
"3" println()
  client io close()
}
