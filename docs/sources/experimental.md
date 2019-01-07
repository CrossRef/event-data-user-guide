# Experimental sources

Experimental Events are data we collect as part of prototypes and experiments. It is not available in the API by default, but you can retrieve them from the <https://api.eventdata.crossref.org/v1/events/experimental> . It also contains data from the early version of Crossref Event Data that might not meet the production criteria for quality and evidence. 

**Experimental Events should not be used for production purposes.**

## Experimental source: PLAUDiT

| | |
|---------------------------|-|
| Agent Source token        | `e330ad99-b54e-4557-a81c-b9178ed7953f` |
| Consumes Artifacts        | None |
| Subject coverage          | ORCID IDs |
| Object coverage           | DOIs |
| Data contributor          | PLAUDiT.pub |
| Data origin               | PLAUDiT.pub |
| Freshness                 | Life |
| Identifies                | Users' ORCID IDs who want to ensorse a paper. |
| License                   | Creative commons [CC0 1.0 Universal (CC0 1.0)](https://creativecommons.org/publicdomain/zero/1.0/) |
| Name                      | PLUADiT |
| Operated by               | PLAUDiT |
| Produces Evidence Records | No |
| Produces relation types   | `likes` |
| Produces relation subtypes| `clear`, `robust` or `exciting` |
| Source ID                 | `plaudit` |
| Updates or deletions      | None expected |


## What it is

Created as part of the [eLife Innovation Sprint 2018](https://elifesciences.org/events/c40798c3/elife-innovation-sprint-2018).

Plaudit is a simple, lightweight mechanism for an individual with an ORCID to endorse an object with a DOI. Using the Plaudit button they can add their endorsement to an article, using their ORCID. Endorsements can say that an article is "clear", "robust" or "exciting". Each Plaudit endorsement shows up as an individual Event saying "the person with this ORCID ID applauds the article with this DOI". The type of endorsement is recorded in the `relation_subtype_id` field.

## What it does

Every time a new interaction occurs on Plaudit, an Event is created and sent into Crossref Event Data.

## Example Event

    {
      "license": "https://creativecommons.org/publicdomain/zero/1.0/",
      "obj_id": "https://doi.org/10.3201/eid2202.151250",
      "source_token": "e330ad99-b54e-4557-a81c-b9178ed7953f",
      "occurred_at": "2016-01-26T01:49:17Z",
      "subj_id": " https://orcid.org/0000-0002-0840-454X",
      "id": "53133861-1f04-447e-b419-05d5a6221b5c",
      "action": "add",
      "subj": {
        "pid": "https://orcid.org/0000-0002-0840-454X",
      },
      "source_id": "plaudit",
      "obj": {
        "pid": "https://doi.org/10.5555/12345678",
      },
      "timestamp": "2017-02-22T17:16:17Z",
      "relation_type_id": "likes",
      "relation_subtype_id": "clear"
    }

## Evidence Record

Events are sent directly as they happen. No Evidence Records are created.

## Edits / deletion

We don't expect to have to edit or delete any Events.

## Quirks

 - Plaudit only works when it's been installed on the publisher's webpage or a user has the browser plugin. 

## Failure modes

None expected.

## Further information

- <https://plaudit.glitch.me/>

