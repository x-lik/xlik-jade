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
	// 外置 lua引擎
	L := lua.NewState()
	defer L.Close()
	luaRequireEmbed(L, "embeds/lua/go/driver.lua")
	luaRequireEmbed(L, "embeds/lua/go/json.lua")
	luaRequireEmbed(L, "embeds/lua/go/comm.lua")
	luaRequireEmbed(L, "embeds/lua/go/slk.lua")
	luaRequireEmbed(L, "embeds/lua/go/assets.lua")
	luaRequireEmbed(L, "embeds/lua/go/system.lua")
	// lni - UI
	CopyDir("embeds/lni/assets/UI", app.BuildDstPath+"/map/UI")
	//
	var coreScripts []string
	// coreScripts初始化
	if app.BuildModeName == "_local" {
		coreScripts = append(coreScripts, "package.path = package.path .. \";"+strings.Replace(app.Pwd, "\\", "/", -1)+"/?.lua\"")
	}
	// luaScript (require and parse lua files)
	// luaScript:embeds/lua/engine
	app.luaFileHandler(`embeds/lua/engine/engine.lua`)
	app.luaFileHandler(`embeds/lua/engine/debug.lua`)
	if app.BuildModeName == `_dist` {
		app.luaFileHandler(`embeds/lua/engine/debugRelease.lua`)
	}
	app.luaFileHandler(`embeds/lua/engine/typeof.lua`)
	app.luaFileHandler(`embeds/lua/engine/promise.lua`)
	app.luaFileHandler(`embeds/lua/engine/pairx.lua`)
	app.luaFileHandler(`embeds/lua/engine/blizzard.lua`)
	app.luaFileHandler(`embeds/lua/engine/mapping.lua`)
	app.luaFileHandler(`embeds/lua/engine/setting.lua`)
	// luaScript:library project/library
	luaLibDirs := []string{app.Path.Library, app.Path.Projects + "/" + app.ProjectName + "/library"}
	var luaLibSrc []string
	for _, lib := range luaLibDirs {
		if !fileutil.IsDir(lib) {
			continue
		}
		yamlFile := lib + `/library.yaml`
		if fileutil.IsExist(yamlFile) {
			data, _ := os.ReadFile(yamlFile)
			y := YamlLibrary{}
			erry := yaml.Unmarshal(data, &y)
			if nil == erry {
				if len(y.Require) == 0 {
					luaLibSrc = append(luaLibSrc, lib)
				} else {
					for _, n := range y.Require {
						p := lib + `/` + n
						if fileutil.IsDir(p) {
							luaLibSrc = append(luaLibSrc, p)
						}
					}
				}
			}
		} else {
			luaLibSrc = append(luaLibSrc, lib)
		}
	}
	for _, src := range luaLibSrc {
		err = filepath.Walk(src, func(path string, info fs.FileInfo, err error) error {
			if err != nil {
				return err
			}
			if strings.EqualFold(filepath.Ext(path), ".lua") {
				app.luaFileHandler(path)
			}
			return nil
		})
		if err != nil {
			Panic(err)
		}
	}
	// luaScript:embeds/lua/slk
	app.luaFileHandler(`embeds/lua/slk/slk.lua`)
	app.luaFileHandler(`embeds/lua/slk/assets.lua`)
	app.luaFileHandler(`embeds/lua/slk/system.lua`)
	app.luaFileHandler(`embeds/lua/slk/ids.lua`)
	// luaScript:project/assets project/slk
	proInput := []string{app.Path.Projects + "/" + app.ProjectName + "/assets", app.Path.Projects + "/" + app.ProjectName + "/slk"}
	for _, ipt := range proInput {
		if fileutil.IsDir(ipt) {
			err = filepath.Walk(ipt, func(path string, info fs.FileInfo, err error) error {
				if err != nil {
					return err
				}
				if strings.EqualFold(filepath.Ext(path), ".lua") {
					luaRequire(L, path)
					app.luaFileHandler(path)
				}
				return nil
			})
			if err != nil {
				Panic(err)
			}
		}
	}

	// luaAssets:处理 GO_ASSETS_ALL
	fn := L.GetGlobal("GO_ASSETS_ALL")
	if err = L.CallByParam(lua.P{Fn: fn, NRet: 1, Protect: true}); err != nil {
		Panic(err)
	}
	var ga AssetsGo
	err = json.Unmarshal([]byte(L.ToString(-1)), &ga)
	if err != nil {
		Panic(err)
	}
	// luaAssets:读取resources
	assetsCodes, assetsFdf := app.luaAssets(ga)
	// luaAssets:合并toc
	tocFile := app.BuildDstPath + "/map/UI/xlik.toc"
	if !fileutil.IsExist(tocFile) {
		Panic("xlik.toc not exist")
	}
	toc, err2 := fileutil.ReadFileToString(tocFile)
	if err2 != nil {
		Panic(err2)
	}
	if len(assetsFdf) > 0 {
		toc += "\r\n" + strings.Join(assetsFdf, "\r\n")
	}
	err = fileutil.WriteStringToFile(tocFile, toc+"\r\n", false)
	if err != nil {
		Panic(err)
	}
	// luaSlk:处理 GO_SLK_ALL
	fn = L.GetGlobal("GO_SLK_ALL")
	if err = L.CallByParam(lua.P{Fn: fn, NRet: 1, Protect: true}); err != nil {
		Panic(err)
	}
	// luaSlk:get lua function results
	slkData := L.ToString(-1)
	var slData []map[string]interface{}
	err = json.Unmarshal([]byte(slkData), &slData)
	if err != nil {
		Panic(err)
	}
	// luaSlk:拼接ini
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
	// luaSlk:写入ini
	csTableDir := app.BuildDstPath + "/table"
	for k, v := range slkIniBuilder {
		if iniF6[k] == "" {
			err = fileutil.WriteStringToFile(csTableDir+"/"+k+".ini", v.String(), false)

		} else {
			err = fileutil.WriteStringToFile(csTableDir+"/"+k+".ini", iniF6[k]+"\n\n"+v.String(), false)
		}
		if err != nil {
			Panic(err)
		}
	}
	// luaSlk:补充setting中的物编ID
	_luaSettingKey := "embeds/lua/engine/setting.lua"
	_luaSettingCode := _luaFiles[_luaSettingKey].code
	if len(slkIdCli) > 0 {
		for k, v := range slkIdCli {
			slkIdCli[k] = "'" + v + "'"
		}
		_luaSettingCode = strings.Replace(_luaSettingCode, "LK_GO_IDS = {}", "LK_GO_IDS = {"+strings.Join(slkIdCli, ",")+"}", 1)
	}
	// import assets codes
	_luaSettingCode = strings.Replace(_luaSettingCode, "---lk:placeholder assets", assetsCodes, 1)
	// map name
	wj, _ := fileutil.ReadFileToString(app.BuildDstPath + "/map/war3map.j")
	reg = regexp.MustCompile("SetMapName\\(\"(.*)\"\\)")
	sm := reg.FindAllStringSubmatch(wj, 1)
	if len(sm) > 0 {
		mapName := sm[0][1]
		_luaSettingCode = strings.Replace(_luaSettingCode, "LK_MAP_NAME = '(name)'", `LK_MAP_NAME = "`+mapName+`"`, 1)
	}
	_luaFiles[_luaSettingKey].code = _luaSettingCode
	// luaScript:embeds/lua/engine/init
	app.luaFileHandler(`embeds/lua/engine/init.lua`)
	// luaScript:project/scripts
	proScripts := app.Path.Projects + "/" + app.ProjectName + "/scripts"
	if fileutil.IsDir(proScripts) {
		err = filepath.Walk(proScripts, func(path string, info fs.FileInfo, err error) error {
			if err != nil {
				return err
			}
			if strings.EqualFold(filepath.Ext(path), ".lua") {
				app.luaFileHandler(path)
			}
			return nil
		})
		if err != nil {
			Panic(err)
		}
	}

	// luaScript:ChipsIn
	app.luaFileToChips()

	// luaScript:final chips
	// luaScript:setup
	luaChipsIn(LuaFile{
		name: "projects.setup",
		dst:  app.BuildDstPath + "/map/projects/setup.lua",
		code: app.luaSetup(),
		gen:  true,
	})
	// luaScript:start
	luaChipsIn(LuaFile{
		name: "projects.start",
		dst:  app.BuildDstPath + "/map/projects/start.lua",
		code: app.luaStart(),
		gen:  true,
	})
	// luaChipsIn to coreScripts
	coreName := "core"
	if app.BuildModeName == "_dist" {
		coreName = Nano(23)
		connect := []string{coreName}
		for i := 0; i < len(_luaChips); i++ {
			nano := Nano(23)
			if _luaChips[i].name == "engine.drive.debugRelease" {
				connect = append(connect, nano)
			} else {
				if _luaChips[i].name == "engine.drive.debug" {
					connect = append(connect, nano)
				}
				coreScripts = append(coreScripts, luaRequireStr(nano))
			}
			_luaChips[i].name = nano
		}
		err = fileutil.WriteStringToFile(app.BuildDstPath+"/map/.connect", strings.Join(connect, "|"), false)
		if err != nil {
			Panic(err)
		}
	} else {
		for _, v := range _luaChips {
			coreScripts = append(coreScripts, luaRequireStr(v.name))
		}
	}
	// luaScript:core
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
			FileCheck(dst)
			err = fileutil.WriteStringToFile(dst, code, false)
			if err != nil {
				Panic(err)
			}
		}
	}
	return coreName
}
