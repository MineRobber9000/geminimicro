PROXY = "http://localhost:8000/"

parseUrl = function(url)
    result = {"protocol":"", "host":"", "path":"", "query":""}
    
    // Extract protocol
    protoEnd = url.indexOf("://")
    if protoEnd >= 0 then
        result.protocol = url[:protoEnd]
        url = url[protoEnd+3:]
    end if
    
    // Extract host and path
    slashPos = url.indexOf("/")
    if slashPos < 0 then
        result.host = url
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

gemini_url_to_proxy = function(url)
    parsed = parseUrl(url)
    if parsed.protocol!="gemini" then return null
    path = parsed.path
    if parsed.query!="" then
        path=path + "?" + parsed.query
    end if
    return PROXY+parsed.host+path
end function

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