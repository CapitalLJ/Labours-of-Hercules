## Setting-up scripts for Windows 10



- [Setting-up scripts for Windows 10](#setting-up-scripts-for-windows-10)
    - [Get ISO](#get-iso)
    - [Install, active and update Windows](#install-active-and-update-windows)
    - [Enable some optional features of Windows 10](#enable-some-optional-features-of-windows-10)
    - [WSL 2](#wsl-2)
    - [Ubuntu 20.04](#ubuntu-2004)
    - [Install `winget` and `Windows Terminal`](#install-winget-and-windows-terminal)
    - [Optional: Adjusting Windows](#optional-adjusting-windows)
    - [Optional: winget-pkgs](#optional-winget-pkgs)
    - [Optional: Windows 7 games](#optional-windows-7-games)
    - [Optional: Packages Managements](#optional-packages-managements)
    - [Optional: Rust and C/C++](#optional-rust-and-cc)
    - [Directory Organization](#directory-organization)

Most following commands should be pasted to `Powershell`.

### Get ISO
为了确保你使用的windows能够启用虚拟化，请更新你的windows系统。

Some features of Windows 10 20H1/2004 are needed here.

* Build 19041.84 or later
* English or Chinese Simplified
* 64-bit


### Install, active and update Windows

* Enable Virtualization in BIOS or VM

	Follwo instructions of [this page](https://support.microsoft.com/zh-cn/windows/%E5%9C%A8windows-11%E7%94%B5%E8%84%91%E4%B8%8A%E5%90%AF%E7%94%A8%E8%99%9A%E6%8B%9F%E5%8C%96-c5578302-6e43-4b4b-a449-8ced115f58e1).


* Update Windows and then check system info

```powershell
# simple
winver		#查看windows版本

# details
systeminfo  

#查看输出结果中的Hyper-V 要求:     已检测到虚拟机监控程序。将不显示 Hyper-V 所需的功能。

```

After Windows updating, the Windows version  is 22000.856 as my current date.

## Enable some optional features of Windows 10

* Mount Windows ISO to D: (or others)

* Open PowerShell as an Administrator

```powershell
# .Net 2.5 and 3
DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:D:\sources\sxs

# Online
# DISM /Online /Enable-Feature /FeatureName:NetFx3 /All

# SMB 1（开启SMB1权限，是一种网络共享协议）
Enable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -All

# Telnet(启用TelnetClient)
DISM /Online /Enable-Feature /FeatureName:TelnetClient

```

你也可以按照[教程](<https://learn.microsoft.com/zh-cn/dotnet/framework/install/dotnet-35-windows>)开启NETFX3。

## WSL 2

* Follow instructions of [this page](https://docs.microsoft.com/en-us/windows/wsl/wsl2-install).

  ```powershell
  #Open PowerShell as an Administrator
  wsl --install
  
  ```

  

* Open PowerShell as an Administrator（）

```powershell
# HyperV
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart

# WSL
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
#可直接按照第一步安装即可

```

Update the [WSL 2](https://docs.microsoft.com/en-us/windows/wsl/wsl2-kernel) Linux kernel if necessarily.

Restart then set WSL 2 as default.

```powershell
wsl -l -v
#   NAME      STATE           VERSION
# * Ubuntu    Running         2
#如果version为1，可以使用下面的命令进行替换
wsl --set-default-version 2
```

## Ubuntu 20.04

Search `bash` in Microsoft Store or use the following command lines.

```powershell
if (!(Test-Path Ubuntu.appx -PathType Leaf))
{
    Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile Ubuntu.appx -UseBasicParsing
}
Add-AppxPackage .\Ubuntu.appx #安装Ubuntu，使用wsl --install时系统会自动安装新版本的ubuntu。

```

Launch the distro from the Start menu, wait for a minute or two for the installation to complete,
and set up a new Linux user account.

The following command verifies the status of WSL:

```powershell
wsl -l -v

```

### Symlinks

* WSL: reduce the space occupied by virtual disks

```shell
cd

rm -fr Script data

ln -s /mnt/c/Users/wangq/Scripts/ ~/Scripts
#建立一个软连接，可通过help查看相关参数说明
ln -s /mnt/d/data/ ~/data

```

* Windows: second disk
    * Open `cmd.exe` as an Administrator

```cmd
cd c:\Users\wangq\

mklink /D c:\Users\wangq\data d:\data

```

## Install `winget` and `Windows Terminal`

```powershell
if (!(Test-Path Microsoft.WindowsTerminal.msixbundle -PathType Leaf))
{
    Invoke-WebRequest `
        'https://github.com/microsoft/winget-cli/releases/download/v1.2.10271/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle' `
        -OutFile 'Microsoft.DesktopAppInstaller.msixbundle'
}
Add-AppxPackage -path .\Microsoft.DesktopAppInstaller.msixbundle

winget --version

winget install -e --id Microsoft.WindowsTerminal

winget install -e --id Microsoft.PowerShell

winget install -e --id Git.Git

```

You can browse [this page](https://learn.microsoft.com/zh-cn/windows/package-manager/winget/) to learn winget.

Open `Windows Terminal`

* Set `Settings` -> `Startup` -> `Default profile` to `PowerShell`, not `Windows PowerShell`.

* Set `Default terminal application` to `Windows Terminal`.

* Hide unneeded `Profiles`.

## Optional: Adjusting Windows

Works with Windows 10 or 11.

```powershell
mkdir -p ~/Scripts  #新建目录  ~表示用户目录
cd ~/Scripts #切换到新建目录
git clone --recursive https://github.com/wang-q/windows

cd ~/Scripts/windows/setup
powershell.exe -NoProfile -ExecutionPolicy Bypass `
    -File "Win10-Initial-Setup-Script/Win10.ps1" `
    -include "Win10-Initial-Setup-Script/Win10.psm1" `
    -preset "Default.preset"

```

Log in to the Microsoft Store and get updates from there.

## Optional: winget-pkgs

```powershell
# You can install what you want.
# programming 
# winget install -s winget -e --id AdoptOpenJDK.OpenJDK
winget install -s winget -e --id Oracle.JavaRuntimeEnvironment
winget install -s winget -e --id Oracle.JDK.18
# winget install -s winget -e --id Microsoft.dotnet
winget install -s winget -e --id StrawberryPerl.StrawberryPerl
# winget install -e --id Python.Python
winget install -s winget -e --id RProject.R
# winget install -s winget -e --id RProject.Rtools
# winget install -s winget-e --id OpenJS.NodeJS.LTS
winget install -s winget -e --id RStudio.RStudio.OpenSource
winget install -s winget -e --id Kitware.CMake

# development
winget install -s winget -e --id GitHub.GitHubDesktop
winget install -s winget -e --id WinSCP.WinSCP
winget install -s winget -e --id Microsoft.VisualStudioCode
winget install -s winget -e --id ScooterSoftware.BeyondCompare4
winget install -s winget -e --id JetBrains.Toolbox
winget install -s winget -e --id Clement.bottom
# winget install -e --id WinFsp.WinFsp
# winget install -e --id SSHFS-Win.SSHFS-Win
# \\sshfs\REMUSER@HOST[\PATH]

# winget install -e --id Docker.DockerDesktop
# winget install -e --id VMware.WorkstationPlayer
# winget install -s winget -e --id Canonical.Multipass

# utils
winget install -s winget -e --id voidtools.Everything
winget install -s winget -e --id Bandisoft.Bandizip
winget install -s msstore Rufus # need v3.18 or higher
winget install -s winget -e --id QL-Win.QuickLook
winget install -s winget -e --id AntibodySoftware.WizTree
winget install -s winget -e --id HandBrake.HandBrake
# winget install -s winget -e --id Microsoft.PowerToys
winget install -s winget -e --id qBittorrent.qBittorrent
winget install -s winget -e --id IrfanSkiljan.IrfanView

# apps
winget install -s winget -e --id Mozilla.Firefox
winget install -s winget -e --id Tencent.WeChat
winget install -s winget -e --id Tencent.TencentMeeting
winget install -s winget -e --id Tencent.QQ
winget install -s winget -e --id NetEase.CloudMusic
winget install -s winget -e --id Youdao.YoudaoDict
winget install -s winget -e --id Baidu.BaiduNetdisk
winget install -s winget -e --id stax76.mpvdotnet
winget install -s winget -e --id Zotero.Zotero

# winget install -e --id Adobe.AdobeAcrobatReaderDC
# winget install -e --id Alibaba.DingTalk

```

## Optional: Windows 7 games

<https://winaero.com/download.php?view.1836>

## Optional: Packages Managements

* [`scoop.md`](setup/scoop.md)
* [`msys2.md`](setup/msys2.md)

## Optional: Rust and C/C++

## Optional: sysinternals

## Optional: QuickLook Plugins

## Directory Organization

* [`packer/`](packer/): Scripts for building a Windows 10 box for Parallels.

* [`setup/`](setup/): Scripts for setting-up Windows.
