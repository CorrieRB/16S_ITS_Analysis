##----------------------------Sanger_Analysis_Functions for Sanger Sequencing reads----------------------------------------

if (!requireNamespace(c("librarian", "BiocManager")))
  install.packages("librarian", "BiocManager")

librarian::shelf(devtools, tidyverse, lib = tempdir(), update_all = TRUE)

BiocManager::install("sangeranalyseR", update = FALSE)
library(sangeranalyseR)

#--------------------------------------------load files function------------------------------------------------------------
#load abi files-------------------------------------------------------------------------------------------------------------
#rename files to remove date and time stamp---------------------------------------------------------------------------------
#index forward and reverse reads and create groups--------------------------------------------------------------------------

load.files <- function(path = path){
  
  #get the file names and the list of file names you want to replace them with
  old_file_names <- dir(path, pattern=".ab1", full.names = TRUE)
  new_file_names<- gsub("FWD_\\d+_\\d+.*", "FWD.ab1", old_file_names)
  new_file_names<- gsub("REV_\\d+_\\d+.*", "REV.ab1", new_file_names)
  
  file.rename(from = old_file_names, to = new_file_names)
  
  #Index forward and reverse reads
  files_cleaned = new_file_names
  f_matches = str_match(files_cleaned, "FWD")
  f_indices = which(!is.na(f_matches))
  r_matches = str_match(files_cleaned, "REV")
  r_indices = which(!is.na(r_matches))
  
  #ONLY keep files that match either FWD or REV suffix
  keep = c(f_indices, r_indices)
  files_cleaned = files_cleaned[keep]
  
  # remove the suffixes to create a groupname
  files_cleaned = gsub("_FWD.*", "", files_cleaned)
  files_cleaned = gsub("_REV.*", "", files_cleaned)
  
  #create groups
  group_dataframe =  data.frame("file.path" = new_file_names[keep], "group" = files_cleaned)
  groups = unique(group_dataframe$group)
  
  return(groups)
}

#----------------------------------------CB.Contig function using sangercontig-----------------------------------------------
#CB.Contig function generates a contig from a fwd and reverse read using sangercontig function-------------------------------
#fasta consensus is output into fasta file-----------------------------------------------------------------------------------
#quality data for fwd and rev read are subsetted and returned as a summary object--------------------------------------------

CB.Contig<- function(path, contigName, suffixForwardRegExp, suffixReverseRegExp, file_name_fwd, file_name_rev){
  
  print("reading forward and reverse reads and generating contig")
  
  sangerContig <- SangerContig(
    inputSource           = "ABIF",
    parentDirectory       = path,
    contigName            = contigName,
    suffixForwardRegExp   = suffixForwardRegExp,
    suffixReverseRegExp   = suffixReverseRegExp,
    TrimmingMethod        = "M1",
    M1TrimmingCutoff      = 1e-03,
    minReadLength         = 0,
    signalRatioCutoff     = 0.33,
    showTrimmed           = TRUE)
 
  print("exporting fasta sequence")
  
  writeFasta(sangerContig, outputDir = "../Fasta_Sequences/", selection = "contig")
  
  print("subsetting quality data")
  
  QualityFWD <- sangerContig@forwardReadList[[file_name_fwd]]@QualityReport
  QualityREV <- sangerContig@reverseReadList[[file_name_rev]]@QualityReport
  
  print("Generating read summary")
  
  read.summary = c("trim.cutoff"                 = QualityFWD@M1TrimmingCutoff,
                   "trimmed.start.FWD"           = QualityFWD@trimmedStartPos,
                   "trimmed.start.REV"           = QualityREV@trimmedStartPos,
                   "trimmed.finish.FWD"          = QualityFWD@trimmedFinishPos,
                   "trimmed.finish.REV"          = QualityREV@trimmedFinishPos,
                   "raw.seq.length.FWD"          = QualityFWD@rawSeqLength,
                   "raw.seq.length.REV"          = QualityREV@rawSeqLength,
                   "trimmed.seq.length.FWD"       = QualityFWD@trimmedSeqLength,
                   "trimmed.seq.length.REV"       = QualityREV@trimmedSeqLength,
                   "raw.Mean.qual.FWD"           = QualityFWD@rawMeanQualityScore,
                   "raw.Mean.qual.REV"           = QualityREV@rawMeanQualityScore,
                   "trimmed.Mean.qual.FWD"       = QualityFWD@trimmedMeanQualityScore,
                   "trimmed.Mean.qual.REV"       = QualityREV@trimmedMeanQualityScore)
  
  return(list("summary" = read.summary, "contig" = sangerContig))
  
}

#----------------------------------Summarize.Sanger function----------------------------------------------------------------
#Summarize.Sanger function runs sanger contig function and puts subsetted quality data into a dataframe---------------------

Summarize.Sanger<- function(group, path = path, summarylist = summarylist){
  
  file_name_fwd = paste(group, "_FWD.ab1", sep="")
  file_name_rev = paste(group, "_REV.ab1", sep="")
  contigName = basename(group)
  
  row_names = c("trim_cutoff",
                "trim_start_FWD",
                "trim_start_REV",
                "trim_finish_FWD",
                "trim_finish_REV",
                "raw_length_FWD",
                "raw_length_REV",
                "trim_length_FWD",
                "trim_length_FWD",
                "raw_MeanQual_FWD",
                "raw_MeanQual_rev",
                "trim_MeanQual_FWD",
                "trim_MeanQal_REV")
  
  
  consensus_sequence <- CB.Contig(path =                path,
                                  contigName =          contigName,
                                  suffixForwardRegExp = "_FWD.ab1",
                                  suffixReverseRegExp = "_REV.ab1",
                                  file_name_fwd =       file_name_fwd,
                                  file_name_rev =       file_name_rev)
  
  #separate summary data from the consensus sequence object 
  #turn it into a dataframe with row names from above
  summary = consensus_sequence$summary
  summary = t(summary) %>% 
    as.data.frame(., row.names = row_names)
  
  #add a column called sample which is equal to the contig name
  summary$sample <- contigName
  
  summarylist[[group]]<-summary
}

#---------------------------------------analyze.sequences function------------------------------------------------------
#Function to run summarize.sanger on groups of files and output  summary of quality results for all samples-------------

analyze.sequences<- function(path){
  
  #load the files and group into groups based on accession #
  groups<- load.files(path) 
  
  #generate an empty summary list to put the summary data in
  summarylist = list()
  
  #run summarize.sanger function on all files in the path to generate fasta files
  summarylist<- lapply(groups, FUN = Summarize.Sanger, path = path, summarylist = summarylist)
  #then concatenate the summary data into a single df
  summary_data<- do.call(rbind, summarylist)
  
  #change the order of the columns so the contig name is the first column of the df
  summary_data<- summary_data[, c(14,1:13)]
  
  #export the summary data into a csv in the Results folder
  Resultpath<- file.path("../Results", paste("Quality_Report", basename(path), ".csv", sep=""))
  write.csv(summary_data, file = Resultpath, row.names = FALSE)
  
}