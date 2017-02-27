# Appendix: FAQ and Glossary

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
  : Yes. Event Data is evidence-first and we will supply supporting Evidence for all data that we collect. See [Evidence First](concept#concept-evidence-first).

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
