# create letter with latex ------------------------------------------------
library(dplyr)
library(purrr)

# read csv file -----------------------------------------------------------
df <- read.csv2("details.csv", stringsAsFactors = F)

# create dirs -------------------------------------------------------------
create_dirs <- function(x=df) {
  x <- paste0("output/",x[["companynameshort"]])
  if (!file.exists(x)){
    # if the file does not yet exist, create it 
    print(paste0('creating the dir ', x))
    dir.create(x)
    file.copy(from = "template/letter.tex", to = paste0(x,"/letter.tex"), overwrite = T)
  } else {
    # if the file does exist, overwrite the existing one for now
    print(paste0('dir ', x, 'already exists, but copying the directory anyway for now, poissbly overwriting the files in it..'))
    file.copy(from = "template/letter.tex", to = paste0(x,"/letter.tex"), overwrite = T)
  }
}

# compose the letter ------------------------------------------------------
compose_letter <- function(x=df) {
  filename <- paste0("output/", x[["companynameshort"]], "/letter.tex")
  fileconnection <- file(filename)
  content <- readLines(filename)
  contentadj <- content
  for (i in c(1:ncol(details))) {
    var <- names(details)[i]
    pattern <- paste0('\\newcommand{\\', var, '}{', var, '}')
    replacement <- paste0("\\newcommand{\\", var, "}{", details[i], "}")
    contentadj <- gsub(pattern, replacement, contentadj, fixed = T, perl = F)
  }
  writeLines(contentadj, fileconnection)
  close(fileconnection)
}

# apply functions ---------------------------------------------------------
for (i in c(1,2)){
  create_dirs(df[i,])
  compose_letter(df[i,])
}

# compile pdfs ------------------------------------------------------------
system('bash compile_latex_pdf.sh')

# list pdf files ----------------------------------------------------------
files <- list.files("output", full.names = T, recursive = T)
filespdf <- grep(".pdf", files, value =T)

