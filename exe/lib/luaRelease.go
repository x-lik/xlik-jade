package cmd

import (
	"github.com/duke-git/lancet/v2/fileutil"
	"github.com/pterm/pterm"
	"os"
	"strings"
)

func (app *App) luaRelease() string {
	if app.BuildModeName != "_release" {
		Panic("luaRelease")
	}
	// check dist
	spinner, _ := pterm.DefaultSpinner.Start("检测dist阶段结果正确性...")
	localPath := app.Path.Temp + "/_local/" + app.ProjectName
	buildPath := app.Path.Temp + "/_build/" + app.ProjectName
	distPath := app.Path.Temp + "/_dist/" + app.ProjectName
	localMod := GetModTime(localPath)
	buildMod := GetModTime(buildPath)
	distMod := GetModTime(distPath)
	if buildMod > distMod {
		pterm.Warning.Println("【上线】检测到dist阶段数据或比build阶段数据旧，为确保新代码被打包，建议重新进行dist阶段测试")
	}
	if localMod > distMod {
		pterm.Warning.Println("【上线】检测到dist阶段数据或比local阶段数据旧，为确保新代码被打包，建议重新进行dist阶段测试")
	}
	if !fileutil.IsDir(distPath) {
		spinner.Fail("【上线】检测到dist阶段数据丢失，须先完成dist阶段测试")
		os.Exit(0)
	}
	// clone dist
	_ = os.RemoveAll(app.BuildDstPath)
	CopyPath(distPath, app.BuildDstPath)
	// check connect、release
	connectFile := app.BuildDstPath + "/map/.connect"
	if !fileutil.IsExist(connectFile) {
		spinner.Fail("【上线】检测到dist阶段测试结果错误关联，须重新进行dist阶段测试")
		os.Exit(0)
	}
	// replace
	connectStr, err := fileutil.ReadFileToString(connectFile)
	if err != nil {
		Panic(err)
	}
	_ = os.Remove(connectFile)
	connect := strings.Split(connectStr, "|")
	distFile := app.BuildDstPath + "/map/" + connect[1] + ".lua"
	releaseFile := app.BuildDstPath + "/map/" + connect[2] + ".lua"
	if !fileutil.IsExist(distFile) || !fileutil.IsExist(releaseFile) {
		spinner.Fail("【上线】检测到dist阶段测试结果严重偏离，须重新进行dist阶段测试")
		os.Exit(0)
	}
	spinner.Info("【上线】dist阶段测试结果符合打包预期")
	releaseCode, err2 := fileutil.ReadFileToString(releaseFile)
	if err2 != nil {
		Panic(err2)
	}
	_ = os.Remove(releaseFile)
	err = fileutil.WriteStringToFile(distFile, releaseCode, false)
	if err != nil {
		Panic(err)
	}
	_ = os.Remove(app.BuildDstPath + "/pack.w3x")
	pterm.Debug.Println("【上线】dist调试已关闭")
	pterm.Success.Println("【上线】release处理已完成")
	return connect[0]
}
