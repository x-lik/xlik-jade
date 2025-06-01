package cmd

import (
	"errors"
	"github.com/duke-git/lancet/v2/fileutil"
	"io"
	"io/fs"
	"os"
	"path/filepath"
	"strings"
)

// CopyFile 拷贝文件
func CopyFile(src, dst string) bool {
	if len(src) == 0 || len(dst) == 0 {
		return false
	}
	FileCheck(dst)
	if strings.Contains(src, "embeds/") {
		if FileIsDiff(src, dst) {
			b, err := Embeds.ReadFile(src)
			if err != nil {
				return false
			}
			return nil == os.WriteFile(dst, b, fs.ModePerm)
		}
	} else {
		if !fileutil.IsExist(src) {
			return false
		}
		srcFile, e := os.OpenFile(src, os.O_RDONLY, fs.ModePerm)
		if e != nil {
			Panic(e.Error())
			return false
		}
		defer srcFile.Close()
		if FileIsDiff(src, dst) {
			// 这里要把O_TRUNC 加上，否则会出现新旧文件内容出现重叠现象
			dstFile, e2 := os.OpenFile(dst, os.O_CREATE|os.O_TRUNC|os.O_RDWR, fs.ModePerm)
			if e2 != nil {
				Panic(e2.Error())
				return false
			}
			defer dstFile.Close()
			if _, e2 = io.Copy(dstFile, srcFile); e != nil {
				Panic(e2.Error())
				return false
			}
		}
	}
	return true
}

// CopyDir 拷贝目录
func CopyDir(src string, dst string) bool {
	di := strings.TrimRight(strings.TrimRight(dst, "/"), "\\")
	var err error
	if strings.Contains(src, "embeds/") {
		err = fs.WalkDir(Embeds, ".", func(path string, d fs.DirEntry, err error) error {
			if err != nil {
				return err
			}
			if strings.Index(path, src) == -1 {
				return nil
			}
			relationPath := strings.Replace(path, src, "/", -1)
			info, _ := d.Info()
			dstPath := strings.TrimRight(strings.TrimRight(dst, "/"), "\\") + relationPath
			if !info.IsDir() {
				if CopyFile(path, dstPath) {
					return nil
				} else {
					return errors.New(path + " copy failed")
				}
			} else {
				if _, err2 := os.Stat(dstPath); err2 != nil {
					if os.IsNotExist(err2) {
						if err3 := os.MkdirAll(dstPath, fs.ModePerm); err3 != nil {
							return err3
						} else {
							return nil
						}
					} else {
						return err2
					}
				} else {
					return nil
				}
			}
		})
	} else {
		srcFileInfo := FileGetInfo(src)
		if nil == srcFileInfo || !srcFileInfo.IsDir() {
			return false
		}
		src, err = filepath.Abs(src)
		if err != nil {
			Panic(err)
		}
		err = filepath.Walk(src, func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}
			relationPath := strings.Replace(path, src, "/", -1)
			dstPath := di + relationPath
			if !info.IsDir() {
				if CopyFile(path, dstPath) {
					return nil
				} else {
					return errors.New(path + " copy failed")
				}
			} else {
				if _, err2 := os.Stat(dstPath); err2 != nil {
					if os.IsNotExist(err2) {
						if err3 := os.MkdirAll(dstPath, fs.ModePerm); err3 != nil {
							return err3
						} else {
							return nil
						}
					} else {
						return err2
					}
				} else {
					return nil
				}
			}
		})
	}
	if err != nil {
		Panic(err)
	}
	return true
}
