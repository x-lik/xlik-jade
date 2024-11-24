-- 定义单位描述体
-- [基础信息]
---@param this Item
description.define("unitBase", function(this, _)
    local desc = {}
    table.insert(desc, this:name())
    if (this:level() > 0) then
        table.insert(desc, "等级：Lv" .. this:level())
    else
        name = this:name()
    end
    return desc
end)