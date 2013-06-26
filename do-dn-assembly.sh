#! /bin/bash
for k in {21..51..2}
do
echo "velveth dn.$k $k -shortPaired combined-trim.fq.pe.keep.abundfilt.pe.keep -short combined-trim.fq.pe.keep.abundfilt.se.keep combined-trim.fq.se.keep.abundfilt.keep s1_se.filt.keep.abundfilt.keep && velvetg dn.$k -exp_cov auto"
done
