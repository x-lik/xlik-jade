--- 视图字符串处理方法
--- 用于处理在UI中显示字符串的显示
--- 常见的有多字节、颜色字符串处理

---@class vistring 视图字符串
vistring = vistring or {}

--- 字体数据
---@type table<string,{cr:number,zh:number,h:number}>
vistring._font = vistring._font or {}

--- 设置字体数据
--- 将自动war3mapFont字体同名lua
---@param fontName string 字体名称，对应war3mapFont
---@param cr number 非中宽度
---@param zh number 中文宽度
---@param h number 字符高度
---@return void
function vistring.setFont(fontName, cr, zh, h)
    vistring._font[fontName] = { cr = cr, zh = zh, h = h }
end

--- 获取字体数据
--- 用于字体View观感尺寸体现
---@param fontName string 字体名称，对应war3mapFont
---@return number,number,number 非中宽度,中文宽度,字符高度
function vistring.getFont(fontName)
    -- 默认数据[创粗黑]
    local cr = 0.65
    local zh = 1.03
    local h = 1.126
    local f = vistring._font[fontName]
    if (type(f) == "table") then
        cr = f.cr
        zh = f.zh
        h = f.h
    end
    return cr, zh, h
end

--- 获取多字节字符串视图长度
---@param str string
---@return number
function vistring.len(str)
    local lenInByte = #str
    local width = 0
    local i = 1
    while (i <= lenInByte) do
        local byteLen = mbstring.byteLen(str, i)
        local charLen = 1
        if (byteLen == 1) then
            if (string.sub(str, i, i + 3) == "|cff") then
                byteLen = 10
                charLen = 0
            elseif (string.sub(str, i, i + 1) == "|r") then
                byteLen = 2
                charLen = 0
            end
        end
        i = i + byteLen -- 重置下一字节的索引
        width = width + charLen -- 字符的个数（长度）
    end
    return width
end

--- 获取多字节字符串视图长度
---@param str string
---@param fontSize number 字体大小,默认10
---@param width number 一个字符占的位置
---@param widthCN number 一个汉字占的位置
---@return number
function vistring.width(str, fontSize, width, widthCN)
    if (type(str) == "number") then
        str = tostring(str)
    end
    if (type(str) ~= "string") then
        return 0
    end
    local cff = string.subCount(str, "|cff") * 12
    local l1 = string.len(str) - cff
    local l2 = mbstring.len(str) - cff
    local cn = (l1 - l2) / 2
    local xn = l2 - cn
    local cr, zh = vistring.getFont(japi.AssetsFont())
    fontSize = (fontSize or 10) * 0.001
    width = width or (fontSize * cr)
    widthCN = widthCN or (fontSize * zh)
    return xn * width + cn * widthCN
end

--- 获取字视图高度
---@param line number 行数
---@param fontSize number 字体大小,默认10
---@param height number 一个字符占的高度
---@return number
function vistring.height(line, fontSize, height)
    if (line <= 0) then
        return 0
    end
    local _, _, fh = vistring.getFont(japi.AssetsFont())
    fontSize = (fontSize or 10) * 0.001
    height = height or (fontSize * fh)
    return line * height
end

--- 多字节字符串视图式截取
---@param s string
---@param i number
---@param j number
---@return string
function vistring.sub(s, i, j)
    if (type(i) ~= "number") then
        return s
    end
    if (i < 1) then
        return ''
    end
    if (type(j) == "number") then
        if (j < i) then
            return ''
        end
    else
        j = nil
    end
    local lenInByte = #s
    if (lenInByte <= 0) then
        return ''
    end
    local count = 0
    local s1, s2 = 0, 0
    local k = 1
    local cffing = false
    local cff1st = -1
    local cffColor = nil
    while (k <= lenInByte) do
        local byteLen = mbstring.byteLen(s, k)
        local charLen = 1
        if (byteLen == 1) then
            if (string.sub(s, k, k + 3) == "|cff") then
                byteLen = 10
                charLen = 0
                cffing = true
                if (cff1st == -1) then
                    cff1st = k
                end
            elseif (string.sub(s, k, k + 1) == "|r") then
                byteLen = 2
                charLen = 0
                cffing = false
            end
        end
        count = count + charLen -- 字符的个数（长度）
        if (s1 == 0 and (i == 1 or count == i)) then
            s1 = k
            if (k > cff1st) then
                cffColor = string.sub(s, cff1st, cff1st + 9)
            end
        end
        k = k + byteLen -- 下一字节的索引
        if (s1 ~= 0) then
            if (nil == j or j >= lenInByte) then
                s2 = lenInByte
                break
            elseif (j == count) then
                s2 = k - 1
                break
            end
        end
    end
    local sr = string.sub(s, s1, s2)
    if (nil ~= cffColor) then
        sr = cffColor .. sr
    end
    if (cffing) then
        sr = sr .. "|r"
    end
    return sr
end

--- 视图式分隔多字节字符串
---@param str string
---@param size number 每隔[size]个字切一次
---@return string[]
function vistring.split(str, size)
    local sp = {}
    local lenInByte = #str
    if (lenInByte <= 0) then
        return sp
    end
    size = size or 1
    local count = 0
    local i0 = 1
    local i = 1
    local cffColor = nil
    local cffColorS = nil
    local cffTailing = false
    local subStr = {}
    while (i <= lenInByte) do
        local byteLen = mbstring.byteLen(str, i)
        local charLen = 1
        if (byteLen == 1) then
            if (string.sub(str, i, i + 3) == "|cff") then
                byteLen = 10
                charLen = 0
                cffColorS = string.sub(str, i, i + 9)
                cffColor = cffColorS
                i0 = i0 + 10
            elseif (string.sub(str, i, i + 1) == "|r") then
                byteLen = 2
                charLen = 0
                cffTailing = true
            end
        end
        i = i + byteLen -- 下一字节的索引
        if (charLen > 0) then
            count = count + charLen -- 阶段字符的个数（长度）
            if (nil ~= cffColor) then
                subStr[#subStr + 1] = cffColor
                cffColor = nil
            end
            subStr[#subStr + 1] = string.sub(str, i0, i - 1)
            if (count >= size) then
                if (nil ~= cffColorS) then
                    if (false == cffTailing) then
                        subStr[#subStr + 1] = "|r"
                    else
                        cffTailing = false
                        cffColor = nil
                        cffColorS = nil
                    end
                end
                sp[#sp + 1] = table.concat(subStr, '')
                count = 0
                subStr = {}
                cffColor = cffColorS
            elseif (i > lenInByte) then
                sp[#sp + 1] = table.concat(subStr, '')
            end
            i0 = i
        end
    end
    return sp
end