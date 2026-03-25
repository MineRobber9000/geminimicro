if meta[:6]=="image/" then
    print URL
    view "body"
end if
if meta[:5]=="text/" then
    // TODO: implement gemtext support
    pageThrough file.readLines("body")
end if