# Reddit Links

TODO

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | event-data-reddit-agent |
| Matches by                | Landing Page URL hyperlink, DOI hyperlink |
| Consumes Artifacts        | `domain-list` |
| Produces relation types   | `discusses` |
| Freshness                 | every few hours |
| Data Source               | Reddit API |
| Coverage                  | All landing page URLs and DOI URLs |
| Relevant concepts         | [Unambiguously linking URLs to DOIs](#concept-urls), [Pre-filtering](#pre-filtering) |
| Operated by               | Crossref |
| Agent                     | event-data-reddit-agent |

## What it is

Discussions of Items on Reddit "the front Page of the Internet". 

## What it does

The Agent monitors the Reddit API for discussions of Items via DOI links or links to Landing Pages. Only discussions that link to the article page are included. Free-form DOIs in comments are not collected.

## Where data comes from

The `domain-list` Artifact is consulted. On a regular basis the Agent retrieves the Artifact, then follows the link to every blog post or page mentioned. 

The Reddit API provides access to conversations that happen on Reddit. 

## Example Event

    }
      obj_id: "https://doi.org/10.1371/journal.pone.0172464",
      source_token: "a6c9d511-9239-4de8-a266-b013f5bd8764",
      occurred_at: "2017-02-24T18:49:47.000Z",
      subj_id: "https://reddit.com/r/citral/comments/5vzabs/the_surrounding_landscape_influences_the/",
      id: "018bbdb7-f4e3-4fc4-a85d-8e87dea741ba",
      action: "add",
      subj: {
        pid: "https://reddit.com/r/citral/comments/5vzabs/the_surrounding_landscape_influences_the/",
        type: "post",
        title: "The surrounding landscape influences the diversity of leaf-litter ants in riparian cloud forest remnants",
        issued: "2017-02-24T18:49:47.000Z"
      },
      source_id: "reddit",
      obj: {
        pid: "https://doi.org/10.1371/journal.pone.0172464",
        url: "http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0172464"
      },
      timestamp: "2017-02-25T01:25:16.311Z",
      evidence-record: "https://evidence.eventdata.crossref.org/evidence/201702254d2aa87a-a86a-4849-95f3-9df577697dcb",
      relation_type_id: "discusses"
    }

## Methodology

On a regular basis (approximately every six hours) the Reddit Agent starts a scan. Each scan:

1. It downloads a copy of the latest version of the `domain-list` Artifact.
2. For every domain in the domain list (including doi.org):
    1. It queries the Reddit API for all activities that relate to that domain. The request is sorted by recently occurred. It consumes all pages of data to cover the time period since the last scan.
    2. Every response from the Reddit API includes the text of the comment and the URL.
    3. Every item results in plain-text candidates and candidate landing page URL for the Percolator.
3. Every domain scan results in an input to the Percolator. Pages of API results correspond to pages in an Evidence Record.

## Evidence Record

An example Evidence Record can be found at https://evidence.eventdata.crossref.org/evidence/201702254d2aa87a-a86a-4849-95f3-9df577697dcb

 - Each Evidence Record corresponds to a scan of a particular domain. 
 - Each Page corresponds to a page of API results.
 - Each Page's URL is the API URL queried.

## Edits / Deletion

 - Events may be edited if they are found to be faulty, e.g. non-existent DOIs

## Quirks

There are no particular quirks to the Reddit agent.

## Failure modes

 - Publisher sites may block the Event Data Bot collecting Landing Pages.
 - Publisher sites may prevent the Event Data Bot collecting Landing Pages with robots.txt


## Further information

- [Reddit homepage](https://www.reddit.com/)
