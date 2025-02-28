package cmd

type YamlEnv struct {
	War3    string `yaml:"war3"`
	Pwd     string `yaml:"pwd"`
	We      string `yaml:"we"`
	W3x2lni string `yaml:"w3x2lni"`
	Assets  string `yaml:"assets"`
}

type YamlSound struct {
	Path     string `yaml:"path"`
	Duration int    `yaml:"duration"`
}

type YamlEncrypt struct {
	Forces []string            `yaml:"forces,flow"`
	Rules  []map[string]string `yaml:"rules,flow"`
}

type YamlLibrary struct {
	Require []string    `yaml:"require,flow"`
	Encrypt YamlEncrypt `yaml:"encrypt,flow"`
}
