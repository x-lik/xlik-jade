package cmd

import (
	"github.com/duke-git/lancet/v2/fileutil"
	"github.com/pterm/pterm"
	"github.com/samber/lo"
	"gopkg.in/yaml.v3"
	"math/rand"
	"os"
	"path/filepath"
	"reflect"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

var (
	_holderData map[string]string
	_analysis   map[string][]string
	_results    map[string]map[string]string
)

func init() {
	_holderData = map[string]string{
		`<?l?>`: `local`,
	}
	_results = map[string]map[string]string{
		"规则词根删除": {},
		"规则词根替换": {},
		"规则函数替换": {},
		"规则用类替换": {},
		"规则强制替换": {},
		"字符串":    {},
		"数字":     {},
	}
}

func EncryptPrintResult() {
	for k, v := range _results {
		pterm.Info.Println(`【混淆】已处理` + k + `合计 ` + strconv.Itoa(len(v)) + ` 个`)
	}
}

// Encrypt2Csv csv测试文件
func Encrypt2Csv(dstDir string, filename string) {
	dstDir = strings.Replace(dstDir, `\`, `/`, -1)
	FileCheck(dstDir)
	csvFile := dstDir + `/` + filename + `.csv`
	_ = os.Remove(csvFile)
	_ = fileutil.WriteStringToFile(csvFile, CsvMapSSS(_results), false)
}

// 处理规则
func (app *App) encryptRules(content string) string {
	// analysis
	if reflect.ValueOf(_analysis).IsNil() {
		_analysis = map[string][]string{
			// [规则提取]强行整词的串替换 [对应library.yaml::encrypt::forces]（安全性高，替换性能低，量不宜太大）
			`force`: {},
			// [规则提取]删除（规则与文件内容无关，写的什么就删除什么，安全性高，替换性能高，量小）
			`del`: {},
			// [规则提取]正则快速替换（安全性低，替换性能高但，量很大）
			`repl`: {`math.sin`, `math.cos`, `math.tan`, `math.asin`, `math.acos`, `math.atan`},
			// [规则提取]专用于函数方法替换（安全性高，替换性能中，量小）
			`fun`: {},
			// [规则提取]专用于替换self冒号方法替换（安全性高，替换性能高，量小）
			`self`: {},
		}
		// 按规则整合：销毁、替换 [对应library..yaml::encrypt::rules]
		var encryptRules []map[string]string
		// self规则提取禁止数据，这些词不会被匹配到
		selfBan := make(map[string]bool)
		banList := []string{
			// _index
			`construct`, `destruct`,
			// string
			`byte`, `find`, `format`, `gmatch`, `gsub`, `len`, `lower`, `match`,
			`pack`, `packsize`, `rep`, `reverse`, `sub`, `unpack`, `upper`,
			// io
			`close`, `flush`, `lines`, `read`, `seek`, `setvbuf`, `write`,
		}
		for _, b := range banList {
			selfBan[b] = true
		}
		// 处理rules,处理单个lua文件匹配内容
		replLua := func(f string, rule map[string]string) {
			cont := ""
			if 0 == strings.Index(f, "embeds/") {
				b, err := Embeds.ReadFile(f)
				if err != nil {
					Panic(err)
				}
				cont = string(b)
			} else {
				b, err := fileutil.ReadFileToString(f)
				if err != nil {
					Panic(err)
				}
				cont = b
			}
			for _, v := range []string{`repl`, `fun`, `self`} {
				if rule[v] != `` {
					rep := strings.Split(rule[v], `|`)
					for _, re := range rep {
						reg := regexp.MustCompile(`(?m)` + re)
						match := reg.FindAllStringSubmatch(cont, -1)
						for _, m := range match {
							if v == `self` && selfBan[m[1]] == true {
								continue
							}
							_analysis[v] = append(_analysis[v], m[1])
						}
					}
				}
			}
		}
		//
		replLua("embeds/lua/engine/blizzard.lua", map[string]string{`repl`: "^(\\w+) = "})
		replLua("embeds/lua/engine/engine.lua", map[string]string{`repl`: "^(J\\.\\w+) = "})
		_analysis[`del`] = append(_analysis[`del`], `J = {}`)
		replLua("embeds/lua/engine/pairx.lua", map[string]string{`repl`: "^function (pairx)\\("})
		replLua("embeds/lua/engine/promise.lua", map[string]string{`repl`: "^function (promise)\\("})
		replLua("embeds/lua/engine/mapping.lua", map[string]string{`repl`: "^function (\\w+)\\("})
		replLua("embeds/lua/engine/typeof.lua", map[string]string{`repl`: "^function (typeof)\\("})
		replLua("embeds/lua/slk/assets.lua", map[string]string{`repl`: "^function (\\w+)\\("})
		replLua("embeds/lua/slk/slk.lua", map[string]string{`repl`: "^function (\\w+)\\("})
		// 读取encrypt配置数据
		// 包含main、sub、plugins三个目录配置
		// path 类型，指该内容会被正则找出匹配值并替换
		yamlFiles := []string{
			// 处理 main library encrypt
			app.Path.Library + `/library.yaml`,
			// 处理 sub library encrypt
			app.Path.Projects + `/` + app.ProjectName + `/library/library.yaml`,
		}
		for _, f := range yamlFiles {
			if fileutil.IsExist(f) {
				data, _ := os.ReadFile(f)
				y := YamlLibrary{}
				err := yaml.Unmarshal(data, &y)
				if nil == err {
					_analysis[`force`] = append(_analysis[`force`], y.Encrypt.Forces...)
					encryptRules = append(encryptRules, y.Encrypt.Rules...)
				}
			}
		}
		// 找出所有LK_开头的框架变量
		// 添加到force组中
		reg := regexp.MustCompile(`\bLK_[A-Z0-9_]+\b`)
		match := reg.FindAllStringSubmatch(app.luaAllContent(), -1)
		for _, m := range match {
			_analysis[`force`] = append(_analysis[`force`], m[0])
		}
		// force重复消除
		_analysis[`force`] = lo.Uniq[string](_analysis[`force`])
		sort.Sort(sort.Reverse(sort.StringSlice(_analysis[`force`])))
		// 分析rules
		for _, rule := range encryptRules {
			// del 类型，指该内容会被删除
			if rule[`del`] != `` {
				_analysis[`del`] = append(_analysis[`del`], strings.Split(rule[`del`], `|`)...)
			}
			// path 类型，指该内容会被正则找出匹配值并替换
			paths := []string{
				// 处理 main library
				app.Path.Library + `/` + rule[`path`],
				// 同根处理 sub library
				app.Path.Projects + `/` + app.ProjectName + `/library/` + rule[`path`],
			}
			for _, path := range paths {
				// 检测path是lua文件类型还是目录类型
				// 目录类型则对里面所有lua文件做同一个规则处理
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
		// repl反向排序
		sort.Slice(_analysis[`repl`], func(i, j int) bool {
			l1 := len(_analysis[`repl`])
			l2 := len(_analysis[`repl`])
			if l1 > l2 {
				return true
			}
			if l1 == l2 {
				return _analysis[`repl`][i] > _analysis[`repl`][j]
			}
			return false
		})
		// self重复消除
		_analysis[`self`] = lo.Uniq[string](_analysis[`self`])
	}
	// 删除特定内容
	force := _analysis[`force`]
	del := _analysis[`del`]
	repl := _analysis[`repl`]
	fun := _analysis[`fun`]
	self := _analysis[`self`]
	// del
	for _, w := range del {
		if `` == _results["规则词根删除"][w] {
			_results["规则词根删除"][w] = `-删除-`
		}
		content = strings.Replace(content, w, ``, -1)
	}
	// repl
	wl := 0
	for _, w := range repl {
		wn := _results["规则词根替换"][w]
		if `` == wn {
			wn = NanoOL(Rand(7, 11))
			_results["规则词根替换"][w] = wn
		}
		content = strings.Replace(content, w, wn, -1)
		wl += 1
	}
	// fun
	for _, w := range fun {
		wn := _results["规则函数替换"][w]
		if `` == wn {
			wn = NanoOL(Rand(7, 11))
			_results["规则函数替换"][w] = wn
		}
		reg := regexp.MustCompile(`\b` + w + `\(`)
		content = reg.ReplaceAllString(content, wn+`(`)
	}
	// self
	for _, w := range self {
		wn := _results["规则用类替换"][w]
		if `` == wn {
			wn = NanoOL(Rand(7, 11))
			_results["规则用类替换"][w] = wn
		}
		content = strings.Replace(content, `:`+w+`(`, `:`+wn+`(`, -1)
		content = strings.Replace(content, `(_index).`+w+`(self`, `(_index).`+wn+`(self`, -1)
	}
	// force
	for _, w := range force {
		wn := _results["规则强制替换"][w]
		if `` == wn {
			wn = NanoOL(Rand(7, 11))
			_results["规则强制替换"][w] = wn
		}
		reg := regexp.MustCompile(`\b` + w + `\b`)
		content = reg.ReplaceAllString(content, wn)
	}
	return content
}

// 处理字符串
func (app *App) encryptString(content string) string {
	_holderData[`<?s?>`] = Zebra(6)
	strMap := make(map[string]int)
	var strArr []string
	// 正则表达式，用于匹配各种格式的字符串
	reg := regexp.MustCompile(`"(?:[^"\\]|\\.)*"|'(?:[^'\\]|\\.)*'|(\[=*\[)([\s\S]*?)(\]=*\])`)
	content = reg.ReplaceAllStringFunc(content, func(s string) string {
		var ts string
		if `"` == s[0:1] {
			ts = s[1 : len(s)-1]
		} else if `'` == s[0:1] {
			ts = strings.Replace(s[1:len(s)-1], `"`, `\"`, -1)
		} else if `[[` == s[0:2] {
			ts = strings.Replace(s[2:len(s)-2], `"`, `\"`, -1)
		} else if `[=[` == s[0:3] {
			ts = strings.Replace(s[3:len(s)-3], `"`, `\"`, -1)
		}
		if len(ts) == 0 {
			return `''`
		}
		ts = strings.Replace(ts, `\'`, `'`, -1)
		ts = `"` + ts + `"`
		_, err := strconv.Unquote(ts)
		if err != nil {
			return s
		}
		_, exists := strMap[ts]
		if !exists {
			strArr = append(strArr, ts)
			idx := len(strArr)
			strMap[ts] = idx
			idxs := strconv.Itoa(idx)
			_results["字符串"][s] = `[str:` + idxs + `]`
			return `<?s?>[` + idxs + `]`
		} else {
			return `<?s?>[` + strconv.Itoa(strMap[ts]) + `]`
		}
	})
	_holderData[`<?ss?>`] = strings.Join(strArr, `,`)
	content = `<?l?> <?s?>` + ` = {<?ss?>} ` + content
	return content
}

// 处理数字
func (app *App) encryptDigital(content string) string {
	reg := regexp.MustCompile(` ([1-9][0-9]*) `)
	nu := reg.FindAllStringSubmatch(content, -1)
	var ns []int
	for _, n := range nu {
		if len(n) == 2 {
			ni, err2 := strconv.Atoi(n[1])
			if nil == err2 {
				ns = append(ns, ni)
			}
		}
	}
	ns = lo.Uniq[int](ns)
	sort.Slice(ns, func(i, j int) bool {
		return ns[i] > ns[j]
	})
	nums := make(map[string]string)
	for _, n := range ns {
		r := rand.Intn(100)
		r1 := 7 + rand.Intn(9999)
		r2 := -1 * (7 + rand.Intn(9999))
		var vs string
		if r < 50 {
			vs = strconv.Itoa(n+r1-r2) + " + " + strconv.Itoa(r2) + " - " + strconv.Itoa(r1)
		} else {
			vs = strconv.Itoa(n+r2-r1) + " + " + strconv.Itoa(r1) + " - " + strconv.Itoa(r2)
		}
		k := strconv.Itoa(n)
		nums[k] = `(` + vs + `)`
	}
	for _, n := range ns {
		k := strconv.Itoa(n)
		if nums[k] != "" {
			v := nums[k]
			_results["数字"][k] = v
			content = strings.Replace(content, "= "+k+")", "= "+v+")", -1)
			content = strings.Replace(content, "= "+k+" ", "= "+v+" ", -1)
			content = strings.Replace(content, " "+k+")", " "+v+")", -1)
			content = strings.Replace(content, " "+k+",", " "+v+",", -1)
			content = strings.Replace(content, ", "+k+" ", ", "+v+" ", -1)
			content = strings.Replace(content, ", "+k+")", ", "+v+")", -1)
			content = strings.Replace(content, "("+k+",", "("+v+",", -1)
		}
	}
	return content
}

// EncryptOne 混淆Lua
// Lua Code Obfuscation Feature Supplement
//
// Obfuscating Lua code enhances security by making it harder to understand and reverse - engineer.
// Due to limited support and low revenue, and to safeguard users' code security, the obfuscation function isn't open.
// However, we offer techniques for users to implement on their own.
//
// The framework extracts all strings from Lua code, which provides a convenient basis for users to perform string obfuscation according to their needs.
// It also offers fully open - sourced YAML - based obfuscation rules and a simple integer obfuscation method.
//
// Users can customize the obfuscation process with the following techniques:
// 1. String: Encode (e.g., Base64) and decode at runtime; split and concatenate strings.
// 2. Number: Store in variables and perform operations on them.
// 3. Function: Rename to meaningless names and wrap functions.
// 4. Parameter: Rename to meaningless names.
//
// Applying these techniques can improve code security against reverse - engineering attempts.
func (app *App) EncryptOne(content string) string {
	content = app.encryptString(content)  // 字符串
	content = luaZip(content)             // 压缩
	content = app.encryptRules(content)   // 规则系
	content = app.encryptDigital(content) // 数字
	// 反转替换
	for k, v := range _holderData {
		content = strings.Replace(content, k, v, -1)
	}
	return content
}

func (app *App) EncryptChips(chips []LuaFile) {
	spinner, _ := pterm.DefaultSpinner.Start(`【混淆】准备中...`)
	for i, v := range chips {
		spinner.UpdateText(`【混淆】处理 ` + v.name)
		chips[i].code = app.EncryptOne(v.code)
	}
	EncryptPrintResult()
	Encrypt2Csv(app.Path.Temp+`/_encrypt`, app.ProjectName+app.BuildModeName)
	spinner.Success(`【混淆】全部处理已完成`)
}
