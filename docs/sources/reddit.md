# Reddit

| | |
|---------------------------|-|
| Agent Source Token        | `a6c9d511-9239-4de8-a266-b013f5bd8764` |
| Consumes Artifacts        | `domain-list` |
| Subject Coverage          | All discussions on Reddit |
| Object Coverage           | All DOIs, all Article Landing Pages |
| Data Contributor          | Reddit |
| Data Origin               | Discussions on Reddit |
| Freshness                 | Every few hours |
| Identifies                | Linked DOIs |
| License                   | Creative Commons [CC0 1.0 Universal (CC0 1.0)](https://creativecommons.org/publicdomain/zero/1.0/) |
| Looks in                  | The link that corredsponds to each discussion |
| Name                      | Reddit Links |
| Operated by               | Crossref |
| Produces Evidence Records | Yes |
| Produces relation types   | `discusses` |
| Source ID                 | `reddit` |
| Updates or deletions      | None expected |

## What it is

Users share and discuss links on Reddit. The Reddit Source looks at the links that are shared and detects if any of them are DOIs or links to Article Landing Pages. It is different to the Reddit Links Source in that it looks for discussions of Registered Content (rather than discussions of webpages that themselves discuss Registered Content).

## What it does

 - Scans every article Landing Page domain in the `domain-list`, including `doi.org`
 - Makes a query to the Reddit API for discussions that occurred for pages on that domain.
 - For each link discussed, attempts to reverse it back to a DOI.

## Example Event

    {
      "license": "https://creativecommons.org/publicdomain/zero/1.0/",
      "obj_id": "https://doi.org/10.3201/eid2202.151250",
      "source_token": "a6c9d511-9239-4de8-a266-b013f5bd8764",
      "occurred_at": "2016-01-26T01:49:17Z",
      "subj_id": "https://reddit.com/r/science/comments/42p4xg/prognostic_indicators_for_ebola_patient_survival/",
      "id": "0003a012-e3fd-4d2f-8c18-1d8b7bb07e20",
      "evidence_record": "https://evidence.eventdata.crossref.org/evidence/2017022244f5e774-b3ca-4b29-8555-269777b38983",
      "terms": "https://doi.org/10.13003/CED-terms-of-use",
      "action": "add",
      "subj": {
        "pid": "https://reddit.com/r/science/comments/42p4xg/prognostic_indicators_for_ebola_patient_survival/",
        "type": "post",
        "title": "Prognostic Indicators for Ebola Patient Survival",
        "issued": "2016-01-26T01:49:17.000Z"
      },
      "source_id": "reddit",
      "obj": {
        "pid": "https://doi.org/10.3201/eid2202.151250",
        "url": "http://wwwnc.cdc.gov/eid/article/22/2/15-1250_article"
      },
      "timestamp": "2017-02-22T17:16:17Z",
      "relation_type_id": "discusses"
    }

## Evidence Record

 - Includes `landing-page-url` type observations.

## Edits / Deletion

We don't expect to have to edit or delete any Events.

## Quirks

None known.

## Failure modes

 - The Reddit API may be unavailable.
 - Publisher sites may block the Event Data Bot collecting Landing Pages.

## Further information

- https://reddit.com/
