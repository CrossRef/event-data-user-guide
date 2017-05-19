# Wordpress.com

| | |
|---------------------------|-|
| Agent Source Token        | `7750d578-d74d-4e92-9348-cd443cbb7afa` |
| Consumes Artifacts        | `domain-list` |
| Subject Coverage          | All blogs hosted on Wordpress.com that are listed in the search. |
| Object Coverage           | All DOIs, Landing Page URLs, plain-text DOIs. |
| Data Contributor          | Authors of blogs on the Wordpress.com platform. |
| Data Origin               | Wordpress.com search results API, and the blog posts they point to that are hosted on Wordpress.com |
| Freshness                 | Every few hours. |
| Identifies                | Linked DOIs, unlinked DOIs, Landing Page URLs |
| License                   | Creative Commons [CC0 1.0 Universal (CC0 1.0)](https://creativecommons.org/publicdomain/zero/1.0/) |
| Looks in                  | HTML of Blog posts |
| Name                      | Wordpress.com |
| Operated by               | Crossref |
| Produces Evidence Records | Yes |
| Produces relation types   | `discusses` |
| Source ID                 | `wordpressdotcom` |
| Updates or deletions      | None expected |

## What it is

Authors of blog posts hosted on the Wordpress.com platform link to Registered Content Items. The Wordpress.com Agent monitors the service to look for these links.

## What it does

 - Scans every article Landing Page domain in the `domain-list`, including `doi.org`
 - Makes a query to the Wordpress.com API for blog posts that mentioned that domain.
 - For each result, visits the blog post and attempts to extract links from the HTML of the blog post.

## Example Event

    {
    "license": "https://creativecommons.org/publicdomain/zero/1.0/",
    "obj_id": "https://doi.org/10.1007/s12122-016-9232-5",
    "source_token": "7750d578-d74d-4e92-9348-cd443cbb7afa",
    "occurred_at": "2017-04-01T00:33:21Z",
    "subj_id": "https://unionreaderblog.wordpress.com/2017/04/01/the-2011-industrial-relations-reform-and-nominal-wage-adjustments-in-greece-524/",
    "id": "00011980-a1c3-4b85-a5b4-84cf3082f51c",
    "evidence_record": "https://evidence.eventdata.crossref.org/evidence/20170406-wordpressdotcom-8a2287c9-e16e-4e19-aa7c-275ac249c4f6",
    "terms": "https://doi.org/10.13003/CED-terms-of-use",
    "action": "add",
    "subj": {
      "pid": "https://unionreaderblog.wordpress.com/2017/04/01/the-2011-industrial-relations-reform-and-nominal-wage-adjustments-in-greece-524/",
      "type": "post-weblog",
      "title": "The 2011 Industrial Relations Reform and Nominal Wage Adjustments in Greece"
    },
    "source_id": "wordpressdotcom",
      "obj": {
      "pid": "https://doi.org/10.1007/s12122-016-9232-5",
      "url": "https://doi.org/10.1007/s12122-016-9232-5"
    },
    "timestamp": "2017-04-06T13:34:23Z",
    "relation_type_id": "discusses"
    }

## Evidence Record

 - Includes batches of `landing-page-url` type observations.

## Edits / Deletion

## Quirks

Note that this only monitors blogs hosted on Wordpress' wordpress.com platform. It does not monitor all blogs that use the Wordpress software.

## Failure modes

 - Publisher sites may block the Event Data Bot collecting Landing Pages.

## Further information

 - [Wordpress.com](http://wordpress.com)
