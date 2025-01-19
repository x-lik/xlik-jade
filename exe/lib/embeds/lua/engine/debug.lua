--- 自启动调试
LK_DEBUG = true
J.Runtime['console'] = true
J.Runtime['sleep'] = false
J.Runtime['handle_level'] = 0
---@protected
---@param msg string
---@return string
function LK_ERROR(msg)
    msg = tostring(msg)
    local a1, a2 = string.find(msg, '@', nil, true)
    if (nil ~= a1) then
        local pn = string.sub(msg, 1, a1 - 1)
        local pt = string.sub(msg, a2 + 1)
        msg = "参数 " .. pn .. " 必须为 " .. pt .. "类型\n┣━━  Param [" .. pn .. "] must be of type [" .. pt .. ']'
    end
    local _, fm = string.find(msg, '**MUST**', 1, true)
    if (nil == fm) then
        print(msg .. '\n' .. debug.traceback())
    else
        msg = string.sub(msg, fm + 1)
        local trace = {}
        local back, delimeter = debug.traceback('', 2), '\n'
        local s, a, b = 1, 1, 1
        while true do
            a, b = string.find(back, delimeter, s, true)
            if not a then
                break
            end
            table.insert(trace, string.sub(back, s, a - 1))
            s = b + 1
        end
        table.insert(trace, string.sub(back, s))
        local paths = {}
        for i = 3, #trace, 1 do
            local t = trace[i]
            local f = string.find(t, '(debug)', nil)
            if nil == f then
                f = string.find(t, '\\', nil, true)
                if nil ~= f then
                    local sub = string.gsub(t, '%s', ' ', 1)
                    paths[#paths + 1] = '┃' .. sub
                end
            end
        end
        if (#paths > 0) then
            table.insert(paths, 1, "┏━━  必检 M U S T ━━\n┣━━  " .. msg)
            table.insert(paths, '┗' .. string.rep('━', 90))
            msg = table.concat(paths, '\n')
        end
        print(msg)
    end
end
J.Runtime['error_handle'] = LK_ERROR

--- 打印
---@return void
function print(...)
    J.Console['write'](...)
end

--- 打印栈
---@return void
function stack()
    print(debug.traceback('', 2))
end

--- 文件日志
--- 仅在调试期有效，会引起文件I/O阻塞，造成卡顿，非必要不用使用
---@param msg string|string[]
---@return void
function logger(msg)
    local t = os.time()
    local f = os.date("%Y%m%d_%H%M", t)
    if (type(msg) == "table") then
        msg = string.implode(" ", msg)
    end
    if (type(msg) ~= "string") then
        msg = "..."
    end
    local out = { "==================================", os.date("%Y-%m-%d %H:%M:%S", t), msg }
    out[#out + 1] = debug.traceback("", 2)
    local l, _ = io.open("Logs\\lk-" .. f .. ".txt", 'a+')
    l:write(table.concat(out, '\n'))
    l:close()
end

--- 输出详尽内容
---@param value any 输出的table
---@param description nil|string 调试信息格式，默认为 <var>
---@param nesting number|nil 输出时的嵌套层级，默认为 10
---@return void
function dump(value, description, nesting)
    if type(nesting) ~= 'number' then
        nesting = 10
    end
    local lookup = {}
    local result = {}
    local traceback = string.explode('\n', debug.traceback('', 2))
    local str = '- dump from: ' .. string.trim(traceback[3])
    local _format = function(v)
        if type(v) == 'string' then
            v = '\'' .. v .. '\''
        end
        return tostring(v)
    end
    local _dump
    _dump = function(val, desc, indent, nest, keyLen)
        desc = desc or '<var>'
        local spc = ''
        if type(keyLen) == 'number' then
            spc = string.rep(' ', keyLen - string.len(_format(desc)))
        end
        if type(val) ~= 'table' then
            result[#result + 1] = string.format('%s%s%s = %s', indent, _format(desc), spc, _format(val))
        elseif lookup[tostring(val)] then
            result[#result + 1] = string.format('%s%s%s = *REF*', indent, _format(desc), spc)
        else
            lookup[tostring(val)] = true
            if nest > nesting then
                result[#result + 1] = string.format('%s%s = *MAX NESTING*', indent, _format(desc))
            else
                result[#result + 1] = string.format('%s%s = {', indent, _format(desc))
                local indent2 = indent .. '    '
                local keys = {}
                local kl = 0
                local values = {}
                for k, v in pairs(val) do
                    if k ~= '___message' then
                        keys[#keys + 1] = k
                        local vk = _format(k)
                        local vkl = string.len(vk)
                        if vkl > kl then
                            kl = vkl
                        end
                        values[k] = v
                    end
                end
                table.sort(keys, function(a, b)
                    if type(a) == 'number' and type(b) == 'number' then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for _, k in ipairs(keys) do
                    _dump(values[k], k, indent2, nest + 1, kl)
                end
                result[#result + 1] = string.format('%s}', indent)
            end
        end
    end
    _dump(value, description, ' ', 1)
    str = str .. '\n' .. table.concat(result, '\n')
    print(str)
end

--- 强制检查结果真确性
---@param check boolean 检测的参数
---@param tips string 失败提示，特定格式name@type可替换为通用类型提示
---@return void
function must(check, tips)
    if (type(check) ~= 'boolean') then
        check = false
    end
    if (false == check) then
        if (type(tips) ~= "string") then
            tips = "must error"
        end
        if (nil == game or false == game.isRunning()) then
            LK_ERROR('**MUST**' .. tips)
        else
            error('**MUST**' .. tips)
        end
    end
end