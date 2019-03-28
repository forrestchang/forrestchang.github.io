
由于本人目前也处在学习的阶段，文章中列出来的内容也并未全部学习过，所以文章的客观性可能存在一些问题，还望读者自行判断。

这份指南会不定期更新，有好的建议也可以留言或者给我发邮件。

# 准备

需要的所有工具就是一台可以连接上网络的电脑以及你本人。

## 科学上网

很可惜，即使是现在，大部分学习计算机的学生还是不会科学上网。在当前的网络环境下，不会科学上网，意味着你不能用 Google 查资料，不能在 Hacker News 查看最新资讯，需要忍受龟速的 GitHub，云云。然而，科学上网本身却是一件成本非常低的事情，不想折腾的话，一年花个几百块钱买个现成的服务；有折腾精神的人，可以买个服务器自己假设架设上网工具。这一步很重要，不能跳过，否则后面指南中的许多内容都无法进行访问。

关于科学上网的具体内容，就不再多说了，给你一个关键词：**Lantern**。

## 学会使用 Google 搜索

学会了科学上网，你就能够使用 Google 了，为什么不是 Baidu？相信你用了 Google 之后就自然明白了。

当了一个学期的助教之后发现，很多的同学其实是没有使用搜索引擎的意识的，遇到问题要么自己死磕，或者就直接求助于他人。这两种都不是很好的办法，正确的做法是**在自己思考后没有结果，然后使用搜索引擎查找问题**，现阶段，你遇到的所有问题（几乎）都能在 Google 上找到现成的答案，如果没找到，肯定是你搜索的方式不正确。

使用Google的基本搜索功能就能够解决大部分问题了，当然，如果想要学习更加高级的技巧，这里有一份指南：[如何用好Google等搜索引擎？][1]。

## 英语

你不得不承认，目前为止，编程世界的主流语言还是英文，所以英语能力的好坏决定了你编程能力的上界。中文资料和英文资料相比，实在是太匮乏了，就质量而言，也相对较低。比如我后面提到的很多的课程，都是英文的内容。

值得庆幸的是，阅读编程资料所需要的英文水平并不需要很高，就个人经验来说，基本上四级水平就足够了，可能还会存在一些生词，但是基本上并不妨碍理解。

英文的学习应该一直贯穿于编程的学习之中，作为一门工具语言，只需要花少量时间就可以带来比较大的收益（2/8法则）。

本人的英文水平也不算好，但是基本上能够阅读技术书籍和文档，能够听懂公开课，所以还是有一些简单的经验可以分享一下。

### 把系统换成英文的

有些同学可能看到英文就头疼，这很正常，因为在中文的环境下面生活的太久了。为此，可以试着将平常用的系统换成英文的，虽说不能学到几个单词（Copy/Paste 之类的词），但是可以让你不那么排斥英文。

### 安装电子词典

OS X下推荐欧路词典，在APP Store中购买完整版的，因为需要添加外部的词典。

这里推荐一部比较好的词典：《Collins 英汉双解词典》，它是这个样子的：

![eudi][image-1]

主要看它的英文解释，一个词看得次数多了也就记住了。

### 每天阅读英文的资料

一些个人经常阅读的网站：

- [Quora][2]：一个类似于知乎的问答类网站，可以挑自己感兴趣的内容来阅读。
- [Hacker News][3]：互联网资讯，业界发生的最新的事件都会在上面。
- [PROGRAMMING][4]：Reddit 的 Programming 板块，和 Hacker News 类似，不过更加专注于技术内容方面。

**不要花太多时间在上面，每天浏览一下就行。**

## 英文学习的总结

英语不是能够速成的东西，也不是三言两语能够讲完的东西，这里只是提供一个简单的指导，具体的学习计划还请自行搜索更加专业的学习指南。

# 编程基础

完成了这一部分内容的学习后你应该具备：

- 了解什么是 Computer Science
- 基本的计算机数学能力
- 基本的程序开发能力
- 基本的算法与数据结构的知识

