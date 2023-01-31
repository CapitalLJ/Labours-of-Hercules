
#### 实验数据和参考数据下载

实验数据下载

```bash


mkdir -p $HOME/NBT_repeat/data/seq_data/WT_mESC_rep1
mkdir -p $HOME/NBT_repeat/data/seq_data/TetTKO_mESC_rep1
cd $HOME/NBT_repeat/data/seq_data/

aria2c -d ./WT_mESC_rep1/ -Z ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR736/001/SRR7368841/SRR7368841.fastq.gz \
    ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR736/002/SRR7368842/SRR7368842.fastq.gz
aria2c -d ./TetTKO_mESC_rep1/ -Z ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR736/005/SRR7368845/SRR7368845.fastq.gz


```

参考基因组下载：
```bash
mkdir -p $HOME/NBT_repeat/data/genome_data/
cd $HOME/NBT_repeat/data/genome_data/

# Basic command line download
aria2c -d ./ -Z ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.1.fa.gz ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.2.fa.gz ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.3.fa.gz ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.4.fa.gz
aria2c -d ./ -Z ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.5.fa.gz ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.6.fa.gz ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.7.fa.gz ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.8.fa.gz
aria2c -d ./ -Z ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.9.fa.gz ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.10.fa.gz ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.11.fa.gz ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.12.fa.gz
aria2c -d ./ -Z ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.13.fa.gz ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.14.fa.gz ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.15.fa.gz ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.16.fa.gz
aria2c -d ./ -Z ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.17.fa.gz ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.18.fa.gz ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.19.fa.gz ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.X.fa.gz ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.Y.fa.gz 
```

利用fastqc查看测序文件质量
```bash

cd $HOME/NBT_repeat/data/seq_data/

# quality control to see the quality of the raw seq-data
fastqc --threads 3 ./WT_mESC_rep1/*.fastq.gz ./TetTKO_mESC_rep1/*.fastq.gz

# -t/--threads <int>: Specifies the number of files which can be processed simultaneously.

```
利用Trim Galore去接头以及剔除测序质量差的碱基

```bash
# quality and adapter trimming, followd by fastqc operation
trim_galore -o ./WT_mESC_rep1/trimmed_data/ --fastqc ./WT_mESC_rep1/*.fastq.gz
trim_galore -o ./TetTKO_mESC_rep1/trimmed_data/ --fastqc ./TetTKO_mESC_rep1/*.fastq.gz

# -o/--output_dir <DIR>: 质控后输出文件目录
# --fastqc:修剪完后运行fastqc查看结果

```