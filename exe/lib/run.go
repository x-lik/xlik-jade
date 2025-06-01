package cmd

import (
	"github.com/duke-git/lancet/v2/fileutil"
	"github.com/pterm/pterm"
	"os"
	"os/exec"
	"time"
)

func (app *App) runTest(w3xFire string, times int) {
	cmd := exec.Command(app.Path.WE+"/bin/WEConfig.exe", "-launchwar3", "-loadfile", w3xFire)
	_, _ = cmd.Output()
	pterm.Info.Println("尝试启动中")
	time.Sleep(time.Second)
	exes := []string{"war3.exe"}
	if ExeRunningQty(exes) > 0 {
		pterm.Success.Println("War3已启动 " + app.Path.War3)
		bmn := app.BuildModeName
		if bmn == "_local" || bmn == "_test" || bmn == "_build" {
			// 热更新！启动！
			app.Hot()
		}
	} else {
		if times >= 3 {
			pterm.Error.Println("War3启动失败，请检查环境")
			return
		}
		pterm.Warning.Println("War3启动失败,1秒后再次重试")
		time.Sleep(time.Second)
		app.runTest(w3xFire, times+1)
	}
}

func (app *App) Run() {
	app.guessPr()
	if !app.isExistPr() {
		if app.ProjectName != "" {
			Panic("项目不存在：" + app.ProjectName)
		}
	}
	// 模式
	isCache := false // 额外模式，后面加符号[~]，如-l~  是否调用缓存启动（采用.tmp文件，常用于直接修改.tmp代码调试）
	isSemi := false  // 额外模式，后面加符号[!]，如-l!  是否半构造（最后不启动，常用于看we生成结果调试）
	mode := "-l"
	app.BuildModeName = ""
	modeLni := "slk"
	if len(os.Args) >= 4 {
		if len(os.Args[3]) == 3 {
			mode = os.Args[3][0:2]
			extraMode := os.Args[3][2:3]
			if extraMode == "~" {
				isCache = true
			} else if extraMode == "!" {
				isSemi = true
			}
		} else if len(os.Args[3]) == 2 {
			mode = os.Args[3]
		}
	}
	if mode == "-l" {
		app.BuildModeName = "_local"
		modeLni = "obj"
	} else if mode == "-t" {
		app.BuildModeName = "_test"
		modeLni = "obj"
	} else if mode == "-b" {
		app.BuildModeName = "_build"
	} else if mode == "-d" {
		app.BuildModeName = "_dist"
	} else if mode == "-r" {
		app.BuildModeName = "_release"
	} else {
		Panic("模式错误：" + mode)
	}
	app.BuildDstPath = app.Path.Temp + "/" + app.BuildModeName + "/" + app.ProjectName
	dstW3xFire := app.BuildDstPath + "/pack.w3x"
	if !isCache {
		if app.BuildModeName == "_release" {
			pterm.Debug.Println("准备发布打包")
		} else {
			temProjectDir := app.Path.Temp + "/" + app.ProjectName
			temProjectW3xFire := app.Path.Temp + "/" + app.ProjectName + ".w3x"
			buoyFire := app.Path.Temp + "/" + app.ProjectName + "/.we"
			mtW := FileGetModTime(temProjectW3xFire)
			mtB := FileGetModTime(buoyFire)
			if mtW > mtB {
				// 如果地图文件比we打开时新（说明有额外保存过）把保存后的文件拆包并同步
				cmd := exec.Command(app.Path.W3x2lni+"/w2l.exe", "lni", temProjectW3xFire)
				_, err := cmd.Output()
				if err != nil {
					Panic(err)
				}
				_ = os.Remove(buoyFire)
				CopyFile("embeds/lni/x.we", buoyFire)
				app.Backup() // 以编辑器为主版本
				pterm.Info.Println("同步完毕[检测到有新的地图保存行为，以‘WE’为主版本]")
			} else {
				app.Pickup() // 以project为主版本
				pterm.Info.Println("同步完毕[检测到没有新的地图保存行为，以‘project’为主版本]")
			}
			if app.BuildModeName == "_release" || app.BuildModeName == "_dist" {
				_ = os.RemoveAll(app.BuildDstPath)
			} else {
				// 非release|dist采用非必要更替性覆盖（多余的资源文件将存留在.tmp中继续使用，除非有更新的同名文件覆盖它）
				_ = os.Remove(app.BuildDstPath + "/.we")
				_ = os.RemoveAll(app.BuildDstPath + "/map")
				_ = os.RemoveAll(app.BuildDstPath + "/table")
			}
			CopyDir(temProjectDir, app.BuildDstPath)
			pterm.Success.Println("构建地图完毕：" + app.BuildModeName)
		}
		// 调整代码，以支持war3
		t := time.Now()
		app.War3map()
		pterm.Success.Println("资源及代码处理完成，耗时：" + time.Since(t).String())
		// 生成地图
		spinner, _ := pterm.DefaultSpinner.Start("打包地图中...")
		t = time.Now()
		cmd := exec.Command(app.Path.W3x2lni+"/w2l.exe", modeLni, app.BuildDstPath, dstW3xFire)
		_, err := cmd.Output()
		if err != nil {
			Panic(err)
		}
		// 检查标志
		spinner.Success(`打包地图完成[` + modeLni + `]，耗时` + time.Since(t).String() + `，大小` + FileGetSizeString(dstW3xFire))
		if isSemi {
			pterm.Info.Println(`>>> 临时地图已生成，位置:` + dstW3xFire + ` <<<`)
			return
		}
	} else {
		// 检查数据
		if !fileutil.IsDir(app.BuildDstPath) {
			pterm.Error.Println("未找到最近一次的地图资源缓存数据")
			return
		}
		if fileutil.IsExist(dstW3xFire) {
			_ = os.Remove(dstW3xFire)
		}
		// 生成地图
		spinner, _ := pterm.DefaultSpinner.Start("打包地图中...")
		t := time.Now()
		cmd := exec.Command(app.Path.W3x2lni+"/w2l.exe", modeLni, app.BuildDstPath, dstW3xFire)
		_, err := cmd.Output()
		if err != nil {
			Panic(err)
		}
		pterm.Info.Println(`使用最近一次[` + app.BuildModeName + `]地图资源缓存数据`)
		spinner.Success(`打包地图完成[` + modeLni + `]，耗时` + time.Since(t).String() + `，大小` + FileGetSizeString(dstW3xFire))
	}
	_ = os.Remove(app.Path.War3 + "/fwht.txt")
	_ = os.Remove(app.Path.War3 + "/fwhc.txt")
	_ = os.Remove(app.Path.War3 + "/dz_w3_plugin.dll")
	_ = os.Remove(app.Path.War3 + "/version.dll")
	wtPath := app.Path.War3 + "/Maps/Test"
	if !fileutil.IsDir(wtPath) {
		_ = os.Mkdir(wtPath, os.ModePerm)
	}
	pterm.Info.Println("即将准备地图测试")
	exes := []string{"war3.exe"}
	if ExeRunningQty(exes) > 0 {
		pterm.Warning.Println(">>> 请先关闭当前war3!!! <<<")
		return
	}
	// 跑
	app.runTest(dstW3xFire, 0)
}
