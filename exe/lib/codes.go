package cmd

import (
	"github.com/duke-git/lancet/v2/fileutil"
	"github.com/duke-git/lancet/v2/slice"
	"github.com/pterm/pterm"
	lua "github.com/yuin/gopher-lua"
	"regexp"
	"strconv"
	"strings"
)

type LuaFile struct {
	name string
	dst  string
	code string
	gen  bool
}

var (
	_spiltSym     = ` ♬♬♬♬♬♬♬ `
	_codes        []LuaFile
	_codesContent string
)

func luaRequire(L *lua.LState, file string) {
	err := L.DoFile(file)
	if err != nil {
		Panic(err)
	}
}

func luaRequireEmbed(L *lua.LState, file string) {
	s, _ := Embeds.ReadFile(file)
	err := L.DoString(string(s))
	if err != nil {
		Panic(err)
	}
}

func luaRequireStr(s string) string {
	return "require(\"" + s + "\")"
}

func luaZip(src string) string {
	content, err := fileutil.ReadFileToString(src)
	if err != nil {
		content = src
	}
	content = strings.Replace(content, "\r\n", "\n", -1)
	content = strings.Replace(content, "\r", "\n", -1)
	reg := regexp.MustCompile("\\s*--.*\\[\\[[\\s\\S]*?\\]\\]")
	content = reg.ReplaceAllString(content, "")
	reg = regexp.MustCompile("\\s*--.*")
	content = reg.ReplaceAllString(content, "")
	cta := strings.Split(content, "\n")
	var ctn []string
	for _, c := range cta {
		c = strings.Trim(c, " ")
		if len(c) > 0 {
			ctn = append(ctn, c)
		}
	}
	return strings.Join(ctn, " ")
}

func (app *App) luaTrimName(path string, trim string) string {
	trim = strings.Replace(trim, "\\", "/", -1)
	name := strings.Replace(path, "\\", "/", -1)
	name = strings.Replace(name, trim, "", 1)
	name = name[1:]
	name = strings.Replace(name, "/", ".", -1)
	name = strings.Replace(name, ".lua", "", -1)
	return name
}

func slkIni(file string) string {
	content, errIni := fileutil.ReadFileToString(file)
	if errIni != nil {
		return ""
	}
	return content
}

func codesContent() string {
	if `` != _codesContent {
		return _codesContent
	}
	// 智能分析混淆
	var _codesBuilder strings.Builder
	for _, v := range _codes {
		_codesBuilder.WriteString(luaZip(v.code) + _spiltSym)
	}
	_codesContent = _codesBuilder.String()
	_codesBuilder.Reset()
	return _codesContent
}

func codesContentZip() string {
	content := codesContent()
	return luaZip(content)
}

func codesIn(item LuaFile) {
	_codes = append(_codes, item)
	if `` != _codesContent {
		_codesContent = ``
	}
}

// check Count 检测代码中某代码的含量
// 需要存在某个代码大于n即可为true
func orCount(content string, code map[string]int) bool {
	res := false
	for c, n := range code {
		if n <= strings.Count(content, c) {
			res = true
			break
		}
	}
	return res
}

