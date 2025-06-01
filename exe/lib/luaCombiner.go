package cmd

import (
	"github.com/duke-git/lancet/v2/fileutil"
	"github.com/duke-git/lancet/v2/slice"
	"github.com/pterm/pterm"
	lua "github.com/yuin/gopher-lua"
	"os"
	"path/filepath"
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
	_luaChips         []LuaFile
	_luaContent       string
	_luaFiles         map[string]*LuaFile
	_luaFileSorter    []string
	_luaFileLoopCheck map[string]bool
)

func init() {
	_luaFiles = make(map[string]*LuaFile)
	_luaFileLoopCheck = make(map[string]bool)
}

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
	reg = regexp.MustCompile(`(\w)\s*([.:])\s*(\w)`)
	content = reg.ReplaceAllString(content, "$1$2$3")
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

func (app *App) luaAllContent() string {
	if `` != _luaContent {
		return _luaContent
	}
	// 智能分析混淆
	var builder strings.Builder
	for _, v := range _luaChips {
		builder.WriteString(luaZip(v.code) + ` `)
	}
	_luaContent = builder.String()
	builder.Reset()
	return _luaContent
}

func luaChipsIn(item LuaFile) {
	_luaChips = append(_luaChips, item)
	if `` != _luaContent {
		_luaContent = ``
	}
}

func (app *App) luaFileHandler(path string) {
	// skip handel file
	l := strings.Replace(path, `\`, `/`, -1)
	if _, exists := _luaFiles[l]; exists {
		return
	}
	// skip non-lua file
	if !strings.EqualFold(filepath.Ext(l), ".lua") {
		return
	}
	// code
	code := FileToString(l)
	usePattern := regexp.MustCompile(`---\[\[:use\s+(.+?)\s*]]`)
	matches := usePattern.FindAllStringSubmatch(code, -1)
	if len(matches) > 0 {
		for _, match := range matches {
			useName := strings.Replace(match[1], `\`, `/`, -1)
			usePath := app.Pwd + "/" + useName + ".lua"
			if _, exists := _luaFiles[usePath]; !exists {
				if true == _luaFileLoopCheck[usePath] {
					pterm.Error.Println("存在循环的use:" + useName)
					os.Exit(0)
				}
				_luaFileLoopCheck[usePath] = true
				app.luaFileHandler(usePath)
			}
		}
	}
	// gen
	gen := "_local" != app.BuildModeName || strings.Contains(l, "embeds/")
	// anchor
	anchor := strings.Replace(l, `.lua`, ``, -1)
	if strings.Contains(anchor, `embeds/lua/engine/`) {
		// anchor:handle engine
		anchor = strings.Replace(anchor, `embeds/lua/engine/`, `engine/drive/`, 1)
	} else if strings.Contains(anchor, `embeds/lua/slk/`) {
		// anchor:handle slk
		anchor = strings.Replace(anchor, `embeds/lua/slk/`, `engine/slk/`, 1)
	} else {
		// anchor:handle others
		anchor = strings.Replace(anchor, app.Pwd+"/", "", 1)
	}
	// name
	name := strings.Replace(anchor, `/`, `.`, -1)
	// dst
	dst := app.BuildDstPath + "/map/" + anchor + ".lua"
	_luaFileSorter = append(_luaFileSorter, l)
	_luaFiles[l] = &LuaFile{
		name: name,
		dst:  dst,
		code: code,
		gen:  gen,
	}
}

func (app *App) luaFileToChips() {
	for _, name := range _luaFileSorter {
		luaChipsIn(*_luaFiles[name])
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
	content := app.luaAllContent()
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
	// hook
	l, _ := Embeds.ReadFile("embeds/lua/setup/hook.lua")
	if len(l) > 0 {
		scripts = strings.Replace(scripts, "---lk:placeholder setup:hook", string(l), 1)
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
	content := app.luaAllContent()
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
	// asyncEffects
	isCount = orCount(content, map[string]int{
		"japi.AsyncEffectShow(": 2,
	})
	if isSimplify || isCount {
		l, _ = Embeds.ReadFile("embeds/lua/start/asyncEffects.lua")
		scripts = strings.Replace(scripts, "---lk:placeholder start:asyncEffects", string(l), 1)
	}
	return scripts
}
