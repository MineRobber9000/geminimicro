history = {}
_history = []

history.len = function
    return _history.len
end function

current_url = function
    if globals.hasIndex("response") and globals.response.hasIndex("canonical") then
        return globals.response.canonical
    end if
    return URL
end function

history.getstate = function
    return {"url": current_url, "body": file.loadRaw("body"), "header": status_code+" "+meta}
end function

history.push = function
    if _history.len==0 or _history[-1].url!=current_url then
        _history.push history.getstate
    end if
    if _history.len>10 then
        _history[-11].remove "body" // don't store bodies past the last 10 links
    end if
end function

history.pop = function
    return _history.pop
end function

return history