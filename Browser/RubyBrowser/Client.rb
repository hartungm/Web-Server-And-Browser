require 'socket'
include Socket::Constants

class Client 

	# Establish a connection with server at specified url (initialize the socket)
	def initialize
		@@socket = Socket.new( AF_INET, SOCK_STREAM, 0 )
	end

	# grab text or binary information from the file path
	def getFile(portNum, url)
		socket_address = Socket.pack_sockaddr_in(portNum, url)
		@@socket.connect(socket_address)
		@@socket.write( "GET / HTTP/1.1\r\n\r\n" )
		results = @@socket.read
		puts results
	end

	def destroy
		@@socket.close
	end
end

client = Client.new
client.getFile(80, 'www.google.com')