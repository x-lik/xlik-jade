--- 挂机灭绝器
--- negative hang up
if (false == LK_DEBUG) then
    
    game.onPhase("process", function()
        
        sync.receive("negativeHangUp", function(syncData)
            local idx = tonumber(syncData.transferData[1])
            Player(idx):quit("消极挂机")
        end)
        async.loc(function()
            local cx, cy = camera.x(), camera.y()
            local click = false
            local clickResume = function()
                click = true
            end
            mouse.onLeftClick("negativeHangUp", clickResume)
            mouse.onRightClick("negativeHangUp", clickResume)
            async.setInterval(1800, function(curTimer)
                local period = curTimer:period()
                if (period > 10800) then
                    class.destroy(curTimer)
                    return
                end
                local cx2, cy2 = camera.x(), camera.y()
                if (true ~= click and cx == cx2 and cy == cy2) then
                    class.destroy(curTimer)
                    sync.send("negativeHangUp", { PlayerLocal():index() })
                    return
                end
                cx, cy = cx2, cy2
                click = false
                curTimer:period(period + 300)
            end)
        end)
    
    end)

end