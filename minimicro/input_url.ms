prefix = "URL/Number: "
if globals.hasIndex("resolveURL") then
    locals.resolveURL = @globals.resolveURL
else
    locals.resolveURL = function(inp)
        parsed = utils.parseUrl(inp)
        if parsed.protocol!="" then return inp
        return null
    end function
    prefix = "URL: "
end if

if not locals.hasIndex("current_url") then current_url = ""

if not locals.hasIndex("chars") then import "chars"

old_footer = ""
for x in range(0,67)
    old_footer = text.cell(x,0)
end for
old_footer = old_footer.trim

while true
    utils.footer prefix + current_url[-67+prefix.len:]
    while not key.available; yield; end while
    k = key.get
    if chars.allPrintable.indexOf(k)!=null then current_url += k
    if k==chars.backup then current_url = current_url[:-1]
    if k==chars.returnKey then
        if current_url=="" then current_url = URL
        resolved_url = resolveURL(current_url)
        if resolved_url!=null then
            globals.forwards = []
            locals.remove "prefix"
            globals.remove "resolveURL"
            locals.remove "resolveURL"
            globals.remove "input_allow_escape"
            locals.remove "current_url"
            globals.history.push
            globals.URL = resolved_url
            locals.remove "resolved_url"
            run "startup"
        end if
        locals.remove "resolved_url"
    end if
    if globals.hasIndex("input_allow_escape") and k.code==27 then
        return
    end if
end while