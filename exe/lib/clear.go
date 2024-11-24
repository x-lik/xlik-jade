package cmd

import (
	"github.com/pterm/pterm"
	"os"
)

func (app *App) Clear() {
	_ = os.Remove(app.Path.War3 + "/dz_w3_plugin.ini")
	pterm.Success.Println(`清理魔兽存档完毕`)
	_ = os.RemoveAll(app.Path.Temp)
	pterm.Success.Println(`清理临时区完毕`)
}
