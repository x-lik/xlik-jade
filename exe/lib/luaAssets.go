package cmd

import (
	"errors"
	"github.com/duke-git/lancet/v2/fileutil"
	"github.com/pterm/pterm"
	"gopkg.in/yaml.v3"
	"io/fs"
	"math"
	"os"
	"path/filepath"
	"reflect"
	"regexp"
	"strconv"
	"strings"
	"time"
)

type AssetsGo struct {
	Selection string
	Font      string
	Loading   string
	Preview   string
	Terrain   string
	Image     [][]string
	Model     [][]string
	Bgm       [][]string
	Vcm       [][]string
	V3d       [][]string
	Vwp       []string
	UI        []string
}

type AssetsType struct {
	Path string
	Name string
	Ext  []string
	Skip bool
}

var (
	asTypes      map[string]AssetsType
	asChecker    map[string][]string
	asCheckInt   map[string]int
	asScripts    []string
	asModelAlias map[string]string
	asDetectP    map[string]map[string]int
	asDetectA    map[string]map[string]int
)

func init() {
	asTypes = map[string]AssetsType{
		"image": {
			Path: "war3mapImage",
			Name: "【图片】Image",
			Ext:  []string{".tga", ".blp"},
		},
		"model": {
			Path: "war3mapModel",
			Name: "【模型】Model",
			Ext:  []string{".mdx", ".mdl"},
		},
		"bgm": {
			Path: "war3mapBgm",
			Name: "【乐曲】Bgm",
			Ext:  []string{".mp3", ".wav"},
		},
		"vcm": {
			Path: "war3mapVoice",
			Name: "【音效】Vcm",
			Ext:  []string{".mp3", ".wav"},
		},
		"v3d": {
			Path: "war3mapVoice",
			Name: "【音效】V3d",
			Ext:  []string{".mp3", ".wav"},
		},
		"vwp": {
			Path: "war3mapVwp",
			Name: "【音效】Vwp",
			Ext:  []string{".yaml"},
			Skip: true,
		},
		"vwp-voice": {
			Path: "war3mapVoice",
			Name: "【音效】Vwp",
			Ext:  []string{".mp3", ".wav"},
		},
	}
	asCheckInt = make(map[string]int)
}

func asExt(src string, set string) string {
	ext := filepath.Ext(src)
	if set != ext {
		src = src + set
	}
	return src
}

// asCheck 检查资源是否未被使用，以免加载多余的资源
func (app *App) asCheck() {
	content := app.luaAllContent()
	check := make(map[string]int)
	reg := regexp.MustCompile(`[一-龥，。！、（）【】；：“”《》？…]+`)
	mcn := reg.FindAllString(content, -1)
	if len(mcn) > 0 {
		for _, s := range mcn {
			if check[s] == 0 {
				check[s] = 1
			} else {
				check[s] += 1
			}
		}
	}
	reg = regexp.MustCompile(`"[<>0-9A-Za-z._:!*,/+\\-]{2,}"`)
	m := reg.FindAllString(content, -1)
	if len(m) > 0 {
		for _, s := range m {
			s2 := s[1 : len(s)-1]
			check[strings.ToLower(s2)] += 1
		}
	}
	// 资源检测
	for kind, ns := range asChecker {
		for _, a := range ns {
			la := strings.ToLower(a)
			if check[la] <= (2 + asCheckInt[la]) {
				pterm.Warning.Println("【资源检测】：" + kind + `:` + a + " 可能未曾使用")
			}
		}
	}
}

// asDetect 检查资源是否重复引用，以免多次加载资源
func asDetect(kind string, path string, alias string, srcPath string) bool {
	support := asTypes[kind]
	if len(support.Ext) < 1 {
		Panic("asDetect:" + kind)
	}
	if reflect.ValueOf(asDetectP[kind]).IsNil() {
		asDetectP[kind] = make(map[string]int)
	}
	n := asDetectP[kind][srcPath]
	n += 1
	if n > 1 {
		pterm.Warning.Println("【资源检测】" + support.Name + ` 以 ` + path + ` 调用即(` + srcPath + ") 重复引入")
	}
	asDetectP[kind][srcPath] = n
	//
	if reflect.ValueOf(asDetectA[kind]).IsNil() {
		asDetectA[kind] = make(map[string]int)
	}
	n = asDetectA[kind][alias]
	n += 1
	asDetectA[kind][alias] = n
	if n > 1 {
		pterm.Warning.Println("【资源检测】" + support.Name + ` 别称 ` + alias + " 重复引入")
		return false
	}
	return true
}

