### This program calculates the rows correlation of an abundance matrix 
### These correlations are filtered for the most very standard (pearson, p<0.05, df=106)
### These pair of rows are filtered for avoid the same gene against itself and
### Redundant comparision, just significant values are reported at the end
### Bcn, 2017 - C.Dias Santos-Junior, F.Latorre
### celio.diasjunior@gmail.com

import numpy as np
import sys 

def corrcoef(matrix):

	r = np.corrcoef(matrix)

	return r

if __name__ == '__main__':

	fh1 = open(sys.argv[1], 'r')

	c = 0 

	gene_list = []

	big_list = []

	for line in fh1:

		line_tmp = line.split(",")

		if c == 0:

			header = line_tmp

		else:

			gene_list.append(line_tmp[0])

			big_list.append(line_tmp[1:])

		c += 1

	fh1.close()

	fh2 = open(sys.argv[2], "w")	

	for i in range(0, len(gene_list)):

		for u in range(0, len(gene_list)):
			
			if gene_list[u] > gene_list[i]:
		
				mat = np.array([big_list[i], big_list[u]]).astype(np.float)

				r = corrcoef(mat)

				v = float(r[0,1])

				if (float(v) > 0.1909) or (float(v) < -0.1909):

					fh2.write("{0}\t{1}\t{2}\n".format(str(gene_list[i]), str(gene_list[u]), float(r[0,1])))

	fh2.close()
