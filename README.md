# poutpourri_tools

--------------------------------------------------

This repository contains many scripts of general usage and tools which turns the bioinformatic daily task really simpler. 

Applications involves since from genomics, metagenomics and transcriptomics. 

Hope that it help you. 

If you use, you cite. ;)

--------------------------------------------------

### Scripts

1. parsing_h_parsing.sh

It was created to work with parsed HMM profile searching results. These files are in general two column lists, containing in the first column the gene names, and in the second column the KO family (here could be every possible families or functions). It will take several of these files, generate a single normalized table already suitable to make a heatmap.

**General usage:**

```
parsing_h_parsing.sh <input_file> <output_file>
```
The script should be run in the folder where these files are, since it will use these files without the pathways. Just copy and paste the script into the desired folder, generate a list using the command:

```
ls *.<your_desired_files_extension> > input_file_name
```

2. Correlation_matrix.py

This program calculates the pair-wised rows correlation of an abundance matrix, these correlations are filtered for the most very standard (pearson, p<0.05, df=106). These pair of rows are filtered for avoid the same gene against itself and redundant comparision, just significant values are reported at the end.

**General usage:**

```
python Correlation_matrix.py <input_file> <output_file>
```

The input_file consists in a matrix or table of abundances in csv format. The output_file will be a three column list of row_x, row_y, correlation_index(p). It does not need to run in the samples file, just need to set up the addresses. *NEEDS NUMPY.*

3. filter_gene_presence.sh

Imagine a table with millions of genes and hundreds of samples, each cell is an abundance value. Filter each row by its presence or absence in a certain percentage of samples would be a hard task, until now. This scripts makes this filtering really easy and quick.

**General usage:**

```
filter_gene_abundance.sh <input_table_address> <output_table> <%_of_presence>
```

The input file is a table of abundance as above described, containing header and row names, and tabulation (\t separator). The output will be a subtable containing only the filtered rows. The *%_of_presence* is the minimum percentage (0-100) of presence in each row. 
