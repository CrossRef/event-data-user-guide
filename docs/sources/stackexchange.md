# StackExchange

| | |
|---------------------------|-|
| Agent Source Token        | `a8affc7d-9395-4f1f-a1fd-d00cfbdfa718` |
| Consumes Artifacts        | `stackexchange-sites`, `domain-list` |
| Subject Coverage          | Questions and Answers on all StackExchange sites |
| Object Coverage           | All DOIs, all Article Landing Pages |
| Data Contributor          | StackExchange |
| Data Origin               | Questions and Answers on StackExchange sites |
| Freshness                 | Every few days |
| Identifies                | Linked DOIs, unlinked DOIs, Landing Page URLs |
| License                   | Creative Commons [Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/) |
| Looks in                  | Text of Questions and Answers |
| Name                      | StackExchange |
| Operated by               | Crossref |
| Produces Evidence Records | Yes |
| Produces relation types   | `discusses` |
| Source ID                 | `stackexchange` |
| Updates or deletions      | None expected |


## What it is

StackExchange is a network of 'question and answer' sites. It originated with StackOverflow.com but now includes a large network of sites, each of which covers a specific subject area. Users may post questions and other users may post answers. When a question or an answer includes a link to Registered Content we will detect it.

## What it does

The StackExchange Agent aims to cover all StackExchange sites. To do this it runs two processes. The first one covers sites where we expect to find links, and scans every few days. The second covers all other StackExchnage sites and scans every month or two.

Regular scan:

 - Retrieves the list of StackExchange sites we're interested in from the `stackexchange-sites` Artifact
 - Scans every article Landing Page domain in the `domain-list`, including `doi.org`.
 - For each site and each domain, make a search query for questions and answers on that site that mention that domain.
 - For each link found, attempt to match that to a DOI.

Full scan:

 - Retrieves the full list of all StackExchange sites from StackExchange API.
 - Scans every article Landing Page domain in the `domain-list`, including `doi.org`.
 - For each site and each domain, make a search query for questions and answers on that site that mention that domain.
 - For each link found, attempt to match that to a DOI.

## Example Event

    {
      "license": "https://creativecommons.org/licenses/by-sa/4.0/",
      "obj_id": "https://doi.org/10.1063/1.1792071",
      "source_token": "a8affc7d-9395-4f1f-a1fd-d00cfbdfa718",
      "occurred_at": "2015-12-01T10:15:35Z",
      "subj_id": "https://chemistry.stackexchange.com/a/41547",
      "id": "00185922-5dee-40ad-9726-8fb7c2cf1746",
      "evidence_record": "https://evidence.eventdata.crossref.org/evidence/20170413-stackexchange-b22762bf-7d83-47b6-99b8-a7e173973ada",
      "terms": "https://doi.org/10.13003/CED-terms-of-use",
      "action": "add",
      "subj": {
        "pid": "https://chemistry.stackexchange.com/a/41547",
        "title": "How important is it that geometry be optimized at a high level of theory?",
        "issued": "2015-12-01T10:15:35Z",
        "type": "comment",
        "author": {
          "url": "https://chemistry.stackexchange.com/users/186/wildcat",
          "name": "Wildcat",
          "id": 186
        }
      },
      "source_id": "stackexchange",
      "obj": {
        "pid": "https://doi.org/10.1063/1.1792071",
        "url": "http://doi.org/10.1063/1.1792071"
      },
      "timestamp": "2017-04-13T20:03:24Z",
      "relation_type_id": "discusses"
    }

## Evidence Record

 - Contains observations of type `plaintext`. This the text of the Question or Answer. The `sensitive` hash is set to true, but you can find the link to the Question in the Event.

## Edits / Deletion

We don't expect to have to edit or delete any Events.

## Quirks

The Event is captured at the point it is returned from the StackExchange search. It may be edited before or after it is captured. We don't detect if it has been edited, so you should be aware of this. 

The Agent is only aware of Questions or Answers that are matched via a Landing Page or doi.org domain. If an answer mentions an unlinked DOI (i.e. plain text DOIs such as `10.5555/12345678`) we will not retrieve it. However, if the Agent does become aware of a Question or Answer because it contains a linked DOI or Landing Page URL and it also contain an unlinked DOI, it will match both.

## Failure modes

 - Publisher sites may block the Event Data Bot collecting Landing Pages.

## Further information

 - https://stackexchange.com

