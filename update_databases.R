#Setting up any required packages------------------------------------------

# writeLines('PATH="${RTOOLS40_HOME}/usr/bin;${PATH}"', con = "~/.Renviron")
# devtools::install_github("mhahsler/rBLAST")

#downloading/updating databases--------------------------------------------

download.file("ftp://ftp.ncbi.nlm.nih.gov/blast/db/16S_ribosomal_RNA.tar.gz",
              "C:\\Users\\corri\\Sequencing_Analysis\\NCBI\\blast-2.12.0+\\db\\16S_ribosomal_RNA.tar.gz", mode='wb')
untar("../NCBI/blast-2.12.0+/db/16S_ribosomal_RNA.tar.gz", exdir="../NCBI/blast-2.12.0+/db/16S_ribosomal_RNA")

download.file("ftp://ftp.ncbi.nlm.nih.gov/blast/db/ITS_RefSeq_Fungi.tar.gz",
              "C:\\Users\\corri\\Sequencing_Analysis\\NCBI\\blast-2.12.0+\\db\\ITS_RefSeq_Fungi.tar.gz", mode='wb')
untar("../NCBI/blast-2.12.0+/db/ITS_RefSeq_Fungi.tar.gz", exdir="../NCBI/blast-2.12.0+/db/ITS_RefSeq_Fungi")


download.file("ftp://ftp.ncbi.nlm.nih.gov/blast/db/taxdb.tar.gz",
              "../NCBI/blast-2.12.0+/taxdb.tar.gz", mode='wb')
untar("../NCBI/blast-2.12.0+/taxdb.tar.gz", exdir="../NCBI/blast-2.12.0+/taxdb")



download.file("ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.00.tar.gz",
              "../ncbi-blast-2.13.0+/db/nt.00.tar.gz", method = 'wget')
untar("../ncbi-blast-2.12.0+/db/nt.03.tar.gz", exdir="../NCBI/blast-2.12.0+/db")
