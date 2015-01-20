require 'socket'
require './Client.rb'
require './StringExt.rb'

Shoes.app(title: "RubyBrowser", width: 600, height: 400) do
    stack margin: 10 do #double check Shoes docs, make sure we need stack
        flow do
            @address_bar = edit_line width: 500
            @text = nil
            @go_button = button "GO"
            @go_button.click do
                    url = @address_bar.text #pull url string from address bar
                    @client = Client.new('localhost', 8080)
                    @data = @client.getFile('/MyMarkupTest.txt')
                    header_strip = @data.split("\r\n\r\n").last
                    header_strip.gsub! "\n", " <br> "
                    @linkbit = false
                    @link = ""
                    @linkwords = ""
                    data_string = header_strip.split(" "); #Not sure if this is the correct newline character or not
                    @text = flow  do
                    data_string.each_with_index do |word, index| #parse through the text pulled from the url 
                        
                        if @linkbit === false
                            if word.include? "*"
                                word.gsub! '*', ''
                                para word, weight: "bold"
                            elsif word.include? "_"
                                word.gsub! '_', ''
                                para word, emphasis: "italic"
                            elsif word.include?( "[[") && word.include?( "]]")
                                word.gsub! "[[" ""
                                word.gsub! "]]" ""
                                para(link(word).click do
                                    #code for request
                                end)
                            elsif word.include? "[["
                                word.gsub! "[[" ""
                                @link = word
                                @linkbit = true
                            elsif word.include? "]]"
                                word.gsub! "]]" ""
                                @linkwords = @linkwords + word
                                para(link(@linkwords).click do

                                end)
                                @linkbit = false
                            elsif word.include? "<<"
                            else #print the word normally if there are no special characters
                                para word
                            end
                        else
                            if word.include? "<br>"
                                word.gsub! "<br>", ""
                                para "\n"
                            end
                            @linkwords = @linkwords + word + " "
                        end
                    end
                end
            end
            #can put necessary UI elements here...
        end
        #or here, outside the flow...
    end
    #or here, outside the stack in a different stack/flow
end
