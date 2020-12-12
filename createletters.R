# create letter with latex ------------------------------------------------
library(dplyr)
library(purrr)

# read csv file -----------------------------------------------------------
df <- read.csv2("details.csv", stringsAsFactors = F)

df <- df %>% 
  filter(createletter ==1) %>% 
  mutate(dir = paste0("output/", companynameshort, "_", gsub("/", "-", letterdate)))

# copy files --------------------------------------------------------------
copy_files <- function(x) {
  file.copy(from = "template/letter.tex", to = x, overwrite = F)
  file.copy(from = "template/body.txt", to = x, overwrite = F)
  file.copy(from = "template/email.txt", to = x, overwrite = F)
}

unlink(df$dir, recursive=TRUE)
map(df$dir, dir.create)
map(df$dir, copy_files)

# compose the letter ------------------------------------------------------
compose_letter <- function(x) {
  print(x)
  filename <- paste0(x$dir, "/letter.tex")
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

for (i in c(1:nrow(df))) {
  print(i)
  compose_letter(x = df[i,])
}

# compile pdfs ------------------------------------------------------------
system('bash compile_latex_pdf.sh')

# make backup -------------------------------------------------------------
files <- list.files("output", full.names = T, recursive = T, pattern = ".pdf")
filesbackup <- paste0("pdf/", basename(dirname(files)), "_", basename(files))
map2(.x=files, .y=filesbackup, function(.x,.y) {file.copy(from=.x, to=.y, overwrite=T)})

          
