---
title: Crossref Event Data User Guide
papersize: a4
documentclass: book
margin-left: 2cm
margin-right: 2cm
margin-top: 2cm
margin-bottom: 4cm
fontfamily: "sans"
---

v0.4 draft


# Welcome

Welcome to the Crossref Event Data User Guide. It contains everything you need to know about Crossref Event Data (and probably a little more), from a high-level overview down to the details in-depth. It is split into four sections:

 - "Introduction" is a high level overview of the service and background and is suitable for everyone.
 - "The Service" describes the Event Data service and how to use it.
 - "Concepts" covers some of the issues that should be understood before using Event Data.
 - "In Depth" describes all the technical detail required to understand and integrate with the service from top to bottom and is suitable for a technical or research audience.

Everyone should read the introduction. You can jump ahead to "The Service" for a detailed description of what CED provides, but for full understanding you should read "Concepts".

**This document is pre-release. Some features described here are at preview stage and some are planned. The Event Data Service has not yet launched and is not feature-complete.**

# 1 Introduction

Crossref is home to over 80 million items of Registered Content (mostly journal articles, but we also have book chapters, conference papers etc). Crossref Event Data is a service for collecting events that occur around these items. For example, when datasets are linked to articles, articles are mentioned on social media or referenced online.

<img src="images/overview.png" alt="Event Data Overview" class="img-responsive">

Much of the activity around scholarly content happens outside of the formal literature. The scholarly community needs an infrastructure that collects, stores, and openly makes available these interactions. Crossref Event Data will monitor and collect links to scholarly content on the open web. The greater visibility provided by Crossref Event Data will help publishers, authors, bibliometricians and libraries to develop a fuller understanding of where and how scholarly content is being shared and consumed.


## Events

Every 'thing that happens' is recorded as an individual Event. We gather Events from a wide range of sources, but examples include:

 - an article was linked from DataCite dataset via its Crossref DOI
 - an article was referenced in Wikipedia using its Crossref DOI
 - an article was mentioned on Twitter using its Article Landing Page URL
 - an article has been liked on Facebook 55 times as of June 15th

Events from every Data Source are different, but they have a common set of attributes:

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

<img src="images/introduction-evidence-flow.svg" alt="Event Data Evidence Flow" class="img-responsive">

