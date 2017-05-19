# Reddit Links

| | |
|---------------------------|-|
| Agent Source Token        | `93df90e8-1881-40fc-b19d-49d78cc9ee24` |
| Consumes Artifacts        | `subreddit-list` |
| Subject Coverage          | All Links posted in subreddits on the `subreddit-list`. |
| Object Coverage           | All DOIs, all article Landing Pages. |
| Data Contributor          | Reddit |
| Data Origin               | Subreddit feeds and websites that they link to. |
| Freshness                 | Every few hours. |
| Identifies                | Linked DOIs, unlinked DOIs, Landing Page URLs |
| License                   | Creative Commons [CC0 1.0 Universal (CC0 1.0)](https://creativecommons.org/publicdomain/zero/1.0/) |
| Looks in                  | The text of Webpages linked to on specified subreddits. |
| Name                      | Reddit Links |
| Operated by               | Crossref |
| Produces Evidence Records | Yes |
| Produces relation types   | `discusses` |
| Source ID                 | `reddit-links` |
| Updates or deletions      | None expected |

## What it is

Users share and discuss links on Reddit. The Reddit Links source looks at the links that are shared in a specific selection of subreddits (Reddit discussion forums) and visits the webpages that are linked. The selection of Subreddits that are visited are specified in the `subreddit-list` Artifact. The subreddits tend to be scientific or academic in focus.

This is different to the Reddit source, which looks at the discussions themselves.

## What it does

 - Visits each subreddit in turn.
 - Fetches all links that were shared since the last visit.
 - Visits each link and looks in the HTML of the webpage for links to DOIs, links to article Landing Pages and unlinked DOIs.

## Example Event


    {
      "license": "https://creativecommons.org/publicdomain/zero/1.0/",
      "obj_id": "https://doi.org/10.1126/science.1182238",
      "source_token": "93df90e8-1881-40fc-b19d-49d78cc9ee24",
      "occurred_at": "2016-07-16T05:33:05Z",
      "subj_id": "http://rsos.royalsocietypublishing.org/content/3/7/160131",
      "id": "0004a308-b218-47f5-bf58-82bc2c245bc7",
      "evidence_record": "https://evidence.eventdata.crossref.org/  evidence/20170410-reddit-links-fd42bae4-aa51-4cd8-a022-3b3c3e501949",
      "terms": "https://doi.org/10.13003/CED-terms-of-use",
      "action": "add",
      "subj": {
        "pid": "http://rsos.royalsocietypublishing.org/content/3/7/160131"
      },
      "source_id": "reddit-links",
      "obj": {
        "pid": "https://doi.org/10.1126/science.1182238",
        "url": "http://dx.doi.org/10.1126/science.1182238"
      },
      "timestamp": "2017-04-10T16:35:52Z",
      "relation_type_id": "discusses"
    }

## Evidence Record

 - Includes batches of `landing-page-url` type observations.

## Edits / Deletion

We don't expect to have to edit or delete any Events.

## Quirks

We will only visit subreddits on the list. However we monitor the Events generated from Reddit source and manually review those. 

## Failure modes

 - Reddit API may be unavailable.
 - Publisher sites may block the Event Data Bot collecting Landing Pages.
 - Publisher sites may prevent the Event Data Bot collecting Landing Pages with robots.txt


## Further information

 - https://reddit.com/

