  
在OS X平台下，一直没有用到一个很顺手的输入法。系统自带的输入法虽然经过几次的版本更新已经有了很大的改进，但是离能用还有很大的距离。所以之前一直凑合着使用百度输入法，不过最近一直遇到一些奇怪的问题，官方又长时间没有进行更新，恰逢之前听说过`Squirrel`这个输入法，于是就本着试用的心态用了一下，发现异常顺手，并且还有丰富的定制性，于是写一篇文章来介绍一下，也作为自己配置过程中的笔记。

附上一段Gif效果展示：

![luoshenfu](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190326141508.png)

## 介绍

输入法的官方名称是`Rime`，中文名是`中州韵输入法`，但是在各自的平台下面又有不一样的别名。

- Linux
	中州韵 ｜ ibus-rime

- Windows
	小狼毫 ｜ Weasel

- OS X
	鼠须管 ｜ Squirrel

使用了一段时间发现它有以下几个优点其他输入法是比不上的：

1. 速度很快，几乎没有延迟的时间
2. 极强的定制性，如果没有想要的功能还可以直接修改源码
3. 跨平台
4. 对于繁体中文支持非常好

## 安装

直接从官网下载安装包安装即可。

Rime官网：[](http://rime.im/)

使用`Ctrl-~`进行输入法的选择，这里选择`朙月拼音・簡化字`即可：

![rime02](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190326141701.png)

## 配置

默认的的配置其实已经可以使用了，但是为了更加符合自己的使用习惯，我们需要做一些自定义的配置。

所有的配置文件都保存在`~/Library/Rime/`这个目录下面。

不建议直接修改原先的配置文件，因为这样更新之后会导致修改的内容丢失，正确的做法是建立`custom`副本，这样自定义的配置内容会覆盖掉原来的。

＊注：所有的修改完成了之后都需要重启输入法，快捷键`Option+Ctrl+~`。

### 配置外观

初始的外观不是很符合自己的审美，可以进行更换主题、更改字体和字号大小等操作来配置成自己喜欢的样子。

新建配置文件

```
touch squirrel.custom.yaml
```

然后将以下代码写入配置文件

```
patch:
  style/color_scheme: dark_temple #主题
  style/font_point: 18 #字号大小
  style/horizontal: true #水平显示待选字
```

#### 主题列表

自带的主题代码:

```
#   注：预设的配色方案及代码（指定为 style/color_scheme ）
#   碧水 - aqua
#   青天 - azure
#   明月 - luna
#   墨池 - ink
#   孤寺 - lost_temple
#   暗堂 - dark_temple
#   星际我争霸 - starcraft
#   谷歌 - google
#   晒经石 - solarized_rock
#   简约白 - clean_white
```

想要更换什么主题只要把代码替换掉就可以了。

#### 其他一些配置代码及其说明

```
  style/page_size: 8			             # 设定候选词数目
  style/inline_preedit: false              # 关闭内嵌编码，这样就可以显示首行的拼音
  style/corner_radius: 10                  # 窗口圆角半径
  style/border_height: 0                   # 窗口边界高度，大于圆角半径才有效果
  style/border_width: 0                    # 窗口边界宽度，大于圆角半径才有效果
  style/line_spacing: 1                    # 候选词的行间距
  style/spacing: 5                         # 在非内嵌编码模式下，预编辑和候选词之间的距
  style/font_face: "Hiragino Sans GB W3"   # 字体名称
```

更多的一些配置代码可以在`squirrel.yaml`中找到。

### 定制标点符号

鼠须管有一个特别的功能就是输入一个标点的时候可以有很多的候选标点让你选择，比如说中括号：

![rime03](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190326141747.png)


但是有的时候默认就想选择第一个，多出了一个选择的步骤无疑上会增加击键的次数，所以我们可以通过修改配置来解决这个问题，同时也可以自定义想要输入的符号。

这里我们使用的是`朙月拼音・簡化字`，所以需要建立相应的配置文件：

```
touch luna_pinyin_simp.custom.yaml
```

然后写入以下配置（可根据自己的需要修改，这里的代码的意思是在全角和半角的状态下输入`<`均以`《`输出）。

```
patch:
  punctuator/full_shape:
    "<": "《"
  punctuator/half_shape:
    "<": "《"
  punctuator/full_shape:
    ">": "》"
  punctuator/half_shape:
    ">": "》"
```

### 安静模式

之前一直使用百度输入法的原因就是因为它有一个安静模式，可以在特定的程序内关闭输入法，比如说`Emacs`中大部分时间都是不需要输入中文的，所以当切换到这个程序的时候就自动将输入法切换到英文模式。

需要找到应用软件的`Bundle Identifier`，保存在`Info.plist`这个文件当中。

修改`squirrel.custom.yaml`（没有自己创建）：

```
patch:
  style/color_scheme: dark_temple
  style/font_point: 18
  style/horizontal: true

  app_options/com.apple.Xcode:
    ascii_mode: true
  app_options/com.runningwithcrayons.Alfred-2:
    ascii_mode: true
```

## 快捷键

鼠须管默认支持`Emacs`的快捷键，所以基本上在`Emacs`中使用到的一些操作方式都可以在这里使用到。

- ↑：Control+p
- ↓：Control+n
- ←：Control+b
- →：Control+f
- 上頁：Alt+v
- 下頁：Control+v
- 句首：Control+a
- 句末：Control+e
- 回退：Control+h
- 刪除：Control+d
- 清空：Control+g
- 刪詞：Control+k

## 其他

完成以上的配置之后基本上就能够用得很顺手了，更多高级的配置方法可以参考官方的文档：[幫助與反饋](http://rime.im/docs/)

## 参考资料
- [官方文档](http://rime.im/docs/)
- [安装及配置 Mac 上的 Rime 输入法——鼠鬚管 (Squirrel)](http://www.dreamxu.com/install-config-squirrel/)

