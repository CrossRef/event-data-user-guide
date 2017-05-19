# Appendix: Glossary

### Agent

 A piece of software that gathers data for a particular Data Source and pushes it into Event Data. These can be operated by Crossref, DataCite or a third party.

### Altmetrics

 [From Wikipedia](https://en.wikipedia.org/wiki/Altmetrics): In scholarly and scientific publishing, altmetrics are non-traditional metrics proposed as an alternative to more traditional citation impact metrics, such as impact factor and h-index. Proposed as generalisation of article level metrics.

### Landing Page

 The Publisher's page for an item of Registered Content (for example, an article or a dataset etc). Every DOI resolves to a Landing Page, but there may be more than one Landing Page per content item. The URLs of Landing Pages can change over time, and the DOI link should always point to the Landing Page.

### Data Source / Data Contributor

 The provenance or type of Event Data. Data Sources include Wikipedia, Crossref, DataCite etc. A source is different to an agent, which is a piece of software that fetches data for a particular Data Source.

### Event UUID

 A UUID that corresponds to an Event within Crossref Event Data. 

### Registration Agency

 An organisation that assigns DOIs. For example, Crossref and DataCite.

### Registered Content

 Content that has been registered with Crossref and assigned a Crossref DOI, e.g an article or book chapter.

### UUID

 Universally Unique Identifier. Essentially a random number that identifies an Event. Looks like `c0eb1c46-6a59-49c9-926b-a10667ddd9de`.

# Appendix: Abbreviations

### API

 Application Programming Interface. An interface for allowing one piece of software to connect to another. Event Data collects data from other APIs from other services and provides an API for allowing access to data.

### Event Data

 Crossref Event Data

### CoC

 Code of Conduct

### DET

 Means 'DOI Event Tracking', the original name for Crossref Event Data.

### DOI

 Digital Object Identifier. An identifier given to a Registered Content Item, e.g. http://doi.org/10.5555/12345678

### JSON 

 JavaScript Object Notation. A common format for sending data. All data coming out of the Event Data API is in JSON format.

### MEDRA

 Multilingual European DOI Registration Agency. A DOI Registration Agency.

### NISO

 National Information Standards Organisation. A standards body who have created a Code of Conduct for altmetrics.

### ORCiD

 Open Researcher and Contributor ID. A system for assigning identifiers to authors.

### PII: 

Publisher Item Identifier, an identifier used internally by some Publishers.

### RA

 DOI Registration Agency. For example Crossref or DataCite.

### SLA

 Service Level Agreement. An agreement that Event Data will provide predictable service via its API.

### SICI

 Serial Item and Contribution Identifier, an identifier used internally by some Publishers.

### TLA

 Three letter abbreviation. 

### URL

 Uniform Resource Locator. A path that points to a Research Object, e.g. `http://example.com`

### UUID

 Universally Unique Identifier. Looks like `c0eb1c46-6a59-49c9-926b-a10667ddd9de`.

## Deprecated Terminology

The following words have been used during the development of Event Data but are no longer official:

 - Deposit - this is an internal entity used within Lagotto. It does not form part of the public Event Data service, although it may be of interest to users who want to look into the internals.
 - 'DOI Event Tracking' / 'DET' - the old name for the Crossref Event Data service
 - Relations - this is an internal entity used within Lagotto. Event Data does not use Lagotto Relation objects. The concept of a 'relation' is present in the Event object as a description of how a subject and an object are related.
 - Publisher Domains - now referred to as Landing Page Domains
