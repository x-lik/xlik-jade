--- 资源初始化
LK_ASSETS_INIT()

--- 预读技能
local upr = J.Globals["prevReadToken"]
for _, v in ipairs(LK_SLK_ID_SIGHT_MAP) do
    J.UnitAddAbility(upr, LK_SLK_ID_SIGHT_ADD[v])
    J.UnitAddAbility(upr, LK_SLK_ID_SIGHT_SUB[v])
    J.UnitRemoveAbility(upr, LK_SLK_ID_SIGHT_ADD[v])
    J.UnitRemoveAbility(upr, LK_SLK_ID_SIGHT_SUB[v])
end
J.RemoveUnit(upr)
J.HandleUnRef(upr)

--- 只支持自定义UI
japi.EnableWideScreen(true)
japi.LoadToc("UI\\xlik.toc")

--- 默认区域
local wb = J.GetWorldBounds()
J.HandleRef(wb)
local w = J.GetRectMaxX(wb) - J.GetRectMinX(wb)
local h = J.GetRectMaxY(wb) - J.GetRectMinY(wb)
local x = J.GetRectCenterX(wb)
local y = J.GetRectCenterY(wb)
RegionWorld = Region("world", "square", x, y, w, h)
RegionWorld._handle = wb

w = (J.GetCameraBoundMaxX() + J.GetCameraMargin(CAMERA_MARGIN_RIGHT)) - (J.GetCameraBoundMinX() - J.GetCameraMargin(CAMERA_MARGIN_LEFT))
h = (J.GetCameraBoundMaxY() + J.GetCameraMargin(CAMERA_MARGIN_TOP)) - (J.GetCameraBoundMinY() - J.GetCameraMargin(CAMERA_MARGIN_BOTTOM))
x = (J.GetCameraBoundMinX() - J.GetCameraMargin(CAMERA_MARGIN_LEFT)) + w / 2
y = (J.GetCameraBoundMinY() - J.GetCameraMargin(CAMERA_MARGIN_BOTTOM)) + h / 2
RegionPlayable = Region("playable", "square", x, y, w, h)

w = J.GetCameraBoundMaxX() - J.GetCameraBoundMinX()
h = J.GetCameraBoundMaxY() - J.GetCameraBoundMinY()
x = J.GetCameraBoundMinX() + w / 2
y = J.GetCameraBoundMinY() + h / 2
RegionCamera = Region("camera", "square", x, y, w, h)

--- 玩家初始化
for i = 1, BJ_MAX_PLAYER_SLOTS, 1 do Player(i) end
PlayerAggressive = Player(PLAYER_NEUTRAL_AGGRESSIVE + 1)
PlayerVictim = Player(PLAYER_NEUTRAL_VICTIM + 1)
PlayerExtra = Player(PLAYER_NEUTRAL_EXTRA + 1)
PlayerPassive = Player(PLAYER_NEUTRAL_PASSIVE + 1)

--- 客户端尺寸
japi._clientHeight = japi.DZ_GetClientHeight()
japi._clientWidth = japi.DZ_GetClientWidth()

--- 异步随机池
for i = 1, BJ_MAX_PLAYER_SLOTS do
    japi._asyncRandPool.d[i] = {}
    japi._asyncRandPool.i[i] = {}
end

--- ui
japi._uiAdaptive = Array()
japi._uiEsc = Array()