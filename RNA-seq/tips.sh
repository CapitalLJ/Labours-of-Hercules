#!/usr/bin/bash
# 对下载的fasta文件进行第一行描述信息的精简
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







 cat rn6.fa | perl -n -e 'if(m/^>(\S+)(\s+).*/){print ">$1\n";}else{print}' > rn6bak.fa