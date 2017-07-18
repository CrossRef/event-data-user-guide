# Event Data User Guide 

The guide is available to read at at http://www.eventdata.crossref.org/guide

To build:

    mkdocs build

To upload:

    aws s3 sync site s3://event-data-www/guide/

Note that site uses cloudfront so there will be a delay while edge caches update. To force an emmediate update invalidate the objects you want to update in the cloudfront distribution. 

## License

Copyright © Crossref

Distributed under the The MIT License (MIT).


