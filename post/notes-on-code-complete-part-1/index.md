  
这本书最开始是大一的时候买的，买回来后翻了一些章节就成为了显示器的支架，直到最近工作了一段时间才重新开始读，这一次阅读和几年前初次阅读有很大不同，大一阅读时候的编码经验仅仅是局限于算法方面，对大型项目的构建没有特别多感触；这一次是在写了很多业务代码，积累了一定问题的基础上去阅读的，阅读的深度自然不是第一次阅读可以比较的。

和这本书类似的还有一本叫做 [《程序员修炼之道——从小工到专家》](https://book.douban.com/subject/1152111/)（我也写过 [笔记](http://blog.jiayuanzhang.com/post/notes-on-the-pragmatic-programmer-part-1/)）。这本书讲了很多软件工程领域的行话和规则，比如熟悉的 [DRY 原则](https://zh.wikipedia.org/wiki/%E4%B8%80%E6%AC%A1%E4%B8%94%E4%BB%85%E4%B8%80%E6%AC%A1)，如果觉得《代码大全》比较厚（大概九百多页），也可以先读一下这本书。

《代码大全》并不是一本需要从头到尾依次阅读的书，章节和章节之间的联系也不是很大，完全可以随便挑选感兴趣的章节来阅读。这次阅读我主要遵从书上的建议，按照以下顺序来阅读：

- 第 11 章：变量名的力量
- 第 8 章：防御式编程
- 第 7 章：高质量的子程序
- 第 18 章：表驱动法
- 第 4 章：关键的「构建」决策
- 第 33 章：个人性格
- 第 32 章：自说明代码
- 其他章节按照顺序或者兴趣度依次阅读

这个「读《代码大全》」系列的文章主要是记录一些阅读笔记。之前的阅读笔记比较喜欢把书上的内容抄下来，但是实际上发现，「抄书」可能抄完就忘了，因为「抄」其实很简单，不需要动脑，打字快的话也不会觉得很累。这次阅读笔记主要是「问题 - 回答」的模式来写，在阅读每章之前，先提出几个问题，然后在阅读的过程中解决问题。

## 第 11 章：变量名的力量

问题：

1. 怎样给一个变量命名？
2. 长名字还是短名字？
3. 命名的最佳实践有哪些？
4. 有哪些常见的命名方法？
5. 在命名中应该要避免的东西有哪些？

### 怎样给一个变量命名？

> 通常，对变量的描述就是最佳的变量名。

书中举了几个简单的例子，例如表示美国奥林匹克代表团成员数量的变量 `numberOfPeopleOnTheUsOlympicTeam`，表示某国代表团在现代奥运会上获得的最高分数的变量 `maximumNumberOfPointsInModernOlympics`。这种变量命名的好处是一眼就能看出这个变量表示的是什么，它们都是非常明确的。而像 `nums` 和 `maxPoints` 就相对来说没有那么明确，至于 `n` 和 `m` 这样的命名就是非常差的描述，移除了上下文根本无法理解。

这种对变量描述的命名方法也有一个缺点：变量名太长了，这一点会之后讨论。

另外一个命名的方法是「以问题为导向（Problem Orientation）」。

> 一个好名字通常表达的是「什么（what）」，而不是「如何（how）」。如果一个名字反映了计算的某些方面而不是问题本省，那么它反应的就是「how」，而不是「what」了，应该避免取这样的名字。
书中也举了几个例子，例如一条员工数据记录可以称作 `inputRec` 或者 `employeeData`，`inputRec` 是一个反映输入、记录这些计算概念的计算机术语，二 `employeeData` 则直指问题领域。

变量命名中有很多的限定词，例如 `Total`、`Sum`、`Average`、`Max`、`Min`、`Record` 等。使用这样的限定词的时候，最好把这些限定词加到最后，这样做的好处有：

1. 避免歧义：`moneyTotal` 和 `totalMoney` 产生的歧义；
2. 一致性：`numberTotal`、`moneyTotal`、`costTotal` 这样的命名具有一致性。

使用好「对仗词」也可以很好得提升变量的可读性：

- begin/end
- first/last
- locked/unlocked
- min/max
- next/previous
- old/new
- opened/closed
- visible/invisible
- source/target
- source/destination
- up/down

个人经验：

- 使用名词来命名变量名，可以是 `adj + noun` 这种格式。

### 长名字还是短名字？

上一个问题里所讲的「对变量的描述就是最佳的变量名」这种命名方法很有可能会导致变量名过长，例如 `maximumNumberOfPointsInMordernOlympics`，虽然现代的编辑器和 IDE 都拥有非常智能的补全，这些长名字的输入也不是什么问题，但是无疑会让代码看起来过于臃肿。

> Gorla 和 Benander 发现，当变量名的平均长度在 10 到 16 个字符的时候，调试程序所花费的力气是最小的（1990）。

例如上面的这个变量名可以简化为 `maxPointsInOlympics` ，这样既保留了变量的原本意思（参考上下文的情况下），又缩短的变量名的长度。

在编写变量名的时候还需要考虑作用域的问题，一般来说，小作用域里的变量名可以简短一些，因为只作用于几行代码，例如 Python 中的列表推导式（Python 3，Python 2 中的列表推导式不是块级作用域）：

```python
alist = [do_something(elem) for elem in some_list]
```

甚至在不需要使用这个变量的时候可以把它忽略：

```python
# 生成一个随机数列表
random_numbers = [random.randint(1, 100) for _ in range(100)]
```

相反的，如果是一个全局作用域，变量名就需要取得独特一些，避免产生命名空间冲突。例如用户接口部分的雇员类可以命名为 `uiEmployee`，数据库部分的雇员类可以命名为 `dbEmployee`。

### 命名的最佳实践有哪些？

程序中常见的变量类型有「循环变量」、「状态变量」、「临时变量」、「布尔变量」、「枚举变量」和「具名常量」，这一部分会针对这些不同的变量（常量）类型讨论最佳实践。

#### 循环变量

1. （不推荐）简单的循环可以使用 `i`, `j`, `k` 来命名；
2. 复杂的循环或者循环变量需要在循环外使用的应该使用富有含义的命名。

例如，我需要便利一个用户列表信息来对每个用户的信息做处理：

```python
for user_info in user_infos:
    do_something(user_info)
```

要注意的事，在 Python 中，`for` 循环是不存在子作用域的，所以在循环外访问 `user_info` 会获取 `user_infos` 中的最后一个值。

个人经验：

- 便利下标可以使用 `idx` 或者 `index` 作为结尾，例如 `user_info_idx`

#### 状态变量

状态变量一般用来描述程序的状态。最常用的状态变量名就是 `flag`，但是这种命名方法缺少具体的含义，不推荐。

最好的命名方法是名字中不含有 `flag`，并且能够精准地表述状态。例如用来描述是否符合某一条件的变量名：`matched`，它是一个布尔值。

如果某个状态含有多个值，可以使用枚举值来代替。

#### 临时变量

临时变量用于存储计算的中间结果，它常被命名为 `temp`, `x` 等模糊且缺乏描述性的名字。

虽然临时变量是「临时」使用的，但是也不应该随意给它们命名，赋予一个更有意义的名字会让程序更加可读。

例如下面一段计算二元一次方程的代码：

```python
temp = math.sqrt(b ** 2 - 4 * a * c)
answer[0] = (-b + temp) / (2 * a)
answer[1] = (-b - temp) / (2 * a)
```

虽然上面这段代码没有什么逻辑问题，但是 `temp` 这个变量并不能很好的表述计算的中间结果，如果把 `temp` 改为 `discriminant`（判别式） 会更好。

#### 布尔变量

一些常用的布尔变量：

- done：表示某件事已经完成。在完成之前把 done 的值设为 false；
- error：表示有错误发生。在错误发生之前把 error 的值设为 false；
- found：表示某个值已经找到了。在未找到之前把 found 的值设为 false；
- success/ok：表示某一项操作是否成功。在操作失败的情况下把它的值设为 false。

最佳实践：

- 给布尔变量赋于隐含「真/假」含义的名字；
- 使用肯定的布尔变量名。

个人经验：

- 可以在布尔变量之前添加 `is` 前缀来区分，例如 `is_done`，这样做法的唯一缺点是写在条件判断中不是那么清晰，`if (done)` 要比 `if (is_done)` 更加清晰一些。

#### 枚举变量

在使用枚举类型的时候，可以通过使用组前缀，如 `Color_`, `Planet_` 等来明确表示该类型的成员属于同一个组。

#### 常量

常量应该始终大写，并使用有意义的值，避免在程序中使用魔法变量。

### 有哪些常见的命名方法？

命名规范首先应该参考项目的规范或者所编写的语言规范，例如 Java 通常使用的是驼峰命名法，Python 使用的是下划线命名法。

#### 驼峰命名法（CamelCase）

驼峰命名法来源于 Perl 语言中普遍使用的大小写混合命名，而 Larry Wall 所著的《Programming Perl》的封面就是一匹骆驼。

一般来说，变量名、函数使用小驼峰命名法（lowerCamelCase）；类使用大驼峰命名法（UpperCamelCase）。

驼峰命名法常在 Java、JavaScript 等语言中被使用。

#### 下划线命名法（underline_case）

下划线命名法使用下划线 `_` 来分隔多个单词。这种命名方式通常在 Python 等语言中被使用。它的缺点是会使含有多个单词的变量名的长度增加。

#### 匈牙利命名法

在匈牙利命名法中，一个变量由一个或多个小些字母开始，这些字母有助于记忆变量的类型和用途，紧跟着的就是程序员选择的任何名称。这个后半部分的首字母可以大写，以区别前面的类型指示字母。

匈牙利命名法被广泛用在 Microsoft Windows 系统的开发中。但是目前这种命名方式已经被很少使用，不推荐。

### 在命名中应该要避免的东西有哪些？

（这是《代码大全》中列出的指导原则。）

- 避免使用令人误解的名字和缩写。要确保名字的含义是明确的。例如 FALSE 常用做 TRUE 的反义词，如果它用做「Fig and Almond Season」的缩写就很糟糕了；
- 避免使用具有相似含义的名字。如果你能够交换两个变量的名字而不会妨碍对程序的理解，那么你就需要为这两个变量重新命名了。
- 避免使用具有不同含义但却有相似名字的变量。如果你有两个名字相似但含义不同的变量，那么试着给其中之一重新命名。
- 避免使用发音相近的名字。例如 wrap 和 rap，当你试图和别人讨论代码的时候，同音字会产生麻烦。
- 避免在名字中使用数字。如果名字中的数字真的非常重要，可以使用数组来代替一组单个的变量。
- 避免在名字中拼错单词。（后期要修改非常麻烦。）
- 避免使用英语中常常拼错的单词。很多英语手册会包含一份常常拼错单词的清单，避免在你的变量名中使用这些单词。
- 不要仅靠大小写来区分变量名。（大写仅作为常量命名。）
- 避免使用多种自然语言。（统一使用标准现代英语，避免使用 emoji、中文和其他语言。）
- 避免使用标准类型、变量和子程序的名字。所有的编程语言指南都会包含一份该语言保留的和预定的名字列表，不要使用列表上的名字作为变量名。
- 不要使用与变量含义完全无关的名字。
- 避免在名字中包含容易混淆的字符。要意识到有些字符看上去非常接近，很难把它们区分开来。

## 总结

变量的命名是程序开发中非常小的一个环节，但是却能够发展出这么多的理论，原因之一就是「程序首先是给人阅读的，其次才是给机器执行的」。良好的命名方法可以让代码更加易于维护，也可以让别人更好地理解你的代码。

变量的命名规范首先应当符合团队或者项目制定的编码规范，如果没有制定规范或者是个人项目，可以沿用社区的编码规范。下面列出一些常见语言的编码规范：

- Python: [styleguide/pyguide.md at gh-pages · google/styleguide](https://github.com/google/styleguide/blob/gh-pages/pyguide.md)
- Java: [alibaba/p3c: Alibaba Java Coding Guidelines pmd implements and IDE plugin](https://github.com/alibaba/p3c)
- JavaScript: [airbnb/javascript: JavaScript Style Guide](https://github.com/airbnb/javascript)
- C/C++: [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html)
- Golang: [CodeReviewComments · golang/go Wiki](https://github.com/golang/go/wiki/CodeReviewComments)

编码规范也不能够完全依靠文档来约束，集成到 IDE 或者 CI 中是更好的方式。各种语言都提供了各种 format 工具，例如 Python 的 [yapf](https://github.com/google/yapf)，Golang 的 [gofmt](https://golang.org/cmd/gofmt/) 等。

IDE 和代码编辑器也提供了很好的格式化代码的功能，例如 Jebbrains 的 IDE 就可以通过导入 XML 格式的文件来进行配置格式化代码的风格。

## 参考文献

- [Don't repeat yourself - Wikipedia](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)
- [Camel case - Wikipedia](https://en.wikipedia.org/wiki/Camel_case)
- [Hungarian notation - Wikipedia](https://en.wikipedia.org/wiki/Hungarian_notation)
- [Code Complete: A Practical Handbook of Software Construction, Second Edition: Steve McConnell: 0790145196705: Amazon.com: Books](https://www.amazon.com/Code-Complete-Practical-Handbook-Construction/dp/0735619670)

