-- 命令
--- -gg 投降
player.command("^-gg$", function(evtData)
    evtData.triggerPlayer:quit("GG")
end)
--- -apm 查看玩家分钟操作数
player.command("^-apm$", function(evtData)
    echo("您的apm为:" .. evtData.triggerPlayer:apm(), evtData.triggerPlayer)
end)
--- -d [+|-|=][NUMBER]减少/增加/设置视距
player.command("^-d [-+=]%d+$", function(evtData)
    local cds = string.explode(" ", string.lower(evtData.chatString))
    local first = string.sub(cds[2], 1, 1)
    if (first == "+" or first == "-" or first == "=") then
        --视距
        local v = string.sub(cds[2], 2, string.len(cds[2]))
        v = math.abs(tonumber(v))
        if (v > 0) then
            local val = math.abs(v)
            local distance = camera.distance()
            if (first == "+") then
                distance = distance + val
            elseif (first == "-") then
                distance = distance - val
            elseif (first == "=") then
                distance = val
            end
            async.call(evtData.triggerPlayer, function()
                camera.distance(distance)
            end)
            echo("视距已设置为：" .. camera.distance(), evtData.triggerPlayer)
        end
    end
end)
if (LK_DEBUG) then
    --- 流程掌控
    player.command("^-proc [a-zA-Z0-9_]+$", function(evtData)
        local p = string.trim(evtData.matchedString)
        p = string.sub(p, 7, string.len(p))
        local proc = nil
        if (p == "this") then
            proc = ProcessCurrent
        else
            proc = Process(p)
        end
        if (class.isObject(proc, ProcessClass)) then
            print(p .. "流程已重置")
            ProcessCurrent:over()
            proc:start()
        end
    end)
end