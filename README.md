Language : CN | [US](./README.en-US.md)

# X-LIK 璞玉版本（完全开源）

[![查看 DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/x-lik/xlik-jade)

- 首页: [https://www.hunzsig.com/x-lik](https://www.hunzsig.com/x-lik)
- 更新: [https://www.hunzsig.com/x-lik-log](https://www.hunzsig.com/x-lik-log)

## 框架结构

> （*）Required 必要性，丢失崩溃
>
> （~）Automatic 临时性，缺少自动构建
>
> （·）Customize 自定义，按需构建

```text
├── library - （*）核心库
│   ├── ability - 独立技能集
│   ├── class - 类
│   │   ├── meta - （*）精简元类
│   │   ├── ui - （*）UI界面类
│   │   └── vast - （*）复合大类
│   ├── common - 基础库
│   ├── japi - JAPI 库，包含 YD、DZ、KK、LK 四个接口
│   └── encrypt.yaml - （·） 定义混淆规则的配置文件
├── projects -（~|·）用来放置你的地图项目目录，如 project_demo
│   └── project_demo -（·）
│       ├── assets - 资源引入
│       ├── slk - slk引入
│       └── library（·）项目子库
├── vendor -（·）工具资源目录，你可以放置assets/w3x2lni/we等(当然也可以不放)
│   ├── assets -（*|·）资源库
│   │   ├── war3mapBgm - 放音乐，只支持 mp3、wav
│   │   ├── war3mapFont - 放字体，只支持 ttf（可搭配lua配置）
│   │   ├── war3mapImage - 放图片，如过去lik的图标，只支持 tga、blp
│   │   ├── war3MapLoading - 载入图，只支持单图 tga 或 规则组合 tga
│   │   ├── war3mapModel - 放模型，只支持 mdx，贴图不要扔进来
│   │   ├── war3mapModelNew - 放新的未测试模型，测试完成后再放入war3mapModel（使用命令model -n测试）
│   │   ├── war3mapPreview - 预览图，只支持 tga
│   │   ├── war3mapSelection - 放选择圈，参考已提供格式
│   │   ├── war3mapTerrain - 放地形贴图，参考已提供格式，支持 tga、blp
│   │   ├── war3mapTextures - 放模型贴图，只支持 blp
│   │   ├── war3mapTexturesNew - 放新的未测试模型贴图，测试完成后再放入war3mapTextures（使用命令model -n测试）
│   │   ├── war3mapUI - 放UI套件，已有格式参考
│   │   ├── war3mapVoice - 放vcm、v3d、vwp音效，只支持 mp3、wav
│   │   └── war3mapVwp - 放武器音效配置，只支持 yaml
│   ├── w3x2lni - w3x2lni工具(v:2.7.2)
│   └── WE - 新马仔
├── env.yaml -（·）开发环境配置
├── exbook.exe -（·）文档阅读器
├── xlik.exe -（*）命令工具
└── .tmp -（~）缓存
```

## 构建exe工具

```
cd /xlik-jade/exe
go build
```

## 使用入门

```
xlik.exe new my_project
xlik.exe run my_project -l //本地调试模式下热更新调试
xlik.exe run my_project -t //构建脚本不加密地图并热更新调试
xlik.exe run my_project -b //构建脚本加密地图并热更新调试
xlik.exe run my_project -d //构建脚本加密且slk优化的地图并调试
xlik.exe run my_project -r //基于-d二次构建上线地图并测试
```