## 计算机科学导论

- [Introduction to Computer Science and Programming][5]：面向**无编程基础或者只有一点基础的人群**，使用**Python**作为教学语言。
- [Intensive Introduction to Computer Science Open Learning Course][6]：CS50，哈佛很火的一门课，在网易公开课上可以找到翻译的视频内容。涵盖的主题有算法（设计、应用、分析）；软件开发（抽象、封装、数据结构、Debug、测试）；计算机体系结构等等。基本上是一门大杂烩的导论课。使用的语言是**C**、**PHP**、**JavaScript**。
- [Programming Abstractions][7]：介绍了更加高级的编程主题（递归、算法分析、数据抽象等等），使用C++作为教学语言。

## 数学

- [Mathematics for Computer Science][8]：介绍了学习计算机所需要的一些数学知识，内容包括集合、关系、证明方法、数论、图论等等。
- [Discrete Mathematics][9]：离散数学。

## 编程语言

- [Learn to Program: The Fundamentals][10]：面向**无编程基础或者只有一点基础的人群**，使用**Python**作为教学语言。
- [Learn to Program: Crafting Quality Code][11]：如何编写高效与正确的代码。需要有[Learn to Program: The Fundamentals][12]的基础。
- [The Structure and Interpretation of Computer Programs][13]：经典的 SICP 的 Python 版。

## 计算理论

- [Introduction to the Theory of Computation][14]
- [Principles of Computing (Part 1)][15]：介绍了 CS 中基本的数学和编程理论，需要有**Python**基础。

## 算法与数据结构

- [Introduction to Algorithms][16]：MIT的算法导论课，用《算法导论》作为教材，网上可以找到视频资源，网易公开课上有老版的翻译。

# 核心课程

学完了「编程基础」部分的内容后，应该已经可以开发一些复杂的程序了，「核心课程」的内容将深入学习计算机科学理论的几个重要的内容。

## 数学

- [Coding the Matrix: Linear Algebra through Computer Science Applications][17]：线性代数以及在计算机中的应用。
- [Discrete Mathematics and Probability Theory][18]：离散数学与概率论。

## 计算理论

- [Theory of Computation - Fall 2011][19]：介绍了机器模型、上下文无关文法、图灵机等，使用的教材是 Michael Sipser 的 [Introduction to the Theory of Computation][20]。

## 算法与数据结构

- [Data Structures and Advanced Programming][21]
- [Efficient Algorithms and Intractable Problems][22]

## 操作系统

- [Operating Systems and Systems Programming][23]：UCB 经典的操作系统课程，介绍了操作系统的基本概念、系统编程、网络、分布式系统、内存分配、多线程等等。
- [Introduction to Linux][24]：介绍了 Linux 以及一些简单的命令行使用。

## 程序语言理论

- [Programming Paradigms][25]：编程范式。
- [Compilers][26]：Stanford 的编译原理课。
- [Principles of Programming Languages][27]

## 计算机体系结构

- [Computer Architecture][28]：CMU
- [Computer Architecture][29]

## 计算机网络

- [Computer Networks][30]
- [Fundamentals of Computer Networking][31]

# 编程工具

## IDE

- Python: [PyCharm][32]
- Java:[IntelliJ IDEA][33]
- C/C++: [Visual Studio][34]

## 编辑器

- Emacs/Vim
- Sublime Text 3
- VS Code
- Atom

并不一定要用 Emacs 或者 Vim，Sublime Text 其实已经很强大了，足够做日常简单的编辑工作。（这里黑一下 Atom，启动速度太感人了，所以放在最后一个。）

## Git & GitHub

使用版本控制来管理自己平时写的代码。

推荐阅读：

- [git-recipes][35]
- [Pro Git 2nd Edition][36]
- [Git教程 - 廖雪峰][37]

# 如何克服拖延

资料是有了，但是拖延症不去学怎么办？

