DIRS=$(ls -d output/*)
for DIR in $DIRS
do
	pdflatex -aux-directory=$DIR -output-directory=$DIR $DIR'/letter.tex'
done	
