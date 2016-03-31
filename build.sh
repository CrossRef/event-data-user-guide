mkdir ./build

DATE=`date "+%Y-%m-%d-%H-%M"`

dot -Tpng pushpull.dot  > build/pushpull.png

rm build/event-data-manual.pdf

pandoc -s event-data-manual.md --toc -o build/event-data-manual.pdf
pandoc -s event-data-manual.md --toc -o build/event-data-manual.html

cp build/event-data-manual.pdf build/event-data-manual.$DATE.pdf