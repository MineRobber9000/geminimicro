utils.header "Certificate Required"

print "The server wants us to use certificates; unfortunately GeMiniMicro does not support certificates."
if meta!="" then
    print ""
    print "Specifically, the server says:", " "
    print meta
end if

run "error_controls"