if status_code=="51" then run "handle_notfound"
if status_code=="52" then run "handle_gone"
if status_code=="53" then run "handle_proxyrefused"
if status_code=="59" then run "handle_badrequest"

utils.header "Permanent failure"

print "The server ran into an unspecified permanent failure. Retrying at a later time is unlikely to result in success."
if meta!="" then
    print ""
    print "Specifically, the server says:", " "
    print meta
end if

utils.footer response.canonical

run "error_controls"