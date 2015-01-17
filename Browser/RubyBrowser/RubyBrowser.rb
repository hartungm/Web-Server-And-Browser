require 'socket'
require './Client.rb'
require './StringExt.rb'

Shoes.app(title: "RubyBrowser", width: 600, height: 400) do
    stack margin: 10 do #double check Shoes docs, make sure we need stack
        flow do
            @address_bar = edit_line width: 500
            @go_button = button "GO"
            @go_button.click do
                @client = Client.new('localhost', 8080)
                @data = @client.getFile('/')
                data_string = data.slice("");
                data_string.each_with_index do |character, index|
                    if character.eql? "*"
                    elsif character.eql? "_"
                    elsif character.eql? "[" && data_string[index + 1].eql? "["
                    elsif character.eql? "<" && data_string[index + 1].eql? "<" 
                end
            end
            #can put necessary UI elements here...
        end
        #or here, outside the flow...
    end
    #or here, outside the stack in a different stack/flow
end
