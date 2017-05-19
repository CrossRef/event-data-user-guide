# Hypothes.is

| Agent Source Token        | `8075957f-e0da-405f-9eee-7f35519d7c4c` |
| Consumes Artifacts        | `domain-list` |
| Subject Coverage          | All Hypothes.is annotations that are available to the public |
| Object Coverage           | All DOIs, Landing Page URLs, plain-text DOIs. |
| Data Contributor          | Hypothes.is |
| Data Origin               | Annotations made by Hypothes.is users, via the Hypothes.is API |
| Freshness                 | Every few hours. |
| Identifies                | Linked DOIs, unlinked DOIs, Landing Page URLs |
| License                   | Creative Commons [CC0 1.0 Universal (CC0 1.0)](https://creativecommons.org/publicdomain/zero/1.0/) |
| Looks in                  | URL for annotation, text of annotations |
| Name                      | Hypothes.is |
| Operated by               | Crossref |
| Produces Evidence Records | Yes |
| Produces relation types   | `annotates`, `discusses` |
| Source ID                 | `hypothesis` |
| Updates or deletions      | None expected |

## What it is

Users of the Hypothes.is annotate and discuss webpages. The Hypothes.is Agent monitors annotations. It looks for two things: the annotation of Registered Content (for example Article Landing pages) and the mentioning of Registered Content (for example DOIs) in the text of annotations.

## What it does

When looking for annotations of Registered Content:

 - Scans every Article Landing Page domain in the `domain-list`, including `doi.org`
 - Makes a query to the Hypothes.is API for annotations to URLs on that domain.
 - For each result, attempts to reverse that URL back to a Registered Content Item, recording an Event with the `annotates` relation type.

 - Scans every Article Landing Page domain in the `domain-list`, including `doi.org`
 - Makes a query to the Hypothes.is API for annotations that contain URLs on that domain in the text of the annotation.
 - For each result, looks in the text for links to Registered Content and records Events with the `discusses` relation type.

## Example Event

Annotates:

  {
    "license": "https://creativecommons.org/publicdomain/zero/1.0/",
    "obj_id": "https://doi.org/10.1007/bfb0105342",
    "source_token": "8075957f-e0da-405f-9eee-7f35519d7c4c",
    "occurred_at": "2015-11-04T06:30:10Z",
    "subj_id": "https://hypothes.is/a/NrIw4KlKTwa7MzbTrMAyjw",
    "id": "00044ac9-d729-4d3f-a2c8-618bcdf1d252",
    "evidence_record": "https://evidence.eventdata.crossref.org/evidence/20170412-hypothesis-de560308-e500-4c55-ba28-799d7b272039",
    "terms": "https://doi.org/10.13003/CED-terms-of-use",
    "action": "add",
    "subj": {
      "pid": "https://hypothes.is/a/NrIw4KlKTwa7MzbTrMAyjw",
      "json-url": "https://hypothes.is/api/annotations/NrIw4KlKTwa7MzbTrMAyjw",
      "url": "https://hyp.is/NrIw4KlKTwa7MzbTrMAyjw/arxiv.org/abs/quant-ph/9803052",
      "type": "annotation",
      "title": "[This article](http://arxiv.org/abs/quant-ph/9803052) was referenced by ["Decoherence"](http://web.mit.edu/redingtn/www/netadv/Xdecoherenc.html) on Sunday, September 25 2005.",
      "issued": "2015-11-04T06:30:10Z"
    },
    "source_id": "hypothesis",
    "obj": {
      "pid": "https://doi.org/10.1007/bfb0105342",
      "url": "http://arxiv.org/abs/quant-ph/9803052"
    },
    "timestamp": "2017-04-12T07:16:20Z",
    "relation_type_id": "annotates"
  }

Discusses:

    {
      "license": "https://creativecommons.org/publicdomain/zero/1.0/",
      "obj_id": "https://doi.org/10.1146/annurev.earth.32.082503.144359",
      "source_token": "8075957f-e0da-405f-9eee-7f35519d7c4c",
      "occurred_at": "2015-05-11T04:03:44Z",
      "subj_id": "https://hypothes.is/a/qNv_Ei5ZSnWOWO54GXdFPA",
      "id": "00054d54-7f35-4557-b083-7fa1f028856d",
      "evidence_record": "https://evidence.eventdata.crossref.org/evidence/20170413-hypothesis-a37bc9bf-1dc0-4c8a-b943-2e14beb4de6f",
      "terms": "https://doi.org/10.13003/CED-terms-of-use",
      "action": "add",
      "subj": {
        "pid": "https://hypothes.is/a/qNv_Ei5ZSnWOWO54GXdFPA",
        "json-url": "https://hypothes.is/api/annotations/qNv_Ei5ZSnWOWO54GXdFPA",
        "url": "https://hyp.is/qNv_Ei5ZSnWOWO54GXdFPA/www.cnn.com/2015/05/05/opinions/sutter-sea-level-climate/#",
        "type": "annotation",
        "title": "The various scenarios presented should be specified as being global averages of expected sea level rise. The sea level rise observed locally will vary significantly, due to a lot of different geophysical factors.

        For instance, the ongoing recovery of the Earth's surface to the impact of the last ice age causes a natural change in local observations of sea level, with some regions sinking or rising (thus mitigating, or aggravating the impact of mean sea level change) (for example, see Peltier, 2004: http://www.annualreviews.org/doi/abs/10.1146/annurev.earth.32.082503.144359).

        Also, the observed local sea level rise due to the melting of land ice will not be uniform globally, due to the gravitational response of the Earth to the changing distribution of mass at its surface (see Spada et al., 2013: http://onlinelibrary.wiley.com/doi/10.1029/2012GL053000/abstract, and Hay et al., 2015: http://www.nature.com/nature/journal/v517/n7535/full/nature14093.html).
        ",
        "issued": "2015-05-11T04:03:44Z"
      },
      "source_id": "hypothesis",
      "obj": {
      "pid": "https://doi.org/10.1146/annurev.earth.32.082503.144359",
      "url": "https://doi.org/10.1146/annurev.earth.32.082503.144359"
      },
      "timestamp": "2017-04-13T10:40:18Z",
      "relation_type_id": "discusses"
    }


## Evidence Record

 - Creates observations of type `landing-page-url` for `annotates` relation types.
 - Creates observations of type `plaintext` for `discusses` relation types.

## Edits / Deletion

 - Events may be edited if they are found to be faulty, e.g. non-existent DOIs

## Quirks

Note that this only monitors blogs hosted on Wordpress' hosted wordpress.com platform. It does not monitor all blogs that use the Wordpress software.

## Failure modes

 - Publisher sites may block the Event Data Bot collecting Landing Pages.
 - Publisher sites may prevent the Event Data Bot collecting Landing Pages with robots.txt
 - Wordpress.com may block the Agent
 - Wordpress.com may block the Percolator Bot

## Further information

 - [Hypothes.is](http://hypothes.is)

