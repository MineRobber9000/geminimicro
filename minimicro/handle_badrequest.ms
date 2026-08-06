utils.header "Bad Request"

print "The remote server has rejected our request as malformed."
if meta!="" then
    print ""
    print "Specifically, the server says:", " "
    print meta
end if

utils.footer response.canonical

run "error_controls"