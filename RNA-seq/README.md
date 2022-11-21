### 1、前期准备
##### 在进行数据处理之前，规划好数据的位置与分析流程，进行文件夹的创建。在这里问我们将文件夹存放在nas上，如果硬盘存储空间足够不建议这样做。

```bash
# 首先将nas上的文件挂载到终端，此处权限设置都设置为0777，也可根据自己需求更改。
sudo mount -o username=Leilingjie,password=*********,dir_mode=0777,file_mode=0777 //114.212.160.236/backup/Leilingjie /mnt/nasLeilingjie/

#新建文件夹来存放整个项目
cd /mnt/nas/nasLeilingjie
mkdir rat_RNASEQ_test

#新建不同文件夹来存放不同类型的文件
cd rat_RNASEQ_test
mkdir annotation genome sequence output script
```

| 文件夹名 | 说明 |
| ---| --- |
| annotation | 存放注释文件(.gff .bed .gff3) |
| genome | 存放基因组与索引文件(.fa .bt)|
| sequence | 存放测序数据(.fastq.gz) |
| output | 存放各种处理的输出文件 |
| script | 存放脚本的位置 |

```bash
#tree命令查看文件结构
tree

.
|-- annotation
|-- genome
|-- output
|-- script
`-- sequence
```

### 2、数据下载
#### 这里使用大鼠的测序数据作为测试。大鼠又叫大白鼠（Rat，Rattus norvegicus），是非常重要的模式生物之一，因为其与人类之间存在高度的同源性、优良的品系资源，被广泛应用于毒理学、神经病学，细胞培养等研究中。在`ENSEMBL`和`UCSC`中均有其基因组数据。

### 2.1 参考基因组

```bash
#将大鼠的基因组序列下载到genome文件中
cd /mnt/nasLeilingjie/rat_RNASEQ_test/genome/
wget http://ftp.ensembl.org/pub/release-104/fasta/rattus_norvegicus/dna/Rattus_norvegicus.Rnor_6.0.dna.toplevel.fa.gz
gzip -d Rattus_norvegicus.Rnor_6.0.dna.toplevel.fa.gz
#解压缩后改名方便后续操作
mv Rattus_norvegicus.Rnor_6.0.dna.toplevel.fa rn6.fa
```
我们可以使用'grep'命令来选择性查看fa文件的相关信息。

```bash
cat rn6.fa | grep "^>"
#也可以比较一下  cat rn6.fa | grep ">"与上述命令看谁更快。
#输出结果：
>1 dna:chromosome chromosome:Rnor_6.0:1:1:282763074:1 REF
>2 dna:chromosome chromosome:Rnor_6.0:2:1:266435125:1 REF
>3 dna:chromosome chromosome:Rnor_6.0:3:1:177699992:1 REF
>4 dna:chromosome chromosome:Rnor_6.0:4:1:184226339:1 REF
>5 dna:chromosome chromosome:Rnor_6.0:5:1:173707219:1 REF
>6 dna:chromosome chromosome:Rnor_6.0:6:1:147991367:1 REF
>7 dna:chromosome chromosome:Rnor_6.0:7:1:145729302:1 REF
>8 dna:chromosome chromosome:Rnor_6.0:8:1:133307652:1 REF
>9 dna:chromosome chromosome:Rnor_6.0:9:1:122095297:1 REF
>10 dna:chromosome chromosome:Rnor_6.0:10:1:112626471:1 REF
>11 dna:chromosome chromosome:Rnor_6.0:11:1:90463843:1 REF
>12 dna:chromosome chromosome:Rnor_6.0:12:1:52716770:1 REF
>13 dna:chromosome chromosome:Rnor_6.0:13:1:114033958:1 REF
>14 dna:chromosome chromosome:Rnor_6.0:14:1:115493446:1 REF
>15 dna:chromosome chromosome:Rnor_6.0:15:1:111246239:1 REF
>16 dna:chromosome chromosome:Rnor_6.0:16:1:90668790:1 REF
>17 dna:chromosome chromosome:Rnor_6.0:17:1:90843779:1 REF
>18 dna:chromosome chromosome:Rnor_6.0:18:1:88201929:1 REF
>19 dna:chromosome chromosome:Rnor_6.0:19:1:62275575:1 REF
>20 dna:chromosome chromosome:Rnor_6.0:20:1:56205956:1 REF
>X dna:chromosome chromosome:Rnor_6.0:X:1:159970021:1 REF
>Y dna:chromosome chromosome:Rnor_6.0:Y:1:3310458:1 REF
>MT dna:chromosome chromosome:Rnor_6.0:MT:1:16313:1 REF
>KL568162.1 dna:scaffold scaffold:Rnor_6.0:KL568162.1:1:10937627:1 REF
>KL568139.1 dna:scaffold scaffold:Rnor_6.0:KL568139.1:1:9752924:1 REF
>KL568161.1 dna:scaffold scaffold:Rnor_6.0:KL568161.1:1:7627431:1 REF
>KL568148.1 dna:scaffold scaffold:Rnor_6.0:KL568148.1:1:6483517:1 REF
>KL568157.1 dna:scaffold scaffold:Rnor_6.0:KL568157.1:1:5447879:1 REF
>KL568160.1 dna:scaffold scaffold:Rnor_6.0:KL568160.1:1:4317250:1 REF
>KL568151.1 dna:scaffold scaffold:Rnor_6.0:KL568151.1:1:3931032:1 REF
>KL568149.1 dna:scaffold scaffold:Rnor_6.0:KL568149.1:1:3292674:1 REF
>KL568141.1 dna:scaffold scaffold:Rnor_6.0:KL568141.1:1:2733323:1 REF
>KL568156.1 dna:scaffold scaffold:Rnor_6.0:KL568156.1:1:2193381:1 REF
>KL568159.1 dna:scaffold scaffold:Rnor_6.0:KL568159.1:1:1977169:1 REF
.....................
```
将这里看到每一条染色体的名称后面还跟了一些描述信息，这些描述信息就是当前组装版本，长度等等信息，但是这个信息会妨碍后面写脚本统计或者一些分析，所以这里最好去掉。

```bash
cat rn6.fa | perl -n -e 'if(m/^>(\S+)(\s+).*/){print ">$1\n";}else{print}' > rn6bak.fa
mv -i rn6bak.fa rn6.fa
# -i 若更名的文件已存在，系统会提问是否将原有的rn6.fa文件覆盖。
```
统计一下每一条染色体的长度
```bash
cat rn6.fa | perl -n -e '
s/\r?\n//;
    if(m/^>(.+?)\s*$/){
        $title = $1;
        push @t, $title;
    }elsif(defined $title){
        $title_len{$title} += length($_);
     }
    END{
        for my $title (@t){
        print "$title","\t","$title_len{$title}","\n";
        }
    }
'
#这里如果有两个read的名称一样会将两个的长度叠加，不过read名称相同本身好像就有点奇怪。
```
这里直接选用其中一条来进行后续的比对，节省时间。

```bash
# faops one rn6.fa 1 rn6.chr1.fa  直接使用faops

cat rn6.fa | perl -n -e '
  if(m/^>/){
    if(m/>1$/){
      $title = 1;
    }else{
      $title = 0;
    }
  }else{
    push @s, $_ if $title;
  }
  END{
    printf ">1\n%s", join("", @s);
  }
' > rn6.chr1.fa
```
### 2.2 下载注释文件

```bash
cd /mnt/nasLeilingjie/rat_RNASEQ_test/annotation
wget 