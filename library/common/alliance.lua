--- 联盟关系，控制玩家的联盟关系
--- 一般不需要使用，并且自带魔兽原生bug，可能导致玩家单位的寻敌异常
---@class alliance
alliance = alliance or {}

--- 设置结盟
---@param sourcePlayer Player
---@param otherPlayer Player
---@param flag boolean
---@return void
function alliance.ally(sourcePlayer, otherPlayer, flag)
    sync.must()
    J.SetPlayerAlliance(sourcePlayer:handle(), otherPlayer:handle(), ALLIANCE_PASSIVE, flag)
    J.SetPlayerAlliance(sourcePlayer:handle(), otherPlayer:handle(), ALLIANCE_HELP_REQUEST, flag)
    J.SetPlayerAlliance(sourcePlayer:handle(), otherPlayer:handle(), ALLIANCE_HELP_RESPONSE, flag)
    J.SetPlayerAlliance(sourcePlayer:handle(), otherPlayer:handle(), ALLIANCE_SHARED_XP, flag)
    J.SetPlayerAlliance(sourcePlayer:handle(), otherPlayer:handle(), ALLIANCE_SHARED_SPELLS, flag)
end

--- 设置视野
---@param sourcePlayer Player
---@param otherPlayer Player
---@param flag boolean
---@return void
function alliance.vision(sourcePlayer, otherPlayer, flag)
    sync.must()
    J.SetPlayerAlliance(sourcePlayer:handle(), otherPlayer:handle(), ALLIANCE_SHARED_VISION, flag)
end

--- 设置控制
---@param sourcePlayer Player
---@param otherPlayer Player
---@param flag boolean
---@return void
function alliance.control(sourcePlayer, otherPlayer, flag)
    sync.must()
    J.SetPlayerAlliance(sourcePlayer:handle(), otherPlayer:handle(), ALLIANCE_SHARED_CONTROL, flag)
end

--- 设置完全控制
---@param sourcePlayer Player
---@param otherPlayer Player
---@param flag boolean
---@return void
function alliance.fullControl(sourcePlayer, otherPlayer, flag)
    sync.must()
    J.SetPlayerAlliance(sourcePlayer:handle(), otherPlayer:handle(), ALLIANCE_SHARED_ADVANCED_CONTROL, flag)
end

--- 设置中立
---@param sourcePlayer Player
---@param otherPlayer Player
---@param flag boolean
---@return void
function alliance.neutral(sourcePlayer, otherPlayer, flag)
    sync.must()
    J.SetPlayerAlliance(sourcePlayer:handle(), otherPlayer:handle(), ALLIANCE_PASSIVE, flag)
end

