if meta[:6]=="image/" then
    print URL
    view "body"
end if
if meta[:5]=="text/" then
    run "display_text"
end if