// cf. https://miniscript.org/wiki/RawData#Converting_a_string_to_RawData
string_to_rawdata = function(s)
    retval = new RawData
    retval.resize s.len*4
    retval.resize retval.setUtf8(0, s)
    return retval
end function

generate_response = function(header, body, canonical=null)
    if body == null then body = new RawData
    if body isa string then body = string_to_rawdata(body)
    return {"header": header, "body": body, "canonical": canonical}
end function

Dispatcher = {}
Dispatcher.routes = {}

Dispatcher.route = function(path, query, url)
    if self.routes.hasIndex(path) then
        route = @self.routes[path]
        retval = route(query, url)
        if retval.canonical==null then retval.canonical=url
        return retval
    end if
    return generate_response("51 Not Found",null,url)
end function

Dispatcher.add_static_route = function(path, body, header="20 text/gemini")
    generate_response = @generate_response
    self.routes[path] = function(query, canonical)
        if query!=null then
            canonical = canonical[:canonical.lastIndexOf("?")]
        end if
        return generate_response(header, body, canonical)
    end function
end function

Dispatcher.add_file_route = function(path, filename, type="text/gemini")
    generate_response = @generate_response
    filename = file.child(utils.PREFIX+"/chrome",filename)
    self.routes[path] = function(query, canonical)
        if query!=null then
            canonical = canonical[:canonical.lastIndexOf("?")]
        end if
        if not file.exists(filename) then
            return generate_response("4x fileroutemissing",null,canonical)
        end if
        body = file.readLines(filename).join(char(10))
        return generate_response("20 "+type, body, canonical)
    end function
end function