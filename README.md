#16S_ITS_Analysis

This is a Github repository containing functions useful for 16S and ITS Sanger sequencing analysis.

#Required packages

RTools must be installed and configured before use

The following packages are used for this Sanger analysis pipeline:
Sangeranalyze.R
Tidyverse
Seqinr
Devtools
Biostrings
 
local Blast+ must be installed before use and location of blast directories updated in the **Blast_Analysis_functions.R** script (lines 12 and 13)

Blast can be downloaded [here](https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/)

See update_databases.R for 16S, ITS, nucleotide and taxdb databases that need to be downloaded and updated
git
#Instructions for use

##Setup
First make sure the the **16S_ITS_Analysis** repository is located in a directory which also contains the following Directories
./Raw_data (for the ab1 Sanger sequencing files)
./NCBI (containing the local BLAST databases)
./Fasta_Sequences (the output directory for contig fasta files)
./Fasta_Sequences_nucleotide_search (directory to put files to be searched against nucleotide database)
./Resutls (the output directory for the contig alignments, quality reports and final BLAST results)

The Sequencing data should be saved with the following convention:
YYYY_MM_DD_16S_Accession#_FWD
YYYY_MM_DD_16S_Accession#_REV

run the folowing code in the **Sequence_Analysis.R** script to source the sequence analysis and blast functions:


```
#1.----------------Install packages and sourcing functions--------------------------------------

source("Analyze_Sanger_Functions.R")
source("Blast_Analysis_functions.R")
```

##Trimming and contig generation
To analyze the Sanger sequence data, save the raw data in the Raw_data directory and update the location of the folder containing all the read files (line 25) or a single read file (line 29) in the **Sequence_Analysis.R** script.
Run the following code to generate contig alignments, quality reports and fasta sequences.

```
#2.------------------Trim, merge and generating consensus sequences-----------------------------

#for generating contig from forward and reverse reads in a sequencing file
#change path to location of raw sequencing data
analyze.sequences(path ="../Raw_data/2022_03_17_16S")

#for trimming and generating fasta sequence for a single read forward or reverse
#change readFileName to sequence of interest including sequence location
single.read(readFileName = "../Raw_data/2022_03_17_16S/2022_03_16_16S_H717480_FWD.ab1", readFeature = "Forward Read")
```
**Note:** If either forward or reverse reads do not meet quality cutoffs then a consensus sequence cannot be generated and the analysis will quit at that sequence without finishing. Remove these files from the directory containing the other reads to analyze all the reads without the analysis cutting short.

##Blast searching against 16S or nucleotide DB
Running the following will Blast the sequences in the Fasta_Sequences directory against the local 16S database:

```
#3.---------------------------------Blast-----------------------------------------------------
#for search against 16S and ITS databases
#change Blastpath to location of fasta sequences
Blast.Files(Blastpath = "../Fasta_Sequences", DBname = "_rRNA")

```

Running the following will Blast the sequences in the Fasta_sequences_nucleotide_search directory against the uncurrated nucleotide database:

```
#for search against nucleotide database
#change Blastpath to location of fasta sequences
Blast.Files(Blastpath = "../Fasta_Sequences_nucleotide_search", blast16Sdb = "../NCBI/blast-2.11.0+/db/nt", blastITSdb = "../NCBI/blast-2.11.0+/db/nt", DBname = "_nucleotide")

```

#License

BSD-2-Clause