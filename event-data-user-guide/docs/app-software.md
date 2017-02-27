# Appendix 1: Software in Use

The Crossref Event Data system has a number of components. All parts of the system that are used to generate or distribute Events, Evidence, Artifacts are open source. Whilst you will probably never want to run any of this software, it may help with the interpretation of the data.

Crossref Event Data uses a collection of software. It is all open source. 

| Name                  | Description                                                   | URL                                                           | Maintainer          |
|---------------------  |-------------------------------------------------------------  |-------------------------------------------------------------- |-------------------- |
| Wikipedia Agent       | Agent to monitor Wikipedia for Events.                        | https://github.com/crossref/event-data-wikipedia-agent        | Crossref            |
| Wordpress.com Agent   | Agent to monitor Wordpress.com for Events.                    | https://github.com/crossref/event-data-wordpressdotcom-agent  | Crossref            |
| Twitter Agent         | Agent to monitor Twitter for Events.                          | https://github.com/crossref/event-data-twitter-agent          | Crossref            |
| Reddit Agent          | Agent to monitor Reddit for Events.                           | https://github.com/crossref/event-data-reddit-agent           | Crossref            |
| Newsfeed Agent        | Agent to monitor newsfeeds for blogs (RSS, Atom) for Events   | https://github.com/crossref/event-data-newsfeed-agent         | Crossref            |

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
