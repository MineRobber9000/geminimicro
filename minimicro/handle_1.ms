if not globals.hasIndex("chars") then import "chars"
utils.header "Input Requested"
utils.footer response.canonical

print meta
print

savedstate = {}
savedstate.color = text.color
savedstate.backColor = text.backColor
row = text.row

text.backColor = "#333333"
text.color = "#ffffff"

_input = ""
submit = false

while true
    textUtil.clearRow row
    text.column = 0
    text.row = row
    text.print "> "+_input[:65], ""
    k=key.get
    if chars.allPrintable.indexOf(k)!=null then _input += k
    if k==chars.backup then _input = _input[:-1]
    if k==chars.returnKey then
        submit = true
        break
    end if
    if k.code==27 then break
end while

text.backColor = savedstate.backColor
text.color = savedstate.color
globals.remove "savedstate"
globals.remove "row"
if submit then
    parsed = utils.parseUrl(URL)
    parsed.query = _input
    globals.remove "_input"
    URL = utils.unparseURL(parsed)
    run "startup"
end if
globals.remove "_input"