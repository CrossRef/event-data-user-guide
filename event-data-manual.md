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


# Welcome

Welcome to the Crossref Event Data User Guide. It contains everything you need to know about Crossref Event Data (and probably a little more), from a high-level overview down to the details in-depth. It is split into four sections:

 - "Introduction" is a high level overview of the service and background and is suitable for everyone.
 - "The Service" describes the various components of the Event Data service.
 - "Concepts" covers some of the issues that should be understood before using Event Data.
 - "In Depth" describes all the technical detail required to understand and integrate with the service from top to bottom and is suitable for a technical or research audience

Everyone should read the introduction. You can jump ahead to "The Service" for a detailed description of what CED provides, but for full understanding you should read "Concepts".

# Introduction

Crossref is home to over 80 million items of Registered Content (mostly journal articles, but we also have book chapters, conference papers etc). Crossref Event Data is a service for collecting events that occur around these items. For example, when datasets are linked to articles, articles are mentioned on social media or referenced online.

![](images/overview.png "Event Data Overview")

Much of the activity around scholarly content happens outside of the formal literature. The scholarly community needs an infrastructure that collects, stores, and openly makes available these interactions. Crossref Event Data will provide a means of monitoring and displaying links to scholarly content on the open web. Our belief is that the greater visibility provided by Crossref Event Data will help publishers, authors, bibliometricians and libraries to develop a fuller understanding of where and how scholarly content is being shared and consumed.


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

We don't just ask you to trust us. Every Event is the result of some data input from a source, and the entire process — including the data that we gathered in order to produce the event and the software we used to generate it — is completely open. For every Event we provide a full Evidence Record.

![](images/introduction-evidence-flow.png "Event Data Evidence Flow")

Crossref Event Data was developed alongside the NISO recommendations for Altmetrics Data Quality Code of Conduct, and we participated in the Data Quality working group. CED aims to be an examplar altmetrics data provider, setting the standard in openness and transparency. You can read the CED Code of Conduct Self-Reporting table in the [appendix](#appendix-niso-coc).

## Getting the Data 

Crossref Event Data is available via our Query API. The Query API allows you to make requests like:

 - give me all events that were collected on 2016-12-08
 - give me all events that occurred on 2015-12-08
 - give me all the facebook events that were collected on 2015-12-08
 - give me all the events that occurred for this DOI on 2016-01-08
 - give me all the twitter events that occurred for this DOI on 2016-01-08

We will add other mechanisms for retrieving Events when we introduce the Service Level Agreement.

The data made available via a REST API. However, because upwards of 40,000 events are collected per day, 

# The Service

## Query API

events format
split by day partitions

## Data Sources

Event Data is a hub for the collection and distribution of Events and contains data from a selection of Data Sources. It plays two roles: that of Data Provider and Data Aggregator. 

Sources that Crossref provides:

 - Crossref to DataCite
 - Facebook
 - Mendeley
 - Newsfeed
 - Reddit
 - Twitter
 - Wikipedia
 - Wordpress.com

Sources provided by partners:

 - DataCite to Crossref

A detailed discussion of each one is included in the 'In Depth' section.

## Evidence

## Health

# Concepts

## Data Aggregator vs Provider



## DOIs and URLs

### Matching by DOIs {#concept-matching-dois}

Some services use DOIs directly to make references. Wikipedia, for example, has citations all over the web, but where they link scholarly articles, the DOI is generally included. There are tools in the page editing workflow to encourage and suggest the incorporation of DOIs. Another data source that uses DOIs for references is DataCite, who link datasets to articles via their dataset metadata.

Data that come from services like this can be very precise. We know that the person who made the citation intended to use the DOI to refer to the content item in question and we can reliably report that an Event occurred for this Crossref DOI.

### Unabiguously linking DOIs to URLs {#concept-urls}

### External Parties Matching Content to DOIs {#concept-external-dois}



### Publisher Domains {#concept-publisher-domains}

### Pre-filtering Domains {#concept-pre-filtering}


## Duplicate Data {#concept-duplicate}

## Evidence First {#concept-evidence-first}

## Occurred-at vs collected-at {#concept-timescales}

 - citability
 - stability

## External Agents {#concept-external-agents}

## Individual Events vs Pre-Aggregated {#concept-individual-aggregated}





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
| Matches by                | DOI |
| Consumes artifacts        | `high-urls`, `medium-urls`, `all-urls` |
| Produces relation types   | `bookmarks`, `shares` |
| Fields in Evidence Record | Complete API response |
| Freshness                 | Three schedules |
| Data Source               | Facebook API |
| Coverage                  | All DOIs where there is a unique URL mapping |
| Relevant concepts         | [Unabiguously linking URLs to DOIs](#concept-urls), [Individual Events vs Pre-Aggregated](#concept-individual-aggregated) |
| Operated by               | Crossref |
| Agent                     | event-data-facebook-agent |

DISCUSSION

#### Example Event

TODO

#### Example Evidence Record

TODO

#### Methodology

TODO

#### Further information

TODO



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

DISCUSSION

#### Example Event

TODO

#### Example Evidence Record

TODO

#### Methodology

TODO

note not all wordpress

#### Further information

TODO


# In Depth

## Evidence 

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

##### High-priority, Medium Priority, Entire URL list

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

**Note:** This Artifact is used by querying Agents such as the Facebok Agent. Other sources may report events for mappings that are not on this list.

##### Newsfeed List

This is a list of RSS and Atom newsfeed URLs. The list is manually curated, and is taken from blogs and blog aggregation services. The Artifact Record contains the list of URLs. There are no part files.

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



# Appendix 1: Software in Use

The Crossref Event Data system has a number of components. They are all open-source software.

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


# Revision history

| Date           | Version | Author                      |                                                   |
|----------------|---------| ----------------------------|---------------------------------------------------|
| 18-April-2016  | 0.1     | Joe Wass jwass@crossref.org | Initial MVP release                               |
| 19-April-2016  | 0.2     | Joe Wass jwass@crossref.org | Add 'Contributing to Event Data'                  |
| 16-August-2016 | 0.3     | Joe Wass jwass@crossref.org | Remove Relations & Deposits, update new Query API |
| ??-August-2016 | 0.4     | Joe Wass jwass@crossref.org | Complete rewrite using new concepts and components|
