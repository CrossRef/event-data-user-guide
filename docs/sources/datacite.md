# DataCite metadata

|-|-|
|---------------------------|-|
| Agent                     | `28276d12-b320-41ba-9272-bb0adc3466ff` |
| Consumes Artifacts        | None |
| Subject coverage          | All DataCite DOIs |
| Object coverage           | All Crossref DOIs |
| Data contributor          | DataCite |
| Data origin               | DataCite metadata deposited by Crossref members |
| Freshness                 | Every few hours |
| Identifies                | DOIs |
| License                   | Creative commons [CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/) |
| Looks in                  | References in DataCite schema |
| Name                      | DataCite metadata |
| Operated by               | DataCite |
| Produces Evidence Records | No |
| Produces relation types   | `references` and other types found in the DataCite schema |
| Source ID                 | `datacite` |
| Updates or deletions      | None expected |

## What it is

Links from DataCite DOIs to Crossref DOIs. These are recorded in the metadata for DataCite's registered content. The data is ultimately supplied by DataCite members who are the publishers and 'owners' of the registered content.

Only Relations between DataCite DOIs and Crossref DOIs are included. If you want other metadata you can find it in DataCite's APIs.

## What it does

The Agent monitors all relationships in DataCite metadata deposited by members. Where a relation is made between a DataCite DOI and a Crossref DOI, that link is sent in an Event.

## Where data comes from

Metadata deposits from DataCite members, usually publishers and libraries.

## Example Event

    {
      "license": "https://creativecommons.org/publicdomain/zero/1.0/",
      "obj_id": "https://doi.org/10.2973/odp.proc.ir.155.1995",
      "source_token": "28276d12-b320-41ba-9272-bb0adc3466ff",
      "occurred_at": "2005-06-21T01:42:46Z",
      "subj_id": "https://doi.org/10.1594/pangaea.272094",
      "id": "00070ea8-1dc6-4989-9c77-ee32e2818c14",
      "terms": "https://doi.org/10.13003/CED-terms-of-use",
      "message_action": "create",
      "source_id": "datacite",
      "timestamp": "2017-04-01T08:22:01Z",
      "relation_type_id": "references"
    }

## Methodology

1. A member makes an XML deposit with DataCite.
2. The agent monitors new deposits (or back-fills).
3. When a link is found an Event is created if:
    - it is to a non-DataCite DOI
    - it has not already been reported to Event Data

## Evidence Record

No Evidence Record is created because the events come straight from the data source into Event Data.

## Edits / deletion

We do not anticipate that Events are ever deleted or edited.

## Quirks

None.

## Failure modes

 - Members may remove references before the Agent first scans the data, in which case we will not create a new Event.
 - Members may deposit incorrect metadata.

## Further information

 - [DataCite schema](https://schema.datacite.org/)
