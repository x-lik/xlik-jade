package cmd

import (
	"github.com/duke-git/lancet/v2/fileutil"
	"github.com/pterm/pterm"
	"io/fs"
	"math"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"sort"
	"strconv"
	"strings"
	"time"
)

var id int
var ids []string
var cvt36 string

func init() {
	id = 0
	cvt36 = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
}

func modelID() string {
	numStr := ""
	if id == 0 {
		numStr = "0"
	} else {
		i := id
		for {
			ii := i % 36
			i = i / 36
			numStr = cvt36[ii:ii+1] + numStr
			if i == 0 {
				break
			}
		}
	}
	l := len(numStr)
	if l == 3 {
		numStr = "m" + numStr
	} else if l == 2 {
		numStr = "m0" + numStr
	} else if l == 1 {
		numStr = "m00" + numStr
	}
	id += 1
	ids = append(ids, numStr)
	return numStr
}

func (app *App) ModelMap(class string, filter string, page int) {
	batch := `<第` + strconv.Itoa(page+1) + `批>`
	// 构造图文件名，以文件名缓存
	w3xName := MD5(class + filter + strconv.Itoa(page))
	w3xDir := app.Path.Temp + "/_modelW3x"
	w3xFire := w3xDir + "/" + w3xName + ".w3x"
	w3xHas := fileutil.IsExist(w3xFire) && class != "-n"
	if !fileutil.IsDir(w3xDir) {
		err := os.MkdirAll(w3xDir, os.ModePerm)
		if err != nil {
			Panic(err)
		}
	}
	app.ProjectName = ""
	if !w3xHas {
		id = 0
		tempDir := app.Path.Temp + "/_model"
		if strings.Index(class, "-p") == 0 {
			p2 := strings.Split(class, ":")
			if len(p2) != 2 {
				pterm.Error.Println("-p参数 项目指向性错误")
				return
			}
			app.ProjectName = p2[1]
		}
		if app.ProjectName != "" {
			app.guessPr()
			w3xHas = false // 项目模型不跑缓存
			tempDir = tempDir + `/` + app.ProjectName
			if filter != "" {
				tempDir = tempDir + `_` + filter
			}
		} else {
			if filter != "" {
				tempDir = tempDir + `/` + filter
			}
		}
		dstPath, _ := filepath.Abs(tempDir + "/resource")
		_ = os.RemoveAll(dstPath)
		var models []map[string]string
		count := 0
		checkTrouble := make(map[string]bool)
		if app.ProjectName == "" {
			srcModelPath := app.Path.Assets + "/war3mapModel"
			srcTexturesPath := app.Path.Assets + "/war3mapTextures"
			if class == "-n" {
				srcModelPath = app.Path.Assets + "/war3mapModelNew"
				srcTexturesPath = app.Path.Assets + "/war3mapTexturesNew"
			}
			if fileutil.IsDir(srcModelPath) {
				srcPath, _ := filepath.Abs(srcModelPath)
				err := filepath.Walk(srcModelPath, func(path string, info fs.FileInfo, err error) error {
					if err != nil {
						return err
					}
					if filepath.Ext(path) == ".mdx" {
						// 过滤
						if filter != "" {
							if strings.Index(strings.ToLower(path), strings.ToLower(filter)) == -1 {
								return nil
							}
						}
						if count >= page*289 && count < (page+1)*289 {
							p := strings.Replace(path, srcPath+"\\", "", -1)
							CopyFile(path, dstPath+"/war3mapModel/"+p)
							n := strings.Replace(p, ".mdx", "", -1)
							n = strings.Replace(n, "\\", "_", -1)
							p = strings.Replace(p, "\\", "\\\\", -1)
							m := make(map[string]string)
							m["id"] = modelID()
							m["name"] = n
							m["file"] = `war3mapModel\\` + p
							models = append(models, m)
							if checkTrouble[p] == false {
								checkTrouble[p] = true
							} else {
								pterm.Warning.Println("冲突：" + m["file"] + " 已存在")
							}
						}
						count += 1
					}
					return nil
				})
				if err != nil {
					Panic(err)
				}
			}
			if fileutil.IsDir(srcTexturesPath) {
				srcPath, _ := filepath.Abs(srcTexturesPath)
				err := filepath.Walk(srcTexturesPath, func(path string, info fs.FileInfo, err error) error {
					if err != nil {
						return err
					}
					if filepath.Ext(path) == ".blp" {
						p := strings.Replace(path, srcPath+"\\", "", -1)
						CopyFile(path, dstPath+"/war3mapTextures/"+p)
					}
					return nil
				})
				if err != nil {
					Panic(err)
				}
			}
		} else {
			projectAssetsPath := app.Pwd + "/projects/" + app.ProjectName + "/assets"
			if fileutil.IsDir(projectAssetsPath) {
				pterm.Info.Println(batch + "Project:" + app.ProjectName)
				srcPath, _ := filepath.Abs(projectAssetsPath)
				var modelStrs []string
				err := filepath.Walk(srcPath, func(path string, info fs.FileInfo, err error) error {
					if err != nil {
						return err
					}
					if filepath.Ext(path) == ".lua" {
						luaStr, _ := fileutil.ReadFileToString(path)
						luaStr = strings.Replace(luaStr, "\r\n", "\n", -1)
						luaStr = strings.Replace(luaStr, "\r", "\n", -1)
						reg := regexp.MustCompile("--(.*)\\[\\[[\\s\\S]*?\\]\\]")
						luaStr = reg.ReplaceAllString(luaStr, "")
						reg = regexp.MustCompile("--(.*)")
						luaStr = reg.ReplaceAllString(luaStr, "")
						luaStrs := strings.Split(luaStr, "\n")
						for _, ls := range luaStrs {
							reg = regexp.MustCompile(`(?ms)assets_model\(\"(.*?)\"`)
							luaMs := reg.FindStringSubmatch(ls)
							if len(luaMs) >= 2 {
								// 过滤
								filterPass := (filter == "") || strings.Index(strings.ToLower(luaMs[1]), strings.ToLower(filter)) != -1
								if filterPass {
									res := strings.Replace(luaMs[1], "\\\\", "/", -1)
									modelStrs = append(modelStrs, res)
								}
							}
						}
					}
					return nil
				})
				if err != nil {
					Panic(err)
				}
				sort.Strings(modelStrs)
				for _, ms := range modelStrs {
					name := ""
					file := ""
					if count >= page*289 && count < (page+1)*289 {
						ext := filepath.Ext(ms)
						if ext == ".mdl" || ext == ".mdx" {
							name = ms
							file = name
						} else {
							name = ms
							file = `war3mapModel/` + name + `.mdx`
							modelFile := app.Path.Assets + `/` + file
							if fileutil.IsExist(modelFile) {
								CopyFile(modelFile, dstPath+"/war3mapModel/"+name+".mdx")
								modelStr, _ := fileutil.ReadFileToString(modelFile)
								modelStr = strings.Replace(modelStr, "\r", "", -1)
								reg := regexp.MustCompile("(?i)war3mapTextures(.*?)(.blp)")
								textures := reg.FindAllString(modelStr, -1)
								if len(textures) > 0 {
									for _, t := range textures {
										t = strings.Replace(t, "war3mapTextures", "", -1)
										textureFile := app.Path.Assets + "/war3mapTextures" + t
										if fileutil.IsExist(textureFile) {
											CopyFile(textureFile, dstPath+"/war3mapTextures"+t)
										} else {
											pterm.Error.Println("【贴图】：文件不存在 " + t)
										}
									}
								}
							} else {
								pterm.Error.Println("【模型】：文件不存在 " + name)
							}
						}
						name = strings.Replace(name, ".mdx", "", -1)
						name = strings.Replace(name, ".mdl", "", -1)
						name = strings.Replace(name, "/", "_", -1)
						file = strings.Replace(file, "/", "\\\\", -1)
						m := make(map[string]string)
						m["id"] = modelID()
						m["name"] = name
						m["file"] = file
						models = append(models, m)
						if checkTrouble[file] == false {
							checkTrouble[file] = true
						} else {
							pterm.Warning.Println("冲突：" + m["file"] + " 已存在")
						}
					}
					count += 1
				}
			}
		}
		if len(models) <= 0 {
			pterm.Debug.Println(batch + "已无模型符合要求，停止处理")
			return
		}

		pterm.Info.Println(batch + "开始构建虚构 " + filter)
		CopyPath("embeds/lni/table", tempDir+"/table")
		CopyPath("embeds/lni/w3x2lni", tempDir+"/w3x2lni")
		CopyFile("embeds/lni/x.w3x", tempDir+"/.w3x")
		CopyPath("embeds/models", tempDir+"/map")
		CopyFile("embeds/models/w3i.ini", tempDir+"/table/w3i.ini")
		if app.ProjectName != "" {
			CopyPath(app.Path.Projects+"/"+app.ProjectName+"/w3x/resource", tempDir+"/resource")
		}

		unitIni := tempDir + "/table/unit.ini"
		unitIniContent := ""
		for _, v := range models {
			unitIniContent += "\n\n[" + v["id"] + "]\n_parent=\"nrwm\"\nfile=\"" + v["file"]
			unitIniContent += "\"\nName=\"" + v["id"] + ":" + v["name"] + "\"\nTip=\"" + v["name"] + "\""
			unitIniContent += "\nfused=0\nunitShadow=\"\"\nfmade=0\nrace=\"human\"\nmoveHeight=70"
			if strings.Contains(v["name"], "item_") {
				unitIniContent += "\nmodelScale=2.0"
			} else if strings.Contains(v["name"], "eff_") {
				unitIniContent += "\nmodelScale=0.75"
			} else {
				unitIniContent += "\nmodelScale=1.0"
			}
			if id%17 == 0 {
				unitIniContent += "\nArt=\"ReplaceableTextures\\\\CommandButtons\\\\BTNFootman.blp\""
			}
		}

		t1 := time.Now()
		allP := strconv.FormatFloat(math.Ceil(float64(count)/289), 'f', 0, 64)
		pterm.Success.Println(batch + "已处理 " + strconv.Itoa(id) + "[" + strconv.Itoa(page*289) + ":" + strconv.Itoa((page+1)*289-1) + "]个模型，共" + allP + "批")
		err := FilePutContents(unitIni, unitIniContent, fs.ModePerm)
		if err != nil {
			Panic(err)
		}
		pterm.Success.Println(batch + "处理完成(" + time.Since(t1).String() + ")")
		t2 := time.Now()
		cmd := exec.Command(app.Path.W3x2lni+"/w2l.exe", "obj", tempDir, w3xFire)
		_, err = cmd.Output()
		if err != nil {
			Panic(err)
		}
		// 检查标志
		pterm.Success.Println(batch + "模型图已生成(" + time.Since(t2).String() + ")")
	}
	// 打开模型图
	cmd := exec.Command(app.Path.WE+"/WE.exe", "-loadfile", w3xFire)
	_, err := cmd.Output()
	if err != nil {
		Panic(err)
	}
	if w3xHas {
		pterm.Info.Println(batch + "模型图(缓存)正在打开：" + w3xFire)
	} else {
		pterm.Info.Println(batch + "模型图正在打开：" + w3xFire)
	}
	app.ModelMap(class, filter, page+1)
}

func (app *App) Model() {
	if len(os.Args) < 3 {
		Panic("Params error!")
	}
	// 分类
	class := os.Args[2]
	// 搜索
	var filter []string
	if len(os.Args) >= 4 {
		filter = strings.Split(os.Args[3], ",")
	}
	pterm.Info.Println("虚构构建准备启动")
	if len(filter) > 0 {
		pterm.Debug.Println("搜索路径带有：" + os.Args[3])
		for _, f := range filter {
			app.ModelMap(class, f, 0)
		}
	} else {
		app.ModelMap(class, ``, 0)
	}
}
