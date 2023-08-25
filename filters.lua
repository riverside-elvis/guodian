function do_strings (elem)
    local text = elem.text
    -- Replace characters with no font glyphs.
    if string.find(text, "") then
        text = text:gsub("", "⿸")
    end
    return pandoc.Str(text)
end

return {{Str = do_strings}}
