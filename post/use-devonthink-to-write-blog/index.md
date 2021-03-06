  
虽然博客没有写太多篇，但是写博客的工具却折腾过不少。从最开始的 org-mode，到 Jekyll、Hexo，再到现在的 Hugo，一直没有找到一个满意的工作流。

我的需求：

- 使用统一的工具来管理笔记和写作的文章；
- 能够多端同步；
- 自动化。

之前使用 Hugo 写作的流程是：

1. 在命令行新建一篇文章；
2. 打开 Typora 进行写作；
3. 写完了再去命令行 generate 并 push 到 GitHub 上。

后来使用 Ulysses 作为写作的工具，把 Hugo 的 post 文件夹作为 Ulysses 的外部文件夹来进行写作。Ulysses 是一个很强大的写作工具，但是唯一的缺点是它自带的 Markdown 语法与通用的 Markdown 语法不兼容，这导致了之前写的很多文章都需要转码一遍才能够正确在 Ulysses 中显示。

Devonthink 是我用来做知识管理的工具，你可以把它看做是一个增强版的 Finder + Evernote，我主要用它来写笔记和剪裁网页，配合 Alfred 的搜索可以快速找到想要的内容，关于 Devonthink 的具体使用我之后会写一篇文章来介绍，如果你有疑问，可以先看一下这篇文章：[DEVONthink 和 Evernote，谁是更好的知识管理工具？ - 少数派](https://sspai.com/post/44774)。

既然我把我写的和剪裁的东西都统一管理在 Devonthink 中，那么能不能把博客的写作流程也整合进去呢？

搜索了一下，发现 Devonthink 能够支持 AppleScript 和 JavaScript for Automation（JXA），实现的思路如下：

1. 用一个 Folder 统一管理写作的文章；
2. 读取这个 Folder 中的所有文章和元数据；
3. 把元数据生成 YAML 格式的内容插入到文章的开头；
4. 把新生成的文章写入到 Hugo 对应的文件夹下。

实现的逻辑很简单，困难点主要在于 JXA 的文档缺乏，有一些操作需要调用系统的 Objective-C Bridge 来进行（相当于在 JavaScript 中写 Objective-C 的代码）。

我写了一个 Alfred Workflow 来完成这个功能，核心代码如下：

```javascript
/**
 * Constants
 */
const devonthink = Application('DEVONthink 3')
const blogPath = '/Users/jiayuan/Dropbox/personal-site/blog/content/post/'


/**
 * Utils
 */

function formatTime(time, cFormat) {
  if (arguments.length === 0) {
    return null
  }
  const format = cFormat || '{y}-{m}-{d} {h}:{i}:{s}'
  let date
  if (typeof time === 'object') {
    date = time
  } else {
    if (('' + time).length === 10) time = parseInt(time) * 1000
    date = new Date(time)
  }
  const formatObj = {
    y: date.getFullYear(),
    m: date.getMonth() + 1,
    d: date.getDate(),
    h: date.getHours(),
    i: date.getMinutes(),
    s: date.getSeconds(),
    a: date.getDay()
  }
  const time_str = format.replace(/{([ymdhisa])+}/g, (result, key) => {
    let value = formatObj[key]
    if (key === 'a') return ['一', '二', '三', '四', '五', '六', '日'][value - 1]
    if (result.length > 0 && value < 10) {
      value = '0' + value
    }
    return value || 0
  })
  return time_str
}


/**
 * Functions
 */

function writeToFile(filename, path, content) {
  if (!path.endsWith('/')) {
    path = path + '/'
  }
  filePath = path + filename

  contentEncoded = $.NSString.alloc.initWithUTF8String(content);
  contentEncoded.writeToFileAtomicallyEncodingError(filePath, true, $.NSUTF8StringEncoding, null);
}

function getMetaData(record) {

  // Get created time
  const createdTime = formatTime(record.creationDate(), '{y}-{m}-{d}')

  // Get updated time
  const updatedTime = formatTime(record.modificationDate(), '{y}-{m}-{d}')

  // Get file name
  const customMetaData = record.customMetaData()
  let fileName = customMetaData.mdblogfilename
  if (!fileName.endsWith('.md')) {
    fileName = fileName + '.md'
  }

  // Get tags
  const tags = record.tags()

  // Get categories
  const category = customMetaData.mdcategory

  // Get draft info
  const isDraft = customMetaData.mddraft

  // Get title
  const title = record.name()

  const metaData = {
    createdTime,
    updatedTime,
    fileName,
    tags,
    category,
    title,
    isDraft
  }

  return metaData
}

function generateYamlMetaString(metaData) {
  let yamlMetaString = `---
title: ${metaData.title}
date: ${metaData.createdTime}
lastmod: ${metaData.updatedTime}
categories: [${metaData.category}]
tags: [${metaData.tags}]
draft: ${metaData.isDraft === true}
---
  `

  return yamlMetaString
}


function main() {
  const blogPosts = devonthink.databases.byName('02.Writing').parents.byName('Blog').children()

  for (let i = 0; i < blogPosts.length; i++) {
    const selectedRecord = blogPosts[i]

    const metaData = getMetaData(selectedRecord)

    const yamlMetaString = generateYamlMetaString(metaData)
    const content = selectedRecord.plainText()
    const blogPostContent = `${yamlMetaString}
${content}
`
    writeToFile(metaData.fileName, blogPath, blogPostContent)
  }

  const app = Application.currentApplication()
  app.includeStandardAdditions = true

  app.displayNotification(`You have generated ${blogPosts.length} articles.`, { withTitle: 'Success' })
}

/**
 * Main
 */
main()
```

源代码可以在这里看到：[alfred-workflows/src/Devonthink-to-Hugo-Blog at master · forrestchang/alfred-workflows](https://github.com/forrestchang/alfred-workflows/tree/master/src/Devonthink-to-Hugo-Blog)。

如果你需要用到你的工作流中，需要配置以下内容：

- hugo 的 `post` 路径，在 `blogPath` 中定义；
- Devonthink 中的 Blog 文件夹，在 `blogPosts` 中定义；
- 需要使用 Devonthink 3 的 Custom Metadata 功能，添加三个 Metadata：`Category` 用来作为此篇博客的分类，`Blog File Name` 用来作为生成的路径名，`Draft` 用来判断是否是草稿。

这个脚本支持读取 Devonthink 的文章标题为博客标题，创建时间为博客的创建时间，Tags 为博客的 Tags，其他的 Metadata 也可以在 `getMetaData` 这个函数中自行定义。

现在这个脚本还不是特别完善，之后会添加一些错误处理的功能并支持 org-mode 格式的文件。

![](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190513165627.png)


