# Crossref Links

| | |
|---------------------------|-|
| Agent Source Token        | `8676e950-8ac5-4074-8ac3-c0a18ada7e99` |
| Consumes Artifacts        | none |
| Subject coverage          | All Crossref DOIs |
| Object Coverage           | All DataCite DOIs |
| Data Contributor          | Crossref |
| Data Origin               | Crossref Metadata deposited by Crossref Members |
| Freshness                 | Every few hours |
| Identifies                | DOIs |
| License                   | Made available without restriction |
| Looks in                  | References in Crossref Schema |
| Name                      | Crossref Links |
| Operated by               | Crossref |
| Produces Evidence Records | No |
| Produces relation types   | `references` and other types found in the Crossref schema |
| Source ID                 | `crossref` |
| Updates or deletions      | None expected |

## What it is

Links from Crossref DOIs to DataCite DOIs. These are recorded in the metadata for Crosref's Registered Content. The data is ultimatley supplied by Crossref members who are the publishers and 'owners' of the Registered Content.

Only Relations between Crossref DOIs and DataCite DOIs are included. If you want other metadata you can find it in the [Crossref Metadata REST API](https://www.crossref.org/services/metadata-delivery/rest-api/).

In future we may add links to other objects, such as ORCID IDs and Clinical Trial Numbers.

## What it does

The Agent monitors all relationships in Crossref metadata deposited by members. Where a relation is made between a Crossref DOI and a DataCite DOI, that link is sent in an Event.

## Where data comes from

Metadata deposits from Crossref members, usually publishers.

## Example Event

    {
      "obj_id":"https://doi.org/10.13127/ITACA/2.1",
      "occurred_at":"2016-08-19T20:30:00Z",
      "subj_id":"https://doi.org/10.1007/S10518-016-9982-8",
      "total":1,
      "id":"8676e950-8ac5-4074-8ac3-c0a18ada7e99",
      "message_action":"create",
      "source_id":"crossref",
      "timestamp":"2016-08-19T22:14:33Z",
      "terms": "https://doi.org/10.13003/CED-terms-of-use",
      "relation_type_id":"cites"
    }

## Methodology

1. A member makes an XML deposit with Crossref.
2. The agent monitors new deposits (or back-fills).
3. When a link is found an Event is created if:
    - it is to a non-Crossref DOI
    - it has not already been reported to Event Data

## Evidence Record

No evidence record is created because the events come straight from the data source into Event Data.

## Edits / Deletion

We do not anticipate that Events are ever deleted or edited.

## Quirks

None.

## Failure modes

 - Member may remove references before the Agent first scans the data, in which case we will not create a new Event
 - Member may deposit incorrect metadata.

## Further information

 - [Crossref Schema documentation](https://support.crossref.org/hc/en-us/categories/201744683-Metadata-and-Schema)