// asScriptIn
func asScriptIn(kind string, alias string, value string, ex string) {
	in := []string{strconv.Quote(kind)}
	if `` != alias {
		in = append(in, strconv.Quote(strings.ToLower(alias)))
	}
	if value[0:1] == `{` {
		in = append(in, value)
	} else {
		in = append(in, strconv.Quote(value))
	}
	if `` != ex {
		in = append(in, ex)
	}
	asScripts = append(asScripts, `assets_pset(`+strings.Join(in, `,`)+`)`)
}

// kind 资源种类
// path 配置的第1个路径参数
// alias 配置的别称参数
// 返回: 标识值,资源路径,额外数据
func (app *App) asAnalysisFile(kind string, path string, alias string, skipDetect bool) (bool, string, string) {
	support := asTypes[kind]
	if len(support.Ext) < 1 {
		Panic("asAnalysisFile:" + kind)
	}
	analyser := strings.Replace(path, "/", "\\", -1)
	ext := filepath.Ext(analyser)
	//
	asPath := ""
	srcPath := ""
	exData := ""
	if "" == ext || !InArray(ext, support.Ext) {
		// 没有后缀时，取优先第一后缀
		// 如果有后缀但不支持时，也设为第一后缀，反正加到路径后文件如果不对还是找不到
		ext = support.Ext[0]
	}
	// 补正后缀名，确保 src 路径是带后缀名的路径
	analyser = asExt(analyser, ext)
	if ext == ".mdl" {
		analyser = strings.Replace(analyser, ".mdl", ".mdx", -1)
	}
	// 资源来源，war3资源的优先级别是最低的
	// assets优先级最高，再是project/resource，最后才是war3
	isWar3 := false
	aFile := app.Path.Assets + "\\" + support.Path + "\\" + analyser
	if fileutil.IsExist(aFile) {
		aTail := strings.Replace(asExt(alias, ext), "/", "\\", -1)
		asPath = support.Path + "\\" + aTail
		srcPath = aFile
		// 复制assets文件到temp
		if !support.Skip {
			dstPath := app.BuildDstPath + "/resource/" + support.Path + "/" + aTail
			CopyFile(srcPath, dstPath)
		}
		switch ext {
		case ".mp3", ".wav":
			asPath = "resource\\" + asPath
			// 音频文件需要获取持续时长(毫秒)
			dur := VoiceMilliseconds(srcPath)
			exData = strconv.Itoa(dur)
		case ".yaml":
			exData = srcPath
		case ".mdl":
			exData = srcPath
		case ".mdx":
			asPath = strings.Replace(asPath, ".mdx", ".mdl", -1)
			exData = srcPath
		}
	} else {
		// project资源
		// 项目自带资源 需要处理 resource\\
		r := analyser
		if 0 == strings.Index(r, "resource\\") {
			r = strings.Replace(r, "resource\\", "", 1)
		}
		pFile := app.Path.Projects + "\\" + app.ProjectName + "\\w3x\\resource\\" + r
		if fileutil.IsExist(pFile) {
			asPath = "resource\\" + r
			srcPath = pFile
			switch ext {
			case ".mdl":
				asPath = strings.Replace(asPath, ".mdx", ".mdl", -1)
			case ".mp3", ".wav":
				// 音频文件需要获取持续时长(毫秒)
				dur := VoiceMilliseconds(srcPath)
				exData = strconv.Itoa(dur)
			}
		} else {
			// war3原生资源
			isWar3 = true
			asPath = analyser
			srcPath = analyser
			switch ext {
			case ".mdl":
				asPath = strings.Replace(asPath, ".mdx", ".mdl", -1)
			case ".mp3", ".wav":
				// war3原生音频文件需要检测是否真的存在
				// 并获取预设持续时长(毫秒)
				dur := War3soundDur(srcPath)
				if dur >= 0 {
					exData = strconv.Itoa(dur)
				} else {
					asPath = ""
				}
			}
		}
	}
	if "" == asPath {
		pterm.Error.Println(support.Name + "：资源不存在 " + path)
		time.Sleep(time.Second)
		return false, asPath, exData
	}
	if !skipDetect {
		if asDetect(kind, path, alias, asPath) {
			if !isWar3 && kind != "vwp-voice" {
				asChecker[kind] = append(asChecker[kind], alias)
			}
		}
	}
	return true, asPath, exData
}

