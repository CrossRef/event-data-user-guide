# The Artifact Registry

Crossref maintains a number of Artifacts. These are individual pieces of information that we have produced which enable Agents to do their job. They contain information like:

 - the list of domains where we think we'll find publisher landing pages
 - the list of DOI prefixes
 - the list of available sources

Every Artifact has a label and a version number. Whenever one is used, its label and version number are mentioned in an Evidence Record. This way you can trace the provenance of an Event all the way back. For example you may wish to know why an Event was captured for this landing page domain but not this one. The Artifact will tell you which domains we knew about, when.

You can see the full list of Artifacts by browsing the Artifact Registry:

    https://artifact.eventdata.crossref.org/a/artifacts.json

Here are the current Artifacts in use:

  - `crossref-doi-prefix-list`
  - `crossref-domain-list`
  - `crossref-sourcelist`
  - `doi-prefix-list`
  - `domain-list`
  - `exclude-domains` 
  - `newsfeed-list`



## Crossref DOI Prefix List: `crossref-doi-prefix-list`

This is the list of DOI prefixes that belong to Crossref, e.g. `10.5555`. It is used when looking for DOIs. It contains every DOI prefix for all Crossref Members.

## Crossref Domain List: `crossref-domain-list`

This is a list of domains that Crossref's DOIs resolve to. The list is created by crawling a sample of DOIs to find their landing page, and recording the domain. The Artifact Part files contain a list of domain names, one per line.

The data is generated automatically but manually curated to some extent. As some DOIs resolve to domains such as google.com and youtube.com, it is simply impractical to use them. See `exclude-domains`.

By providing the domain list as an Artifact, you can answer questions like "why wasn't this landing page matched".

## Crossref Source List - `crossref-sourcelist`

This is the list of CED source ids that we make available in our Query API. 

## DOI Prefix List - `doi-prefix-list`

The full list of DOI prefixes that we are collecting for. It currently includes `crossref-doi-prefix-list` but may include others, e.g. DataCite prefixes in future.

## Domain List - `domain-list`

This is the full list of domains that we are collecting for. It currently includes `crossref-domain-list` but may include others, like DataCite's domains, in future.

## Exclude Domains - `exclude-domains`

The list of domains that we deliberately exclude because we know we can never match landing pages.

# Newsfeed List - `newsfeed-list`

This is a list of RSS and Atom newsfeed URLs. It is manually curated. Each line is a URL that is an RSS or Atom Newsfeed.

If you think a newsfeed is missing from the list, please contact eventdata@crossref.org .

