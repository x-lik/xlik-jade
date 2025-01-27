Language : CN | [US](./README.en-US.md)

# X-LIK 璞玉版本

- 首页: [https://www.hunzsig.com/x-lik](https://www.hunzsig.com/x-lik)
- 发电: [https://afdian.com/a/hunzsig](https://afdian.com/a/hunzsig)

## 介绍

**待打磨的璞玉**

X-LIK 璞玉版本的框架就像一块未经雕琢的璞玉，等待着各自的打磨。它体现了公司为游戏开发者提供一个探索和实验自己想法的平台的承诺。如同璞玉一般，玉不琢不成器，但它为开发者提供了一张空白的画布，让他们能够创造出独特的游戏体验。

代码是完全开源的，开发者可以自由访问和修改代码库。它保留了核心功能模块，确保框架的基础稳定可靠。开发者可以自由开发自定义功能模块，根据自身需求对框架进行定制。

这个框架非常适合那些热衷于探索和研究自己想法的开发者。让开发者能够尝试新的概念和技术，推动自定义游戏开发的极限，赋予开发者将他们的愿景变为现实的能力。此仓库只进行必要的维护和更新。

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