
Web 后端开发者很少会去充分了解跨域问题，原因是他们很少和 JavaScript 打交道。但是作为一个 Web 开发者，知道跨域请求和如何解决跨域问题可以和前端开发者在沟通上变得更为顺畅。

这篇文章会介绍和跨域请求相关的一些概念，以及如何在后端（Python）解决浏览器的跨域请求问题。

## 一、什么是跨域请求

首先，我们要了解什么是跨域请求。简单来说，当一台服务器资源从另一台服务器（不同的域名或者端口）请求一个资源时，就会发起一个跨域 HTTP 请求。

举个简单的例子，`http://example-a.com/index.html` 这个 HTML 页面请求了 `http://example-b.com/resource/image.jpg` 这个图片资源时（发起 Ajax 请求，非 `<img>` 标签），就是发起了一个跨域请求。

在不做任何处理的情况下，这个跨域请求是无法被成功请求的，因为浏览器基于**同源策略**会对跨域请求做一定的限制。

## 二、浏览器同源策略

这就引出了**浏览器的同源策略（Same-origin policy）**，同源策略限制了从同一个源加载的文档或者脚本如何与来自另一个源的资源进行交互。这是一个用于隔离潜在恶意文件的重要安全机制。

什么是同源？同源需要同时满足三个条件：

1. 请求的协议相同（例如同为 http 协议）
2. 请求的域名相同（例如同为 `www.example.com`）
3. 请求的端口相同（例如同为 80 端口）

第 2 点需要注意的是，必须是域名完全相同，比如说 `blog.example.com` 和 `mail.example.com` 这两个域名，虽然它们的顶级域名和二级域名（均为 `example.com`）都相同，但是三级域名（`blog` 和 `mail`）不相同，所以也不能算作域名相同。

如果不同时满足这上面三个条件，那就不符合浏览器的同源策略。

修改 `document.domain` 参数可以更改当前的源，例如 `blog.example.com` 想要访问父域 `example.com` 的资源时，可以执行以下 JavaScript 脚本来进行修改：

```js
document.domain = 'example.com';
```

但是 `document.domain` 不能被设置为 `foo.com` 或者是 `bar.com`，因为它们不是 `blog.example.com` 的超级域。

当然，也不是所有的交互都会被同源策略拦截下来，下面两种交互就不会触发同源策略：

- 跨域写操作（Cross-origin writes），例如超链接、重定向以及表单的提交操作，特定少数的 HTTP 请求需要添加预检请求（preflight）；
- 跨域资源嵌入（Cross-origin embedding）：
  - `<script>` 标签嵌入的跨域脚本；
  - `<link>` 标签嵌入的 CSS 文件；
  - `<img>` 标签嵌入图片；
  - `<video>` 和 `<audio>` 标签嵌入多媒体资源；
  - `<object>`, `<embed>`, `<applet>` 的插件；
  - `@font-face` 引入的字体，一些浏览器允许跨域字体（cross-origin fonts），一些需要同源字体（same-origin fonts）；
  - `<frame>` 和 `<iframe>` 载入的任何资源，站点可以使用 `X-Frame-Options` 消息头来组织这种形式的跨域交互。

如果浏览器缺失同源策略这种安全机制会怎么样呢？设想一下，当你登陆了 `www.bank.com` 银行网站进行操作时，浏览器保存了你登录时的 Cookie 信息，如果没有同源策略，在访问其他网站时，其他网站就可以读取还未过期的 Cookie 信息，从而伪造登陆进行操作，造成财产损失。

## 三、CORS（Cross-origin resource sharing，跨域资源共享）

虽然同源策略一定程度上保证了安全性，但是如果是一个正常的请求需要跨域该怎么做呢？

常见的方法有四种：

1. JSONP
2. `<iframe>` 标签
3. CORS（Cross-origin resource sharing，跨域资源共享）
4. 代理服务器

前两种方式本质上是利用浏览器同源策略的漏洞来进行跨域请求，不是推荐的做法，只能作为低版本浏览器的缓兵之计。

