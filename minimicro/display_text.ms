if not globals.hasIndex("stringUtil") then import "stringUtil"
if not globals.hasIndex("textUtil") then import "textUtil"
if not globals.hasIndex("textparser") then import "textparser"

clear
utils.footer response.canonical[:66]
text.column = 0
text.row = 25

rawlines = file.readLines("body")
actions = new utils.actions
links = {}

parser = new textparser.TextParser
if meta[:11]=="text/gemini" then
    parser = new textparser.GemTextParser
    parser.handle_link_line = function(n, link)
        outer.links[n+""]=utils.joinURL(response.canonical, link)
        if n<11 then
            if n==10 then n=0
            outer.actions[n+""] = function
                history.push
                globals.URL = utils.joinURL(URL, link)
                globals.remove "resolveURL"
                run "startup"
            end function
        end if
    end function
    resolveURL = function(inp)
        if links.hasIndex(inp) then return links[inp]
        parsed = utils.parseUrl(inp)
        if parsed.protocol!="" then return inp
        return null
    end function
end if

bodylines = []
for line in rawlines
    bodylines += parser.parse_line(line)
end for

idx = 0
max_idx = bodylines.len - 25

draw = function
    textUtil.clearRect 0, 1, 68, 25
    text.column = 0
    text.row = 25
    row = 0
    while text.row>0 and (idx+row)<bodylines.len
        print bodylines[idx+row][:67]
        row+=1
    end while
end function

draw

actions[char(19)] = function // up
    if idx>0 then
        outer.idx-=1
        draw
    end if
end function

actions[char(20)] = function // down
    if idx<max_idx then
        outer.idx+=1
        draw
    end if
end function
actions[char(10)] = @actions[char(20)] // return does same as down

actions.q = function // page up (minimicro doesn't seem to let me actually do page up)
    outer.idx -= 25
    if idx<0 then outer.idx=0
    draw
end function

actions.a = function // page down (ditto)
    outer.idx += 25
    if idx>max_idx then outer.idx=max_idx
    draw
end function

actions[" "] = function // do something *like* the default actions but not quite, allows the use of escape here
    globals.input_allow_escape = true
    import "input_url"
    globals.remove "input_allow_escape"
    utils.footer response.canonical[:66] // restore footer
end function

actions.b = function // bookmark
    if response.canonical.indexOf("chrome://bookmarks/")==0 then
        utils.footer "Yo, dawg..."
        wait 3
        utils.footer response.canonical[:66]
        return
    end if
    bookmarks_path = utils.PREFIX+"/chrome/homepage/bookmarks.gmi"
    bookmarks = file.readLines(bookmarks_path)
    for bookmark in bookmarks
        parts = bookmark.split(" ")
        if len(parts)>=2 and parts[1]==response.canonical then
            utils.footer "This page is already bookmarked..."
            wait 3
            utils.footer response.canonical[:66]
            return
        end if
    end for
    bookmarks.push "=> "+response.canonical+" "+response.canonical
    file.writeLines bookmarks_path, bookmarks
    utils.footer "Added bookmark!"
    wait 3
    utils.footer response.canonical[:66]
end function

actions.runActions