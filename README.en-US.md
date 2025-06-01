Language : [CN](./README.md) | US

# X-LIK Jade Version (Completely open source)

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/x-lik/xlik-jade)

- HomePage: [https://www.hunzsig.com/x-lik](https://www.hunzsig.com/x-lik)
- ChangeLog: [https://www.hunzsig.com/x-lik-log](https://www.hunzsig.com/x-lik-log)

## Introduction

**A Raw Gemstone Awaiting Polishing**

The Jade version of the x-lik game framework is a raw gemstone, awaiting its final polish. It is a testament to the company's commitment to providing a platform for game developers to explore and experiment with their own ideas. Like a jade stone, the framework is not yet fully refined, but it offers a blank canvas for developers to create their own unique game experiences.

The Jade version of x-lik game framework is completely full open-source, allowing developers to access and modify the codebase. However, it retains its core functionality modules, ensuring that the foundation of the framework remains stable and reliable. Developers are free to develop their own custom functionality modules, tailoring the framework to their specific needs.

It is ideal for developers who are passionate about exploring and researching their own ideas. It provides a blank canvas for developers to experiment with new concepts and techniques, pushing the boundaries of game development. Empowers developers to bring their vision to life. This repository will only receive necessary maintenance and updates.

## Framework Structure

> (*) Required: Necessary, missing will cause a crash
>
> (~) Automatic: Temporary, automatic build not available
>
> (·) Customize: Customizable, build on demand

```text
├── library - (*) Core
│   ├── ability - Independent ability set
│   ├── class - Class
│   │   ├── meta - (*) Simplified metaclass
│   │   ├── ui - (*) UI interface class
│   │   └── vast - (*) Composite large class
│   ├── common - Basic library
│   ├── japi - JAPI library, containing YD, DZ, KK, LK four interfaces
│   └── encrypt.yaml - (·) Define the rules configuration for obfuscation
├── projects - (~|·) Directory to place your map project, such as project_demo
│   └── project_demo - (·)
│       ├── assets - import assets
│       ├── slk - import slk
│       └── library (·) the sub library in current project
├── vendor - (·) Tool resource directory, you can place assets/w3x2lni/we, etc. (Of course, you can also leave it out)
│   ├── assets - (*)|· Resource library
│   │   ├── war3mapBgm - Place music, only supports mp3
│   │   ├── war3mapFont - Place fonts, only supports ttf (can be paired with lua configuration)
│   │   ├── war3mapIcon - Place icons, only supports tga
│   │   ├── war3MapLoading - Loading image, only supports single tga or rule combination tga
│   │   ├── war3mapModel - Place models, only supports mdx, do not put textures in
│   │   ├── war3mapModelNew - Place new untested models, move to war3mapModel after testing (use command model -n to test)
│   │   ├── war3mapPlugins - Place plugins, refer to existing formats
│   │   ├── war3mapPreview - Preview image, only supports tga
│   │   ├── war3mapSelection - Place selection circles, refer to provided formats
│   │   ├── war3mapTerrain - Place terrain textures, refer to provided formats, supports tga, blp
│   │   ├── war3mapTextures - Place model textures, only supports blp
│   │   ├── war3mapTexturesNew - Place new untested model textures, move to war3mapTextures after testing (use command model -n to test)
│   │   ├── war3mapUI - Place UI suite, refer to existing formats
│   │   ├── war3mapVoice - Place vcm, v3d, vwp sound effects, only supports mp3
│   │   └── war3mapVwp - Place weapon sound effect configuration, only supports yaml
│   ├── w3x2lni - w3x2lni tool (v:2.7.2)
│   └── WE - terrain tool
├── env.yaml - (~|·) Development environment configuration
├── exbook.exe -(·) EX document reader
├── xlik.exe - (*) Command tool
└── .tmp - (~) Cache
```

### How To Build ExeTool

```
cd /xlik-jade/exe
go build
```

## How To Use

```
xlik.exe new my_project
xlik.exe run my_project -l // local test
xlik.exe run my_project -t // pack test
xlik.exe run my_project -b // build
xlik.exe run my_project -d // dist
xlik.exe run my_project -r // publish released
```