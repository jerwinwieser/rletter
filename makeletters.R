details <- read.csv2("details.csv", stringsAsFactors = F)

dir <- paste0("output/", details$companyname)

names(details)

file.remove(dir)
dir.create(dir)

content <- readLines("template/letter.tex")
detailscurrent <- as.character(as.vector(details[1,]))

gsub("ut","ot",
     content)

writeLines(content)

if (!file.exists(dir)){
  print('dir does not exist')
} else {
  print('dir already exists')
}
