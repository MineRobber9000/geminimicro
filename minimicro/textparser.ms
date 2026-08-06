// Turns a text file into wrapped lines and, if requested, parses gemtext
if not globals.hasIndex("stringUtil") then import "stringUtil"
if not globals.hasIndex("unidecode") then import "unidecode"
WIDTH = 67

TextParser = {}

TextParser.parse_line = function(line)
    return self.massage_line(line).wrap(WIDTH)
end function

TextParser.massage_line = function(line)
    return unidecode.unidecode(line)
end function

GemTextParser = new TextParser
GemTextParser.n = 1
GemTextParser.pre = false

GemTextParser.parse_line = function(line)
    if self.pre then
        if line[:3]=="```" then
            self.pre = false
            return []
        else
            return [line]
        end if
    else
        if line[:2]=="=>" and (line[2]==" " or line[3]==stringUtil.TAB) then // link line
            n = self.n
            self.n+=1
            idx = 2
            link = null
            text = null
            while idx<line.len
                if stringUtil.whitespace.indexOf(line[idx])!=null then
                    idx+=1
                else if link==null then
                    idx_start = idx
                    while idx<line.len and stringUtil.whitespace.indexOf(line[idx])==null
                        idx+=1
                    end while
                    link = line[idx_start:idx].trim
                else if text==null then
                    text = line[idx:]
                    idx=line.len
                end if
            end while
            if text==null then text=link
            line = "["+n+"] "+text
            self.handle_link_line n, link
            return self.massage_line(line).wrap(WIDTH)
        else if line[:3]=="```" then // pre-formatted toggle
            self.pre = true
            return []
        else if line.len>0 and line[0]==">" then
            wrapped = self.massage_line(line)[1:].trimLeft.wrap(WIDTH-2)
            for i in range(0,wrapped.len-1)
                wrapped[i] = "> "+wrapped[i]
            end for
            return wrapped
        else
            return self.massage_line(line).wrap(WIDTH)
        end if
    end if
    return ["something went wrong"]
end function

GemTextParser.handle_link_line = function(n, link); end function