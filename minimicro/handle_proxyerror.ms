utils.header "Proxy Error"

print "An error occurred in the proxy when handling your request. Retrying at a later time may result in success."
if meta!="" then
    print ""
    print "Specifically, the server says:", " "
    print meta
end if

utils.footer response.canonical

run "error_controls"