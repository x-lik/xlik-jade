--- 游戏开始
local tgr = J.CreateTrigger()
J.HandleRef(tgr)
J.TriggerRegisterTimerEvent(tgr, 0.1, false)
J.TriggerAddAction(tgr, function()
    J.DisableTrigger(tgr)
    J.DestroyTrigger(tgr)
    J.HandleUnRef(tgr)
    tgr = nil
    game.phase("start")
    local qty = 0
    for i = 0, BJ_MAX_PLAYERS - 1 do
        if ((J.GetPlayerController(J.Player(i)) == MAP_CONTROL_USER) and (J.GetPlayerSlotState(J.Player(i)) == PLAYER_SLOT_STATE_PLAYING)) then
            qty = qty + 1
        end
    end
    player.startQuantity = qty
    player.currentQuantity = qty
    
    ---@param enumObj UIKit
    Pool(UIKitClass):forEach(function(enumObj)
        enumObj:start()
    end)
    
    --- 初始化 异步帧钟
    J.Japi["DzFrameSetUpdateCallbackByCode"](function()
        if (false == japi.DZ_IsWindowActive()) then
            return
        end
        ---lk:placeholder start:cameraEvents
        ---lk:placeholder start:asyncRefresh
        ---lk:placeholder start:asyncExec
        ---lk:placeholder start:asyncExecDelay
    end)
    
    ---lk:placeholder start:cameraLock
    
    --- sync同步处理
    local tgr2 = J.CreateTrigger()
    J.HandleRef(tgr2)
    japi.DZ_TriggerRegisterSyncData(tgr2, "lk_send", false)
    J.TriggerAddAction(tgr2, function()
        local pid = 1 + J.GetPlayerId(japi.DZ_GetTriggerSyncPlayer())
        for _, v in ipairs(string.explode("||", japi.DZ_GetTriggerSyncData())) do
            local trData = string.explode("|", v)
            local k = trData[1]
            table.remove(trData, 1)
            sync.exec(k, trData, Player(pid))
        end
    end)
    
    --- 同步时钟
    local t = J.CreateTimer()
    J.HandleRef(t)
    J.TimerStart(t, 0.01, true, function()
        for i = 1, #time._clock do
            promise(time._clock[i])
        end
    end)
    
    ---lk:placeholder start:zInit
    
    game.phase("process")
    
    --- process start
    local p1st = Process("start")
    if (class.isObject(p1st, ProcessClass)) then
        p1st:start()
    end
end)