// kind 资源种类
// path 配置的第1个路径参数
// alias 配置的别称参数
// 返回: 标识值,资源路径,额外数据
func (app *App) asAnalysisPath(kind string, path string, alias string) (bool, string, string) {
	support := asTypes[kind]
	if len(support.Ext) < 1 {
		Panic("asAnalysisPath:" + kind)
	}
	analyser := strings.Replace(path, "/", "\\", -1)
	if analyser[len(analyser)-2:] == `\*` {
		// 序列模式
		analyser = analyser[:len(analyser)-2]
		aRoot := app.Path.Assets + "\\" + support.Path + "\\"
		seq := aRoot + analyser
		if !fileutil.IsDir(seq) {
			r := analyser
			if 0 == strings.Index(analyser, "resource\\") {
				r = strings.Replace(analyser, "resource\\", "", 1)
			}
			seq = app.Path.Projects + "\\" + app.ProjectName + "\\w3x\\resource\\" + r
		}
		if fileutil.IsDir(seq) {
			var segList []string
			err := filepath.Walk(seq, func(path string, info os.FileInfo, err error) error {
				if err != nil {
					return err
				}
				if !fileutil.IsDir(path) {
					file := strings.Replace(path, aRoot, "", -1)
					status, ap, _ := app.asAnalysisFile(kind, file, file, true)
					if status {
						segList = append(segList, ap)
						asDetect(kind, path, file, file)
					}
				}
				return nil
			})
			if err != nil {
				Panic(err)
			}
			if len(segList) > 0 {
				for k, v := range segList {
					segList[k] = strconv.Quote(v)
				}
				asPath := `{` + strings.Join(segList, `,`) + `}`
				exData := strconv.Itoa(len(segList))
				asChecker[kind] = append(asChecker[kind], alias)
				return true, asPath, exData
			}
		}
		pterm.Error.Println(support.Name + "：资源序列不存在 " + path)
		time.Sleep(time.Second)
		return false, ``, ``
	} else {
		// 单例模式
		status, asp, ed := app.asAnalysisFile(kind, path, alias, false)
		if !status {
			return false, asp, ed
		}
		return true, asp, ed
	}
}

// asSelection 选择圈
func (app *App) asSelection(data string) {
	dir := app.Path.Assets + "/war3mapSelection/" + data
	if !fileutil.IsDir(dir) {
		pterm.Warning.Println("【选择圈】组件 " + data + " 不存在")
		CopyPath("embeds/lni/assets/Selection", app.BuildDstPath+"/resource/ReplaceableTextures/Selection")
		pterm.Info.Println("【选择圈】引入：Lni")
	} else {
		CopyPath(dir, app.BuildDstPath+"/resource/ReplaceableTextures/Selection")
		pterm.Info.Println("【选择圈】引入：" + data)
	}
}

// asTerrain 地形贴图
func (app *App) asTerrain(data string) {
	if data != "" {
		terrainDir := app.Path.Assets + "/war3mapTerrain/" + data
		if fileutil.IsDir(terrainDir) {
			ok := true
			cliff := terrainDir + "/Cliff"
			if !fileutil.IsDir(cliff) {
				pterm.Error.Println("【地形贴图】组件：" + data + " Cliff悬崖贴图丢失")
				ok = false
			}
			terrainArt := terrainDir + "/TerrainArt"
			if !fileutil.IsDir(terrainArt) {
				pterm.Error.Println("【地形贴图】组件：" + data + " TerrainArt地表贴图丢失")
				ok = false
			}
			if ok {
				CopyPath(cliff, app.BuildDstPath+"/resource/ReplaceableTextures/Cliff")
				CopyPath(terrainArt, app.BuildDstPath+"/resource/TerrainArt")
				pterm.Info.Println("【地形贴图】引入：" + data)
			} else {
				pterm.Error.Println("【地形贴图】引入：" + data + " 存在问题已中止")
			}
		} else {
			pterm.Error.Println("【地形贴图】组件：" + data + " 不存在")
		}
	}
}

