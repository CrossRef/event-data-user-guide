# Hypothes.is

Content to follow soon.

<!--
| Property                  | Value          |
|---------------------------|----------------|
| Name                      | `wordpressdotcom` |
| Matches by                | Landing Page URL hyperlink, DOI hyperlink, DOI text |
| Consumes Artifacts        | `domain-list` |
| Produces relation types   | `mentions` |
| Freshness                 | every few hours |
| Data Source               | Wordpress.com API |
| Coverage                  | All blogs hosted on Wordpress |
| Relevant concepts         | [Pre-filtering](#pre-filtering) |
| Operated by               | Crossref |
| Agent                     | event-data-wordpress-agent |

## What it is

Links from Wordpress blogs **hosted on the wordpress.com domain**. 

## What it does

The Agent monitors the Wordpress API for blog posts that mention Items via DOI links or links to Landing Pages. Each blog post is checked for links to articles via plain text DOIs, DOI hyperlinks and landing page URL hyperlinks.

## Where data comes from

 - The `domain-list` Artifact is consulted. On a regular basis the Agent retrieves the Artifact, then follows the link to every blog post or page mentioned.
 - The Wordpress.com API is searched for links to blogs
 - Each individual blog

## Example Event

*Content to follow*

## Methodology

On a regular basis (approximately every six hours) the Wordpress Agent starts a scan. Each scan:

1. It downloads a copy of the latest version of the `domain-list` Artifact.
2. For every domain in the domain list (including doi.org):
    1. It queries the Wordpress API for blog posts that relate to that domain. The request is sorted by recently occurred. It consumes all pages of data to cover the time period since the last scan.
    2. Every response from the Wordpress API includes a link to a blog post. This link is sent to the Percolator.
    3. The Percolator follows the link and looks at the HTML of the page.

## Evidence Record

*Content to follow*

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

 - [Wordpress.com](http://wordpress.com)

-->