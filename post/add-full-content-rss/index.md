
之前博客虽然也有 RSS，但是不是全文索引的，为了方便读者能够直接在 RSS 阅读器中阅读，花了点时间给博客添加了全文 RSS 输出。

查阅文档[^fn:1]可知，Hugo 的 RSS 模板搜索顺序如下：

```nil
[layouts/index.rss.xml
layouts/home.rss.xml
layouts/rss.xml
layouts/list.rss.xml
layouts/index.xml
layouts/home.xml
layouts/list.xml
layouts/_default/index.rss.xml
layouts/_default/home.rss.xml
layouts/_default/rss.xml
layouts/_default/list.rss.xml
layouts/_default/index.xml
layouts/_default/home.xml
layouts/_default/list.xml
layouts/_internal/_default/rss.xml]
```

我们随便按照顺序建立一个 xml 模板文件即可，例如，我们这里建立
`layouts/index.rss.xml` 文件，使用 Hugo 官方提供的 RSS 模板：

```xml
{{ printf "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\" ?>" | safeHTML }}
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <title>{{ if eq  .Title  .Site.Title }}{{ .Site.Title }}{{ else }}{{ with .Title }}{{.}} on {{ end }}{{ .Site.Title }}{{ end }}</title>
    <link>{{ .Permalink }}</link>
    <description>Recent content {{ if ne  .Title  .Site.Title }}{{ with .Title }}in {{.}} {{ end }}{{ end }}on {{ .Site.Title }}</description>
    <generator>Hugo -- gohugo.io</generator>{{ with .Site.LanguageCode }}
    <language>{{.}}</language>{{end}}{{ with .Site.Author.email }}
    <managingEditor>{{.}}{{ with $.Site.Author.name }} ({{.}}){{end}}</managingEditor>{{end}}{{ with .Site.Author.email }}
    <webMaster>{{.}}{{ with $.Site.Author.name }} ({{.}}){{end}}</webMaster>{{end}}{{ with .Site.Copyright }}
    <copyright>{{.}}</copyright>{{end}}{{ if not .Date.IsZero }}
    <lastBuildDate>{{ .Date.Format "Mon, 02 Jan 2006 15:04:05 -0700" | safeHTML }}</lastBuildDate>{{ end }}
    {{ with .OutputFormats.Get "RSS" }}
        {{ printf "<atom:link href=%q rel=\"self\" type=%q />" .Permalink .MediaType | safeHTML }}
    {{ end }}
    {{ range .Pages }}
    <item>
      <title>{{ .Title }}</title>
      <link>{{ .Permalink }}</link>
      <pubDate>{{ .Date.Format "Mon, 02 Jan 2006 15:04:05 -0700" | safeHTML }}</pubDate>
      {{ with .Site.Author.email }}<author>{{.}}{{ with $.Site.Author.name }} ({{.}}){{end}}</author>{{end}}
      <guid>{{ .Permalink }}</guid>
      <description>{{ .Summary | html }}</description>
    </item>
    {{ end }}
  </channel>
</rss>
```

其中，我们需要全局输出，只需要修改 `<description>{{ .Summary | html
}}</description>` 为 `<description>{{ .Content | html }}</description>` 即可。

`config.toml` 配置中的一些字段可以用来控制 RSS 的输出：

```toml
rssLimit = 10  # 限制 RSS 文章输出的数量
languageCode = "en-us"
copyright = "This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License."

[author]
    name = "My Name Here"
```

最开始的时候生成 RSS 会抛出一些异常：

```language
 error on line 455 at column 40: PCDATA invalid Char value 8
```

一般来说，出现这些问题是因为 Markdown 文件中存在一些特殊字符，例如 `^H`、`^E` 等字符，解决办法有两个：

1.  通过 Hugo 的正则表达式替换掉特殊字符，参考文档[^fn:2]
2.  在 markdown 源文件中把特殊字符删除

另外，可以通过这个链接来订阅本博客：<http://blog.jiayuanzhang.com/index.xml>

[^fn:1]: : <https://gohugo.io/templates/rss/>
[^fn:2]: : <https://gohugo.io/functions/replacere/#readout>
