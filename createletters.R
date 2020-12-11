# create letter with latex ------------------------------------------------
library(dplyr)
library(purrr)

unlink("output", recursive=T)
dir.create("output")

# read csv file -----------------------------------------------------------
df <- read.csv2("details.csv", stringsAsFactors = F)

# create dirs -------------------------------------------------------------
create_dirs <- function(x=df) {
  dir <- paste0("output/", x[["companynameshort"]])
  letterdate <- gsub("/", "-", x[["letterdate"]])
  filenamenew <- paste0(dir,"/", x[["companynameshort"]], "_letter_", letterdate, ".tex")
  bodynew <- paste0(dir,"/", "body.txt")
  emailnew <- paste0(dir,"/", "email.txt")
  if (!file.exists(dir)){
    # if the file does not yet exist, create it 
    print(paste0('creating the dir ', dir))
    dir.create(dir)
    file.copy(from = "template/letter.tex", to = filenamenew, overwrite = T)
    file.copy(from = "template/body.txt", to = bodynew, overwrite = T)
    file.copy(from = "template/email.txt", to = emailnew, overwrite = T)
  } else {
    # if the file does exist, overwrite the existing one for now
    print(paste0('dir ', dir, 'already exists, but copying the directory anyway for now, poissbly overwriting the files in it..'))
    file.copy(from = "template/letter.tex", to = filenamenew, overwrite = T)
    file.copy(from = "template/body.txt", to = bodynew, overwrite = T)
    file.copy(from = "template/email.txt", to = emailnew, overwrite = T)
  }
}

# compose the letter ------------------------------------------------------
compose_letter <- function(x=df) {
  letterdate <- gsub("/", "-", x[["letterdate"]])
  filename <- paste0("output/", x[["companynameshort"]], "/", x[["companynameshort"]], "_letter_", letterdate, ".tex")
  print(filename)
  fileconnection <- file(filename)
  content <- readLines(filename)
  contentadj <- content
  for (i in c(1:ncol(x))) {
    var <- names(x)[i]
    pattern <- paste0('\\newcommand{\\', var, '}{', var, '}')
    replacement <- paste0("\\newcommand{\\", var, "}{", x[i], "}")
    contentadj <- gsub(pattern, replacement, contentadj, fixed = T, perl = F)
  }
  writeLines(contentadj, fileconnection)
  close(fileconnection)
}

# apply functions ---------------------------------------------------------
for (i in seq_along(df)){
  create_dirs(df[i,])
  compose_letter(df[i,])
}

# compile pdfs ------------------------------------------------------------
# system('bash compile_latex_pdf.sh')

# list pdf files ----------------------------------------------------------
# files <- list.files("output", full.names = T, recursive = T, pattern = ".pdf")
# file.copy(from = files, to = "pdf/", overwrite = T)

          
