local process = Process("test")

function process:onStart()
    
    print("Hello, XLIK!")
    echo("你好，XLIK！")
    
    --- bgm 播放
    sound.bgm("xlik")
    time.setTimeout(20, function()
        sound.bgm("ArthasTheme")
    end)
    
    --- 双英对打
    local bubble = self:bubble()
    bubble.eff = effector.agile("Echo", 0, 0, 0)
    effector.rotateZ(bubble.eff, 270)
    bubble.unit = Unit(Player(1), TPL_UNIT.DEMO, 0, -100, 270)
    bubble.unit2 = Unit(Player(2), TPL_UNIT.DEMO2, 0, -100, 270)

end

function process:onOver()
    sound.bgmStop()
    effector.destroy(bubble.eff)
end
