## Classifying Plasmids

### NCBI RefSeq

<!-- NCBI的参考序列（RefSeq）计划，为多种生物提供序列的数据信息及相关资料，用于医学、基因功能和基因功能比较研究。RefSeq数据库中所有的数据是一个非冗余的、提供参考标准的数据，包括染色体、基因组（细胞器、病毒、质粒）、蛋白、RNA等。 -->

fna （fasta nucleic acid file）所有核酸序列信息\
ffn （fasta nucleotide coding regions file）所有基因的核酸序列信息\
faa （fasta Amino Acid file） 即所有基因对应的蛋白质序列信息

```bash
mkdir -p ~/data/plasmid
cd ~/data/plasmid

rsync -avP ftp.ncbi.nlm.nih.gov::refseq/release/plasmid/ RefSeq/

# rsync 一种快速、多功能、远程（和本地）文件复制工具.它能同步更新两处计算机的文件与目录，并适当利用差分编码以减少数据传输量。rsync可以拷贝／显示目录内容，以及拷贝文件，并可选压缩以及递归拷贝。可用来进行整个目录的传输。

# -r表示递归、-a参数可以替代-r，除了可以递归同步以外，还可以同步元信息（比如修改时间、权限等）。
# -P参数是--progress和--partial这两个参数的结合。--partial参数允许恢复中断的传输。不使用该参数时，rsync会删除传输到一半被打断的文件；使用该参数后，传输到一半的文件也会同步到目标目录，下次同步时再恢复中断的传输。一般需要与--append或--append-verify配合使用。
# -v参数表示输出细节。-vv表示输出更详细的信息，-vvv表示输出最详细的信息。
[look here]<https://www.ruanyifeng.com/blog/2020/08/rsync.html>

gzip -dcf RefSeq/*.genomic.gbff.gz > genomic.gbff
#gbff文件儲存了基因的基因信息，特徵注釋信息和序列信息。

# -c 标准输出 -f force 强制执行
perl ~/Scripts/withncbi/taxon/gb_taxon_locus.pl genomic.gbff > refseq_id_seq.csv
rm genomic.gbff
# 将所有的gbff文件提取出来整合到一个文件里面。

gzip -dcf RefSeq/plasmid.1.1.genomic.fna.gz |
    grep "^>" |
    head -n 5

faops n50 -S -C RefSeq/*.genomic.fna.gz
gzip -dcf RefSeq/*.genomic.fna.gz > RefSeq/plasmid.fa
#将所有的fna文件整合成一个fa文件。
```

### MinHash to get non-redundant plasmid
此部分的思路为将收集到的所有质粒的序列整合到一个fa文件中，按照他们序列的大小进行第一步筛选，除去长度小于2000的序列；在利用mash对长度大于2000的序列进行分析。计算它们的遗传距离，将遗传距离大于0.01的都保留，遗传距离小于0.01的保留其中一个就行。最终得到非冗余质粒序列集合文件refseq.nr.fa


```bash
mkdir ~/data/plasmid/nr
cd ~/data/plasmid/nr

faops size ../RefSeq/plasmid.fa > refseq.sizes
#Non-Redundant 非冗余基因
# 将整合后的fa文件的每个序列的大小统计出来并存放到sizes文件里

head -n 20 refseq.sizes 
# NZ_D13972.1     4809
# NZ_L25424.1     2345
# NZ_Y18549.1     471
# NZ_M10917.1     2955
# NZ_U40997.1     3712


tsv-filter refseq.sizes --le 2:2000 | wc -l
#查看一下大小小于2000的序列数
faops some ../RefSeq/plasmid.fa <(tsv-filter refseq.sizes --gt 2:2000) refseq.fa
# < 定向输出，将(tsv-filter refseq.sizes --gt 2:2000)的结果输出到stdout，
# 将整合的fa文件中的序列大于2000的提取出来并保存到refseq.fa文件中

cat refseq.fa | mash sketch -k 21 -s 1000 -i -p 8 - -o refseq.plasmid.k21s1000.msh

# mash ——— fast genome and metagenome distance estimation using MinHash使用 MinHash 快速估计基因组和宏基因组距离

# mash sketch 

# Create a sketch file, which is a reduced representation of a sequence or set
# of sequences (based on min-hashes) that can be used for fast distance
# estimations. Inputs can be fasta or fastq files (gzipped or not), and "-" can
# be given to read from standard input. Input files can also be files of file
# names (see -l). For output, one sketch file will be generated, but it can have
# multiple sketches within it, divided by sequences or files (see -i). By
# default, the output file name will be the first input file with a '.msh'
# extension, or 'stdin.msh' if standard input is used (see -o).
# 创建草图文件，它是序列或集合的简化表示可用于快速距离估计的序列（基于最小哈希）。 输入可以是 fasta 或 fastq 文件（压缩或未压缩），可以给出“-”以从标准输入读取。 输入文件也可以是文件名文件（见-l）。 对于输出，将生成一个草图文件，但其中可以包含多个草图，按序列或文件划分（请参阅 -i）。 默认情况下，输出文件名将是第一个带有“.msh”的输入文件扩展名，如果使用标准输入，则为“stdin.msh”（请参阅 -o）。

# -k K-mer 大小。 哈希将基于这么多核苷酸的字符串。 默认情况下使用规范核苷酸。(1-32)[21]
# -s 草图尺寸。 每个草图最多会有这么多非冗余的最小哈希值。 [1000]
# -i 绘制单个序列，而不是整个文件，例如 用于单染色体基因组的多 fastas 或成对基因比较。
# -p parallel 
# - 表示从标准输入读取

mkdir -p job
faops size refseq.fa | cut -f 1 | split -l 1000 -a 3 -d - job/

# 将大于2000的序列名称提取出来并且按照1000行为一个标准分割成多个文件

# split 
# -a 3 生成长度为3的后缀（默认为2）。
# -d 使用从0开始的数字后缀，而不是字母
# -l 每个文件输出的行数
# - 从标准输入读取

find job -maxdepth 1 -type f -name "[0-9]??" | sort |
    parallel -j 4 --line-buffer '
        echo >&2 "==> {}"
        faops some refseq.fa {} stdout |
            mash sketch -k 21 -s 1000 -i -p 6 - -o {}.msh
'
# 从分割的文件中按照名称提取出来，每一个设置一个mash草图

# -maxdepth 1 
# -maxdepth 0 表示仅将测试和操作应用于起点本身。1表示下一级。
# -type f 类型为普通文件 -name 按名称查找 
```
```bash
find job -maxdepth 1 -type -f -name "[0-9]??" | sort |
    parallel -j 4 --line-buffer '
    echo >&2 "==> {}"
    mash dist -p 6 {}.msh refseq.plasmid.k21s1000.msh > {}.tsv
    '

# mash dist 
# 估计每个查询序列到参考的距离。 参考和查询都可以是 fasta 或 fastq，压缩或不压缩，或具有匹配 k-mer 大小的 Mash sketch 文件 (.msh)。 查询文件也可以是文件名的文件（见-l）。 默认比较整个文件
# 输出的tsv文件数据含义[参考 ID、查询 ID、距离、p 值、共享哈希]。
```

