if not globals.hasIndex("utils") then import "utils"
if not globals.hasIndex("URL") then globals.URL = "gemini://tilde.team/~khuxkm/tests"
if not globals.hasIndex("history") then globals.history = []

response = utils.request(URL)
if response==null then response={"header": "43 Proxy down","body": (new RawData),"canonical": URL}
status_code = response.header[:2]
meta = response.header[3:]
if response.body.len>0 then file.saveRaw "body", response.body

run "handle_"+status_code[0]