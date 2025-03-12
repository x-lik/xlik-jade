package cmd

import (
	"crypto/md5"
	"fmt"
	"github.com/go-audio/wav"
	gonanoid "github.com/matoous/go-nanoid"
	"github.com/mitchellh/go-ps"
	"github.com/pterm/pterm"
	"github.com/tcolgate/mp3"
	"math/rand"
	"os"
	"path/filepath"
	"reflect"
	"regexp"
	"runtime"
	"strconv"
	"strings"
	"time"
)

var charChao map[string]string
var charChaoAnti map[string]string

func isDebugging() bool {
	executable, err := os.Executable()
	if err != nil {
		return false
	}
	return strings.Contains(executable, "\\AppData\\Local\\Temp\\")
}

func stack() string {
	var buf [2 << 10]byte
	res := string(buf[:runtime.Stack(buf[:], true)])
	if !isDebugging() {
		pwd, _ := os.Getwd()
		pwd = strings.Replace(pwd, "\\", "/", -1)
		p := strings.Split(pwd, "/")
		tiny := strings.Join(p[len(p)-2:], "/")
		reg := regexp.MustCompile("(\\s+)(.*?)+/" + tiny)
		res = reg.ReplaceAllString(res, "$1/xlik")
	}
	return res
}

func Panic(what interface{}) {
	t := reflect.TypeOf(what)
	switch t.Kind() {
	case reflect.String:
		pterm.Error.Println(what)
	case reflect.Ptr:
		pterm.Error.Println(what)
		pterm.Info.Println(stack())
	default:
		pterm.Error.Println(t.Kind())
	}
	os.Exit(0)
}

// Rand rand()
// Range: [0, 2147483647]
func Rand(min, max int) int {
	if min > max {
		panic("min: min cannot be greater than max")
	}
	// PHP: getrandmax()
	if int31 := 1<<31 - 1; max > int31 {
		panic("max: max can not be greater than " + strconv.Itoa(int31))
	}
	if min == max {
		return min
	}
	return rand.Intn(max+1-min) + min
}

// InArray in_array()
// haystack supported types: slice, array or map
func InArray(needle interface{}, haystack interface{}) bool {
	val := reflect.ValueOf(haystack)
	switch val.Kind() {
	case reflect.Slice, reflect.Array:
		for i := 0; i < val.Len(); i++ {
			if reflect.DeepEqual(needle, val.Index(i).Interface()) {
				return true
			}
		}
	case reflect.Map:
		for _, k := range val.MapKeys() {
			if reflect.DeepEqual(needle, val.MapIndex(k).Interface()) {
				return true
			}
		}
	default:
		panic("haystack: haystack type muset be slice, array or map")
	}

	return false
}

func ExeRunningQty(names []string) int {
	qty := 0
	pa, _ := ps.Processes()
	for _, p := range pa {
		for _, n := range names {
			if strings.ToLower(p.Executable()) == strings.ToLower(n) {
				qty += 1
			}
		}
	}
	return qty
}

func Nano(n int) string {
	if n < 1 {
		return ""
	}
	var err error
	s1 := ""
	s2 := ""
	if n > 7 {
		s1, err = gonanoid.Generate("_abcDEFghiJKLmnopqrSTUvwxYZ", 5)
		if err != nil {
			Panic(err)
		}
		s2, err = gonanoid.Generate("_0123456789abcDEFghiJKLmnopqrSTUvwxYZ", n-5)
		if err != nil {
			Panic(err)
		}
	} else {
		s1, err = gonanoid.Generate("_abcdefghijklnmopqrstuvwxyzABCDEFGHIJKLNMOPQRSTUVWXYZ", n)
		if err != nil {
			Panic(err)
		}
	}
	return s1 + s2
}

// This function generates a string of length n using the characters in the given string
func NanoOL(n int) string {
	// Generate a string of length n using the characters in the given string
	s, err := gonanoid.Generate("abcDEFghiJKLmnopqrSTUvwxYZ", n)
	// If there is an error, panic
	if err != nil {
		Panic(err)
	}
	// Return the generated string
	return s
}

// Zebra n must be an even
func Zebra(n int) string {
	letterStr := "abcdefghijklmnopqrstuvwxyxzABCDEFGHIJKLMNOPQRSTUVWXYXZ"
	numberStr := "0123456789"
	if n < 4 {
		n = 4
	}
	if n%2 != 0 {
		Panic("Zebra:n must be an even")
	}
	r := ""
	for j := 0; j < n; j++ {
		if j%2 == 0 {
			k := rand.Intn(len(letterStr) - 1)
			r += letterStr[k:(k + 1)]
		} else {
			k := rand.Intn(len(numberStr) - 1)
			r += numberStr[k:(k + 1)]
		}
	}
	return r
}

// VoiceMilliseconds 获取音频时长，支持 mp3、wav
func VoiceMilliseconds(soundFile string) int {
	ms := 0
	f, err := os.Open(soundFile)
	if err != nil {
		Panic(err)
		return 0
	}
	defer f.Close()
	ext := filepath.Ext(soundFile)
	if ext == ".mp3" {
		skipped := 0
		d := mp3.NewDecoder(f)
		var fr mp3.Frame
		for {
			if err2 := d.Decode(&fr, &skipped); err2 != nil {
				if err2.Error() == "EOF" {
					break
				} else {
					Panic(err2)
					return 0
				}
			}
			ms += int(float64(time.Millisecond) * (1000 / float64(fr.Header().SampleRate())) * float64(fr.Samples()))
		}
		ms = ms / 1000000
	} else if ext == ".wav" {
		d, err2 := wav.NewDecoder(f).Duration()
		if err2 != nil {
			Panic(err)
			return 0
		}
		ms = int(d.Milliseconds())
	}
	return ms
}

func CharRand() string {
	allStr := "01234abcdefghijklmnopqrstuvwxyxzABCDEFGHIJKLMNOPQRSTUVWXYXZ56789"
	i := rand.Intn(len(allStr) - 1)
	return allStr[i:(i + 1)]
}

func MD5(str string) string {
	data := []byte(str)
	has := md5.Sum(data)
	md5str := fmt.Sprintf("%x", has)
	return md5str
}
