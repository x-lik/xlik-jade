### env.yaml 文件配置

```yaml
# 魔兽争霸3客户端文件路径
# Warcraft 3 client file path
war3: "/yourWorkspace/war3Client"

# 框架根目录（设置空则自动定为exe工具执行所在目录）
# Framework root directory (set empty to automatically specify the directory where the exe tool is executed)
pwd: "/yourWorkspace/xlik"

# WE工具目录
# WE tool catalogue
we: "vendor/WE.v4"

# w3x2lni工具目录
# w3x2lni tools directory
w3x2lni: "vendor/w3x2lni"

# assets资源目录
# assets resource directory
assets: "vendor/assets"
```

### 构建exe工具

```
go build
go build -ldflags "-s -w"
```