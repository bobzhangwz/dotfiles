# Manjaro + Xmonad 完全入坑指南

---

## 序言

因为公司提供的是苹果的电脑，所以一直以来都是在 MacOS 下进行开发工作。 MacOS 本身也提供了各种友好且顺手的开发工具，对命令行(bash, zsh) 的支持也非常完善，但是我始终没有在Mac生态圈找到类似 Xmonad 的窗口管理系统(Tiling Windows Manager)，以至于我还是觉得 MacOS 的可定制性没有Linux强大。可定制性比较强，意味着用户需要花大量的时间和精力来配置，所以我有一个脚本来快速配置这些东西：https://github.com/bobzhangwz/dotfiles 。

我在现在的开发环境主要是 
1. Arch Linux，操作系统
2. Xmonad, 窗口管理器
3. Spacemacs, SpaceVim, 编辑器
5. rxvt-unicode + tmux, 终端管理
6. oh-my-zsh

为了完成这些工具的配置和组合，我参考了好多文档，花了很长时间。这次把他都记录下来，方便后来人能方便的使用、学习。

以上这些工具软件，重度使用快捷键，提升开发效率；新手需要不断磨合/习惯

## 一、安装操作系统 - Manjaro Linux

Arch linux 提供了滚动升级的特性，能让你的系统随时保持在最新的版本；并且通过AUR，你能获得丰富的软件和工具；同时Arch wiki 提供了详尽的文档，并且有活跃的社区支持。但是安装 Arch Linux 需要手动执行一堆命令，并且需要自己根据需要手动安装桌面环境，以及各种工具；对新手不是很友好，没有类似Ubuntu/Federal一键傻瓜安装的模式。

Manjaro 是基于 arch linux 的一个发行版，提供了一键式安装模式，并且提供了基于 xfce4/KDE/Gnome 桌面的发行版本。

第一步下载 Manjaro XFCE4, 根据官方文档，比较推荐先在 virturalbox 上进行先行安装，并试用；熟悉之后可以在真实的PC机器上安装。

### 初始化

安装完成之后，可以运行命令 `pacman-mirror -i -c China` , 选择可用软件镜像之后运行 `pacman -Syu` 升级更新到最新软件版本.

`virtualbox` 用户，在安装完成后需要运行 `virturalbox guest iso`安装 virtualbox 驱动。

## 二、初始化，stow 和 ansible

我使用 stow 来管理配置文件，ansible 来自动安装软件; 运行以下脚本，自动完成配置和软件安装
```
git clone https://github.com/bobzhangwz/dotfiles.git
## rm ~/.xinitrc 或者  rm ./dotfiles/config/linux/.xinitrc
PLATFORM=linux ./dotfiles/init.sh
```

### stow 来管理配置

Linux/Mac 各种软件配置和系统配置文件都放在 home 目录下，这些文件都叫做 dotfiles，我们可以通过GIT托管这些配置的dotfiles。然后运行 stow 命令，让这些配置软链接到用户home目录下。实现配置文件的复用

### `yay` 来管理安装aur软件

脚本安装了 `yay` 用来管理AUR的软件，使用方法类似 `pacman`, 以下是一些常用命令
```
yay -Syu ## 更新升级, 可以经常运行，滚动升级
yay -Ss software ## 模糊查找软件
yay -S software ## 安装软件
yay -Rs software ## 删除软件
yay -Qi software ## 查找已经安装软件
```

### ansible 软件安装 和 配置

脚本里会使用 ansible 安装 oh-my-zh, spacemacs, spacevim 以及一些常用的字体
以及一些常用软件(`linux/init.yml`)，比如
```
emacs
neovim
chrome
xmonad
fzf
```

因为安装 oh-my-zsh, dotfiles 里的 `.zshrc` 会替换，一定在 `zshrc` 里面加上以下下几句
```
export TERM=rxvt-256color
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
```

`z` 是用来快速跳转到文件，在命令行输入 `z <想要的目录><TAB>`，可以自动完成目录。
`fzf` 用来在命令行查找历史命令，以及快速输入文件，可以在命令行使用 `Ctrl-R` 和 `Ctrl+T` 使用。

#### Spacemacs 配置

脚本安装了 emacs 和 Spacemacs，配置文件 在 `~/.spacemacs`。第一次打开 emacs 会自动下载插件，需要翻墙。
Spacemace 结合了 vim 和 emacs 所有的快捷键
如何配置和使用 spacemacs 请参考官方文档： https://www.spacemacs.org/

