# Artifacts

Crossref maintains a number of Artifacts. These are individual pieces of information that we have produced internally which enable Agents or other parts of the Event Data system to do their job. They contain information like:

 - the list of domains where we think we'll find Publisher Landing Pages
 - the list of DOI prefixes
 - the list of available sources

Every Artifact has a label and a version number. Whenever one is used, its label and version number are mentioned in an Evidence Record. This way you can trace the provenance of an Event all the way back. For example you may wish to know why an Event was captured for this Landing Page domain but not this one. The Artifact will tell you which domains we knew about, when.

Here are the current Artifacts in use:

| Name | Purpose |
|------|---------|
| `crossref-doi-prefix-list` | List of prefixes that are issued to Crossref members. |
| `crossref-domain-list` | List of Domains that resolve from Crossref DOIs. |
| `crossref-sourcelist` | List of sources that are available in the Crossref Query API. |
| `datacite-doi-prefix-list` | List of prefixes that are issued to DataCite members. |
| `datacite-domain-list` | List of Domains that resolve from DataCite DOIs. |
| `doi-prefix-list` | Union of `crossref-doi-prefix-list` and `datacite-doi-prefix-list`. |
| `domain-list` | Union of `crossref-domain-list` and `datacite-domain-list`. |
| `exclude-domains` | Domains that should be ignored, e.g youtube.com |
| `newsfeed-list` | List of RSS and Atom feeds that the Newsfeed Agent follows. |
| `stackexchange-sites` | List of StackExchange sites that the StackExchange Agent follows. |
| `subreddit-list` | List of Subreddits that the Reddit Agent follows. |

You will see Artifacts mentioned in Evidence Records when they are used by Agents. You can browse all of the Artifacts, including their previous versions in the [Artifact Registry](../service/artifact-registry).
