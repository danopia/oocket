import socket

sock := Socket connect("174.137.57.117", 6667)

sock send("NICK asdf\nUSER a s d f\nJOIN #offtopic\n")

buffer: String

while (true) {
  buffer = sock recv(255)
  buffer println()
}
