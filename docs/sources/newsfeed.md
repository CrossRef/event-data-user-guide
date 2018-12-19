# Newsfeed

| | |
|---------------------------|-|
| Agent Source token        | `c1bfb47c-39b8-4224-bb18-96edf85e3f7b` |
| Consumes Artifacts        | `newsfeed-list` |
| Subject coverage          | Blog posts mentioned in RSS and Atom feeds on `newsfeed-list`  |
| Object coverage           | All DOIs, landing page URLs, plain-text DOIs. |
| Data contributor          | Curators of RSS and Atom feed aggregators. Authors of blog posts. |
| Data origin               | RSS and Atom feeds, and the blog posts they point to. |
| Freshness                 | Every few hours. |
| Identifies                | Linked DOIs, unlinked DOIs, Landing Page URLs |
| License                   | Creative commons [CC0 1.0 Universal (CC0 1.0)](https://creativecommons.org/publicdomain/zero/1.0/) |
| Looks in                  | HTML of webpages (mostly blog posts) linked to from RSS and Atom feeds. |
| Name                      | Newsfeed |
| Operated by               | Crossref |
| Produces Evidence Records | Yes |
| Produces relation types   | `discusses` |
| Source ID                 | `newsfeed` |
| Updates or deletions      | None expected |

## What it is

Links from blogs and other content with a newsfeed. 

## What it does

The Agent has a list of RSS feeds. It monitors each one for links to blog posts. If a blog post links to registered content, or mentions DOIs in the text, they are extracted into Events.

## Where data comes from

The `newsfeed-list` Artifact is consulted. On a regular basis the Agent retrieves the Artifact, then follows the link to every blog post or page mentioned. Data sources:

1. The `newsfeed-list` Artifact, curated by Crossref.
2. The content of each newsfeed. Each newsfeed may be operated by a different organization. 
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
3. It passes the URL of every blog post to the Percolator.

## Evidence Record

 - Includes batches of `landing-page-url` type observations.

## Edits / deletion

 - Events may be edited if they are found to be faulty, e.g. non-existent DOIs

## Quirks

 - Links to blog posts are followed. If a summary of the blog post is included in the RSS feed, it is not consulted.

## Failure modes

 - RSS feeds may be taken offline.
 - RSS feeds may contain incomplete data.
 - RSS feeds may update too quickly for the Agent to keep up.
 - Publisher sites may block the Event Data Bot collecting landing pages.
 - Publisher sites may prevent the Event Data Bot collecting landing pages with robots.txt
 - Blog sites may block the Event Data Bot collecting landing pages.
 - Blog sites may prevent the Event Data Bot collecting landing pages with robots.txt

## Further information

 - [RSS on Wikipedia](https://en.wikipedia.org/wiki/RSS)

