mkdir ./build

DATE=`date "+%Y/%m/%d"`

cp ./*.png build/

rm build/index.html

cp templates/bootstrap.min.css build/
cp -r images build/
cp event-data-manual.md build/

pandoc -s build/event-data-manual.md --toc -o build/index.html --template templates/default.html

# pandoc -s build/event-data-manual.md --toc -o build/future.pdf 