spacemacs的按键模式有 `vim/emacs/hybrid`, 本人比较习惯 混合模式(hybrid)，以下为一些常用快捷键
```
SPC f f    ## 打开文件
SPC b b    ## 切换缓冲区
SPC b d    ## 关闭缓冲区
SPC f t    ## 打开文件侧边栏
SPC w 2    ## 分割缓冲区成2个
SPC p f    ## 在项目中查找文件，默认一个git库是一个项目
SPC p p    ## 切换项目
SPC p t    ## 打开项目文件侧边栏
SPC l l    ## 切换工作区(layout)
SPC p l    ## 切换到项目工作区
SPC c ;    ## 注释
SPC q q    ## 退出
```

更多高级功能请自行摸索.

#### Spacevim 配置

脚本同时也安装了 spacevim 和 neovim， 配置文件在 `~/.SpaceVim.d/init.toml`，建议先注释掉 所有有关 `lang` 和 `lsp` 的 layer, 再启动 `nvim`, 因为还需要给那些编程语言 layer 手动安装许多依赖，可以根据官方文档自行配置

SpaceVim 很多基础快捷键和 Spacemacs 很像，但是只能使用 vim 快捷键。

Vim 在终端操作比较友好，所以个人比较习惯在终端中使用vim快速编辑一些文件

#### 其他配置文件

`.xinitrc`, linux 终端登录时，当运行命令 `startx` 去启动图形界面, 会自动执行 `xinitrc` 里面的内容；如果不使用 `lightDM` 之类的 display manager， 需要进行定制; 

`.Xmodmap`,  重新映射键盘按键，这里主要是 将 `CapsLock` 映射成 `Ctrl` 键，这个配置文件有一点小瑕疵，如果有更好的，可自行替换。

`.xprofile`, 启动图形界面后，会执行这个文件，载入一些初始化

`.tmux.conf`, tmux 配置文件，后面的章节会涉及到

`.Xresource`, urxvt 终端的配置文件

`.proxychains`， 代理工具proxychains ，可以在终端启用 socket5 方式翻墙，更改配置文件指向socket5端口，启动方式运行 `proxychains <命令>`
如 `proxychains wget http://xxxx.com`

`.gitconfig` 全局的 git 配置， 自行设置 git 的账号
`.gitignore_global`, global ignore file

## 三、配置 urxvt

Urxvt 是一个可配置性非常高的一个 Linux 终端，所有配置信息都存储在 `~/.Xresouces`，通过配置文件，可以方便的进行重用。

配置文件中，主要就是配置字体，配色，以及一些快捷键。

字体我用的是，英文字体 - Monofur, 汉字-文泉驿黑体，特殊字符 - `DejaVuSansMono Nerd Font Mono`(均已通过脚本安装),
可以修改 `URxvt.font:xft:` 进行设置

快捷键：
```
Ctrl-Alt-C   ## 复制
Ctrl-Alt-V   ## 黏贴
Ctrl+向上箭头  ## 放大
Ctrl+向下箭头  ## 缩小
```

关于终端配色，自行谷歌 `urxvt theme`, 复制粘贴；emacs 和 vim 在终端配色难看，一般都是终端配色的问题。

一般我会在系统启动时启动 urxvt 的守护程序 `urxvtd -q -f`.
之后所有的终端可以通过运行 `urxvtc` 启动，这样的好处是加快打开终端的速度。坏处是单点故障。

更改完 Xresource 文件后，需要运行命令重新载入： `xrdb ~/.Xresources`

常用的一些命令行快捷键：
```
Ctrl-a      # 光标跳到命令行头
Ctrl-e      # 光标跳到命令行尾
Ctrl-w      # 删除前一个单词
Ctrl-f      # 光标前移一个字符
Alt-f       # 光标前移一个单词
Ctrl-b      # 光标后移一个字符
Alt-b       # 光标后移一个单词
Ctrl-k      # 删除所有之后的字符，配合 Ctrl-a， 删除整行命令

Ctrl-p      # 前一个执行命令
Ctrl-n      # 下一个执行命令
```

## 四、配置 tmux

`tmux` 是一个终端会话管理工具，配合各种终端，可代替一些终端的 TAB 。

tmux 有三个概念 `pannel`,`window`,`session`, 参考 https://www.zhihu.com/question/52147908
1. session是存储的是整个tmux记录，再次打开时读取的session信息．
2. 窗口在tmux中用数字0-9表示，当前屏幕可以展示某一个窗口．
3. pane是对窗口进行分割，也就是一个屏幕中可以有多个pane.

配置文件中使用了 tmux-tpm 来管理 tmux 插件，以下是一些快捷键, 可自行修改 prefix，我使用的 `O`