// asFont 字体
func (app *App) asFont(data string) string {
	ext := filepath.Ext(data)
	if ext != "" {
		if ext != ".ttf" {
			pterm.Warning.Println("【字体】文件不支持 " + ext + " 格式")
			data = "default"
		}
	}
	data = strings.Replace(data, ".ttf", "", -1)
	isDefault := false
	fontFile := app.Path.Assets + "/war3mapFont/" + data + ".ttf"
	if false == fileutil.IsExist(fontFile) {
		pterm.Warning.Println("【字体】文件 " + data + " 不存在")
		isDefault = true
		fontFile = "embeds/lni/assets/fonts.ttf"
		data = "default"
	}
	CopyFile(fontFile, app.BuildDstPath+"/map/fonts.ttf")
	pterm.Info.Println("【字体】引入：" + data)
	if !isDefault {
		luaFile := app.Path.Assets + "/war3mapFont/" + data + ".lua"
		if fileutil.IsExist(luaFile) {
			fontLua, err := fileutil.ReadFileToString(luaFile)
			if err != nil {
				Panic(err)
			}
			if fontLua != "" {
				pterm.Debug.Println("【字体】载入lua配置")
				luaChipsIn(LuaFile{
					name: "projects.fonts",
					dst:  app.BuildDstPath + "/map/projects/fonts.lua",
					code: fontLua,
					gen:  true,
				})
			}
		}
	}
	asScriptIn(`font`, ``, data, ``)
	return data
}

// asLoading 载入图
func (app *App) asLoading(data string) {
	_ = os.Remove(app.BuildDstPath + "/resource/Framework/LoadingScreen.mdx")
	loadingPath := app.Path.Assets + "/war3MapLoading/" + data
	loadingFile := app.Path.Assets + "/war3MapLoading/" + data + ".tga"
	loaded := false
	if fileutil.IsDir(loadingPath) {
		CopyFile("embeds/lni/assets/LoadingScreenDir.mdx", app.BuildDstPath+"/resource/Framework/LoadingScreen.mdx")
		loadingSites := []string{"pic", "bc", "bg"}
		for _, s := range loadingSites {
			loadingFile = loadingPath + "/" + s + ".tga"
			if fileutil.IsExist(loadingFile) {
				CopyFile(loadingFile, app.BuildDstPath+"/resource/Framework/LoadingScreen"+s+".tga")
			} else {
				pterm.Error.Println("【载入图】引入拼图文件：" + s + " 不存在")
			}
		}
		loaded = true
	} else if fileutil.IsExist(loadingFile) {
		CopyFile("embeds/lni/assets/LoadingScreenFile.mdx", app.BuildDstPath+"/resource/Framework/LoadingScreen.mdx")
		CopyFile(loadingFile, app.BuildDstPath+"/resource/Framework/LoadingScreen.tga")
		loaded = true
	}
	if loaded {
		w3i, _ := fileutil.ReadFileToString(app.BuildDstPath + "/table/w3i.ini")
		w3i = strings.Replace(w3i, "\r\n", "\n", -1)
		w3i = strings.Replace(w3i, "\r", "\n", -1)
		w3ia := strings.Split(w3i, "\n")
		canReplace := false
		for k, v := range w3ia {
			if strings.Index(v, "[载入图]") != -1 {
				canReplace = true
			}
			if canReplace && strings.Index(v, "路径") != -1 {
				w3ia[k] = `路径 = "Framework\\LoadingScreen.mdx"`
				break
			}
		}
		err := fileutil.WriteStringToFile(app.BuildDstPath+"/table/w3i.ini", strings.Join(w3ia, "\r\n"), false)
		if err != nil {
			Panic(err)
		}
		pterm.Info.Println("【载入图】引入：" + data)
	} else {
		pterm.Error.Println("【载入图】套件：" + data + " 不存在")
		time.Sleep(time.Second)
	}
}