```bash
find job -maxdepth 1 -type f -name "[0-9]??" | sort |
    parallel -j 16 '
        cat {}.tsv |
            tsv-filter --ff-str-ne 1:2 --le 3:0.01
    ' \
    > redundant.tsv
# --ff-str-ne 字段与字段的比较，第一列为参考ID、第二列为查询ID；参考ID与查询ID不相等，第三列为距离小于0.01.

```

```bash
cat redundant.tsv |
    perl -nla -F"\t" -MGraph::Undirected -e '
        BEGIN {
            our $g = Graph::Undirected->new;
        }

        $g->add_edge($F[0], $F[1]);

        END {
            for my $cc ( $g->connected_components ) {
                print join qq{\t}, sort @{$cc};
            }
        }
    ' \
    > connected_components.tsv

# 此步为将遗传距离小于0.01的序列ID提取出来
```

```bash
cat connected_components.tsv | perl -nla -F"\t" -e 'printf qq{%s\n}, $_ for @F' > components.list
# 将提取出的序列ID转化为列表文件，方便后续的提取


faops some -i refseq.fa components.list stdout > refseq.nr.fa
# 提取序列大于2000的refseq.fa文件中遗传距离大于0.01的序列
faops some refseq.fa <(cut -f 1 connected_components.tsv) stdout >> refseq.nr.fa
# 提取序列大于2000的refseq.fa文件中遗传距离小于0.01的序列中的第一个
```

### Grouping by MinHash

```bash

mkdir ~/data/plasmid/grouping
cd ~/data/plasmid/grouping

cat ../nr/refseq.nr.fa | mash sketch -k 21 -s 1000 -i -p 8 - -o refseq.nr.k21s1000.msh

mkdir -p job
faops size ../nr/refseq.nr.fa |  cut -f 1 | split -l 1000 -a 3 -d - job/
#将非冗余序列ID分割1000行大小的多个文件。

find job -maxdepth 1 -type f -name "[0-9]??" | sort | 
parallel -j 4 --line-buffer'
echo >&2 "==> {}"
faops some ../nr/refseq.nr.fa {} stdout | mash sketch -k 21 -s 1000 -i -p 6 - -o {}.msh
'
#将分割后的文件分别建立草图下一步与总的草图进行比对。

find job -maxdepth 1 -type f -name "[0-9]??" | sort | 
parallel -j 4 --line-buffer '
echo >&2 "==> {}"
mash dist -p 6 {}.msh refseq.nr.k21s1000.msh > {}.tsv
' 
# 估计每个查询查询序列到参考的距离。输出的tsv文件数据含义[参考 ID、查询 ID、距离、p 值、共享哈希]。

find job -maxdepth 1 -type f -name "[0-9]??" | sort |
parallel -j 1 'cat {}.tsv' > dist_full.tsv
# 将分割后计算好距离的tsv文件汇总

cat dist_full.tsv | tsv-filter --ff-str-ne 1:2 --le 3:0.05 > connected.tsv
# 筛选出遗传距离小于0.05序列
```
```bash
mkdir -p group
cat connected.tsv | perl -nla -F"\t" -MGraph::Undirected -MPath::Tiny -e '
BEGIN {
    our $g = Graph::Undirected->new;
}
$g->add_edge($F[0], $F[1]);
END {
    my @rare;
    my $serial = 1;
    my @ccs = $g->connected_components;
    @ccs = map { $_->[0] }
        sort { $b->[1] <=> $a->[1] }
        map { [ $_, scalar( @{$_} ) ] } @ccs;
    for my $cc ( @ccs ) {
         my $count = scalar @{$cc};
         if ($count < 50) {
                    push @rare, @{$cc};
                }
                else {
                    path(qq{group/$serial.lst})->spew(map {qq{$_\n}} @{$cc});
                    $serial++;
                }
            }
            path(qq{group/00.lst})->spew(map {qq{$_\n}} @rare);

            path(qq{grouped.lst})->spew(map {qq{$_\n}} $g->vertices);
}
'

Graph::Un
faops some -i ../nr/refseq.nr.fa grouped.lst stdout | faops size stdin |
cut -f 1 > group/lonely.lst


```