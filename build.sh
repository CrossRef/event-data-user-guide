mkdir ./build

DATE=`date "+%Y/%m/%d"`

dot -Tpng pushpull.dot  > build/pushpull.png

cp ./*.png build/

rm build/event-data-manual-current.md
rm build/event-data-manual-todo.md
rm build/event-data-manual-future.md

# rm build/event-data-manual-current.pdf
# rm build/event-data-manual-todo.pdf
# rm build/event-data-manual-future.pdf

rm build/event-data-manual-current.html


gpp event-data-manual.md -o build/event-data-manual-current.md -D__VERSION__="Version 0.1 MVP $DATE"
gpp event-data-manual.md -o build/event-data-manual-todo.md -D__TODO__=true -D__VERSION__="Version 0.1 MVP Draft with TODOs"
gpp event-data-manual.md -o build/event-data-manual-future.md -D__FUTURE__=true -D__TODO__=true -D__VERSION__="Version 0.1 Draft MVP Pre-draft with Future Features and TODOs"

# pandoc -s build/event-data-manual-current.md --toc -o build/event-data-manual-current.pdf
# pandoc -s build/event-data-manual-future.md --toc -o build/event-data-manual-future.pdf
# pandoc -s build/event-data-manual-todo.md --toc -o build/event-data-manual-todo.pdf

cp templates/bootstrap.min.css build/
pandoc -s build/event-data-manual-current.md --toc -o build/index.html --template templates/default.html


# cp build/event-data-manual.pdf build/event-data-manual.$DATE.pdf