// asPreview 预览图
func (app *App) asPreview(data string) {
	if data == "" {
		pterm.Debug.Println("【预览图】无资源引入")
	} else {
		file := app.Path.Assets + "/war3mapPreview/" + asExt(data, ".tga")
		if fileutil.IsExist(file) {
			CopyFile(file, app.BuildDstPath+"/resource/war3mapPreview.tga")
			pterm.Info.Println("【预览图】引入：" + data)
		}
	}
}

// asImage 图片
func (app *App) asImage(data [][]string) {
	count := 0
	for _, i := range data {
		status, asPath, exData := app.asAnalysisPath("image", i[0], i[1])
		if !status {
			continue
		}
		if `` == exData {
			asScriptIn(`image`, i[1], asPath, ``)
			count += 1
		} else {
			n, err := strconv.Atoi(exData)
			if err == nil {
				asScriptIn(`image`, i[1], asPath, ``)
				count += n
			}
		}
	}
	pterm.Info.Println(asTypes["image"].Name + " 引入：" + strconv.Itoa(count) + "个")
}

// asModel 模型
func (app *App) asModel(data [][]string) {
	count := 0
	count2 := 0
	for _, i := range data {
		status, asPath, srcPath := app.asAnalysisPath("model", i[0], i[1])
		if !status {
			continue
		}
		portraitPath := app.Path.Assets + "/war3mapModel/" + i[0] + "_Portrait.mdx"
		if fileutil.IsExist(portraitPath) {
			CopyFile(portraitPath, app.BuildDstPath+"/resource/war3mapModel/"+i[1]+"_Portrait.mdx")
		}
		if "" != srcPath {
			mData, _ := fileutil.ReadFileToString(srcPath)
			mData = strings.Replace(mData, "\r", "", -1)
			mData = strings.Replace(mData, "\r", "", -1)
			reg := regexp.MustCompile("(?i)war3mapTextures(.*?)(.blp)")
			textures := reg.FindAllString(mData, -1)
			if len(textures) > 0 {
				ti := 0
				for _, t := range textures {
					t = strings.Replace(t, "war3mapTextures", "", -1)
					textureFile := app.Path.Assets + "/war3mapTextures" + t
					if fileutil.IsExist(textureFile) {
						CopyFile(textureFile, app.BuildDstPath+"/resource/war3mapTextures"+t)
						ti += 1
					} else {
						pterm.Error.Println("【模型】Textures： " + t + " 不存在")
						time.Sleep(time.Second)
					}
				}
				count2 = count2 + ti
			}
		}
		asModelAlias[strconv.Quote(i[1])] = strconv.Quote(asPath)
		asScriptIn(`model`, i[1], asPath, ``)
		count += 1
	}
	pterm.Info.Println(asTypes["model"].Name + " 引入：" + strconv.Itoa(count) + "个")
	pterm.Info.Println("【模型】Textures 引入：" + strconv.Itoa(count2) + "张")
}

// asBGM 声音 - 乐曲
func (app *App) asBGM(data [][]string) {
	_reg := func(alias string, asPath string, dur string, volume string) {
		vi, _ := strconv.Atoi(volume)
		vf := float64(vi)
		vf = math.Min(vf, 1.00)
		vf = math.Max(vf, 0.01)
		volume = strconv.Itoa(int(127 * vf))
		asScriptIn(`bgm`, alias, asPath, strings.Join([]string{dur, volume}, ","))
	}
	count := 0
	for _, i := range data {
		status, asPath, dur := app.asAnalysisPath("bgm", i[0], i[1])
		if !status {
			continue
		}
		_reg(i[1], asPath, dur, i[2])
		count += 1
	}
	pterm.Info.Println(asTypes["bgm"].Name + " 引入：" + strconv.Itoa(count) + "个")
}

