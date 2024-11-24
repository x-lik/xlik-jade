---@alias slkUnitData {_id_force,_class,_parent,_xlik,model,Name,Description,Tip,Ubertip,Hotkey,level,race,type,goldcost,lumbercost,manaN,regenMana,mana0,HP,regenHP,regenType,fmade,fused,stockStart,stockRegen,stockMax,sight,nsight,collision,modelScale,file,fileVerFlags,scaleBull,scale,selZ,selCircOnWater,red,green,blue,occH,maxPitch,maxRoll,impactZ,impactSwimZ,launchX,launchY,launchZ,launchSwimZ,unitSound,RandomSoundLabel,MovementSoundLabel,LoopingSoundFadeOut,LoopingSoundFadeIn,auto,abilList,Sellitems,Sellunits,Markitems,Builds,Buttonpos_1,Buttonpos_2,Art,Specialart,unitShadow,buildingShadow,shadowH,shadowW,shadowX,shadowY,shadowOnWater,death,deathType,movetp,moveHeight,moveFloor,spd,maxSpd,minSpd,turnRate,acquire,minRange,weapsOn,Missileart_1,Missilespeed_1,Missilearc_1,MissileHoming_1,targs1,atkType1,weapTp1,weapType1,spillRadius1,spillDist1,damageLoss1,showUI1,backSw1,dmgpt1,rangeN1,RngBuff1,dmgplus1,dmgUp1,sides1,dice1,splashTargs1,cool1,Farea1,targCount1,Qfact1,Qarea1,Hfact1,Harea1,Missileart_2,Missilespeed_2,Missilearc_2,MissileHoming_2,targs2,atkType2,weapTp2,weapType2,spillRadius2,spillDist2,damageLoss2,showUI2,backSw2,dmgpt2,rangeN2,RngBuff2,dmgplus2,dmgUp2,sides2,dice2,splashTargs2,cool2,Farea2,targCount2,Qfact2,Qarea2,Hfact2,Harea2,defType,defUp,def,armor,targType,Propernames,nameCount,Awakentip,Revivetip,Primary,STR,STRplus,AGI,AGIplus,INT,INTplus,heroAbilList,hideHeroMinimap,hideHeroBar,hideHeroDeathMsg,Requiresacount,Requires1,Requires2,Requires3,Requires4,Requires5,Requires6,Requires7,Requires8,Reviveat,buffRadius,buffType,Revive,Trains,Upgrade,requirePlace,preventPlace,requireWaterRadius,pathTex,uberSplat,nbrandom,nbmmlcon,canBuildOn,isBuildOn,tilesets,special,campaign,inEditor,dropItems,hostilePal,useClickHelper,tilesetSpecific,Requires,Requiresamount,DependencyOr,Researches,upgrades,EditorSuffix,Casterupgradename,Casterupgradetip,Castrerupgradeart,ScoreScreenIcon,animProps,Attachmentanimprops,Attachmentlinkprops,Boneprops,castpt,castbsw,blend,run,walk,propWin,orientInterp,teamColor,customTeamColor,elevPts,elevRad,fogRad,fatLOS,repulse,repulsePrio,repulseParam,repulseGroup,isbldg,bldtm,bountyplus,bountysides,bountydice,goldRep,lumberRep,reptm,lumberbountyplus,lumberbountysides,lumberbountydice,cargoSize,hideOnMinimap,points,prio,formation,canFlee,canSleep}
---@param _v slkUnitData
---@return {_id:string}
function slk_unit(_v)
    _v._class = "unit"
    if (nil == _v._parent) then
        _v._parent = "hpea"
    end
    LK_SETTING(_v)
end

---@alias slkItemData {_id_force,_class,_parent,abilList,Requires,Requiresamount,Name,Description,Tip,Ubertip,Hotkey,Art,scale,file,Buttonpos_1,Buttonpos_2,selSize,colorR,colorG,colorB,armor,Level,oldLevel,class,goldcost,lumbercost,HP,stockStart,stockRegen,stockMax,prio,cooldownID,ignoreCD,morph,drop,powerup,sellable,pawnable,droppable,pickRandom,uses,perishable,usable}
---@param _v slkItemData
---@return {_id:string}
function slk_item(_v)
    _v._class = "item"
    if (nil == _v._parent) then
        _v._parent = "rat9"
    end
    LK_SETTING(_v)
end

