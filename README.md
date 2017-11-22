# GBS-Pcinnamomi

Phytophthora cinnamomi is an important plant pathogen of forest trees, agricultural crops and horticulture plants. P. cinnamomi is root limited oomycete and is resposible for root rot of avocado in US, jarrah die back in Australia. Because P. cinnamomi is limited to soil and roots, the movement of pathogen happens primarily due to the trade of plants.

# Demultiplexing

We will need two things a barcode file in .txt format and raw fastq file. Sabre allows one to demultiplex for SE and PE reads. Before using Sabre barcode file needs to be slightly modified.

convert .csv barcode file to .txt file.
delete header lines (in my case first two and grep 3 and 4th column that has barcode and sample names). Rename the file.
sed '1,2d' GBS0162_Grunwald_Keyfile.txt | cut -f 3-4 > GBS0162_sabre_barcode.txt

sample barcode.txt

TGACGCCA        S-93-Clack-OR-USA
CAGATA  21-S152-S2-1-Portugal
GAAGTG  38-S289-R5C-Portugal
TAGCGGAT        27-S193-S7A-Portugal
TATTCGCAT       112-TW97-YilanCo-NE-Taiwan
ATAGAT  125-TW178-SPen-Taiwan
CCGAACA 33-S244S1B-Portugal

```
sabre se -f ../lane6-s005-index----GBS0162_S5_L006_R1_001.fastq.gz -b GBS0162_sabre_barcode.txt -u unknown_barcode.fq
```

# Mapping reads using bowtie2 and processing

```
bowtie2 --local -x $REF -U ${fq[$i]} --rg-id ${fq[$i]} --rg PU:ill --rg SM:${fq[$i]} --rg PL:Illumina -S ${fq[$i]}.sam

convert sam to bam: samtools view -bS ${sam[$i]} > ${sam[$i]}.bam

sort bam:samtools sort ${bam[$i]} -o ${bam[$i]}.sorted

remove duplicates: samtools rmdup ${sam[$i]} ${sam[$i]}.rmdup.bam

index bam:samtools index ${bam[$i]}

```
# Calling Variants

## Variants can be called in two different ways.

1. Use indexed bam files to call variants with GATK Haplotype caller. [https://github.com/shankarkshakya/GBS-Pcinnamomi/blob/master/gatk2_1_sge.sh]

2. Use indexed bam files to first create gvcfs (genomic vcfs) and later on merge gvcfs to create single vcf file.

Calling variants will need some sort of text file with path to list of bam files. 


```
bash
 
for i in `ls *.bam`; do echo "`pwd`/$i"; done > bam.list

ls | awk '{system("readlink -f " $1)}' > bam.list

readlink -f *.bam > bam.list

```

# Filtering variants: What is a good variant?

Variants can be filtered on many criterias like mapping quality, read depth, minor allele frequency etc.


# Population structure analysis using ADMIXTURE

First the vcf file need to be converted into plink format which can be used further by ADMIXTURE.

```
plink 
--vcf ../rawGBS/FASTQ/RMDUP_BAMS/Pcinna242.rmdup.gvcf2vcf.vcf.gz 
--allow-extra-chr 
--recode12 
--out Pcinna242.rmdup.gvcf2vcf.vcf
```

This will result into .log, .map, .nosex and .ped file.

[https://www.genetics.ucla.edu/software/admixture/admixture-manual.pdf]

```
admixture <inputfile> <K>
admixture Pcinna242.rmdup.gvcf2vcf.181ind.220Var.vcf.ped 11
```

```
for K in 12 13; 
do admixture --cv Pcinna242.rmdup.gvcf2vcf.181ind.220Var.vcf.ped $K | tee log${K}.out; 
done
```


