#!/bin/bash
################################

## This script makes the filtering of gene abundance data
## based in the percentage of presence in different stations
## Célio Dias Santos Junior
## celio.diasjunior@gmail.com
## Usage:
## filter_gene_abundance.sh <input_table_address> <output_table> <%_of_presence>

################################

rm -rf list tmp $2

if [ -z $1 ]; 
then 
	echo "## Usage:
## filter_gene_presence.sh <input_table_address> <output_table> <%_of_presence>
[STATUS .. There is no input_file]"
	exit
elif [ -z $2 ]; 
then
	echo "## Usage:
## filter_gene_presence.sh <input_table_address> <output_table> <%_of_presence>
[STATUS .. There is no Output_file]"
	exit
elif [ -z $3 ]; 
then
	echo "## Usage:
## filter_gene_presence.sh <input_table_address> <output_table> <%_of_presence>
[STATUS .. There is no Filtering_parameter]"
	exit
fi

################################

echo "H++ :: Setting constant"

start=`date +%s`

pcolumn=`awk -F'\t' '{print NF; exit}' $1`

column=`echo $(($pcolumn - 1))`

if [ -z $column ]; 
then
	echo "COL var __ ERROR NOT SET :: Unexpected error :: $pcolumn :: $column"
	exit
else
	pre=`echo -e "100\t$3" | awk '{ $3 = $2 / $1 } {print $3}'`
	inter=`echo -e "1\t$pre" | awk '{ $3 = $1 - $2 } {print $3}'`
	if [ -z $inter ];
	then 
		echo "INTER var __ ERROR NOT SET :: Unexpected error :: $inter"
		exit	
	else
		val=`echo -e "$column\t$inter" | awk '{ $3 = $2 * $1 } {print $3}' | awk 'int($1)'`
		k=100
		if [ -z $val ];
		then
			echo "VAL var __ ERROR NOT SET :: Unexpected error :: $val"
			exit	
		else
			if [ $(echo " $val > $k" | bc) -eq 1 ];
			then 
				echo "VAL var __ ERROR HIGHER 100 :: Unexpected error :: $val"
				exit
			fi
		fi
	fi
fi
#################################

echo "H++ :: Calculating zero fields frequency per line"

awk -F'\t' 'BEGIN{print "code", "count"}{print $1 "\t" gsub(/\t0\t/,"")}' $1 > tmp

echo "H++ :: Filtering Data"

awk -v VALUE=$val '$2 <= VALUE { print }' tmp | cut -f1 | sort | uniq > list
rm -rf tmp

echo "H++ :: Mounting table"

sort -k1,1 $1 > tmp

join list tmp | sed 's/ /\t/g' > $2

genes=`wc -l $1`

filtered=`wc -l $2`

rm -rf list tmp

end=`date +%s`

runtime=$((end-start))

echo "################################# Report"
echo ">> Variables setted up"
echo ">> Number of file columns : $pcolumn"
echo ">> Filter criteria : $3 %"
echo ">> Filtering differential : $inter"
echo ">> Number of zeros accepted as max : $val"
echo ">> Initial number of genes : $genes"
echo ">> Filtered genes : $filtered"
echo ">> Time : $runtime"
echo "#################################"
