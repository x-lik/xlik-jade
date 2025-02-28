package cmd

import (
	"encoding/json"
	"fmt"
	"github.com/duke-git/lancet/v2/fileutil"
	"github.com/pterm/pterm"
	lua "github.com/yuin/gopher-lua"
	"gopkg.in/yaml.v3"
	"io/fs"
	"os"
	"path/filepath"
	"reflect"
	"regexp"
	"strconv"
	"strings"
)

func (app *App) luaDev() string {
	var err error
	pterm.Debug.Println("请稍候...")
	//
	var coreScripts []string
	// coreScripts初始化
	if app.BuildModeName == "_local" {
		coreScripts = append(coreScripts, "package.path = package.path .. \";"+strings.Replace(app.Path.Assets, "\\", "/", -1)+"/?.lua\"")
		coreScripts = append(coreScripts, "package.path = package.path .. \";"+strings.Replace(app.Pwd, "\\", "/", -1)+"/?.lua\"")
	}
	// 外置 lua引擎
	L := lua.NewState()
	defer L.Close()
	luaRequireEmbed(L, "embeds/lua/go/driver.lua")
	luaRequireEmbed(L, "embeds/lua/go/json.lua")
	luaRequireEmbed(L, "embeds/lua/go/comm.lua")
	luaRequireEmbed(L, "embeds/lua/go/slk.lua")
	luaRequireEmbed(L, "embeds/lua/go/assets.lua")
	luaRequireEmbed(L, "embeds/lua/go/system.lua")
	// lua - core1
	_idxPt := make(map[string]int)
	cores := []string{"engine", "debug"}
	if app.BuildModeName == "_dist" {
		cores = append(cores, "debugRelease")
	}
	cores = append(cores, []string{"promise", "pairx", "blizzard", "setting"}...)
	for i, v := range cores {
		dst := app.BuildDstPath + "/map/engine/" + v + ".lua"
		x, _ := Embeds.ReadFile("embeds/lua/engine/" + v + ".lua")
		code := string(x)
		m := LuaFile{
			name: "engine." + v,
			dst:  dst,
			code: code,
			gen:  true,
		}
		luaChipsIn(m)
		// 记录以下后续需要用到的索引
		if v == `blizzard` || v == `setting` || v == `debug` || v == `debugRelease` {
			_idxPt[v] = i
		}
	}

	//-------------- library ---------------

	var libSortMain []string
	yamlFile := app.Path.Library + `/library.yaml`
	if fileutil.IsExist(yamlFile) {
		data, _ := os.ReadFile(yamlFile)
		y := YamlLibrary{}
		erry := yaml.Unmarshal(data, &y)
		if nil == erry {
			libSortMain = y.Require
		}
	}
	var librarySrc []string
	if len(libSortMain) == 0 {
		librarySrc = append(librarySrc, app.Path.Library)
	} else {
		for _, n := range libSortMain {
			p := app.Path.Library + `/` + n
			if fileutil.IsDir(p) {
				librarySrc = append(librarySrc, p)
			}
		}
	}
	var libSortSub []string
	subRoot := app.Path.Projects + "/" + app.ProjectName + `/library`
	yamlFile = subRoot + `/library.yaml`
	if fileutil.IsExist(yamlFile) {
		data, _ := os.ReadFile(yamlFile)
		y := YamlLibrary{}
		erry := yaml.Unmarshal(data, &y)
		if nil == erry {
			libSortSub = y.Require
		}
	}
	if len(libSortSub) == 0 {
		librarySrc = append(librarySrc, subRoot)
	} else {
		for _, n := range libSortSub {
			p := subRoot + `/` + n
			if fileutil.IsDir(p) {
				librarySrc = append(librarySrc, p)
			}
		}
	}
	for _, src := range librarySrc {
		err = filepath.Walk(src, func(path string, info fs.FileInfo, err error) error {
			if err != nil {
				return err
			}
			if filepath.Ext(path) == ".lua" {
				code, err2 := fileutil.ReadFileToString(path)
				if err2 != nil {
					Panic(err2)
				}
				isGen := "_local" != app.BuildModeName
				name := luaTrimName(path, app.Pwd)
				dst := ""
				if isGen {
					ns := strings.Split(name, ".")
					if ns[1] == app.ProjectName {
						// 处理 project 内 library
						n3 := strings.Join(ns[0:3], ".")
						name = strings.Replace(name, n3, "librpro", 1)
					}
					n := strings.Replace(name, `.`, `/`, -1)
					dst = app.BuildDstPath + "/map/" + n + ".lua"
				}
				luaChipsIn(LuaFile{
					name: name,
					dst:  dst,
					code: code,
					gen:  isGen,
				})
			}
			return nil
		})
		if err != nil {
			Panic(err)
		}
	}

	// lua - core2
	cores = []string{"slk", "assets", "system", "ids"}
	for _, v := range cores {
		dst := app.BuildDstPath + "/map/projects/" + v + ".lua"
		x, _ := Embeds.ReadFile("embeds/lua/slk/" + v + ".lua")
		code := string(x)
		luaChipsIn(LuaFile{
			name: "projects." + v,
			dst:  dst,
			code: code,
			gen:  true,
		})
	}

	//-------------- assets ---------------

	// lni - UI
	CopyPath("embeds/lni/assets/UI", app.BuildDstPath+"/map/UI")

	// 加载 项目 assets
	assetsDir, _ := filepath.Abs(app.Path.Projects + "/" + app.ProjectName + "/assets")
	hasAssets := fileutil.IsDir(assetsDir)
	if hasAssets {
		err = filepath.Walk(assetsDir, func(path string, info fs.FileInfo, err error) error {
			if err != nil {
				return err
			}
			if filepath.Ext(path) == ".lua" {
				luaRequire(L, path)
				name := luaTrimName(path, app.Pwd)
				n := strings.Replace(name, `.`, `/`, -1)
				dst := app.BuildDstPath + "/map/" + n + ".lua"
				code, err2 := fileutil.ReadFileToString(path)
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
			return nil
		})
		if err != nil {
			Panic(err)
		}
	}

	// assets文件处理
	fn := L.GetGlobal("GO_ASSETS_ALL")
	if err = L.CallByParam(lua.P{Fn: fn, NRet: 1, Protect: true}); err != nil {
		Panic(err)
	}
	var ga AssetsGo
	err = json.Unmarshal([]byte(L.ToString(-1)), &ga)
	if err != nil {
		Panic(err)
	}
	asCodes, asFdfs := app.luaAssets(ga)

	//-------------- SLK ----------------

	// 加载 项目 slk
	slkDir, _ := filepath.Abs(app.Path.Projects + "/" + app.ProjectName + "/slk")
	hasSlk := fileutil.IsDir(slkDir)
	if hasSlk {
		err = filepath.Walk(slkDir, func(path string, info fs.FileInfo, err error) error {
			if err != nil {
				return err
			}
			if filepath.Ext(path) == ".lua" {
				luaRequire(L, path)
				name := luaTrimName(path, app.Pwd)
				n := strings.Replace(name, `.`, `/`, -1)
				dst := app.BuildDstPath + "/map/" + n + ".lua"
				code, err2 := fileutil.ReadFileToString(path)
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
			return nil
		})
		if err != nil {
			Panic(err)
		}
	}
	//
	fn = L.GetGlobal("GO_SLK_ALL")
	if err = L.CallByParam(lua.P{Fn: fn, NRet: 1, Protect: true}); err != nil {
		Panic(err)
	}
	// get lua function results
	slkData := L.ToString(-1)
	var slData []map[string]interface{}
	err = json.Unmarshal([]byte(slkData), &slData)
	if err != nil {
		Panic(err)
	}
	// 拼接 slk ini
	iniKeys := []string{"ability", "unit", "item", "destructable", "doodad", "buff", "upgrade"}
	iniF6 := make(map[string]string)
	reg := regexp.MustCompile("\\[[A-Za-z][A-Za-z\\d]{3}]")
	var idIni []string
	for _, k := range iniKeys {
		conIni, errIni := fileutil.ReadFileToString(app.BuildDstPath + "/table/" + k + ".ini")
		if errIni != nil {
			conIni = ""
		}
		iniF6[k] = conIni
		matches := reg.FindAllString(iniF6[k], -1)
		for _, v := range matches {
			v = strings.Replace(v, "[", "", 1)
			v = strings.Replace(v, "]", "", 1)
			idIni = append(idIni, v)
		}
	}
	idIniByte, _ := json.Marshal(idIni)
	fn = L.GetGlobal("GO_SLK_INI")
	if err = L.CallByParam(lua.P{
		Fn:      fn,
		NRet:    0,
		Protect: true,
	}, lua.LString(idIniByte)); err != nil {
		Panic(err)
	}
	slkIniBuilder := make(map[string]*strings.Builder)
	for _, k := range iniKeys {
		slkIniBuilder[k] = &strings.Builder{}
	}
	var slkIdCli []string
	for _, sda := range slData {
		_slk := make(map[string]string)
		_hash := make(map[string]interface{})
		_id := ""
		_parent := ""
		for key, val := range sda {
			if key[:1] == "_" {
				_hash[key] = val
				if key == "_id" {
					switch v := val.(type) {
					case string:
						_id = v
					}
				} else if key == "_parent" {
					switch v := val.(type) {
					case string:
						_parent = "\"" + strings.Replace(v, "\\", "\\\\", -1) + "\""
					}
				}
			} else {
				var newVal string
				v := reflect.ValueOf(val)
				valType := reflect.TypeOf(val).Kind()
				switch valType {
				case reflect.String:
					newVal = "\"" + strings.Replace(v.String(), "\\", "\\\\", -1) + "\""
				case reflect.Int, reflect.Int8, reflect.Int16, reflect.Int32, reflect.Int64,
					reflect.Uint, reflect.Uint8, reflect.Uint16, reflect.Uint32, reflect.Uint64:
					newVal = strconv.FormatInt(v.Int(), 10)
				case reflect.Float32, reflect.Float64:
					d := fmt.Sprintf("%v", v)
					if -1 == strings.Index(d, ".") {
						newVal = strconv.FormatInt(int64(v.Float()), 10)
					} else {
						newVal = strconv.FormatFloat(v.Float(), 'f', 2, 64)
					}
				case reflect.Slice, reflect.Array:
					newVal = "{"
					for i := 0; i < v.Len(); i++ {
						var n string
						vv := v.Index(i)
						ve := vv.Elem()
						d := fmt.Sprintf("%v", vv)
						switch ve.Kind() {
						case reflect.String:
							n = "\"" + d + "\""
						case reflect.Float64:
							if -1 == strings.Index(d, ".") {
								n = strconv.FormatInt(int64(ve.Float()), 10)
							} else {
								n = strconv.FormatFloat(ve.Float(), 'f', 2, 64)
							}
						}
						if newVal == "{" {
							newVal += n
						} else {
							newVal += "," + n
						}
					}
					newVal += "}"
				}
				_slk[key] = newVal
			}
		}
		if _id != "" && _parent != "" && len(_slk) > 0 {
			slkIdCli = append(slkIdCli, _id)
			_class := _hash["_class"].(string)
			sbr := slkIniBuilder[_class]
			sbr.WriteString("[" + _id + "]")
			sbr.WriteString("\n_parent=" + _parent)
			for k, v := range _slk {
				// 跳过一些自定义key
				if InArray(k, []string{"model"}) {
					continue
				}
				// 处理extra填写了model的情况
				if _class == "unit" && k == "file" && _slk["model"] != "" {
					m := _slk["model"]
					if "" != asModelAlias[m] {
						sbr.WriteString("\nfile=" + asModelAlias[m])
					} else {
						sbr.WriteString("\n" + k + "=" + v)
					}
				} else {
					sbr.WriteString("\n" + k + "=" + v)
				}
			}
			sbr.WriteString("\n\n")
		}
	}

	// 合并 slk ini
	csTableDir := app.BuildDstPath + "/table"
	for k, v := range slkIniBuilder {
		if iniF6[k] == "" {
			err = FilePutContents(csTableDir+"/"+k+".ini", v.String(), fs.ModePerm)

		} else {
			err = FilePutContents(csTableDir+"/"+k+".ini", iniF6[k]+"\n\n"+v.String(), fs.ModePerm)
		}
		if err != nil {
			Panic(err)
		}
	}

	// lua - init
	x, _ := Embeds.ReadFile("embeds/lua/engine/init.lua")
	initCodes := string(x)
	luaChipsIn(LuaFile{
		name: "projects.init",
		dst:  app.BuildDstPath + "/map/projects/init.lua",
		code: initCodes,
		gen:  true,
	})

	// project scripts
	sDir, _ := filepath.Abs(app.Path.Projects + "/" + app.ProjectName + "/scripts")
	err = filepath.Walk(sDir, func(path string, info fs.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if filepath.Ext(path) == ".lua" {
			lc, err2 := fileutil.ReadFileToString(path)
			if err2 != nil {
				Panic(err2)
			}
			name := luaTrimName(path, app.Pwd)
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

	// 为 setting 补充：物编ID
	settingCode := _luaChips[_idxPt[`setting`]].code
	if len(slkIdCli) > 0 {
		for k, v := range slkIdCli {
			slkIdCli[k] = "'" + v + "'"
		}
		settingCode = strings.Replace(settingCode, "---lk:placeholder go_ids", "LK_GO_IDS = {"+strings.Join(slkIdCli, ",")+"}", 1)
	}
	// import assets codes
	settingCode = strings.Replace(settingCode, "---lk:placeholder assets", asCodes, 1)
	// map name
	wj, _ := fileutil.ReadFileToString(app.BuildDstPath + "/map/war3map.j")
	reg = regexp.MustCompile("SetMapName\\(\"(.*)\"\\)")
	sm := reg.FindAllStringSubmatch(wj, 1)
	if len(sm) > 0 {
		mapName := sm[0][1]
		settingCode = strings.Replace(settingCode, "---lk:placeholder map_name", `LK_MAP_NAME = "`+mapName+`"`, 1)
	}
	_luaChips[_idxPt[`setting`]].code = settingCode

	// toc
	tocFile := app.BuildDstPath + "/map/UI/xlik.toc"
	if !fileutil.IsExist(tocFile) {
		Panic("xlik.toc not exist")
	}
	toc, err2 := fileutil.ReadFileToString(tocFile)
	if err2 != nil {
		Panic(err2)
	}
	if len(asFdfs) > 0 {
		toc += "\r\n" + strings.Join(asFdfs, "\r\n")
	}
	err = FilePutContents(tocFile, toc+"\r\n", fs.ModePerm)
	if err != nil {
		Panic(err)
	}

	// lua - setup
	luaChipsIn(LuaFile{
		name: "projects.setup",
		dst:  app.BuildDstPath + "/map/projects/setup.lua",
		code: app.luaSetup(),
		gen:  true,
	})

	// lua - start
	luaChipsIn(LuaFile{
		name: "projects.start",
		dst:  app.BuildDstPath + "/map/projects/start.lua",
		code: app.luaStart(),
		gen:  true,
	})

	// core
	coreName := "core"
	// 处理代码
	if app.BuildModeName == "_dist" {
		coreName = Nano(23)
		connect := []string{coreName}
		for i := 0; i < len(_luaChips); i++ {
			nano := Nano(23)
			if i == _idxPt[`debug`] || i == _idxPt[`debugRelease`] {
				connect = append(connect, nano)
			}
			if i != _idxPt[`debugRelease`] {
				coreScripts = append(coreScripts, luaRequireStr(nano))
			}
			_luaChips[i].name = nano
		}
		err = FilePutContents(app.BuildDstPath+"/map/.connect", strings.Join(connect, "|"), os.ModePerm)
		if err != nil {
			Panic(err)
		}
	} else {
		for _, v := range _luaChips {
			coreScripts = append(coreScripts, luaRequireStr(v.name))
		}
	}

	// core
	coreDst := app.BuildDstPath + "/map/" + coreName + ".lua"
	coreCode := strings.Join(coreScripts, "\n")
	coreMap := LuaFile{
		name: coreName,
		dst:  coreDst,
		code: coreCode,
		gen:  true,
	}
	luaChipsIn(coreMap)

	// assets check
	app.asCheck()

	if app.BuildModeName == "_build" || app.BuildModeName == "_dist" {
		app.EncryptChips(_luaChips)
	}
	for _, v := range _luaChips {
		dst := v.dst
		code := v.code
		if app.BuildModeName == "_dist" {
			dst = app.BuildDstPath + "/map/" + v.name + ".lua"
		}
		if dst != "" && v.gen {
			DirCheck(dst)
			err = FilePutContents(dst, code, os.ModePerm)
			if err != nil {
				Panic(err)
			}
		}
	}
	return coreName
}
