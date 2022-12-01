## Classifying Plasmids

### NCBI RefSeq

<!-- NCBI的参考序列（RefSeq）计划，为多种生物提供序列的数据信息及相关资料，用于医学、基因功能和基因功能比较研究。RefSeq数据库中所有的数据是一个非冗余的、提供参考标准的数据，包括染色体、基因组（细胞器、病毒、质粒）、蛋白、RNA等。 -->

```bash
mkdir -p ~/data/plasmid
cd ~/data/plasmid

rsync -avP ftp.ncbi.nlm.nih.gov::refseq/release/plasmid/ RefSeq/

# rsync 一种快速、多功能、远程（和本地）文件复制工具.它能同步更新两处计算机的文件与目录，并适当利用差分编码以减少数据传输量。rsync可以拷贝／显示目录内容，以及拷贝文件，并可选压缩以及递归拷贝。可用来进行整个目录的传输。

# -r表示递归、-a参数可以替代-r，除了可以递归同步以外，还可以同步元信息（比如修改时间、权限等）。
# -P参数是--progress和--partial这两个参数的结合。--partial参数允许恢复中断的传输。不使用该参数时，rsync会删除传输到一半被打断的文件；使用该参数后，传输到一半的文件也会同步到目标目录，下次同步时再恢复中断的传输。一般需要与--append或--append-verify配合使用。
# -v参数表示输出细节。-vv表示输出更详细的信息，-vvv表示输出最详细的信息。
[look here](https://www.ruanyifeng.com/blog/2020/08/rsync.html)

gzip -dcf RefSeq/*.genomic.gbff.gz > genomic.gbff
perl ~/Scripts/withncbi/taxon/gb_taxon_locus.pl genomic.gbff > refseq_id_seq.csv
rm genomic.gbff

gzip -dcf RefSeq/plasmid.1.1.genomic.fna.gz |
    grep "^>" |
    head -n 5