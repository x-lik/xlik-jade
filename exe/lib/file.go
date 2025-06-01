package cmd

import (
	"github.com/duke-git/lancet/v2/fileutil"
	"github.com/pterm/pterm"
	"io/fs"
	"os"
	"path/filepath"
	"strconv"
	"strings"
)

// FileCheck with directory
// when directory is not exist, create it
func FileCheck(path string) bool {
	if len(path) == 0 {
		return false
	}
	path = strings.Replace(path, "\\", "/", -1)
	pathArr := strings.Split(path, "/")
	pathArr = pathArr[0 : len(pathArr)-1]
	dstPath := strings.Join(pathArr, "/")
	dstFileInfo := FileGetInfo(dstPath)
	if nil == dstFileInfo {
		if e := os.MkdirAll(dstPath, fs.ModePerm); e != nil {
			pterm.Error.Println("path:", path, dstPath)
			Panic(e)
			return false
		}
	}
	return true
}

// FileToString This function takes a string as an argument and returns a string
func FileToString(src string) string {
	if 0 == strings.Index(src, "embeds/") {
		b, err := Embeds.ReadFile(src)
		if err != nil {
			Panic(err)
		}
		return string(b)
	} else {
		b, err := fileutil.ReadFileToString(src)
		if err != nil {
			Panic(err)
		}
		return b
	}
}

// FileGetInfo 判断文件或目录是否存在
func FileGetInfo(src string) os.FileInfo {
	if fileInfo, e := os.Stat(src); e != nil {
		if os.IsNotExist(e) {
			return nil
		}
		return nil
	} else {
		return fileInfo
	}
}

// FileGetModTime 获取文件(夹)修改时间 返回unix时间戳
func FileGetModTime(path string) int64 {
	modTime := int64(0)
	if fileutil.IsExist(path) {
		if fileutil.IsDir(path) {
			err := filepath.Walk(path, func(path string, info os.FileInfo, err error) error {
				if err != nil {
					return nil
				}
				u := info.ModTime().Unix()
				if u > modTime {
					modTime = u
				}
				return nil
			})
			if err != nil {
				return 0
			}
		} else {
			info := FileGetInfo(path)
			modTime = info.ModTime().Unix()
		}
	}
	return modTime
}

// FileGetSize 获取文件(夹)总大小
func FileGetSize(src string) int64 {
	size := int64(0)
	if 0 == strings.Index(src, "embeds/") {
		f, erre := Embeds.Open(src)
		if erre == nil {
			stat, _ := f.Stat()
			stat.Size()
			if stat.IsDir() {
				err := fs.WalkDir(Embeds, src, func(path string, d fs.DirEntry, err error) error {
					if err != nil {
						return err
					}
					info, _ := d.Info()
					size += info.Size()
					return nil
				})
				if err != nil {
					Panic(err)
				}
			} else {
				size = stat.Size()
			}
		}
	} else {
		if fileutil.IsExist(src) {
			if fileutil.IsDir(src) {
				err := filepath.Walk(src, func(path string, info os.FileInfo, err error) error {
					if err != nil {
						return nil
					}
					size += info.Size()
					return nil
				})
				if err != nil {
					return 0
				}
			} else {
				info := FileGetInfo(src)
				size = info.Size()
			}
		}
	}
	return size
}

// FileGetSizeString 获取文件(夹)总大小的字符串，自动转换单位
func FileGetSizeString(src string) string {
	size := FileGetSize(src)
	if size < 1024 {
		return strconv.FormatInt(size, 10) + "B"
	} else if size < 1024*1024 {
		return strconv.FormatFloat(float64(size)/1024, 'f', 2, 64) + "KB"
	} else if size < 1024*1024*1024 {
		return strconv.FormatFloat(float64(size)/(1024*1024), 'f', 2, 64) + "MB"
	} else {
		return strconv.FormatFloat(float64(size)/(1024*1024*1024), 'f', 2, 64) + "GB"
	}
}

// FileIsDiff 简单判定新文件是否值得替换当前文件
func FileIsDiff(new string, now string) bool {
	var n1, n2 int64
	isE1 := strings.Contains(new, "embeds/")
	isE2 := strings.Contains(now, "embeds/")
	s1 := FileGetSize(new)
	s2 := FileGetSize(now)
	if isE1 {
		_, err := Embeds.Open(new)
		if err == nil {
			n1 = 1
		} else {
			n1 = 0
		}
	} else {
		n1 = FileGetModTime(new)
	}
	if isE2 {
		_, err := Embeds.Open(now)
		if err == nil {
			n2 = 1
		} else {
			n2 = 0
		}
	} else {
		n2 = FileGetModTime(now)
	}
	res := n1 > n2 || s1 != s2
	if !res {
		var d1 []byte
		var d2 []byte
		if isE1 {
			d1, _ = Embeds.ReadFile(new)
		} else {
			d1, _ = os.ReadFile(new)
		}
		if isE2 {
			d2, _ = Embeds.ReadFile(now)
		} else {
			d2, _ = os.ReadFile(now)
		}
		for i := 0; i < len(d1); i++ {
			if d1[i] != d2[i] {
				res = true
				break
			}
		}
	}
	return res
}
