--- 雾体控制
---@class fog
fog = fog or {}

--- 设置战争迷雾
---@param status boolean
---@return void
function fog.enable(status)
    sync.must()
    J.FogEnable(status)
end

--- 设置黑色阴影
---@param status boolean
---@return void
function fog.maskEnable(status)
    sync.must()
    J.FogMaskEnable(status)
end

--- 销毁雾体修改器
---@param whichFog number
---@return void
function fog.destroyModifier(whichFog)
    sync.must()
    J.DestroyFogModifier(whichFog)
    J.HandleUnRef(whichFog)
end

--- 创建雾体修改器
---@param whichPlayer Player
---@param x number
---@param y number
---@param radius number
---@param fogState number FOG_OF_WAR_MASKED|FOG_OF_WAR_FOGGED|FOG_OF_WAR_VISIBLE
---@return number
function fog.createModifier(whichPlayer, x, y, radius, fogState)
    sync.must()
    local h = J.CreateFogModifierRadius(whichPlayer:handle(), fogState, x, y, radius, true, false)
    J.HandleRef(h)
    return h
end

--- 雾体修改器起效
---@param whichFog number
---@return void
function fog.startModifier(whichFog)
    sync.must()
    J.FogModifierStart(whichFog)
end

--- 停用雾体修改器
---@param whichFog number
---@return void
function fog.stopModifier(whichFog)
    sync.must()
    J.FogModifierStop(whichFog)
end
