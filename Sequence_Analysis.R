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

analyze.sequences(path ="./Analysis-compare_Round2/2020_07_11_FUNGAL_ITS")

f#3.---------------------------------Blast-----------------------------------------------------

Blast.Files(Blastpath = "./Fasta_Sequences")

