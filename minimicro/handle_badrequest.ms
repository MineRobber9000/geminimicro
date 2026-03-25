utils.header "Bad Request"

print "The remote server has rejected our request as malformed."
if meta!="" then
    print ""
    print "Specifically, the server says:", " "
    print meta
end if

run "error_controls"