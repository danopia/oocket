include stdio
include sys/types
include sys/socket
include arpa/inet
include netdb

import os/FileDescriptor

InAddr: cover from struct in_addr {
    s_addr: extern ULong // load with inet_aton()
}

SockAddr: cover from struct sockaddr {
    sa_family: extern UShort    // address family, AF_xxx
    sa_data: extern Char[14]  // 14 bytes of protocol address
}

SockAddrIn: cover from struct sockaddr_in {
    sin_family: extern Short   // e.g. AF_INET
    sin_port: extern UShort     // e.g. htons(3490)
    sin_addr: extern InAddr     // see struct in_addr, below
    sin_zero: extern Char[8]  // zero this if you want to
}

HostEntry: cover from struct hostent {
  h_name: extern String // official name of the host
  h_aliases: extern String* // alt names
  h_addr_type: extern Int // host type; AF_INET or AF_INET6 (IPv6)
  h_length: extern Int // length in bytes of each address
  h_addr_list: extern String* // list of addresses for the host
  h_addr: extern String // the first address from addr_list
}

AF_INET: extern Int
SOCK_STREAM: extern Int

socket: extern func (family, type, protocol: Int) -> Int

gethostbyname: extern func (name: String) -> HostEntry

htonl: extern func (hostlong: UInt32) -> UInt32
htons: extern func (hostshort: UInt16) -> UInt16
ntohl: extern func (netlong: UInt32) -> UInt32
ntohs: extern func (netshort: UInt16) -> UInt16

connect: extern func (socket: Int, address: SockAddr*, protocol: Int) -> Int

inet_addr: extern func (ip: String) -> ULong

Socket: class {
  descriptor: Int
  io: FileDescriptor
  
  init: func() {
    this descriptor = socket(AF_INET, SOCK_STREAM, 0)
    this io = this descriptor
  }
  
  /*connect: static func~classmethod (ip: String, port: Int) -> This {
    sock := This new()
    sock connect(ip, port)
    sock
  }*/
  
  connect: func(ip: String, port: Int) -> Bool {
    serv_addr: SockAddrIn

    //server := gethostbyname(hostname) as HostEntry*
    //if (server == null) {
    //    "ERROR, no such host" println()
    //    exit(0)
    //}

    memset(serv_addr&, 0, sizeof(serv_addr))
    serv_addr sin_family = AF_INET
    serv_addr sin_addr s_addr = inet_addr(ip) //server h_addr
    serv_addr sin_port = htons(port)
    
    connect(this descriptor, serv_addr& as SockAddr*, sizeof(serv_addr)) == 0
  }
  
  recv: func(maxlen: Int) -> String {
    return io read(maxlen)
  }
  
  send: func(data: String) -> Int {
    return io write(data, data length())
  }
}

LineSocket: class extends Socket {
  buffer := ""
  terminator := '\n'
  
  sendline: func(data: String) -> Int {
    send(data + terminator)
  }
  
  recvline: func() -> String {
    while (!( buffer contains(terminator) )) {
      buffer = buffer append(recv(1024 - buffer length()))
    }
    
    data := buffer substring(0, buffer indexOf(terminator))
    buffer = buffer substring(data length() + 1)
    return data
  }
}

