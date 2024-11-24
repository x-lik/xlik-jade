package cmd

import (
	"github.com/duke-git/lancet/v2/fileutil"
	"github.com/pterm/pterm"
	"io/fs"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
)

func (app *App) WE() {
	if len(app.Args) <= 2 {
		cmd := exec.Command(app.Path.WE + "/WE.exe")
		_, err := cmd.Output()
		if err != nil {
			Panic(err)
		}
		pterm.Info.Println("WE正在打开")
		return
	}
	app.guessPr()
	if !app.isExistPr() {
		Panic("项目" + app.ProjectName + "不存在")
	}
	// 判断是否已有we在修改项目，提示一下
	exes := []string{"worldedit.exe", "worldeditydwe.exe", "worldeditkkwe.exe"}
	if ExeRunningQty(exes) > 0 {
		pterm.Warning.Println("提示：检测到已有WE开启中，如果你是重复调用了we命令，请保留一个进行修改!")
	}
	//
	w3xDir := app.Path.Temp + "/" + app.ProjectName
	w3xFire := app.Path.Temp + "/" + app.ProjectName + ".w3x"
	// 检查上一次we的修改数据是否未保存
	buoyFire := app.Path.Temp + "/" + app.ProjectName + "/.we"
	mtW := GetModTime(w3xFire)
	mtB := GetModTime(buoyFire)
	if mtW > mtB {
		// 如果地图文件比we打开时新（说明有额外保存过）把保存后的文件拆包并同步
		cmd := exec.Command(app.Path.W3x2lni+"/w2l.exe", "lni", w3xFire)
		_, err := cmd.Output()
		if err != nil {
			Panic(err)
		}
		app.Backup() // 以编辑器为主版本
		pterm.Info.Println("同步完毕[检测到之前有过使用we命令进行地图保存行为，正在进行同步备份]")
	}
	_ = os.Remove(buoyFire)
	// pickup
	app.Pickup()
	// 加载项目地形贴图
	projectAssetsPath := app.Pwd + "/projects/" + app.ProjectName + "/assets"
	if fileutil.IsDir(projectAssetsPath) {
		pterm.Info.Println("尝试加载项目" + app.ProjectName + "中的terrain资源")
		srcPath, _ := filepath.Abs(projectAssetsPath)
		terrain := ""
		err := filepath.Walk(srcPath, func(path string, info fs.FileInfo, err error) error {
			if err != nil {
				return err
			}
			if filepath.Ext(path) == ".lua" {
				luaStr, _ := fileutil.ReadFileToString(path)
				luaStr = strings.Replace(luaStr, "\r\n", "\n", -1)
				luaStr = strings.Replace(luaStr, "\r", "\n", -1)
				reg, _ := regexp.Compile("--(.*)\\[\\[[\\s\\S]*?\\]\\]")
				luaStr = reg.ReplaceAllString(luaStr, "")
				reg, _ = regexp.Compile("--(.*)")
				luaStr = reg.ReplaceAllString(luaStr, "")
				luaStrs := strings.Split(luaStr, "\n")
				for _, ls := range luaStrs {
					reg, _ = regexp.Compile(`(?ms)assets_terrain\(\"(.*?)\"`)
					luaMs := reg.FindStringSubmatch(ls)
					if len(luaMs) >= 2 {
						if terrain != "" {
							pterm.Warning.Println("地形贴图冲突[调用过" + terrain + "的贴图，确保项目只引用过一次的地形贴图]")
						}
						terrain = luaMs[1]
					}
				}
			}
			return nil
		})
		if err != nil {
			Panic(err)
		}
		if terrain == "" {
			pterm.Debug.Println("未找到项目" + app.ProjectName + "中引用了terrain资源")
		} else {
			terrainDir := app.Path.Assets + "/war3mapTerrain/" + terrain
			if fileutil.IsDir(terrainDir) {
				cliff := terrainDir + "/Cliff"
				terrainArt := terrainDir + "/TerrainArt"
				if !fileutil.IsDir(cliff) || !fileutil.IsDir(terrainArt) {
					pterm.Error.Println("地形贴图：" + terrain + " 地形数据错误")
				}
				CopyPath(cliff, w3xDir+"/resource/ReplaceableTextures/Cliff")
				CopyPath(terrainArt, w3xDir+"/resource/TerrainArt")
				pterm.Info.Println("地形贴图：" + terrain)
			} else {
				pterm.Error.Println("地形贴图：" + terrain + " 不存在")
			}
		}
	}
	// pack
	cmd := exec.Command(app.Path.W3x2lni+"/w2l.exe", "obj", w3xDir, w3xFire)
	_, err := cmd.Output()
	if err != nil {
		Panic(err)
	}
	CopyFile("embeds/lni/x.we", buoyFire)
	cmd = exec.Command(app.Path.WE+"/WE.exe", "-loadfile", w3xFire)
	_, err = cmd.Output()
	if err != nil {
		Panic(err)
	}
	pterm.Info.Println("WE正在配图并打开")
}
