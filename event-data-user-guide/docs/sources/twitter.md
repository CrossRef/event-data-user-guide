# Twitter

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