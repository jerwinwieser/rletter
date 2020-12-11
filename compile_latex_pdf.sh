DIRS=$(ls -d output/*)
FILES=$(find output/* | grep '.tex$')
for DIR in $DIRS
do
	pdflatex -aux-directory=$DIR -output-directory=$DIR $FILES
done	
