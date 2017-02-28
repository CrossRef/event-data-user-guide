# DataCite to CrossRef Links

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | datacite_crossref |
| Consumes Artifacts        | none |
| Matches by                | DOI |
| Produces relation types   | cites |
| Fields in Evidence Record | no evidence record |
| Freshness                 | daily |
| Data Source               | DataCite API |
| Coverage                  | All DOIs |
| Relevant concepts         | [External Agents](#contept-external-agent), [Occurred-at vs collected-at](concepts#concept-timescales) |
| Operated by               | DataCite |

When members of DataCite deposit datasets, they can include links to Crossref Registered Content via their Crossref DOIs. The DataCite agent monitors these links and sends them to Event Data. As this is an External Agent, there are no Artifacts or Evidence Records.

### Example Event

    {
      "obj_id":"https://doi.org/10.1007/S10518-016-9982-8",
      "occurred_at":"2016-08-19T20:30:00Z",
      "subj_id":"https://doi.org/10.13127/ITACA/2.1",
      "total":1,
      "id":"71e62cbd-28a8-4a41-9b74-7e58dca03efc",
      "message_action":"create",
      "source_id":"datacite_crossref",
      "timestamp":"2016-08-19T22:14:33Z",
      "relation_type_id":"cites"
    }

### Methodology

 - DataCite operate an Agent that scans its Metadata API for new citations to Crossref DOIs. When it finds links, it deposits them.
 - It can also scan for back-files

### Notes

 - Because the Agent can scan for back-files, it is possible that duplicate Events may be re-created. See [Duplicate Data](concepts#concept-duplicate).
 - Because the Agent can scan for back-files, Events may be created with `occurred_at` in the past. See [Occurred-at vs collected-at](concepts#concept-timescales).
