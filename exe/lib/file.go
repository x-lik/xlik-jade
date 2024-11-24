package cmd

import (
	"errors"
	"github.com/duke-git/lancet/v2/fileutil"
	"github.com/pterm/pterm"
	"io"
	"io/fs"
	"os"
	"path/filepath"
	"strings"
)

// GetFileInfo 判断文件或目录是否存在
func GetFileInfo(src string) os.FileInfo {
	if fileInfo, e := os.Stat(src); e != nil {
		if os.IsNotExist(e) {
			return nil
		}
		return nil
	} else {
		return fileInfo
	}
}

func DirCheck(path string) bool {
	if len(path) == 0 {
		return false
	}
	path = strings.Replace(path, "\\", "/", -1)
	pathArr := strings.Split(path, "/")
	pathArr = pathArr[0 : len(pathArr)-1]
	dstPath := strings.Join(pathArr, "/")
	dstFileInfo := GetFileInfo(dstPath)
	if nil == dstFileInfo {
		if e := os.MkdirAll(dstPath, fs.ModePerm); e != nil {
			pterm.Error.Println("path:", path, dstPath)
			Panic(e)
			return false
		}
	}
	return true
}

// FilePutContents file_put_contents()
func FilePutContents(filename string, data string, mode os.FileMode) error {
	return os.WriteFile(filename, []byte(data), mode)
}

// GetModTime 获取文件(夹)修改时间 返回unix时间戳
func GetModTime(path string) int64 {
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
			info := GetFileInfo(path)
			modTime = info.ModTime().Unix()
		}
	}
	return modTime
}

// GetSize 获取文件(夹)总大小
func GetSize(path string) int64 {
	size := int64(0)
	if fileutil.IsExist(path) {
		if fileutil.IsDir(path) {
			err := filepath.Walk(path, func(path string, info os.FileInfo, err error) error {
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
			info := GetFileInfo(path)
			size = info.Size()
		}
	}
	return size
}

// GetSizeEmbed 获取内置文件(夹)总大小
func GetSizeEmbed(src string) int64 {
	size := int64(0)
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
	return size
}

// IsDiffFile 简单判定新文件是否值得替换当前文件
func IsDiffFile(new string, now string) bool {
	var n1, n2, s1, s2 int64
	isE1 := -1 != strings.Index(new, "embeds/")
	isE2 := -1 != strings.Index(now, "embeds/")
	if isE1 {
		_, err := Embeds.Open(new)
		if err == nil {
			n1 = 1
		} else {
			n1 = 0
		}
		s1 = GetSizeEmbed(new)
	} else {
		n1 = GetModTime(new)
		s1 = GetSize(new)
	}
	if isE2 {
		_, err := Embeds.Open(now)
		if err == nil {
			n2 = 1
		} else {
			n2 = 0
		}
		s2 = GetSizeEmbed(now)
	} else {
		n2 = GetModTime(now)
		s2 = GetSize(now)
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

// CopyFile 拷贝文件
func CopyFile(src, dst string) bool {
	if len(src) == 0 || len(dst) == 0 {
		return false
	}
	DirCheck(dst)
	if -1 != strings.Index(src, "embeds/") {
		if IsDiffFile(src, dst) {
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
		if IsDiffFile(src, dst) {
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

// CopyPath 拷贝目录
func CopyPath(src string, dst string) bool {
	di := strings.TrimRight(strings.TrimRight(dst, "/"), "\\")
	var err error
	if -1 != strings.Index(src, "embeds/") {
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
		srcFileInfo := GetFileInfo(src)
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
