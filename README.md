# Labours-of-Hercules
学习生物信息的过程
### 命令行

学会用命令行的方式来对windows以及linux做出一些指令。

- 命令行一般由 `命令`、`参数`、`输入文件`、`输出文件`组成，有些部分在某些条件下可省略。

  一般来说对于一个命令我们可以通过help来快速地了解他。

  ```bash
  $ mkdir --help
  Usage: mkdir [OPTION]... DIRECTORY...
  Create the DIRECTORY(ies), if they do not already exist.
  
  Mandatory arguments to long options are mandatory for short options too.
    -m, --mode=MODE   set file mode (as in chmod), not a=rwx - umask
    -p, --parents     no error if existing, make parent directories as needed
    -v, --verbose     print a message for each created directory
    -Z                   set SELinux security context of each created directory
                           to the default type
        --context[=CTX]  like -Z, or if CTX is specified then set the SELinux
                           or SMACK security context to CTX
        --help     display this help and exit
        --version  output version information and exit
  
  GNU coreutils online help: <https://www.gnu.org/software/coreutils/>
  Report mkdir translation bugs to <https://translationproject.org/team/>
  Full documentation at: <https://www.gnu.org/software/coreutils/mkdir>
  or available locally via: info '(coreutils) mkdir invocation'
  #快速地帮助我们掌握一个命令
  ```

  

- 命令行可以同时执行多条命令 ，用`|`分隔即可，但必须保证所有的命令都是正确的。

  ```bash
  llj@LAPTOP-VVN6JKK4:~$ ls | cd tmp
  #-bash: cd: tmp: No such file or directory
  ```

- 熟练利用命令行有时比图形操作界面更加便捷。

- 尽可能详细地记录操作过程，当作实验记录保存下来。
