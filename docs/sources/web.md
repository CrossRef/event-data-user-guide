# Web

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | web |
| Matches by                | Landing Page URL hyperlink, DOI hyperlink, DOI text |
| Consumes Artifacts        | `domain-list`, `doi-prefix-list` |
| Produces relation types   | `mentions` |
| Freshness                 | Undefined |
| Coverage                  | Random collection of web pages |
| Identifies links by       | Linked DOIs, unlinked DOIs, linked landing page domains |
| Operated by               | Crossref |
| Agent                     | event-data-web-agent |

## What it is

Events from any non-member web page we think might be relevant. We monitor a list of URLs that we think might have links to Items via their DOIs or Landing Pages, and then follow them to see if we can find any Items. We curate this list, as best we can, to ensure that we never follow a link when we believe it belongs to a Crossref member or when directed not to by robots.txt.

The list of URLs can come from a range of sources, including those submitted by users. If you have such a list, feel free to contact us. 

## What it does

A list of URLs is maintained. The Agent submits every URL to the Percolator. The Percolator looks for linked or unlinked DOIs, or linked article landing pages in the HTML of each page.

## Where data comes from

 - A list of URLs that we compile internally, and that are submitted by users.
 - The content of each web page on the list.

## Example Event

*Content to follow.*

## Methodology

1. A list of URLs is maintained manually.
2. We remove URLs that belong to any domain in the `domain-list` Artifact. This means that we do not visit webpages that belong to Publishers.
3. We remove URLs that might be picked up via other sources, e.g. Wikipedia and Reddit
4. The Web agent pics batches of URLs the URL list and sends them to the Percolator.
5. The Percolator visits each URL to look for Events.

## Evidence Record

*Content to follow.*

## Edits / Deletion

 - Events may be edited if they are found to be faulty, e.g. non-existent DOIs
 - If we mistakenly collect Events for a publisher site, the publisher may reasonably ask us to remove them.

## Quirks

The selection of URLs doesn't follow any particular pattern. 

## Failure modes

 - Publisher sites may block the Event Data Bot collecting Landing Pages.
 - Publisher sites may prevent the Event Data Bot collecting Landing Pages with robots.txt