```
Ctrl-O c   # 创建新window
Ctrl-O 1/2/3/4/5/6/7 # 切换到窗口
Ctrl-O `   # 重命名window

Ctrl-O |   # 左右分割window，创建 panel
Ctrl-O -   # 上下分割window, 创建 panel
Ctrl-O x   # 删除当前 pannel
Ctrl-O z   # 最大化当前panel
Ctrl-O Ctrl-o # 轮换 panel
Ctrl-O h/j/k/l  # 切换到 左/下/上/右 的panel

Ctrl-O s   # 切换 Session
Ctrl-O d   # detach session

Ctrl-O [   # 进入预览模式，配合 emacs 快捷键使用（可设置成vim)； 按 q 退出；Ctrl-p Ctrl-n 向上/向下；
Ctrl-O ?   # 查看快捷键
```

配置文件中配置了一个自动保存会话的插件，下次启动 tmux 会自动启动保存的tmux会话，使用起来非常方便。

## 五、配置 Xmonad

Xmonad 是一个 windows manager, 主要作用是在桌面上平铺（tiling）窗口。参考： http://www.ruanyifeng.com/blog/2017/07/xmonad.html

### 手动准备

因为xmonad需要绑定很多快捷键，主要是 `Windows/Super` 按键, 第一步需要把 `xfce` 默认的按键绑定去掉。打开 `keyboard` 设置窗口，将 `Windows/Super` 和 `xfce4-popup-whiskermenu` 解绑

第二步要设置 xmonad 随 xfce 启动， 并替换 XFCE 默认的窗口管理器。打开 `Session ans Startup` 设置 > `Application Autostart` > `Add`， 添加 `xmonad --replace` 到启动命令。

这样下次重启之后，就会进入 `xmonad` 窗口管理。

### 常用快捷键

可参考 http://www.ruanyifeng.com/blog/2017/07/xmonad.html ，里面有一些常用快捷键方法。
同时参考配置文件 `~/.xmonad/xmonad.hs`，里面记录着快捷键配置

```
Win + \      ## 快速切换出 urxvt 终端，此终端默认绑定 tmux
Win + R      ## 快速启动程序(synapse)，类似Mac上的 alfred
Win + 1/2/3/4/5/6/7/9/0     ## 切换到虚拟桌面 1/2/3/4...
Shift + Win + 1/2/3/4/5     ## 移动当前窗口到虚拟桌面 1/2/3/4...
Win + -/=                     ## 调大/调小 音量
Win + Shift + -/=           ## 调大/调小屏幕亮度
Win + Shift + Enter         ## 打开一个 urxvtc 终端
Win + Space                 ## 切换布局方案
Ctrl + ;    Space            ## 切换到布局到独占窗口
Ctrl + ; O O                ## 网格 快速命令
Ctrl + ; P O                ## 运行命令
Alt + F3                    ## 关闭当前窗口
Ctrl + ; O L                ## 锁屏
Ctrl + ; O D                ## 打开目录
Win + Shift + P             ## 运行定制命令
```

### 定制 Xmonad

请根据 `~/.xmonad/xmonad.hs` 自行定制, 修改完成后，在命令行执行 `xmonad --recompile`, 进行语法检查，并重新编译。编译完成，重新登录或者重启系统。

高级玩家可以克隆 `https://github.com/bobzhangwz/xmonad.git`， 运行 IDE 进行编辑，编辑完成，并编译通过，复制 `Main.hs` 到 `~/.xmonad/xmonad.hs`。

#### 主要配置

`myGSCmd = [...]`, 配置一些快速运行的命令，运行快捷键 `Ctrl + ; O O` 调出

`myCommand = [...]`, 也是配置一些快速运行的命令，运行快捷键 `Win + Shift + P` 调出

`myStartupHook = [...]`, 配置一些随xmonad启动的程序，千万不能删除一下两个命令；其他请自行调整
```
spawn "sleep 2; xfce4-panel -r"
spawn "sleep 3; xcompmgr -c -C -t-5 -l-5 -r4.2 -o.55"
```

`myKeys`, `comboKeymap`, `scratchpadsKeymaps`, `myPromptKeymap` 配置一些按键绑定，请自行尝试

`myLayoutHook = [...]` 设置的是一些布局

`myManagerHook = [...]`, 设置那些应用自动那个虚拟桌面打开，会浮动/弹出还是自动被编排如布局，配置中将虚拟桌面划分为 10 个，给了它们不同的命名。配合运行命令 `xprop`, 查看应用窗口信息以及名字 
