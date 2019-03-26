
这篇文章是在阅读《The Swift Programming Language》Automatic Reference Counting（ARC，自动引用计数）一章时做的一些笔记，同时参考了其他的一些资料。

在早期的 iOS 开发中，内存管理是由开发者手动来完成的。因为传统的垃圾回收机制对于移动平台来说十分低效，苹果采用的是引用计数（RC，Reference Counting）的方式来管理内存，开发者需要通过手工的方式增加或减少一个实例的引用计数。在 iOS 5 之后，引入了 ARC 自动引用计数，使得开发者不需要手动地调用 `retain` 和 `release` 来管理引用计数，但是实际上这些方法还是会被调用，只不过是交给了编译器来完成，编译器会在合适的地方帮我们加入这些方法。

**什么是自动引用计数？**

每当你创建一个类的实例的时候，ARC 便会自动分配一块内存空间来存放这个实例的信息，当这个实例不再被使用的时候，ARC 便释放实例所占用的内存。一般每个被管理的实例都会与一个引用计数器相连，这个计数器保存着当前实例被引用的次数，一旦创建一个新的引用指向这个实例，引用计数器便加 1，每当指向该实例的引用失效，引用计数器便减 1，当某个实例的引用计数器变成 0 的时候，这个实例就会被立即销毁。

在 Swift 中，对引用描述的关键字有三个：`strong`，`weak` 和 `unowned`，所有的引用没有特殊说明都是 `strong` 强引用类型。在 ARC 中，只有指向一个实例的所有 `strong` 强引用都断开了，这个实例才会被销毁。

举一个简单的例子：

``` swift
class A {
    let name: String
    init(name: String) {
        self.name = name
    }
    deinit {
        print("A deinit")
    }
}

var a1: A?
var a2: A?

a1 = A(name: "A")
a2 = a1

a1 = nil
```

上面这个例子中，虽然 `a1` 这个 `strong` 强引用断开了，但是还有 `a2` 这个强引用指向这个实例，所以不会在命令行中输出 `A deinit`，当我们把 `a2` 也设置为 `nil` 时，与这个实例关联的所有强引用均断开了，这个实例便会被销毁，在命令行中打印 `A deinit`。

**循环强引用（Strong Reference Cycles）**

但是，在某些情况下，一个类实例的强引用数永远不能变为 0，例如两个类实例互相持有对方的强引用，因而每个类实例都让对方一直存在，这就是所谓的强引用循环（Strong Reference Cycles）。

这里引用 TSPL 中的例子：

``` swift
class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    var tenant: Person?
    deinit { print("Apartment \(unit) is being deinitialized") }
}
```

每一个 `Person` 实例有一个可选的初始化为 `nil` 的 `Apartment` 类型，因为一个人并不总是拥有公寓。同样，每一个 `Apartment` 实例都有一个可选的初始化为 `nil` 的 `Person` 类型，因为一个公寓并不总是属于一个人。

接下来的代码片段定义了两个可选类型的变量 `john` 和 `unit4A`，并分别设定为下面的 `Person` 和 `Apartment` 的实例，这两个变量都备受设定为 `nil`：

``` swift
var john: Person?
var unit4A: Apartment?
```

现在可以创建特定的 `Person` 和 `Apartment` 实例，并将它们赋值给 `john` 和 `unit4A` 变量：

``` swift
john = Person(name: "John Appleseed")
unit4A = Apartment(unit: "4A")
```

下面一段代码将这两个实例关联起来：

``` swift
john!.apartment = unit4A
unit4A!.tenant = john
```

将两个实例关联在一起后，强引用的关系如图所示：

![14607053938205](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190326144231.png)

这两个实例关联之后，会产生一个循环强引用，当断开 `john` 和 `unit4A` 所持有的强引用时，引用计数器并不会归零，所以这两块空间也得不到释放，这就导致了内存泄漏。

可以将其中一个类中的变量设定为 `weak` 弱引用来打破这种强引用循环：

``` swift
class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    weak var tenant: Person?
    deinit { print("Apartment \(unit) is being deinitialized") }
}
```

![14607057294969](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190326144320.png)

