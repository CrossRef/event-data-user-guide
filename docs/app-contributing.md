# Appendix: Contributing to Event Data

We welcome new data contributors. We have two interfaces: the Event Bus which accepts raw Events, or the Percolator, which does some work to reverse landing pages and text back into Events.

### Preparation

We would love to help you develop your Push Source.

 1. Contact us at eventdata@crossref.org to discuss your source. 
 1. Decide what kind of Relation Types best describe your data.
 1. We will give you authentication tokens for staging and production, and an agent ID.

### Authorisation

All authorisation is done with JWT. We will send you a token for staging and when you are ready, another one for production.

### Sending Events to the Bus

If you can create ready-made Events, send them directly to the Event Bus. This is done with an HTTP POST to the right endpoint.

 - https://bus-staging.eventdata.crossref.org/events
 - https://bus.eventdata.crossref.org/events

You will receive an HTTP 201 on success.

The [Event Bus is open source and available on Github](https://github.com/crossref/event-data-event-bus).

### Sending Events to the Percolator

If you have data that you think is useful but not enough to make Events, you could send it to the Percolator. The Percolator accepts inputs as input Evidence Records, and will:
 
 - Convert landing pages into DOIs.
 - Verify that DOIs really exist.
 - Extract landing pages and DOIs from supplied HTML snippets, text snippets, or follow URLs to do this.

If you use the Percolator then your input will be converted into an Evidence Record and enter the Evidence Registry.

The [Percolator is open source and available on Github](https://github.com/crossref/event-data-percolator).

### Example 1: Bigipedia

Bigipedia is an online Encyclopedia. It cites DOIs in its reference list for its articles. Its source token is `b1bba157-ab5b-4cb8-9ac8-4beb2d6405ff`. Bigipedia will tell Event Data every time a DOI is cited, and will send data every time a citation is added.

In this example, Bigipedia informs us that the DOI is referenced by the article page. Note that because the subject is not a DOI, the metadata must be supplied in the `subj` key. 

    $ curl "https://bus.eventdata.crossref.org/events" \
           --verbose \
           -H "Content-Type: application/json" \
           -H "Authorization: Token token=591df7a9-5b32-4f1a-b23c-d54c19adf3fe" \
           -X POST \
           --data '{"id": "dbba925e-b47c-4732-a27b-0063040c079d",
                    "source_token": "b1bba157-ab5b-4cb8-9ac8-4beb2d6405ff",
                    "subj_id": "http://bigipedia.com/pages/Chianto",
                    "obj_id": "https://doi.org/10.3403/30164641u",
                    "relation_type_id": "references",
                    "source_id": "bigipedia",
                    "license: "https://creativecommons.org/publicdomain/zero/1.0/",
                    "subj": {"title": "Chianto",
                             "issued": "2016-01-02",
                              "URL": "http://bigipedia.com/pages/Chianto"}}'

### Example 2: DOI Remember

DOI Remember is a bookmarking service for DOIs. DOI Remember will tell Event Data how many times each DOI is cited. Every day it will send data for every DOI, stating how many times it is currently bookmarked. Its source token is `366273b5-d3d8-488b-afdc-940bcd0b9b87`.

In this example, DOI Remember tells that as of the 1st of March 2016, 922 people have bookmarked the given DOI. The Subject is the 'DOI Remember' source as a whole. As its URL is not a DOI, subject metadata must be included. Event Data allows for the year `0000-01-01` for the issue date when it's not meaningful to provide one.
    
    $ curl "https://bus.eventdata.crossref.org/events" \
           --verbose \
           -H "Content-Type: application/json" \
           -H "Authorization: Token token=22e49a7c-5edd-4873-a2b2-c541512c933a" \
           -X POST \
           --data '{"id": "c06fc051-5e29-4cd3-b46a-652c646a3582",
                     "source_token": "366273b5-d3d8-488b-afdc-940bcd0b9b87",
                     "subj_id": "http://doiremember.com",
                     "obj_id": "https://doi.org/10.3403/30164641u",
                     "total": 922,
                     "occurred_at": "2016-03-01T00:00:00Z",
                     "relation_type_id": "bookmarks",
                     "source_id": "doi_remember",
                     "license: "https://creativecommons.org/publicdomain/zero/1.0/",
                     "subj":{
                       "title":"DOI Remember",
                       "issued":"0000-01-01",
                       "URL":"http://doiremember.com"}}}'

### Example 3: Hansard Watch

Hansard Watch is a service that monitors the UK House of Commons and sends an event every time a DOI is mentioned in Parliament. Every time it finds a new DOI mention it will send a link to the URL of the online Hansard page. Its source token is `a8d4efa6-868b-4230-9685-74b6c7c192bf`.

In this example, the given Hansard page discusses the given DOI. It has a publication date.

    $ curl "https://bus.eventdata.crossref.org/events" \
       --verbose \
       -H "Content-Type: application/json" \
       -H "Authorization: Token token=b832bf3a-f5ca-4435-9a2b-09fec0f313a6" \
       -X POST \
       --data '{"id": "16acd857-82b8-493c-8e79-6ac0a67ce53b",
                "source_token": "a8d4efa6-868b-4230-9685-74b6c7c192bf",
                "subj_id": "https://hansard.parliament.uk/Commons/2013-04-24/debates/13042449000029/VATOnToastedSandwiches",
                "obj_id": "https://doi.org/10.3403/30164641u",
                "occurred_at": "2013-03-24T00:00:00Z",
                "relation_type_id": "discusses",
                "source_id": "hansard_watch",
                "license: "https://creativecommons.org/publicdomain/zero/1.0/",
                "subj":{
                  "title":"Previous VAT on toasted sandwiches",
                  "issued":"2013-03-24",
                  "URL":"https://hansard.parliament.uk/Commons/2013-04-24/debates/13042449000029/VATOnToastedSandwiches"}}'

### Example 4: TrouserPress

TrouserPress is an online hosted blogging platform. It's increasingly being used for Science Communication. Every time someone publishes a post that cites a DOI it will send a link to the URL of the blog post. Its source token is `d9a177bd-9906-4244-864d-1fb83d8c58ed`.

In this example, the given TrouserPress article discusses the DOI.

    $ curl "https://bus.eventdata.crossref.org/events" \
       --verbose \
       -H "Content-Type: application/json" \
       -H "Authorization: Token token=22810d9a-8fae-4905-8d0d-ac7b98731646" \
       -X POST \
       --data '{"id": "baa93bc4-c832-4e19-aaac-d52ad827843a",
                "source_token": "d9a177bd-9906-4244-864d-1fb83d8c58ed",
                "subj_id": "http://trouser.press/jim/my-favourite-dois",
                "obj_id": "http://doi.org/10.3403/30164641u",
                "occurred_at": "2013-03-24T00:00:00Z",
                "relation_type_id": "discusses",
                "source_id": "trouser_press",
                "license: "https://creativecommons.org/publicdomain/zero/1.0/",
                "subj":{
                  "title":"My Top 10 DOIs",
                  "author": "Jim",
                  "issued":"2013-03-24",
                  "URL":"http://trouser.press/jim/my-favourite-dois"}}'
