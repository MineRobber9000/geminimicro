utils.header "CGI Error"

print "An error occurred in a CGI script when handling your request. Retrying at a later time may result in success."
if meta!="" then
    print ""
    print "Specifically, the server says:", " "
    print meta
end if

run "error_controls"