
## 安装

直接使用 pip 来进行安装：

```
$ sudo pip install virtualenv
```

## 用途

主要用来创建隔离的 Python 开发环境，比如说一个项目需要用到 2.7 的库，另一个项目需要用到 3.0 的库，我们就可以使用  virtualenv 来分别给这两个项目创建虚拟的 Python 环境，这样可以有效的避免冲突。

virtualenv 会创建一个拥有独立安装目录的 Python 环境，该隔离环境不会与其他 virtualenv 环境共享模块（可以选择是否访问全局安装目录）。

## 使用

### 创建虚拟环境

最基本的使用：

```
$ virtualenv ENV
```

其中 `ENV` 是用来存放虚拟环境的目录。

```
$tree -L 1 ENV
ENV
├── bin
├── include
├── lib
└── pip-selfcheck.json
```

其中 `lib` 和 `include` 目录是用来存放新的虚拟 Python 环境的依赖库，Package 被安装到 `lib/pythonX.X/site-packages/` 中，`bin` 目录中是新的 Python 解释器。`pip` 和 `setuptools` 默认被安装的。

### active script

进入虚拟环境：

```
$ source ENV/bin/active
```

（如果 `source` 命令不存在可以使用 `.` 命令。）

退出虚拟环境：

```
$ deactivate
```

### Removing an Environment

```
(ENV)$ deactivate
$ rm -r /path/to/ENV
```

### `--system-site-packages` 选项

使用 `virtualenv --system-site-packages ENV` 将会继承全局 packages。并不是很常用的功能。

### 指定 Python 版本

使用 `-p PYTHON_EXE` 选项在创建虚拟环境的时候制定 Python 版本。

Python 2.7:

```
$ virtualenv -p /usr/bin/python2.7 ENV2.7
```

Python 3.5:

```
$ virtualenv -p /usr/local/bin/python3.5 ENV3.5
```

### 生成可打包环境

某些情况下，我们可能需要在别的地方使用这个已经配置好的虚拟环境，可以使用 `virtualenv --relocatable` 将 ENV 修改为可迁移的。

```
(ENV)$ virutalenv --relocatable ./
```
