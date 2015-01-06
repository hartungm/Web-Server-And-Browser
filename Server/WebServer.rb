require 'socket'

class WebServer

	SERVER_ROOT_DIRECTORY = "./public"

	CONTENT_TYPE = {
		'html' => 'text/html',
		'txt'  => 'text/plain',
		'png'  => 'image/png',
		'jpg'  => 'image/jpeg',
		'css'  => 'text/css'
	}

	server = TCPServer.new('localhost', 8080)

	loop do
		Thread.start(server.accept) do |client|
			request = client.gets
			puts request
			request_array = request.split(" ")

			# Send 'Bad Request' if Request Header isn't GET or if the Protocol isnt HTTP/1.1
			if request_array[0] === "GET" && request_array[2] === "HTTP/1.1"
				path = request_array[1]
				path = File.join(SERVER_ROOT_DIRECTORY, path)

				# If the path is to a directory, append index.html to the end of the path
				path = File.join(path, 'index.html') if File.directory?(path)

				# output edited path to console, used for debugging
				puts path

				# Make sure file exists, if it doesn't send a 404 error
				if File.exist?(path)
					extension = path.split(".").last
					File.open(path, "rb") do |file|
						client.print "HTTP/1.1 200 OK\r\n" +
									 "Content-Type: #{CONTENT_TYPE.fetch(extension.downcase)}\r\n" +
									 "Content-Length: #{file.size}\r\n" +
									 "Connection: Keep-Alive\r\n"

						client.print "\r\n"

			      		# write the contents of the file to the client 
			      		IO.copy_stream(file, client)
			      	end
		      	else
		      		message = "404 File Not Found"
		      		client.print "HTTP/1.1 404 Not Found\r\n" +
		                 		 "Content-Type: text/plain\r\n" +
		                 		 "Content-Length: #{message.size}\r\n" +
		                 		 "Connection: close\r\n"
		            
		            client.print "\r\n"
		            client.print message
				end
			else
				client.print "Bad Request"
			end
			client.close
		end
	end
end

WebServer.new