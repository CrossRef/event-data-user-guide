# DataCite Links

|-|-|
|---------------------------|-|
| Agent                     | `28276d12-b320-41ba-9272-bb0adc3466ff` |
| Consumes Artifacts        | None |
| Subject Coverage          | All DataCite DOIs |
| Object Coverage           | All Crossref DOIs |
| Data Contributor          | DataCite |
| Data Origin               | DataCite Metadata deposited by Crossref Members |
| Freshness                 | Every few hours |
| Identifies                | DOIs |
| License                   | Creative Commons [CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/) |
| Looks in                  | References in DataCite Schema |
| Name                      | DataCite Links |
| Operated by               | DataCite |
| Produces Evidence Records | No |
| Produces relation types   | `references` and other types found in the DataCite schema |
| Source ID                 | `datacite` |
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
