import "chrome_utils"

this = new chrome_utils.Dispatcher

this.add_static_route("/", "This is a test of the chrome:// protocol. It should Just Work(tm)."+char(10)+char(10)+"=> gemini://geminiprotocol.net Example of a link leaving a chrome page"+char(10)+"=> input Input test")

this.routes["/input"] = function(query, canonical)
    if query==null then
        return chrome_utils.generate_response("10 Say something:",null,canonical)
    end if
    return chrome_utils.generate_response("20 text/gemini","You said: "+query.urlDecode, canonical)
end function

return this