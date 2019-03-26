
## Shell 的基本操作

### 常用快捷键

按键 | 作用
------- | -------
`Tab` | 命令补全
`Ctrl+c` | 强行终止当前程序
`Ctrl+d` | 键盘输入结束或退出终端
`Ctrl+s` | 暂定当前程序，暂停后按下任意键恢复运行
`Ctrl+z` | 将当前程序放到后台运行，恢复到前台命令 `fg`
`Ctrl+a` | 将光标移动到行首
`Ctrl+e` | 将光标移动到行尾
`Ctrl+k` | 删除从光标所在位置到行末
`Alt+Backspace` | 向前删除一个单词

### 常用通配符

字符 | 含义
------- | -------
`*` | 匹配0或多个字符
`?` | 匹配任意一个字符
`[list]` | 匹配 list 中的任意单一字符
`[!list]` | 匹配除 list 中的任意单一字符以外的字符
`[c1-c2]` | 匹配c1-c2中的任意单一字符，如[0-9][a-z]
`{string1,string2,...}` | 匹配其中一个字符串
`{c2..c2` | 匹配c1-c2中全部字符，如{1..10}

## 用户管理

### 查看用户

```
$ who am i
```

或者

```
$ who mon likes
```

`who` 命令其他常用参数

参数 | 说明
-----|-----
`-a` | 打印能打印的全部
`-d` | 打印死掉的进程
`-m` | 同 `am i`, `mom likes`
`-q` | 打印当前登陆用户数及用户名
`-u` | 打印当前登陆用户登陆信息
`-r` | 打印运行等级

### 创建用户
 
创建用户需要 `root` 用户的权限，所以需要使用 `sudo` 这个命令。使用 `sudo` 名利需要满足两个条件：

1. 知道当前登陆用户的密码
2. 当前用户必须在 `sudo` 用户组

```
$ su <user> # 切换用户到 user
```

```
$ sudo <cmd> # 以 root 权限运行命令
```

```
$ su - <user> # 切换用户，并且环境变量同时改变到目标用户的环境变量
```

新建用户命令：

```
$ sudo adduser <username>
```

创建用户的同时会为用户创建 home 目录。

### 用户组

在 Linux 中每个用户都有一个用户组，它们共享一些资源和权限，同时拥有私有资源。

#### 查看自己的用户组

```
$ groups <username>
```

或者，查看`/etc/group`文件

```
$ cat /etc/group | sort
```

`sort` 表示将读取的文本进行一个字典排序再输出。

##### `etc/group` 文件格式说明

/etc/group 的内容包括用户组（Group）、用户组口令、GID 及该用户组所包含的用户（User），每个用户组一条记录。格式如下：

> group_name:password:GID:user_list

#### 将其他用户加入 sudo 用户组

使用 `usermod` 命令可以为用户组添加用户，使用该命令需要有 root 权限。

使用一个具有 root 权限的用户为一个不具有 root 权限的用户添加 `sudo` 权限：

```
$ sudo usermod -G sudo <username>
```

### 删除用户

```
$ sudo deluser <username> --remove-home
```

## 文件权限

### 查看文件权限

```
$ ls -l
```

![](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190326143412.png)

![](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190326143425.png)

![](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190326143435.png)

#### 文件类型

Linux 里面一切皆文件。

#### 文件权限

- 读权限：可以读取某个文件的内容
- 写权限：可以编辑和修改某个文件
- 执行权限：通常指可以运行的二进制程序文件或者脚本文件

注：一个目录要同时具有读权限和执行权限才可以打开，要有写权限才允许在其中创建其他文件。Linux 不是用过文件的后缀名来区分文件的类型。

#### 链接数

链接到该文件所在的 inode 结点的文件名数目。

### 修改文件权限

#### 方法1：二进制数字表示

![](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190326143447.png)

修改 `<filename>` 只能自己使用：

```
$ chmod 700 <filename>
```

#### 方法2：加减赋值操作

```
$ chmod go-rw <filename>
```

'g''o'还有'u'，分别表示group，others，user，'+'，'-' 就分别表示增加和去掉相应的权限。


## 目录结构

Windows 是以存储介质为主的，之下才是目录；而 Unix 是以目录为主的，存储介质是挂载在目录上的。Linux 以树形目录结构的形式来构建整个系统。

### FHS 标准

> FHS（英文：Filesystem Hierarchy Standard 中文：文件系统层次结构标准），多数 Linux 版本采用这种文件组织形式，FHS 定义了系统中每个区域的用途、所需要的最小构成的文件和目录同时还给出了例外处理与矛盾处理。

FHS 定义了两层规范，第一层是，/下面的各个目录应该要放什么文件数据，例如 /etc 应该要放设置文件，/bin 与 /sbin 则应该要放置可执行文件等等。

第二层则是针对 /usr 及 /var 这两个目录的子目录来定义。例如 /var/log 放置系统登录文件，/usr/share 放置共享数据等等。

![](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190326143513.png)

FSH 是根据以往无数 Linux 用户和开发者的经验总结出来的，并且会持续更新，FSH 依据文件系统使用的频繁与否以及是否允许用户随意改动，将目录定义为四中交互作用的形态，如下表示：

![](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190326143527.png)

### 目录路径

#### 绝对路径

以根目录为起点的完整路径。

#### 相对路径

相对于你当前目录的路径。

## 文件的基本操作

### 新建

#### 新建空白文件

```
$ touch test
```

关于 `touch` 命令，其主要是用来更改文件时间戳的。

#### 新建目录

```
$ mkdir testDir
```

