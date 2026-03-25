utils.header "Slow Down"

print "The server has requested that we slow down; that is to say, we have made too many requests too quickly."
if meta!="" then
    print ""
    print "Specifically, the server says:", " "
    print meta
end if

if (not globals.hasIndex("slowdowninfo")) or slowdowninfo.url!=URL then
    globals.slowdowninfo = {"url": URL, "wait": 1}
else if globals.hasIndex("slowdowninfo") then
    slowdowninfo.current *= 2
end if

print
_printMark "Press `b` to go back, otherwise, please wait..."
t1 = time
while true
    while (not key.available) and (time-t1)<slowdowninfo.current
        yield
    end while
    if (time-t1)>=slowdowninfo.current then run "startup"
    k = key.get
    if k=="b" then run "back"
    if k.code==27 then exit // escape
end while