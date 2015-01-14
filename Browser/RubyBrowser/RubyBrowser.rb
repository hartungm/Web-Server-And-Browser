require 'socket'
require './Client.rb'

Shoes.app(title: "RubyBrowser", width: 600, height: 400) do
    stack margin: 10 do #double check Shoes docs, make sure we need stack
        flow do
            @address_bar = edit_line width: 500
            @go_button = button "GO"
            @go_button.click do
                para 'Made it here'
                @client = Client.new('localhost', 8080)
                para 'Instantiated'
                para @client.getFile('/')
            end
            #can put necessary UI elements here...
        end
        #or here, outside the flow...
    end
    #or here, outside the stack in a different stack/flow
end
