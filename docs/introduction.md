
# Introduction

Crossref is home to over 80 million items of Registered Content (mostly journal articles, but we also have book chapters, conference papers etc). Crossref Event Data is a service for collecting Events that occur around these items. For example, when datasets are linked to articles, articles are mentioned on social media or referenced online.

<img src='/images/overview.png' alt='Event Data Overview' class='img-responsive'>

Much of the activity around scholarly content happens outside of the formal literature. The scholarly community needs an infrastructure that collects, stores, and openly makes available these interactions. Crossref Event Data will monitor and collect links to scholarly content on the open web. The greater visibility provided by Crossref Event Data will help publishers, authors, bibliometricians and libraries to develop a fuller understanding of where and how scholarly content is being shared and consumed.


## Events

Every time we notice that there is a new relationship between a piece of Registered Content and something out in the web, we record as an individual Event. We gather Events from a wide range of sources, but examples include:

 - an article was linked from DataCite dataset via its Crossref DOI
 - an article was referenced in Wikipedia using its Crossref DOI
 - an article was mentioned on Twitter using its Article Landing Page URL
 - an article has been liked on Facebook 55 times as of June 15th

Events from every Data Source take many forms, but they have a common set of attributes:

 - the **subject** of the event, e.g. Wikipedia article on Fish
 - the **type of the relation**, e.g. "cites"
 - the **object** of the event, e.g. article with DOI 10.5555/12345678
 - the date and time that the event **occurred**
 - the date and time that the event was **collected and processed**
 - a **total** for when an Event has a quantity
 - optional **bibliographic metadata** about the **subject** (e.g. Wikipedia article title, author, publication date)
 - optional **bibliographic metadata** about the **object** (e.g. article title, author, publication date)

## Transparency and Data Quality

Data comes from a wide range of sources and each source is subject to different types of processing. Transparency of each piece of Event Data is crucial: where it came from, why it was selected, how it was processed and how it got here. 

Every Event starts its journey somewhere, usually in an external source. Data from that external source is processed and analyzed, and, if we're lucky, one or more Events are created. The entire process is transparent: what data we were working from, what we extracted and how, and how that relates to each Event. Every Event that Crossref generates is linked back to an Evidence Record, which documents its journey.

<img src='/images/introduction-evidence-flow.svg' alt='Event Data Evidence Flow' class='img-responsive'>

Crossref Event Data was developed alongside the NISO recommendations for altmetrics Data Quality Code of Conduct, and we participated in the Data Quality working group. CED aims to be an example of openness and transparency. You can read the [CED Code of Conduct Self-Reporting table](app-niso.md) in the appendix.

## Accessing the Data 

Crossref Event Data is available via our Query API. The Query API allows you to make requests like:

 - give me all Events that were collected on 2016-12-08
 - give me all Events that occurred on 2015-12-08
 - give me all the Reddit Events that were collected on 2015-12-08
 - give me all the Events that occurred for this DOI on 2016-01-08
 - give me all the Twitter Events that occurred for this DOI on 2016-01-08

## Reliability and Monitoring

*This feature will be available at launch.*

We will provide a Status Service which will show how each component in the system and each external source is functioning. CED integrates with a number of external Data Sources, and is transparent about how we interact with them.

## Service Level Agreement

*This feature will be at a later date.*

We will introduce a Service Level Agreement which will provide agreed service levels for responsiveness of the service. It will also include APIs for access to data.
