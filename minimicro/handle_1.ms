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
_input_display = ""
submit = false

addChar = function(c)
    outer._input += c
    if status_code=="11" then
        outer._input_display += "*"
    else
        outer._input_display += c
    end if
end function

delChar = function
    outer._input = _input[:-1]
    outer._input_display = _input_display[:-1]
end function

while true
    textUtil.clearRow row
    text.column = 0
    text.row = row
    text.print "> "+_input_display[:65], ""
    k=key.get
    if chars.allPrintable.indexOf(k)!=null then addChar(k)
    if k==chars.backup then delChar
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
globals.remove "addChar"
globals.remove "delChar"
if submit then
    parsed = utils.parseUrl(URL)
    if _input!="" then
        parsed.query = _input.urlEncode
    else
        parsed.query = ""
    end if
    globals.remove "_input"
    URL = utils.unparseURL(parsed)
    run "startup"
end if
globals.remove "_input"