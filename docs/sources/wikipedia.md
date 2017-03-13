# Wikipedia

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | Wikipedia |
| Matches by                | Landing Page URL hyperlink, DOI hyperlink, DOI text |
| Consumes Artifacts        | `domain-list`, `doi-prefix-list` |
| Produces relation types   | `references` |
| Freshness                 | Delay of up to 1 hour |
| Data Source               | Wikipedia Recent Changes Stream, Wikipedia RESTBase |
| Coverage                  | All Wikimedia properties. |
| Relevant concepts         | [Matching by DOIs](#concept-matching-dois)|
| Operated by               | Crossref |
| Agent                     | event-data-wikipedia-agent |

## What it is

Items referenced on Wikipedia. Every time a page is edited, every referenced Item generates an Event. 

## What it does


The Wikipedia Agent monitors edits to Wikipedia. It looks at every single edit to every page, and reports on the Items linked from each page version. It also records relationships between Wikipedia pages and their versions where relevant.

## Where data comes from

The Wikipedia EventStream sends a list of edits to Articles. The Percolator visits each one, getting the HTML from the Wikipedia RESTBase API, and looks for events in the rendered HTML.

## Example Event

*Content to follow*

## Methodology

1. The Wikipdia Agent subcribes to the EventStream
2. Every edit to every Article, that version of the Article is sent to the Percolator.
3. The Percolator visits every page version. If the new version has any Items in it, referenced by DOI text, DOI hyperlink or landing page URL, it will create a new Event for every link. Events reference the specific version of the Wikipedia page.
4. An Event that links the version of the page to the canonical URL using the `is_new_version_of` relation type will be produced under certain circumstances. This is provided as a courtesy for consumers of data who may wish to connect DOIs back to the canonical URL of the page. The link will be generated if either:
    1. If there were any Events generated from the new version of the page.
    2. If there were no Events in the new page, the Percolator will look at the old page. If there would have been events in the old version of the page, that means that links might have been removed. Recording an `is_new_version_of` for the new Version but no events indicates that the Agent saw the page and recorded no Events, i.e. they may have been removed.

## Evidence Record

*Content to follow*

## Edits / Deletion

 - Events may be edited if they are found to be faulty, e.g. non-existent DOIs

## Quirks

## Failure modes

 - Publisher sites may block the Event Data Bot collecting Landing Pages.
 - Publisher sites may prevent the Event Data Bot collecting Landing Pages with robots.txt
 - The stream has no catch-up. If the agent is disconnected (which can happen from time to time), then edit events may be missed.
 - The RESTBase API occasionally does not contain the edit mentioned in the change. Although the Agent will retry several times, if it repeatedly receives an error for retriving either the old or the new versions, no event will be returned. This will be recorded in the Evidence Record as an empty input.

## Further information

 - [EventStreams documentation](https://wikitech.wikimedia.org/wiki/EventStreams)
 - [RESTBase API documentation](https://www.mediawiki.org/wiki/RESTBase)
