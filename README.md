# GBS-Pcinnamomi

Phytophthora cinnamomi is pathogen on forest trees, shrubs and trees. ..........


barcode_file.csv : convert to .txt file to be used by sabre.
 
#delete header lines (in my case first two and grep 3 and 4th column that has barcode and sample names). Rename the file.
sed '1,2d' GBS0162_Grunwald_Keyfile.txt | cut -f 3-4 > GBS0162_sabre_barcode.txt

## Start demultiplexing

sample barcode.txt

TGACGCCA        S-93-Clack-OR-USA
CAGATA  21-S152-S2-1-Portugal
GAAGTG  38-S289-R5C-Portugal
TAGCGGAT        27-S193-S7A-Portugal
TATTCGCAT       112-TW97-YilanCo-NE-Taiwan
ATAGAT  125-TW178-SPen-Taiwan
CCGAACA 33-S244S1B-Portugal


# sabre se -f ../lane6-s005-index----GBS0162_S5_L006_R1_001.fastq.gz -b GBS0162_sabre_barcode.txt -u unknown_barcode.fq
