```bash
#!/usr/bin/env bash

echo "====> Download Genomics related tools <===="

mkdir -p $HOME/bin
mkdir -p $HOME/.local/bin
mkdir -p $HOME/share
mkdir -p $HOME/Scripts
#mkdir -p 递归创建目录。

# make sure $HOME/bin in your $PATH
if grep -q -i homebin $HOME/.bashrc; then
    echo "==> .bashrc already contains homebin"
else
    echo "==> Update .bashrc"

    HOME_PATH='export PATH="$HOME/bin:$HOME/.local/bin:$PATH"'
    echo '# Homebin' >> $HOME/.bashrc
    echo $HOME_PATH >> $HOME/.bashrc
    echo >> $HOME/.bashrc

    eval $HOME_PATH
fi
#确保$HOME/bin存在于$PATH中，如果没有，则写入$HOME/bin。





# Clone or pull other repos 
for OP in dotfiles withncbi; do   #for循环，在dotfiles和withncbi中逐一寻找OP，执行下面命令
    if [[ ! -d "$HOME/Scripts/$OP/.git" ]]; then 
        if [[ ! -d "$HOME/Scripts/$OP" ]]; then
            echo "==> Clone $OP"
            git clone https://github.com/wang-q/${OP}.git "$HOME/Scripts/$OP"
        else
            echo "==> $OP exists"
        fi
    else
        echo "==> Pull $OP"
        pushd "$HOME/Scripts/$OP" > /dev/null
        git pull
        popd > /dev/null
    fi
done
#逻辑：在dotfiles和withncbi找到OP后，建立文件“$HOME/Scripts/$OP/.git”，并将https://github.com/wang-q/${OP}的内容写入"$HOME/Scripts/$OP"中。


# alignDB
# chmod +x $HOME/Scripts/alignDB/alignDB.pl #给予运行权限
# ln -fs $HOME/Scripts/alignDB/alignDB.pl $HOME/bin/alignDB.pl #建立一个软连接

echo "==> Jim Kent bin"
cd $HOME/bin/
RELEASE=$( ( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1 )
#LSB是Linux Standard Base的缩写，lsb_release命令用来显示LSB和特定版本的相关信息。-s, --short：输出简短的描述信息，-d 显示该发行版的描述信息。
#uname显示系统内核信息 -o,显示操作系统名称 -m,显示计算机硬件架构。 "||"表示或，前一个命令错误时执行后一个


if [[ $(uname) == 'Darwin' ]]; then
    curl -L https://github.com/wang-q/ubuntu/releases/download/20190906/jkbin-egaz-darwin-2011.tar.gz
else
    if echo ${RELEASE} | grep CentOS > /dev/null ; then
        curl -L https://github.com/wang-q/ubuntu/releases/download/20190906/jkbin-egaz-centos-7-2011.tar.gz
    else
        curl -L https://github.com/wang-q/ubuntu/releases/download/20190906/jkbin-egaz-ubuntu-1404-2011.tar.gz
    fi
fi \
 #根据使用版本的不同安装不同的Jim Kent bin
 
 > jkbin.tar.gz

echo "==> untar from jkbin.tar.gz"
tar xvfz jkbin.tar.gz x86_64/axtChain
tar xvfz jkbin.tar.gz x86_64/axtSort
tar xvfz jkbin.tar.gz x86_64/axtToMaf
tar xvfz jkbin.tar.gz x86_64/chainAntiRepeat
tar xvfz jkbin.tar.gz x86_64/chainMergeSort
tar xvfz jkbin.tar.gz x86_64/chainNet
tar xvfz jkbin.tar.gz x86_64/chainPreNet
tar xvfz jkbin.tar.gz x86_64/chainSplit
tar xvfz jkbin.tar.gz x86_64/chainStitchId
tar xvfz jkbin.tar.gz x86_64/faToTwoBit
tar xvfz jkbin.tar.gz x86_64/lavToPsl
tar xvfz jkbin.tar.gz x86_64/netChainSubset
tar xvfz jkbin.tar.gz x86_64/netFilter
tar xvfz jkbin.tar.gz x86_64/netSplit
tar xvfz jkbin.tar.gz x86_64/netSyntenic
tar xvfz jkbin.tar.gz x86_64/netToAxt

mv $HOME/bin/x86_64/* $HOME/bin/
rm jkbin.tar.gz

if [[ $(uname) == 'Darwin' ]]; then
    curl -L http://hgdownload.soe.ucsc.edu/admin/exe/macOSX.x86_64/faToTwoBit
else
    curl -L http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/faToTwoBit
fi \
    > faToTwoBit
mv faToTwoBit $HOME/bin/
chmod +x $HOME/bin/faToTwoBit
```

```bash
fatal: unable to access 'https://github.com/wang-q/dotfiles.git/': GnuTLS recv error (-110): The TLS connection was non-properly terminated.

#解决办法
~$ git config --global --unset http.https://github.com.proxy

```

```bash
curl: (92) HTTP/2 stream 1 was not closed cleanly before end of the underlying stream

#解决办法：git默认使用的通信协议出现了问题，可以通过将默认通信协议修改为http/1.1来解决该问题。
git config --global http.version HTTP/1.1

```

