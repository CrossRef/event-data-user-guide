# Web

| | |
|---------------------------|-|
| Agent Source Token        | `d9c55bad-73db-4860-be18-520d3891b01f` |
| Consumes Artifacts        | `domain-list` |
| Subject Coverage          | Any webpage. |
| Object Coverage           | All DOIs, all article Landing Pages |
| Data Contributor          | Various |
| Data Origin               | Authors of webpages |
| Freshness                 | Infrequent |
| Identifies                | Linked DOIs, unlinked DOIs, Landing Page URLs |
| License                   | Creative Commons [CC0 1.0 Universal (CC0 1.0)](https://creativecommons.org/publicdomain/zero/1.0/) |
| Looks in                  | Text of webpages. |
| Name                      | Web |
| Operated by               | Crossref |
| Produces Evidence Records | Yes |
| Produces relation types   | `mentions` |
| Source ID                 | `web` |
| Updates or deletions      | None expected |

## What it is

The Web source is a catch-all name we give to Events collected from the Web when we folllow links that fall outside any other source. As with all other sources, we don't visit webpages that belong to Crossref members.

Many Agents such as Reddit Links, Newsfeed, Wikipedia follow links.

## What it is

Events from any non-member web page we think might be relevant. We monitor a list of URLs that we think might have links to Items via their DOIs or Landing Pages, and then follow them to see if we can find any Items. We curate this list, as best we can, to ensure that we never follow a link when we believe it belongs to a Crossref member or when directed not to by robots.txt.

The list of URLs can come from a range of sources, including those submitted by users. If you have such a list, feel free to contact us. 

## What it does

A list of URLs is maintained. The Agent submits every URL to the Percolator. The Percolator looks for linked or unlinked DOIs, or linked a›rticle Landing Pages in the HTML of each page.

## Where data comes from

 - A list of URLs that we compile internally, and that are submitted by users.
 - The content of each web page on the list.

## Example Event

    {
      "obj_id": "https://doi.org/10.1017/s0963180100005168",
      "source_token": "d9c55bad-73db-4860-be18-520d3891b01f",
      "occurred_at": "2017-03-13T10:10:38Z",
      "subj_id": "http://philpapers.org/rec/ANNAAS",
      "id": "00003c22-1571-4bd3-924b-0438f6f7ff54",
      "evidence_record": "https://evidence.eventdata.crossref.org/evidence/20170313e86bef03-4556-4ecc-8401-0e71af4d0bb6",
      "terms": "https://doi.org/10.13003/CED-terms-of-use",
      "action": "add",
      "subj": {
        "pid": "http://philpapers.org/rec/ANNAAS",
        "work-type": "webpage",
        "url": "http://philpapers.org/rec/ANNAAS"
      },
      "source_id": "web",
      "obj": {
        "pid": "https://doi.org/10.1017/s0963180100005168",
        "url": "https://doi.org/10.1017/s0963180100005168"
      },
      "timestamp": "2017-03-13T10:11:19Z",
      "relation_type_id": "mentions"
    }

## Evidence Record

The Evidence Record contains obserations of type `content-url` which correspond to every URL visited.

## Edits / Deletion

We may mark Events as deleted if we subsequently find that the `subj_id` doesn't conform to the Event Data aims (e.g. if it belongs to a member). 

## Quirks

 - The selection of URLs doesn't follow any particular pattern. 

## Failure modes

 - Publisher sites may block the Event Data Bot collecting Landing Pages.

## Further information

None.
