#############################################################################################
#----------------------16S_ITS Analysis-Blasting Sequences-----------------------------------
#############################################################################################

######Place cursor on line to be run or highlight and press run on top right hand corner#####

##Notes:

##Name files with the following convention
###----YYYY_MM_DD_16S_Accession#_FWD
###----YYYY_MM_DD_ITS_Accession#_REV

#Quality summary will be put in Results Folder
#fasta contigs will be put in Fasta_Sequences Folder

#1.----------------Install packages and sourcing functions--------------------------------------

source("Analyze_Sanger_Functions.R")
source("Blast_Analysis_functions.R")

#2.------------------Trim, merge and generating consensus sequences-----------------------------

#for generating contig from forward and reverse reads in a sequencing file
#change path to location of raw sequencing data
analyze.sequences(path ="../Raw_data/2022_03_02_16S_ITS_2")

#for trimming and generating fasta sequence for a single read forward or reverse
#change readFileName to sequence of interest including sequence location
analyze.single.sequence(readFileName = "../Raw_data/2022_03_02_16S_ITS/2022_03_02_16S_F40389_REV.ab1", readFeature = "Reverse Read")

#3.---------------------------------Blast-----------------------------------------------------
#for search against 16S and ITS databases
#change Blastpath to location of fasta sequences
Blast.Files(Blastpath = "../Fasta_Sequences", DBname = "_rRNA")

#for search against nucleotide database
#change Blastpath to location of fasta sequences
Blast.Files(Blastpath = "../Fasta_Sequences_nucleotide_search", blast16Sdb = "../NCBI/blast-2.11.0+/db/nt", blastITSdb = "../NCBI/blast-2.11.0+/db/nt", DBname = "_nucleotide")