- [番茄工作法][38]

# 参考资料

- [https://github.com/prakhar1989/awesome-courses][39]
- [http://blog.agupieware.com/2014/05/online-learning-bachelors-level.html][40]
- [https://docs.google.com/spreadsheets/d/1\_kdHrT8izbROJNaxGflpcZm2ivsjRGF8j1hMzl3b8O0/htmlview][41]
- [https://www.reddit.com/r/programming/wiki/faq][42]

[1]:	https://www.zhihu.com/question/20161362
[2]:	http://quora.com/
[3]:	https://news.ycombinator.com/
[4]:	http://www.reddit.com/r/programming/
[5]:	http://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-00sc-introduction-to-computer-science-and-programming-spring-2011/
[6]:	http://www.extension.harvard.edu/open-learning-initiative/intensive-introduction-computer-science
[7]:	https://www.youtube.com/view_play_list?p=FE6E58F856038C69
[8]:	http://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-042j-mathematics-for-computer-science-fall-2010/
[9]:	https://www.youtube.com/watch?v=h_9WjWENWV8&feature=share&list=PLTdIp1DywMlUpLHEg3ADhE6rrxhW_T5Rx
[10]:	https://www.coursera.org/course/programming1
[11]:	https://www.coursera.org/course/programming2
[12]:	https://www.coursera.org/course/programming1
[13]:	http://cs61a.org/
[14]:	https://www.youtube.com/playlist?list=PL601FC994BDD963E4
[15]:	https://www.coursera.org/course/principlescomputing1
[16]:	http://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-006-introduction-to-algorithms-fall-2011/
[17]:	https://www.coursera.org/course/matrix
[18]:	http://inst.eecs.berkeley.edu/~cs70/sp16/
[19]:	https://www.youtube.com/playlist?list=PLslgisHe5tBM8UTCt1f66oMkpmjCblzkt
[20]:	http://www.amazon.com/Introduction-Theory-Computation-Michael-Sipser/dp/113318779X
[21]:	http://www-inst.eecs.berkeley.edu/~cs61b/fa15/
[22]:	http://www.cs.berkeley.edu/~jrs/170/
[23]:	https://cs162.eecs.berkeley.edu/
[24]:	https://www.edx.org/course/introduction-linux-linuxfoundationx-lfs101x-2#!
[25]:	https://www.youtube.com/playlist?list=PL9D558D49CA734A02
[26]:	https://www.coursera.org/course/compilers
[27]:	http://freevideolectures.com/Course/2249/Principles-of-Programming-Languages/1
[28]:	https://www.youtube.com/playlist?list=PL5PHm2jkkXmgVhh8CHAu9N76TShJqfYDt
[29]:	https://www.coursera.org/course/comparch
[30]:	http://www.cs.berkeley.edu/~istoica/classes/cs268/10/
[31]:	https://www.youtube.com/channel/UCb1OiccPJ0wbMZMOleCvhWQ
[32]:	https://www.jetbrains.com/pycharm/
[33]:	https://www.jetbrains.com/idea/
[34]:	https://www.visualstudio.com/en-us/visual-studio-homepage-vs.aspx
[35]:	https://github.com/geeeeeeeeek/git-recipes/wiki
[36]:	http://git-scm.com/book/zh/v2?f=tt&hmsr=toutiao.io&utm_medium=toutiao.io&utm_source=toutiao.io
[37]:	http://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000
[38]:	http://www.pomodorotechnique.com/
[39]:	https://github.com/prakhar1989/awesome-courses
[40]:	http://blog.agupieware.com/2014/05/online-learning-bachelors-level.html
[41]:	https://docs.google.com/spreadsheets/d/1_kdHrT8izbROJNaxGflpcZm2ivsjRGF8j1hMzl3b8O0/htmlview
[42]:	https://www.reddit.com/r/programming/wiki/faq

[image-1]:	https://raw.githubusercontent.com/forrestchang/img-repo/master/20190326142830.png