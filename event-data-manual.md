---
title: Crossref Event Data User Guide
---

Version 0.4 - Service Early Preview

# Welcome

Welcome to the Crossref Event Data User Guide. It contains everything you need to know about Crossref Event Data (and probably a little more), from a high-level overview down to the details in-depth. It is split into four sections:

 - 'Introduction' is a high level overview of the service and background and is suitable for everyone.
 - 'The Service' describes the Event Data service and how to use it.
 - 'Concepts' covers some of the issues that should be understood before using Event Data.
 - 'In Depth' describes all the technical detail required to understand and integrate with the service from top to bottom and is suitable for a technical or research audience.

Crossref Event Data is an open service and will be put to a wide range of uses so it's important to understand exactly what the data means. We aim to set the standard in openness and transparency so the documentation not only describes the service, but precisely how we generate it.

**The Event Data Service has not yet launched and is not feature-complete.** This document is pre-release: some features described here are at preview stage and some are planned for development. Terminology and features may change before final release.

# Introduction

Crossref is home to over 80 million items of Registered Content (mostly journal articles, but we also have book chapters, conference papers etc). Crossref Event Data is a service for collecting Events that occur around these items. For example, when datasets are linked to articles, articles are mentioned on social media or referenced online.

<img src='images/overview.png' alt='Event Data Overview' class='img-responsive'>

Much of the activity around scholarly content happens outside of the formal literature. The scholarly community needs an infrastructure that collects, stores, and openly makes available these interactions. Crossref Event Data will monitor and collect links to scholarly content on the open web. The greater visibility provided by Crossref Event Data will help publishers, authors, bibliometricians and libraries to develop a fuller understanding of where and how scholarly content is being shared and consumed.


## Events

Every 'thing that happens' is recorded as an individual Event. We gather Events from a wide range of sources, but examples include:

 - an article was linked from DataCite dataset via its Crossref DOI
 - an article was referenced in Wikipedia using its Crossref DOI
 - an article was mentioned on Twitter using its Article Landing Page URL
 - an article has been liked on Facebook 55 times as of June 15th

Events from every Data Source take many forms, but they have a common set of attributes:

 - the subject of the event, e.g. Wikipedia article on Fish
 - the type of the relation, e.g. "cites"
 - the object of the event, e.g. article with DOI 10.5555/12345678
 - the date and time that the event occurred
 - the date and time that the event was collected and processed
 - a total (useful in the above Facebook example)
 - optional bibliographic metadata about the subject (e.g. Wikipedia article title, author, publication date)
 - optional bibliographic metadata about the object (e.g. article title, author, publication date)

## Transparency and Data Quality

Data comes from a wide range of sources and each source is subject to different types of processing. Transparency of each piece of Event Data is crucial: where it came from, why it was selected, how it was processed and how it got here. 

Every Event is the result of some data input from a source, and the entire process is completely open. For every Event we provide a full Evidence Record.

<img src='images/introduction-evidence-flow.svg' alt='Event Data Evidence Flow' class='img-responsive'>