Crossref Event Data was developed alongside the NISO recommendations for Altmetrics Data Quality Code of Conduct, and we participated in the Data Quality working group. CED aims to be an examplar altmetrics data provider, setting the standard in openness and transparency. You can read the [CED Code of Conduct Self-Reporting table](#appendix-niso-coc) in the appendix.

## Accessing the Data 

Crossref Event Data is available via our Query API. The Query API allows you to make requests like:

 - give me all events that were collected on 2016-12-08
 - give me all events that occurred on 2015-12-08
 - give me all the facebook events that were collected on 2015-12-08
 - give me all the events that occurred for this DOI on 2016-01-08
 - give me all the twitter events that occurred for this DOI on 2016-01-08

We will add other mechanisms for retrieving Events when we introduce the Service Level Agreement.

The data is made available via a REST API. Because around a million events are collected per month, the queries are made to the API on a per-day basis. Even per day there are tens of thousands of events, so it's worth deciding on a query filter that matches your use case.

## Reliability and Monitoring

We will provide a Health Dashboard which will show how each component in the system and each external source is functioning. CED integrates with a number of external data sources, and is transparent about how we interact with them.

## Service Level Agreement

We will introduce a Service Level Agreement which will provide agreed service levels for responsiveness of the service. It will also include APIs for access to data.

# 2 The Service

Crossref Event Data is a system for collecting Events and distributing them. Up to 100,000 Events occur per day, which is approximately one per second. Events for most Data Sources are collected and produced by Crossref, but some are produced by our partners.

 - The Query API provides an interface for accessing Events. It's a REST API that allows download of events and supports various filters. 

 - Every Event that Crossref produces has an Evidence Record. These are available via the Evidence Service. It provides supporting evidence for every Event.

 - Every component in the CED system, internal and external, in CED is monitored. The Health Dashboard monitors all data flowing into the system, all parts of the processing pipeline, and the delivery mechanisms. It records the availability and activity of components and completeness of data.

## Data Sources {#data-sources}

Event Data is a hub for the collection and distribution of Events and contains data from a selection of Data Sources. 

| Name                   | Source Identifier   | Provider    | What does it contain? |
|------------------------|---------------------|-------------|------------------|
| Crossref to DataCite   | crossref_datacite   | Crossref    | Dataset citations from Crossref Items to DataCite Items |
| Facebook               | facebook            | Crossref    | Count number of likes and comments for Items |
| Mendeley               | mendeley            | Crossref    | Reader count number, etc from Mendeley |
| Newsfeed               | newsfeed            | Crossref    | Mentions of Items on blogs and websites with syndication feeds |
| Reddit                 | reddit              | Crossref    | Mentions and discussions of Items on Reddit |
| Twitter                | twitter             | Crossref    | Mentions of Items on Twitter |
| Wikipedia              | wikipedia           | Crossref    | References of Items on Wikipedia |
| Wordpress.com          | wordpressdotcom     | Crossref    | References of Items on Wordpress.com blogs |
| DataCite to Crossref   | datacite_crossref   | DataCite    | Dataset citations from DataCite Items to Crossref Items |

For detailed discussion of each one, see the [Sources In Depth](#in-depth-sources) section.

## Query API

The Query API provides access to Event Data. It is simple REST API and uses JSON. Because there are up to a million events per month, every query is scoped by a date, in `YYYY-MM-DD` format. Even when scoped to a particular date, there can be tens of thousands of events. Therefore there are a number of filters available.

When you write a client to work with the API it should be able to deal with responses in the tens of megabytes, preferably dealing with them as a stream. You may find that saving an API response directly to disk is sensible.

### Timing and Freshness

The Query has two date views: `collected` and `occurred`. See ['Occurred-at vs Collected-at'](#concept-timescales) for a more detailed discussion. Each is suitable for different use cases:

 - `collected` is useful when you want to run a daily query to fetch all events for a given filter and you want to be sure you always have all available events
 - `collected` is useful when you want to reference a dataset and be sure it never changes
 - `occurred` is useful when you want to retrieve events that occurred at a particular time
 - when using `occurred` you should be aware that new events may be collected at any time in the future that occurred at a date in the past

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

If you want to collect all events for a given date range, you can issue a set of queries. E.g. to get all Wikipedia events in August 2016, issue the following API queries:

 - `http://query.api.eventdata.crossref.org/occurred/2016-08-01/sources/twitter/events.json`
 - `http://query.api.eventdata.crossref.org/occurred/2016-08-02/sources/twitter/events.json`
 - `http://query.api.eventdata.crossref.org/occurred/2016-08-03/sources/twitter/events.json`
 - `http://query.api.eventdata.crossref.org/occurred/2016-08-.../sources/twitter/events.json`
 - `http://query.api.eventdata.crossref.org/occurred/2016-08-31/sources/twitter/events.json`

Note that this is a form of pagination, which is a standard part of REST APIs. You can find code examples in the [Code Examples](#appendix-code-examples) section.

### Format of Event Records

The response from the Query API will be a list of Events. An Event is of the form "this subject has this relation to this object". The list of relations is:

The most up-to-date list of supported relations is available in [Lagotto](https://github.com/lagotto/lagotto/blob/master/db/seeds/production/relation_types.yml).

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

 - `subj_id` - the subject of the relation as a URI, in this case a tweet.
 - `relation_type_id` - the type of relation.
 - `obj_id` - the object of the relation as a URI, in this case a DOI.
 - `occurred_at` - the date and time when the Event occurred.
 - `id` - the unique ID of the event. This is used to identify the event in Event Data. Is used to trace Evidence for an Event. 
 - `message-action` - what action does this represent? Can be `create` or `delete`. In nearly all cases, this is `create`, but can be `delete` in, for example, Wikipedia.
 - `source_id` - the ID of the source as listed in [Data Sources]{#data-sources}.
 - `subj` - the subject metadata, optional. Depends on the Source.
 - `obj` - the object metadata, optional. Depends on the Source.
 - `total` - the pre-aggregated total that this represents, if this is from a pre-aggregated source such as Facebook. Usually 1. See [Individual Events vs Pre-Aggregated](#concept-individual-aggregated).
 - `timestamp`- the date and time time at which Event was processed by Event Data.

All times in the API in ISO8601 UTC Zulu format.

See [Event Records in Depth](#event-records-in-depth) for more detail on precisely what the fields of an Event mean under various circumstances.

## Evidence

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

 - `timestamp` - the timestamp that the Evidence was recieved. This can be different from the `timestamps` and 'occurred_at` fields on the resulting Events. You should not normally use this field.
 - `input-artifacts` - links to Artifacts that were used in processing the input
 - `input-status` - the HTTP status code of an external API response
 - `input-headers` - the HTTP headers of an external API response
 - `input-body` - the HTTP response of an external API as a string, or in some digested form
 - `events` - a list of Events that were produced, in internal Lagotto Deposit format. These may appear to be similar to Event format, but there are some differences. Note that the `events` section may be empty if the input resulted in no Events.

### Getting Evidence Records

If you have an Event and you want to see the Evidence for it, query by its ID.

    http://service.eventdata.crossref.org/evidence/event/«event-id»

You will recieve `HTTP 302 Found` response which will provide the URL of the Evidence Record via the `Link` header. Configure your HTTP client to follow redirects and you will download the Evidence Record.

Inside the Evidence Record you will find an `events` section which will contain one or more events, including the one you queried for. Note that one piece of Evidence may have produced a number of Events.

You can also query for Evidence Records by the date they occurred:

    http://service.eventdata.crossref.org/evidence/occurred/«YYYY-MM-DD»

You will recieve a page which includes a list of URLs for all Evidence Records for that day. 

This can be useful if, for example, you want to see all inputs that were received from a particular source, whether or not they resulted in Events. Note that the time in the query corresponds to the `timestamp` field of the Evidence Record, and corresponds to the time the Evidence was processed. The times at which an Event occurred, the Event was collected, the Evidence was processed are different.

## Health Dashboard

Event Data connects to external systems and gathers data from them through a pipeline. Not all external services are available all the time, and some may experience fluctuations in service. The internal pipeline with the Event Data service may become congested or require maintenance from time to time. 

The Event Data Health Dashboard proactively monitors all parts of the system and reports on activity, availability and completeness of data. The Dashboard will be available via a user interface and via an API through which users can access historical data.

# 3 Concepts

## Registered Content, URLs, Persistent Identifiers and DOIs

Crossref has approximately 80 million items of Registered Content: articles, books, chapters etc. They are 'works' according to the [FRBR](http://archive.ifla.org/VII/s13/frbr/frbr1.htm#3.2) model. 

When a Content Item is registered with Crossref or Datacite, it is assigned a Persistent Identifier (PID) in the form of a Crossref DOI or DataCite DOI. The PID permanently identifies the Content Item and is used when referring to, or linking between, Items. Other PIDs, such as PubMed ID (PMID) are available, but they are beyond the scope of Crossref Event Data.

All items of Registered Content have a presence on the web, known as the Landing Page. It is usually hosted on the website of the publisher of the Item. This is the 'home' of the article, and it's what you see when you click on a DOI. Over time, Landing Pages can change as publishers reorganise their websites. This is where a Persistent Identifier comes in useful, as it always redirects to the current Landing Page.

<img src="images/doi-url.svg" alt="DOIs and Landing Pages" class="img-responsive">

Because DOIs silently redirect to Landing Pages, when people want to link to an Item, many people and services use the Landing Page not the DOI. Event Data therefore attempts to track Events via the Landing Page as well as via DOIs.

### Event Data tracks Content Items not DOIs

Crossref Event Data, like all Crossref services, uses the Crossref DOI to refer an item of Registered Content. Every Event that references a Registered Item uses its Crossref DOI. 

Every Data Source uses 

We track events using the most appropriate identifier for the Item according to the source. 



Other services may use the DOI or the Landing Page. 



## Data Aggregator vs Provider

The NISO Code of Conduct describes an 'altmetric data aggregator as':

> Tools and platforms that aggregate and offer online events as well as derived metrics from altmetric data providers (e.g., Altmetric.com, Plum Analytics, PLOS ALM, ImpactStory, Crossref).

TODO

## Works vs Persistent Identifiers / DOIs




## DOIs and URLs

### Matching by DOIs {#concept-matching-dois}

Some services use DOIs directly to make references. Wikipedia, for example, has references all over the web, but where they link scholarly articles, the DOI is generally included. There are tools in the page editing workflow to encourage and suggest the incorporation of DOIs. Another data source that uses DOIs for references is DataCite, who link datasets to articles via their dataset metadata.

Data that come from services like this can be very precise. We know that the person who made the citation intended to use the DOI to refer to the content item in question and we can reliably report that an Event occurred for this Crossref DOI.

### Unabiguously linking DOIs to URLs {#concept-urls}

### External Parties Matching Content to DOIs {#concept-external-dois}

### Linked and Unlinked DOIs

DOIs can be expressed in a number of ways, for example:

 - `10.5555/12345678`
 - `doi:10.5555/12345678`
 - `http://dx.doi.org/10.5555/12345678`
 - `https://doi.org/10.5555/12345678`

In addition, when they are displayed in an HTML page, they can be hyperlinked. **The Crossref DOI Display guidelines specify that a DOI should be a hyperlink**.

Some services, such as Twitter, automatically link URLs. Some services, such as Wikipedia, provide tools that make linking the default, although there are still unlinked DOIs.

Generally, Event Data will only find links in HTML that are correctly linked using a URL.

### Publisher Domains {#concept-publisher-domains}

### Pre-filtering Domains {#concept-pre-filtering}


## Duplicate Data {#concept-duplicate}

## Evidence First {#concept-evidence-first}

## Occurred-at vs collected-at {#concept-timescales}

 - citability
 - stability

## External Agents {#concept-external-agents}

## Individual Events vs Pre-Aggregated {#concept-individual-aggregated}

todo





# 4 In Depth

## Event Records in Depth #{event-records-in-depth}

### Subject and Object IDs

The `subj_id` and `obj_id` are both URIs that represent the subject and object of the Event respectively. In most cases they are resolvable URLs, but in some cases they can be URIs that represent entities but are not resolvable URLs.

Examples of resolvable `subj_id` or `obj_id`s are: 

 - DOIs, e.g. `http://doi.org/10.5555/12345678`
 - Twitter URLs, e.g. `http://twitter.com/statuses/763877751396954112`

Examples of non-resolvable `subj_id` or `obj_id`s are:

 - Facebook-month, e.g. `http://facebook.com/2016-08/`

URIs like the Facebook-month example are used for two reasons. Firstly, we are collecting data for 'total like count of some users on Facebook', therefore no URL that can identify the entities actually exists. Secondly, it is useful to record the entity-per-date for ease of data processing and counting at a later date.

### Occurred At

The `occurred_at` field represents the date that the Event occurred. The precise meaning of 'occurred' varies from source to source:

For some sources, an event occurrs on the publication of a `work`, and the `occurred_at` is the same as the issue date of the work. In these cases, the `occurred_at` value is supplied by the original Source (e.g. Twitter API or metadata on the blog).

 - a tweet was published and it referenced a DOI
 - a blog post was published and it referenced a DOI

For some sources, an event occurrs at the point that an existing work is edited and the `occurred_at` is the same as the edit date. In these cases the `occurred_at` value is supplied by the original Source (e.g. Wikipedia API):

 - a Wikipedia article was edited and it referenced a DOI

For some sources, an event occurs at the point that a count is observed from a pre-aggregating source. In these cases, the `occurred_at` value is supplied by the Agent that makes the request to an external service, e.g. Facebook Agent:

 - Facebook was polled for the count for a DOI
 - Mendeley was polled for the count for a DOI

Therefore `occurred_at` field comes from a different authority depending on the source, sometimes an internal service, sometimes an external one. Bear this in mind if you intend to rely on the precise time of an Event. 

### Timestamp

The `timestamp` field represents the date that the Event was processed. Every piece of data travels through an internal pipeline within the Event Data service. The timestamp records the time at which an Event was inserted into the Lagotto service, which is the central component that collects all Events.

TODO: PIPELINE PICTURE

The `timestamp` is used in the `collected_at` view in the Query API.

The `timestamp` usually happens a short while after the event was collected. For some sources, such as Twitter, this can be a few minutes. For sources that operate in large batches, such as Facebook, this can be a day or two. Regardless of variation between agents, the `timestamp` represents the canonical time at which Event Data became aware of an Event.

### Subject and Object Metadata

Event Data allows Subject and Object metadata to be included. Where the Subject or Object metadata are DOIs, and therefore can be easily looked up from the Crossref or DataCite Metadata API, it is usually not included. In other cases, it is often included.

### ID

The ID is generated by Agents, whether they're operated by Crossref or external parties. They are expressed as UUIDs and should be treated as opaque identifiers.

See the list of (Sources in-depth)[#in-depth-sources] for a discussion of the various subject fields per source.

### Message Action

Most of the time an Event can be read as "this relation was created". An Event records the relationship that came into being at a given point in time.

Sometimes these relationships come and go. For example, in Wikipeida, an edit can result in the removal of a reference from an article. In fact, we often see a history of references being added and removed as the result of a series of edits and sometimes reversions to previous versions.

The removal of a relation in Wikipedia doesn't constitute the removal of an Event, it means a new event that records that the relation was removed.

## Sources in Depth {#in-depth-sources}



### Crossref to DataCite Links

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | crossref_datacite |
| Consumes artifacts        | none |
| Matches by                | DOI |
| Produces relation types   | cites |
| Freshness                 | Daily |
| Data Source               | Crossref Metadata API |
| Coverage                  | All DOIs |
| Relevant concepts         | [Occurred-at vs collected-at](#concept-timescales), [Duplicate Data](#concept-duplicate) |
| Operated by               | Crossref |
| Agent                     | Cayenne |

When members of Crossref (who are mostly Scholarly Publishers) deposit metadata, they can deposit links to datasets via their DataCite DOIs. The Crossref Metadata API monitors these links and sends them to Event Data. As this is an internal system there are no Artifacts as the data comes straight from the source.

#### Example Event

    {
      "obj_id":"https:\/\/doi.org\/10.13127\/ITACA\/2.1",
      "occurred_at":"2016-08-19T20:30:00Z",
      "subj_id":"https:\/\/doi.org\/10.1007\/S10518-016-9982-8",
      "total":1,
      "id":"71e62cbd-28a8-4a41-9b74-7e58dca03efc",
      "message_action":"create",
      "source_id":"crossref_datacite",
      "timestamp":"2016-08-19T22:14:33Z",
      "relation_type_id":"cites"
    }

#### Methodology

 - The Metadata API scans incoming Content Registration items and when it finds links to DataCite DOIs, it deposits them.
 - It can also scan back-files for links.

#### Notes

 - Because the Agent can scan for back-files, it is possible that duplicate Events may be re-created. See (Duplicate Data){#concept-duplicate}.
 - Becuase the Agent can scan for back-files, Events may be created with `occurred_at` in the past. See (Occurred-at vs collected-at)[#concept-timescales].



### Datacite to CrossRef Links

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | datacite_crossref |
| Consumes artifacts        | none |
| Matches by                | DOI |
| Produces relation types   | cites |
| Fields in Evidence Record | no evidence record |
| Freshness                 | daily |
| Data Source               | DataCite API |
| Coverage                  | All DOIs |
| Relevant concepts         | [External Agents](#contept-external-agent), [Occurred-at vs collected-at](#concept-timescales) |
| Operated by               | DataCite |

When members of DataCite deposit datasets, they can include links to Crossref Registered Content via their Crossref DOIs. The DataCite agent monitors these links and sends them to Event Data. As this is an External Agent, there are no Artifacts or Evidence Records.

#### Example Event

    {
      "obj_id":"https:\/\/doi.org\/10.1007\/S10518-016-9982-8",
      "occurred_at":"2016-08-19T20:30:00Z",
      "subj_id":"https:\/\/doi.org\/10.13127\/ITACA\/2.1",
      "total":1,
      "id":"71e62cbd-28a8-4a41-9b74-7e58dca03efc",
      "message_action":"create",
      "source_id":"datacite_crossref",
      "timestamp":"2016-08-19T22:14:33Z",
      "relation_type_id":"cites"
    }

#### Methodology

 - DataCite operate an Agent that scans its Metadata API for new citations to Crossref DOIs. When it finds links, it deposits them.
 - It can also scan for back-files

#### Notes

 - Because the Agent can scan for back-files, it is possible that duplicate Events may be re-created. See (Duplicate Data){#concept-duplicate}.
 - Because the Agent can scan for back-files, Events may be created with `occurred_at` in the past. See (Occurred-at vs collected-at)[#concept-timescales].



### Facebook

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | facebook |
| Matches by                | Landing Page URL |
| Consumes artifacts        | `high-urls`, `medium-urls`, `all-urls` |
| Produces relation types   | `bookmarks`, `shares` |
| Fields in Evidence Record | Complete API response |
| Freshness                 | Three schedules |
| Data Source               | Facebook API |
| Coverage                  | All DOIs where there is a unique URL mapping |
| Relevant concepts         | [Unabiguously linking URLs to DOIs](#concept-urls), [Individual Events vs Pre-Aggregated](#concept-individual-aggregated) |
| Operated by               | Crossref |
| Agent                     | event-data-facebook-agent |

The Facebook Data Source polls Facebook for Items via their Landing Page URLs. It records how many 'likes' a given Item has receieved at that point in time, via its Landing Page URL. A Facebook Event records the current number of Likes an Item has on Facebook at a given point in time. It doesn't record who liked the Item or when then the liked it. See [Individual Events vs Pre-Aggregated](#concept-individual-aggregated) for further discussion. The timestamp represents the time at which the query was made. 

Because of the structure of the Facebook API, it is necessary to make one API query per Item, which means that it can take a long time to work through the entire list of Items. This means that, whilst we try and poll as often and regularly as possible, the time between Facebook Events for a given Item can be unpredictable. 

#### Freshness

The Facebook Agent uses three categories of Item: `high-urls`, `medium-urls` and `all-urls` (see the [URL Artifact lists documentation](#artifact-url-list) for more detail). It processes the three categories in parallel. In each category it scans the current list of all Items with URLs from start to finish, and queries the Facebook API for each one. It does this in a loop, each time fetching the most recent list of URLs.

The Facebook Agent works within rate limits of Facebook API. If the Facebook API indicates that the rate of traffic is too high then the Agent will lower the rate of querying and a complete scan will take longer.

#### Subject URLs and PIDs

As Facebook events are pre-aggregated and don't record the relationship between the liker and the Item, Events are recorded against Facebook as a whole. Because we don't expect to collect events more than once per month per Item, we create an entity that represents Facebook in a given month.

Each "Facebook Month" is recorded as a separate subject PID, e.g. `https://facebook.com/2016/8`. This PID a URI and doesn't correspond to an extant URL. Note that the metadata contains the URL of `https://facebook.com`.

This strikes the balance between recording data against a consistent Subject whilst allowing easy analysis of numbers on a per-month basis.

If you just want to find 'all the Facebook data for this DOI' remember that you can filter by the `source_id`.

#### Example Event

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
      "source_id":"facebook",
      "timestamp":"2016-08-11T00:26:48Z",
      "relation_type_id":"references"
    }

#### Example Evidence Record

TODO

#### Landing Page URLs vs DOI URLs

Facebook Users may share links to Items two ways: they may link using the DOI URL, or they may link using the Landing Page URL. When a DOI is used, Facebook records and shows the DOI URL but records statistics against the Landing Page URL it resolves to. This means that Facebook doesn't necessarily maintain a one-to-one mapping between URLs and statistics for that URL.

Event Data always uses the Landing page URL when it queries Facebook and never the DOI URL. If a Facebook user used the Landing Page URL then there would be no results for the DOI, and if they used the DOI, the statistics would be recorded against the Landing Page anyway.

Here is a worked example using the Facebook Graph API v2.7. Note that these API results capture a point in time and the same results may not be returned now.

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

#### HTTP and HTTPS

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

#### Methodology

The Agent has three parallel processes. They operate on three Artifacts: `high-urls`, `medium-urls` and `all-urls`. The last of these contains the mapping of all known DOI to URL mappings. The first two contain subsets of these.

Each process:

 1. fetches the most recent version of the relevant URL List Artifact
 2. iterates over each the URL. It uses the Facebook Graph API 2.7 to query data for the Landing Page URL.
 3. the `comment_count` is recorded as an Event with the given `total` field and the `relation_type_id` of `shares`.
 4. the `comment_count` is subtracted from the `share_count` and the result is recorded as an Event with the given `total` field and the `relation_type_id` of `bookmarks`.
 5. When the end of the list is reached, it starts again at step 1.


#### Further information

 - [Facebook Graph API](https://developers.facebook.com/docs/graph-api)
 - [Facebook CED Agent](https://github.com/crossref/event-data-facebook-agent)



### Mendeley

| Property                  | Value          |
|---------------------------|----------------|
| Name                      |  |
| Matches by                | DOI |
| Consumes artifacts        |  |
| Produces relation types   |  |
| Fields in Evidence Record |  |
| Freshness                 |  |
| Data Source               |  |
| Coverage                  |  |
| Relevant concepts         | [Matching by DOIs](#concept-matching-dois), [External Parties Matching Content to DOIs](#concept-external-dois), [Individual Events vs Pre-Aggregated](#concept-individual-aggregated) |
| Operated by               |  |
| Agent                     |  |

DISCUSSION

#### Example Event

TODO

#### Example Evidence Record

TODO

#### Methodology

TODO

#### Further information

TODO



### Newsfeed

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | `newsfeed` |
| Matches by                | Landing Page URL |
| Consumes artifacts        | `newsfeed-list` |
| Produces relation types   | `mentions` |
| Fields in Evidence Record |  |
| Freshness                 | half-hourly |
| Data Source               | Multiple blog and aggregator RSS feeds |
| Coverage                  | All DOIs |
| Relevant concepts         | [Unabiguously linking URLs to DOIs](#concept-urls), [Duplicate Data](#concept-duplicate), [Publisher Domains](#concept-publisher-domains), [Pre-filtering](#concept-pre-filtering) |
| Operated by               | Crossref |
| Agent                     | event-data-newsfeed-agent |

The Newsfeed agent monitors RSS and Atom feeds from blogs and blog aggregators. Crossref maintains a list of newsfeeds, including

 - ScienceSeeker blog aggregator
 - ScienceBlogging blog aggregator
 - BBC News

You can see the latest version of the newsfeed-list by using the Evience Service: http://service.eventdata.crossref.org/evidence/artifact/newsfeed-list/current 

#### Example Event

TODO

#### Example Evidence Record

TODO

#### Methodology

 - Every hour, the latest 'newsfeed-list' Artifact is retrieved
 - For every feed URL in the list, the agent queries the newsfeed to see if there are any new blog posts
 - For every hyperlink in the blog post, the agent queries the DOI Reversal service to try and turn it into a DOI.

#### Notes

Becuase the Newsfeed Agent connects to blogs and blog aggregators, it is possible that the same blog post may be picked up by two different routes. In this case, the same blog post may be reported in more than one event.




### Reddit

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | event-data-reddit-agent |
| Matches by                | DOI |
| Consumes artifacts        | `domain-list` |
| Produces relation types   |  |
| Fields in Evidence Record |  |
| Freshness                 |  |
| Data Source               |  |
| Coverage                  |  |
| Relevant concepts         | [Unabiguously linking URLs to DOIs](#concept-urls), [Pre-filtering](#pre-filtering) |
| Operated by               | Crossref |
| Agent                     |  |

DISCUSSION

#### Example Event

TODO

#### Example Evidence Record

TODO

#### Methodology

TODO

#### Further information

TODO



### Twitter

| Property                  | Value          |
|---------------------------|----------------|
| Name                      |  |
| Matches by                | DOI |
| Consumes artifacts        |  |
| Produces relation types   |  |
| Fields in Evidence Record |  |
| Freshness                 |  |
| Data Source               |  |
| Coverage                  |  |
| Relevant concepts         | [Pre-filtering](#pre-filtering) |
| Operated by               | Crossref |
| Agent                     |  |

DISCUSSION

#### Example Event

TODO

#### Example Evidence Record

TODO

#### Methodology

TODO

#### Further information

TODO



### Wikipedia

| Property                  | Value          |
|---------------------------|----------------|
| Name                      |  |
| Matches by                | DOI |
| Consumes artifacts        |  |
| Produces relation types   |  |
| Fields in Evidence Record |  |
| Freshness                 |  |
| Data Source               |  |
| Coverage                  |  |
| Relevant concepts         | [Matching by DOIs](#concept-matching-dois)|
| Operated by               | Crossref |
| Agent                     | event-data-wikipedia-agent |

DISCUSSION

#### Example Event

TODO

#### Example Evidence Record

TODO

#### Methodology

TODO

#### Further information

TODO


### Wordpress.com

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | `wordpressdotcom` |
| Matches by                | DOI |
| Consumes artifacts        |  |
| Produces relation types   |  |
| Fields in Evidence Record |  |
| Freshness                 |  |
| Data Source               |  |
| Coverage                  |  |
| Relevant concepts         | [Pre-filtering](#pre-filtering) |
| Operated by               |  |
| Agent                     |  |

The Wordpress.com agent queries the Wordpress.com API for Landing Page Domains. It monitors blogs hosted on Wordpress.com that mention articles by their landing page or by DOI URL.

#### Example Event

TODO

#### Example Evidence Record

TODO

#### Methodology

TODO

note not all wordpress

#### Further information

TODO

## Evidence in Depth {#in-depth-evidence}

Every Event has an Evidence Record. Each Evidence Record corresponds to an input from an external source. Each Evidence Record has links to supporting data in the form of Artifacts.

The Evidence Service links Events to their Evidence.

### Artifacts

An Artifact is an input to an Agent that's required to process its External Input. It provides the necessary context or supporting data that enables an Agent to produce Events. 

#### Structure of an Artifact file

Artifacts can be very large, for example the `all-doi` file may be up to 3GB, so they are split up into Artifact Part Files. An Artifact is represented by an Artifact Record, which contains pointers to all of its parts. 

An Artifact Record is a text file that contains a list of URLs, one per line, of the parts that make it up. Therefore to download an artifact completely you must first download the Artifact record and then download each link within it. 


 Artifact files are split into parts becuase they are very large (for example the DOI file may be up to 3GB). To retrieve a complete Artifact, download the the Artifact Record and then download each link within it. Every Artifact file (both record and the parts) is made up of a name and an MD5 hash of its content, so you verify that recieved all the files correctly.

The structure of each type of Artifact file is chosen to best suit the data, and is described per-source below.

#### List of artifact types

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


##### High Priority, Medium Priority, Entire DOI List 

This is a list of Crossref DOIs that are deemed to be high-priority, medium-priority respectively, and the list of all DOIs. The content of an Artifact Part File is a list of DOIs (expressed without a resolver, e.g. `10.5555/12345678`), one per line. 

For Agents that consume a list of DOIs (e.g. Mendeley) these constitute the list of DOIs that the Agent will query for. Every Evidence Record will contain a link to the Artifact that gave rise to the Event.

The High Priority list contains DOIs that have been recently published and for which it is likely we will find events. Agents that use this list will poll using it on a regular basis.

The Medium list contains DOIs that have been less recently published. Agents that use this list will poll on a less regular basis.

The Entire list contains all DOIs, over 80 million. Agents will try to collect data for all of these, but are limited by the size of the list.

**Note:** Every crawl of a set of DOIs uses a DOI list Artifact ('high', 'medium' or 'entire'). Therefore, if you get the Artifact that was used for a given Event ID, you can check the list of DOIs that was used as part of the crawl.

**Note:** DOI list Artifacts are used to generate crawls for certain Agents. You may find Events with DOIs that were not part of the list.

DOI Lists are produced by the Thamnophilus service.

##### High-priority, Medium Priority, Entire URL list {#artifact-url-list}

Every DOI resolves to a URL, at least in theory. The URL lists contain the mapping of DOIs to URLs (and vice versa) where there is a unique mapping. The content of the Part files are alternating lines of DOI, URL.

This file is genreated by the Thamnophilus service, which maintains a list of all DOIs and follows each one to see where it leads. If two DOIs point to the same URL then then the mapping is considered ambiguous and it is not included in the Artifact.

The contents of this Artifact change over time for a number of reasons:

 - new DOIs are added
 - it can take time to resolve all of the DOIs, so not all may have been resolved at a different point in time
 - the landing page for a DOI may have changed, meaning the URL has changed
 - we discover an ambiguity that wasn't previously present so the DOI must be removed from the list

The lists are used in a number of places:

 - Agents that query by landing page URL, e.g. Facebook . Like the DOI list, the three URL lists are used to schedule scans at high, medium and low frequencies.
 - The DOI Reversal Service, which transforms landing pages back into DOIS for Agents like Twitter

This may be used to answer questions like:

 - When you gathered data for this DOI, e.g from Facebook, which URL did you use to query it?
 - The landing page for a DOI changed. At what point did you start using the new URL to query for it?

**Note:** This Artifact is used by querying Agents such as the Facebook Agent. Other sources may report events for mappings that are not on this list.

##### Newsfeed List {#artifact-newsfeed-list}

This is a list of RSS and Atom newsfeed URLs. It is manually curated. Each part file contains a list of URLs that are RSS or Atom Newsfeeds. 

We run the Newsfeed Detector software on our DOI Resolution logs to find websites that refer to DOIs. For each website we find, we probe it to try and discover if it has an RSS or Atom newsfeed that we can subscribe to.

The list is manually curated from known blogs and updated every month or two with input from the Newsfeed Detector.

If you think a newsfeed is missing from the list, please contact eventdata@crossref.org

##### Domain List

This is a list of domains that DOIs resolve to. The list is created by the Thamnophilus service, which crawls every DOI to find its landing page, and records the domain. The Artifact Part files contain a list of domain names, one per line.

The data is generated automatically but manually curated to some extent. As some DOIs resolve to domains such as `google.com` and `youtube.com`, it is simply impractical to use them.

By providing the domain list as an Artifact, you can answer questions like "why wasn't this landing page matched". 

For more information see [Pre-filtering Domains](#concept-pre-filtering).

##### Software Name and Version

Every piece of software that's running as part of Event Data is an Artifact, including all of the Agents. An Agent will include a reference to it's currently running version in any Evidence Log records that it produces. Note that links will be to a tagged release in a source code repository (Github), therefore don't use the the Artifact Record structure.

#### Artifacts in the Evidence Service

The Evidence Service maintains a list of all of the artifacts.

You can use the Evidence Service to retrieve the most recent version, or previous versions, of an artifact.

 - To retrieve the current newsfeed list, for example, visit `http://service.eventdata.crossref.org/evidence/artifact/newsfeed-list/current` and you will be directed to the current Artifact Record. 
 - To retrieve the list of versions of the newsfeed, and what date they were created, visit `http://service.eventdata.crossref.org/evidence/artifact/newsfeed-list/list` and you will be shown a list of all versions with date stamps.
 - To see when new versions of software components, e.g. Agents, were released.

#### Finding Artifacts for an Event

Every Event has a corresponding Evidence Record, which contains a link to all of the Artifacts that were used to construct the Event. Therefore, to find the list of newsfeeds that was used to produce a blog reference Event:

 - Retrieve the ID from the Event, e.g. `d41d8cd98f00b204e9800998ecf8427e`
 - Query the Evidence Service to find the Evidence by visiting `http://service.eventdata.crossref.org/event/d41d8cd98f00b204e9800998ecf8427e/evidence`
 - You will see the list of Evidence Links in the response.

### Evidence Records

TODO

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
| Newsfeed Agent        | Agent to monitor newsfeeds for blogs (RSS, Atom) for events   | https://github.com/crossref/event-data-newsfeed-agent         | Crossref            |
| Evidence Processor    | Service to process Evidence from Agents.                      | https://github.com/crossref/event-data-evidence-processor     | Crossref            |
| Evidence Service      | Service to serve Evidence API.                                | https://github.com/crossref/event-data-evidence-service       | Crossref            |
| Thamnophilus          | Collects and resolves DOIs to produce Artifacts.              | https://github.com/crossref/thamnophilus                      | Crossref            |
| DOI Destinations      | Service to convert landing page URLs back into DOIs.          | https://github.com/crossref/doi-desetinations                 | Crossref            |
| Newsfeed Detector     | Service to monitor Crossref resolution logs for blogs         | https://github.com/crossref/event-data-newsfeed-detector      | Crossref            |


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

The Newsfeed List is manually curated using input from the Newsfeed Dector. For more information see the [`newsfeed-list` Artifact](#artifact-newsfeed-list).

# Appendix: NISO Altmetrics Code of Conduct {#appendix-niso-coc}

### 1: List all available data and metrics (providers and aggregators) and altmetric data providers from which data are collected (aggregators).

### 2: Provide a clear definition of each metric.

### 3: Describe the method(s) by which data are generated or T1, T2, R1 collected and how data are maintained over time.

### 4: Describe all known limitations of the data.

### 5: Provide a documented audit trail of how and when data generation and collection methods change over time and list all known effects of these changes. Documentation should note whether changes were applied historically or only from change date forward.

### 6: Describe how data are aggregated

### 7: Detail how often data are updated.

### 8: Describe how data can be accessed

### 9: Confirm that data provided to different data aggregators and users at the same time are identical and, if not, how and why they differ.

### 10: Confirm that all retrieval methods lead to the same data and, if not, how and why they differ.

### 11: Describe the data-quality monitoring process.

### 12: Provide a process by which data can be independently verified.

### 13: Provide a process for reporting and correcting data or metrics that are suspected to be inaccurate

# Appendix: Code Examples {#appendix-code-examples}

Here are some examples in Python.

TODO


# Appendix: FAQ

Does CED collect data for all DOIs in existence?
 : CED will accept events for DOIs issued by any RA (for example, DataCite), and will poll for all Crossref DOIs. Different sources operate differently, so the data for some sources will be fresher than others.
 
Which Registration Agencies' DOIs does CED use?
 : CED is is a joint venture by Crossref and DataCite. It is able to collect DOIs from any DOI Registration Agency (RA), and most Data Sources don't check which RA a DOI belongs to. So in theory, some MEDRA DOIs might end up being included. However, some Data Sources (such as Twitter) target only Crossref and DataCite DOIs. Check the individual Data Sources for full details.

How long is Data available?
 : Once data has entered the Query API it won't be removed (unless under extraordinary circumstances). The data will never 'exipire'.
 
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
 : We are aiming to launch toward the end of 2016.

How do I access the data?
  : The Query API is the way to access data. 

# Appendix: Glossary

Agent
  : A piece of software that gathers data for a particular Data Source and pushes it into CED. These can be operated by Crossref, DataCite or a third party.

Altmetrics
  : [From Wikipedia](https://en.wikipedia.org/wiki/Altmetrics): In scholarly and scientific publishing, altmetrics are non-traditional metrics proposed as an alternative to more traditional citation impact metrics, such as impact factor and h-index. Proposed as generalization of article level metrics.

Landing Page
 : The Publisher's page for an article (or DataSet etc). Every DOI resolves to a landing page, but there may be more than one landing page per Article. The URLs of landing pages can change over time, and the DOI link should always point to the landing page.

Data Source
  : The provenance or type of Event Data. Data Sources include Wikipedia, Mendeley, Crossref, DataCite etc. A source is different to an agent, which is a piece of software that fetches data for a particular data source.

Deposit
  : A single data point that records when CED became aware of new information. A Deposit is made by an Agent and concerns one Source.

Event UUID
  : a UUID that corresponds to an event within Crossref Event Data. 

Registration Agency
  : An organisation that assigns DOIs. For example, Crossref and DataCite.

Registered Content
 : Content that has been registered with Crossref and assigned a Crossref DOI, e.g an article or book chapter.

UUID
  : Universally Unique Identifier. Essentially a random number that identifies an Event. Looks like `c0eb1c46-6a59-49c9-926b-a10667ddd9de`.

# Appendix: Abbreviations

API
 : Application Programming Interface. An interface for allowing one piece of software to connect to another. CED collects data from other APIs from other services and provides an API for allowing access to data.

CED
 : Crossref Event Data

CoC
 : Code of Conduct

DET
 : DOI Event Tracking, the original name for Crossref Event Data.

DOI
 : Digital Object Identifier. An identifier given to a Content Item, e.g. http://doi.org/10.5555/12345678

JSON 
 : JavaScript Object Notation. A common format for sending data. All data coming out of the CED API is in JSON format.

MEDRA
 :  Multilingual European DOI Registration Agency. A DOI Registration Agency.

NISO
 : National Information Standards Organisation. A standards body who have created a Code of Conduct for altmetrics.

ORCiD
 : Open Researcher and Contributor ID. A system for assigning identifiers to authors.

RA
 : DOI Registration Agency. For example Crossref or Datacite.

SLA
 : Service Level Agreement. An agreement that CED will provide predictable service via its API.

TLA
 : Three letter abbreviation. 

URL
 : Uniform Resource Locator. A path that points to a Research Object, e.g. `http://example.com`

UUID
  : universally unique identifier. Looks like `c0eb1c46-6a59-49c9-926b-a10667ddd9de`.

## Retired Terminology

The following words have been used during the development of Event Data but are no longer official:

 - Deposit - this is an internal entity used within Lagotto. It does not form part of the public DET service, although it may be of interest to users who want to look into the internals.
 - "DOI Event Tracking" / "DET" - the old name for the Crossref Event Data service
 - Relations - this is an internal entity used within Lagotto. CED does not use Lagotto Relation objects. The concept of 'relations' is however.


# Revision history

| Date           | Version | Author                      |                                                   |
|----------------|---------| ----------------------------|---------------------------------------------------|
| 18-April-2016  | 0.1     | Joe Wass jwass@crossref.org | Initial MVP release                               |
| 19-April-2016  | 0.2     | Joe Wass jwass@crossref.org | Add 'Contributing to Event Data'                  |
| 16-August-2016 | 0.3     | Joe Wass jwass@crossref.org | Remove Relations & Deposits, update new Query API |
| ??-August-2016 | 0.4     | Joe Wass jwass@crossref.org | Complete rewrite using new concepts and components|