当断开 `john` 和 `unit4A` 所持有的强引用时，`Person instance` 的引用计数器变成 0，实例被销毁，从而 `Apartment instance` 的引用计数器也变为 0，实例被销毁。

**什么时候使用 `weak`？**

当两个实例是 optional 关联在一起时，确保其中的一个使用 `weak` 弱引用，就像上面所说的那个例子一样。

**`unowned` 无主引用**

在某些情况下，声明的变量总是有值得时候，我们需要使用 `unowned` 无主引用。

同样借用一下 TSPL 中的例子：

``` swift
class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}

class CreditCard {
    let number: UInt64
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}
```

这里定义了两个类，`Customer` 和 `CreditCard`，模拟了银行客户和客户的信用卡，在这个例子中，每一个类都是将另一个类的实例作为自身的属性，所以会产生循环强引用。

和之前那个例子不同的是，`CreditCard` 类中有一个非可选类型的 `customer` 属性，因为，一个客户可能有或者没有一张信用卡，但是一张信用卡总是关联着一个用户。

``` swift
var john: Customer?
john = Customer(name: "John Appleseed")
john!.card = CreditCard(number: 1234_5678_9012_3456, customer: john!)
```

关联两个实例后，它们的引用关系如图所示：

![14607068387297](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190326144333.png)

当断开 `john` 变量持有的强引用时，再也没有指向 `Customer` 的强引用了，所以该实例被销毁了，其后，再也没有指向 `CreditCard` 的强引用了，该实例也被销毁了。

**什么时候使用 `unowned` 无主引用？**

两个实例 A 和 B，如果实例 A 必须在实例 B 存在的前提下才能存在，那么实例 A 必须用 `unowned` 无主引用指向实例 B。也就是说，有强制依赖性的那个实例必须对另一个实例持有无主引用。

例如上面那个例子所说，银行客户可能没有信用卡，但是每张信用卡总是绑定着一个银行客户，所以信用卡这个类就需要用 `unowned` 无主引用。

**无主引用以及隐市解析可选属性**

还有一种情况，两个属性都必须有值，并且初始化完成之后永远不会为 `nil`。在这种情况下，需要一个类使用 `unowned` 无主引用，另一个类使用[隐式解析可选属性](http://wiki.jikexueyuan.com/project/swift/chapter2/01_The_Basics.html#implicityly_unwrapped_optionals)。

**闭包引起的循环强引用**

在 Swift 中，闭包和函数都属于引用类型。并且闭包还有一个特性：可以在其定义的上下文中捕获常量或者变量。所以，在一个类中，闭包被赋值给了一个属性，而这个闭包又使用了这个类的实例的时候，就会引起循环强引用。

Swift 提供了一种方法来解决这个问题：闭包捕获列表（closure capture list）。在定义闭包的同时定义捕获列表作为闭包的一部分，捕获列表定义了闭包体内捕获一个或者多个引用类型的规则。跟解决两个类实例之间的循环强引用一样，声明每个捕获的引用为弱引用或者无主引用。

捕获列表中的每一项都由一对元素组成，一个元素是 `weak` 或者 `unowned` 关键字，另一个元素是类实例的引用（例如最常见得是 `self`），这些在方括号内用逗号隔开。

具体的使用方法请参考[官方文档](http://wiki.jikexueyuan.com/project/swift/chapter2/16_Automatic_Reference_Counting.html#resolving_strong_reference_cycles_for_closures)。

**何时使用 `weak`，何时使用 `unowned`**

在闭包和捕获的实例总是相互引用并且总是同时销毁的时候，将闭包内的捕获定义为 `unowned` 无主引用。

在被捕获的实例可能变成 `nil` 的情况下，使用 `weak` 弱引用。如果被捕获的引用绝对不会变成 `nil`，应该使用 `unowned` 无主引用，而不是 `weak` 弱引用。

**Garbage Collection（GC，垃圾回收）**

其实 ARC 应该也算 GC 的一种，不过我们一谈到 GC，大多都会想到 Java 中的垃圾回收机制，相比较 GC，ARC 简单得许多。以后有机会可以讨论一下 Java 中的内存管理。

另外，需要注意的一点是，这里所讲的都是针对于`引用类型`，`结构体`和`枚举`在 Swift 中属于值类型，不在 ARC 的考虑范围之内。