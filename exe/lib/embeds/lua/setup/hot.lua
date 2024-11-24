function LK_HT()
    xRequire = function(name)
        print("[HOT]load: " .. name)
        if package.loaded[name] then
            package.loaded[name] = nil
        end
        local status, err = xpcall(require, debug.traceback, name)
        if (true ~= status) then
            print("[HOT]err: " .. err)
        end
    end
    time.setInterval(0.5, function()
        local ht, err1 = io.open("xhot.txt", 'r+')
        if (nil == err1) then
            local str = ht:read('a')
            ht:close()
            ht, _ = io.open("xhot.txt", 'w')
            ht:close()
            if (string.len(str) > 0) then
                local name = string.match(str, '<' .. 'xhot>(.*)<xhot' .. '>')
                if name ~= nil then
                    print("[HOT]files: " .. name)
                    local status, f = xpcall(load, debug.traceback, str)
                    if (true == status and type(f) == "function") then
                        f()
                    end
                end
            end
        end
    end)
end
game.onPhase("process", function() LK_HT() end)