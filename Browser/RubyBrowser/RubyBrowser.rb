require 'socket'
require './Client.rb'
require './StringExt.rb'

Shoes.app(title: "RubyBrowser", width: 600, height: 400) do
    stack margin: 10 do #double check Shoes docs, make sure we need stack
        flow do
            @address_bar = edit_line width: 500
            @go_button = button "GO"
            @go_button.click do
                url = @address_bar.text #pull url string from address bar
                @client = Client.new('localhost', 8080)
                @data = @client.getFile('/MyMarkupTest.txt')
                data_string = @data.slice("\r\n"); #Not sure if this is the correct newline character or not
                data_string.each_with_index do |line, index| #parse through the text pulled from the url 

                    if line.include? "*"
                        para line, weight: "bold"
                    elsif line.include? "_"
                        para line, underline: "single"
                    elsif line.include? "[["
                    elsif line.include? "<<"
                    else #print the line normally if there are no special characters
                        para line
                    end
                
                end
            end
            #can put necessary UI elements here...
        end
        #or here, outside the flow...
    end
    #or here, outside the stack in a different stack/flow
end
