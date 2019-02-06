# Crossref metadata

| | |
|---------------------------|-|
| Agent Source token        | `99c3978e-ec40-4cef-8151-32b62832398c` |
| Consumes Artifacts        | None |
| Subject coverage          | All ORCID iDs |
| Object coverage           | All DOIs |
| Data contributor          | Plaudit |
| Data origin               | Plaudit |
| Freshness                 | Every day |
| Identifies                | ORCID iDs whose owners have endorsed articles with the given DOIs |
| License                   | [CC0 1.0 Universal (CC0 1.0)](https://creativecommons.org/publicdomain/zero/1.0/) |
| Name                      | Plaudit |
| Operated by               | Plaudit |
| Produces Evidence Records | No |
| Produces relation types   | `recommends` |
| Source ID                 | `plaudit` |
| Updates or deletions      | None expected |

## What it is

[Plaudit](https://plaudit.pub/) links researchers, identified by their ORCID, to research they endorse, identified by its DOI. is a simple mechanism that allows an individual with an ORCID iD to endorse a work with a DOI.

## What it does

For every endorsement made through Plaudit, Plaudit creates an Event in Crossref Event Data. Each Event represents an endorsement of DOI Registered Content by an individual using theor ORCID iD.

## Where data comes from

Data is provided directly by Plaudit.

## Example Event

    {
      "obj_id":"https://doi.org/10.7554/elife.36263",
      "occurred_at":"2019-02-05T13:45:49.039Z",
      "subj_id":"https://orcid.org/0000-0002-4013-9889",
      "id":"54a1a4c0-29e5-11e9-a1e3-df8f05e30777",
      "message_action":"add",
      "source_id":"plaudit",
      "timestamp":"2019-02-06T08:00:56Z",
      "relation_type_id":"recommends"
    }

## Methodology

1. A user endorses an academic work through Plaudit.
2. Once a day, Plaudit checks which endorsements have been added since the last export.
3. Plaudit creates new Events for every endorsement created since the last export and sends them to Event Data.

## Evidence Record

No evidence record is created because the events come straight from the data source into Event Data.

## Edits / deletion

We do not anticipate that Events are ever deleted or edited.

## Quirks

None.

## Failure modes

 - An endorsement might have been added after the last export, so the data may be a few hours out of date.

## Further information

 - https://plaudit.pub
