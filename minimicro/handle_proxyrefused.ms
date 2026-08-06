utils.header "Huh?"

print "The remote server has apparently convinced itself we are trying to"
print "use it as a proxy."
if meta!="" then
    print ""
    print "Specifically, the server says:", " "
    print meta
end if

utils.footer response.canonical

run "error_controls"