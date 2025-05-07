--- 地形，修改编辑大地图上纹理的方法
---@class terrain
terrain = terrain or {}

-- 地表贴图类型
local t = { _type = "terrain" }
terrain.kind = {
    -- 地形类型（这里只写默认的16个，如果你改动了地形，请自行补充）
    -- 对应地形样式取决于we内配置的16个样式
    lords_dirt = setmetatable({ value = J.C2I("Ldrt"), label = "洛丹伦(夏) 泥地 [泥土]" }, { __index = t }),
    lords_dirtrough = setmetatable({ value = J.C2I("Ldro"), label = "洛丹伦(夏) 坑洼的泥土 [遗迹地砖]" }, { __index = t }),
    lords_dirtgrass = setmetatable({ value = J.C2I("Ldrg"), label = "洛丹伦(夏) 草色泥土 [沙地]" }, { __index = t }),
    lords_rock = setmetatable({ value = J.C2I("Lrok"), label = "洛丹伦(夏) 岩石 [黑冰]" }, { __index = t }),
    lords_grass = setmetatable({ value = J.C2I("Lgrs"), label = "洛丹伦(夏) 草地 [白雪]" }, { __index = t }),
    lords_grassdark = setmetatable({ value = J.C2I("Lgrd"), label = "洛丹伦(夏) 深色草地 [森林]" }, { __index = t }),
    city_dirtrough = setmetatable({ value = J.C2I("Ydtr"), label = "城邦 坑洼的泥土 [秋草]" }, { __index = t }),
    city_blackmarble = setmetatable({ value = J.C2I("Yblm"), label = "城邦 黑色大理石 [黄土]" }, { __index = t }),
    city_bricktiles = setmetatable({ value = J.C2I("Ybtl"), label = "城邦 砖 [红色地砖]" }, { __index = t }),
    city_roundtiles = setmetatable({ value = J.C2I("Yrtl"), label = "城邦 圆形地形 [火焰]" }, { __index = t }),
    city_grass = setmetatable({ value = J.C2I("Ygsb"), label = "城邦 草地 [青草]" }, { __index = t }),
    city_grasstrim = setmetatable({ value = J.C2I("Yhdg"), label = "城邦 平整草地 [败草]" }, { __index = t }),
    city_whitemarble = setmetatable({ value = J.C2I("Ywmb"), label = "城邦 白色大理石 [熔岩]" }, { __index = t }),
    dalaran_dirtrough = setmetatable({ value = J.C2I("Xdtr"), label = "达拉然 坑洼的泥土 [荒地]" }, { __index = t }),
    dalaran_blackmarble = setmetatable({ value = J.C2I("Xblm"), label = "达拉然 黑色大理石 [藤蔓]" }, { __index = t }),
    dalaran_bricktiles = setmetatable({ value = J.C2I("Xbtl"), label = "达拉然 砖 [蓝冰]" }, { __index = t }),
}

--- 检测是否有效的并已经备注的类型
--- 此方法并不能判定所有地形是否有效，你可以补充terrain.kind达到检测所有的范围
---@param value table
---@return boolean
function terrain.isValid(value)
    return type(value) == "table" and value._type == "terrain"
end

--- 设置水颜色
---@param red number 取值范围[0-255]
---@param green number 取值范围[0-255]
---@param blue number 取值范围[0-255]
---@param alpha number 取值范围[0-255]
---@return void
function terrain.setWaterColor(red, green, blue, alpha)
    J.SetWaterBaseColor(red, green, blue, alpha)
end

--- 获取x，y坐标的地形地表贴图类型ID
---@param x number
---@param y number
---@return number
function terrain.getKind(x, y)
    return J.GetTerrainType(x, y)
end

