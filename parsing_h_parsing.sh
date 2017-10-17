#!/bin/bash

################################

#### This script takes a parsed HMM profile searching result and parses it 
#### Until a frequency table using bash, to heatmap generation
#### This was made for KO numbers, but can be changed to use for any other kind
#### Author: Célio Dias Santos Júnior (celio.diasjunior@gmail.com)
#### General usage:
#### parsing_h_parsing.sh <input_file> <output_file>
#### Input_file is a list of parsed annotation files, one file per line

################################

rm -rf code_list tmp $2

if [ -z $1 ]; 
then 
	echo "## Usage:
## parsing_h_parsing.sh <input_file> <output_file>
[STATUS .. There is no input_file    ]
[STATUS .. input_file must be a list ]
[STATUS .. review entering code //   ]"
	exit
elif [ -z $2 ]; 
then
	echo "## Usage:
## parsing_h_parsing.sh <input_file> <output_file>
[STATUS .. There is no output_file]"
	exit
fi
################################

start=`date +%s`

echo "H++ :: Starting parsing"

echo "H++ :: Generating sources files"

for i in $(cat $1)
do
	cut -f2 $i | sort | uniq -c > tmp.$i

	sed -i 's/ K/\tK/g' tmp.$i ## Here you need change the string where your protein family HMM profile usually starts, here we used K for the KO numbers; but for PFAM families PF for example, should work

	sed -i 's/ //g' tmp.$i

	awk -F'\t' '$2 != ""' tmp.$i > t; rm -rf tmp.$i; mv t tmp.$i

	rm -rf 1 2; cut -f1 tmp.$i > 2; cut -f2 tmp.$i > 1; paste -d '\t' 1 2 | sort -k1,1 > tmp2.$i; rm -rf tmp.$i 1 2
done

echo "H++ :: Generating main code_list source"

for i in $(cat $1)
do
	cut -f1 tmp2.$i > tmp3.$i
done

cat tmp3.* | sort | uniq > code_list_source_KO

rm -rf tmp3.*

echo "H++ :: Generating the intermediate files for searching"

for each in $(ls tmp2.*)
do
	join code_list_source_KO $each | sed 's/ /\t/g' > oct.$each

	cut -f1 $each > col; grep -v -f col code_list_source_KO > oct2.$each

	rm -rf col

	perl -p -e 's/\n/\t0\n/' oct2.$each > oct3.$each

	cat oct.$each oct3.$each > oct4.$each

	rm -rf oct.$each oct3.$each oct2.$each

	sort -k1,1 oct4.$each > tre.$each; rm -rf oct4.$each

	rm -rf $each
done 

echo "H++ :: Calculating and normalizing"

touch log

for i in $(ls tre.*)
do
	cut -f2 $i > tmp

	awk 'FNR==NR{s+=$1;next;} {printf "%s\t%s\t%\n",$1,s}' tmp tmp > tmp2
	
	awk '$1>0{$3=100*$1/$2}1 {print $3}' tmp2 > tmp3; rm -rf tmp2; mv tmp3 tmp2

	paste -d '\t' log tmp2 > lt; rm -rf log tmp tmp2; mv lt log
done

echo "H++ ::  Rearranging matrix"

ls tre.* | tr "\n" "\t" > col.names

echo "FAMILY" > tmp

paste -d'\t' tmp col.names > ct; rm -rf col.names tmp; mv ct col.names

paste -d'\t' code_list_source_KO log > ll; rm -rf log code_list_source_KO; mv ll log

sed -i 's/\t\t/\t/g' log

cat col.names log > $2; rm -rf log col.names

sed -i 's/tre.tmp2.//g' $2

sed -i 's/\%/0/g' $2

rm -rf tre.*

end=`date +%s`

runtime=$((end-start))

echo "H++ :: Process finished"

echo "H++ :: Time of process $runtime s"
