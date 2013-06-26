#! /bin/bash
for k in {21..51..2}
do
echo "velveth dn.$k $k -shortPaired combined-trim.fq.pe -short combined-trim.fq.se s1_se && velvetg dn.$k -exp_cov auto"
done
