# Appendix 1: Software in Use

## Software used internally in Event Data

The Crossref Event Data system has a number of components. All parts of the system that are used to generate or distribute Events, Evidence, Artifacts are open source. Whilst you will probably never want to run any of this software, it may help with the interpretation of the data.

Crossref Event Data uses a collection of software. It is all open source, and you can browse it [our repository on Github under the 'crossref-event-data'](https://github.com/search?q=topic%3Acrossref-event-data+org%3ACrossRef&type=Repositories) label.

| Name                       | Description                                                            | URL                                                               | Maintainer          |
|----------------------------|------------------------------------------------------------------------|-------------------------------------------------------------------|---------------------|
| Artifact Manager           | Utility to allow Crossref to manage and upload new Artifacts           | https://github.com/Crossref/event-data-artifact-manager           | jwass@crossref.org  |
| Event Bus                  | Internal service that accepts Events, archives, rebroadcasts           | https://github.com/Crossref/event-data-event-bus                  | jwass@crossref.org  |
| Event Data Common          | Clojure library providing common functionality                         | https://github.com/Crossref/event-data-common                     | jwass@crossref.org  |
| Event Data Integration     | End-to-end demonstration of the Event Data internal system with Docker | https://github.com/Crossref/event-data-integration                | jwass@crossref.org  |
| Crossref Agents            | Crossref-operated Agents that take data from external sources: hypothesis, newsfeed, reddit, reddit-links, stackexchange, twitter, wikipedia | https://github.com/Crossref/event-data-agents | jwass@crossref.org  |
| Live Demo                  | Show a live stream of Events as they happen                            | https://github.com/Crossref/event-data-live-demo                  | jwass@crossref.org  |
| Percolator                 | Produces Evidence and Events from data Agents send                     | https://github.com/Crossref/event-data-percolator                 | jwass@crossref.org  |
| Query API Server           | Serve up the Query API                                                 | https://github.com/Crossref/event-data-query                      | jwass@crossref.org  |
| Status                     | Service to collect Status messages and serve dashboard                 | https://github.com/Crossref/event-data-status                     | jwass@crossref.org  |
| Twitter Compliance Logger  | Collect Compliance events to ensure we abide by them                   | https://github.com/Crossref/event-data-twitter-compliance-logger  | jwass@crossref.org  |
| Twitter Compliance Patcher | Automatically apply Twitter compliance (deletions) to Events           | https://github.com/Crossref/event-data-twitter-compliance-patcher | jwass@crossref.org  |
| Twitter Spot Check         | Tool for manually auditing Events for compliance.                      | https://github.com/crossref/event-data-twitter-spot-check         | jwass@crossref.org  |
| User Guide                 | This User Guide                                                        | https://github.com/Crossref/event-data-user-guide                 | jwass@crossref.org  |
| Evidence Logger            | Saves Evidence Logs to application logs for internal monitoring        | https://github.com/CrossRef/event-data-evidence-logger            | jwass@crossref.org  |
| Evidence Log Snapshot      | Saves snapshots of the Evidence Log to daily archive.                  | https://github.com/CrossRef/event-data-evidence-log-snapshot      | jwass@crossref.org  |


## Data flow through the system

This chart shows the flow of data through the system. A [PDF](/images/ced-data-flow.pdf) shows more detail.

![Event Data Flows](/images/ced-data-flow.png)