// asVcm 声音 - vcm
func (app *App) asVcm(data [][]string) {
	_reg := func(alias string, asPath string, dur string, volume string) {
		vi, _ := strconv.Atoi(volume)
		vf := float64(vi)
		vf = math.Min(vf, 1.00)
		vf = math.Max(vf, 0.01)
		volume = strconv.Itoa(int(127 * vf))
		asScriptIn(`vcm`, alias, asPath, strings.Join([]string{dur, volume}, ","))
	}
	count := 0
	for _, i := range data {
		status, asPath, dur := app.asAnalysisPath("vcm", i[0], i[1])
		if !status {
			continue
		}
		_reg(i[1], asPath, dur, i[2])
		count += 1
	}
	pterm.Info.Println(asTypes["vcm"].Name + " 引入：" + strconv.Itoa(count) + "个")
}

// asV3d 声音 - v3d
func (app *App) asV3d(data [][]string) {
	_reg := func(alias string, asPath string, dur string, volume string) {
		vi, _ := strconv.Atoi(volume)
		vf := float64(vi)
		vf = math.Min(vf, 1.00)
		vf = math.Max(vf, 0.01)
		volume = strconv.Itoa(int(127 * vf))
		asScriptIn(`v3d`, alias, asPath, strings.Join([]string{dur, volume}, ","))
	}
	count := 0
	for _, i := range data {
		status, asPath, dur := app.asAnalysisPath("v3d", i[0], i[1])
		if !status {
			continue
		}
		_reg(i[1], asPath, dur, i[2])
		count += 1
	}
	pterm.Info.Println(asTypes["v3d"].Name + " 引入：" + strconv.Itoa(count) + "个")
}

// asVVwp 声音 - vwp
func (app *App) asVwp(data []string) {
	count := 0
	for _, yf := range data {
		yf = strings.Replace(yf, ".yaml", "", -1)
		status, _, yamlPath := app.asAnalysisPath("vwp", yf, yf)
		if !status {
			continue
		}
		if yamlPath == "" {
			pterm.Error.Println(asTypes["vwp"].Name + " 配置 " + yf + " 不存在")
			time.Sleep(time.Second)
		} else {
			yd, _ := os.ReadFile(yamlPath)
			var y map[string][]string
			err2 := yaml.Unmarshal(yd, &y)
			if err2 != nil {
				Panic(err2)
			}
			for material, paths := range y {
				var voices []string
				for _, path := range paths {
					status2, asPath, dur := app.asAnalysisPath("vwp-voice", path, path)
					if !status2 {
						continue
					}
					voices = append(voices, `{`+strings.Join([]string{strconv.Quote(asPath), dur}, ",")+`}`)
				}
				asScriptIn(`vwp`, yf+`@`+material, strings.Join(voices, ","), ``)
			}
			asCheckInt[strings.ToLower(yf)]--
			count += 1
		}
	}
	pterm.Info.Println(asTypes["vwp"].Name + " 引入：" + strconv.Itoa(count) + "种配置")
}

