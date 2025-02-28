--- 键盘方法
--- 用于注册键盘事件
--- 注意键盘callFunc函数内为异步环境
---@class keyboard
keyboard = keyboard or {}

--- 技能热键设定集
---@type table<number,string>
keyboard._abilityHotkey = keyboard._abilityHotkey or nil

--- 物品热键设定集
---@type table<number,string>
keyboard._itemHotkey = keyboard._itemHotkey or nil

--- 键值代码
--- 代码中请使用完整的字符串索引值，如keyboard.code["A"]
--- 不要使用键索引和字符串拼接或键值应用
---@type table<string,number>
keyboard.code = {
    ["0"] = 48,
    ["1"] = 49,
    ["2"] = 50,
    ["3"] = 51,
    ["4"] = 52,
    ["5"] = 53,
    ["6"] = 54,
    ["7"] = 55,
    ["8"] = 56,
    ["9"] = 57,
    ["A"] = 65,
    ["B"] = 66,
    ["C"] = 67,
    ["D"] = 68,
    ["E"] = 69,
    ["F"] = 70,
    ["G"] = 71,
    ["H"] = 72,
    ["I"] = 73,
    ["J"] = 74,
    ["K"] = 75,
    ["L"] = 76,
    ["M"] = 77,
    ["N"] = 78,
    ["O"] = 79,
    ["P"] = 80,
    ["Q"] = 81,
    ["R"] = 82,
    ["S"] = 83,
    ["T"] = 84,
    ["U"] = 85,
    ["V"] = 86,
    ["W"] = 87,
    ["X"] = 88,
    ["Y"] = 89,
    ["Z"] = 90,
    ["~"] = 192,
    ["-"] = 189,
    ["="] = 187,
    ["\\"] = 220,
    ["["] = 219,
    ["]"] = 221,
    [";"] = 186,
    ["'"] = 222,
    [","] = 188,
    ["."] = 190,
    ["/"] = 191,
    ["F1"] = 112,
    ["F2"] = 113,
    ["F3"] = 114,
    ["F4"] = 115,
    ["F5"] = 116,
    ["F6"] = 117,
    ["F7"] = 118,
    ["F8"] = 119,
    ["F9"] = 120,
    ["F10"] = 121,
    ["F11"] = 122,
    ["F12"] = 123,
    ["Numpad0"] = 96,
    ["Numpad1"] = 97,
    ["Numpad2"] = 98,
    ["Numpad3"] = 99,
    ["Numpad4"] = 100,
    ["Numpad5"] = 101,
    ["Numpad6"] = 102,
    ["Numpad7"] = 103,
    ["Numpad8"] = 104,
    ["Numpad9"] = 105,
    ["Numpad*"] = 106,
    ["Numpad+"] = 107,
    ["Numpad-"] = 109,
    ["Numpad."] = 110,
    ["Numpad/"] = 111,
    ["NumLock"] = 144,
    ["Backspace"] = 8,
    ["Esc"] = 27,
    ["Tab"] = 9,
    ["CapsLock"] = 20,
    ["Left"] = 37,
    ["Right"] = 39,
    ["Up"] = 38,
    ["Down"] = 40,
    ["Insert"] = 45,
    ["Delete"] = 46,
    ["Home"] = 36,
    ["End"] = 35,
    ["PageUp"] = 33,
    ["PageDown"] = 34,
    ["Enter"] = 13,
    ["Shift"] = 16,
    ["Control"] = 17,
    ["Alt"] = 18,
}
---@type table<number,string>
keyboard.codeKV = {}
for k, v in pairx(keyboard.code) do
    keyboard.codeKV[v] = k
end

--- 键盘键字符串转数字
--- 未知返回-1
---@param ketString string
---@return number
function keyboard.s2i(ketString)
    return keyboard.code[ketString] or -1
end

--- 键盘键数字转字符串
--- 未知返回空串''
---@param ketNumber number
---@return string
function keyboard.i2s(ketNumber)
    return keyboard.codeKV[ketNumber] or ''
end

--- [异步]按下键盘
---@param ketString string
---@return void
function keyboard.press(ketString)
    J.ForceUIKey(ketString)
end

--- [异步]键盘正在按下
---@param ketString string
---@return boolean
function keyboard.isPressing(ketString)
    return japi.DZ_IsKeyDown(ketString)
end

--- [异步]当键盘异下
---@param keyboardCode number
---@param key string
---@param callFunc fun(evtData:eventOnKeyboardPress)
---@return void
function keyboard.onPress(keyboardCode, key, callFunc)
    event.asyncRegister("keyboard" .. keyboardCode, eventKind.keyboardPress, key, callFunc)
end

--- [异步]当键盘释放
---@param key string
---@param callFunc fun(evtData:eventOnKeyboardRelease)
---@return void
function keyboard.onRelease(keyboardCode, key, callFunc)
    event.asyncRegister("keyboard" .. keyboardCode, eventKind.keyboardRelease, key, callFunc)
