require 'socket'
require './Client.rb'
require './StringExt.rb'

Shoes.app(title: "RubyBrowser", width: 600, height: 400) do
    stack margin: 10 do #double check Shoes docs, make sure we need stack
        flow do
            @imgpaths = [".jpg", ".jpeg", ".png", ".gif"]
            @address_bar = edit_line width: 500
            @text = nil
            @go_button = button "GO"
            @go_button.click do
                    startUrl = @address_bar.text #pull url string from address bar
                    if ["jpg", "jpeg", "png", "gif"].include? startUrl.rpartition(".").last
                        image startUrl
                        puts "image"
                    else
                        puts "not image"
                        if startUrl.include? "://" #split http:// off url
                            url = startUrl.split("://").last
                            puts url
                        end
                        if url.include? "/"
                            pos = url.index("/")
                            file = url.slice(pos..-1)
                            addr = url.slice(0..pos-1)
                            puts file
                            puts addr
                        else
                            file = "/"
                            addr = url
                        end
                        if addr.include? ":"
                            portnum = addr.split(":").last
                            addr = addr.split(":").first
                            puts portnum
                            puts addr
                        else
                            portnum = "80"
                        end
                        @client = Client.new(addr, portnum)
                        @data = @client.getFile(file,addr)
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
                                    word.gsub! "[[", ""
                                    word.gsub! "]]", ""
                                    if !word.include? ":"
                                        word = startUrl.rpartition("/").first + "/" + word
                                    end
                                    para(link(word).click do
                                       @address_bar.text = word
                                    end)
                                elsif word.include? "[["
                                    word.gsub! "[[", ""
                                    if !word.include? ":"
                                        word = startUrl.rpartition("/").first + "/" + word
                                    end
                                    @link = word
                                    @linkbit = true
                                elsif word.include?("<<") && word.include?(">>")
                                    word.gsub! "<<", ""
                                    word.gsub! ">>", ""
                                    if !word.include? ":"
                                        word = startUrl.rpartition("/").first + "/" + word
                                    end
                                    image word
                                    stack do
                                        image word
                                    end
                                else #print the word normally if there are no special characters
                                    para word
                                end
                            elsif word.include? "]]"
                                word.gsub! "]]", ""
                                @linkwords = @linkwords + word
                                para(link(@linkwords).click do
                                    @address_bar.text = @link
                                end)
                                @linkbit = false
                            else
                                @linkwords = @linkwords + word + " "
                            end
                            if word.include? "<br>"
                                word.gsub! "<br>", ""
                                para "\n"
                            end
                        end
                    end
                end
            end
        end
    end
end