代理服务器的做法是让浏览器访问同源服务器，再由同源服务器去访问目标服务器，这样虽然可以避免跨域请求的问题，但是原本只需要一次的请求被请求了两次，无疑增加了时间的开销。

目前主流的方法是使用 CORS 的方式，这也是下面主要讲的内容。

### 3.1 什么是 CORS

CORS 其实是浏览器制定的一个规范，它的实现则主要在服务端，它通过一些 HTTP Header 来限制可以访问的域，例如页面 A 需要访问 B 服务器上的数据，如果 B 服务器上声明了允许 A 的域名访问，那么从 A 到 B 的跨域请求就可以完成。

对于那些会对服务器数据产生副作用的 HTTP 请求，浏览器会使用 `OPTIONS` 方法发起一个预检请求（preflight request），从而可以获知服务器端是否允许该跨域请求，服务器端确认允许后，才会发起实际的请求。在预检请求的返回中，服务器端也可以告知客户端是否需要身份认证信息。

### 3.2 简单请求（Simple requests）

某些请求不会触发 CORS 预检请求，我们称这样的请求为简单请求。

若请求满足下面所有条件，则该请求可视为简单请求：

- `GET`, `HEAD`, `POST` 方法之一；
- Header 仅有以下字段：
  - `Accept`
  - `Accept-Language`
  - `Content-Language`
  - `Content-Type` 为下面三者之一：
    - `text / plain`
    - `multipart / form-data`
    - `application / x-www.form-urlencoded`
  - `DPR`
  - `Downloadlink`
  - `Save-Data`
  - `Viewport-Width`
  - `Width`
- 请求中的任意 `XMLHttpRequestUpload` 对象均没有注册任何事件监听器，`XMLHttpRequestUpload` 对象可以使用 `XMLHttpRequest.upload` 属性访问；
- 请求中没有使用 `ReadableStream` 对象。

举一个例子[^1]，例如站点 `http://foo.example` 的网页应用想要访问 `http://bar.other` 的资源，`http://foo.example` 的网页中可能包含类似于下面的 JavaScript 代码：

```javascript
var invocation = new XMLHttpRequest();
var url = 'http://bar.other/resources/public-data/';
   
function callOtherDomain() {
  if(invocation) {    
    invocation.open('GET', url, true);
    invocation.onreadystatechange = handler;
    invocation.send(); 
  }
}
```

熟悉 JavaScript 的同学可能发现这段代码向 `http://bar.other/resources/public-data/` 发起了一个 `GET` 请求，请求和响应的报文如下。

请求报文：