// asUI UI套件
func (app *App) asUI(data []string) []string {
	var fdfs []string
	for _, i := range data {
		i2 := strings.Replace(i, "\\", "/", -1)
		uiPath := app.Path.Assets + "/war3mapUI/" + i2
		if fileutil.IsDir(uiPath) {
			uiTips := "【套件】引入：" + i
			mainLua := uiPath + "/main.lua"
			if !fileutil.IsExist(mainLua) {
				pterm.Error.Println("【套件】" + i + " 核心main.lua未定义")
				time.Sleep(time.Second)
			} else {
				fdf := uiPath + "/main.fdf"
				uiTips += `，确认main`
				if fileutil.IsExist(fdf) {
					fdfs = append(fdfs, "UI\\"+strings.Replace(i2, "/", "\\", -1)+".fdf")
					CopyFile(fdf, app.BuildDstPath+"/map/UI/"+i2+".fdf")
					uiTips += `，已引入fdf`
				}
				uiAssets := uiPath + "/assets"
				if fileutil.IsDir(uiAssets) {
					uiASrc, err2 := filepath.Abs(uiAssets)
					if err2 != nil {
						Panic(err2)
					}
					dstDir := app.BuildDstPath + "/resource/war3mapUI/" + i2 + "/assets"
					asRepl := strings.Replace(app.Path.Assets, "/", "\\", -1) + "\\"
					err := filepath.Walk(uiASrc, func(path string, info os.FileInfo, err error) error {
						if err != nil {
							return err
						}
						asName := strings.Replace(path, uiASrc, "", -1)
						dstPath := dstDir + asName
						if !info.IsDir() {
							asName = asName[1:]
							asName = strings.Replace(asName, "\\", "/", -1)
							ext := filepath.Ext(path)
							switch ext {
							case ".blp", ".tga":
								p := strings.Replace(path, "/", "\\", -1)
								p = strings.Replace(p, asRepl, "", -1)
								asScriptIn(`ui`, i, asName, strconv.Quote(p))
							case ".mdx":
								p := strings.Replace(path, "/", "\\", -1)
								p = strings.Replace(p, asRepl, "", -1)
								p = strings.Replace(path, ".mdx", ".mdl", -1)
								asScriptIn(`ui`, i, asName, strconv.Quote(p))
							default:
								pterm.Warning.Println("【套件】不支持资源 " + asName)
							}
							if CopyFile(path, dstPath) {
								return nil
							} else {
								return errors.New(path + " copy failed")
							}
						} else {
							if _, err3 := os.Stat(dstPath); err3 != nil {
								if os.IsNotExist(err3) {
									if err4 := os.MkdirAll(dstPath, fs.ModePerm); err4 != nil {
										return err4
									} else {
										return nil
									}
								} else {
									return err3
								}
							} else {
								return nil
							}
						}
					})
					if err != nil {
						Panic(err)
					}
					uiTips += `，已引入assets`
				}
				// scripts
				if fileutil.IsDir(uiPath + "/scripts") {
					uiScripts, _ := filepath.Abs(uiPath + "/scripts")
					err := filepath.Walk(uiScripts, func(path string, info fs.FileInfo, err error) error {
						if err != nil {
							return err
						}
						if filepath.Ext(path) == ".lua" {
							lc, errl := fileutil.ReadFileToString(path)
							if errl != nil {
								Panic(errl)
							}
							name := luaTrimName(path, app.Path.Assets)
							n := strings.Replace(name, `.`, `/`, -1)
							dst := app.BuildDstPath + "/map/" + n + ".lua"
							code := lc
							luaChipsIn(LuaFile{
								name: name,
								dst:  dst,
								code: code,
								gen:  "_local" != app.BuildModeName,
							})
						}
						return nil
					})
					if err != nil {
						Panic(err)
					}
					uiTips += `，已引入scripts`
				}
				// main
				name := luaTrimName(mainLua, app.Path.Assets)
				n := strings.Replace(name, `.`, `/`, -1)
				dst := app.BuildDstPath + "/map/" + n + ".lua"
				code, err2 := fileutil.ReadFileToString(mainLua)
				if err2 != nil {
					Panic(err2)
				}
				luaChipsIn(LuaFile{
					name: name,
					dst:  dst,
					code: code,
					gen:  "_local" != app.BuildModeName,
				})
			}
			pterm.Info.Println(uiTips)
		} else {
			pterm.Error.Println("【套件】" + i + " 不存在")
			time.Sleep(time.Second)
		}
	}
	return fdfs
}

func (app *App) luaAssets(ga AssetsGo) (string, []string) {
	asChecker = make(map[string][]string)
	asScripts = []string{}
	asModelAlias = make(map[string]string)
	asDetectP = make(map[string]map[string]int)
	asDetectA = make(map[string]map[string]int)
	// selection
	app.asSelection(ga.Selection)
	// terrain
	app.asTerrain(ga.Terrain)
	// font
	app.asFont(ga.Font)
	// loading
	app.asLoading(ga.Loading)
	// preview
	app.asPreview(ga.Preview)
	// image
	app.asImage(ga.Image)
	// model
	app.asModel(ga.Model)
	// bgm
	app.asBGM(ga.Bgm)
	// vcm
	app.asVcm(ga.Vcm)
	// v3d
	app.asV3d(ga.V3d)
	// vwp
	app.asVwp(ga.Vwp)
	// ui
	fdfs := app.asUI(ga.UI)
	return strings.Join(asScripts, "\n"), fdfs
}
