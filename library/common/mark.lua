--- 魔兽自带遮罩
---@class mark
mark = mark or {}

-- 遮罩贴图
mark.texture = {
    white = "ReplaceableTextures\\CameraMasks\\White_mask.blp", --白色迷雾
    black = "ReplaceableTextures\\CameraMasks\\Black_mask.blp", --黑色迷雾
    haze = "ReplaceableTextures\\CameraMasks\\HazeFilter_mask.blp", --薄雾
    groundFog = "ReplaceableTextures\\CameraMasks\\GroundFog_mask.blp", --地面迷雾
    hazeFog = "ReplaceableTextures\\CameraMasks\\HazeAndFogFilter_Mask.blp", --薄雾和迷雾
    diagonalSlash = "ReplaceableTextures\\CameraMasks\\DiagonalSlash_mask.blp", --对角线
    dream = "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", --梦境（四周模糊）
    scope = "ReplaceableTextures\\CameraMasks\\Scope_Mask.blp", --范围
}

--- 自带滤镜
--- 效果特别差，只建议用于纯色迷雾
---@param duration number
---@param bMode number
---@param tex number
---@param red0 number
---@param green0 number
---@param blue0 number
---@param trans0 number
---@param red1 number
---@param green1 number
---@param blue1 number
---@param trans1 number
---@return void
function mark._cinematicFilter(duration, bMode, tex, red0, green0, blue0, trans0, red1, green1, blue1, trans1)
    J.SetCineFilterTexture(tex)
    J.SetCineFilterBlendMode(bMode)
    J.SetCineFilterTexMapFlags(TEXMAP_FLAG_NONE)
    J.SetCineFilterStartUV(0, 0, 1, 1)
    J.SetCineFilterEndUV(0, 0, 1, 1)
    J.SetCineFilterStartColor(red0, green0, blue0, 255 - trans0)
    J.SetCineFilterEndColor(red1, green1, blue1, 255 - trans1)
    J.SetCineFilterDuration(duration)
    J.DisplayCineFilter(true)
end

--- 显示一个遮罩
---@param path string 贴图路径(看上面mark.texture) 512x256 blp
---@param duration number 持续时间，默认3秒，转帧执行
---@param red number 取值范围[0-255]
---@param green number 取值范围[0-255]
---@param blue number 取值范围[0-255]
---@return void
function mark.display(path, duration, red, green, blue)
    async.must()
    if (nil ~= path) then
        red = red or 255
        green = green or 255
        blue = blue or 255
        local frame = 60 * math.trunc(duration or 3, 2)
        mark._cinematicFilter(0.50, BLEND_MODE_ADDITIVE, path, red, green, blue, 255, red, green, blue, 0)
        async.setTimeout(frame, function()
            mark._cinematicFilter(0.50, BLEND_MODE_ADDITIVE, path, red, green, blue, 0, red, green, blue, 255)
        end)
    end
end