package cmd

import (
	"strings"
)

func csvParse(str string) string {
	hasQuota := strings.Index(str, `"`) != -1
	isParse := hasQuota || strings.Index(str, `,`) != -1
	if hasQuota {
		str = strings.Replace(str, `"`, `""`, -1)
	}
	if isParse {
		str = `"` + str + `"`
	}
	return str
}

func CsvMapSSS(data map[string]map[string]string) string {
	var content []string
	for e, m := range data {
		for k, v := range m {
			v = strings.Replace(v, `,`, `，`, -1)
			content = append(content, e+`,`+csvParse(k)+`,`+csvParse(v))
		}
	}
	return "\xEF\xBB\xBF" + strings.Join(content, "\n")
}
