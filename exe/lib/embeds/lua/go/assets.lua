function assets_selection(typeName)
    if (type(typeName) == "string") then
        GO_RESULT.selection = string.trim(typeName)
    end
end

function assets_font(ttfName)
    if (type(ttfName) == "string") then
        GO_RESULT.font = string.trim(ttfName)
    end
end

function assets_loading(tga)
    if (type(tga) == "string") then
        GO_RESULT.loading = string.trim(tga)
    end
end

function assets_preview(tga)
    if (type(tga) == "string") then
        GO_RESULT.preview = string.trim(tga)
    end
end

function assets_terrain(tga)
    if (type(tga) == "string") then
        GO_RESULT.terrain = string.trim(tga)
    end
end

function assets_image(path, alias)
    if (type(path) == "string") then
        path = string.trim(path)
        alias = alias or path
        table.insert(GO_RESULT.image, { path, alias })
    end
end

function assets_model(path, alias)
    if (type(path) == "string") then
        path = string.trim(path)
        alias = alias or path
        table.insert(GO_RESULT.model, { path, alias })
    end
end

function assets_bgm(path, alias, volume)
    if (type(path) == "string") then
        path = string.trim(path)
        alias = alias or path
        volume = volume or 1.00
        volume = math.max(0.01, volume)
        volume = math.min(1.00, volume)
        table.insert(GO_RESULT.bgm, { path, alias, tostring(volume) })
    end
end

function assets_vcm(path, alias, volume)
    if (type(path) == "string") then
        path = string.trim(path)
        alias = alias or path
        volume = volume or 1.00
        volume = math.max(0.01, volume)
        volume = math.min(1.00, volume)
        table.insert(GO_RESULT.vcm, { path, alias, tostring(volume) })
    end
end

function assets_v3d(path, alias, volume)
    if (type(path) == "string") then
        path = string.trim(path)
        alias = alias or path
        volume = volume or 1.00
        volume = math.max(0.01, volume)
        volume = math.min(1.00, volume)
        table.insert(GO_RESULT.v3d, { path, alias, tostring(volume) })
    end
end

function assets_vwp(name)
    if (type(name) == "string") then
        name = string.trim(name)
        table.insert(GO_RESULT.vwp, name)
    end
end

function assets_ui(kit)
    if (kit) then
        table.insert(GO_RESULT.ui, kit)
    end
end

function assets_speech_extra(_v)
    return _v
end

function assets_speech(name, extra)
    if (nil ~= name) then
        name = string.trim(name)
        local v = {
            _xlik = 1,
            weapsOn = 1,
            file = ".mdl",
            unitSound = name,
            collision = 32,
            Name = name .. "|D",
            abilList = "AInv",
            canFlee = 1,
        }
        slk_unit(v)
        if (type(extra) == "table") then
            for k, e in pairx(extra) do
                if (type(e) == "table") then
                    local ve = {}
                    for k2, v2 in pairs(v) do
                        ve[k2] = v2
                    end
                    for k2, v2 in pairs(e) do
                        ve[k2] = v2
                    end
                    ve.unitSound = name
                    ve.Name = name .. "|EX|" .. k
                    ve.canFlee = ve.canFlee or 1
                    local abilList = { "AInv" }
                    if (type(ve.abilList) == "string") then
                        for _, a in ipairs(string.explode(',', ve.abilList)) do
                            abilList[#abilList + 1] = a
                        end
                    end
                    ve.abilList = table.concat(abilList, ',')
                    slk_unit(ve)
                end
            end
        end
    end
end