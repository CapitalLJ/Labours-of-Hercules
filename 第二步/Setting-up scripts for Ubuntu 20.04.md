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

> 		185.199.108.133
> 		185.199.109.133
> 		185.199.110.133
> 		185.199.111.133
> 		2606:50c0:8000::154
> 		2606:50c0:8001::154
> 		2606:50c0:8002::154
> 		2606:50c0:8003::154

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
















