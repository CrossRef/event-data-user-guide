# Wikipedia

| | |
|---------------------------|-|
| Agent Source Token        | `36c35e23-8757-4a9d-aacf-345e9b7eb50d` |
| Consumes Artifacts        | |
| Subject Coverage          | All Wikimedia properties whose changes are published via [MediaWiki Event Streams](https://wikitech.wikimedia.org/wiki/EventStreams)|
| Object Coverage           | All DOIs, all article Landing Pages |
| Data Contributor          | Wikimedia Foundation |
| Data Origin               | Edits of articles on Wikimedia properties, e.g. Wikipedias. Via the Wikipedia MediaWiki Event Streams and the Media WikiRESTBase API.|
| Freshness                 | Continuous. |
| Identifies                | Linked DOIs, unlinked DOIs, Landing Page URLs |
| License                   | Creative Commons [CC0 1.0 Universal (CC0 1.0)](https://creativecommons.org/publicdomain/zero/1.0/) |
| Looks in                  | The rendered HTML of Wikipedia pages, including inline citations and references. |
| Name                      | Wikipedia |
| Operated by               | Crossref |
| Produces Evidence Records | Yes |
| Produces relation types   | `references` |
| Source ID                 | `wikipedia` |
| Updates or deletions      | None expected |

## What it is

Wikipedia is the free encyclopedia that anyone can edit. We find references to Registered Content Items in page references and citations. The Wikipedia Agent monitors all WikiMedia properties that are exposed via the MediaWiki Event Stream. This includes all Wikipedia sites, plus some other sites.

One of the features of Wikipedia is that pages can be edited and each version is given a unique ID. Because of this, references can come and go over the course of a page's lifetime. **Event Data treats every version of a page as a separate entity** and reports on links from that page. This means that if a page is edited and a reference is added, it will record an Event for every reference in the old version and an also Event for every reference in the new version. Wikipedia pages change once they are created but Events don't. The stream of Events for a Wikipedia page describe its evolution over time.

For every edit for a page the Agent creates an Event to link that new version to the canonical ID of the page and another Event that records that it supersedes the previous version. It then records all the Events for the new page.

In this example we have a Page on Wikipedia called "Psychoceramics". It has three versions. The first version has a reference to the DOI https://doi.org/10.5555/12345678. In the second version a reference to https://doi.org/10.5555/777766665555 was added and the original one was retained. In the third version that reference was removed, leaving only the original. This would be as follows (where each arrow represents an Event):

<img src="../../images/wikipedia-links.png" alt="Wikipedia Links" class="img-responsive">

The evolution of the page is recorded with `replaces` links. The relationship between the page version and its canonical ID is recorded with `is_version_of` links. And each version has its own `references` links.

## What it does

 - The Agent subscribes to the Event Stream. This stream sends information about every edit of every page on MediaWiki properties. 
 - For every edit, the Agent visits that page. It uses the RESTBase API to retrieve the rendered HTML of the page.
 - The HTML of the page is searched for unlinked DOIs, linked DOIs and Landing Page URLs.
 - The Agent sends an Event to record the `is_version_of` and `replaces` relationships
 - The Agent sends an Event for every Reference it finds.

## Example Event

An Event that records a new version of a Wikipedia page.

    {
      "license": "https://creativecommons.org/publicdomain/zero/1.0/",
      "obj_id": "https://fr.wikipedia.org/wiki/Pierre_de_Bonzi",
      "source_token": "36c35e23-8757-4a9d-aacf-345e9b7eb50d",
      "occurred_at": "2017-04-15T23:53:50Z",
      "subj_id": "https://fr.wikipedia.org/w/index.php?title=Pierre_de_Bonzi&oldid=135865709",
      "id": "0000524c-d000-4011-b35f-0709bd4b34ca",
      "evidence_record": "https://evidence.eventdata.crossref.org/evidence/20170415-wikipedia-ef00e0c1-303c-45ce-9a68-e94cd95bc696",
      "terms": "https://doi.org/10.13003/CED-terms-of-use",
      "action": "add",
      "source_id": "wikipedia",
      "timestamp": "2017-04-15T23:54:36Z",
      "relation_type_id": "is_version_of"
    }

An Event that records a reference from a Wikipedia page to a DOI.

    {
      "license": "https://creativecommons.org/publicdomain/zero/1.0/",
      "obj_id": "https://doi.org/10.1007/s00253-011-3689-1",
      "source_token": "36c35e23-8757-4a9d-aacf-345e9b7eb50d",
      "occurred_at": "2017-05-17T16:18:29Z",
      "subj_id": "https://en.wikipedia.org/w/index.php?title=Gliotoxin&oldid=780858119",
      "id": "000053b8-4eaf-460f-80fd-84d8bd0ff640",
      "evidence_record": "https://evidence.eventdata.crossref.org/evidence/20170517-wikipedia-8397e91a-c10b-4058-96a7-e0f83e7e988a",
      "terms": "https://doi.org/10.13003/CED-terms-of-use",
      "action": "add",
      "subj": {
        "pid": "https://en.wikipedia.org/w/index.php?title=Gliotoxin&oldid=780858119",
        "url": "https://en.wikipedia.org/wiki/Gliotoxin",
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

An Event that records a new version of a Wikipedia page replacing its previous version.

    {
      "license": "https://creativecommons.org/publicdomain/zero/1.0/",
      "obj_id": "https://en.wikipedia.org/w/index.php?title=Varg_Vikernes&oldid=780351110",
      "source_token": "36c35e23-8757-4a9d-aacf-345e9b7eb50d",
      "occurred_at": "2017-05-14T22:37:56Z",
      "subj_id": "https://en.wikipedia.org/w/index.php?title=Varg_Vikernes&oldid=780410405",
      "id": "0000549c-ad9e-412c-ac13-4934646db3dc",
      "evidence_record": "https://evidence.eventdata.crossref.org/evidence/20170514-wikipedia-ce59b8d6-c83e-4d7c-9fec-35a174da1d17",
      "terms": "https://doi.org/10.13003/CED-terms-of-use",
      "action": "add",
      "source_id": "wikipedia",
      "timestamp": "2017-05-14T22:39:39Z",
      "relation_type_id": "replaces"
    }

## Evidence Record

The Agent collects edits into batches and sends a number per Evidence Record. These are sent as `content-url` type observations. Note that because of the volume, and the fact that MediaWiki stores all past versions, the text is not saved. A checksum is included however. Also note that the RESTBase URL is included for observation, but the version URL is included as the `subj_url`.

## Edits / Deletion

We don't expect to have to edit or delete any Events.

## Quirks

There are a number of initatives in the community concerning citation and referencing in Wikipedia, leading to various ways in which links may be made in the WikiText source of the article. The Agent monitors the final rendered HTML, so transcends these different methods.

Due to the way that references are sometimes made (for example, both Landing Pages and DOIs), an article may contain two references to the same Registered Content Item. Because these are treated differently by Event Data, you should pay careful attention to the `obj.url` field.

We record every edit for which we find relevant references. This means that if a page is edited in a way that doesn't change the references, we will still record it as normal.

There are some similar but distinct terms:
 - Wikipedia is the encyclopedia, available at http://wikipedia.org . There are various Wikipedia servers, e.g. for different language versions.
 - MediaWiki is the software that runs Wikipedia. It also runs some other websites. 
 - Wikimedia is the organisation that runs Wikipedia and develops the MediaWiki software
 - WikiText is the markup language used to author pages in MediaWiki.

## Failure modes

 - Publisher sites may block the Event Data Bot collecting Landing Pages.
 - If the bot is temporarily disconnected from the edit stream, we will not be aware of edits until it reconnects.

## Further information

 - [EventStreams documentation](https://wikitech.wikimedia.org/wiki/EventStreams)
 - [RESTBase API documentation](https://www.mediawiki.org/wiki/RESTBase)
