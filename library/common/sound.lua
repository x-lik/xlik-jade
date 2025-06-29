--- 声音管理
---@class sound
sound = sound or {}

--- 当前播放BGM
sound._curBgm = sound._curBgm or nil

--- 音效通道类型
local m_sc = Mapping("soundChannel")
sound.channel = {
    normal = m_sc:set(0, "普通"),
    selection = m_sc:set(1, "单位选择"),
    confirm = m_sc:set(2, "单位确认"),
    move = m_sc:set(3, "单位移动"),
    ready = m_sc:set(4, "单位准备"),
    combat = m_sc:set(5, "战斗"),
    error = m_sc:set(6, "错误"),
    music = m_sc:set(7, "音乐"),
    ui = m_sc:set(8, "用户界面"),
    patrol = m_sc:set(9, "循环移动"),
    env = m_sc:set(10, "循环环境"),
    animate = m_sc:set(11, "动画"),
    construct = m_sc:set(12, "建筑"),
    spell = m_sc:set(13, "出生"),
    flame = m_sc:set(14, "火焰"),
}

--- 检测是否属于有效的单位核心
---@param value table sound.channel.*
---@return boolean
function sound.isValidChannel(value)
    return isMapping(value, m_sc._kind)
end

--- 修改音频播放通道
---@see sound#channel
---@param voice number 音频handle
---@param channel number|MappingValue 数字或通道类型，参考sound.channel.*
---@return void
function sound.setChannel(voice, channel)
    if (sound.isValidChannel(channel)) then
        channel = channel.value
    end
    J.SetSoundChannel(voice, channel)
end

--- 播放vcm音效
---@param alias string
---@return void
function sound.vcm(alias)
    local v = japi.AssetsVcm(alias)
    if (type(v) == "number" and v > 0) then
        J.StartSound(v)
    end
end

--- 播放v3d音效
---@param alias string
---@return void
function sound.v3d(alias)
    sync.must()
    local v = japi.AssetsV3d(alias)
    if (type(v) == "number" and v > 0) then
        J.StartSound(v)
    end
end

--- 对单位播放v3d音效
---@param alias string
---@param targetUnit Unit
---@return void
function sound.v3dUnit(alias, targetUnit)
    sync.must()
    must(class.isObject(targetUnit, UnitClass), "targetUnit@Unit")
    local v = japi.AssetsV3d(alias)
    if (type(v) == "number" and v > 0) then
        J.AttachSoundToUnit(v, targetUnit:handle())
        J.StartSound(v)
    end
end

--- 对坐标位置播放v3d音效
---@param alias string
---@param x number
---@param y number
---@param z number
---@return void
function sound.v3dXYZ(alias, x, y, z)
    sync.must()
    local v = japi.AssetsV3d(alias)
    if (type(v) == "number" and v > 0) then
        J.SetSoundPosition(v, x, y, z)
        J.StartSound(v)
    end
end

--- 播放vwp(武器打击)音效
--- wp音效还可以配置与3d一致的音效，但其播放频繁，建议武器打击音最好是在外编辑好
--- 如若需要动态配置打击音参数，可参考上面的v3dOptions
---@param sourceUnit Unit
---@param targetUnit Unit 目标单位（一般指被砍击那个单位）
---@return void
function sound.vwp(sourceUnit, targetUnit)
    sync.must()
    must(class.isObject(sourceUnit, UnitClass), "sourceUnit@Unit")
    must(class.isObject(targetUnit, UnitClass), "targetUnit@Unit")
    local v = japi.AssetsVwp(sourceUnit, targetUnit)
    if (type(v) == "number" and v > 0) then
        J.AttachSoundToUnit(v, targetUnit:handle())
        J.StartSound(v)
    end
end

--- 获取当前播放的bgm
---@return string|nil
function sound.getBgmCur()
    return sound._curBgm
end

--- 播放bgm音乐
--- 你可以使用此方法播放原生音乐，如：sound.bgm("Sound\\Music\\mp3Music\\ArthasTheme.mp3")
--- 将尝试从japi数据中自动获取配置的音量，默认播放100%音量
---@param musicAlias string
---@return void
function sound.bgm(musicAlias)
    sync.must()
    local src, vol = japi.AssetsBgm(musicAlias)
    if (src == sound._curBgm) then
        return
    end
    J.StopMusic(true)
    sound._curBgm = src
    time.setTimeout(3.3, function()
        J.SetMusicVolume(vol)
        J.PlayMusic(sound._curBgm)
    end)
end

--- 停止bgm
---@return void
function sound.bgmStop()
    sync.must()
    J.StopMusic(true)
end