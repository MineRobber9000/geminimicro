if status_code=="41" then run "handle_serverunavailable"
if status_code=="42" then run "handle_cgierror"
if status_code=="43" then run "handle_proxyerror"
if status_code=="44" then run "handle_slowdown"
if status_code=="4x" then run "handle_internalerror"

utils.header "Temporary failure"

print "The server ran into an unspecified temporary failure. Retrying at a later time may result in success."
if meta!="" then
    print ""
    print "Specifically, the server says:", " "
    print meta
end if

utils.footer response.canonical

run "error_controls"