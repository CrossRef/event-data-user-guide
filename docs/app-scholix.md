# Appendix: Scholix API Endpoint

[Scholix](http://www.scholix.org/) is a metadata specification for the expression of scholarly links between literature and datasets. Event Data implements a Scholix endpoint in the API:

    https://query.eventdata.crossref.org/v1/events/scholix

A subset of relevant Events (from the 'crossref' and 'datacite' sources) is available at this endpoint. 

The filter parameters are the same as specified in the [Query API](/service/query-api). The response format uses the [Scholix schema](http://www.scholix.org/schema). 