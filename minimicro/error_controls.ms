print
_printMark "Press `r` to reattempt the request, or `b` to go back to your last"+char(10)+"page..."
while true
    while not key.available; yield; end while
    k = key.get
    if k=="r" then run "startup" // reload
    if k=="b" then run "back" // go back
    if k.code==27 then exit // escape
end while