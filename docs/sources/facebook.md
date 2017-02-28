# Facebook

> *NB: The Facebook source is not currently running.*

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | Facebook |
| Matches by                | Landing Page URL |
| Consumes Artifacts        | `high-urls`, `medium-urls`, `all-urls` |
| Produces relation types   | `bookmarks`, `shares` |
| Fields in Evidence Record | Complete API response |
| Freshness                 | Three schedules |
| Data Source               | Facebook API |
| Coverage                  | All DOIs where there is a unique URL mapping |
| Relevant concepts         | [Unambiguously linking URLs to DOIs](concepts#concept-urls), [Individual Events vs Pre-Aggregated](concepts#concept-individual-aggregated), [Sources that must be queried once per Item](concepts#concept-once-per-item) |
| Operated by               | Crossref |
| Agent                     | event-data-facebook-agent |

The Facebook Data Source polls Facebook for Items via their Landing Page URLs. It records how many 'likes' a given Item has received at that point in time, via its Landing Page URL. A Facebook Event records the current number of Likes an Item has on Facebook at a given point in time. It doesn't record who liked the Item or when then the liked it. See [Individual Events vs Pre-Aggregated](concepts#concept-individual-aggregated) for further discussion. The timestamp represents the time at which the query was made. 

Because of the structure of the Facebook API, it is necessary to make one API query per Item, which means that it can take a long time to work through the entire list of Items. This means that, whilst we try and poll as often and regularly as possible, the time between Facebook Events for a given Item can be unpredictable. 

### Freshness

The Facebook Agent uses three categories of Item: `high-urls`, `medium-urls` and `all-urls` (see the [URL Artifact lists documentation](evidence-in-depth#artifact-url-list) for more detail). It processes the three categories in parallel. In each category it scans the current list of all Items with URLs from start to finish, and queries the Facebook API for each one. It does this in a loop, each time fetching the most recent list of URLs.

The Facebook Agent works within rate limits of Facebook API. If the Facebook API indicates that the rate of traffic is too high then the Agent will lower the rate of querying and a complete scan will take longer.

<a name="in-depth-facebook-uris"></a>
### Subject URIs and PIDs

As Facebook Events are pre-aggregated and don't record the relationship between the liker and the Item, Events are recorded against Facebook as a whole. Because we don't expect to collect Events more than once per month per Item, we create an entity that represents Facebook in a given month.

Each 'Facebook Month' is recorded as a separate subject PID, e.g. `https://facebook.com/2016/8`. This PID is a URI and doesn't correspond to an extant URL. Note that the metadata contains the URL of `https://facebook.com`.

This approach strikes the balance between recording data against a consistent Subject whilst allowing easy analysis of numbers on a per-month basis.

If you just want to find 'all the Facebook data for this DOI' remember that you can filter by the `source_id`.

### Example Event

    {
      "obj_id":"https://doi.org/10.1080/13600820802090512",
      "occurred_at":"2016-08-11T00:00:30Z",
      "subj_id":"https://facebook.com/2016/8",
      "total":5681,
      "id":"55492dc1-ce8a-4c5d-85d0-97a5192519c7",
      "subj":{
        "pid":"https:/facebook.com/2016/8",
        "URL":"https://facebook.com",
        "title":"Facebook activity for August 2016",
        "type":"webpage",
        "issued":"2016-08-01"
      },
      "message_action":"create",
      "source_id":"Facebook",
      "timestamp":"2016-08-11T00:26:48Z",
      "relation_type_id":"references"
    }

<!--- 
### Example Evidence Record

An Evidence Record contains one response from a Facebook API. API requests are batched in groups of URLs, up to 50 at a time. Therefore an Evidence Record can result in multiple Events.

TODO
-->

### Landing Page URLs vs DOI URLs in Facebook

Facebook Users may share links to Items two ways: they may link using the DOI URL, or they may link using the Landing Page URL. When a DOI is used, Facebook records and shows the DOI URL but records statistics against the Landing Page URL it resolves to. This means that Facebook doesn't necessarily maintain a one-to-one mapping between URLs and statistics for that URL.

Event Data always uses the Landing page URL when it queries Facebook and never the DOI URL. If a Facebook user shared an Item using its Landing Page URL then there would be no results for the DOI, and if they used the DOI, the statistics would be recorded against the Landing Page anyway.

Here is a justification of the above approach using examples from the Facebook Graph API v2.7. Note that these API results capture a point in time and the same results may not be returned now.

Where a Facebook User has shared an Item using its DOI, Facebook's system resolves the DOI discover the Landing page. In cases where Facebook has seen the DOI URL it is possible to query using it, e.g. `https://graph.facebook.com/v2.7/http://doi.org/10.5555/12345678?access_token=XXXX` gives:

    {
      og_object: {
        id: "10150995451832648",
        title: "Toward a Unified Theory of High-Energy Metaphysics: Silly String Theory",
        type: "website",
        updated_time: "2016-08-25T01:23:00+0000"
      },
      share: {
        comment_count: 0,
        share_count: 3
      },
      id: "http://doi.org/10.5555/12345678"
    }

If we query for the current Landing Page URL for the same Item we see the same results. `https://graph.facebook.com/v2.7/http://psychoceramics.labs.crossref.org/10.5555-12345678.html?access_token=XXXX` gives:

    {
      og_object: {
        id: "10150995451832648",
        title: "Toward a Unified Theory of High-Energy Metaphysics: Silly String Theory",
        type: "website",
        updated_time: "2016-08-25T01:23:00+0000"
      },
      share: {
        comment_count: 0,
        share_count: 3
      },
      id: "http://psychoceramics.labs.crossref.org/10.5555-12345678.html"
    }

Here we see that Facebook considers the DOI URL and the Landing Page to have the same `id` of `10150995451832648`, because the DOI URL redirected to the Landing Page URL.

DOIs can be expressed a number of different ways using different resolvers and protocols, e.g. `http://doi.org/10.5555/12345678`, `https://doi.org/10.5555/12345678`, `http://dx.oi.org/10.5555/12345678`, `https://dx.doi.org/10.5555/12345678`. These may all treated as different URLs by Facebook. Therefore there is no 'canonical' DOI URL from Facebook's point of view. As they all redirect to the same Landing Page, the Landing Page is the only thing that they have in common from Facebook's perspective.

Where a user has shared the Item using its Landing Page, Facebook is not aware of the DOI. In this example, there is data for the Landing Page of an Item: `https://graph.facebook.com/v2.7/http://www.emeraldinsight.com/doi/abs/10.1108/RSR-11-2015-0046?access_token=XXXX`

    {
      og_object: {
       id: "1034517766662581",
        description: "Impact of web-scale discovery on reference inquiryArticle Options and ToolsView: PDFAdd to Marked ListDownload CitationTrack CitationsAuthor(s): Kimberly Copenhaver ( Eckerd College St. Petersburg United States ) Alyssa Koclanes ( Eckerd College St. Petersburg United States )Citation: Kimberly Copen…",
        title: "Impact of web-scale discovery on reference inquiry: Reference Services Review: Vol 44, No 3",
        type: "website",
        updated_time: "2016-06-30T05:01:41+0000"
      },
        share: {
        comment_count: 0,
        share_count: 8
      },
      id: "http://www.emeraldinsight.com/doi/abs/10.1108/RSR-11-2015-0046"
    }

But a Query using its DOI fails `https://graph.facebook.com/v2.7/http://doi.org/10.1108/RSR-11-2015-0046?access_token=XXXX`:

    {
      id: "http://doi.org/10.1108/RSR-11-2015-0046"
    }

Therefore, whilst Facebook returns results for *some* DOIs, we use exclusively use the Landing Page URL to query Facebook for activity. This takes account of users sharing via the DOI and via the Landing Page.

### HTTP and HTTPS in Facebook

Many websites allow users to access the same content over HTTP and HTTPS, and serve up the same content. Whilst the web server may consider the two URLs equal in some way, Facebook doesn't automatically treat HTTPS and HTTP versions of the same URL as equal. The [WHATWG URL Specification](https://url.spec.whatwg.org/#url-equivalence) supports this position.

If we take the example of a website that allows serving of both HTTP and HTTPS content, e.g. The Co-operative Bank, we see that Facebook assigns different OpenGraph IDs and different `share_count` results.

`https://graph.facebook.com/v2.7/http://co-operativebank.co.uk?access_token=XXXX`

    {
      og_object: {
        id: "10150337668163877",
        description: "The Co-operative Bank provides personal banking services including current accounts, credit cards, online and mobile banking, personal loans, savings and more",
        title: "Personal banking | Online banking | Co-op Bank",
        type: "website",
        updated_time: "2016-08-31T14:07:30+0000"
      },
      share: {
        comment_count: 0,
        share_count: 910
      },
      id: "http://co-operativebank.co.uk"
    }

`https://graph.facebook.com/v2.7/https://co-operativebank.co.uk?access_token=XXXX`

    {
      og_object: {
        id: "742866445762882",
        type: "website",
        updated_time: "2014-09-11T17:38:25+0000"
      },
      share: {
        comment_count: 0,
        share_count: 0
      },
      id: "https://co-operativebank.co.uk"
    }

Other sites implement automatic redirects, and an HTTP URL will immediately redirect to an HTTPS version. For example, PLoS HTTP:

`https://graph.facebook.com/v2.7/http://plos.org?access_token=XXXX`

    {
      og_object: {
        id: "393605900711524",
        description: "A Model for an Angular Velocity-Tuned Motion Detector Accounting for Deviations in the Corridor-Centering Response of the Bee",
        title: "PLOS | Public Library Of Science",
        type: "website",
        updated_time: "2016-08-30T18:28:58+0000"
      },
      share: {
        comment_count: 0,
        share_count: 523
      },
      id: "http://plos.org"
    }

And the HTTPS version: 
`https://graph.facebook.com/v2.7/https://plos.org?access_token=XXXX`

    {
      og_object: {
        id: "393605900711524",
        description: "A Model for an Angular Velocity-Tuned Motion Detector Accounting for Deviations in the Corridor-Centering Response of the Bee",
        title: "PLOS | Public Library Of Science",
        type: "website",
        updated_time: "2016-08-30T18:28:58+0000"
      }
      share: {
        comment_count: 0,
        share_count: 523
      },
      id: "https://plos.org"
    }

Note the same `share_count` and `id`.

Therefore Facebook considers HTTP and HTTPS URLs to be equivalent **if** the HTTP site redirects to HTTPS. 

Crossref Event Data uses the Landing Page that the DOI resolved to. If this is HTTP, then we use HTTP, and this means we query Facebook for the same URL that Facebook users share. If the site subsequently adds HTTPS redirects but CED has an outdated HTTP Landing Page URL, the way Facebook treats redirects will ensure we get the correct results. 

If a situation arises where the publisher serves the same Landing Page both over HTTP and HTTPS without redirecting, CED will use the Landing Page URL that the DOI resolves to. This may result in some views not being accounted for, but it is the most accurate and consistent.

### Methodology

The Agent has three parallel processes. They operate on three Artifacts: `high-urls`, `medium-urls` and `all-urls`. The last of these contains the mapping of all known DOI to URL mappings. The first two contain subsets of these.

Each process:

 1. fetches the most recent version of the relevant URL List Artifact
 2. iterates over each the URL. It uses the Facebook Graph API 2.7 to query data for the Landing Page URL.
 3. the `comment_count` is recorded as an Event with the given `total` field and the `relation_type_id` of `shares`.
 4. the `comment_count` is subtracted from the `share_count` and the result is recorded as an Event with the given `total` field and the `relation_type_id` of `bookmarks`.
 5. When the end of the list is reached, it starts again at step 1.


### Further information

 - [Facebook Graph API](https://developers.facebook.com/docs/graph-api)
 - [Facebook CED Agent](https://github.com/crossref/event-data-facebook-agent)

