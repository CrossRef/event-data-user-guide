# Twitter

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | twitter |
| Matches by                | Landing Page URL hyperlink, DOI hyperlink, DOI text |
| Consumes Artifacts        | `domain-list`, `doi-prefix-list` |
| Produces relation types   | `discusses` |
| Freshness                 | Delay of up to 1 hour |
| Data Source               | Twitter via Gnip |
| Coverage                  | All tweets that mention current DOI prefix list or landing page domain list |
| Identifies links by       | Linked DOIs, unlinked DOIs, linked landing page domains |
| Relevant concepts         | [Pre-filtering](#pre-filtering) |
| Operated by               | Crossref |
| Agent                     | event-data-twitter-agent |

## What it is

Tweets that mention Items. Matched by Landing Page URL, DOI URL or plain DOI text.

## What it does

The Agent monitors the Twitter PowerTrack firehose. It queries for Tweets that look like they have a DOI in them, or which mention a Landing Page domain or DOI.org .

## Where data comes from

 - The `domain-list` artifact is used to construct rues.
 - The Twitter PowerTrack API.

## Example Event

If a tweet is a retweet, the `original-tweet-url` and `original-tweet-author` are included.

    {
      "obj_id": "https://doi.org/10.1038/542391a",
      "source_token": "45a1ef76-4f43-4cdc-9ba8-5a6ad01cc231",
      "occurred_at": "2017-02-25T23:51:44.000Z",
      "subj_id": "http://twitter.com/anairam_o/statuses/835638443136929794",
      "id": "0000a016-a3b7-4022-970e-a24a44603242",
      "action": "add",
      "subj": {
        "pid": "http://twitter.com/anairam_o/statuses/835638443136929794",
        "title": "Tweet 835638443136929794",
        "issued": "2017-02-25T23:51:44.000Z",
        "author": {
          "url": "http://www.twitter.com/anairam_o"
        },
        "original-tweet-url": "http://twitter.com/anairam_o/statuses/835638443136929794",
        "original-tweet-author": null
      },
      "source_id": "twitter",
      "obj": {
        "pid": "https://doi.org/10.1038/542391a",
        "url": "http://www.nature.com/news/researchers-should-reach-beyond-the-science-bubble-1.21514"
      },
      "timestamp": "2017-02-25T23:52:32.877Z",
      "evidence-record": "https://evidence.eventdata.crossref.org/evidence/2017022580a35fb2-df4a-48c0-b2ea-a3380bb6ada2",
      "relation_type_id": "discusses"
    }


## Methodology

Whenever the relevant Artifacts change, the Twitter agent submits a set of rules to the PowerTrack API. It constructs rules that filter for:

 - search for every DOI prefix in the `doi-prefixes` Artifact
 - search for links in Tweets that mention any of the domains from the `domain-list` Artifact

The Agent subscribes to the PowerTrack data stream. Twitter enriches the data by extracting links from Tweets and following / unwinding link redirects. It bundles Tweets into batches and sends them to the Percolator with the following fields:

 - `plain-text-sensitive` - for extracting un-linked DOIs in the text
 - `urls` - for landing page URLs or DOI URLs. 

## Evidence Record

An example Evidence Record can be found at https://evidence.eventdata.crossref.org/evidence/2017022580a35fb2-df4a-48c0-b2ea-a3380bb6ada2

The Twitter agent batches Tweets up into small chunks, one chunk per Evidence Record.

## Edits / Deletion

Events may be edited if they are found to be faulty, e.g. non-existent DOIs

When a Tweet or Twitter User is deleted we are obliged to delete the data from CED. When this happens we will edit the Event and delete the following fields:

 - `subj_id` - the ID of the tweet
 - `subj` - including the author and ID of the tweet

The following fields are added:

 - The `subj_id` is replaced with `https://www.twitter.com`.
 - The `edited_at` field has a timestamp for when the edits were made.

The rest of the Event is not deleted. The Evidence Record is also deleted. The effect of this is that a Tweet event goes from "this DOI was mentioned in this tweet" to "this DOI was mentioned in some tweet, but we don't know which one".

The following [Twitter Compliance Events](http://support.gnip.com/apis/compliance_firehose2.0/overview.html) result in the removal of Twitter data from an Event:

 - `delete` - delete all Events that contain this Tweet ID
 - `user_delete` - delete all Events that were written by this Author
 - `user_protect` - delete all Events that were written by this Author
 - `user_suspend` - delete all Events that were written by this Author


If the above Tweet had been deleted, the Event would be edited to read:

    {
      "obj_id": "https://doi.org/10.1038/542391a",
      "source_token": "45a1ef76-4f43-4cdc-9ba8-5a6ad01cc231",
      "occurred_at": "2017-02-25T23:51:44.000Z",
      // tweet ID removed
      "subj_id": "http://twitter.com/",
      "id": "0000a016-a3b7-4022-970e-a24a44603242",
      "action": "add",
      // subj removed
      "source_id": "twitter",
      "obj": {
        "pid": "https://doi.org/10.1038/542391a",
        "url": "http://www.nature.com/news/researchers-should-reach-beyond-the-science-bubble-1.21514"
      },
      "timestamp": "2017-02-25T23:52:32.877Z",
      "evidence-record": "https://evidence.eventdata.crossref.org/evidence/2017022580a35fb2-df4a-48c0-b2ea-a3380bb6ada2",
      "relation_type_id": "discusses",
      // updated field set to 'deleted'
      "updated": "deleted",
      "updated-date": "2018-02-25T23:51:44.000Z"
    }


## Quirks

According to the agreement we have with Twitter, we are allowed to process the text of Tweets to extract events but we are not allowed to store or redistribute it. The text of the tweet is therefore passed to the Percolator and marked as 'sensitive'. This means that the SHA1 hash of the text appears in the Evidence Record as an `input-content-hash`, but not the text itself.

If you are interested in the text of a Tweet, you can easily follow the link to Twitter or use the Twitter API to fetch the data. Twitter calls this process 'rehydration'. If you want to check the content of the Tweet as part of an audit, you can apply a SHA1 hash of the retrieved text yourself and compare it to ours.

## Failure modes

 - Publisher sites may block the Event Data Bot collecting Landing Pages.
 - Publisher sites may prevent the Event Data Bot collecting Landing Pages with robots.txt

## Further information

 - [Twitter Developer Documentation](https://dev.twitter.com/)

