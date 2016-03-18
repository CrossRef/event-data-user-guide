rm -r ./build
mkdir ./build

dot -Tpng pushpull.dot  > build/pushpull.png

pandoc -s event-data-manual.md --toc -o build/event-data-manual.pdf
pandoc -s event-data-manual.md --toc -o build/event-data-manual.html
