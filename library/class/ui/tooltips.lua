--- 提示面板UI
---@class UITooltips:UI
local _index = UI(UITooltipsClass, {
    ---@type boolean 保护
    _protect = true
})

--- 内容设置
--[[
    -- 数据格式
    data:{
        textAlign:TEXT_ALIGN_*  -- 文本对齐方式
        fontSize:10  -- 文本字号，默认10
        padding:{0,0,0,0}, --上右下左填补
        icons:{
            { texture, text },-- 图标带文本的东东格式，默认最多4个
        }
        bars:{
            { texture, text, ratio, width, height }, -- 条状物格式，默认最多2个
        }
        tips:{
            "string",
        }
    },
]]
---@alias TooltipContentIcons { texture:string, text:string }
---@alias TooltipContentBars { texture:string, text:string,ratio:number,width:number,height:number }
---@alias TooltipContent {textAlign:number,fontSize:number,padding:number[],icons:TooltipContentIcons[],bars:TooltipContentBars[],tips:string|string[]}
---@param options TooltipContent
---@return self
function _index:content(options)
    if (type(options) == "string") then
        options = { tips = options }
    end
    ---@type UIBar[]
    local uiBars = self._bars
    ---@type UIText[]
    local uiText = self._text
    --
    local fontSize = options.fontSize or 10
    local bars = options.bars
    local tips = options.tips
    uiText:fontSize(fontSize)
    if (type(tips) == "string") then
        tips = string.explode("|n", tips)
    end
    local icons = options.icons
    -- 处理文本对齐方向
    if ((type(icons) == "table" and #icons > 0)) then
        -- 当有顶部图标时，自动调节为左对齐
        uiText:textAlign(TEXT_ALIGN_LEFT)
    elseif (type(tips) == "table" and #tips == 1) then
        -- 当只有一行文本时，自动调节为居中
        uiText:textAlign(TEXT_ALIGN_CENTER)
    else
        -- 无图标且多行文本时，以options设定为准，默认 TEXT_ALIGN_CENTER
        uiText:textAlign(options.textAlign or TEXT_ALIGN_CENTER)
    end
    
    -- 处理内容及计算宽高
    local padTop = 0.008
    local padRight = 0.009
    local padBottom = 0.008
    local padLeft = 0.008
    if (type(options.padding) == "table") then
        padTop = options.padding[1] or padTop
        padRight = options.padding[2] or padRight
        padBottom = options.padding[3] or padTop
        padLeft = options.padding[4] or padLeft
    end
    local tw = 0
    local th = 0
    local hasIcons = false
    local hasTips = false
    
    ---@type table<number,{bg:UIBackdrop,txt:UIText}>
    local uiIcons = self._icons
    local cw = 0
    for i = 1, #uiIcons, 1 do
        if (type(icons) ~= "table" or nil == icons[i]) then
            uiIcons[i].bg:show(false)
        else
            if (i == 1) then
                hasIcons = true
                uiIcons[i].bg:relation(UI_ALIGN_LEFT_TOP, self, UI_ALIGN_LEFT_TOP, padLeft, -padTop)
            else
                uiIcons[i].bg:relation(UI_ALIGN_LEFT, uiIcons[i - 1].txt, UI_ALIGN_RIGHT, 0.008, 0)
                cw = cw + 0.008
            end
            uiIcons[i].txt:text(icons[i].text):fontSize(fontSize - 1)
            uiIcons[i].bg:texture(icons[i].texture)
            uiIcons[i].bg:show(true)
            cw = cw + 0.013 + 0.002 + vistring.width(icons[i].text, fontSize)
        end
    end
    tw = math.max(tw, cw)
    if (hasIcons) then
        th = th + 0.013
    end
    
    ---@type table<number,UIBar>
    local lastBarIdx = 0
    for i = 1, #uiBars, 1 do
        if (type(bars) ~= "table" or nil == bars[i]) then
            uiBars[i]:show(false)
        else
            lastBarIdx = i
            local bh = vistring.height(1, fontSize - 2)
            if (i == 1) then
                tw = math.max(tw, bars[i].width)
                if (hasIcons) then
                    uiBars[i]:relation(UI_ALIGN_LEFT_TOP, uiIcons[1].bg, UI_ALIGN_LEFT_BOTTOM, 0, -bh - padTop / 2)
                    th = th + padTop / 2
                else
                    uiBars[i]:relation(UI_ALIGN_LEFT_TOP, self, UI_ALIGN_LEFT_TOP, padLeft, -bh - padTop)
                end
            else
                uiBars[i]:relation(UI_ALIGN_LEFT_TOP, uiBars[i - 1], UI_ALIGN_LEFT_BOTTOM, 0, -bh - padTop / 4)
                th = th + padTop / 4
            end
            uiBars[i]:text(LAYOUT_ALIGN_LEFT_TOP, bars[i].text)
            uiBars[i]:fontSize(LAYOUT_ALIGN_LEFT_TOP, fontSize - 2)
            uiBars[i]:valueTexture(bars[i].texture)
            uiBars[i]:ratio(bars[i].ratio, bars[i].width, bars[i].height)
            uiBars[i]:show(true)
            th = th + bars[i].height + bh
        end
    end
    if (type(tips) == "table" and #tips > 0) then
        hasTips = true
        if (lastBarIdx > 0) then
            uiText:relation(UI_ALIGN_LEFT_TOP, uiBars[lastBarIdx], UI_ALIGN_LEFT_BOTTOM, 0, -padTop / 3)
            th = th + padTop / 3
        elseif (hasIcons) then
            uiText:relation(UI_ALIGN_LEFT_TOP, uiIcons[1].bg, UI_ALIGN_LEFT_BOTTOM, 0, -padTop / 3)
            th = th + padTop / 3
        else
            uiText:relation(UI_ALIGN_LEFT_TOP, self, UI_ALIGN_LEFT_TOP, padLeft, -padTop)
        end
        local txw = 0
        local txts = {}
        local ns = 0
        for _, s in ipairs(tips) do
            txw = math.max(txw, vistring.width(s .. ' ', fontSize))
            txts[#txts + 1] = s
            ns = ns + string.subCount(s, "|n")
        end
        local txh = vistring.height(#txts + ns, fontSize)
        uiText:size(txw, txh):text(table.concat(txts, "|n"))
        tw = math.max(tw, txw)
        th = th + txh
    end
    --
    tw = tw + padLeft + padRight
    th = th + padTop + padBottom
    self:size(tw, th)
    return self
end

--- 构造UITooltips信息对象
---@param index number 序号0框架保留使用，请使用其他1-3号序号或缺省（默认1）
---@return UITooltips
function UITooltips(index)
    index = math.floor(index or 1)
    must(type(index) == "number", "index@integer")
    must(index >= 0 and index <= 3, "index out of range 0~3")
    local cache = class.cache(UITooltipsClass)
    if (nil == cache[index]) then
        local key = UITooltipsClass .. index
        ---@type UITooltips
        local o = oUI({
            _key = key,
            _parent = UIGame,
            _fdfName = "LK_BACKDROP_TOOLTIP",
            _fdfType = "BACKDROP"
        }, _index)
        o:adaptive(true)
        o:absolut(0, 0)
        o:size(0.1, 0.1)
        o:show(false)
        --
        local ic = {}
        for i = 1, 4 do
            local tmp = {}
            tmp.bg = UIBackdrop(key .. "IconBg" .. i, o)
                :size(0.013, 0.013)
                :show(false)
            tmp.txt = UIText(key .. "IconTxt" .. i, tmp.bg)
                :relation(UI_ALIGN_LEFT, tmp.bg, UI_ALIGN_RIGHT, 0.002, 0)
                :textAlign(TEXT_ALIGN_LEFT)
            table.insert(ic, tmp)
        end
        o._icons = ic
        local brs = {}
        for i = 1, 2 do
            local b = UIBar(key .. "Bar" .. i, o, { _layouts = { LAYOUT_ALIGN_LEFT_TOP } })
            b:show(false)
            table.insert(brs, b)
        end
        o._bars = brs
        o._text = UIText(key .. "->Txt", o)
            :relation(UI_ALIGN_CENTER, o, UI_ALIGN_CENTER, 0, 0)
            :textAlign(TEXT_ALIGN_LEFT)
            :fontSize(10)
        ---@param evtData eventOnUIShow
        o:onEvent(eventKind.uiShow, "clear_", function(evtData)
            evtData.triggerUI:onEvent(eventKind.uiLeftClick, "clear2_", function(evtData2)
                evtData2.triggerUI:onEvent(eventKind.uiLeftClick, "clear2_", nil)
                evtData2.triggerUI:show(false)
            end)
        end)
        --
        Pool(UITooltipsClass):insert(o)
        cache[index] = o
    end
    return cache[index]
end