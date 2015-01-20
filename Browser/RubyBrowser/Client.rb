require 'socket'

class Client
	# Establish a connection with server at specified url (initialize the socket)
	def initialize(url, portNum)
		@@socket = TCPSocket.new(url, portNum)
		@@url = url
		@@portNum = portNum
	end

	# grab text or binary information from the file path
	def getFile(filePath)
		@@socket.write("GET " + filePath + " HTTP/1.1\r\n\r\n")
		lines = ""
		while line = @@socket.gets
			lines = lines + line
		end
		return lines
	end

	def getImagePath(filePath)
		return @@url + ":" + @@portNum + "/" + filePath
	end

	# Close the Socket 
	def destroy
		@@socket.close
	end
	
end

#client = Client.new('localhost', 8080)
#client.getFile('/')
#client.destroy
