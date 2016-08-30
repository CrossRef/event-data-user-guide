---
title: Crossref Event Data Technical User Guide
papersize: a4
documentclass: book
margin-left: 2cm
margin-right: 2cm
margin-top: 2cm
margin-bottom: 4cm
fontfamily: "sans"  
date: __VERSION__
header-includes:
    - \\usepackage{graphicx}
    - \\usepackage[dvipsnames]{xcolor}
    - \\hypersetup{colorlinks=true,linkcolor=MidnightBlue}
    - \\let\\cleardoublepage\\clearpage
    - \\DeclareUnicodeCharacter{00A0}{ }


---

# Introduction {#introduction}

#ifdef __TODO__
---- ------------------------------------------------------------
Note WORK IN PROGRESS INCLUDES TODOS
------------------------------------------------------------------
#endif

#ifdef __FUTURE__
---- ------------------------------------------------------------
Note WORK IN PROGRESS INCLUDES FUTURE FEATURES
------------------------------------------------------------------
#endif

#ifdef __WIP__
---- ------------------------------------------------------------
Note Note that this document is a work in progress.
     For internal circulation only.
     Some parts may be missing and references may be made to non-existent sections.
------------------------------------------------------------------
#endif


Crossref Event Data (CED) is a service for collecting and distributing the events that occur around scholarly research objects. It concerns primarily articles in Crossref and datasets in DataCite that have a DOI. For the purposes of this document, 'Research Object' will be used to mean any item in Crossref (including articles, books, conference proceedings, etc) or in DataCite (including datasets etc) that has a DOI. 

CED is currently under development. We are making the service available to interested parties, but we are constantly making improvements. **It is not offered as a complete or production-quality service**. This User Guide may refer to future capibilities of Event Data which have not yet been developed.

