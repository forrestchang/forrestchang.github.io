  
最近在看《Python for Data Analysis》（利用 Python 进行数据分析）这本书，贴一点笔记，这一篇是关于环境搭建的。另外吐槽一下，书中还是有不少错误的，语法错误就发现了好多处，大概读完了之后会整理出一份勘误表出来，可能是因为写书的时候是 14 年，两年过去了，pandas 库也有了一些变化。

## 安装虚拟环境

不想把系统的 python 库搞得乱乱的（其实已经很乱了），所以还是建一个独立虚拟环境专门来做科学计算吧。具体的方法我在[virtualenv 相关笔记](http://forrestchang.github.io/2016/07/17/virtualenv-notes/)这篇博客中已经详细写了，建议将启动虚拟环境的命令添加到终端的配置文件中去（使用`alias`），这样就避免每次一打开就输入一长串命令了。

因为科学计算社区的一些库还是基于 Python 2.x 版本的，所以这里我们使用的 Python 版本为 2.7。

然后使用以下命令一键安装所需要的库：

```shell
sudo pip install numpy pandas matplotlib jupyter scikit-learn
```

安装不上的请检查是不是需要翻墙。

## IPython

熟悉 Python 的同学应该对这个解释器不陌生，自带的 Python 解释器实在是太弱了。它与传统的“edit-compile-run”（编辑-编译-运行）方式的区别在于，它鼓励使用“execute-explore”（执行-探索），所以特别适合用在计算和数据分析领域，可以方便得使用「试错法」和「迭代法」进行开发。这里主要介绍它基于 Web 的交互式笔记本功能（命令行中大同小异）。

### 开启 IPython Notebook

使用以下命令来打开 IPython Notebook：

```shell
(ENV2.7)$ jupyter notebook
```

这样 server 就启动了，浏览器会自动打开一个目录树。

Note：记住在启动了虚拟环境的状态下使用这条命令，要不然就会使用系统的 IPython 版本来运行。

然后我们新建一个 IPython Notebook 用作演示：

![14776647413275](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190326145820.png)


`In [1]` 中的命令是为了能让我们直接在 IPython Notebook 中集成显示 `matplotlib` 画的图片，所以如果是用作科学计算的话，首先先执行以下这条命令再说。

### 内省

在变量的前面或后面加上一个 `?` 就可以将有关该对象的一些通用信息显示出来。

![14776649884990](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190326145843.png)

基本上什么都能看。

### `%run` 命令

使用 `%run` 可以运行本地的 Python 脚本，并可以在 IPython 中访问脚本中定义的所有变量。

如果想要脚本能够访问 IPython 中的命名空间，可以使用 `%run -i` 命令。

### 测试代码的执行时间

使用 `%time` 和 `%timeit` 可以用来测试代码的执行时间。

![14776653395450](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190326150005.png)

## Example

下面使用一个具体的例子来演示 IPython Notebook 的使用。

使用到的数据可以在[Beyond the Top 1000 Names](https://www.ssa.gov/oact/babynames/limits.html)下载到，这是一份包含1880-2015年每年出生婴儿姓名出现次数的数据表。

由于该数据按年份被分割成了好多文件，所以第一步我们需要把所有数据组装到一个 DataFrame 中去。

![14776659007521](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190326150028.png)

不知道这些 Python 代码没关系，因为这里只是用来演示 IPython Notebook。

然后我们按照性别和年度统计总出生数：

![14776660937109](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190326150107.png)

然后绘制出表格：

![14776661445090](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190326150149.png)


