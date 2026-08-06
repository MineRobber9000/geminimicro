if not globals.hasIndex("utils") then import "utils"
if not globals.hasIndex("URL") then globals.URL = "gemini://geminiprotocol.net/"
if not globals.hasIndex("history") then import "history"
if not globals.hasIndex("forwards") then forwards=[]

utils.footer ("Loading "+URL+"...")[:66]
response = utils.request(URL)
if response==null then
    response={"header": "43 Proxy down","body": (new RawData),"canonical": URL}
    parsed = utils.parseUrl(URL)
    if parsed.protocol!="gemini" then
        response.header = "4x nongemini"
    end if
end if
URL = response.canonical
status_code = response.header[:2]
meta = response.header[3:]
if response.body.len>0 then file.saveRaw "body", response.body

run "handle_"+status_code[0]