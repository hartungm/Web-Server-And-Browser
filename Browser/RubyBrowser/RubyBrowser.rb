Shoes.app(title: "RubyBrowser", width: 600, height: 400) do
    stack margin: 10 do
        flow do
            @address_bar = edit_line
            @go_button = button "GO"
            @go_button.click do
                #process address_bar text here
                #Shoes has built in http requests, but we cant use those
                #so here, create and submit request to server
                #then load page (content) and parse markup
            end
        end
    end
end
