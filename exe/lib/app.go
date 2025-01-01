package cmd

import (
	"embed"
	"github.com/duke-git/lancet/v2/fileutil"
	"github.com/pterm/pterm"
	"gopkg.in/yaml.v3"
	"os"
	"path/filepath"
	"strings"
)

//go:embed embeds
var Embeds embed.FS

type Path struct {
	Logs     string
	Projects string
	Temp     string
	Assets   string
	War3     string
	Library  string
	W3x2lni  string
	WE       string
}

type App struct {
	Args            []string
	Pwd             string
	ProjectName     string
	BuildModeName   string
	BuildDstPath    string
	Path            Path
	EncryptAnalysis map[string][]string
	EncryptResults  map[string]map[string]string
}

// NewApp creates a new App application struct
func NewApp() *App {
	return &App{}
}

func (app *App) absPath(path string) string {
	p1 := strings.Replace(path, "\\", "/", -1)
	p2, _ := filepath.Abs(path)
	p2 = strings.Replace(p2, "\\", "/", -1)
	if p1 != p2 {
		p2, _ = filepath.Abs(app.Pwd + "/" + path)
		p2 = strings.Replace(p2, "\\", "/", -1)
	}
	return p2
}

func (app *App) Init() {
	if app.Pwd == "" {
		envMap := map[string]string{
			"pwd":     "工作路径",
			"war3":    "魔兽1.27版本客户端路径",
			"we":      "WE工具路径",
			"w3x2lni": "w3x2lni工具路径",
			"assets":  "assets资源路径",
		}
		envTxt := func(key string) string {
			return `[` + key + `](` + envMap[key] + `)`
		}
		if !fileutil.IsExist("./env.yaml") {
			CopyFile("embeds/env.yaml", "./env.yaml")
			pterm.Info.Println("请配置<env.yaml>参数" + envTxt("war3"))
			os.Exit(0)
		}
		// 读取env配置客户端及环境
		y := YamlEnv{}
		data, _ := os.ReadFile("./env.yaml")
		err := yaml.Unmarshal(data, &y)
		if err != nil {
			pterm.Error.Println("<env.yaml>文件配置编写格式错误，请检查")
			pterm.Error.Println(err.Error())
			os.Exit(0)
		}
		//pwd
		app.Pwd = y.Pwd
		if app.Pwd == "" {
			app.Pwd, _ = os.Getwd()
		} else {
			if !fileutil.IsExist(y.Pwd + "/env.yaml") {
				pterm.Info.Println("<env.yaml>当前配置参数" + envTxt("pwd") + "无效:'" + y.Pwd + "'")
				os.Exit(0)
			}
		}
		app.Pwd, _ = filepath.Abs(app.Pwd)
		app.Pwd = strings.Replace(app.Pwd, "\\", "/", -1)
		//
		app.Path.Projects = app.Pwd + "/projects"
		app.Path.Logs = app.Pwd + "/logs"
		app.Path.Library = app.Pwd + "/library"
		app.Path.Temp = app.Pwd + "/.tmp"
		// war3
		app.Path.War3 = app.absPath(y.War3)
		if !fileutil.IsExist(app.Path.War3 + "/War3.exe") {
			pterm.Error.Println("<env.yaml>当前配置" + envTxt("war3") + "无效:'" + y.War3 + "'")
			pterm.Info.Println("可前往 https://www.hunzsig.com/download.html 获取war3客户端开发专用版")
			os.Exit(0)
		}
		// check library
		if !fileutil.IsDir(app.Path.Library) {
			pterm.Error.Println("library丢失，已中止运行。")
			os.Exit(0)
		}
		// we
		app.Path.WE = app.absPath(y.We)
		if !fileutil.IsDir(app.Path.WE) {
			pterm.Error.Println("<env.yaml>当前配置" + envTxt("we") + "无效:'" + y.We + "'")
			pterm.Info.Println("可前往 https://github.com/x-lik-vendor 获取工具支持")
			os.Exit(0)
		}
		if !fileutil.IsExist(app.Path.WE + "/bin/WEConfig.exe") {
			pterm.Error.Println("<env.yaml>当前配置" + envTxt("we") + "无效:'" + y.We + "'")
			pterm.Info.Println("可前往 https://github.com/x-lik-vendor 获取工具支持")
			os.Exit(0)
		}
		// w3x2lni
		app.Path.W3x2lni = app.absPath(y.W3x2lni)
		if !fileutil.IsDir(app.Path.W3x2lni) {
			pterm.Error.Println("<env.yaml>当前配置" + envTxt("w3x2lni") + "无效:'" + y.W3x2lni + "'")
			pterm.Info.Println("可前往 https://github.com/x-lik-vendor 获取工具支持")
			os.Exit(0)
		}
		// assets
		app.Path.Assets = app.absPath(y.Assets)
		if !fileutil.IsDir(app.Path.Assets) {
			pterm.Error.Println("<env.yaml>当前配置" + envTxt("assets") + "无效:'" + y.Assets + "'")
			pterm.Info.Println("可前往 https://github.com/x-lik-vendor 获取工具支持")
			os.Exit(0)
		}
	}
	app.Args = os.Args
	if len(app.Args) >= 3 {
		app.ProjectName = app.Args[2]
	} else {
		app.ProjectName = ""
	}
}

func (app *App) isExistPr() bool {
	return fileutil.IsDir(app.Path.Projects + "/" + app.ProjectName)
}

func (app *App) guessPr() {
	if !fileutil.IsDir(app.Path.Projects + "/" + app.ProjectName) {
		var matchPr []string
		files, err := os.ReadDir(app.Path.Projects)
		if nil == err {
			lp := len(app.ProjectName)
			for _, v := range files {
				if v.IsDir() {
					name := v.Name()
					if len(name) >= lp && name[0:lp] == app.ProjectName {
						matchPr = append(matchPr, name)
					}
				}
			}
		}
		l := len(matchPr)
		if l > 1 {
			pterm.Warning.Println("项目名无法模糊匹配多个：" + strings.Join(matchPr, `,`))
		} else if l == 1 {
			pterm.Warning.Println("项目名模糊匹配：" + app.ProjectName + ` to ` + matchPr[0])
			app.ProjectName = matchPr[0]
		}
	}
}