This manual may refer to future cabpilities of Crossref Event Data in order to illustrate principles. Crossref Event Data and this manual are constantly evolving. **For more information about Crossref Event Data, and the most up to date version of this User Manual, see [http://eventdata.crossref.org](http://eventdata.crossref.org)**.

Much of the web activity around scholarly content happens outside of the formal literature. The scholarly community needs an infrastructure that collects, stores, and openly makes available these interactions. That’s why we are working to develop a new service that will provide a means of monitoring and displaying links to scholarly content on the open web. Our belief is that the greater visibility provided by Crossref Event Data will help publishers, authors, bibliometricians and libraries to develop a fuller understanding of where and how scholarly content is being shared and consumed.

We believe that by developing all of our software as open source, and by making our processes and data transparent, Event Data will be as trustworthy and understandable as possible. 

#ifdef __FUTURE__

## NISO

Crossref Event Data was developed alongside the National Information Standards Organisation (NISO) Altmetrics Data Quality Code of Conduct and Crossref participated in the working group to form the recommendations. CED aims to follow all of the recommendations.

[Appendix: NISO Altmetrics Data Quality Code of Conduct](#niso-appendix) answers every point in the Code of Conduct, making reference to detail in this manual. See also the ["Definitions and Use Cases"](http://www.niso.org/apps/group_public/download.php/16268/NISO%20RP-25-201x-1%2C%20Altmetrics%20Definitions%20and%20Use%20Cases%20-%20draft%20for%20public%20comment.pdf) document.

For the purposes of NISO compliance, Crossref Event Data serves both as an 'altmetric data provider' in that it generates some Event Data (e.g. the 'Crossref Related' Data Source) and an 'altmetric data aggreator' in that it collects, processea and makes available Event Data through its APIs.

You can find more information on the [NISO Altmetrics Initiative site](http://www.niso.org/topics/tl/altmetrics_initiative). See the [Roadmap](#roadmap) section for details on when CED will be compliant.

#endif

## What is an Event? {#what-is-event}

The world of Event Data is varied, and CED aims to capture data from as wide a range of Data Sources as possible. An event can be described as

> an action that occurs concerning a Research Object that has a DOI

However the types of events that occur are varied. Here are some examples:

- someone tweeted mentioning a DOI
- someone liked an article on Facebook
- a reference to an article was added to Wikipedia using its DOI

Data is collected from a range of services and the information we have access to is as varied as the types of events that occur

 - we can capture and represent an individual Tweet that mentions a DOI on Twitter
 - Facebook only gives us access to a count of how many times a DOI has been liked at a given point in time
 - Wikipedia poses an interesting challenge because a reference can be added or removed, so depending when you query the system, a reference may or may not exist

There are also different types of data consumers who want to see different levels of detail:

- an author wants to know if article was mentioned on Twitter
- a bibliometrician wants to know what time of day people tweet about DOIs
- a Wikipedian wants to know how often DOI references are removed from articles

## Events

An Event is a single data point that records when CED became aware of new information. Examples of Events are:

- On 12th November 2014, Twitter reported that `twitter.com/CrossrefOrg/status/517313741491552256` was published and it mentioned `doi.org/10.5555/12345678`.
- On 26th November 2016, CED contacted Facebook, and Facebook reported that
    `doi.org/10.1016/0300-9629(73)90490-8` currently had 5 likes.
- On 24th September 2015, Wikipedia reported that there was an edit to the `en.wikipedia.org/wiki/Fish` in which a reference to `doi.org/10.1007%2Fs003600050092` was removed.

#ifdef __FUTURE__

# Roadmap

The approximate roadmap is:

- 0.1 - **MVP** - Minimum Viable Product.
- 1.0 - **Audit** - Stable system with full audit capability and compliance with NISO Code of Conduct.
- 2.0 - **Event Data Launch** - Launch with complete feature set.
- 3.0 - **SLA** - Service Level Agreements available.

## Available Data Sources

See the [Data Sources](#sources) section for a list of currently available Data Sources. **Future** Data Sources may include:

| Blogs & Reference Works | Social Bookmarks | Social Shares & Discussions | Links to Research Entities |
|-------------------------|------------------|-----------------------------|----------------------------|
| Research Blogging       | CiteULike        | Facebook                    | ORCiD                      |
| ScienceSeeker           | Mendeley         | Twitter                     | DataCite                   |
| Wikipedia               | Reddit           | Europe PMC                  | Database Citations         |
| Wordpress.com           |

## Service Level Agreements (SLA)

When the SLA is launched, Crossref Event Data will provide Service Level Agreements to partners. This will provide an agreed level of service availability for access to the API. It will provide exactly the same data, but with the level of service clearly defined. It will also include a method to notify users of data on a more timely basis.

Please contact Crossref if you are interested on eventdata@crossref.org.

## Access to Data

Access to Event Data is made via the API. You can find example API queries later in this document.

#endif

# Quick start

You can access data through the user interface or the API. Here are some examples to get you started.

## API

You can access the API in your browser, use tools like [cURL](https://curl.haxx.se/) or integrate it with your software.

If you're using Chrome, we suggest you use JSONView (available for [Chrome](https://chrome.google.com/webstore/detail/jsonview/chklaanhfefbnpoihckbnefhakgolnmc) and [Firefox](https://addons.mozilla.org/en-us/firefox/addon/jsonview/)) to make it easier to read the output.

Please note that many of these responses are very large, and your browser may struggle. We recommend you use appropriate tools to access this data.

### Browse all of the events that occurred on the 12th April 2005

[http://query.api.eventdata.crossref.org/occurred/2005-04-12/events.json](http://query.api.eventdata.crossref.org/occurred/2005-04-12/events.json)

Note that the events occurred in 2006 but were collected in 2016.

### Browse all of the events that were collected on 2016-08-01 from Reddit. 

[http://query.api.eventdata.crossref.org/collected/2016-08-04/sources/reddit/events.json](http://query.api.eventdata.crossref.org/collected/2016-08-04/sources/reddit/events.json)

Note that the events were collected on the 4th but occurred on the 3rd.

### Browse all of the events for the DOI `10.1002/(ISSN)1099-0720` collected on 2016-08-04.

[http://query.api.eventdata.crossref.org/collected/2016-08-04/works/10.1002/(ISSN)1099-0720/events.json](http://query.api.eventdata.crossref.org/collected/2016-08-04/works/10.1002/(ISSN)1099-0720/events.json)

### Browse all of the events for the DOI `10.1002/14651858.CD011119.PUB2` collected on 2016-08-04 from Twitter.

[https://query.api.eventdata.crossref.org/collected/2016-08-04/works/10.1002/14651858.CD011119.PUB2/sources/twitter/events.json](https://query.api.eventdata.crossref.org/collected/2016-08-04/works/10.1002/14651858.CD011119.PUB2/sources/twitter/events.json)

# Scope {#scope}	

Crossref Event Data collects Event Data on Research Objects that have Crossref or DataCite DOIs. It does this by monitoring various services for references to those Research Objects.

## DOIs vs Landing Pages {#landing-pages}

All of the Research Objects that Crossref Event Data tracks have DOIs. However not every website and service we're interested in tracking uses them. As every DOI resolves to a landing page, some services follow the link before recording it and some use the DOI directly. 

CED tracks Research Objects using the most suitable URL. For some, like Wikipedia, this will be the DOI. For others, such as Facebook, this will be the landing page URL.

CED therefore monitors certain Data Sources for article landing pages and attempts to deduce the DOI from the landing page URL. For details on the methodology see the [Landing Page Reversal](#reversal) section.

A different approach is suitable for each Data Source, so please see each Data Source's documentation for full details.

## Other DOI Registration Agencies 

CED accepts any DOI so, whilst nearly every DOI in CED will belong to either Crossref or DataCite, it is possible that DOIs from another Registration Agency (RA) will be found in CED.

#ifdef __FUTURE__


# Landing Page Reversal


We use the most suitable approach for each Data Source to ensure we get the most complete data. Refer to the documentation for each Data Source for details of the method used and the .

TODO FINISH

The methodology and limitations are detailed in the [Reversal](#reversal) section.


## Methodology

TODO

- how are domains collected / filtered
- list methods

## Limitations

TODO

- does not hit all landing pages, but nearly all known ones
- not all landing pages can be followed
- not possible to reverse all URLs
- some publishers prevent it
- show data for proportion of Tweets collected
- domains from sample of DOIs per publisher

## Auditability 

TODO

- snapshots freely available, provide details
- versioning policy
- contents of snapshot
- source code available
- see sources for their own audit log format



# Audit & Reproducibility {#audit-reproducibility}

TODO
 - Crossref Event Data is completely transparent
 


#### Per source audit

If you want access to the audit logs for given sources, please contact Crossref. For contractual reasons, access to some data is subject to restrictions.

TODO

- limitations e.g. API keys, requests, removing sensitive info
- not available at MVP technical challenges

## DOI Reversal service {#reversal}

TODO

- see chapter


### Known research objects

TODO

- timestamp avilable for all Research Objects useful for knowing when a DOI might have first been queried against.

## Software

All the software involved in running Crossref Event Data is open source and available to the public. Crossref will publish a detailed log of every piece of software that is running at what version and update it when the new versions are deployed. This will allow auditors to know precisely which combinations of software were running at a given point in time.

## Upstream services

TODO

- will attempt to draw attention to interruptions to upstream services, but no commitment to rigorous interpretation

## audits.eventdata.crossref.org

TODO

 - version numbers and reversal datasets

#endif

# Data Sources {#sources}

The following Event Data Sources are available:


| Name                 | Identifier for API         |
|----------------------|----------------------------|
| Datacite to Crossref | `datacite_crossref`        |
| Crossref to Datacite | `crossref_datacite`        |
| Mendeley             | `mendeley`                 |
| Wikipedia            | `wikipedia`                |
| Twitter              | `twitter`                  |
| Facebook             | `facebook`                 |
| Newsfeed             | `newsfeed`                 |
| Reddit               | `reddit`                   |


Full details of each Data Source are provided below.

## Data Sources, Agents and Source tokens

A Data Source describes the type of data or where it came from. Examples of Data Sources are Wikipedia or Mendeley. For each source, a piece of software called an Agent runs to collect the data and put it into CED. There is usually one Agent for each Data Source.

Every source has an identifier, for example `mendeley` or `wikipedia`. You can use these to filter Events. Every Agent has its own Source token, for example `a147a49b-8ef1-4d2a-92b3-541ee7c87f2f`, and this identifies a particular piece of software running on a particular server. You can use this trace the path of data through the system. See see the [Source Tokens Appendix](#source-tokens-appendix) for a full list of currently operating Agents and their Source Tokens.

All of the agents are operated by Crossref and Datacite, Agents could in theory be run by anyone — Crossref, DataCite or a third party.

## List of Data Sources

### Datacite to Crossref

Data citations in the form of links to Crossref DOIs from DataCite DOIs. The links are deposited in dataset metadata by dataset publishers. Agent operated by DataCite.

#### What events look like

Every citation from a DataCite DOI to a Crossref DOI produces a `cites` event.

#### Provenance

Links are deposited with DataCite by DataCite members as part of the work metadata. 

#### Methodology

Metadata deposits are processed by the DataCite system and made available on the DataCite API. DataCite operates an agent that extracts deposits and sends them to CED.

#### Coverage

All DataCite DOIs are covered.

#### Freshness

DataCite will push data on a regular schedule, approximately once a day.

#### Audit & Reproducibility

All data comes from the DataCite Metadata API.

#### Limitations, Quirks & Failure Cases

If the agent does not run the data might be out of date. 

#### Further information

For more information about DataCite see the [DataCite website](http://datacite.org).

More information on the [source information](http://api.eventdata.crossref.org/sources/crossref_datacite#documentation).

### Crossref to Datacite

Data citations in the form of links to DataCite DOIs from Crossref DOIs. The links are deposited in Crossref article metadata by article publishers. Agent operated by Crossref.

#### What events look like

Every citation from a Crossref DOI to a DataCite DOI produces a `cites` event.

#### Provenance

Links are deposited with Crossref by Crossref members, most of which are scholarly publishers.

#### Methodology

Data is taken from the public Crossref Metadata API by an agent operated by Crossref. 

#### Coverage

All DOI links from Crossref metadata to DOIs registered by DataCite. Data is inserted on a continual basis for new events and in batch for historical events.

#### Freshness

Data is updated on a daily schedule in batches. 

#### Audit & Reproducibility

Data is taken from the public Crossref Metadata API by an agent operated by Crossref. All the source data is freely available. The date of each Event is available.

#### Limitations, Quirks & Failure Cases

If there are delays in processing, data might be out of date.

#### Further information

See the [Crossef website](http://crossref.org).

More information on the [source information](http://api.eventdata.crossref.org/sources/datacite_crossref#documentation)

### Mendeley

Mendeley is a reference manager and academic social network. CED queries the public Mendeley API for counts of how many times a DOI has been bookmarked and liked. It uses the internal Research Object list. Agent operated by Crossref.

#### What events look like

The Mendeley Data Source provides Events of type `bookmarks` and `likes`. Each one has a date stamp and a count.  

#### Provenance

All data comes from the public Mendeley API. The counts are provided by Mendeley.

#### Methodology

A query is made against the Mendeley API for every DOI in the internal Research Object list. Queries are made on a regular basis, dependent on real-world observations. Every Relation shows the most recent count for a query. 

#### Coverage

We aim to provide data for all of the corpus of Crossref Research Objects.

As Mendley provides a count per Research Object at a given point in time, each Event describe the individual data point as they were collected. 

#### Freshness

Queries are made on a regular basis. The actual values depend on real-world behaviour.

#### Audit & Reproducibility

All data is from the Mendeley API. The counts are made by Mendeley's internal systems. 

#### Limitations, Quirks & Failure Cases

As Research Objects can be added or removed from Mendeley collections, values can rise as well as fall.

If there are changes in the Mendeley API, or it is unavailable, data cannot be collected. Mendeley's internal systems calculate totals, so values may fluctuate if the algorithms change or internal data is refined.

#### Further information

Information about the Mendely API can be found on the [developer pages](http://dev.mendeley.com/). 

More information on the [source information](http://api.eventdata.crossref.org/sources/mendeley#documentation)

#ifdef __FUTURE__

### Twitter {#twitter}

Agent operated by Crossref.

TODO

- Twitter mentions of Research Objects via DOI or article landing page. These are tweets that mention an article or dataset by its DOI, or via the landing page of the DOI.
- It applies to DOIs that belong to Crossref and DataCite.
- uses the DOI reverser to filter for domains of publisher landing pages and to attempt to reverse the URLs


#### What events look like

#### How to use it

#### Provenance

The data are supplied by Twitter and filtered by Crossref DET.

TODO

- uses DOI Reverser and domain list, see DOI reverser for details
- publisher domains and datacite member domains
- re-generated events with new data


#### Methodology

TODO

 - member domains list
 - filters
 - pipeline
 - audit logs
- title is body of Tweet


#### Coverage

#### Freshness

TODO

- live stream, processed
- re-generation of data based on updated date stamps 


#### Audit & Reproducibility

TODO

- see DOI reverser for details on reproducibility
- all the audit info of DOI reversal, see DOI Reversal
- uses latest domain list and software can be correlated against events
- re-generated events 
- audit log contians all input events that match the initial filter
- identify which tweets came from DOI vs member domain by looking at text of tweet
- will publish date-stamped domain lists when new releases
- will store audit logs for all input events that match input filters


#### Limitations, Quirks & Failure Cases

TODO

- disconnection should be handled, so there should be no missing data
- all the caveats of DOI reversal, see DOI Reversal
- as long as domain was on domain list, matches can be improved
- uses latest domain list and software, if domains are missing at that time , no recourse
- all DOIs but not all landing pages
- landing pages taken from Crossref and DataCite
- all the limitations of the DOI Reversal service see [DOI Reversal](#doi-reversal)


#### Further information

More information on the [source information](http://api.eventdata.crossref.org/sources/twitter#documentation)

#endif

#ifdef __FUTURE__
### Facebook

Number of “shares,” “likes” and “comments” for a given DOI, as retrieved from the Facebook API. As this is a Pull Source, CED only polls Facebook for the DOIs on its Internal Research Object list.


  - old developer account, maybe not all data types available


Agent operated by Crossref.

#### What events look like

TODO

 - likes, shares etc most recent


#### How to use it

TODO

 - likes, shares, etc most recent
 - useful to look at Events to get samples over time



#### Provenance

Data comes from the Facebook API.

#### Methodology

The Facebook Agent polls against the Facebook API using the Internal List of Research Objects, using their DOIs, at a regular interval.

#endif

#### Coverage

The Facebook Data Source works by fetching counts for a selection of DOIs for Research Object that CED knows about. See the Internal Research Object section.

#### Freshness

CED will fetch data for each DOI it knows about

The Facebook agent fetches DOIs on a schedule, currently twice a day at 06:00 and 18:00. Depending on the number of DOIs and response times it may not be possible to maintain this level. 

#ifdef __TODO__

#### Audit & Reproducibility

TODO

 - plan to store API responses in audit log when service is launched


 
#### Limitations, Quirks & Failure Cases

TODO

 - only as good as most recent sample
 - data can be missing if sample didn't happen
 - rate of update variable, no committment
 - only DOIs we know about see scope
 - DOIs may be added, missing data doesn't mean no data
 - depends on Facebook API availability and rate limiting
 - Facebook has changed data schema before, may reduce amount of data in future


#### Further information

The Facebook Data Source is part of the Lagotto software. Full technical details of the Facebook source are available on [the Lagotto documentation](http://www.lagotto.io/docs/facebook/).

More information on the [source information](http://api.eventdata.crossref.org/sources/facebook#documentation)
#endif


### Wikipedia {#sources-wikipedia}

Edits taken from all known Wikipedia projects (`*.wikipedia.org`). This excludes Wikibooks, Wikiversity, various beta products for various technical reasons (availability and stability of upstream APIs, known formats etc). Agent operated by Crossref.

Wikipedia DOI citations and uncitations. These are edits to Wikipedia pages that mention a DOI directly, or edits that remove such mentions. The data are supplied by Wikipedia and filtered by Crossref DET.

#### What events look like

A `references` type Event is added when a reference from a Wikipedia article page to a DOI is found.

Wikipedia provides a Canonical URL for each page. DOIs are reported as they are found linked from Wikipedia pages. When CED detects that a DOI link is added to an article it will be added as a normal Event. All such activity is detailed in the Deposits, which are available on the API.

#### How to use it

When you see an Event that mentions a DOI you can follow the link to the Wikipedia page and view the link. Note that the DOI might have been subsequently removed and CED may not yet be aware of that.

If you are interested in looking at patterns of adding and removal you may be interested in the Deposits API, which will provide details of how often a reference was added or removed. For full details check the Audit Log for the Wikipedia source, which will provide the individual revision numbers for each edit to the article.

#### Provenance

The data about edits comes from the [Wikipedia Recent Changes stream](https://www.mediawiki.org/wiki/API:Recent_changes_stream). This includes edit numbers and the title. The citations come from the article text via the [Wikipedia RESTBase API](https://www.mediawiki.org/wiki/RESTBase). The Canonical URL comes from the article page via the standard Wikipedia page.

#### Methodology

Crossref runs a service that monitors the Wikipedia Recent Changes live stream, which includes every edit that is made to any Wikipedia page in any language. It fetches the old and new versions of the edit and compares DOI links. See the [Software](#software) section for details.

#### Coverage

Every DOI that is found linked from a Wikipedia article page is added to CED.

#### Freshness

Events are collected as they occur.

#### Audit & Reproducibility

An input trigger event corresponds to a change in any Wikipedia property. Because there is a very high volume of edits (up to 2 million per day) it is impractical to store triggers for which no DOIs were found. When an trigger does correspond to an event because a DOI was added or removed (50 thousand triggers per day), it is stored. When a trigger is stored it is given a UUID. Because an edit to a Wikipedia page (which would be treated as one trigger) can introduce more than one DOI reference, every trigger may correspond to one or more events. 

A monthly audit log of triggers is stored and may be available to users to wish to audit Wikipedia events. Each month's logs contain a log of events that correlate the trigger id, the event id and the relevant Wikipedia information:

 - `input-event-id`: trigger UUID, e.g. `c0eb1c46-6a59-49c9-926b-a10667ddd9de`
 - `event-id`: event UUID (available on Deposits data) `646c0a88-1905-47d8-a21f-6a86fbb384db`
 - `server-name`: Wikipedia server, e.g. `en.wikipedia.org`
 - `title`: article title, e.g. `Fish`
 - timestamp of edit event
 - old revision ID within Wikipedia, e.g. `1000`
 - new revision ID within Wikipedia, e.g. `1001`
 - action, one of `add` or `remove`
 - DOI
 
Example: 

    {"event-id":"a6fc8282-6581-4255-9e45-cd85d927ef91",
     "old-revision":33357537,
     "new-revision":33554607,
     "input-event-id":"6177d950-65e7-48a5-875f-3924a2d322fa",
     "title":"Mount Stanley",
     "url":"https://sv.wikipedia.org/wiki/Mount_Stanley",
     "dois-added": ["10.5194/hess-11-1633-2007"],
	 "dois-removed": [],
     "server-name":"sv.wikipedia.org"}
 
Using this data it is possible to fetch the page versions and compare cited DOIs.

#### Limitations, Quirks & Failure Cases

##### Recent Change Stream disconnection

The Recent Changes stream connection can be dropped due to network errors or server errors at either side (for example, in [2016](https://phabricator.wikimedia.org/T130024) when an upgrade caused a prolonged outage). The client will attempt to reconnect immediately, but there can be a few minutes' downtime. Events that occur while the Recent Changes Stream is disconnected cannot be recovered.

##### RESTBase API

Pages are fetched using wikimedia’s RESTBase API, after a short delay to allow propagation. If they are not available on the API then they cannot be fetched. Because of the high volume of data coming through it is not possible to retry. 
Page revisions that take more than one minute to propagate through Wikipedia’s internal systems may not be captured.

The RESTBase API is techincally [unstable](https://www.mediawiki.org/wiki/API_versioning#Unstable) so there may be interruptions to service.


##### Inability to recognise DOI

TODO

URL vs text, reference section

##### Completeness of audit data

It is impractical to store the metadata of every single edit that appears on Wikipedia. Therefore only those edits for which there was a DOI citation was added or removed are stored. This means that it's possible to audit false positives but not false-negatives.

#### DOIs and templates

The [Wikitext markup language](https://en.wikipedia.org/wiki/Wiki_markup) allows for the inclusion of templates. Historically there have been a large number of ways of citing Research Objects (whether using DOIs or not) and there is a large number of templates spread out over the various Wikipedia language properties. 

This means that DOIs may occur in the rendered HTML version of a page that are not present in the Wikitext markup. Bear this in mind if you are using a tool such as [MWCites](https://github.com/mediawiki-utilities/python-mwcites).

#### Edit wars

One of the things that makes Wikipedia interesting as a source of scholarly event data is the fact that anyone can edit, including reverts.

Sometimes authors disagree on a matter of academic principle, which can reasult in references to Research Objects being added and removed. Sometimes a larger edit containing a reference is automatically rolled back. Sometimes vandalism to an article with references causes references to be removed (and often automatically restored). 

This means that when there *is* activity around a reference, there's often more than just one event.

#### Further information

See the [Software](#software) section for details on the software that gathers data.

### Twitter

#### What events look like

TODO

#### How to use it

TODO

#### Provenance

TODO

#### Methodology

TODO

#### Coverage

TODO

#### Freshness

TODO

#### Audit & Reproducibility

TODO

#### Limitations, Quirks & Failure Cases

TODO

#### Further information

TODO


### Facebook

TODO

#### What events look like

TODO

#### How to use it

TODO

#### Provenance

TODO

#### Methodology

TODO

#### Coverage

TODO

#### Freshness

TODO

#### Audit & Reproducibility

TODO

#### Limitations, Quirks & Failure Cases

TODO

#### Further information

TODO



### Newsfeed

TODO

#### What events look like

TODO

#### How to use it

TODO

#### Provenance

TODO

#### Methodology

TODO

#### Coverage

TODO

#### Freshness

TODO

#### Audit & Reproducibility

TODO

#### Limitations, Quirks & Failure Cases

TODO

#### Further information

TODO



### Reddit

TODO

#### What events look like

TODO

#### How to use it

TODO

#### Provenance

TODO

#### Methodology

TODO

#### Coverage

TODO

#### Freshness

TODO

#### Audit & Reproducibility

TODO

#### Limitations, Quirks & Failure Cases

TODO

#### Further information

TODO




### Other Push sources

TODO

- Data supplied by other providers. We allow data providers to supply us with individual events concerning DOIs. We are working with a prominent player in the scholarly space. Every event, such as “this DOI was annotated” is recorded. The data are sent directly from the provider.


#### What events look like

#### How to use it

#### Provenance

#### Methodology

#### Coverage

#### Freshness

Depending upon the providers, these can be received as a live stream or sent in batches.

#### Audit & Reproducibility

#### Limitations, Quirks & Failure Cases


#ifdef __FUTURE__

# Pushing data into Crossref Event Data

## Push API

If organisations with Event Data wish to contribute to CED they can use the Deposit API to push data in. This accepts deposits in JSON format that represent Events in *subject verb object* format. To push data, the organisation should obtain an API key by contacting Crossref support.

## Sandbox and Staging

Crossref provides two test instances: Sandbox and Staging.

TODO

 - use of sandbox
 - use of staging
 - don't trust the data
 - may be service interruptions
 - contact us if you want to try stuff out

#endif

# Using the API

The API is free to use without restrictions. It is under constant development and is not yet launched, so this documentation is subject to change. 

Note: The responses returned by the API can be sizable. At the time of writing, for example, the "all events for a given day"(which is the largest possible request) is approximately 20MB.

## Collected on vs Occurred on

Every event **occurs** on a given date. For example, a Twitter event happens when the tweet is published. A link to a dataset happens when the article is published. A Facebook event occurs when the count for a given Research Object is requested. 

Every event also has a **collection date**, which is the date CED became aware of it. These dates are usually similar, but it's possible to collect data on a dataset link that happened ten years ago.

Users of the API may be interested in both types of data. Researchers may want to query for events that occurred on a given date, regardless of when the data was collected. Systems integrators may want to query for events that were collected on a given date so they can be confident of collecting all the data. CED gives access to both views.

Because events (may have occurred in the past) are constantly being collected, the response to an 'occurred at' query may change over time. Therefore the result of an 'occurred at' query should not be considered stable and cannot be cited directly. The 'collected' view for a given date, however, is stable and will never change.

## Available filters

Every query must include:

 - `day`:  `YYYY-MM-DD` format, which is interpreted as UTC Zulu format
 - `view`: a view, either `collected` or `occurred`

The following query filters are supported:

 - `DOI`: DOI, upper case, e.g. `10.5555/12345678'
 - `source name`: name of source, per (see [Data Sources](#sources))

The following queries are available:

### All events per day

 - `http://query.api.eventdata.crossref.org/«view»/«YYYY-MM-DD»/events.json`

e.g. 

 - `http://query.api.eventdata.crossref.org/collected/2016-06-05/events.json`
 - `http://query.api.eventdata.crossref.org/occurred/2016-06-05/events.json`

### All events for source per day

 - `http://query.api.eventdata.crossref.org/«view»/«YYYY-MM-DD»/sources/«source name»/events.json`

e.g. 

 - `http://query.api.eventdata.crossref.org/collected/2016-06-05/sources/twitter/events.json`
 - `http://query.api.eventdata.crossref.org/occurred/2016-06-05/sources/facebook/events.json`

### All events for DOI per day

Note, DOI must be uppercase.

 - `http://query.api.eventdata.crossref.org/«view»/«YYYY-MM-DD»/works/«DOI»/events.json`

e.g. 

 - `http://query.api.eventdata.crossref.org/collected/2016-06-05/works/10.5555/12345678/events.json`
 - `http://query.api.eventdata.crossref.org/occurred/2016-08-04/works/10.1002/(ISSN)1099-0720/events.json`

### All events for DOI from given source per day

 - `http://query.api.eventdata.crossref.org/«view»/«YYYY-MM-DD»/works/«DOI»/sources/«source name»/events.json`

e.g. 

 - `http://query.api.eventdata.crossref.org/collected/2016-06-05/works/10.5555/12345678/sources/twitter/events.json`
 - `http://query.api.eventdata.crossref.org/occurred/2016-08-04/works/10.1002/(ISSN)1099-072/sources/facebook/events.json`


## Stability of data

Data in the 'collected' view will not change once it has been made available. Data in the `occurred` view may chnage once it has been made available.

## Timelieness

All times are UTC Zulu. The API will contain data for the previous day, and will be available by the morning. For example, all the data for Sunday will be available on Monday morning.

## Availability {#availability}

All of the data is open for anyone to use. We will try to ensure that the APIs are available to all. As we are providing this as a free-to-access service, high demand may produce occasional fluctuations in service. We are planning to introduce a paid-for Sevice Level Agreement (SLA), which will provide agreements about the availability of the service. They will provide exatly the same data.

# Contributing to Event Data

We welcome new Data Sources. Using the Push API, third parties can easily push Deposits. We run a Sandbox instance for developers to work with and for integration testing. Please review the [API section](#using-the-api) for familiarity with the Deposit format. The [API is documented using Swagger](http://api.eventdata.crossref.org/api).

### Preparation

We would love to help you develop your Push Source.

 1. Contact us at eventdata@crossref.org to discuss your source. We will need to create a Data Source in Event Data and update our documentation.
 1. Decide what kind of Relation Types best describes your data. 
 1. Decide if you want to include a Total. For individual events, like tweets, you don't need to. When there's a total number of events in an Event, e.g. Facebook where we record the total number of likes for a given DOI, a total can be supplied.

### Tokens

 1. Sign in at [http://sandbox.api.eventdata.crossref.org](http://sandbox.api.eventdata.crossref.org).
 1. Email eventdata@crossref.org and we will enable your account for Push API access. Pushes won't work until we do this.
 1. Click on your name, select 'your account'. Copy your API key. You will use this to authenticate all of your push requests.
 1. Create a UUID for your agent. You can use your favourite GUID library or a service like [uuidgenerator.net](https://www.uuidgenerator.net/). This will be your Source Token, and will uniquely identify your agent. Don't re-use this for another agent.

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
                              "title":"My Favourite DOIs",
                              "author": "Jim",
                              "issued":"2013-03-24",
                              "URL":"http://trouser.press/jim/my-favourite-dois"}}}'

# Appendix: Software

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

## Lagotto

[http://lagotto.io](http://lagotto.io)

Lagotto is central to Crossref Event Data, and it runs at `eventdata.crossref.org`. It accepts events through the Deposit Push API and serves them up via the Relations and Deposit API. It also hosts all of the pull agents. Lagotto has extensive documentation, which can provide further detailed information the pull sources and interfaces, available on the [Lagotto site](http://lagotto.io).

Lagotto was originally developed at [PLoS](http://plos.org) and [DataCite](http://datacite.org) by Martin Fenner. It is now developed and maintained jointly by DataCite and Crossref. 

The Lagotto sterver that runs Event Data is operated by Crossref.

## Baleen-Wikipedia

[http://github.com/crossref/baleen-wikipedia]()

The adaptor that connects to the Wikipedia live Recent Changes event stream calculates events.

Maintained and operated by Crossref.

#ifdef __FUTURE_

## DOI Destinations

[http://github.com/crossref/doi-destinations]()

DOI Reversal service - see [Landing Pages](#landing-pages)

Maintained and operated by Crossref.

TODO

- where it runs
- docs


#endif



# Appendix: List of Source Tokens {#source-tokens-appendix}

A source token identifies an agent that feeds data into Event Data. These source tokens are useful for filtering the Deposits API and for tracing the provenance of a Relation.



| Agent name       | Source Token                         |
|------------------|--------------------------------------|
| Wikipedia        | a147a49b-8ef1-4d2a-92b3-541ee7c87f2f |
| Mendeley         | 54902caf-60f6-4e2a-9b91-2c9db2e0d114 |
| Crossref Related | 8676e950-8ac5-4074-8ac3-c0a18ada7e99 |



  
# Appendix: List of URLs and services

## Public

### Event Data Product Information Page

- [http://eventdata.crossref.org](http://eventdata.crossref.org)
- Product page for Crossref Event Data, full information and user guide.

### Event Data API

- [http://api.eventdata.crossref.org/api](http://api.eventdata.crossref.org/api)
- The API for Crossref Event Data. The Lagotto software is running here.

### Event Data MVP User Inferface

- [http://api.eventdata.crossref.org](http://api.eventdata.crossref.org)
- The API for Crossref Event Data. The Lagotto software is running here. Access to the User Interface is provided at MVP stage.

## Internal and Development

### Event Data API Staging

- [http://staging.api.eventdata.crossref.org](http://staging.api.eventdata.crossref.org)
- Instance of the API where we can test the next version. This is an unstable testing environment and does not contain real data.

### Event Data API Sandbox

- [http://sandbox.api.eventdata.crossref.org](http://sandbox.api.eventdata.crossref.org)
- Instance of the API to allow external developers and partners to test integration. This is usually running the same version of the software as the production instance at `api.eventdata.crossref.org`. This does not contain production data. Contact us if you want to use it.

### Wikipedia Live Events

- [http://wikipedia.eventdata.crossref.org](http://wikipedia.eventdata.crossref.org)
- The Wikipedia agent for CED. This is the service that monitors Wikipedia and pushes data into CED. Watch live events as they occur.