![2018-12-02-request-msg](https://raw.githubusercontent.com/forrestchang/img-repo/master/20190505164610.png)

响应报文：

![2018-12-02-response-msg](https://ws1.sinaimg.cn/large/006tNbRwgy1fxsiwz302wj31uo0rsn0i.jpg)

在请求报文中，`Origin` 字段表明该请求来源于 `http://foo.example`。

在响应报文中，`Access-Control-Allow-Origin` 字段被设置为 `*`，表明该资源可以被任意的域访问。

使用 `Origin` 和 `Access-Control-Allow-Origin` 就能完成最简单访问控制。如果服务端仅允许来自 `http://foo.example` 域的访问，应该把 进行如下设置：

```http
Access-Control-Allow-Origin: http://foo.example
```

### 3.3 预检请求（Preflight Request）

和简单请求不同，「需预检的请求」要求必须先使用 `OPTIONS` 方法发送一个预检请求到服务器，以获知服务器是否允许该请求，或者是否需要携带身份认证信息。「预检请求」的使用，可以避免跨域请求对服务器的用户数据产生未预期的影响。

当一个请求满足以下任一条件时，该请求需要首先发送预检请求。

- 使用了下面任一 HTTP 方法：`PUT`、`DELETE`、`CONNECT`、`OPTIONS`、`TRACE`、`PATCH`；
- Header 中设置了除简单请求 Header 字段外的其他字段（见简单请求中的 Header 字段说明）；
- `Content-Type` 的值不属于下列之一：
  - `application/x-www-form-urlencoded`
  - `multipart/form-data`
  - `text/plain`
- 请求中的 `XMLHttpRequestUpload` 对象注册了任意多个事件监听器；
- 请求中使用了 `ReadableStream` 对象。



例如下面这个例子[^1]：

```js
var invocation = new XMLHttpRequest();
var url = 'http://bar.other/resources/post-here/';
var body = '<?xml version="1.0"?><person><name>Arun</name></person>';
    
function callOtherDomain(){
  if(invocation)
    {
      invocation.open('POST', url, true);
      invocation.setRequestHeader('X-PINGOTHER', 'pingpong');
      invocation.setRequestHeader('Content-Type', 'application/xml');
      invocation.onreadystatechange = handler;
      invocation.send(body); 
    }
}
```

上面的代码使用 POST 请求发送一个 XML 文档，该请求中包含了一个自定义的 Header 字段 `X-PINGOTHER: pingpong`。另外，该请求的 `Content-Type` 为 `application/xml`，因此，该请求需要首先发起「预检请求」。

OPTIONS 请求报文：

![2018-12-03-option-request-msg](https://ws4.sinaimg.cn/large/006tNbRwgy1fxtit1a99sj31uo0rs0yi.jpg)

OPTIONS 响应报文：

![2018-12-03-option-response-msg](https://ws1.sinaimg.cn/large/006tNbRwgy1fxtiwydue5j31uo0rsjwi.jpg)

OPTIONS 方法是 HTTP/1.1 中定义的方法，用以从服务器获取更多的信息，该方法不会对服务器资源产生影响。预检请求的 Headers 中携带了两个字段：

```http
Access-Control-Request-Method: POST
Access-Control-Request-Headers: X-PINGOTHER, Content-Type
```

`Access-Control-Request-Method: POST` 字段告诉服务器，实际请求将使用 `POST` 方法；`Access-Control-Request-Headers` 字段告诉服务器，实际请求将携带两个自定义请求的 Header 字段：`X-PINGOTHER` 和 `Content-Type`，服务器根据此决定，该实际请求是否被允许。

OPTIONS 响应报文表明服务器将接受后续的实际请求，其中：

```http
Access-Control-Allow-Origin: http://foo.example
Access-Control-Allow-Methods: POST, GET, OPTIONS
Access-Control-Allow-Headers: X-PINGOTHER, Content-Type
Access-Control-Max-Age: 86400
```

- `Access-Control-Allow-Origin `表示允许 `http://foo.example` 的域进行访问；
- `Access-Control-Allow-Methods` 表明允许客户端发送 `POST`，`GET`，`OPTIONS` 请求；
- `Access-Control-Allow-Headers` 表明语序客户端携带 `X-PINGOTHER` 和 `Content-Type` Header 字段；
- `Access-Control-Max-Age` 表明该响应的有效时间为 86400 秒（24 小时），在有效时间内，浏览器无需为同一请求再次发起预检请求。（注，浏览器自身维护了一个最大有效时间，如果该 Header 字段超过了最大有效时间，将不会生效）。

预检请求完成之后，发送实际的请求，请求报文如下：

```http
POST /resources/post-here/ HTTP/1.1
Host: bar.other
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1b3pre) Gecko/20081130 Minefield/3.1b3pre
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-us,en;q=0.5
Accept-Encoding: gzip,deflate
Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7
Connection: keep-alive
X-PINGOTHER: pingpong
Content-Type: text/xml; charset=UTF-8
Referer: http://foo.example/examples/preflightInvocation.html
Content-Length: 55
Origin: http://foo.example
Pragma: no-cache
Cache-Control: no-cache

<?xml version="1.0"?><person><name>Arun</name></person>
```

响应报文：

```http
HTTP/1.1 200 OK
Date: Mon, 01 Dec 2008 01:15:40 GMT
Server: Apache/2.0.61 (Unix)
Access-Control-Allow-Origin: http://foo.example
Vary: Accept-Encoding, Origin
Content-Encoding: gzip
Content-Length: 235
Keep-Alive: timeout=2, max=99
Connection: Keep-Alive
Content-Type: text/plain

[Some GZIP'd payload]
```

### 3.4 附带身份认证的请求

一般而言，对于跨域 `XMLHTTPRequest` 或者 `Fetch` 请求，浏览器不会发送身份凭证信息，如果需要发送身份凭证信息，需要把 `XMLHTTPRequest` 的 `withCredentials` 属性设置为 `true`。

举个例子，下面这段代码表示 `http://foo.example` 向 `http://bar.other` 发送一个 `GET` 请求，并且设置 `Cookies`。

```js
var invocation = new XMLHttpRequest();
var url = 'http://bar.other/resources/credentialed-content/';
    
function callOtherDomain(){
  if(invocation) {
    invocation.open('GET', url, true);
    invocation.withCredentials = true;
    invocation.onreadystatechange = handler;
    invocation.send(); 
  }
}
```

通过把 `withCredentials` 设置为 `true`，从而向服务器发送一个携带 `Cookies` 的请求。因为这是一个简单的 `GET` 请求，所以浏览器不会发起预检请求，但是，服务端的响应中如果未携带 `Access-Control-Allow-Credentials: true` ，浏览器不会把响应内容返回给请求的发送者。

对于携带身份认证的请求，服务器不得设置 `Access-Control-Allow-Origin` 的值为 `*`。

### 3.5 用于 CORS 的 Headers

下面列出所有用于 HTTP 请求和响应中的 Header 字段，具体的使用请查阅[相关文档](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS#The_HTTP_response_headers)。

HTTP 请求 Headers：

- `Origin`：表明预检请求或实际请求的源站，它不包含任何路径信息，只是服务器名称（URI）；
- `Access-Control-Request-Method`：用于预检请求，作用是将实际请求所使用 HTTP 方法告诉服务器；
- `Access-Control-Request-Headers`：用于预检请求，作用是将实际请求所使用的 Header 字段告诉服务器；

HTTP 响应 Headers：

- `Access-Control-Allow-Origin`：指定了允许访问该资源的外域 URI；
- `Access-Control-Expose-Headers`：让服务器把允许浏览器访问的头放入白名单，这样浏览器就能使用 `getResponseHeader` 方法来访问了；
- `Access-Control-Max-Age`：指定了预检请求的结果能够被缓存多久；
- `Access-Control-Allow-Credentials`：指定了当浏览器的`credentials`设置为 true 时是否允许浏览器读取 response 的内容；
- `Access-Control-Allow-Headers`：用于预检请求的响应。其指明了实际请求中允许携带的首部字段。

## 四、服务器端实现

为了实现 CORS，在服务器端需要做一些工作，最主要的就是在响应 Header 中添加指定的字段。

如果是使用 Python + Flask 的开发的话，可以在 `after_app_request` 钩子函数中添加指定的响应头：

```python
@app.after_app_request
def after_request(response):
    """正常请求结束后的处理"""
    # ... some code here
    
    response.headers['Access-Control-Allow-Origin'] = 'http://example.com'
    response.headers['Access-Control-Allow-Methods'] = 'GET, PUT, POST, DELETE, HEAD, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = (
        'Content-Type, Authorization, X-Requested-With'
    )
    
    # ... some code here
    
    return response
```

其他语言在对应的钩子函数中处理即可。

## 参考资料

- [Cross-Origin Resource Sharing (CORS)](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)
- [Same-origin policy](https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy)
- [浏览器同源政策及其规避方法](http://www.ruanyifeng.com/blog/2016/04/same-origin-policy.html)

[^1]: 这个例子的来源：[Cross-Origin Resource Sharing (CORS)](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)