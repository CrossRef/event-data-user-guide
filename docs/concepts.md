# Concepts

[TOC]

<a name="concept-items-urls-dois"></a>
## Content Items, URLs, Persistent Identifiers and DOIs 

Crossref has approximately 80 million Items of Registered Content: articles, books, chapters etc. A Content Item is a 'work' according to the [FRBR](http://archive.ifla.org/VII/s13/frbr/frbr1.htm#3.2) model. 

When a Content Item is registered with Crossref or DataCite, it is assigned a Persistent Identifier (PID) in the form of a Crossref DOI or DataCite DOI. The PID permanently identifies the Content Item and is used when referring to, or linking between, Items. Other PIDs, such as PubMed ID (PMID) are available, but they are beyond the scope of Crossref Event Data.

<img src="../images/doi-url-simple.svg" class="img-responsive">

All items of Registered Content have a presence on the web, known as the Landing Page. This is the 'home' of the Item and it is hosted on the website of its publisher. It usually contains information about the Item, such as title, other bibliographic metadata, abstract, links to download the content, or possibly the whole article itself.

The purpose of a DOI link is to automatically redirect to the Landing Page. This means that although many users click on DOIs, by the time it comes to share an Item on social media, the user is on the Landing Page, and might share that URL not the DOI.

Event Data therefore attempts to track Events via the Landing Page URLs as well as via DOI URLs.

### Event Data uses DOIs to refer to Items

Like all Crossref services, whenever CED refers to an Item it uses the DOI to identify it. The Query API uses DOIs to query for data associated with Items and each Event uses DOIs when referring to items.

CED normalizes DOIs into a standard form, using `HTTPS` and the `doi.org` resolver, e.g. `https://doi.org/10.5555/12345678`. Even though Events may be collected via DOIs expressed in different forms, all Events contain DOIs in this form.

### Event Data tracks Content Items not DOIs

CED uses DOIs to refer to Items, but it is important to understand that internally CED tracks Events around Items themselves. CED does not 'track DOIs'.

Input data collected from different Sources uses different identifiers to refer to Items. Some use the DOI and some use the Landing Page. However the data comes in, CED matches the input to an Item and records the data against that.

### DOIs are unique. Landing Pages aren't always.

Crossref items have a variety of Content Types including:

 - Journal Article
 - Chapter
 - Conference Paper
 - Component
 - Entry
 - Book
 - Journal Issue
 - Journal
 - Section

Some Items are considered to be part of other Items, for example an article may contain figures, and each figure might be registered as a separate Item. In this case there would be one Item of type 'journal article' and several item of type 'component'. Each Item has a DOI. Because Publishers are free to decide how to structure their websites, the Landing Page for each Figure may or may not be the same as the Landing Page for the article.

Sometimes the Landing Page for a Book Chapter can be the same as the Landing Page for the whole book. And sometimes they are separate.

<img src="../images/doi-components.svg" class="img-responsive">

There is an exact one-to-one mapping between Items and their Persistent Identifiers (DOIs), but no exact one-to-one mapping between Items and their Landing Pages. When CED receives data for a Landing Page, it has to follow steps to assign the data to the correct Item.

For an in-depth discussion see [URLs in Depth](urls-in-depth).

### Landing Page URLs can change.

Over time, Landing Pages can change as publishers reorganize their websites. This is where a Persistent Identifier comes in useful, as it always redirects to the current Landing Page.

<img src="../images/doi-url.svg" alt="DOIs and Landing Pages" class="img-responsive">

CED attempts to always store the most recent Landing Page.

### Not all Landing Pages are known

The Crossref metadata contains a 'Resource link' field. This is a URL that you are redirected to when you click on a Crossref DOI. It redirects to the Landing Page but it doesn't always do this directly. Publishers deposit links with Crossref, but they sometimes add their own internal redirects. 

Let's take a simple example of a Crossref demonstration DOI. The Crossref DOI `10.5555/12345678` has the Resource link `http://psychoceramics.labs.crossref.org/10.5555-12345678.html`, which you can see in the [article metadata](http://api.crossref.org/works/10.5555/12345678/transform/application/vnd.crossref.unixsd+xml). If we follow the DOI we see only one redirect, that from the DOI link.

| URL | Comment |
|-----|---------|
| `http://doi.org/10.5555/12345678` | Initial DOI redirect from Resource link |
| `http://psychoceramics.labs.crossref.org/10.5555-12345678.html` | Finished |

In cases like this, the Landing Page is known to Crossref, as it's the same as the Resource link.

Let's take another example, the PLoS DOI `10.1371/journal.pone.0160106`. The Resource link, which you can see in the [article metadata](http://api.crossref.org/works/10.1371/journal.pone.0160106/transform/application/vnd.crossref.unixsd+xml) is `http://dx.plos.org/10.1371/journal.pone.0160106`.

If we follow the DOI URL, we see the following chain of redirects.

| URL | Comment |
|-----|---------|
| `http://doi.org/10.1371/journal.pone.0160106` | Initial DOI redirect from Resource link |
| `http://dx.plos.org/10.1371/journal.pone.0160106` | Internal redirect within PLoS Site |
| `http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0160106` | Internal redirect within PLoS Site |
| `http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0160106` | Finished |

In cases like this, the final Landing Page is different to that registered with Crossref, so we can't know without following it. 

Furthermore, we have no automatic way to knowing when we do know the landing page. This means that if we want to collect every Landing Page URL, we have to follow every single Resource link to discover where it leads.

### Landing Page data can be out of date

In order to compile the mapping of DOIs to Landing Pages it's necessary to follow every single DOI. As there are over 80 million content items with DOIs, this is a time consuming process. Furthermore, Crossref has to respect rate limit on Publisher websites, which means that we can't do this simply do the crawl as fast as possible. 

The data for the mapping of DOIs to Landing pages (and vice versa) is refreshed as often as possible, but it may be out of date. In order to account for this, the mappings are captured as versioned, immutable Artifacts within the CED system. This allows you to check exactly what mapping was in use at a given point in time.

### It is not possible to discover all Landing Pages

Publisher sites are reorganized from time to time, and there may be a delay in updating the Crossref metadata. This means that DOI links can break and it can be impossible to find the Landing Page for a period of time. 

In other cases, Publisher sites implement checks which prevent automated access, such as requiring cookies and performing redirects using JavaScript. For example, trying to resolve the anonymyzed DOI `10.XXX/YYY.06.008` without cookies enabled produces:

| URL | Comment |
|-----|---------|
| `http://doi.org/10.XXX/YYY.06.008` | Initial DOI redirect|
| `http://FFF.AAA.com/retrieve/pii/DDD` | Internal redirect |
| `http://FFF.AAA.com/retrieve/articleSelectPrefsTemp?Redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&key=71835a2ddc744fbddf6d9a5a9003a4aced4b81a1` | Internal redirect |
| `http://www.CCC.com/retrieve/pii/DDD` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&rc=0&code=EEE` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?rc=1&redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&code=EEE` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?rc=2&redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&code=EEE` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?rc=3&redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&code=EEE` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?rc=4&redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&code=EEE` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?rc=5&redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&code=EEE` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?rc=6&redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&code=EEE` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?rc=7&redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&code=EEE` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?rc=8&redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&code=EEE` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?rc=9&redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&code=EEE` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?rc=10&redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&code=EEE` | Internal redirect |
| `http://secure.BBB.com/action/cookieAbsent` | Final error page |

The final step in this chain is an error page stating that cookies are required and it is therefore impossible to resolve the DOI using HTTP.

Crossref [Membership rules #10](http://www.crossref.org/02publishers/59pub_rules.html) state that 

> links enabled by Crossref must resolve to a response page containing no less than complete bibliographic information about the target content

Where publishers break these rules, we will alert them.

Crossref will attempt to find Landing Pages for Items such as these, but only on a best-effort basis. If you find Event Data missing for a given Item, you can check the Artifacts to see if the mapping was included.

<a name="concept-matching-dois"></a>
### Matching by DOIs

Some services use DOIs directly to make references. Wikipedia, for example, has references all over the web, but where they link scholarly articles, the DOI is generally included. There are tools in the page editing workflow to encourage and suggest the incorporation of DOIs. Another Data Source that uses DOIs for references is DataCite, who link datasets to articles via their dataset metadata.

Data that come from services like this can be very precise. We know that the person who made the citation intended to use the DOI to refer to the Item in question and we can reliably report that an Event occurred for the Item with this Crossref DOI.

<a href="concept-external-doi-mappings"></a>
### External Parties Matching Content to DOIs 

It is possible for an external party to store activity around Items and use their own systems to match Items to DOIs, Landing Pages and other Identifiers. Although their APIs can be queried using DOIs, they might have recorded activity against the Item using its Landing Page or another Identifier. The internal mappings between various identifiers may change from time to time, which may mean that certain activity may be reported against one Item at one point in time and then against another Item at another point in time. Data may therefore change over time and this may be caused by algorithms being updated rather than user activity.

An example of this is Mendeley, who use machine learning to cluster, group and classify articles.

CED provides all available Evidence for all Events, but is unable to provide visibility of mappings within external services. Data from these sources of this type should be interpreted with this in mind.

### Linked and Unlinked DOIs

DOIs can be expressed in a number of ways, for example:

 - `10.5555/12345678`
 - `doi:10.5555/12345678`
 - `http://dx.doi.org/10.5555/12345678`
 - `https://doi.org/10.5555/12345678`

In addition, when they are displayed in an HTML page, they can be hyperlinked. **The Crossref DOI Display guidelines specify that a DOI should be a hyperlink**.

Some services, such as Twitter, automatically link URLs. Some services, such as Wikipedia, provide tools that make linking the default, although there are still unlinked DOIs. 

**Generally, Event Data will only find links in HTML that are correctly linked using a URL. It ignores unlinked DOIs.**

<a name="concept-landing-page-domains"></a>
### Landing Page Domains

CED maintains a list of the domain names that belong to Landing Pages. This is called the [`domain-list` Artifact](evidence-in-depth#artifact-domain-list). It consists of around 15,000 domains that belong to Publishers. It is automatically generated but manually curated. Some Publishers create DOIs that resolve to domains such as `youtube.com`. These domains produce a large amount of false-positives. They also belong to organizations, such as YouTube, who have no involvement in scholarly publishing, which makes it unlikely that it would be possible to extract data for them in any case. For these reasons, domains of this type are manually removed from the Landing Page Domain list.

This list is used for some sources as an initial pre-filter to identify URLs that might be Landing Pages. 

The Artifact is updated on a regular basis. For more information see [`domain-list` Artifact](evidence-in-depth#artifact-domain-list).

## Different levels of Data Source Specificity

External sources fall into four broad levels of specificity, in order of preference:

1. Sources that provide only relevant Data.
2. Sources that can be queried by pre-filtering Landing Page Domains.
3. Sources that must be fetched in their entirety.
4. Sources that must be queried once per Item.

<a name="concept-relevant-source"></a>
### Sources that send only relevant Data

Some sources, such as "DataCite Crossref" and "Crossref DataCite" are specialists in the Scholarly Publishing space. They send data to CED, and each item of Data that is sent can be converted into an Event. This is highly efficient, as it means that no data or time is wasted.

<a name="concept-pre-filtering"></a>
### Pre-filtering URLS by their Domain

Some sources, such as Twitter and Reddit support queries by domain. This means that the Agent has to issue each Query once per domain to perform a full scan of the corpus of Items. In these cases the [`domain-list` Artifact](evidence-in-depth#artifact-domain-list) Artifact is used. It contains around 15,000 domains. In these cases, some data is sent that cannot be matched to an Event, but the ratio is still very high.

When an Agent of this type connects to a Data Source it will conduct a search for this domain list. In the case of Twitter that means constructing a ruleset that includes all domains. In the case of Reddit and Wordpress.com it means conducting one search per domain. This initial filter returns a dataset which mentions one of the domains that is found to contain Landing Pages. From this pre-filtered dataset the Agent then examines each result for Events.

Every Agent that uses the `domain-list` Artifact includes a link to the version of the Artifact they used when they conducted the query.

<a name="concept-query-entirety"></a>
### Sources that must be queried in their entirety

Some sources have no means of filtering or querying and must be downloaded in their entirety. These sources generally contain a high amount of relevant content, so the chance of being able to extract Events is high, and this method isn't wasteful.

Examples of these sources are Newsfeeds. The Newsfeed agent consumes all the data in each Newsfeed and then filters them for Events. As Newsfeed List is curated to include only blogs that are likely to feature links to Items that can be extracted, this approach is reasonably efficient.

<a name="concept-once-per-item"></a>
### Sources that must be queried once per Item

Some sources don't allow queries of the above kind, meaning it is necessary to query once per item to retrieve all the data. This is a slow process, as there are over 80 million items and APIs have rate limits.

Facebook and Mendeley are examples of this type of source. In the case of Mendeley, queries are made using the DOI and in the case of Facebook they use the Landing Page.

To mitigate the problem of long crawl times, CED splits Items into three categories: 

 - high interest Items
 - medium interest Items
 - all Items

The three lists are polled in a loop independently, meaning that the smaller, higher interest Items have updates more often. See the [DOI List](evidence-in-depth#artifact-doi-list) and [URL List](evidence-in-depth#artifact-url-list) Artifacts and the documentation for the respective Sources for more details.

## Data Aggregator vs Provider

The NISO Code of Conduct describes an 'altmetric data aggregator as':

> Tools and platforms that aggregate and offer online Events as well as derived metrics from altmetric data providers (e.g., Altmetric.com, Plum Analytics, PLOS ALM, ImpactStory, Crossref).

CED is an 'aggregator' by this definition. We offer 'online events' but we **do not provide metrics**. For some Data Sources that originate within Crossref, CED is also a 'Provider' according to the NISO definition.

Note that a small proportion of Event Data, such as that from Facebook, has is collected in pre-aggregated form.

<a name="concept-duplicate"></a>
## Duplicate Data

When an Event occurs in the wild it may be reported via more than one channel. For example, a blog may have an RSS feed that the Newsfeed agent subscribes to. It may also be included in a blog aggregator's results. In this case the action of publishing the blog post might result in two Events in CED. Note that two Events that describe the same external action via two routes will have different Event IDs.

It is important that CED reports Events without trying to 'clean up' the data. The Evidence pipeline ensures that every input that should result in an Event, does result in an Event. 

<a name="concept-evidence-first"></a>
## Evidence First

Crossref Event Data contains data from external data providers, such as Twitter, Wikipedia and DataCite. Every Event is created with an Agent. In most cases, such as Twitter and Wikipedia, the Agent is operated by Crossref, not by the original data provider. In some cases, such as DataCite, the data provider runs the Agent themselves.

Converting external data into Events provides an evidence gap. It raises questions like:

 - what data was received?
 - how was it converted into Events?
 - if some other service got the same data, why did it produce different results?

<img src="../images/evidence-first-evidence-gap.svg" alt="Evidence Gap" class="img-responsive">

#### Bridging the Evidence Gap

CED solves this by taking an **Evidence First** approach. For every piece of external data we receive we create an Evidence Record. This contains all the relevant parts of the input data and all supporting information needed to process it. This means that we can provide evidence for every Event. 

<img src="../images/evidence-first-bridge.svg" alt="Bridging the Evidence Gap" class="img-responsive">

Evidence is important because it bridges the gap between generic primary Data Providers, such as Twitter, with the specialized Events in CED. They explain not only what data were used to construct an Event, but also the process by which the Event was created. Providing this explanation pinpoints the precise meaning of the Event within the individual context it comes from.

A number data providers (including, for example, CED) may produce equivalent data. Evidence enables two events from different providers to be compared and helps to explain any discrepancies. It allows the consumer to check whether they were working from the same input data, and whether they processed it the same way.

<a name="evidence-not-all"></a>
#### Not all Events need Evidence

Evidence bridges the gap between external data in a custom format and the resulting Events. There are two factors at play:

 - the format of the data, which is in some external format and needs to be processed into to Events
 - the fact that the original Data Source is controlled by a different party than the Agent that produces Events

Some sources understand and produce Events directly. Examples of these are the `datacite_crossref` and `crossref_datacite` sources. In these cases, the Events themselves are considered to be Primary Data.

We may also accept Events directly from external Data Sources, where the external source runs their own Agent and provides Events as primary data. In this case the Source may not be able or willing to provide any additional evidence beyond the Events themselves.

For more information see [Evidence Records in Depth](evidence-in-depth#in-depth-evidence-records).

<a name="concept-timescales"></a>
## Occurred-at vs collected-at

Every Event results from an action that was taken at some point in time. This is considered to be the time that the Event 'occurred'. Examples of the 'occurred' field:

 - the time the Tweet was published
 - the time the edit was made on Wikipedia
 - the time that the Reddit comment was made
 - the time that the blog post was published
 - the time an article with a data citation was published

Most Events are collected soon after they occur:

 - tweets are collected within a few minutes of publication
 - Wikipedia edits are collected within a few minutes of the edit
 - Reddit comments are collected the day after they were made
 - blog posts are collected within an hour of publication or syndication

These are approximate guidelines. In some circumstances the Event may be collected some time after it occurred:

 - article back-files from years ago are scanned for citations
 - a monthly data-dump comes in and it registers Events from the start of the month
 - a historical data-dump is made available

These two dates are represented as the `occurred_at` and `timestamp` fields on each Event. The Query API has two views which allow you to find Events filtered by both timescales.

### Using the Query API over time

The Query API is updated every day. Once data for a given date exists in the `collected` view of the Query API it will never change. Anything collected on a future day will be made available under that day's view.

The Query API also contains an `occurred` view. This returns Events based on the date they occurred on. Because Events can be collected some time after they occurred, the data in this view can change.

<img src="../images/occurred-collected-timeline.svg" alt="Occurred at vs Collected at" class="img-responsive">

When you use the **collected** view you should be aware that it may contain Events that occurred in the past.

When you use the **occurred** view you should be aware that that the results may change over time, and that Events may have happened in the past that have not yet been collected.

### Stable dataset with `collected`

The `collected` dataset provides a stable dataset that can be referenced. You can be confident that the data returned by a query URL won't change over time. You can also be confident that by collecting data for each day you will build a complete dataset of Events collected over that period.

The downside of this is that you will not be able to find Events that occurred on a given day without downloading a complete dataset.

### Flexible data with `occurred`

The `occurred` dataset provides an up-to-date dataset that lets you find Events that occurred on a given day. The data at a Query URL will change over time, so you can't rely on the dataset to be stable and citable.

The timestamp field is available on all Events, so you can see when they were collected and added to the dataset for a given day.

<a name="concept-external-agents"></a>
## External Agents

Most Agents are operated by Crossref (see [Data Sources](service#data-sources)). Some are operated by external parties, for example DataCite. We welcome new Data Sources.

Where Crossref operates the Agent we provide full Evidence records for each Event. Where the Agent is operated by an external party, they may or may not provide full Evidence. See [Not all Events need Evidence](evidence#evidence-not-all) for further discussion.

<a name="concept-individual-aggregated"></a>
## Individual Events vs Pre-Aggregated

Most sources, such as Twitter, Wikipedia, DataCite etc, provide a view of individual Events. Some, like Mendeley or Facebook, are only able to capture snapshots of aggregate values. It is preferable to capture individual Events, and pre-aggregated Events are only produced where it is the only format available.

The `occurred_at` field of individual Events is generally the time the original event happened, e.g.

 - the tweet was published at this date and time
 - the edit was made to the Wikipedia article at this date and time

In the case of 'likes' on Facebook, we don't have access to each time an Item was liked (or unliked). We only have visibility of the total number of likes. Therefore for pre-aggregated Events the `occurred_at` field means:

 - the Agent checked Facebook at this date and time and it reported the Item has 5 likes
 - the Agent checked Mendeley at this date and time and it reported the Item is in 10 groups

In Events like this, the `total` field records the number of pre-aggregated Events.

These Events don't record *when* an Item was liked, just the number of likes that exist on a given date. This means that if an Item has a Facebook Event with 100 likes in January and 150 likes in February, we don't know whether 50 extra people liked the Item, or if it was a combination of unlikes and new likes.

Co-incidentally, sources like this also tend to be the type that must be polled once per Item which means that the time between Events for a given Item might be large, and the data might not be very recent. See see [Sources that must be queried once per Item](concepts#concept-once-per-item).
