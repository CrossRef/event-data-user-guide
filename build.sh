mkdir ./build

DATE=`date "+%Y/%m/%d"`

cp ./*.png build/

rm build/event-data-manual-current.md
rm build/event-data-manual-todo.md
rm build/event-data-manual-future.md

rm build/index.html

gpp event-data-manual.md -o build/event-data-manual-current.md -D__VERSION__="Version 0.2 MVP $DATE"
gpp event-data-manual.md -o build/event-data-manual-todo.md -D__TODO__=true -D__VERSION__="Version 0.1 MVP Draft with TODOs"
gpp event-data-manual.md -o build/event-data-manual-future.md -D__FUTURE__=true -D__TODO__=true -D__VERSION__="Version 0.1 Draft MVP Pre-draft with Future Features and TODOs"

cp templates/bootstrap.min.css build/
pandoc -s build/event-data-manual-current.md --toc -o build/index.html --template templates/default.html