--- 设置x，y坐标的地形地表贴图类型
---@param x number
---@param y number
---@param kind number 可以使用数字ID或terrain.kind，自动转为number
---@param radius number 默认128，改变的半径范围，实际会转为刷子大小，1刷子等于128
---@param shape number 默认0，0圆形|1方形
---@param style number 默认-1，随机样式
---@return void
function terrain.setKind(x, y, kind, radius, shape, style)
    if (terrain.isValid(kind)) then
        kind = kind.value
    end
    radius = radius or 128
    radius = math.floor(radius / 128)
    if (radius < 1) then
        return
    end
    J.SetTerrainType(x, y, kind, style or -1, radius, shape or 0)
end

--- 是否某类型
---@see terrain#kind
---@param x number
---@param y number
---@param whichKind number terrain.kind
---@return boolean
function terrain.isKind(x, y, whichKind)
    if (terrain.isValid(whichKind)) then
        whichKind = whichKind.value
    end
    return whichKind == terrain.getKind(x, y)
end

--- 为玩家设置x，y坐标的荒芜地表
---@param whichPlayer Player
---@param enable boolean true添加，false消除
---@param x number
---@param y number
---@param radius number 小于1无效
---@return void
function terrain.setBlight(whichPlayer, enable, x, y, radius)
    must(class.isObject(whichPlayer, PlayerClass), "whichPlayer@Player")
    must(type(enable) == "boolean", "enable@boolean")
    if (radius < 1) then
        return
    end
    J.SetBlight(whichPlayer:handle(), x, y, radius, enable)
end

--- 为玩家设置区域的荒芜地表
--- 会创建区域
---@param whichPlayer Player
---@param enable boolean true添加，false消除
---@param whichRegion Region
---@return void
function terrain.setBlightRegion(whichPlayer, enable, whichRegion)
    must(class.isObject(whichPlayer, PlayerClass), "whichPlayer@Player")
    must(type(enable) == "boolean", "enable@boolean")
    must(class.isObject(whichRegion, RegionClass), "whichRegion@Region")
    J.SetBlightRect(whichPlayer:handle(), whichRegion:handle(), enable)
end

--- 是否荒芜地表
---@param x number
---@param y number
---@return boolean
function terrain.isBlighted(x, y)
    return J.IsPointBlighted(x, y)
end

--- 是否可通行
---@param x number
---@param y number
---@return boolean
function terrain.isWalkable(x, y)
    return not J.IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
end

--- 是否飞行可通行
---@param x number
---@param y number
---@return boolean
function terrain.isWalkableFly(x, y)
    return not J.IsTerrainPathable(x, y, PATHING_TYPE_FLYABILITY)
end

--- 是否水(海)面可通行
---@param x number
---@param y number
---@return boolean
function terrain.isWalkableWater(x, y)
    return not J.IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY)
end

--- 是否两栖可通行
---@param x number
---@param y number
---@return boolean
function terrain.isWalkableAmphibious(x, y)
    return not J.IsTerrainPathable(x, y, PATHING_TYPE_AMPHIBIOUSPATHING)
end

--- 是否荒芜可通行
---@param x number
---@param y number
---@return boolean
function terrain.isWalkableBlight(x, y)
    return not J.IsTerrainPathable(x, y, PATHING_TYPE_BLIGHTPATHING)
end

--- 是否建造可通行
---@param x number
---@param y number
---@return boolean
function terrain.isWalkableBuild(x, y)
    return not J.IsTerrainPathable(x, y, PATHING_TYPE_BUILDABILITY)
end

--- 是否采集时可通行
---@param x number
---@param y number
---@return boolean
function terrain.isWalkablePeonHarvest(x, y)
    return not J.IsTerrainPathable(x, y, PATHING_TYPE_PEONHARVESTPATHING)
end

--- 是否处在水面
---@param x number
---@param y number
---@return boolean
function terrain.isWater(x, y)
    return terrain.isWalkableWater(x, y)
end

--- 是否处于地面
--- 这里实际上判断的是非水区域
---@param x number
---@param y number
---@return boolean
function terrain.isGround(x, y)
    return not terrain.isWalkableWater(x, y)
end