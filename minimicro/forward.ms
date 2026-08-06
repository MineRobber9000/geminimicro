if forwards.len>0 then
    history.push
    entry = forwards.pop
    response = {"header": entry.header, "body": entry.body, "canonical": entry.url}
    URL = entry.url
end if
status_code = response.header[:2]
meta = response.header[3:]
if response.body.len>0 then file.saveRaw "body", response.body
run "handle_"+status_code[0]