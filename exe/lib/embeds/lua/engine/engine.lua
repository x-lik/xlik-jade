-- 加载lua-engine
J = {}
J.Runtime = require("jass.runtime")
J.Console = require("jass.console")
J.Debug = require("jass.debug")
J.Common = require("jass.common")
J.Globals = require("jass.globals")
J.Slk = require("jass.slk")
J.Japi = require("jass.japi")
J.HandleRef = function(h) J.Debug["handle_ref"](h) end
J.HandleUnRef = function(h) J.Debug["handle_unref"](h) end
J.HandleMax = function() return J.Debug["handlemax"]() end
J.HandleDef = function(...) return J.Debug["handledef"](...) end
--- abilityIdString string
---@type fun(abilityIdString:string):number int
J.AbilityId = J.Common["AbilityId"]
--- abilityId number int
---@type fun(abilityId:number):string
J.AbilityId2String = J.Common["AbilityId2String"]
--- 增加经验值 [R]
--- 增加[某个英雄][Quantity]点经验值,[显示/隐藏]升级动画
--- 经验值不能倒退.
--- whichHero number unit
--- xpToAdd number int
--- showEyeCandy boolean
---@type fun(whichHero:number,xpToAdd:number,showEyeCandy:boolean):void
J.AddHeroXP = J.Common["AddHeroXP"]
--- whichWidget number widget
--- red number int
--- green number int
--- blue number int
--- alpha number int
---@type fun(whichWidget:number,red:number,green:number,blue:number,alpha:number):void
J.AddIndicator = J.Common["AddIndicator"]
--- 添加物品(所有市场)
--- 添加[物品类型]到所有市场并设置库存量:[Count]最大库存量:[Max]
--- 影响所有拥有'出售物品'技能的单位.
--- itemId number int
--- currentStock number int
--- stockMax number int
---@type fun(itemId:number,currentStock:number,stockMax:number):void
J.AddItemToAllStock = J.Common["AddItemToAllStock"]
--- 添加物品(指定市场)
--- 添加[物品类型]到[Marketplace]并设置库存量:[Count]最大库存量:[Max]
--- 只影响有'出售物品'技能的单位.
--- whichUnit number unit
--- itemId number int
--- currentStock number int
--- stockMax number int
---@type fun(whichUnit:number,itemId:number,currentStock:number,stockMax:number):void
J.AddItemToStock = J.Common["AddItemToStock"]
--- 创建闪电效果
--- 创建一道[Type]闪电效果,从[坐标]到[坐标]
--- codeName string
--- checkVisibility boolean
--- x1 number
--- y1 number
--- x2 number
--- y2 number
---@type fun(codeName:string,checkVisibility:boolean,x1:number,y1:number,x2:number,y2:number):number lightning
J.AddLightning = J.Common["AddLightning"]
--- codeName string
--- checkVisibility boolean
--- x1 number
--- y1 number
--- z1 number
--- x2 number
--- y2 number
--- z2 number
---@type fun(codeName:string,checkVisibility:boolean,x1:number,y1:number,z1:number,x2:number,y2:number,z2:number):number lightning
J.AddLightningEx = J.Common["AddLightningEx"]
--- 增加科技等级
--- 增加[玩家]的[科技]科技[整数]级
--- 科技等级不能倒退。
--- whichPlayer number player
--- techid number int
--- levels number int
---@type fun(whichPlayer:number,techid:number,levels:number):void
J.AddPlayerTechResearched = J.Common["AddPlayerTechResearched"]
--- 增加黄金储量
--- 增加[Quantity]黄金储量给[金矿]
--- 使用负数来减少黄金储量.
--- whichUnit number unit
--- amount number int
---@type fun(whichUnit:number,amount:number):void
J.AddResourceAmount = J.Common["AddResourceAmount"]
--- modelName string
--- x number
--- y number
---@type fun(modelName:string,x:number,y:number):number effect
J.AddSpecialEffect = J.Common["AddSpecialEffect"]
--- 创建特效(指定点)
--- 在[指定点]创建特效:[Model File]
--- modelName string
--- where number location
---@type fun(modelName:string,where:number):number effect
J.AddSpecialEffectLoc = J.Common["AddSpecialEffectLoc"]
--- modelName string
--- targetWidget number widget
--- attachPointName string
---@type fun(modelName:string,targetWidget:number,attachPointName:string):number effect
J.AddSpecialEffectTarget = J.Common["AddSpecialEffectTarget"]
--- abilityString string
--- t any effecttype
--- x number
--- y number
---@type fun(abilityString:string,t:any,x:number,y:number):number effect
J.AddSpellEffect = J.Common["AddSpellEffect"]
--- abilityId number int
--- t any effecttype
--- x number
--- y number
---@type fun(abilityId:number,t:any,x:number,y:number):number effect
J.AddSpellEffectById = J.Common["AddSpellEffectById"]
--- abilityId number int
--- t any effecttype
--- where number location
---@type fun(abilityId:number,t:any,where:number):number effect
J.AddSpellEffectByIdLoc = J.Common["AddSpellEffectByIdLoc"]
--- abilityString string
--- t any effecttype
--- where number location
---@type fun(abilityString:string,t:any,where:number):number effect
J.AddSpellEffectLoc = J.Common["AddSpellEffectLoc"]
--- modelName string
--- t any effecttype
--- targetWidget number widget
--- attachPoint string
---@type fun(modelName:string,t:any,targetWidget:number,attachPoint:string):number effect
J.AddSpellEffectTarget = J.Common["AddSpellEffectTarget"]
--- abilityId number int
--- t any effecttype
--- targetWidget number widget
--- attachPoint string
---@type fun(abilityId:number,t:any,targetWidget:number,attachPoint:string):number effect
J.AddSpellEffectTargetById = J.Common["AddSpellEffectTargetById"]
--- 添加/删除 单位动画附加名 [R]
--- 给[单位]附加动作[Tag],状态为[Add/Remove]
--- 比如恶魔猎手添加'alternate'会显示为恶魔形态;农民添加'gold'则为背负黄金形态.
--- whichUnit number unit
--- animProperties string
--- add boolean
---@type fun(whichUnit:number,animProperties:string,add:boolean):void
J.AddUnitAnimationProperties = J.Common["AddUnitAnimationProperties"]
--- 添加单位(所有市场)
--- 添加[单位类型]到所有市场并设置库存量:[Count]最大库存量:[Max]
--- 影响所有拥有'出售单位'技能的单位.
--- unitId number int
--- currentStock number int
--- stockMax number int
---@type fun(unitId:number,currentStock:number,stockMax:number):void
J.AddUnitToAllStock = J.Common["AddUnitToAllStock"]
--- 添加单位(指定市场)
--- 添加[单位类型]到[Marketplace]并设置库存量:[Count]最大库存量:[Max]
--- 只影响有'出售单位'技能的单位.
--- whichUnit number unit
--- unitId number int
--- currentStock number int
--- stockMax number int
---@type fun(whichUnit:number,unitId:number,currentStock:number,stockMax:number):void
J.AddUnitToStock = J.Common["AddUnitToStock"]
--- where number rect
--- effectID number int
---@type fun(where:number,effectID:number):number weathereffect
J.AddWeatherEffect = J.Common["AddWeatherEffect"]
--- whichField any camerafield
--- offset number
--- duration number
---@type fun(whichField:any,offset:number,duration:number):void
J.AdjustCameraField = J.Common["AdjustCameraField"]
--- 绑定单位
--- 将[3D音效]绑定到[单位]
--- 该动作仅用于3D音效.
--- soundHandle number sound
--- whichUnit number unit
---@type fun(soundHandle:number,whichUnit:number):void
J.AttachSoundToUnit = J.Common["AttachSoundToUnit"]
--- whichPlayer number player
---@type fun(whichPlayer:number):void
J.CachePlayerHeroData = J.Common["CachePlayerHeroData"]
--- 设置镜头平滑参数
--- 设置镜头平滑参数为[Factor]
--- 数值越大,镜头转换越平滑.
--- factor number
---@type fun(factor:number):void
J.CameraSetSmoothingFactor = J.Common["CameraSetSmoothingFactor"]
--- mag number
--- velocity number
---@type fun(mag:number,velocity:number):void
J.CameraSetSourceNoise = J.Common["CameraSetSourceNoise"]
--- 摇晃镜头源(所有玩家) [R]
--- 摇晃玩家的镜头源, 摇晃幅度:[Magnitude]速率:[Velocity]摇晃方式:[方式]
--- 使用'镜头 - 重置镜头'或设置摇晃幅度和速率为0来停止摇晃.
--- mag number
--- velocity number
--- vertOnly boolean
---@type fun(mag:number,velocity:number,vertOnly:boolean):void
J.CameraSetSourceNoiseEx = J.Common["CameraSetSourceNoiseEx"]
--- mag number
--- velocity number
---@type fun(mag:number,velocity:number):void
J.CameraSetTargetNoise = J.Common["CameraSetTargetNoise"]
--- 摇晃镜头目标(所有玩家) [R]
--- 摇晃玩家的镜头源, 摇晃幅度:[Magnitude]速率:[Velocity]摇晃方式:[方式]
--- 使用'镜头 - 重置镜头'或设置摇晃幅度和速率为0来停止摇晃.
--- mag number
--- velocity number
--- vertOnly boolean
---@type fun(mag:number,velocity:number,vertOnly:boolean):void
J.CameraSetTargetNoiseEx = J.Common["CameraSetTargetNoiseEx"]
--- whichSetup any camerasetup
--- doPan boolean
--- panTimed boolean
---@type fun(whichSetup:any,doPan:boolean,panTimed:boolean):void
J.CameraSetupApply = J.Common["CameraSetupApply"]
--- 应用镜头(所有玩家)(限时) [R]
--- 将[镜头]应用方式设置为[Apply Method],持续[Time]秒
--- whichSetup any camerasetup
--- doPan boolean
--- forceDuration number
---@type fun(whichSetup:any,doPan:boolean,forceDuration:number):void
J.CameraSetupApplyForceDuration = J.Common["CameraSetupApplyForceDuration"]
--- whichSetup any camerasetup
--- zDestOffset number
--- forceDuration number
---@type fun(whichSetup:any,zDestOffset:number,forceDuration:number):void
J.CameraSetupApplyForceDurationWithZ = J.Common["CameraSetupApplyForceDurationWithZ"]
--- whichSetup any camerasetup
--- zDestOffset number
---@type fun(whichSetup:any,zDestOffset:number):void
J.CameraSetupApplyWithZ = J.Common["CameraSetupApplyWithZ"]
--- whichSetup any camerasetup
---@type fun(whichSetup:any):number location
J.CameraSetupGetDestPositionLoc = J.Common["CameraSetupGetDestPositionLoc"]
--- whichSetup any camerasetup
---@type fun(whichSetup:any):number
J.CameraSetupGetDestPositionX = J.Common["CameraSetupGetDestPositionX"]
--- whichSetup any camerasetup
---@type fun(whichSetup:any):number
J.CameraSetupGetDestPositionY = J.Common["CameraSetupGetDestPositionY"]
--- whichSetup any camerasetup
--- whichField any camerafield
---@type fun(whichSetup:any,whichField:any):number
J.CameraSetupGetField = J.Common["CameraSetupGetField"]
--- whichSetup any camerasetup
--- x number
--- y number
--- duration number
---@type fun(whichSetup:any,x:number,y:number,duration:number):void
J.CameraSetupSetDestPosition = J.Common["CameraSetupSetDestPosition"]
--- whichSetup any camerasetup
--- whichField any camerafield
--- value number
--- duration number
---@type fun(whichSetup:any,whichField:any,value:number,duration:number):void
J.CameraSetupSetField = J.Common["CameraSetupSetField"]
--- 切换关卡 [R]
--- 切换到关卡:[Filename]([Show/Skip]计分屏)
--- newLevel string
--- doScoreScreen boolean
---@type fun(newLevel:string,doScoreScreen:boolean):void
J.ChangeLevel = J.Common["ChangeLevel"]
--- 输入作弊码 [R]
--- 输入作弊码:[String]
--- 作弊码只在单机有效.
--- cheatStr string
---@type fun(cheatStr:string):void
J.Cheat = J.Common["Cheat"]
--- level number int
---@type fun(level:number):number int
J.ChooseRandomCreep = J.Common["ChooseRandomCreep"]
--- level number int
---@type fun(level:number):number int
J.ChooseRandomItem = J.Common["ChooseRandomItem"]
--- whichType any itemtype
--- level number int
---@type fun(whichType:any,level:number):number int
J.ChooseRandomItemEx = J.Common["ChooseRandomItemEx"]
---@type fun():number int
J.ChooseRandomNPBuilding = J.Common["ChooseRandomNPBuilding"]
--- 清空背景音乐列表
---@type fun():void
J.ClearMapMusic = J.Common["ClearMapMusic"]
--- 清空选择(所有玩家)
--- 清空所有玩家的选择
--- 使玩家取消选择所有已选单位.
---@type fun():void
J.ClearSelection = J.Common["ClearSelection"]
--- 清空文本信息(所有玩家) [R]
--- 清空玩家屏幕上的文本信息
---@type fun():void
J.ClearTextMessages = J.Common["ClearTextMessages"]
--- 发送AI命令
--- 对[某个玩家]发送AI命令:([命令],[数据])
--- 发送的AI命令将被AI脚本所使用.
--- num number player
--- command number int
--- data number int
---@type fun(num:number,command:number,data:number):void
J.CommandAI = J.Common["CommandAI"]
--- func any code
---@type fun(func:any):function conditionfunc
J.Condition = J.Common["Condition"]
--- i number int
---@type fun(i:number):any aidifficulty
J.ConvertAIDifficulty = J.Common["ConvertAIDifficulty"]
--- i number int
---@type fun(i:number):any alliancetype
J.ConvertAllianceType = J.Common["ConvertAllianceType"]
--- i number int
---@type fun(i:number):any attacktype
J.ConvertAttackType = J.Common["ConvertAttackType"]
--- i number int
---@type fun(i:number):any blendmode
J.ConvertBlendMode = J.Common["ConvertBlendMode"]
--- i number int
---@type fun(i:number):any camerafield
J.ConvertCameraField = J.Common["ConvertCameraField"]
--- i number int
---@type fun(i:number):any damagetype
J.ConvertDamageType = J.Common["ConvertDamageType"]
--- i number int
---@type fun(i:number):any dialogevent
J.ConvertDialogEvent = J.Common["ConvertDialogEvent"]
--- i number int
---@type fun(i:number):any effecttype
J.ConvertEffectType = J.Common["ConvertEffectType"]
--- i number int
---@type fun(i:number):any fgamestate
J.ConvertFGameState = J.Common["ConvertFGameState"]
--- i number int
---@type fun(i:number):any fogstate
J.ConvertFogState = J.Common["ConvertFogState"]
--- i number int
---@type fun(i:number):any gamedifficulty
J.ConvertGameDifficulty = J.Common["ConvertGameDifficulty"]
--- i number int
---@type fun(i:number):any gameevent
J.ConvertGameEvent = J.Common["ConvertGameEvent"]
--- i number int
---@type fun(i:number):any gamespeed
J.ConvertGameSpeed = J.Common["ConvertGameSpeed"]
--- i number int
---@type fun(i:number):any gametype
J.ConvertGameType = J.Common["ConvertGameType"]
--- i number int
---@type fun(i:number):any igamestate
J.ConvertIGameState = J.Common["ConvertIGameState"]
--- i number int
---@type fun(i:number):any itemtype
J.ConvertItemType = J.Common["ConvertItemType"]
--- i number int
---@type fun(i:number):any limitop
J.ConvertLimitOp = J.Common["ConvertLimitOp"]
--- i number int
---@type fun(i:number):any mapcontrol
J.ConvertMapControl = J.Common["ConvertMapControl"]
--- i number int
---@type fun(i:number):any mapdensity
J.ConvertMapDensity = J.Common["ConvertMapDensity"]
--- i number int
---@type fun(i:number):any mapflag
J.ConvertMapFlag = J.Common["ConvertMapFlag"]
--- i number int
---@type fun(i:number):any mapsetting
J.ConvertMapSetting = J.Common["ConvertMapSetting"]
--- i number int
---@type fun(i:number):any mapvisibility
J.ConvertMapVisibility = J.Common["ConvertMapVisibility"]
--- i number int
---@type fun(i:number):any pathingtype
J.ConvertPathingType = J.Common["ConvertPathingType"]
--- i number int
---@type fun(i:number):any placement
J.ConvertPlacement = J.Common["ConvertPlacement"]
--- i number int
---@type fun(i:number):any playercolor
J.ConvertPlayerColor = J.Common["ConvertPlayerColor"]
--- i number int
---@type fun(i:number):any playerevent
J.ConvertPlayerEvent = J.Common["ConvertPlayerEvent"]
--- i number int
---@type fun(i:number):any playergameresult
J.ConvertPlayerGameResult = J.Common["ConvertPlayerGameResult"]
--- i number int
---@type fun(i:number):any playerscore
J.ConvertPlayerScore = J.Common["ConvertPlayerScore"]
--- i number int
---@type fun(i:number):any playerslotstate
J.ConvertPlayerSlotState = J.Common["ConvertPlayerSlotState"]
--- i number int
---@type fun(i:number):any playerstate
J.ConvertPlayerState = J.Common["ConvertPlayerState"]
--- i number int
---@type fun(i:number):any playerunitevent
J.ConvertPlayerUnitEvent = J.Common["ConvertPlayerUnitEvent"]
--- i number int
---@type fun(i:number):any race
J.ConvertRace = J.Common["ConvertRace"]
--- i number int
---@type fun(i:number):any racepreference
J.ConvertRacePref = J.Common["ConvertRacePref"]
--- i number int
---@type fun(i:number):any raritycontrol
J.ConvertRarityControl = J.Common["ConvertRarityControl"]
--- i number int
---@type fun(i:number):any soundtype
J.ConvertSoundType = J.Common["ConvertSoundType"]
--- i number int
---@type fun(i:number):any startlocprio
J.ConvertStartLocPrio = J.Common["ConvertStartLocPrio"]
--- i number int
---@type fun(i:number):any texmapflags
J.ConvertTexMapFlags = J.Common["ConvertTexMapFlags"]
--- i number int
---@type fun(i:number):any unitevent
J.ConvertUnitEvent = J.Common["ConvertUnitEvent"]
--- i number int
---@type fun(i:number):any unitstate
J.ConvertUnitState = J.Common["ConvertUnitState"]
--- i number int
---@type fun(i:number):any unittype
J.ConvertUnitType = J.Common["ConvertUnitType"]
--- i number int
---@type fun(i:number):any version
J.ConvertVersion = J.Common["ConvertVersion"]
--- i number int
---@type fun(i:number):any volumegroup
J.ConvertVolumeGroup = J.Common["ConvertVolumeGroup"]
--- i number int
---@type fun(i:number):any weapontype
J.ConvertWeaponType = J.Common["ConvertWeaponType"]
--- i number int
---@type fun(i:number):number widgetevent
J.ConvertWidgetEvent = J.Common["ConvertWidgetEvent"]
--- 复制存档文件
--- 复制[源文件]并保存为[目标文件]
--- 该动作只在响应'保存/读取进度'时有效,每个事件中最多能用16次.
--- sourceSaveName string
--- destSaveName string
---@type fun(sourceSaveName:string,destSaveName:string):boolean
J.CopySaveGame = J.Common["CopySaveGame"]
--- id number player
--- x number
--- y number
--- face number
---@type fun(id:number,x:number,y:number,face:number):number unit
J.CreateBlightedGoldmine = J.Common["CreateBlightedGoldmine"]
---@type fun():any camerasetup
J.CreateCameraSetup = J.Common["CreateCameraSetup"]
--- whichPlayer number player
--- unitid number int
--- x number
--- y number
--- face number
---@type fun(whichPlayer:number,unitid:number,x:number,y:number,face:number):number unit
J.CreateCorpse = J.Common["CreateCorpse"]
--- objectid number int
--- x number
--- y number
--- face number
--- scale number
--- variation number int
---@type fun(objectid:number,x:number,y:number,face:number,scale:number,variation:number):number destructable
J.CreateDeadDestructable = J.Common["CreateDeadDestructable"]
--- objectid number int
--- x number
--- y number
--- z number
--- face number
--- scale number
--- variation number int
---@type fun(objectid:number,x:number,y:number,z:number,face:number,scale:number,variation:number):number destructable
J.CreateDeadDestructableZ = J.Common["CreateDeadDestructableZ"]
--- 创建失败条件
--- 创建失败条件:[文字]
--- 失败条件会在每个任务中显示.
---@type fun():function defeatcondition
J.CreateDefeatCondition = J.Common["CreateDefeatCondition"]
--- 创建可破坏物
--- 创建[可破坏物类型]在[指定点],面向角度:[Direction]尺寸缩放:[Scale]样式:[Variation]
--- 面向角度采用角度制,0度为正东方向,90度为正北方向. 使用'最后创建的可破坏物'来获取创建的物体.
--- objectid number int
--- x number
--- y number
--- face number
--- scale number
--- variation number int
---@type fun(objectid:number,x:number,y:number,face:number,scale:number,variation:number):number destructable
J.CreateDestructable = J.Common["CreateDestructable"]
--- objectid number int
--- x number
--- y number
--- z number
--- face number
--- scale number
--- variation number int
---@type fun(objectid:number,x:number,y:number,z:number,face:number,scale:number,variation:number):number destructable
J.CreateDestructableZ = J.Common["CreateDestructableZ"]
--- forWhichPlayer number player
--- whichState any fogstate
--- centerx number
--- centerY number
--- radius number
--- useSharedVision boolean
--- afterUnits boolean
---@type fun(forWhichPlayer:number,whichState:any,centerx:number,centerY:number,radius:number,useSharedVision:boolean,afterUnits:boolean):number fogmodifier
J.CreateFogModifierRadius = J.Common["CreateFogModifierRadius"]
--- 创建可见度修正器(圆范围)
--- 创建一个状态为[Enabled/Disabled]的可见度修正器给[某个玩家],设置[Visibility State]在圆心为[指定点]半径为[Radius]的圆范围
--- 会创建可见度修正器.
--- forWhichPlayer number player
--- whichState any fogstate
--- center number location
--- radius number
--- useSharedVision boolean
--- afterUnits boolean
---@type fun(forWhichPlayer:number,whichState:any,center:number,radius:number,useSharedVision:boolean,afterUnits:boolean):number fogmodifier
J.CreateFogModifierRadiusLoc = J.Common["CreateFogModifierRadiusLoc"]
--- 创建可见度修正器(矩形区域)
--- 创建一个状态为[Enabled/Disabled]的可见度修正器给[某个玩家],设置[Visibility State]在[Region]
--- 会创建可见度修正器.
--- forWhichPlayer number player
--- whichState any fogstate
--- where number rect
--- useSharedVision boolean
--- afterUnits boolean
---@type fun(forWhichPlayer:number,whichState:any,where:number,useSharedVision:boolean,afterUnits:boolean):number fogmodifier
J.CreateFogModifierRect = J.Common["CreateFogModifierRect"]
---@type fun():number force
J.CreateForce = J.Common["CreateForce"]
---@type fun():number group
J.CreateGroup = J.Common["CreateGroup"]
--- 创建
--- 使用图像:[某个图像]大小:[Size]创建点:[指定点]Z轴偏移:[Z]图像类型:[Type]
--- 使用'图像 - 设置永久渲染状态'才能显示图像. 创建点作为图像的左下角位置. 该功能存在Bug,会在图像上和右面多出256象素. 所以需要支持Alpha通道的图像且上和右面最后一行像素为透明才能完美显示.
--- file string
--- sizeX number
--- sizeY number
--- sizeZ number
--- posX number
--- posY number
--- posZ number
--- originX number
--- originY number
--- originZ number
--- imageType number int
---@type fun(file:string,sizeX:number,sizeY:number,sizeZ:number,posX:number,posY:number,posZ:number,originX:number,originY:number,originZ:number,imageType:number):number image
J.CreateImage = J.Common["CreateImage"]
--- 创建
--- 新建[物品]在([X],[Y])
--- itemid number int
--- x number
--- y number
---@type fun(itemid:number,x:number,y:number):number item
J.CreateItem = J.Common["CreateItem"]
---@type fun():number itempool
J.CreateItemPool = J.Common["CreateItemPool"]
--- 创建
--- 对[玩家组]创建排行榜,使用标题:[文字]
--- 排行榜不能在地图初始化时显示. 标题为空则不显示标题栏.
---@type fun():number leaderboard
J.CreateLeaderboard = J.Common["CreateLeaderboard"]
--- soundLabel string
--- fadeInRate number int
--- fadeOutRate number int
---@type fun(soundLabel:string,fadeInRate:number,fadeOutRate:number):number sound
J.CreateMIDISound = J.Common["CreateMIDISound"]
--- 创建
--- 创建一个列数为[Columns]行数为[Rows]标题为[文字]的多面板
--- 多面板不能在地图初始化时显示.
---@type fun():number multiboard
J.CreateMultiboard = J.Common["CreateMultiboard"]
--- 创建任务
--- 创建一个[Quest Type]任务,标题:[文字]任务说明:[文字]任务图标:[Icon Path]
---@type fun():number quest
J.CreateQuest = J.Common["CreateQuest"]
---@type fun():number region
J.CreateRegion = J.Common["CreateRegion"]
--- fileName string
--- looping boolean
--- is3D boolean
--- stopwhenoutofrange boolean
--- fadeInRate number int
--- fadeOutRate number int
--- eaxSetting string
---@type fun(fileName:string,looping:boolean,is3D:boolean,stopwhenoutofrange:boolean,fadeInRate:number,fadeOutRate:number,eaxSetting:string):number sound
J.CreateSound = J.Common["CreateSound"]
--- fileName string
--- looping boolean
--- is3D boolean
--- stopwhenoutofrange boolean
--- fadeInRate number int
--- fadeOutRate number int
--- SLKEntryName string
---@type fun(fileName:string,looping:boolean,is3D:boolean,stopwhenoutofrange:boolean,fadeInRate:number,fadeOutRate:number,SLKEntryName:string):number sound
J.CreateSoundFilenameWithLabel = J.Common["CreateSoundFilenameWithLabel"]
--- soundLabel string
--- looping boolean
--- is3D boolean
--- stopwhenoutofrange boolean
--- fadeInRate number int
--- fadeOutRate number int
---@type fun(soundLabel:string,looping:boolean,is3D:boolean,stopwhenoutofrange:boolean,fadeInRate:number,fadeOutRate:number):number sound
J.CreateSoundFromLabel = J.Common["CreateSoundFromLabel"]
---@type fun():number texttag
J.CreateTextTag = J.Common["CreateTextTag"]
---@type fun():number timer
J.CreateTimer = J.Common["CreateTimer"]
--- 创建计时器窗口
--- 为[计时器]创建计时器窗口,标题:[文字]
--- 计时器窗口不能在地图初始化时显示.
--- t number timer
---@type fun(t:number):number timerdialog
J.CreateTimerDialog = J.Common["CreateTimerDialog"]
--- trackableModelPath string
--- x number
--- y number
--- facing number
---@type fun(trackableModelPath:string,x:number,y:number,facing:number):any trackable
J.CreateTrackable = J.Common["CreateTrackable"]
---@type fun():number trigger
J.CreateTrigger = J.Common["CreateTrigger"]
--- 创建地面纹理变化
--- 创建一个地面纹理变化在[指定点],使用图像:[Type]颜色值:([Red]%,[Green]%,[Blue]%) 透明度[Alpha]% ([Enable/Disable]暂停状态,[Enble/Disable]跳过出生动画)
--- 颜色格式为(红,绿,蓝). 透明度100%是不可见的. 使用'地面纹理变化 - 设置永久渲染状态' 来显示创建的纹理变化. 暂停状态表示动画播放完毕后是否继续保留该纹理变化.
--- x number
--- y number
--- name string
--- red number int
--- green number int
--- blue number int
--- alpha number int
--- forcePaused boolean
--- noBirthTime boolean
---@type fun(x:number,y:number,name:string,red:number,green:number,blue:number,alpha:number,forcePaused:boolean,noBirthTime:boolean):any ubersplat
J.CreateUbersplat = J.Common["CreateUbersplat"]
--- id number player
--- unitid number int
--- x number
--- y number
--- face number
---@type fun(id:number,unitid:number,x:number,y:number,face:number):number unit
J.CreateUnit = J.Common["CreateUnit"]
--- id number player
--- unitid number int
--- whichLocation number location
--- face number
---@type fun(id:number,unitid:number,whichLocation:number,face:number):number unit
J.CreateUnitAtLoc = J.Common["CreateUnitAtLoc"]
--- id number player
--- unitname string
--- whichLocation number location
--- face number
---@type fun(id:number,unitname:string,whichLocation:number,face:number):number unit
J.CreateUnitAtLocByName = J.Common["CreateUnitAtLocByName"]
--- whichPlayer number player
--- unitname string
--- x number
--- y number
--- face number
---@type fun(whichPlayer:number,unitname:string,x:number,y:number,face:number):number unit
J.CreateUnitByName = J.Common["CreateUnitByName"]
---@type fun():number unitpool
J.CreateUnitPool = J.Common["CreateUnitPool"]
--- whichPlayer number player
--- toWhichPlayers number force
--- flag boolean
---@type fun(whichPlayer:number,toWhichPlayers:number,flag:boolean):void
J.CripplePlayer = J.Common["CripplePlayer"]
--- 降低技能等级 [R]
--- 使[单位]的[技能]等级降低1级
--- 改变死亡单位的光环技能会导致魔兽崩溃.
--- whichUnit number unit
--- abilcode number int
---@type fun(whichUnit:number,abilcode:number):number int
J.DecUnitAbilityLevel = J.Common["DecUnitAbilityLevel"]
--- 改变失败条件说明
--- 改变[Defeat Condition]的说明为:[文字]
--- whichCondition function defeatcondition
--- description string
---@type fun(whichCondition:function,description:string):void
J.DefeatConditionSetDescription = J.Common["DefeatConditionSetDescription"]
--- whichStartLoc number int
--- x number
--- y number
---@type fun(whichStartLoc:number,x:number,y:number):void
J.DefineStartLocation = J.Common["DefineStartLocation"]
--- whichStartLoc number int
--- whichLocation number location
---@type fun(whichStartLoc:number,whichLocation:number):void
J.DefineStartLocationLoc = J.Common["DefineStartLocationLoc"]
--- degrees number
---@type fun(degrees:number):number
J.Deg2Rad = J.Common["Deg2Rad"]
--- e function boolexpr
---@type fun(e:function):void
J.DestroyBoolExpr = J.Common["DestroyBoolExpr"]
--- c function conditionfunc
---@type fun(c:function):void
J.DestroyCondition = J.Common["DestroyCondition"]
--- 删除失败条件
--- 删除[Defeat Condition]
--- 被删除的失败条件会从每个任务中移除.
--- whichCondition function defeatcondition
---@type fun(whichCondition:function):void
J.DestroyDefeatCondition = J.Common["DestroyDefeatCondition"]
--- 删除特效
--- 删除[Special Effect]
--- whichEffect number effect
---@type fun(whichEffect:number):void
J.DestroyEffect = J.Common["DestroyEffect"]
--- f function filterfunc
---@type fun(f:function):void
J.DestroyFilter = J.Common["DestroyFilter"]
--- 删除可见度修正器
--- 删除[Visibility Modifier]
--- whichFogModifier number fogmodifier
---@type fun(whichFogModifier:number):void
J.DestroyFogModifier = J.Common["DestroyFogModifier"]
--- 删除玩家组 [R]
--- 删除[玩家组]
--- 注意: 不要删除系统预置的玩家组.
--- whichForce number force
---@type fun(whichForce:number):void
J.DestroyForce = J.Common["DestroyForce"]
--- 删除单位组 [R]
--- 删除[单位组]
--- whichGroup number group
---@type fun(whichGroup:number):void
J.DestroyGroup = J.Common["DestroyGroup"]
--- 删除
--- 删除[图像]
--- whichImage number image
---@type fun(whichImage:number):void
J.DestroyImage = J.Common["DestroyImage"]
--- 删除物品池 [R]
--- 删除[物品池]
--- whichItemPool number itempool
---@type fun(whichItemPool:number):void
J.DestroyItemPool = J.Common["DestroyItemPool"]
--- 删除
--- 删除[排行榜]
--- lb number leaderboard
---@type fun(lb:number):void
J.DestroyLeaderboard = J.Common["DestroyLeaderboard"]
--- 删除闪电效果
--- 删除[某个闪电效果]
--- whichBolt number lightning
---@type fun(whichBolt:number):boolean
J.DestroyLightning = J.Common["DestroyLightning"]
--- 删除
--- 删除[某个多面板]
--- lb number multiboard
---@type fun(lb:number):void
J.DestroyMultiboard = J.Common["DestroyMultiboard"]
--- 删除任务
--- 删除[某个任务]
--- 被删除的任务将不再显示在任务列表.
--- whichQuest number quest
---@type fun(whichQuest:number):void
J.DestroyQuest = J.Common["DestroyQuest"]
--- 删除
--- 删除[Floating Text]
--- 游戏最多允许存在100个漂浮文字,所以请及时删除不再使用的漂浮文字.
--- t number texttag
---@type fun(t:number):void
J.DestroyTextTag = J.Common["DestroyTextTag"]
--- 删除计时器 [R]
--- 删除[计时器]
--- 一般来说,计时器并不需要删除.只为某些有特别需求的用户提供.
--- whichTimer number timer
---@type fun(whichTimer:number):void
J.DestroyTimer = J.Common["DestroyTimer"]
--- 删除计时器窗口
--- 删除[计时器窗口]
--- whichDialog number timerdialog
---@type fun(whichDialog:number):void
J.DestroyTimerDialog = J.Common["DestroyTimerDialog"]
--- 删除触发器 [R]
--- 删除[触发器]
--- 对不再使用的触发器可以使用该动作来删除.
--- whichTrigger number trigger
---@type fun(whichTrigger:number):void
J.DestroyTrigger = J.Common["DestroyTrigger"]
--- 删除地面纹理变化
--- 删除[某个地形纹理]
--- whichSplat any ubersplat
---@type fun(whichSplat:any):void
J.DestroyUbersplat = J.Common["DestroyUbersplat"]
--- 删除单位池 [R]
--- 删除[单位池]
--- whichPool number unitpool
---@type fun(whichPool:number):void
J.DestroyUnitPool = J.Common["DestroyUnitPool"]
--- 复活
--- 复活[某个可破坏物],设置生命值为[Value]并[显示/隐藏]生长动画
--- d number destructable
--- life number
--- birth boolean
---@type fun(d:number,life:number,birth:boolean):void
J.DestructableRestoreLife = J.Common["DestructableRestoreLife"]
--- 添加对话按钮
--- 为[某个对话框]添加一个对话按钮,按钮标签为[Text]
--- 使用'最后创建的对话按钮'来获得创建的对话按钮.
--- whichDialog number dialog
--- buttonText string
--- hotkey number int
---@type fun(whichDialog:number,buttonText:string,hotkey:number):number button
J.DialogAddButton = J.Common["DialogAddButton"]
--- 添加退出游戏按钮 [R]
--- 为[对话框]添加退出游戏按钮([跳过]计分屏) 按钮标题为:[文字]快捷键为:[HotKey]
--- 该函数创建的按钮并不被纪录到'最后创建的对话框按钮'.当该按钮被点击时会退出游戏
--- whichDialog number dialog
--- doScoreScreen boolean
--- buttonText string
--- hotkey number int
---@type fun(whichDialog:number,doScoreScreen:boolean,buttonText:string,hotkey:number):number button
J.DialogAddQuitButton = J.Common["DialogAddQuitButton"]
--- 清空
--- 清空[某个对话框]
--- 清除对话框的标题和按钮.
--- whichDialog number dialog
---@type fun(whichDialog:number):void
J.DialogClear = J.Common["DialogClear"]
---@type fun():number dialog
J.DialogCreate = J.Common["DialogCreate"]
--- 删除 [R]
--- 删除[对话框]
--- 将对话框清除出内存.一般来说对话框并不需要删除.
--- whichDialog number dialog
---@type fun(whichDialog:number):void
J.DialogDestroy = J.Common["DialogDestroy"]
--- 显示/隐藏 [R]
--- 对[某个玩家]设置[对话框]的状态为[显示/隐藏]
--- 对话框不能应用于地图初始化事件.
--- whichPlayer number player
--- whichDialog number dialog
--- flag boolean
---@type fun(whichPlayer:number,whichDialog:number,flag:boolean):void
J.DialogDisplay = J.Common["DialogDisplay"]
--- 改变标题
--- 改变[某个对话框]的标题为[Title]
--- whichDialog number dialog
--- messageText string
---@type fun(whichDialog:number,messageText:string):void
J.DialogSetMessage = J.Common["DialogSetMessage"]
--- 禁用 重新开始任务按钮
--- 设置 重新开始任务按钮可以点击为[]
--- 当单人游戏时，可以设置重新开始任务按钮能否允许点击。
--- flag boolean
---@type fun(flag:boolean):void
J.DisableRestartMission = J.Common["DisableRestartMission"]
--- 关闭触发
--- 关闭[某个触发器]
--- whichTrigger number trigger
---@type fun(whichTrigger:number):void
J.DisableTrigger = J.Common["DisableTrigger"]
--- 显示/隐藏 滤镜
--- [显示/隐藏]滤镜
--- flag boolean
---@type fun(flag:boolean):void
J.DisplayCineFilter = J.Common["DisplayCineFilter"]
---@type fun():void
J.DisplayLoadDialog = J.Common["DisplayLoadDialog"]
--- 对玩家显示文本消息(自动限时) [R]
--- 对[玩家]在屏幕位移([X],[Y])处显示文本:[文字]
--- 显示时间取决于文字长度. 位移的取值在0-1之间. 可使用'本地玩家'实现对所有玩家发送消息.
--- toPlayer number player
--- x number
--- y number
--- message string
---@type fun(toPlayer:number,x:number,y:number,message:string):void
J.DisplayTextToPlayer = J.Common["DisplayTextToPlayer"]
--- toPlayer number player
--- x number
--- y number
--- duration number
--- message string
---@type fun(toPlayer:number,x:number,y:number,duration:number,message:string):void
J.DisplayTimedTextFromPlayer = J.Common["DisplayTimedTextFromPlayer"]
--- 对玩家显示文本消息(指定时间) [R]
--- 对[玩家]在屏幕位移([X],[Y])处显示[时间]秒的文本信息:[文字]
--- 位移的取值在0-1之间. 可使用'本地玩家[R]'实现对所有玩家发送消息.
--- toPlayer number player
--- x number
--- y number
--- duration number
--- message string
---@type fun(toPlayer:number,x:number,y:number,duration:number,message:string):void
J.DisplayTimedTextToPlayer = J.Common["DisplayTimedTextToPlayer"]
--- 关闭游戏录像功能 [R]
--- 关闭游戏录像功能
--- 游戏结束时不保存游戏录像.
---@type fun():void
J.DoNotSaveReplay = J.Common["DoNotSaveReplay"]
--- 允许/禁用框选
--- [Enable/Disable]框选功能 ([Enable/Disable]显示选择框)
--- state boolean
--- ui boolean
---@type fun(state:boolean,ui:boolean):void
J.EnableDragSelect = J.Common["EnableDragSelect"]
--- 允许/禁用小地图按钮
--- [Enable/Disable]联盟颜色显示按钮,[Enable/Disable]中立生物显示按钮
--- enableAlly boolean
--- enableCreep boolean
---@type fun(enableAlly:boolean,enableCreep:boolean):void
J.EnableMinimapFilterButtons = J.Common["EnableMinimapFilterButtons"]
--- 允许/禁止闭塞(所有玩家) [R]
--- [Enable/Disable]闭塞
--- flag boolean
---@type fun(flag:boolean):void
J.EnableOcclusion = J.Common["EnableOcclusion"]
--- 允许/禁用预选
--- [Enable/Disable]预选功能 ([Enable/Disable]显示预选圈,生命槽,物体信息)
--- state boolean
--- ui boolean
---@type fun(state:boolean,ui:boolean):void
J.EnablePreSelect = J.Common["EnablePreSelect"]
--- 允许/禁用选择
--- [Enable/Disable]选择和取消选择功能 ([Enable/Disable]显示选择圈)
--- 禁用选择后仍可以通过触发来选择物体. 只有允许选择功能时才会显示选择圈.
--- state boolean
--- ui boolean
---@type fun(state:boolean,ui:boolean):void
J.EnableSelect = J.Common["EnableSelect"]
--- 开启触发
--- 开启[某个触发器]
--- whichTrigger number trigger
---@type fun(whichTrigger:number):void
J.EnableTrigger = J.Common["EnableTrigger"]
--- 启用/禁用玩家控制权(所有玩家) [R]
--- [启用/禁用]玩家控制权
--- b boolean
---@type fun(b:boolean):void
J.EnableUserControl = J.Common["EnableUserControl"]
--- b boolean
---@type fun(b:boolean):void
J.EnableUserUI = J.Common["EnableUserUI"]
--- 启用/禁用 天气效果
--- 设置[Weather Effect]的状态为:[On/Off]
--- 可以使用'环境 - 创建天气效果'动作来创建天气效果.
--- whichEffect number weathereffect
--- enable boolean
---@type fun(whichEffect:number,enable:boolean):void
J.EnableWeatherEffect = J.Common["EnableWeatherEffect"]
--- 允许/禁止 边界染色(所有玩家) [R]
--- [Enable/Disable]边界染色,应用于所有玩家
--- 禁用边界染色时边界为普通地形,不显示为黑色,但仍是不可通行的.
--- b boolean
---@type fun(b:boolean):void
J.EnableWorldFogBoundary = J.Common["EnableWorldFogBoundary"]
---@type fun():void
J.EndCinematicScene = J.Common["EndCinematicScene"]
--- doScoreScreen boolean
---@type fun(doScoreScreen:boolean):void
J.EndGame = J.Common["EndGame"]
--- 停止主题音乐[C]
--- 停止正在播放的主题音乐
---@type fun():void
J.EndThematicMusic = J.Common["EndThematicMusic"]
--- r number rect
--- filter function boolexpr
--- actionFunc any code
---@type fun(r:number,filter:function,actionFunc:any):void
J.EnumDestructablesInRect = J.Common["EnumDestructablesInRect"]
--- 选取矩形区域内物品做动作
--- 选取[矩形区域]内所有物品[做动作]
--- 组动作中可使用'选取物品'来获取对应的物品. 区域内每个物品都会运行一次动作(包括隐藏物品,不包括单位身上的物品). 等待不能在组动作中运行.
--- r number rect
--- filter function boolexpr
--- actionFunc any code
---@type fun(r:number,filter:function,actionFunc:any):void
J.EnumItemsInRect = J.Common["EnumItemsInRect"]
--- 运行函数 [R]
--- 运行:[函数名]
--- 使用该功能运行的函数与触发独立, 只能运行自定义无参数函数.
--- funcName string
---@type fun(funcName:string):void
J.ExecuteFunc = J.Common["ExecuteFunc"]
--- func any code
---@type fun(func:any):function filterfunc
J.Filter = J.Common["Filter"]
--- 结束地面纹理变化
--- 结束[某个地形纹理]
--- 在动画播放完毕时自动清除该地面纹理变化.
--- whichSplat any ubersplat
---@type fun(whichSplat:any):void
J.FinishUbersplat = J.Common["FinishUbersplat"]
--- whichGroup number group
---@type fun(whichGroup:number):number unit
J.FirstOfGroup = J.Common["FirstOfGroup"]
--- 闪动任务按钮
---@type fun():void
J.FlashQuestDialogButton = J.Common["FlashQuestDialogButton"]
--- <1.24> 清空哈希表主索引 [C]
--- 清空[Hashtable]中位于主索引[Value] 之内的所有数据
--- 清空哈希表主索引下的所有数据
--- table any hashtable
--- parentKey number int
---@type fun(table:any,parentKey:number):void
J.FlushChildHashtable = J.Common["FlushChildHashtable"]
--- 删除缓存 [C]
--- 删除[GameCache]
--- 删除并清空该缓存的所有数据.和原版UI完全一致，但却不能兼容原版UI，它的存在完全是在添乱啊
--- cache any gamecache
---@type fun(cache:any):void
J.FlushGameCache = J.Common["FlushGameCache"]
--- <1.24> 清空哈希表 [C]
--- 清空[Hashtable]
--- 清空哈希表所有数据
--- table any hashtable
---@type fun(table:any):void
J.FlushParentHashtable = J.Common["FlushParentHashtable"]
--- cache any gamecache
--- missionKey string
--- key string
---@type fun(cache:any,missionKey:string,key:string):void
J.FlushStoredBoolean = J.Common["FlushStoredBoolean"]
--- cache any gamecache
--- missionKey string
--- key string
---@type fun(cache:any,missionKey:string,key:string):void
J.FlushStoredInteger = J.Common["FlushStoredInteger"]
--- 删除类别
--- 删除缓存[GameCache]中[Category]类别
--- 清空该类别下的所有缓存数据.
--- cache any gamecache
--- missionKey string
---@type fun(cache:any,missionKey:string):void
J.FlushStoredMission = J.Common["FlushStoredMission"]
--- cache any gamecache
--- missionKey string
--- key string
---@type fun(cache:any,missionKey:string,key:string):void
J.FlushStoredReal = J.Common["FlushStoredReal"]
--- cache any gamecache
--- missionKey string
--- key string
---@type fun(cache:any,missionKey:string,key:string):void
J.FlushStoredString = J.Common["FlushStoredString"]
--- cache any gamecache
--- missionKey string
--- key string
---@type fun(cache:any,missionKey:string,key:string):void
J.FlushStoredUnit = J.Common["FlushStoredUnit"]
--- 启用/禁用 战争迷雾 [R]
--- [启用/禁用]战争迷雾
--- enable boolean
---@type fun(enable:boolean):void
J.FogEnable = J.Common["FogEnable"]
--- 启用/禁用黑色阴影 [R]
--- [启用/禁用]黑色阴影
--- enable boolean
---@type fun(enable:boolean):void
J.FogMaskEnable = J.Common["FogMaskEnable"]
--- 启用可见度修正器
--- 启用[Visibility Modifier]
--- whichFogModifier number fogmodifier
---@type fun(whichFogModifier:number):void
J.FogModifierStart = J.Common["FogModifierStart"]
--- 禁用可见度修正器
--- 禁用[Visibility Modifier]
--- whichFogModifier number fogmodifier
---@type fun(whichFogModifier:number):void
J.FogModifierStop = J.Common["FogModifierStop"]
--- 选取玩家组内玩家做动作
--- 选取[玩家组]内所有玩家[做动作]
--- 玩家组动作中可使用'选取玩家'来获取对应的玩家. 等待不能在组动作中运行.
--- whichForce number force
--- callback any code
---@type fun(whichForce:number,callback:any):void
J.ForForce = J.Common["ForForce"]
--- 选取单位组内单位做动作
--- 选取[单位组]内所有单位[做动作]
--- 使用'选取单位'来取代相应的单位. 对于单位组内每个单位都会运行一次动作(包括死亡的,不包括隐藏的). 等待不能在组动作中运行.
--- whichGroup number group
--- callback any code
---@type fun(whichGroup:number,callback:any):void
J.ForGroup = J.Common["ForGroup"]
--- 添加玩家 [R]
--- [玩家组]添加[玩家]
--- 并不影响玩家本身.
--- whichForce number force
--- whichPlayer number player
---@type fun(whichForce:number,whichPlayer:number):void
J.ForceAddPlayer = J.Common["ForceAddPlayer"]
---@type fun():void
J.ForceCampaignSelectScreen = J.Common["ForceCampaignSelectScreen"]
--- 字幕显示
--- [On/Off]电影字幕显示功能
--- 该功能和'游戏菜单-声音选项'中的字幕选项中有一项为开时即能够显示电影字幕.
--- flag boolean
---@type fun(flag:boolean):void
J.ForceCinematicSubtitles = J.Common["ForceCinematicSubtitles"]
--- 清空玩家组
--- 清空[玩家组]内所有玩家
--- 并不影响玩家本身.
--- whichForce number force
---@type fun(whichForce:number):void
J.ForceClear = J.Common["ForceClear"]
--- whichForce number force
--- whichPlayer number player
--- filter function boolexpr
---@type fun(whichForce:number,whichPlayer:number,filter:function):void
J.ForceEnumAllies = J.Common["ForceEnumAllies"]
--- whichForce number force
--- whichPlayer number player
--- filter function boolexpr
---@type fun(whichForce:number,whichPlayer:number,filter:function):void
J.ForceEnumEnemies = J.Common["ForceEnumEnemies"]
--- whichForce number force
--- filter function boolexpr
---@type fun(whichForce:number,filter:function):void
J.ForceEnumPlayers = J.Common["ForceEnumPlayers"]
--- whichForce number force
--- filter function boolexpr
--- countLimit number int
---@type fun(whichForce:number,filter:function,countLimit:number):void
J.ForceEnumPlayersCounted = J.Common["ForceEnumPlayersCounted"]
--- whichPlayer number player
--- startLocIndex number int
---@type fun(whichPlayer:number,startLocIndex:number):void
J.ForcePlayerStartLocation = J.Common["ForcePlayerStartLocation"]
---@type fun():void
J.ForceQuestDialogUpdate = J.Common["ForceQuestDialogUpdate"]
--- 移除玩家 [R]
--- 从[玩家组]中移除[玩家]
--- 并不影响玩家本身.
--- whichForce number force
--- whichPlayer number player
---@type fun(whichForce:number,whichPlayer:number):void
J.ForceRemovePlayer = J.Common["ForceRemovePlayer"]
--- 强制按Esc键
--- 命令[某个玩家]按下Esc键
---@type fun():void
J.ForceUICancel = J.Common["ForceUICancel"]
--- 强制按键
--- 命令[某个玩家]按下[Key]键
--- key string
---@type fun(key:string):void
J.ForceUIKey = J.Common["ForceUIKey"]
--- num number player
---@type fun(num:number):any aidifficulty
J.GetAIDifficulty = J.Common["GetAIDifficulty"]
--- abilityString string
--- t any effecttype
--- index number int
---@type fun(abilityString:string,t:any,index:number):string
J.GetAbilityEffect = J.Common["GetAbilityEffect"]
--- abilityId number int
--- t any effecttype
--- index number int
---@type fun(abilityId:number,t:any,index:number):string
J.GetAbilityEffectById = J.Common["GetAbilityEffectById"]
--- abilityString string
--- t any soundtype
---@type fun(abilityString:string,t:any):string
J.GetAbilitySound = J.Common["GetAbilitySound"]
--- abilityId number int
--- t any soundtype
---@type fun(abilityId:number,t:any):string
J.GetAbilitySoundById = J.Common["GetAbilitySoundById"]
---@type fun():number int
J.GetAllyColorFilterState = J.Common["GetAllyColorFilterState"]
---@type fun():number unit
J.GetAttacker = J.Common["GetAttacker"]
---@type fun():number unit
J.GetBuyingUnit = J.Common["GetBuyingUnit"]
---@type fun():number
J.GetCameraBoundMaxX = J.Common["GetCameraBoundMaxX"]
---@type fun():number
J.GetCameraBoundMaxY = J.Common["GetCameraBoundMaxY"]
---@type fun():number
J.GetCameraBoundMinX = J.Common["GetCameraBoundMinX"]
---@type fun():number
J.GetCameraBoundMinY = J.Common["GetCameraBoundMinY"]
---@type fun():number location
J.GetCameraEyePositionLoc = J.Common["GetCameraEyePositionLoc"]
---@type fun():number
J.GetCameraEyePositionX = J.Common["GetCameraEyePositionX"]
---@type fun():number
J.GetCameraEyePositionY = J.Common["GetCameraEyePositionY"]
---@type fun():number
J.GetCameraEyePositionZ = J.Common["GetCameraEyePositionZ"]
--- whichField any camerafield
---@type fun(whichField:any):number
J.GetCameraField = J.Common["GetCameraField"]
--- whichMargin number int
---@type fun(whichMargin:number):number
J.GetCameraMargin = J.Common["GetCameraMargin"]
---@type fun():number location
J.GetCameraTargetPositionLoc = J.Common["GetCameraTargetPositionLoc"]
---@type fun():number
J.GetCameraTargetPositionX = J.Common["GetCameraTargetPositionX"]
---@type fun():number
J.GetCameraTargetPositionY = J.Common["GetCameraTargetPositionY"]
---@type fun():number
J.GetCameraTargetPositionZ = J.Common["GetCameraTargetPositionZ"]
---@type fun():number unit
J.GetCancelledStructure = J.Common["GetCancelledStructure"]
---@type fun():number unit
J.GetChangingUnit = J.Common["GetChangingUnit"]
---@type fun():number player
J.GetChangingUnitPrevOwner = J.Common["GetChangingUnitPrevOwner"]
---@type fun():number button
J.GetClickedButton = J.Common["GetClickedButton"]
---@type fun():number dialog
J.GetClickedDialog = J.Common["GetClickedDialog"]
---@type fun():number unit
J.GetConstructedStructure = J.Common["GetConstructedStructure"]
---@type fun():number unit
J.GetConstructingStructure = J.Common["GetConstructingStructure"]
---@type fun():any mapdensity
J.GetCreatureDensity = J.Common["GetCreatureDensity"]
---@type fun():boolean
J.GetCreepCampFilterState = J.Common["GetCreepCampFilterState"]
--- whichButton number int
---@type fun(whichButton:number):boolean
J.GetCustomCampaignButtonVisible = J.Common["GetCustomCampaignButtonVisible"]
---@type fun():number unit
J.GetDecayingUnit = J.Common["GetDecayingUnit"]
---@type fun():any gamedifficulty
J.GetDefaultDifficulty = J.Common["GetDefaultDifficulty"]
--- d number destructable
---@type fun(d:number):number
J.GetDestructableLife = J.Common["GetDestructableLife"]
--- d number destructable
---@type fun(d:number):number
J.GetDestructableMaxLife = J.Common["GetDestructableMaxLife"]
--- d number destructable
---@type fun(d:number):string
J.GetDestructableName = J.Common["GetDestructableName"]
--- d number destructable
---@type fun(d:number):number
J.GetDestructableOccluderHeight = J.Common["GetDestructableOccluderHeight"]
--- d number destructable
---@type fun(d:number):number int
J.GetDestructableTypeId = J.Common["GetDestructableTypeId"]
--- d number destructable
---@type fun(d:number):number
J.GetDestructableX = J.Common["GetDestructableX"]
--- d number destructable
---@type fun(d:number):number
J.GetDestructableY = J.Common["GetDestructableY"]
---@type fun():number unit
J.GetDetectedUnit = J.Common["GetDetectedUnit"]
---@type fun():number unit
J.GetDyingUnit = J.Common["GetDyingUnit"]
---@type fun():number unit
J.GetEnteringUnit = J.Common["GetEnteringUnit"]
---@type fun():number destructable
J.GetEnumDestructable = J.Common["GetEnumDestructable"]
---@type fun():number item
J.GetEnumItem = J.Common["GetEnumItem"]
---@type fun():number player
J.GetEnumPlayer = J.Common["GetEnumPlayer"]
---@type fun():number unit
J.GetEnumUnit = J.Common["GetEnumUnit"]
---@type fun():number
J.GetEventDamage = J.Common["GetEventDamage"]
---@type fun():number unit
J.GetEventDamageSource = J.Common["GetEventDamageSource"]
---@type fun():number player
J.GetEventDetectingPlayer = J.Common["GetEventDetectingPlayer"]
---@type fun():any gamestate
J.GetEventGameState = J.Common["GetEventGameState"]
---@type fun():string
J.GetEventPlayerChatString = J.Common["GetEventPlayerChatString"]
---@type fun():string
J.GetEventPlayerChatStringMatched = J.Common["GetEventPlayerChatStringMatched"]
---@type fun():any playerstate
J.GetEventPlayerState = J.Common["GetEventPlayerState"]
---@type fun():number unit
J.GetEventTargetUnit = J.Common["GetEventTargetUnit"]
---@type fun():any unitstate
J.GetEventUnitState = J.Common["GetEventUnitState"]
---@type fun():number timer
J.GetExpiredTimer = J.Common["GetExpiredTimer"]
---@type fun():number destructable
J.GetFilterDestructable = J.Common["GetFilterDestructable"]
---@type fun():number item
J.GetFilterItem = J.Common["GetFilterItem"]
---@type fun():number player
J.GetFilterPlayer = J.Common["GetFilterPlayer"]
---@type fun():number unit
J.GetFilterUnit = J.Common["GetFilterUnit"]
--- whichFloatGameState any fgamestate
---@type fun(whichFloatGameState:any):number
J.GetFloatGameState = J.Common["GetFloatGameState"]
--- unitId number int
---@type fun(unitId:number):number int
J.GetFoodMade = J.Common["GetFoodMade"]
--- unitId number int
---@type fun(unitId:number):number int
J.GetFoodUsed = J.Common["GetFoodUsed"]
---@type fun():any gamedifficulty
J.GetGameDifficulty = J.Common["GetGameDifficulty"]
---@type fun():any placement
J.GetGamePlacement = J.Common["GetGamePlacement"]
---@type fun():any gamespeed
J.GetGameSpeed = J.Common["GetGameSpeed"]
---@type fun():any gametype
J.GetGameTypeSelected = J.Common["GetGameTypeSelected"]
--- h any handle
---@type fun(h:any):number int
J.GetHandleId = J.Common["GetHandleId"]
--- whichHero number unit
--- includeBonuses boolean
---@type fun(whichHero:number,includeBonuses:boolean):number int
J.GetHeroAgi = J.Common["GetHeroAgi"]
--- whichHero number unit
--- includeBonuses boolean
---@type fun(whichHero:number,includeBonuses:boolean):number int
J.GetHeroInt = J.Common["GetHeroInt"]
--- whichHero number unit
---@type fun(whichHero:number):number int
J.GetHeroLevel = J.Common["GetHeroLevel"]
--- whichHero number unit
---@type fun(whichHero:number):string
J.GetHeroProperName = J.Common["GetHeroProperName"]
--- whichHero number unit
---@type fun(whichHero:number):number int
J.GetHeroSkillPoints = J.Common["GetHeroSkillPoints"]
--- whichHero number unit
--- includeBonuses boolean
---@type fun(whichHero:number,includeBonuses:boolean):number int
J.GetHeroStr = J.Common["GetHeroStr"]
--- whichHero number unit
---@type fun(whichHero:number):number int
J.GetHeroXP = J.Common["GetHeroXP"]
--- whichIntegerGameState any igamestate
---@type fun(whichIntegerGameState:any):number int
J.GetIntegerGameState = J.Common["GetIntegerGameState"]
---@type fun():number int
J.GetIssuedOrderId = J.Common["GetIssuedOrderId"]
--- whichItem number item
---@type fun(whichItem:number):number int
J.GetItemCharges = J.Common["GetItemCharges"]
--- whichItem number item
---@type fun(whichItem:number):number int
J.GetItemLevel = J.Common["GetItemLevel"]
--- whichItem number item
---@type fun(whichItem:number):string
J.GetItemName = J.Common["GetItemName"]
--- whichItem number item
---@type fun(whichItem:number):number player
J.GetItemPlayer = J.Common["GetItemPlayer"]
--- whichItem number item
---@type fun(whichItem:number):any itemtype
J.GetItemType = J.Common["GetItemType"]
--- i number item
---@type fun(i:number):number int
J.GetItemTypeId = J.Common["GetItemTypeId"]
--- whichItem number item
---@type fun(whichItem:number):number int
J.GetItemUserData = J.Common["GetItemUserData"]
--- i number item
---@type fun(i:number):number
J.GetItemX = J.Common["GetItemX"]
--- i number item
---@type fun(i:number):number
J.GetItemY = J.Common["GetItemY"]
---@type fun():number unit
J.GetKillingUnit = J.Common["GetKillingUnit"]
---@type fun():number int
J.GetLearnedSkill = J.Common["GetLearnedSkill"]
---@type fun():number int
J.GetLearnedSkillLevel = J.Common["GetLearnedSkillLevel"]
---@type fun():number unit
J.GetLearningUnit = J.Common["GetLearningUnit"]
---@type fun():number unit
J.GetLeavingUnit = J.Common["GetLeavingUnit"]
---@type fun():number unit
J.GetLevelingUnit = J.Common["GetLevelingUnit"]
--- whichBolt number lightning
---@type fun(whichBolt:number):number
J.GetLightningColorA = J.Common["GetLightningColorA"]
--- whichBolt number lightning
---@type fun(whichBolt:number):number
J.GetLightningColorB = J.Common["GetLightningColorB"]
--- whichBolt number lightning
---@type fun(whichBolt:number):number
J.GetLightningColorG = J.Common["GetLightningColorG"]
--- whichBolt number lightning
---@type fun(whichBolt:number):number
J.GetLightningColorR = J.Common["GetLightningColorR"]
---@type fun():number unit
J.GetLoadedUnit = J.Common["GetLoadedUnit"]
--- source string
---@type fun(source:string):number int
J.GetLocalizedHotkey = J.Common["GetLocalizedHotkey"]
--- source string
---@type fun(source:string):string
J.GetLocalizedString = J.Common["GetLocalizedString"]
--- whichLocation number location
---@type fun(whichLocation:number):number
J.GetLocationX = J.Common["GetLocationX"]
--- whichLocation number location
---@type fun(whichLocation:number):number
J.GetLocationY = J.Common["GetLocationY"]
---@type fun():number item
J.GetManipulatedItem = J.Common["GetManipulatedItem"]
---@type fun():number unit
J.GetManipulatingUnit = J.Common["GetManipulatingUnit"]
--- objectId number int
---@type fun(objectId:number):string
J.GetObjectName = J.Common["GetObjectName"]
---@type fun():number location
J.GetOrderPointLoc = J.Common["GetOrderPointLoc"]
---@type fun():number
J.GetOrderPointX = J.Common["GetOrderPointX"]
---@type fun():number
J.GetOrderPointY = J.Common["GetOrderPointY"]
---@type fun():number widget
J.GetOrderTarget = J.Common["GetOrderTarget"]
---@type fun():number destructable
J.GetOrderTargetDestructable = J.Common["GetOrderTargetDestructable"]
---@type fun():number item
J.GetOrderTargetItem = J.Common["GetOrderTargetItem"]
---@type fun():number unit
J.GetOrderTargetUnit = J.Common["GetOrderTargetUnit"]
---@type fun():number unit
J.GetOrderedUnit = J.Common["GetOrderedUnit"]
--- whichUnit number unit
---@type fun(whichUnit:number):number player
J.GetOwningPlayer = J.Common["GetOwningPlayer"]
--- sourcePlayer number player
--- otherPlayer number player
--- whichAllianceSetting any alliancetype
---@type fun(sourcePlayer:number,otherPlayer:number,whichAllianceSetting:any):boolean
J.GetPlayerAlliance = J.Common["GetPlayerAlliance"]
--- whichPlayer number player
---@type fun(whichPlayer:number):any playercolor
J.GetPlayerColor = J.Common["GetPlayerColor"]
--- whichPlayer number player
---@type fun(whichPlayer:number):any mapcontrol
J.GetPlayerController = J.Common["GetPlayerController"]
--- whichPlayer number player
---@type fun(whichPlayer:number):number
J.GetPlayerHandicap = J.Common["GetPlayerHandicap"]
--- whichPlayer number player
---@type fun(whichPlayer:number):number
J.GetPlayerHandicapXP = J.Common["GetPlayerHandicapXP"]
--- whichPlayer number player
---@type fun(whichPlayer:number):number int
J.GetPlayerId = J.Common["GetPlayerId"]
--- whichPlayer number player
---@type fun(whichPlayer:number):string
J.GetPlayerName = J.Common["GetPlayerName"]
--- whichPlayer number player
---@type fun(whichPlayer:number):any race
J.GetPlayerRace = J.Common["GetPlayerRace"]
--- whichPlayer number player
--- whichPlayerScore any playerscore
---@type fun(whichPlayer:number,whichPlayerScore:any):number int
J.GetPlayerScore = J.Common["GetPlayerScore"]
--- whichPlayer number player
---@type fun(whichPlayer:number):boolean
J.GetPlayerSelectable = J.Common["GetPlayerSelectable"]
--- whichPlayer number player
---@type fun(whichPlayer:number):any playerslotstate
J.GetPlayerSlotState = J.Common["GetPlayerSlotState"]
--- whichPlayer number player
---@type fun(whichPlayer:number):number int
J.GetPlayerStartLocation = J.Common["GetPlayerStartLocation"]
--- whichPlayer number player
--- whichPlayerState any playerstate
---@type fun(whichPlayer:number,whichPlayerState:any):number int
J.GetPlayerState = J.Common["GetPlayerState"]
--- whichPlayer number player
--- includeIncomplete boolean
---@type fun(whichPlayer:number,includeIncomplete:boolean):number int
J.GetPlayerStructureCount = J.Common["GetPlayerStructureCount"]
--- sourcePlayer number player
--- otherPlayer number player
--- whichResource any playerstate
---@type fun(sourcePlayer:number,otherPlayer:number,whichResource:any):number int
J.GetPlayerTaxRate = J.Common["GetPlayerTaxRate"]
--- whichPlayer number player
---@type fun(whichPlayer:number):number int
J.GetPlayerTeam = J.Common["GetPlayerTeam"]
--- whichPlayer number player
--- techid number int
--- specificonly boolean
---@type fun(whichPlayer:number,techid:number,specificonly:boolean):number int
J.GetPlayerTechCount = J.Common["GetPlayerTechCount"]
--- whichPlayer number player
--- techid number int
---@type fun(whichPlayer:number,techid:number):number int
J.GetPlayerTechMaxAllowed = J.Common["GetPlayerTechMaxAllowed"]
--- whichPlayer number player
--- techid number int
--- specificonly boolean
---@type fun(whichPlayer:number,techid:number,specificonly:boolean):boolean
J.GetPlayerTechResearched = J.Common["GetPlayerTechResearched"]
--- whichPlayer number player
--- unitName string
--- includeIncomplete boolean
--- includeUpgrades boolean
---@type fun(whichPlayer:number,unitName:string,includeIncomplete:boolean,includeUpgrades:boolean):number int
J.GetPlayerTypedUnitCount = J.Common["GetPlayerTypedUnitCount"]
--- whichPlayer number player
--- includeIncomplete boolean
---@type fun(whichPlayer:number,includeIncomplete:boolean):number int
J.GetPlayerUnitCount = J.Common["GetPlayerUnitCount"]
---@type fun():number int
J.GetPlayers = J.Common["GetPlayers"]
--- lowBound number int
--- highBound number int
---@type fun(lowBound:number,highBound:number):number int
J.GetRandomInt = J.Common["GetRandomInt"]
--- lowBound number
--- highBound number
---@type fun(lowBound:number,highBound:number):number
J.GetRandomReal = J.Common["GetRandomReal"]
--- whichRect number rect
---@type fun(whichRect:number):number
J.GetRectCenterX = J.Common["GetRectCenterX"]
--- whichRect number rect
---@type fun(whichRect:number):number
J.GetRectCenterY = J.Common["GetRectCenterY"]
--- whichRect number rect
---@type fun(whichRect:number):number
J.GetRectMaxX = J.Common["GetRectMaxX"]
--- whichRect number rect
---@type fun(whichRect:number):number
J.GetRectMaxY = J.Common["GetRectMaxY"]
--- whichRect number rect
---@type fun(whichRect:number):number
J.GetRectMinX = J.Common["GetRectMinX"]
--- whichRect number rect
---@type fun(whichRect:number):number
J.GetRectMinY = J.Common["GetRectMinY"]
---@type fun():number unit
J.GetRescuer = J.Common["GetRescuer"]
---@type fun():number int
J.GetResearched = J.Common["GetResearched"]
---@type fun():number unit
J.GetResearchingUnit = J.Common["GetResearchingUnit"]
--- whichUnit number unit
---@type fun(whichUnit:number):number int
J.GetResourceAmount = J.Common["GetResourceAmount"]
---@type fun():any mapdensity
J.GetResourceDensity = J.Common["GetResourceDensity"]
---@type fun():number unit
J.GetRevivableUnit = J.Common["GetRevivableUnit"]
---@type fun():number unit
J.GetRevivingUnit = J.Common["GetRevivingUnit"]
---@type fun():string
J.GetSaveBasicFilename = J.Common["GetSaveBasicFilename"]
---@type fun():number unit
J.GetSellingUnit = J.Common["GetSellingUnit"]
---@type fun():number item
J.GetSoldItem = J.Common["GetSoldItem"]
---@type fun():number unit
J.GetSoldUnit = J.Common["GetSoldUnit"]
--- soundHandle number sound
---@type fun(soundHandle:number):number int
J.GetSoundDuration = J.Common["GetSoundDuration"]
--- musicFileName string
---@type fun(musicFileName:string):number int
J.GetSoundFileDuration = J.Common["GetSoundFileDuration"]
--- soundHandle number sound
---@type fun(soundHandle:number):boolean
J.GetSoundIsLoading = J.Common["GetSoundIsLoading"]
--- soundHandle number sound
---@type fun(soundHandle:number):boolean
J.GetSoundIsPlaying = J.Common["GetSoundIsPlaying"]
---@type fun():number ability
J.GetSpellAbility = J.Common["GetSpellAbility"]
---@type fun():number int
J.GetSpellAbilityId = J.Common["GetSpellAbilityId"]
---@type fun():number unit
J.GetSpellAbilityUnit = J.Common["GetSpellAbilityUnit"]
---@type fun():number destructable
J.GetSpellTargetDestructable = J.Common["GetSpellTargetDestructable"]
---@type fun():number item
J.GetSpellTargetItem = J.Common["GetSpellTargetItem"]
---@type fun():number location
J.GetSpellTargetLoc = J.Common["GetSpellTargetLoc"]
---@type fun():number unit
J.GetSpellTargetUnit = J.Common["GetSpellTargetUnit"]
---@type fun():number
J.GetSpellTargetX = J.Common["GetSpellTargetX"]
---@type fun():number
J.GetSpellTargetY = J.Common["GetSpellTargetY"]
--- whichStartLoc number int
--- prioSlotIndex number int
---@type fun(whichStartLoc:number,prioSlotIndex:number):any startlocprio
J.GetStartLocPrio = J.Common["GetStartLocPrio"]
--- whichStartLoc number int
--- prioSlotIndex number int
---@type fun(whichStartLoc:number,prioSlotIndex:number):number int
J.GetStartLocPrioSlot = J.Common["GetStartLocPrioSlot"]
--- whichStartLocation number int
---@type fun(whichStartLocation:number):number location
J.GetStartLocationLoc = J.Common["GetStartLocationLoc"]
--- whichStartLocation number int
---@type fun(whichStartLocation:number):number
J.GetStartLocationX = J.Common["GetStartLocationX"]
--- whichStartLocation number int
---@type fun(whichStartLocation:number):number
J.GetStartLocationY = J.Common["GetStartLocationY"]
--- cache any gamecache
--- missionKey string
--- key string
---@type fun(cache:any,missionKey:string,key:string):boolean
J.GetStoredBoolean = J.Common["GetStoredBoolean"]
--- cache any gamecache
--- missionKey string
--- key string
---@type fun(cache:any,missionKey:string,key:string):number int
J.GetStoredInteger = J.Common["GetStoredInteger"]
--- cache any gamecache
--- missionKey string
--- key string
---@type fun(cache:any,missionKey:string,key:string):number
J.GetStoredReal = J.Common["GetStoredReal"]
--- cache any gamecache
--- missionKey string
--- key string
---@type fun(cache:any,missionKey:string,key:string):string
J.GetStoredString = J.Common["GetStoredString"]
---@type fun():number unit
J.GetSummonedUnit = J.Common["GetSummonedUnit"]
---@type fun():number unit
J.GetSummoningUnit = J.Common["GetSummoningUnit"]
---@type fun():number int
J.GetTeams = J.Common["GetTeams"]
--- x number
--- y number
---@type fun(x:number,y:number):number int
J.GetTerrainCliffLevel = J.Common["GetTerrainCliffLevel"]
--- x number
--- y number
---@type fun(x:number,y:number):number int
J.GetTerrainType = J.Common["GetTerrainType"]
--- x number
--- y number
---@type fun(x:number,y:number):number int
J.GetTerrainVariance = J.Common["GetTerrainVariance"]
---@type fun():number
J.GetTimeOfDayScale = J.Common["GetTimeOfDayScale"]
---@type fun():number player
J.GetTournamentFinishNowPlayer = J.Common["GetTournamentFinishNowPlayer"]
---@type fun():number int
J.GetTournamentFinishNowRule = J.Common["GetTournamentFinishNowRule"]
---@type fun():number
J.GetTournamentFinishSoonTimeRemaining = J.Common["GetTournamentFinishSoonTimeRemaining"]
--- whichPlayer number player
---@type fun(whichPlayer:number):number int
J.GetTournamentScore = J.Common["GetTournamentScore"]
---@type fun():number unit
J.GetTrainedUnit = J.Common["GetTrainedUnit"]
---@type fun():number int
J.GetTrainedUnitType = J.Common["GetTrainedUnitType"]
---@type fun():number unit
J.GetTransportUnit = J.Common["GetTransportUnit"]
---@type fun():number destructable
J.GetTriggerDestructable = J.Common["GetTriggerDestructable"]
--- whichTrigger number trigger
---@type fun(whichTrigger:number):number int
J.GetTriggerEvalCount = J.Common["GetTriggerEvalCount"]
---@type fun():number eventid
J.GetTriggerEventId = J.Common["GetTriggerEventId"]
--- whichTrigger number trigger
---@type fun(whichTrigger:number):number int
J.GetTriggerExecCount = J.Common["GetTriggerExecCount"]
---@type fun():number player
J.GetTriggerPlayer = J.Common["GetTriggerPlayer"]
---@type fun():number unit
J.GetTriggerUnit = J.Common["GetTriggerUnit"]
---@type fun():number widget
J.GetTriggerWidget = J.Common["GetTriggerWidget"]
---@type fun():number region
J.GetTriggeringRegion = J.Common["GetTriggeringRegion"]
---@type fun():any trackable
J.GetTriggeringTrackable = J.Common["GetTriggeringTrackable"]
---@type fun():number trigger
J.GetTriggeringTrigger = J.Common["GetTriggeringTrigger"]
--- whichUnit number unit
--- abilcode number int
---@type fun(whichUnit:number,abilcode:number):number int
J.GetUnitAbilityLevel = J.Common["GetUnitAbilityLevel"]
--- whichUnit number unit
---@type fun(whichUnit:number):number
J.GetUnitAcquireRange = J.Common["GetUnitAcquireRange"]
--- whichUnit number unit
---@type fun(whichUnit:number):number int
J.GetUnitCurrentOrder = J.Common["GetUnitCurrentOrder"]
--- whichUnit number unit
---@type fun(whichUnit:number):number
J.GetUnitDefaultAcquireRange = J.Common["GetUnitDefaultAcquireRange"]
--- whichUnit number unit
---@type fun(whichUnit:number):number
J.GetUnitDefaultFlyHeight = J.Common["GetUnitDefaultFlyHeight"]
--- whichUnit number unit
---@type fun(whichUnit:number):number
J.GetUnitDefaultMoveSpeed = J.Common["GetUnitDefaultMoveSpeed"]
--- whichUnit number unit
---@type fun(whichUnit:number):number
J.GetUnitDefaultPropWindow = J.Common["GetUnitDefaultPropWindow"]
--- whichUnit number unit
---@type fun(whichUnit:number):number
J.GetUnitDefaultTurnSpeed = J.Common["GetUnitDefaultTurnSpeed"]
--- whichUnit number unit
---@type fun(whichUnit:number):number
J.GetUnitFacing = J.Common["GetUnitFacing"]
--- whichUnit number unit
---@type fun(whichUnit:number):number
J.GetUnitFlyHeight = J.Common["GetUnitFlyHeight"]
--- whichUnit number unit
---@type fun(whichUnit:number):number int
J.GetUnitFoodMade = J.Common["GetUnitFoodMade"]
--- whichUnit number unit
---@type fun(whichUnit:number):number int
J.GetUnitFoodUsed = J.Common["GetUnitFoodUsed"]
--- whichUnit number unit
---@type fun(whichUnit:number):number int
J.GetUnitLevel = J.Common["GetUnitLevel"]
--- whichUnit number unit
---@type fun(whichUnit:number):number location
J.GetUnitLoc = J.Common["GetUnitLoc"]
--- whichUnit number unit
---@type fun(whichUnit:number):number
J.GetUnitMoveSpeed = J.Common["GetUnitMoveSpeed"]
--- whichUnit number unit
---@type fun(whichUnit:number):string
J.GetUnitName = J.Common["GetUnitName"]
--- whichUnit number unit
---@type fun(whichUnit:number):number int
J.GetUnitPointValue = J.Common["GetUnitPointValue"]
--- unitType number int
---@type fun(unitType:number):number int
J.GetUnitPointValueByType = J.Common["GetUnitPointValueByType"]
--- whichUnit number unit
---@type fun(whichUnit:number):number
J.GetUnitPropWindow = J.Common["GetUnitPropWindow"]
--- whichUnit number unit
---@type fun(whichUnit:number):any race
J.GetUnitRace = J.Common["GetUnitRace"]
--- whichUnit number unit
---@type fun(whichUnit:number):number destructable
J.GetUnitRallyDestructable = J.Common["GetUnitRallyDestructable"]
--- whichUnit number unit
---@type fun(whichUnit:number):number location
J.GetUnitRallyPoint = J.Common["GetUnitRallyPoint"]
--- whichUnit number unit
---@type fun(whichUnit:number):number unit
J.GetUnitRallyUnit = J.Common["GetUnitRallyUnit"]
--- whichUnit number unit
--- whichUnitState any unitstate
---@type fun(whichUnit:number,whichUnitState:any):number
J.GetUnitState = J.Common["GetUnitState"]
--- whichUnit number unit
---@type fun(whichUnit:number):number
J.GetUnitTurnSpeed = J.Common["GetUnitTurnSpeed"]
--- whichUnit number unit
---@type fun(whichUnit:number):number int
J.GetUnitTypeId = J.Common["GetUnitTypeId"]
--- whichUnit number unit
---@type fun(whichUnit:number):number int
J.GetUnitUserData = J.Common["GetUnitUserData"]
--- whichUnit number unit
---@type fun(whichUnit:number):number
J.GetUnitX = J.Common["GetUnitX"]
--- whichUnit number unit
---@type fun(whichUnit:number):number
J.GetUnitY = J.Common["GetUnitY"]
--- whichWidget number widget
---@type fun(whichWidget:number):number
J.GetWidgetLife = J.Common["GetWidgetLife"]
--- whichWidget number widget
---@type fun(whichWidget:number):number
J.GetWidgetX = J.Common["GetWidgetX"]
--- whichWidget number widget
---@type fun(whichWidget:number):number
J.GetWidgetY = J.Common["GetWidgetY"]
---@type fun():number player
J.GetWinningPlayer = J.Common["GetWinningPlayer"]
---@type fun():number rect
J.GetWorldBounds = J.Common["GetWorldBounds"]
--- 添加单位 [R]
--- 为[单位组]添加[单位]
--- 并不影响单位本身.
--- whichGroup number group
--- whichUnit number unit
---@type fun(whichGroup:number,whichUnit:number):void
J.GroupAddUnit = J.Common["GroupAddUnit"]
--- 清空单位组
--- 清空[单位组]内所有单位
--- 并不影响单位本身.
--- whichGroup number group
---@type fun(whichGroup:number):void
J.GroupClear = J.Common["GroupClear"]
--- 选取单位添加到单位组(坐标)
--- 为[单位组]添加以([坐标X],[坐标Y])为圆心，[半径]为半径的圆范围内，满足[条件]的单位
--- whichGroup number group
--- x number
--- y number
--- radius number
--- filter function boolexpr
---@type fun(whichGroup:number,x:number,y:number,radius:number,filter:function):void
J.GroupEnumUnitsInRange = J.Common["GroupEnumUnitsInRange"]
--- 选取单位添加到单位组(坐标)(不建议使用)
--- 为[单位组]添加以([坐标X],[坐标Y])为圆心，[半径]为半径的圆范围内，满足[条件]的单位。无效项([N])
--- 最后一项是无效项，建议用上一个UI
--- whichGroup number group
--- x number
--- y number
--- radius number
--- filter function boolexpr
--- countLimit number int
---@type fun(whichGroup:number,x:number,y:number,radius:number,filter:function,countLimit:number):void
J.GroupEnumUnitsInRangeCounted = J.Common["GroupEnumUnitsInRangeCounted"]
--- 选取单位添加到单位组(点)
--- 为[单位组]添加以[坐标]为圆心，[半径]为半径的圆范围内，满足[条件]的单位
--- whichGroup number group
--- whichLocation number location
--- radius number
--- filter function boolexpr
---@type fun(whichGroup:number,whichLocation:number,radius:number,filter:function):void
J.GroupEnumUnitsInRangeOfLoc = J.Common["GroupEnumUnitsInRangeOfLoc"]
--- 选取单位添加到单位组(点)(不建议使用)
--- 为[单位组]添加以[坐标]为圆心，[半径]为半径的圆范围内，满足[条件]的单位。无效项([N])
--- 最后一项是无效项，建议用上一个UI
--- whichGroup number group
--- whichLocation number location
--- radius number
--- filter function boolexpr
--- countLimit number int
---@type fun(whichGroup:number,whichLocation:number,radius:number,filter:function,countLimit:number):void
J.GroupEnumUnitsInRangeOfLocCounted = J.Common["GroupEnumUnitsInRangeOfLocCounted"]
--- whichGroup number group
--- r number rect
--- filter function boolexpr
---@type fun(whichGroup:number,r:number,filter:function):void
J.GroupEnumUnitsInRect = J.Common["GroupEnumUnitsInRect"]
--- whichGroup number group
--- r number rect
--- filter function boolexpr
--- countLimit number int
---@type fun(whichGroup:number,r:number,filter:function,countLimit:number):void
J.GroupEnumUnitsInRectCounted = J.Common["GroupEnumUnitsInRectCounted"]
--- whichGroup number group
--- whichPlayer number player
--- filter function boolexpr
---@type fun(whichGroup:number,whichPlayer:number,filter:function):void
J.GroupEnumUnitsOfPlayer = J.Common["GroupEnumUnitsOfPlayer"]
--- whichGroup number group
--- unitname string
--- filter function boolexpr
---@type fun(whichGroup:number,unitname:string,filter:function):void
J.GroupEnumUnitsOfType = J.Common["GroupEnumUnitsOfType"]
--- whichGroup number group
--- unitname string
--- filter function boolexpr
--- countLimit number int
---@type fun(whichGroup:number,unitname:string,filter:function,countLimit:number):void
J.GroupEnumUnitsOfTypeCounted = J.Common["GroupEnumUnitsOfTypeCounted"]
--- whichGroup number group
--- whichPlayer number player
--- filter function boolexpr
---@type fun(whichGroup:number,whichPlayer:number,filter:function):void
J.GroupEnumUnitsSelected = J.Common["GroupEnumUnitsSelected"]
--- 发布命令(无目标)
--- 对[单位组]发布[Order]
--- 最多只能对单位组中12个单位发布命令.
--- whichGroup number group
--- order string
---@type fun(whichGroup:number,order:string):boolean
J.GroupImmediateOrder = J.Common["GroupImmediateOrder"]
--- 发布命令(无目标)(ID)
--- 对[单位组]发布[Order]
--- 最多只能对单位组中12个单位发布命令.
--- whichGroup number group
--- order number int
---@type fun(whichGroup:number,order:number):boolean
J.GroupImmediateOrderById = J.Common["GroupImmediateOrderById"]
--- 发布命令(指定坐标) [R]
--- 对[单位组]发布[Order]命令,目标点:([X],[Y])
--- 最多只能对单位组中12个单位发布命令.
--- whichGroup number group
--- order string
--- x number
--- y number
---@type fun(whichGroup:number,order:string,x:number,y:number):boolean
J.GroupPointOrder = J.Common["GroupPointOrder"]
--- 发布命令(指定坐标)(ID)
--- 对[单位组]发布[Order]命令,目标点:([X],[Y])
--- 最多只能对单位组中12个单位发布命令.
--- whichGroup number group
--- order number int
--- x number
--- y number
---@type fun(whichGroup:number,order:number,x:number,y:number):boolean
J.GroupPointOrderById = J.Common["GroupPointOrderById"]
--- 发布命令(指定点)(ID)
--- 对[单位组]发布[Order]命令,目标:[指定点]
--- 最多只能对单位组中12个单位发布命令.
--- whichGroup number group
--- order number int
--- whichLocation number location
---@type fun(whichGroup:number,order:number,whichLocation:number):boolean
J.GroupPointOrderByIdLoc = J.Common["GroupPointOrderByIdLoc"]
--- 发布命令(指定点)
--- 对[单位组]发布[Order]命令,目标:[指定点]
--- 最多只能对单位组中12个单位发布命令.
--- whichGroup number group
--- order string
--- whichLocation number location
---@type fun(whichGroup:number,order:string,whichLocation:number):boolean
J.GroupPointOrderLoc = J.Common["GroupPointOrderLoc"]
--- 移除单位 [R]
--- 为[单位组]删除[单位]
--- 并不影响单位本身.
--- whichGroup number group
--- whichUnit number unit
---@type fun(whichGroup:number,whichUnit:number):void
J.GroupRemoveUnit = J.Common["GroupRemoveUnit"]
--- 发布命令(指定单位)
--- 对[单位组]发布[Order]命令,目标:[单位]
--- 最多只能对单位组中12个单位发布命令.
--- whichGroup number group
--- order string
--- targetWidget number widget
---@type fun(whichGroup:number,order:string,targetWidget:number):boolean
J.GroupTargetOrder = J.Common["GroupTargetOrder"]
--- 发布命令(指定单位)(ID)
--- 对[单位组]发布[Order]命令,目标:[单位]
--- 最多只能对单位组中12个单位发布命令.
--- whichGroup number group
--- order number int
--- targetWidget number widget
---@type fun(whichGroup:number,order:number,targetWidget:number):boolean
J.GroupTargetOrderById = J.Common["GroupTargetOrderById"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):boolean
J.HaveSavedBoolean = J.Common["HaveSavedBoolean"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):boolean
J.HaveSavedHandle = J.Common["HaveSavedHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):boolean
J.HaveSavedInteger = J.Common["HaveSavedInteger"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):boolean
J.HaveSavedReal = J.Common["HaveSavedReal"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):boolean
J.HaveSavedString = J.Common["HaveSavedString"]
--- cache any gamecache
--- missionKey string
--- key string
---@type fun(cache:any,missionKey:string,key:string):boolean
J.HaveStoredBoolean = J.Common["HaveStoredBoolean"]
--- cache any gamecache
--- missionKey string
--- key string
---@type fun(cache:any,missionKey:string,key:string):boolean
J.HaveStoredInteger = J.Common["HaveStoredInteger"]
--- cache any gamecache
--- missionKey string
--- key string
---@type fun(cache:any,missionKey:string,key:string):boolean
J.HaveStoredReal = J.Common["HaveStoredReal"]
--- cache any gamecache
--- missionKey string
--- key string
---@type fun(cache:any,missionKey:string,key:string):boolean
J.HaveStoredString = J.Common["HaveStoredString"]
--- cache any gamecache
--- missionKey string
--- key string
---@type fun(cache:any,missionKey:string,key:string):boolean
J.HaveStoredUnit = J.Common["HaveStoredUnit"]
--- i number int
---@type fun(i:number):number
J.I2R = J.Common["I2R"]
--- i number int
---@type fun(i:number):string
J.I2S = J.Common["I2S"]
--- 提升技能等级 [R]
--- 使[单位]的[技能]等级提升1级
--- 改变死亡单位的光环技能会导致魔兽崩溃.
--- whichUnit number unit
--- abilcode number int
---@type fun(whichUnit:number,abilcode:number):number int
J.IncUnitAbilityLevel = J.Common["IncUnitAbilityLevel"]
--- 创建游戏缓存
--- 创建游戏缓存,使用文件名:[Filename]
--- campaignFile string
---@type fun(campaignFile:string):any gamecache
J.InitGameCache = J.Common["InitGameCache"]
--- <1.24> 新建哈希表 [C]
--- 创建一个新的哈希表
--- 您可以使用哈希表来储存临时数据
---@type fun():any hashtable
J.InitHashtable = J.Common["InitHashtable"]
---@type fun():boolean
J.IsCineFilterDisplayed = J.Common["IsCineFilterDisplayed"]
--- d number destructable
---@type fun(d:number):boolean
J.IsDestructableInvulnerable = J.Common["IsDestructableInvulnerable"]
---@type fun():boolean
J.IsFogEnabled = J.Common["IsFogEnabled"]
---@type fun():boolean
J.IsFogMaskEnabled = J.Common["IsFogMaskEnabled"]
--- x number
--- y number
--- whichPlayer number player
---@type fun(x:number,y:number,whichPlayer:number):boolean
J.IsFoggedToPlayer = J.Common["IsFoggedToPlayer"]
--- whichGameType any gametype
---@type fun(whichGameType:any):boolean
J.IsGameTypeSupported = J.Common["IsGameTypeSupported"]
--- unitId number int
---@type fun(unitId:number):boolean
J.IsHeroUnitId = J.Common["IsHeroUnitId"]
--- itemId number int
---@type fun(itemId:number):boolean
J.IsItemIdPawnable = J.Common["IsItemIdPawnable"]
--- itemId number int
---@type fun(itemId:number):boolean
J.IsItemIdPowerup = J.Common["IsItemIdPowerup"]
--- itemId number int
---@type fun(itemId:number):boolean
J.IsItemIdSellable = J.Common["IsItemIdSellable"]
--- whichItem number item
---@type fun(whichItem:number):boolean
J.IsItemInvulnerable = J.Common["IsItemInvulnerable"]
--- whichItem number item
---@type fun(whichItem:number):boolean
J.IsItemOwned = J.Common["IsItemOwned"]
--- whichItem number item
---@type fun(whichItem:number):boolean
J.IsItemPawnable = J.Common["IsItemPawnable"]
--- whichItem number item
---@type fun(whichItem:number):boolean
J.IsItemPowerup = J.Common["IsItemPowerup"]
--- whichItem number item
---@type fun(whichItem:number):boolean
J.IsItemSellable = J.Common["IsItemSellable"]
--- whichItem number item
---@type fun(whichItem:number):boolean
J.IsItemVisible = J.Common["IsItemVisible"]
--- lb number leaderboard
---@type fun(lb:number):boolean
J.IsLeaderboardDisplayed = J.Common["IsLeaderboardDisplayed"]
--- whichLocation number location
--- whichPlayer number player
---@type fun(whichLocation:number,whichPlayer:number):boolean
J.IsLocationFoggedToPlayer = J.Common["IsLocationFoggedToPlayer"]
--- whichRegion number region
--- whichLocation number location
---@type fun(whichRegion:number,whichLocation:number):boolean
J.IsLocationInRegion = J.Common["IsLocationInRegion"]
--- whichLocation number location
--- whichPlayer number player
---@type fun(whichLocation:number,whichPlayer:number):boolean
J.IsLocationMaskedToPlayer = J.Common["IsLocationMaskedToPlayer"]
--- whichLocation number location
--- whichPlayer number player
---@type fun(whichLocation:number,whichPlayer:number):boolean
J.IsLocationVisibleToPlayer = J.Common["IsLocationVisibleToPlayer"]
--- whichMapFlag any mapflag
---@type fun(whichMapFlag:any):boolean
J.IsMapFlagSet = J.Common["IsMapFlagSet"]
--- x number
--- y number
--- whichPlayer number player
---@type fun(x:number,y:number,whichPlayer:number):boolean
J.IsMaskedToPlayer = J.Common["IsMaskedToPlayer"]
--- lb number multiboard
---@type fun(lb:number):boolean
J.IsMultiboardDisplayed = J.Common["IsMultiboardDisplayed"]
--- lb number multiboard
---@type fun(lb:number):boolean
J.IsMultiboardMinimized = J.Common["IsMultiboardMinimized"]
---@type fun():boolean
J.IsNoDefeatCheat = J.Common["IsNoDefeatCheat"]
---@type fun():boolean
J.IsNoVictoryCheat = J.Common["IsNoVictoryCheat"]
--- whichPlayer number player
--- otherPlayer number player
---@type fun(whichPlayer:number,otherPlayer:number):boolean
J.IsPlayerAlly = J.Common["IsPlayerAlly"]
--- whichPlayer number player
--- otherPlayer number player
---@type fun(whichPlayer:number,otherPlayer:number):boolean
J.IsPlayerEnemy = J.Common["IsPlayerEnemy"]
--- whichPlayer number player
--- whichForce number force
---@type fun(whichPlayer:number,whichForce:number):boolean
J.IsPlayerInForce = J.Common["IsPlayerInForce"]
--- whichPlayer number player
---@type fun(whichPlayer:number):boolean
J.IsPlayerObserver = J.Common["IsPlayerObserver"]
--- whichPlayer number player
--- pref any racepreference
---@type fun(whichPlayer:number,pref:any):boolean
J.IsPlayerRacePrefSet = J.Common["IsPlayerRacePrefSet"]
--- x number
--- y number
---@type fun(x:number,y:number):boolean
J.IsPointBlighted = J.Common["IsPointBlighted"]
--- whichRegion number region
--- x number
--- y number
---@type fun(whichRegion:number,x:number,y:number):boolean
J.IsPointInRegion = J.Common["IsPointInRegion"]
--- whichQuest number quest
---@type fun(whichQuest:number):boolean
J.IsQuestCompleted = J.Common["IsQuestCompleted"]
--- whichQuest number quest
---@type fun(whichQuest:number):boolean
J.IsQuestDiscovered = J.Common["IsQuestDiscovered"]
--- whichQuest number quest
---@type fun(whichQuest:number):boolean
J.IsQuestEnabled = J.Common["IsQuestEnabled"]
--- whichQuest number quest
---@type fun(whichQuest:number):boolean
J.IsQuestFailed = J.Common["IsQuestFailed"]
--- whichQuestItem number questitem
---@type fun(whichQuestItem:number):boolean
J.IsQuestItemCompleted = J.Common["IsQuestItemCompleted"]
--- whichQuest number quest
---@type fun(whichQuest:number):boolean
J.IsQuestRequired = J.Common["IsQuestRequired"]
--- whichHero number unit
---@type fun(whichHero:number):boolean
J.IsSuspendedXP = J.Common["IsSuspendedXP"]
--- x number
--- y number
--- t any pathingtype
---@type fun(x:number,y:number,t:any):boolean
J.IsTerrainPathable = J.Common["IsTerrainPathable"]
--- whichDialog number timerdialog
---@type fun(whichDialog:number):boolean
J.IsTimerDialogDisplayed = J.Common["IsTimerDialogDisplayed"]
--- whichTrigger number trigger
---@type fun(whichTrigger:number):boolean
J.IsTriggerEnabled = J.Common["IsTriggerEnabled"]
--- whichTrigger number trigger
---@type fun(whichTrigger:number):boolean
J.IsTriggerWaitOnSleeps = J.Common["IsTriggerWaitOnSleeps"]
--- whichUnit number unit
--- whichSpecifiedUnit number unit
---@type fun(whichUnit:number,whichSpecifiedUnit:number):boolean
J.IsUnit = J.Common["IsUnit"]
--- whichUnit number unit
--- whichPlayer number player
---@type fun(whichUnit:number,whichPlayer:number):boolean
J.IsUnitAlly = J.Common["IsUnitAlly"]
--- whichUnit number unit
--- whichPlayer number player
---@type fun(whichUnit:number,whichPlayer:number):boolean
J.IsUnitDetected = J.Common["IsUnitDetected"]
--- whichUnit number unit
--- whichPlayer number player
---@type fun(whichUnit:number,whichPlayer:number):boolean
J.IsUnitEnemy = J.Common["IsUnitEnemy"]
--- whichUnit number unit
--- whichPlayer number player
---@type fun(whichUnit:number,whichPlayer:number):boolean
J.IsUnitFogged = J.Common["IsUnitFogged"]
--- whichUnit number unit
---@type fun(whichUnit:number):boolean
J.IsUnitHidden = J.Common["IsUnitHidden"]
--- unitId number int
--- whichUnitType any unittype
---@type fun(unitId:number,whichUnitType:any):boolean
J.IsUnitIdType = J.Common["IsUnitIdType"]
--- whichUnit number unit
---@type fun(whichUnit:number):boolean
J.IsUnitIllusion = J.Common["IsUnitIllusion"]
--- whichUnit number unit
--- whichForce number force
---@type fun(whichUnit:number,whichForce:number):boolean
J.IsUnitInForce = J.Common["IsUnitInForce"]
--- whichUnit number unit
--- whichGroup number group
---@type fun(whichUnit:number,whichGroup:number):boolean
J.IsUnitInGroup = J.Common["IsUnitInGroup"]
--- whichUnit number unit
--- otherUnit number unit
--- distance number
---@type fun(whichUnit:number,otherUnit:number,distance:number):boolean
J.IsUnitInRange = J.Common["IsUnitInRange"]
--- whichUnit number unit
--- whichLocation number location
--- distance number
---@type fun(whichUnit:number,whichLocation:number,distance:number):boolean
J.IsUnitInRangeLoc = J.Common["IsUnitInRangeLoc"]
--- whichUnit number unit
--- x number
--- y number
--- distance number
---@type fun(whichUnit:number,x:number,y:number,distance:number):boolean
J.IsUnitInRangeXY = J.Common["IsUnitInRangeXY"]
--- whichRegion number region
--- whichUnit number unit
---@type fun(whichRegion:number,whichUnit:number):boolean
J.IsUnitInRegion = J.Common["IsUnitInRegion"]
--- whichUnit number unit
--- whichTransport number unit
---@type fun(whichUnit:number,whichTransport:number):boolean
J.IsUnitInTransport = J.Common["IsUnitInTransport"]
--- whichUnit number unit
--- whichPlayer number player
---@type fun(whichUnit:number,whichPlayer:number):boolean
J.IsUnitInvisible = J.Common["IsUnitInvisible"]
--- whichUnit number unit
---@type fun(whichUnit:number):boolean
J.IsUnitLoaded = J.Common["IsUnitLoaded"]
--- whichUnit number unit
--- whichPlayer number player
---@type fun(whichUnit:number,whichPlayer:number):boolean
J.IsUnitMasked = J.Common["IsUnitMasked"]
--- whichUnit number unit
--- whichPlayer number player
---@type fun(whichUnit:number,whichPlayer:number):boolean
J.IsUnitOwnedByPlayer = J.Common["IsUnitOwnedByPlayer"]
--- whichHero number unit
---@type fun(whichHero:number):boolean
J.IsUnitPaused = J.Common["IsUnitPaused"]
--- whichUnit number unit
--- whichRace any race
---@type fun(whichUnit:number,whichRace:any):boolean
J.IsUnitRace = J.Common["IsUnitRace"]
--- whichUnit number unit
--- whichPlayer number player
---@type fun(whichUnit:number,whichPlayer:number):boolean
J.IsUnitSelected = J.Common["IsUnitSelected"]
--- whichUnit number unit
--- whichUnitType any unittype
---@type fun(whichUnit:number,whichUnitType:any):boolean
J.IsUnitType = J.Common["IsUnitType"]
--- whichUnit number unit
--- whichPlayer number player
---@type fun(whichUnit:number,whichPlayer:number):boolean
J.IsUnitVisible = J.Common["IsUnitVisible"]
--- x number
--- y number
--- whichPlayer number player
---@type fun(x:number,y:number,whichPlayer:number):boolean
J.IsVisibleToPlayer = J.Common["IsVisibleToPlayer"]
--- whichPeon number unit
--- unitToBuild string
--- x number
--- y number
---@type fun(whichPeon:number,unitToBuild:string,x:number,y:number):boolean
J.IssueBuildOrder = J.Common["IssueBuildOrder"]
--- 发布建造命令(指定坐标) [R]
--- 命令[单位]建造[单位类型]在坐标:([X],[Y])
--- whichPeon number unit
--- unitId number int
--- x number
--- y number
---@type fun(whichPeon:number,unitId:number,x:number,y:number):boolean
J.IssueBuildOrderById = J.Common["IssueBuildOrderById"]
--- 发布命令(无目标)
--- 对[单位]发布[Order]命令
--- whichUnit number unit
--- order string
---@type fun(whichUnit:number,order:string):boolean
J.IssueImmediateOrder = J.Common["IssueImmediateOrder"]
--- 发布命令(无目标)(ID)
--- 对[单位]发布[Order]命令
--- whichUnit number unit
--- order number int
---@type fun(whichUnit:number,order:number):boolean
J.IssueImmediateOrderById = J.Common["IssueImmediateOrderById"]
--- whichUnit number unit
--- order string
--- x number
--- y number
--- instantTargetWidget number widget
---@type fun(whichUnit:number,order:string,x:number,y:number,instantTargetWidget:number):boolean
J.IssueInstantPointOrder = J.Common["IssueInstantPointOrder"]
--- whichUnit number unit
--- order number int
--- x number
--- y number
--- instantTargetWidget number widget
---@type fun(whichUnit:number,order:number,x:number,y:number,instantTargetWidget:number):boolean
J.IssueInstantPointOrderById = J.Common["IssueInstantPointOrderById"]
--- whichUnit number unit
--- order string
--- targetWidget number widget
--- instantTargetWidget number widget
---@type fun(whichUnit:number,order:string,targetWidget:number,instantTargetWidget:number):boolean
J.IssueInstantTargetOrder = J.Common["IssueInstantTargetOrder"]
--- whichUnit number unit
--- order number int
--- targetWidget number widget
--- instantTargetWidget number widget
---@type fun(whichUnit:number,order:number,targetWidget:number,instantTargetWidget:number):boolean
J.IssueInstantTargetOrderById = J.Common["IssueInstantTargetOrderById"]
--- 发布中介命令(无目标)
--- 使[玩家]对[单位]发布[Order]命令
--- 可以用来对非本玩家单位发布命令.
--- forWhichPlayer number player
--- neutralStructure number unit
--- unitToBuild string
---@type fun(forWhichPlayer:number,neutralStructure:number,unitToBuild:string):boolean
J.IssueNeutralImmediateOrder = J.Common["IssueNeutralImmediateOrder"]
--- 发布中介命令(无目标)(ID)
--- 使[玩家]对[单位]发布[Order]命令
--- 可以用来对非本玩家单位发布命令.
--- forWhichPlayer number player
--- neutralStructure number unit
--- unitId number int
---@type fun(forWhichPlayer:number,neutralStructure:number,unitId:number):boolean
J.IssueNeutralImmediateOrderById = J.Common["IssueNeutralImmediateOrderById"]
--- 发布中介命令(指定坐标)
--- 使[玩家]对[单位]发布[Order]命令到坐标:([X],[Y])
--- 可以用来对非本玩家单位发布命令.
--- forWhichPlayer number player
--- neutralStructure number unit
--- unitToBuild string
--- x number
--- y number
---@type fun(forWhichPlayer:number,neutralStructure:number,unitToBuild:string,x:number,y:number):boolean
J.IssueNeutralPointOrder = J.Common["IssueNeutralPointOrder"]
--- 发布中介命令(指定坐标)(ID)
--- 使[玩家]对[单位]发布[Order]命令到坐标:([X],[Y])
--- 可以用来对非本玩家单位发布命令.
--- forWhichPlayer number player
--- neutralStructure number unit
--- unitId number int
--- x number
--- y number
---@type fun(forWhichPlayer:number,neutralStructure:number,unitId:number,x:number,y:number):boolean
J.IssueNeutralPointOrderById = J.Common["IssueNeutralPointOrderById"]
--- 发布中介命令(指定单位)
--- 使[玩家]对[单位]发布[Order]命令到目标:[单位]
--- 可以用来对非本玩家单位发布命令.
--- forWhichPlayer number player
--- neutralStructure number unit
--- unitToBuild string
--- target number widget
---@type fun(forWhichPlayer:number,neutralStructure:number,unitToBuild:string,target:number):boolean
J.IssueNeutralTargetOrder = J.Common["IssueNeutralTargetOrder"]
--- 发布中介命令(指定单位)(ID)
--- 使[玩家]对[单位]发布[Order]命令到目标:[单位]
--- 可以用来对非本玩家单位发布命令.
--- forWhichPlayer number player
--- neutralStructure number unit
--- unitId number int
--- target number widget
---@type fun(forWhichPlayer:number,neutralStructure:number,unitId:number,target:number):boolean
J.IssueNeutralTargetOrderById = J.Common["IssueNeutralTargetOrderById"]
--- 发布命令(指定坐标)
--- 对[单位]发布[Order]命令到坐标:([X],[Y])
--- whichUnit number unit
--- order string
--- x number
--- y number
---@type fun(whichUnit:number,order:string,x:number,y:number):boolean
J.IssuePointOrder = J.Common["IssuePointOrder"]
--- 发布命令(指定坐标)(ID)
--- 对[单位]发布[Order]命令到坐标:([X],[Y])
--- whichUnit number unit
--- order number int
--- x number
--- y number
---@type fun(whichUnit:number,order:number,x:number,y:number):boolean
J.IssuePointOrderById = J.Common["IssuePointOrderById"]
--- 发布命令(指定点)(ID)
--- 对[单位]发布[Order]命令到目标点:[指定点]
--- whichUnit number unit
--- order number int
--- whichLocation number location
---@type fun(whichUnit:number,order:number,whichLocation:number):boolean
J.IssuePointOrderByIdLoc = J.Common["IssuePointOrderByIdLoc"]
--- 发布命令(指定点)
--- 对[单位]发布[Order]命令到目标点:[指定点]
--- whichUnit number unit
--- order string
--- whichLocation number location
---@type fun(whichUnit:number,order:string,whichLocation:number):boolean
J.IssuePointOrderLoc = J.Common["IssuePointOrderLoc"]
--- 发布命令(指定单位)
--- 对[单位]发布[Order]命令到目标:[单位]
--- whichUnit number unit
--- order string
--- targetWidget number widget
---@type fun(whichUnit:number,order:string,targetWidget:number):boolean
J.IssueTargetOrder = J.Common["IssueTargetOrder"]
--- 发布命令(指定单位)(ID)
--- 对[单位]发布[Order]命令到目标:[单位]
--- whichUnit number unit
--- order number int
--- targetWidget number widget
---@type fun(whichUnit:number,order:number,targetWidget:number):boolean
J.IssueTargetOrderById = J.Common["IssueTargetOrderById"]
--- 添加物品类型 [R]
--- 在[物品池]中添加一个[物品]比重为[数值]
--- 比重越高被选择的机率越大.
--- whichItemPool number itempool
--- itemId number int
--- weight number
---@type fun(whichItemPool:number,itemId:number,weight:number):void
J.ItemPoolAddItemType = J.Common["ItemPoolAddItemType"]
--- 删除物品类型 [R]
--- 从[物品池]中删除[物品]
--- whichItemPool number itempool
--- itemId number int
---@type fun(whichItemPool:number,itemId:number):void
J.ItemPoolRemoveItemType = J.Common["ItemPoolRemoveItemType"]
--- 杀死
--- 杀死[可破坏物]
--- d number destructable
---@type fun(d:number):void
J.KillDestructable = J.Common["KillDestructable"]
--- 删除音效
--- 删除[音效]
--- 如果音效正在播放则在播放结束时删除.
--- soundHandle number sound
---@type fun(soundHandle:number):void
J.KillSoundWhenDone = J.Common["KillSoundWhenDone"]
--- 杀死
--- 杀死[单位]
--- whichUnit number unit
---@type fun(whichUnit:number):void
J.KillUnit = J.Common["KillUnit"]
--- 添加玩家
--- 添加[某个玩家]到[某个排行榜],使用名字:[文字]设置分数:[Value]
--- lb number leaderboard
--- label string
--- value number int
--- p number player
---@type fun(lb:number,label:string,value:number,p:number):void
J.LeaderboardAddItem = J.Common["LeaderboardAddItem"]
--- 清空 [R]
--- 清空[排行榜]
--- 清空排行榜中所有内容.
--- lb number leaderboard
---@type fun(lb:number):void
J.LeaderboardClear = J.Common["LeaderboardClear"]
--- 显示/隐藏 [R]
--- 设置[排行榜][显示/隐藏]
--- 排行榜不能在地图初始化时显示.
--- lb number leaderboard
--- show boolean
---@type fun(lb:number,show:boolean):void
J.LeaderboardDisplay = J.Common["LeaderboardDisplay"]
--- lb number leaderboard
---@type fun(lb:number):number int
J.LeaderboardGetItemCount = J.Common["LeaderboardGetItemCount"]
--- lb number leaderboard
---@type fun(lb:number):string
J.LeaderboardGetLabelText = J.Common["LeaderboardGetLabelText"]
--- lb number leaderboard
--- p number player
---@type fun(lb:number,p:number):number int
J.LeaderboardGetPlayerIndex = J.Common["LeaderboardGetPlayerIndex"]
--- lb number leaderboard
--- p number player
---@type fun(lb:number,p:number):boolean
J.LeaderboardHasPlayerItem = J.Common["LeaderboardHasPlayerItem"]
--- lb number leaderboard
--- index number int
---@type fun(lb:number,index:number):void
J.LeaderboardRemoveItem = J.Common["LeaderboardRemoveItem"]
--- 移除玩家
--- 把[某个玩家]从[某个排行榜]移除
--- lb number leaderboard
--- p number player
---@type fun(lb:number,p:number):void
J.LeaderboardRemovePlayerItem = J.Common["LeaderboardRemovePlayerItem"]
--- lb number leaderboard
--- whichItem number int
--- val string
---@type fun(lb:number,whichItem:number,val:string):void
J.LeaderboardSetItemLabel = J.Common["LeaderboardSetItemLabel"]
--- lb number leaderboard
--- whichItem number int
--- red number int
--- green number int
--- blue number int
--- alpha number int
---@type fun(lb:number,whichItem:number,red:number,green:number,blue:number,alpha:number):void
J.LeaderboardSetItemLabelColor = J.Common["LeaderboardSetItemLabelColor"]
--- lb number leaderboard
--- whichItem number int
--- showLabel boolean
--- showValue boolean
--- showIcon boolean
---@type fun(lb:number,whichItem:number,showLabel:boolean,showValue:boolean,showIcon:boolean):void
J.LeaderboardSetItemStyle = J.Common["LeaderboardSetItemStyle"]
--- lb number leaderboard
--- whichItem number int
--- val number int
---@type fun(lb:number,whichItem:number,val:number):void
J.LeaderboardSetItemValue = J.Common["LeaderboardSetItemValue"]
--- lb number leaderboard
--- whichItem number int
--- red number int
--- green number int
--- blue number int
--- alpha number int
---@type fun(lb:number,whichItem:number,red:number,green:number,blue:number,alpha:number):void
J.LeaderboardSetItemValueColor = J.Common["LeaderboardSetItemValueColor"]
--- 设置标题
--- 设置[某个排行榜]的标题为[文字]
--- lb number leaderboard
--- label string
---@type fun(lb:number,label:string):void
J.LeaderboardSetLabel = J.Common["LeaderboardSetLabel"]
--- 设置文字颜色 [R]
--- 设置[某个排行榜]的文字颜色为([Red],[Green],[Blue]) Alpha通道值为:[Alpha]
--- 颜色格式为(红,绿,蓝). Alpha通道值0为不可见. 颜色值和Alpha通道值取值范围为0-255.
--- lb number leaderboard
--- red number int
--- green number int
--- blue number int
--- alpha number int
---@type fun(lb:number,red:number,green:number,blue:number,alpha:number):void
J.LeaderboardSetLabelColor = J.Common["LeaderboardSetLabelColor"]
--- lb number leaderboard
--- count number int
---@type fun(lb:number,count:number):void
J.LeaderboardSetSizeByItemCount = J.Common["LeaderboardSetSizeByItemCount"]
--- 设置显示样式
--- 设置[某个排行榜]的显示样式:[显示/隐藏]标题,[显示/隐藏]文字,[显示/隐藏]分数,[显示/隐藏]图标
--- lb number leaderboard
--- showLabel boolean
--- showNames boolean
--- showValues boolean
--- showIcons boolean
---@type fun(lb:number,showLabel:boolean,showNames:boolean,showValues:boolean,showIcons:boolean):void
J.LeaderboardSetStyle = J.Common["LeaderboardSetStyle"]
--- 设置数值颜色 [R]
--- 设置[某个排行榜]的数值颜色为([Red],[Green],[Blue]) Alpha通道值为:[Alpha]
--- 颜色格式为(红,绿,蓝). Alpha通道值0为不可见. 颜色值和Alpha通道值取值范围为0-255.
--- lb number leaderboard
--- red number int
--- green number int
--- blue number int
--- alpha number int
---@type fun(lb:number,red:number,green:number,blue:number,alpha:number):void
J.LeaderboardSetValueColor = J.Common["LeaderboardSetValueColor"]
--- lb number leaderboard
--- ascending boolean
---@type fun(lb:number,ascending:boolean):void
J.LeaderboardSortItemsByLabel = J.Common["LeaderboardSortItemsByLabel"]
--- lb number leaderboard
--- ascending boolean
---@type fun(lb:number,ascending:boolean):void
J.LeaderboardSortItemsByPlayer = J.Common["LeaderboardSortItemsByPlayer"]
--- lb number leaderboard
--- ascending boolean
---@type fun(lb:number,ascending:boolean):void
J.LeaderboardSortItemsByValue = J.Common["LeaderboardSortItemsByValue"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number ability
J.LoadAbilityHandle = J.Common["LoadAbilityHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):boolean
J.LoadBoolean = J.Common["LoadBoolean"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):function boolexpr
J.LoadBooleanExprHandle = J.Common["LoadBooleanExprHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number button
J.LoadButtonHandle = J.Common["LoadButtonHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):function defeatcondition
J.LoadDefeatConditionHandle = J.Common["LoadDefeatConditionHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number destructable
J.LoadDestructableHandle = J.Common["LoadDestructableHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number dialog
J.LoadDialogHandle = J.Common["LoadDialogHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number effect
J.LoadEffectHandle = J.Common["LoadEffectHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number fogmodifier
J.LoadFogModifierHandle = J.Common["LoadFogModifierHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):any fogstate
J.LoadFogStateHandle = J.Common["LoadFogStateHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number force
J.LoadForceHandle = J.Common["LoadForceHandle"]
--- 读取进度
--- 读取游戏进度[Filename]([Show/Skip]计分屏)
--- saveFileName string
--- doScoreScreen boolean
---@type fun(saveFileName:string,doScoreScreen:boolean):void
J.LoadGame = J.Common["LoadGame"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number group
J.LoadGroupHandle = J.Common["LoadGroupHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):any hashtable
J.LoadHashtableHandle = J.Common["LoadHashtableHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number image
J.LoadImageHandle = J.Common["LoadImageHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number int
J.LoadInteger = J.Common["LoadInteger"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number item
J.LoadItemHandle = J.Common["LoadItemHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number itempool
J.LoadItemPoolHandle = J.Common["LoadItemPoolHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number leaderboard
J.LoadLeaderboardHandle = J.Common["LoadLeaderboardHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number lightning
J.LoadLightningHandle = J.Common["LoadLightningHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number location
J.LoadLocationHandle = J.Common["LoadLocationHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number multiboard
J.LoadMultiboardHandle = J.Common["LoadMultiboardHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number multiboarditem
J.LoadMultiboardItemHandle = J.Common["LoadMultiboardItemHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number player
J.LoadPlayerHandle = J.Common["LoadPlayerHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number quest
J.LoadQuestHandle = J.Common["LoadQuestHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number questitem
J.LoadQuestItemHandle = J.Common["LoadQuestItemHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number
J.LoadReal = J.Common["LoadReal"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number rect
J.LoadRectHandle = J.Common["LoadRectHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number region
J.LoadRegionHandle = J.Common["LoadRegionHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number sound
J.LoadSoundHandle = J.Common["LoadSoundHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):string
J.LoadStr = J.Common["LoadStr"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number texttag
J.LoadTextTagHandle = J.Common["LoadTextTagHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number timerdialog
J.LoadTimerDialogHandle = J.Common["LoadTimerDialogHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number timer
J.LoadTimerHandle = J.Common["LoadTimerHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):any trackable
J.LoadTrackableHandle = J.Common["LoadTrackableHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):function triggeraction
J.LoadTriggerActionHandle = J.Common["LoadTriggerActionHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):function triggercondition
J.LoadTriggerConditionHandle = J.Common["LoadTriggerConditionHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):any event
J.LoadTriggerEventHandle = J.Common["LoadTriggerEventHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number trigger
J.LoadTriggerHandle = J.Common["LoadTriggerHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):any ubersplat
J.LoadUbersplatHandle = J.Common["LoadUbersplatHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number unit
J.LoadUnitHandle = J.Common["LoadUnitHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number unitpool
J.LoadUnitPoolHandle = J.Common["LoadUnitPoolHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):number widget
J.LoadWidgetHandle = J.Common["LoadWidgetHandle"]
--- x number
--- y number
---@type fun(x:number,y:number):number location
J.Location = J.Common["Location"]
--- 移动闪电效果(指定点)
--- 移动[某个闪电效果],使其连接[坐标]到[坐标]
--- whichBolt number lightning
--- checkVisibility boolean
--- x1 number
--- y1 number
--- x2 number
--- y2 number
---@type fun(whichBolt:number,checkVisibility:boolean,x1:number,y1:number,x2:number,y2:number):boolean
J.MoveLightning = J.Common["MoveLightning"]
--- 移动闪电效果(指定坐标) [R]
--- 移动[某个闪电效果]到新位置,([Boolean]检查可见性) 新起始点: ([X],[Y],[Z]) 新终结点: ([X],[Y],[Z])
--- 可指定Z坐标. 允许检查可见性则在指定起始点和终结点都不可见时将不移动闪电效果.
--- whichBolt number lightning
--- checkVisibility boolean
--- x1 number
--- y1 number
--- z1 number
--- x2 number
--- y2 number
--- z2 number
---@type fun(whichBolt:number,checkVisibility:boolean,x1:number,y1:number,z1:number,x2:number,y2:number,z2:number):boolean
J.MoveLightningEx = J.Common["MoveLightningEx"]
--- 移动点 [R]
--- 移动[坐标]到([X],[Y])
--- 该点必须是一个变量. 因为移动一个不可重用的点是无意义的.
--- whichLocation number location
--- newX number
--- newY number
---@type fun(whichLocation:number,newX:number,newY:number):void
J.MoveLocation = J.Common["MoveLocation"]
--- 移动矩形区域(指定坐标) [R]
--- 移动[矩形区域]到([X],[Y])
--- 该区域必须是一个变量. 目标点将作为该区域的新中心点.
--- whichRect number rect
--- newCenterX number
--- newCenterY number
---@type fun(whichRect:number,newCenterX:number,newCenterY:number):void
J.MoveRectTo = J.Common["MoveRectTo"]
--- 移动矩形区域(指定点)
--- 移动[矩形区域]到[目标点]
--- 该区域必须是一个变量. 目标点将作为该区域的新中心点.
--- whichRect number rect
--- newCenterLoc number location
---@type fun(whichRect:number,newCenterLoc:number):void
J.MoveRectToLoc = J.Common["MoveRectToLoc"]
--- 清空多面板
--- 清空[某个多面板]
--- 清空该多面板中的所有行和列.
--- lb number multiboard
---@type fun(lb:number):void
J.MultiboardClear = J.Common["MultiboardClear"]
--- 显示/隐藏 [R]
--- 设置[某个多面板][显示/隐藏]
--- 多面板不能在地图初始化时显示.
--- lb number multiboard
--- show boolean
---@type fun(lb:number,show:boolean):void
J.MultiboardDisplay = J.Common["MultiboardDisplay"]
--- lb number multiboard
---@type fun(lb:number):number int
J.MultiboardGetColumnCount = J.Common["MultiboardGetColumnCount"]
--- lb number multiboard
--- row number int
--- column number int
---@type fun(lb:number,row:number,column:number):number multiboarditem
J.MultiboardGetItem = J.Common["MultiboardGetItem"]
--- lb number multiboard
---@type fun(lb:number):number int
J.MultiboardGetRowCount = J.Common["MultiboardGetRowCount"]
--- lb number multiboard
---@type fun(lb:number):string
J.MultiboardGetTitleText = J.Common["MultiboardGetTitleText"]
--- 最大/最小化 [R]
--- 设置[某个多面板][Minimize/Maximize]
--- 最小化的多面板只显示标题.
--- lb number multiboard
--- minimize boolean
---@type fun(lb:number,minimize:boolean):void
J.MultiboardMinimize = J.Common["MultiboardMinimize"]
--- 删除多面板项目 [R]
--- 删除[多面板项目]
--- 并不会影响对多面板的显示. 多面板项目指向多面板但不附属于多面板.
--- mbi number multiboarditem
---@type fun(mbi:number):void
J.MultiboardReleaseItem = J.Common["MultiboardReleaseItem"]
--- 设置列数
--- 设置[某个多面板]的列数为[Columns]
--- lb number multiboard
--- count number int
---@type fun(lb:number,count:number):void
J.MultiboardSetColumnCount = J.Common["MultiboardSetColumnCount"]
--- 设置指定项目图标 [R]
--- 设置[多面板项目]的项目图标为[Icon File]
--- 颜色格式为(红,绿,蓝). Alpha值为0是不可见的. 颜色值和Alpha值取值范围为0-255.
--- mbi number multiboarditem
--- iconFileName string
---@type fun(mbi:number,iconFileName:string):void
J.MultiboardSetItemIcon = J.Common["MultiboardSetItemIcon"]
--- 设置指定项目显示风格 [R]
--- 设置[多面板项目]的显示风格:[显示/隐藏]文字[显示/隐藏]图标
--- mbi number multiboarditem
--- showValue boolean
--- showIcon boolean
---@type fun(mbi:number,showValue:boolean,showIcon:boolean):void
J.MultiboardSetItemStyle = J.Common["MultiboardSetItemStyle"]
--- 设置指定项目文本 [R]
--- 设置[多面板项目]的项目文本为[文字]
--- mbi number multiboarditem
--- val string
---@type fun(mbi:number,val:string):void
J.MultiboardSetItemValue = J.Common["MultiboardSetItemValue"]
--- 设置指定项目颜色 [R]
--- 设置[多面板项目]的项目颜色为([Red],[Green],[Blue]), Alpha值为[Alpha]
--- 颜色格式为(红,绿,蓝). Alpha值为0是不可见的. 颜色值和Alpha值取值范围为0-255.
--- mbi number multiboarditem
--- red number int
--- green number int
--- blue number int
--- alpha number int
---@type fun(mbi:number,red:number,green:number,blue:number,alpha:number):void
J.MultiboardSetItemValueColor = J.Common["MultiboardSetItemValueColor"]
--- 设置指定项目宽度 [R]
--- 设置[多面板项目]的项目宽度为[Width]倍屏幕宽度
--- 颜色格式为(红,绿,蓝). Alpha值为0是不可见的. 颜色值和Alpha值取值范围为0-255.
--- mbi number multiboarditem
--- width number
---@type fun(mbi:number,width:number):void
J.MultiboardSetItemWidth = J.Common["MultiboardSetItemWidth"]
--- 设置所有项目图标 [R]
--- 设置[多面板]的所有项目图标为[Icon File]
--- 可以设置行/列数为0来指代所有的行/列.
--- lb number multiboard
--- iconPath string
---@type fun(lb:number,iconPath:string):void
J.MultiboardSetItemsIcon = J.Common["MultiboardSetItemsIcon"]
--- 设置所有项目显示风格 [R]
--- 设置[多面板]的所有项目显示风格:[显示/隐藏]文字[显示/隐藏]图标
--- 颜色格式为(红,绿,蓝). Alpha值为0是不可见的. 颜色值和Alpha值取值范围为0-255.
--- lb number multiboard
--- showValues boolean
--- showIcons boolean
---@type fun(lb:number,showValues:boolean,showIcons:boolean):void
J.MultiboardSetItemsStyle = J.Common["MultiboardSetItemsStyle"]
--- 设置所有项目文本 [R]
--- 设置[多面板]的所有项目文本为[文字]
--- 颜色格式为(红,绿,蓝). Alpha值为0是不可见的. 颜色值和Alpha值取值范围为0-255.
--- lb number multiboard
--- value string
---@type fun(lb:number,value:string):void
J.MultiboardSetItemsValue = J.Common["MultiboardSetItemsValue"]
--- 设置所有项目颜色 [R]
--- 设置[多面板]的所有项目颜色为([Red],[Green],[Blue]), Alpha值为[Alpha]
--- 颜色格式为(红,绿,蓝). Alpha值为0是不可见的. 颜色值和Alpha值取值范围为0-255.
--- lb number multiboard
--- red number int
--- green number int
--- blue number int
--- alpha number int
---@type fun(lb:number,red:number,green:number,blue:number,alpha:number):void
J.MultiboardSetItemsValueColor = J.Common["MultiboardSetItemsValueColor"]
--- 设置所有项目宽度 [R]
--- 设置[多面板]的所有项目宽度为[Width]倍屏幕宽度
--- 可以设置行/列数为0来指代所有的行/列.
--- lb number multiboard
--- width number
---@type fun(lb:number,width:number):void
J.MultiboardSetItemsWidth = J.Common["MultiboardSetItemsWidth"]
--- 设置行数
--- 设置[某个多面板]的行数为[Rows]
--- lb number multiboard
--- count number int
---@type fun(lb:number,count:number):void
J.MultiboardSetRowCount = J.Common["MultiboardSetRowCount"]
--- 设置标题
--- 设置[某个多面板]的标题为[文字]
--- lb number multiboard
--- label string
---@type fun(lb:number,label:string):void
J.MultiboardSetTitleText = J.Common["MultiboardSetTitleText"]
--- 设置标题颜色 [R]
--- 设置[某个多面板]的标题颜色为([Red],[Green],[Blue]), Alpha值为[Alpha]
--- 颜色格式为(红,绿,蓝). Alpha值为0是不可见的. 颜色值和Alpha值取值范围为0-255.
--- lb number multiboard
--- red number int
--- green number int
--- blue number int
--- alpha number int
---@type fun(lb:number,red:number,green:number,blue:number,alpha:number):void
J.MultiboardSetTitleTextColor = J.Common["MultiboardSetTitleTextColor"]
--- 显示/隐藏多面板模式 [R]
--- [打开/关闭]隐藏多面板模式
--- 隐藏多面板模式将无法显示多面板.
--- flag boolean
---@type fun(flag:boolean):void
J.MultiboardSuppressDisplay = J.Common["MultiboardSuppressDisplay"]
--- environmentName string
---@type fun(environmentName:string):void
J.NewSoundEnvironment = J.Common["NewSoundEnvironment"]
--- orderIdString string
---@type fun(orderIdString:string):number int
J.OrderId = J.Common["OrderId"]
--- orderId number int
---@type fun(orderId:number):string
J.OrderId2String = J.Common["OrderId2String"]
--- x number
--- y number
---@type fun(x:number,y:number):void
J.PanCameraTo = J.Common["PanCameraTo"]
--- 平移镜头(所有玩家)(限时) [R]
--- 平移玩家镜头到([X],[Y]),持续[Time]秒
--- x number
--- y number
--- duration number
---@type fun(x:number,y:number,duration:number):void
J.PanCameraToTimed = J.Common["PanCameraToTimed"]
--- 指定高度平移镜头(所有玩家)(限时) [R]
--- 平移玩家镜头到([X],[Y]),镜头距离地面高度为[Z],持续[Time]秒
--- 在指定移动路径上镜头不会低于地面高度.
--- x number
--- y number
--- zOffsetDest number
--- duration number
---@type fun(x:number,y:number,zOffsetDest:number,duration:number):void
J.PanCameraToTimedWithZ = J.Common["PanCameraToTimedWithZ"]
--- x number
--- y number
--- zOffsetDest number
---@type fun(x:number,y:number,zOffsetDest:number):void
J.PanCameraToWithZ = J.Common["PanCameraToWithZ"]
--- 暂停/恢复 AI脚本运行 [R]
--- 设定[某个玩家][暂停/恢复]当前AI脚本的运行
--- 事实上该函数是有问题的,可以这么理解:设玩家当前AI脚本的运行状态R为0,暂停1次则R+1,恢复1次则R-1,仅当R=0时该玩家才会运行AI. 在使用前请先理解这段话的意思.
--- p number player
--- pause boolean
---@type fun(p:number,pause:boolean):void
J.PauseCompAI = J.Common["PauseCompAI"]
--- 暂停/恢复游戏 [R]
--- [暂停/恢复]游戏
--- flag boolean
---@type fun(flag:boolean):void
J.PauseGame = J.Common["PauseGame"]
--- 暂停计时器 [R]
--- 暂停[计时器]
--- whichTimer number timer
---@type fun(whichTimer:number):void
J.PauseTimer = J.Common["PauseTimer"]
--- 暂停/恢复 [R]
--- 设置[单位][Pause/Unpause]
--- whichUnit number unit
--- flag boolean
---@type fun(whichUnit:number,flag:boolean):void
J.PauseUnit = J.Common["PauseUnit"]
--- 小地图信号(所有玩家) [R]
--- 对所有玩家发送小地图信号到坐标([X],[Y]) 持续时间:[Duration]秒
--- x number
--- y number
--- duration number
---@type fun(x:number,y:number,duration:number):void
J.PingMinimap = J.Common["PingMinimap"]
--- 小地图信号(指定颜色)(所有玩家) [R]
--- 对所有玩家发送小地图信号到坐标([X],[Y]) 持续时间:[Duration]秒, 信号颜色:([Red],[Green],[Blue]) 信号类型:[Style]
--- 颜色格式为(红,绿,蓝). 颜色值取值范围为0-255.
--- x number
--- y number
--- duration number
--- red number int
--- green number int
--- blue number int
--- extraEffects boolean
---@type fun(x:number,y:number,duration:number,red:number,green:number,blue:number,extraEffects:boolean):void
J.PingMinimapEx = J.Common["PingMinimapEx"]
--- 选择放置物品 [R]
--- 从[物品池]中任意选择一个物品并放置到([X],[Y])点
--- whichItemPool number itempool
--- x number
--- y number
---@type fun(whichItemPool:number,x:number,y:number):number item
J.PlaceRandomItem = J.Common["PlaceRandomItem"]
--- 选择放置单位 [R]
--- 从[单位池]中为[玩家]任意选择一个单位并放置到点([X],[Y]) 面向[度]
--- whichPool number unitpool
--- forWhichPlayer number player
--- x number
--- y number
--- facing number
---@type fun(whichPool:number,forWhichPlayer:number,x:number,y:number,facing:number):number unit
J.PlaceRandomUnit = J.Common["PlaceRandomUnit"]
--- movieName string
---@type fun(movieName:string):void
J.PlayCinematic = J.Common["PlayCinematic"]
--- modelName string
---@type fun(modelName:string):void
J.PlayModelCinematic = J.Common["PlayModelCinematic"]
--- 播放背景音乐
--- 播放[背景音乐]
--- musicName string
---@type fun(musicName:string):void
J.PlayMusic = J.Common["PlayMusic"]
--- 跳播背景音乐
--- 播放[背景音乐],跳过开始[Offset]秒,淡入时间:[Fade Time]秒
--- musicName string
--- frommsecs number int
--- fadeinmsecs number int
---@type fun(musicName:string,frommsecs:number,fadeinmsecs:number):void
J.PlayMusicEx = J.Common["PlayMusicEx"]
--- 播放主题音乐 [C]
--- 播放[Music Theme]主题音乐
--- 播放主题音乐一次,然后恢复原来的音乐.
--- musicFileName string
---@type fun(musicFileName:string):void
J.PlayThematicMusic = J.Common["PlayThematicMusic"]
--- 跳播主题音乐 [R]
--- 播放[Music Theme]主题音乐,跳过开始[Offset]毫秒
--- 播放主题音乐一次,然后恢复原来的音乐.
--- musicFileName string
--- frommsecs number int
---@type fun(musicFileName:string,frommsecs:number):void
J.PlayThematicMusicEx = J.Common["PlayThematicMusicEx"]
--- number number int
---@type fun(number:number):number player
J.Player = J.Common["Player"]
--- toPlayer number player
---@type fun(toPlayer:number):number leaderboard
J.PlayerGetLeaderboard = J.Common["PlayerGetLeaderboard"]
--- 设置玩家使用的排行榜 [R]
--- 设置[某个玩家]使用[排行榜]
--- 每个玩家只能显示一个排行榜.
--- toPlayer number player
--- lb number leaderboard
---@type fun(toPlayer:number,lb:number):void
J.PlayerSetLeaderboard = J.Common["PlayerSetLeaderboard"]
--- 预载文件
--- 预载[文件]
--- 可以事先载入文件并调入到游戏内存,以加快游戏的速度.
--- filename string
---@type fun(filename:string):void
J.Preload = J.Common["Preload"]
--- 开始预载
--- 开始预载, 超时设置[Time]秒
--- 将文件调入到游戏内存中.
--- timeout number
---@type fun(timeout:number):void
J.PreloadEnd = J.Common["PreloadEnd"]
---@type fun():void
J.PreloadEndEx = J.Common["PreloadEndEx"]
---@type fun():void
J.PreloadGenClear = J.Common["PreloadGenClear"]
--- filename string
---@type fun(filename:string):void
J.PreloadGenEnd = J.Common["PreloadGenEnd"]
---@type fun():void
J.PreloadGenStart = J.Common["PreloadGenStart"]
---@type fun():void
J.PreloadRefresh = J.Common["PreloadRefresh"]
---@type fun():void
J.PreloadStart = J.Common["PreloadStart"]
--- 批量预载
--- 预载所有在[文件]中列出的文件
--- filename string
---@type fun(filename:string):void
J.Preloader = J.Common["Preloader"]
--- whichQuest number quest
---@type fun(whichQuest:number):number questitem
J.QuestCreateItem = J.Common["QuestCreateItem"]
--- 设置任务项目完成
--- 设置[Quest Requirement][Completed/Incomplete]
--- whichQuestItem number questitem
--- completed boolean
---@type fun(whichQuestItem:number,completed:boolean):void
J.QuestItemSetCompleted = J.Common["QuestItemSetCompleted"]
--- 改变任务项目说明
--- 改变[Quest Requirement]的说明为:[文字]
--- whichQuestItem number questitem
--- description string
---@type fun(whichQuestItem:number,description:string):void
J.QuestItemSetDescription = J.Common["QuestItemSetDescription"]
--- 设置任务完成
--- 设置[某个任务][Completed/Incomplete]
--- whichQuest number quest
--- completed boolean
---@type fun(whichQuest:number,completed:boolean):void
J.QuestSetCompleted = J.Common["QuestSetCompleted"]
--- 设置任务说明
--- 设置[某个任务]的任务说明为:[文字]
--- whichQuest number quest
--- description string
---@type fun(whichQuest:number,description:string):void
J.QuestSetDescription = J.Common["QuestSetDescription"]
--- 设置任务被发现
--- 设置[某个任务][Discovered/Undiscovered]
--- whichQuest number quest
--- discovered boolean
---@type fun(whichQuest:number,discovered:boolean):void
J.QuestSetDiscovered = J.Common["QuestSetDiscovered"]
--- 启用/禁用 任务 [R]
--- 设置[某个任务][Enable/Disable]
--- 被禁用的任务将不会显示在任务列表.
--- whichQuest number quest
--- enabled boolean
---@type fun(whichQuest:number,enabled:boolean):void
J.QuestSetEnabled = J.Common["QuestSetEnabled"]
--- 设置任务失败
--- 设置[某个任务][Failed/Not Failed]
--- whichQuest number quest
--- failed boolean
---@type fun(whichQuest:number,failed:boolean):void
J.QuestSetFailed = J.Common["QuestSetFailed"]
--- whichQuest number quest
--- iconPath string
---@type fun(whichQuest:number,iconPath:string):void
J.QuestSetIconPath = J.Common["QuestSetIconPath"]
--- whichQuest number quest
--- required boolean
---@type fun(whichQuest:number,required:boolean):void
J.QuestSetRequired = J.Common["QuestSetRequired"]
--- 设置任务标题
--- 设置[某个任务]的标题为[文字]
--- whichQuest number quest
--- title string
---@type fun(whichQuest:number,title:string):void
J.QuestSetTitle = J.Common["QuestSetTitle"]
--- 将可破坏物动画加入队列
--- 将[可破坏物]的[Animation Name]动作加入队列
--- d number destructable
--- whichAnimation string
---@type fun(d:number,whichAnimation:string):void
J.QueueDestructableAnimation = J.Common["QueueDestructableAnimation"]
--- 单位动画加入队列
--- 把[单位]的[Animation Name]动作添加到动作队列
--- 单位按队列中运作的先后顺序播放动作.
--- whichUnit number unit
--- whichAnimation string
---@type fun(whichUnit:number,whichAnimation:string):void
J.QueueUnitAnimation = J.Common["QueueUnitAnimation"]
--- minx number
--- miny number
--- maxx number
--- maxy number
---@type fun(minx:number,miny:number,maxx:number,maxy:number):number rect
J.Rect = J.Common["Rect"]
--- min number location
--- max number location
---@type fun(min:number,max:number):number rect
J.RectFromLoc = J.Common["RectFromLoc"]
--- 恢复指定单位的警戒点
--- 恢复[单位]的警戒点
--- 这个动作通过 AI 来恢复特定单位的警戒点.
--- hUnit number unit
---@type fun(hUnit:number):void
J.RecycleGuardPosition = J.Common["RecycleGuardPosition"]
--- 添加单元点(指定坐标) [R]
--- 对[不规则区域]添加单元点: ([X],[Y])
--- 单元点大小为32x32.
--- whichRegion number region
--- x number
--- y number
---@type fun(whichRegion:number,x:number,y:number):void
J.RegionAddCell = J.Common["RegionAddCell"]
--- 添加单元点(指定点) [R]
--- 对[不规则区域]添加单元点:[坐标]
--- 单元点大小为32x32.
--- whichRegion number region
--- whichLocation number location
---@type fun(whichRegion:number,whichLocation:number):void
J.RegionAddCellAtLoc = J.Common["RegionAddCellAtLoc"]
--- 添加区域 [R]
--- 对[不规则区域]添加[矩形区域]
--- 区域是游戏中一个游戏地区的集合体,可以包含地区和点.
--- whichRegion number region
--- r number rect
---@type fun(whichRegion:number,r:number):void
J.RegionAddRect = J.Common["RegionAddRect"]
--- 移除单元点(指定坐标) [R]
--- 在[不规则区域]中移除单元点: ([X],[Y])
--- 单元点大小为32x32.
--- whichRegion number region
--- x number
--- y number
---@type fun(whichRegion:number,x:number,y:number):void
J.RegionClearCell = J.Common["RegionClearCell"]
--- 移除单元点(指定点) [R]
--- 在[不规则区域]中移除单元点:[坐标]
--- 单元点大小为32x32.
--- whichRegion number region
--- whichLocation number location
---@type fun(whichRegion:number,whichLocation:number):void
J.RegionClearCellAtLoc = J.Common["RegionClearCellAtLoc"]
--- 移除区域 [R]
--- 在[不规则区域]中移除[矩形区域]
--- whichRegion number region
--- r number rect
---@type fun(whichRegion:number,r:number):void
J.RegionClearRect = J.Common["RegionClearRect"]
--- soundHandle number sound
--- byPosition boolean
--- rectwidth number
--- rectheight number
---@type fun(soundHandle:number,byPosition:boolean,rectwidth:number,rectheight:number):void
J.RegisterStackedSound = J.Common["RegisterStackedSound"]
---@type fun():void
J.ReloadGame = J.Common["ReloadGame"]
--- 读取本地缓存数据
--- 从本地硬盘读取缓存数据
--- 只对单机游戏有效,从本地硬盘读取缓存数据,主要用来实现战役关卡间的数据传递.
---@type fun():boolean
J.ReloadGameCachesFromDisk = J.Common["ReloadGameCachesFromDisk"]
--- 忽视所有单位的警戒点
--- 忽视[某个玩家]的所有单位的警戒点
--- 单位将不会自动返回原警戒点. 一个很有用的功能就是刷怪进攻时忽视单位警戒范围的话,怪就不会想家了.
--- num number player
---@type fun(num:number):void
J.RemoveAllGuardPositions = J.Common["RemoveAllGuardPositions"]
--- 删除
--- 删除[可破坏物]
--- d number destructable
---@type fun(d:number):void
J.RemoveDestructable = J.Common["RemoveDestructable"]
--- 忽视指定单位的警戒点
--- 忽视[单位]的警戒点
--- 单位将不会自动返回原警戒点. 一个很有用的功能就是刷怪进攻时忽视单位警戒范围的话,怪就不会想家了.
--- hUnit number unit
---@type fun(hUnit:number):void
J.RemoveGuardPosition = J.Common["RemoveGuardPosition"]
--- 删除
--- 删除[物品]
--- whichItem number item
---@type fun(whichItem:number):void
J.RemoveItem = J.Common["RemoveItem"]
--- 删除物品(所有市场)
--- 删除[物品类型]从所有市场
--- 影响所有拥有'出售物品'技能的单位.
--- itemId number int
---@type fun(itemId:number):void
J.RemoveItemFromAllStock = J.Common["RemoveItemFromAllStock"]
--- 删除物品(指定市场)
--- 删除[物品类型]从[Marketplace]
--- 只影响有'出售物品'技能的单位
--- whichUnit number unit
--- itemId number int
---@type fun(whichUnit:number,itemId:number):void
J.RemoveItemFromStock = J.Common["RemoveItemFromStock"]
--- 清除点 [R]
--- 清除[坐标]
--- 点是堆积最多的垃圾资源,不需要再使用的点都要记得清除掉.
--- whichLocation number location
---@type fun(whichLocation:number):void
J.RemoveLocation = J.Common["RemoveLocation"]
--- 踢除玩家
--- 踢除[某个玩家]，玩家的游戏结果为[文字]
--- whichPlayer number player
--- gameResult any playergameresult
---@type fun(whichPlayer:number,gameResult:any):void
J.RemovePlayer = J.Common["RemovePlayer"]
--- 删除矩形区域 [R]
--- 删除[矩形区域]
--- whichRect number rect
---@type fun(whichRect:number):void
J.RemoveRect = J.Common["RemoveRect"]
--- 删除不规则区域 [R]
--- 删除[不规则区域]
--- whichRegion number region
---@type fun(whichRegion:number):void
J.RemoveRegion = J.Common["RemoveRegion"]
--- 删除存档文件夹
--- 删除[文件夹]
--- 文件夹内的内容都会被删除.
--- sourceDirName string
---@type fun(sourceDirName:string):boolean
J.RemoveSaveDirectory = J.Common["RemoveSaveDirectory"]
--- 清理哈希项存储的布尔值 <new>
--- 清空[Hashtable] 主索引 [Value] 子索引[childKey] 之内的布尔值
--- 清空哈希表主索引下的布尔值
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):void
J.RemoveSavedBoolean = J.Common["RemoveSavedBoolean"]
--- 清理哈希项存储的句柄 <new>
--- 清空[Hashtable] 主索引 [Value] 子索引[childKey] 之内的句柄
--- 清空哈希表主索引下的句柄
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):void
J.RemoveSavedHandle = J.Common["RemoveSavedHandle"]
--- 清理哈希项存储的整数值 <new>
--- 清空[Hashtable] 主索引 [Value] 子索引[childKey] 之内的整数值
--- 清空哈希表主索引下的整数值
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):void
J.RemoveSavedInteger = J.Common["RemoveSavedInteger"]
--- 清理哈希项存储的实数值 <new>
--- 清空[Hashtable] 主索引 [Value] 子索引[childKey] 之内的实数值
--- 清空哈希表主索引下的实数值
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):void
J.RemoveSavedReal = J.Common["RemoveSavedReal"]
--- 清理哈希项存储的字符串 <new>
--- 清空[Hashtable] 主索引 [Value] 子索引[childKey] 之内的字符串
--- 清空哈希表主索引下的字符串
--- table any hashtable
--- parentKey number int
--- childKey number int
---@type fun(table:any,parentKey:number,childKey:number):void
J.RemoveSavedString = J.Common["RemoveSavedString"]
--- 删除
--- 删除[单位]
--- 被删除的单位不会留下尸体. 如果是英雄则不能再被复活.
--- whichUnit number unit
---@type fun(whichUnit:number):void
J.RemoveUnit = J.Common["RemoveUnit"]
--- 删除单位(所有市场)
--- 删除[单位类型]从所有市场
--- 影响所有拥有'出售单位'技能的单位.
--- unitId number int
---@type fun(unitId:number):void
J.RemoveUnitFromAllStock = J.Common["RemoveUnitFromAllStock"]
--- 删除单位(指定市场)
--- 删除[单位类型]从[Marketplace]
--- 只影响有'出售单位'技能的单位.
--- whichUnit number unit
--- unitId number int
---@type fun(whichUnit:number,unitId:number):void
J.RemoveUnitFromStock = J.Common["RemoveUnitFromStock"]
--- 删除天气效果
--- 删除[天气效果]
--- whichEffect number weathereffect
---@type fun(whichEffect:number):void
J.RemoveWeatherEffect = J.Common["RemoveWeatherEffect"]
--- 重命名存档文件夹
--- 更改[源文件夹]的名字为[目标文件夹]
--- sourceDirName string
--- destDirName string
---@type fun(sourceDirName:string,destDirName:string):boolean
J.RenameSaveDirectory = J.Common["RenameSaveDirectory"]
--- 重置迷雾
--- 重置迷雾为默认设置
---@type fun():void
J.ResetTerrainFog = J.Common["ResetTerrainFog"]
--- 重置游戏镜头(所有玩家) [R]
--- 重置玩家镜头为游戏默认状态,持续 [Time]秒
--- duration number
---@type fun(duration:number):void
J.ResetToGameCamera = J.Common["ResetToGameCamera"]
--- whichTrigger number trigger
---@type fun(whichTrigger:number):void
J.ResetTrigger = J.Common["ResetTrigger"]
--- 重置地面纹理变化
--- 重置[某个地形纹理]
--- whichSplat any ubersplat
---@type fun(whichSplat:any):void
J.ResetUbersplat = J.Common["ResetUbersplat"]
--- 重置身体朝向
--- 重置[单位]的身体朝向
--- 恢复单位的身体朝向为正常状态.
--- whichUnit number unit
---@type fun(whichUnit:number):void
J.ResetUnitLookAt = J.Common["ResetUnitLookAt"]
--- doScoreScreen boolean
---@type fun(doScoreScreen:boolean):void
J.RestartGame = J.Common["RestartGame"]
--- cache any gamecache
--- missionKey string
--- key string
--- forWhichPlayer number player
--- x number
--- y number
--- facing number
---@type fun(cache:any,missionKey:string,key:string,forWhichPlayer:number,x:number,y:number,facing:number):number unit
J.RestoreUnit = J.Common["RestoreUnit"]
--- 恢复背景音乐
---@type fun():void
J.ResumeMusic = J.Common["ResumeMusic"]
--- 恢复计时器 [R]
--- 恢复[计时器]
--- whichTimer number timer
---@type fun(whichTimer:number):void
J.ResumeTimer = J.Common["ResumeTimer"]
--- 立即复活(指定坐标) [R]
--- 立即复活[英雄]在([X],[Y]),[显示/隐藏]复活动画
--- 如果英雄正在祭坛复活,则会退回部分花费(默认为100%).
--- whichHero number unit
--- x number
--- y number
--- doEyecandy boolean
---@type fun(whichHero:number,x:number,y:number,doEyecandy:boolean):boolean
J.ReviveHero = J.Common["ReviveHero"]
--- 立即复活(指定点)
--- 立即复活[英雄]在[指定点],[显示/隐藏]复活动画
--- 如果英雄正在祭坛复活,则会退回部分花费(默认为100%).
--- whichHero number unit
--- loc number location
--- doEyecandy boolean
---@type fun(whichHero:number,loc:number,doEyecandy:boolean):boolean
J.ReviveHeroLoc = J.Common["ReviveHeroLoc"]
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichAbility number ability
---@type fun(table:any,parentKey:number,childKey:number,whichAbility:number):boolean
J.SaveAbilityHandle = J.Common["SaveAbilityHandle"]
--- <1.24> 保存布尔 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存布尔[Value]
--- 使用 '哈希表 - 从哈希表提取布尔' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- value boolean
---@type fun(table:any,parentKey:number,childKey:number,value:boolean):void
J.SaveBoolean = J.Common["SaveBoolean"]
--- <1.24> 保存布尔表达式 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存布尔表达式[Value]
--- 使用 '哈希表 - 从哈希表提取布尔表达式' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichBoolexpr function boolexpr
---@type fun(table:any,parentKey:number,childKey:number,whichBoolexpr:function):boolean
J.SaveBooleanExprHandle = J.Common["SaveBooleanExprHandle"]
--- <1.24> 保存对话框按钮 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存对话框按钮[Value]
--- 使用 '哈希表 - 从哈希表提取对话框按钮' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichButton number button
---@type fun(table:any,parentKey:number,childKey:number,whichButton:number):boolean
J.SaveButtonHandle = J.Common["SaveButtonHandle"]
--- <1.24> 保存失败条件 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存失败条件[Value]
--- 使用 '哈希表 - 从哈希表提取失败条件' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichDefeatcondition function defeatcondition
---@type fun(table:any,parentKey:number,childKey:number,whichDefeatcondition:function):boolean
J.SaveDefeatConditionHandle = J.Common["SaveDefeatConditionHandle"]
--- <1.24> 保存可破坏物 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存可破坏物[Value]
--- 使用 '哈希表 - 从哈希表提取可破坏物' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichDestructable number destructable
---@type fun(table:any,parentKey:number,childKey:number,whichDestructable:number):boolean
J.SaveDestructableHandle = J.Common["SaveDestructableHandle"]
--- <1.24> 保存对话框 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存对话框[Value]
--- 使用 '哈希表 - 从哈希表提取对话框' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichDialog number dialog
---@type fun(table:any,parentKey:number,childKey:number,whichDialog:number):boolean
J.SaveDialogHandle = J.Common["SaveDialogHandle"]
--- <1.24> 保存特效 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存特效[Value]
--- 使用 '哈希表 - 从哈希表提取特效' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichEffect number effect
---@type fun(table:any,parentKey:number,childKey:number,whichEffect:number):boolean
J.SaveEffectHandle = J.Common["SaveEffectHandle"]
--- <1.24> 保存可见度修正器 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存可见度修正器[Value]
--- 使用 '哈希表 - 从哈希表提取可见度修正器' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichFogModifier number fogmodifier
---@type fun(table:any,parentKey:number,childKey:number,whichFogModifier:number):boolean
J.SaveFogModifierHandle = J.Common["SaveFogModifierHandle"]
--- <1.24> 保存迷雾状态 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存迷雾状态[Value]
--- 使用 '哈希表 - 从哈希表提取迷雾状态' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichFogState any fogstate
---@type fun(table:any,parentKey:number,childKey:number,whichFogState:any):boolean
J.SaveFogStateHandle = J.Common["SaveFogStateHandle"]
--- <1.24> 保存玩家组 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存玩家组[Value]
--- 使用 '哈希表 - 从哈希表提取玩家组' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichForce number force
---@type fun(table:any,parentKey:number,childKey:number,whichForce:number):boolean
J.SaveForceHandle = J.Common["SaveForceHandle"]
--- 保存进度 [R]
--- 保存游戏进度为:[Filename]
--- saveFileName string
---@type fun(saveFileName:string):void
J.SaveGame = J.Common["SaveGame"]
--- 本地保存游戏缓存
--- 保存[Game Cache]到本地硬盘
--- 只对单机游戏有效,保存缓存数据到本地硬盘,主要用来实现战役关卡间的数据传递.
--- whichCache any gamecache
---@type fun(whichCache:any):boolean
J.SaveGameCache = J.Common["SaveGameCache"]
--- saveName string
---@type fun(saveName:string):boolean
J.SaveGameExists = J.Common["SaveGameExists"]
--- <1.24> 保存单位组 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存单位组[Value]
--- 使用 '哈希表 - 从哈希表提取单位组' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichGroup number group
---@type fun(table:any,parentKey:number,childKey:number,whichGroup:number):boolean
J.SaveGroupHandle = J.Common["SaveGroupHandle"]
--- <1.24> 保存图像 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存图像[Value]
--- 使用 '哈希表 - 从哈希表提取图像' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichImage number image
---@type fun(table:any,parentKey:number,childKey:number,whichImage:number):boolean
J.SaveImageHandle = J.Common["SaveImageHandle"]
--- <1.24> 保存整数 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存整数[Value]
--- 使用 '哈希表 - 从哈希表提取整数' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- value number int
---@type fun(table:any,parentKey:number,childKey:number,value:number):void
J.SaveInteger = J.Common["SaveInteger"]
--- <1.24> 保存物品 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存物品[Value]
--- 使用 '哈希表 - 从哈希表提取物品' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichItem number item
---@type fun(table:any,parentKey:number,childKey:number,whichItem:number):boolean
J.SaveItemHandle = J.Common["SaveItemHandle"]
--- <1.24> 保存物品池 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存物品池[Value]
--- 使用 '哈希表 - 从哈希表提取物品池' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichItempool number itempool
---@type fun(table:any,parentKey:number,childKey:number,whichItempool:number):boolean
J.SaveItemPoolHandle = J.Common["SaveItemPoolHandle"]
--- <1.24> 保存排行榜 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存排行榜[Value]
--- 使用 '哈希表 - 从哈希表提取排行榜' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichLeaderboard number leaderboard
---@type fun(table:any,parentKey:number,childKey:number,whichLeaderboard:number):boolean
J.SaveLeaderboardHandle = J.Common["SaveLeaderboardHandle"]
--- <1.24> 保存闪电效果 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存闪电效果[Value]
--- 使用 '哈希表 - 从哈希表提取闪电效果' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichLightning number lightning
---@type fun(table:any,parentKey:number,childKey:number,whichLightning:number):boolean
J.SaveLightningHandle = J.Common["SaveLightningHandle"]
--- <1.24> 保存点 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存点[Value]
--- 使用 '哈希表 - 从哈希表提取点' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichLocation number location
---@type fun(table:any,parentKey:number,childKey:number,whichLocation:number):boolean
J.SaveLocationHandle = J.Common["SaveLocationHandle"]
--- <1.24> 保存多面板 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存多面板[Value]
--- 使用 '哈希表 - 从哈希表提取多面板' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichMultiboard number multiboard
---@type fun(table:any,parentKey:number,childKey:number,whichMultiboard:number):boolean
J.SaveMultiboardHandle = J.Common["SaveMultiboardHandle"]
--- <1.24> 保存多面板项目 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存多面板项目[Value]
--- 使用 '哈希表 - 从哈希表提取多面板项目' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichMultiboarditem number multiboarditem
---@type fun(table:any,parentKey:number,childKey:number,whichMultiboarditem:number):boolean
J.SaveMultiboardItemHandle = J.Common["SaveMultiboardItemHandle"]
--- <1.24> 保存玩家 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存玩家[Value]
--- 使用 '哈希表 - 从哈希表提取玩家' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichPlayer number player
---@type fun(table:any,parentKey:number,childKey:number,whichPlayer:number):boolean
J.SavePlayerHandle = J.Common["SavePlayerHandle"]
--- <1.24> 保存任务 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存任务[Value]
--- 使用 '哈希表 - 从哈希表提取任务' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichQuest number quest
---@type fun(table:any,parentKey:number,childKey:number,whichQuest:number):boolean
J.SaveQuestHandle = J.Common["SaveQuestHandle"]
--- <1.24> 保存任务要求 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存任务要求[Value]
--- 使用 '哈希表 - 从哈希表提取任务要求' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichQuestitem number questitem
---@type fun(table:any,parentKey:number,childKey:number,whichQuestitem:number):boolean
J.SaveQuestItemHandle = J.Common["SaveQuestItemHandle"]
--- <1.24> 保存实数 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存实数[Value]
--- 使用 '哈希表 - 从哈希表提取实数' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- value number
---@type fun(table:any,parentKey:number,childKey:number,value:number):void
J.SaveReal = J.Common["SaveReal"]
--- <1.24> 保存区域(矩型) [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存区域(矩型)[Value]
--- 使用 '哈希表 - 从哈希表提取区域(矩型)' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichRect number rect
---@type fun(table:any,parentKey:number,childKey:number,whichRect:number):boolean
J.SaveRectHandle = J.Common["SaveRectHandle"]
--- <1.24> 保存区域(不规则) [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存区域(不规则)[Value]
--- 使用 '哈希表 - 从哈希表提取区域(不规则)' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichRegion number region
---@type fun(table:any,parentKey:number,childKey:number,whichRegion:number):boolean
J.SaveRegionHandle = J.Common["SaveRegionHandle"]
--- <1.24> 保存音效 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存音效[Value]
--- 使用 '哈希表 - 从哈希表提取音效' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichSound number sound
---@type fun(table:any,parentKey:number,childKey:number,whichSound:number):boolean
J.SaveSoundHandle = J.Common["SaveSoundHandle"]
--- <1.24> 保存字符串 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存字符串[Value]
--- 使用 '哈希表 - 从哈希表提取字符串' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- value string
---@type fun(table:any,parentKey:number,childKey:number,value:string):boolean
J.SaveStr = J.Common["SaveStr"]
--- <1.24> 保存漂浮文字 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存漂浮文字[Value]
--- 使用 '哈希表 - 从哈希表提取漂浮文字' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichTexttag number texttag
---@type fun(table:any,parentKey:number,childKey:number,whichTexttag:number):boolean
J.SaveTextTagHandle = J.Common["SaveTextTagHandle"]
--- <1.24> 保存计时器窗口 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存计时器窗口[Value]
--- 使用 '哈希表 - 从哈希表提取计时器窗口' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichTimerdialog number timerdialog
---@type fun(table:any,parentKey:number,childKey:number,whichTimerdialog:number):boolean
J.SaveTimerDialogHandle = J.Common["SaveTimerDialogHandle"]
--- <1.24> 保存计时器 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存计时器[Value]
--- 使用 '哈希表 - 从哈希表提取计时器' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichTimer number timer
---@type fun(table:any,parentKey:number,childKey:number,whichTimer:number):boolean
J.SaveTimerHandle = J.Common["SaveTimerHandle"]
--- <1.24> 保存可追踪物 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存可追踪物[Value]
--- 使用 '哈希表 - 从哈希表提取可追踪物' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichTrackable any trackable
---@type fun(table:any,parentKey:number,childKey:number,whichTrackable:any):boolean
J.SaveTrackableHandle = J.Common["SaveTrackableHandle"]
--- <1.24> 保存触发动作 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存触发动作[Value]
--- 使用 '哈希表 - 从哈希表提取触发动作' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichTriggeraction function triggeraction
---@type fun(table:any,parentKey:number,childKey:number,whichTriggeraction:function):boolean
J.SaveTriggerActionHandle = J.Common["SaveTriggerActionHandle"]
--- <1.24> 保存触发条件 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存触发条件[Value]
--- 使用 '哈希表 - 从哈希表提取触发条件' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichTriggercondition function triggercondition
---@type fun(table:any,parentKey:number,childKey:number,whichTriggercondition:function):boolean
J.SaveTriggerConditionHandle = J.Common["SaveTriggerConditionHandle"]
--- <1.24> 保存触发事件 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存触发事件[Value]
--- 使用 '哈希表 - 从哈希表提取触发事件' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichEvent any event
---@type fun(table:any,parentKey:number,childKey:number,whichEvent:any):boolean
J.SaveTriggerEventHandle = J.Common["SaveTriggerEventHandle"]
--- <1.24> 保存触发器 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存触发器[Value]
--- 使用 '哈希表 - 从哈希表提取触发器' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichTrigger number trigger
---@type fun(table:any,parentKey:number,childKey:number,whichTrigger:number):boolean
J.SaveTriggerHandle = J.Common["SaveTriggerHandle"]
--- <1.24> 保存地面纹理变化 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存地面纹理变化[Value]
--- 使用 '哈希表 - 从哈希表提取地面纹理变化' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichUbersplat any ubersplat
---@type fun(table:any,parentKey:number,childKey:number,whichUbersplat:any):boolean
J.SaveUbersplatHandle = J.Common["SaveUbersplatHandle"]
--- <1.24> 保存单位 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存单位[Value]
--- 使用 '哈希表 - 从哈希表提取单位' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichUnit number unit
---@type fun(table:any,parentKey:number,childKey:number,whichUnit:number):boolean
J.SaveUnitHandle = J.Common["SaveUnitHandle"]
--- <1.24> 保存单位池 [C]
--- 在[Hashtable]的主索引[Value]子索引[Value]中保存单位池[Value]
--- 使用 '哈希表 - 从哈希表提取单位池' 可以取出保存的值
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichUnitpool number unitpool
---@type fun(table:any,parentKey:number,childKey:number,whichUnitpool:number):boolean
J.SaveUnitPoolHandle = J.Common["SaveUnitPoolHandle"]
--- table any hashtable
--- parentKey number int
--- childKey number int
--- whichWidget number widget
---@type fun(table:any,parentKey:number,childKey:number,whichWidget:number):boolean
J.SaveWidgetHandle = J.Common["SaveWidgetHandle"]
--- 学习技能
--- 命令[某个英雄]学习技能[Skill]
--- 只有当英雄有剩余技能点时有效.
--- whichHero number unit
--- abilcode number int
---@type fun(whichHero:number,abilcode:number):void
J.SelectHeroSkill = J.Common["SelectHeroSkill"]
--- whichUnit number unit
--- flag boolean
---@type fun(whichUnit:number,flag:boolean):void
J.SelectUnit = J.Common["SelectUnit"]
--- 限制物品种类(所有市场)
--- 限制所有市场的可出售物品种类数为[Quantity]
--- 影响所有拥有'出售物品'技能的单位.
--- slots number int
---@type fun(slots:number):void
J.SetAllItemTypeSlots = J.Common["SetAllItemTypeSlots"]
--- 限制单位种类(所有市场)
--- 限制所有市场的可出售单位种类数为[Quantity]
--- 影响所有拥有'出售单位'技能的单位.
--- slots number int
---@type fun(slots:number):void
J.SetAllUnitTypeSlots = J.Common["SetAllUnitTypeSlots"]
--- 设置联盟颜色显示
--- 设置联盟颜色显示状态为[State]
--- 0为不开启. 1为小地图显示. 2为小地图和游戏都显示. 相当于游戏中Alt+A功能.
--- state number int
---@type fun(state:number):void
J.SetAllyColorFilterState = J.Common["SetAllyColorFilterState"]
--- 设置小地图特殊标志
--- 设置小地图特殊标志为[某个图像]
--- 必须使用16x16的图像.
--- iconPath string
---@type fun(iconPath:string):void
J.SetAltMinimapIcon = J.Common["SetAltMinimapIcon"]
--- 创建/删除荒芜地表(圆范围)(指定坐标) [R]
--- 为[某个玩家]在圆心为([X],[Y]),半径为[R]的圆范围内[Create/Remove]一块荒芜地表
--- whichPlayer number player
--- x number
--- y number
--- radius number
--- addBlight boolean
---@type fun(whichPlayer:number,x:number,y:number,radius:number,addBlight:boolean):void
J.SetBlight = J.Common["SetBlight"]
--- whichPlayer number player
--- whichLocation number location
--- radius number
--- addBlight boolean
---@type fun(whichPlayer:number,whichLocation:number,radius:number,addBlight:boolean):void
J.SetBlightLoc = J.Common["SetBlightLoc"]
--- whichPlayer number player
--- x number
--- y number
--- addBlight boolean
---@type fun(whichPlayer:number,x:number,y:number,addBlight:boolean):void
J.SetBlightPoint = J.Common["SetBlightPoint"]
--- 创建/删除荒芜地表(矩形区域) [R]
--- 为[某个玩家]在[Region][Create/Remove]一块荒芜地表
--- whichPlayer number player
--- r number rect
--- addBlight boolean
---@type fun(whichPlayer:number,r:number,addBlight:boolean):void
J.SetBlightRect = J.Common["SetBlightRect"]
--- 设置可用镜头区域(所有玩家) [R]
--- 设置玩家可用镜头区域: 左下角([X],[Y]), 左上角([X],[Y]), 右上角([X],[Y]), 右下角([X],[Y])
--- 该动作同样会影响小地图的显示. 但小地图的图片是无法改变的. 实际可用区域要大于可用镜头区域.
--- x1 number
--- y1 number
--- x2 number
--- y2 number
--- x3 number
--- y3 number
--- x4 number
--- y4 number
---@type fun(x1:number,y1:number,x2:number,y2:number,x3:number,y3:number,x4:number,y4:number):void
J.SetCameraBounds = J.Common["SetCameraBounds"]
--- 设置镜头属性(所有玩家)(限时) [R]
--- 设置玩家的镜头属性[Field]为[数值],持续[Time]秒
--- whichField any camerafield
--- value number
--- duration number
---@type fun(whichField:any,value:number,duration:number):void
J.SetCameraField = J.Common["SetCameraField"]
--- 锁定镜头到单位(固定镜头源)(所有玩家) [R]
--- 锁定玩家镜头到[单位], 偏移坐标([X],[Y])
--- 偏移坐标(X,Y)以单位脚底为原点坐标.
--- whichUnit number unit
--- xoffset number
--- yoffset number
---@type fun(whichUnit:number,xoffset:number,yoffset:number):void
J.SetCameraOrientController = J.Common["SetCameraOrientController"]
--- x number
--- y number
---@type fun(x:number,y:number):void
J.SetCameraPosition = J.Common["SetCameraPosition"]
--- 设置空格键转向点(所有玩家) [R]
--- 设置玩家的空格键转向点为([X],[Y])
--- 按下空格键时镜头转向的位置.
--- x number
--- y number
---@type fun(x:number,y:number):void
J.SetCameraQuickPosition = J.Common["SetCameraQuickPosition"]
--- 指定点旋转镜头(所有玩家)(弧度)(限时) [R]
--- 以([X],[Y])为中心,旋转弧度为[Rad], 持续:[Time]秒
--- x number
--- y number
--- radiansToSweep number
--- duration number
---@type fun(x:number,y:number,radiansToSweep:number,duration:number):void
J.SetCameraRotateMode = J.Common["SetCameraRotateMode"]
--- 锁定镜头到单位(所有玩家) [R]
--- 锁定玩家镜头到[单位], 偏移坐标([X],[Y]) ,使用[Rotation Source]
--- 偏移坐标(X,Y)以单位脚底为原点坐标.
--- whichUnit number unit
--- xoffset number
--- yoffset number
--- inheritOrientation boolean
---@type fun(whichUnit:number,xoffset:number,yoffset:number,inheritOrientation:boolean):void
J.SetCameraTargetController = J.Common["SetCameraTargetController"]
--- 允许/禁止 战役
--- [Enable/Disable][Campaign]
--- campaignNumber number int
--- available boolean
---@type fun(campaignNumber:number,available:boolean):void
J.SetCampaignAvailable = J.Common["SetCampaignAvailable"]
--- 设置战役背景
--- 设置战役背景为[Campaign]
--- r any race
---@type fun(r:any):void
J.SetCampaignMenuRace = J.Common["SetCampaignMenuRace"]
--- campaignIndex number int
---@type fun(campaignIndex:number):void
J.SetCampaignMenuRaceEx = J.Common["SetCampaignMenuRaceEx"]
--- whichMode any blendmode
---@type fun(whichMode:any):void
J.SetCineFilterBlendMode = J.Common["SetCineFilterBlendMode"]
--- duration number
---@type fun(duration:number):void
J.SetCineFilterDuration = J.Common["SetCineFilterDuration"]
--- red number int
--- green number int
--- blue number int
--- alpha number int
---@type fun(red:number,green:number,blue:number,alpha:number):void
J.SetCineFilterEndColor = J.Common["SetCineFilterEndColor"]
--- minu number
--- minv number
--- maxu number
--- maxv number
---@type fun(minu:number,minv:number,maxu:number,maxv:number):void
J.SetCineFilterEndUV = J.Common["SetCineFilterEndUV"]
--- red number int
--- green number int
--- blue number int
--- alpha number int
---@type fun(red:number,green:number,blue:number,alpha:number):void
J.SetCineFilterStartColor = J.Common["SetCineFilterStartColor"]
--- minu number
--- minv number
--- maxu number
--- maxv number
---@type fun(minu:number,minv:number,maxu:number,maxv:number):void
J.SetCineFilterStartUV = J.Common["SetCineFilterStartUV"]
--- whichFlags any texmapflags
---@type fun(whichFlags:any):void
J.SetCineFilterTexMapFlags = J.Common["SetCineFilterTexMapFlags"]
--- filename string
---@type fun(filename:string):void
J.SetCineFilterTexture = J.Common["SetCineFilterTexture"]
--- 播放电影镜头(所有玩家) [R]
--- 对所有玩家播放电影镜头:[Camera File]
--- 在 Objects\\CinematicCameras 目录下有一些电影镜头,可用Mpq工具来查询.
--- cameraModelFile string
---@type fun(cameraModelFile:string):void
J.SetCinematicCamera = J.Common["SetCinematicCamera"]
--- portraitUnitId number int
--- color any playercolor
--- speakerTitle string
--- text string
--- sceneDuration number
--- voiceoverDuration number
---@type fun(portraitUnitId:number,color:any,speakerTitle:string,text:string,sceneDuration:number,voiceoverDuration:number):void
J.SetCinematicScene = J.Common["SetCinematicScene"]
--- whichdensity any mapdensity
---@type fun(whichdensity:any):void
J.SetCreatureDensity = J.Common["SetCreatureDensity"]
--- 设置小地图中立生物显示
--- 小地图[显示/隐藏]中立生物
--- 相当于游戏中Alt+R功能.
--- state boolean
---@type fun(state:boolean):void
J.SetCreepCampFilterState = J.Common["SetCreepCampFilterState"]
--- whichButton number int
--- visible boolean
---@type fun(whichButton:number,visible:boolean):void
J.SetCustomCampaignButtonVisible = J.Common["SetCustomCampaignButtonVisible"]
--- terrainDNCFile string
--- unitDNCFile string
---@type fun(terrainDNCFile:string,unitDNCFile:string):void
J.SetDayNightModels = J.Common["SetDayNightModels"]
--- g any gamedifficulty
---@type fun(g:any):void
J.SetDefaultDifficulty = J.Common["SetDefaultDifficulty"]
--- 播放可破坏物动画
--- 播放[可破坏物]的[Animation Name]动作
--- d number destructable
--- whichAnimation string
---@type fun(d:number,whichAnimation:string):void
J.SetDestructableAnimation = J.Common["SetDestructableAnimation"]
--- 改变可破坏物动画播放速度 [R]
--- 改变[可破坏物]的动画播放速度为正常的[Percent]倍
--- 设置1倍动画播放速度来恢复正常状态.
--- d number destructable
--- speedFactor number
---@type fun(d:number,speedFactor:number):void
J.SetDestructableAnimationSpeed = J.Common["SetDestructableAnimationSpeed"]
--- 设置无敌/可攻击
--- 设置[可破坏物][Invulnerable/Vulnerable]
--- d number destructable
--- flag boolean
---@type fun(d:number,flag:boolean):void
J.SetDestructableInvulnerable = J.Common["SetDestructableInvulnerable"]
--- 设置生命值(指定值)
--- 设置[可破坏物]的生命值为[Value]
--- d number destructable
--- life number
---@type fun(d:number,life:number):void
J.SetDestructableLife = J.Common["SetDestructableLife"]
--- 设置最大生命值
--- 设置[可破坏物]的最大生命值为[Value]
--- d number destructable
--- max number
---@type fun(d:number,max:number):void
J.SetDestructableMaxLife = J.Common["SetDestructableMaxLife"]
--- 设置闭塞高度
--- 设置[可破坏物]的闭塞高度为[Height]
--- d number destructable
--- height number
---@type fun(d:number,height:number):void
J.SetDestructableOccluderHeight = J.Common["SetDestructableOccluderHeight"]
--- 播放圆范围内地形装饰物动画 [R]
--- 选取圆心为([X],[Y]),半径为[半径]的圆范围内的[装饰物类型](选取方式:[选取方式]), 做[Animation Name]动作([允许/禁止]随机播放)
--- 特殊动画名: 'show', 'hide', 'soundon', 'soundoff'. 随机播放:比如某装饰物有好几个'stand'动作,则允许该项时会随机抽取某个动作播放,而禁止该项时只播放首个动作.
--- x number
--- y number
--- radius number
--- doodadID number int
--- nearestOnly boolean
--- animName string
--- animRandom boolean
---@type fun(x:number,y:number,radius:number,doodadID:number,nearestOnly:boolean,animName:string,animRandom:boolean):void
J.SetDoodadAnimation = J.Common["SetDoodadAnimation"]
--- 播放矩形区域内地形装饰物动画 [R]
--- 播放[Rect]内所有[装饰物类型]的[Animation Name]动作([允许/禁止]随机播放)
--- 特殊动画名: 'show', 'hide', 'soundon', 'soundoff'. 随机播放:比如某装饰物有好几个'stand'动作,则允许该项时会随机抽取某个动作播放,而禁止该项时只播放首个动作.
--- r number rect
--- doodadID number int
--- animName string
--- animRandom boolean
---@type fun(r:number,doodadID:number,animName:string,animRandom:boolean):void
J.SetDoodadAnimationRect = J.Common["SetDoodadAnimationRect"]
--- campaignNumber number int
--- available boolean
---@type fun(campaignNumber:number,available:boolean):void
J.SetEdCinematicAvailable = J.Common["SetEdCinematicAvailable"]
--- whichFloatGameState any fgamestate
--- value number
---@type fun(whichFloatGameState:any,value:number):void
J.SetFloatGameState = J.Common["SetFloatGameState"]
--- 设置地图迷雾(圆范围) [R]
--- 为[玩家]设置[FogStateVisible]在圆心为([X],[Y]) 半径为[数值]的范围, (对盟友[共享]视野)
--- forWhichPlayer number player
--- whichState any fogstate
--- centerx number
--- centerY number
--- radius number
--- useSharedVision boolean
---@type fun(forWhichPlayer:number,whichState:any,centerx:number,centerY:number,radius:number,useSharedVision:boolean):void
J.SetFogStateRadius = J.Common["SetFogStateRadius"]
--- forWhichPlayer number player
--- whichState any fogstate
--- center number location
--- radius number
--- useSharedVision boolean
---@type fun(forWhichPlayer:number,whichState:any,center:number,radius:number,useSharedVision:boolean):void
J.SetFogStateRadiusLoc = J.Common["SetFogStateRadiusLoc"]
--- 设置地图迷雾(矩形区域) [R]
--- 为[玩家]设置[FogStateVisible]在[矩形区域](对盟友[共享]视野)
--- forWhichPlayer number player
--- whichState any fogstate
--- where number rect
--- useSharedVision boolean
---@type fun(forWhichPlayer:number,whichState:any,where:number,useSharedVision:boolean):void
J.SetFogStateRect = J.Common["SetFogStateRect"]
--- 设置游戏难度 [R]
--- 设置当前游戏难度为[GameDifficulty]
--- 游戏难度只是作为运行AI的一个参考值,没有AI的地图该功能无用.
--- whichdifficulty any gamedifficulty
---@type fun(whichdifficulty:any):void
J.SetGameDifficulty = J.Common["SetGameDifficulty"]
--- whichPlacementType any placement
---@type fun(whichPlacementType:any):void
J.SetGamePlacement = J.Common["SetGamePlacement"]
--- 设定游戏速度
--- 设定游戏速度为[Speed]
--- 你可以通过'游戏 - 锁定游戏速度'动作来锁定游戏速度.
--- whichspeed any gamespeed
---@type fun(whichspeed:any):void
J.SetGameSpeed = J.Common["SetGameSpeed"]
--- whichGameType any gametype
--- value boolean
---@type fun(whichGameType:any,value:boolean):void
J.SetGameTypeSupported = J.Common["SetGameTypeSupported"]
--- 设置英雄敏捷 [R]
--- 设置[英雄]的敏捷为[Value],([Permanent]永久奖励)
--- 永久奖励貌似无效项,不需要理会.
--- whichHero number unit
--- newAgi number int
--- permanent boolean
---@type fun(whichHero:number,newAgi:number,permanent:boolean):void
J.SetHeroAgi = J.Common["SetHeroAgi"]
--- 设置英雄智力 [R]
--- 设置[英雄]的智力为[Value],([Permanent]永久奖励)
--- 永久奖励貌似无效项,不需要理会.
--- whichHero number unit
--- newInt number int
--- permanent boolean
---@type fun(whichHero:number,newInt:number,permanent:boolean):void
J.SetHeroInt = J.Common["SetHeroInt"]
--- 设置等级
--- 设置[某个英雄]的英雄等级为[Level],[显示/隐藏]升级动画
--- 如果等级有变动,英雄经验将重置为该等级的初始值.
--- whichHero number unit
--- level number int
--- showEyeCandy boolean
---@type fun(whichHero:number,level:number,showEyeCandy:boolean):void
J.SetHeroLevel = J.Common["SetHeroLevel"]
--- 设置英雄力量 [R]
--- 设置[英雄]的力量为[Value],([Permanent]永久奖励)
--- 永久奖励貌似无效项,不需要理会.
--- whichHero number unit
--- newStr number int
--- permanent boolean
---@type fun(whichHero:number,newStr:number,permanent:boolean):void
J.SetHeroStr = J.Common["SetHeroStr"]
--- 设置经验值
--- 设置[某个英雄]的经验值为[Quantity],[显示/隐藏]升级动画
--- 经验值不能倒退.
--- whichHero number unit
--- newXpVal number int
--- showEyeCandy boolean
---@type fun(whichHero:number,newXpVal:number,showEyeCandy:boolean):void
J.SetHeroXP = J.Common["SetHeroXP"]
--- 图像水面显示状态
--- 设置[某个图像]:[Enable/Disable]水面显示,[Enable/Disable]水的Alpha通道
--- 前者设置图像在水面或是水底显示. 后者设置图像是否受水的Alpha通道影响.
--- whichImage number image
--- flag boolean
--- useWaterAlpha boolean
---@type fun(whichImage:number,flag:boolean,useWaterAlpha:boolean):void
J.SetImageAboveWater = J.Common["SetImageAboveWater"]
--- 改变图像颜色 [R]
--- 设置[某个图像]的颜色值为([Red],[Green],[Blue]) Alpha值为[Alpha]
--- 颜色格式为(红,绿,蓝). Alpha值为0是不可见的. 颜色值和Alpha值取值范围0-255.
--- whichImage number image
--- red number int
--- green number int
--- blue number int
--- alpha number int
---@type fun(whichImage:number,red:number,green:number,blue:number,alpha:number):void
J.SetImageColor = J.Common["SetImageColor"]
--- 设置图像高度
--- 设置[某个图像][Enable/Disable]Z轴显示,并设置高度为[Height]
--- 实际显示高度为图像高度+Z轴偏移. 只有允许Z轴显示时才有效.
--- whichImage number image
--- flag boolean
--- height number
---@type fun(whichImage:number,flag:boolean,height:number):void
J.SetImageConstantHeight = J.Common["SetImageConstantHeight"]
--- 改变图像位置(指定坐标) [R]
--- 改变[某个图像]的位置为([X],[Y]),Z轴偏移为[Z]
--- 指图像的左下角位置.
--- whichImage number image
--- x number
--- y number
--- z number
---@type fun(whichImage:number,x:number,y:number,z:number):void
J.SetImagePosition = J.Common["SetImagePosition"]
--- 设置图像渲染状态
--- 设置[某个图像]:[Enable/Disable]显示状态
--- 未发现有任何作用.
--- whichImage number image
--- flag boolean
---@type fun(whichImage:number,flag:boolean):void
J.SetImageRender = J.Common["SetImageRender"]
--- 设置图像永久渲染状态
--- 设置[某个图像]:[Enable/Disable]永久显示状态
--- 要显示图像则必须开启该项.
--- whichImage number image
--- flag boolean
---@type fun(whichImage:number,flag:boolean):void
J.SetImageRenderAlways = J.Common["SetImageRenderAlways"]
--- 改变图像类型
--- 改变[某个图像]类型为[Type]
--- whichImage number image
--- imageType number int
---@type fun(whichImage:number,imageType:number):void
J.SetImageType = J.Common["SetImageType"]
--- whichIntegerGameState any igamestate
--- value number int
---@type fun(whichIntegerGameState:any,value:number):void
J.SetIntegerGameState = J.Common["SetIntegerGameState"]
--- introModelPath string
---@type fun(introModelPath:string):void
J.SetIntroShotModel = J.Common["SetIntroShotModel"]
--- introText string
---@type fun(introText:string):void
J.SetIntroShotText = J.Common["SetIntroShotText"]
--- 设置物品使用次数
--- 设置[物品]的使用次数为[Charges]
--- 设置为0可以使物品能无限次使用.
--- whichItem number item
--- charges number int
---@type fun(whichItem:number,charges:number):void
J.SetItemCharges = J.Common["SetItemCharges"]
--- 设置重生神符的产生单位类型
--- 设置[物品]产生[单位类型]
--- 设置重生神符对应的单位类型后，当英雄吃了重生神符，则会产生指定类型的单位。
--- whichItem number item
--- unitId number int
---@type fun(whichItem:number,unitId:number):void
J.SetItemDropID = J.Common["SetItemDropID"]
--- 设置物品死亡是否掉落
--- 设置[物品][Drop from/Stay with]在持有者死亡时
--- whichItem number item
--- flag boolean
---@type fun(whichItem:number,flag:boolean):void
J.SetItemDropOnDeath = J.Common["SetItemDropOnDeath"]
--- 设置物品可否丢弃
--- 设置[物品][Droppable/Undroppable]
--- 不可掉落物品在被捡起之后就不能移动和丢弃.(但可通过触发实现)
--- i number item
--- flag boolean
---@type fun(i:number,flag:boolean):void
J.SetItemDroppable = J.Common["SetItemDroppable"]
--- 设置物品无敌/可攻击
--- 设置[物品][Invulnerable/Vulnerable]
--- whichItem number item
--- flag boolean
---@type fun(whichItem:number,flag:boolean):void
J.SetItemInvulnerable = J.Common["SetItemInvulnerable"]
--- 设置物品可否抵押
--- 设置[物品][Pawnable/Unpawnable]
--- 不可抵押物品不能被卖到商店.
--- i number item
--- flag boolean
---@type fun(i:number,flag:boolean):void
J.SetItemPawnable = J.Common["SetItemPawnable"]
--- 改变物品所属玩家
--- 改变[物品]的所属玩家为:[某个玩家]并[Change/Retain Color]
--- 不是所有物品都能改变颜色. 所属玩家与持有者无关,默认为中立被动玩家.
--- whichItem number item
--- whichPlayer number player
--- changeColor boolean
---@type fun(whichItem:number,whichPlayer:number,changeColor:boolean):void
J.SetItemPlayer = J.Common["SetItemPlayer"]
--- 移动物品到坐标(立即)(指定坐标) [R]
--- 移动[物品]到([X],[Y])
--- i number item
--- x number
--- y number
---@type fun(i:number,x:number,y:number):void
J.SetItemPosition = J.Common["SetItemPosition"]
--- 限制物品种类(指定市场)
--- 限制[Marketplace]的可出售物品种类数为[Quantity]
--- 只影响有'出售物品'技能的单位.
--- whichUnit number unit
--- slots number int
---@type fun(whichUnit:number,slots:number):void
J.SetItemTypeSlots = J.Common["SetItemTypeSlots"]
--- 设置物品自定义值
--- 设置[物品]的自定义值为[Index]
--- 物品自定义值只用于触发器. 可以用来为物品绑定一个整型数据.
--- whichItem number item
--- data number int
---@type fun(whichItem:number,data:number):void
J.SetItemUserData = J.Common["SetItemUserData"]
--- 显示/隐藏 [R]
--- 设置[物品]的状态为:[显示/隐藏]
--- 只对在地面的物品有效,不会影响在物品栏中的物品. 单位通过触发得到一个隐藏物品时,会自动显示该物品.
--- whichItem number item
--- show boolean
---@type fun(whichItem:number,show:boolean):void
J.SetItemVisible = J.Common["SetItemVisible"]
--- 改变闪电效果颜色
--- 改变[某个闪电效果]的颜色值为([Red][Green][Blue]) Alpha通道值为[Alpha]
--- 颜色格式为(红,绿,蓝). 颜色和Alpha通道值取值范围0-1. Alpha通道值为0即完全透明.
--- whichBolt number lightning
--- r number
--- g number
--- b number
--- a number
---@type fun(whichBolt:number,r:number,g:number,b:number,a:number):boolean
J.SetLightningColor = J.Common["SetLightningColor"]
--- description string
---@type fun(description:string):void
J.SetMapDescription = J.Common["SetMapDescription"]
--- 设置地图参数
--- 设置[Map Flag]为[On/Off]
--- whichMapFlag any mapflag
--- value boolean
---@type fun(whichMapFlag:any,value:boolean):void
J.SetMapFlag = J.Common["SetMapFlag"]
--- 设置背景音乐列表 [R]
--- 设置背景音乐列表为:[Music],[允许/禁止]随机播放, 开始播放序号为[Index]
--- 可指定播放文件或播放目录.
--- musicName string
--- random boolean
--- index number int
---@type fun(musicName:string,random:boolean,index:number):void
J.SetMapMusic = J.Common["SetMapMusic"]
--- name string
---@type fun(name:string):void
J.SetMapName = J.Common["SetMapName"]
--- 允许/禁止 关卡
--- [Enable/Disable][Mission]
--- campaignNumber number int
--- missionNumber number int
--- available boolean
---@type fun(campaignNumber:number,missionNumber:number,available:boolean):void
J.SetMissionAvailable = J.Common["SetMissionAvailable"]
--- 设置背景音乐播放时间点 [R]
--- 设置当前背景音乐的播放时间点为[Offset]毫秒
--- millisecs number int
---@type fun(millisecs:number):void
J.SetMusicPlayPosition = J.Common["SetMusicPlayPosition"]
--- 设置背景音乐音量 [R]
--- 设置背景音乐音量为[Volume]
--- 音量取值范围为0-127.
--- volume number int
---@type fun(volume:number):void
J.SetMusicVolume = J.Common["SetMusicVolume"]
--- campaignNumber number int
--- available boolean
---@type fun(campaignNumber:number,available:boolean):void
J.SetOpCinematicAvailable = J.Common["SetOpCinematicAvailable"]
--- 允许/禁用 技能 [R]
--- 设置[某个玩家]的[技能]为[Enable/Disable]
--- 设置玩家能否使用该技能.
--- whichPlayer number player
--- abilid number int
--- avail boolean
---@type fun(whichPlayer:number,abilid:number,avail:boolean):void
J.SetPlayerAbilityAvailable = J.Common["SetPlayerAbilityAvailable"]
--- 设置联盟状态(指定项目) [R]
--- 命令[某个玩家]对[某个玩家]设置[Alliance Type][On/Off]
--- 注意:可以对玩家自己设置联盟状态. 可用来实现一些特殊效果.
--- sourcePlayer number player
--- otherPlayer number player
--- whichAllianceSetting any alliancetype
--- value boolean
---@type fun(sourcePlayer:number,otherPlayer:number,whichAllianceSetting:any,value:boolean):void
J.SetPlayerAlliance = J.Common["SetPlayerAlliance"]
--- 改变玩家颜色 [R]
--- 将[某个玩家]的玩家颜色改为[Color]
--- 不改变现有单位的颜色.
--- whichPlayer number player
--- color any playercolor
---@type fun(whichPlayer:number,color:any):void
J.SetPlayerColor = J.Common["SetPlayerColor"]
--- whichPlayer number player
--- controlType any mapcontrol
---@type fun(whichPlayer:number,controlType:any):void
J.SetPlayerController = J.Common["SetPlayerController"]
--- 设置生命上限 [R]
--- 设置[某个玩家]的生命障碍为正常的[Percent]倍
--- 生命上限影响玩家拥有单位的生命最大值. 生命之书并不受生命上限限制,所以对英雄血量可能会有偏差.
--- whichPlayer number player
--- handicap number
---@type fun(whichPlayer:number,handicap:number):void
J.SetPlayerHandicap = J.Common["SetPlayerHandicap"]
--- 设置经验获得率 [R]
--- 设置[某个玩家]的经验获得率为正常的[Value]倍
--- whichPlayer number player
--- handicap number
---@type fun(whichPlayer:number,handicap:number):void
J.SetPlayerHandicapXP = J.Common["SetPlayerHandicapXP"]
--- 更改名字
--- 更改[某个玩家]的名字为[文字]
--- whichPlayer number player
--- name string
---@type fun(whichPlayer:number,name:string):void
J.SetPlayerName = J.Common["SetPlayerName"]
--- 显示/隐藏计分屏显示 [R]
--- 设置[某个玩家][显示/隐藏]在计分屏的显示.
--- whichPlayer number player
--- flag boolean
---@type fun(whichPlayer:number,flag:boolean):void
J.SetPlayerOnScoreScreen = J.Common["SetPlayerOnScoreScreen"]
--- whichPlayer number player
--- whichRacePreference any racepreference
---@type fun(whichPlayer:number,whichRacePreference:any):void
J.SetPlayerRacePreference = J.Common["SetPlayerRacePreference"]
--- whichPlayer number player
--- value boolean
---@type fun(whichPlayer:number,value:boolean):void
J.SetPlayerRaceSelectable = J.Common["SetPlayerRaceSelectable"]
--- whichPlayer number player
--- startLocIndex number int
---@type fun(whichPlayer:number,startLocIndex:number):void
J.SetPlayerStartLocation = J.Common["SetPlayerStartLocation"]
--- 设置属性
--- 设置[某个玩家]的[Property]为[Value]
--- whichPlayer number player
--- whichPlayerState any playerstate
--- value number int
---@type fun(whichPlayer:number,whichPlayerState:any,value:number):void
J.SetPlayerState = J.Common["SetPlayerState"]
--- 设置税率 [R]
--- 设置[某个玩家]交纳给[某个玩家]的[Resource]所得税为[Rate]%
--- 缴纳所得税所损失的资源可以通过'玩家得分'的'税务损失的黄金/木材'来获取. 所得税最高为100%. 且玩家1对玩家2和玩家3都交纳80%所得税.则玩家1采集黄金时将给玩家2 8黄金,玩家3 2黄金.
--- sourcePlayer number player
--- otherPlayer number player
--- whichResource any playerstate
--- rate number int
---@type fun(sourcePlayer:number,otherPlayer:number,whichResource:any,rate:number):void
J.SetPlayerTaxRate = J.Common["SetPlayerTaxRate"]
--- 设置玩家队伍
--- 设置[某个玩家]的队伍为[队伍ID]
--- whichPlayer number player
--- whichTeam number int
---@type fun(whichPlayer:number,whichTeam:number):void
J.SetPlayerTeam = J.Common["SetPlayerTeam"]
--- whichPlayer number player
--- techid number int
--- maximum number int
---@type fun(whichPlayer:number,techid:number,maximum:number):void
J.SetPlayerTechMaxAllowed = J.Common["SetPlayerTechMaxAllowed"]
--- whichPlayer number player
--- techid number int
--- setToLevel number int
---@type fun(whichPlayer:number,techid:number,setToLevel:number):void
J.SetPlayerTechResearched = J.Common["SetPlayerTechResearched"]
--- whichPlayer number player
--- newOwner number int
---@type fun(whichPlayer:number,newOwner:number):void
J.SetPlayerUnitsOwner = J.Common["SetPlayerUnitsOwner"]
--- playercount number int
---@type fun(playercount:number):void
J.SetPlayers = J.Common["SetPlayers"]
--- 设置随机种子
--- 设置随机种子数为：[整数]
--- 设置游戏的随机种子，随机种子会影响随机整数，攻击骰子之类的随机数。
--- seed number int
---@type fun(seed:number):void
J.SetRandomSeed = J.Common["SetRandomSeed"]
--- 设置矩形区域(指定坐标) [R]
--- 重新设置[矩形区域],左下角坐标为([X],[Y]), 右上角坐标为([X],[Y])
--- 该区域必须是一个变量. 重新设置矩形区域的大小和位置.
--- whichRect number rect
--- minx number
--- miny number
--- maxx number
--- maxy number
---@type fun(whichRect:number,minx:number,miny:number,maxx:number,maxy:number):void
J.SetRect = J.Common["SetRect"]
--- 设置矩形区域(指定点) [R]
--- 重新设置[矩形区域],左下角点为[坐标]右上角点为[坐标]
--- 该区域必须是一个变量. 重新设置矩形区域的大小和位置.
--- whichRect number rect
--- min number location
--- max number location
---@type fun(whichRect:number,min:number,max:number):void
J.SetRectFromLoc = J.Common["SetRectFromLoc"]
--- 保留英雄图标
--- 为玩家保留[Number]个左上角英雄图标.
--- 因为共享单位而被控制的其他玩家英雄的图标将在保留位置之后开始显示.
--- reserved number int
---@type fun(reserved:number):void
J.SetReservedLocalHeroButtons = J.Common["SetReservedLocalHeroButtons"]
--- 设置黄金储量
--- 设置[金矿]的黄金储量为[Quantity]
--- whichUnit number unit
--- amount number int
---@type fun(whichUnit:number,amount:number):void
J.SetResourceAmount = J.Common["SetResourceAmount"]
--- whichdensity any mapdensity
---@type fun(whichdensity:any):void
J.SetResourceDensity = J.Common["SetResourceDensity"]
--- 设置天空
--- 设置天空模型为[Sky]
--- skyModelFile string
---@type fun(skyModelFile:string):void
J.SetSkyModel = J.Common["SetSkyModel"]
--- soundHandle number sound
--- channel number int
---@type fun(soundHandle:number,channel:number):void
J.SetSoundChannel = J.Common["SetSoundChannel"]
--- soundHandle number sound
--- inside number
--- outside number
--- outsideVolume number int
---@type fun(soundHandle:number,inside:number,outside:number,outsideVolume:number):void
J.SetSoundConeAngles = J.Common["SetSoundConeAngles"]
--- soundHandle number sound
--- x number
--- y number
--- z number
---@type fun(soundHandle:number,x:number,y:number,z:number):void
J.SetSoundConeOrientation = J.Common["SetSoundConeOrientation"]
--- 设置声音截断距离
--- 设置[音效]的截断距离为[数值]
--- 地图距离,玩家镜头距离音源超过该范围则切断声音.
--- soundHandle number sound
--- cutoff number
---@type fun(soundHandle:number,cutoff:number):void
J.SetSoundDistanceCutoff = J.Common["SetSoundDistanceCutoff"]
--- 设置3D音效衰减范围
--- 设置[3D音效]的衰减最小范围:[数值]最大范围:[数值]
--- 该动作仅用于3D音效. 注意不一定要达到最大范围,音量衰减到一定程度也会变没的.
--- soundHandle number sound
--- minDist number
--- maxDist number
---@type fun(soundHandle:number,minDist:number,maxDist:number):void
J.SetSoundDistances = J.Common["SetSoundDistances"]
--- soundHandle number sound
--- duration number int
---@type fun(soundHandle:number,duration:number):void
J.SetSoundDuration = J.Common["SetSoundDuration"]
--- soundHandle number sound
--- soundLabel string
---@type fun(soundHandle:number,soundLabel:string):void
J.SetSoundParamsFromLabel = J.Common["SetSoundParamsFromLabel"]
--- 设置声音速率
--- 设置[音效]的速率为[数值]
--- 表示正常速率的倍数.
--- soundHandle number sound
--- pitch number
---@type fun(soundHandle:number,pitch:number):void
J.SetSoundPitch = J.Common["SetSoundPitch"]
--- 设置音效播放时间点 [R]
--- 设置[音效]的播放时间点为[Offset]毫秒
--- 音效必须是正在播放的. 不能用于3D音效.
--- soundHandle number sound
--- millisecs number int
---@type fun(soundHandle:number,millisecs:number):void
J.SetSoundPlayPosition = J.Common["SetSoundPlayPosition"]
--- 设置3D音效位置(指定坐标) [R]
--- 设置[3D音效]的播放位置为([X],[Y]), Z轴高度为[Z]
--- 该动作仅用于3D音效.
--- soundHandle number sound
--- x number
--- y number
--- z number
---@type fun(soundHandle:number,x:number,y:number,z:number):void
J.SetSoundPosition = J.Common["SetSoundPosition"]
--- soundHandle number sound
--- x number
--- y number
--- z number
---@type fun(soundHandle:number,x:number,y:number,z:number):void
J.SetSoundVelocity = J.Common["SetSoundVelocity"]
--- 设置音效音量 [R]
--- 设置[音效]的音量为[Volume]
--- 音量取值范围0-127.
--- soundHandle number sound
--- volume number int
---@type fun(soundHandle:number,volume:number):void
J.SetSoundVolume = J.Common["SetSoundVolume"]
--- whichStartLoc number int
--- prioSlotIndex number int
--- otherStartLocIndex number int
--- priority any startlocprio
---@type fun(whichStartLoc:number,prioSlotIndex:number,otherStartLocIndex:number,priority:any):void
J.SetStartLocPrio = J.Common["SetStartLocPrio"]
--- whichStartLoc number int
--- prioSlotCount number int
---@type fun(whichStartLoc:number,prioSlotCount:number):void
J.SetStartLocPrioCount = J.Common["SetStartLocPrioCount"]
--- teamcount number int
---@type fun(teamcount:number):void
J.SetTeams = J.Common["SetTeams"]
--- a number
--- b number
--- c number
--- d number
--- e number
---@type fun(a:number,b:number,c:number,d:number,e:number):void
J.SetTerrainFog = J.Common["SetTerrainFog"]
--- 设置迷雾 [R]
--- 迷雾风格:[Style], Z轴开始端:[Z-Start], Z轴结束端:[Z-End], 密度:[Density]颜色:([Red],[Green],[Blue])
--- 颜色格式为(红,绿,蓝). 取值范围0.00-1.00.
--- style number int
--- zstart number
--- zend number
--- density number
--- red number
--- green number
--- blue number
---@type fun(style:number,zstart:number,zend:number,density:number,red:number,green:number,blue:number):void
J.SetTerrainFogEx = J.Common["SetTerrainFogEx"]
--- 设置地形通行状态(指定坐标) [R]
--- 设置([X],[Y])处单元点的[Pathing]地形通行状态为:[On/Off]
--- 例:设置'建造'通行状态为开,则该点可以建造建筑. 一个单元点范围为32x32.
--- x number
--- y number
--- t any pathingtype
--- flag boolean
---@type fun(x:number,y:number,t:any,flag:boolean):void
J.SetTerrainPathable = J.Common["SetTerrainPathable"]
--- 改变地形类型(指定坐标) [R]
--- 改变([X],[Y])处的地形为[Terrain Type],使用样式:[Variation]范围:[Area]形状:[Shape]
--- 地形样式-1表示随机样式. 范围即地形编辑器中的刷子大小.1表示128x128范围
--- x number
--- y number
--- terrainType number int
--- variation number int
--- area number int
--- shape number int
---@type fun(x:number,y:number,terrainType:number,variation:number,area:number,shape:number):void
J.SetTerrainType = J.Common["SetTerrainType"]
--- 设置已存在时间
--- 设置[Floating Text]的已存在时间为[Time]秒
--- 该动作并不影响永久性漂浮文字.
--- t number texttag
--- age number
---@type fun(t:number,age:number):void
J.SetTextTagAge = J.Common["SetTextTagAge"]
--- 改变颜色 [R]
--- 改变[Floating Text]的颜色为([Red],[Green],[Blue]) 透明值为[Alpha]
--- 颜色格式为(红,绿,蓝). 透明值0为不可见. 颜色值和透明值取值范围为0-255.
--- t number texttag
--- red number int
--- green number int
--- blue number int
--- alpha number int
---@type fun(t:number,red:number,green:number,blue:number,alpha:number):void
J.SetTextTagColor = J.Common["SetTextTagColor"]
--- 设置消逝时间点
--- 设置[Floating Text]的消逝时间点为[Time]秒
--- 该动作并不影响永久性漂浮文字. 当漂浮文字存在时间到达该值时会开始淡化消逝.
--- t number texttag
--- fadepoint number
---@type fun(t:number,fadepoint:number):void
J.SetTextTagFadepoint = J.Common["SetTextTagFadepoint"]
--- 设置显示时间
--- 设置[Floating Text]的显示时间为[Time]秒
--- 该动作并不影响永久性漂浮文字. 当显示时间到期时,系统会自动清除该漂浮文字.
--- t number texttag
--- lifespan number
---@type fun(t:number,lifespan:number):void
J.SetTextTagLifespan = J.Common["SetTextTagLifespan"]
--- 设置永久显示
--- 设置[Floating Text]:[Enable/Disable]永久显示.
--- t number texttag
--- flag boolean
---@type fun(t:number,flag:boolean):void
J.SetTextTagPermanent = J.Common["SetTextTagPermanent"]
--- 改变位置(坐标) [R]
--- 改变[Floating Text]的位置为([X],[Y]) ,Z轴高度为[Z]
--- t number texttag
--- x number
--- y number
--- heightOffset number
---@type fun(t:number,x:number,y:number,heightOffset:number):void
J.SetTextTagPos = J.Common["SetTextTagPos"]
--- 改变位置(单位)
--- 改变[Floating Text]的位置到[单位]头顶Z轴偏移[Z]处
--- t number texttag
--- whichUnit number unit
--- heightOffset number
---@type fun(t:number,whichUnit:number,heightOffset:number):void
J.SetTextTagPosUnit = J.Common["SetTextTagPosUnit"]
--- 暂停/恢复
--- 设置[Floating Text]:[Enable/Disable]暂停状态
--- 暂停状态暂停漂浮文字的移动和生命计时.
--- t number texttag
--- flag boolean
---@type fun(t:number,flag:boolean):void
J.SetTextTagSuspended = J.Common["SetTextTagSuspended"]
--- 改变文字内容 [R]
--- 改变[Floating Text]的内容为[文字],字体大小:[Size]
--- 采用原始字体大小单位. 字体大小不能超过0.5.
--- t number texttag
--- s string
--- height number
---@type fun(t:number,s:string,height:number):void
J.SetTextTagText = J.Common["SetTextTagText"]
--- 设置速率 [R]
--- 设置[Floating Text]的X轴速率:[XSpeed],Y轴速率:[YSpeed]
--- 对移动后的漂浮文字设置速率,该漂浮文字会先回到原点再向设定的角度移动. 这里的1约等于游戏中的1800速度.
--- t number texttag
--- xvel number
--- yvel number
---@type fun(t:number,xvel:number,yvel:number):void
J.SetTextTagVelocity = J.Common["SetTextTagVelocity"]
--- 显示/隐藏 (所有玩家) [R]
--- 对所有玩家[显示/隐藏][Floating Text]
--- t number texttag
--- flag boolean
---@type fun(t:number,flag:boolean):void
J.SetTextTagVisibility = J.Common["SetTextTagVisibility"]
--- 设置主题音乐播放时间点 [R]
--- 设置当前主题音乐播放时间点为[Offset]毫秒
--- millisecs number int
---@type fun(millisecs:number):void
J.SetThematicMusicPlayPosition = J.Common["SetThematicMusicPlayPosition"]
--- 设置昼夜时间流逝速度 [R]
--- 设置昼夜时间流逝速度为默认值的[Value]倍
--- 设置100%来恢复正常值. 该值并不影响游戏速度.
--- r number
---@type fun(r:number):void
J.SetTimeOfDayScale = J.Common["SetTimeOfDayScale"]
--- cleared boolean
---@type fun(cleared:boolean):void
J.SetTutorialCleared = J.Common["SetTutorialCleared"]
--- 设置渲染状态
--- 设置[某个地形纹理]:[Enable/Disable]渲染状态
--- 未发现有任何作用.
--- whichSplat any ubersplat
--- flag boolean
---@type fun(whichSplat:any,flag:boolean):void
J.SetUbersplatRender = J.Common["SetUbersplatRender"]
--- 设置永久渲染状态
--- 设置[某个地形纹理]:[Enable/Disable]永久渲染状态
--- 要显示地面纹理变化则必须开启该项.
--- whichSplat any ubersplat
--- flag boolean
---@type fun(whichSplat:any,flag:boolean):void
J.SetUbersplatRenderAlways = J.Common["SetUbersplatRenderAlways"]
--- 设置技能等级 [R]
--- 设置[单位]的[技能]等级为[Level]
--- 改变死亡单位的光环技能会导致魔兽崩溃.
--- whichUnit number unit
--- abilcode number int
--- level number int
---@type fun(whichUnit:number,abilcode:number,level:number):number int
J.SetUnitAbilityLevel = J.Common["SetUnitAbilityLevel"]
--- 设置主动攻击范围
--- 设置[单位]的主动攻击范围为[数值]
--- whichUnit number unit
--- newAcquireRange number
---@type fun(whichUnit:number,newAcquireRange:number):void
J.SetUnitAcquireRange = J.Common["SetUnitAcquireRange"]
--- 播放单位动画
--- 播放[Unit]的[动画名]动作
--- 通过 '重置单位动作' 恢复到普通的动作.
--- whichUnit number unit
--- whichAnimation string
---@type fun(whichUnit:number,whichAnimation:string):void
J.SetUnitAnimation = J.Common["SetUnitAnimation"]
--- 播放单位指定序号动动作 [R]
--- 播放[单位]的第[序号]号动作
--- 可以指定播放所有的单位动画,不过需要自己多尝试.每个单位的动作序号不一样的.
--- whichUnit number unit
--- whichAnimation number int
---@type fun(whichUnit:number,whichAnimation:number):void
J.SetUnitAnimationByIndex = J.Common["SetUnitAnimationByIndex"]
--- 播放单位动运作(指定概率)
--- 播放[单位]的[Animation Name]动作,只用[Rarity]动作
--- 通过 '重置单位动作' 恢复到普通的动作.
--- whichUnit number unit
--- whichAnimation string
--- rarity any raritycontrol
---@type fun(whichUnit:number,whichAnimation:string,rarity:any):void
J.SetUnitAnimationWithRarity = J.Common["SetUnitAnimationWithRarity"]
--- 改变单位混合时间
--- 改变[单位]的混合时间为[数值]
--- 单位动画图像混合时间. 决定身体部件连接的快慢,比如攻击时手臂挥舞的速度. 默认值0.15,增大该值会导致动作僵硬化.
--- whichUnit number unit
--- blendTime number
---@type fun(whichUnit:number,blendTime:number):void
J.SetUnitBlendTime = J.Common["SetUnitBlendTime"]
--- 改变队伍颜色
--- 改变[单位]的队伍颜色为[Color]
--- 改变队伍颜色并不会改变单位所属.
--- whichUnit number unit
--- whichColor any playercolor
---@type fun(whichUnit:number,whichColor:any):void
J.SetUnitColor = J.Common["SetUnitColor"]
--- 锁定指定单位的警戒点 [R]
--- 设置[单位]的警戒点:[option]
--- 锁定并防止 AI 脚本改动单位警戒点.
--- whichUnit number unit
--- creepGuard boolean
---@type fun(whichUnit:number,creepGuard:boolean):void
J.SetUnitCreepGuard = J.Common["SetUnitCreepGuard"]
--- 设置死亡方式
--- 设置[单位][Explode/Die Normally]在死亡时
--- whichUnit number unit
--- exploded boolean
---@type fun(whichUnit:number,exploded:boolean):void
J.SetUnitExploded = J.Common["SetUnitExploded"]
--- 设置单位面向角度 [R]
--- 设置[单位]的面向角度为[Angle]度
--- 面向角度采用角度制,0度为正东方向,90度为正北方向。速度等于单位的转身速度。
--- whichUnit number unit
--- facingAngle number
---@type fun(whichUnit:number,facingAngle:number):void
J.SetUnitFacing = J.Common["SetUnitFacing"]
--- 设置单位面向角度(指定时间)
--- 设置[单位]的面向角度为[Angle]度,使用时间[Time]秒
--- 面向角度采用角度制,0度为正东方向,90度为正北方向。不能超过单位的转身速度。
--- whichUnit number unit
--- facingAngle number
--- duration number
---@type fun(whichUnit:number,facingAngle:number,duration:number):void
J.SetUnitFacingTimed = J.Common["SetUnitFacingTimed"]
--- 改变单位飞行高度
--- 改变[单位]的飞行高度为[数值],变换速率:[数值]
--- 飞行单位可以直接改变飞行高度. 其他单位通过添加/删除 替换为飞行单位的变身技能(如乌鸦形态)之后,也能改变飞行高度.
--- whichUnit number unit
--- newHeight number
--- rate number
---@type fun(whichUnit:number,newHeight:number,rate:number):void
J.SetUnitFlyHeight = J.Common["SetUnitFlyHeight"]
--- a number
--- b number
--- c number
--- d number
--- e number
---@type fun(a:number,b:number,c:number,d:number,e:number):void
J.SetUnitFog = J.Common["SetUnitFog"]
--- 设置无敌/可攻击
--- 设置[单位][Invulnerable/Vulnerable]
--- whichUnit number unit
--- flag boolean
---@type fun(whichUnit:number,flag:boolean):void
J.SetUnitInvulnerable = J.Common["SetUnitInvulnerable"]
--- 锁定身体朝向
--- 锁定[单位]的[Source]朝向[目标单位],偏移坐标 ([X],[Y],[Z])
--- 单位的该身体部件会一直朝向目标单位的偏移坐标点处,直到使用'重置身体朝向'. 坐标偏移以目标单位脚下为坐标原点.
--- whichUnit number unit
--- whichBone string
--- lookAtTarget number unit
--- offsetX number
--- offsetY number
--- offsetZ number
---@type fun(whichUnit:number,whichBone:string,lookAtTarget:number,offsetX:number,offsetY:number,offsetZ:number):void
J.SetUnitLookAt = J.Common["SetUnitLookAt"]
--- 设置移动速度
--- 设置[单位]的移动速度为[Speed]
--- whichUnit number unit
--- newSpeed number
---@type fun(whichUnit:number,newSpeed:number):void
J.SetUnitMoveSpeed = J.Common["SetUnitMoveSpeed"]
--- 改变所属
--- 改变[单位]所属为[某个玩家]并[Change/Retain Color]
--- whichUnit number unit
--- whichPlayer number player
--- changeColor boolean
---@type fun(whichUnit:number,whichPlayer:number,changeColor:boolean):void
J.SetUnitOwner = J.Common["SetUnitOwner"]
--- 设置碰撞开关
--- 设置[单位][On/Off]碰撞
--- 关闭碰撞的单位无视障碍物,但其他单位仍视其为障碍物.
--- whichUnit number unit
--- flag boolean
---@type fun(whichUnit:number,flag:boolean):void
J.SetUnitPathing = J.Common["SetUnitPathing"]
--- 移动单位(立即)(指定坐标) [R]
--- 立即移动[单位]到([X],[Y])
--- whichUnit number unit
--- newX number
--- newY number
---@type fun(whichUnit:number,newX:number,newY:number):void
J.SetUnitPosition = J.Common["SetUnitPosition"]
--- 移动单位(立即)(指定点)
--- 立即移动[单位]到[指定点]
--- whichUnit number unit
--- whichLocation number location
---@type fun(whichUnit:number,whichLocation:number):void
J.SetUnitPositionLoc = J.Common["SetUnitPositionLoc"]
--- 改变单位转向角度(弧度制) [R]
--- 改变[单位]的转向角度为[数值](弧度制)
--- 设置单位转身时的转向角度. 数值越大转向幅度越大.
--- whichUnit number unit
--- newPropWindowAngle number
---@type fun(whichUnit:number,newPropWindowAngle:number):void
J.SetUnitPropWindow = J.Common["SetUnitPropWindow"]
--- 设置可否营救(对玩家) [R]
--- 设置[单位]对[玩家][Rescuable/Unrescuable]
--- whichUnit number unit
--- byWhichPlayer number player
--- flag boolean
---@type fun(whichUnit:number,byWhichPlayer:number,flag:boolean):void
J.SetUnitRescuable = J.Common["SetUnitRescuable"]
--- 设置营救范围
--- 设置[单位]的营救范围为[Range]
--- whichUnit number unit
--- range number
---@type fun(whichUnit:number,range:number):void
J.SetUnitRescueRange = J.Common["SetUnitRescueRange"]
--- 改变单位尺寸(按倍数) [R]
--- 改变[单位]的尺寸缩放为:([X],[Y],[Z])
--- 缩放尺寸使用(长,宽,高)格式.
--- whichUnit number unit
--- scaleX number
--- scaleY number
--- scaleZ number
---@type fun(whichUnit:number,scaleX:number,scaleY:number,scaleZ:number):void
J.SetUnitScale = J.Common["SetUnitScale"]
--- 设置单位属性 [R]
--- 设置[单位]的[属性]为[Value]
--- whichUnit number unit
--- whichUnitState any unitstate
--- newVal number
---@type fun(whichUnit:number,whichUnitState:any,newVal:number):void
J.SetUnitState = J.Common["SetUnitState"]
--- 改变单位动画播放速度(按倍数) [R]
--- 改变[单位]的动画播放速度为正常速度的[Percent]倍
--- 设置1倍动画播放速度来恢复正常状态.
--- whichUnit number unit
--- timeScale number
---@type fun(whichUnit:number,timeScale:number):void
J.SetUnitTimeScale = J.Common["SetUnitTimeScale"]
--- 改变单位转身速度
--- 改变[单位]的转身速度为[Value]
--- 转身速度表示单位改变面向方向时的速度，数值(0-1)越小表示转身越慢，为0则无法转身。
--- whichUnit number unit
--- newTurnSpeed number
---@type fun(whichUnit:number,newTurnSpeed:number):void
J.SetUnitTurnSpeed = J.Common["SetUnitTurnSpeed"]
--- 限制单位种类(指定市场)
--- 限制[Marketplace]的可出售单位种类数为[Quantity]
--- 只影响有'出售单位'技能的单位.
--- whichUnit number unit
--- slots number int
---@type fun(whichUnit:number,slots:number):void
J.SetUnitTypeSlots = J.Common["SetUnitTypeSlots"]
--- 允许/禁止 人口占用 [R]
--- 设置[单位]:[Enable/Disable]其人口占用
--- whichUnit number unit
--- useFood boolean
---@type fun(whichUnit:number,useFood:boolean):void
J.SetUnitUseFood = J.Common["SetUnitUseFood"]
--- 设置自定义值
--- 设置[单位]的自定义值为[Index]
--- 单位自定义值仅用于触发器. 可用来给单位绑定一个整型数据.
--- whichUnit number unit
--- data number int
---@type fun(whichUnit:number,data:number):void
J.SetUnitUserData = J.Common["SetUnitUserData"]
--- 改变单位的颜色(RGB:0-255) [R]
--- 改变[单位]的颜色值: ([Red],[Green],[Blue]), 透明值:[Alpha]
--- 颜色格式为(红,绿,蓝). 大多数单位使用(255,255,255)的颜色值和255的Alpha值. 透明值为0是不可见的.颜色值和Alpha值取值范围为0-255.
--- whichUnit number unit
--- red number int
--- green number int
--- blue number int
--- alpha number int
---@type fun(whichUnit:number,red:number,green:number,blue:number,alpha:number):void
J.SetUnitVertexColor = J.Common["SetUnitVertexColor"]
--- 设置X坐标 [R]
--- 设置[单位]的X坐标为[X]
--- 注意如果坐标超出地图边界是会出错的.
--- whichUnit number unit
--- newX number
---@type fun(whichUnit:number,newX:number):void
J.SetUnitX = J.Common["SetUnitX"]
--- 设置Y坐标 [R]
--- 设置[单位]的Y坐标为[Y]
--- 注意如果坐标超出地图边界是会出错的.
--- whichUnit number unit
--- newY number
---@type fun(whichUnit:number,newY:number):void
J.SetUnitY = J.Common["SetUnitY"]
--- 设置水颜色 [R]
--- 设置水颜色为:([Red],[Green],[Blue]), 透明值为:[Alpha]
--- 颜色格式为(红,绿,蓝). 透明值0为不可见. 颜色值和透明道值取值范围为0-255.
--- red number int
--- green number int
--- blue number int
--- alpha number int
---@type fun(red:number,green:number,blue:number,alpha:number):void
J.SetWaterBaseColor = J.Common["SetWaterBaseColor"]
--- 开启/关闭 水面变形
--- [On/Off]水面变形
--- 开启时当发生地形变化时水面高度也会随着变化. 对永久变形无效.
--- val boolean
---@type fun(val:boolean):void
J.SetWaterDeforms = J.Common["SetWaterDeforms"]
--- whichWidget number widget
--- newLife number
---@type fun(whichWidget:number,newLife:number):void
J.SetWidgetLife = J.Common["SetWidgetLife"]
--- 显示/隐藏 [R]
--- 设置[可破坏物]的状态为[显示/隐藏]
--- 隐藏的可破坏物不被显示,但仍影响通行和视线.
--- d number destructable
--- flag boolean
---@type fun(d:number,flag:boolean):void
J.ShowDestructable = J.Common["ShowDestructable"]
--- 显示/隐藏 [R]
--- 设置[某个图像][显示/隐藏]
--- whichImage number image
--- flag boolean
---@type fun(whichImage:number,flag:boolean):void
J.ShowImage = J.Common["ShowImage"]
--- 开启/关闭 信箱模式(所有玩家) [R]
--- [开启/关闭]信箱模式,转换时间为[Duration]秒
--- 使用电影镜头模式,隐藏游戏界面.
--- flag boolean
--- fadeDuration number
---@type fun(flag:boolean,fadeDuration:number):void
J.ShowInterface = J.Common["ShowInterface"]
--- 显示/隐藏 地面纹理变化[R]
--- 设置[某个地形纹理]状态为[显示/隐藏]
--- whichSplat any ubersplat
--- flag boolean
---@type fun(whichSplat:any,flag:boolean):void
J.ShowUbersplat = J.Common["ShowUbersplat"]
--- 显示/隐藏 [R]
--- 设置[单位]的状态为[显示/隐藏]
--- 隐藏单位不会被'区域内单位'所选取.
--- whichUnit number unit
--- show boolean
---@type fun(whichUnit:number,show:boolean):void
J.ShowUnit = J.Common["ShowUnit"]
--- x number
---@type fun(x:number):number
J.SquareRoot = J.Common["SquareRoot"]
--- 启用战役AI
--- 为[某个玩家]启用战役AI:[Script]
--- AI只能对电脑玩家使用,当运行该动作后,与之配匹的电脑玩家会强制执行该AI脚本.
--- num number player
--- script string
---@type fun(num:number,script:string):void
J.StartCampaignAI = J.Common["StartCampaignAI"]
--- 启用对战AI
--- 为[某个玩家]启用对战AI:[Script]
--- AI只能对电脑玩家使用,当运行该动作后,与之配匹的电脑玩家会强制执行该AI脚本.
--- num number player
--- script string
---@type fun(num:number,script:string):void
J.StartMeleeAI = J.Common["StartMeleeAI"]
--- soundHandle number sound
---@type fun(soundHandle:number):void
J.StartSound = J.Common["StartSound"]
--- 停止播放镜头(所有玩家) [R]
--- 让所有玩家停止播放镜头
--- 比如在平移镜头的过程中可用该动作来中断平移.
---@type fun():void
J.StopCamera = J.Common["StopCamera"]
--- 停止背景音乐
--- 停止背景音乐[After Fading/Immediately]
--- fadeOut boolean
---@type fun(fadeOut:boolean):void
J.StopMusic = J.Common["StopMusic"]
--- 停止音效
--- 停止播放[音效][After Fading/Immediately]
--- soundHandle number sound
--- killWhenDone boolean
--- fadeOut boolean
---@type fun(soundHandle:number,killWhenDone:boolean,fadeOut:boolean):void
J.StopSound = J.Common["StopSound"]
--- 记录布尔值
--- 缓存:[Game Cache] 类别名:[Category]使用名称:[文字]记录:[布尔值]
--- 使用'游戏缓存 - 读取布尔值'来读取该值. 名称和类别名不能包含空格.
--- cache any gamecache
--- missionKey string
--- key string
--- value boolean
---@type fun(cache:any,missionKey:string,key:string,value:boolean):void
J.StoreBoolean = J.Common["StoreBoolean"]
--- 记录整数
--- 缓存:[Game Cache] 类别名:[Category]使用名称:[文字]记录:[整数]
--- 使用'游戏缓存 - 读取整数'来读取该数值. 名称和类别名不能包含空格.
--- cache any gamecache
--- missionKey string
--- key string
--- value number int
---@type fun(cache:any,missionKey:string,key:string,value:number):void
J.StoreInteger = J.Common["StoreInteger"]
--- 记录实数
--- 缓存:[Game Cache] 类别名:[Category]使用名称:[文字]记录:[实数]
--- 使用'游戏缓存 - 读取实数'来读取该数值. 名称和类别名不能包含空格.
--- cache any gamecache
--- missionKey string
--- key string
--- value number
---@type fun(cache:any,missionKey:string,key:string,value:number):void
J.StoreReal = J.Common["StoreReal"]
--- 记录字符串
--- 缓存:[Game Cache] 类别名:[Category]使用名称:[文字]记录:[字符串]
--- 使用'游戏缓存 - 读取字符串'来读取该值. 名称和类别名不能包含空格.
--- cache any gamecache
--- missionKey string
--- key string
--- value string
---@type fun(cache:any,missionKey:string,key:string,value:string):boolean
J.StoreString = J.Common["StoreString"]
--- 记录单位
--- 记录[单位],使用名称:[文字]类别名:[Category]缓存:[Game Cache]
--- 使用'游戏缓存 - 读取单位'来读取该数值. 名称和类别名不能包含空格.
--- cache any gamecache
--- missionKey string
--- key string
--- whichUnit number unit
---@type fun(cache:any,missionKey:string,key:string,whichUnit:number):boolean
J.StoreUnit = J.Common["StoreUnit"]
--- source string
--- upper boolean
---@type fun(source:string,upper:boolean):string
J.StringCase = J.Common["StringCase"]
--- s string
---@type fun(s:string):number int
J.StringHash = J.Common["StringHash"]
--- s string
---@type fun(s:string):number int
J.StringLength = J.Common["StringLength"]
--- source string
--- start number int
--- end number int
---@type fun(source:string,start:number,end:number):string
J.SubString = J.Common["SubString"]
--- 允许/禁止经验获取 [R]
--- [Enable/Disable][某个英雄]的经验获取
--- whichHero number unit
--- flag boolean
---@type fun(whichHero:number,flag:boolean):void
J.SuspendHeroXP = J.Common["SuspendHeroXP"]
--- b boolean
---@type fun(b:boolean):void
J.SuspendTimeOfDay = J.Common["SuspendTimeOfDay"]
---@type fun():void
J.SyncSelections = J.Common["SyncSelections"]
--- cache any gamecache
--- missionKey string
--- key string
---@type fun(cache:any,missionKey:string,key:string):void
J.SyncStoredBoolean = J.Common["SyncStoredBoolean"]
--- cache any gamecache
--- missionKey string
--- key string
---@type fun(cache:any,missionKey:string,key:string):void
J.SyncStoredInteger = J.Common["SyncStoredInteger"]
--- cache any gamecache
--- missionKey string
--- key string
---@type fun(cache:any,missionKey:string,key:string):void
J.SyncStoredReal = J.Common["SyncStoredReal"]
--- cache any gamecache
--- missionKey string
--- key string
---@type fun(cache:any,missionKey:string,key:string):void
J.SyncStoredString = J.Common["SyncStoredString"]
--- cache any gamecache
--- missionKey string
--- key string
---@type fun(cache:any,missionKey:string,key:string):void
J.SyncStoredUnit = J.Common["SyncStoredUnit"]
--- x number
--- y number
--- radius number
--- depth number
--- duration number int
--- permanent boolean
---@type fun(x:number,y:number,radius:number,depth:number,duration:number,permanent:boolean):any terraindeformation
J.TerrainDeformCrater = J.Common["TerrainDeformCrater"]
--- x number
--- y number
--- radius number
--- minDelta number
--- maxDelta number
--- duration number int
--- updateInterval number int
---@type fun(x:number,y:number,radius:number,minDelta:number,maxDelta:number,duration:number,updateInterval:number):any terraindeformation
J.TerrainDeformRandom = J.Common["TerrainDeformRandom"]
--- x number
--- y number
--- radius number
--- depth number
--- duration number int
--- count number int
--- spaceWaves number
--- timeWaves number
--- radiusStartPct number
--- limitNeg boolean
---@type fun(x:number,y:number,radius:number,depth:number,duration:number,count:number,spaceWaves:number,timeWaves:number,radiusStartPct:number,limitNeg:boolean):any terraindeformation
J.TerrainDeformRipple = J.Common["TerrainDeformRipple"]
--- 停止地形变化 [R]
--- 停止[Terrain Deformation],衰退时间:[Duration]毫秒
--- 地形变化会平滑地过渡到无.
--- deformation any terraindeformation
--- duration number int
---@type fun(deformation:any,duration:number):void
J.TerrainDeformStop = J.Common["TerrainDeformStop"]
--- 停止所有地形变化
--- 包括由技能引起的地形变化.
---@type fun():void
J.TerrainDeformStopAll = J.Common["TerrainDeformStopAll"]
--- x number
--- y number
--- dirX number
--- dirY number
--- distance number
--- speed number
--- radius number
--- depth number
--- trailTime number int
--- count number int
---@type fun(x:number,y:number,dirX:number,dirY:number,distance:number,speed:number,radius:number,depth:number,trailTime:number,count:number):any terraindeformation
J.TerrainDeformWave = J.Common["TerrainDeformWave"]
--- 显示/隐藏 计时器窗口(所有玩家) [R]
--- 设置[计时器窗口]的状态为[显示/隐藏]
--- 计时器窗口不能在地图初始化时显示.
--- whichDialog number timerdialog
--- display boolean
---@type fun(whichDialog:number,display:boolean):void
J.TimerDialogDisplay = J.Common["TimerDialogDisplay"]
--- whichDialog number timerdialog
--- timeRemaining number
---@type fun(whichDialog:number,timeRemaining:number):void
J.TimerDialogSetRealTimeRemaining = J.Common["TimerDialogSetRealTimeRemaining"]
--- 设置计时器窗口速率 [R]
--- 设置[Timer Window]的时间流逝速度为[Factor]倍
--- 同时计时器显示时间也会随之变化. 就是说60秒的计时器设置为2倍速则显示时间也会变为120秒.
--- whichDialog number timerdialog
--- speedMultFactor number
---@type fun(whichDialog:number,speedMultFactor:number):void
J.TimerDialogSetSpeed = J.Common["TimerDialogSetSpeed"]
--- 改变计时器窗口计时颜色 [R]
--- 改变[Timer Window]的计间颜色为([Red],[Green],[Blue]) 透明值为:[Alpha]
--- 颜色格式为(红,绿,蓝). Alpha通道值0为不可见. 颜色值和透明值值取值范围为0-255.
--- whichDialog number timerdialog
--- red number int
--- green number int
--- blue number int
--- alpha number int
---@type fun(whichDialog:number,red:number,green:number,blue:number,alpha:number):void
J.TimerDialogSetTimeColor = J.Common["TimerDialogSetTimeColor"]
--- 改变计时器窗口标题
--- 改变[Timer Window]的标题为[Title]
--- whichDialog number timerdialog
--- title string
---@type fun(whichDialog:number,title:string):void
J.TimerDialogSetTitle = J.Common["TimerDialogSetTitle"]
--- 改变计时器窗口文字颜色 [R]
--- 改变[Timer Window]文字颜色为([Red],[Green],[Blue]) 透明值为:[Alpha]
--- 颜色格式为(红,绿,蓝). Alpha通道值0为不可见. 颜色值和透明值值取值范围为0-255.
--- whichDialog number timerdialog
--- red number int
--- green number int
--- blue number int
--- alpha number int
---@type fun(whichDialog:number,red:number,green:number,blue:number,alpha:number):void
J.TimerDialogSetTitleColor = J.Common["TimerDialogSetTitleColor"]
--- whichTimer number timer
---@type fun(whichTimer:number):number
J.TimerGetElapsed = J.Common["TimerGetElapsed"]
--- whichTimer number timer
---@type fun(whichTimer:number):number
J.TimerGetRemaining = J.Common["TimerGetRemaining"]
--- whichTimer number timer
---@type fun(whichTimer:number):number
J.TimerGetTimeout = J.Common["TimerGetTimeout"]
--- 运行计时器 [C]
--- 运行[计时器]，周期:[时间]秒，模式:[模式]，运行函数:[函数]
--- 等同于TimerStart
--- whichTimer number timer
--- timeout number
--- periodic boolean
--- handlerFunc any code
---@type fun(whichTimer:number,timeout:number,periodic:boolean,handlerFunc:any):void
J.TimerStart = J.Common["TimerStart"]
--- whichTrigger number trigger
--- actionFunc any code
---@type fun(whichTrigger:number,actionFunc:any):function triggeraction
J.TriggerAddAction = J.Common["TriggerAddAction"]
--- whichTrigger number trigger
--- condition function boolexpr
---@type fun(whichTrigger:number,condition:function):function triggercondition
J.TriggerAddCondition = J.Common["TriggerAddCondition"]
--- whichTrigger number trigger
---@type fun(whichTrigger:number):void
J.TriggerClearActions = J.Common["TriggerClearActions"]
--- whichTrigger number trigger
---@type fun(whichTrigger:number):void
J.TriggerClearConditions = J.Common["TriggerClearConditions"]
--- whichTrigger number trigger
---@type fun(whichTrigger:number):boolean
J.TriggerEvaluate = J.Common["TriggerEvaluate"]
--- 运行触发(无视条件)
--- 运行[触发](无视条件)
--- 无视事件和条件,运行触发动作.
--- whichTrigger number trigger
---@type fun(whichTrigger:number):void
J.TriggerExecute = J.Common["TriggerExecute"]
--- whichTrigger number trigger
---@type fun(whichTrigger:number):void
J.TriggerExecuteWait = J.Common["TriggerExecuteWait"]
--- whichTrigger number trigger
--- whichWidget number widget
---@type fun(whichTrigger:number,whichWidget:number):any event
J.TriggerRegisterDeathEvent = J.Common["TriggerRegisterDeathEvent"]
--- whichTrigger number trigger
--- whichButton number button
---@type fun(whichTrigger:number,whichButton:number):any event
J.TriggerRegisterDialogButtonEvent = J.Common["TriggerRegisterDialogButtonEvent"]
--- whichTrigger number trigger
--- whichDialog number dialog
---@type fun(whichTrigger:number,whichDialog:number):any event
J.TriggerRegisterDialogEvent = J.Common["TriggerRegisterDialogEvent"]
--- whichTrigger number trigger
--- whichRegion number region
--- filter function boolexpr
---@type fun(whichTrigger:number,whichRegion:number,filter:function):any event
J.TriggerRegisterEnterRegion = J.Common["TriggerRegisterEnterRegion"]
--- whichTrigger number trigger
--- whichUnit number unit
--- whichEvent any unitevent
--- filter function boolexpr
---@type fun(whichTrigger:number,whichUnit:number,whichEvent:any,filter:function):any event
J.TriggerRegisterFilterUnitEvent = J.Common["TriggerRegisterFilterUnitEvent"]
--- whichTrigger number trigger
--- whichGameEvent any gameevent
---@type fun(whichTrigger:number,whichGameEvent:any):any event
J.TriggerRegisterGameEvent = J.Common["TriggerRegisterGameEvent"]
--- whichTrigger number trigger
--- whichState any gamestate
--- opcode any limitop
--- limitval number
---@type fun(whichTrigger:number,whichState:any,opcode:any,limitval:number):any event
J.TriggerRegisterGameStateEvent = J.Common["TriggerRegisterGameStateEvent"]
--- whichTrigger number trigger
--- whichRegion number region
--- filter function boolexpr
---@type fun(whichTrigger:number,whichRegion:number,filter:function):any event
J.TriggerRegisterLeaveRegion = J.Common["TriggerRegisterLeaveRegion"]
--- whichTrigger number trigger
--- whichPlayer number player
--- whichAlliance any alliancetype
---@type fun(whichTrigger:number,whichPlayer:number,whichAlliance:any):any event
J.TriggerRegisterPlayerAllianceChange = J.Common["TriggerRegisterPlayerAllianceChange"]
--- whichTrigger number trigger
--- whichPlayer number player
--- chatMessageToDetect string
--- exactMatchOnly boolean
---@type fun(whichTrigger:number,whichPlayer:number,chatMessageToDetect:string,exactMatchOnly:boolean):any event
J.TriggerRegisterPlayerChatEvent = J.Common["TriggerRegisterPlayerChatEvent"]
--- whichTrigger number trigger
--- whichPlayer number player
--- whichPlayerEvent any playerevent
---@type fun(whichTrigger:number,whichPlayer:number,whichPlayerEvent:any):any event
J.TriggerRegisterPlayerEvent = J.Common["TriggerRegisterPlayerEvent"]
--- whichTrigger number trigger
--- whichPlayer number player
--- whichState any playerstate
--- opcode any limitop
--- limitval number
---@type fun(whichTrigger:number,whichPlayer:number,whichState:any,opcode:any,limitval:number):any event
J.TriggerRegisterPlayerStateEvent = J.Common["TriggerRegisterPlayerStateEvent"]
--- whichTrigger number trigger
--- whichPlayer number player
--- whichPlayerUnitEvent any playerunitevent
--- filter function boolexpr
---@type fun(whichTrigger:number,whichPlayer:number,whichPlayerUnitEvent:any,filter:function):any event
J.TriggerRegisterPlayerUnitEvent = J.Common["TriggerRegisterPlayerUnitEvent"]
--- whichTrigger number trigger
--- timeout number
--- periodic boolean
---@type fun(whichTrigger:number,timeout:number,periodic:boolean):any event
J.TriggerRegisterTimerEvent = J.Common["TriggerRegisterTimerEvent"]
--- whichTrigger number trigger
--- t number timer
---@type fun(whichTrigger:number,t:number):any event
J.TriggerRegisterTimerExpireEvent = J.Common["TriggerRegisterTimerExpireEvent"]
--- whichTrigger number trigger
--- t any trackable
---@type fun(whichTrigger:number,t:any):any event
J.TriggerRegisterTrackableHitEvent = J.Common["TriggerRegisterTrackableHitEvent"]
--- whichTrigger number trigger
--- t any trackable
---@type fun(whichTrigger:number,t:any):any event
J.TriggerRegisterTrackableTrackEvent = J.Common["TriggerRegisterTrackableTrackEvent"]
--- whichTrigger number trigger
--- whichUnit number unit
--- whichEvent any unitevent
---@type fun(whichTrigger:number,whichUnit:number,whichEvent:any):any event
J.TriggerRegisterUnitEvent = J.Common["TriggerRegisterUnitEvent"]
--- whichTrigger number trigger
--- whichUnit number unit
--- range number
--- filter function boolexpr
---@type fun(whichTrigger:number,whichUnit:number,range:number,filter:function):any event
J.TriggerRegisterUnitInRange = J.Common["TriggerRegisterUnitInRange"]
--- whichTrigger number trigger
--- whichUnit number unit
--- whichState any unitstate
--- opcode any limitop
--- limitval number
---@type fun(whichTrigger:number,whichUnit:number,whichState:any,opcode:any,limitval:number):any event
J.TriggerRegisterUnitStateEvent = J.Common["TriggerRegisterUnitStateEvent"]
--- whichTrigger number trigger
--- varName string
--- opcode any limitop
--- limitval number
---@type fun(whichTrigger:number,varName:string,opcode:any,limitval:number):any event
J.TriggerRegisterVariableEvent = J.Common["TriggerRegisterVariableEvent"]
--- whichTrigger number trigger
--- whichAction function triggeraction
---@type fun(whichTrigger:number,whichAction:function):void
J.TriggerRemoveAction = J.Common["TriggerRemoveAction"]
--- whichTrigger number trigger
--- whichCondition function triggercondition
---@type fun(whichTrigger:number,whichCondition:function):void
J.TriggerRemoveCondition = J.Common["TriggerRemoveCondition"]
--- 等待(玩家时间)
--- 等待[Time]秒
--- 该延迟功能受真实时间的影响(也就是玩家机器上的时间). 因此每个玩家所延迟的时间可能不一致.
--- timeout number
---@type fun(timeout:number):void
J.TriggerSleepAction = J.Common["TriggerSleepAction"]
---@type fun():void
J.TriggerSyncReady = J.Common["TriggerSyncReady"]
---@type fun():void
J.TriggerSyncStart = J.Common["TriggerSyncStart"]
--- s number sound
--- offset number
---@type fun(s:number,offset:number):void
J.TriggerWaitForSound = J.Common["TriggerWaitForSound"]
--- whichTrigger number trigger
--- flag boolean
---@type fun(whichTrigger:number,flag:boolean):void
J.TriggerWaitOnSleeps = J.Common["TriggerWaitOnSleeps"]
--- 添加技能 [R]
--- 为[单位]添加[技能]
--- whichUnit number unit
--- abilityId number int
---@type fun(whichUnit:number,abilityId:number):boolean
J.UnitAddAbility = J.Common["UnitAddAbility"]
--- 闪动指示器(对单位) [R]
--- 对[单位]闪动指示器,使用颜色:([Red]%,[Green]%,[Blue]%) Alpha通道值:[Alpha]
--- 颜色格式为(红,绿,蓝). Alpha通道值0为不可见. 颜色值和Alpha通道值取值范围为0-255.
--- whichUnit number unit
--- red number int
--- green number int
--- blue number int
--- alpha number int
---@type fun(whichUnit:number,red:number,green:number,blue:number,alpha:number):void
J.UnitAddIndicator = J.Common["UnitAddIndicator"]
--- 给予物品 [R]
--- 给予[单位][物品]
--- whichUnit number unit
--- whichItem number item
---@type fun(whichUnit:number,whichItem:number):boolean
J.UnitAddItem = J.Common["UnitAddItem"]
--- whichUnit number unit
--- itemId number int
---@type fun(whichUnit:number,itemId:number):number item
J.UnitAddItemById = J.Common["UnitAddItemById"]
--- 新建物品到指定物品栏 [R]
--- 给予[单位][物品类型]并放在物品栏#[数值]
--- 注意: 物品栏编号从0-5,而不是1-6. 该动作创建的物品不被'最后创建的物品'所记录.
--- whichUnit number unit
--- itemId number int
--- itemSlot number int
---@type fun(whichUnit:number,itemId:number,itemSlot:number):boolean
J.UnitAddItemToSlotById = J.Common["UnitAddItemToSlotById"]
--- whichUnit number unit
--- add boolean
---@type fun(whichUnit:number,add:boolean):void
J.UnitAddSleep = J.Common["UnitAddSleep"]
--- 控制单位睡眠状态
--- 使[单位][Sleep/Remain Awake]
--- 使用该功能前必须用触发为单位添加'一直睡眠'技能.
--- whichUnit number unit
--- add boolean
---@type fun(whichUnit:number,add:boolean):void
J.UnitAddSleepPerm = J.Common["UnitAddSleepPerm"]
--- 添加类别 [R]
--- 为[单位]添加[Classification]类别
--- 已去除所有无效类别.
--- whichUnit number unit
--- whichUnitType any unittype
---@type fun(whichUnit:number,whichUnitType:any):boolean
J.UnitAddType = J.Common["UnitAddType"]
--- 设置生命周期 [R]
--- 为[单位]设置[Buff Type]类型的生命周期,持续时间为[Duration]秒
--- whichUnit number unit
--- buffId number int
--- duration number
---@type fun(whichUnit:number,buffId:number,duration:number):void
J.UnitApplyTimedLife = J.Common["UnitApplyTimedLife"]
--- whichUnit number unit
---@type fun(whichUnit:number):boolean
J.UnitCanSleep = J.Common["UnitCanSleep"]
--- whichUnit number unit
---@type fun(whichUnit:number):boolean
J.UnitCanSleepPerm = J.Common["UnitCanSleepPerm"]
--- whichUnit number unit
--- removePositive boolean
--- removeNegative boolean
--- magic boolean
--- physical boolean
--- timedLife boolean
--- aura boolean
--- autoDispel boolean
---@type fun(whichUnit:number,removePositive:boolean,removeNegative:boolean,magic:boolean,physical:boolean,timedLife:boolean,aura:boolean,autoDispel:boolean):number int
J.UnitCountBuffsEx = J.Common["UnitCountBuffsEx"]
--- 伤害区域 [R]
--- 命令[单位]在[Seconds]秒后对半径为[Size]圆心为([X],[Y])的范围造成[Amount]点伤害([是]攻击伤害,[是]远程攻击) 攻击类型:[AttackType]伤害类型:[DamageType]装甲类型:[WeaponType]
--- 该动作不会打断单位动作. 由该动作伤害/杀死单位同样正常触发'受到伤害'和'死亡'单位事件.
--- whichUnit number unit
--- delay number
--- radius number
--- x number
--- y number
--- amount number
--- attack boolean
--- ranged boolean
--- attackType any attacktype
--- damageType any damagetype
--- weaponType any weapontype
---@type fun(whichUnit:number,delay:number,radius:number,x:number,y:number,amount:number,attack:boolean,ranged:boolean,attackType:any,damageType:any,weaponType:any):boolean
J.UnitDamagePoint = J.Common["UnitDamagePoint"]
--- 伤害目标 [R]
--- 命令[单位]对[Target]造成[Amount]点伤害([是]攻击伤害,[是]远程攻击) 攻击类型:[AttackType]伤害类型:[DamageType]武器类型:[WeaponType]
--- 该动作不会打断单位动作. 由该动作伤害/杀死单位同样正常触发'受到伤害'和'死亡'单位事件.
--- whichUnit number unit
--- target number widget
--- amount number
--- attack boolean
--- ranged boolean
--- attackType any attacktype
--- damageType any damagetype
--- weaponType any weapontype
---@type fun(whichUnit:number,target:number,amount:number,attack:boolean,ranged:boolean,attackType:any,damageType:any,weaponType:any):boolean
J.UnitDamageTarget = J.Common["UnitDamageTarget"]
--- 发布丢弃物品命令(指定坐标) [R]
--- 命令[单位]丢弃物品[物品]到坐标:([X],[Y])
--- whichUnit number unit
--- whichItem number item
--- x number
--- y number
---@type fun(whichUnit:number,whichItem:number,x:number,y:number):boolean
J.UnitDropItemPoint = J.Common["UnitDropItemPoint"]
--- 移动物品到物品栏 [R]
--- 命令[单位]移动[物品]到物品栏#[Index]
--- 只有当单位持有该物品时才有效. 注意: 该函数中物品栏编号从0-5,而不是1-6.
--- whichUnit number unit
--- whichItem number item
--- slot number int
---@type fun(whichUnit:number,whichItem:number,slot:number):boolean
J.UnitDropItemSlot = J.Common["UnitDropItemSlot"]
--- 发布给予物品命令
--- 命令[单位]把[物品]给[单位]
--- whichUnit number unit
--- whichItem number item
--- target number widget
---@type fun(whichUnit:number,whichItem:number,target:number):boolean
J.UnitDropItemTarget = J.Common["UnitDropItemTarget"]
--- whichUnit number unit
--- removePositive boolean
--- removeNegative boolean
--- magic boolean
--- physical boolean
--- timedLife boolean
--- aura boolean
--- autoDispel boolean
---@type fun(whichUnit:number,removePositive:boolean,removeNegative:boolean,magic:boolean,physical:boolean,timedLife:boolean,aura:boolean,autoDispel:boolean):boolean
J.UnitHasBuffsEx = J.Common["UnitHasBuffsEx"]
--- whichUnit number unit
--- whichItem number item
---@type fun(whichUnit:number,whichItem:number):boolean
J.UnitHasItem = J.Common["UnitHasItem"]
--- unitIdString string
---@type fun(unitIdString:string):number int
J.UnitId = J.Common["UnitId"]
--- unitId number int
---@type fun(unitId:number):string
J.UnitId2String = J.Common["UnitId2String"]
--- whichUnit number unit
--- flag boolean
---@type fun(whichUnit:number,flag:boolean):boolean
J.UnitIgnoreAlarm = J.Common["UnitIgnoreAlarm"]
--- whichUnit number unit
---@type fun(whichUnit:number):boolean
J.UnitIgnoreAlarmToggled = J.Common["UnitIgnoreAlarmToggled"]
--- whichUnit number unit
---@type fun(whichUnit:number):number int
J.UnitInventorySize = J.Common["UnitInventorySize"]
--- whichUnit number unit
---@type fun(whichUnit:number):boolean
J.UnitIsSleeping = J.Common["UnitIsSleeping"]
--- whichUnit number unit
--- itemSlot number int
---@type fun(whichUnit:number,itemSlot:number):number item
J.UnitItemInSlot = J.Common["UnitItemInSlot"]
--- 设置技能永久性 [R]
--- 设置[单位][是否][技能]永久性
--- 如触发添加给单位的技能就是非永久性的,非永久性技能在变身并回复之后会丢失掉. 这类情况就需要设置技能永久性.
--- whichUnit number unit
--- permanent boolean
--- abilityId number int
---@type fun(whichUnit:number,permanent:boolean,abilityId:number):boolean
J.UnitMakeAbilityPermanent = J.Common["UnitMakeAbilityPermanent"]
--- 添加剩余技能点 [R]
--- 增加[英雄][Value]点剩余技能点
--- whichHero number unit
--- skillPointDelta number int
---@type fun(whichHero:number,skillPointDelta:number):boolean
J.UnitModifySkillPoints = J.Common["UnitModifySkillPoints"]
--- 暂停/恢复生命周期 [R]
--- 使[单位][Pause/Unpause]生命周期
--- 只有召唤单位有生命周期.
--- whichUnit number unit
--- flag boolean
---@type fun(whichUnit:number,flag:boolean):void
J.UnitPauseTimedLife = J.Common["UnitPauseTimedLife"]
--- 添加单位类型 [R]
--- 在[单位池]中添加一个[单位]比重为[数值]
--- 比重越高被选择的机率越大
--- whichPool number unitpool
--- unitId number int
--- weight number
---@type fun(whichPool:number,unitId:number,weight:number):void
J.UnitPoolAddUnitType = J.Common["UnitPoolAddUnitType"]
--- 删除单位类型 [R]
--- 从[单位池]中删除[单位]
--- whichPool number unitpool
--- unitId number int
---@type fun(whichPool:number,unitId:number):void
J.UnitPoolRemoveUnitType = J.Common["UnitPoolRemoveUnitType"]
--- 删除技能 [R]
--- 为[单位]删除[技能]
--- whichUnit number unit
--- abilityId number int
---@type fun(whichUnit:number,abilityId:number):boolean
J.UnitRemoveAbility = J.Common["UnitRemoveAbility"]
--- 删除魔法效果(指定极性) [R]
--- 删除[单位]的附带Buff,([Include/Exclude]正面Buff,[Include/Exclude]负面Buff)
--- whichUnit number unit
--- removePositive boolean
--- removeNegative boolean
---@type fun(whichUnit:number,removePositive:boolean,removeNegative:boolean):void
J.UnitRemoveBuffs = J.Common["UnitRemoveBuffs"]
--- 删除魔法效果(详细类别) [R]
--- 删除[单位]的附带Buff,([Include/Exclude]正面Buff,[Include/Exclude]负面Buff[Include/Exclude]魔法Buff,[Include/Exclude]物理Buff[Include/Exclude]生命周期,[Include/Exclude]光环效果[Include/Exclude]不可驱散Buff)
--- whichUnit number unit
--- removePositive boolean
--- removeNegative boolean
--- magic boolean
--- physical boolean
--- timedLife boolean
--- aura boolean
--- autoDispel boolean
---@type fun(whichUnit:number,removePositive:boolean,removeNegative:boolean,magic:boolean,physical:boolean,timedLife:boolean,aura:boolean,autoDispel:boolean):void
J.UnitRemoveBuffsEx = J.Common["UnitRemoveBuffsEx"]
--- whichUnit number unit
--- whichItem number item
---@type fun(whichUnit:number,whichItem:number):void
J.UnitRemoveItem = J.Common["UnitRemoveItem"]
--- whichUnit number unit
--- itemSlot number int
---@type fun(whichUnit:number,itemSlot:number):number item
J.UnitRemoveItemFromSlot = J.Common["UnitRemoveItemFromSlot"]
--- 删除类别 [R]
--- 为[单位]删除[Classification]类别
--- 已去除所有无效类别.
--- whichUnit number unit
--- whichUnitType any unittype
---@type fun(whichUnit:number,whichUnitType:any):boolean
J.UnitRemoveType = J.Common["UnitRemoveType"]
--- 重置技能CD
--- 重置[单位]的所有技能冷却时间
--- 如果要重置单一技能的CD,可以通过删除技能+添加技能+设置技能等级来完成.
--- whichUnit number unit
---@type fun(whichUnit:number):void
J.UnitResetCooldown = J.Common["UnitResetCooldown"]
--- 设置建筑建造进度条
--- 设置[某个建筑]的建造进度条为[Progress]%
--- 只作用于正在建造的建筑.
--- whichUnit number unit
--- constructionPercentage number int
---@type fun(whichUnit:number,constructionPercentage:number):void
J.UnitSetConstructionProgress = J.Common["UnitSetConstructionProgress"]
--- 设置建筑升级进度条
--- 设置[某个建筑]的升级进度条为[Progress]%
--- 只作用于正在升级的建筑. 是建筑A升级为建筑B的升级,不是科技的研究.
--- whichUnit number unit
--- upgradePercentage number int
---@type fun(whichUnit:number,upgradePercentage:number):void
J.UnitSetUpgradeProgress = J.Common["UnitSetUpgradeProgress"]
--- 开启/关闭 小地图特殊标志
--- [On/Off][单位]的小地图特殊标志
--- 使用'中立建筑 - 设置小地图特殊标志'动作来设置显示的标志. 默认为中立建筑标志.
--- whichUnit number unit
--- flag boolean
---@type fun(whichUnit:number,flag:boolean):void
J.UnitSetUsesAltIcon = J.Common["UnitSetUsesAltIcon"]
--- 共享视野 [R]
--- 设置[单位]的视野对[某个玩家][on/off]
--- whichUnit number unit
--- whichPlayer number player
--- share boolean
---@type fun(whichUnit:number,whichPlayer:number,share:boolean):void
J.UnitShareVision = J.Common["UnitShareVision"]
--- 降低等级 [R]
--- 降低[某个英雄][Level]个等级
--- 只能降低等级. 英雄经验将重置为该等级的初始值.
--- whichHero number unit
--- howManyLevels number int
---@type fun(whichHero:number,howManyLevels:number):boolean
J.UnitStripHeroLevel = J.Common["UnitStripHeroLevel"]
--- 暂停尸体腐烂 [R]
--- 设置[单位]的尸体腐烂状态:[Suspend/Resume]
--- 只对已完成死亡动作的尸体有效.
--- whichUnit number unit
--- suspend boolean
---@type fun(whichUnit:number,suspend:boolean):void
J.UnitSuspendDecay = J.Common["UnitSuspendDecay"]
--- 使用物品(无目标)
--- 命令[单位]使用[物品]
--- whichUnit number unit
--- whichItem number item
---@type fun(whichUnit:number,whichItem:number):boolean
J.UnitUseItem = J.Common["UnitUseItem"]
--- 使用物品(指定坐标)
--- 命令[单位]使用[物品],目标坐标:([X],[Y])
--- whichUnit number unit
--- whichItem number item
--- x number
--- y number
---@type fun(whichUnit:number,whichItem:number,x:number,y:number):boolean
J.UnitUseItemPoint = J.Common["UnitUseItemPoint"]
--- 使用物品(对单位)
--- 命令[单位]使用[物品],目标:[单位]
--- whichUnit number unit
--- whichItem number item
--- target number widget
---@type fun(whichUnit:number,whichItem:number,target:number):boolean
J.UnitUseItemTarget = J.Common["UnitUseItemTarget"]
--- 叫醒
--- 叫醒[单位]
--- 不影响催眠魔法效果.
--- whichUnit number unit
---@type fun(whichUnit:number):void
J.UnitWakeUp = J.Common["UnitWakeUp"]
--- soundHandle number sound
--- byPosition boolean
--- rectwidth number
--- rectheight number
---@type fun(soundHandle:number,byPosition:boolean,rectwidth:number,rectheight:number):void
J.UnregisterStackedSound = J.Common["UnregisterStackedSound"]
--- whichVersion any version
---@type fun(whichVersion:any):boolean
J.VersionCompatible = J.Common["VersionCompatible"]
---@type fun():any version
J.VersionGet = J.Common["VersionGet"]
--- whichVersion any version
---@type fun(whichVersion:any):boolean
J.VersionSupported = J.Common["VersionSupported"]
--- 重置多通道音量
--- 重置所有通道音量为预设值.
---@type fun():void
J.VolumeGroupReset = J.Common["VolumeGroupReset"]
--- 设置多通道音量 [R]
--- 设置[Volume Channel]的音量为[Volume]
--- 音量取值范围0-1.
--- vgroup any volumegroup
--- scale number
---@type fun(vgroup:any,scale:number):void
J.VolumeGroupSetVolume = J.Common["VolumeGroupSetVolume"]
--- 启用/禁用 传送门
--- [Enable/Disable][传送门]
--- waygate number unit
--- activate boolean
---@type fun(waygate:number,activate:boolean):void
J.WaygateActivate = J.Common["WaygateActivate"]
--- waygate number unit
---@type fun(waygate:number):number
J.WaygateGetDestinationX = J.Common["WaygateGetDestinationX"]
--- waygate number unit
---@type fun(waygate:number):number
J.WaygateGetDestinationY = J.Common["WaygateGetDestinationY"]
--- waygate number unit
---@type fun(waygate:number):boolean
J.WaygateIsActive = J.Common["WaygateIsActive"]
--- 设置传送门目的坐标 [R]
--- 设置[传送门]的目的地为([X],[Y])
--- waygate number unit
--- x number
--- y number
---@type fun(waygate:number,x:number,y:number):void
J.WaygateSetDestination = J.Common["WaygateSetDestination"]

math.sin = J.Common["Sin"]
math.cos = J.Common["Cos"]
math.tan = J.Common["Tan"]
math.asin = J.Common["Asin"]
math.acos = J.Common["Acos"]
math.atan = J.Common["Atan2"]

if (nil ~= J.Common) then
    math.random = nil
end

local cc = { c = {}, i = {} }

--- 字符ID转整型ID
---@type fun(idChar:string):number
J.C2I = function(idChar)
    must(type(idChar) == "string", "idChar@string")
    local id = cc.c[idChar]
    if (nil == id) then
        id = ('>I4'):unpack(idChar)
        cc.c[idChar] = id
        cc.i[id] = idChar
    end
    return id
end

--- 整型ID转字符ID
---@type fun(id:number):string
J.I2C = function(id)
    must(type(id) == "number", "id@number")
    local ic = cc.i[id]
    if (nil == ic) then
        ic = ('>I4'):pack(id)
        cc.i[id] = ic
        cc.c[ic] = id
    end
    return ic
end