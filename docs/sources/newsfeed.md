# Newsfeed

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | `newsfeed` |
| Matches by                | Landing Page URL hyperlink, DOI hyperlink, DOI text |
| Consumes Artifacts        | `newsfeed-list` |
| Produces relation types   | `mentions` |
| Fields in Evidence Record |  |
| Freshness                 | half-hourly |
| Data Source               | Multiple blog and aggregator RSS feeds |
| Coverage                  | All DOIs |
| Relevant concepts         | [Unambiguously linking URLs to DOIs](concepts#concept-urls), [Duplicate Data](concepts#concept-duplicate), [Landing Page Domains](concepts#concept-landing-page-domains), [Sources that must be queried in their entirety](concepts#concept-query-entirety), [DOI Reversal Service](concepts#in-depth-doi-reversal) |
| Operated by               | Crossref |
| Agent                     | event-data-newsfeed-agent |

## What it is

Links from blogs and other content with a newsfeed. A selection of RSS newsfeeds are monitored for Links to Events. 

## What it does

The Agent has a list of RSS feeds. It monitors each one for links to blog posts. If a blog post links to registered content, or mentions DOIs in the text, they are extracted into Events.

## Where data comes from

The `newsfeed-list` Artifact is consulted. On a regular basis the Agent retrieves the Artifact, then follows the link to every blog post or page mentioned. Data sources:

1. The `newsfeed-list` Artifact, curated by Crossref.
2. The content of each newsfeed. Each newsfeed may be operated by a different organisation. 
3. The content of the individual blog posts.

Example RSS feeds include:

 - ScienceSeeker blog aggregator
 - ScienceBlogging blog aggregator

## Example Event

*Content to follow.*

## Methodology

On a regular basis (approximately every hour) the Newsfeed Agent starts a scan. Each scan:

1. It retrieves the most recent version of the `newsfeed-list` Artifact.
2. It scans over every RSS feed.
3. It passes the URL of every Blog post to the Percolator.

## Evidence Record

*Content to follow.*

## Edits / Deletion

 - Events may be edited if they are found to be faulty, e.g. non-existent DOIs

## Quirks

## Failure modes

 - RSS feeds may be taken offline.
 - RSS feeds may contain incomplete data.
 - RSS feeds may update too quickly for the Agent to keep up.
 - Publisher sites may block the Event Data Bot collecting Landing Pages.
 - Publisher sites may prevent the Event Data Bot collecting Landing Pages with robots.txt
 - Blog sites may block the Event Data Bot collecting Landing Pages.
 - Blog sites may prevent the Event Data Bot collecting Landing Pages with robots.txt

## Further information

 - [RSS on Wikipedia](https://en.wikipedia.org/wiki/RSS)

