--- 魔兽自带对话框
--- 单人游戏时弹出此框会暂停游戏
---@class Dialog
local _index = Meta(DialogClass)

local _evt = J.Condition(function()
    ---@type Dialog
    local triggerDialog = class.h2o(J.GetClickedDialog())
    ---@type Array
    local buttons = triggerDialog._buttons
    local evtData = buttons:get(tostring(J.GetClickedButton()))
    local action = triggerDialog._action
    if (type(evtData) == "table" and type(action) == "function") then
        evtData.triggerDialog = triggerDialog
        evtData.triggerPlayer = Player(1 + J.GetPlayerId(J.GetTriggerPlayer()))
        action(evtData)
    end
    class.destroy(triggerDialog)
end)

function _index:destruct()
    ---@type Array
    local buttons = self._buttons
    local keys = buttons:keys()
    if (#keys > 0) then
        for _, k in ipairs(keys) do
            J.HandleUnRef(math.round(tonumber(k)))
        end
    end
    self._buttons = nil
    J.DialogClear(self._handle)
    J.DialogDestroy(self._handle)
    J.HandleUnRef(self._handle)
    class.handle(self, nil)
end

--- 展示，可指定给某玩家
---@param whichPlayer Player|nil
---@return void
function _index:display(whichPlayer)
    if (class.isObject(whichPlayer, PlayerClass)) then
        J.DialogDisplay(whichPlayer:handle(), self._handle, true)
    else
        J.DialogDisplay(Player1st():handle(), self._handle, true)
    end
end

--[[
    对话框
    buttons = {
        "第1个",
        "第2个",
        "第3个",
    }
    或
    buttons = {
        { value = "Q", label = "第1个" },
        { value = "W", label = "第2个" },
        { value = "D", label = "第3个" },
    }
]]
---@param title string
---@param buttons string[]|table<number,{value:string,label:string,hotkey:string|number}>
---@param action fun(evtData:{triggerPlayer:Player,triggerDialog:Dialog,label:"标签",value:"值"}):void
---@return Dialog
function Dialog(title, buttons, action)
    sync.must()
    must(#buttons > 0, "#buttons must to be greater than 1")
    must(type(action) == "function", "action@DialogFunc")
    local o = oMeta({ _action = action }, _index)
    o._handle = J.DialogCreate()
    class.handle(o, o._handle)
    J.HandleRef(o._handle)
    J.DialogSetMessage(o._handle, title or "标题")
    local bs = Array()
    for i = 1, #buttons do
        local label, value, hotkey
        local bt = buttons[i]
        if (type(bt) == "table") then
            label = bt.label
            value = bt.value
            hotkey = bt.hotkey or bt.value
        else
            label = bt
            value = bt
            hotkey = bt
        end
        local hk = 0
        if (type(hotkey) == "number") then
            hk = hotkey
        elseif (type(hotkey) == "string") then
            hk = string.byte(hotkey, 1)
        end
        local b = J.DialogAddButton(o._handle, label, hk)
        J.HandleRef(b)
        bs:set(tostring(b), { label = label, value = value })
    end
    o._buttons = bs
    event.condition(_evt, function(tgr)
        J.TriggerRegisterDialogEvent(tgr, o._handle)
    end)
    return o
end
