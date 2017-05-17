# DataCite Metadata

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | datacite |
| Consumes Artifacts        | none |
| Matches by                | DOI references in DataCite XML |
| Produces relation types   | cites |
| Freshness                 | daily |
| Data Source               | DataCite Metadata deposited by DataCite members |
| Coverage                  | All DOIs |
| Identifies links by       | References in DataCite schema |
| Relevant concepts         | [External Agents](#contept-external-agent), [Occurred-at vs collected-at](concepts#concept-timescales) |
| Operated by               | DataCite |

## What it is

Links from DataCite's bibliographic metadata to Crossref DOIs. Such links are usually data citation between a dataset in DataCite and an article in Crossref.

## What it does

The Agent monitors deposits as they come in from DataCite members and sends any links to DataCite DOIs into Event Data.

## Where data comes from

Metadata deposits from Crossref members, usually publishers.

## Example Event

    {
      "obj_id":"https://doi.org/10.13127/ITACA/2.1",
      "occurred_at":"2016-08-19T20:30:00Z",
      "subj_id":"https://doi.org/10.1007/S10518-016-9982-8",
      "total":1,
      "id":"71e62cbd-28a8-4a41-9b74-7e58dca03efc",
      "message_action":"create",
      "source_id":"crossref",
      "timestamp":"2016-08-19T22:14:33Z",
      "relation_type_id":"cites"
    }

## Methodology

1. A member makes an XML deposit with DataCite.
2. The agent monitors new deposits (or back-fills).
3. When a link is found an Event is created if:
    - it is to a non-DataCite DOI
    - it has not already been reported to Event Data

## Evidence Record

No evidence record is created because the events come straight from the data source into Event Data.

## Edits / Deletion

We do not anticipate that Events are ever deleted or edited.

## Quirks

None.

## Failure modes

 - Members may remove references, in which case we will not create a new Event
 - Members may deposit incorrect metadata.

## Further information

 - [Crossref Schema documentation](https://support.crossref.org/hc/en-us/categories/201744683-Metadata-and-Schema)
