package cmd

import (
	"bufio"
	"github.com/duke-git/lancet/v2/fileutil"
	"github.com/samber/lo"
	"gopkg.in/yaml.v3"
	"io"
	"io/fs"
	"os"
	"regexp"
	"strings"
)

var war3sound map[string]int
var war3soundNil map[string]bool

func init() {
	data, _ := Embeds.ReadFile("embeds/war3sounds.yaml")
	y := map[string][]YamlSound{}
	err2 := yaml.Unmarshal(data, &y)
	if err2 != nil {
		Panic(err2)
	}
	war3sound = make(map[string]int)
	war3soundNil = make(map[string]bool)
	for _, v := range y["sounds"] {
		war3sound[v.Path] = v.Duration
		war3soundNil[v.Path] = true
	}
}

// War3soundDur 获取war原生音频资源持续时间（毫秒），没有找到音频则返回-1
func War3soundDur(src string) int {
	if !war3soundNil[src] {
		return -1
	}
	return war3sound[src]
}

// War3map 处理 war3map.j 文件
func (app *App) War3map() {
	luaCoreName := ``
	if app.BuildModeName == "_release" {
		luaCoreName = app.luaRelease()
	} else {
		luaCoreName = app.luaDev()
	}
	if app.BuildModeName != "_release" {
		war3mapJass := app.BuildDstPath + "/map/war3map.j"
		if fileutil.IsExist(war3mapJass) {
			var war3mapContentBuilder strings.Builder
			jassFile, err := os.OpenFile(war3mapJass, os.O_RDONLY, 0666)
			defer jassFile.Close()
			if err != nil {
				Panic(err)
			}
			srcReader := bufio.NewReader(jassFile)
			for {
				str, err2 := srcReader.ReadString('\n')
				if err2 != nil {
					if err2 == io.EOF {
						break
					} else {
						Panic(err2)
					}
				}
				if strings.Trim(str, " ")[0:2] == "//" {
					continue
				}
				if strings.HasSuffix(str, " \r\n") {
					continue
				}
				if strings.HasPrefix(str, "\r\n") {
					continue
				}
				war3mapContentBuilder.WriteString(str)
			}
			war3mapContent := war3mapContentBuilder.String()
			// 处理J
			execGlobals := []string{"unit prevReadToken = null"}
			var execLua []string
			var execCheatSha1 []string

			nLen := 888
			lua := "exec-lua:"
			luas := strings.Split(lua, "")
			for _, v := range luas {
				nn := NanoOL(nLen)
				execGlobals = append(execGlobals, "string "+nn+"=\""+v+"\"")
				execLua = append(execLua, nn)
			}
			sha1s := strings.Split(luaCoreName, "")
			for _, v := range sha1s {
				nn := NanoOL(nLen)
				execGlobals = append(execGlobals, "string "+nn+"=\""+v+"\"")
				execCheatSha1 = append(execCheatSha1, nn)
			}
			gi := 10
			for {
				if gi <= 0 {
					break
				}
				nn := NanoOL(nLen)
				execGlobals = append(execGlobals, "string "+nn+"=\""+CharRand()+"\"")
				gi -= 1
			}

			execGlobals = lo.Shuffle[string](execGlobals)

			reContent := strings.Join(execGlobals, "\r\n") + "\r\nendglobals"
			reg := regexp.MustCompile("endglobals")
			war3mapContent = reg.ReplaceAllString(war3mapContent, reContent)

			reLua := "call Cheat(" + strings.Join(execLua, "+") + "+\"\\\"\"+" + strings.Join(execCheatSha1, "+") + "+\"\\\"\")"
			reContent = "function InitGlobals takes nothing returns nothing\r\n    " + "set prevReadToken = CreateUnit(Player(15),'hfoo',0,0,0)\r\n    " + reLua
			reg = regexp.MustCompile("function InitGlobals takes nothing returns nothing")
			war3mapContent = reg.ReplaceAllString(war3mapContent, reContent)

			// merge
			err = FilePutContents(war3mapJass, war3mapContent, fs.ModePerm)
			if err != nil {
				Panic(err)
			}
		}
	}
}
