# git-grep package

`git grep` in atom editor.

![](http://i.gyazo.com/efa20ec320ff27a26c98cf93f60f9c60.png)

## Install

```
apm install git-grep
```

## How to use

Set your keybind.cson as you like.

```coffee
'.workspace':
  'cmd-k cmd-g': 'git-grep:grep' # default
```

Root of `git grep` is always current root of workspace. 
