utils.header "Server unavailable"

print "The server is currently unavailable, due to overload, maintenance,"
print "or some other cause. Retrying at a later time may result in success.", ""
if meta!="" then
    print ""
    print "Specifically, the server says:", " "
    print meta
end if

utils.footer response.canonical

run "error_controls"