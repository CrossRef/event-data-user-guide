# Appendix: Glossary

### Agent

A piece of software that gathers data for a particular data source and pushes it into Event Data. These can be operated by Crossref, DataCite or a third party.

### Altmetrics

[From Wikipedia](https://en.wikipedia.org/wiki/Altmetrics): In scholarly and scientific publishing, altmetrics are non-traditional metrics proposed as an alternative to more traditional citation impact metrics, such as impact factor and h-index. Proposed as generalization of article level metrics.

### Landing page

The publisher's page for an item of registered content (for example, an article or a dataset etc). Every DOI resolves to a landing page, but there may be more than one landing page per content item. The URLs of landing pages can change over time, and the DOI link should always point to the panding page.

### Data source / data contributor

The provenance or type of Event Data. Data sources include Wikipedia, Crossref, DataCite etc. A Source is different to an Agent, which is a piece of software that fetches data for a particular data source.

### Event UUID

A UUID that corresponds to an Event within Crossref Event Data. 

### Registration Agency

An organization that assigns DOIs. For example, Crossref and DataCite.

### Registered content

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

National Information Standards Organization. A standards body who have created a Code of Conduct for altmetrics.

### ORCiD

Open researcher and contributor ID. A system for assigning identifiers to authors.

### PII: 

Publisher Item Identifier, an identifier used internally by some Publishers.

### RA

DOI Registration Agency. For example Crossref or DataCite.

### SLA

Service Level Agreement. An agreement that Event Data will provide predictable service via its API.

### SICI

Serial Item and Contribution Identifier, an identifier used internally by some publishers.

### TLA

Three letter abbreviation. 

### URL

Uniform Resource Locator. A path that points to a Research Object, e.g. `http://example.com`

### UUID

Universally Unique Identifier. Looks like `c0eb1c46-6a59-49c9-926b-a10667ddd9de`.

## Deprecated Terminology

The following words have been used during the development of Event Data but are no longer official:

 - Deposit - this is an internal entity used within Lagotto. It does not form part of the public Event Data service, although it may be of interest to users who want to look into the internals.
 - 'DOI Event Tracking' / 'DET' - the old name for the Crossref Event Data service.
 - Relations - this is an internal entity used within Lagotto. Event Data does not use Lagotto Relation objects. The concept of a 'relation' is present in the Event object as a description of how a subject and an object are related.
 - Publisher domains - now referred to as landing page domains
