  
「Linux 命令详解」这个系列的文章将会介绍 Linux/Unix/macOS 系统中使用到的常用命令，包括该命令的简单介绍、常用参数解释以及最佳实践，如果需要快速使用这个命令，直接跳到最佳实践部分即可。

「Linux 命令详解」系列文章：

- [Linux命令详解：SFTP][1]

## 一、介绍

SFTP（Secure File Transfer Protocol，安全文件传输协议）是一种基于可靠数据流（data stream），提供文件存取和管理的网络传输协议，它在网络协议层的结构如下图所示：

![sftp-layer][image-1]

与 FTP 协议相比，SFTP 在客户端与服务器间提供了一种更为安全的文件传输方式，如果你还在使用 FTP 来进行文件传输，强烈建议切换到更为安全的 SFTP 上来。

本篇文章将会介绍 SFTP 的链接，以及在交互式命令行中的一些常用命令，并对一些参数进行解释，最后给出实际使用中的最佳实践。目前已经有很多 GUI 客户端支持 SFTP 协议，但是不在本篇文章的讨论范围之内。

## 二、使用 SFTP 进行连接

因为 SFTP 是基于 SSH 协议的，所以默认的身份认证方法与 SSH 协议保持一致。通常我们使用 SSH Key 来进行连接，如果你已经可以使用 SSH 连接到远程服务器上，那么可以使用以下命令来连接 SFTP：

```bash
sftp user_name@remote_server_address[:path]
```

如果远程服务器自定义了连接的端口，可以使用 `-P` 参数：

```bash
sftp -P remote_port user_name@remote_server_address[:path]
```

连接成功后将进入一个 SFTP 的解释器，可以发现命令行提示符变成了 `sftp>`，使用 `exit` 命令可以退出连接。

如果连接地址存在 `path` 并且 `path` 不是一个目录，那么 SFTP 会直接从服务器端取回这个文件。

## 三、连接参数详解

- `-B`: buffer\_size，制定传输 buffer 的大小，更大的 buffer 会消耗更多的内存，默认为 32768 bytes；
- `-P`: port，制定连接的端口号；
- `-R`: num\_requests，制定一次连接的请求数，可以略微提升传输速度，但是会增加内存的使用量。

## 四、目录管理

在 SFTP 解释器中可以使用 `help` 命令来查看帮助文档。

```bash
sftp> help
Available commands:
bye                                Quit sftp
cd path                            Change remote directory to 'path'
chgrp grp path                     Change group of file 'path' to 'grp'
chmod mode path                    Change permissions of file 'path' to 'mode'
chown own path                     Change owner of file 'path' to 'own'
df [-hi] [path]                    Display statistics for current directory or
                                   filesystem containing 'path'
exit                               Quit sftp
get [-afPpRr] remote [local]       Download file
reget [-fPpRr] remote [local]      Resume download file
reput [-fPpRr] [local] remote      Resume upload file
help                               Display this help text
lcd path                           Change local directory to 'path'
lls [ls-options [path]]            Display local directory listing
lmkdir path                        Create local directory
ln [-s] oldpath newpath            Link remote file (-s for symlink)
lpwd                               Print local working directory
ls [-1afhlnrSt] [path]             Display remote directory listing
lumask umask                       Set local umask to 'umask'
mkdir path                         Create remote directory
progress                           Toggle display of progress meter
put [-afPpRr] local [remote]       Upload file
pwd                                Display remote working directory
quit                               Quit sftp
rename oldpath newpath             Rename remote file
rm path                            Delete remote file
rmdir path                         Remove remote directory
symlink oldpath newpath            Symlink remote file
version                            Show SFTP version
!command                           Execute 'command' in local shell
!                                  Escape to local shell
?                                  Synonym for help
```

SFTP 解释器中预置了常用的命令，但是没有自带的 Bash 来得丰富。

1）显示当前的工作目录：

```bash
sftp> pwd
Remote working directory: /
```

2）查看当前目录的内容：

```bash
sftp> ls
Summary.txt     info.html       temp.txt        testDirectory
```

3）使用 `-la` 参数可以以列表形式查看，并显示隐藏文件：

```bash
sftp> ls -la
drwxr-xr-x    5 demouser   demouser       4096 Aug 13 15:11 .
drwxr-xr-x    3 root       root           4096 Aug 13 15:02 ..
-rw-------    1 demouser   demouser          5 Aug 13 15:04 .bash_history
-rw-r--r--    1 demouser   demouser        220 Aug 13 15:02 .bash_logout
-rw-r--r--    1 demouser   demouser       3486 Aug 13 15:02 .bashrc
drwx------    2 demouser   demouser       4096 Aug 13 15:04 .cache
-rw-r--r--    1 demouser   demouser        675 Aug 13 15:02 .profile
. . .
```

4）切换目录：

```bash
sftp> cd testDirectory
```

5）建立文件夹：

```bash
sftp> mkdir anotherDirectory
```

以上的命令都是用来操作远程服务器的，如果想要操作本地目录呢？只需要在每个命令前添加 `l` 即可，例如显示本地操作目录下的文件：

```bash
sftp> lls
localFiles
```

使用 `!` 可以直接运行 Shell 中的指令：

```bash
sftp> !df -h
Filesystem      Size   Used  Avail Capacity iused               ifree %iused  Mounted on
/dev/disk1s1   466Gi  360Gi  101Gi    79% 3642919 9223372036851132888    0%   /
devfs          336Ki  336Ki    0Bi   100%    1162                   0  100%   /dev
/dev/disk1s4   466Gi  4.0Gi  101Gi     4%       5 9223372036854775802    0%   /private/var/vm
map -hosts       0Bi    0Bi    0Bi   100%       0                   0  100%   /net
map auto_home    0Bi    0Bi    0Bi   100%       0                   0  100%   /home
```

## 五、传输文件

### 5.1 从远程服务器拉取文件

使用 `get` 命令可以从远程服务器拉取文件到本地：

```bash
sftp> get remoteFile [newName]
```

如果不指定 `newName`，将使用和远程服务器相同的文件名。

使用 `-r` 参数可以拉取整个目录：

```bash
sftp> get -r remoteDirectory
```

### 5.2 从本地上传文件到服务器

使用 `put` 命令可以从本地上传文件到服务器：

```bash
sftp> put localFile
```

同样的，可以使用 `-r` 参数来上传整个目录，但是有一点要注意，**如果服务器上不存在这个目录需要首先新建**：

```bash
sftp> mkdir folderName
sftp> put -r folderName
```

## 六、最佳实践

1）连接远程服务器

```bash
sftp remote_user@remote_host
```

2）使用端口进行连接

```bash
sftp -P remote_port remote_user@remote_host
```

3）从远程服务器拉取文件

```bash
get /path/remote_file
```

4）上传本地文件到服务器

```bash
put local_file
```

5）查看远程服务器目录内容

```bash
ls
```

6）查看本地目录内容

```bassh
lls
```

7）执行本地 Shell 命令

```bash
![command]
```

## 参考资料

- [SSH File Transfer Protocol][3]
- [How To Use SFTP to Securely Transfer Files with a Remote Server][4]

[1]:	http://jiayuanzhang.com/linux-command-sftp/
[2]:	https://draveness.me/
[3]:	https://en.wikipedia.org/wiki/SSH_File_Transfer_Protocol
[4]:	https://www.digitalocean.com/community/tutorials/how-to-use-sftp-to-securely-transfer-files-with-a-remote-server

[image-1]: https://raw.githubusercontent.com/forrestchang/img-repo/master/sftp-layer.png

