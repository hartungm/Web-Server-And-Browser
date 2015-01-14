require 'Shoes'
require 'socket'

Shoes.app(title: "RubyBrowser", width: 600, height: 400) do
    stack margin: 10 do #double check Shoes docs, make sure we need stack
        flow do
            @address_bar = edit_line width: 500
            @go_button = button "GO"
            @go_button.click do
                @trigger_request(@address_bar.text())
            end
            #can put necessary UI elements here...
        end
        #or here, outside the flow...
    end
    #or here, outside the stack in a different stack/flow
    def @trigger_request (url)
        #split url into addr, port, filePath
        socket = TCPSocket.new(addr, port)
        socket.write("GET " + filePath + " HTTP/1.1\r\n\r\n")
        while line = socket.gets
            #maybe build into string, then pass to buildPage?
        end
    end

    def @build_page (text)
        #parse through text to create page content
        #this may need to be moved...we'll play with it
    end

    def @on_link (url)
        @address_bar.text(url)
        trigger_request(url)
    end
end
