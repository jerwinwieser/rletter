DIRS=$(ls -d output/*)
for DIR in $DIRS
do
	FILE=$(find $DIR | grep '.tex$')
	pdflatex -aux-directory=$DIR -output-directory=$DIR $FILE
done	
