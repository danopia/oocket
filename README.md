oocket: socket library for ooc
==============================

oocket is a simple library for ooc that allows you to use linux sockets.
For now, only clients are allowed and there are no hostname lookup
mechanizisms.

Get ooc from http://github.com/nddrylliog/ooc

oocket works by opening a socket, connecting it, and giving the caller
an instance of the built-in FileDescriptor class. FileDescriptor's
methods are read() and write(). See sdk/os/FileDescriptor in ooc for
more information on that.

Example
-------
(see also example.ooc)

	import socket
	sock := Socket new()

	sock connect("174.137.57.117", 6667)

	sock io write("NICK asdf\nUSER a s d f\nJOIN #offtopic\n")

	buffer: String
	buffer = sock io read(255)
	buffer println()

Todo
----
1. Handle DNS
2. Allow serving connections
3. Closing sockets
4. Non-blocking reads and writes
