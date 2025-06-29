--- 天气控制
--- 特性1、天气类型非handle类型，[视觉区]指曾看到的区域，是虚构的概念实际上不存在，但可粗略理解为Region
--- 特性2、迷雾类型指：薄雾/厚雾/风/大风；光束类型指：日光/月光；雨水类型指：雨/大雨
--- 特性3、同一片区域可以多次设置天气（但非常不建议，详情见特性6/7）
--- 特性4、同一片区域多次设置同一天气后，在视觉效果上不会有什么差异，实际影响未知
--- 特性5、同源类型（如迷雾/光束），不能同时显示在同一片视觉区，会被抢先生成的占领视觉区，即使使用不同Region也无效
--- 特性6、同一Region，只添加最多1种天气时，此天气添加[迷雾|光束|雨水类型]后，可后续修改为其他的[迷雾|光束|雨水类型](但依然遵循 特性5)
--- 特性7、同一Region，曾添加过2种以上天气后，则该视觉区在添加1次[迷雾|光束|雨水类型]后，则该视觉区的其他的[迷雾|光束|雨水类型]功能将被废且锁死，无法生效
---@class weather 天气类型
weather = weather or {}

--- 已创建天气类型记录
weather._record = weather._record or {}

--- 天气类型
local m_wk = Mapping("weatherKind")
weather.kind = {
    sun = m_wk:set(J.C2I("LRaa"), "日光"),
    moon = m_wk:set(J.C2I("LRma"), "月光"),
    shield = m_wk:set(J.C2I("MEds"), "紫光盾"),
    rain = m_wk:set(J.C2I("RAlr"), "雨"),
    rainstorm = m_wk:set(J.C2I("RAhr"), "大雨"),
    snow = m_wk:set(J.C2I("SNls"), "雪"),
    snowstorm = m_wk:set(J.C2I("SNhs"), "大雪"),
    wind = m_wk:set(J.C2I("WOlw"), "风"),
    windstorm = m_wk:set(J.C2I("WNcw"), "大风"),
    mistWhiteLight = m_wk:set(J.C2I("FDwl"), "薄白雾"),
    mistWhiteHeave = m_wk:set(J.C2I("FDwh"), "厚白雾"),
    mistGreenLight = m_wk:set(J.C2I("FDgl"), "薄绿雾"),
    mistGreenHeave = m_wk:set(J.C2I("FDgh"), "厚绿雾"),
    mistBlueLight = m_wk:set(J.C2I("FDbl"), "薄蓝雾"),
    mistBlueHeave = m_wk:set(J.C2I("FDbh"), "厚蓝雾"),
    mistRedLight = m_wk:set(J.C2I("FDrl"), "薄红雾"),
    mistRedHeave = m_wk:set(J.C2I("FDrh"), "厚红雾"),
}

--- 检测是否属于有效的类型
---@param whichKind table lightning.kind.*
---@return boolean
function weather.isValidKind(whichKind)
    return isMapping(whichKind, m_wk._kind)
end

--- 生成一片天气
--- 使用此方法并不会将天气数据插入到Region之内（仅仅是引用了Region生成的原生区域）
--- 一般不直接使用此方法，而是基于Region对象使用，详情见 meta/region weather相关方法
---@see weather#kind
---@param kind MappingValue 天气类型，参考 weather.kind.*
---@param bindRegion Region 绑定的区域
---@return number
function weather.create(kind, bindRegion)
    sync.must()
    must(weather.isValidKind(kind), "kind@weather.kind")
    local w = J.AddWeatherEffect(bindRegion:handle(), kind.value)
    J.EnableWeatherEffect(w, true)
    weather._record[w] = kind
    return w
end

--- 获取某片天气的类型
---@see weather#kind
---@param whichWeather number 天气ID
---@return table|nil
function weather.getKind(whichWeather)
    sync.must()
    return weather._record[whichWeather]
end

--- 删除某片天气
---@param whichWeather number
---@return void
function weather.destroy(whichWeather)
    sync.must()
    if (type(whichWeather) == "number") then
        J.EnableWeatherEffect(whichWeather, false)
        J.RemoveWeatherEffect(whichWeather)
        weather._record[whichWeather] = nil
    end
end