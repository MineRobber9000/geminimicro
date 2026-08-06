if history.len==0 then
    globals.remove "URL" // go back to homepage
    run "startup"
else
    forwards.push history.getstate
    entry = history.pop
    if not entry.hasIndex("body") then
        URL = entry.url
        run "startup"
    end if
    response = {"header": entry.header, "body": entry.body, "canonical": entry.url}
    URL = entry.url
    status_code = response.header[:2]
    meta = response.header[3:]
    if response.body.len>0 then file.saveRaw "body", response.body
    run "handle_"+status_code[0]
end if