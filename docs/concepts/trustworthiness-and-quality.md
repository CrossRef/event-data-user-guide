# Trustworthiness and Quality


## Data Aggregator vs Provider

The NISO Code of Conduct describes an 'altmetric data aggregator as':

> Tools and platforms that aggregate and offer online Events as well as derived metrics from altmetric data providers (e.g., Altmetric.com, Plum Analytics, PLOS ALM, ImpactStory, Crossref).

CED is an 'aggregator' by this definition. We offer 'online events' but we **do not provide metrics**. For some Data Sources that originate within Crossref, CED is also a 'Provider' according to the NISO definition.

We **do not provide metrics** of any kind, but because the data is freely available, anyone could use CED to build metrics. We make the full Evidence Records available to anyone who uses our data, so they can in turn provide evidence for their output.



<a name="concept-duplicate"></a>
## Duplicate Data

When an Event occurs in the wild it may be reported via more than one channel. For example, a blog may have an RSS feed that the Newsfeed agent subscribes to. It may also be included in a blog aggregator's results. In this case the action of publishing the blog post might result in two Events in CED. Note that two Events that describe the same external action via two routes will have different Event IDs.

It is important that CED reports Events without trying to 'clean up' the data. The Evidence pipeline ensures that every input that should result in an Event, does result in an Event. 

Becuase it's up to consumers to interpret the data as required, one consumer may treat duplicates differently. Some consumers may treat the same event coming from two Agents as a corroboration, and therefore significant. Some consumers may wish to just ignore duplicates.

Each Agent will itself try to avoid generating the same event twice. E.g. if a single tweet results in an Event, that Event should only be created once. However, CED makes no *guarantees* that this won't happen.

<a name="concept-evidence-first"></a>
## Evidence First

Crossref Event Data contains data from external data providers, such as Twitter, Wikipedia and DataCite. Every Event is created by an Agent. In most cases, such as Twitter and Wikipedia, the Agent is operated by Crossref, not by the original data provider. In some cases, such as DataCite, the data provider runs the Agent themselves.

Converting external data into Events provides an evidence gap. It raises questions like:

 - what data was received?
 - how was it converted into Events?
 - if some other service got the same data, why did it produce different results?

<img src="../../images/evidence-first-evidence-gap.svg" alt="Evidence Gap" class="img-responsive">

#### Bridging the Evidence Gap

CED solves this by taking an **Evidence First** approach. For every piece of external data we receive we create an Evidence Record. This contains all the relevant parts of the input data and all supporting information needed to process it. This means that we can provide evidence for every Event. 

<img src="../../images/evidence-first-bridge.svg" alt="Bridging the Evidence Gap" class="img-responsive">

Evidence is important because it bridges the gap between generic primary Data Providers, such as Twitter, with the specialized Events in CED. They explain not only what data were used to construct an Event, but also the process by which the Event was created. Providing this explanation pinpoints the precise meaning of the Event within the individual context it comes from.

A number data providers (including, for example, CED) may produce equivalent data. Evidence enables two events from different providers to be compared and helps to explain any discrepancies. It allows the consumer to check whether they were working from the same input data, and whether they processed it the same way.

<a name="evidence-not-all"></a>
#### Not all Events need Evidence

Evidence bridges the gap between external data in a custom format and the resulting Events. There are two factors at play:

 - the format of the data, which is in some external format and needs to be processed into to Events
 - the fact that the original Data Source is controlled by a different party than the Agent that produces Events

Some sources understand and produce Events directly. Examples of these are the `datacite_crossref` and `crossref_datacite` sources. In these cases, the Events themselves are considered to be Primary Data.

We may also accept Events directly from external Data Sources, where the external source runs their own Agent and provides Events as primary data. In this case the Source may not be able or willing to provide any additional evidence beyond the Events themselves.

For more information see [Evidence Registry](../service/evidence-registry) page.

