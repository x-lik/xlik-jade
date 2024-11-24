package main

import (
	"github.com/pterm/pterm"
	"xlik/lib"
)

func init() {
	pterm.EnableDebugMessages()
	pterm.Debug.Prefix.Text = "调整"
	pterm.Info.Prefix.Text = "提示"
	pterm.Success.Prefix.Text = "完成"
	pterm.Warning.Prefix.Text = "警告"
	pterm.Error.Prefix.Text = "错误"
}

func main() {
	// 构造应用
	pterm.Debug.Println("xlik璞玉版，自由搭建属于你的游戏系统！先来试试删除这句提示吧~")
	pterm.Debug.Println("Jade xlik, free to build your own framework! Try deleting this prompt first~")
	app := cmd.NewApp()
	app.Init()
	if len(app.Args) < 2 {
		pterm.Error.Println("无效操作！")
		return
	}
	switch app.Args[1] {
	case "new":
		app.New()
	case "we":
		app.WE()
	case "model":
		app.Model()
	case "clear":
		app.Clear()
	case "run":
		app.Run()
	case "multi":
		app.Multi()
	case "kill":
		app.Kill()
	case "help":
		app.Help()
	default:
		pterm.Warning.Println("命令: `" + app.Args[1] + "` 不存在!")
		app.Help()
	}
}
