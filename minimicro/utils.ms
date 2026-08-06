if not globals.hasIndex("stringUtil") then import "stringUtil"

// URL of proxy
PROXY = "http://localhost:8000/"

// parse gemini URL into parts
parseUrl = function(url)
    result = {"protocol":"", "host":"", "path":"", "query": null}
    
    // Extract protocol
    protoEnd = url.indexOf("://")
    if protoEnd >= 0 then
        result.protocol = url[:protoEnd]
        url = url[protoEnd+3:]
    end if
    
    // Extract host and path
    slashPos = url.indexOf("/")
    if slashPos == null then
        result.host = url
        result.path = "/"
        queryPos = url.indexOf("?")
        if queryPos!=null then result.query = url[queryPos+1:]
        return result
    end if
    
    result.host = url[:slashPos]
    pathAndQuery = url[slashPos:]
    
    // Extract query string
    queryPos = pathAndQuery.indexOf("?")
    if queryPos >= 0 then
        result.path = pathAndQuery[:queryPos]
        result.query = pathAndQuery[queryPos+1:]
    else
        result.path = pathAndQuery
    end if
    
    return result
end function

// turn parts back into gemini URL
unparseURL = function(parsed)
    url = parsed.protocol+"://"+parsed.host+parsed.path
    if parsed.query!=null then
        url += "?" + parsed.query
    end if
    return url
end function

// join a relative URL to a current one
joinURL = function(url, relative)
    if relative.indexOf("//")!=null then
        if relative.indexOf("//")==0 then
            relative = "gemini:"+relative
        end if
        return relative
    end if
    parsed = parseUrl(url)
    if relative.indexOf("/")==0 then
        parsed.path = relative
        return unparseURL(parsed)
    end if
    parsed.path = file.child(parsed.path[:parsed.path.lastIndexOf("/")], relative)
    path_parts = parsed.path.split("/")
    final_path = []
    for part in path_parts
        if part=="." then
            continue
        else if part==".." and final_path.len>1 then
            final_path.pop
        else
            final_path.push part
        end if
    end for
    parsed.path = final_path.join("/")
    parsed.query = null
    return unparseURL(parsed)
end function

// convert gemini URL to proxy URL
gemini_url_to_proxy = function(url)
    parsed = parseUrl(url)
    if parsed.protocol!="gemini" then return null
    path = parsed.path
    if parsed.query!=null then
        path=path + "?" + parsed.query
    end if
    return PROXY+parsed.host+path
end function

// request gemini resource
request = function(url)
    proxy_url = gemini_url_to_proxy(url)
    if proxy_url==null then return null
    resp = http.get(proxy_url)
    if resp==null then return null
    if not (resp isa RawData) then return null
    urlLen = resp.uint(-4)
    bodyLen = resp.uint(-8)
    resp.resize resp.len-8
    header = resp.utf8(bodyLen+urlLen)
    resp.resize bodyLen+urlLen
    canonical = resp.utf8(bodyLen)
    resp.resize bodyLen
    return {"header": header, "body": resp, "canonical": canonical}
end function

// draw header (used for error pages)
header = function(contents)
    text.clear
    text.row = 25
    text.column = floor(33.5-(contents.len/2))
    text.inverse = true
    text.print contents
    text.inverse = false
    text.column = 0
    text.print
end function

// draw footer
footer = function(contents)
    savedColumn = text.column
    savedRow = text.row
    text.setCell range(0,67), 0, " "
    text.setCellBackColor range(0,67), 0, text.color
    text.column = 0
    text.row = 0
    text.inverse = true
    print contents, ""
    text.inverse = false
    text.column = savedColumn
    text.row = savedRow
end function

// import maputil if needed
if not globals.hasIndex("mapUtil") then import "mapUtil"

// do things when buttons are pressed
// used for DRY in menus and such
actions = {}
actions.runActions = function
    while true
        while not key.available
            yield
        end while
        k = key.get
        if self.hasOrInherits(k) and (@self[k])!=null then
            ret = self[k]
            if ret then return
        end if
    end while
end function

// default actions (remove by setting to null)
actions.b = function
    run "back"
end function
actions[","] = @actions.b

actions.f = function
    if forwards.len>0 then run "forward"
end function
actions["."] = @actions.f

actions.r = function
    run "startup"
end function

actions[char(27)] = function
    exit
end function

actions[" "] = function
    run "input_url"
end function