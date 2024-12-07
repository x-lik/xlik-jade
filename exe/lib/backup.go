package cmd

import (
	"github.com/duke-git/lancet/v2/fileutil"
	"github.com/pterm/pterm"
	"os"
)

func (app *App) Backup() {
	// 生成备份w3x目录
	tempDir := app.Path.Temp + "/" + app.ProjectName
	w3xDir := app.Path.Projects + "/" + app.ProjectName + "/w3x/map"
	if GetModTime(tempDir+"/map") > GetModTime(w3xDir) {
		_ = os.RemoveAll(w3xDir)
		CopyPath(tempDir+"/map", w3xDir)
		pterm.Info.Println("备份完成[.tmp(地图备份)->w3x/map]")
	}
	war3mapMap := app.Path.Projects + "/" + app.ProjectName + "/w3x/war3mapMap.blp"
	if !fileutil.IsExist(war3mapMap) {
		CopyFile("embeds/lni/war3mapMap.blp", war3mapMap)
		pterm.Info.Println("修正备份[lni(war3mapMap)->w3x/war3mapMap]")
	}
	if GetModTime(tempDir+"/resource/war3mapMap.blp") > GetModTime(war3mapMap) {
		_ = os.Remove(war3mapMap)
		CopyFile(tempDir+"/resource/war3mapMap.blp", war3mapMap)
		pterm.Info.Println("更新同步[.tmp(war3mapMap)->w3x/war3mapMap]")
	}
	tableDir := app.Path.Projects + "/" + app.ProjectName + "/w3x/table"
	if GetModTime(tempDir+"/table") > GetModTime(tableDir) {
		_ = os.RemoveAll(tableDir)
		CopyPath(tempDir+"/table", tableDir)
		pterm.Success.Println("同步完成[.tmp(原生物编)->w3x/table]")
	}
}
