# Transparency, Authority and Trust

You can look at Event Data as a stream of assertions of relationships between things. When you interpret an assertion, you should know exactly who it is that is making the assertion, and what data they were working from. Trustworthiness is not black and white. You may accept some Events on face value and you may want to independently verify others. 

## Provenance

The provenance of the Event isn't simple: the assertion and supporting data has passed through a number of hands. For example:

 - You got the Event from the Event Data API
 - The Event travelled to you over the Internet, via HTTPS
 - The Event Data API got the Event from the internal Event Data system
 - The Event Data system got the Event from the Agent, which is operated by someone (in most cases Crossref)
 - The Agent generated the Event from some data that it retrieved from the Reddit API
 - The Percolator found a landing page domain in the data.
 - The Percolator matched the landing page to the DOI based on metadata found on the landing page.
 - The Reddit API got the data from a Reddit user
 - The Reddit user may be talking about published research
 - The published research may have been peer reviewed
 - The research may have been based on data sets
 - The data sets may have come from previously published work
 - and so on...

It's up to you to decide how far down the provenance chain you want to go. Event Data strives to represent provenance transparently at all points from where the data **entered** the system to the point where it **leaves** the system. Questions around whether the Reddit API accurately represented what the user typed may be relevant to your interpretation, but are beyond the scope of Event Data.

## Relations

Every subject-relation-object Event is an assertion made by the Agent (and in the case of Crossref Agent, the Percolator). When deciding whether or not you trust an Event, you should look at the Agent ID and make your decision on that basis. Some Agents, like Crossref Metadata and DataCite Metadata, are operated by organizations that directly hold the data. Some Agents, like Reddit or Newsfeeds, observe things on the web and make assertions about what they saw. The Evidence Record provides the link between what the external party said and the Event.

## Landing Page to DOI mappings

When a blog post or Tweet mentions a DOI directly, you know that the author intended to link to the specific piece of content identified by that DOI. When the author uses a landing page, which is more common, we find the best DOI match we can, and describe how performed the match and verification. This is described fully in the [How Crossref Agents match Landing Pages to DOIs](/data/matching-landing-pages).

## Data Aggregator or Provider?

Event Data is a both a pipeline for providing access to Events as well as a family of Agents, operated within and outside Crossref and DataCite. 

The NISO Code of Conduct describes an 'altmetric data aggregator' as:

> Tools and platforms that aggregate and offer online Events as well as derived metrics from altmetric data providers (e.g., Altmetric.com, Plum Analytics, PLOS ALM, ImpactStory, Crossref).

Event Data is an 'aggregator' by this definition. We offer 'online Events' but we **do not provide metrics**. For some data sources that originate within Crossref, Event Data is also a 'Provider' according to the NISO definition.

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

Evidence is important because it bridges the gap between generic primary data sources, such as Twitter, with the specialized Events in Event Data. They explain not only what data were used to construct an Event, but also the process by which the Event was created. Providing this explanation pinpoints the precise meaning of the Event within the individual context it comes from.

You may want to compare Event Data with, or to combine it to, other services. Evidence Records enable two Events from different providers to be compared and helps to explain any discrepancies. It allows the consumer to check whether they were working from the same input data, and whether they processed it the same way.

<a name="evidence-not-all"></a>
#### Not all Events need Evidence

Evidence bridges the gap between external data in a custom format and the resulting Events. There are two factors at play:

 - the format of the data, which is in some external format and needs to be processed into Events
 - the fact that the original data source is controlled by a different party than the Agent that produces Events

Some sources understand and produce Events directly. Examples of these are the DataCite Metadata and Crossref Metadata sources. In these cases, the Events themselves are considered to be primary data.

We may also accept Events directly from external data sources, where the external source runs their own Agent and provides Events as primary data. In this case the source may not be able or willing to provide any additional evidence beyond the Events themselves.

For more information see [Evidence Records](evidence-records) page.

