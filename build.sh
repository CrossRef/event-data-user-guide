mkdir ./build

DATE=`date "+%Y/%m/%d"`

cp ./*.png build/

rm build/event-data-manual-current.md
rm build/event-data-manual-todo.md
rm build/event-data-manual-future.md
rm build/future.pdf 
rm build/index.html



gpp event-data-manual-2.md -o build/event-data-manual-current.md -D__VERSION__="Version 0.3 $DATE"
gpp event-data-manual-2.md -o build/event-data-manual-todo.md -D__TODO__=true -D__VERSION__="Version 0.3 Draft with TODOs"
gpp event-data-manual-2.md -o build/event-data-manual-future.md -D__FUTURE__=true -D__TODO__=true -D__VERSION__="Version 0.3 Draft Pre-draft with Future Features and TODOs"

cp templates/bootstrap.min.css build/
cp -r images build/

pandoc -s build/event-data-manual-current.md --toc -o build/index.html --template templates/default.html

pandoc -s build/event-data-manual-future.md --toc -o build/future.pdf 
