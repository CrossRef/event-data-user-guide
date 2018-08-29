# The Lens

| | |
|---------------------------|-|
| Agent Source Token        | `1ad0b713-78ed-4bb9-8d5d-a3c2d163d46f` |
| Consumes Artifacts        | None |
| Subject Coverage          | All patents tracked by Cambia Lens. |
| Object Coverage           | All DOIs identified by Cambia Lens. |
| Data Contributor          | The Lens, Cambia. |
| Data Origin               | The Lens, Cambia. |
| Freshness                 | Every few hours. |
| Identifies                | Content with DOIs cited in Patents. |
| License                   | Creative Commons Attribution-ShareAlike 4.0 International  [(CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/) |
| Looks in                  | Citations from patents. |
| Name                      | Cambia Lens. |
| Operated by               | The Lens, Cambia. |
| Produces Evidence Records | No. |
| Produces relation types   | `cites` |
| Source ID                 | `cambia-lens` |
| Updates or deletions      | When errors are identified or metadata is cleaned up. |

## What it is

The Lens serves nearly all of the patent documents in the world as open, annotatable digital public goods that are integrated with scholarly and technical literature along with regulatory and business data. 

When citations from patents to the scholarly literature are identified and can be matched to a DOI, that citation will be made available via Event Data. Patents are identified by their Lens ID.


## What it does

The lens identifies links and metadata from patents. When it sees citations using DOIs, it sends them to Crossref Event Data.

All subject types are patents, but the following types of patents may be indicated via the `work_subtype_id`:

 - `Abstract`
 - `ambiguous`
 - `Amended Patent`
 - `Granted Patent`
 - `Limited Patent`
 - `Patent Application`
 - `Plant patent`
 - `Search report`
 - `Statutory Invention Registration`
 - `unknown`

## Example Event

    {
      "license": "https://creativecommons.org/licenses/by-sa/4.0/",
      "obj_id": "https://doi.org/10.1002/chin.200416142",
      "source_token": "1ad0b713-78ed-4bb9-8d5d-a3c2d163d46f",
      "occurred_at": "2014-06-17T00:00:00Z",
      "subj_id": "https://lens.org/173-631-769-260-712",
      "id": "fba4a28f-9bb8-682e-d742-eefeab0f8e04",
      "terms": "https://doi.org/10.13003/CED-terms-of-use",
      "action": "add",
      "subj": {
        "work_subtype_id": "Granted Patent",
        "work_type_id": "patent",
        "title": "Cycloalkyl Containing Thienopyrimidines For Pharmaceutical Compositions",
        "pid": "https://lens.org/173-631-769-260-712",
        "jurisdiction": "US"
      },
      "source_id": "cambia-lens",
      "timestamp": "2017-11-10T19:40:21Z",
      "relation_type_id": "cites"
    }

## Evidence Record

As Cambia Lens Events are created by an external party, Evidence Records are not generated for these Events.

## Edits / Deletion

Edits and deletions may be made when a citation has been misidentified or when subject metadata (such as the title) is edited.

## Quirks

None known.

## Failure modes

 - The Lens may temporarily stop sending Events

## Further information

 - <https://www.lens.org/>
 - <https://www.lens.org/about/>
 - <https://www.lens.org/about/news/category/release-notes/>
