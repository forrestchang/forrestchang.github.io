
开始学习机器学习/数据挖掘相关的内容，打算每学习一部分知识就写一篇博客总结一下，当做学习过程中的笔记，也为以后看的时候提供存档。

这一篇笔记是关于推荐系统的，主要讲了两种推荐算法（基于用户和基于物品的协同过滤）。

## 基于用户的协同过滤

### 协同过滤（Collaborative filtering）

一个协作型过滤算法通常的做法是对一大群人进行搜索，并从中找出与我们品味相近的一小群人。算法会对这些人所偏爱的其他内容进行考察，并将它们组合起来构造出一个经过排名的推荐列表。

### 测试数据集

为了演示一些算法，我们需要从[这个网站](http://grouplens.org/datasets/movielens/)上下载一份数据集。这里因为是作为演示使用，所以只需要下载[ml-latest-small.zip](http://files.grouplens.org/datasets/movielens/ml-latest-small.zip)这一份简单的数据集就可以了。

### 相似度计算

在有了数据之后，我们需要有一种方法来确定人们在品味方面的相似程度。为此，我们可以将每个人与所有其他人进行对比，并计算他们的**相似度评价值**。

#### 欧几里德距离评价（Euclidean Distance Score）

欧几里德距离是指多维空间中两点间的距离，这是一种用直尺测量出来的距离。如果我们将两个点分别记作$(p_1, p_2, p_3, p_4, ...)$和$(q_1, q_2, q_3, q_4, ...)$，则欧几里德距离的计算公式为：

$$
\sqrt{((p_1-q_1)^2+(p_2-q_2)^2+...+(p_n-q_n)^2)} = \sqrt{(\sum_{i=1}^n(p_i-q_i)^2)}
$$

创建 `recommendations.py`。

用代码表示：

```python
from math import sqrt

# 返回一个有关 person1 与 person2 的基于距离的相似度评价
def sim_distance(prefs, person1, person2):
	# 得到 shared_items 的列表
	shared_items = {}
	for item in prefs[person1]:
		if item in prefs[person2]:
		shared_items[item] = 1
	
	# 如果两者没有共同之处，则返回 0
	if len(shared_items) == 0:
		return 0
		
	# 计算所有差值的平方和
	sum_of_squares = sum([pow(prefs[person1][item]-prefs[person2][item], 2)for item in prefs[person1] if item in prefs[person2]])
	
	return 1 / (1 + sqrt(sum_of_squares))
```

欧几里德距离计算公式可以计算出距离值，偏好越相似的人，其距离就越短。不过，我们还需要一个函数，来对偏好越相近的情况给出越大的值，为此，我们可以将函数的值加 1（这样就可以避免遇到被 0 整除的错误了），并取其倒数，入上面代码最后一行所示。

好了，现在我们需要先将数据读取进来，在 `recommendations.py` 中添加如下代码:

```python
def loadMovieLens(path='data'):
    movies = {}
    for line in open(path + '/movies.csv'):
        (id, title) = line.split(',')[0:2]
        movies[id] = title

    prefs = {}
    for line in open(path+'/ratings.csv'):
        (user, movieid, rating, ts) = line.split(',')
        prefs.setdefault(user, {})
        prefs[user][movies[movieid]] = float(rating)
    return prefs
```

在 ipython 交互环境中：

```python
>>> import recommendations
>>> prefs = recommendations.loadMovieLens()
>>> # 比较 10 号用户 和 20 号用户的相似度评价
>>> recommendations.sim_distance(prefs, '10', '20')
0.23371479611805132
```

#### 皮尔逊相关系数（Pearson Correlation Coefficient）

皮尔逊相关系数是一种度量两个变量间相关程度的方法，它是一个介于 1 和 -1 之间的值，其中，1 表示变量完全正相关，0 表示无关， -1 则表示完全负相关（一个变量的值越大，则另一个变量的值反而会越小）。

计算公式：

$$
r = \frac{\sum{XY}-\frac{\sum X \sum Y}{N}}{\sqrt{(\sum X^2 - \frac{(\sum X)^2}{N})(\sum Y^2 - \frac{(\sum Y)^2}{N})}}
$$

在 `recommendations.py` 中添加如下代码：

```python
def sim_pearson(prefs, person1, person2):
	  # 得到双方都曾评价过的物品列表
    shared_items = {}
    for item in prefs[person1]:
        if item in prefs[person2]:
            shared_items[item] = 1
	  # 得到物品列表元素的个数
    n = len(shared_items)

	  # 如果两者没有共同元素，则返回0
    if n == 0:
        return 0

	  # 计算 person1 和 person2 的皮尔逊相关系数
    sumxy = sum([prefs[person1][item] * prefs[person2][item]
                for item in shared_items])
    sumx = sum([prefs[person1][item] for item in shared_items])
    sumy = sum([prefs[person2][item] for item in shared_items])
    sumx2 = sum([prefs[person1][item] ** 2 for item in shared_items])
    sumy2 = sum([prefs[person2][item] ** 2 for item in shared_items])

    zahler = sumxy - (sumx * sumy) / n
    nenner = sqrt((sumx2 - (sumx ** 2) / n) * (sumy2 - (sumy ** 2) / n))
    if nenner == 0:
        return 0
    r = zahler / nenner

    return r
```

在 ipython 交互环境中：
 
```python
>>> reload(recommendations)
>>> prefs = recommendations.loadMovieLens()
>>> recommendations.sim_pearson(prefs, '10', '20')
0.4908806936738162
```

可以看到和上面使用欧几里德距离评价计算出来的相似度是不一样的。

#### 关于该使用哪一种相似性度量方法

除了这两种计算相似度的方法，实际上还有许多别的计算相似度的算法，例如**Tanimoto 分值**。使用哪一种方法，完全取决于具体的应用。

下面的代码中，将使用一个通用的相似性函数来计算相似度，只要它满足以下条件：拥有同样的函数签名，以一个浮点数作为返回值，其数值越大代表相似度越大。

### 寻找相似的用户

既然我们已经有了对两个人进行比较的函数，下面我们就可以编写，根据指定人员对每个人进行打分，并找出最接近的匹配结果了。

```python
# 从反映偏好的字典中返回最佳匹配者
# 返回结果的个数和相似度函数均为可选参数
def topMatches(prefs, person, n=5, similarity=sim_pearson):
	scores = [(similarity(prefs, person, other), other) for other in prefs if other != person]
	
	# 对列表进行排序，评价值最高者排在最前面
	scores.sort(reverse=True)
	return scores[:n]
```

在 ipython 交互环境中测试：

```python
>>> reload(recommendations)
>>> prefs = recommendations.loadMovieLens()
>>> # 与 40 号用户相似的 10 个用户
>>> recommendations.topMatches(prefs, '40', n=10)
[(1.0, '63'),
 (1.0, '582'),
 (1.0, '326'),
 (1.0, '260'),
 (1.0, '220'),
 (1.0, '198'),
 (1.0, '153'),
 (1.0, '116'),
 (0.9999999999999947, '474'),
 (0.9999999999999947, '215')]
```

### 推荐物品

有的时候我们可能不需要寻找相似的用户，例如在购物网站中，我们需要的是一份可能会想要购买的物品列表，一种方法是从相似的用户所购买的物品列表中选出没有购买的，但是这种方法不确定的因素太多，例如可能相似用户还未购买某些物品，而这些物品恰恰就是我们所需要的。

为了解决上面的问题，我们需要通过一个经过加权的评价值来为影片打分，评论者的评分结果因此而形成了先后的排名。为此，我们需要取得所有其他评论者的评价结果，借此得到相似度之后，再乘以他们为每部影片所给的评价值。

以以下数据集为例：

```
{'Lisa Rose': {'Lady in the Water': 2.5,
               'Snakes on a Plane': 3.5,
               'Just My Luck': 3.0,
               'Superman Returns': 3.5,
               'You, Me and Dupree': 2.5,
               'The Night Listener': 3.0},
 'Gene Seymour': {'Lady in the Water': 3.0,
                  'Snakes on a Plane': 3.5,
                  'Just My Luck': 1.5,
                  'Superman Returns': 5.0,
                  'The Night Listener': 3.0,
                  'You, Me and Dupree': 3.5},
 'Michael Phillips': {'Lady in the Water': 2.5,
                      'Snakes on a Plane': 3.0,
                      'Superman Returns': 3.5,
                      'The Night Listener': 4.0},
 'Claudia Puig': {'Snakes on a Plane': 3.5,
                  'Just My Luck': 3.0,
                  'The Night Listener': 4.5,
                  'Superman Returns': 4.0,
                  'You, Me and Dupree': 2.5},
 'Mick LaSalle': {'Lady in the Water': 3.0,
                  'Snakes on a Plane': 4.0,
                  'Just My Luck': 2.0,
                  'Superman Returns': 3.0,
                  'The Night Listener': 3.0,
                  'You, Me and Dupree': 2.0},
 'Jack Matthews': {'Lady in the Water': 3.0,
                   'Snakes on a Plane': 4.0,
                   'The Night Listener': 3.0,
                   'Superman Returns': 5.0,
                   'You, Me and Dupree': 3.5},
 'Toby': {'Snakes on a Plane': 4.5,
          'You, Me and Dupree': 1.0,
          'Superman Returns': 4.0}}
```

假设我们需要给 Toby 提供影片推荐，我们可以根据上面的算法得出一张表：

| 评论者 | 相似度 | Night | S.xNight | Lady | S.xLady | Luck | S.xLuck |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Rose | 0.99 | 3.0 | 2.97 | 2.5 | 2.48 | 3.0 | 2.97 |
| Seymour | 0.38 | 3.0 | 1.14 | 3.0 | 1.14 | 1.5 | 0.57 |
| Puig | 0.89 | 4.5 | 4.02 |  |  | 3.0 | 2.68 |
| LaSalle | 0.92 | 3.0 | 2.77 | 3.0 | 2.77 |  |  |
| Matthews | 0.66 | 3.0 | 1.99 | 3.0 | 1.99 |  |  |
| 总计 |  |  | 12.89 |  | 8.38 |  | 8.07 |
| Sim.Sum |  |  | 3.84 |  | 2.95 |  | 3.18 |
| 总计/Sim.Sum |  |  | 3.35 |  | 2.83 |  | 2.53 |

表中列出来每位评论者的相关度评价值，以及他们对三部影片的评分情况。以 S.x 打头的列给出了乘以评价值之后的相似度。如此一来，相比于与我们不相近的人，那些与我们相近的人将会对整体评价拥有更多的贡献。总计所有加权评价值的和。

我们也可以选择利用总计值来计算排名，但是这其中有一个问题，一部受更多人评论的影片会对结果产生很大影响。为了修正这一问题，我们需要除以表总名为 Sim.Sum 的那一行，它代表了**所有对这部电影有过评论的评论者的相似度之和**。对于影片《Lady in the Water》来说，Puig 并未做过评论，所以我们将这部影片的总计值除以所有其他人的相似度之和。

在 `recommendations.py` 中添加如下代码：

```python
# 利用所有其他人评价值得加权平均，为某人提供建议
def getRecommendations(prefs, person, similarity=sim_pearson):
	totals = {}
	simSums = {}
	for other in prefs:
		# 不要和自己做比较
		if other == person:
			continue
		sim = similarity(prefs, person, other)
		
		# 忽略评价值为零或者小于零的情况
		if sim <= 0:
			continue
			
		for item in prefs[other]:
			# 只对自己还未看过的影片进行评价
			if item not in prefs[person] or prefs[person][item] == 0:
				# 相似度*评价值
				totals.setdefault(item, 0)
				totals[item] += prefs[other][item] * sim
				# 相似度之和
				simSums.setdefault(item, 0)
				simSums[item] += sim
		
		# 建立一个归一化的列表
		rankings = [(total / simSums[item], item) for item, total in totals.items()]
		
		# 返回经过排序的列表
		rankings.sort(reverse=True)
		return rankings
```

在 ipython 中测试一下：

```python
>>> relaod(recommendations)
>>> prefs = recommendations.loadMovieLens()
>>> recommendations.getRecommendations(prefs, '10')[:20]
[(5.000000000000001,
  'The Slipper and the Rose: The Story of Cinderella (1976)'),
 (5.000000000000001, 'Hands on a Hard Body (1996)'),
 (5.000000000000001, 'For the Birds (2000)'),
 (5.000000000000001, 'Diva (1981)'),
 (5.0, 'Zorba the Greek (Alexis Zorbas) (1964)'),
 (5.0, 'Zerophilia (2005)'),
 (5.0, 'Zelary (2003)'),
 (5.0, 'Z Channel: A Magnificent Obsession (2004)'),
 (5.0, 'Yossi (Ha-Sippur Shel Yossi) (2012)'),
 (5.0, 'World of Tomorrow (2015)'),
 (5.0, 'Woody Allen: A Documentary (2012)'),
 (5.0, 'Woman on Top (2000)'),
 (5.0, 'Without a Clue (1988)'),
 (5.0, 'Withnail & I (1987)'),
 (5.0, 'Wild Zero (2000)'),
 (5.0, 'War Room (2015)'),
 (5.0, 'Walker (1987)'),
 (5.0, 'Voices from the List (2004)'),
 (5.0, 'Videodrome (1983)'),
 (5.0, 'Victoria (2015)')]
```

### 匹配商品

现在我们已经可以为指定人员寻找品味相近的用户，以及如何向其推荐商品。假如我们想要了解哪些物品是相近的，那又该如何呢？

在我们浏览 Amazon 的时候，经常会看到页面底部会推荐与当前浏览的物品相似的商品。这种情况，我们可以通过查看哪些人喜欢某一特定物品，以及这些人喜欢哪些其他物品来决定相似度。事实上，这和我们之前用来计算人与人之间的相似度是一样的，只需要把人和物品相互调换就行了。

我们来编写这个翻转字典的函数：

```python
def transformPrefs(prefs):
	result = {}
	for person in prefs:
		for item in prefs[person]:
			result.setdefault[item, {}]
			# 将物品和人对调
			result[item][person] = prefs[person][item]
	return result
```

有了这个方法之后，我们就可以复用之前所写的方法了。

在 ipython 环境中测试：

```python
>>> load(recommendations)
>>> movies = recommendations.transformPrefs()
>>> recommendations.topMatches(movies, 'For the Birds (2000)')
[(1.000000000000016, '"Silence of the Lambs'),
 (1.0, 'World War Z (2013)'),
 (1.0, 'Wallace & Gromit in The Curse of the Were-Rabbit (2005)'),
 (1.0, 'Tron: Legacy (2010)'),
 (1.0, 'Transcendence (2014)')]
```

我们还可以为影片推荐评论者：

```python
>>> recommendations.getRecommendations(movies, 'For the Birds (2000)')[:20]
[(5.0, '668'),
 (5.0, '618'),
 (5.0, '543'),
 (5.0, '541'),
 (5.0, '536'),
 (5.0, '52'),
 (5.0, '464'),
 (5.0, '46'),
 (5.0, '409'),
 (5.0, '357'),
 (5.0, '308'),
 (5.0, '296'),
 (5.0, '29'),
 (5.0, '28'),
 (5.0, '197'),
 (5.0, '196'),
 (5.0, '190'),
 (5.0, '131'),
 (5.0, '113'),
 (4.999999999999999, '465')]
```

## 基于物品的协同过滤

当前所完成的推荐系统，要求我们使用每一位用户的全部评分来构建数据集，这种方法对于小规模的数据集是没有问题的，但是对于像 Amazon 这样有着上百万用户和商品的大型网站而言，讲一个用户同其他所有用户进行比较，然后再对每位用户评过分的商品进行比较，时间花费上是巨大的。

目前为止我们所使用的技术被称为**基于用户的协同过滤**（user-based collaborative filtering）。除此以外，还有一种可供选择的方法被称为**基于物品的协同过滤**（item-based collaborative filtering）。在拥有大量数据集的情况下，基于物品的协同过滤能够得出更好的结论，而且它允许我们将大量的计算任务预先执行，从而使需要给予推荐的用户能够更快地得到他们所要的结果。

基于物品的协同过滤总体思路就是为每件物品预先计算好最为相近的其他物品。然后，当我们想为某位用户提供推荐的时候，就可以查看他曾经评过分的物品，并从中选出排名靠前者，再构造一个加权列表，其中包含了与这些选中物品最相近的其他物品。此处最显著的区别在于，尽管第一步要求我们检查所有的数据，但是物品间的比较不会像用户间比较那么频繁变化。

### 构造物品比较数据集

为了对物品进行比较，我们要做的第一件事就是编写一个函数，构造一个包含相近物品的完整数据集。构建完数据集之后，我们就可以在需要的时候重复使用它。

将下面代码添加到 `recommendations.py` 中：

```python
def calculateSimilarItems(prefs, n=10):
	# 建立字典，以给出与这些物品最为相近的其他物品
	result = {}
	
	# 以物品为中心最偏好矩阵进行倒置处理
	itemPrefs = transformPrefs(prefs)
	c = 0
	for item in itemPrefs:
		# 针对大数据集更新状态变量
		c += 1
		if c % 100 == 0:
			print "%d / %d" % (c, len(itemPrefs))
		scores = tomMatchs(itemPrefs, item, n=n, similarity=sim_pearson)
		result[item] = scores
	return result
```

该函数首先利用了此前定义过得 `transformPrefs` 函数，对反映评价的字典进行倒置处理，从而得到一个有关物品及其用户评价情况的列表，然后程序又循环遍历每项物品，并将转换了的字典传入 `tomMatches` 函数中，求得最为相近的物品及其相似度评价值，最后，它建立并返回了一个包含物品及其最相近物品列表的字典。

在 ipython 交互环境中测试：

```python
>>> reload(recommendations)
>>> itemsim = recommendations.calculateSimilarItems(prefs)
100 / 8963
200 / 8963
300 / 8963
400 / 8963
500 / 8963
600 / 8963
700 / 8963
800 / 8963
900 / 8963
1000 / 8963
1100 / 8963
1200 / 8963
1300 / 8963
1400 / 8963
1500 / 8963
1600 / 8963
1700 / 8963
1800 / 8963
1900 / 8963
...
```

首次运行需要等待一段时间进行计算。

只有频繁执行该函数，才能令物品的相似度不至于过期。通常我们需要在用户基数和评分数量不是很大的时候执行这一函数，但是随着用户数量的不断增长，物品间的相似度评价通常会变得越来越稳定。

### 获得推荐

现在，我们可以利用反映物品相似度的字典来给出推荐了，我们可以去到用户评价过得所有物品，并找出其相近的物品，根据相似度对其进行加权。

下表给出了利用基于物品的方法寻找推荐的过程，所用到的数据可以在上面**推荐物品**一节中找到。

为 Toby 提供基于物品的推荐：


| 影片 | 评分 | Night | R.xNight | Lady | R.xLady | Luck | R.xLuck |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Snakes | 4.5 | 0.182 | 0.818 | 0.222 | 0.999 | 0.105 | 0.474 |
| Superman | 4.0 | 0.103 | 0.412 | 0.091 | 0.363 | 0.065 | 0.258 |
| Dupree | 1.0 | 0.148 | 0.148 | 0.4 | 0.4 | 0.182 | 0.182 |
| 总计 |  | 0.433 | 1.378 | 0.713 | 1.762 | 0.352 | 0.914 |
| 归一化结果 |  |  | 3.183 |  | 2.473 |  | 2.598 |

此处每一行都列出了一部我们曾经观看过的影片，以及对该片的个人评价。对于每一部我们还未曾看过的影片，相应有一列会指出它与已观看影片的相似程度。以 R.x 打头的列给出了我们队影片的评价值乘以相似度之后的结果。

总计一行给出了每部影片相似度评价值的总和以及 R.x 列的总和，为了预测我们对每一部影片的评分情况，只要将 R.x 列的总计值除以相似度一列的总计值即可。

在 `recommendations.py` 中添加如下代码：

```python
def getRecommendedItems(prefs, itemMatch, user):
	userRatings = prefs[user]
	scores = {}
	totlaSim = {}
	
	# 循环遍历由当前用户评分的物品
	for (item, rating) in userRatings.items():
		
		# 循环遍历与当前物品相近的物品
		for (similarity, item2) in itemMatch[item]:
		
			# 如果该用户已经对当前物品做过评价，则将其忽略
			if item2 in userRatings:
				continue
			
			# 评价值与相似度加权之和
			scores.setdefault(item2, 0)
			scores[item2] += similarity * rating
			
			# 全部相似度之和
			totalSim.setdefault(item2, 0)
			totalSim[item2] += similarity
			
	# 将每个合计值除以加权和，求出平均值
	rankings = [(score / totalSim[item], item) for item, score in scores.items()]
	
	# 按最高值到最低值的顺序，返回评分结果
	rankings.sort(reverse=True)
	return rankings
```

在 ipython 中测试一下：

```python
>>> reload(recommendations)
>>> recommendations.getRecommendedItems(prefs, itemsim, '20')[:10]
[(5.0, 'Zoot Suit (1981)'),
 (5.0, 'Zoolander (2001)'),
 (5.0, 'Zack and Miri Make a Porno (2008)'),
 (5.0, "You've Got Mail (1998)"),
 (5.0, 'X-Men: The Last Stand (2006)'),
 (5.0, 'X-Men: Apocalypse (2016)'),
 (5.0, 'X-Men (2000)'),
 (5.0, "Von Ryan's Express (1965)"),
 (4.75, 'Willow (1988)'),
 (4.75, "White Men Can't Jump (1992)")]
```

## 基于用户进行过滤还是基于物品进行过滤

在数据集大小上，基于物品进行过滤的方式要比基于用户进行过滤更快；在数据的稀疏程度上，稀疏的数据集使用基于物品的过滤方法更优，而对于秘密集的数据集而言，两者的效果几乎一样。

基于用户的过滤方法更加易于实现，而且无需额外步骤，因此它通常更适用于规模较小的变化非常频繁的数据集。在一些应用中，告诉用户还有哪些人与自己有着相近偏好是有一定价值的——也许对于一个购物网站而言，我们并不想这么做，但是对于一个音乐分享类或者电影评分类网站而言，这种潜在的需求却是存在的。