// luaSetup
func (app *App) luaSetup() string {
	openHot := app.BuildModeName == "_local" || app.BuildModeName == "_test" || app.BuildModeName == "_build"
	isSimplify := openHot
	content := codesContentZip()
	var l []byte
	// setup
	x, _ := Embeds.ReadFile("embeds/lua/setup/setup.lua")
	scripts := string(x)
	// hot
	if openHot {
		s, _ := Embeds.ReadFile("embeds/lua/setup/hot.lua")
		if len(s) > 0 {
			scripts = strings.Replace(scripts, "---lk:placeholder setup:hot", string(s), 1)
		}
	}
	// asyncRand
	var asyncRandIn [][]string
	reg := regexp.MustCompile(`japi.AsyncRand\((.+?),(.+?)\)`)
	matches := reg.FindAllStringSubmatch(content, -1)
	if len(matches) > 0 {
		for _, a := range matches {
			a[1] = strings.Trim(a[1], " ")
			a[2] = strings.Trim(a[2], " ")
			_, e1 := strconv.Atoi(a[1])
			_, e2 := strconv.Atoi(a[2])
			if nil == e1 || nil == e2 {
				if a[1] != a[2] {
					asyncRandIn = append(asyncRandIn, []string{a[1], a[2]})
				}
			}
		}
	}
	if len(asyncRandIn) > 0 {
		var randCodes strings.Builder
		for _, ar := range asyncRandIn {
			randCodes.WriteString("LK_ASYNC_RAND(" + ar[0] + "," + ar[1] + ") ")
		}
		l, _ = Embeds.ReadFile("embeds/lua/setup/asyncRand.lua")
		rands := string(l)
		rands = strings.Replace(rands, "---lk:placeholder asyncRand", randCodes.String(), 1)
		scripts = strings.Replace(scripts, "---lk:placeholder setup:asyncRand", rands, 1)
	}
	// mouseLeftClick
	isCount := orCount(content, map[string]int{
		"mouse.onLeftClick(":             2,
		"mouse.onLeftLongPress(":         2,
		":onEvent(eventKind.uiLeftClick": 1,
	})
	if isSimplify || isCount {
		l, _ = Embeds.ReadFile("embeds/lua/setup/mouseLeftClick.lua")
		scripts = strings.Replace(scripts, "---lk:placeholder setup:mouseLeftClick", string(l), 1)
	}
	// mouseLeftRelease
	isCount = orCount(content, map[string]int{
		"mouse.onLeftRelease(":             2,
		"mouse.onLeftLongPress(":           2,
		":onEvent(eventKind.uiLeftRelease": 1,
	})
	if isSimplify || isCount {
		l, _ = Embeds.ReadFile("embeds/lua/setup/mouseLeftRelease.lua")
		scripts = strings.Replace(scripts, "---lk:placeholder setup:mouseLeftRelease", string(l), 1)
	}
	// mouseRightClick
	isCount = orCount(content, map[string]int{
		"mouse.onRightClick(":             2,
		"mouse.onRightLongPress(":         2,
		":onEvent(eventKind.uiRightClick": 1,
	})
	if isSimplify || isCount {
		l, _ = Embeds.ReadFile("embeds/lua/setup/mouseRightClick.lua")
		scripts = strings.Replace(scripts, "---lk:placeholder setup:mouseRightClick", string(l), 1)
	}
	// mouseRightRelease
	isCount = orCount(content, map[string]int{
		"mouse.onRightRelease(":             2,
		"mouse.onRightLongPress(":           2,
		":onEvent(eventKind.uiRightRelease": 1,
	})
	if isSimplify || isCount {
		l, _ = Embeds.ReadFile("embeds/lua/setup/mouseRightRelease.lua")
		scripts = strings.Replace(scripts, "---lk:placeholder setup:mouseRightRelease", string(l), 1)
	}
	// mouseWheel
	isCount = orCount(content, map[string]int{
		"mouse.onWheel(":             2,
		":onEvent(eventKind.uiWheel": 1,
	})
	if isSimplify || isCount {
		l, _ = Embeds.ReadFile("embeds/lua/setup/mouseWheel.lua")
		scripts = strings.Replace(scripts, "---lk:placeholder setup:mouseWheel", string(l), 1)
	}
	// mouseMove
	l, _ = Embeds.ReadFile("embeds/lua/setup/mouseMove.lua")
	scripts = strings.Replace(scripts, "---lk:placeholder setup:mouseMove", string(l), 1)
	// ui - esc
	uiEsc := false
	isCount = orCount(content, map[string]int{
		":esc(true)":  1,
		":esc(false)": 1,
	})
	if isSimplify || isCount {
		uiEsc = true
		l, _ = Embeds.ReadFile("embeds/lua/setup/uiEsc.lua")
		scripts = strings.Replace(scripts, "---lk:placeholder setup:uiEsc", string(l), 1)
	}
	// keyboard - release
	l, _ = Embeds.ReadFile("embeds/lua/setup/keyboard.lua")
	ls := string(l)
	if !isSimplify {
		reg = regexp.MustCompile(`keyboard\.code\[(.*?)\]`)
		matches = reg.FindAllStringSubmatch(content, -1)
		if len(matches) > 0 {
			var keycodes []string
			check := map[string]bool{}
			for _, a := range matches {
				kn := a[1]
				kn = strings.Replace(kn, `'`, `"`, -1)
				if check[kn] != true {
					check[kn] = true
					kn1 := kn[0:1]
					if `'` == kn1 || `"` == kn1 {
						keycodes = append(keycodes, `keyboard.code[`+kn+`]`)
						if kn == `"Esc"` {
							uiEsc = false
						}
					}
				}
			}
			if uiEsc {
				keycodes = append(keycodes, `keyboard.code["Esc"]`)
			}
			keyChunks := slice.Chunk(keycodes, 6)
			for _, c := range keyChunks {
				cs := strings.Join(c, `,`)
				cs = strings.Replace(cs, `keyboard.code["`, "", -1)
				cs = strings.Replace(cs, `"]`, "", -1)
				pterm.Debug.Println("【键码】" + cs)
			}
			n := Zebra(10)
			ls = strings.Replace(ls, "local allKeyboardCodes = keyboard.code", `local `+n+` = {`+strings.Join(keycodes, `,`)+`}`, 1)
			ls = strings.Replace(ls, "for _, kb in pairx(allKeyboardCodes) do", `for _, kb in ipairs(`+n+`) do`, 1)
		}
	}
	scripts = strings.Replace(scripts, "---lk:placeholder setup:keyboard", ls, 1)
	// ui - adaptive
	uiAdaptive := false
	isCount = orCount(content, map[string]int{
		":adaptive(true)":  1,
		":adaptive(false)": 1,
	})
	if isSimplify || isCount {
		uiAdaptive = true
		l, _ = Embeds.ReadFile("embeds/lua/setup/uiAdaptive.lua")
		scripts = strings.Replace(scripts, "---lk:placeholder setup:uiAdaptive", string(l), 1)
	}
	// window - resize
	isCount = orCount(content, map[string]int{
		"window.onResize(": 2,
	})
	if isSimplify || uiAdaptive || isCount {
		l, _ = Embeds.ReadFile("embeds/lua/setup/windowResize.lua")
		scripts = strings.Replace(scripts, "---lk:placeholder setup:windowResize", string(l), 1)
	}
	return scripts
}

