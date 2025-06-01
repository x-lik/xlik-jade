package cmd

import (
	"github.com/duke-git/lancet/v2/fileutil"
	"github.com/fsnotify/fsnotify"
	"github.com/pterm/pterm"
	"github.com/samber/lo"
	"strings"
	"sync"
	"time"
)

import (
	"os"
	"path/filepath"
)

var (
	_hotDelay      int64
	_hotCurrentMap sync.Map
)

// xHot monitors Lua files in libraries, projects, and buffers.
// It inserts operations into the runtime when a Lua file is created, modified, or deleted.
// The framework already provides basic handling for file modification and deletion.
// Users with capabilities can write their own monitoring logic.
func hotHandler(app *App, kind string, path string) {
	if ExeRunningQty([]string{"war3.exe"}) < 1 {
		os.Exit(0)
		return
	}
	if (time.Now().Unix() - _hotDelay) < 5 {
		return
	}
	if filepath.Ext(path) != ".lua" {
		return
	}
	if strings.Index(path, "builtIn") > 0 {
		// 跳过包含builtIn的路径
		return
	}
	xHotFile := app.Path.War3 + "/xhot.txt"
	xf, _ := fileutil.ReadFileToString(xHotFile)
	if !fileutil.IsExist(xHotFile) || `` == xf {
		_hotCurrentMap.Clear()
	}
	name := path
	name = strings.Replace(name, "\\", "/", -1)
	name = strings.Replace(name, ".lua", "", -1)
	isHook := false
	isTemp := strings.Index(name, app.Path.Temp+"/"+app.BuildModeName) != -1
	if isTemp {
		// 如果是对temp内的生成文件进行修改，去掉根路径前缀
		isHook = true
		name = strings.Replace(name, app.Path.Temp+"/"+app.BuildModeName+"/"+app.ProjectName+"/map/", "", 1)
	} else {
		// 如果是对root根目录内的项目文件进行修改，去掉根路径前缀
		name = strings.Replace(name, app.Pwd+"/", "", -1)
	}
	if app.BuildModeName == "_test" || app.BuildModeName == "_build" {
		isHook = true
	}
	name = strings.Replace(name, "/", ".", -1)
	code := ""
	// 如果执行注入模式，读取lua代码到xhot文件
	if isHook {
		dst := app.Path.Temp + "/" + app.BuildModeName + "/" + app.ProjectName + "/map/" + strings.Replace(name, ".", "/", -1) + ".lua"
		if kind == "modify" {
			rf, err := fileutil.ReadFileToString(path)
			if err == nil {
				if !isTemp {
					err2 := fileutil.WriteStringToFile(dst, rf, false)
					if err2 != nil {
						pterm.Error.Println(err2.Error())
					}
				}
				code = rf
			}
		} else if kind == "remove" {
			if fileutil.IsExist(dst) {
				if !isTemp {
					err := os.Remove(dst)
					if err != nil {
						pterm.Error.Println(err.Error())
					}
				}
			}
		}
	} else {
		code = `xRequire('` + name + `')`
	}
	if kind == "modify" {
		_hotCurrentMap.Store(name, code)
	} else if kind == "remove" {
		_hotCurrentMap.Delete(name)
	}
	var nameArr []string
	var codeArr []string
	_hotCurrentMap.Range(func(k, v interface{}) bool {
		nameArr = append(nameArr, k.(string))
		codeArr = append(codeArr, v.(string))
		return true
	})
	nameStr := "-- <xhot>" + strings.Join(nameArr, ",") + "<xhot>\n"
	hotStr := nameStr + strings.Join(codeArr, "\n")
	err := fileutil.WriteStringToFile(xHotFile, hotStr, false)
	if err != nil {
		pterm.Error.Println(err.Error())
	}
}

func (app *App) Hot() {
	pterm.Success.Println("热更新生效中...")
	_ = os.Remove(app.Path.War3 + "/xhot.txt")
	_hotDelay = time.Now().Unix()
	//
	// new watcher
	watcher, errh := fsnotify.NewWatcher()
	if errh != nil {
		pterm.Error.Println("热更新启动失败", errh.Error())
		return
	}
	defer watcher.Close()
	// watcher directories
	assetsRoot := strings.Replace(app.Path.Assets, app.Pwd+"/", "", 1)
	listenDir := []string{
		app.Pwd,
		app.BuildDstPath + "/map",
	}
	var directories []string
	for _, ld := range listenDir {
		directories = append(directories, []string{
			ld + "/library",
			ld + "/projects/" + app.ProjectName + "/library",
			ld + "/projects/" + app.ProjectName + "/scripts",
			ld + "/" + assetsRoot + "/war3mapFont",
			ld + "/" + assetsRoot + "/war3mapUI",
		}...)
	}
	for _, dir := range directories {
		if fileutil.IsDir(dir) {
			_ = filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
				if info.IsDir() {
					if strings.Index(path, ".git") != -1 {
						return nil
					}
					directories = append(directories, path)
				}
				return nil
			})
		}
	}
	directories = lo.Uniq(directories)
	for _, dir := range directories {
		_ = watcher.Add(dir)
	}
	go func() {
		for {
			if ExeRunningQty([]string{"war3.exe"}) < 1 {
				os.Exit(0)
				return
			}
			select {
			case ev := <-watcher.Events:
				{
					//if ev.Op&fsnotify.Create == fsnotify.Create {
					//	// 获取新创建文件的信息，如果是目录，则加入监控中
					//	file, err := os.Stat(ev.Name)
					//	if nil == err {
					//		if file.IsDir() {
					//			_ = watcher.Add(ev.Name)
					//		} else {
					//			hotHandler(app, "create", ev.Name)
					//		}
					//	}
					//}
					if ev.Op&fsnotify.Write == fsnotify.Write {
						hotHandler(app, "modify", ev.Name)
					}
					if ev.Op&fsnotify.Remove == fsnotify.Remove || ev.Op&fsnotify.Rename == fsnotify.Rename {
						//如果删除或重名文件是目录，则移除监控
						fi, err := os.Stat(ev.Name)
						if nil == err && fi.IsDir() {
							_ = watcher.Remove(ev.Name)
						} else {
							hotHandler(app, "remove", ev.Name)
						}
					}
					//if ev.Op&fsnotify.Chmod == fsnotify.Chmod {
					//	pterm.Info.Println("修改权限 : ", ev.Name)
					//}
				}
			case err := <-watcher.Errors:
				{
					pterm.Error.Println("error : ", err)
					return
				}
			}
		}
	}()
	select {}
}
