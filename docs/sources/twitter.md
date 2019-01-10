# Twitter

| | |
|---------------------------|-|
| Agent Source token        | `45a1ef76-4f43-4cdc-9ba8-5a6ad01cc231` |
| Consumes Artifacts        | `domain-list`, `doi-prefix-list` |
| Subject coverage          | All tweets |
| Object coverage           | All DOIs, all Article Landing Pages |
| Data contributor          | Twitter via the Gnip PowerTrack service |
| Data origin               | Tweet text and associated metadata |
| Freshness                 | Continual |
| Identifies                | Linked DOIs, unlinked DOIs, Landing Page URLs |
| License                   | Creative commons [CC0 1.0 Universal (CC0 1.0)](https://creativecommons.org/publicdomain/zero/1.0/) |
| Looks in                  | Text of tweets, plus URLs extracted by Twitter's Gnip product. |
| Name                      | Twitter |
| Operated by               | Crossref |
| Produces Evidence Records | Yes |
| Produces relation types   | `discusses` |
| Source ID                 | `twitter` |
| Updates or deletions      | Deletions if a tweet is deleted |

## What it is

Twitter users discuss registered content items in tweets. They also retweet others who have discussed registered content items. The Twitter agent monitors a stream of tweets and tries to match DOI links, landing page links, and unlinked DOIs back to registered content items. Note that we use a unique URI format when we refer to Tweets.

## What it does

We submit a set of filter rules to the Gnip PowerTrack service. This list is made up of:

 - DOI prefixes from the `doi-prefix-list` Artifact, e.g. `10.5555`
 - DOI resolver domains, e.g. `doi.org`, `dx.doi.org`
 - All domains in the `domain-list` Artifact, e.g. `journals.iucr.org`

This is managed manually whenever we update the domain list Artifact.

The Agent monitors all data sent back from the PowerTrack stream. This includes:

 - Tweets that contain a DOI prefix, i.e. those that look like they might contain an unlinked DOI.
 - Tweets that contain a hyperlinked DOI.
 - Tweets that contain a hyperlinked landing page URL.
 - Tweets that contain a link-shortened link to a DOI or landing page URL.

The Gnip service automatically follows and extracts URLs from link-shortening services like bit.ly before the data is sent to us. This gives the Twitter source an advantage, as it removes opaque link-shortened links that we otherwise could not match.

We then attempt to match all links to registered content items.

## Example Event

Note that the format of Tweet and author IDs changed in January 2019. They are now non-resolvable URIs. To read a Tweet in your browser, you can visit the URL: 

    http://twitter.com/statuses/«ID»

New format:

    {
     "license":"https://creativecommons.org/publicdomain/zero/1.0/",
     "obj_id":"https://doi.org/10.1039/c8ee03134g",
     "source_token":"45a1ef76-4f43-4cdc-9ba8-5a6ad01cc231",
     "occurred_at":"2019-01-10T17:12:26Z",
     "subj_id":"twitter://status?id=1083411254788739073",
     "id":"29ffcda3-c9bc-47ca-a916-dcde1e2023fa",
     "evidence_record":"https://evidence.eventdata.crossref.org/evidence/20190110-twitter-28393e6c-03e9-47f8-89ae-584f0d9687f9",
     "terms":"https://doi.org/10.13003/CED-terms-of-use",
     "action":"add",
     "subj":{
        "pid":"twitter://status?id=1083411254788739073",
        "url":"twitter://status?id=1083411254788739073",
        "title":"Tweet 1083411254788739073",
        "issued":"2019-01-10T17:12:26.000Z",
        "author":{
          "url":"twitter://user?screen_name=pmherder"},
          "original-tweet-url":"twitter://status?id=1083379011089133568",
          "original-tweet-author":"twitter://user?screen_name=TomBurdyny",
          "alternative-id":"1083411254788739073"
        },
     "source_id":"twitter",
     "obj":{
       "pid":"https://doi.org/10.1039/c8ee03134g",
       "url":"https://pubs.rsc.org/en/Content/ArticleLanding/2019/EE/C8EE03134G",
       "method":"landing-page-meta-tag",
       "verification":"checked-url-exact"
       },
       "timestamp":"2019-01-10T17:21:51Z",
       "relation_type_id":"discusses"
     }

Old style, pre 2019:

    {
      "license": "https://creativecommons.org/publicdomain/zero/1.0/",
      "obj_id": "https://doi.org/10.1107/s2052252514014845",
      "source_token": "45a1ef76-4f43-4cdc-9ba8-5a6ad01cc231",
      "occurred_at": "2017-05-14T05:04:37Z",
      "subj_id": "http://twitter.com/AfSynchrotron/statuses/863621047475728386",
      "id": "00000191-5e08-4af9-b467-954a283c92b3",
      "evidence_record": "https://evidence.eventdata.crossref.org/evidence/20170514-twitter-c4cbb038-c9c7-42a1-babb-86e47304b09f",
      "terms": "https://doi.org/10.13003/CED-terms-of-use",
      "action": "add",
      "subj": {
        "pid": "http://twitter.com/AfSynchrotron/statuses/863621047475728386",
        "title": "Tweet 863621047475728386",
        "issued": "2017-05-14T05:04:37.000Z",
        "author": {
          "url": "http://www.twitter.com/AfSynchrotron"
        },
        "original-tweet-url": "http://twitter.com/AfSynchrotron/statuses/863621047475728386",
        "original-tweet-author": null,
        "alternative-id": "863621047475728386"
      },
      "source_id": "twitter",
      "obj": {
        "pid": "https://doi.org/10.1107/s2052252514014845",
        "url": "http://journals.iucr.org/m/issues/2014/05/00/fc5002/index.html"
      },
      "timestamp": "2017-05-14T05:04:57Z",
      "relation_type_id": "discusses"
    }

You can see that this is a retweet because of the presence of the `original-tweet-url`.

## Evidence Record

The Agent collects tweets into batches and sends a number per Evidence Record.

 - Includes observations of type `plaintext` for the text of the tweet. This is marked as `sensitive` because we are not allowed to share the tweet text for contractual reasons.
 - Includes observations of the type `landing-page-url`, one for each URL extracted and sent to us by the Gnip PowerTrack service.

## Edits / deletion

Some tweets are deleted by their authors after they are published. We observe single-digit percentage deletion rates in Event Data. Twitter publishes a stream of deleted tweet IDs, which we check against our database. If we find that a tweet has been deleted, we will edit the Event:

 - The `updated` field is set to indicate the timestamp when we took the action.
 - The `updated_type` field is set to `deleted`.
 - The `updated_reason` will be set to the URL of an announcement that indicates the reason.
 - The `subj_id` will be updated to remove the tweet ID (it is considered to be sensitive information), and will just show `https://twitter.com`
 - The `subj` metadata will be removed.

Events that have been subject to compliance actions will not be included in new query results from the Query API. They will be available via the `from-updated-date` query to allow you to perform your own compliance actions. If you store Twitter Events from Event Data, you should perform periodic checks to see if you should update your own data.

## Quirks

In January we updated the Agent to use the new URL format. We did not update old Events. You should expect URIs in either format when you use data from this Source.

The rules sent to Gnip PowerTack are manually updated. We aim to keep them in sync with the `domain-list` Artifact, but they may lag slightly.

According to the agreement we have with Twitter, we are allowed to process the text of tweets to extract events but we are not allowed to store or redistribute it. The text of the tweet is therefore passed to the Percolator and marked as 'sensitive'. This means that the SHA1 hash of the text appears in the Evidence Record as an `input-content-hash`, but not the text itself.

If you are interested in the text of a tweet, you can easily follow the link to Twitter or use the Twitter API to fetch the data. Twitter calls this process 'rehydration'. If you want to check the content of the tweet as part of an audit, you can apply a SHA1 hash of the retrieved text yourself and compare it to ours.

Please be aware that if you retrieve data from the Twitter API you are bound by Twitter's terms and conditions.

## Failure modes

 - Publisher sites may block the Event Data Bot collecting landing pages.

## Further information

 - https://twitter.com
