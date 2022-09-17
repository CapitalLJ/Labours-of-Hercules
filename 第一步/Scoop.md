## Scoop

#### Install Scoop

```powershell
set-executionpolicy remotesigned -s currentuser #给予当前用户权限
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')

scoop install sudo 7zip  #sudo linux中sudo可以给予普通用户root权限。

scoop install aria2 dark innounp  #安装报错可参考下面教程,关于Scoop的使用在里面也有介绍，此时还没有使用成功。
```

If you can't install , you can browse [this page](https://hackettyu.com/2020-05-07-windows-scoop/#scoop-bucket).

Scoop can utilize aria2 to use mult-connection downloads.

Close the powershell windows and start a new one to refresh the environment variables.

#### Install packages

```powershell
scoop bucket known # 查看官方支持的库
scoop bucket add extras #方便我们安装更为常见的带有 GUI 的软件
#下面为一些可能需要的软件
scoop install curl wget
scoop install gzip unzip grep
scoop install jq jid pandoc

scoop install bat ripgrep tokei hyperfine
scoop install sqlite sqlitestudio

```

- List install packages

  ```powershell
  scoop list #查看已下载的安装包
  ```

  