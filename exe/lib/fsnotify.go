package cmd

import (
	"github.com/duke-git/lancet/v2/fileutil"
	"github.com/fsnotify/fsnotify"
	"github.com/pterm/pterm"
	"io/fs"
	"strings"
	"sync"
	"time"
)

import (
	"os"
	"path/filepath"
)

type NotifyFile struct {
	watch *fsnotify.Watcher
}

var (
	fsnSec  int64
	xHotMap sync.Map
)

func NewNotifyFile() *NotifyFile {
	w := new(NotifyFile)
	w.watch, _ = fsnotify.NewWatcher()
	return w
}

// WatchDir 监控目录
func (this *NotifyFile) WatchDir(app *App, dir string) {
	filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
		if info.IsDir() {
			if strings.Index(path, ".git") > 0 {
				return nil
			}
			paa, err2 := filepath.Abs(path)
			if err2 != nil {
				return err2
			}
			err2 = this.watch.Add(paa)
			if err2 != nil {
				return err2
			}
		}
		return nil
	})
	go this.WatchEvent(app) //协程
}

func xHot(app *App, kind string, path string) {
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
		xHotMap.Range(func(key, value any) bool {
			xHotMap.Delete(key)
			return true
		})
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
	} else if strings.Index(name, app.Path.Assets) != -1 {
		// 如果是对assets内的生成文件进行修改，去掉资源路径前缀
		if strings.Index(name, "war3mapFont") != -1 {
			// 如果是字体资源
			isHook = true
			name = "projects.fonts"
		} else {
			name = strings.Replace(name, app.Path.Assets+"/", "", 1)
		}
	} else {
		// 如果是对root根目录内的项目文件进行修改，去掉根路径前缀
		name = strings.Replace(name, app.Pwd+"/", "", -1)
	}
	if app.BuildModeName == "_test" || app.BuildModeName == "_build" {
		isHook = true
		// 如果修改的是project的library文件
		if strings.Index(name, "projects/"+app.ProjectName+"/library/") != -1 {
			name = strings.Replace(name, "projects/"+app.ProjectName+"/library", "librpro", 1)
		}
	}
	name = strings.Replace(name, "/", ".", -1)
	code := ""
	// 如果执行注入模式，读取lua代码到xhot文件
	if isHook {
		dst := app.Path.Temp + "/" + app.BuildModeName + "/" + app.ProjectName + "/map/" + strings.Replace(name, ".", "/", -1) + ".lua"
		if kind == "create" || kind == "modify" {
			rf, err := fileutil.ReadFileToString(path)
			if err == nil {
				if !isTemp {
					err2 := FilePutContents(dst, rf, fs.ModePerm)
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
	if kind == "create" || kind == "modify" {
		xHotMap.Store(name, code)
	} else if kind == "remove" {
		xHotMap.Store(name, ``)
	}
	var nameArr []string
	var codeArr []string
	xHotMap.Range(func(k, v interface{}) bool {
		c := v.(string)
		if c != "" {
			nameArr = append(nameArr, k.(string))
			codeArr = append(codeArr, c)
		}
		return true
	})
	nameStr := "-- <xhot>" + strings.Join(nameArr, ",") + "<xhot>\n"
	hotStr := nameStr + strings.Join(codeArr, "\n")
	err := FilePutContents(xHotFile, hotStr, fs.ModePerm)
	if err != nil {
		pterm.Error.Println(err.Error())
	}
}

func create(app *App, name string) {
	exes := []string{"war3.exe"}
	if ExeRunningQty(exes) < 1 {
		os.Exit(0)
		return
	}
	if (time.Now().Unix() - fsnSec) > 5 {
		xHot(app, "create", name)
	}
}

func modify(app *App, name string) {
	exes := []string{"war3.exe"}
	if ExeRunningQty(exes) < 1 {
		os.Exit(0)
		return
	}
	if (time.Now().Unix() - fsnSec) > 5 {
		xHot(app, "modify", name)
	}
}

func remove(app *App, name string) {
	exes := []string{"war3.exe"}
	if ExeRunningQty(exes) < 1 {
		os.Exit(0)
		return
	}
	if (time.Now().Unix() - fsnSec) > 5 {
		xHot(app, "remove", name)
	}
}

func (this *NotifyFile) WatchEvent(app *App) {
	defer this.watch.Close()
	for {
		select {
		case ev := <-this.watch.Events:
			{
				if ev.Op&fsnotify.Create == fsnotify.Create {
					// 获取新创建文件的信息，如果是目录，则加入监控中
					file, err := os.Stat(ev.Name)
					if nil == err {
						if file.IsDir() {
							this.watch.Add(ev.Name)
						} else {
							create(app, ev.Name)
						}
					}
				}

				if ev.Op&fsnotify.Write == fsnotify.Write {
					modify(app, ev.Name)
				}

				if ev.Op&fsnotify.Remove == fsnotify.Remove || ev.Op&fsnotify.Rename == fsnotify.Rename {
					//如果删除或重名文件是目录，则移除监控
					fi, err := os.Stat(ev.Name)
					if nil == err && fi.IsDir() {
						this.watch.Remove(ev.Name)
					} else {
						remove(app, ev.Name)
					}
				}

				//if ev.Op&fsnotify.Chmod == fsnotify.Chmod {
				//	pterm.Info.Println("修改权限 : ", ev.Name)
				//}
			}
		case err := <-this.watch.Errors:
			{
				pterm.Error.Println("error : ", err)
				return
			}
		}
	}
}

func (app *App) Hot() {
	pterm.Success.Println("全局热更新生效中...")
	_ = os.Remove(app.Path.War3 + "/xhot.txt")
	fsnSec = time.Now().Unix()
	watch := NewNotifyFile()
	watch.WatchDir(app, app.Pwd+"/library")
	watch.WatchDir(app, app.Path.Assets+"/war3mapFont")
	watch.WatchDir(app, app.Path.Assets+"/war3mapUI")
	watch.WatchDir(app, app.Pwd+"/projects/"+app.ProjectName)
	watch.WatchDir(app, app.Path.Temp+"/"+app.BuildModeName+"/"+app.ProjectName+"/map")
	select {}
}
