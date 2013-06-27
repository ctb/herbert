#! /bin/bash
for k in {21..51..2}
do
echo "velveth v.$k $k -shortPaired combined-trim.fq.pe -short combined-trim.fq.se -fastq s1_se && velvetg v.$k -exp_cov auto"
done
