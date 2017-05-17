# Transparency, Authority and Trust

You can look at Event Data as a stream of assertions of relationships between things. When you interpret an assertion, you should know exactly who it is that is making the assertion, and what data they were working from. Trustworthiness is not black and white. You may accept some Events on face value and you may want to independently verify others. 

## Provenance

The provenance of the Event isn't simple: the assertion and supporting data has passed through a number of hands. For example:

 - You got the Event from the Event Data API
 - The Event travelled to you over the Internet, via HTTPS
 - The Event Data API got the Event from the internal Event Data system
 - The Event Data system got the Event from the Agent, which is operated by someone (in most cases Crossref)
 - The Agent generated the Event from some data that it retrieved from the Reddit API
 - The Reddit API got the data from a Reddit user
 - The Reddit user may be talking about published research
 - The published research may have been peer reviewed
 - The research may have been based on data sets
 - The data sets may have come from previously published work
 - and so on...

It's up to you to decide how far down the provenance chain you want to go. Event Data strives to represent provenance transparently at all points from where the data **entered** the system to the point where it **leaves** the system. Questions around whether the Reddit API accurately represented what the user typed may be relevant to your interpretation, but are beyond the scope of Event Data.

## Relations

Every subject-relation-object Event is an assertion made by the Agent. When deciding whether or not you trust an Event, you should look at the Agent ID and make your decision on that basis. Some Agents, like Crossref Metadata and DataCite Metadata, are operated by organisations that directly hold the data. Some Agents, like Reddit or Newsfeeds, observe things on the web and make assertions about what they saw. The Evidence Record provides the link between what the external party said and the Event.

## Landing Page to DOI mappings

When an Event links to a DOI but the URL in the corresponding `obj` metadata is different, the Agent has made a judgment about an article landing page. The Event therefore contains two assertions:

 - this webpage mentions this article landing page
 - this article landing page corresponds to this DOI

The Evidence Record for each Event documents this mapping in some detail.

Agents that perform this mapping have a few methods available. The first method is to look for the DOI embedded in the URL. This happens quite often, e.g. PLOS:

    http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0160617

There are other similar methods to this. If we are unable to get the DOI from the URL, we will visit the URL. If the landing page has the correct metadata tags in the HTML, we will use that. e.g. from the same PLOS Page:

    <head>
      <meta name="dc.identifier" content="10.1371/journal.pone.0160617" />
    </head>

This means that in cases like this, the landing page URL to DOI mapping is made on the authority of the organisation running that website, i.e. the Publisher's. 

We maintain a list of publisher domains (see the [Artifacts](artifacts)), which we do by following DOIs to see where the resolve to. We will only accept URL to DOI equivalence assertions from domains on this list. 

## Data Aggregator or Provider?

Event Data is a both a pipeline for providing access Events and a family of Agents, operated within and outside Crossref and DataCite. 

The NISO Code of Conduct describes an 'altmetric data aggregator as':

> Tools and platforms that aggregate and offer online Events as well as derived metrics from altmetric data providers (e.g., Altmetric.com, Plum Analytics, PLOS ALM, ImpactStory, Crossref).

Event Data is an 'aggregator' by this definition. We offer 'online events' but we **do not provide metrics**. For some Data Sources that originate within Crossref, Event Data is also a 'Provider' according to the NISO definition.

<a name="concept-evidence-first"></a>
## Evidence First

Crossref Event Data contains data from external data providers, such as Twitter, Wikipedia and DataCite. Every Event is created by an Agent. In most cases, such as Twitter and Wikipedia, the Agent is operated by Crossref, not by the original data provider. In some cases, such as DataCite, the data provider runs the Agent themselves.

Converting external data into Events provides an evidence gap. It raises questions like:

 - what data was received?
 - how was it converted into Events?
 - if some other service got the same data, why did it produce different results?

<img src="../../images/evidence-first-evidence-gap.svg" alt="Evidence Gap" class="img-responsive">

#### Bridging the Evidence Gap

Event Data solves this by taking an **Evidence First** approach. For every piece of external data we receive we create an Evidence Record. This contains the relevant parts of the input data (where reasonable) and all supporting information needed to process it. Check each Agent's documentation to see whether or not it produces Evidence Records.

<img src="../../images/evidence-first-bridge.svg" alt="Bridging the Evidence Gap" class="img-responsive">

Evidence is important because it bridges the gap between generic primary Data Providers, such as Twitter, with the specialised Events in Event Data. They explain not only what data were used to construct an Event, but also the process by which the Event was created. Providing this explanation pinpoints the precise meaning of the Event within the individual context it comes from.

You may want to compare Event Data with, or to combine it to, other services. Evidence Records enable two events from different providers to be compared and helps to explain any discrepancies. It allows the consumer to check whether they were working from the same input data, and whether they processed it the same way.

<a name="evidence-not-all"></a>
#### Not all Events need Evidence

Evidence bridges the gap between external data in a custom format and the resulting Events. There are two factors at play:

 - the format of the data, which is in some external format and needs to be processed into to Events
 - the fact that the original Data Source is controlled by a different party than the Agent that produces Events

Some sources understand and produce Events directly. Examples of these are the DataCite Links and Crossref Links sources. In these cases, the Events themselves are considered to be primary data.

We may also accept Events directly from external Data Sources, where the external source runs their own Agent and provides Events as primary data. In this case the Source may not be able or willing to provide any additional evidence beyond the Events themselves.

For more information see [Evidence Records](evidence-records) page.