end

--- [异步]当键盘长按
--- 必须包含：可能打断->顺利开始->结束，完整3种流程设定才生效，任一流程缺失都取消注册
---@param keyboardCode number
---@param key string
---@param startFunc fun(evtData:eventOnKeyboardLongPressStart) 长按开始回调
---@param brokenFunc fun(evtData:eventOnKeyboardLongPressBroken) 长按打断回调
---@param overFunc fun(evtData:eventOnKeyboardLongPressOver) 长按开始回调
---@return void
function keyboard.onLongPress(keyboardCode, key, startFunc, brokenFunc, overFunc)
    if (type(startFunc) ~= "function" or type(brokenFunc) ~= "function" or type(overFunc) ~= "function") then
        event.asyncUnregister("keyboard" .. keyboardCode, eventKind.keyboardLongPressBroken, key, nil)
        event.asyncUnregister("keyboard" .. keyboardCode, eventKind.keyboardLongPressStart, key, nil)
        event.asyncUnregister("keyboard" .. keyboardCode, eventKind.keyboardLongPressOver, key, nil)
        return
    end
    event.asyncRegister("keyboard" .. keyboardCode, eventKind.keyboardLongPressBroken, key, brokenFunc)
    event.asyncRegister("keyboard" .. keyboardCode, eventKind.keyboardLongPressStart, key, startFunc)
    event.asyncRegister("keyboard" .. keyboardCode, eventKind.keyboardLongPressOver, key, overFunc)
end

--- 配置技能栏键盘热键
--- 当 params 为数字数组时，设置键值，如{keyboard.code["Q"],keyboard.code["W"],keyboard.code["E"],keyboard.code["R"]}
--- 当 params 为数字时，返回对应位置键值，如1返回keyboard.code["Q"]，如果后续需要键名"Q"可使用keyboard.i2s转换
--- 当 params 为nil时，返回所有设置
---@see keyboard#code
---@see keyboard#i2s
---@param param nil|number|number[]
---@return number[]|number|void
function keyboard.abilityHotkey(param)
    if (type(param) == "table") then
        sync.must()
        local key = "lk_ahk"
        for idx, keycode in ipairs(param) do
            local call = nil
            call = function(evtData)
                keyboard.onPress(keycode, key, nil)
                keyboard.onRelease(keycode, key, function()
                    keyboard.onPress(keycode, key, call)
                end)
                if (japi.IsLongPressing("keyboard")) then
                    return
                end
                local selection = evtData.triggerPlayer:selection()
                if (false == class.isObject(selection, UnitClass)) then
                    return
                end
                local abilitySlot = selection:abilitySlot()
                if (nil == abilitySlot) then
                    return
                end
                ---@type Ability
                local ab = abilitySlot:storage()[idx]
                if (class.isObject(ab, AbilityClass)) then
                    cursor.quote(ab:targetType(), { ability = ab, keyboard = keycode })
                end
            end
            keyboard.onRelease(keycode, key, nil)
            keyboard.onPress(keycode, key, call)
        end
        keyboard._abilityHotkey = param
    elseif (type(param) == "number") then
        return keyboard._abilityHotkey[param]
    end
    return keyboard._abilityHotkey
end

--- 游戏物品栏热键
--- 当 params 为数字数组时，设置键值，如{keyboard.code["1"],keyboard.code["2"],keyboard.code["3"]}
--- 当 params 为数字时，返回对应位置键值，如1返回keyboard.code["1"]，如果后续需要键名"1"可使用keyboard.i2s转换
--- 当 params 为nil时，返回所有设置
---@see keyboard#code
---@param param nil|number|number[]
---@return number[]|number|void
function keyboard.itemHotkey(param)
    if (type(param) == "table") then
        sync.must()
        local key = "lk_ihk"
        for idx, keycode in ipairs(param) do
            local call = nil
            call = function(evtData)
                keyboard.onPress(keycode, key, nil)
                keyboard.onRelease(keycode, key, function()
                    keyboard.onPress(keycode, key, call)
                end)
                if (japi.IsLongPressing("keyboard")) then
                    return
                end
                local selection = evtData.triggerPlayer:selection()
                if (false == class.isObject(selection, UnitClass)) then
                    return
                end
                local itemSlot = selection:itemSlot()
                if (nil == itemSlot) then
                    return
                end
                ---@type Item
                local it = itemSlot:storage()[idx]
                if (class.isObject(it, ItemClass)) then
                    ---@type Ability
                    local ab = it:bindAbility()
                    if (class.isObject(ab, AbilityClass)) then
                        cursor.quote(ab:targetType(), { ability = ab, keyboard = keycode })
                    end
                end
            end
            keyboard.onRelease(keycode, key, nil)
            keyboard.onPress(keycode, key, call)
        end
        keyboard._itemHotkey = param
    elseif (type(param) == "number") then
        return keyboard._itemHotkey[param]
    end
    return keyboard._itemHotkey
end