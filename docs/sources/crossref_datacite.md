# Crossref to DataCite Links

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | crossref_datacite |
| Consumes Artifacts        | none |
| Matches by                | DOI |
| Produces relation types   | cites |
| Freshness                 | Daily |
| Data Source               | Crossref Metadata API |
| Coverage                  | All DOIs |
| Relevant concepts         | [Occurred-at vs collected-at](concept#concept-timescales), [Duplicate Data](concept#concept-duplicate) |
| Operated by               | Crossref |
| Agent                     | Cayenne |

When members of Crossref (who are mostly Scholarly Publishers) deposit metadata, they can deposit links to datasets via their DataCite DOIs. The Crossref Metadata API monitors these links and sends them to Event Data. As this is an internal system there are no Artifacts as the data comes straight from the source.

### Example Event

    {
      "obj_id":"https://doi.org/10.13127/ITACA/2.1",
      "occurred_at":"2016-08-19T20:30:00Z",
      "subj_id":"https://doi.org/10.1007/S10518-016-9982-8",
      "total":1,
      "id":"71e62cbd-28a8-4a41-9b74-7e58dca03efc",
      "message_action":"create",
      "source_id":"crossref_datacite",
      "timestamp":"2016-08-19T22:14:33Z",
      "relation_type_id":"cites"
    }

### Methodology

 - The Metadata API scans incoming Content Registration items and when it finds links to DataCite DOIs, it adds the Events to CED.
 - It can also scan back-files for links.

### Notes

 - Because the Agent can scan for back-files, it is possible that duplicate Events may be re-created. See [Duplicate Data](concept#concept-duplicate).
 - Because the Agent can scan for back-files, Events may be created with `occurred_at` in the past. See [Occurred-at vs collected-at](concept#concept-timescales).