使用 `-p` 参数，可以创建一个多级目录，例如：

```
$ mkdir -p father/son/grandson
```

### 复制

#### 复制文件

```
$ cp test testDir
```

#### 复制目录

```
$ cp -r father family
```

### 删除

```
$ rm test
```

参数 `-f` 可以强制删除一些为只读权限的文件。

```
$ rm -f test
```

删除一个目录：

```
$ rm -r testDir
```

### 移动文件

```
$ mv testFile testDir
```

### 重命名文件

`mv` 命令还有重命名的作用：

```
$ mv oldName newName
```

### 查看文件

#### `cat` 与 `tac`

这两个命令都是用来打印文件内容到标准输出（终端），其中`cat` 为正序显示，`tac` 为倒序显示。

> 标准输入输出：当我们执行一个 shell 命令行时通常会自动打开三个标准文件，即标准输入文件（stdin），默认对应终端的键盘；标准输出文件（stdout）和标准错误输出文件（stderr），这两个文件都对应被重定向到终端的屏幕，以便我们能直接看到输出内容。进程将从标准输入文件中得到输入数据，将正常输出数据输出到标准输出文件，而将错误信息送到标准错误文件中。

可以使用`-n` 参数来显示行号：

```
$ cat -n <filename>
```

#### `nl`

添加行号并打印，比 `cat` 更加强大，参数说明：

```
-b : 指定添加行号的方式，主要有两种：
    -b a:表示无论是否为空行，同样列出行号("cat -n"就是这种方式)
    -b t:只列出非空行的编号并列出（默认为这种方式）
-n : 设置行号的样式，主要有三种：
    -n ln:在行号字段最左端显示
    -n rn:在行号字段最右边显示，且不加 0
    -n rz:在行号字段最右边显示，且加 0
-w : 行号字段占用的位数(默认为 6 位)
```

### 查看文件类型

使用 `file` 命令来查看文件类型：

```
$ file /bin/ls
```

![](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190326143553.png)

这表示这是一个可执行文件。

## 环境变量

### 变量

使用`declare`命令可以创建一个变量：

```
$ declare tmp
```

读取变量的值，使用`echo`命令和`$`符号：

```
$ echo $tmp
```

### 环境变量

环境变量就是作用域比自己定义的变量要大，如 Shell 的环境变量作用于自身和它的子进程。例如 Shell 环境变量作用于自身和它的子进程。在类 UNIX 系统中，每个进程都有其各自的环境变量设置，当一个进程被创建时，处理创建过程中明确指定的话，它将继承其父进程的绝大部分环境设置。

通常我们会涉及到的环境变量有三种：

- 当前 Shell 进程私有用户自定义变量，只在当前 Shell 中有效
- Shell 本身内建的变量
- 从自定义变量导出的环境变量

`set`, `env`, `export`这三个命令可以用来打印相关环境变量，区别在于涉及的是不同范围的环境变量：

命令 | 说明
---- | ----
`set` | 显示当前 shell 所有环境变量，包括其内建环境变量、用户自定义变量及导出的环境变量
`env` | 显示与当前用户相关的环境变量，还可以让命令在制定环境中运行
`export` | 显示从 Shell 中导出成环境变量的变量，也能通过它将自定义变量导出为环境变量

![](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190326143605.png)

### 命令的查找路径与顺序

Shell 通过环境变量`PATH`来搜索命令。

查看 `PATH` 环境变量的内容：

```
$ echo $PATH
```

输出的内容为：

```
/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

这些目录下面存放的都是可执行文件。

### 添加自定义路径到`PATH` 环境变量

`PATH`里面的路径是以`:`作为分隔符，所以可以这样添加自定义路径：

```
$ PATH=$PATH:/home/xxxx
```

注意到这里一定要使用绝对路径。

这种修改的方式只对当前的 Shell 有效，要想让每个用户都讷讷够使用，需要更改相应的配置文件，例如`zsh`需要修改相应的`.zshrc`。

### 修改和删除已有变量

可以使用`unset`命令来删除一个环境变量：

```
$ unset temp
```

### 如何让环境变量立即生效

在修改了配置文件后，可以使用`source`命令来让其立即生效：

```
$ source .zshrc
```

## 搜索文件

### `whereis`简单快速

```
$ whereis who
```

`whereis`只能搜索二进制文件(-b)，man 帮助文件(-m)和源代码文件(-s)。

### `locate`快而全

通过`/var/lib/mlocate/mlocate.db`数据库查找，不过这个数据库也不是实时更新的，系统会使用定时任务每天自动执行`updatedb`命令更新一次，所以有时候你刚添加的文件，它可能会找不到，需要手动执行一次`updatedb`命令。他可以用来查找指定目录下的不同文件类型，例如查找/usr/share/下所有的 jpg 文件：

```
$ locate /usr/share/\*.jpg
```

注意要添加`*`号前面的反斜杠转义，否则会无法找到

### `which`小而精

我们通常使用`which`来确定是否安装了某个指定的软件，因为它只从`PATH` 环境变量指定的路径中去搜索命令：

```
$ which man
```

### `find` 精而细

`find`命令应该是这几个命令中最强大的了，它不但可以通过文件类型、文件名进行查找，而且可以根据文件的属性（如文件的时间戳，文件的权限等）进行搜索。

在指定目录下搜索指定文件名的文件：

```
$ find /etc/ -name interface
```

`find` 命令的基本参数格式为：`find [path] [option] [action]`

与时间相关的命令参数：

参数 | 说明
--- | ---
`-atime` | 最后访问时间
`-ctime` | 创建时间
`-mtime` | 最后修改时间