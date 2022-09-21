### Setting-up scripts for Ubuntu 20.04

- [Setting-up scripts for Ubuntu 20.04](#setting-up-scripts-for-ubuntu-2004)
    - [Bypass GFW blocking](#bypass-gfw-blocking)
    - [Install packages needed by Linuxbrew and some others](#install-packages-needed-by-linuxbrew-and-some-others)
    - [Optional: adjusting Desktop](#optional-adjusting-desktop)
    - [Install Linuxbrew](#install-linuxbrew)
    - [Download](#download)
    - [Install packages managed by Linuxbrew](#install-packages-managed-by-linuxbrew)
    - [Packages of each language](#packages-of-each-language)
    - [Bioinformatics Apps](#bioinformatics-apps)
    - [MySQL](#mysql)
    - [Optional: dotfiles](#optional-dotfiles)
    - [Directory Organization](#directory-organization)

#### Bypass GFW blocking

- Query the IP address on [ipddress](https://www.ipaddress.com/) for
  - `raw.githubusercontent.com`
  - `gist.githubusercontent.com`
  - `camo.githubusercontent.com`
  - `user-images.githubusercontent.com`

  

You can get 4 IPv4 addresses and 4 IPv6 addresses for user-images.githubusercontent.com .

> 		185.199.108.133	raw.githubusercontent.com
> 		185.199.109.133	gist.githubusercontent.com
> 		185.199.110.133	camo.githubusercontent.com
> 		185.199.111.133	user-images.githubusercontent.com
> 

- Add them to `/etc/hosts` or `C:\Windows\System32\drivers\etc\hosts`

	(/表示在linux中的，\表示在windows中)

```bash
 ~$ cd /etc
 /etc$ sudo vim hosts
 #输入密码
 #进入文件后输入 I 进入编辑模式
 
#127.x.x.x       LAPTOP-VVN6xxxx.localdomain     LAPTOP-VVN6xxxx
185.199.108.133	user-images.githubusercontent.com
185.199.109.133 user-images.githubusercontent.com
#将所有的ip地址和域名添加即可，此处为IPv4 addresses

#ffxx::x ip6-allrouters
2606:50c0:8000::154	user-images.githubusercontent.com
2606:50c0:8001::154	user-images.githubusercontent.com
#将所有的IPv6 addresses和域名添加即可

#输入 esc键退出编辑模式
#输入 ：wq！ 保存退出即可

```

#### install-packages-needed-by-linuxbrew-and-some-others

```bash
echo "==> When some packages went wrong, check http://mirrors.ustc.edu.cn/ubuntu/ for updating status."
# echo 打印字符串中的内容
bash -c "$(curl -fsSL https://raw.githubusercontent.com/wang-q/ubuntu/master/prepare/1-apt.sh)"
# bash -c 从字符串中读取命令； curl 在Shell终端界面中基于URL规则进行的文件传输工作 -f:Fail silently (no output at all) on HTTP errors -s:Silent mode -S:Show error even when -s is used -L: --Locatio Follow redirects.
```



[https://raw.githubusercontent.com/wang-q/ubuntu/master/prepare/1-apt.sh](https://github.com/CapitalLJ/Labours-of-Hercules/blob/main/%E7%AC%AC%E4%BA%8C%E6%AD%A5/1-apt.sh%20.md) 中的bash命令。

#### Optional: adjusting Desktop

In GUI desktop, disable auto updates: `Software & updates -> Updates`, set `Automatically check for updates` to `Never`, untick all checkboxes, click close and click close again.

```shell
# Removes nautilus bookmarks and disables lock screen
echo '==> `Ctrl+Alt+T` to start a GUI terminal'
curl -fsSL https://raw.githubusercontent.com/wang-q/ubuntu/master/prepare/2-gnome.sh |
    bash
```

[https://raw.githubusercontent.com/wang-q/ubuntu/master/prepare/2-gnome.sh](https://github.com/CapitalLJ/Labours-of-Hercules/blob/main/%E7%AC%AC%E4%BA%8C%E6%AD%A5/2-gnome.sh.md)中的bash命令。



#### Install Linuxbrew

使用清华的镜像。

```shell Script
echo "==> Tuna mirrors of Homebrew/Linuxbrew"


#将变量提升为环境变量，下面为设置环境变量
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"

# –depth= 1 参数可以使我们只下载当前的最新提交即可
git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git brew-install
/bin/bash brew-install/install.sh #从本镜像下载安装脚本并安装 Homebrew / Linuxbrew

rm -rf brew-install

#test -d 检测文件是否存在并且为目录，检测环境变量。
test -d ~/.linuxbrew && PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
test -d /home/linuxbrew/.linuxbrew && PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"

# grep:用于全面搜索的正则表达式，并将结果输出.-i 不区分大小写 -q禁止输出任何结果，已退出状态表示搜索是否成功
if grep -q -i Homebrew $HOME/.bashrc; then
    echo "==> .bashrc already contains Homebrew"
else
    echo "==> Update .bashrc"
# 当$HOME/.bashrc不存在新建$HOME/.bashrc。
# echo >> 输出追加重定向。在文件$HOME/.bashrc后面追加输出内容。
    echo >> $HOME/.bashrc
    echo '# Homebrew' >> $HOME/.bashrc
    
    
    echo "export PATH='$(brew --prefix)/bin:$(brew --prefix)/sbin'":'"$PATH"' >> $HOME/.bashrc
    #定义"$PATH"为环境变量并重输入到$HOME/.bashrc中。
    
    echo "export MANPATH='$(brew --prefix)/share/man'":'"$MANPATH"' >> $HOME/.bashrc
    #定义"$MANPATH"为环境变量并重输入到$HOME/.bashrc中。
    
    echo "export INFOPATH='$(brew --prefix)/share/info'":'"$INFOPATH"' >> $HOME/.bashrc
    #定义"$INFDPATH"为环境变量并重输入到$HOME/.bashrc中。
    
    echo "export HOMEBREW_NO_ANALYTICS=1" >> $HOME/.bashrc
    echo 'export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"' >> $HOME/.bashrc
    echo 'export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"' >> $HOME/.bashrc
    echo 'export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"' >> $HOME/.bashrc
    
    echo >> $HOME/.bashrc
fi

source $HOME/.bashrc
```

在安装时遇到了下述问题，并附上了解决办法。

```bash
From https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core
 * [new branch]              master     -> origin/master
fatal: Could not resolve HEAD to a revision
Warning: /home/linuxbrew/.linuxbrew/bin is not in your PATH.

#下面为解决办法
==> Next steps:
- Run these two commands in your terminal to add Homebrew to your PATH:

    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/llj/.profile   

#将"$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"写入/home/llj/.profile 文件中

    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
#eval命令用于重新运算求出参数的内容。

- Run these commands in your terminal to add the non-default Git remotes for Homebrew/brew and Homebrew/homebrew-core:

    echo 'export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"' >> /home/llj/.profile
    echo 'export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"' >> /home/llj/.profile
    
    export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
    export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
    
    
- Install Homebrew's dependencies if you have sudo access:
    sudo apt-get install build-essential
  For more information, see:
    https://docs.brew.sh/Homebrew-on-Linux

```

#### Download

Fill `$HOME/bin`, `$HOME/share` and `$HOME/Scripts`.

```bash
curl -LO https://raw.githubusercontent.com/wang-q/dotfiles/master/download.sh
bash download.sh
source $HOME/.bashrc 

#source命令的功能是用于从指定文件中读取和执行命令，通常用于被修改过的文件，使之新参数能够立即生效，而不必重启整台服务器。
```

[https://raw.githubusercontent.com/wang-q/dotfiles/master/download.sh](https://github.com/CapitalLJ/Labours-of-Hercules/blob/main/%E7%AC%AC%E4%BA%8C%E6%AD%A5/download.sh.md)中的bash命令。



#### Install packages managed by Linuxbrew

Packages include:

- Programming languages: Perl, Python, R, Java, Lua and Node.js
- Some generalized tools

```bash
bash $HOME/Scripts/dotfiles/brew.sh
source $HOME/.bashrc
```

[$HOME/Scripts/dotfiles/brew.sh]() 中的bash命令。

