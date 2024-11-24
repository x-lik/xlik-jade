--- 选择圈
--- 只支持组件包
---@param typeName string
---@return void
function assets_selection(typeName) end

--- 字体
--- 只支持assets外置资源
--- 只支持ttf文件，带不带后缀名都可以
---@param ttfName string
---@return void
function assets_font(ttfName) end

--- 载入图
--- 只支持assets外置资源
--- 只支持tga文件，单文件形式必带后缀名，目录形式不带后缀名
---@param tga string
---@return void
function assets_loading(tga) end

--- 预览图
--- 只支持组件包
--- 只支持tga文件，带不带后缀名都可以
---@param tga string
---@return void
function assets_preview(tga) end

--- 地形贴图
--- 只支持组件包
--- 包内贴图一般支持blp,tga文件，此格式不会对其进行检测
--- 默认为""空字符串则是不使用，new项目中自带设为xlik组件
--- 提示：使用你的自定义地形贴图组件，需要修改WE地形设置配合，如命令xlik.exe we demo
---@param tga string
---@return void
function assets_terrain(tga) end

--- 图片
--- 一般不需要放置在war3mapUI的额外图片资源都可以放在这里
--- 支持tga、blp文件
--- 优先取tga后缀，blp文件必带后缀名
--- 支持外部资源，也就是来自assets资源
--- 支持原生资源路径
--- 支持项目资源，放置在项目 w3x/resource 下的加载文件
---@param path string
---@param alias string|nil
---@return void
function assets_image(path, alias) end

--- 模型
--- 自动贴图，贴图路径必须 war3mapTextures 开头，文件放入 assets/war3mapTextures 内
--- 支持 mdx 文件及 mdl 路径
--- 支持外部资源，也就是来自assets资源
--- 支持原生资源路径
--- 支持项目资源，放置在项目 w3x/resource 下的加载文件
---@param path string
---@param alias string|nil
---@return void
function assets_model(path, alias) end

--- 声音 - BGM
--- 只支持 wav、mp3（mp3建议使用：48000HZ 320K）
--- 支持外部资源，也就是来自assets资源
--- 支持原生资源，以Sound开头的路径
--- 支持项目资源，放置在项目 w3x/resource 下的加载文件
---@param path string 路径中的后缀名可写可不写，完整路径建议写上，不写预设为 mp3
---@param alias string|nil
---@param volume number 音量0.01·1.00，默认1.00
---@return void
function assets_bgm(path, alias, volume) end

--- 声音 - VCM
--- 只支持 wav、mp3（mp3建议使用：48000HZ 192K 单通道）
--- 支持外部资源，也就是来自assets资源
--- 支持原生资源，以Sound开头的路径
--- 支持项目资源，放置在项目 w3x/resource 下的加载文件
---@param path string
---@param alias string|nil
---@param volume number 音量0.01·1.00，默认1.00
---@return void
function assets_vcm(path, alias, volume) end

--- 声音 - V3D
--- 只支持 wav、mp3（mp3建议使用：48000HZ 192K 单通道）
--- 支持外部资源，也就是来自assets资源
--- 支持原生资源，以Sound开头的路径
--- 支持项目资源，放置在项目 w3x/resource 下的加载文件
---@param path string
---@param alias string|nil
---@param volume number 音量0.01·1.00，默认1.00
---@return void
function assets_v3d(path, alias, volume) end

--- 声音 - VWP
--- 配置武器打击音，只支持yaml
--- 参考已有的 assets/war3mapVwp 配置写法
---@param name string
---@return void
function assets_vwp(name) end

--- UI套件
--- 只支持套件形式，需按要求构建
--- 套件内可放置独立的assets资源，支持 wav、mp3、blp、tga、mdx
--- 参考已有的 assets/war3mapUI 套件写法
---@param kit string
---@return void
function assets_ui(kit) end

--- speech参数提示
---@param _v slkUnitData
---@return slkUnitData
function assets_speech_extra(_v)
    return _v
end

--- 只支持原生单位语音
--- 注意此数据无别称
---@param name string
---@param extra table<string,slkUnitData>
---@return void
function assets_speech(name, extra)
    if (nil ~= name) then
        name = string.trim(name)
        slk_unit({})
        LK_SPEECH[name] = true
        if (type(extra) == "table") then
            for _, e in pairx(extra) do
                if (type(e) == "table") then
                    slk_unit({})
                end
            end
        end
    end
end

---@protected
---@param kind string
---@vararg any
---@return void
function assets_load(kind, ...)
    local params = { ... }
    if (kind == "font") then
        japi._assets[kind] = params[1]
    elseif (kind == "image" or kind == "model") then
        if (nil == japi._assets[kind]) then
            japi._assets[kind] = {}
        end
        japi._assets[kind][params[1]] = params[2]
    elseif (kind == "bgm") then
        if (nil == japi._assets[kind]) then
            japi._assets[kind] = {}
        end
        japi._assets[kind][params[1]] = { params[2], params[4] }
    elseif (kind == "vcm") then
        if (nil == japi._assets[kind]) then
            japi._assets[kind] = {}
        end
        local h = J.CreateSound(params[2], false, false, false, 10, 10, "DefaultEAXON")
        J.HandleRef(h)
        J.SetSoundDuration(h, params[3])
        J.SetSoundVolume(h, params[4])
        japi._assets[kind][params[1]] = h
    elseif (kind == "v3d") then
        if (nil == japi._assets[kind]) then
            japi._assets[kind] = {}
        end
        local k = params[1]
        if (nil == japi._assets[kind][k]) then
            japi._assets[kind][k] = { i = 1, h = {} }
        end
        for _ = 1, 3 do
            local h = J.CreateSound(params[2], false, true, true, 10, 10, "DefaultEAXON")
            J.HandleRef(h)
            J.SetSoundDuration(h, params[3])
            J.SetSoundVolume(h, params[4])
            table.insert(japi._assets[kind][k].h, h)
        end
    elseif (kind == "vwp") then
        if (nil == japi._assets[kind]) then
            japi._assets[kind] = {}
        end
        local k = params[1]
        if (nil == japi._assets[kind][k]) then
            japi._assets[kind][k] = { i = 1, h = {} }
        end
        for _ = 1, 5 do
            for j = 2, #params, 1 do
                local v = params[j]
                local h = J.CreateSound(v[1], false, true, true, 10, 10, "CombatSoundsEAX")
                J.HandleRef(h)
                J.SetSoundDuration(h, v[2])
                table.insert(japi._assets[kind][k].h, h)
            end
        end
    elseif (kind == "ui") then
        if (nil == japi._assets[kind]) then
            japi._assets[kind] = {}
        end
        if (nil == japi._assets[kind][params[1]]) then
            japi._assets[kind][params[1]] = {}
        end
        japi._assets[kind][params[1]][params[2]] = params[3]
    end
end