package cmd

import (
	"github.com/duke-git/lancet/v2/fileutil"
	"github.com/pterm/pterm"
	"io/fs"
	"os"
)

// New 新建项目
func (app *App) New() {
	if app.ProjectName == "" {
		Panic("不允许存在空名称项目")
	}
	if app.ProjectName[:1] == "_" {
		Panic("项目名不合法(下划线“_”开始的名称已被禁用)")
	}
	if app.isExistPr() {
		Panic("已存在同名项目，你可以输入“run " + app.ProjectName + "”命令直接测试，或者请使用其他名称")
	}
	var err error
	// 如果没有 projects 目录则生成一个
	check := fileutil.IsDir(app.Path.Projects)
	if !check {
		err = os.Mkdir(app.Path.Projects, fs.ModePerm)
		if err != nil {
			Panic(err)
		}
	}
	// 生成项目目录
	projectDir := app.Path.Projects + "/" + app.ProjectName
	err = os.Mkdir(projectDir, fs.ModePerm)
	// 复制初始文件
	CopyPath("embeds/lni/map", projectDir+"/w3x/map")
	CopyPath("embeds/lni/table", projectDir+"/w3x/table")
	CopyFile("embeds/lni/war3mapMap.blp", projectDir+"/w3x/war3mapMap.blp")
	// 复制初始脚本
	CopyPath("embeds/new", projectDir)
	// 生成备份w3x目录
	app.Backup()
	pterm.Success.Println("项目创建完成！")
	pterm.Info.Println("你可以输入“we " + app.ProjectName + "”编辑地图信息")
	pterm.Info.Println("或可以输入“run " + app.ProjectName + "”命令直接调试")
}