Crossref Event Data was developed alongside the NISO recommendations for altmetrics Data Quality Code of Conduct, and we participated in the Data Quality working group. CED aims to be an exemplar altmetrics data provider, setting the standard in openness and transparency. You can read the [CED Code of Conduct Self-Reporting table](#appendix-niso-coc) in the appendix.

## Accessing the Data 

Crossref Event Data is available via our Query API. The Query API allows you to make requests like:

 - give me all Events that were collected on 2016-12-08
 - give me all Events that occurred on 2015-12-08
 - give me all the Facebook Events that were collected on 2015-12-08
 - give me all the Events that occurred for this DOI on 2016-01-08
 - give me all the twitter Events that occurred for this DOI on 2016-01-08

We will add other mechanisms for retrieving Events when we introduce the Service Level Agreement.

The data is made available via a REST API. Because around a million Events are collected per month, the queries are made to the API on a per-day basis. Even per day there are tens of thousands of Events, so it's worth deciding on a query filter that matches your use case.

## Reliability and Monitoring

We will provide a Status Dashboard which will show how each component in the system and each external source is functioning. CED integrates with a number of external Data Sources, and is transparent about how we interact with them.

## Service Level Agreement

We will introduce a Service Level Agreement which will provide agreed service levels for responsiveness of the service. It will also include APIs for access to data.

# The Service

Crossref Event Data is a system for collecting Events and distributing them. Up to 100,000 Events occur per day, which is approximately one per second. Events for most Data Sources are collected and produced by Crossref, but some are produced by our partners.

 - The Query API provides an interface for accessing Events. It's a REST API that allows download of Events and supports various filters. 

 - Every Event that Crossref produces has an Evidence Record. These are available via the Evidence Service. It provides supporting evidence for every Event.

 - Every component in the CED system, internal and external, in CED is monitored. The Status Dashboard monitors all data flowing into the system, all parts of the processing pipeline, and the delivery mechanisms. It records the availability and activity of components and completeness of data.

## Versions

The current version of the service as whole is the same as the version of this User Guide. Each component of the Service, for example the Query API and the various Agents that collect data, have versions, and you can check the currently running version using the Evidence Service.

## Data Sources {#data-sources}

Event Data is a hub for the collection and distribution of Events and contains data from a selection of Data Sources. 

| Name                   | Source Identifier   | Provider    | What does it contain? |
|------------------------|---------------------|-------------|------------------|
| Crossref to DataCite   | crossref_datacite   | Crossref    | Dataset citations from Crossref Items to DataCite Items |
| Facebook               | Facebook            | Crossref    | Count number of likes and comments for Items |
| Mendeley               | mendeley            | Crossref    | Reader count number, etc from Mendeley |
| Newsfeed               | newsfeed            | Crossref    | Mentions of Items on blogs and websites with syndication feeds |
| Reddit                 | Reddit              | Crossref    | Mentions and discussions of Items on Reddit |
| Twitter                | twitter             | Crossref    | Mentions of Items on Twitter |
| Wikipedia              | wikipedia           | Crossref    | References of Items on Wikipedia |
| Wordpress.com          | wordpressdotcom     | Crossref    | References of Items on Wordpress.com blogs |
| DataCite to Crossref   | datacite_crossref   | DataCite    | Dataset citations from DataCite Items to Crossref Items |

For detailed discussion of each one, see the [Sources In Depth](#in-depth-sources) section.

## Query API

The Query API provides access to Event Data. It is simple REST API and uses JSON. Because there are up to a million Events per month, every query is scoped by a date, in `YYYY-MM-DD` format. Even when scoped to a particular date, there can be tens of thousands of Events. Therefore there are a number of filters available.

When you write a client to work with the API it should be able to deal with responses in the tens of megabytes, preferably dealing with them as a stream. You may find that saving an API response directly to disk is sensible.

### Timing and Freshness

The Query has two date views: `collected` and `occurred`. See ['Occurred-at vs Collected-at'](#concept-timescales) for a more detailed discussion. Each is suitable for different use cases:

 - `collected` is useful when you want to run a daily query to fetch all Events for a given filter and you want to be sure you always have all available Events
 - `collected` is useful when you want to reference a dataset and be sure it never changes
 - `occurred` is useful when you want to retrieve Events that occurred at a particular time
 - when using `occurred` you should be aware that new Events may be collected at any time in the future that occurred at a date in the past

The API base is therefore one of:

  - `http://api.eventdata.crossref.org/occurred/`
  - `http://api.eventdata.crossref.org/collected/`

All queries are available on both views.

The Query API is updated every day. This means that from the time an Event is first collected to the time when it is available on the Query API can be up to 24 hours. Once a `collected` result is available it should never change, but `occurred` results can.

### Available Queries

#### All data for a day

    http://query.api.eventdata.crossref.org/«view»/«date»/events.json

e.g.

    http://query.api.eventdata.crossref.org/collected/2016-08-08/events.json

#### All data for a particular source for a day

    http://query.api.eventdata.crossref.org/«view»/«date»/sources/«source»/events.json

e.g.

    http://query.api.eventdata.crossref.org/collected/2016-08-08/twitter/events.json

#### All data for a DOI for a day

Note: Convert the DOI to lower case before querying.

    http://query.api.eventdata.crossref.org/«view»/«date»/works/«doi»/events.json

e.g.

    http://query.api.eventdata.crossref.org/collected/2016-08-08/works/10.5555/12345678/events.json

#### All data for a DOI for a day for a given source

Note: Convert the DOI to lower case before querying.

    http://query.api.eventdata.crossref.org/«view»/«date»/works/«doi»/sources/«source»/events.json

e.g.

    http://query.api.eventdata.crossref.org/collected/2016-08-08/works/10.5555/12345678/sources/twitter/events.json

### Querying a Date Range

If you want to collect all Events for a given date range, you can issue a set of queries. E.g. to get all Wikipedia Events in August 2016, issue the following API queries:

 - `http://query.api.eventdata.crossref.org/occurred/2016-08-01/sources/twitter/events.json`
 - `http://query.api.eventdata.crossref.org/occurred/2016-08-02/sources/twitter/events.json`
 - `http://query.api.eventdata.crossref.org/occurred/2016-08-03/sources/twitter/events.json`
 - `http://query.api.eventdata.crossref.org/occurred/2016-08-.../sources/twitter/events.json`
 - `http://query.api.eventdata.crossref.org/occurred/2016-08-31/sources/twitter/events.json`

Note that this is a form of pagination, which is a standard feature of REST APIs. You can find code examples in the [Code Examples](#appendix-code-examples) section.

### Format of Event Records

The response from the Query API will be a list of Events. An Event is of the form 'this subject has this relation to this object'. The most up-to-date list of supported relations is available in [Lagotto](https://github.com/lagotto/lagotto/blob/master/db/seeds/production/relation_types.yml), but the documentation for each Source in this document lists all relation types that the Source produces.f

A sample Event can be read:

 - the DOI `10.1056/NEJMP1608511`
 - was `discussed`
 - in the tweet ID `http://twitter.com/statuses/763877751396954112`
 - on Twitter
 - the text of the tweet is `"RT @NEJM: Recently Published Online First: Caring for High-Need, High-Cost Patients — An Urgent Priority (Perspective) https://t.co/tla7lAd…"`
 - and the author was `kdjhaveri`. 
 - the tweet was made at `2016-08-11T23:20:22Z`
 - and was processed at `2016-08-12T00:41:11Z`.
 - the ID of the Event is `1b5620e1-89c4-4d50-ac65-006babd07b4b`.

It looks like:

    {
      "obj_id": "https://doi.org/10.1056/NEJMP1608511",
      "occurred_at": "2016-08-11T23:20:22Z",
      "subj_id": "http://twitter.com/statuses/763877751396954112",
      "total": 1,
      "id": "1b5620e1-89c4-4d50-ac65-006babd07b4b",
      "subj": {
        "pid": "http://twitter.com/statuses/763877751396954112",
        "author": {
          "literal": "http://www.twitter.com/kdjhaveri"
        },
        "title": "RT @NEJM: Recently Published Online First: Caring for High-Need, High-Cost Patients — An Urgent Priority (Perspective) https://t.co/tla7lAd…",
        "issued": "2016-08-11T23:20:22.000Z",
        "URL": "http://twitter.com/statuses/763877751396954112",
        "type": "tweet"
      },
      "message_action": "create",
      "source_id": "twitter",
      "timestamp": "2016-08-12T00:41:11Z",
      "relation_type_id": "discusses"
    }

The following fields are available:

 - `subj_id` - the subject of the relation as a URI, in this case a tweet. This is normalized to use the `http://doi.org` DOI resolver and converted to upper case.
 - `relation_type_id` - the type of relation.
 - `obj_id` - the object of the relation as a URI, in this case a DOI.
 - `occurred_at` - the date and time when the Event occurred.
 - `id` - the unique ID of the event. This is used to identify the event in Event Data. Is used to trace Evidence for an Event. 
 - `message-action` - what action does this represent? Can be `create` or `delete`. In nearly all cases, this is `create`, but can be `delete` in, for example, Wikipedia.
 - `source_id` - the ID of the source as listed in [Data Sources]{#data-sources}.
 - `subj` - the subject metadata, optional. Depends on the Source.
 - `obj` - the object metadata, optional. Depends on the Source.
 - `total` - the pre-aggregated total that this represents, if this is from a pre-aggregated source such as Facebook. Usually 1. See [Individual Events vs Pre-Aggregated](#concept-individual-aggregated).
 - `timestamp`- the date and time at which the Event was processed by Event Data.

All times in the API in ISO8601 UTC Zulu format.

See [Event Records in Depth](#event-records-in-depth) for more detail on precisely what the fields of an Event mean under various circumstances.

## Evidence API

The Evidence API provides access to Evidence Records and Artifacts. You can find a full discussion of Evidence in the [Evidence In Depth](#in-depth-evidence) section.

An Evidence Record generally corresponds to a single input that came from an external API. For example, the poll of an external API or an input event from a stream.

An Artifact generally corresponds to an internal piece of data is produced by Crossref and consumed in the process of deriving Events from Evidence. For example, the list of DOIs or Newsfeed RSS feed URLs.

### Format of Evidence Records

An Evidence Record looks like:

     {
      "timestamp": "2016-08-12T00:41:11Z",
      "input-artifacts": [
        "http://evidence.eventdata.crossref.org/artifacts/domains-7215EE9C7D9DC229D2921A40E899EC5F",
        "https://github.com/CrossRef/doi-destinations/version/234",
        "https://github.com/CrossRef/event-data-twitter-agent/version/234",
        "http://evidence.eventdata.crossref.org/artifacts/doi-url-7215EE9C7D9DC229D2921A40E899EC5F"
        ]
      "input-status": 200,
      "input-headers": {
        "x-fb-trace-id": "GKoDnoIcGvR",
        "date": "Tue, 23 Aug 2016 08:27:28 GMT",
        "x-fb-rev": "2520541",
        "pragma": "no-cache",
        «SNIPPED»
      },
      "input-body": {
        "tweetId": "tag:search.twitter.com,2005:767511609329803264",
          "author": "http://www.twitter.com/JAMAInternalMed",
          "postedTime": "2016-08-22T00:00:01.000Z",
          "body": "Physicians' utilization patterns of non-recommended services suggest consistent behavior https://t.co/KWintjzxaA https://t.co/1AGbQiFf5m",
          "urls": [
            "http://archinte.jamanetwork.com/article.aspx?articleid=2543749&utm_source=TWITTER&utm_medium=social_jn&utm_term=543832897&utm_content=content_engagement%7Carticle_engagement&utm_campaign=article_alert&linkId=27613815",
            "https://twitter.com/JAMAInternalMed/status/767511609329803264/photo/1"
        ],
        "matchingRules": [
            "url_contains:\"//archinte.jamanetwork.com/\""
        ]},
      "events": [
        {
          "obj_id": "https://doi.org/10.1056/NEJMP1608511",
          "occurred_at": "2016-08-11T23:20:22Z",
          "subj_id": "http://twitter.com/statuses/763877751396954112",
          "total": 1,
          "id": "1b5620e1-89c4-4d50-ac65-006babd07b4b",
          "subj": {
            "pid": "http://twitter.com/statuses/763877751396954112",
            "author": {
              "literal": "http://www.twitter.com/kdjhaveri"
              },
              "title": "RT @NEJM: Recently Published Online First: Caring for High-Need, High-Cost Patients — An Urgent Priority (Perspective) https://t.co/tla7lAd…",
              "issued": "2016-08-11T23:20:22.000Z",
              "URL": "http://twitter.com/statuses/763877751396954112",
              "type": "tweet"
            },
          "message_action": "create",
          "source_id": "twitter",
          "timestamp": "2016-08-12T00:41:11Z",
          "relation_type_id": "discusses"
          }
        ]
      }


Not all fields are compulsory, and the format will vary from Source to Source. However, the following fields are commonly found:

 - `timestamp` - the timestamp that the Evidence was received. This can be different from the `timestamps` and 'occurred_at` fields on the resulting Events. You should not normally use this field.
 - `input-artifacts` - links to Artifacts that were used in processing the input
 - `input-status` - the HTTP status code of an external API response
 - `input-headers` - the HTTP headers of an external API response
 - `input-body` - the HTTP response of an external API as a string, or in some digested form
 - `events` - a list of Events that were produced, in internal Lagotto Deposit format. These may appear to be similar to Event format, but there are some differences. Note that the `events` section may be empty if the input resulted in no Events.

### Getting Evidence Records

If you have an Event and you want to see the Evidence for it, query by its ID.

    http://service.eventdata.crossref.org/evidence/event/«event-id»

You will receive `HTTP 302 Found` response which will provide the URL of the Evidence Record via the `Location` header. Configure your HTTP client to follow redirects and you will download the Evidence Record.

Inside the Evidence Record you will find an `events` section which will contain one or more Events, including the one you queried for. Note that one piece of Evidence may have produced a number of Events.

You can also query for Evidence Records by the date they occurred:

    http://service.eventdata.crossref.org/evidence/occurred/«YYYY-MM-DD»

You will receive a page which includes a list of URLs for all Evidence Records for that day. 

This can be useful if, for example, you want to see all inputs that were received from a particular source, whether or not they resulted in Events. Note that the time in the query corresponds to the `timestamp` field of the Evidence Record, and corresponds to the time the Evidence was processed. The times at which an Event occurred, the Event was collected, the Evidence was processed are different.

## Status Dashboard

Event Data connects to external systems and gathers data from them through a pipeline. Not all external services are available all the time, and some may experience fluctuations in service. The internal pipeline with the Event Data service may become congested or require maintenance from time to time. 

The Event Data Status Dashboard proactively monitors all parts of the system and reports on activity, availability and completeness of data. The Dashboard will be available via a user interface and via an API through which users can access historical data.

# Concepts

## Content Items, URLs, Persistent Identifiers and DOIs {#concept-items-urls-dois}

Crossref has approximately 80 million Items of Registered Content: articles, books, chapters etc. A Content Item is a 'work' according to the [FRBR](http://archive.ifla.org/VII/s13/frbr/frbr1.htm#3.2) model. 

When a Content Item is registered with Crossref or DataCite, it is assigned a Persistent Identifier (PID) in the form of a Crossref DOI or DataCite DOI. The PID permanently identifies the Content Item and is used when referring to, or linking between, Items. Other PIDs, such as PubMed ID (PMID) are available, but they are beyond the scope of Crossref Event Data.

<img src="images/doi-url-simple.svg" class="img-responsive">

All items of Registered Content have a presence on the web, known as the Landing Page. This is the 'home' of the Item and it is hosted on the website of its publisher. It usually contains information about the Item, such as title, other bibliographic metadata, abstract, links to download the content, or possibly the whole article itself.

The purpose of a DOI link is to automatically redirect to the Landing Page. This means that although many users click on DOIs, by the time it comes to share the an Item on social media, the user is on the Landing Page, and might share that URL not the DOI.

Event Data therefore attempts to track Events via the Landing Page URLs as well as via DOI URLs.

### Event Data uses DOIs to refer to Items

Like all Crossref services, whenever CED refers to an Item it uses the DOI to identify it. The Query API uses DOIs to query for data associated with Items and each Event uses DOIs when referring to items.

CED normalizes DOIs into a standard form, using `HTTPS` and the `doi.org` resolver, e.g. `https://doi.org/10.5555/12345678`. Even through Events may be collected via DOIs expressed in different forms, all Events contain DOIs in this form.

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

<img src="images/doi-components.svg" class="img-responsive">

There is an exact one-to-one mapping between Items and their Persistent Identifiers (DOIs), but no exact one-to-one mapping between Items and their Landing Pages. When CED receives data for a Landing Page, it has to follow steps to assign the data to the correct Item.

For an in-depth discussion see [URLs in Depth](#in-depth-urls).

### Landing Page URLs can change.

Over time, Landing Pages can change as publishers reorganize their websites. This is where a Persistent Identifier comes in useful, as it always redirects to the current Landing Page.

<img src="images/doi-url.svg" alt="DOIs and Landing Pages" class="img-responsive">

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

In other cases, Publisher sites implement checks which prevent automated access, such as requiring cookies and performing redirects using JavaScript. For example, trying to resolve the the anonymyzed DOI `10.XXX/YYY.06.008` without cookies enabled produces:

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

### Matching by DOIs {#concept-matching-dois}

Some services use DOIs directly to make references. Wikipedia, for example, has references all over the web, but where they link scholarly articles, the DOI is generally included. There are tools in the page editing workflow to encourage and suggest the incorporation of DOIs. Another Data Source that uses DOIs for references is DataCite, who link datasets to articles via their dataset metadata.

Data that come from services like this can be very precise. We know that the person who made the citation intended to use the DOI to refer to the Item in question and we can reliably report that an Event occurred for the Item with this Crossref DOI.

### External Parties Matching Content to DOIs {#concept-external-doi-mappings}

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

### Landing Page Domains {#concept-landing-page-domains}

CED maintains a list of the domain names that belong to Landing Pages. This is called the [`domain-list` Artifact](#artifact-domain-list). It consists of around 15,000 domains that belong to Publishers. It is automatically generated but manually curated. Some Publishers create DOIs that resolve to domains such as `youtube.com`. These domains produce a large amount of false-positives. They also belong to organizations, such as YouTube, who have no involvement in scholarly publishing, which makes it unlikely that it would be possible to extract data for them in any case. For these reasons, domains of this type are manually removed from the Landing Page Domain list.

This list is used for some sources as an initial pre-filter to identify URLs that might be Landing Pages. 

The Artifact is updated on a regular basis. For more information see [`domain-list` Artifact](#artifact-domain-list).

## Different levels of Data Source Specificity

External sources fall into four broad levels of specificity, in order of preference:

1. Sources that provide only relevant Data.
2. Sources that can be queried by pre-filtering Landing Page Domains.
3. Sources that must be fetched in their entirety.
4. Sources that must be queried once per Item.

### Sources that send only relevant Data {#concept-relevant-source}

Some sources, such as "DataCite Crossref" and "Crossref DataCite" are specialists in the Scholarly Publishing space. They send data to CED, and each item of Data that is sent can be converted into an Event. This is highly efficient, as it means that no data or time is wasted.

### Pre-filtering URLS by their Domain {#concept-pre-filtering}

Some sources, such as Twitter and Reddit support queries by domain. This means that the Agent has to issue each Query once per domain to perform a full scan of the corpus of Items. In these cases the [`domain-list` Artifact](#artifact-domain-list) Artifact is used. It contains around 15,000 domains. In these cases, some data is sent that cannot be matched to an Event, but the ratio is still very high.

When an Agent of this type connects to a Data Source it will conduct a search for this domain list. In the case of Twitter that means constructing a ruleset that includes all domains. In the case of Reddit and Wordpress.com it means conducting one search per domain. This initial filter returns a dataset which mentions one of the domains that is found to contain Landing Pages. From this pre-filtered dataset the Agent then examines each result for Events.

Every Agent that uses the `domain-list` Artifact includes a link to the version of the Artifact they used when they conducted the query.

### Sources that must be queried in their entirety {#concept-query-entirety}

Some sources have no means of filtering or querying and must be downloaded in their entirety. These sources generally contain a high amount of relevant content, so the chance of being able to extract Events is high, and this method isn't wasteful.

Examples of these sources are Newsfeeds. The Newsfeed agent consumes all the data in each Newsfeed and then filters them for Events. As Newsfeed List is curated to include only blogs that are likely to feature links to Items that can be extracted, this approach is reasonably efficient.

### Sources that must be queried once per Item {#concept-once-per-item}

Some sources don't allow queries of the above kind, meaning it is necessary to query once per item to retrieve all the data. This is a slow process, as there are over 80 million items and APIs have rate limits.

Facebook and Mendeley are examples of this type of source. In the case of Mendeley, queries are made using the DOI and in the case of Facebook they use the Landing Page.

To mitigate the problem of long crawl times, CED splits Items into three categories: 

 - high interest Items
 - medium interest Items
 - all Items

The three lists are polled in a loop independently, meaning that the smaller, higher interest Items have updates more often. See the [DOI List](#artifact-doi-list) and [URL List](#artifact-url-list) Artifacts and the documentation for the respective Sources for more details.

## Data Aggregator vs Provider

The NISO Code of Conduct describes an 'altmetric data aggregator as':

> Tools and platforms that aggregate and offer online Events as well as derived metrics from altmetric data providers (e.g., Altmetric.com, Plum Analytics, PLOS ALM, ImpactStory, Crossref).

CED is an 'aggregator' by this definition. We offer 'online events' but we **do not provide metrics**. For some Data Sources that originate within Crossref, CED is also a 'Provider' according to the NISO definition.

Note that a small proportion of Event Data, such as that from Facebook, has is collected in pre-aggregated form.

## Duplicate Data {#concept-duplicate}

When an Event occurs in the wild it may be reported via more than one channel. For example, a blog may have an RSS feed that the Newsfeed agent subscribes to. It may also be included in a blog aggregator's results. In this case the action of publishing the blog post might result in two Events in CED. Note that two Events that describe the same external action via two routes will have different Event IDs.

It is important that CED reports Events without trying to 'clean up' the data. The Evidence pipeline ensures that every input that should result in an Event, does result in an Event. 

## Evidence First {#concept-evidence-first}

Crossref Event Data contains data from external data providers, such as Twitter, Wikipedia and DataCite. Every Event is created with an Agent. In most cases, such as Twitter and Wikipedia, the Agent is operated by Crossref, not by the original data provider. In some cases, such as DataCite, the data provider runs the Agent themselves.

Converting external data into Events provides an evidence gap. It raises questions like:

 - what data was received?
 - how was it converted into Events?
 - if some other service got the same data, why did it produce different results?

<img src="images/evidence-first-evidence-gap.svg" alt="Evidence Gap" class="img-responsive">

#### Bridging the Evidence Gap

CED solves this by taking an **Evidence First** approach. For every piece of external data we receive we create an Evidence Record. This contains all the relevant parts of the input data and all supporting information needed to process it. This means that we can provide evidence for every Event. 

<img src="images/evidence-first-bridge.svg" alt="Bridging the Evidence Gap" class="img-responsive">

Evidence is important because it bridges the gap between generic primary Data Providers, such as Twitter, with the specialized Events in CED. They explain not only what data were used to construct an Event, but also the process by which the Event was created. Providing this explanation pinpoints the precise meaning of the Event within the individual context it comes from.

A number data providers (including, for example, CED) may produce equivalent data. Evidence enables two events from different providers to be compared and helps to explain any discrepancies. It allows the consumer to check whether they were working from the same input data, and whether they processed it the same way.

#### Not all Events need Evidence {#evidence-not-all}

Evidence bridges the gap between external data in a custom format and the resulting Events. There are two factors at play:

 - the format of the data, which is in some external format and needs to be processed into to Events
 - the fact that the original Data Source is controlled by a different party than the Agent that produces Events

Some sources understand and produce Events directly. Examples of these are the `datacite_crossref` and `crossref_datacite` sources. In these cases, the Events themselves are considered to be Primary Data.

We may also accept Events directly from external Data Sources, where the external source runs their own Agent and provides Events as primary data. In this case the Source may not be able or willing to provide any additional evidence beyond the Events themselves.

For more information see [Evidence Records in Depth](#in-depth-evidence-records).

## Occurred-at vs collected-at {#concept-timescales}

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

These are approximate guidelines. In some circumstances the Event may be collected some time after the it occurred:

 - article back-files from years ago are scanned for citations
 - a monthly data-dump comes in and it registers Events from the start of the month
 - a historical data-dump is made available

These two dates are represented as the `occurred_at` and `timestamp` fields on each Event. The Query API has two views which allow you to find Events filtered by both timescales.

### Using the Query API over time

The Query API is updated every day. Once data for a given date exists in the `collected` view of the Query API it will never change. Anything collected on a future day will be made available under that day's view.

The Query API also contains an `occurred` view. This returns Events based on the date they occurred on. Because Events can be collected some time after they occurred, the data in this view can change.

<img src="images/occurred-collected-timeline.svg" alt="Occurred at vs Collected at" class="img-responsive">

When you use the **collected** view you should be aware that it may contain Events that occurred in the past.

When you use the **occurred** view you should be aware that that the results may change over time, and that Events may have happened in the past that have not yet been collected.

### Stable dataset with `collected`

The `collected` dataset provides a stable dataset that can be referenced. You can be confident that the data returned by a query URL won't change over time. You can also be confident that by collecting data for each day you will build a complete dataset of Events collected over that period.

The downside of this is that you will not be able to find Events that occurred on a given day without downloading a complete dataset.

### Flexible data with `occurred`

The `occurred` dataset provides an up-to-date dataset that lets you find Events that occurred on a given day. The data at a Query URL will change over time, so you can't rely on the dataset to be stable and citable.

The timestamp field is available on all Events, so you can see when they were collected and added to the dataset for a given day.

## External Agents {#concept-external-agents}

Most Agents are operated by Crossref (see [Data Sources](#data-sources)). Some are operated by external parties, for example DataCite. We welcome new Data Sources.

Where Crossref operates the Agent we provide full Evidence records for each Event. Where the Agent is operated by an external party, they may or may not provide full Evidence. See [Not all Events need Evidence](#evidence-not-all) for further discussion.

## Individual Events vs Pre-Aggregated {#concept-individual-aggregated}

Most sources, such as Twitter, Wikipedia, DataCite etc, provide a view of individual Events. Some, like Mendeley or Facebook, are only able to capture snapshots of aggregate values. It is preferable to capture individual Events, and pre-aggregated Events are only produced where it is the only format available.

The `occurred_at` field of individual Events is generally the time the original event happened, e.g.

 - the tweet was published at this date and time
 - the edit was made to the Wikipedia article at this date and time

In the case of 'likes' on Facebook, we don't have access to each time an Item was liked (or unliked). We only have visibility of the total number of likes. Therefore for pre-aggregated Events the `occurred_at` field means:

 - the Agent checked Facebook at this date and time and it reported the Item has 5 likes
 - the Agent checked Mendeley at this date and time and it reported the Item is in 10 groups

In Events like this, the `total` field records the number of pre-aggregated Events.

These Events don't record *when* an Item was liked, just the number of likes that exist on a given date. This means that if an Item has a Facebook Event with 100 likes in January and 150 likes in February, we don't know whether 50 extra people liked the Item, or if it was a combination of unlikes and new likes.

Co-incidentally, sources like this also tend to be the type that must be polled once per Item which means that the time between Events for a given Item might be large, and the data might not be very recent. See see [Sources that must be queried once per Item](#concept-once-per-item).

# Event Records in Depth {#event-records-in-depth}

## Subject and Object IDs

The `subj_id` and `obj_id` are URIs that represent the subject and object of the Event respectively. In most cases they are resolvable URLs, but in some cases they can be URIs that represent entities but are not resolvable URLs.

Examples of resolvable `subj_id` or `obj_id`s are: 

 - DOIs, e.g. `https://doi.org/10.5555/12345678`
 - Twitter URLs, e.g. `http://twitter.com/statuses/763877751396954112`

Examples of non-resolvable `subj_id` or `obj_id`s are:

 - Facebook-month, e.g. `https://facebook.com/2016/08/`

URIs like the Facebook-month example are used for two reasons. Firstly, we are collecting data for 'total like count of some users on Facebook', therefore no URL that can identify the entities actually exists. Secondly, it is useful to record the entity-per-date for ease of data processing and counting at a later date.

## Occurred At

The `occurred_at` field represents the date that the Event occurred. The precise meaning of 'occurred' varies from source to source:

For some sources, an event occurs on the publication of a `work`, and the `occurred_at` is the same as the issue date of the work. In these cases, the `occurred_at` value is supplied by the original Source (e.g. Twitter API or metadata on the blog).

 - a tweet was published and it referenced a DOI
 - a blog post was published and it referenced a DOI

For some sources, an event occurs at the point that an existing work is edited and the `occurred_at` is the same as the edit date. In these cases the `occurred_at` value is supplied by the original Source (e.g. Wikipedia API):

 - a Wikipedia article was edited and it referenced a DOI

For some sources, an event occurs at the point that a count is observed from a pre-aggregating source. In these cases, the `occurred_at` value is supplied by the Agent that makes the request to an external service, e.g. Facebook Agent:

 - Facebook was polled for the count for a DOI
 - Mendeley was polled for the count for a DOI

Therefore `occurred_at` field comes from a different authority depending on the source, sometimes an internal service, sometimes an external one. Bear this in mind if you intend to rely on the precise time of an Event. 

## Timestamp

The `timestamp` field represents the date that the Event was processed. Every piece of data travels through an internal pipeline within the Event Data service. The timestamp records the time at which an Event was inserted into the Lagotto service, which is the central component that collects all Events.

<!---
TODO: PIPELINE PICTURE
-->

The `timestamp` is used in the `collected` view in the Query API.

The `timestamp` usually happens a short while after the event was collected. For some sources, such as Twitter, this can be a few minutes. For sources that operate in large batches, such as Facebook, this can be a day or two. Regardless of variation between agents, the `timestamp` represents the canonical time at which Event Data became aware of an Event.

## Subject and Object Metadata

Event Data allows Subject and Object metadata to be included. Where the Subject or Object metadata are DOIs, and therefore can be easily looked up from the Crossref or DataCite Metadata API, it is usually not included. In other cases, it is often included.

For some sources, such as Facebook, the subject ID may be a representative URI and not a URL, and doesn't correspond to a webpage. See [Subject URIs and PIDs in Facebook](#in-depth-facebook-uris) for more details.

## ID

The ID is generated by Agents, whether they're operated by Crossref or external parties. They are expressed as UUIDs and should be treated as opaque identifiers.

See the list of (Sources in-depth)[#in-depth-sources] for a discussion of the various subject fields per source.

## Message Action

Most of the time an Event can be read as 'this relation was created or observed'. An Event records the relationship that came into being at a given point in time.

Sometimes these relationships come and go. For example, in Wikipedia, an edit can result in the removal of a reference from an article. In fact, we often see a history of references being added and removed as the result of a series of edits and sometimes reversions to previous versions.

The removal of a relation in Wikipedia doesn't constitute the removal of an Event, it means a new event that records the fact that that the relation was removed.

# Sources in Depth {#in-depth-sources}

The following is a description of the Sources of data available in CED. Every Data Source requires an Agent to process the data, so the following section describes the format of data, the agent used to collect it and issues surrounding each source.

## Crossref to DataCite Links

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | crossref_datacite |
| Consumes Artifacts        | none |
| Matches by                | DOI |
| Produces relation types   | cites |
| Freshness                 | Daily |
| Data Source               | Crossref Metadata API |
| Coverage                  | All DOIs |
| Relevant concepts         | [Occurred-at vs collected-at](#concept-timescales), [Duplicate Data](#concept-duplicate) |
| Operated by               | Crossref |
| Agent                     | Cayenne |

When members of Crossref (who are mostly Scholarly Publishers) deposit metadata, they can deposit links to datasets via their DataCite DOIs. The Crossref Metadata API monitors these links and sends them to Event Data. As this is an internal system there are no Artifacts as the data comes straight from the source.

### Example Event

    {
      "obj_id":"https://doi.org/10.13127/ITACA/2.1",
      "occurred_at":"2016-08-19T20:30:00Z",
      "subj_id":"https://doi.org/10.1007/S10518-016-9982-8",
      "total":1,
      "id":"71e62cbd-28a8-4a41-9b74-7e58dca03efc",
      "message_action":"create",
      "source_id":"crossref_datacite",
      "timestamp":"2016-08-19T22:14:33Z",
      "relation_type_id":"cites"
    }

### Methodology

 - The Metadata API scans incoming Content Registration items and when it finds links to DataCite DOIs, it adds the Events to CED.
 - It can also scan back-files for links.

### Notes

 - Because the Agent can scan for back-files, it is possible that duplicate Events may be re-created. See (Duplicate Data){#concept-duplicate}.
 - Because the Agent can scan for back-files, Events may be created with `occurred_at` in the past. See (Occurred-at vs collected-at)[#concept-timescales].



## DataCite to CrossRef Links

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | datacite_crossref |
| Consumes Artifacts        | none |
| Matches by                | DOI |
| Produces relation types   | cites |
| Fields in Evidence Record | no evidence record |
| Freshness                 | daily |
| Data Source               | DataCite API |
| Coverage                  | All DOIs |
| Relevant concepts         | [External Agents](#contept-external-agent), [Occurred-at vs collected-at](#concept-timescales) |
| Operated by               | DataCite |

When members of DataCite deposit datasets, they can include links to Crossref Registered Content via their Crossref DOIs. The DataCite agent monitors these links and sends them to Event Data. As this is an External Agent, there are no Artifacts or Evidence Records.

### Example Event

    {
      "obj_id":"https://doi.org/10.1007/S10518-016-9982-8",
      "occurred_at":"2016-08-19T20:30:00Z",
      "subj_id":"https://doi.org/10.13127/ITACA/2.1",
      "total":1,
      "id":"71e62cbd-28a8-4a41-9b74-7e58dca03efc",
      "message_action":"create",
      "source_id":"datacite_crossref",
      "timestamp":"2016-08-19T22:14:33Z",
      "relation_type_id":"cites"
    }

### Methodology

 - DataCite operate an Agent that scans its Metadata API for new citations to Crossref DOIs. When it finds links, it deposits them.
 - It can also scan for back-files

### Notes

 - Because the Agent can scan for back-files, it is possible that duplicate Events may be re-created. See [Duplicate Data](#concept-duplicate).
 - Because the Agent can scan for back-files, Events may be created with `occurred_at` in the past. See [Occurred-at vs collected-at](#concept-timescales).



## Facebook

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | Facebook |
| Matches by                | Landing Page URL |
| Consumes Artifacts        | `high-urls`, `medium-urls`, `all-urls` |
| Produces relation types   | `bookmarks`, `shares` |
| Fields in Evidence Record | Complete API response |
| Freshness                 | Three schedules |
| Data Source               | Facebook API |
| Coverage                  | All DOIs where there is a unique URL mapping |
| Relevant concepts         | [Unambiguously linking URLs to DOIs](#concept-urls), [Individual Events vs Pre-Aggregated](#concept-individual-aggregated), [Sources that must be queried once per Item](#concept-once-per-item) |
| Operated by               | Crossref |
| Agent                     | event-data-facebook-agent |

The Facebook Data Source polls Facebook for Items via their Landing Page URLs. It records how many 'likes' a given Item has received at that point in time, via its Landing Page URL. A Facebook Event records the current number of Likes an Item has on Facebook at a given point in time. It doesn't record who liked the Item or when then the liked it. See [Individual Events vs Pre-Aggregated](#concept-individual-aggregated) for further discussion. The timestamp represents the time at which the query was made. 

Because of the structure of the Facebook API, it is necessary to make one API query per Item, which means that it can take a long time to work through the entire list of Items. This means that, whilst we try and poll as often and regularly as possible, the time between Facebook Events for a given Item can be unpredictable. 

### Freshness

The Facebook Agent uses three categories of Item: `high-urls`, `medium-urls` and `all-urls` (see the [URL Artifact lists documentation](#artifact-url-list) for more detail). It processes the three categories in parallel. In each category it scans the current list of all Items with URLs from start to finish, and queries the Facebook API for each one. It does this in a loop, each time fetching the most recent list of URLs.

The Facebook Agent works within rate limits of Facebook API. If the Facebook API indicates that the rate of traffic is too high then the Agent will lower the rate of querying and a complete scan will take longer.

### Subject URIs and PIDs {#in-depth-facebook-uris}

As Facebook Events are pre-aggregated and don't record the relationship between the liker and the Item, Events are recorded against Facebook as a whole. Because we don't expect to collect Events more than once per month per Item, we create an entity that represents Facebook in a given month.

Each 'Facebook Month' is recorded as a separate subject PID, e.g. `https://facebook.com/2016/8`. This PID is a URI and doesn't correspond to an extant URL. Note that the metadata contains the URL of `https://facebook.com`.

This approach strikes the balance between recording data against a consistent Subject whilst allowing easy analysis of numbers on a per-month basis.

If you just want to find 'all the Facebook data for this DOI' remember that you can filter by the `source_id`.

### Example Event

    {
      "obj_id":"https://doi.org/10.1080/13600820802090512",
      "occurred_at":"2016-08-11T00:00:30Z",
      "subj_id":"https://facebook.com/2016/8",
      "total":5681,
      "id":"55492dc1-ce8a-4c5d-85d0-97a5192519c7",
      "subj":{
        "pid":"https:/facebook.com/2016/8",
        "URL":"https://facebook.com",
        "title":"Facebook activity for August 2016",
        "type":"webpage",
        "issued":"2016-08-01"
      },
      "message_action":"create",
      "source_id":"Facebook",
      "timestamp":"2016-08-11T00:26:48Z",
      "relation_type_id":"references"
    }

<!--- 
### Example Evidence Record

An Evidence Record contains one response from a Facebook API. API requests are batched in groups of URLs, up to 50 at a time. Therefore an Evidence Record can result in multiple Events.

TODO
-->

### Landing Page URLs vs DOI URLs in Facebook

Facebook Users may share links to Items two ways: they may link using the DOI URL, or they may link using the Landing Page URL. When a DOI is used, Facebook records and shows the DOI URL but records statistics against the Landing Page URL it resolves to. This means that Facebook doesn't necessarily maintain a one-to-one mapping between URLs and statistics for that URL.

Event Data always uses the Landing page URL when it queries Facebook and never the DOI URL. If a Facebook user shared an Item using its Landing Page URL then there would be no results for the DOI, and if they used the DOI, the statistics would be recorded against the Landing Page anyway.

Here is a justification of the above approach using examples from the Facebook Graph API v2.7. Note that these API results capture a point in time and the same results may not be returned now.

Where a Facebook User has shared an Item using its DOI, Facebook's system resolves the DOI discover the Landing page. In cases where Facebook has seen the DOI URL it is possible to query using it, e.g. `https://graph.facebook.com/v2.7/http://doi.org/10.5555/12345678?access_token=XXXX` gives:

    {
      og_object: {
        id: "10150995451832648",
        title: "Toward a Unified Theory of High-Energy Metaphysics: Silly String Theory",
        type: "website",
        updated_time: "2016-08-25T01:23:00+0000"
      },
      share: {
        comment_count: 0,
        share_count: 3
      },
      id: "http://doi.org/10.5555/12345678"
    }

If we query for the current Landing Page URL for the same Item we see the same results. `https://graph.facebook.com/v2.7/http://psychoceramics.labs.crossref.org/10.5555-12345678.html?access_token=XXXX` gives:

    {
      og_object: {
        id: "10150995451832648",
        title: "Toward a Unified Theory of High-Energy Metaphysics: Silly String Theory",
        type: "website",
        updated_time: "2016-08-25T01:23:00+0000"
      },
      share: {
        comment_count: 0,
        share_count: 3
      },
      id: "http://psychoceramics.labs.crossref.org/10.5555-12345678.html"
    }

Here we see that Facebook considers the DOI URL and the Landing Page to have the same `id` of `10150995451832648`, because the DOI URL redirected to the Landing Page URL.

DOIs can be expressed a number of different ways using different resolvers and protocols, e.g. `http://doi.org/10.5555/12345678`, `https://doi.org/10.5555/12345678`, `http://dx.oi.org/10.5555/12345678`, `https://dx.doi.org/10.5555/12345678`. These may all treated as different URLs by Facebook. Therefore there is no 'canonical' DOI URL from Facebook's point of view. As they all redirect to the same Landing Page, the Landing Page is the only thing that they have in common from Facebook's perspective.

Where a user has shared the Item using its Landing Page, Facebook is not aware of the DOI. In this example, there is data for the Landing Page of an Item: `https://graph.facebook.com/v2.7/http://www.emeraldinsight.com/doi/abs/10.1108/RSR-11-2015-0046?access_token=XXXX`

    {
      og_object: {
       id: "1034517766662581",
        description: "Impact of web-scale discovery on reference inquiryArticle Options and ToolsView: PDFAdd to Marked ListDownload CitationTrack CitationsAuthor(s): Kimberly Copenhaver ( Eckerd College St. Petersburg United States ) Alyssa Koclanes ( Eckerd College St. Petersburg United States )Citation: Kimberly Copen…",
        title: "Impact of web-scale discovery on reference inquiry: Reference Services Review: Vol 44, No 3",
        type: "website",
        updated_time: "2016-06-30T05:01:41+0000"
      },
        share: {
        comment_count: 0,
        share_count: 8
      },
      id: "http://www.emeraldinsight.com/doi/abs/10.1108/RSR-11-2015-0046"
    }

But a Query using its DOI fails `https://graph.facebook.com/v2.7/http://doi.org/10.1108/RSR-11-2015-0046?access_token=XXXX`:

    {
      id: "http://doi.org/10.1108/RSR-11-2015-0046"
    }

Therefore, whilst Facebook returns results for *some* DOIs, we use exclusively use the Landing Page URL to query Facebook for activity. This takes account of users sharing via the DOI and via the Landing Page.

### HTTP and HTTPS in Facebook

Many websites allow users to access the same content over HTTP and HTTPS, and serve up the same content. Whilst the web server may consider the two URLs equal in some way, Facebook doesn't automatically treat HTTPS and HTTP versions of the same URL as equal. The [WHATWG URL Specification](https://url.spec.whatwg.org/#url-equivalence) supports this position.

If we take the example of a website that allows serving of both HTTP and HTTPS content, e.g. The Co-operative Bank, we see that Facebook assigns different OpenGraph IDs and different `share_count` results.

`https://graph.facebook.com/v2.7/http://co-operativebank.co.uk?access_token=XXXX`

    {
      og_object: {
        id: "10150337668163877",
        description: "The Co-operative Bank provides personal banking services including current accounts, credit cards, online and mobile banking, personal loans, savings and more",
        title: "Personal banking | Online banking | Co-op Bank",
        type: "website",
        updated_time: "2016-08-31T14:07:30+0000"
      },
      share: {
        comment_count: 0,
        share_count: 910
      },
      id: "http://co-operativebank.co.uk"
    }

`https://graph.facebook.com/v2.7/https://co-operativebank.co.uk?access_token=XXXX`

    {
      og_object: {
        id: "742866445762882",
        type: "website",
        updated_time: "2014-09-11T17:38:25+0000"
      },
      share: {
        comment_count: 0,
        share_count: 0
      },
      id: "https://co-operativebank.co.uk"
    }

Other sites implement automatic redirects, and an HTTP URL will immediately redirect to an HTTPS version. For example, PLoS HTTP:

`https://graph.facebook.com/v2.7/http://plos.org?access_token=XXXX`

    {
      og_object: {
        id: "393605900711524",
        description: "A Model for an Angular Velocity-Tuned Motion Detector Accounting for Deviations in the Corridor-Centering Response of the Bee",
        title: "PLOS | Public Library Of Science",
        type: "website",
        updated_time: "2016-08-30T18:28:58+0000"
      },
      share: {
        comment_count: 0,
        share_count: 523
      },
      id: "http://plos.org"
    }

And the HTTPS version: 
`https://graph.facebook.com/v2.7/https://plos.org?access_token=XXXX`

    {
      og_object: {
        id: "393605900711524",
        description: "A Model for an Angular Velocity-Tuned Motion Detector Accounting for Deviations in the Corridor-Centering Response of the Bee",
        title: "PLOS | Public Library Of Science",
        type: "website",
        updated_time: "2016-08-30T18:28:58+0000"
      }
      share: {
        comment_count: 0,
        share_count: 523
      },
      id: "https://plos.org"
    }

Note the same `share_count` and `id`.

Therefore Facebook considers HTTP and HTTPS URLs to be equivalent **if** the HTTP site redirects to HTTPS. 

Crossref Event Data uses the Landing Page that the DOI resolved to. If this is HTTP, then we use HTTP, and this means we query Facebook for the same URL that Facebook users share. If the site subsequently adds HTTPS redirects but CED has an outdated HTTP Landing Page URL, the way Facebook treats redirects will ensure we get the correct results. 

If a situation arises where the publisher serves the same Landing Page both over HTTP and HTTPS without redirecting, CED will use the Landing Page URL that the DOI resolves to. This may result in some views not being accounted for, but it is the most accurate and consistent.

### Methodology

The Agent has three parallel processes. They operate on three Artifacts: `high-urls`, `medium-urls` and `all-urls`. The last of these contains the mapping of all known DOI to URL mappings. The first two contain subsets of these.

Each process:

 1. fetches the most recent version of the relevant URL List Artifact
 2. iterates over each the URL. It uses the Facebook Graph API 2.7 to query data for the Landing Page URL.
 3. the `comment_count` is recorded as an Event with the given `total` field and the `relation_type_id` of `shares`.
 4. the `comment_count` is subtracted from the `share_count` and the result is recorded as an Event with the given `total` field and the `relation_type_id` of `bookmarks`.
 5. When the end of the list is reached, it starts again at step 1.


### Further information

 - [Facebook Graph API](https://developers.facebook.com/docs/graph-api)
 - [Facebook CED Agent](https://github.com/crossref/event-data-facebook-agent)


<!--
## Mendeley

| Property                  | Value          |
|---------------------------|----------------|
| Name                      |  |
| Matches by                | DOI |
| Consumes Artifacts        | `high-dois`, `medium-dois`, `all-dois` |
| Produces relation types   |  |
| Fields in Evidence Record |  |
| Freshness                 |  |
| Data Source               |  |
| Coverage                  |  |
| Relevant concepts         | [Matching by DOIs](#concept-matching-dois), [External Parties Matching Content to DOIs](#concept-external-doi-mappings), [Individual Events vs Pre-Aggregated](#concept-individual-aggregated), [Sources that must be queried once per Item](#concept-once-per-item) |
| Operated by               |  |
| Agent                     |  |

The Mendeley Agent polls Mendeley for every DOI and records the `reader_count` and `group_count` numbers. A Mendeley Event Data record should be read as 'As of this date this Item has this many readers' or 'as of this date this Item is in this many groups'.


### Example Event

TODO

### Example Evidence Record

TODO
-->

### Methodology

1. The Mendeley agent consumes three Artifacts: `high-dois`, `medium-dois` and `all-dois`. It runs a three parallel processes, one per list.
2. For each list, the agent fetches the most recent version of the Artifact.
3. It scans over the entire list, making one query per DOI.
4. For each Item for which there is data, two Event is created with total values. The `reader_count` total is stored in an event with `relation_type_id` of `bookmarks`. The `group_count` total is stored in an event with the `relation_type_id` of `likes`.
4. When it has finished the list, it starts again at step 1.

### Further information

 - [Mendeley API Documentation](http://dev.mendeley.com/methods/)



## Newsfeed

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | `newsfeed` |
| Matches by                | Landing Page URL |
| Consumes Artifacts        | `newsfeed-list` |
| Produces relation types   | `mentions` |
| Fields in Evidence Record |  |
| Freshness                 | half-hourly |
| Data Source               | Multiple blog and aggregator RSS feeds |
| Coverage                  | All DOIs |
| Relevant concepts         | [Unambiguously linking URLs to DOIs](#concept-urls), [Duplicate Data](#concept-duplicate), [Landing Page Domains](#concept-landing-page-domains), [Sources that must be queried in their entirety](#concept-query-entirety), [DOI Reversal Service](#in-depth-doi-reversal) |
| Operated by               | Crossref |
| Agent                     | event-data-newsfeed-agent |

The Newsfeed agent monitors RSS and Atom feeds from blogs and blog aggregators. Crossref maintains a list of newsfeeds, including

 - ScienceSeeker blog aggregator
 - ScienceBlogging blog aggregator
 - BBC News

You can see the latest version of the newsfeed-list by using the Evidence Service: http://service.eventdata.crossref.org/evidence/artifact/newsfeed-list/current 

<!---
#### Example Event

TODO

#### Example Evidence Record

TODO

-->

### Methodology

 - Every hour, the latest 'newsfeed-list' Artifact is retrieved.
 - For every feed URL in the list, the agent queries the newsfeed to see if there are any new blog posts.
 - The content of the body in the RSS feed item are inspected to look for DOIs and URLs. The Agent queries the DOI Reversal Service for each URL to try and convert it into a DOI.
 - The URL of the blog post is retrieved and the body is inspected to look for DOIs and URLs. The Agent queries the DOI Reversal Service for each URL to try and convert it into a DOI.
 - For every DOI found an Event is created with a `relation_type_id` of `mentions`.

### Notes

Because the Newsfeed Agent connects to blogs and blog aggregators, it is possible that the same blog post may be picked up by two different routes. In this case, the same blog post may be reported in more than one event See [Duplicate Data](#concept-duplicate).



<!---
## Reddit

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | event-data-reddit-agent |
| Matches by                | DOI |
| Consumes Artifacts        | `domain-list` |
| Produces relation types   |  |
| Fields in Evidence Record |  |
| Freshness                 |  |
| Data Source               |  |
| Coverage                  |  |
| Relevant concepts         | [Unambiguously linking URLs to DOIs](#concept-urls), [Pre-filtering](#pre-filtering) |
| Operated by               | Crossref |
| Agent                     |  |

DISCUSSION

### Example Event

TODO

### Example Evidence Record

TODO

### Methodology

TODO

### Further information

TODO

-->


<!---
## Twitter

| Property                  | Value          |
|---------------------------|----------------|
| Name                      |  |
| Matches by                | DOI |
| Consumes Artifacts        |  |
| Produces relation types   |  |
| Fields in Evidence Record |  |
| Freshness                 |  |
| Data Source               |  |
| Coverage                  |  |
| Relevant concepts         | [Pre-filtering](#pre-filtering) |
| Operated by               | Crossref |
| Agent                     |  |

The Twitter source identifies Items that have been mentioned in Tweets. It matches Items using their Landing Page or DOI URL. Each event contains subject metadata including:

 - tweet author
 - tweet content
 - tweet type (tweet or retweet)
 - tweet publication date

When Items are matched using their Landing Page URL the URL Reversal Service is used.

DISCUSSION

### Example Event

TODO

### Example Evidence Record

TODO

### Methodology

 1. On a periodic basis the most recent version of the `domain-list` Artifact is retrieved. A set of Gnip PowerTrack rules are compiled and sent to Gnip.
 2. The Twitter agent connects to Gnip PowerTrack.
 3. All tweets matching the URL rule list are sent to the 


### Further information

TODO
-->

<!---
## Wikipedia

| Property                  | Value          |
|---------------------------|----------------|
| Name                      |  |
| Matches by                | DOI |
| Consumes Artifacts        |  |
| Produces relation types   |  |
| Fields in Evidence Record |  |
| Freshness                 |  |
| Data Source               |  |
| Coverage                  |  |
| Relevant concepts         | [Matching by DOIs](#concept-matching-dois)|
| Operated by               | Crossref |
| Agent                     | event-data-wikipedia-agent |

DISCUSSION

### Example Event

TODO

### Example Evidence Record

TODO

### Methodology

TODO

### Further information

TODO


## Wordpress.com

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | `wordpressdotcom` |
| Matches by                | DOI |
| Consumes Artifacts        |  |
| Produces relation types   |  |
| Fields in Evidence Record |  |
| Freshness                 |  |
| Data Source               |  |
| Coverage                  |  |
| Relevant concepts         | [Pre-filtering](#pre-filtering) |
| Operated by               |  |
| Agent                     |  |

The Wordpress.com agent queries the Wordpress.com API for Landing Page Domains. It monitors blogs hosted on Wordpress.com that mention articles by their landing page or by DOI URL.

### Example Event

TODO

### Example Evidence Record

TODO

### Methodology

TODO

note not all Wordpress

### Further information

TODO

-->

# Evidence in Depth {#in-depth-evidence}

Every Event has an Evidence Record. Each Evidence Record corresponds to an input from an external source. Each Evidence Record has links to supporting data in the form of Artifacts.

The Evidence Service links Events to their Evidence.

## Artifacts

An Artifact is an input to an Agent that's required to process its External Input. It provides the necessary context or supporting data that enables an Agent to produce Events. 

## Structure of an Artifact file

Artifacts can be very large, for example the `all-doi` file may be up to 3GB, so they are split up into Artifact Part Files. An Artifact is represented by an Artifact Record, which contains pointers to all of its parts. 

An Artifact Record is a text file that contains a list of URLs, one per line, of the parts that make it up.

 Artifact files are split into parts because they are very large (for example the DOI file may be up to 3GB). To retrieve a complete Artifact, download the Artifact Record and then download each link within it. Every Artifact file (both record and the parts) is made up of a name and an MD5 hash of its content, so you verify that received all the files correctly.

The structure of each type of Artifact file is chosen to best suit the data, and is described per-source below.

### List of Artifact types

| Type name              | Description                      | Example URL                                                                                                |
|------------------------|----------------------------------|------------------------------------------------------------------------------------------------------------|
| high-dois              | High priority DOI list           | http://evidence.eventdata.crossref.org/artifact/high-dois-d41d8cd98f00b204e9800998ecf8427e                 |
| medium-dois            | Medium priority DOI list         | http://evidence.eventdata.crossref.org/artifact/medium-dois-d41d8cd98f00b204e9800998ecf8427e               |
| all-dois               | Entire DOI list                  | http://evidence.eventdata.crossref.org/artifact/entire-dois-d41d8cd98f00b204e9800998ecf8427e               |
| high-urls              | High priority URL-DOI mapping    | http://evidence.eventdata.crossref.org/artifact/high-urls-d41d8cd98f00b204e9800998ecf8427e                 |
| medium-urls            | Medium priority URL-DOI mapping  | http://evidence.eventdata.crossref.org/artifact/medium-urls-d41d8cd98f00b204e9800998ecf8427e               |
| entire-urls            | Low priority URL-DOI mapping     | http://evidence.eventdata.crossref.org/artifact/entire-urls-d41d8cd98f00b204e9800998ecf8427e               |
| newsfeed-list          | Newsfeed list                    | http://evidence.eventdata.crossref.org/artifact/newsfeed-d41d8cd98f00b204e9800998ecf8427e                  |
| domain-list            | Landing Page Domain list         | http://evidence.eventdata.crossref.org/artifact/domain-list-d41d8cd98f00b204e9800998ecf8427e               |
| «software-name»        | The name and version of software | http://github.com/crossref/event-data-facebook-agent/tags/v2.5                                             |


#### High Priority, Medium Priority, Entire DOI List {#artifact-doi-list}

This is a list of Crossref DOIs that are deemed to be high-priority, medium-priority respectively, and the list of all DOIs. The content of an Artifact Part File is a list of DOIs (expressed without a resolver, e.g. `10.5555/12345678`), one per line. 

For Agents that consume a list of DOIs (e.g. Mendeley) these constitute the list of DOIs that the Agent will query for. Every Evidence Record will contain a link to the Artifact that gave rise to the Event.

The High Priority list contains DOIs that have been recently published and for which it is likely we will find Events. Agents that use this list will poll using it on a regular basis.

The Medium list contains DOIs that have been less recently published. Agents that use this list will poll on a less regular basis.

The Entire list contains all DOIs, over 80 million. Agents will try to collect data for all of these, but are limited by the size of the list.

**Note:** Every crawl of a set of DOIs uses a DOI list Artifact ('high', 'medium' or 'all'). Therefore, if you get the Artifact that was used for a given Event ID, you can check the list of DOIs that was used as part of the crawl.

**Note:** DOI list Artifacts are used to generate crawls for certain Agents. You may find Events with DOIs that were not part of the list.

DOI Lists are produced by the Thamnophilus service.

#### High-priority, Medium Priority, Entire URL list {#artifact-url-list}

Every DOI resolves to a URL, at least in theory. The URL lists contain the mapping of DOIs to URLs (and vice versa) where there is a unique mapping. The content of the Part files are alternating lines of DOI, URL.

This file is generated by the Thamnophilus service, which maintains a list of all DOIs and follows each one to see where it leads. If two DOIs point to the same URL then then the mapping is considered ambiguous and it is not included in the Artifact.

The contents of this Artifact change over time for a number of reasons:

 - new DOIs are added
 - it can take time to resolve all of the DOIs, so not all may have been resolved at a different point in time
 - the landing page for a DOI may have changed, meaning the URL has changed
 - we discover an ambiguity that wasn't previously present so the DOI must be removed from the list

The lists are used in a number of places:

 - Agents that query by landing page URL, e.g. Facebook . Like the DOI list, the three URL lists are used to schedule scans at high, medium and low frequencies.
 - The [DOI Reversal Service](#in-depth-doi-reversal), which transforms landing pages back into DOIS for Agents like Twitter

This may be used to answer questions like:

 - When you gathered data for this DOI, e.g from Facebook, which URL did you use to query it?
 - The landing page for a DOI changed. At what point did you start using the new URL to query for it?

**Note:** This Artifact is used by querying Agents such as the Facebook Agent. Other sources may report Events for mappings that are not on this list.

#### Newsfeed List {#artifact-newsfeed-list}

This is a list of RSS and Atom newsfeed URLs. It is manually curated. Each part file contains a list of URLs that are RSS or Atom Newsfeeds. 

We run the Newsfeed Detector software on our DOI Resolution logs to find websites that refer to DOIs. For each website we find, we probe it to try and discover if it has an RSS or Atom newsfeed that we can subscribe to.

The list is manually curated from known blogs and updated every month or two with input from the Newsfeed Detector.

If you think a newsfeed is missing from the list, please contact eventdata@crossref.org

#### Domain List {#artifact-domain-list}

This is a list of domains that DOIs resolve to. The list is created by the Thamnophilus service, which crawls every DOI to find its landing page, and records the domain. The Artifact Part files contain a list of domain names, one per line.

The data is generated automatically but manually curated to some extent. As some DOIs resolve to domains such as `google.com` and `youtube.com`, it is simply impractical to use them.

By providing the domain list as an Artifact, you can answer questions like "why wasn't this landing page matched". 

For context see [Pre-filtering Domains](#concept-pre-filtering).

#### Software Name and Version

Every piece of software that's running as part of Event Data is an Artifact, including all of the Agents. An Agent will include a reference to it's currently running version in any Evidence Log records that it produces. Note that links will be to a tagged release in a source code repository (Github), therefore don't use the Artifact Record structure.

### Artifacts in the Evidence Service

The Evidence Service maintains a list of all of the Artifacts.

You can use the Evidence Service to retrieve the most recent version, or previous versions, of an Artifact.

 - To retrieve the current newsfeed list, for example, visit `http://service.eventdata.crossref.org/evidence/artifact/newsfeed-list/current` and you will be directed to the current Artifact Record. 
 - To retrieve the list of versions of the newsfeed, and what date they were created, visit `http://service.eventdata.crossref.org/evidence/artifact/newsfeed-list/history` and you will be shown a list of all versions with date stamps.
 - To see when new versions of software components, e.g. Agents, were released.

### Finding Artifacts for an Event

Every Event has a corresponding Evidence Record, which contains a link to all of the Artifacts that were used to construct the Event. Therefore, to find the list of newsfeeds that was used to produce a blog reference Event:

 - Retrieve the ID from the Event, e.g. `d41d8cd98f00b204e9800998ecf8427e`
 - Query the Evidence Service to find the Evidence by visiting `http://service.eventdata.crossref.org/event/d41d8cd98f00b204e9800998ecf8427e/evidence`
 - You will see the list of Evidence Links in the response.

## Evidence Records in Depth {#in-depth-evidence-records}

An Agent is responsible for fetching data from an external Data Source and extracting Events from the input data. An Evidence Record is created by an Agent as the result of an input from an external Data Source. It contains the input, the resultant Events, and all the state and information necessary to support the resulting Events.

Every Evidence Record contains the following sections:

 - `input` - the data that entered the system from an external source
 - `artifacts` - the Artifacts that were used in processing
 - `agent` - the name and version of the Agent
 - `state` - any relevant pieces of state 
 - `working` - any internal working that is relevant to the processing of the input
 - `events` - any resulting Events

The precise content of each of these sections varies from Agent to Agent.

### Input

The Input contains the data input from the external source. It may contain the precise input an HTTP body, or some reduction of the input. The Input contains all information necessary to construct the Events.

### Artifacts

The Artifacts that were consumed by the Agent in the course of processing the Input.

### Agent

Internal data about the Agent, including the version number.

### State

Any extra state information necessary to process the Input. For example, because the Newsfeed Agent often checks newsfeeds more regularly than they are updated, it might see the same blog post URL in the Newsfeed twice. 

### Working

Any working data that the Agent produces in the course of generating the Event that might be useful to know. For example, the Newsfeed Agent provides the list of Blog URLs that it considered. If it is unable to retrieve a blog post URL, it will record it here.

### Events

All the Events that were produced. These are in Lagotto Deposit format, which is very similar to the Event format. Each event has an ID, which can be used to track it.

# URLs in Depth {#in-depth-urls}

For context please see [Content Items, URLs, Persistent Identifiers and DOIs](#concept-items-urls-dois).

## Landing Page Conflict Resolution

The DOI-URL Mapping is a one-to-one mapping: every DOI is mentioned only once and every URL is mentioned only once. If we find two DOIs that resolve to the same URL, we use the following process:

1. If a URL maps to only one DOI, that mapping is used.
2. If two DOIs map to one DOI and one Item a parent of the other (indicated by the `parent_doi` tag in the metadata), then the parent DOI is used for the mapping.
3. If two DOIs map to one URL we look in the metadata for the `publication_type`. If one has a value of `full_text` and the other has a value of `abstract_only` or `bibliographic_record`, the Item with the `publication_type` of `full_text` is used.
4. Failing that, the mapping is excluded.

<img src="images/conflict-resolution.svg" alt="Conflict Resolution Examples" class="img-responsive">

Note that this process is used only when constructing the DOI-URL list, in order that URLs can be mapped to DOIs. If an Event that mentions e.g. a component DOI is produced by a source, the event will be recorded against the Item with that Component DOI.

## DOI Reversal Service {#in-depth-doi-reversal}

The DOI Reversal Service converts Landing Pages back into DOIs so they can be used to identify Items. It uses a variety of techniques including:

 - looking up the Landing Page in the `url-doi` Artifact mapping.
 - searching for a valid DOI embedded in the URL
 - looking up SICIs (Serial Item and Contribution Identifier) embedded in the URL
 - looking up PIIs (Publisher Item Identifier)
 - looking in the HTML metadata of the URL to see if a DOI is supplied

The process of DOI Reversal is not perfect and because these methods may not always succeed it will never be possible to match 100%. See [URLS in Depth](#in-depth-urls) for a discussion of some of the issues.

# Appendix 1: Software in Use

The Crossref Event Data system has a number of components. All parts of the system that are used to generate or distribute Events, Evidence, Artifacts are open source. 

You can find the latest versions of running software via the Evidence Service.

Crossref Event Data uses a collection of software. It is all open source. 

| Name                  | Description                                                   | URL                                                           | Maintainer          |
|---------------------  |-------------------------------------------------------------  |-------------------------------------------------------------- |-------------------- |
| Lagotto               | Service to store, process and exchange Events                 | http://lagotto.io                                             | DataCite, Crossref  |
| Facebook Agent        | Agent to query Facebook for Events.                           | https://github.com/crossref/event-data-facebook-agent         | Crossref            |
| Query API Loader      | Service to generate the Event Data Query API                  | https://github.com/crossref/event-data-query-api-loader       | Crossref            |
| Wikipedia Agent       | Agent to monitor Wikipedia for Events.                        | https://github.com/crossref/event-data-wikipedia-agent        | Crossref            |
| Wordpress.com Agent   | Agent to monitor Wordpress.com for Events.                    | https://github.com/crossref/event-data-wordpressdotcom-agent  | Crossref            |
| Twitter Agent         | Agent to monitor Twitter for Events.                          | https://github.com/crossref/event-data-twitter-agent          | Crossref            |
| Reddit Agent          | Agent to monitor Reddit for Events.                           | https://github.com/crossref/event-data-reddit-agent           | Crossref            |
| Newsfeed Agent        | Agent to monitor newsfeeds for blogs (RSS, Atom) for Events   | https://github.com/crossref/event-data-newsfeed-agent         | Crossref            |
| Evidence Processor    | Service to process Evidence from Agents.                      | https://github.com/crossref/event-data-evidence-processor     | Crossref            |
| Evidence Service      | Service to serve Evidence API.                                | https://github.com/crossref/event-data-evidence-service       | Crossref            |
| Thamnophilus          | Collects and resolves DOIs to produce Artifacts.              | https://github.com/crossref/thamnophilus                      | Crossref            |
| DOI Destinations      | Service to convert landing page URLs back into DOIs.          | https://github.com/crossref/doi-desetinations                 | Crossref            |
| Newsfeed Detector     | Service to monitor Crossref resolution logs for blogs         | https://github.com/crossref/event-data-newsfeed-detector      | Crossref            |

<!---

### Lagotto

Description
: Service to store, process and exchange Events

URL
: http://lagotto.io

Maintainer
: DataCite, Crossref

All Agents push Deposits into Lagotto. The Query API processes output from Lagotto. Exchanges data with DataCite's Event Data system.

### Facebook Agent

Description
: Agent to poll Facebook

### Query API Loader

The Query API Loader is a service for maintaining the Query API.

### Wikipedia Agent
### Wordpress.com
### Twitter Agent
### Reddit Agent
### Newsfeed Agent
### Evidence Processor
### Evidence Service
### Thamnophilus
### DOI Destinations

### Newsfeed Detector

Status: Planned for development.

This is internal software. It is used to generate the `newsfeed-list` Artifact. 

The Newsfeed Detector analyzes our DOI Resolution Logs and builds a list of domain names that refer web traffic to the `doi.org` resolver. It monitors those domains and detects if they have RSS feeds.

The Newsfeed List is manually curated using input from the Newsfeed Detector. For more information see the [`newsfeed-list` Artifact](#artifact-newsfeed-list).

-->

# Appendix: NISO Altmetrics Code of Conduct {#appendix-niso-coc}

### 1: List all available data and metrics (providers and aggregators) and altmetric data providers from which data are collected (aggregators).

CED is a platform for collecting event data. The data are gathered through a combination of actively collecting data from non-scholarly sources and allowing scholarly sources to send data. It focuses on events ("these things happened") not aggregations ("this many things happened") or metrics ("you got this score"). You can find the list of Sources in [Sources](#data-sources).

### 2: Provide a clear definition of each metric.

Crossref CED reports raw Events, not metrics. The [Sources in Depth](#in-depth-sources) provides a detailed discussion of each Source and exactly what Events from the Source means.

### 3: Describe the method(s) by which data are generated or collected and how data are maintained over time.

The [Sources in Depth](#in-depth-sources) provides a detailed discussion of each Source and exactly what Events from the Source means. 

### 4: Describe all known limitations of the data.

The [Sources in Depth](#in-depth-sources) provides a detailed discussion of each Source and the limits of the Data it produces.

### 5: Provide a documented audit trail of how and when data generation and collection methods change over time and list all known effects of these changes. Documentation should note whether changes were applied historically or only from change date forward.

The [Evidence In Depth](#in-depth-evidence) section describes the complete audit trail of data, from input to Events, via Evidence Records. It also describes how the Artifact Service shows the complete environment under which an Event was generated.

### 6: Describe how data are aggregated

Data is not aggreated.

### 7: Detail how often data are updated.

Each Event has a timestamp which describes when the Event was collected. The [Occurred at vs Collected At](#concept-timescales) section explains that the 'collected' view in the Query API is updated daily, and once a day's data is provided, it never changes. It also details the 'occurred at' view and how to tell when Event Data was updated. The [Evidence Service](#in-depth-evidence) automatic documentation of when Artifacts were updated.

### 8: Describe how data can be accessed

The [Service](#the-service) section details the Query API, which is used for accessing Event Data and the Evidence API, which is used for accessing audit data..

### 9: Confirm that data provided to different data aggregators and users at the same time are identical and, if not, how and why they differ.

There is only one version of the data. All consumers receive the same data regardless of audience.

### 10: Confirm that all retrieval methods lead to the same data and, if not, how and why they differ.

There is only one version of the data. All consumers receive the same data regardless of retrieval method.

### 11: Describe the data-quality monitoring process.

The Evidence Service allows anyone to perform audits on Event Data. The Status Service monitors the performance and activity of all parts of the system. We will run an automatic service to analyze the outputs to ensure they correlate to the inputs.

### 12: Provide a process by which data can be independently verified.

All data is available on the Query API and Evidence API.

### 13: Provide a process for reporting and correcting data or metrics that are suspected to be inaccurate

Crossref support will be able to handle requests. We can attempt to reprocess raw data to re-generate events. We can back-fill missing events with appropriate date-stamps. As we are not aggregating events into metrics or scores, we will not provide scores which might later need adjustment.

If there are any interruptions or other notices, they will be recorded via the Status Service.

<!---
# Appendix: Code Examples {#appendix-code-examples}

Here are some examples in Python.

TODO
-->

# Appendix: Contributing to Event Data

We welcome new Data Sources. Using the Lagotto Deposit API, third parties can easily push Events. We run a Sandbox instance for developers to work with and for integration testing. Please review the [API section](#using-the-api) for familiarity with the Deposit format. The [API is documented using Swagger](http://api.eventdata.crossref.org/api).

### Preparation

We would love to help you develop your Push Source.

 1. Contact us at eventdata@crossref.org to discuss your source. 
 1. Decide what kind of Relation Types best describe your data.
 1. Decide if your source supplies pre-aggregated or individual Events.

### Tokens

 1. Sign in at [http://sandbox.api.eventdata.crossref.org](http://sandbox.api.eventdata.crossref.org).
 1. Email eventdata@crossref.org and we will enable your account for Push API access. Pushes won't work until we do this.
 1. Click on your name, select 'your account'. Copy your API key. You will use this to authenticate all of your push requests.
 1. Create a UUID for your agent. You can use your a GUID library of your choice or a service like [uuidgenerator.net](https://www.uuidgenerator.net/). This will be your Source Token, and will uniquely identify your agent. Don't re-use this for another agent.

### Format

 1. One HTTP POST is made per deposit. The payload should be in JSON format, with the `Content-Type: application/json` header.
 1. Authentication using your token should use the header: `Authorization: Token token=«your-token»`.
 1. A Event is expressed as a Subject, Object, Relation Type, Total and Date. 
    1. The Subject, `subj_id` must be a URL. It can be a DOI or a web page.  
    1. The Object, `subj_id` must be a URL. It is usually a DOI.
    1. The Total can be omitted, and it defaults to 1. For cases where the Deposit corresponds to countable information, you can supply an integer. 
    1. If the Subject or Object is a DOI, CED will automatically look up the metadata. If not, you must supply minimal metadata as `subject` or `object` respectively.
 1. Create a UUID for your Deposit. Every deposit must have a unique UUID.

### Sending Data

 1. Send your Deposit by POSTing to [`http://sandbox.api.eventdata.crossref.org/api/deposits`](http://sandbox.api.eventdata.crossref.org/api/deposits)
 1. You will receive a 202 on success or a 400 on failure. 
 1. You can check on the status of your deposit by visiting `http://sandbox.api.eventdata.crossref.org/api/deposits/«deposit-id»`
 1. Deposits will usually be processed within a few minutes. When the status changes from `waiting` to `done`, it has been fully processed. If there is an error processing, it will read `failed`.

### Ready to go!

 1. When you are happy with your Agent, let us know and we will enable it in the Production service.
 1. Switch over from the Staging Environment, `staging.api.eventata.crossref.org` to the Production Environment, `api.eventdata.crossref.org`
 1. Enable your agent, push historical deposits if necessary, and start pushing new data!

## Examples

Here are some worked examples using cURL.

### Example 1: Bigipedia

Bigipedia is an online Encyclopedia. It cites DOIs in its reference list for its articles. Its source token is `b1bba157-ab5b-4cb8-9ac8-4beb2d6405ff`. Bigipedia will tell CED every time a DOI is cited, and will send data every time a citation is added.

In this example, Bigipedia informs us that the DOI is referenced by the article page. Note that because the subject is not a DOI, the metadata must be supplied in the `subj` key. 

    $ curl "http://sandbox.api.eventdata.crossref.org/api/deposits" \
           --verbose \
           -H "Content-Type: application/json" \
           -H "Authorization: Token token=591df7a9-5b32-4f1a-b23c-d54c19adf3fe" \
           -X POST \
           --data '{"deposit": {"uuid": "dbba925e-b47c-4732-a27b-0063040c079d",
                                "source_token": "b1bba157-ab5b-4cb8-9ac8-4beb2d6405ff",
                                "subj_id": "http://bigipedia.com/pages/Chianto",
                                "obj_id": "http://doi.org/10.3403/30164641u",
                                "relation_type_id": "references",
                                "source_id": "bigipedia",
                                "subj": {"title": "Chianto",
                                            "issued": "2016-01-02",
                                             "URL": "http://bigipedia.com/pages/Chianto"}}}'

Response:

    HTTP/1.1 202 Accepted

    {"meta":
      {"status":"accepted",
       "message-type":"deposit",
       "message-version":"v7"},
       "deposit":{
         "id":"dbba925e-b47c-4732-a27b-0063040c079d",
         "state":"waiting",
         "message_type":"relation",
         "message_action":"create",
         "source_token":"b1bba157-ab5b-4cb8-9ac8-4beb2d6405ff",
         "subj_id":"http://bigipedia.com/pages/Chianto",
         "obj_id":"http://doi.org/10.3403/30164641u",
         "relation_type_id":"references",
         "source_id":"bigipedia",
         "total":1,
         "occurred_at":"2016-04-19T15:26:02Z",
         "timestamp":"2016-04-19T15:26:02Z",
         "subj":{
            "title":"Chianto",
            "issued":"2016-01-02",
            "URL":"http://bigipedia.com/pages/Chianto"},
          "obj":{}}}

You would be able to check on the status at `http://sandbox.api.eventdata.crossref.org/api/deposits/dbba925e-b47c-4732-a27b-0063040c079d`

### Example 2: DOI Remember

DOI Remember is a bookmarking service for DOIs. DOI Remember will tell CED how many times each DOI is cited. Every day it will send data for every DOI, stating how many times it is currently bookmarked. Its source token is `366273b5-d3d8-488b-afdc-940bcd0b9b87`.

In this example, DOI Remember tells that as of the 1st of March 2016, 922 people have bookmarked the given DOI. The Subject is the 'DOI Remember' source as a whole. As its URL is not a DOI, subject metadata must be included. CED allows for the year `0000-01-01` for the issue date when it's not meaningful to provide one.
    
    $ curl "http://sandbox.api.eventdata.crossref.org/api/deposits" \
           --verbose \
           -H "Content-Type: application/json" \
           -H "Authorization: Token token=22e49a7c-5edd-4873-a2b2-c541512c933a" \
           -X POST \
           --data '{"deposit": {"uuid": "c06fc051-5e29-4cd3-b46a-652c646a3582",
                                "source_token": "366273b5-d3d8-488b-afdc-940bcd0b9b87",
                                "subj_id": "http://doiremember.com",
                                "obj_id": "http://doi.org/10.3403/30164641u",
                                "total": 922,
                                "occurred_at": "2016-03-01",
                                "relation_type_id": "bookmarks",
                                "source_id": "doi_remember",
                                "subj":{
                                  "title":"DOI Remember",
                                  "issued":"0000-01-01",
                                  "URL":"http://doiremember.com"}}}'

### Example 3: Hansard Watch

Hansard Watch is a service that monitors the UK House of Commons and sends an event every time a DOI is mentioned in Parliament. Every time it finds a new DOI mention it will send a link to the URL of the online Hansard page. Its source token is `a8d4efa6-868b-4230-9685-74b6c7c192bf`.

In this example, the given Hansard page discusses the given DOI. It has a publication date.

    $ curl "http://sandbox.api.eventdata.crossref.org/api/deposits" \
       --verbose \
       -H "Content-Type: application/json" \
       -H "Authorization: Token token=b832bf3a-f5ca-4435-9a2b-09fec0f313a6" \
       -X POST \
       --data '{"deposit": {"uuid": "16acd857-82b8-493c-8e79-6ac0a67ce53b",
                            "source_token": "a8d4efa6-868b-4230-9685-74b6c7c192bf",
                            "subj_id": "https://hansard.parliament.uk/Commons/2013-04-24/debates/13042449000029/VATOnToastedSandwiches",
                            "obj_id": "http://doi.org/10.3403/30164641u",
                            "occurred_at": "2013-03-24",
                            "relation_type_id": "discusses",
                            "source_id": "hansard_watch",
                            "subj":{
                              "title":"Previous VAT on toasted sandwiches",
                              "issued":"2013-03-24",
                              "URL":"https://hansard.parliament.uk/Commons/2013-04-24/debates/13042449000029/VATOnToastedSandwiches"}}}'

### Example 4: TrouserPress

TrouserPress is an online hosted blogging platform. It's increasingly being used for Science Communication. Every time someone publishes a post that cites a DOI it will send a link to the URL of the blog post. Its source token is `d9a177bd-9906-4244-864d-1fb83d8c58ed`.

In this example, the given TrouserPress article discusses the DOI.

    curl "http://sandbox.api.eventdata.crossref.org/api/deposits" \
       --verbose \
       -H "Content-Type: application/json" \
       -H "Authorization: Token token=22810d9a-8fae-4905-8d0d-ac7b98731646" \
       -X POST \
       --data '{"deposit": {"uuid": "baa93bc4-c832-4e19-aaac-d52ad827843a",
                            "source_token": "d9a177bd-9906-4244-864d-1fb83d8c58ed",
                            "subj_id": "http://trouser.press/jim/my-favourite-dois",
                            "obj_id": "http://doi.org/10.3403/30164641u",
                            "occurred_at": "2013-03-24",
                            "relation_type_id": "discusses",
                            "source_id": "trouser_press",
                            "subj":{
                              "title":"My Top 10 DOIs",
                              "author": "Jim",
                              "issued":"2013-03-24",
                              "URL":"http://trouser.press/jim/my-favourite-dois"}}}'


# Appendix: FAQ

Does CED collect data for all DOIs in existence?
  : CED will accept Events for DOIs issued by any RA (for example, DataCite), and will poll for all Crossref DOIs. Different sources operate differently, so the data for some sources will be fresher than others.
 
Which Registration Agencies' DOIs does CED use?
  : CED is is a joint venture by Crossref and DataCite. It is able to collect DOIs from any DOI Registration Agency (RA), and most Data Sources don't check which RA a DOI belongs to. So in theory, some MEDRA DOIs might end up being included. However, some Data Sources (such as Twitter) target only Crossref and DataCite DOIs. Check the individual Data Sources for full details.

How long is Data available?
  : Once data has entered the Query API it won't be removed (unless under extraordinary circumstances). The data will never 'expire'.
 
What is an event?
  : An event can be described as 'an action that occurs concerning a Content Object'. Every kind of event is slightly different, see the Sources for details.

What format does the API data come in?
  : All APIs use JSON format

Do I have to pay for the data?
  : No, the public data via the Query API will be free. We will offer a paid-for Service Level Agreement that will provide more timely access to data.

Will the data be auditable?
  : Yes. Event Data is evidence-first and we will supply supporting Evidence for all data that we collect. See [Evidence First](#concept-evidence-first).

Can I use the data to feed into my commercial tool? 
  : Yes. We do not clean or aggregate the data we collect so that any commercial vendor has the opportunity to do this themselves in order to use the data in the way which best suits their needs.

Is your code base open source?
  : Yes, all the code we use is open source. See the [Software](#software) section.

When will Event Data be launched?
  :  We are aiming to launch toward the end of 2016.

How do I access the data?
  : The Query API is currently the only way to access data. 

Does CED work with Multiple Resolution?
  : We plan to address and clarfiy how CED relates to Multiple Resolution in future.



# Appendix: Glossary

Agent
  :  A piece of software that gathers data for a particular Data Source and pushes it into CED. These can be operated by Crossref, DataCite or a third party.

Altmetrics
  :  [From Wikipedia](https://en.wikipedia.org/wiki/Altmetrics): In scholarly and scientific publishing, altmetrics are non-traditional metrics proposed as an alternative to more traditional citation impact metrics, such as impact factor and h-index. Proposed as generalization of article level metrics.

Landing Page
  :  The Publisher's page for an article (or dataset etc). Every DOI resolves to a landing page, but there may be more than one landing page per Article. The URLs of landing pages can change over time, and the DOI link should always point to the landing page.

Data Source
  :  The provenance or type of Event Data. Data Sources include Wikipedia, Mendeley, Crossref, DataCite etc. A source is different to an agent, which is a piece of software that fetches data for a particular Data Source.

Event UUID
  :  A UUID that corresponds to an event within Crossref Event Data. 

Registration Agency
  :  An organization that assigns DOIs. For example, Crossref and DataCite.

Registered Content
  :  Content that has been registered with Crossref and assigned a Crossref DOI, e.g an article or book chapter.

UUID
  :  Universally Unique Identifier. Essentially a random number that identifies an Event. Looks like `c0eb1c46-6a59-49c9-926b-a10667ddd9de`.

# Appendix: Abbreviations

API
  :  Application Programming Interface. An interface for allowing one piece of software to connect to another. CED collects data from other APIs from other services and provides an API for allowing access to data.

CED
  :  Crossref Event Data

CoC
  :  Code of Conduct

DET
  :  DOI Event Tracking, the original name for Crossref Event Data.

DOI
  :  Digital Object Identifier. An identifier given to a Content Item, e.g. http://doi.org/10.5555/12345678

JSON 
  :  JavaScript Object Notation. A common format for sending data. All data coming out of the CED API is in JSON format.

MEDRA
  :  Multilingual European DOI Registration Agency. A DOI Registration Agency.

NISO
  :  National Information Standards Organization. A standards body who have created a Code of Conduct for altmetrics.

ORCiD
  :  Open Researcher and Contributor ID. A system for assigning identifiers to authors.

PII: 
  : Publisher Item Identifier, an identifier used internally by some Publishers.

RA
  :  DOI Registration Agency. For example Crossref or DataCite.

SLA
  :  Service Level Agreement. An agreement that CED will provide predictable service via its API.

SICI
  :  Serial Item and Contribution Identifier, an identifier used internally by some Publishers.

TLA
  :  Three letter abbreviation. 

URL
  :  Uniform Resource Locator. A path that points to a Research Object, e.g. `http://example.com`

UUID
  :  Universally Unique Identifier. Looks like `c0eb1c46-6a59-49c9-926b-a10667ddd9de`.

## Deprecated Terminology

The following words have been used during the development of Event Data but are no longer official:

 - Deposit - this is an internal entity used within Lagotto. It does not form part of the public DET service, although it may be of interest to users who want to look into the internals.
 - 'DOI Event Tracking' / 'DET' - the old name for the Crossref Event Data service
 - Relations - this is an internal entity used within Lagotto. CED does not use Lagotto Relation objects. The concept of a 'relation' is present in the Event object as a description of how a subject and an object are related.
 - Publisher Domains - now referred to as Landing Page Domains

# Revision history

| Date              | Version | Author                      |                                                   |
|-------------------|---------| ----------------------------|---------------------------------------------------|
| 18-April-2016     | 0.1     | Joe Wass jwass@crossref.org | Initial MVP release                               |
| 19-April-2016     | 0.2     | Joe Wass jwass@crossref.org | Add 'Contributing to Event Data'                  |
| 16-August-2016    | 0.3     | Joe Wass jwass@crossref.org | Remove Relations & Deposits, update new Query API |
| 08-September-2016 | 0.4     | Joe Wass jwass@crossref.org | Complete rewrite using new concepts and components|
