# URLs in Depth

For context please see [Content Items, URLs, Persistent Identifiers and DOIs](concepts#concept-items-urls-dois).

## Landing Page Conflict Resolution

The DOI-URL Mapping is a one-to-one mapping: every DOI is mentioned only once and every URL is mentioned only once. If we find two DOIs that resolve to the same URL, we use the following process:

1. If a URL maps to only one DOI, that mapping is used.
2. If two DOIs map to one DOI and one Item a parent of the other (indicated by the `parent_doi` tag in the metadata), then the parent DOI is used for the mapping.
3. If two DOIs map to one URL we look in the metadata for the `publication_type`. If one has a value of `full_text` and the other has a value of `abstract_only` or `bibliographic_record`, the Item with the `publication_type` of `full_text` is used.
4. Failing that, the mapping is excluded.

<img src='../images/conflict-resolution.svg" alt="Conflict Resolution Examples" class="img-responsive">

Note that this process is used only when constructing the DOI-URL list, in order that URLs can be mapped to DOIs. If an Event that mentions e.g. a component DOI is produced by a source, the event will be recorded against the Item with that Component DOI.

<a name="in-depth-doi-reversal"></a>
## DOI Reversal Service

The DOI Reversal Service converts Landing Pages back into DOIs so they can be used to identify Items. It uses a variety of techniques including:

 - looking up the Landing Page in the `url-doi` Artifact mapping.
 - searching for a valid DOI embedded in the URL
 - looking up SICIs (Serial Item and Contribution Identifier) embedded in the URL
 - looking up PIIs (Publisher Item Identifier)
 - looking in the HTML metadata of the URL to see if a DOI is supplied

The process of DOI Reversal is not perfect and because these methods may not always succeed it will never be possible to match 100%. See [URLS in Depth](urls-in-depth) for a discussion of some of the issues.
