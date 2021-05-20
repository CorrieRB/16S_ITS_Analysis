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

analyze.sequences(path ="../Raw_data/Analysis-compare_Round2/Plate_2019_08_02_16S_Myco")

#3.---------------------------------Blast-----------------------------------------------------
#for search against 16S and ITS databases
Blast.Files(Blastpath = "../Fasta_Sequences")

#for search against nucleotide database
Blast.Files(Blastpath = "../Fasta_Sequences_nucleotide_search", blast16Sdb = "../NCBI/blast-2.11.0+/db/nt")

