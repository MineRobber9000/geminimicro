if history.len==0 then
    globals.remove "URL" // go back to homepage
else
    globals.URL = history.pop
end if
run "startup"