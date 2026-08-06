utils.header "Certificate Required"

print "The server wants us to use certificates; unfortunately GeMiniMicro"
print "does not support certificates."
if meta!="" then
    print ""
    print "Specifically, the server says:", " "
    print meta
end if

utils.footer response.canonical

run "error_controls"