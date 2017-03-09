# The Percolator

The Percolator isn't a source or an Agent, but it is a common part of most most Agents. If you are interested in knowing how data is processed, you should understand how the Percolator works.

Most Agents operated by Crossref collect data from their individual data source and transform it into a range of observations. These observations are packaged up into a bundle and sent to the Percolator, which extracts Events from them and then saves the bundle as an Evidence Record.

## Observations

The following types observations are made:

 - `plaintext` - some text that could contain plain-text DOIs, DOI URLs or Landing Page URLs
 - `html` - some HTML that could contain plain-text DOIs, DOI URLs or Landing Page URLs
 - `content-url` - the URL of a webpage that could point to a webpage that could contain plain-text DOIs, DOI URLs or Landing Page URLs
 - `url` - a URL that could itself be a DOI or Article Landing Page

Observations may be marked as 'sensitive'. When this happens, e.g. with text from Tweets, the input is removed before it's saved as an Evidence Record.

## Actions

An Action is an external stimulus that represents "something happened to something". An Action can have a number of Observations attached to it. E.g.

 - a Reddit comment was made, and has mentions this `url`
 - a Tweet was published, and has this text and contains these `url`s and this `plaintext`
 - a Webpage was submitted, it has this `content-url`

Actions also contain metadata about the thing in question, e.g. the title of the Reddit discussion, publication time of the Tweet etc.

## Pages

Actions are presented in Pages. Sometimes, as in Reddit, API responses come back in paginated form. Sometimes, as in Twitter, the agent bundles Tweets up into batches, a few to a page, for efficiency.

## Matches, Candidates and Events

The Percolator takes every Observation and tries to turn it into an Event. 

The First step is to create a set of Candidates. For example, it may look at some `plaintext` and identify something that looks like a DOI and something that looks like an article landing page URL. It may visit a `content-url` and find something that looks like an Article Landing Page in the HTML of that page.

The next step is to try and match every Candidate into a known DOI. It does this by trying to reverse the Landing Page back into a DOI, and by verifying that every DOI exists and cleaning it up.

Once Matches have been made, they are combined with the information in the Action (for example the subject ID and URL and any bibliographic metadata) to produce Events. 

## Input Bundles and Evidence Records

An Agent sends an Input Bundle to the Percolator. It contains a number of Pages of Actions, each with Observations. The Percolator processes the Input Bundle, looks at Observations and tries to make them into Matches, then turns the Matches into Events. The Input Bundle is then saved as an Evidence Record in essentially the same format as it came from the Agent, with all the new information included.

## Event Data Bot

The Percolator is the home of the Event Data Bot. It visits URLs for two reasons:

1. To look for links to Items (i.e. following `content-url` observations)
2. To try and match a Landing Page back to a DOI

The Event Data Bot respects `robots.txt` files and identifies itself as `CrossrefEventDataBot (eventdata@crossref.org)` User Agent.

The Event Data Bot keeps track of every URL that it visits and the status code it got. It also records when the `robots.txt` file prevented it from visiting a site. See the `web-trace` section of an Evidence Record, [for example this one](https://evidence.eventdata.crossref.org/evidence/20170217eddcee57-6b68-462d-9be3-7d06de8419cd).

## Traceability

The percolator inserts a Links back to the Evidence Record URL in every Event, and every Evidence Record contains all the Events that were produced. 

You can therefore:

1. take an Event
2. find its Evidence Record
3. see which Agent produced it, including extra information like the versions of Artifacts that the Agent and Percolator were using
4. see what API requests were made to produce the data (depending on the Agent and Source)
5. see which input Observations the Agent extracted from the API input
6. see which Observations the Percolator was able to turn into Candidates
7. see which Observations the Percolator was able to turn into Matches
8. see which Matches the Percolator was able to turn into Events

## More information

See the [Percolator repository on Github](https://github.com/CrossRef/event-data-percolator) for more detail.