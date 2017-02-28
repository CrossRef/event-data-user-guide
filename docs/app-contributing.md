# Appendix: Contributing to Event Data

We welcome new Data Sources. Using the Lagotto Deposit API, third parties can easily push Events. We run a Sandbox instance for developers to work with and for integration testing. Please review the [API section](#using-the-api) for familiarity with the Deposit format. The [API is documented using Swagger](http://api.eventdata.crossref.org/api).

### Preparation

We would love to help you develop your Push Source.

 1. Contact us at eventdata@crossref.org to discuss your source. 
 1. Decide what kind of Relation Types best describe your data.
 1. Decide if your source supplies pre-aggregated or individual Events.

### Tokens

 1. Sign in at [http://sandbox.api.eventdata.crossref.org](http://sandbox.api.eventdata.crossref.org).
 1. Email eventdata@crossref.org and we will enable your account for Push API access. Pushes won't work until we do this.
 1. Click on your name, select 'your account'. Copy your API key. You will use this to authenticate all of your push requests.
 1. Create a UUID for your agent. You can use your a GUID library of your choice or a service like [uuidgenerator.net](https://www.uuidgenerator.net/). This will be your Source Token, and will uniquely identify your agent. Don't re-use this for another agent.

### Format

 1. One HTTP POST is made per deposit. The payload should be in JSON format, with the `Content-Type: application/json` header.
 1. Authentication using your token should use the header: `Authorization: Token token=«your-token»`.
 1. A Event is expressed as a Subject, Object, Relation Type, Total and Date. 
    1. The Subject, `subj_id` must be a URL. It can be a DOI or a web page.  
    1. The Object, `subj_id` must be a URL. It is usually a DOI.
    1. The Total can be omitted, and it defaults to 1. For cases where the Deposit corresponds to countable information, you can supply an integer. 
    1. If the Subject or Object is a DOI, CED will automatically look up the metadata. If not, you must supply minimal metadata as `subject` or `object` respectively.
 1. Create a UUID for your Deposit. Every deposit must have a unique UUID.

### Sending Data

 1. Send your Deposit by POSTing to [`http://sandbox.api.eventdata.crossref.org/api/deposits`](http://sandbox.api.eventdata.crossref.org/api/deposits)
 1. You will receive a 202 on success or a 400 on failure. 
 1. You can check on the status of your deposit by visiting `http://sandbox.api.eventdata.crossref.org/api/deposits/«deposit-id»`
 1. Deposits will usually be processed within a few minutes. When the status changes from `waiting` to `done`, it has been fully processed. If there is an error processing, it will read `failed`.

### Ready to go!

 1. When you are happy with your Agent, let us know and we will enable it in the Production service.
 1. Switch over from the Staging Environment, `staging.api.eventata.crossref.org` to the Production Environment, `api.eventdata.crossref.org`
 1. Enable your agent, push historical deposits if necessary, and start pushing new data!

## Examples

Here are some worked examples using cURL.

### Example 1: Bigipedia

Bigipedia is an online Encyclopedia. It cites DOIs in its reference list for its articles. Its source token is `b1bba157-ab5b-4cb8-9ac8-4beb2d6405ff`. Bigipedia will tell CED every time a DOI is cited, and will send data every time a citation is added.

In this example, Bigipedia informs us that the DOI is referenced by the article page. Note that because the subject is not a DOI, the metadata must be supplied in the `subj` key. 

    $ curl "http://sandbox.api.eventdata.crossref.org/api/deposits" \
           --verbose \
           -H "Content-Type: application/json" \
           -H "Authorization: Token token=591df7a9-5b32-4f1a-b23c-d54c19adf3fe" \
           -X POST \
           --data '{"deposit": {"uuid": "dbba925e-b47c-4732-a27b-0063040c079d",
                                "source_token": "b1bba157-ab5b-4cb8-9ac8-4beb2d6405ff",
                                "subj_id": "http://bigipedia.com/pages/Chianto",
                                "obj_id": "http://doi.org/10.3403/30164641u",
                                "relation_type_id": "references",
                                "source_id": "bigipedia",
                                "subj": {"title": "Chianto",
                                            "issued": "2016-01-02",
                                             "URL": "http://bigipedia.com/pages/Chianto"}}}'

Response:

    HTTP/1.1 202 Accepted

    {"meta":
      {"status":"accepted",
       "message-type":"deposit",
       "message-version":"v7"},
       "deposit":{
         "id":"dbba925e-b47c-4732-a27b-0063040c079d",
         "state":"waiting",
         "message_type":"relation",
         "message_action":"create",
         "source_token":"b1bba157-ab5b-4cb8-9ac8-4beb2d6405ff",
         "subj_id":"http://bigipedia.com/pages/Chianto",
         "obj_id":"http://doi.org/10.3403/30164641u",
         "relation_type_id":"references",
         "source_id":"bigipedia",
         "total":1,
         "occurred_at":"2016-04-19T15:26:02Z",
         "timestamp":"2016-04-19T15:26:02Z",
         "subj":{
            "title":"Chianto",
            "issued":"2016-01-02",
            "URL":"http://bigipedia.com/pages/Chianto"},
          "obj":{}}}

You would be able to check on the status at `http://sandbox.api.eventdata.crossref.org/api/deposits/dbba925e-b47c-4732-a27b-0063040c079d`

### Example 2: DOI Remember

DOI Remember is a bookmarking service for DOIs. DOI Remember will tell CED how many times each DOI is cited. Every day it will send data for every DOI, stating how many times it is currently bookmarked. Its source token is `366273b5-d3d8-488b-afdc-940bcd0b9b87`.

In this example, DOI Remember tells that as of the 1st of March 2016, 922 people have bookmarked the given DOI. The Subject is the 'DOI Remember' source as a whole. As its URL is not a DOI, subject metadata must be included. CED allows for the year `0000-01-01` for the issue date when it's not meaningful to provide one.
    
    $ curl "http://sandbox.api.eventdata.crossref.org/api/deposits" \
           --verbose \
           -H "Content-Type: application/json" \
           -H "Authorization: Token token=22e49a7c-5edd-4873-a2b2-c541512c933a" \
           -X POST \
           --data '{"deposit": {"uuid": "c06fc051-5e29-4cd3-b46a-652c646a3582",
                                "source_token": "366273b5-d3d8-488b-afdc-940bcd0b9b87",
                                "subj_id": "http://doiremember.com",
                                "obj_id": "http://doi.org/10.3403/30164641u",
                                "total": 922,
                                "occurred_at": "2016-03-01",
                                "relation_type_id": "bookmarks",
                                "source_id": "doi_remember",
                                "subj":{
                                  "title":"DOI Remember",
                                  "issued":"0000-01-01",
                                  "URL":"http://doiremember.com"}}}'

