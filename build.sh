mkdir ./build

DATE=`date "+%Y-%m-%d-%H-%M"`

dot -Tpng pushpull.dot  > build/pushpull.png

pandoc -s event-data-manual.md --toc -o build/event-data-manual.$DATE.pdf
pandoc -s event-data-manual.md --toc -o build/event-data-manual.$DATE.html