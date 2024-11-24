package cmd

import (
	"github.com/duke-git/lancet/v2/fileutil"
	"github.com/samber/lo"
	"gopkg.in/yaml.v3"
	"os"
	"path/filepath"
	"reflect"
	"regexp"
	"sort"
	"strings"
)

func (app *App) encryptAnalysis() map[string][]string {
	if reflect.ValueOf(app.EncryptAnalysis).IsNil() {
		app.EncryptAnalysis = map[string][]string{
			`force`: {},
			`del`:   {},
			`repl`:  {`math.sin`, `math.cos`, `math.tan`, `math.asin`, `math.acos`, `math.atan`},
			`fun`:   {},
			`self`:  {},
		}
		var encryptRules []map[string]string
		selfBan := make(map[string]bool)
		banList := []string{`construct`, `destruct`}
		for _, b := range banList {
			selfBan[b] = true
		}
		replLua := func(f string, rule map[string]string) {
			content := ""
			if 0 == strings.Index(f, "embeds/") {
				b, err := Embeds.ReadFile(f)
				if err != nil {
					Panic(err)
				}
				content = string(b)
			} else {
				b, err := fileutil.ReadFileToString(f)
				if err != nil {
					Panic(err)
				}
				content = b
			}
			for _, v := range []string{`repl`, `fun`, `self`} {
				if rule[v] != `` {
					rep := strings.Split(rule[v], `|`)
					for _, re := range rep {
						reg, _ := regexp.Compile(`(?m)` + re)
						match := reg.FindAllStringSubmatch(content, -1)
						for _, m := range match {
							if v == `self` && selfBan[m[1]] == true {
								continue
							}
							app.EncryptAnalysis[v] = append(app.EncryptAnalysis[v], m[1])
						}
					}
				}
			}
		}
		replLua("embeds/lua/engine/blizzard.lua", map[string]string{`repl`: "^(\\w+) = "})
		replLua("embeds/lua/engine/engine.lua", map[string]string{`repl`: "^(J\\.\\w+) = "})
		app.EncryptAnalysis[`del`] = append(app.EncryptAnalysis[`del`], `J = {}`)
		replLua("embeds/lua/engine/pairx.lua", map[string]string{`repl`: "^function (pairx)\\("})
		replLua("embeds/lua/slk/slk.lua", map[string]string{`repl`: "^function (\\w+)\\("})
		encryptFiles := []string{
			app.Path.Library + `/encrypt.yaml`,
			app.Path.Projects + `/` + app.ProjectName + `/library/encrypt.yaml`,
		}
		for _, f := range encryptFiles {
			if fileutil.IsExist(f) {
				data, _ := os.ReadFile(f)
				y := YamlEncrypt{}
				err := yaml.Unmarshal(data, &y)
				if nil == err {
					app.EncryptAnalysis[`force`] = append(app.EncryptAnalysis[`force`], y.Forces...)
					encryptRules = append(encryptRules, y.Rules...)
				}
			}
		}
		reg, _ := regexp.Compile(`\bLK_[A-Z0-9_]+\b`)
		match := reg.FindAllStringSubmatch(codesContent(), -1)
		for _, m := range match {
			app.EncryptAnalysis[`force`] = append(app.EncryptAnalysis[`force`], m[0])
		}
		app.EncryptAnalysis[`force`] = lo.Uniq[string](app.EncryptAnalysis[`force`])
		sort.Sort(sort.Reverse(sort.StringSlice(app.EncryptAnalysis[`force`])))
		for _, rule := range encryptRules {
			if rule[`del`] != `` {
				app.EncryptAnalysis[`del`] = append(app.EncryptAnalysis[`del`], strings.Split(rule[`del`], `|`)...)
			}
			paths := []string{
				app.Path.Library + `/` + rule[`path`],
				app.Path.Projects + `/` + app.ProjectName + `/library/` + rule[`path`],
			}
			for _, path := range paths {
				if fileutil.IsDir(path) {
					err := filepath.Walk(path, func(p string, info os.FileInfo, err error) error {
						if err != nil {
							return err
						}
						if filepath.Ext(p) == ".lua" {
							replLua(p, rule)
						}
						return nil
					})
					if err != nil {
						Panic(err)
					}
				} else if fileutil.IsExist(path + `.lua`) {
					replLua(path+`.lua`, rule)
				}
			}
		}
		sort.Slice(app.EncryptAnalysis[`repl`], func(i, j int) bool {
			l1 := len(app.EncryptAnalysis[`repl`])
			l2 := len(app.EncryptAnalysis[`repl`])
			if l1 > l2 {
				return true
			}
			if l1 == l2 {
				return app.EncryptAnalysis[`repl`][i] > app.EncryptAnalysis[`repl`][j]
			}
			return false
		})
		app.EncryptAnalysis[`self`] = lo.Uniq[string](app.EncryptAnalysis[`self`])
	}
	return app.EncryptAnalysis
}
