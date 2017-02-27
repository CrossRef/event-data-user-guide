# Sources in Depth

[TOC]

The following is a description of the Sources of data available in CED. Every Data Source requires an Agent to process the data, so the following section describes the format of data, the agent used to collect it and issues surrounding each source.

## Crossref to DataCite Links

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | crossref_datacite |
| Consumes Artifacts        | none |
| Matches by                | DOI |
| Produces relation types   | cites |
| Freshness                 | Daily |
| Data Source               | Crossref Metadata API |
| Coverage                  | All DOIs |
| Relevant concepts         | [Occurred-at vs collected-at](concept#concept-timescales), [Duplicate Data](concept#concept-duplicate) |
| Operated by               | Crossref |
| Agent                     | Cayenne |

When members of Crossref (who are mostly Scholarly Publishers) deposit metadata, they can deposit links to datasets via their DataCite DOIs. The Crossref Metadata API monitors these links and sends them to Event Data. As this is an internal system there are no Artifacts as the data comes straight from the source.

### Example Event

    {
      "obj_id":"https://doi.org/10.13127/ITACA/2.1",
      "occurred_at":"2016-08-19T20:30:00Z",
      "subj_id":"https://doi.org/10.1007/S10518-016-9982-8",
      "total":1,
      "id":"71e62cbd-28a8-4a41-9b74-7e58dca03efc",
      "message_action":"create",
      "source_id":"crossref_datacite",
      "timestamp":"2016-08-19T22:14:33Z",
      "relation_type_id":"cites"
    }

### Methodology

 - The Metadata API scans incoming Content Registration items and when it finds links to DataCite DOIs, it adds the Events to CED.
 - It can also scan back-files for links.

### Notes

 - Because the Agent can scan for back-files, it is possible that duplicate Events may be re-created. See [Duplicate Data](concept#concept-duplicate).
 - Because the Agent can scan for back-files, Events may be created with `occurred_at` in the past. See [Occurred-at vs collected-at](concept#concept-timescales).



## DataCite to CrossRef Links

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | datacite_crossref |
| Consumes Artifacts        | none |
| Matches by                | DOI |
| Produces relation types   | cites |
| Fields in Evidence Record | no evidence record |
| Freshness                 | daily |
| Data Source               | DataCite API |
| Coverage                  | All DOIs |
| Relevant concepts         | [External Agents](#contept-external-agent), [Occurred-at vs collected-at](concept#concept-timescales) |
| Operated by               | DataCite |

When members of DataCite deposit datasets, they can include links to Crossref Registered Content via their Crossref DOIs. The DataCite agent monitors these links and sends them to Event Data. As this is an External Agent, there are no Artifacts or Evidence Records.

### Example Event

    {
      "obj_id":"https://doi.org/10.1007/S10518-016-9982-8",
      "occurred_at":"2016-08-19T20:30:00Z",
      "subj_id":"https://doi.org/10.13127/ITACA/2.1",
      "total":1,
      "id":"71e62cbd-28a8-4a41-9b74-7e58dca03efc",
      "message_action":"create",
      "source_id":"datacite_crossref",
      "timestamp":"2016-08-19T22:14:33Z",
      "relation_type_id":"cites"
    }

### Methodology

 - DataCite operate an Agent that scans its Metadata API for new citations to Crossref DOIs. When it finds links, it deposits them.
 - It can also scan for back-files

### Notes

 - Because the Agent can scan for back-files, it is possible that duplicate Events may be re-created. See [Duplicate Data](concept#concept-duplicate).
 - Because the Agent can scan for back-files, Events may be created with `occurred_at` in the past. See [Occurred-at vs collected-at](concept#concept-timescales).



## Facebook

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
| Relevant concepts         | [Unambiguously linking URLs to DOIs](concept#concept-urls), [Individual Events vs Pre-Aggregated](concept#concept-individual-aggregated), [Sources that must be queried once per Item](concept#concept-once-per-item) |
| Operated by               | Crossref |
| Agent                     | event-data-facebook-agent |

The Facebook Data Source polls Facebook for Items via their Landing Page URLs. It records how many 'likes' a given Item has received at that point in time, via its Landing Page URL. A Facebook Event records the current number of Likes an Item has on Facebook at a given point in time. It doesn't record who liked the Item or when then the liked it. See [Individual Events vs Pre-Aggregated](concept#concept-individual-aggregated) for further discussion. The timestamp represents the time at which the query was made. 

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


<!--
## Mendeley

| Property                  | Value          |
|---------------------------|----------------|
| Name                      |  |
| Matches by                | DOI |
| Consumes Artifacts        | `high-dois`, `medium-dois`, `all-dois` |
| Produces relation types   |  |
| Fields in Evidence Record |  |
| Freshness                 |  |
| Data Source               |  |
| Coverage                  |  |
| Relevant concepts         | [Matching by DOIs](concept#concept-matching-dois), [External Parties Matching Content to DOIs](concept#concept-external-doi-mappings), [Individual Events vs Pre-Aggregated](concept#concept-individual-aggregated), [Sources that must be queried once per Item](concept#concept-once-per-item) |
| Operated by               |  |
| Agent                     |  |

The Mendeley Agent polls Mendeley for every DOI and records the `reader_count` and `group_count` numbers. A Mendeley Event Data record should be read as 'As of this date this Item has this many readers' or 'as of this date this Item is in this many groups'.


### Example Event

TODO

### Example Evidence Record

TODO
-->

### Methodology

1. The Mendeley agent consumes three Artifacts: `high-dois`, `medium-dois` and `all-dois`. It runs a three parallel processes, one per list.
2. For each list, the agent fetches the most recent version of the Artifact.
3. It scans over the entire list, making one query per DOI.
4. For each Item for which there is data, two Event is created with total values. The `reader_count` total is stored in an event with `relation_type_id` of `bookmarks`. The `group_count` total is stored in an event with the `relation_type_id` of `likes`.
4. When it has finished the list, it starts again at step 1.

### Further information

 - [Mendeley API Documentation](http://dev.mendeley.com/methods/)



## Newsfeed

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | `newsfeed` |
| Matches by                | Landing Page URL |
| Consumes Artifacts        | `newsfeed-list` |
| Produces relation types   | `mentions` |
| Fields in Evidence Record |  |
| Freshness                 | half-hourly |
| Data Source               | Multiple blog and aggregator RSS feeds |
| Coverage                  | All DOIs |
| Relevant concepts         | [Unambiguously linking URLs to DOIs](concept#concept-urls), [Duplicate Data](concept#concept-duplicate), [Landing Page Domains](concept#concept-landing-page-domains), [Sources that must be queried in their entirety](concept#concept-query-entirety), [DOI Reversal Service](concept#in-depth-doi-reversal) |
| Operated by               | Crossref |
| Agent                     | event-data-newsfeed-agent |

The Newsfeed agent monitors RSS and Atom feeds from blogs and blog aggregators. Crossref maintains a list of newsfeeds, including

 - ScienceSeeker blog aggregator
 - ScienceBlogging blog aggregator
 - BBC News

You can see the latest version of the newsfeed-list by using the Evidence Service: [http://evidence.eventdata.crossref.org/artifacts/newsfeed-list/current](http://evidence.eventdata.crossref.org/artifacts/newsfeed-list/current). 


#### Example Event


    {
      obj_id: "https://doi.org/10.1145/2933057.2933107",
      occurred_at: "2016-09-26T00:25:08Z",
      subj_id: "https://rjlipton.wordpress.com/2016/09/25/a-creeping-model-of-computation/",
      total: 1,
      id: "170678af-92da-4375-967c-b056d828525d",
      subj: {
        pid: "https://rjlipton.wordpress.com/2016/09/25/a-creeping-model-of-computation/",
        title: "A Creeping Model Of Computation",
        issued: "2016-09-26T00:25:08.000Z",
        URL: "https://rjlipton.wordpress.com/2016/09/25/a-creeping-model-of-computation/",
        type: "post-weblog"
      },
      message_action: "create",
      source_id: "newsfeed",
      timestamp: "2016-09-26T00:30:18Z",
      relation_type_id: "discusses"
    },

#### Example Evidence Record

[http://archive.eventdata.crossref.org/evidence/54bb341977cb2ed8906c5be25dd48cbc](http://archive.eventdata.crossref.org/evidence/54bb341977cb2ed8906c5be25dd48cbc)

    {
      "artifacts": [
        "http://evidence.eventdata.crossref.org/artifacts/newsfeed-list/versions/41ac1c7ecf505785411b0e0b498c4cef",
        "http://evidence.eventdata.crossref.org/artifacts/domain-list/versions/1b2bcc1f6e77196b9b40be238675101c"
      ],
      "input": {
        "newsfeed-url": "http://www.inoreader.com/stream/user/1005830516/tag/Artificial%20Intelligence%2C%20Computer%20Science",
        "blog-urls": [
          "https://rjlipton.wordpress.com/2016/09/25/a-creeping-model-of-computation/",
          "http://feedproxy.google.com/~r/blogspot/wCeDd/~3/pY5hWW0nwXM/sunday-morning-video-bay-area-deep.html",
          « ... removed ... »
        ],
        "blog-urls-seen": [
          {
            "seen-before": true,
            "seen-before-date": "2016-09-25T15:59:24.000Z",
            "seen-before-feed": "http://www.inoreader.com/stream/user/1005830516/tag/Artificial%20Intelligence%2C%20Computer%20Science",
            "url": "http://feedproxy.google.com/~r/blogspot/wCeDd/~3/pY5hWW0nwXM/sunday-morning-video-bay-area-deep.html"
          },
          « ... removed ... »
        ],
        "blog-urls-unseen": [
          "https://rjlipton.wordpress.com/2016/09/25/a-creeping-model-of-computation/"
        ]
      },
      "processing": {
        "https://rjlipton.wordpress.com/2016/09/25/a-creeping-model-of-computation/": {
          "data": {
            "seen-before": false,
            "seen-before-date": null,
            "seen-before-feed": null,
            "url": "https://rjlipton.wordpress.com/2016/09/25/a-creeping-model-of-computation/",
            "blog-item": {
              "title": "A Creeping Model Of Computation",
              "link": "https://rjlipton.wordpress.com/2016/09/25/a-creeping-model-of-computation/",
              "id": "http://www.inoreader.com/article/3a9c6e7f83b41e90",
              "updated": "2016-09-26T00:25:08.000Z",
              "summary": "<p><br><em>Local rules can achieve global behavior</em><br> « ... removed ... »</p>",
              "feed-url": "http://www.inoreader.com/stream/user/1005830516/tag/Artificial%20Intelligence%2C%20Computer%20Science",
              "fetch-date": "2016-09-26T00:29:20.616Z"
            }
          },
          "dois": [
            "10.1145/2933057.2933107"
          ],
          "url-doi-matches": {
            "http://arxiv.org/abs/1603.07991": {
              "doi": "10.1145/2933057.2933107",
              "version": null
            }
          }
        }
      },
      "deposits": [
        {
          "obj_id": "https://doi.org/10.1145/2933057.2933107",
          "source_token": "c1bfb47c-39b8-4224-bb18-96edf85e3f7b",
          "occurred_at": "2016-09-26T00:25:08.000Z",
          "subj_id": "https://rjlipton.wordpress.com/2016/09/25/a-creeping-model-of-computation/",
          "action": "added",
          "subj": {
            "title": "A Creeping Model Of Computation",
            "issued": "2016-09-26T00:25:08.000Z",
            "pid": "https://rjlipton.wordpress.com/2016/09/25/a-creeping-model-of-computation/",
            "URL": "https://rjlipton.wordpress.com/2016/09/25/a-creeping-model-of-computation/",
            "type": "post-weblog"
          },
          "uuid": "170678af-92da-4375-967c-b056d828525d",
          "source_id": "newsfeed",
          "relation_type_id": "discusses"
        }
      ]
    }



### Methodology

 - Every hour, the latest 'newsfeed-list' Artifact is retrieved.
 - For every feed URL in the list, the agent queries the newsfeed to see if there are any new blog posts.
 - The content of the body in the RSS feed item are inspected to look for DOIs and URLs. The Agent queries the DOI Reversal Service for each URL to try and convert it into a DOI.
 - The URL of the blog post is retrieved and the body is inspected to look for DOIs and URLs. The Agent queries the DOI Reversal Service for each URL to try and convert it into a DOI.
 - For every DOI found an Event is created with a `relation_type_id` of `mentions`.

### Notes

Because the Newsfeed Agent connects to blogs and blog aggregators, it is possible that the same blog post may be picked up by two different routes. In this case, the same blog post may be reported in more than one event See [Duplicate Data](concept#concept-duplicate).




## Reddit

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | event-data-reddit-agent |
| Matches by                | DOI |
| Consumes Artifacts        | `domain-list` |
| Produces relation types   | `discusses` |
| Freshness                 | Polling approximately every 30 minutes |
| Data Source               | Reddit API |
| Coverage                  | All landing page URLs and DOI URLs |
| Relevant concepts         | [Unambiguously linking URLs to DOIs](#concept-urls), [Pre-filtering](#pre-filtering) |
| Operated by               | Crossref |
| Agent                     | event-data-reddit-agent |

The Reddit agent queries the Reddit API for each domain in the Landing Page Domain list. It finds discussions and comments that mention Items via their landing pages or DOIs.

### Methodology

1. The Reddit agent runs a loop, with a delay of a 30 minutes between runs. 
2. The most recent `domain-list` Artifact is fetched at the start of each loop.
3. During the loop, for each domain in the `domain-list`
   1. The Agent requests all data for the domain, ordered by date descending.
   2. The Agent continues fetching pages of results until it finds inputs it has seen before.
   3. The Agent looks at every result. Where it has not seen a link before, it tries to reverse it to an Item DOI.
   4. Where an Item is found, an Event is created.

### Example Event

    {
      "obj_id": "https://doi.org/10.1523/JNEUROSCI.1907-16.2016",
      "occurred_at": "2016-09-25T16:59:52Z",
      "subj_id": "https://reddit.com/r/science/comments/54fyzt/many_supposed_features_of_alzheimers_are/",
      "total": 1,
      "id": "7cc890a6-ca68-4d7c-8853-fb243aa59279",
      "subj": {
        "pid": "https://reddit.com/r/science/comments/54fyzt/many_supposed_features_of_alzheimers_are/",
        "title": "Many supposed features of Alzheimers are artifacts of the mouse models used. The findings of over 3000 publications may need to be re-evaluated.",
        "issued": "2016-09-25T16:59:52.000Z",
        "URL": "https://reddit.com/r/science/comments/54fyzt/many_supposed_features_of_alzheimers_are/",
        "type": "post"
      },
      "message_action": "create",
      "source_id": "reddit",
      "timestamp": "2016-09-25T20:31:36Z",
      "relation_type_id": "discusses"
    }


### Example Evidence Record

[http://evidence.eventdata.crossref.org/events/7cc890a6-ca68-4d7c-8853-fb243aa59279/evidence](http://evidence.eventdata.crossref.org/events/7cc890a6-ca68-4d7c-8853-fb243aa59279/evidence)

    {
      "agent": {
        "name": "reddit",
        "version": "0.1.1"
      },
      "run": "2016-09-25T20:24:01.392Z",
      "artifacts": [
        "http://evidence.eventdata.crossref.org/artifacts/domain-list/versions/1b2bcc1f6e77196b9b40be238675101c"
      ],
      "input": {
        "https://oauth.reddit.com/domain/www.jneurosci.org/new.json?sort=new&after=": {
          "after-token": "t3_46qn9t",
          "items": [
            {
              "url": "http://www.jneurosci.org/content/36/38/9933.abstract?etoc",
              "id": "54fyzt",
              "title": "Many supposed features of Alzheimers are artifacts of the mouse models used. The findings of over 3000 publications may need to be re-evaluated.",
              "permalink": "/r/science/comments/54fyzt/many_supposed_features_of_alzheimers_are/",
              "created_utc": 1474822792,
              "subreddit": "science",
              "kind": "t3"
            },
            « ... removed ... »
          ]
        }
      },
      "processing": {
        "items": [
          {
            "url": "http://www.jneurosci.org/content/36/38/9933.abstract?etoc",
            "id": "54fyzt",
            "title": "Many supposed features of Alzheimers are artifacts of the mouse models used. The findings of over 3000 publications may need to be re-evaluated.",
            "permalink": "/r/science/comments/54fyzt/many_supposed_features_of_alzheimers_are/",
            "created_utc": 1474822792,
            "subreddit": "science",
            "kind": "t3",
            "seen-before-date": null,
            "url-doi-match": {
              "doi": "10.1523/jneurosci.1907-16.2016",
              "version": null,
              "query": "http://www.jneurosci.org/content/36/38/9933.abstract?etoc"
            }
          },
          « ... removed ... »
        ],
        "interested-items": [
          {
            "url": "http://www.jneurosci.org/content/36/38/9933.abstract?etoc",
            "id": "54fyzt",
            "title": "Many supposed features of Alzheimers are artifacts of the mouse models used. The findings of over 3000 publications may need to be re-evaluated.",
            "permalink": "/r/science/comments/54fyzt/many_supposed_features_of_alzheimers_are/",
            "created_utc": 1474822792,
            "subreddit": "science",
            "kind": "t3",
            "seen-before-date": null,
            "url-doi-match": {
              "doi": "10.1523/jneurosci.1907-16.2016",
              "version": null,
              "query": "http://www.jneurosci.org/content/36/38/9933.abstract?etoc"
            }
          }
        ]
      },
      "deposits": [
        {
          "source_token": "a6c9d511-9239-4de8-a266-b013f5bd8764",
          "uuid": "7cc890a6-ca68-4d7c-8853-fb243aa59279",
          "action": "added",
          "subj_id": "https://reddit.com/r/science/comments/54fyzt/many_supposed_features_of_alzheimers_are/",
          "subj": {
            "title": "Many supposed features of Alzheimers are artifacts of the mouse models used. The findings of over 3000 publications may need to be re-evaluated.",
            "issued": "2016-09-25T16:59:52.000Z",
            "pid": "https://reddit.com/r/science/comments/54fyzt/many_supposed_features_of_alzheimers_are/",
            "URL": "https://reddit.com/r/science/comments/54fyzt/many_supposed_features_of_alzheimers_are/",
            "type": "post"
          },
          "source_id": "reddit",
          "relation_type_id": "discusses",
          "obj_id": "https://doi.org/10.1523/jneurosci.1907-16.2016",
          "occurred_at": "2016-09-25T16:59:52.000Z"
        }
      ]
    }
    
### Twitter

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | twitter |
| Matches by                | DOI |
| Consumes Artifacts        | `domain-list`, `doi-prefix-list` |
| Produces relation types   | `discusses` |
| Freshness                 | continual |
| Data Source               | Twitter via Gnip |
| Coverage                  | All DOIs, all known Landing Pages |
| Relevant concepts         | [Pre-filtering](#pre-filtering) |
| Operated by               | Crossref |
| Agent                     | event-data-twitter-agent |

The Twitter source identifies Items that have been mentioned in Tweets. It matches Items using their Landing Page or DOI URL. Each event contains subject metadata including:

 - tweet author ID
 - tweet id
 - tweet type (tweet or retweet)
 - tweet publication date

When Items are matched using their Landing Page URL the URL Reversal Service is used.

#### Methodology

 1. On a periodic basis (approximately every 24 hours) the most recent version of the `domain-list` Artifact is retrieved. A set of Gnip PowerTrack rules are compiled and sent to Gnip. The list of rules specifies that Gnip should send all tweets that:
   1. Mention a DOI URL
   2. Mention a URL that uses an article Landing Page domain
   3. Contain a DOI prefix, e.g. `10.5555`
 2. The Twitter agent connects to Gnip PowerTrack.
 3. All Tweets that the agent recieves from PowerTrack have been sent because they match a rule. Gnip also extracts all URLs and follows them to their destination. All URLs extracted and sent along with the data for the Tweet.
 4. The Agent attempts to reverse every URL using the DOI Reversal Service. For every recognised DOI an Event is created.

#### Example Event

    {
      "obj_id": "https://doi.org/10.1038/nature19798",
      "occurred_at": "2016-09-26T15:23:13.000Z",
      "subj_id": "http://twitter.com/randomshandom/statuses/780427511956180992",
      "total": 1,
      "id": "35ec2a67-a765-4f26-9c37-7f9eb9a1c7a8",
      "subj": {
        "pid": "http://twitter.com/randomshandom/statuses/780427511956180992",
        "author": {
          "literal": "http://www.twitter.com/randomshandom"
        },
        "issued": "",
        "URL": "http://twitter.com/randomshandom/statuses/780427511956180992",
        "type": "tweet"
      },
      "message_action": "create",
      "source_id": "twitter",
      "timestamp": "2016-09-26T15:23:13.000Z",
      "relation_type_id": "discusses"
    }

#### Example Evidence Record

[http://archive.eventdata.crossref.org/evidence/87d7ab90d497198f74d7b46d67faca15](http://archive.eventdata.crossref.org/evidence/87d7ab90d497198f74d7b46d67faca15)

    {
      artifacts: [
        "http://evidence.eventdata.crossref.org/artifacts/domain-list/versions/1b2bcc1f6e77196b9b40be238675101c",
        "http://evidence.eventdata.crossref.org/artifacts/doi-prefix-list/versions/797e77470ed94b2f7b336adab4cbaf19"
      ],
      input: {
        tweet-url: "http://twitter.com/randomshandom/statuses/780427511956180992",
        author: "http://www.twitter.com/randomshandom",
        posted-time: "2016-09-26T15:23:13.000Z"
      urls: [
        "http://www.nature.com/nature/journal/vaop/ncurrent/full/nature19798.html"
      ],
      matching-rules: [
        "url_contains:"//www.nature.com/""
      ]
    },
    agent: {
      name: "twitter",
      version: "0.1.2"
    },
    working: {
      matching-rules: [
      "url_contains:"//www.nature.com/""
      ],
      matching-dois: [
      {
        doi: "10.1038/nature19798",
        version: null,
        query: "http://www.nature.com/nature/journal/vaop/ncurrent/full/nature19798.html"
      }
      ],
      match-attempts: [
      {
        doi: "10.1038/nature19798",
        version: null,
        query: "http://www.nature.com/nature/journal/vaop/ncurrent/full/nature19798.html"
      }
      ],
      original-tweet-author: null,
      original-tweet-url: "http://twitter.com/randomshandom/statuses/780427511956180992"
      },
      deposits: [
      {
      obj_id: "https://doi.org/10.1038/nature19798",
        source_token: "45a1ef76-4f43-4cdc-9ba8-5a6ad01cc231",
        occurred_at: "2016-09-26T15:23:13.000Z",
        subj_id: "http://twitter.com/randomshandom/statuses/780427511956180992",
        action: "add",
        subj: {
        author: {
          literal: "http://www.twitter.com/randomshandom"
        },
        issued: "2016-09-26T15:23:13.000Z",
        pid: "http://twitter.com/randomshandom/statuses/780427511956180992",
        URL: "http://twitter.com/randomshandom/statuses/780427511956180992",
        type: "tweet"
      },
      uuid: "35ec2a67-a765-4f26-9c37-7f9eb9a1c7a8",
      source_id: "twitter",
        relation_type_id: "discusses"
      }
      ]
    }



## Wikipedia

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | Wikipedia |
| Matches by                | DOI |
| Consumes Artifacts        |  |
| Produces relation types   | `references` |
| Freshness                 | continual |
| Data Source               | Wikipedia Recent Changes Stream, Wikipedia RESTBase |
| Coverage                  | All Wikimedia properties. DOI URL references only. |
| Relevant concepts         | [Matching by DOIs](#concept-matching-dois)|
| Operated by               | Crossref |
| Agent                     | event-data-wikipedia-agent |

### Methodology

1. The agent subscribes to the Recent Changes Stream using the wildcard "`*`". This includes all Wikimedia properties. 
2. The Recent Changes Stream server sends the Agent every change to a page. Every change event includes the page title, the old and new revision and other data.
3. For every change, the Agent fetches the HTML of the old and the new pages using the RESTBase API.
    1. For every URL in the old version, the Agent looks for those that are DOI URLs.
    2. For every URL in the new version, the Agent looks for those that are DOI URLs.
4. DOIs are split into those that were added and those that were removed.
    1. For every DOI that was removed an Event with the `action: "delete"` is produced.
    2. For every DOI that was added an Event with the `action: "add"` is produced.


### Example Event

    {
      obj_id: "https://doi.org/10.1093/EMBOJ/20.15.4132",
      occurred_at: "2016-09-25T23:58:58Z",
      subj_id: "https://es.wikipedia.org/wiki/Se%C3%B1alizaci%C3%B3n_paracrina",
      total: 1,
      id: "d24e5449-7835-44f4-b7e6-289da4900cd0",
      subj: {
        pid: "https://es.wikipedia.org/wiki/Se%C3%B1alizaci%C3%B3n_paracrina",
        title: "Señalización paracrina",
        issued: "2016-09-25T23:58:58.000Z",
        URL: "https://es.wikipedia.org/wiki/Se%C3%B1alizaci%C3%B3n_paracrina",
        type: "entry-encyclopedia"
      },
      message_action: "create",
      source_id: "wikipedia",
      timestamp: "2016-09-26T00:03:52Z",
      relation_type_id: "references"
    }

### Example Evidence Record

[http://archive.eventdata.crossref.org/evidence/d8043c407165bd3e07d11c5ca0d74955](http://archive.eventdata.crossref.org/evidence/d8043c407165bd3e07d11c5ca0d74955)

    {
      artifacts: [ ],
      agent: {
        name: "wikipedia",
        version: "0.1.5"
      },
      input: {
        stream-input: {
          bot: false, user: "J3D3",
          id: 133112611,
          timestamp: 1474847938,
          wiki: "eswiki",
          revision: {
            new: 93906371, old: 93391161
          },
          server_script_path: "/w",
          minor: false,
          server_url: "https://es.wikipedia.org",
          server_name: "es.wikipedia.org",
          length: {
            new: 51542, old: 51700
          },
          title: "Señalización paracrina",
          type: "edit",
          namespace: 0,
          comment: "Traduciendo otra pequeña parte"
        },
        old-revision-id: 93391161,
        new-revision-id: 93906371,
        old-body: "<!DOCTYPE html> <html prefix="dc: http://purl.org/dc/terms/ mw: http://mediawiki.org/rdf/" about="http://es.wikipedia.org/wiki/Special:Redirect/revision/93391161">« ... removed ... »</html>",
        new-body: "<!DOCTYPE html> <html prefix="dc: http://purl.org/dc/terms/ mw: http://mediawiki.org/rdf/" about="http://es.wikipedia.org/wiki/Special:Redirect/revision/93906371">« ... removed ... »</html>"
      },
      processing: {
        canonical: "https://es.wikipedia.org/wiki/Se%C3%B1alizaci%C3%B3n_paracrina",
        dois-added: [
        « ... removed ... »
        {
          action: "add",
          doi: "10.1016/S1097-2765(01)00421-X",
          event-id: "48de8c32-a901-4cc5-b911-544c959332f5"
        }
      ],
      dois-removed: [ ]
      },
        deposits: [
        « ... removed ... »
        {
          obj_id: "https://doi.org/10.1016/s1097-2765(01)00421-x",
          source_token: "36c35e23-8757-4a9d-aacf-345e9b7eb50d",
          occurred_at: "2016-09-25T23:58:58.000Z",
          subj_id: "https://es.wikipedia.org/wiki/Se%C3%B1alizaci%C3%B3n_paracrina",
          action: "add",
          subj: {
            title: "Señalización paracrina",
            issued: "2016-09-25T23:58:58.000Z",
            pid: "https://es.wikipedia.org/wiki/Se%C3%B1alizaci%C3%B3n_paracrina",
            URL: "https://es.wikipedia.org/wiki/Se%C3%B1alizaci%C3%B3n_paracrina",
            type: "entry-encyclopedia"
          },
          uuid: "48de8c32-a901-4cc5-b911-544c959332f5",
          source_id: "wikipedia",
          relation_type_id: "references"
        }
      ]
    }

### Failure modes

 - The stream has no catch-up. If the agent is disconnected (which can happen from time to time), then edit events may be missed.
 - The RESTBase API occasionally does not contain the edit mentioned in the change. Although the Agent will retry several times, if it repeatedly receives an error for retriving either the old or the new versions, no event will be returned. This will be recorded in the Evidence Record as an empty input.

<!---


## Wordpress.com

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | `wordpressdotcom` |
| Matches by                | DOI |
| Consumes Artifacts        |  |
| Produces relation types   |  |
| Fields in Evidence Record |  |
| Freshness                 |  |
| Data Source               |  |
| Coverage                  |  |
| Relevant concepts         | [Pre-filtering](#pre-filtering) |
| Operated by               |  |
| Agent                     |  |

The Wordpress.com agent queries the Wordpress.com API for Landing Page Domains. It monitors blogs hosted on Wordpress.com that mention articles by their landing page or by DOI URL.

### Example Event

TODO

### Example Evidence Record

TODO

### Methodology

TODO

note not all Wordpress

### Further information

TODO

-->
