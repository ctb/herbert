all: combined-trim.fq s1_se.filt combined-trim.fq.pe.keep combined-trim.fq.se.keep combined-trim.fq.pe.keep.abundfilt.pe.keep combined-trim.fq.pe.keep.abundfilt.se.keep

s1_pe: SRR065390_1.fastq.gz SRR065390_2.fastq.gz
	java -jar /usr/local/bin/trimmomatic-0.27.jar PE SRR065390_1.fastq.gz SRR065390_2.fastq.gz s1_pe s1_se s2_pe s2_se ILLUMINACLIP:../illuminaClipping.fa:2:30:10

combined.fq: s1_pe s2_pe
	python /usr/local/share/khmer/sandbox/interleave.py s1_pe s2_pe > combined.fq

combined-trim.fq: combined.fq
	fastx_trimmer -Q33 -l 70 -i combined.fq | fastq_quality_filter -Q33 -q 30 -p 50 > combined-trim.fq

s1_se.filt: s1_se
	fastx_trimmer -Q33 -l 70 -i s1_se | fastq_quality_filter -Q33 -q 30 -p 50 > s1_se.filt

combined-trim.fq.pe: combined-trim.fq
	python /usr/local/share/khmer/sandbox/strip-and-split-for-assembly.py combined-trim.fq

combined-trim.fq.pe.keep: combined-trim.fq.pe
	python /usr/local/share/khmer/scripts/normalize-by-median.py -x 1.6e9 -N 4 --savehash combined-trim-dn.kh -C 20 -k 20 -p combined-trim.fq.pe

combined-trim.fq.se.keep: combined-trim.fq.se combined-trim.fq.pe.keep
	python /usr/local/share/khmer/scripts/normalize-by-median.py -x 1.6e9 -N 4 --loadhash combined-trim-dn.kh --savehash combined-trim-dn2.kh -C 20 -k 20 combined-trim.fq.se s1_se.filt

combined-trim.fq.pe.keep.abundfilt: combined-trim.fq.pe.keep combined-trim.fq.se.keep
	python /usr/local/share/khmer/scripts/filter-abund.py -C 2 combined-trim-dn2.kh combined-trim.fq.pe.keep combined-trim.fq.se.keep s1_se.filt.keep

combined-trim.fq.pe.keep.abundfilt.pe: combined-trim.fq.pe.keep.abundfilt
	python /usr/local/share/khmer/sandbox/strip-and-split-for-assembly.py combined-trim.fq.pe.keep.abundfilt

combined-trim.fq.pe.keep.abundfilt.pe.keep: combined-trim.fq.pe.keep.abundfilt.pe
	python /usr/local/share/khmer/scripts/normalize-by-median.py -x 1.6e9 -N 4 --savehash dn5.kh -C 5 -k 20 -p combined-trim.fq.pe.keep.abundfilt.pe

combined-trim.fq.pe.keep.abundfilt.se.keep: combined-trim.fq.pe.keep.abundfilt.pe.keep
	python /usr/local/share/khmer/scripts/normalize-by-median.py -x 1.6e9 -N 4 --loadhash dn5.kh --savehash dn5-round2.kh -C 5 -k 20 combined-trim.fq.pe.keep.abundfilt.se combined-trim.fq.se.keep.abundfilt s1_se.filt.keep.abundfilt
