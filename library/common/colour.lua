--- 字体颜色模块
--- 安装插件 Color Highlighter 可直接直观参考颜色
---@class colour 颜色
colour = colour or {}

colour.black = "000000" -- 黑色

colour.white = "FFFFFF" -- 白色
colour.snow = "FFFAFA" -- 雪白色
colour.whitesmoke = "F5F5F5" -- 烟白色
colour.lightgray = "D3D3D3" -- 浅灰
colour.silver = "C0C0C0" -- 银色
colour.darkgray = "A9A9A9" -- 暗灰色

colour.red = "ff2424" -- 红色
colour.indianred = "FF6A6A" -- 印度红色
colour.littlepink = "FF8080" -- 小粉色
colour.pink = "FFC0CB" -- 粉红色
colour.mistyrose = "FFE4E1" -- 浅玫瑰色

colour.gold = "FFCC00" -- 金色
colour.orange = "FFA500" -- 橙色
colour.sandybrown = "F4A460" -- 沙褐色
colour.lightcoral = "F08080" -- 亮珊瑚色
colour.salmon = "FA8072" -- 鲜肉色
colour.lightsalmon = "FFA07A" -- 亮肉色
colour.tomato = "FF6347" -- 西红柿色

colour.yellow = "FFFF00" -- 黄色
colour.darkkhaki = "BDB76B" -- 暗黄褐色
colour.khaki = "F0E68C" -- 黄褐色
colour.beige = "F5F5DC" -- 米色
colour.lemonchiffon = "FFFACD" -- 柠檬绸色
colour.lightyellow = "FFFFE0" -- 浅黄色

colour.green = "80FF00" -- 大绿色
colour.limegreen = "32CD32" -- 橙绿色
colour.lawngreen = "7CFC00" -- 草绿色
colour.lightgreen = "90EE90" -- 亮绿色
colour.palegreen = "98F898" -- 苍绿色
colour.aquamarine = "7FFFD4" -- 碧绿色
colour.honeydew = "F0FFF0" -- 蜜色
colour.darkseagreen = "C1FFC1" -- 浅墨绿色
colour.mintcream = "F5FFFA" -- 薄荷色

colour.royalblue = "4169E1" -- 皇家蓝
colour.dodgerblue = "1E90FF" -- 闪兰色
colour.cornflowerblue = "6495ED" -- 菊兰色
colour.deepskyblue = "00BFFF" -- 深天蓝色
colour.skyblue = "87CECB" -- 天蓝色
colour.lightskyblue = "87CEFA" -- 亮天蓝色
colour.lightsteelblue = "B0C4DE" -- 亮钢兰色
colour.lightblue = "ADD8E6" -- 亮蓝色
colour.lightcyan = "E0FFFF" -- 亮青色
colour.aliceblue = "F0F8FF" -- 艾利斯兰

colour.purple = "CC1AFF" -- 紫色
colour.darkorchid = "9932CC" -- 暗紫色
colour.mediumpurple = "9370DB" -- 间紫色
colour.mediumorchid = "BA55D3" -- 间紫兰色
colour.violet = "EE82EE" -- 浅紫色
colour.plum = "DDA0DD" -- 洋李色
colour.thistle = "D8BFD8" -- 蓟色
colour.lavender = "E6E6FA" -- 淡紫色


--- hex
---@param hex string hex6位颜色
---@param str string
---@return string
function colour.hex(hex, str)
    if (type(str) == "number") then
        str = tostring(str)
    end
    if (type(str) ~= "string") then
        return ''
    end
    must(type(hex) == "string", "hex@string")
    must(string.len(hex) == 6, "hex length must be 6")
    return "|cff" .. hex .. str .. "|r"
end


--- 插入组合
--[[
    str 一个字符串，替换数值写法 %s,%s,%s
    packHex 最外围两边包裹的6位hex颜色码
    options {
        {"00ccff", "100"}, -- 按顺序替换
        {"ee82ee", "200"},
        {colour.purple, "300"}, -- 可使用函数进行颜色设定，自定义函数也可以只要返回string类型即可
    }
]]
---@param str string
---@param packHex nil|string
---@param options table
---@return string
function colour.format(str, packHex, options)
    if (type(str) ~= "string") then
        return ''
    end
    local poses = string.subAllPos(str, '%%s')
    local lp = #poses
    if (lp == 0) then
        return colour.hex(packHex, str)
    else
        local builder = {}
        if (lp > 0) then
            local idx = 1
            local cs = 1
            for _, p in ipairs(poses) do
                if (p[1] > 1) then
                    if (type(packHex) == "string") then
                        table.insert(builder, colour.hex(packHex, string.sub(str, cs, p[1] - 1)))
                    else
                        table.insert(builder, string.sub(str, cs, p[1] - 1))
                    end
                end
                if (type(options) == "table" and type(options[idx]) == "table") then
                    table.insert(builder, colour.hex(options[idx][1], tostring(options[idx][2])))
                end
                cs = p[2] + 1
                idx = idx + 1
            end
            if (type(packHex) == "string") then
                table.insert(builder, colour.hex(packHex, string.sub(str, cs)))
            else
                table.insert(builder, string.sub(str, cs))
            end
        end
        return table.concat(builder, '')
    end
end