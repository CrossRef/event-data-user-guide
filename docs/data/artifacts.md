# Artifacts

Crossref maintains a number of Artifacts. These are individual pieces of information that we have produced internally which enable Agents or other parts of the Event Data system to do their job. They contain information like:

 - The list of domains where we think we'll find publisher landing pages.
 - The list of DOI prefixes.
 - The list of available sources.

Every Artifact has a label and a version number. Whenever one is used, its label and version number are mentioned in an Evidence Record. This way you can trace the provenance of an Event. For example you may wish to know why an Event was captured for one landing page domain but not another one. The Artifact will tell you which domains we knew about, and when.

Here are the current Artifacts in use:

| Name | Purpose |
|------|---------|
| `domain-decision-structure` | List of domains, prefixes, and the link between them. |
| `crossref-sourcelist` | List of sources that are available in the Crossref Query API. |
| `datacite-doi-prefix-list` | List of prefixes that are issued to DataCite members. |
| `newsfeed-list` | List of RSS and Atom feeds that the Newsfeed Agent follows. |
| `stackexchange-sites` | List of StackExchange sites that the StackExchange Agent follows. |
| `subreddit-list` | List of Subreddits that the Reddit Agent follows. |

You will see Artifacts mentioned in Evidence Records when they are used by Agents. You can browse all of the Artifacts, including their previous versions in the [Artifact Registry](../service/artifact-registry).

# Deprecated Artifacts

The  `domain-decision-structure` Artifact contains a list of all domains, prefixes, and the relationships between them. You may see the following Artifacts linked to historical data.

| Name | Purpose | Consolidated into |
|------|---------|-------------------|
| `crossref-doi-prefix-list` | List of prefixes that are issued to Crossref members. | `domain-decision-structure` |
| `crossref-domain-list` | List of domains that resolve from Crossref DOIs. | `domain-decision-structure` |
| `datacite-domain-list` | List of domains that resolve from DataCite DOIs. | `domain-decision-structure` |
| `doi-prefix-list` | Union of `crossref-doi-prefix-list` and `datacite-doi-prefix-list`. | `domain-decision-structure` |
| `domain-list` | Union of `crossref-domain-list` and `datacite-domain-list`. | `domain-decision-structure` |
| `exclude-domains` | Domains that should be ignored, e.g youtube.com | `domain-decision-structure` |
