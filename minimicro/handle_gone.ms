utils.header "Gone"

print "The file you were looking for does not and will not exist on the remote server."
if meta!="" then
    print ""
    print "Specifically, the server says:", " "
    print meta
end if

run "error_controls"