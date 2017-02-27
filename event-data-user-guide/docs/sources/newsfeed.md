# Newsfeed

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


