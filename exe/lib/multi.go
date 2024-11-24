package cmd

import (
	"github.com/pterm/pterm"
	"os"
	"os/exec"
	"strconv"
	"time"
)

func (app *App) runMulti(max int, cur int) {
	for i := cur; i <= max; i++ {
		cmd := exec.Command(app.Path.WE+"/bin/WEConfig.exe", "-launchwar3")
		_, _ = cmd.Output()
		pterm.Debug.Println("第" + strconv.Itoa(i) + "个魔兽尝试启动中")
	}
	ticker := time.NewTicker(time.Second)
	pterm.Debug.Println(<-ticker.C)
	exes := []string{"war3.exe"}
	cur = ExeRunningQty(exes)
	if cur >= max {
		pterm.Info.Println("测试地图一般存放在 " + app.Path.War3 + "\\Maps\\Test\\WorldEditTestMap.w3x ")
	} else {
		pterm.Warning.Println("部分启动失败，1秒后重试")
		time.Sleep(time.Second)
		app.runMulti(max, cur+1)
	}
}

func (app *App) Multi() {
	m := 2
	if len(os.Args) == 3 {
		m, _ = strconv.Atoi(os.Args[2])
	}
	if m > 9 {
		m = 9
		pterm.Warning.Println("最大只支持9个客户端同时开启")
	}
	app.runMulti(m, 1)
}
