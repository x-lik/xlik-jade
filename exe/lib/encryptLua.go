package cmd

import (
	"github.com/duke-git/lancet/v2/fileutil"
	"github.com/pterm/pterm"
	"github.com/samber/lo"
	"math/rand"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

func (app *App) Abort(content string) {
	content = strings.Replace(content, _spiltSym, ` `, -1)
	_ = fileutil.WriteStringToFile(app.Path.Temp+`/_encrypt/content.lua`, content, false)
	Panic("Abort")
}

// EncryptLua 混淆Lua
func (app *App) EncryptLua(data []LuaFile) {
	// 智能分析混淆
	app.EncryptResults = map[string]map[string]string{
		"汉字":    {},
		"Chaos": {},
		"字符串":   {},
		"数学算术":  {},
		"销毁词根":  {},
		"替换词根":  {},
		"精准函数":  {},
		"用类词根":  {},
		"强制词根":  {},
	}
	spinner, _ := pterm.DefaultSpinner.Start("智能分析启动中...")
	content := codesContent()
	//
	spinner.UpdateText("中文汉字等效分析中...")
	reg := regexp.MustCompile(`[一-龥，。！、（）【】；：“”《》？…]+`)
	mcn := reg.FindAllString(content, -1)
	wcn := make(map[string]int)
	wci := rand.Intn(33) + 3
	var cnParse [][]string
	cnParseUni := make(map[string]bool)
	cnParseKV := make(map[string]string)
	if len(mcn) > 0 {
		for _, s := range mcn {
			sl := MBSplit(s, 1)
			var code []string
			for _, c := range sl {
				if wcn[c] == 0 {
					wcn[c] = wci
					wci = wci + 1 + rand.Intn(11)
					if cnParseKV[c] == "" {
						cnParseKV[c] = `[` + strconv.Itoa(wcn[c]) + `]=` + `'` + c + `'`
					}
				}
				code = append(code, strconv.Itoa(wcn[c]))
			}
			if cnParseUni[s] == false {
				cnParseUni[s] = true
				cnParse = append(cnParse, []string{s, "J.N2C(" + strings.Join(code, ",") + ")"})
			}
		}
	}
	sort.Slice(cnParse, func(i, j int) bool {
		return len(cnParse[i][0]) > len(cnParse[j][0])
	})
	pterm.Info.Println("【混淆】中文汉字分析出 " + strconv.Itoa(len(cnParse)) + " 个预备数据")
	//
	spinner.UpdateText("字串等效分析中...")
	var strParse []string
	reg = regexp.MustCompile(`"[<>@\|0-9A-Za-z._:!,/+\\-]{2,}"`)
	m := reg.FindAllString(content, -1)
	if len(m) > 0 {
		for _, s := range m {
			strParse = append(strParse, s)
		}
	}
	strParse = lo.Uniq[string](strParse)
	pterm.Info.Println("【混淆】字串等效分析出 " + strconv.Itoa(len(strParse)) + " 个预备数据")

	// 中文汉字混淆
	spinner.UpdateText("中文汉字混淆中...")
	chineseBuilder := strings.Builder{}
	for _, p := range cnParse {
		k, v := p[0], p[1]
		c := Zebra(8)
		chineseBuilder.WriteString(c + ` = ` + v + ` `)
		app.EncryptResults["汉字"][k] = c
		content = strings.Replace(content, `"`+k+`"`, c, -1)
		content = strings.Replace(content, ` `+k+` `, ` "..`+c+`.." `, -1)
		content = strings.Replace(content, `"<`+k+`>"`, `"<"..`+c+`..">"`, -1)
		content = strings.Replace(content, `'<`+k+`>'`, `'<'..`+c+`..'>'`, -1)
		content = strings.Replace(content, `<`+k+`>'`, `<"..`+c+`..">`, -1)
		content = strings.Replace(content, `[`+k+`]`, `["..`+c+`.."]`, -1)
		content = strings.Replace(content, `{`+k+`}`, `{"..`+c+`.."}`, -1)
		content = strings.Replace(content, `(`+k+`)`, `("..`+c+`..")`, -1)
		content = strings.Replace(content, `"`+k, c+`.."`, -1)
		content = strings.Replace(content, k+`"`, `"..`+c, -1)
		content = strings.Replace(content, `：`+k, `："..`+c+`.."`, -1)
		content = strings.Replace(content, k+`：`, `"..`+c+`.."：`, -1)
		content = strings.Replace(content, `:`+k, `:"..`+c+`.."`, -1)
		content = strings.Replace(content, k+`:`, `"..`+c+`..":`, -1)
	}
	var parseSetArr []string
	for _, v := range cnParseKV {
		parseSetArr = append(parseSetArr, v)
	}
	content = strings.Replace(content, `LK_N2C = {}`, `LK_N2C = {`+strings.Join(parseSetArr, ",")+`}`, 1)
	content = strings.Replace(content, `LK_ZH = {}`, chineseBuilder.String(), 1)
	pterm.Success.Println("【混淆】中文汉字已混淆 " + strconv.Itoa(len(cnParse)) + " 个数据")

	// 字串混淆
	spinner.UpdateText("双引号字串混淆中...")
	strParseKV := make(map[string]string)
	chao, _ := CharChao()
	for k, v := range chao {
		app.EncryptResults["Chaos"][k] = v
	}
	for _, str := range strParse {
		eky := str[1 : len(str)-1]
		ess := strings.Split(strings.Replace(eky, `\\`, `\`, -1), "")
		for k, e := range ess {
			chae := strings.Split(chao[e], "")
			for x, y := 0, len(chae)-1; x < y; x, y = x+1, y-1 {
				chae[x], chae[y] = chae[y], chae[x]
			}
			ess[k] = strings.Join(chae, "")
		}
		for i, j := 0, len(ess)-1; i < j; i, j = i+1, j-1 {
			ess[i], ess[j] = ess[j], ess[i]
		}
		mysterious := Zebra(22)
		esd := "___('" + mysterious + strings.Join(ess, mysterious) + "')"
		strParseKV[eky] = esd
	}
	strParseKV2 := make(map[string]string)
	strBuilder := strings.Builder{}
	for _, v := range strParseKV {
		strParseKV2[v] = Nano(13)
		strBuilder.WriteString(strParseKV2[v] + ` = ` + v + ` `)
	}
	content = strings.Replace(content, `ENCRYPT_STRING()`, strBuilder.String(), 1)
	for k, v := range strParseKV {
		v2 := strParseKV2[v]
		app.EncryptResults["字符串"][k] = v2
		content = strings.Replace(content, `"`+k+`"`, v2, -1)
	}
	pterm.Success.Println("【混淆】字串混淆已混淆 " + strconv.Itoa(len(strParse)) + " 个数据")

	// 数学繁杂化
	spinner.UpdateText("数学算术异化中...")
	reg = regexp.MustCompile(` ([1-9][0-9]*) `)
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
			app.EncryptResults["数学算术"][k] = v
			content = strings.Replace(content, "= "+k+")", "= "+v+")", -1)
			content = strings.Replace(content, "= "+k+" ", "= "+v+" ", -1)
			content = strings.Replace(content, " "+k+")", " "+v+")", -1)
			content = strings.Replace(content, " "+k+",", " "+v+",", -1)
			content = strings.Replace(content, ", "+k+" ", ", "+v+" ", -1)
			content = strings.Replace(content, ", "+k+")", ", "+v+")", -1)
			content = strings.Replace(content, "("+k+",", "("+v+",", -1)
		}
	}
	pterm.Success.Println("【混淆】数学算术异化已处理 " + strconv.Itoa(len(ns)) + " 个数据")

	spinner.UpdateText("处理词根中...")
	// 删除特定内容
	analysis := app.encryptAnalysis()
	force := analysis[`force`]
	del := analysis[`del`]
	repl := analysis[`repl`]
	fun := analysis[`fun`]
	self := analysis[`self`]
	// del
	for _, w := range del {
		app.EncryptResults["销毁词根"][w] = `(删除)`
		content = strings.Replace(content, w, "", -1)
	}
	pterm.Success.Println("【混淆】销毁词根已处理 " + strconv.Itoa(len(del)) + " 个数据")
	// repl
	wl := 0
	for _, w := range repl {
		wn := NanoOL(Rand(11, 17))
		app.EncryptResults["替换词根"][w] = wn
		content = strings.Replace(content, w, wn, -1)
		wl += 1
	}
	pterm.Success.Println("【混淆】替换词根已处理 " + strconv.Itoa(wl) + " 个数据")
	// fun
	for _, w := range fun {
		wn := NanoOL(Rand(11, 17))
		app.EncryptResults["精准函数"][w] = wn
		reg = regexp.MustCompile(`\b` + w + `\(`)
		content = reg.ReplaceAllString(content, wn+`(`)
	}
	pterm.Success.Println("【混淆】精准函数已处理 " + strconv.Itoa(len(fun)) + " 个数据")
	// self
	for _, w := range self {
		wn := NanoOL(Rand(11, 17))
		app.EncryptResults["用类词根"][w] = wn
		content = strings.Replace(content, `:`+w+`(`, `:`+wn+`(`, -1)
		content = strings.Replace(content, `(_index).`+w+`(self`, `(_index).`+wn+`(self`, -1)
	}
	pterm.Success.Println("【混淆】用类词根已处理 " + strconv.Itoa(len(self)) + " 个数据")
	// force
	for _, w := range force {
		wn := NanoOL(Rand(11, 17))
		app.EncryptResults["强制词根"][w] = wn
		reg = regexp.MustCompile(`\b` + w + `\b`)
		content = reg.ReplaceAllString(content, wn)
	}
	pterm.Success.Println("【混淆】强制词根已处理 " + strconv.Itoa(len(force)) + " 个数据")
	contents := strings.Split(content, _spiltSym)
	for i := range data {
		data[i].code = contents[i]
	}
	spinner.Success("【混淆】合计" + strconv.Itoa(len(data)) + " 段代码已经处理完毕")
}
