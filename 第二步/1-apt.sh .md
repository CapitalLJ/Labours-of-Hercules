关于1-apt.sh中一些bash命令的学习，从这个[界面](https://www.linuxcool.com/)可以找到一些命令的帮助。

```bash
#!/usr/bin/env bash
# “#！”后接解释器的绝对路径，用于调用解释器。 env bash则是让计算机在$PATH中逐一目录寻找bash。

echo "====> Install softwares via apt-get <===="
# apt-get:其功能是用于管理服务软件
#哈啥就是
echo "==> Disabling the release upgrader禁用发布升级"
sudo sed -i.bak 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades
#sed：用于利用语法/脚本对文本文件进行批量的编辑操作。-i.bak: edit files in place (makes backup if SUFFIX supplied).  将目标文件中的"^Prompt=.*$"替换成"Prompt=never"并另存为/etc/update-manager/release-upgrades.bak中。

#sed语法：sed [-hnV][-e<script>][-f<script文件>][文本文件]


echo "==> Switch to an adjacent mirror"  #替换镜像源为临近镜像源
# https://lug.ustc.edu.cn/wiki/mirrors/help/ubuntu

cat <<EOF > list.tmp	#cat：查看文件内容。 cat <<EOF > 文件名 ：持续写入内容直到第二个EOF出现。
deb https://mirrors.ustc.edu.cn/ubuntu/ focal main restricted universe multiverse		#deb开头的行表示二进制包仓库
deb-src https://mirrors.ustc.edu.cn/ubuntu/ focal main restricted universe multiverse	#deb-src开头的行表示二进制包的源码库
deb https://mirrors.ustc.edu.cn/ubuntu/ focal-security main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ focal-security main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
## Not recommended
# deb https://mirrors.ustc.edu.cn/ubuntu/ focal-proposed main restricted universe multiverse
# deb-src https://mirrors.ustc.edu.cn/ubuntu/ focal-proposed main restricted universe multiverse
EOF

#deb后面的内容有三大部分：deb URI section1 section2 || URI: 库所在的地址  ||section1 版本 ||section2：不同的软件包索引。main: 完全的自由软件。restricted: 不完全的自由软件。universe: Ubuntu官方不提供支持与补丁，全靠社区支持。multiverse：非自由软件，完全不提供支持和补丁。


#apt可以将软件库存储在如下文件中：/etc/apt/sources.list和/etc/apt/sources.list.d/目录中带.list后缀的文件中。下面命令是将检测是否存在/etc/apt/sources.list的备份文件，如果没有新建备份文件，并将我们修改替换镜像源的list.tmp文件替换到系统的/etc/apt/sources.list文件中。
if [ ! -e /etc/apt/sources.list.bak ]; then
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
fi
sudo mv list.tmp /etc/apt/sources.list


# Virtual machines needn't this and I want life easier.
# https://help.ubuntu.com/lts/serverguide/apparmor.html
if [ "$(whoami)" == 'vagrant' ]; then
    echo "==> Disable AppArmor"
    sudo service apparmor stop #关闭apparmor服务
    sudo update-rc.d -f apparmor remove #从所有的运行级别中删除指定启动项
fi
#bash在读取或打印变量时，需使用$+变量名，""用于表示变量，''表示字符串。如果当前用户为游客，则关闭AppArmor，Apparmor是一个Linux系统安全应用程序。

echo "==> Disable whoopsie"
sudo sed -i 's/report_crashes=true/report_crashes=false/' /etc/default/whoopsie  #修改whoopsie的配置文件
sudo service whoopsie stop #关闭whoopsie服务，whoopsie是linux出现系统崩溃是的一个报错程序。

#安装一些linuxbrew的依赖包
echo "==> Install linuxbrew dependences"
sudo apt-get -y update  #-y 无需系统再次确认，update和upgrad更新并升级apt-pet
sudo apt-get -y upgrade
sudo apt-get -y install build-essential curl file git
sudo apt-get -y install libbz2-dev zlib1g-dev libzstd-dev libexpat1-dev
# sudo apt-get -y install libcurl4-openssl-dev libncurses-dev

echo "==> Install other software"
sudo apt-get -y install aptitude parallel vim screen xsltproc numactl

echo "==> Install develop libraries"
# sudo apt-get -y install libreadline-dev libedit-dev
sudo apt-get -y install libdb-dev libxml2-dev libssl-dev libncurses5-dev # libgd-dev
# sudo apt-get -y install gdal-bin gdal-data libgdal-dev # /usr/lib/libgdal.so: undefined reference to `TIFFReadDirectory@LIBTIFF_4.0'
# sudo apt-get -y install libgsl0ldbl libgsl0-dev

# Gtk stuff, Need by alignDB
# install them in a fresh machine to avoid problems
echo "==> Install gtk3"
#sudo apt-get -y install libcairo2-dev libglib2.0-0 libglib2.0-dev libgtk-3-dev libgirepository1.0-dev
#sudo apt-get -y install gir1.2-glib-2.0 gir1.2-gtk-3.0 gir1.2-webkit-3.0

echo "==> Install gtk3 related tools"
# sudo apt-get -y install xvfb glade

echo "==> Install graphics tools"
sudo apt-get -y install gnuplot graphviz imagemagick

#echo "==> Install nautilus plugins"
#sudo apt-get -y install nautilus-open-terminal nautilus-actions

# Mysql will be installed separately.
# Remove system provided mysql package to avoid confusing linuxbrew.
echo "==> Remove system provided mysql"
# sudo apt-get -y purge mysql-common

#将系统的sources.list文件还原。
echo "==> Restore original sources.list"
if [ -e /etc/apt/sources.list.bak ]; then
    sudo rm /etc/apt/sources.list
    sudo mv /etc/apt/sources.list.bak /etc/apt/sources.list
fi

echo "====> Basic software installation complete! <===="
```