### Example 3: Hansard Watch

Hansard Watch is a service that monitors the UK House of Commons and sends an event every time a DOI is mentioned in Parliament. Every time it finds a new DOI mention it will send a link to the URL of the online Hansard page. Its source token is `a8d4efa6-868b-4230-9685-74b6c7c192bf`.

In this example, the given Hansard page discusses the given DOI. It has a publication date.

    $ curl "http://sandbox.api.eventdata.crossref.org/api/deposits" \
       --verbose \
       -H "Content-Type: application/json" \
       -H "Authorization: Token token=b832bf3a-f5ca-4435-9a2b-09fec0f313a6" \
       -X POST \
       --data '{"deposit": {"uuid": "16acd857-82b8-493c-8e79-6ac0a67ce53b",
                            "source_token": "a8d4efa6-868b-4230-9685-74b6c7c192bf",
                            "subj_id": "https://hansard.parliament.uk/Commons/2013-04-24/debates/13042449000029/VATOnToastedSandwiches",
                            "obj_id": "http://doi.org/10.3403/30164641u",
                            "occurred_at": "2013-03-24",
                            "relation_type_id": "discusses",
                            "source_id": "hansard_watch",
                            "subj":{
                              "title":"Previous VAT on toasted sandwiches",
                              "issued":"2013-03-24",
                              "URL":"https://hansard.parliament.uk/Commons/2013-04-24/debates/13042449000029/VATOnToastedSandwiches"}}}'

### Example 4: TrouserPress

TrouserPress is an online hosted blogging platform. It's increasingly being used for Science Communication. Every time someone publishes a post that cites a DOI it will send a link to the URL of the blog post. Its source token is `d9a177bd-9906-4244-864d-1fb83d8c58ed`.

In this example, the given TrouserPress article discusses the DOI.

    curl "http://sandbox.api.eventdata.crossref.org/api/deposits" \
       --verbose \
       -H "Content-Type: application/json" \
       -H "Authorization: Token token=22810d9a-8fae-4905-8d0d-ac7b98731646" \
       -X POST \
       --data '{"deposit": {"uuid": "baa93bc4-c832-4e19-aaac-d52ad827843a",
                            "source_token": "d9a177bd-9906-4244-864d-1fb83d8c58ed",
                            "subj_id": "http://trouser.press/jim/my-favourite-dois",
                            "obj_id": "http://doi.org/10.3403/30164641u",
                            "occurred_at": "2013-03-24",
                            "relation_type_id": "discusses",
                            "source_id": "trouser_press",
                            "subj":{
                              "title":"My Top 10 DOIs",
                              "author": "Jim",
                              "issued":"2013-03-24",
                              "URL":"http://trouser.press/jim/my-favourite-dois"}}}'
