# Appendix: FAQ

[TOC]

### Does Event Data collect data for all DOIs in existence?
  
Event Data will accept Events for DOIs issued by any RA (for example, DataCite), and will poll for all DOIs in the 'doi-prefix' Artifact (currently Crossref, DataCite in future). Different Agents operate differently, so the data for some sources will be fresher than others.
 
### Which Registration Agencies' DOIs does Event Data use?

Event Data is is a joint venture by Crossref and DataCite. It is able to collect DOIs from any DOI Registration Agency (RA), and most Data Sources don't check which RA a DOI belongs to. So in theory, some MEDRA DOIs might end up being included. However, some Data Sources (such as Twitter) target only Crossref and DataCite DOIs. Check the individual Data Sources for full details.

### How long is Data available?

Once data has entered the Query API it won't be removed (unless under extraordinary circumstances). The data will never 'expire'.
 
### What is an Event?

An Event can be described as 'an action that occurs concerning a Content Object'. Every kind of event is slightly different, see the Sources for details.

### What format does the API data come in?

All APIs use JSON format

### Do I have to pay for the data?

No, the public data via the Query API will be free. We will offer a paid-for Service Level Agreement that will provide more timely access to data.

### Will the data be auditable?

Yes. Event Data is evidence-first and we will supply supporting Evidence for all data that we collect. See [Evidence First](concepts/trustworthiness-and-quality/#evidence-first).

### Can I use the data to feed into my commercial tool? 

Yes. We do not clean or aggregate the data we collect so that any commercial vendor has the opportunity to do this themselves in order to use the data in the way which best suits their needs.

### Is your code base open source?

Yes, all the code we use is open source. See the [Software](app-software) section.

### When will Event Data be launched?

Check the [Event Data page](https://www.crossref.org/services-event-data) on the Crossref website.

### How do I access the data?

The Query API is currently the only way to access data. 

### Does Event Data work with Multiple Resolution?

We plan to address and clarify how Event Data relates to Multiple Resolution in future.

### Does Event Data work with DOIs that include emoticons?

Yes. 

### Will the API make data available in other formats?

Currently no. If we provided an endpoint in, for example, CSV, format, we would have to remove data to make it fit. In order to preserve all the information that's relevant to an Event, we only offer the JSON endpoints. See the various 'Connecting Event Data to your service' pages for information on how to interface with other systems.
