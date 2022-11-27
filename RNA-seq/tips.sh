#!/usr/bin/bash
# 对下载的fasta文件进行第一行描述信息的精简
cat 111.fa | perl -n -e '
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






 cat rn6.fa | perl -n -e 'if(m/^>(\S+)(\s+).*/){print ">$1\n";}else{print}' > rn6bak.fa






 $ for i in $(ls *.fastq.gz);
do
    # --minimum-length 如果剔除接头后read长度低于30，这条read将会被丢弃
    # --overlap        如果两端的序列与接头有4个碱基的匹配将会被剔除
    # --trim-n         剔除两端的N
    cutadapt -a AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT --minimum-length 30 --overlap 4 --trim-n  -o ../output/adapter/${i}  ${i}
done

cutadapt -a AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT --minimum-length 30 --overlap 4 --trim-n  -o ../output/adapter/  
parallel -j 4 " cutadapt -a AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT --minimum-length 30 --overlap 4 --trim-n  -o ../output/adapter/{1} {1}" ::: $(ls *.gz)

$ parallel -j 4 "java -jar ~/biosoft/Trimmomatic-0.38/trimmomatic-0.38.jar SE -phred33 {1} ../trim/{1} LEADING:20 TRAILING:20 SLIDINGWINDOW:5:15 MINLEN:30 " ::: $( ls *.gz)