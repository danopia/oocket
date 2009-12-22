import socket

sock := Socket new()

sock connect("174.137.57.117", 6667)

sock io write("NICK asdf\nUSER a s d f\nJOIN #offtopic\n")

while (true) {
  buffer: String // if I use := it won't work
  buffer = sock io read(255)
  buffer println()
}
