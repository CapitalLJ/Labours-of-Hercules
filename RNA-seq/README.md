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
if(m/^>(.+)/){
    $title =$1;
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
wget http://ftp.ensembl.org/pub/release-104/gff3/rattus_norvegicus/Rattus_norvegicus.Rnor_6.0.104.gff3.gz
gzip -d Rattus_norvegicus.Rnor_6.0.104.gff3.gz
mv Rattus_norvegicus.Rnor_6.0.104.gff3 rn6.gff3
#下载注释文件gff3解压缩改名


wget http://ftp.ensembl.org/pub/release-104/gtf/rattus_norvegicus/Rattus_norvegicus.Rnor_6.0.104.gtf.gz
gzip -d Rattus_norvegicus.Rnor_6.0.104.gtf.gz
mv Rattus_norvegicus.Rnor_6.0.104.gtf rn6.gtf
#下载注释文件gtf解压缩改名
```

### 2.2 下载实验数据(测序文件)
为了进行演示，从NCBI上查找相关的`RNA-seq`数据进行下载，在GEO数据库中找了一个数据`GSE72960`，对应的SRP数据为`SRP063345`，对应的文献是：

[肝硬化分子肝癌的器官转录组分析和溶血磷脂酸途径抑制 - 《Molecular Liver Cancer Prevention in Cirrhosis by Organ Transcriptome Analysis and Lysophosphatidic Acid Pathway Inhibition》](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5161110/)

+ 首先进入站点[NCBI - GEO](https://www.ncbi.nlm.nih.gov/geo)，然后在搜索框中输入`GSE72960`，之后在下方出现了这个基因表达数据集的描述信息，比如样本提交日期，样本文献来源，数据提交人的信息，样本测序样本数量，对应的编号等等。

![](./pic/GEO.png)

+ 我们直接点击最下面的`SRA Run selector`这个里面包含了这8个测序样本的测序信息以及文件`SRA编号`，通过这个编号就可以下载测序数据。

```bash
cd /mnt/nasLeilingjie/rat_RNASEQ_test/sequence
prefetch SRR2190795 SRR224018{2..7} SRR2240228
#将下载好的sra文件放在sequence文件中
```

下载的文件属于.sra格式，我们需要将其转化为fastq格式的文件，这里还是使用`SRAtoolkit`工具包，但是是里面的`fastq-dump`工具，使用它来进行格式转化


```bash
cd /mnt/nasLeilingjie/rat_RNASEQ_test/sequence
ls *.sra | parallel -j 4 " fastq-dump --split-3 --gzip"
#将sra文件转化为fastq.gz后删除sra文件

rm *.sra
```

### 3、测序文件质量控制

### 3.1 质量评估
拿到测序数据文件，在序列比对之前需要对测序文件的测序质量进行查看，因为不同测序数据来源测序质量也不一样，为了保证后续分析的有效性和可靠性，需要对质量进行评估，如果数据很差那么在后续分析的时候就需要注意了。这里使用fastqc进行质量评估。

```bash
# fastqc [选项] [测序文件]

cd /mnt/nasLeilingjie/rat_RNASEQ_test/sequence

mkdir -p ../output/fastqc
# -t 指定线程数
# -o 指定输出文件夹

fastqc -t 6 -o ../output/fastqc
```
这里的.html用浏览器打开，查看一下情况，可以看到这个测序质量不是特别好，这里有一篇文章写的可以[用FastQC检查二代测序原始数据的质量](https://www.plob.org/article/5987.html)

> 绿色表示通过，红色表示未通过，黄色表示不太好。一般而言RNA-Seq数据在sequence deplication levels 未通过是比较正常的。毕竟一个基因会大量表达，会测到很多遍。
这里因为有多份报告，有时候查看不是特别方便，这里有一个将所有的fastqc的检测报告合并到一个文件上的程序`multiqc`

```bash
cd /mnt/nasLeilingjie/rat_RNASEQ_test/output/fastqc
multiqc .
```
### 3.2 剔除接头以及测序质量差的碱基

从fastq结果可以看到，在接头那里是显示的通过，但是可以看到有部分是有4个碱基与接头序列匹配的，属于Illumina的通用接头。另外也可以看到，除了可能存在接头的情况，在测序质量那里也可以看到在5'端存在低质量的测序区域，所以像两端这种低质量的区域也是要去除的的，这一步采用trimmomatic进行。

```bash
cd /mnt/nasLeilingjie/rat_RNASEQ_test/output
mkdir -p adapter
#新建文件夹来存放处理后的文件

cd ../sequence
parallel -j 4 " cutadapt -a AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT --minimum-length 30 --overlap 4 --trim-n  -o ../output/adapter/{1} {1}" ::: $(ls *.gz)
# --minimum-length 如果剔除接头后read长度低于30，这条read将会被丢弃
# --overlap        如果两端的序列与接头有4个碱基的匹配将会被剔除
# --trim-n         剔除两端的N
```

### 3.3 再次去除低质量区域

```bash
cd /mnt/nasLeilingjie/rat_RNASEQ_test/output
mkdir trim
cd adapter
parallel -j 4 "java -jar ~/biosoft/Trimmomatic-0.38/trimmomatic-0.38.jar SE -phred33 {1} ../trim/{1} LEADING:20 TRAILING:20 SLIDINGWINDOW:5:15 MINLEN:30 " ::: $( ls *.gz)
# LEADING:20，从序列的开头开始去掉质量值小于 20 的碱基
# TRAILING:20，从序列的末尾开始去掉质量值小于 20 的碱基
# SLIDINGWINDOW:5:15，从 5' 端开始以 5bp 的窗口计算碱基平均质量，如果此平均值低于 15，则从这个位置截断read
# MINLEN:36， 如果 reads 长度小于 30bp 则扔掉整条 read。
```
### 3.4 再次查看质量情况

```bash
cd /mnt/nasLeilingjie/rat_RNASEQ_test/output/trim

mkdir ../fastqc-trim
parallel -j 7 "
fastqc -t 4 -o ../fastqc_trim {1}
" ::: $(ls *.gz)

cd ../fastqc_trim
multiqc .

```
对比接头去除前的情况，可以发现结果明显变好。

### 4 序列比对
### 4.1 建立索引

这一步使用`hisat2`中的工具`hisat2-build`建立索引。






