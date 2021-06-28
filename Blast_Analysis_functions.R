#---------------------------------Blast functions for blasting fasta sequences against 16S and ITS DB----------------------------------------
#Installing required packages and loading required libraries---------------------------------------------------------------------------------

if (!requireNamespace("librarian", quietly = TRUE))
  install.packages("librarian")
librarian::shelf(Biostrings, tidyverse, seqinr, devtools, lib = tempdir(), update_all = TRUE)

#--------------------------------Setting correct paths for blast and blast DB----------------------------------------------------------------
#change D: depending on the drive cmputer assigns to the USB 
#is this neccessary to keep?

Sys.setenv(PATH = paste(Sys.getenv("PATH"), "C:\\Users\\corri\\16S_ITS_Analysis\\NCBI\\blast-2.11.0+\\bin", sep= .Platform$path.sep))
Sys.setenv(PATH = paste(Sys.getenv("PATH"), "C:\\Users\\corri\\16S_ITS_Analysis\\NCBI\\blast-2.11.0+\\db", sep= .Platform$path.sep))

#----------------------------------------------------------edit.fasta function---------------------------------------------------------------
#Function to remove spaces from fastafiles---------------------------------------------------------------------------------------------------

edit.fasta<- function(x){
  fasta<- read.fasta(x, whole.header = TRUE, as.string = TRUE)
  noSpace<- lapply(names(fasta), function(y)gsub('\\s+', "_",y))
  write.fasta(sequences = fasta, names = noSpace, file.out = x)
}

#--------------------------------------------------------------Blast.CB Funtion--------------------------------------------------------------
#runs local blast through the system command
#creates tibble with output data

Blast.CB<-function (x, 
                    blastn = "blastn",
                    blast_db = blast_db,
                    input = x,
                    evalue = 0.05,
                    format = '"6 sscinames sseqid pident length qcovhsp mismatch gapopen qstart qend sstart send evalue bitscore"',
                    max_target_seqs = 100,
                    gapopen = 0,
                    word_size = 28,
                    qcov_hsp_perc = 90){
  
  colnames <- c("Name",
                "sseqid",
                "pident",
                "length",
                "query_coverage",
                "mismatch",
                "gapopen",
                "qstart",
                "qend",
                "sstart",
                "send",
                "evalue",
                "bitscore")
  
  blast_out<- system2(command = blastn, 
                    args = c("-db", blast_db, 
                             "-query", input, 
                             "-outfmt", format, 
                             "-evalue", evalue, 
                             "-gapopen", gapopen,
                             "-max_target_seqs", max_target_seqs,
                             "-word_size", word_size,
                             "-qcov_hsp_perc", qcov_hsp_perc),
                    wait = TRUE,
                    stdout = TRUE) %>% 
              as_tibble() %>% 
              separate(col = value, into = colnames, sep = "\t", convert = TRUE)
  
  return(blast_out)
}

#------------------------------------------------------------Blast.all function-----------------------------------------------------------
#runs edit.fasta function to remove any spaces in the fasta file
#runs the Blast.CB function on the file and
#savest the blast result into a csv

Blast.all<- function(file_name, blast_db, DBname){
  name = basename(file_name)
  DB = DBname
  edit.fasta(file_name)
  Blast_output<- Blast.CB(file_name, blast_db = blast_db) 
  mypath <- file.path("../Results/", paste("Result", DB, name, ".csv", sep=""))
  write.csv(Blast_output, file = mypath, row.names = FALSE)
}

#----------------------------------------------------Blast.Files function-----------------------------------------------------------------
#runs Blast.all on a list of files within the Blastpath
#blasts against 16S DB for files with 16S in the file name
#blasts against ITS DB for files with ITS in the file name


Blast.Files<- function(Blastpath, blast16Sdb = "../NCBI/blast-2.11.0+/db/16S_ribosomal_RNA", blastITSdb = "../NCBI/blast-2.11.0+/db/ITS_RefSeq_Fungi", DBname = DBname){
  
  file_names <- dir(Blastpath, pattern=".fa|.fsta", full.names = TRUE)
  
  print("generating 16S sequence list")
  
  matches_16S = str_match(file_names, "16S")
  indices_16S = which(!is.na(matches_16S))
  file_names_16S = file_names[indices_16S]
  
  print("blasting 16S")
 
  lapply(file_names_16S, FUN = Blast.all, blast_db = blast16Sdb, DBname = DBname)
  
  
  print("generating ITS sequence list")
  
  matches_ITS = str_match(file_names, "ITS")
  indices_ITS = which(!is.na(matches_ITS))
  file_names_ITS = file_names[indices_ITS]
  
  print("blasting ITS")
  
  lapply(file_names_ITS, FUN = Blast.all, blast_db = blastITSdb, DBname = DBname)
}



