--- camera lock token
do
    local lock = {}
    for i = 0, BJ_MAX_PLAYERS, 1 do
        local k = tostring(i)
        lock[k] = J.CreateUnit(PlayerPassive._handle, LK_SLK_ID_UNIT_TOKEN, 0, 0, 270)
        J.HandleRef(lock[k])
    end
    japi._cameraLock = lock
    sync.receive("lk_cam_lok", function(syncData)
        local aid = tostring(syncData.transferData[1])
        local tx = tonumber(syncData.transferData[2])
        local ty = tonumber(syncData.transferData[3])
        local tu = japi._cameraLock[aid]
        if (type(tu) == "number") then
            J.SetUnitPosition(tu, tx, ty)
            async.call(Player(tonumber(aid), function()
                J.SetCameraTargetController(tu, 0, 0, false)
            end))
        end
    end)
end