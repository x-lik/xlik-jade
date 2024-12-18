--- 魔兽自带F9任务控制
---@class Quest:Meta
local _index = Meta(QuestClass)

---@protected
function _index:destruct()
    J.DestroyQuest(self._handle)
    J.HandleUnRef(self._handle)
    self._handle = nil
    class.cache(QuestClass)[self._title] = nil
end

--- 设置图标
---@param icon string 图标路径
---@return self
function _index:setIcon(icon)
    J.QuestSetIconPath(self._handle, japi.AssetsImage(icon))
    return self
end

--- 设置位置
---@param side string 填'l'或'r'，表示这个任务放在左边还是右边
---@return self
function _index:setSide(side)
    J.QuestSetRequired(self._handle, side == 'l')
    return self
end

--- 设置内容
---@param content string|string[]
---@return self
function _index:setContent(content)
    if (content and type(content) == "table") then
        content = table.concat(content, "|n")
    end
    J.QuestSetDescription(self._handle, content)
    return self
end

--- 设置完成状态
---@param status boolean
---@return self
function _index:setComplete(status)
    J.QuestSetCompleted(self._handle, status)
    return self
end

--- 设置失败状态
---@param status boolean
---@return self
function _index:setFail(status)
    J.QuestSetFailed(self._handle, status)
    return self
end

--- 设置发现状态
---@param status boolean
---@return self
function _index:setDiscover(status)
    J.QuestSetDiscovered(self._handle, status)
    return self
end

--- 令任务按钮闪烁
---@return void
function _index:flash()
    J.FlashQuestDialogButton()
end

--- 构造F9任务对象
---@param title string 唯一标题，F9内内容一般标题唯一，以此标准作为唯一键
---@return Quest
function Quest(title)
    sync.must()
    local cache = class.cache(QuestClass)
    if (nil == cache[title]) then
        ---@type Quest
        local o = oMeta(_index, {
            _title = title, _content = '',
            _complete = false, _fail = false, _discover = true,
        })
        o._handle = J.CreateQuest()
        J.HandleRef(o._handle)
        J.QuestSetTitle(o._handle, title)
        o:setIcon("ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp")
        cache[title] = o
    end
    return cache[title]
end