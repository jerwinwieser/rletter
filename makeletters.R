details <- read.csv2("details.csv", stringsAsFactors = F)

dir <- paste0("output/", details$companyname)

names(details)

file.remove(dir)
dir.create(dir)

if (!file.exists(dir)){
  print('dir does not exist')
} else {
  print('dir already exists')
}

detailscurrent <- as.character(as.vector(details[1,]))

filename <- "checkletter/letter.tex"
fileconnection <- file(filename)
content <- readLines(filename)
writeLines(content, fileconnection)
close(fileconnection)


