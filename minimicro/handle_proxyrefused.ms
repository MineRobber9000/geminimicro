utils.header "Huh?"

print "The remote server has apparently convinced itself we are trying to use it as a proxy."
if meta!="" then
    print ""
    print "Specifically, the server says:", " "
    print meta
end if

run "error_controls"