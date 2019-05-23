  
OmniFocus 3 提供了 Dark Mode，但是却没有提供自定义主题的功能，Dark Mode 看久了也会腻，所以最近又切换到 Light Mode 下来了。搜索了一下，看到这篇讨论：[Is it possible to reduce fontsize or fontstyle of the headline of a perspective?](https://discourse.omnigroup.com/t/is-it-possible-to-reduce-fontsize-or-fontstyle-of-the-headline-of-a-perspective/44258/8?u=jannock)。可以通过修改配置的方式来修改 OmniFocus 的主题。

![](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190523111224.png)

具体的修改方法为：

在 `/Applications/OmniFocus.app/Contents/Resources/ThemeResources/SystemFont` 下面修改字体的大小和页边距，首先我们先修改边距大小，我默认选择的是 Extra Large 的字体，所以需要修改 `OFIExtraLargeLayoutConstraintConstants.plit`。

找到以下代码：

```xml
<key>extraPaddingBelowNoteForActionCells</key>
<real>20</real>
<key>extraPaddingBelowNoteForColumnarActionCells</key>
<real>20</real>
<key>extraPaddingBelowNoteForProjectCells</key>
<real>20</real>
```

然后把 `real` 的值设定成自己想要的就好了，我这边设定为 20，最后看起来的效果还可以。

然后修改 Note 的字体，打开 `OFIFontRegistry.plit`，找到以下代码：

```xml
<key>OFITextStyleNoteBody</key>
<dict>
	<key>content-sizes</key>
	<array>
		<real>13</real>
		<real>13</real>
		<real>14</real>
		<real>15</real>
		<real>16</real>
	</array>
	<key>font-name</key>
	<string>regular</string>
</dict>
```

依次修改 `real` 的值，对应 OmniFocus 的以下配置：

![](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190523112118.png)

Next Action, Due 和 Overdue 的颜色可以在 `/Applications/OmniFocus.app/Contents/Resources/ThemeResources/` 下面修改，找到对应的主题，例如我现在使用的是 Light Mode，就修改 `30-Light-ColoredText/OFIThemeAppearance.plist` 文件。

其中颜色的值使用的 NSColor HSB[^nscolor] 格式的，需要对 RGB 或者 Hex 格式的颜色值做一下转换，可以找到喜欢的颜色值，然后在[这个网站](https://rgb.to/)[^convert]转换。

把 Resource 中的配置文件浏览了一下，发现还是可以定制很多其他东西的，基于这个可以实现一个主题工具，但是不知道 OmniFocus 更新会不会把 Resource 文件覆盖掉，这个之后测试一下。

[^nscolor]: [NSColor - AppKit | Apple Developer Documentation](https://developer.apple.com/documentation/appkit/nscolor)
[^convert]: [Convert Hex color #7ca746 to Rgb, Pantone, RAL, HSL, HSV, HSB, JSON. Get color scheme.](https://rgb.to/)
