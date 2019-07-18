
最近开始重新使用 org-mode，在这之前大概有一年左右的时间，慢慢把一些东西从
org-mode 转移到别的工具上了，比如利用 OmniFocus 来管理任务，用 Devonthink 来管理笔记，用 Ulysses 来写作。虽然这些工具非常好用，但是总能找到一两个不满意的点，为此还写了不少脚本进行优化（这些 App 均支持 AppleScript），既然都是要写代码才能完全满足使用需求，不如直接使用 Emacs 来做这些事好了（目前已经将任务管理系统又迁移到 org-mode 上来了）。

<div class="sidenote">
  <div></div>

This is a test side note

</div>

从 [上篇文章](http://blog.jiayuanzhang.com/post/use-devonthink-to-write-blog/) 可以知道，我开始使用 Devonthink 来写博客，配合 Alfred 的 Workflow 可以方便地生成 Hugo 的博客文章，其实就是简单地将 Devonthink 中的 Metadata 生成
YAML 格式的内容插入到 Markdown 文件中。

如果你只使用 Markdown 来写作的话，这种写博客的流程是非常好的，配合一个 Markdown
编辑器（推荐 iA Writer），Devonthink 可以方便的作为管理博客文章的前端，另外再配合我写的 Alfred 全局搜索（支持拼音） Workflow，可以快速地找到所写的内容。

但是，比起 Markdown，我更喜欢用 org-mode 来写东西。所以，我需要对上面这些流程做一些 Hack，其实也非常简单：

1.  在 Devonthink 中建立 org 格式的文件（在 Devonthink 显示为 plain-text）；
2.  调用 Emacs 来打开这个文件（Open with Emacs，或者可以写一个脚本用 Alfred 来调用打开）；
3.  在 Emacs 中使用 org-mode 来完成写作；
4.  修改之前的 Alfred Workflow，检测到是 `.org` 格式的文件就用 Pandoc 转换为 Markdown；
5.  利用 Hugo 生成博客内容。

既然都使用 Emacs 来写了，不如直接舍弃 Devonthink 这个前端（Emacs 同样支持拼音搜索等功能），搜索了一下，发现了 ox-hugo 这个 Emacs package，这个 package 的优点在于：不需要舍弃掉之前用 Markdown 写的文章，可以在这个基础上继续用 org-mode 来写，即使之后想放弃 ox-hugo 了，也可以继续修改生成的 Markdown 文件。

这篇文章我主要介绍一下如何使用 ox-hugo 来写博客，顺便介绍一下我的博客工作流，如果你是使用 Emacs 自带的 org-publish 而不是 Hugo 等外部静态网站生成工具的话，可以参考我几年前写的一篇文章：[使用 Emacs Org-mode + GitHub Pages 来写博客 -
Jiayuan's Blog](http://blog.jiayuanzhang.com/post/how-to-use-emacs-and-org-mode-to-build-a-blog/)。

主要用到的工具：

-   Emacs + org-mode：写作 & 管理工具
-   Alfred：脚本快速执行工具
-   PicGo：图床工具

{{< figure src="https://raw.githubusercontent.com/forrestchang/img-repo/master/20190606165847.png" >}}


## 安装与配置 ox-hugo {#安装与配置-ox-hugo}

我使用的 Emacs 配置是 [Doom Emacs](https://github.com/hlissner/doom-emacs/tree/develop/)，我在 [Hacking log #001 编写 Doom Emacs
private module](https://www.bilibili.com/video/av54257764) 这个视频里有详细讲解如何使用 Doom Emacs 来安装第三方的 Package 以及如何编写自己的 module。这里我们把 ox-hugo 添加到自己的 `my-org` module 中，非
Doom Emacs 的用户可以参考官方文档来进行配置：[ox-hugo - Org to Hugo exporter](https://ox-hugo.scripter.co/)。

首先在 `my-org/packages.el` 中添加 ox-hugo：

```elisp
;; packages.el
(package! ox-hugo)
```

然后修改 `my-org/configle.` ，使用 Doom Emacs 自定义的 `def-package!` macro，其他用户可以使用 `use-package` 或者直接使用 `require` 来进行导入。

```elisp
;; config.el
(def-package! ox-hugo
  :after ox
  )
```


## 开始写作 {#开始写作}

ox-hugo 支持两种方式来管理 org 格式的博客文章，一种是所有的文章都放在同一个 org
文件里，另一种是对不同的文章使用独立的 org 文件。因为最终都是导出 Markdown 格式的文件，所以这两种方法本质上并没有什么区别。

这里推荐对于非长篇类的文章可以使用同一个 org 文件进行管理，这种方法可以方便地使用 org-mode 提供的 Tag 继承功能；针对于长篇的文章，可以直接使用单独的 org 文件。

这边简单介绍一下如何使用单个的 org 文件来管理博客文章，首先需要两个全局的
Property： `HUGO_SECTION` 和 `HUGO_BASE_DIR` ，

-   `HUGO_SECTION`: 这个是指定导出的内容在 content 目录所在的路径，例如我的博客文章的 Markdown 文件是放在 `/content/post` 下的，那么这边的值就是 `post` ；
-   `HUGO_BASE_DIR`: 博客的根目录，例如我的 Hugo 博客是在 `~/Dropbox/blog` 下，那么这边的值就是 `~/Dorpbox/blog` 。

其他一些设定可以参考我的 [org raw file](https://raw.githubusercontent.com/forrestchang/blog-raw/master/content-org/post.org?token=AB36HZWPBHGMFX4PTQUDJB247MWO4)。

ox-hugo 使用 org-mode 中的 Tag 来标记文章的 Category 和 Tags，使用 `@` 开头的
Tag 为 Category，其他的为普通的 Tags，利用 org-mode 的特性，我们可以方便地继承上级的 Tag，例如：

```org
* Programming :@Programming:
** TODO New post
:PROPERTIES:
:EXPORT_FILE_NAME: new-post
:END:
This is a test post.
```

其中 `Programming` 下的文章都会被分类到 `Programming` Category 中去。

一篇文章有两个状态： `TODO` 和 `DONE` ，TODO 代表的是未发布的文章，在生成的
Markdown 元数据中 `draft=true` ，DONE 代表已完成的文章，DONE Date 会被作为发表的时间戳。TODO 和 DONE 的关键字是可以自己指定的，具体可以参考官方文档：[Org
meta-data to Hugo front-matter — ox-hugo - Org to Hugo exporter](https://ox-hugo.scripter.co/doc/org-meta-data-to-hugo-front-matter/) 。

另一个比较重要的参数是 `EXPORT_FILE_NAME` ，这个参数控制了导出时的文件名，例如上面这个例子中导出后就为 `new-post.md` 。

ox-hugo 的导出方式也非常简单，使用 `C-c C-e` 就可以呼出导出菜单，然后选择 `H H`
就会把当前文章导出到 Hugo 的目录下。

{{< figure src="https://raw.githubusercontent.com/forrestchang/img-repo/master/20190608114908.png" >}}


## 开启自动 Export {#开启自动-export}

ox-hugo 的官方文档中介绍了一种自动 Export 的方式，只要保存了 org 格式的文章，就可以直接导出 Hugo 中。

首先需要在配置中 load org-hugo-auto-export-mode：

```elisp
(def-package! org-hugo-auto-export-mode)
```

然后在 Hugo 的根目录下建立 `.dir-locals.el` 文件：

```elisp
(("content-org/"
  . ((org-mode . ((eval . (org-hugo-auto-export-mode)))))))
```

Reload 一下 Emacs 的配置就可以自动 Export 了，配合 `hugo serve -D` 命令，可以做到实时预览。

{{< figure src="https://raw.githubusercontent.com/forrestchang/img-repo/master/20190608115739.png" >}}


## 使用 PicGo + GitHub 来搭建图床 {#使用-picgo-plus-github-来搭建图床}

博客的写作中难免会用到一些图片素材，目前我使用 PicGo + GitHub 来作为博客的图床，除了 GitHub 之外，PicGo 还支持很多其他图床。

使用起来也非常简单：

1.  调用截图工具截图（图片自动保存到剪贴板中）
2.  调用快捷键使用 PicGo 上传图片到 GitHub（可以在 PicGo 中自定义）
3.  自动生成 org link 格式的图片链接地址到剪贴板中

具体的配置方法可以参照下面两个链接：

-   PicGo: <https://github.com/Molunerfinn/PicGo>
-   GitHub 图床的配置方法：<https://picgo.github.io/PicGo-Doc/zh/guide/config.html>


## 快速获取 Chrome 超链接 {#快速获取-chrome-超链接}

写文章的时候需要一些参考链接，这个可以借助 AppleScript 和 Alfred 来完成。

实现方式非常简单，使用 AppleScript 获取当前 Chrome 的链接和 title，并组合成对应格式的链接地址（markdown 或者 org-mode）放到剪贴板中，然后使用 Alfred 来调用。

生成 org-mode link 的代码可以参考我写的这个：

```applescript
tell application "Google Chrome"
  set tab_link to (get URL of active tab of first window)
  set tab_title to (get title of active tab of first window)
  set org_link to ("[[" & tab_link & "]" & "[" & tab_title & "]]")
  set the clipboard to org_link
  display notification org_link with title "成功复制当前标签页链接到剪贴板"
end tell
```
