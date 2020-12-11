details <- read.csv2("details.csv", stringsAsFactors = F)

# dir <- paste0("output/", details$companyname)
# 
# names(details)
# 
# file.remove(dir)
# dir.create(dir)
# 
# if (!file.exists(dir)){
#   print('dir does not exist')
# } else {
#   print('dir already exists')
# }

detailscurrent <- as.character(as.vector(details[1,]))

file.copy(from = "template/letter.tex", to = "output/lettertest/letter.tex", overwrite = T)

filename <- "output/lettertest/letter.tex"
fileconnection <- file(filename)
content <- readLines(filename)
contentadj <- content

for (j in nrow(details)){
  for (i in seq_along(details)) {
    var <- names(details)[i]
    varcont <- details[j,i]
    pattern <- paste0('\\newcommand{\\', var, '}{', var, '}')
    replacement <- paste0("\\newcommand{\\", var, "}{", varcont, "}")
    contentadj <- gsub(pattern, replacement, contentadj, fixed = T, perl = F)
  }
}

writeLines(contentadj, fileconnection)
close(fileconnection)

system(paste("pdflatex", filename))
