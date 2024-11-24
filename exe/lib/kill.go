package cmd

import (
	"github.com/pterm/pterm"
	"os/exec"
	"path/filepath"
)

func (app *App) Kill() {
	bat, err := filepath.Abs(app.Path.WE + "/bin/kill.bat")
	if err != nil {
		Panic(err)
	}
	cmd := exec.Command(bat)
	err = cmd.Run()
	if err != nil {
		Panic(err)
	}
	pterm.Info.Println("已尝试关闭所有魔兽客户端")
}
