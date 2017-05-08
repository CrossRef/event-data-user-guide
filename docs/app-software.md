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

Check the 'Connecting to your system' page for advice on ingesting Event Data into your own software. 

## Data flow through the system

This chart shows the flow of data through the system. A [PDF](/images/ced-data-flow.pdf) shows more detail.

![Event Data Flows](/images/ced-data-flow.png)



