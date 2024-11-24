--- 任务
Quest("主动投降")
    :setSide("r")
    :setIcon("ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp")
    :setContent("-gg 投降并退出")

Quest("查看你的APM数值")
    :setSide("r")
    :setIcon("ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp")
    :setContent("-apm 查看你的APM数值")

Quest("调整你的视距")
    :setSide("r")
    :setIcon("ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp")
    :setContent({ "-d +[number] 增加视距", "-d -[number] 减少视距", "-d =[number] 设置视距" })