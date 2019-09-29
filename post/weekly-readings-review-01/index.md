  
两年前曾经写过类似的文章：[这周在读什么 Issue#1](http://blog.jiayuanzhang.com/post/weekly-reading-report-issue-01/)，主要是为了分享一下最近在读、或者是看到的比较好的内容，但是没能坚持写下去，草稿箱里还躺着几篇未发布的阅读分享。这一次打算重写开始写，阮一峰老师已经写了[60 期](http://www.ruanyifeng.com/blog/2019/06/weekly-issue-60.html)了。

分享些什么内容？我的主要阅读来源是 Hacker News 和一些订阅的网站（我使用
inoreader RSS 服务），所以可能分享的大部分内容都是英文的，主题主要涵盖 **编程** 、 **创业** 、 **效率** 这三个方面，每一次分享我会分别推荐几篇文章并写一些简单的评论，这些文章并不一定是最近发布的，主要看我阅读的时间。

发布时间不定，但是保证一周至少发布一篇文章。

我的稍后读流程（之后会写一篇文章来详细说明）：

{{< figure src="https://raw.githubusercontent.com/forrestchang/img-repo/master/阅读流程.jpg" >}}

「每周评论」的标题借用陈独秀和李大钊在 1918 年创办的期刊&nbsp;[^fn:1]。


## 编程 {#编程}


### [Hacker Tools · hacker tools](https://hacker-tools.github.io/) {#hacker-tools-hacker-tools}

这是 MIT 开设的一门课程，主要介绍了一些程序员使用的工具。计算机作为我们使用的工具，肯定是越高效越好，如何才能变得高效？在我看来，主要有这几点：

1.  把重复性工作自动化，如果需要每天都重复做的事情，不如写几行脚本自动化；
2.  使用开源的工具，如果工具不适应你的工作流，完全可以自己动手改造它；
3.  KISS（Keep It Simple, Stupid）[^fn:2]，例如命令行工具是符合 KISS 的，但是可以通过组合不同的 KISS 工具实现复杂的功能（例如管道）。

Emacs 是一个 Hacker's Tool，这门课程中推荐使用 Vim（我推荐 Emacs 和 Vim 双修，使用 Emacs 的 Evil 模式）。

除了编辑器，这门课还讲了数据挖掘、版本控制系统、容器等内容，并且这门课在 Youtube
上有视频：[6.HT 2019 - YouTube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuiujH1lpn8cA9dsyulbYRv) 。


## 创业 {#创业}


### [There were 17,000 YouTubes Before YouTube](https://thenextweb.com/boris/2013/10/28/17000-youtubes-youtube/) {#there-were-17-000-youtubes-before-youtube}

在 Google launch 之前有 18 家做搜索引擎的，至少有两家和 Google 是做完全一样的业务；在 YouTube 之前有 17000 家（夸张？）做在线视频分享的服务；在 Facebook 前有
myspace、ICQ、MSN。

> In other words; nothing is new, everything is a copy of something, or at least
> an iteration on a previous idea.

Idea 被做过又怎么样，关键看你能不能有所创新或抓住时机。

> Their value is not in the idea itself, but the perfect timing and excution.

吸取别人失败的经验，站在巨人的肩膀上。

> The goal isn’t to reinvent the wheel or come up with an idea that no one else
> has ever come up with. You can be very successful just taking something that
> someone else failed at and do a better version, at a better time.


### [As a startup founder, what are the pros and cons of building something you would want to use yourself?](https://www.quora.com/As-a-startup-founder-what-are-the-pros-and-cons-of-building-something-you-would-want-to-use-yourself) {#as-a-startup-founder-what-are-the-pros-and-cons-of-building-something-you-would-want-to-use-yourself}

创业做自己想用的东西有什么优缺点？Quora 的 Founder 给出了回答。

> Building a product you would want to use yourself is motivating.
>
> It’s rare to hear about people who create software for fun that they themselves won’t use.

Motivation 可以让工作变得更加 enjoyable，连续加班也不觉得累，这是成功和个人发展的决定性因素。

> Second, if you use a product yourself, your intuition will point more closely
> toward the right strategy for the business.

总的来说，没有什么坏处，都是显而易见的好处。

为了创业而创业就会陷入下面的境地：

> If you are not a typical customer of your product, you can build up this
> intuition over time as you run a company, but you won’t start out with it,
> because you haven’t been exposed to customers’ preferences in a deep way. This
> can make it a lot harder to get initial traction or funding.


## 效率 {#效率}


### [Augmenting Long-term Memory](http://augmentingcognition.com/ltm.html) {#augmenting-long-term-memory}

Anki 是一个 Flashcard 软件，类似于 Supermemo，一般大家都用来背单词。这篇文章作者（是一个量子物理学家）介绍了他是如何用 Anki 来阅读论文的，包括如何在短时间内阅读并理解 AlphaGo 的论文。

Anki 是一个长期记忆的工具，你可以用它来记住任何东西。Anki 的算法完全是开源的，你可以在 GitHub 上看到它的源码：<https://github.com/dae/anki>

个人使用 Anki 的经验：

作为背单词的工具，可以配置 Chrome 或 Firefox 的插件「Anki 划词制卡助手」，可以在阅读网页的过程中自动查词并保存到 Anki 对应的 Deck 中，还包含了阅读时的上下文。

{{< figure src="https://raw.githubusercontent.com/forrestchang/img-repo/master/20190726124109.png" >}}

图中绿框内即为当时阅读时的上下文，这种情境式背单词的方法比直接拿一本单词书来背效果好太多。

除了用 Anki 来背单词，还可以用它来做卡片笔记，纳博科夫[^fn:3]就是使用卡片笔记来写作的。这种单个的卡片笔记方便记忆（一张卡片就一个知识点），例如下面是我记的一个卡片笔记：

{{< figure src="https://raw.githubusercontent.com/forrestchang/img-repo/master/20190726124607.png" >}}

[^fn:1]: : [每周评论 - 维基百科，自由的百科全书](https://zh.wikipedia.org/wiki/每周评论)
[^fn:2]: : [KISS principle - Wikipedia](https://en.wikipedia.org/wiki/KISS%5Fprinciple)
[^fn:3]: : [弗拉基米爾·弗拉基米羅維奇·納博科夫](https://zh.wikipedia.org/wiki/%E5%BC%97%E6%8B%89%E5%9F%BA%E7%B1%B3%E7%88%BE%C2%B7%E5%BC%97%E6%8B%89%E5%9F%BA%E7%B1%B3%E7%BE%85%E7%B6%AD%E5%A5%87%C2%B7%E7%B4%8D%E5%8D%9A%E7%A7%91%E5%A4%AB)

