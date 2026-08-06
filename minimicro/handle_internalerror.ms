errors = {"nongemini": ["Non-Gemini Link", "Links to non-Gemini resources are outside the scope of this"+char(10)+"project.", true]}

error = ["missingno", "no specification for error "+meta, false]
if errors.hasIndex(meta) then error=errors[meta]

utils.header error[0]

print error[1]

utils.footer response.canonical

if error[2] then
    print
    _printMark "Press `b` to go back, or space to navigate to a new URL."
    current_url = URL
    actions = new utils.actions
    actions.r = null
    actions.runActions
else
    run "error_controls"
end if