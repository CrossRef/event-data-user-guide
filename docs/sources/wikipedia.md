# Wikipedia

| | |
|---------------------------|-|
| Agent Source token        | `36c35e23-8757-4a9d-aacf-345e9b7eb50d` |
| Consumes Artifacts        | |
| Subject coverage          | All Wikimedia properties whose changes are published via [MediaWiki Event Streams](https://wikitech.wikimedia.org/wiki/EventStreams)|
| Object coverage           | All DOIs, all Article Landing Pages |
| Data contributor          | Wikimedia Foundation |
| Data origin               | Edits of articles on Wikimedia properties, e.g. Wikipedias. Via the Wikipedia MediaWiki Event Streams and the media WikiRESTBase API.|
| Freshness                 | Continuous. |
| Identifies                | Linked DOIs, unlinked DOIs, landing page URLs |
| License                   | Creative Commons [CC0 1.0 Universal (CC0 1.0)](https://creativecommons.org/publicdomain/zero/1.0/) |
| Looks in                  | The rendered HTML of Wikipedia pages, including inline citations and references. |
| Name                      | Wikipedia |
| Operated by               | Crossref |
| Produces Evidence Records | Yes |
| Produces relation types   | `references` |
| Source ID                 | `wikipedia` |
| Updates or deletions      | None expected |

## What it is

Wikipedia is the free encyclopedia that anyone can edit. We find references to registered content items in page references and citations. The Wikipedia Agent monitors all WikiMedia properties that are exposed via the MediaWiki Event Stream. This includes all Wikipedia sites, plus some other sites.

One of the features of Wikipedia is that pages can be edited and each version is given a unique ID. Because of this, references can come and go over the course of a page's lifetime. **Event Data treats every version of a page as a separate entity** and reports on links from that page. This means that if a page is edited and a reference is added, it will record an Event for every reference in the old version and an also Event for every reference in the new version. Wikipedia pages change once they are created but Events don't. The stream of Events for a Wikipedia page describe its evolution over time.

## What it does

 - The Agent subscribes to the Event Stream. This stream sends information about every edit of every page on MediaWiki properties. 
 - For every edit, the Agent visits that page. It uses the RESTBase API to retrieve the rendered HTML of the page.
 - The HTML of the page is searched for unlinked DOIs, linked DOIs and landing page URLs.
 - The Agent sends an Event for every Reference it finds.

## Example Event

An Event that records a reference from a Wikipedia page to a DOI.

    {
      "license": "https://creativecommons.org/publicdomain/zero/1.0/",
      "obj_id": "https://doi.org/10.1007/s00253-011-3689-1",
      "source_token": "36c35e23-8757-4a9d-aacf-345e9b7eb50d",
      "occurred_at": "2017-05-17T16:18:29Z",
      "subj_id": "https://en.wikipedia.org/wiki/Gliotoxin",
      "id": "000053b8-4eaf-460f-80fd-84d8bd0ff640",
      "evidence_record": "https://evidence.eventdata.crossref.org/evidence/20170517-wikipedia-8397e91a-c10b-4058-96a7-e0f83e7e988a",
      "terms": "https://doi.org/10.13003/CED-terms-of-use",
      "action": "add",
      "subj": {
        "pid": "https://en.wikipedia.org/wiki/Gliotoxin",
        "url": "https://en.wikipedia.org/w/index.php?title=Gliotoxin&oldid=780858119",
        "title": "Gliotoxin",
        "api-url": "https://en.wikipedia.org/api/rest_v1/page/html/Gliotoxin/780858119"
      },
      "source_id": "wikipedia",
      "obj": {
        "pid": "https://doi.org/10.1007/s00253-011-3689-1",
        "url": "https://doi.org/10.1007/s00253-011-3689-1"
      },
      "timestamp": "2017-05-17T16:19:23Z",
      "relation_type_id": "references"
    }

## Evidence Record

The Agent collects edits into batches and sends a number per Evidence Record. These are sent as `content-url` type observations. Note that because of the volume, and the fact that MediaWiki stores all past versions, the text is not saved. A checksum is included however. Also note that the RESTBase URL is included for observation, but the version URL is included as the `subj_url`.

## Edits / deletion

We don't expect to have to edit or delete any Events.

## Quirks

There are a number of initiatives in the community concerning citation and referencing in Wikipedia, leading to various ways in which links may be made in the WikiText source of the article. The Agent monitors the final rendered HTML, so transcends these different methods.

Due to the way that references are sometimes made (for example, both landing pages and DOIs), an Article may contain two references to the same registered content item. Because these are treated differently by Event Data, you should pay careful attention to the `obj.url` field.

We record every edit for which we find relevant references. This means that if a page is edited in a way that doesn't change the references, we will still record it as normal.

There are some similar but distinct terms:
 - Wikipedia is the encyclopedia, available at https://wikipedia.org . There are various Wikipedia servers, e.g. for different language versions.
 - MediaWiki is the software that runs Wikipedia. It also runs some other websites. 
 - Wikimedia is the organisation that runs Wikipedia and develops the MediaWiki software.
 - WikiText is the markup language used to author pages in MediaWiki.

## Failure modes

 - Publisher sites may block the Event Data Bot collecting landing pages.
 - If the Agent is temporarily disconnected from the edit stream, we will not be aware of edits until it reconnects.

## Further information

 - [EventStreams documentation](https://wikitech.wikimedia.org/wiki/EventStreams)
 - [RESTBase API documentation](https://www.mediawiki.org/wiki/RESTBase)
