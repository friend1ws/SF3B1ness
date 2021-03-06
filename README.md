[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Build Status](https://travis-ci.org/friend1ws/SF3B1ness.svg?branch=master)](https://travis-ci.org/friend1ws/SF3B1ness)

# SF3B1ness
R package for obtaining SF3B1ness score

## Install 

The easiest way for installing **SF3B1ness** is to use the package ** devtools**.
If you have not installed **devtools**, then
```
install.packages("devtools")
```

To install and load **SF3B1ness**,
```R
devtools::install_github("friend1ws/SF3B1ness")
library(SF3B1ness)
```

## Calculate SF3B1ness score for recount2 data

**SF3B1ness** can directly accept junction coverate file from recount2.
```R
# load the example recount2 file
recount2_junction_coverage <- system.file("extdata/recount2/SRP056033.junction_coverage.tsv.gz", package="SF3B1ness")

# calculate SF3B1ness score
SF3B1ness_recout2 <- SF3B1ness_recount2(recount2_junction_coverage)
print(SF3B1ness_recout2)

# following data frame will appear

#       Study        Run       Score
# 1 SRP056033 SRR1908917  2970.10654
# 2 SRP056033 SRR1908922  1393.82765
# 3 SRP056033 SRR1908921   -54.03809
# 4 SRP056033 SRR1908920  2257.09786
# 5 SRP056033 SRR1908918 -1026.42436
# 6 SRP056033 SRR1908923  3327.38061
# 7 SRP056033 SRR1908919  -767.68221
# 8 SRP056033 SRR1908916  3095.03185
```

## Calculate SF3B1ness score for STAR splicing junction files

**SJ.out.tab** files generated through STAR alignment can be used.
```R
# load the example SJ.out.tab file
SJ_file <- system.file("extdata/SJ_hg19/CCLE-MUTZ-3-RNA-08.SJ.out.tab", package="SF3B1ness")

# calculate SF3B1ness score
SF3B1ness_SJ <- SF3B1ness_SJ(SJ_file)
print(SF3B1ness_SJ)

# following data frame will appear

#          Sample_Name    Score
# 1 CCLE-MUTZ-3-RNA-08 983.4035
```