// luaStart
func (app *App) luaStart() string {
	isSimplify := app.BuildModeName == "_local"
	content := codesContentZip()
	x, _ := Embeds.ReadFile("embeds/lua/start/start.lua")
	scripts := string(x)
	// cameraEvents
	l, _ := Embeds.ReadFile("embeds/lua/start/cameraEvents.lua")
	scripts = strings.Replace(scripts, "---lk:placeholder start:cameraEvents", string(l), 1)
	// AsyncRefresh
	isCount := orCount(content, map[string]int{
		"japi.AsyncRefresh(": 2,
	})
	if isSimplify || isCount {
		l, _ = Embeds.ReadFile("embeds/lua/start/asyncRefresh.lua")
		scripts = strings.Replace(scripts, "---lk:placeholder start:asyncRefresh", string(l), 1)
	}
	// AsyncExec
	isCount = orCount(content, map[string]int{
		"japi.AsyncExec(": 2,
	})
	if isSimplify || isCount {
		l, _ = Embeds.ReadFile("embeds/lua/start/asyncExec.lua")
		scripts = strings.Replace(scripts, "---lk:placeholder start:asyncExec", string(l), 1)
	}
	// AsyncExecDelay
	isCount = orCount(content, map[string]int{
		"japi.AsyncExecDelay(": 2,
	})
	if isSimplify || isCount {
		l, _ = Embeds.ReadFile("embeds/lua/start/asyncExecDelay.lua")
		scripts = strings.Replace(scripts, "---lk:placeholder start:asyncExecDelay", string(l), 1)
	}
	// zInit
	isCount = orCount(content, map[string]int{
		"japi.Z(": 2,
	})
	if isSimplify || isCount {
		l, _ = Embeds.ReadFile("embeds/lua/start/zInit.lua")
		scripts = strings.Replace(scripts, "---lk:placeholder start:zInit", string(l), 1)
	}
	return scripts
}
