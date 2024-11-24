---@param getData eventOnItemGet
TPL_ITEM.DEMO = ItemTpl()
    --:model("???") -- 默认就是物品宝箱
    :name("勇气之剑")
    :description("就是一把剑")
    :bindAbilityTpl(TPL_ABILITY.DEMO)
    :icon("ReplaceableTextures\\CommandButtons\\BTNArcaniteMelee.blp")
    :worth({ gold = 10 })
    :onEvent(eventKind.itemGet,
    function(getData)
        echo(getData.triggerUnit:name() .. " 获得物品 " .. getData.triggerItem:name())
    end)