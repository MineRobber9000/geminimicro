clear
for x in range(0,67)
    text.setCellBackColor x, 0, text.color
end for
text.column = 0
text.row = 0
text.inverse = true
print response.canonical, ""
text.inverse = false
text.column = 0
text.row = 25

bodylines = file.readLines("body")
pageThrough bodylines