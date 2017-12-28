#!/bin/bash

#infile="PITG_Supercontig_1.MT_noindels.fasta"
#infile="./multistate.data.phy"


#perl -pi -e 's/\(//g' $infile
#perl -pi -e 's/\)//g' $infile


# -T number of threads
# -n name of output file
# -s name of alignment file in PHYLIP or FASTA format
# -q name of partition file
# -p random number seed for parsimony inferences
# -x random seed and turn on rapid bootstrapping
# -N 
# -c Number of distinct rate categories, default = 25
# -f a select rapid bootstrap algorithm
# -m GTRCAT select model
# -m GTRGAMMA select model


#CMD="/home/local/USDA-ARS/knausb/gits/standard-RAxML/raxmlHPC-HYBRID -T 4 -n result -s $infile -q core.part -p 12345 -x 12345 -N 100 -f a -m GTRGAMMA"

#CMD="/home/local/USDA-ARS/knausb/gits/standard-RAxML/raxmlHPC-HYBRID -T 4 -n result -s $infile -p 12345 -x 12345 -N 100 -c 25 -f a -m GTRCAT"

#CMD="~/gits/standard-RAxML/raxmlHPC-HYBRID -T 4 -n result -s $infile -p 12345 -x 12345 -N 100 -c 25 -f a -m GTRCAT"

#
#CMD="~/gits/standard-RAxML/raxmlHPC-HYBRID -T 3 -n result -s $infile -p 12345 -x 12345 -N 1000 -c 25 -f a -m GTRCAT"


#CMD="raxmlHPC -s $1 -n result -m GTRCAT -f a -x 123 -N 1000 -p 100 -o Psojae"

CMD="raxmlHPC -s $1 -n Ind205_results -m MULTICAT -f a -x 123 -N 1000 -p 100 -o Psojae"

echo $CMD
#
eval $CMD



# EOF.
