# Reddit

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