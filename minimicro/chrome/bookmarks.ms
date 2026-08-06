import "chrome_utils"

this = new chrome_utils.Dispatcher

bookmarks_path = utils.PREFIX+"/chrome/homepage/bookmarks.gmi"
bookmarks = file.readLines(bookmarks_path)
this.routes["/"] = function(query, canonical)
    if query!=null then
        canonical = canonical[:canonical.lastIndexOf("?")]
    end if
    body = "# Bookmarks"+char(10)+char(10)+"Press `b` to bookmark a page."+char(10)+char(10)
    for bookmark in bookmarks
        body += bookmark + char(10)
    end for
    body += char(10)+"=> delete Delete bookmarks"
    body += char(10)+"=> rename Rename bookmarks"
    body += char(10)+"=> //homepage/ Back to homepage"
    return chrome_utils.generate_response("20 text/gemini", body, canonical)
end function

this.routes["/delete"] = function(query, canonical)
    if query!=null then
        bookmarks.remove query.val
        file.writeLines bookmarks_path, bookmarks
        canonical = canonical[:canonical.lastIndexOf("?")]
    end if
    body = "# Delete bookmark"+char(10)+char(10)
    for i in range(0, bookmarks.len-1)
        bookmark = bookmarks[i]
        text = bookmark.split(" ")[2:].join(" ")
        body += "=> delete?"+i+" "+text+char(10)
    end for
    body += char(10)+"=> . Go back"
    return chrome_utils.generate_response("20 text/gemini", body, canonical)
end function

this.routes["/rename"] = function(query, canonical)
    if query!=null then
        if globals.hasIndex("_bookmarks_index") then
            if query!="" then
                parts = bookmarks[_bookmarks_index].split(" ")[:2]
                bookmarks[_bookmarks_index] = parts.join(" ")+" "+query.urlDecode
                file.writeLines bookmarks_path, bookmarks
            end if
            globals.remove("_bookmarks_index")
        else
            idx = query.val
            if idx<0 or idx>=bookmarks.len then
                return chrome_utils.generate_response("51 No such bookmark",null)
            else
                globals._bookmarks_index = idx
                return chrome_utils.generate_response("10 Enter new name for bookmark",null)
            end if
        end if
    end if
    body = "# Rename bookmark"+char(10)+char(10)
    for i in range(0, bookmarks.len-1)
        bookmark = bookmarks[i]
        text = bookmark.split(" ")[2:].join(" ")
        body += "=> rename?"+i+" "+text+char(10)
    end for
    body += char(10)+"=> . Go back"
    return chrome_utils.generate_response("20 text/gemini", body, canonical)
end function

this.route = function(path, query, canonical)
    globals._dont_save_body = true // don't cache bookmarks in history
    return super.route(path, query, canonical)
end function

return this