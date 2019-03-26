
这个博客就是使用Emacs org-mode + GitHub Pages搭建的，博客的主题是org-mode官网的主题，非常的简洁；评论采用的disqus，访问统计使用的是Google和Baidu的统计代码。

另外，本文中进行操作的环境是在OSX下完成的，Windows用户请自行参考脑补:)

## 起因

之前也折腾过好多的博客，Jekyll、Hexo、Farbox等，这些静态博客生成器都有一个共同点，都是采用的Markdown语法来进行书写的，而自己平时记笔记都是使用的Emacs org-mode，这样就导致了记笔记和写博客两个过程分裂开来了。

昨晚偶然看到[dirtysalt's homepage](http://dirlt.com/)，被深深的震撼了，博主写了很多的干货，专注与博客的内容而不是博客的外观。而自己也是一个极简主义者，觉得这样的博客样式还是挺好看的（很有Web1.0时代的复古风啊）。恰巧博主也是使用的Emacs来写博客，于是便花了一个上午的时间搜集相关的资料并把博客搭建起来了。

## 准备

### GitHub帐号与GitHub Pages

首先你需要一个存放博客的地方，这里采用的是GitHub，当让也可以使用其他的服务，只要支持静态页面展示即可。

GitHub的注册过程省略。

注册完GitHub帐号之后建立一个新的仓库，命名为 `xxx.github.io` ，其中 `xxx` 为你的用户名。

### Emacs环境

我使用的是最近比较火的[spacemacs](https://github.com/syl20bnr/spacemacs) ，很多功能都配置好了，基本上手即用。

如果不是用的spacemacs，确保你的Emacs版本为24，org-mode版本为8.0以上，不排除可能因为版本的原因出现各种各样的错误。

什么，你还不知道Emacs是什么，那先去下载一个Emacs吧，使用org-mode基本不需要什么Emacs的基础，只需要记住几个快捷键就可以了。

## 建立目录结构

随便在哪里建一个心得目录，这个目录就是存放你的org文件和html文件的地方。假设我们已经有了这么一个目录 `org` ：

```
$ mkdir notes
$ mkdir public_html
$ mkdir gtd
```

当然，那个gtd目录你可以不要，那是用来做时间管理的，如果你不想用Emacs做时间管理的话，可以不用建那个目录。

- notes: 这个目录就是用来存放元数据的地方，你的org文件、图片、CSS文件、PDF等全都是存放在这里的。
- public_html: 这个目录是用来存放导出的HTML文件的，那些非org格式的文件还会原封不动地拷贝过来。

## 配置Emacs

这一步有一些复杂，没有Elisp基础的同学可能看不怎么懂，不过没关系，照着做就是了，现在看不懂可以以后学嘛。

Emacs org-mode自带了很强大的导出功能，可以导出成HTML、markdown、PDF等格式的文件，我们这里使用自带的导出Project的功能，只不过在导出之前，要做一些配置，告诉Emacs要导出哪些东西，导出到哪里，采用什么规则。

首先我们在配置文件中添加以下代码（普通的在.emacs中添加，spacemacs用户在.spacemacs中添加）：

``` lisp
  (require 'ox-publish)
  (setq org-publish-project-alist
        '(

          ;; 把各部分的配置文件写到这里面来

          ))
```

然后把其他的配置文件依次添加进来就可以了，主要有生成HTML的部分和原样拷贝的部分。

下面来配置需要转换成HTML的内容：

``` html
  ("blog-notes"
   :base-directory "~/org/notes"
   :base-extension "org"
   :publishing-directory "~/org/public_html/"
   :recursive t
   :publishing-function org-html-publish-to-html
   :headline-levels 4             ; Just the default for this project.
   :auto-preamble t
   :section-numbers nil
   :author "Yourname"
   :email "example@test.com"
   :auto-sitemap t                ; Generate sitemap.org automagically...
   :sitemap-filename "sitemap.org"  ; ... call it sitemap.org (it's the default)...
   :sitemap-title "Sitemap"         ; ... with title 'Sitemap'.
   :sitemap-sort-files anti-chronologically
   :sitemap-file-entry-format "%d %t"
   )
```

- :base-directory - 你存放笔记的目录（想将哪里的org文件导出成HTML）
- :base-extension - 导出的文件格式
- :publishing-directory - 导出HTML的目标目录
- :recursive - 设置为t会将子目录中的文件也导出
- :publishing-function - 使用哪个函数来进行publish（注：org 7与8在这个地方有区别）
- :auto-sitemap - 自动生存sitemap
- :sitemap-sort-files - 我这里采用的是按照从新到旧的排列方式
- :sitemap-file-entry-format - 这里采用时间+标题的方式生成sitemap

并不是所有的文件都需要转化为HTML的，比如说一些图片、PDF、CSS样式等，只需要原样拷贝到目标文件就行，配置代码如下：

``` lisp
  ("blog-static"
   :base-directory "~/org/notes"
   :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
   :publishing-directory "~/org/public_html/"
   :recursive t
   :publishing-function org-publish-attachment
   )
```

把这两段代码查到刚刚给的框架里面去即可。

最后，我们再加一段代码：

``` lisp
  ("blog" :components ("blog-notes" "blog-static"))
```

至此，基本的配置已经完成了，现在可以写一些org文件来生成HTML了。

比如说我已经写完了一些org文件：

```
.
├── blog-history.org
├── css
│   └── worg.css
├── cv.org
├── front-end-development
│   ├── css.org
│   └── html.org
├── how-to-use-org-mode-build-blog.org
├── index.org
├── personal
│   ├── how-to-study-efficiently.org
│   └── index.org
└── sitemap.org
```

然后使用`M-x org-publish-project`，输入`blog`，就会自动开始生成HTML文件了，现在已经可以在public_html文件夹中访问了。

当然，index页面是需要自己来写的，可以参照我的主页来写，或者自由发挥。

## 个性化定制

### 添加CSS文件

首先需要在notes文件夹内新建一个css文件夹，里面保存需要用到的CSS文件，这里我使用的是org-mode官网上用的CSS文件，非常的简洁。

然后我们需要在 `blog-notes` 这个配置中新增一条属性：

``` lisp
 :html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/worg.css\"/>"
```

这样子的话再每次生成HTML的时候都会自动加上CSS，这里建议使用绝对路径来访问css文件，要不然在notes文件夹中新建文件夹的时候就无效了。

### 添加评论功能

这里使用的Disqus的评论系统，使用Duoshuo的话配置过程应该也一样。

首先在Disqus中注册一个服务，获得一段代码，在 `blog-notes` 中新增加一条属性：

``` lisp
  :html-postamble "<p class=\"postamble\">Last Updated %C. Created by %a</p>
  <div id=\"disqus_thread\"></div>
  <script type=\"text/javascript\">
  var disqus_shortname = 'yourshortname';
  (function() {
           var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
           dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
           (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
           })();
  </script>
  "
```

需要注意的是代码中的双引号前面需要加上反斜杠来转义。

### 添加统计功能

使用百度和Google的统计服务，和添加评论功能类似，还是添加在这条属性里面：

``` lisp
    :html-postamble "<p class=\"postamble\">Last Updated %C. Created by %a</p>
  <script>
  var _hmt = _hmt || [];
  (function() {
           var hm = document.createElement(\"script\");
           hm.src = \"//hm.baidu.com/hm.js?yourkey\";
           var s = document.getElementsByTagName(\"script\")[0];
           s.parentNode.insertBefore(hm, s);
           })();
  </script>

  <div id=\"disqus_thread\"></div>
  <script type=\"text/javascript\">
  var disqus_shortname = 'yourshortname';
  (function() {
           var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
           dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
           (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
           })();
  </script>

  <script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
           (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
           m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
           })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'yourkey', 'auto');
  ga('send', 'pageview');

  </script>
  "
```

同样注意双引号的转义问题即可。

## 托管到GitHub上

生成了HTML文件之后需要把public_html目录托管到GitHub上：

```
$ git add .
$ git commit -m "first commit"
$ git remote add origin xxx
$ git push -u origin master
```

其中`xxx`为你之前创建仓库的SSH路径。以后每次generate之后add、commit、push就可以了。

现在访问 `xxx.github.io` 已经可以看到你的博客啦：）