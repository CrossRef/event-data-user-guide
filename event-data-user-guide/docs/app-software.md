# Appendix 1: Software in Use

## Software used internally in Event Data

The Crossref Event Data system has a number of components. All parts of the system that are used to generate or distribute Events, Evidence, Artifacts are open source. Whilst you will probably never want to run any of this software, it may help with the interpretation of the data.

Crossref Event Data uses a collection of software. It is all open source. 

| Name                      | Description                                                     | URL                                                              | Maintainer          |
|---------------------------|-----------------------------------------------------------------|------------------------------------------------------------------|---------------------|
| Event Bus                 | Internal service that accepts Events, archives, rebroadcasts    | https://github.com/CrossRef/event-data-event-bus                 | jwass@crossref.org  |
| Event Data Common         | Clojure library providing common functionality                  | https://github.com/CrossRef/event-data-common                    | jwass@crossref.org  |
| Artifact Manager          | Utility to allow Crossref to manage and upload new Artifacts    | https://github.com/CrossRef/event-data-artifact-manager          | jwass@crossref.org  |
| Status                    | Service to collect Status messages and serve dashboard          | https://github.com/CrossRef/event-data-status                    | jwass@crossref.org  |
| Percolator                | Produces Evidence and Events from data Agents send              | https://github.com/CrossRef/event-data-percolator                | jwass@crossref.org  |
| Wordpress.com Agent       | Agent to monitor Wordpress.com for Events.                      | https://github.com/crossref/event-data-wordpressdotcom-agent     | jwass@crossref.org  |
| Twitter Compliance Logger | Collect Compliance events to ensure we abide by them            | https://github.com/CrossRef/event-data-twitter-compliance-logger | jwass@crossref.org  |
| Event Data Integration    | End-to-end demonstration of the CED internal system with Docker | https://github.com/CrossRef/event-data-integration               | jwass@crossref.org  |
| Crossref Agent Framework  | Clojure framework for Crossref Agents                           | https://github.com/CrossRef/event-data-agent-framework           | jwass@crossref.org  |
| Newsfeed Agent            | Agent to monitor newsfeeds for blogs (RSS, Atom) for Events     | https://github.com/crossref/event-data-newsfeed-agent            | jwass@crossref.org  |
| Event Data Reports        | Create daily reports on internal system activity                | https://github.com/CrossRef/event-data-reports                   | jwass@crossref.org  |
| Live Demo                 | Show a live stream of Events as they happen                     | https://github.com/CrossRef/event-data-live-demo                 | jwass@crossref.org  |
| Twitter Agent             | Agent to monitor Twitter for Events.                            | https://github.com/crossref/event-data-twitter-agent             | jwass@crossref.org  |
| Wikipedia Agent           | Agent to monitor Wikipedia for Events.                          | https://github.com/crossref/event-data-wikipedia-agent           | jwass@crossref.org  |
| Reddit Agent              | Agent to monitor Reddit for Events.                             | https://github.com/crossref/event-data-reddit-agent              | jwass@crossref.org  |
| Query API Server          | Serve up the Query API                                          |https://github.com/CrossRef/event-data-query-api-server           | jwass@crossref.org  |

<!--
| Newsfeed Detector     | Service to monitor Crossref resolution logs for blogs         | https://github.com/crossref/event-data-newsfeed-detector      | Crossref            |
| Facebook Agent        | Agent to query Facebook for Events.                           | https://github.com/crossref/event-data-facebook-agent         | Crossref            |
| Query API Loader      | Service to generate the Event Data Query API                  | https://github.com/crossref/event-data-query-api-loader       | Crossref            |
| Evidence Processor    | Service to process Evidence from Agents.                      | https://github.com/crossref/event-data-evidence-processor     | Crossref            |
| Evidence Service      | Service to serve Evidence API.                                | https://github.com/crossref/event-data-evidence-service       | Crossref            |
| Thamnophilus          | Collects and resolves DOIs to produce Artifacts.              | https://github.com/crossref/thamnophilus                      | Crossref            |
| DOI Destinations      | Service to convert landing page URLs back into DOIs.          | https://github.com/crossref/doi-desetinations                 | Crossref            |
-->

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

The Newsfeed List is manually curated using input from the Newsfeed Detector. For more information see the [`newsfeed-list` Artifact](evidence-in-depth#artifact-newsfeed-list).

-->


## Software you can use with Event Data

Event Data is easy to convert into other formats to ingest into a range of software. We will be writing a series of blog posts, and will update this documentation as we go.

Crossref Event Data is designed to be compatible with [Lagotto](https://lagotto.io) and a future release will include the means of connecting to the service.