---@alias slkAbilityData {_id_force,_class,_parent,checkDep,Requires,Requiresamount,Effectsound,Effectsoundlooped,EditorSuffix,Name,Untip,Unubertip,Tip,Ubertip,Researchtip,Researchubertip,Unorder,Orderon,Order,Orderoff,Unhotkey,Hotkey,Researchhotkey,UnButtonpos_1,UnButtonpos_2,Buttonpos_1,Buttonpos_2,Researchbuttonpos1,Researchbuttonpos2,Unart,Researchart,Art,SpecialArt,Specialattach,Missileart_1,Missilespeed_1,Missilearc_1,MissileHoming_1,LightningEffect,EffectArt,TargetArt,Targetattachcount,Targetattach,Targetattach1,Targetattach2,Targetattach3,Targetattach4,Targetattach5,Areaeffectart,Animnames,CasterArt,Casterattachcount,Casterattach,Casterattach1,hero,item,race,levels,reqLevel,priority,BuffID,EfctID,Tip,Ubertip,targs,DataA,DataB,DataC,DataD,DataE,DataF,Cast,Cool,Dur,HeroDur,Cost,Rng,Area}
---@param _v slkAbilityData
---@return {_id:string}
function slk_ability(_v)
    _v._class = "ability"
    if (nil == _v._parent) then
        _v._parent = "ANcl"
    end
    LK_SETTING(_v)
end

---@alias slkDestructableData {_id_force,_class,_parent,EditorSuffix,HP,InBeta,MMBlue,MMGreen,MMRed,Name,armor,buildTime,canPlaceDead,canPlaceRandScale,category,cliffHeight,code,colorB,colorG,colorR,comment,deathSnd,doodClass,fatLOS,file,fixedRot,flyH,fogRadius,fogVis,goldRep,lightweight,lumberRep,maxPitch,maxRoll,maxScale,minScale,numVar,occH,onCliffs,onWater,pathTex,pathTexDeath,portraitmodel,radius,repairTime,selSize,selcircsize,selectable,shadow,showInMM,targType,texFile,texID,tilesetSpecific,tilesets,useClickHelper,useMMColor,version,walkable}
---@param _v slkDestructableData
---@return {_id:string}
function slk_destructable(_v)
    _v._class = "destructable"
    if (nil == _v._parent) then
        _v._parent = "BTsc"
    end
    LK_SETTING(_v)
end

---@alias slkDoodadData {_id_force,_class,_parent,InBeta,MMBlue,MMGreen,MMRed,Name,animInFog,canPlaceRandScale,category,code,comment,defScale,doodClass,file,fixedRot,floats,ignoreModelClick,maxPitch,maxRoll,maxScale,minScale,numVar,onCliffs,onWater,pathTex,selSize,shadow,showInFog,showInMM,soundLoop,tilesetSpecific,tilesets,useClickHelper,useMMColor,version,vertB01,vertB02,vertB03,vertB04,vertB05,vertB06,vertB07,vertB08,vertB09,vertB10,vertG01,vertG02,vertG03,vertG04,vertG05,vertG06,vertG07,vertG08,vertG09,vertG10,vertR01,vertR02,vertR03,vertR04,vertR05,vertR06,vertR07,vertR08,vertR09,vertR10,visRadius,walkable}
---@param _v slkDoodadData
---@return {_id:string}
function slk_doodad(_v)
    _v._class = "doodad"
    if (nil == _v._parent) then
        _v._parent = "AOgs"
    end
    LK_SETTING(_v)
end

---@alias slkBuffData {_id_force,_class,_parent,Effectsound,Effectsoundlooped,EditorSuffix,EditorName,Bufftip,Buffubertip,Buffart,SpecialArt,Specialattach,Missileart_1,Missilespeed_1,EffectArt,Effectattach,TargetArt,Targetattachcount,Targetattach,Targetattach1,Targetattach2,Targetattach3,Targetattach4,Targetattach5,LightningEffect,Missilearc_1,MissileHoming_1,Spelldetail,isEffect,race}
---@param _v slkBuffData
---@return {_id:string}
function slk_buff(_v)
    _v._class = "buff"
    if (nil == _v._parent) then
        _v._parent = "BHbd"
    end
    LK_SETTING(_v)
end

---@alias slkUpgradeData {_id_force,_class,_parent,Requires,Requiresamount,effect,EditorSuffix,Name,Hotkey,Tip,Ubertip,Buttonpos_1,Buttonpos_2,Art,maxlevel,race,goldbase,lumberbase,timebase,goldmod,lumbermod,timemod,class,inherit,global}
---@param _v slkUpgradeData
---@return {_id:string}
function slk_upgrade(_v)
    _v._class = "upgrade"
    if (nil == _v._parent) then
        _v._parent = "Rhme"
    end
    LK_SETTING(_v)
end