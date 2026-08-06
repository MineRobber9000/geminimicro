if not globals.hasIndex("utils") then import "utils"
if not globals.hasIndex("URL") then globals.URL = "chrome://homepage/"
if not globals.hasIndex("history") then import "history"
if not globals.hasIndex("forwards") then forwards=[]

globals.remove "_dont_save_body"
utils.footer ("Loading "+URL+"...")[:66]
response = utils.request(URL)
if response==null then
    response={"header": "43 Proxy down","body": (new RawData),"canonical": URL}
    parsed = utils.parseUrl(URL)
    if parsed.protocol!="gemini" then
        response.header = "4x nongemini"
    end if
end if
status_code = response.header[:2]
meta = response.header[3:]
if response.body.len>0 then file.saveRaw "body", response.body

run "handle_"+status_code[0]