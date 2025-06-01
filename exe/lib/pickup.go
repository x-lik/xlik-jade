package cmd

import (
	"github.com/duke-git/lancet/v2/fileutil"
	"github.com/pterm/pterm"
	"io/fs"
	"os"
)

func (app *App) Pickup() {
	tempDir := app.Path.Temp + "/" + app.ProjectName
	w3xDir := app.Path.Projects + "/" + app.ProjectName + "/w3x"
	// 构建项目目录
	check := fileutil.IsDir(w3xDir + "/table")
	if !check {
		_ = os.Mkdir(w3xDir+"/table", fs.ModePerm)
	}
	// 检查是否存在temp
	if fileutil.IsDir(tempDir) == false {
		// 没有则构建新的temp
		CopyDir(w3xDir+"/map", tempDir+"/map")
		pterm.Debug.Println("构建临时区[w3x(map)->map]")
		CopyDir(w3xDir+"/table", tempDir+"/table")
		pterm.Debug.Println("构建临时区[w3x(table)->table]")
		CopyDir("embeds/lni/w3x2lni", tempDir+"/w3x2lni")
		pterm.Debug.Println("构建临时区[lni(w3x2lni)->w3x2lni]")
		CopyFile("embeds/lni/x.w3x", tempDir+"/.w3x")
		pterm.Debug.Println("构建临时区[lni(.w3x)->.w3x]")
	}
	// map
	_ = os.RemoveAll(tempDir + "/map/")
	CopyDir(w3xDir+"/map", tempDir+"/map")
	_ = os.Remove(tempDir + "/map/war3mapMap.blp")
	pterm.Info.Println("覆盖同步[w3x(map)->map]")
	// 物编ini判定
	if FileGetModTime(w3xDir+"/table") > FileGetModTime(tempDir+"/table") {
		_ = os.RemoveAll(tempDir + "/table")
		CopyDir(w3xDir+"/table", tempDir+"/table")
		pterm.Info.Println("更新同步[w3x(table)->table]")
	}
	// 资源判定
	_ = os.RemoveAll(tempDir + "/resource")
	CopyDir("embeds/lni/resource", tempDir+"/resource")
	pterm.Info.Println("覆盖同步[lni(resource)->resource]")
	if fileutil.IsDir(w3xDir + "/resource") {
		CopyDir(w3xDir+"/resource", tempDir+"/resource")
		pterm.Info.Println("额外资源[w3x(resource)->resource]")
	}
	// 小地图判定
	if FileGetModTime(w3xDir+"/war3mapMap.blp") > FileGetModTime(tempDir+"/resource/war3mapMap.blp") {
		_ = os.Remove(tempDir + "/resource/war3mapMap.blp")
		CopyFile(w3xDir+"/war3mapMap.blp", tempDir+"/resource/war3mapMap.blp")
		pterm.Info.Println("更新同步[w3x(war3mapMap)->resource/war3mapMap]")
	}
}
