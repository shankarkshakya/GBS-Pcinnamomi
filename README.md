# GBS-Pcinnamomi

Phytophthora cinnamomi is pathogen on forest trees, shrubs and trees. ..........




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

sabre se -f ../lane6-s005-index----GBS0162_S5_L006_R1_001.fastq.gz -b GBS0162_sabre_barcode.txt -u unknown_barcode.fq


# Mapping reads using bowtie2 and processing

bowtie2 --local -x $REF -U ${fq[$i]} --rg-id ${fq[$i]} --rg PU:ill --rg SM:${fq[$i]} --rg PL:Illumina -S ${fq[$i]}.sam

convert sam to bam: samtools view -bS ${sam[$i]} > ${sam[$i]}.bam

sort bam:samtools sort ${bam[$i]} -o ${bam[$i]}.sorted

index bam:samtools index ${bam[$i]}

remove duplicates: samtools rmdup ${sam[$i]} ${sam[$i]}.rmdup.bam


# Variant Calling using GATK Haplotype caller





# Create a txt file with path to list of bam files to be used by GATK

bash
 
for i in `ls *.bam`; do echo "`pwd`/$i"; done > bam.list

ls | awk '{system("readlink -f " $1)}' > bam.list

readlink -f *.bam > bam.list

